import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { TenantContextService } from './tenant-context.service';

@Injectable()
export class TenantMiddleware implements NestMiddleware {
  constructor(private readonly tenantContext: TenantContextService) {}

  use(req: Request, res: Response, next: NextFunction) {
    // Extract tenant info from request.user (set by JWT strategy)
    const user = (req as any).user;

    if (user?.organizationId) {
      // Run the rest of the request within the tenant context
      this.tenantContext.run(
        {
          organizationId: user.organizationId,
          organizationSlug: user.organizationSlug,
        },
        () => next(),
      );
    } else {
      // No tenant context (e.g., public routes)
      next();
    }
  }
}

