# Multi-Tenancy Migration

**Migration ID:** `20260112000000_add_multi_tenancy`  
**Created:** 2026-01-12  
**Status:** Ready for review

## Overview

This migration transforms the FCF Platform from a single-tenant application to a multi-tenant SaaS solution by:

1. Creating the `Organization` model
2. Adding `organizationId` to all tenant-scoped tables
3. Migrating existing FCF data to a default organization
4. Updating unique constraints to be organization-scoped
5. Creating proper indexes for multi-tenant queries

## What This Migration Does

### 1. Creates Organization Table
- Adds `organizations` table with subscription, branding, and settings
- Creates default "Foster Care Foundation" organization with slug `fcf`

### 2. Adds Multi-Tenancy to All Models
Adds `organization_id` column to:
- `users` - Users belong to one organization
- `vendor_sources` - Vendor integrations per org
- `programs` - Programs scoped to org
- `workers` - Workers can work for multiple orgs
- `clients` - Client data isolated by org
- `cases` - Cases scoped to org
- `children` - Child profiles scoped to org
- `families` - Family data scoped to org
- `assessments` - Assessments scoped to org
- `education_records` - Education records scoped to org
- `medical_records` - Medical records scoped to org
- `behavioral_incidents` - Incidents scoped to org
- `goals` - Goals scoped to org
- `child_notes` - Notes scoped to org
- `home_visits` - Home visits scoped to org
- `report_definitions` - Reports scoped to org
- `kpi_daily` - KPIs scoped to org

### 3. Data Migration
- All existing data is assigned to the default FCF organization
- No data loss occurs
- FCF continues to work exactly as before

### 4. Index Updates
- Creates indexes on `organization_id` for all tables
- Creates composite indexes for common queries (e.g., `organization_id + status`)
- Updates unique constraints to be org-scoped

### 5. Unique Constraint Changes
**Before (Global):**
- `vendor_sources.name` - unique globally
- `programs.name` - unique globally
- `workers.email` - unique globally
- `kpi_daily(date, program_id, worker_id)` - unique globally

**After (Org-Scoped):**
- `vendor_sources(organization_id, name)` - unique per org
- `programs(organization_id, name)` - unique per org
- `workers(organization_id, email)` - unique per org
- `kpi_daily(organization_id, date, program_id, worker_id)` - unique per org

## Running the Migration

### Option 1: Using Prisma Migrate (Recommended)

```bash
cd services/api
npx prisma migrate deploy
```

This will:
1. Apply the migration to your database
2. Update the `_prisma_migrations` table
3. Regenerate the Prisma Client

### Option 2: Manual SQL Execution

```bash
# Connect to your database
psql $DATABASE_URL

# Run the migration
\i services/api/prisma/migrations/20260112000000_add_multi_tenancy/migration.sql
```

### Option 3: Using the Migration Script

```bash
cd services/api
npm run migrate:up
```

## Rollback

If you need to rollback this migration:

```bash
# Using the rollback script
psql $DATABASE_URL < services/api/prisma/migrations/20260112000000_add_multi_tenancy/rollback.sql

# Then reset Prisma
cd services/api
npx prisma migrate resolve --rolled-back 20260112000000_add_multi_tenancy
```

**⚠️ WARNING:** Rollback will:
- Remove all organization data
- Remove `organization_id` from all tables
- Revert to single-tenant mode
- **NOT delete any existing data** (just removes org associations)

## Verification

After running the migration, verify it worked:

```sql
-- Check organizations table
SELECT * FROM organizations;

-- Check that all tables have organization_id
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE column_name = 'organization_id'
ORDER BY table_name;

-- Verify FCF data is assigned to default org
SELECT 
    (SELECT COUNT(*) FROM users WHERE organization_id = 'fcf-default-org-id') as users,
    (SELECT COUNT(*) FROM clients WHERE organization_id = 'fcf-default-org-id') as clients,
    (SELECT COUNT(*) FROM cases WHERE organization_id = 'fcf-default-org-id') as cases,
    (SELECT COUNT(*) FROM children WHERE organization_id = 'fcf-default-org-id') as children;
```

## Impact Assessment

### Database Changes
- **New Tables:** 1 (`organizations`)
- **Modified Tables:** 17 (all tenant-scoped tables)
- **New Columns:** 17 (`organization_id` in each table)
- **New Indexes:** 20+ (org indexes + composite indexes)
- **Modified Constraints:** 4 (unique constraints now org-scoped)

### Performance Impact
- **Minimal** - Indexes ensure queries remain fast
- Composite indexes on `(organization_id, status)` optimize common queries
- Foreign key constraints add negligible overhead

### Downtime
- **Zero downtime** - Migration is additive
- Existing queries continue to work
- No application changes required immediately

## Next Steps

After this migration:

1. **Update Prisma Client:**
   ```bash
   cd services/api
   npx prisma generate
   ```

2. **Implement Tenant Context Service** (see `docs/MULTI_TENANCY_CODE_EXAMPLES.md`)

3. **Add Prisma Middleware** for automatic tenant filtering

4. **Update JWT Strategy** to include `organizationId`

5. **Test thoroughly** with the default FCF organization

6. **Create new organizations** for testing

## Testing

```bash
# Run tests to ensure nothing broke
cd services/api
npm test

# Test specific models
npm test -- users.service
npm test -- clients.service
```

## Support

For questions or issues:
- Review: `docs/MULTI_TENANCY_STRATEGY.md`
- Code examples: `docs/MULTI_TENANCY_CODE_EXAMPLES.md`
- Migration plan: `docs/MULTI_TENANCY_MIGRATION_PLAN.md`

