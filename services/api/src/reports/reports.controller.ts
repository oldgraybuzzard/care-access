import { Controller, Get, Post, Body, Param, Query, UseGuards, Request, Res, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { Response } from 'express';
import { ReportsService } from './reports.service';
import { ExportService } from './export.service';
import { RunReportDto } from './dto/run-report.dto';
import { RunCustomReportDto } from './dto/run-custom-report.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('reports')
@Controller('reports')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ReportsController {
  constructor(
    private readonly reportsService: ReportsService,
    private readonly exportService: ExportService,
    private readonly auditService: AuditService,
  ) {}

  @Get('definitions')
  @ApiOperation({ summary: 'Get all available report definitions' })
  async getDefinitions(@Request() req) {
    return this.reportsService.getDefinitions(req.user.organizationId);
  }

  @Post('run')
  @ApiOperation({ summary: 'Run a standard report' })
  async runReport(@Request() req, @Body() runReportDto: RunReportDto) {
    const result = await this.reportsService.runStandardReport(
      runReportDto,
      req.user.userId,
      req.user.organizationId,
    );

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'run_report',
      entityType: 'report',
      entityId: runReportDto.reportDefinitionId,
      metaJson: runReportDto.filters,
    });

    return result;
  }

  @Post('custom/run')
  @ApiOperation({ summary: 'Run a custom ad-hoc report' })
  async runCustomReport(@Request() req, @Body() runCustomReportDto: RunCustomReportDto) {
    const result = await this.reportsService.runCustomReport(
      runCustomReportDto,
      req.user.userId,
      req.user.organizationId,
    );

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'run_custom_report',
      entityType: 'report',
      metaJson: runCustomReportDto,
    });

    return result;
  }

  @Get('runs/:runId/results')
  @ApiOperation({ summary: 'Get report run results' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getReportRunResults(
    @Param('runId') runId: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.reportsService.getReportRunResults(
      runId,
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('runs/:runId/export')
  @ApiOperation({ summary: 'Export report results to CSV or XLSX' })
  @ApiQuery({ name: 'format', enum: ['csv', 'xlsx'], required: false })
  async exportReport(
    @Request() req,
    @Param('runId') runId: string,
    @Query('format') format: string = 'csv',
    @Res() res: Response,
  ) {
    // Get report data (in production, this would fetch from stored results)
    const reportData = await this.reportsService.getReportRunResults(runId);

    // For demo purposes, we'll use sample data
    // In production, you'd fetch the actual report data
    const data = [
      { id: 1, name: 'Sample', value: 100 },
      { id: 2, name: 'Data', value: 200 },
    ];

    const flattenedData = this.exportService.flattenData(data);

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'export_report',
      entityType: 'report',
      entityId: runId,
      metaJson: { format },
    });

    if (format === 'xlsx') {
      const buffer = await this.exportService.exportToExcel(flattenedData, `report-${runId}`);
      
      res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      res.setHeader('Content-Disposition', `attachment; filename=report-${runId}.xlsx`);
      res.send(buffer);
    } else {
      const filepath = await this.exportService.exportToCSV(flattenedData, `report-${runId}`);
      
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename=report-${runId}.csv`);
      res.sendFile(filepath);
    }
  }
}

