import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateChildDto } from './dto/create-child.dto';
import { UpdateChildDto } from './dto/update-child.dto';

@Injectable()
export class ChildrenService {
  constructor(private prisma: PrismaService) {}

  async create(createChildDto: CreateChildDto) {
    const { 
      medications, 
      allergies, 
      medicalConditions, 
      mentalHealthDx,
      triggers,
      copingMechanisms,
      interests,
      strengths,
      likes,
      dislikes,
      fears,
      ...rest 
    } = createChildDto;

    // organizationId is automatically injected by Prisma middleware
    return this.prisma.child.create({
      data: {
        ...rest,
        dateOfBirth: new Date(createChildDto.dateOfBirth),
        medications: medications || [],
        allergies: allergies || [],
        medicalConditions: medicalConditions || [],
        mentalHealthDx: mentalHealthDx || [],
        triggers: triggers || [],
        copingMechanisms: copingMechanisms || [],
        interests: interests || [],
        strengths: strengths || [],
        likes: likes || [],
        dislikes: dislikes || [],
        fears: fears || [],
      } as any,
      include: {
        family: true,
        client: true,
      },
    });
  }

  async findAll(filters?: { 
    status?: string; 
    familyId?: string;
    search?: string;
    page?: number; 
    limit?: number;
  }) {
    const page = filters?.page || 1;
    const limit = filters?.limit || 20;
    const skip = (page - 1) * limit;

    const where: any = {};

    if (filters?.status) {
      where.status = filters.status;
    }

    if (filters?.familyId) {
      where.familyId = filters.familyId;
    }

    if (filters?.search) {
      where.OR = [
        { firstName: { contains: filters.search, mode: 'insensitive' } },
        { lastName: { contains: filters.search, mode: 'insensitive' } },
        { nickname: { contains: filters.search, mode: 'insensitive' } },
      ];
    }

    const [children, total] = await Promise.all([
      this.prisma.child.findMany({
        where,
        include: {
          family: true,
          client: true,
          _count: {
            select: {
              assessments: true,
              incidents: true,
              goals: true,
            },
          },
        },
        orderBy: {
          lastName: 'asc',
        },
        skip,
        take: limit,
      }),
      this.prisma.child.count({ where }),
    ]);

    return {
      data: children,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string) {
    const child = await this.prisma.child.findUnique({
      where: { id },
      include: {
        family: true,
        client: {
          include: {
            cases: {
              include: {
                worker: true,
                program: true,
              },
            },
          },
        },
        assessments: {
          orderBy: { assessmentDate: 'desc' },
          take: 5,
        },
        educationRecords: {
          orderBy: { schoolYear: 'desc' },
          take: 3,
        },
        medicalRecords: {
          orderBy: { recordDate: 'desc' },
          take: 10,
        },
        incidents: {
          orderBy: { incidentDate: 'desc' },
          take: 10,
        },
        goals: {
          where: { status: 'Active' },
          include: {
            progressNotes: {
              orderBy: { progressDate: 'desc' },
              take: 3,
            },
          },
        },
        notes: {
          orderBy: { noteDate: 'desc' },
          take: 20,
        },
      },
    });

    if (!child) {
      throw new NotFoundException('Child not found');
    }

    return child;
  }

  async update(id: string, updateChildDto: UpdateChildDto) {
    const child = await this.findOne(id);

    const updateData: any = { ...updateChildDto };

    if (updateChildDto.dateOfBirth) {
      updateData.dateOfBirth = new Date(updateChildDto.dateOfBirth);
    }

    return this.prisma.child.update({
      where: { id },
      data: updateData,
      include: {
        family: true,
        client: true,
      },
    });
  }

  async remove(id: string) {
    // Verify child exists
    const child = await this.findOne(id);

    // Soft delete by setting status to 'Deleted'
    return this.prisma.child.update({
      where: { id },
      data: {
        status: 'Deleted',
        updatedAt: new Date(),
      },
      include: {
        family: true,
        client: true,
      },
    });
  }
}

