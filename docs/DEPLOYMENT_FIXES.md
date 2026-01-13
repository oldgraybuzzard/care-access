# Deployment Fixes Summary

## 🎯 Problem Solved

**Issue**: Railway deployment was failing with "Prisma schema not found" error when trying to build from the root directory.

**Root Cause**: The monorepo structure requires proper build configuration for each service to locate the Prisma schema correctly.

## ✅ Solutions Implemented

### 1. Nixpacks Configuration Files Created

#### `services/api/nixpacks.toml`
- Configures Node.js 20 + OpenSSL environment
- Installs dependencies with `npm ci`
- Generates Prisma Client during build
- **Automatically runs migrations on startup** with `npx prisma migrate deploy`
- Starts production server

#### `services/worker/nixpacks.toml`
- Configures Node.js 20 + OpenSSL environment
- Installs dependencies with `npm ci`
- Generates Prisma Client from API's schema: `--schema=../api/prisma/schema.prisma`
- Starts production worker

### 2. Documentation Updates

- ✅ **RAILWAY_SETUP_CHECKLIST.md**: Added Nixpacks notes and watch paths
- ✅ **docs/RAILWAY_SETUP.md**: Updated with Nixpacks configuration details
- ✅ **docs/NIXPACKS_CONFIG.md**: New comprehensive guide on Nixpacks setup

### 3. Port Configuration Fixed

- Changed PostgreSQL Docker port from `5432` to `5433` to avoid local conflicts
- Updated `.env` files in both API and Worker services

### 4. TypeScript Errors Fixed

- Fixed `getIntakesVsClosuresTrend()` return type
- Fixed `metaJson` type casting in `runCustomReport()`

## 📦 What's in GitHub

All changes have been pushed to `https://github.com/oldgraybuzzard/care-access` on the `develop` branch:

### Commit 1: Port Conflicts and TypeScript Fixes
- Docker port configuration
- TypeScript compilation errors
- Database migrations
- Seed data

### Commit 2: Nixpacks Configuration
- API and Worker nixpacks.toml files
- Updated deployment documentation
- Nixpacks configuration guide

## 🚀 Next Steps for Railway Deployment

### Step 1: Create Railway Project
1. Go to https://railway.app/dashboard
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose `oldgraybuzzard/care-access`
5. Select `develop` branch

### Step 2: Add PostgreSQL Database
1. Click "+ New" → "Database" → "Add PostgreSQL"
2. Wait for provisioning
3. Note: `DATABASE_URL` is automatically created

### Step 3: Deploy API Service
1. Click "+ New" → "GitHub Repo"
2. Select `oldgraybuzzard/care-access`
3. Go to Settings:
   - Set **Root Directory**: `services/api`
   - Set **Watch Paths**: `services/api/**`
4. Link PostgreSQL database
5. Add environment variables (see checklist)
6. Deploy!

### Step 4: Deploy Worker Service
1. Click "+ New" → "GitHub Repo"
2. Select `oldgraybuzzard/care-access` again
3. Go to Settings:
   - Set **Root Directory**: `services/worker`
   - Set **Watch Paths**: `services/worker/**,services/api/prisma/**`
4. Link PostgreSQL database
5. Add environment variables (see checklist)
6. Deploy!

## 📚 Documentation Reference

- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Railway Checklist**: [RAILWAY_SETUP_CHECKLIST.md](RAILWAY_SETUP_CHECKLIST.md)
- **Railway Guide**: [docs/RAILWAY_SETUP.md](docs/RAILWAY_SETUP.md)
- **Nixpacks Config**: [docs/NIXPACKS_CONFIG.md](docs/NIXPACKS_CONFIG.md)
- **Quick Reference**: [RAILWAY_QUICK_REFERENCE.md](RAILWAY_QUICK_REFERENCE.md)

## 🔍 How Nixpacks Solves the Problem

### Before (Problem)
```bash
# Railway tried to run from root directory
$ npx prisma generate
Error: Could not find Prisma Schema
```

### After (Solution)
```toml
# services/api/nixpacks.toml
[phases.build]
cmds = [
  "npx prisma generate",  # Runs from services/api directory
  "npm run build"
]
```

Railway now:
1. Changes to the **Root Directory** (`services/api`)
2. Runs build commands from there
3. Prisma finds `prisma/schema.prisma` correctly
4. Build succeeds! ✅

## 🎉 Benefits

- ✅ **Automatic Migrations**: API service runs migrations on every deployment
- ✅ **Shared Schema**: Worker uses the same Prisma schema as API
- ✅ **Monorepo Support**: Each service builds independently
- ✅ **Watch Paths**: Only rebuild when relevant files change
- ✅ **No Docker**: Simpler than maintaining Dockerfiles
- ✅ **Reproducible**: Nix packages ensure consistent builds

## 🧪 Local Development

To test locally:

```bash
# Start Docker services
docker-compose up -d

# Terminal 1 - API
cd services/api
npm run start:dev

# Terminal 2 - Worker
cd services/worker
npm run start:dev
```

Or use the convenience script:
```bash
./scripts/dev.sh
```

## 🔐 Important Notes

- **PostgreSQL Port**: Now `localhost:5433` (not 5432)
- **Admin Credentials**: `admin@fcf.org` / `admin123`
- **API Port**: `localhost:3000`
- **Redis Port**: `localhost:6379`

## ✨ Ready to Deploy!

Your project is now fully configured for Railway deployment. Follow the [RAILWAY_SETUP_CHECKLIST.md](RAILWAY_SETUP_CHECKLIST.md) step by step, and you'll have a production deployment in minutes! 🚀

