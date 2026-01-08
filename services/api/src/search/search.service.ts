import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface SearchFilters {
  q?: string;
  program?: string;
  status?: string;
  worker?: string;
  page?: number;
  limit?: number;
}

@Injectable()
export class SearchService {
  constructor(private prisma: PrismaService) {}

  async search(filters: SearchFilters) {
    const page = filters.page || 1;
    const limit = filters.limit || 20;
    const skip = (page - 1) * limit;

    const where: any = {};

    // Text search across client names and case IDs
    if (filters.q) {
      where.OR = [
        {
          firstName: {
            contains: filters.q,
            mode: 'insensitive',
          },
        },
        {
          lastName: {
            contains: filters.q,
            mode: 'insensitive',
          },
        },
      ];
    }

    // Filter by program
    if (filters.program) {
      where.programId = filters.program;
    }

    // Filter by status
    if (filters.status) {
      where.status = filters.status;
    }

    // Filter by worker (through cases)
    const caseWhere: any = {};
    if (filters.worker) {
      caseWhere.assignedWorkerId = filters.worker;
    }

    const [clients, total] = await Promise.all([
      this.prisma.client.findMany({
        where,
        include: {
          program: true,
          cases: {
            where: Object.keys(caseWhere).length > 0 ? caseWhere : undefined,
            include: {
              worker: true,
            },
            orderBy: {
              openedAt: 'desc',
            },
            take: 1,
          },
        },
        orderBy: [
          {
            lastName: 'asc',
          },
          {
            firstName: 'asc',
          },
        ],
        skip,
        take: limit,
      }),
      this.prisma.client.count({ where }),
    ]);

    return {
      data: clients,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}

