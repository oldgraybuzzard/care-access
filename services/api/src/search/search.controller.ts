import { Controller, Get, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { SearchService } from './search.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('search')
@Controller('search')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class SearchController {
  constructor(
    private readonly searchService: SearchService,
    private readonly auditService: AuditService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Global search for clients and cases' })
  @ApiQuery({ name: 'q', required: false, description: 'Search query' })
  @ApiQuery({ name: 'program', required: false, description: 'Program ID filter' })
  @ApiQuery({ name: 'status', required: false, description: 'Status filter' })
  @ApiQuery({ name: 'worker', required: false, description: 'Worker ID filter' })
  @ApiQuery({ name: 'page', required: false, description: 'Page number' })
  @ApiQuery({ name: 'limit', required: false, description: 'Items per page' })
  async search(
    @Request() req,
    @Query('q') q?: string,
    @Query('program') program?: string,
    @Query('status') status?: string,
    @Query('worker') worker?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.searchService.search({
      q,
      program,
      status,
      worker,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    // Audit log the search
    await this.auditService.log({
      userId: req.user.userId,
      action: 'search',
      entityType: 'client',
      metaJson: { q, program, status, worker },
    });

    return result;
  }
}

