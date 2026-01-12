import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Delete,
  Param,
  Query,
  UseGuards,
  Request
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { ChildrenService } from './children.service';
import { CreateChildDto } from './dto/create-child.dto';
import { UpdateChildDto } from './dto/update-child.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('children')
@Controller('children')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ChildrenController {
  constructor(
    private readonly childrenService: ChildrenService,
    private readonly auditService: AuditService,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new child profile' })
  async create(@Request() req, @Body() createChildDto: CreateChildDto) {
    const child = await this.childrenService.create(createChildDto);

    await this.auditService.log({
      userId: req.user.userId,
      action: 'create',
      entityType: 'child',
      entityId: child.id,
    });

    return child;
  }

  @Get()
  @ApiOperation({ summary: 'Get all children' })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'familyId', required: false })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async findAll(
    @Request() req,
    @Query('status') status?: string,
    @Query('familyId') familyId?: string,
    @Query('search') search?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const result = await this.childrenService.findAll({
      status,
      familyId,
      search,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });

    await this.auditService.log({
      userId: req.user.userId,
      action: 'list',
      entityType: 'child',
    });

    return result;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get child by ID with full profile' })
  async findOne(@Request() req, @Param('id') id: string) {
    const child = await this.childrenService.findOne(id);

    await this.auditService.log({
      userId: req.user.userId,
      action: 'view',
      entityType: 'child',
      entityId: id,
    });

    return child;
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update child profile' })
  async update(
    @Request() req,
    @Param('id') id: string,
    @Body() updateChildDto: UpdateChildDto,
  ) {
    const child = await this.childrenService.update(id, updateChildDto);

    await this.auditService.log({
      userId: req.user.userId,
      action: 'update',
      entityType: 'child',
      entityId: id,
      metaJson: updateChildDto,
    });

    return child;
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete child (soft delete)' })
  async remove(@Request() req, @Param('id') id: string) {
    const child = await this.childrenService.remove(id);

    await this.auditService.log({
      userId: req.user.userId,
      action: 'delete',
      entityType: 'child',
      entityId: id,
    });

    return { message: 'Child deleted successfully', child };
  }
}

