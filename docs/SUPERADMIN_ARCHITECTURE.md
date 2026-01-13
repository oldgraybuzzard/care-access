# SuperAdmin Architecture

## Overview

This document explains the technical architecture of the SuperAdmin isolation system in the CareAccess platform.

## Core Principle

**SuperAdmins manage the platform, not the data.**

SuperAdmins can:
- ✅ Create and manage organizations
- ✅ View platform-wide statistics
- ✅ Manage billing and subscriptions
- ✅ Monitor system health

SuperAdmins cannot:
- ❌ Access cases, children, clients, or families
- ❌ View organizational data
- ❌ Perform actions on behalf of organizations
- ❌ Bypass tenant isolation

## Database Schema

### User Model

```prisma
model User {
  id             String        @id @default(uuid())
  email          String        @unique
  name           String
  passwordHash   String
  organizationId String?       // ← NULL for SuperAdmins
  organization   Organization? @relation(fields: [organizationId], references: [id])
  roles          UserRole[]
  isActive       Boolean       @default(true)
  createdAt      DateTime      @default(now())
  updatedAt      DateTime      @updatedAt
}
```

**Key Design Decision:**
- `organizationId` is **nullable**
- SuperAdmins have `organizationId = null`
- Organization users have `organizationId = <uuid>`

### Role Model

```prisma
model Role {
  id          String     @id @default(uuid())
  name        String     @unique  // 'superadmin', 'admin', 'user', etc.
  description String?
  users       UserRole[]
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt
}
```

**Roles:**
- `superadmin` - Platform administrators (no organization)
- `admin` - Organization administrators
- `user` - Regular organization users

## Security Layers

### Layer 1: Database-Level Isolation

**Prisma Middleware** (`services/api/src/prisma/prisma.service.ts`):

```typescript
prisma.$use(async (params, next) => {
  const user = getCurrentUser();
  
  if (!user) return next(params);
  
  // SuperAdmins have no organizationId
  if (!user.organizationId) {
    // No tenant filtering for SuperAdmins
    return next(params);
  }
  
  // For org users, inject organizationId filter
  if (TENANT_SCOPED_MODELS.includes(params.model)) {
    params.args.where = {
      ...params.args.where,
      organizationId: user.organizationId,
    };
  }
  
  return next(params);
});
```

**Effect:**
- SuperAdmins querying `Case`, `Child`, `Client`, etc. get **empty results**
- Even if guards are bypassed, database returns no data
- Defense in depth

### Layer 2: Guard-Level Protection

#### RequireOrganizationGuard

**Purpose:** Block SuperAdmins from accessing organizational endpoints

**Location:** `services/api/src/auth/guards/require-organization.guard.ts`

**Implementation:**
```typescript
@Injectable()
export class RequireOrganizationGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new UnauthorizedException('User not authenticated');
    }

    // Block SuperAdmins
    if (!user.organizationId) {
      throw new ForbiddenException(
        'This endpoint requires organization membership. ' +
        'SuperAdmins cannot access organizational data.'
      );
    }

    return true;
  }
}
```

**Applied to:**
- `CasesController`
- `ChildrenController`
- `ClientsController`
- `FamiliesController`
- `ReportsController`
- `DashboardsController`
- `UserOrganizationsController`

#### SuperAdminGuard

**Purpose:** Block organization users from accessing platform endpoints

**Location:** `services/api/src/auth/guards/superadmin.guard.ts`

**Implementation:**
```typescript
@Injectable()
export class SuperAdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new UnauthorizedException('User not authenticated');
    }

    // Check for superadmin role AND no organization
    const isSuperAdmin = user.roles?.includes('superadmin') && !user.organizationId;

    if (!isSuperAdmin) {
      throw new ForbiddenException(
        'This endpoint requires SuperAdmin privileges.'
      );
    }

    return true;
  }
}
```

**Applied to:**
- `OrganizationsController` (admin endpoints)
- `SuperAdminController`

### Layer 3: Controller-Level Separation

#### Organization Data Controllers

