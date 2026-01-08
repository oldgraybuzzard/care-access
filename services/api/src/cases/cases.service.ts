import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CasesService {
  constructor(private prisma: PrismaService) {}

  async findById(id: string) {
    const caseRecord = await this.prisma.case.findUnique({
      where: { id },
      include: {
        client: {
          include: {
            program: true,
          },
        },
        worker: true,
        program: true,
        vendorSource: true,
      },
    });

    if (!caseRecord) {
      throw new NotFoundException('Case not found');
    }

    return caseRecord;
  }

  async getActivities(caseId: string, filters?: { type?: string; page?: number; limit?: number }) {
    const page = filters?.page || 1;
    const limit = filters?.limit || 50;
    const skip = (page - 1) * limit;

    const where: any = {
      caseId,
    };

    if (filters?.type) {
      where.activityType = filters.type;
    }

    const [activities, total] = await Promise.all([
      this.prisma.activity.findMany({
        where,
        orderBy: {
          occurredAt: 'desc',
        },
        skip,
        take: limit,
      }),
      this.prisma.activity.count({ where }),
    ]);

    return {
      data: activities,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getServices(caseId: string, filters?: { type?: string; page?: number; limit?: number }) {
    const page = filters?.page || 1;
    const limit = filters?.limit || 50;
    const skip = (page - 1) * limit;

    const where: any = {
      caseId,
    };

    if (filters?.type) {
      where.serviceType = filters.type;
    }

    const [services, total] = await Promise.all([
      this.prisma.service.findMany({
        where,
        orderBy: {
          startAt: 'desc',
        },
        skip,
        take: limit,
      }),
      this.prisma.service.count({ where }),
    ]);

    return {
      data: services,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getDocuments(caseId: string, filters?: { type?: string; page?: number; limit?: number }) {
    const page = filters?.page || 1;
    const limit = filters?.limit || 50;
    const skip = (page - 1) * limit;

    const where: any = {
      caseId,
    };

    if (filters?.type) {
      where.docType = filters.type;
    }

    const [documents, total] = await Promise.all([
      this.prisma.document.findMany({
        where,
        orderBy: {
          createdAt: 'desc',
        },
        skip,
        take: limit,
      }),
      this.prisma.document.count({ where }),
    ]);

    return {
      data: documents,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}

