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
import { OrganizationsService } from './organizations.service';
import { CreateOrganizationDto } from './dto/create-organization.dto';
import { UpdateOrganizationDto } from './dto/update-organization.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AssignRoleDto } from './dto/assign-role.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@ApiTags('admin')
@Controller('admin/organizations')
@UseGuards(JwtAuthGuard, RolesGuard)
@ApiBearerAuth()
export class OrganizationsController {
  constructor(private readonly organizationsService: OrganizationsService) {}

  @Post()
  @Roles('admin')
  @ApiOperation({ summary: 'Create a new organization (super admin only)' })
  create(@Body() createOrganizationDto: CreateOrganizationDto) {
    return this.organizationsService.create(createOrganizationDto);
  }

  @Get()
  @Roles('admin')
  @ApiOperation({ summary: 'Get all organizations (super admin only)' })
  findAll() {
    return this.organizationsService.findAll();
  }

  @Get(':id')
  @Roles('admin')
  @ApiOperation({ summary: 'Get organization by ID (super admin only)' })
  findOne(@Param('id') id: string) {
    return this.organizationsService.findOne(id);
  }

  @Get(':id/stats')
  @Roles('admin')
  @ApiOperation({ summary: 'Get organization statistics (super admin only)' })
  getStats(@Param('id') id: string) {
    return this.organizationsService.getStats(id);
  }

  @Patch(':id')
  @Roles('admin')
  @ApiOperation({ summary: 'Update organization (super admin only)' })
  update(
    @Param('id') id: string,
    @Body() updateOrganizationDto: UpdateOrganizationDto,
  ) {
    return this.organizationsService.update(id, updateOrganizationDto);
  }

  @Delete(':id')
  @Roles('admin')
  @ApiOperation({ summary: 'Delete organization (super admin only)' })
  remove(@Param('id') id: string) {
    return this.organizationsService.remove(id);
  }
}

// User-facing organization endpoints
@ApiTags('organizations')
@Controller('organizations')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class UserOrganizationsController {
  constructor(private readonly organizationsService: OrganizationsService) {}

  @Get('me')
  @ApiOperation({ summary: 'Get current user\'s organization' })
  getMyOrganization(@Request() req) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.findOne(organizationId);
  }

  @Get('me/stats')
  @ApiOperation({ summary: 'Get current user\'s organization statistics' })
  getMyOrganizationStats(@Request() req) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.getStats(organizationId);
  }

  @Patch('me')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @ApiOperation({ summary: 'Update current user\'s organization (admin only)' })
  updateMyOrganization(
    @Request() req,
    @Body() updateOrganizationDto: UpdateOrganizationDto,
  ) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.update(organizationId, updateOrganizationDto);
  }

  @Get('me/users')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @ApiOperation({ summary: 'Get all users in current organization (admin only)' })
  getMyOrganizationUsers(@Request() req) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.getOrganizationUsers(organizationId);
  }

  @Patch('me/users/:userId')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @ApiOperation({ summary: 'Update a user in current organization (admin only)' })
  updateOrganizationUser(
    @Request() req,
    @Param('userId') userId: string,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.updateOrganizationUser(
      organizationId,
      userId,
      updateUserDto,
    );
  }

  @Post('me/users/:userId/roles')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @ApiOperation({ summary: 'Assign role to user (admin only)' })
  assignRoleToUser(
    @Request() req,
    @Param('userId') userId: string,
    @Body() assignRoleDto: AssignRoleDto,
  ) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.assignRoleToUser(
      organizationId,
      userId,
      assignRoleDto.roleId,
    );
  }

  @Delete('me/users/:userId/roles/:roleId')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @ApiOperation({ summary: 'Remove role from user (admin only)' })
  removeRoleFromUser(
    @Request() req,
    @Param('userId') userId: string,
    @Param('roleId') roleId: string,
  ) {
    const organizationId = req.user.organizationId;
    return this.organizationsService.removeRoleFromUser(
      organizationId,
      userId,
      roleId,
    );
  }

  @Get('roles')
  @ApiOperation({ summary: 'Get all available roles' })
  getAllRoles() {
    return this.organizationsService.getAllRoles();
  }
}

