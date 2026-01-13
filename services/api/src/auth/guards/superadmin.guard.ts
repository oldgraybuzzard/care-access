import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';

/**
 * Guard that ensures the user is a SuperAdmin.
 * 
 * SuperAdmins are identified by:
 * 1. Having the 'superadmin' role
 * 2. Having organizationId = null
 * 
 * This guard is used on platform management endpoints that should
 * ONLY be accessible to SuperAdmins, such as:
 * - Creating organizations
 * - Managing subscriptions
 * - Platform-wide settings
 * 
 * @example
 * ```typescript
 * @Post()
 * @UseGuards(JwtAuthGuard, SuperAdminGuard)
 * async createOrganization(@Body() dto: CreateOrganizationDto) {
 *   // Only SuperAdmins can access this
 *   // Organization users will get 403 Forbidden
 * }
 * ```
 */
@Injectable()
export class SuperAdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('Authentication required');
    }

    // SuperAdmins must have:
    // 1. The 'superadmin' role
    // 2. NO organizationId (null)
    const isSuperAdmin =
      user.roles?.includes('superadmin') && user.organizationId === null;

    if (!isSuperAdmin) {
      throw new ForbiddenException(
        'This endpoint requires SuperAdmin privileges. ' +
        'Organization users cannot access platform management functions.',
      );
    }

    return true;
  }
}

