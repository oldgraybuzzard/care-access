import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class KpiRollupJob {
  private readonly logger = new Logger(KpiRollupJob.name);

  constructor(private prisma: PrismaService) {}

  // Run daily at 2 AM
  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async handleKpiRollup() {
    this.logger.log('📊 Starting KPI rollup job...');

    try {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);

      // Get all programs
      const programs = await this.prisma.program.findMany();

      // Get all workers
      const workers = await this.prisma.worker.findMany();

      // Rollup KPIs for each program
      for (const program of programs) {
        await this.rollupProgramKpis(program.id, yesterday);
      }

      // Rollup KPIs for each worker
      for (const worker of workers) {
        await this.rollupWorkerKpis(worker.id, yesterday);
      }

      // Rollup overall KPIs
      await this.rollupOverallKpis(yesterday);

      this.logger.log('✅ KPI rollup completed successfully');
    } catch (error) {
      this.logger.error(`❌ KPI rollup failed: ${error.message}`, error.stack);
    }
  }

  private async rollupProgramKpis(programId: string, date: Date) {
    // Count active cases
    const activeCases = await this.prisma.case.count({
      where: {
        programId,
        status: 'active',
        openedAt: { lte: date },
        OR: [
          { closedAt: null },
          { closedAt: { gt: date } },
        ],
      },
    });

    // Count intakes on this date
    const intakes = await this.prisma.case.count({
      where: {
        programId,
        openedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Count closures on this date
    const closures = await this.prisma.case.count({
      where: {
        programId,
        closedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Upsert KPI record
    await this.prisma.kpiDaily.upsert({
      where: {
        date_programId_workerId: {
          date,
          programId,
          workerId: null,
        },
      },
      update: {
        activeCases,
        intakes,
        closures,
      },
      create: {
        date,
        programId,
        activeCases,
        intakes,
        closures,
      },
    });
  }

  private async rollupWorkerKpis(workerId: string, date: Date) {
    // Count active cases
    const activeCases = await this.prisma.case.count({
      where: {
        assignedWorkerId: workerId,
        status: 'active',
        openedAt: { lte: date },
        OR: [
          { closedAt: null },
          { closedAt: { gt: date } },
        ],
      },
    });

    // Count intakes on this date
    const intakes = await this.prisma.case.count({
      where: {
        assignedWorkerId: workerId,
        openedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Count closures on this date
    const closures = await this.prisma.case.count({
      where: {
        assignedWorkerId: workerId,
        closedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Upsert KPI record
    await this.prisma.kpiDaily.upsert({
      where: {
        date_programId_workerId: {
          date,
          programId: null,
          workerId,
        },
      },
      update: {
        activeCases,
        intakes,
        closures,
      },
      create: {
        date,
        workerId,
        activeCases,
        intakes,
        closures,
      },
    });
  }

  private async rollupOverallKpis(date: Date) {
    // Count overall active cases
    const activeCases = await this.prisma.case.count({
      where: {
        status: 'active',
        openedAt: { lte: date },
        OR: [
          { closedAt: null },
          { closedAt: { gt: date } },
        ],
      },
    });

    // Count overall intakes
    const intakes = await this.prisma.case.count({
      where: {
        openedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Count overall closures
    const closures = await this.prisma.case.count({
      where: {
        closedAt: {
          gte: date,
          lt: new Date(date.getTime() + 24 * 60 * 60 * 1000),
        },
      },
    });

    // Upsert overall KPI record
    await this.prisma.kpiDaily.upsert({
      where: {
        date_programId_workerId: {
          date,
          programId: null,
          workerId: null,
        },
      },
      update: {
        activeCases,
        intakes,
        closures,
      },
      create: {
        date,
        activeCases,
        intakes,
        closures,
      },
    });
  }
}

