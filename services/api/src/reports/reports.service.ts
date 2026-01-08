import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RunReportDto } from './dto/run-report.dto';
import { RunCustomReportDto } from './dto/run-custom-report.dto';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  // Get all report definitions
  async getDefinitions() {
    return this.prisma.reportDefinition.findMany({
      where: {
        OR: [
          { type: 'standard' },
          { isShared: true },
        ],
      },
      orderBy: {
        name: 'asc',
      },
    });
  }

  // Run a standard report
  async runStandardReport(dto: RunReportDto, userId: string) {
    const definition = await this.prisma.reportDefinition.findUnique({
      where: { id: dto.reportDefinitionId },
    });

    if (!definition) {
      throw new NotFoundException('Report definition not found');
    }

    // Create report run record
    const reportRun = await this.prisma.reportRun.create({
      data: {
        reportDefinitionId: dto.reportDefinitionId,
        requestedBy: userId,
        status: 'running',
        metaJson: dto.filters || {},
      },
    });

    try {
      // Execute the report based on type
      let data: any[];
      
      switch (definition.name) {
        case 'Caseload by Worker':
          data = await this.getCaseloadByWorker(dto.filters);
          break;
        case 'Active Cases by Program/Status':
          data = await this.getActiveCasesByProgramStatus(dto.filters);
          break;
        case 'Intakes vs Closures Trend':
          data = await this.getIntakesVsClosuresTrend(dto.filters);
          break;
        case 'Overdue/Compliance List':
          data = await this.getOverdueComplianceList(dto.filters);
          break;
        case 'Services Delivered by Period':
          data = await this.getServicesDeliveredByPeriod(dto.filters);
          break;
        default:
          throw new BadRequestException('Unknown report type');
      }

      // Update report run with results
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'completed',
          finishedAt: new Date(),
          rowCount: data.length,
        },
      });

      return {
        reportRunId: reportRun.id,
        data,
        rowCount: data.length,
      };
    } catch (error) {
      // Update report run with error
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'failed',
          finishedAt: new Date(),
          metaJson: { error: error.message },
        },
      });

      throw error;
    }
  }

  // Run a custom report
  async runCustomReport(dto: RunCustomReportDto, userId: string) {
    // Create report run record
    const reportRun = await this.prisma.reportRun.create({
      data: {
        reportDefinitionId: dto.reportDefinitionId || null,
        requestedBy: userId,
        status: 'running',
        metaJson: dto,
      },
    });

    try {
      let data: any[];

      switch (dto.dataset) {
        case 'clients':
          data = await this.queryClients(dto);
          break;
        case 'cases':
          data = await this.queryCases(dto);
          break;
        case 'activities':
          data = await this.queryActivities(dto);
          break;
        case 'services':
          data = await this.queryServices(dto);
          break;
        default:
          throw new BadRequestException('Invalid dataset');
      }

      // Update report run with results
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'completed',
          finishedAt: new Date(),
          rowCount: data.length,
        },
      });

      return {
        reportRunId: reportRun.id,
        data,
        rowCount: data.length,
      };
    } catch (error) {
      await this.prisma.reportRun.update({
        where: { id: reportRun.id },
        data: {
          status: 'failed',
          finishedAt: new Date(),
          metaJson: { error: error.message },
        },
      });

      throw error;
    }
  }

  // Get report run results
  async getReportRunResults(runId: string, page = 1, limit = 100) {
    const reportRun = await this.prisma.reportRun.findUnique({
      where: { id: runId },
      include: {
        reportDefinition: true,
      },
    });

    if (!reportRun) {
      throw new NotFoundException('Report run not found');
    }

    // In a production system, you'd store results in a separate table or cache
    // For now, we'll return the metadata
    return {
      reportRun,
      message: 'Results are available for export',
    };
  }

  // Standard Report Implementations
  private async getCaseloadByWorker(filters: any) {
    return this.prisma.case.groupBy({
      by: ['assignedWorkerId'],
      where: {
        status: 'active',
        ...(filters?.programId && { programId: filters.programId }),
      },
      _count: {
        id: true,
      },
    });
  }

  private async getActiveCasesByProgramStatus(filters: any) {
    return this.prisma.case.groupBy({
      by: ['programId', 'status'],
      where: {
        ...(filters?.programId && { programId: filters.programId }),
      },
      _count: {
        id: true,
      },
    });
  }

  private async getIntakesVsClosuresTrend(filters: any) {
    // This would typically use KpiDaily table for better performance
    const startDate = filters?.startDate ? new Date(filters.startDate) : new Date(new Date().setMonth(new Date().getMonth() - 6));
    const endDate = filters?.endDate ? new Date(filters.endDate) : new Date();

    return this.prisma.$queryRaw`
      SELECT 
        DATE_TRUNC('month', opened_at) as month,
        COUNT(*) FILTER (WHERE opened_at IS NOT NULL) as intakes,
        COUNT(*) FILTER (WHERE closed_at IS NOT NULL) as closures
      FROM cases
      WHERE opened_at >= ${startDate} AND opened_at <= ${endDate}
      GROUP BY month
      ORDER BY month
    `;
  }

  private async getOverdueComplianceList(filters: any) {
    // Placeholder - would need business logic for "overdue" definition
    return this.prisma.case.findMany({
      where: {
        status: 'active',
        // Add overdue logic here based on business rules
      },
      include: {
        client: true,
        worker: true,
        program: true,
      },
    });
  }

  private async getServicesDeliveredByPeriod(filters: any) {
    const startDate = filters?.startDate ? new Date(filters.startDate) : new Date(new Date().setMonth(new Date().getMonth() - 1));
    const endDate = filters?.endDate ? new Date(filters.endDate) : new Date();

    return this.prisma.service.groupBy({
      by: ['serviceType'],
      where: {
        startAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      _count: {
        id: true,
      },
    });
  }

  // Custom Report Query Methods
  private async queryClients(dto: RunCustomReportDto) {
    const where: any = {};

    if (dto.filters?.programId) {
      where.programId = dto.filters.programId;
    }

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    return this.prisma.client.findMany({
      where,
      include: {
        program: true,
      },
    });
  }

  private async queryCases(dto: RunCustomReportDto) {
    const where: any = {};

    if (dto.filters?.programId) {
      where.programId = dto.filters.programId;
    }

    if (dto.filters?.status) {
      where.status = dto.filters.status;
    }

    if (dto.filters?.workerId) {
      where.assignedWorkerId = dto.filters.workerId;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.openedAt = {};
      if (dto.filters.startDate) {
        where.openedAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.openedAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.case.findMany({
      where,
      include: {
        client: true,
        worker: true,
        program: true,
      },
    });
  }

  private async queryActivities(dto: RunCustomReportDto) {
    const where: any = {};

    if (dto.filters?.activityType) {
      where.activityType = dto.filters.activityType;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.occurredAt = {};
      if (dto.filters.startDate) {
        where.occurredAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.occurredAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.activity.findMany({
      where,
      include: {
        case: {
          include: {
            client: true,
          },
        },
      },
    });
  }

  private async queryServices(dto: RunCustomReportDto) {
    const where: any = {};

    if (dto.filters?.serviceType) {
      where.serviceType = dto.filters.serviceType;
    }

    if (dto.filters?.startDate || dto.filters?.endDate) {
      where.startAt = {};
      if (dto.filters.startDate) {
        where.startAt.gte = new Date(dto.filters.startDate);
      }
      if (dto.filters.endDate) {
        where.startAt.lte = new Date(dto.filters.endDate);
      }
    }

    return this.prisma.service.findMany({
      where,
      include: {
        case: {
          include: {
            client: true,
          },
        },
      },
    });
  }
}

