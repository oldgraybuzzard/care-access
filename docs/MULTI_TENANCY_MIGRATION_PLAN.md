# Multi-Tenancy Migration Plan

## Overview

This document provides a step-by-step migration plan to convert the FCF Platform from a single-tenant application to a multi-tenant SaaS solution while maintaining zero downtime for the existing FCF deployment.

## Migration Strategy: Blue-Green Deployment

We'll use a **blue-green deployment** strategy:
- **Blue**: Current single-tenant FCF production (stays running)
- **Green**: New multi-tenant version (deployed in parallel)
- **Cutover**: Migrate FCF data to new system, then switch traffic

## Phase 1: Preparation (Week 1)

### 1.1 Create Feature Branch
```bash
git checkout develop
git pull origin develop
git checkout -b feature/multi-tenancy
```

### 1.2 Database Schema Changes

**Step 1: Create Organization Model**
```bash
cd services/api
npx prisma migrate dev --name add_organization_model
```

**Step 2: Add organizationId to All Models**
```bash
npx prisma migrate dev --name add_organization_id_to_all_models
```

**Migration Files to Create:**

```sql
-- migrations/001_add_organization_model.sql
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  domain VARCHAR(255) UNIQUE,
  plan VARCHAR(50) DEFAULT 'trial',
  status VARCHAR(50) DEFAULT 'active',
  trial_ends_at TIMESTAMP,
  logo_url TEXT,
  primary_color VARCHAR(7),
  settings JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_organizations_slug ON organizations(slug);
CREATE INDEX idx_organizations_status ON organizations(status);
```

```sql
-- migrations/002_add_organization_id_to_users.sql
ALTER TABLE users ADD COLUMN organization_id UUID;

-- Create FCF organization for existing data
INSERT INTO organizations (id, name, slug, plan, status)
VALUES ('00000000-0000-0000-0000-000000000001', 'Friends of Children and Families', 'fcf', 'enterprise', 'active');

-- Assign all existing users to FCF
UPDATE users SET organization_id = '00000000-0000-0000-0000-000000000001';

-- Make it required after backfill
ALTER TABLE users ALTER COLUMN organization_id SET NOT NULL;
ALTER TABLE users ADD CONSTRAINT fk_users_organization FOREIGN KEY (organization_id) REFERENCES organizations(id);
CREATE INDEX idx_users_organization_id ON users(organization_id);
```

```sql
-- migrations/003_add_organization_id_to_children.sql
ALTER TABLE children ADD COLUMN organization_id UUID;

-- Assign all existing children to FCF
UPDATE children SET organization_id = '00000000-0000-0000-0000-000000000001';

-- Make it required
ALTER TABLE children ALTER COLUMN organization_id SET NOT NULL;
ALTER TABLE children ADD CONSTRAINT fk_children_organization FOREIGN KEY (organization_id) REFERENCES organizations(id);
CREATE INDEX idx_children_organization_id ON children(organization_id);
CREATE INDEX idx_children_org_status ON children(organization_id, status);
```

**Repeat for all models:**
- clients
- families
- cases
- programs
- workers
- assessments
- goals
- documents
- activities
- services
- etc.

### 1.3 Update Unique Constraints

Many models have unique constraints that need to be scoped to organization:

```sql
-- Example: Program names should be unique per organization, not globally
ALTER TABLE programs DROP CONSTRAINT programs_name_key;
CREATE UNIQUE INDEX idx_programs_org_name ON programs(organization_id, name);

-- Example: Worker emails should be unique per organization
ALTER TABLE workers DROP CONSTRAINT workers_email_key;
CREATE UNIQUE INDEX idx_workers_org_email ON workers(organization_id, email);
```

## Phase 2: Code Implementation (Week 2-3)

### 2.1 Implement Core Services

**Checklist:**
- [ ] Create `TenantContextService`
- [ ] Create `TenantMiddleware`
- [ ] Update `PrismaService` with middleware
- [ ] Update `JwtStrategy` to include organizationId
- [ ] Update `AuthService` to include organization in JWT
- [ ] Create `OrganizationsModule`, `OrganizationsService`, `OrganizationsController`
- [ ] Update all existing services (no code changes needed if Prisma middleware works correctly)

### 2.2 Testing Strategy

**Unit Tests:**
```bash
# Test tenant isolation
npm run test -- children.service.spec.ts
npm run test -- cases.service.spec.ts
```

**Integration Tests:**
```bash
# Test cross-tenant data leakage
npm run test:e2e -- tenant-isolation.e2e-spec.ts
```

**Manual Testing:**
1. Create two test organizations
2. Create test data in each
3. Verify users can only see their own org's data
4. Verify no cross-contamination



## Phase 7: Post-Deployment (Week 6+)

### 7.1 Enable New Organization Signups

Once FCF is stable on the new multi-tenant system:

**Step 1: Create Signup Endpoint**
```typescript
// POST /api/organizations/signup
{
  "organizationName": "Acme Child Services",
  "slug": "acme",
  "adminEmail": "admin@acme.org",
  "adminName": "John Doe",
  "adminPassword": "SecurePassword123!"
}
```

