# SuperAdmin Security Model

## Overview

The **SuperAdmin** role in CareAccess is designed for platform administrators (Melken TechWork staff) who manage the CareAccess business operations. SuperAdmins are **completely isolated** from all organizational data for security and compliance reasons.

## Core Principle: Zero Access to Organizational Data

SuperAdmins manage the **platform**, not the **data**. This separation ensures:

- ✅ **Data Privacy**: SuperAdmins cannot view sensitive case, client, or child information
- ✅ **Compliance**: Clear separation between platform operations and customer data
- ✅ **Trust**: Organizations can trust that their data is only accessible to their own users
- ✅ **Audit Trail**: All SuperAdmin actions are logged separately from organizational actions

---

## SuperAdmin vs Organization Admin

| Capability | SuperAdmin (Platform) | Organization Admin |
|------------|----------------------|-------------------|
| **Create Organizations** | ✅ Yes | ❌ No |
| **Manage Subscriptions** | ✅ Yes | ❌ No |
| **View Organization List** | ✅ Yes (metadata only) | ❌ No |
| **Access Cases/Clients/Children** | ❌ **NO** | ✅ Yes (own org) |
| **View Reports** | ❌ **NO** | ✅ Yes (own org) |
| **Manage Users** | ❌ No (except SuperAdmins) | ✅ Yes (own org) |
| **System Monitoring** | ✅ Yes | ❌ No |
| **Belongs to Organization** | ❌ **NO** | ✅ Yes |

---

## Technical Implementation

### 1. Database Schema

SuperAdmin users have **`organizationId = null`**:

```prisma
model User {
  id             String   @id @default(uuid())
  email          String   @unique
  name           String
  passwordHash   String
  isActive       Boolean  @default(true)
  
  // NULL for SuperAdmins, required for org users
  organizationId String?  @map("organization_id")
  organization   Organization? @relation(fields: [organizationId], references: [id])
  
  roles          UserRole[]
}
```

### 2. Role Definition

```typescript
// SuperAdmin role
{
  name: 'superadmin',
  description: 'Platform administrator with NO access to organizational data'
}

// Organization Admin role
{
  name: 'admin',
  description: 'Organization administrator with full access to their org data'
}
```

### 3. Tenant Isolation Middleware

The tenant middleware **skips** SuperAdmin users:

```typescript
use(req: Request, res: Response, next: NextFunction) {
  const user = (req as any).user;
  
  // SuperAdmins have no organizationId - skip tenant context
  if (!user?.organizationId) {
    return next();
  }
  
  // Set tenant context for org users
  this.tenantContext.run({
    organizationId: user.organizationId,
    organizationSlug: user.organizationSlug,
  }, () => next());
}
```

### 4. Authorization Guards

SuperAdmins are **blocked** from accessing tenant-scoped endpoints:

```typescript
@Get(':id')
@UseGuards(JwtAuthGuard, RequireOrganizationGuard)
async findCase(@Param('id') id: string) {
  // RequireOrganizationGuard ensures user has organizationId
  // SuperAdmins will be rejected with 403 Forbidden
}
```

---

## SuperAdmin Capabilities

### ✅ What SuperAdmins CAN Do

1. **Organization Management**
   - Create new organizations
   - Update organization metadata (name, slug, plan, status)
   - View organization list and statistics
   - Suspend/activate organizations

2. **Subscription Management**
   - Change subscription plans
   - Extend trial periods
   - View billing information

3. **Platform Administration**
   - Monitor system health
   - View platform-wide metrics (aggregated, anonymized)
   - Manage SuperAdmin users
   - Configure platform settings

4. **Support Operations**
   - View audit logs (with customer authorization)
   - Assist with technical issues (no data access)

### ❌ What SuperAdmins CANNOT Do

1. **Access Organizational Data**
   - ❌ View cases, clients, children, families
   - ❌ Read case notes or documents
   - ❌ Access reports or dashboards
   - ❌ View assessment data
   - ❌ See medical or education records

2. **Manage Organization Users**
   - ❌ Create users for organizations
   - ❌ Assign roles to org users
   - ❌ Reset passwords for org users

3. **Modify Organizational Content**
   - ❌ Create or edit programs
   - ❌ Add workers
   - ❌ Configure org-specific settings

---

## API Endpoints

### SuperAdmin-Only Endpoints

```
POST   /api/admin/organizations          # Create organization
GET    /api/admin/organizations          # List all organizations
GET    /api/admin/organizations/:id      # Get org metadata
PATCH  /api/admin/organizations/:id      # Update org metadata
GET    /api/admin/organizations/:id/stats # Get org statistics
POST   /api/admin/superadmins            # Create SuperAdmin user
GET    /api/admin/platform/health        # Platform health metrics
```

### Blocked for SuperAdmins

```
GET    /api/cases/*                      # All case endpoints
GET    /api/children/*                   # All children endpoints
GET    /api/clients/*                    # All client endpoints
GET    /api/families/*                   # All family endpoints
GET    /api/reports/*                    # All report endpoints
GET    /api/organizations/me/*           # Current org endpoints
```

---

## Security Guarantees

1. **Database-Level Isolation**
   - SuperAdmins have `organizationId = null`
   - Prisma middleware automatically filters by `organizationId`
   - SuperAdmins get zero results from tenant-scoped queries

2. **Application-Level Guards**
   - `RequireOrganizationGuard` blocks SuperAdmins from org endpoints
   - `SuperAdminGuard` blocks org users from platform endpoints

3. **Audit Logging**
   - All SuperAdmin actions logged separately
   - Customer-visible audit logs exclude SuperAdmin platform actions

4. **JWT Payload**
   ```json
   {
     "sub": "superadmin-user-id",
     "email": "admin@melkentechwork.com",
     "roles": ["superadmin"],
     "organizationId": null  // ← Key difference
   }
   ```

---

## Migration Path

For existing deployments with `admin` users tied to organizations:

1. Create new `superadmin` role
2. Create SuperAdmin users with `organizationId = null`
3. Rename existing `admin` role to `org_admin` (or keep as `admin` for org-level)
4. Update guards and middleware
5. Test isolation thoroughly

---

## Compliance & Trust

This model aligns with:

- **SOC 2 Trust Criteria**: Separation of duties, least privilege
- **HIPAA**: No PHI access for platform administrators
- **GDPR**: Data processor vs. data controller separation
- **Customer Trust**: Clear boundaries between platform and data access

---

## Next Steps

See implementation tasks in the task list.

