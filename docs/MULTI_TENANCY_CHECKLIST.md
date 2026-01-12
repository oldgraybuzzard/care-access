# Multi-Tenancy Implementation Checklist

## Phase 1: Database Schema (Week 1)

### Organization Model
- [ ] Create `organizations` table
- [ ] Add fields: id, name, slug, domain, plan, status, trial_ends_at
- [ ] Add branding fields: logo_url, primary_color
- [ ] Add settings JSONB field
- [ ] Create indexes on slug and status
- [ ] Create FCF organization record

### Add organizationId to Models
- [ ] users
- [ ] clients
- [ ] children
- [ ] families
- [ ] cases
- [ ] programs
- [ ] workers
- [ ] assessments
- [ ] goals
- [ ] documents
- [ ] activities
- [ ] services
- [ ] behavioral_incidents
- [ ] education_records
- [ ] medical_records
- [ ] home_visits
- [ ] report_definitions
- [ ] report_runs
- [ ] kpi_daily
- [ ] vendor_sources (reconcile with Organization)

### Update Unique Constraints
- [ ] programs.name → (organization_id, name)
- [ ] workers.email → (organization_id, email)
- [ ] roles.name → keep global or make org-scoped?
- [ ] Review all other unique constraints

### Create Indexes
- [ ] Single column: organization_id on all tables
- [ ] Composite: (organization_id, status) on children, cases, clients
- [ ] Composite: (organization_id, created_at) for time-based queries
- [ ] Composite: (organization_id, name) for lookups

### Data Migration
- [ ] Backfill organization_id for all existing records
- [ ] Verify no NULL organization_id values
- [ ] Add NOT NULL constraints
- [ ] Add foreign key constraints

## Phase 2: Backend Code (Week 2-3)

### Core Services
- [ ] Create `TenantContextService` with AsyncLocalStorage
- [ ] Create `TenantMiddleware` to extract org from JWT
- [ ] Update `PrismaService` with tenant filtering middleware
- [ ] Create `OrganizationsModule`
- [ ] Create `OrganizationsService`
- [ ] Create `OrganizationsController`

### Authentication Updates
- [ ] Update `User` model to include `organizationId`
- [ ] Update `JwtStrategy` to include organization in payload
- [ ] Update `AuthService.login()` to include organization
- [ ] Update JWT payload interface
- [ ] Update refresh token logic

### Prisma Middleware
- [ ] Define TENANT_SCOPED_MODELS array
- [ ] Implement findUnique/findFirst filtering
- [ ] Implement findMany filtering
- [ ] Implement create/createMany injection
- [ ] Implement update/updateMany filtering
- [ ] Implement delete/deleteMany filtering
- [ ] Add error handling for cross-tenant access attempts

### App Configuration
- [ ] Register TenantContextService as global provider
- [ ] Apply TenantMiddleware to all routes except auth
- [ ] Exclude public routes from tenant middleware
- [ ] Update app.module.ts

### API Endpoints
- [ ] POST /organizations/signup
- [ ] GET /organizations/me
- [ ] PATCH /organizations/me
- [ ] GET /organizations/me/users
- [ ] POST /organizations/me/users (invite)
- [ ] DELETE /organizations/me/users/:id

## Phase 3: Subscription & Billing (Week 3-4)

### Stripe Integration
- [ ] Install @nestjs/stripe package
- [ ] Configure Stripe API keys
- [ ] Create Stripe customer on org signup
- [ ] Create Stripe subscription

### Database Models
- [ ] Create `subscriptions` table
- [ ] Create `usage_metrics` table
- [ ] Add Stripe customer_id to organizations
- [ ] Add Stripe subscription_id to subscriptions

### Subscription Service
- [ ] Create SubscriptionsModule
- [ ] Create SubscriptionsService
- [ ] Implement createSubscription()
- [ ] Implement updateSubscription()
- [ ] Implement cancelSubscription()
- [ ] Implement handleWebhook()

### Usage Tracking
- [ ] Track user count per org
- [ ] Track children count per org
- [ ] Track storage usage per org
- [ ] Track API calls per org
- [ ] Implement usage limits enforcement

