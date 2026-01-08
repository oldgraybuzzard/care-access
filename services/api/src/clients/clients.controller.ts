import { Controller, Get, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { ClientsService } from './clients.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('clients')
@Controller('clients')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ClientsController {
  constructor(
    private readonly clientsService: ClientsService,
    private readonly auditService: AuditService,
  ) {}

  @Get(':id')
  @ApiOperation({ summary: 'Get client by ID' })
  async findOne(@Request() req, @Param('id') id: string) {
    const client = await this.clientsService.findById(id);

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view',
      entityType: 'client',
      entityId: id,
    });

    return client;
  }

  @Get(':id/cases')
  @ApiOperation({ summary: 'Get all cases for a client' })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getCases(
    @Request() req,
    @Param('id') id: string,
    @Query('status') status?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.clientsService.getCases(id, {
      status,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    // Audit log
    await this.auditService.log({
      userId: req.user.userId,
      action: 'view_cases',
      entityType: 'client',
      entityId: id,
    });

    return result;
  }
}

