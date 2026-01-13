import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSuperAdminDto } from './dto/create-superadmin.dto';
import { UpdateSuperAdminDto } from './dto/update-superadmin.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class SuperAdminService {
  constructor(private prisma: PrismaService) {}

  async create(createSuperAdminDto: CreateSuperAdminDto) {
    // Check if user already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: createSuperAdminDto.email },
    });

    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Get superadmin role
    const superadminRole = await this.prisma.role.findUnique({
      where: { name: 'superadmin' },
    });

    if (!superadminRole) {
      throw new NotFoundException('SuperAdmin role not found');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(createSuperAdminDto.password, 10);

    // Create SuperAdmin user with organizationId = null
    const user = await this.prisma.user.create({
      data: {
        email: createSuperAdminDto.email,
        name: createSuperAdminDto.name,
        passwordHash,
        organizationId: null, // ← KEY: No organization
        isActive: true,
        roles: {
          create: {
            roleId: superadminRole.id,
          },
        },
      },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Don't return password hash
    const { passwordHash: _, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async findAll() {
    // Find all users with superadmin role and no organization
    const users = await this.prisma.user.findMany({
      where: {
        organizationId: null,
        roles: {
          some: {
            role: {
              name: 'superadmin',
            },
          },
        },
      },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Remove password hashes
    return users.map(({ passwordHash, ...user }) => user);
  }

  async findOne(id: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        organizationId: null,
      },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException('SuperAdmin user not found');
    }

    const { passwordHash, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async update(id: string, updateSuperAdminDto: UpdateSuperAdminDto) {
    const user = await this.findOne(id);

    const updateData: any = {};

    if (updateSuperAdminDto.name) {
      updateData.name = updateSuperAdminDto.name;
    }

    if (updateSuperAdminDto.email) {
      updateData.email = updateSuperAdminDto.email;
    }

    if (updateSuperAdminDto.password) {
      updateData.passwordHash = await bcrypt.hash(
        updateSuperAdminDto.password,
        10,
      );
    }

    if (updateSuperAdminDto.isActive !== undefined) {
      updateData.isActive = updateSuperAdminDto.isActive;
    }

    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: updateData,
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    const { passwordHash, ...userWithoutPassword } = updatedUser;
    return userWithoutPassword;
  }

  async remove(id: string) {
    const user = await this.findOne(id);

    await this.prisma.user.delete({
      where: { id },
    });

    return { message: 'SuperAdmin user deleted successfully' };
  }

  async getPlatformHealth() {
    // Return platform health metrics (no organizational data)
    const totalOrgs = await this.prisma.organization.count();
    const activeOrgs = await this.prisma.organization.count({
      where: { status: 'active' },
    });

    return {
      status: 'healthy',
      timestamp: new Date(),
      organizations: {
        total: totalOrgs,
        active: activeOrgs,
        suspended: totalOrgs - activeOrgs,
      },
    };
  }

  async getPlatformStats() {
    // Return aggregated platform statistics (no individual org data)
    const totalOrgs = await this.prisma.organization.count();
    const totalUsers = await this.prisma.user.count({
      where: { organizationId: { not: null } },
    });
    const totalSuperAdmins = await this.prisma.user.count({
      where: { organizationId: null },
    });

    const orgsByPlan = await this.prisma.organization.groupBy({
      by: ['plan'],
      _count: true,
    });

    const orgsByStatus = await this.prisma.organization.groupBy({
      by: ['status'],
      _count: true,
    });

    return {
      organizations: {
        total: totalOrgs,
        byPlan: orgsByPlan,
        byStatus: orgsByStatus,
      },
      users: {
        totalOrgUsers: totalUsers,
        totalSuperAdmins: totalSuperAdmins,
      },
    };
  }
}