```typescript
@Controller('cases')
@UseGuards(JwtAuthGuard, RequireOrganizationGuard)  // ← Blocks SuperAdmins
export class CasesController {
  // All methods require organizationId
}
```

#### Platform Management Controllers

```typescript
@Controller('admin/organizations')
@UseGuards(JwtAuthGuard, SuperAdminGuard)  // ← Requires SuperAdmin
export class OrganizationsController {
  // All methods require superadmin role
}
```

## Request Flow

### SuperAdmin Accessing Platform Endpoint

```
1. Request: GET /api/admin/organizations
2. JwtAuthGuard: ✅ Valid token
3. SuperAdminGuard: ✅ user.roles includes 'superadmin' AND user.organizationId is null
4. Controller: ✅ Execute method
5. Service: Query organizations (no tenant filter)
6. Response: 200 OK with organization list
```

### SuperAdmin Accessing Org Endpoint (Blocked)

```
1. Request: GET /api/cases
2. JwtAuthGuard: ✅ Valid token
3. RequireOrganizationGuard: ❌ user.organizationId is null
4. Response: 403 Forbidden
   {
     "statusCode": 403,
     "message": "This endpoint requires organization membership. SuperAdmins cannot access organizational data.",
     "error": "Forbidden"
   }
```

### Org User Accessing Platform Endpoint (Blocked)

```
1. Request: GET /api/admin/organizations
2. JwtAuthGuard: ✅ Valid token
3. SuperAdminGuard: ❌ user.organizationId is not null
4. Response: 403 Forbidden
   {
     "statusCode": 403,
     "message": "This endpoint requires SuperAdmin privileges.",
     "error": "Forbidden"
   }
```

### Org User Accessing Org Endpoint

```
1. Request: GET /api/cases
2. JwtAuthGuard: ✅ Valid token
3. RequireOrganizationGuard: ✅ user.organizationId exists
4. Controller: ✅ Execute method
5. Prisma Middleware: Inject organizationId filter
6. Service: Query cases WHERE organizationId = user.organizationId
7. Response: 200 OK with cases
```

## API Endpoint Structure

### Platform Management (SuperAdmin Only)

```
/api/admin/
  ├── organizations/          # Manage all organizations
  │   ├── POST /              # Create organization
  │   ├── GET /               # List all organizations
  │   ├── GET /:id            # Get organization details
  │   ├── PATCH /:id          # Update organization
  │   ├── DELETE /:id         # Delete organization
  │   └── GET /:id/stats      # Get org statistics
  │
  └── superadmins/            # Manage SuperAdmin users
      ├── POST /              # Create SuperAdmin
      ├── GET /               # List all SuperAdmins
      ├── GET /:id            # Get SuperAdmin details
      ├── PATCH /:id          # Update SuperAdmin
      ├── DELETE /:id         # Delete SuperAdmin
      ├── GET /platform/health    # Platform health
      └── GET /platform/stats     # Platform statistics
```

### Organization Data (Org Users Only)

```
/api/
  ├── cases/                  # Case management
  ├── children/               # Child records
  ├── clients/                # Client records
  ├── families/               # Family records
  ├── reports/                # Reports
  ├── dashboards/             # Dashboards
  └── organizations/me/       # Current org management
```

## Testing Strategy

### Unit Tests

Test guards in isolation:

```typescript
describe('RequireOrganizationGuard', () => {
  it('should block SuperAdmins', () => {
    const user = { organizationId: null, roles: ['superadmin'] };
    expect(() => guard.canActivate(context)).toThrow(ForbiddenException);
  });

  it('should allow org users', () => {
    const user = { organizationId: 'uuid', roles: ['user'] };
    expect(guard.canActivate(context)).toBe(true);
  });
});
```

### Integration Tests

Test full request flow:

