# Nixpacks Configuration for Railway Deployment

## Overview

This project uses [Nixpacks](https://nixpacks.com/) to build and deploy services on Railway. Nixpacks is Railway's default build system that automatically detects and builds applications.

## Configuration Files

### API Service: `services/api/nixpacks.toml`

```toml
[phases.setup]
nixPkgs = ["nodejs_20", "openssl"]

[phases.install]
cmds = [
  "npm ci --production=false"
]

[phases.build]
cmds = [
  "npx prisma generate",
  "npm run build"
]

[start]
cmd = "npx prisma migrate deploy && npm run start:prod"
```

**What it does:**
1. **Setup**: Installs Node.js 20 and OpenSSL (required for Prisma)
2. **Install**: Installs all dependencies (including dev dependencies for build)
3. **Build**: 
   - Generates Prisma Client
   - Builds the NestJS application
4. **Start**: 
   - Runs database migrations automatically
   - Starts the production server

### Worker Service: `services/worker/nixpacks.toml`

```toml
[phases.setup]
nixPkgs = ["nodejs_20", "openssl"]

[phases.install]
cmds = [
  "npm ci --production=false"
]

[phases.build]
cmds = [
  "npx prisma generate --schema=../api/prisma/schema.prisma",
  "npm run build"
]

[start]
cmd = "npm run start:prod"
```

**What it does:**
1. **Setup**: Installs Node.js 20 and OpenSSL
2. **Install**: Installs all dependencies
3. **Build**: 
   - Generates Prisma Client using the API's schema (shared schema)
   - Builds the NestJS worker application
4. **Start**: Starts the production worker

## Why Nixpacks?

### Advantages
- ✅ **Automatic Detection**: Detects Node.js projects automatically
- ✅ **Reproducible Builds**: Uses Nix packages for consistent environments
- ✅ **Fast Builds**: Caches dependencies and build artifacts
- ✅ **Monorepo Support**: Works with multiple services in one repository
- ✅ **No Docker Required**: Simpler than maintaining Dockerfiles

### Monorepo Configuration

For monorepo deployments on Railway:

1. **Root Directory**: Set to `services/api` or `services/worker`
2. **Watch Paths**: Configure to only trigger rebuilds on relevant changes
   - API: `services/api/**`
   - Worker: `services/worker/**,services/api/prisma/**`

## Build Process

### API Service Build Flow

```
1. Setup Phase
   └─ Install Node.js 20 + OpenSSL

2. Install Phase
   └─ npm ci --production=false

3. Build Phase
   ├─ npx prisma generate
   └─ npm run build

4. Start Phase
   ├─ npx prisma migrate deploy (run migrations)
   └─ npm run start:prod
```

### Worker Service Build Flow

```
1. Setup Phase
   └─ Install Node.js 20 + OpenSSL

2. Install Phase
   └─ npm ci --production=false

3. Build Phase
   ├─ npx prisma generate --schema=../api/prisma/schema.prisma
   └─ npm run build

4. Start Phase
   └─ npm run start:prod
```

## Environment Variables

Nixpacks automatically makes Railway environment variables available during:
- ✅ Build phase (for build-time configuration)
- ✅ Runtime (for application configuration)

Required variables are set in Railway's dashboard (see [RAILWAY_SETUP.md](./RAILWAY_SETUP.md)).

## Troubleshooting

### Build Fails: "Prisma schema not found"

**Solution**: Ensure the root directory is set correctly in Railway settings:
- API: `services/api`
- Worker: `services/worker`

### Build Fails: "OpenSSL not found"

**Solution**: OpenSSL is included in `nixPkgs` in the setup phase. If this fails, check Railway build logs.

### Migrations Don't Run

**Solution**: The API service runs `npx prisma migrate deploy` on startup. Check:
1. `DATABASE_URL` is set correctly
2. Database is accessible from Railway
3. Migration files exist in `services/api/prisma/migrations/`

### Worker Can't Find Prisma Client

**Solution**: The worker generates Prisma Client from the API's schema:
```toml
npx prisma generate --schema=../api/prisma/schema.prisma
```

Ensure the path is correct relative to the worker's root directory.

## References

- [Nixpacks Documentation](https://nixpacks.com/)
- [Railway Documentation](https://docs.railway.app/)
- [Prisma Documentation](https://www.prisma.io/docs)

