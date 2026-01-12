import { Test, TestingModule } from '@nestjs/testing';
import { TenantContextService } from './tenant-context.service';

describe('TenantContextService', () => {
  let service: TenantContextService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TenantContextService],
    }).compile();

    service = module.get<TenantContextService>(TenantContextService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('setOrganizationId', () => {
    it('should set organization ID in context', async () => {
      const testOrgId = 'test-org-123';

      await service.run({ organizationId: testOrgId }, async () => {
        const orgId = service.getOrganizationId();
        expect(orgId).toBe(testOrgId);
      });
    });

    it('should throw error when no context is set', () => {
      expect(() => service.getOrganizationId()).toThrow('No tenant context found');
    });

    it('should return undefined when using getOrganizationIdOrUndefined', () => {
      const orgId = service.getOrganizationIdOrUndefined();
      expect(orgId).toBeUndefined();
    });

    it('should isolate context between different runs', async () => {
      const org1 = 'org-1';
      const org2 = 'org-2';

      const promise1 = service.run({ organizationId: org1 }, async () => {
        await new Promise(resolve => setTimeout(resolve, 10));
        return service.getOrganizationId();
      });

      const promise2 = service.run({ organizationId: org2 }, async () => {
        await new Promise(resolve => setTimeout(resolve, 5));
        return service.getOrganizationId();
      });

      const [result1, result2] = await Promise.all([promise1, promise2]);

      expect(result1).toBe(org1);
      expect(result2).toBe(org2);
    });

    it('should handle nested contexts', async () => {
      const outerOrg = 'outer-org';
      const innerOrg = 'inner-org';

      await service.run({ organizationId: outerOrg }, async () => {
        expect(service.getOrganizationId()).toBe(outerOrg);

        await service.run({ organizationId: innerOrg }, async () => {
          expect(service.getOrganizationId()).toBe(innerOrg);
        });

        // Should restore outer context
        expect(service.getOrganizationId()).toBe(outerOrg);
      });
    });

    it('should clear context after run completes', async () => {
      await service.run({ organizationId: 'test-org' }, async () => {
        expect(service.getOrganizationId()).toBe('test-org');
      });

      // Context should be cleared
      expect(() => service.getOrganizationId()).toThrow();
    });

    it('should handle errors and still clear context', async () => {
      try {
        await service.run({ organizationId: 'test-org' }, async () => {
          throw new Error('Test error');
        });
      } catch (error) {
        expect(error.message).toBe('Test error');
      }

      // Context should be cleared even after error
      expect(() => service.getOrganizationId()).toThrow();
    });
  });

  describe('getOrganizationId', () => {
    it('should throw error when called outside of run', () => {
      expect(() => service.getOrganizationId()).toThrow('No tenant context found');
    });

    it('should return correct organization ID when called inside run', async () => {
      const testOrgId = 'test-org-456';

      await service.run({ organizationId: testOrgId }, async () => {
        expect(service.getOrganizationId()).toBe(testOrgId);
      });
    });
  });

  describe('concurrent requests', () => {
    it('should handle multiple concurrent requests with different org IDs', async () => {
      const requests = Array.from({ length: 10 }, (_, i) => {
        const orgId = `org-${i}`;
        return service.run({ organizationId: orgId }, async () => {
          await new Promise(resolve => setTimeout(resolve, Math.random() * 20));
          return service.getOrganizationId();
        });
      });

      const results = await Promise.all(requests);

      results.forEach((result, index) => {
        expect(result).toBe(`org-${index}`);
      });
    });

    it('should not leak context between concurrent requests', async () => {
      const org1Promise = service.run({ organizationId: 'org-1' }, async () => {
        await new Promise(resolve => setTimeout(resolve, 20));
        return service.getOrganizationId();
      });

      const org2Promise = service.run({ organizationId: 'org-2' }, async () => {
        await new Promise(resolve => setTimeout(resolve, 10));
        return service.getOrganizationId();
      });

      const org3Promise = service.run({ organizationId: 'org-3' }, async () => {
        await new Promise(resolve => setTimeout(resolve, 15));
        return service.getOrganizationId();
      });

      const [result1, result2, result3] = await Promise.all([
        org1Promise,
        org2Promise,
        org3Promise,
      ]);

      expect(result1).toBe('org-1');
      expect(result2).toBe('org-2');
      expect(result3).toBe('org-3');
    });
  });
});

