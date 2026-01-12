# Multi-Tenancy Developer Guide

## Quick Start

The FCF platform now supports multi-tenancy! This guide will help you write tenant-aware code.

## 🎯 Key Concept

**Every authenticated request is automatically scoped to an organization.** You don't need to manually filter by `organizationId` - the Prisma middleware handles it automatically!

## ✅ What You DON'T Need to Do

❌ **Don't manually add organizationId to queries:**
```typescript
// ❌ DON'T DO THIS
const children = await prisma.child.findMany({
  where: {
    organizationId: user.organizationId, // Not needed!
    status: 'Active'
  }
});
```

❌ **Don't manually add organizationId to creates:**
```typescript
// ❌ DON'T DO THIS
const child = await prisma.child.create({
  data: {
    organizationId: user.organizationId, // Not needed!
    firstName: 'John',
    lastName: 'Doe'
  }
});
```

## ✅ What You SHOULD Do

✅ **Just write normal Prisma queries:**
```typescript
// ✅ DO THIS - organizationId is auto-injected
const children = await prisma.child.findMany({
  where: {
    status: 'Active'
  }
});

// ✅ DO THIS - organizationId is auto-injected
const child = await prisma.child.create({
  data: {
    firstName: 'John',
    lastName: 'Doe'
  } as any // Type assertion needed for TypeScript
});
```

## 🔧 TypeScript Type Assertions

Because the Prisma middleware injects `organizationId` at runtime, TypeScript doesn't know about it. You need to add `as any` to the data object:

```typescript
const user = await prisma.user.create({
  data: {
    email: 'user@example.com',
    name: 'John Doe',
    passwordHash: hashedPassword,
    isActive: true
  } as any // <-- Add this
});
```

## 🌐 Accessing Tenant Context

If you need to access the current organization ID directly:

```typescript
import { TenantContextService } from '../tenant/tenant-context.service';

@Injectable()
export class MyService {
  constructor(
    private readonly tenantContext: TenantContextService,
    private readonly prisma: PrismaService
  ) {}

  async myMethod() {
    // Get current organization ID
    const orgId = this.tenantContext.getOrganizationId();
    
    // Check if tenant context exists
    if (this.tenantContext.hasContext()) {
      // Do something
    }
    
    // Get organization ID or undefined (no error)
    const maybeOrgId = this.tenantContext.getOrganizationIdOrUndefined();
  }
}
```

## 🔒 Tenant-Scoped Models

These models are automatically tenant-scoped:

- User
- Child
- Family
- Client
- Case
- CaseNote
- CaseDocument
- Assessment
- EducationRecord
- MedicalRecord
- PlacementHistory
- ServiceRecord
- Worker
- Program
- VendorSource
- ReportDefinition
- ReportExecution

## 🚫 Non-Tenant Models

These models are NOT tenant-scoped (global):

- Organization
- Role
- UserRole
- AuditLog

## 📝 Writing New Services

When creating a new service that works with tenant-scoped data:

```typescript
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MyNewService {
  constructor(private readonly prisma: PrismaService) {}

  // ✅ Queries are automatically scoped
  async findAll() {
    return this.prisma.myModel.findMany();
  }

  // ✅ Creates are automatically scoped
  async create(data: CreateDto) {
    return this.prisma.myModel.create({
      data: {
        ...data
      } as any
    });
  }

  // ✅ Updates are automatically scoped
  async update(id: string, data: UpdateDto) {
    return this.prisma.myModel.update({
      where: { id },
      data
    });
  }

  // ✅ Deletes are automatically scoped
  async remove(id: string) {
    return this.prisma.myModel.delete({
      where: { id }
    });
  }
}
```

## 🧪 Testing

When writing tests, you may need to set up tenant context:

```typescript
import { TenantContextService } from '../tenant/tenant-context.service';

describe('MyService', () => {
  let service: MyService;
  let tenantContext: TenantContextService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [MyService, PrismaService, TenantContextService],
    }).compile();

    service = module.get<MyService>(MyService);
    tenantContext = module.get<TenantContextService>(TenantContextService);
  });

  it('should work within tenant context', async () => {
    await tenantContext.run(
      { organizationId: 'test-org-id' },
      async () => {
        const result = await service.findAll();
        expect(result).toBeDefined();
      }
    );
  });
});
```

## 🔐 Authentication Flow

1. User logs in with email/password
2. JWT token is created with `organizationId`
3. Token is sent with each request
4. JWT Strategy extracts `organizationId`
5. Tenant Middleware sets tenant context
6. Prisma Middleware uses context for all queries

## 🚨 Common Pitfalls

### 1. Forgetting Type Assertion
```typescript
// ❌ Will cause TypeScript error
const user = await prisma.user.create({
  data: { email, name, passwordHash }
});

// ✅ Correct
const user = await prisma.user.create({
  data: { email, name, passwordHash } as any
});
```

### 2. Trying to Access Cross-Tenant Data
```typescript
// ❌ This will NOT work - middleware prevents it
const otherOrgData = await prisma.child.findMany({
  where: { organizationId: 'other-org-id' }
});
// Result: Empty array (filtered by current org)
```

### 3. Using Tenant Context Outside Request
```typescript
// ❌ This will throw error
const orgId = tenantContext.getOrganizationId(); // No context!

// ✅ Use this instead
const orgId = tenantContext.getOrganizationIdOrUndefined();
if (!orgId) {
  // Handle no context case
}
```

## 📚 Additional Resources

- **Phase 1 Complete:** `docs/PHASE_1_TEST_COMPLETE.md`
- **Phase 2 Complete:** `docs/PHASE_2_COMPLETE.md`
- **Code Examples:** `docs/MULTI_TENANCY_CODE_EXAMPLES.md`
- **Migration Plan:** `docs/MULTI_TENANCY_MIGRATION_PLAN.md`

## 💡 Tips

1. **Trust the middleware** - It handles tenant isolation automatically
2. **Use type assertions** - Add `as any` to create operations
3. **Test thoroughly** - Ensure tenant isolation works as expected
4. **Don't overthink it** - Write normal Prisma queries

## ❓ Questions?

If you're unsure whether a model is tenant-scoped, check the `TENANT_SCOPED_MODELS` array in `services/api/src/prisma/prisma.service.ts`.

---

**Happy coding!** 🚀

