import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { TenantContextService } from '../tenant/tenant-context.service';

// Models that are tenant-scoped (have organizationId)
const TENANT_SCOPED_MODELS = [
  'user',
  'child',
  'family',
  'client',
  'case',
  'caseNote',
  'caseDocument',
  'assessment',
  'educationRecord',
  'medicalRecord',
  'placementHistory',
  'serviceRecord',
  'worker',
  'program',
  'vendorSource',
  'reportDefinition',
  'reportExecution',
];

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(private readonly tenantContext: TenantContextService) {
    super();
  }

  async onModuleInit() {
    await this.$connect();
    this.enableTenantMiddleware();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  /**
   * Enable tenant middleware to automatically filter queries by organizationId
   * and set RLS session variables for database-level enforcement
   */
  private enableTenantMiddleware() {
    this.$use(async (params, next) => {
      const { model, action } = params;

      // Skip middleware for raw queries to prevent infinite loops
      if (action === 'executeRaw' || action === 'queryRaw' || action === 'runCommandRaw') {
        return next(params);
      }

      // Get current organization ID and context
      const organizationId = this.tenantContext.getOrganizationIdOrUndefined();
      const context = this.tenantContext.getContext();

      // NOTE: RLS session variables disabled due to infinite loop issue
      // TODO: Implement RLS in a separate connection or transaction
      // if (organizationId) {
      //   await this.$executeRawUnsafe(
      //     `SET LOCAL app.organization_id = '${organizationId}'`
      //   );
      //   await this.$executeRawUnsafe(
      //     `SET LOCAL app.is_superadmin = 'false'`
      //   );
      // } else {
      //   await this.$executeRawUnsafe(
      //     `SET LOCAL app.is_superadmin = 'true'`
      //   );
      // }

      // Skip application-level filtering if model is not tenant-scoped
      if (!model || !TENANT_SCOPED_MODELS.includes(model.toLowerCase())) {
        return next(params);
      }

      // Skip application-level filtering if no tenant context (e.g., seed scripts, migrations)
      if (!organizationId) {
        return next(params);
      }

      // Handle different query types - application-level filtering
      if (action === 'create' || action === 'createMany') {
        // Auto-inject organizationId into create operations
        if (action === 'create') {
          params.args.data = {
            ...params.args.data,
            organizationId,
          };
        } else if (action === 'createMany') {
          if (Array.isArray(params.args.data)) {
            params.args.data = params.args.data.map((item) => ({
              ...item,
              organizationId,
            }));
          } else {
            params.args.data = {
              ...params.args.data,
              organizationId,
            };
          }
        }
      } else if (
        action === 'findUnique' ||
        action === 'findFirst' ||
        action === 'findMany' ||
        action === 'update' ||
        action === 'updateMany' ||
        action === 'delete' ||
        action === 'deleteMany' ||
        action === 'count' ||
        action === 'aggregate'
      ) {
        // Auto-inject organizationId filter into read/update/delete operations
        params.args.where = {
          ...params.args.where,
          organizationId,
        };
      } else if (action === 'upsert') {
        // Handle upsert specially
        params.args.where = {
          ...params.args.where,
          organizationId,
        };
        params.args.create = {
          ...params.args.create,
          organizationId,
        };
      }

      return next(params);
    });
  }

  async cleanDatabase() {
    if (process.env.NODE_ENV === 'production') {
      throw new Error('Cannot clean database in production');
    }

    const models = Reflect.ownKeys(this).filter(
      (key) => typeof key === 'string' && key[0] !== '_' && key[0] !== '$',
    );

    return Promise.all(
      models.map((modelKey) => {
        const model = this[modelKey as string];
        if (model && typeof model.deleteMany === 'function') {
          return model.deleteMany();
        }
      }),
    );
  }
}

