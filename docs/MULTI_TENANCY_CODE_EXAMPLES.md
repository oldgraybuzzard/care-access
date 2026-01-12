# Multi-Tenancy Implementation Examples

## 1. Database Schema Changes

### Migration: Add Organization Model

```prisma
// services/api/prisma/schema.prisma

model Organization {
  id          String   @id @default(uuid())
  name        String
  slug        String   @unique  // URL-friendly identifier
  domain      String?  @unique  // Custom domain (optional)

  // Subscription
  plan        String   @default("trial")
  status      String   @default("active")
  trialEndsAt DateTime? @map("trial_ends_at")

  // Branding
  logoUrl     String?  @map("logo_url")
  primaryColor String? @map("primary_color")

  // Settings
  settings    Json?

  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  // Relations
  users       User[]
  clients     Client[]
  children    Child[]
  families    Family[]
  programs    Program[]
  workers     Worker[]
  cases       Case[]

  @@map("organizations")
}

// Update existing models
model User {
  id             String   @id @default(uuid())
  email          String   @unique
  name           String
  passwordHash   String   @map("password_hash")
  isActive       Boolean  @default(true) @map("is_active")

  // ADD THIS
  organizationId String   @map("organization_id")
  organization   Organization @relation(fields: [organizationId], references: [id])

  createdAt      DateTime @default(now()) @map("created_at")
  updatedAt      DateTime @updatedAt @map("updated_at")

  roles          UserRole[]
  auditLogs      AuditLog[]
  reportRuns     ReportRun[]
  ownedReports   ReportDefinition[]

  @@index([organizationId])
  @@map("users")
}

model Child {
  id                String    @id @default(uuid())

  // ADD THIS
  organizationId    String    @map("organization_id")
  organization      Organization @relation(fields: [organizationId], references: [id])

  clientId          String?   @unique @map("client_id")
  firstName         String    @map("first_name")
  // ... rest of fields

  @@index([organizationId])
  @@index([organizationId, status])  // Composite index for common queries
  @@map("children")
}

// Repeat for all tenant-scoped models:
// - Client, Case, Family, Program, Worker
// - Assessment, Goal, Document, Activity, Service
// - All other domain models
```

## 2. Tenant Context Service

```typescript
// services/api/src/common/tenant-context.service.ts

import { Injectable } from '@nestjs/common';
import { AsyncLocalStorage } from 'async_hooks';

export interface TenantContext {
  organizationId: string;
  organizationSlug: string;
  userId: string;
}

@Injectable()
export class TenantContextService {
  private readonly storage = new AsyncLocalStorage<TenantContext>();

  setContext(context: TenantContext): void {
    this.storage.enterWith(context);
  }

  getContext(): TenantContext {
    const context = this.storage.getStore();
    if (!context) {
      throw new Error('Tenant context not set. This should never happen.');
    }
    return context;
  }

  getOrganizationId(): string {
    return this.getContext().organizationId;
  }

  getUserId(): string {
    return this.getContext().userId;
  }

  isContextSet(): boolean {
    return this.storage.getStore() !== undefined;
  }
}
```

## 3. Tenant Middleware

```typescript
// services/api/src/common/tenant.middleware.ts

import { Injectable, NestMiddleware, UnauthorizedException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { TenantContextService } from './tenant-context.service';

@Injectable()
export class TenantMiddleware implements NestMiddleware {
  constructor(private readonly tenantContext: TenantContextService) {}

  use(req: Request, res: Response, next: NextFunction) {
    // Extract user from JWT (already validated by JwtAuthGuard)
    const user = (req as any).user;

    if (!user) {
      throw new UnauthorizedException('User not authenticated');
    }

    if (!user.organizationId) {
      throw new UnauthorizedException('User has no organization');
    }

    // Set tenant context for this request
    this.tenantContext.setContext({
      organizationId: user.organizationId,
      organizationSlug: user.organizationSlug,
      userId: user.userId,
    });

    next();
  }
}
```

## 4. Prisma Middleware for Auto-Filtering