**Step 2: Create Landing Page**
- Marketing site explaining the platform
- Signup form
- Pricing page
- Documentation

**Step 3: Onboarding Flow**
1. Organization signup
2. Email verification
3. Onboarding wizard
4. Trial period (14 days)
5. Subscription activation

### 7.2 Monitoring & Metrics

**Key Metrics to Track:**
- Number of organizations
- Active users per organization
- API requests per organization
- Storage usage per organization
- Revenue per organization
- Churn rate
- Trial conversion rate

**Alerts to Configure:**
- High error rate for any organization
- Slow query performance
- Database connection pool exhaustion
- High memory usage
- Failed payment webhooks

### 7.3 Ongoing Maintenance

**Weekly:**
- Review error logs
- Check for slow queries
- Monitor usage metrics
- Review support tickets

**Monthly:**
- Security updates
- Performance optimization
- Feature releases
- Customer feedback review

## Risk Mitigation

### Risk 1: Data Leakage Between Tenants
**Mitigation:**
- Prisma middleware enforces filtering
- Comprehensive test suite
- Security audit before launch
- Regular penetration testing

### Risk 2: Performance Degradation
**Mitigation:**
- Composite indexes on (organizationId, otherField)
- Query optimization
- Load testing before deployment
- Database connection pooling
- Caching strategy (Redis)

### Risk 3: Migration Downtime
**Mitigation:**
- Blue-green deployment
- Database migration tested in staging
- Rollback plan ready
- Maintenance window during low-traffic period

### Risk 4: Unique Constraint Violations
**Mitigation:**
- Identify all unique constraints
- Update to be org-scoped
- Test with duplicate data across orgs

### Risk 5: VendorSource Conflicts
**Mitigation:**
- VendorSource already exists - need to reconcile with Organization
- Option 1: VendorSource becomes a child of Organization
- Option 2: Merge VendorSource into Organization
- Recommend: Keep VendorSource for external integrations, Organization for tenant isolation

## Success Criteria

### Technical Success
- ✅ Zero data leakage between tenants
- ✅ API response times < 200ms (p95)
- ✅ Database queries optimized with proper indexes
- ✅ All tests passing
- ✅ Security audit passed

### Business Success
- ✅ FCF continues to operate without issues
- ✅ First 3 pilot customers onboarded
- ✅ Positive customer feedback
- ✅ Revenue from new customers
- ✅ Scalable infrastructure for 100+ organizations

## Cost Analysis

### Current (Single Tenant)
- Database: $50/month (small instance)
- API Server: $100/month (2 instances)
- Worker: $50/month (1 instance)
- **Total: $200/month**

### Multi-Tenant (10 Organizations)
- Database: $200/month (larger instance)
- API Server: $200/month (4 instances for redundancy)
- Worker: $100/month (2 instances)
- Redis: $50/month (caching)
- **Total: $550/month**
- **Cost per tenant: $55/month**
- **Revenue per tenant: $99-299/month**
- **Profit margin: 45-81%**

### Multi-Tenant (100 Organizations)
- Database: $500/month (production-grade)
- API Server: $800/month (auto-scaling)
- Worker: $400/month (auto-scaling)
- Redis: $200/month (cluster)
- CDN: $100/month
- Monitoring: $100/month
- **Total: $2,100/month**
- **Cost per tenant: $21/month**
- **Revenue per tenant: $99-299/month**
- **Profit margin: 79-93%**

## Next Steps

1. **Review & Approve**: Get stakeholder buy-in on this plan
2. **Create Jira Epic**: Break down into specific tasks
3. **Assign Resources**: Allocate developer time
4. **Set Timeline**: Commit to 6-week timeline
5. **Start Phase 1**: Begin with database schema design

## Questions to Answer

1. **VendorSource vs Organization**: How do we reconcile these two concepts?
2. **Subdomain Strategy**: Do we want `fcf.platform.com` or custom domains?
3. **Pricing**: Confirm pricing tiers and features
4. **Branding**: How much white-labeling do we want to support?
5. **Compliance**: Any specific compliance requirements (HIPAA, SOC2)?
6. **Support Model**: How will we support multiple customers?
7. **SLA**: What uptime guarantees do we want to offer?

## Resources

- [Prisma Multi-Tenancy Guide](https://www.prisma.io/docs/guides/database/multi-tenancy)
- [NestJS Multi-Tenancy](https://docs.nestjs.com/techniques/database#multi-tenancy)
- [Stripe Subscriptions](https://stripe.com/docs/billing/subscriptions/overview)
- [PostgreSQL Row-Level Security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

## Conclusion

This migration plan provides a comprehensive roadmap to convert the FCF Platform into a multi-tenant SaaS solution. The approach is:

- **Low Risk**: Blue-green deployment with rollback plan
- **Scalable**: Designed to support 100+ organizations
- **Secure**: Multiple layers of tenant isolation
- **Profitable**: Strong profit margins at scale
- **Maintainable**: Automatic filtering reduces developer burden

**Estimated Timeline: 6 weeks**
**Estimated Cost: $50,000 (developer time)**
**Expected ROI: 3-6 months** (based on 10 new customers at $99/month)
