import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { TenantContextService } from './tenant-context.service';

@Injectable()
export class TenantMiddleware implements NestMiddleware {
  private readonly logger = new Logger(TenantMiddleware.name);

  constructor(private readonly tenantContext: TenantContextService) {}

  use(req: Request, res: Response, next: NextFunction) {
    // Extract tenant info from request.user (set by JWT strategy)
    const user = (req as any).user;

    if (user?.organizationId) {
      // Organization user - set tenant context for data isolation
      this.tenantContext.run(
        {
          organizationId: user.organizationId,
          organizationSlug: user.organizationSlug,
        },
        () => next(),
      );
    } else {
      // No tenant context for:
      // 1. Public routes (no authentication)
      // 2. SuperAdmin users (organizationId = null)
      //
      // SuperAdmins are intentionally excluded from tenant context
      // to prevent access to organizational data
      if (user && !user.organizationId) {
        this.logger.debug(
          `SuperAdmin request detected: ${user.email} - No tenant context set`,
        );
      }
      next();
    }
  }
}

