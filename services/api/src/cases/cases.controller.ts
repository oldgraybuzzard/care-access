import { Controller, Get, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { CasesService } from './cases.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RequireOrganizationGuard } from '../auth/guards/require-organization.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('cases')
@Controller('cases')
@UseGuards(JwtAuthGuard, RequireOrganizationGuard)
@ApiBearerAuth()
export class CasesController {
  constructor(
    private readonly casesService: CasesService,
    private readonly auditService: AuditService,
  ) {}

  @Get(':id')
  @ApiOperation({ summary: 'Get case by ID' })
  async findOne(@Request() req, @Param('id') id: string) {
    const caseRecord = await this.casesService.findById(id);

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view',
      entityType: 'case',
      entityId: id,
    });

    return caseRecord;
  }

  @Get(':id/activities')
  @ApiOperation({ summary: 'Get all activities for a case' })
  @ApiQuery({ name: 'type', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getActivities(
    @Request() req,
    @Param('id') id: string,
    @Query('type') type?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.casesService.getActivities(id, {
      type,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view_activities',
      entityType: 'case',
      entityId: id,
    });

    return result;
  }

  @Get(':id/services')
  @ApiOperation({ summary: 'Get all services for a case' })
  @ApiQuery({ name: 'type', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getServices(
    @Request() req,
    @Param('id') id: string,
    @Query('type') type?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.casesService.getServices(id, {
      type,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view_services',
      entityType: 'case',
      entityId: id,
    });

    return result;
  }

  @Get(':id/documents')
  @ApiOperation({ summary: 'Get all documents for a case' })
  @ApiQuery({ name: 'type', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getDocuments(
    @Request() req,
    @Param('id') id: string,
    @Query('type') type?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.casesService.getDocuments(id, {
      type,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view_documents',
      entityType: 'case',
      entityId: id,
    });

    return result;
  }
}

