# SuperAdmin API Guide

## Overview

This guide documents the API endpoints available to SuperAdmin users and explains the security model that prevents SuperAdmins from accessing organizational data.

## Authentication

SuperAdmins authenticate the same way as organization users:

```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@melkentechwork.com",
  "password": "your-password"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "admin@melkentechwork.com",
    "name": "Platform Administrator",
    "organizationId": null,  // ← KEY: SuperAdmins have no organization
    "roles": ["superadmin"]
  }
}
```

## SuperAdmin-Only Endpoints

### Organization Management

#### Create Organization
```bash
POST /api/admin/organizations
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "New Organization",
  "slug": "new-org",
  "plan": "professional",
  "status": "active"
}
```

#### List All Organizations
```bash
GET /api/admin/organizations
Authorization: Bearer {token}
```

**Response:**
```json
[
  {
    "id": "uuid",
    "name": "Organization Name",
    "slug": "org-slug",
    "plan": "enterprise",
    "status": "active",
    "createdAt": "2026-01-12T00:00:00.000Z",
    "userCount": 25,
    "caseCount": 150
  }
]
```

#### Get Organization Details
```bash
GET /api/admin/organizations/{id}
Authorization: Bearer {token}
```

#### Update Organization
```bash
PATCH /api/admin/organizations/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "plan": "enterprise",
  "status": "active",
  "trialEndsAt": "2026-02-12T00:00:00.000Z"
}
```

#### Get Organization Statistics
```bash
GET /api/admin/organizations/{id}/stats
Authorization: Bearer {token}
```

**Response:**
```json
{
  "users": 25,
  "cases": 150,
  "children": 200,
  "clients": 180,
  "storage": "2.5 GB"
}
```

### SuperAdmin User Management

#### Create SuperAdmin User
```bash
POST /api/admin/superadmins
Authorization: Bearer {token}
Content-Type: application/json

{
  "email": "newadmin@melkentechwork.com",
  "name": "New Platform Admin",
  "password": "SecurePassword123!"
}
```

#### List All SuperAdmins
```bash
GET /api/admin/superadmins
Authorization: Bearer {token}
```

#### Get SuperAdmin Details
```bash
GET /api/admin/superadmins/{id}
Authorization: Bearer {token}
```

#### Update SuperAdmin
```bash
PATCH /api/admin/superadmins/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Name",
  "isActive": true
}
```

#### Delete SuperAdmin
```bash
DELETE /api/admin/superadmins/{id}
Authorization: Bearer {token}
```

**Note:** Cannot delete your own SuperAdmin account.

### Platform Monitoring

#### Get Platform Health
```bash
GET /api/admin/superadmins/platform/health
Authorization: Bearer {token}
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-12T18:30:00.000Z",
  "organizations": {
    "total": 15,
    "active": 14,
    "suspended": 1
  }
}
```

#### Get Platform Statistics
```bash
GET /api/admin/superadmins/platform/stats
Authorization: Bearer {token}
```

**Response:**
```json
{
  "organizations": {
    "total": 15,
    "byPlan": [
      { "plan": "trial", "_count": 3 },
      { "plan": "basic", "_count": 5 },
      { "plan": "professional", "_count": 4 },
      { "plan": "enterprise", "_count": 3 }
    ],
    "byStatus": [
      { "status": "active", "_count": 14 },
      { "status": "suspended", "_count": 1 }
    ]
  },
  "users": {
    "totalOrgUsers": 250,
    "totalSuperAdmins": 3
  }
}
```

## Blocked Endpoints for SuperAdmins

SuperAdmins **CANNOT** access these endpoints (will receive `403 Forbidden`):

```bash
# All organizational data endpoints
GET /api/cases/*
GET /api/children/*
GET /api/clients/*
GET /api/families/*
GET /api/reports/*
GET /api/dashboards/*
GET /api/organizations/me/*
```

**Error Response:**
```json
{
  "statusCode": 403,
  "message": "This endpoint requires organization membership. SuperAdmins cannot access organizational data.",
  "error": "Forbidden"
}
```

## Security Model

### Database-Level Isolation

SuperAdmins have `organizationId = null` in the database:

```sql
SELECT id, email, name, organization_id 
FROM users 
WHERE email = 'admin@melkentechwork.com';

-- Result:
-- id | email | name | organization_id
-- uuid | admin@melkentechwork.com | Platform Administrator | NULL
```

### Middleware Protection

The tenant isolation middleware skips SuperAdmins:

```typescript
// SuperAdmins get NO tenant context
if (!user.organizationId) {
  // Skip tenant filtering
  next();
}
```

This means when SuperAdmins query tenant-scoped data, they get **zero results** automatically.

### Guard Protection

Two guards enforce the separation:

1. **RequireOrganizationGuard** - Blocks SuperAdmins from org endpoints
2. **SuperAdminGuard** - Blocks org users from platform endpoints

## Best Practices

### 1. Minimal SuperAdmin Accounts

Create only the minimum number of SuperAdmin accounts needed:
- 1-2 primary administrators
- 1 emergency backup account

### 2. Strong Passwords

SuperAdmin accounts should use:
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Password manager recommended

### 3. Regular Audits

Review SuperAdmin activity regularly:
```bash
GET /api/audit/logs?userId={superadmin-id}
```

### 4. Customer Communication

When accessing organization metadata for support:
- Get explicit customer authorization
- Document the reason in a support ticket
- Limit access to metadata only (no case/client data)

### 5. Separation of Duties

SuperAdmins should:
- ✅ Manage platform operations
- ✅ Handle billing and subscriptions
- ✅ Monitor system health
- ❌ Never access customer data
- ❌ Never perform customer support tasks requiring data access

## Testing SuperAdmin Isolation

### Test 1: Verify No Organization Access

```bash
# Login as SuperAdmin
POST /api/auth/login
{
  "email": "admin@melkentechwork.com",
  "password": "password"
}

# Try to access cases (should fail)
GET /api/cases
Authorization: Bearer {superadmin-token}

# Expected: 403 Forbidden
```

### Test 2: Verify Platform Access

```bash
# Get all organizations (should succeed)
GET /api/admin/organizations
Authorization: Bearer {superadmin-token}

# Expected: 200 OK with organization list
```

### Test 3: Verify Database Isolation

```bash
# Login as SuperAdmin and try to query cases
# Even if guards are bypassed, Prisma middleware returns empty results

# The organizationId = null means:
# - All tenant-scoped queries return []
# - Cannot create tenant-scoped records
# - Cannot update tenant-scoped records
```

## Migration from Existing Admin Users

If you have existing `admin` users tied to organizations:

1. **Create SuperAdmin role:**
   ```bash
   npm run prisma:seed:superadmin
   ```

2. **Create SuperAdmin users:**
   ```bash
   POST /api/admin/superadmins
   {
     "email": "platform-admin@melkentechwork.com",
     "name": "Platform Administrator",
     "password": "SecurePassword123!"
   }
   ```

3. **Test SuperAdmin access:**
   - Verify platform endpoints work
   - Verify org endpoints are blocked

4. **Update organization admins:**
   - Keep existing `admin` role for org-level admins
   - Or rename to `org_admin` for clarity

## Support

For questions about SuperAdmin functionality:
- Email: support@melkentechwork.com
- Docs: https://docs.careaccess.com/superadmin

