import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface DashboardFilters {
  from?: string;
  to?: string;
  programId?: string;
  workerId?: string;
}

@Injectable()
export class DashboardsService {
  constructor(private prisma: PrismaService) {}

  async getKPIs(filters: DashboardFilters) {
    const where: any = {};

    if (filters.programId) {
      where.programId = filters.programId;
    }

    if (filters.workerId) {
      where.assignedWorkerId = filters.workerId;
    }

    // Get current active cases
    const activeCases = await this.prisma.case.count({
      where: {
        ...where,
        status: 'active',
      },
    });

    // Get intakes in period
    const intakesWhere: any = { ...where };
    if (filters.from) {
      intakesWhere.openedAt = { gte: new Date(filters.from) };
    }
    if (filters.to) {
      intakesWhere.openedAt = {
        ...intakesWhere.openedAt,
        lte: new Date(filters.to),
      };
    }

    const intakes = await this.prisma.case.count({
      where: intakesWhere,
    });

    // Get closures in period
    const closuresWhere: any = { ...where };
    if (filters.from) {
      closuresWhere.closedAt = { gte: new Date(filters.from) };
    }
    if (filters.to) {
      closuresWhere.closedAt = {
        ...closuresWhere.closedAt,
        lte: new Date(filters.to),
      };
    }

    const closures = await this.prisma.case.count({
      where: {
        ...closuresWhere,
        closedAt: { not: null },
      },
    });

    // Get total clients
    const totalClients = await this.prisma.client.count({
      where: filters.programId ? { programId: filters.programId } : {},
    });

    // Get overdue count (placeholder - needs business logic)
    const overdueCount = 0; // Would implement based on business rules

    return {
      activeCases,
      intakes,
      closures,
      totalClients,
      overdueCount,
      period: {
        from: filters.from || null,
        to: filters.to || null,
      },
    };
  }

  async getTrends(metric: string, interval: string, filters: DashboardFilters) {
    const from = filters.from ? new Date(filters.from) : new Date(new Date().setMonth(new Date().getMonth() - 6));
    const to = filters.to ? new Date(filters.to) : new Date();

    // Use KpiDaily table if available, otherwise aggregate from cases
    const useKpiDaily = await this.prisma.kpiDaily.count() > 0;

    if (useKpiDaily) {
      return this.getTrendsFromKpiDaily(metric, interval, from, to, filters);
    } else {
      return this.getTrendsFromCases(metric, interval, from, to, filters);
    }
  }

  private async getTrendsFromKpiDaily(
    metric: string,
    interval: string,
    from: Date,
    to: Date,
    filters: DashboardFilters,
  ) {
    const where: any = {
      date: {
        gte: from,
        lte: to,
      },
    };

    if (filters.programId) {
      where.programId = filters.programId;
    }

    if (filters.workerId) {
      where.workerId = filters.workerId;
    }

    const data = await this.prisma.kpiDaily.findMany({
      where,
      orderBy: {
        date: 'asc',
      },
    });

    // Group by interval (day, week, month)
    const grouped = this.groupByInterval(data, interval, metric);

    return grouped;
  }

  private async getTrendsFromCases(
    metric: string,
    interval: string,
    from: Date,
    to: Date,
    filters: DashboardFilters,
  ) {
    // For now, return empty array since we don't have case data
    // This method would need proper implementation with actual case data
    return [];
  }

  private groupByInterval(data: any[], interval: string, metric: string) {
    // Simple grouping logic - in production, use a proper date library
    const grouped: any[] = [];
    
    data.forEach((item) => {
      const value = item[metric] || 0;
      grouped.push({
        period: item.date,
        value,
      });
    });

    return grouped;
  }

  async getCasesByProgram(filters: DashboardFilters) {
    const where: any = {};

    if (filters.workerId) {
      where.assignedWorkerId = filters.workerId;
    }

    const result = await this.prisma.case.groupBy({
      by: ['programId', 'status'],
      where,
      _count: {
        id: true,
      },
    });

    return result;
  }

  async getCasesByWorker(filters: DashboardFilters) {
    const where: any = {};

    if (filters.programId) {
      where.programId = filters.programId;
    }

    const result = await this.prisma.case.groupBy({
      by: ['assignedWorkerId'],
      where: {
        ...where,
        status: 'active',
      },
      _count: {
        id: true,
      },
    });

    return result;
  }
}

