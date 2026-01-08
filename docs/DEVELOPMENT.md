# Development Guide

## Project Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd fcf
```

### 2. Install Dependencies

```bash
# Install root dependencies
npm install

# Install API dependencies
cd services/api
npm install
cd ../..

# Install Worker dependencies
cd services/worker
npm install
cd ../..

# Install Flutter dependencies
cd apps/flutter_app
flutter pub get
cd ../..
```

### 3. Database Setup

```bash
# Start PostgreSQL (using Docker)
docker run -d \
  --name fcf-postgres \
  -e POSTGRES_USER=fcf_user \
  -e POSTGRES_PASSWORD=fcf_password \
  -e POSTGRES_DB=fcf_platform \
  -p 5432:5432 \
  postgres:15

# Or use local PostgreSQL installation
```

### 4. Environment Configuration

```bash
# API Service
cd services/api
cp .env.example .env
# Edit .env with your configuration

# Worker Service
cd ../worker
cp .env.example .env
# Edit .env with your configuration
```

### 5. Run Migrations

```bash
cd services/api
npx prisma migrate dev
npx prisma generate
npm run seed
```

## Development Workflow

### Running Services

#### API Service
```bash
cd services/api
npm run start:dev
```

Access at: http://localhost:3000
Swagger docs: http://localhost:3000/api

#### Worker Service
```bash
cd services/worker
npm run start:dev
```

#### Flutter App
```bash
cd apps/flutter_app

# Web
flutter run -d chrome

# iOS Simulator
flutter run -d "iPhone 15 Pro"

# Android Emulator
flutter run -d emulator-5554
```

### Code Generation

#### Prisma
```bash
cd services/api
npx prisma generate        # Generate Prisma Client
npx prisma migrate dev     # Create and apply migration
npx prisma studio          # Open Prisma Studio
```

#### Flutter
```bash
cd apps/flutter_app
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Structure

### API Service (`services/api`)

```
src/
├── auth/              # Authentication module
├── clients/           # Client management
├── cases/             # Case management
├── activities/        # Activity tracking
├── services/          # Service records
├── reports/           # Reporting engine
├── kpis/              # KPI calculations
├── programs/          # Program management
├── workers/           # Worker management
└── common/            # Shared utilities
```

### Worker Service (`services/worker`)

```
src/
├── jobs/              # Scheduled jobs
│   ├── sync.job.ts           # Data sync
│   └── kpi-rollup.job.ts     # KPI calculations
├── integrations/      # Vendor integrations
│   ├── extendedreach.service.ts
│   └── zoho.service.ts
└── prisma/            # Database access
```

### Flutter App (`apps/flutter_app`)

```
lib/
├── core/              # Core utilities
│   ├── api/                  # API client
│   ├── routing/              # Navigation
│   ├── theme/                # Theming
│   ├── storage/              # Secure storage
│   ├── models/               # Core models
│   └── providers/            # Core providers
├── features/          # Feature modules
│   ├── auth/                 # Authentication
│   ├── search/               # Search functionality
│   ├── clients/              # Client views
│   ├── cases/                # Case views
│   ├── reports/              # Reports
│   └── dashboards/           # Dashboards
└── shared/            # Shared widgets
```

## Testing

### API Tests
```bash
cd services/api
npm test                    # Run all tests
npm test -- --watch        # Watch mode
npm test -- --coverage     # With coverage
```

### Worker Tests
```bash
cd services/worker
npm test
```

### Flutter Tests
```bash
cd apps/flutter_app
flutter test                # Unit tests
flutter test integration_test/  # Integration tests
```

## Database Management

### Create Migration
```bash
cd services/api
npx prisma migrate dev --name <migration-name>
```

### Reset Database
```bash
npx prisma migrate reset
```

### Seed Database
```bash
npm run seed
```

### View Data
```bash
npx prisma studio
```

## Debugging

### API Service
- Use VS Code debugger with launch configuration
- Or use `npm run start:debug` and attach debugger

### Flutter App
- Use VS Code Flutter extension
- Or use Android Studio / Xcode debuggers

## Common Tasks

### Add New API Endpoint

1. Create/update module in `services/api/src`
2. Add controller method
3. Add service method
4. Update DTOs if needed
5. Add tests
6. Update API documentation

### Add New Report

1. Create report service in `services/api/src/reports`
2. Add report endpoint in controller
3. Update Flutter app to call new endpoint
4. Add UI for report in Flutter

### Add New Vendor Integration

1. Create service in `services/worker/src/integrations`
2. Implement authentication and data fetching
3. Update sync job to use new integration
4. Add vendor source to database seed

## Code Style

### TypeScript (API/Worker)
- Use ESLint and Prettier
- Run: `npm run lint` and `npm run format`

### Dart (Flutter)
- Use `flutter analyze`
- Run: `flutter format .`

## Git Workflow

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit
3. Push and create pull request
4. Wait for review and CI checks
5. Merge to main

## Troubleshooting

### Database Connection Issues
- Check PostgreSQL is running
- Verify DATABASE_URL in .env
- Check firewall settings

### Prisma Issues
- Delete `node_modules/.prisma` and regenerate
- Run `npx prisma generate`

### Flutter Build Issues
- Run `flutter clean`
- Delete `pubspec.lock` and run `flutter pub get`
- Clear build cache

### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000
# Kill process
kill -9 <PID>
```

