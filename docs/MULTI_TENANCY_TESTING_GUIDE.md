# Multi-Tenancy Testing Guide

## Overview
This guide provides comprehensive instructions for testing the multi-tenancy implementation in the FCF platform.

## Prerequisites

1. **Database Setup**
   ```bash
   cd services/api
   npm run prisma:migrate:dev
   ```

2. **Seed Test Data**
   ```bash
   npm run prisma:seed:multi
   ```

   This creates:
   - 3 Organizations (FCF, Hope, Caring Hearts)
   - 3 Admin users (one per org)
   - 3 Children (one per org)

## Test Accounts

| Organization | Email | Password | Child |
|--------------|-------|----------|-------|
| Foster Care Foundation | admin@fcf.org | password123 | Emma Johnson |
| Hope Family Services | admin@hope.org | password123 | Michael Smith |
| Caring Hearts | admin@caring.org | password123 | Sophia Williams |

## Unit Tests

### TenantContextService Tests

**Run Tests**:
```bash
cd services/api
npm test -- tenant-context.service.spec.ts
```

**What's Tested**:
- ✅ Context setting and retrieval
- ✅ Context isolation between concurrent requests
- ✅ Nested context handling
- ✅ Context cleanup after completion
- ✅ Error handling with context cleanup
- ✅ No context leakage between requests

**Expected Output**:
```
Test Suites: 1 passed, 1 total
Tests:       12 passed, 12 total
```

## Integration Tests

### Tenant Isolation E2E Tests

**Run Tests**:
```bash
cd services/api
npm run test:e2e
```

**What's Tested**:
- ✅ List children - only returns org's children
- ✅ Get child - cannot access other org's children
- ✅ Create child - automatically assigned to correct org
- ✅ Update child - cannot update other org's children
- ✅ Delete child - cannot delete other org's children

## Manual API Testing

### 1. Start the API Server

```bash
cd services/api
npm run start:dev
```

### 2. Test Organization 1 (FCF)

**Login**:
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@fcf.org",
    "password": "password123"
  }'
```

**Save the token**:
```bash
export ORG1_TOKEN="<access_token_from_response>"
```

**List Children** (should only show Emma Johnson):
```bash
curl http://localhost:3000/children \
  -H "Authorization: Bearer $ORG1_TOKEN" \
  -H "Content-Type: application/json"
```

**Get Specific Child**:
```bash
# Get Emma's ID from the list above
export EMMA_ID="<emma_child_id>"

curl http://localhost:3000/children/$EMMA_ID \
  -H "Authorization: Bearer $ORG1_TOKEN" \
  -H "Content-Type: application/json"
```

### 3. Test Organization 2 (Hope)

**Login**:
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@hope.org",
    "password": "password123"
  }'
```

**Save the token**:
```bash
export ORG2_TOKEN="<access_token_from_response>"
```

**List Children** (should only show Michael Smith):
```bash
curl http://localhost:3000/children \
  -H "Authorization: Bearer $ORG2_TOKEN" \
  -H "Content-Type: application/json"
```

### 4. Test Cross-Tenant Access Prevention

**Try to access Emma (Org1) using Org2 token** (should fail):
```bash
curl http://localhost:3000/children/$EMMA_ID \
  -H "Authorization: Bearer $ORG2_TOKEN" \
  -H "Content-Type: application/json"
```

**Expected**: 404 Not Found (child not visible to Org2)

**Try to update Emma using Org2 token** (should fail):
```bash
curl -X PATCH http://localhost:3000/children/$EMMA_ID \
  -H "Authorization: Bearer $ORG2_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Hacked"
  }'
```

**Expected**: 404 Not Found

### 5. Test Child Creation

**Create child as Org1**:
```bash
curl -X POST http://localhost:3000/children \
  -H "Authorization: Bearer $ORG1_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "Child",
    "dateOfBirth": "2015-01-01",
    "gender": "Male",
    "status": "Active"
  }'
```

**Verify**: Response should include `"organizationId": "fcf-default-org-id"`

**Verify Org2 cannot see it**:
```bash
curl http://localhost:3000/children \
  -H "Authorization: Bearer $ORG2_TOKEN" \
  -H "Content-Type: application/json"
```

**Expected**: List should NOT include the newly created child

## Frontend Testing

### 1. Start the Flutter App

```bash
cd apps/flutter_app
flutter run
```

### 2. Test Login Flow

1. **Login as Org1**: Use `admin@fcf.org` / `password123`
2. **Verify**: User object includes `organizationId`
3. **Check Children List**: Should only show Emma Johnson

### 3. Test Organization Isolation

1. **Logout**
2. **Login as Org2**: Use `admin@hope.org` / `password123`
3. **Check Children List**: Should only show Michael Smith
4. **Verify**: No data from Org1 is visible

## Database Verification

### Check Data Isolation

```sql
-- Connect to database
psql -d fcf_dev

-- View all organizations
SELECT id, name, slug FROM organizations;

-- View children by organization
SELECT 
  c.id,
  c.first_name,
  c.last_name,
  o.name as organization
FROM children c
JOIN organizations o ON c.organization_id = o.id
ORDER BY o.name, c.first_name;

-- Verify no children without organizationId
SELECT COUNT(*) FROM children WHERE organization_id IS NULL;
-- Expected: 0
```

## Performance Testing

### Test Concurrent Requests

```bash
# Install Apache Bench (if not installed)
# macOS: brew install httpd

# Test with 100 concurrent requests
ab -n 100 -c 10 \
  -H "Authorization: Bearer $ORG1_TOKEN" \
  http://localhost:3000/children
```

**Verify**: All responses return only Org1 data

## Troubleshooting

### Issue: Tests Fail with "No tenant context found"

**Solution**: Ensure TenantMiddleware is properly configured in `app.module.ts`

### Issue: Cross-tenant data visible

**Solution**: 
1. Check Prisma middleware is enabled
2. Verify JWT includes organizationId
3. Check TenantMiddleware extracts organizationId

### Issue: Seed script fails

**Solution**:
1. Reset database: `npm run prisma:migrate:reset`
2. Run seed again: `npm run prisma:seed:multi`

## Success Criteria

✅ **Unit Tests**: All 12 tests passing  
✅ **Integration Tests**: All E2E tests passing  
✅ **Manual Testing**: Cannot access other org's data  
✅ **Database**: No orphaned records without organizationId  
✅ **Performance**: No degradation with tenant filtering  

## Next Steps

After successful testing:
1. Deploy to staging environment
2. Run full regression test suite
3. Perform security audit
4. Load test with production-like data
5. Deploy to production

## Support

For issues or questions:
- Check logs: `services/api/logs/`
- Review Prisma queries: Enable query logging in `prisma.service.ts`
- Contact: dev-team@fcf.org

