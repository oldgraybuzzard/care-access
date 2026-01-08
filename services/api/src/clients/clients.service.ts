import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ClientsService {
  constructor(private prisma: PrismaService) {}

  async findById(id: string) {
    const client = await this.prisma.client.findUnique({
      where: { id },
      include: {
        program: true,
        vendorSource: true,
        cases: {
          include: {
            worker: true,
            program: true,
          },
          orderBy: {
            openedAt: 'desc',
          },
        },
      },
    });

    if (!client) {
      throw new NotFoundException('Client not found');
    }

    return client;
  }

  async getCases(clientId: string, filters?: { status?: string; page?: number; limit?: number }) {
    const page = filters?.page || 1;
    const limit = filters?.limit || 20;
    const skip = (page - 1) * limit;

    const where: any = {
      clientId,
    };

    if (filters?.status) {
      where.status = filters.status;
    }

    const [cases, total] = await Promise.all([
      this.prisma.case.findMany({
        where,
        include: {
          worker: true,
          program: true,
        },
        orderBy: {
          openedAt: 'desc',
        },
        skip,
        take: limit,
      }),
      this.prisma.case.count({ where }),
    ]);

    return {
      data: cases,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}

