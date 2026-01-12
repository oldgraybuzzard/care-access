import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { EducationRecordsService } from './education-records.service';
import { CreateEducationRecordDto } from './dto/create-education-record.dto';
import { UpdateEducationRecordDto } from './dto/update-education-record.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AuditService } from '../audit/audit.service';

@ApiTags('education-records')
@Controller('children/:childId/education-records')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class EducationRecordsController {
  constructor(
    private readonly educationRecordsService: EducationRecordsService,
    private readonly auditService: AuditService,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new education record for a child' })
  async create(
    @Request() req,
    @Param('childId') childId: string,
    @Body() createEducationRecordDto: CreateEducationRecordDto,
  ) {
    const record = await this.educationRecordsService.create(
      childId,
      createEducationRecordDto,
    );

    await this.auditService.log({
      userId: req.user.userId,
      action: 'create',
      entityType: 'education_record',
      entityId: record.id,
      metaJson: { childId },
    });

    return record;
  }

  @Get()
  @ApiOperation({ summary: 'Get all education records for a child' })
  async findAll(@Param('childId') childId: string) {
    return this.educationRecordsService.findAll(childId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a specific education record' })
  async findOne(@Param('id') id: string) {
    return this.educationRecordsService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update an education record' })
  async update(
    @Request() req,
    @Param('id') id: string,
    @Body() updateEducationRecordDto: UpdateEducationRecordDto,
  ) {
    const record = await this.educationRecordsService.update(
      id,
      updateEducationRecordDto,
    );

    await this.auditService.log({
      userId: req.user.userId,
      action: 'update',
      entityType: 'education_record',
      entityId: id,
      metaJson: updateEducationRecordDto,
    });

    return record;
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete an education record' })
  async remove(@Request() req, @Param('id') id: string) {
    await this.educationRecordsService.remove(id);

    await this.auditService.log({
      userId: req.user.userId,
      action: 'delete',
      entityType: 'education_record',
      entityId: id,
    });

    return { message: 'Education record deleted successfully' };
  }
}

