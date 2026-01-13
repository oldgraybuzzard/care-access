# CareAccess

CareAccess is a nonprofit-focused mobile and web application built for organizations that serve children and families. It provides secure, role-based access to case data, reporting, and dashboards, allowing staff and leadership to stay informed, meet compliance requirements, and make data-driven decisions—without disrupting existing case management systems.

## Architecture

- **Frontend**: Flutter (iOS, Android, Web)
- **Backend API**: NestJS (Node.js)
- **Worker Service**: NestJS (Background jobs)
- **Database**: PostgreSQL
- **Cache/Queue**: Redis (optional)
- **Deployment**: Railway

## Repository Structure

```
fcf-platform/
├── apps/
│   └── flutter_app/          # Flutter mobile + web app
├── services/
│   ├── api/                  # NestJS REST API
│   └── worker/               # Background job processor
├── infra/
│   ├── docker-compose.yml    # Local development
│   └── railway.md            # Railway deployment guide
└── package.json              # Monorepo root
```

## Quick Start

### Prerequisites

- Node.js 20+
- npm 10+
- Flutter 3.16+
- Docker & Docker Compose
- PostgreSQL 15+ (or use Docker)

### Local Development

1. **Clone and install dependencies**
   ```bash
   npm install
   cd apps/flutter_app && flutter pub get && cd ../..
   ```

2. **Start local services (Postgres + Redis)**
   ```bash
   npm run docker:up
   ```

3. **Setup database**
   ```bash
   cd services/api
   cp .env.example .env
   # Edit .env with your configuration
   npm run prisma:migrate:dev
   npm run prisma:generate
   cd ../..
   ```

4. **Start API server**
   ```bash
   npm run api:dev
   ```

5. **Start worker service**
   ```bash
   npm run worker:dev
   ```

6. **Run Flutter app**
   ```bash
   cd apps/flutter_app
   flutter run -d chrome  # For web
   flutter run            # For mobile (with emulator/device)
   ```

## API Documentation

Once the API is running, visit:
- Swagger UI: http://localhost:3001/api
- API Health: http://localhost:3001/health

## Environment Variables

See `services/api/.env.example` and `services/worker/.env.example` for required configuration.

## Deployment

See [infra/railway.md](infra/railway.md) for Railway deployment instructions.

## MVP Features

1. **Onsite Data Access** - Search clients, cases, activities
2. **Standard Reports** - Caseload, intakes, compliance, services
3. **Custom Report Builder** - Ad-hoc queries with filters
4. **Dashboards** - KPI tiles and trend visualizations
5. **Export** - CSV/XLSX export with audit logging

## Security

- JWT access + refresh tokens
- Role-based access control (RBAC)
- Multi-tenant isolation with organization-based data segregation
- SuperAdmin platform management (isolated from organizational data)
- Audit logging for all data access
- Read-only access to vendor data

### Documentation

- [SuperAdmin API Guide](docs/SUPERADMIN_API_GUIDE.md) - API endpoints and usage
- [SuperAdmin Architecture](docs/SUPERADMIN_ARCHITECTURE.md) - Technical implementation details
- [Multi-Tenant Architecture](docs/MULTI_TENANT_ARCHITECTURE.md) - Tenant isolation design

## License

UNLICENSED - Proprietary software for Friends of Children and Families

