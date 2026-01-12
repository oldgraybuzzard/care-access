import {
  Injectable,
  NotFoundException,
  ConflictException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrganizationDto } from './dto/create-organization.dto';
import { UpdateOrganizationDto } from './dto/update-organization.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class OrganizationsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createOrganizationDto: CreateOrganizationDto) {
    // Check if slug is already taken
    const existing = await this.prisma.organization.findUnique({
      where: { slug: createOrganizationDto.slug },
    });

    if (existing) {
      throw new ConflictException('Organization with this slug already exists');
    }

    return this.prisma.organization.create({
      data: {
        ...createOrganizationDto,
        plan: createOrganizationDto.plan || 'free',
        status: createOrganizationDto.status || 'active',
      },
    });
  }

  async findAll() {
    return this.prisma.organization.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string) {
    const organization = await this.prisma.organization.findUnique({
      where: { id },
      include: {
        _count: {
          select: {
            users: true,
            children: true,
            families: true,
            cases: true,
          },
        },
      },
    });

    if (!organization) {
      throw new NotFoundException('Organization not found');
    }

    return organization;
  }

  async findBySlug(slug: string) {
    const organization = await this.prisma.organization.findUnique({
      where: { slug },
    });

    if (!organization) {
      throw new NotFoundException('Organization not found');
    }

    return organization;
  }

  async update(id: string, updateOrganizationDto: UpdateOrganizationDto) {
    // Check if organization exists
    await this.findOne(id);

    return this.prisma.organization.update({
      where: { id },
      data: updateOrganizationDto,
    });
  }

  async remove(id: string) {
    // Check if organization exists
    await this.findOne(id);

    // Soft delete by setting status to cancelled
    return this.prisma.organization.update({
      where: { id },
      data: { status: 'cancelled' },
    });
  }

  async getStats(id: string) {
    const organization = await this.findOne(id);

    const [userCount, childCount, familyCount, caseCount] = await Promise.all([
      this.prisma.user.count({ where: { organizationId: id } }),
      this.prisma.child.count({ where: { organizationId: id } }),
      this.prisma.family.count({ where: { organizationId: id } }),
      this.prisma.case.count({ where: { organizationId: id } }),
    ]);

    return {
      organization,
      stats: {
        users: userCount,
        children: childCount,
        families: familyCount,
        cases: caseCount,
      },
    };
  }

  async getOrganizationUsers(organizationId: string) {
    return this.prisma.user.findMany({
      where: { organizationId },
      select: {
        id: true,
        email: true,
        name: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,
        roles: {
          include: {
            role: {
              select: {
                id: true,
                name: true,
                description: true,
              },
            },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateOrganizationUser(
    organizationId: string,
    userId: string,
    updateUserDto: UpdateUserDto,
  ) {
    // Verify user belongs to the organization
    const user = await this.prisma.user.findFirst({
      where: { id: userId, organizationId },
    });

    if (!user) {
      throw new NotFoundException('User not found in this organization');
    }

    // If updating email, check if it's already taken
    if (updateUserDto.email && updateUserDto.email !== user.email) {
      const existing = await this.prisma.user.findUnique({
        where: { email: updateUserDto.email },
      });

      if (existing) {
        throw new ConflictException('Email already in use');
      }
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: updateUserDto,
      select: {
        id: true,
        email: true,
        name: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,
        roles: {
          include: {
            role: {
              select: {
                id: true,
                name: true,
                description: true,
              },
            },
          },
        },
      },
    });
  }

  async assignRoleToUser(
    organizationId: string,
    userId: string,
    roleId: string,
  ) {
    // Verify user belongs to the organization
    const user = await this.prisma.user.findFirst({
      where: { id: userId, organizationId },
    });

    if (!user) {
      throw new NotFoundException('User not found in this organization');
    }

    // Verify role exists
    const role = await this.prisma.role.findUnique({
      where: { id: roleId },
    });

    if (!role) {
      throw new NotFoundException('Role not found');
    }

    // Check if user already has this role
    const existing = await this.prisma.userRole.findUnique({
      where: {
        userId_roleId: {
          userId,
          roleId,
        },
      },
    });

    if (existing) {
      throw new ConflictException('User already has this role');
    }

    // Assign role
    await this.prisma.userRole.create({
      data: {
        userId,
        roleId,
      },
    });

    // Return updated user with roles
    return this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        name: true,
        isActive: true,
        roles: {
          include: {
            role: {
              select: {
                id: true,
                name: true,
                description: true,
              },
            },
          },
        },
      },
    });
  }

  async removeRoleFromUser(
    organizationId: string,
    userId: string,
    roleId: string,
  ) {
    // Verify user belongs to the organization
    const user = await this.prisma.user.findFirst({
      where: { id: userId, organizationId },
    });

    if (!user) {
      throw new NotFoundException('User not found in this organization');
    }

    // Check if user has this role
    const userRole = await this.prisma.userRole.findUnique({
      where: {
        userId_roleId: {
          userId,
          roleId,
        },
      },
    });

    if (!userRole) {
      throw new NotFoundException('User does not have this role');
    }

    // Remove role
    await this.prisma.userRole.delete({
      where: {
        userId_roleId: {
          userId,
          roleId,
        },
      },
    });

    // Return updated user with roles
    return this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        name: true,
        isActive: true,
        roles: {
          include: {
            role: {
              select: {
                id: true,
                name: true,
                description: true,
              },
            },
          },
        },
      },
    });
  }

  async getAllRoles() {
    return this.prisma.role.findMany({
      select: {
        id: true,
        name: true,
        description: true,
      },
      orderBy: { name: 'asc' },
    });
  }
}

