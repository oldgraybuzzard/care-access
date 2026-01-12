# Multi-Tenancy Strategy for SaaS Conversion

## Executive Summary

This document outlines the strategy to convert the FCF Platform from a single-tenant application to a multi-tenant SaaS solution that can serve multiple child welfare organizations.

## Current State Analysis

### ✅ What We Have
- **Authentication**: JWT-based auth with user/role system
- **Database**: PostgreSQL with Prisma ORM
- **API**: NestJS REST API with proper separation of concerns
- **Data Isolation**: VendorSource model already exists (partial multi-tenancy)
- **Audit Logging**: Comprehensive audit trail system

### ❌ What's Missing for Multi-Tenancy
- **Organization/Tenant Model**: No top-level organization entity
- **Tenant Context**: No tenant isolation in queries
- **User-Tenant Association**: Users not scoped to organizations
- **Tenant-Scoped Data**: Most models lack tenant foreign keys
- **Tenant Middleware**: No automatic tenant context injection
- **Subscription/Billing**: No subscription management
- **Tenant Onboarding**: No self-service signup flow

## Multi-Tenancy Approach

### Recommended: **Row-Level Multi-Tenancy (Shared Database, Shared Schema)**

**Why This Approach:**
- ✅ Cost-effective (single database instance)
- ✅ Easy to maintain and deploy
- ✅ Simple backups and disaster recovery
- ✅ Cross-tenant analytics possible
- ✅ Scales well for 100s of tenants
- ✅ Prisma supports this pattern well

**Trade-offs:**
- ⚠️ Requires careful query filtering
- ⚠️ Risk of data leakage if not implemented correctly
- ⚠️ All tenants share same database resources

### Alternative Approaches (Not Recommended for Now)
1. **Database-per-Tenant**: Too expensive, complex to manage
2. **Schema-per-Tenant**: Complex migrations, harder to maintain

## Implementation Plan

### Phase 1: Core Multi-Tenancy Infrastructure (Week 1-2)

#### 1.1 Add Organization Model
```prisma
model Organization {
  id          String   @id @default(uuid())
  name        String
  slug        String   @unique  // e.g., "fcf", "acme-child-services"
  domain      String?  @unique  // Custom domain support
  
  // Subscription
  plan        String   @default("trial")  // trial, basic, professional, enterprise
  status      String   @default("active") // active, suspended, cancelled
  trialEndsAt DateTime? @map("trial_ends_at")
  
  // Branding
  logoUrl     String?  @map("logo_url")
  primaryColor String? @map("primary_color")
  
  // Settings
  settings    Json?    // Tenant-specific configuration
  
  // Metadata
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")
  
  // Relations
  users       User[]
  clients     Client[]
  children    Child[]
  families    Family[]
  programs    Program[]
  workers     Worker[]
  // ... all other tenant-scoped models
  
  @@map("organizations")
}
```

#### 1.2 Update User Model
```prisma
model User {
  id             String   @id @default(uuid())
  email          String   @unique
  name           String
  passwordHash   String   @map("password_hash")
  isActive       Boolean  @default(true) @map("is_active")
  
  // Multi-tenancy
  organizationId String   @map("organization_id")
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // ... rest of fields
  
  @@index([organizationId])
  @@map("users")
}
```

#### 1.3 Update All Core Models
Add `organizationId` to:
- Client
- Child
- Family
- Case
- Program
- Worker
- Assessment
- Goal
- Document
- Activity
- Service
- All other domain models

### Phase 2: Tenant Context & Middleware (Week 2-3)

#### 2.1 Tenant Context Service
```typescript
// services/api/src/common/tenant-context.service.ts
@Injectable()
export class TenantContextService {
  private tenantId = new AsyncLocalStorage<string>();
  
  setTenantId(tenantId: string) {
    this.tenantId.enterWith(tenantId);
  }
  
  getTenantId(): string {
    const tenantId = this.tenantId.getStore();
    if (!tenantId) {
      throw new Error('Tenant context not set');
    }
    return tenantId;
  }
}
```

#### 2.2 Tenant Middleware
```typescript
// Extract tenant from JWT or subdomain
@Injectable()
export class TenantMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    // Option 1: From JWT (user's organization)
    const tenantId = req.user?.organizationId;

    // Option 2: From subdomain (fcf.yourapp.com)
    // const subdomain = req.hostname.split('.')[0];

    this.tenantContext.setTenantId(tenantId);
    next();
  }
}
```

#### 2.3 Prisma Middleware for Auto-Filtering
```typescript
// Automatically inject organizationId in all queries
prisma.$use(async (params, next) => {
  const tenantId = tenantContext.getTenantId();

  // Add tenant filter to all queries
  if (params.model && TENANT_SCOPED_MODELS.includes(params.model)) {
    if (params.action === 'findMany' || params.action === 'findFirst') {
      params.args.where = {
        ...params.args.where,
        organizationId: tenantId,
      };
    }

    if (params.action === 'create' || params.action === 'createMany') {
      params.args.data = {
        ...params.args.data,
        organizationId: tenantId,
      };
    }
  }

  return next(params);
});
```

### Phase 3: Subscription & Billing (Week 3-4)

