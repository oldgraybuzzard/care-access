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

    // Build where clause for clients
    const clientWhere: any = {};
    if (filters.q) {
      clientWhere.OR = [
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
    if (filters.program) {
      clientWhere.programId = filters.program;
    }
    if (filters.status) {
      clientWhere.status = filters.status;
    }

    // Build where clause for children
    const childWhere: any = {};
    if (filters.q) {
      childWhere.OR = [
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
    if (filters.status) {
      childWhere.status = filters.status;
    }

    // Filter by worker (through cases)
    const caseWhere: any = {};
    if (filters.worker) {
      caseWhere.assignedWorkerId = filters.worker;
    }

    // Search both clients and children in parallel
    const [clients, clientTotal, children, childTotal] = await Promise.all([
      this.prisma.client.findMany({
        where: clientWhere,
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
      this.prisma.client.count({ where: clientWhere }),
      this.prisma.child.findMany({
        where: childWhere,
        include: {
          family: true,
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
      this.prisma.child.count({ where: childWhere }),
    ]);

    // Transform children to match client format for unified response
    const transformedChildren = children.map((child) => ({
      id: child.id,
      firstName: child.firstName,
      lastName: child.lastName,
      dob: child.dateOfBirth,
      status: child.status,
      programId: null,
      program: null,
      cases: [],
      // Add a flag to identify this as a child record
      _type: 'child',
      _childData: {
        middleName: child.middleName,
        nickname: child.nickname,
        gender: child.gender,
        familyId: child.familyId,
        family: child.family,
      },
    }));

    // Combine and sort results
    const combinedResults = [...clients, ...transformedChildren].sort((a, b) => {
      const lastNameCompare = a.lastName.localeCompare(b.lastName);
      if (lastNameCompare !== 0) return lastNameCompare;
      return a.firstName.localeCompare(b.firstName);
    });

    const total = clientTotal + childTotal;

    return {
      data: combinedResults,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
        clientCount: clientTotal,
        childCount: childTotal,
      },
    };
  }
}

