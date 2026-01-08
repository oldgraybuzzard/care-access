# FCF Platform - Project Summary

## Overview

The FCF Platform is a comprehensive data integration and reporting system built for Friends of Children and Families. It syncs data from ExtendedReach (and other case management systems), provides powerful reporting capabilities, and offers mobile/web access to case data.

## Technology Stack

### Backend
- **API Service**: NestJS (TypeScript)
- **Worker Service**: NestJS (TypeScript)
- **Database**: PostgreSQL 15+
- **ORM**: Prisma
- **Cache/Queue**: Redis (optional)
- **Authentication**: JWT (access + refresh tokens)

### Frontend
- **Mobile App**: Flutter 3.16+
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Navigation**: go_router
- **Charts**: fl_chart
- **Storage**: flutter_secure_storage

### Infrastructure
- **Deployment**: Railway
- **Local Development**: Docker Compose
- **CI/CD**: GitHub Actions (future)

## Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (iOS/Android)  │
└────────┬────────┘
         │ HTTPS/REST
         ▼
┌─────────────────┐      ┌──────────────┐
│   NestJS API    │◄────►│  PostgreSQL  │
│   (Port 3000)   │      │   Database   │
└────────┬────────┘      └──────────────┘
         │                       ▲
         │                       │
         ▼                       │
┌─────────────────┐             │
│  Redis Cache    │             │
│   (Optional)    │             │
└─────────────────┘             │
                                │
┌─────────────────┐             │
│ NestJS Worker   │─────────────┘
│ (Background)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ExtendedReach  │
│   Vendor API    │
└─────────────────┘
```

## Key Features

### 1. Data Synchronization
- **Automated Sync**: Hourly sync from ExtendedReach
- **Incremental Updates**: Only sync changed data
- **Multi-Vendor Support**: Extensible to other systems (Zoho, etc.)
- **Error Handling**: Retry logic and error logging

### 2. Reporting System
- **Standard Reports**:
  - Caseload by Worker
  - Active Cases by Program/Status
  - Intakes vs Closures Trend
  - Service Utilization
  - Compliance Reports
  
- **Custom Report Builder**:
  - Ad-hoc queries with filters
  - Grouping and aggregation
  - Export to CSV/XLSX
  
### 3. Dashboards & KPIs
- **Real-time KPIs**: Current active cases, intakes, closures
- **Historical Trends**: Daily rollups for performance
- **Drill-down**: Click through to detailed data
- **Filters**: By program, worker, date range

### 4. Mobile Access
- **Cross-platform**: iOS and Android
- **Offline-capable**: Local caching
- **Secure**: JWT authentication, encrypted storage
- **Responsive**: Optimized for tablets and phones

### 5. Security & Compliance
- **Authentication**: JWT access + refresh tokens
- **Authorization**: Role-based access control (RBAC)
- **Audit Logging**: All data access logged
- **Data Privacy**: Read-only access to vendor data
- **Encryption**: HTTPS, encrypted storage

## Database Schema

### Core Entities
- **User**: System users with roles
- **VendorSource**: Integration sources (ExtendedReach, Zoho)
- **Client**: Individuals receiving services
- **Case**: Service cases
- **Activity**: Case activities and interactions
- **Service**: Services provided
- **Document**: Attached documents
- **Program**: Service programs
- **Worker**: Case workers
- **KpiDaily**: Daily KPI rollups
- **AuditLog**: Audit trail

## API Endpoints

### Authentication
- `POST /auth/login` - Login
- `POST /auth/refresh` - Refresh token
- `POST /auth/logout` - Logout

### Data Access
- `GET /clients` - List clients
- `GET /clients/:id` - Client details
- `GET /cases` - List cases
- `GET /cases/:id` - Case details
- `GET /activities` - List activities
- `GET /services` - List services

### Reporting
- `POST /reports/caseload-by-worker` - Caseload report
- `POST /reports/active-cases-by-program` - Program report
- `POST /reports/intakes-vs-closures` - Trend report
- `POST /reports/custom` - Custom query

### KPIs
- `GET /kpis/daily` - Historical KPIs
- `GET /kpis/current` - Real-time KPIs

## Background Jobs

### Sync Job (Hourly)
1. Authenticate with vendor API
2. Fetch clients, cases, activities, services
3. Upsert data to local database
4. Log sync results

### KPI Rollup Job (Daily at 2 AM)
1. Calculate KPIs for previous day
2. Rollup by program
3. Rollup by worker
4. Rollup overall metrics

## Deployment

### Railway (Production)
- **API Service**: Auto-deploy from main branch
- **Worker Service**: Auto-deploy from main branch
- **Database**: Managed PostgreSQL
- **Environment**: Production variables

### Local Development
- **Docker Compose**: PostgreSQL + Redis
- **Hot Reload**: API and Worker services
- **Flutter**: Run on simulator/emulator

## Development Workflow

1. **Setup**: Clone repo, install dependencies
2. **Database**: Run migrations, seed data
3. **API**: Start development server
4. **Worker**: Start background jobs
5. **Flutter**: Run on device/simulator
6. **Test**: Write and run tests
7. **Deploy**: Push to main branch

## Future Enhancements

### Phase 2
- [ ] Real-time notifications
- [ ] Advanced analytics with ML
- [ ] Document OCR and processing
- [ ] Mobile offline sync
- [ ] Multi-language support

### Phase 3
- [ ] Integration with more vendors
- [ ] Custom workflow builder
- [ ] Advanced permissions
- [ ] Data export automation
- [ ] API webhooks

## Documentation

- **README.md**: Quick start guide
- **docs/DEVELOPMENT.md**: Development setup
- **docs/DEPLOYMENT.md**: Deployment guide
- **docs/API.md**: API documentation
- **docs/PROJECT_SUMMARY.md**: This file

## Support

For questions or issues:
1. Check documentation
2. Review code comments
3. Contact development team

## License

Proprietary - Friends of Children and Families