### Webhooks
- [ ] Handle subscription.created
- [ ] Handle subscription.updated
- [ ] Handle subscription.deleted
- [ ] Handle invoice.payment_succeeded
- [ ] Handle invoice.payment_failed
- [ ] Handle customer.subscription.trial_will_end

## Phase 4: Frontend Updates (Week 4)

### Flutter App
- [ ] Update User model to include organization
- [ ] Update login response parsing
- [ ] Store organization in secure storage
- [ ] Display organization name in app bar (optional)
- [ ] Add organization settings screen (optional)

### Admin Portal (Optional)
- [ ] Create Next.js admin portal
- [ ] Organization settings page
- [ ] User management page
- [ ] Subscription management page
- [ ] Usage analytics dashboard
- [ ] Billing history page

## Phase 5: Testing (Week 5)

### Unit Tests
- [ ] TenantContextService tests
- [ ] TenantMiddleware tests
- [ ] Prisma middleware tests
- [ ] OrganizationsService tests
- [ ] SubscriptionsService tests

### Integration Tests
- [ ] Test tenant isolation in ChildrenService
- [ ] Test tenant isolation in CasesService
- [ ] Test tenant isolation in ClientsService
- [ ] Test cross-tenant access prevention
- [ ] Test organization signup flow
- [ ] Test subscription creation

### Security Tests
- [ ] Test JWT tampering (change organizationId)
- [ ] Test SQL injection attempts
- [ ] Test data leakage in error messages
- [ ] Test rate limiting per tenant
- [ ] Test audit log tenant context

### Load Tests
- [ ] 100 concurrent users across 10 orgs
- [ ] 1000 requests/second
- [ ] Database query performance
- [ ] Memory usage under load
- [ ] Connection pool behavior

### Manual Testing
- [ ] Create 2 test organizations
- [ ] Create test data in each
- [ ] Verify data isolation
- [ ] Test signup flow end-to-end
- [ ] Test subscription flow
- [ ] Test user invitation flow

## Phase 6: Deployment (Week 6)

### Pre-Deployment
- [ ] All tests passing
- [ ] Security audit complete
- [ ] Load testing complete
- [ ] Documentation updated
- [ ] Rollback plan documented
- [ ] Monitoring configured
- [ ] Alerts configured

### Staging Deployment
- [ ] Deploy to staging environment
- [ ] Run smoke tests
- [ ] Verify FCF data migrated correctly
- [ ] Test with pilot customers
- [ ] Gather feedback

### Production Deployment
- [ ] Schedule maintenance window
- [ ] Announce downtime to FCF
- [ ] Backup production database
- [ ] Run database migrations
- [ ] Deploy new API version
- [ ] Run smoke tests
- [ ] Verify FCF access
- [ ] Monitor for errors

### Post-Deployment
- [ ] Monitor error logs (24 hours)
- [ ] Monitor performance metrics
- [ ] Verify audit logs
- [ ] Check database query performance
- [ ] Confirm FCF satisfaction

## Phase 7: Launch (Week 6+)

### Marketing
- [ ] Create landing page
- [ ] Create pricing page
- [ ] Create documentation site
- [ ] Set up support email
- [ ] Create demo video
- [ ] Write blog post announcement

### Sales
- [ ] Identify pilot customers
- [ ] Reach out to prospects
- [ ] Offer pilot pricing
- [ ] Schedule demos
- [ ] Gather testimonials

### Operations
- [ ] Set up customer support system
- [ ] Create onboarding documentation
- [ ] Create admin runbooks
- [ ] Set up monitoring dashboards
- [ ] Configure backup strategy

## Success Criteria

- [ ] Zero cross-tenant data leakage
- [ ] API response time < 200ms (p95)
- [ ] 99.9% uptime
- [ ] FCF operating normally
- [ ] 3 pilot customers onboarded
- [ ] Positive customer feedback
- [ ] Revenue from new customers

---

**Total Tasks: ~150**
**Estimated Effort: 6 weeks**
**Team Size: 2-3 developers**

