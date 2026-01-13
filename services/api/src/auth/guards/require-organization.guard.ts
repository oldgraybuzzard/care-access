import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';

/**
 * Guard that ensures the user belongs to an organization.
 * 
 * This guard BLOCKS SuperAdmin users from accessing tenant-scoped endpoints.
 * SuperAdmins have organizationId = null and should not access organizational data.
 * 
 * Use this guard on all endpoints that deal with:
 * - Cases, Clients, Children, Families
 * - Reports, Assessments, Documents
 * - Any tenant-scoped data
 * 
 * @example
 * ```typescript
 * @Get(':id')
 * @UseGuards(JwtAuthGuard, RequireOrganizationGuard)
 * async findCase(@Param('id') id: string) {
 *   // Only organization users can access this
 *   // SuperAdmins will get 403 Forbidden
 * }
 * ```
 */
@Injectable()
export class RequireOrganizationGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('Authentication required');
    }

    if (!user.organizationId) {
      throw new ForbiddenException(
        'This endpoint requires organization membership. ' +
        'SuperAdmins cannot access organizational data.',
      );
    }

    return true;
  }
}