```typescript
describe('SuperAdmin Isolation', () => {
  it('should block SuperAdmin from accessing cases', async () => {
    const superadminToken = await loginAsSuperAdmin();
    
    const response = await request(app.getHttpServer())
      .get('/api/cases')
      .set('Authorization', `Bearer ${superadminToken}`)
      .expect(403);
      
    expect(response.body.message).toContain('organization membership');
  });

  it('should allow SuperAdmin to access organizations', async () => {
    const superadminToken = await loginAsSuperAdmin();
    
    await request(app.getHttpServer())
      .get('/api/admin/organizations')
      .set('Authorization', `Bearer ${superadminToken}`)
      .expect(200);
  });
});
```

### E2E Tests

Test real-world scenarios:

```typescript
describe('SuperAdmin Workflow', () => {
  it('should create organization and verify isolation', async () => {
    // 1. Login as SuperAdmin
    const superadminToken = await loginAsSuperAdmin();
    
    // 2. Create organization
    const org = await createOrganization(superadminToken);
    
    // 3. Create org user
    const orgUser = await createOrgUser(org.id);
    const orgUserToken = await loginAsOrgUser(orgUser.email);
    
    // 4. Org user creates case
    const case = await createCase(orgUserToken);
    
    // 5. SuperAdmin cannot see the case
    const cases = await getCases(superadminToken);
    expect(cases).toHaveLength(0);
    
    // 6. Org user can see the case
    const orgCases = await getCases(orgUserToken);
    expect(orgCases).toHaveLength(1);
  });
});
```

## Deployment Considerations

### Environment Variables

```bash
# .env
JWT_SECRET=your-secret-key
DATABASE_URL=postgresql://...
```

### Database Migrations

When deploying:

```bash
# Run migrations
npm run prisma:migrate:deploy

# Seed SuperAdmin role
npm run prisma:seed:superadmin
```

### Initial SuperAdmin Creation

```bash
# Create first SuperAdmin via API
POST /api/admin/superadmins
{
  "email": "admin@melkentechwork.com",
  "name": "Platform Administrator",
  "password": "SecurePassword123!"
}
```

Or via database:

```sql
-- Create SuperAdmin role
INSERT INTO roles (id, name, description)
VALUES (gen_random_uuid(), 'superadmin', 'Platform Administrator');

-- Create SuperAdmin user
INSERT INTO users (id, email, name, password_hash, organization_id, is_active)
VALUES (
  gen_random_uuid(),
  'admin@melkentechwork.com',
  'Platform Administrator',
  '$2b$10$...', -- bcrypt hash
  NULL,         -- No organization
  true
);

-- Assign superadmin role
INSERT INTO user_roles (id, user_id, role_id)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM users WHERE email = 'admin@melkentechwork.com'),
  (SELECT id FROM roles WHERE name = 'superadmin')
);
```

## Monitoring and Auditing

### Audit Logs

All SuperAdmin actions should be logged:

```typescript
@Post()
async create(@Body() dto: CreateOrganizationDto, @Request() req) {
  const org = await this.organizationsService.create(dto);
  
  await this.auditService.log({
    userId: req.user.userId,
    action: 'CREATE_ORGANIZATION',
    resourceType: 'Organization',
    resourceId: org.id,
    metadata: { organizationName: org.name },
  });
  
  return org;
}
```

### Metrics

Track SuperAdmin activity:

```typescript
// Prometheus metrics
superadmin_actions_total{action="create_organization"} 15
superadmin_actions_total{action="update_organization"} 42
superadmin_login_total 127
```

## Security Best Practices

1. **Minimal SuperAdmin Accounts**: Create only what's needed
2. **Strong Authentication**: Require MFA for SuperAdmins
3. **Regular Audits**: Review SuperAdmin activity monthly
4. **Principle of Least Privilege**: SuperAdmins should not have org access
5. **Separation of Duties**: Different people for platform vs. support

## Future Enhancements

1. **Multi-Factor Authentication**: Require MFA for SuperAdmin login
2. **IP Whitelisting**: Restrict SuperAdmin access to specific IPs
3. **Time-Based Access**: Temporary SuperAdmin elevation
4. **Approval Workflows**: Require approval for sensitive operations
5. **Enhanced Auditing**: Detailed logs with retention policies

