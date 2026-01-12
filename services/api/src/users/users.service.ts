import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    const passwordHash = await bcrypt.hash(createUserDto.password, 10);

    // organizationId is automatically injected by Prisma middleware
    const user = await this.prisma.user.create({
      data: {
        email: createUserDto.email,
        name: createUserDto.name,
        passwordHash,
        isActive: true,
      } as any,
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Assign default role if provided
    if (createUserDto.roleIds && createUserDto.roleIds.length > 0) {
      await Promise.all(
        createUserDto.roleIds.map((roleId) =>
          this.prisma.userRole.create({
            data: {
              userId: user.id,
              roleId,
            },
          }),
        ),
      );
    }

    const { passwordHash: _, ...result } = user;
    return result;
  }

  async findAll() {
    const users = await this.prisma.user.findMany({
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    return users.map(({ passwordHash, ...user }) => user);
  }

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }

  async findByEmail(email: string) {
    return this.prisma.user.findUnique({
      where: { email },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });
  }

  async update(id: string, updateData: Partial<CreateUserDto>) {
    const user = await this.findById(id);

    const data: any = {};

    if (updateData.name) {
      data.name = updateData.name;
    }

    if (updateData.email && updateData.email !== user.email) {
      const existingUser = await this.prisma.user.findUnique({
        where: { email: updateData.email },
      });

      if (existingUser) {
        throw new ConflictException('Email already in use');
      }

      data.email = updateData.email;
    }

    if (updateData.password) {
      data.passwordHash = await bcrypt.hash(updateData.password, 10);
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data,
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    const { passwordHash, ...result } = updated;
    return result;
  }

  async deactivate(id: string) {
    const updated = await this.prisma.user.update({
      where: { id },
      data: { isActive: false },
    });

    const { passwordHash, ...result } = updated;
    return result;
  }

  async updatePassword(id: string, newPasswordHash: string) {
    await this.prisma.user.update({
      where: { id },
      data: { passwordHash: newPasswordHash },
    });
  }
}

