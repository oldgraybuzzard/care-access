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
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { SuperAdminGuard } from '../auth/guards/superadmin.guard';
import { SuperAdminService } from './superadmin.service';
import { CreateSuperAdminDto } from './dto/create-superadmin.dto';
import { UpdateSuperAdminDto } from './dto/update-superadmin.dto';

@ApiTags('superadmin')
@Controller('admin/superadmins')
@UseGuards(JwtAuthGuard, SuperAdminGuard)
@ApiBearerAuth()
export class SuperAdminController {
  constructor(private readonly superAdminService: SuperAdminService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new SuperAdmin user (SuperAdmin only)' })
  create(@Body() createSuperAdminDto: CreateSuperAdminDto) {
    return this.superAdminService.create(createSuperAdminDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all SuperAdmin users (SuperAdmin only)' })
  findAll() {
    return this.superAdminService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get SuperAdmin user by ID (SuperAdmin only)' })
  findOne(@Param('id') id: string) {
    return this.superAdminService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update SuperAdmin user (SuperAdmin only)' })
  update(
    @Param('id') id: string,
    @Body() updateSuperAdminDto: UpdateSuperAdminDto,
  ) {
    return this.superAdminService.update(id, updateSuperAdminDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete SuperAdmin user (SuperAdmin only)' })
  remove(@Param('id') id: string, @Request() req) {
    // Prevent self-deletion
    if (id === req.user.userId) {
      throw new Error('Cannot delete your own SuperAdmin account');
    }
    return this.superAdminService.remove(id);
  }

  @Get('platform/health')
  @ApiOperation({ summary: 'Get platform health metrics (SuperAdmin only)' })
  getPlatformHealth() {
    return this.superAdminService.getPlatformHealth();
  }

  @Get('platform/stats')
  @ApiOperation({ summary: 'Get platform-wide statistics (SuperAdmin only)' })
  getPlatformStats() {
    return this.superAdminService.getPlatformStats();
  }
}