```typescript
// services/api/src/prisma/prisma.service.ts

import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { TenantContextService } from '../common/tenant-context.service';

// Models that should be scoped to organization
const TENANT_SCOPED_MODELS = [
  'Client',
  'Child',
  'Family',
  'Case',
  'Program',
  'Worker',
  'Assessment',
  'Goal',
  'Document',
  'Activity',
  'Service',
  // Add all other tenant-scoped models
];

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(private readonly tenantContext: TenantContextService) {
    super();
  }

  async onModuleInit() {
    await this.$connect();

    // Register middleware for automatic tenant filtering
    this.$use(async (params, next) => {
      // Skip if tenant context is not set (e.g., during migrations, seeds)
      if (!this.tenantContext.isContextSet()) {
        return next(params);
      }

      const organizationId = this.tenantContext.getOrganizationId();

      // Only apply to tenant-scoped models
      if (params.model && TENANT_SCOPED_MODELS.includes(params.model)) {
        // READ operations - add organizationId filter
        if (params.action === 'findUnique' || params.action === 'findFirst') {
          params.args.where = {
            ...params.args.where,
            organizationId,
          };
        }

        if (params.action === 'findMany') {
          if (params.args.where) {
            if (params.args.where.organizationId && params.args.where.organizationId !== organizationId) {
              throw new Error('Attempted to access data from different organization');
            }
            params.args.where = {
              ...params.args.where,
              organizationId,
            };
          } else {
            params.args.where = { organizationId };
          }
        }

        // WRITE operations - inject organizationId
        if (params.action === 'create') {
          params.args.data = {
            ...params.args.data,
            organizationId,
          };
        }

        if (params.action === 'createMany' && Array.isArray(params.args.data)) {
          params.args.data = params.args.data.map((item) => ({
            ...item,
            organizationId,
          }));
        }

        // UPDATE/DELETE operations - ensure organizationId filter
        if (params.action === 'update' || params.action === 'delete' || params.action === 'updateMany' || params.action === 'deleteMany') {
          params.args.where = {
            ...params.args.where,
            organizationId,
          };
        }
      }

      return next(params);
    });
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

## 5. Updated JWT Strategy

```typescript
// services/api/src/auth/strategies/jwt.strategy.ts

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../../users/users.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private usersService: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_ACCESS_SECRET'),
    });
  }

  async validate(payload: any) {
    const user = await this.usersService.findById(payload.sub);

    if (!user || !user.isActive) {
      throw new UnauthorizedException();
    }

    // Include organization info in request.user
    return {
      userId: payload.sub,
      email: payload.email,
      roles: payload.roles || [],
      organizationId: user.organizationId,  // ADD THIS
      organizationSlug: user.organization.slug,  // ADD THIS
    };
  }
}
```



## 6. Updated Auth Service

```typescript
// services/api/src/auth/auth.service.ts

async login(loginDto: LoginDto) {
  const user = await this.validateUser(loginDto.email, loginDto.password);

  if (!user) {
    throw new UnauthorizedException('Invalid credentials');
  }

  // Include organization in JWT payload
  const payload = {
    sub: user.id,
    email: user.email,
    roles: user.roles?.map(ur => ur.role.name) || [],
    organizationId: user.organizationId,  // ADD THIS
  };

  const accessToken = this.jwtService.sign(payload);
  const refreshToken = this.jwtService.sign(payload, {
    secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
    expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRATION', '7d'),
  });

  return {
    accessToken,
    refreshToken,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      roles: user.roles?.map(ur => ur.role.name) || [],
      organizationId: user.organizationId,  // ADD THIS
      organization: {  // ADD THIS
        id: user.organization.id,
        name: user.organization.name,
        slug: user.organization.slug,
        plan: user.organization.plan,
      },
    },
  };
}
```

## 7. Service Layer Example

```typescript
// services/api/src/children/children.service.ts

import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TenantContextService } from '../common/tenant-context.service';

@Injectable()
export class ChildrenService {
  constructor(
    private prisma: PrismaService,
    private tenantContext: TenantContextService,  // Inject for explicit checks
  ) {}

  async findAll() {
    // Prisma middleware automatically adds organizationId filter
    return this.prisma.child.findMany({
      include: {
        family: true,
        client: true,
      },
      orderBy: { firstName: 'asc' },
    });
    // SQL: SELECT * FROM children WHERE organization_id = 'xxx' ORDER BY first_name
  }

  async findOne(id: string) {
    const child = await this.prisma.child.findUnique({
      where: { id },  // Middleware adds organizationId automatically
      include: {
        family: true,
        client: true,
        assessments: true,
      },
    });

    if (!child) {
      throw new NotFoundException('Child not found');
    }

    return child;
  }

  async create(createChildDto: CreateChildDto) {
    // Middleware automatically injects organizationId
    return this.prisma.child.create({
      data: createChildDto,
      // organizationId is automatically added by middleware
    });
  }

