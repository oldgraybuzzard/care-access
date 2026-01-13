# Adding Postgres Row-Level Security (RLS) to Railway

## Why Add RLS?

RLS provides a **second line of defense** for multi-tenancy:
- Even if application code has a bug, the database enforces isolation
- Prevents accidental cross-tenant queries
- Provides "sleep at night" security for sensitive data

## How RLS Works

1. Enable RLS on a table
2. Create policies that check `current_setting('app.organization_id')`
3. Your app sets the organization ID at the start of each request
4. Postgres automatically filters all queries

---

## Implementation for CareAccess

### Step 1: Create RLS Migration

Create a new migration file:

```bash
cd services/api
npx prisma migrate dev --name add_rls_policies --create-only
```

### Step 2: Add RLS Policies

Edit the migration file:

```sql
-- Enable RLS on tenant-scoped tables
ALTER TABLE "Child" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Case" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Client" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "EducationRecord" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Worker" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Program" ENABLE ROW LEVEL SECURITY;

-- Create policy for Child table
CREATE POLICY tenant_isolation_policy ON "Child"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- Create policy for Case table
CREATE POLICY tenant_isolation_policy ON "Case"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- Create policy for Client table
CREATE POLICY tenant_isolation_policy ON "Client"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- Create policy for EducationRecord table
CREATE POLICY tenant_isolation_policy ON "EducationRecord"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- Create policy for Worker table
CREATE POLICY tenant_isolation_policy ON "Worker"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- Create policy for Program table
CREATE POLICY tenant_isolation_policy ON "Program"
  USING (
    organization_id = current_setting('app.organization_id', true)::uuid
    OR current_setting('app.is_superadmin', true) = 'true'
  );

-- SuperAdmin bypass: Allow superadmins to bypass RLS for admin operations
-- (This is handled by the is_superadmin setting above)
```

### Step 3: Update Prisma Client to Set Organization Context

Create a new file: `services/api/src/common/database/prisma-rls.service.ts`

```typescript
import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Injectable()
export class PrismaRlsService {
  constructor(private prisma: PrismaService) {}

  /**
   * Execute a query with RLS context
   */
  async withOrganizationContext<T>(
    organizationId: string | null,
    isSuperAdmin: boolean,
    callback: () => Promise<T>,
  ): Promise<T> {
    // Set session variables for RLS
    if (organizationId) {
      await this.prisma.$executeRawUnsafe(
        `SET LOCAL app.organization_id = '${organizationId}'`,
      );
    }
    
    await this.prisma.$executeRawUnsafe(
      `SET LOCAL app.is_superadmin = '${isSuperAdmin}'`,
    );

    try {
      return await callback();
    } finally {
      // Reset session variables
      await this.prisma.$executeRawUnsafe(`RESET app.organization_id`);
      await this.prisma.$executeRawUnsafe(`RESET app.is_superadmin`);
    }
  }
}
```

### Step 4: Create RLS Interceptor

Create: `services/api/src/common/interceptors/rls.interceptor.ts`

```typescript
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { PrismaService } from '../database/prisma.service';

@Injectable()
export class RlsInterceptor implements NestInterceptor {
  constructor(private prisma: PrismaService) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (user) {
      const organizationId = user.organizationId;
      const isSuperAdmin = user.roles?.includes('superadmin') || false;

      // Set RLS context for this request
      if (organizationId) {
        await this.prisma.$executeRawUnsafe(
          `SET LOCAL app.organization_id = '${organizationId}'`,
        );
      }
      
      await this.prisma.$executeRawUnsafe(
        `SET LOCAL app.is_superadmin = '${isSuperAdmin}'`,
      );
    }

    return next.handle();
  }
}
```

### Step 5: Apply Globally

In `services/api/src/app.module.ts`:

```typescript
import { APP_INTERCEPTOR } from '@nestjs/core';
import { RlsInterceptor } from './common/interceptors/rls.interceptor';

@Module({
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: RlsInterceptor,
    },
  ],
})
export class AppModule {}
```

---

## Testing RLS

### Test 1: Verify RLS is Active

```sql
-- Should return true
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'Child';
```

### Test 2: Test Cross-Tenant Query (Should Fail)

```typescript
// This should return empty even if data exists for other orgs
const children = await prisma.child.findMany({
  where: {
    organizationId: 'different-org-id', // Trying to access another org
  },
});
// Result: [] (RLS blocks it)
```

---

## Benefits

✅ **Defense-in-depth**: Even if guards fail, RLS protects data  
✅ **Zero trust**: Database enforces isolation  
✅ **Audit compliance**: Shows you take security seriously  
✅ **No app changes**: Works with existing Prisma queries  

---

## When to Add This

- **Now**: If you're onboarding your first paying customer
- **Before**: County/state partnerships or SOC 2 audit
- **After**: You have 3+ organizations and want extra protection

---

## Alternative: Supabase Migration Path

If you later want to migrate to Supabase:

1. Keep your NestJS API on Railway
2. Move Postgres to Supabase
3. Use Supabase Auth (optional)
4. Use Supabase RLS policies (easier management)
5. Use Supabase Storage for documents

This is a **gradual migration**, not a rewrite.

---

**Recommendation**: Add RLS to Railway Postgres now for maximum security, then evaluate Supabase later if you need their Auth/Storage features.

