import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { DashboardsService } from './dashboards.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('dashboards')
@Controller('dashboards')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class DashboardsController {
  constructor(private readonly dashboardsService: DashboardsService) {}

  @Get('kpis')
  @ApiOperation({ summary: 'Get dashboard KPIs' })
  @ApiQuery({ name: 'from', required: false, description: 'Start date (ISO 8601)' })
  @ApiQuery({ name: 'to', required: false, description: 'End date (ISO 8601)' })
  @ApiQuery({ name: 'programId', required: false, description: 'Filter by program' })
  @ApiQuery({ name: 'workerId', required: false, description: 'Filter by worker' })
  async getKPIs(
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('programId') programId?: string,
    @Query('workerId') workerId?: string,
  ) {
    return this.dashboardsService.getKPIs({
      from,
      to,
      programId,
      workerId,
    });
  }

  @Get('trends')
  @ApiOperation({ summary: 'Get trend data for charts' })
  @ApiQuery({ name: 'metric', required: true, description: 'Metric to track (activeCases, intakes, closures)' })
  @ApiQuery({ name: 'interval', required: false, description: 'Time interval (day, week, month)', enum: ['day', 'week', 'month'] })
  @ApiQuery({ name: 'from', required: false, description: 'Start date (ISO 8601)' })
  @ApiQuery({ name: 'to', required: false, description: 'End date (ISO 8601)' })
  @ApiQuery({ name: 'programId', required: false, description: 'Filter by program' })
  @ApiQuery({ name: 'workerId', required: false, description: 'Filter by worker' })
  async getTrends(
    @Query('metric') metric: string,
    @Query('interval') interval: string = 'month',
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('programId') programId?: string,
    @Query('workerId') workerId?: string,
  ) {
    return this.dashboardsService.getTrends(metric, interval, {
      from,
      to,
      programId,
      workerId,
    });
  }

  @Get('cases-by-program')
  @ApiOperation({ summary: 'Get case distribution by program' })
  @ApiQuery({ name: 'workerId', required: false })
  async getCasesByProgram(@Query('workerId') workerId?: string) {
    return this.dashboardsService.getCasesByProgram({ workerId });
  }

  @Get('cases-by-worker')
  @ApiOperation({ summary: 'Get active caseload by worker' })
  @ApiQuery({ name: 'programId', required: false })
  async getCasesByWorker(@Query('programId') programId?: string) {
    return this.dashboardsService.getCasesByWorker({ programId });
  }
}

