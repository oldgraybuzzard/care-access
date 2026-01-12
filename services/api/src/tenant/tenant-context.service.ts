import { Injectable } from '@nestjs/common';
import { AsyncLocalStorage } from 'async_hooks';

export interface TenantContext {
  organizationId: string;
  organizationSlug?: string;
}

@Injectable()
export class TenantContextService {
  private readonly asyncLocalStorage = new AsyncLocalStorage<TenantContext>();

  /**
   * Run a function within a tenant context
   */
  run<T>(context: TenantContext, callback: () => T): T {
    return this.asyncLocalStorage.run(context, callback);
  }

  /**
   * Get the current tenant context
   */
  getContext(): TenantContext | undefined {
    return this.asyncLocalStorage.getStore();
  }

  /**
   * Get the current organization ID
   * @throws Error if no tenant context is set
   */
  getOrganizationId(): string {
    const context = this.getContext();
    if (!context) {
      throw new Error('No tenant context found. This should not happen in a protected route.');
    }
    return context.organizationId;
  }

  /**
   * Get the current organization ID or return undefined if not set
   */
  getOrganizationIdOrUndefined(): string | undefined {
    const context = this.getContext();
    return context?.organizationId;
  }

  /**
   * Check if a tenant context is currently set
   */
  hasContext(): boolean {
    return this.getContext() !== undefined;
  }
}

