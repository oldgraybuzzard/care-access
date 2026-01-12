import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrganizationDto } from './dto/create-organization.dto';
import { UpdateOrganizationDto } from './dto/update-organization.dto';

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

    // If updating slug, check if new slug is available
    if (updateOrganizationDto.slug) {
      const existing = await this.prisma.organization.findUnique({
        where: { slug: updateOrganizationDto.slug },
      });

      if (existing && existing.id !== id) {
        throw new ConflictException('Organization with this slug already exists');
      }
    }

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
}