  async update(id: string, updateChildDto: UpdateChildDto) {
    // Middleware ensures we can only update children in our org
    return this.prisma.child.update({
      where: { id },
      data: updateChildDto,
    });
  }
}
```

## 8. App Module Configuration

```typescript
// services/api/src/app.module.ts

import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { TenantMiddleware } from './common/tenant.middleware';
import { TenantContextService } from './common/tenant-context.service';

@Module({
  imports: [
    // ... existing imports
  ],
  providers: [
    TenantContextService,  // ADD THIS - make it global
  ],
  exports: [TenantContextService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply tenant middleware to all routes except auth
    consumer
      .apply(TenantMiddleware)
      .exclude(
        'auth/login',
        'auth/register',
        'auth/refresh',
        'health',
      )
      .forRoutes('*');
  }
}
```

## 9. Organization Signup Flow

```typescript
// services/api/src/organizations/organizations.service.ts

import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class OrganizationsService {
  constructor(private prisma: PrismaService) {}

  async signup(signupDto: OrganizationSignupDto) {
    const { organizationName, slug, adminEmail, adminName, adminPassword } = signupDto;

    // Check if slug is available
    const existingOrg = await this.prisma.organization.findUnique({
      where: { slug },
    });

    if (existingOrg) {
      throw new ConflictException('Organization slug already taken');
    }

    // Check if email is available
    const existingUser = await this.prisma.user.findUnique({
      where: { email: adminEmail },
    });

    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    // Create organization and admin user in a transaction
    const result = await this.prisma.$transaction(async (tx) => {
      // Create organization
      const organization = await tx.organization.create({
        data: {
          name: organizationName,
          slug,
          plan: 'trial',
          status: 'active',
          trialEndsAt: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000), // 14 days
        },
      });

      // Create admin role if it doesn't exist
      let adminRole = await tx.role.findUnique({ where: { name: 'admin' } });
      if (!adminRole) {
        adminRole = await tx.role.create({
          data: { name: 'admin', description: 'Organization administrator' },
        });
      }

      // Create admin user
      const passwordHash = await bcrypt.hash(adminPassword, 10);
      const user = await tx.user.create({
        data: {
          email: adminEmail,
          name: adminName,
          passwordHash,
          organizationId: organization.id,
          roles: {
            create: {
              roleId: adminRole.id,
            },
          },
        },
        include: {
          roles: {
            include: {
              role: true,
            },
          },
        },
      });

      return { organization, user };
    });

    return result;
  }
}
```

## 10. Testing Tenant Isolation

```typescript
// services/api/src/children/children.service.spec.ts

describe('ChildrenService - Tenant Isolation', () => {
  let service: ChildrenService;
  let prisma: PrismaService;
  let tenantContext: TenantContextService;

  beforeEach(async () => {
    // Setup test module
  });

  it('should only return children from current organization', async () => {
    // Create two organizations
    const org1 = await prisma.organization.create({ data: { name: 'Org 1', slug: 'org1' } });
    const org2 = await prisma.organization.create({ data: { name: 'Org 2', slug: 'org2' } });

    // Create children in different orgs
    await prisma.child.create({ data: { ...childData, organizationId: org1.id } });
    await prisma.child.create({ data: { ...childData, organizationId: org2.id } });

    // Set tenant context to org1
    tenantContext.setContext({ organizationId: org1.id, userId: 'user1' });

    // Query should only return org1's children
    const children = await service.findAll();
    expect(children).toHaveLength(1);
    expect(children[0].organizationId).toBe(org1.id);
  });

  it('should not allow accessing children from other organizations', async () => {
    const org1 = await prisma.organization.create({ data: { name: 'Org 1', slug: 'org1' } });
    const org2 = await prisma.organization.create({ data: { name: 'Org 2', slug: 'org2' } });

    const child = await prisma.child.create({
      data: { ...childData, organizationId: org2.id }
    });

    // Set tenant context to org1
    tenantContext.setContext({ organizationId: org1.id, userId: 'user1' });

    // Trying to access org2's child should fail
    await expect(service.findOne(child.id)).rejects.toThrow(NotFoundException);
  });
});
```

## Key Takeaways

1. **Automatic Filtering**: Prisma middleware handles 99% of tenant isolation automatically
2. **Fail-Safe**: Even if a developer forgets to add filters, middleware catches it
3. **Performance**: Composite indexes on `(organizationId, otherField)` keep queries fast
4. **Security**: Multiple layers of protection (JWT, middleware, Prisma middleware)
5. **Developer Experience**: Services don't need to worry about tenant filtering