#### 3.1 Subscription Model
```prisma
model Subscription {
  id               String    @id @default(uuid())
  organizationId   String    @unique @map("organization_id")
  organization     Organization @relation(fields: [organizationId], references: [id])

  plan             String    // trial, basic, professional, enterprise
  status           String    // active, past_due, cancelled, trialing

  // Stripe integration
  stripeCustomerId      String? @unique @map("stripe_customer_id")
  stripeSubscriptionId  String? @unique @map("stripe_subscription_id")

  // Billing
  currentPeriodStart    DateTime @map("current_period_start")
  currentPeriodEnd      DateTime @map("current_period_end")
  cancelAtPeriodEnd     Boolean  @default(false) @map("cancel_at_period_end")

  // Usage limits
  maxUsers         Int       @default(5)
  maxChildren      Int       @default(100)
  maxStorage       Int       @default(5000) // MB

  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @updatedAt @map("updated_at")

  @@map("subscriptions")
}
```

#### 3.2 Usage Tracking
```prisma
model UsageMetric {
  id             String   @id @default(uuid())
  organizationId String   @map("organization_id")
  organization   Organization @relation(fields: [organizationId], references: [id])

  metricType     String   @map("metric_type") // users, children, storage, api_calls
  value          Int
  recordedAt     DateTime @default(now()) @map("recorded_at")

  @@index([organizationId, metricType, recordedAt])
  @@map("usage_metrics")
}
```

### Phase 4: Tenant Onboarding & Management (Week 4-5)

#### 4.1 Self-Service Signup Flow
1. **Organization Registration**
   - Organization name
   - Subdomain/slug selection
   - Admin user creation
   - Email verification

2. **Trial Period**
   - 14-day free trial
   - Full feature access
   - No credit card required

3. **Onboarding Wizard**
   - Setup programs
   - Invite team members
   - Configure integrations
   - Import initial data

#### 4.2 Tenant Admin Portal
- Organization settings
- User management
- Subscription management
- Usage analytics
- Billing history
- Integration configuration

### Phase 5: Data Migration & Testing (Week 5-6)

#### 5.1 Migrate FCF Data
```sql
-- Create FCF organization
INSERT INTO organizations (id, name, slug, plan, status)
VALUES ('fcf-org-id', 'Friends of Children and Families', 'fcf', 'enterprise', 'active');

-- Update all existing data with FCF org ID
UPDATE users SET organization_id = 'fcf-org-id';
UPDATE clients SET organization_id = 'fcf-org-id';
UPDATE children SET organization_id = 'fcf-org-id';
-- ... etc
```

#### 5.2 Testing Strategy
- Unit tests for tenant isolation
- Integration tests for cross-tenant data leakage
- Load testing with multiple tenants
- Security audit

## Security Considerations

### 1. Data Isolation
- ✅ Prisma middleware enforces tenant filtering
- ✅ All queries automatically scoped to tenant
- ✅ Row-level security policies in PostgreSQL (optional extra layer)

### 2. Authentication
- ✅ JWT includes organizationId claim
- ✅ Users can only belong to one organization
- ✅ Super admin role for platform management

### 3. API Security
- ✅ Rate limiting per tenant
- ✅ Tenant-specific API keys for integrations
- ✅ Audit logging includes tenant context

### 4. Data Encryption
- ✅ Encryption at rest (PostgreSQL)
- ✅ Encryption in transit (TLS)
- ✅ Field-level encryption for sensitive data (SSN, etc.)

## Pricing Strategy

### Tier 1: Trial (Free for 14 days)
- Up to 5 users
- Up to 50 children
- 1 GB storage
- Email support

### Tier 2: Basic ($99/month)
- Up to 10 users
- Up to 200 children
- 10 GB storage
- Email support
- Basic reporting

### Tier 3: Professional ($299/month)
- Up to 25 users
- Up to 1,000 children
- 50 GB storage
- Priority support
- Advanced reporting
- Custom integrations
- API access

### Tier 4: Enterprise (Custom pricing)
- Unlimited users
- Unlimited children
- Unlimited storage
- Dedicated support
- Custom features
- SLA guarantees
- On-premise option

## Technical Debt & Considerations

### Immediate Concerns
1. **VendorSource Model**: Already exists but needs to be reconciled with Organization model
2. **Unique Constraints**: Many models have `@unique` constraints that need to be scoped to tenant
3. **Migrations**: Need careful planning to avoid downtime

### Future Enhancements
1. **Multi-Region Support**: Deploy in multiple regions for compliance
2. **Custom Domains**: Allow tenants to use their own domains
3. **White-Labeling**: Full branding customization
4. **Marketplace**: Plugin/integration marketplace
5. **API Versioning**: Support multiple API versions per tenant

## Migration Checklist

- [ ] Create Organization model and migration
- [ ] Add organizationId to all tenant-scoped models
- [ ] Implement TenantContext service
- [ ] Add tenant middleware
- [ ] Add Prisma middleware for auto-filtering
- [ ] Update all services to use tenant context
- [ ] Create subscription management
- [ ] Build tenant onboarding flow
- [ ] Implement usage tracking
- [ ] Add billing integration (Stripe)
- [ ] Create super admin portal
- [ ] Migrate FCF data to new structure
- [ ] Security audit
- [ ] Load testing
- [ ] Documentation update
- [ ] Deploy to staging
- [ ] User acceptance testing
- [ ] Production deployment

## Timeline Estimate

- **Phase 1**: 2 weeks (Core infrastructure)
- **Phase 2**: 1 week (Middleware & context)
- **Phase 3**: 1 week (Subscription & billing)
- **Phase 4**: 1 week (Onboarding)
- **Phase 5**: 1 week (Migration & testing)

**Total: 6 weeks** for MVP multi-tenant SaaS

## Next Steps

1. **Review & Approve**: Review this strategy with stakeholders
2. **Create Detailed Tasks**: Break down into specific Jira/GitHub issues
3. **Set Up Staging Environment**: Separate environment for testing
4. **Start Phase 1**: Begin with Organization model implementation


