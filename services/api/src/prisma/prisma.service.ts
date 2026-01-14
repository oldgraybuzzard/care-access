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
  'document',
];

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(private readonly tenantContext: TenantContextService) {
    super();
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  /**
   * NOTE: Prisma v6 removed the $use middleware API.
   * Tenant isolation is now handled at the service layer using getTenantWhere() and getTenantData().
   * Each service method should call these helpers to ensure proper tenant scoping.
   *
   * Alternative: Use Prisma v6 extensions, but they require more complex setup.
   * See: https://www.prisma.io/docs/orm/prisma-client/client-extensions
   */

  /**
   * Helper method to get tenant-scoped where clause
   */
  getTenantWhere(additionalWhere: any = {}) {
    const organizationId = this.tenantContext.getOrganizationIdOrUndefined();

    if (!organizationId) {
      return additionalWhere;
    }

    return {
      ...additionalWhere,
      organizationId,
    };
  }

  /**
   * Helper method to get tenant-scoped data for create operations
   */
  getTenantData(data: any) {
    const organizationId = this.tenantContext.getOrganizationIdOrUndefined();

    if (!organizationId) {
      return data;
    }

    return {
      ...data,
      organizationId,
    };
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

