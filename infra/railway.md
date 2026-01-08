# Railway Deployment Guide

## Overview

The FCF Platform deploys to Railway with 3 services:
1. **PostgreSQL** (Railway plugin)
2. **API Service** (NestJS REST API)
3. **Worker Service** (Background jobs)

## Prerequisites

- Railway account (https://railway.app)
- Railway CLI installed: `npm i -g @railway/cli`
- GitHub repository connected to Railway

## Setup Steps

### 1. Create New Railway Project

```bash
railway login
railway init
```

### 2. Add PostgreSQL Database

In Railway dashboard:
1. Click "New" → "Database" → "Add PostgreSQL"
2. Railway will automatically set `DATABASE_URL` environment variable

### 3. Deploy API Service

1. In Railway dashboard, click "New" → "GitHub Repo"
2. Select your repository
3. Configure service:
   - **Name**: `fcf-api`
   - **Root Directory**: `services/api`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm run start:prod`
   - **Port**: `3000` (Railway auto-detects)

4. Add environment variables (see below)

### 4. Deploy Worker Service

1. Click "New" → "GitHub Repo" (same repo)
2. Configure service:
   - **Name**: `fcf-worker`
   - **Root Directory**: `services/worker`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm run start:prod`

3. Add environment variables (see below)

### 5. Optional: Add Redis

1. Click "New" → "Database" → "Add Redis"
2. Use for BullMQ job queue and caching

## Environment Variables

### API Service (`fcf-api`)

```bash
# Database (auto-provided by Railway)
DATABASE_URL=postgresql://...

# JWT Secrets (generate with: openssl rand -base64 32)
JWT_ACCESS_SECRET=<your-secret-here>
JWT_REFRESH_SECRET=<your-secret-here>

# CORS
CORS_ORIGINS=https://your-flutter-web-app.com,http://localhost:3000

# Node
NODE_ENV=production
PORT=3000

# Vendor Integration - ExtendedReach
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=<your-client-id>
EXTENDEDREACH_CLIENT_SECRET=<your-client-secret>

# Vendor Integration - Zoho (if applicable)
ZOHO_BASE_URL=https://www.zohoapis.com
ZOHO_CLIENT_ID=<your-client-id>
ZOHO_CLIENT_SECRET=<your-client-secret>

# Optional: Redis
REDIS_URL=redis://...
```

### Worker Service (`fcf-worker`)

```bash
# Database (same as API)
DATABASE_URL=postgresql://...

# Worker Configuration
WORKER_MODE=true
SYNC_INTERVAL_MINUTES=60

# Vendor Integration (same as API)
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=<your-client-id>
EXTENDEDREACH_CLIENT_SECRET=<your-client-secret>

ZOHO_BASE_URL=https://www.zohoapis.com
ZOHO_CLIENT_ID=<your-client-id>
ZOHO_CLIENT_SECRET=<your-client-secret>

# Node
NODE_ENV=production

# Optional: Redis
REDIS_URL=redis://...
```

## Database Migrations

Run migrations after first deployment:

```bash
# Connect to your Railway project
railway link

# Run migrations
railway run --service fcf-api npm run prisma:migrate:deploy
```

## Monitoring & Logs

- View logs: Railway dashboard → Select service → "Logs" tab
- Metrics: Railway dashboard → Select service → "Metrics" tab
- Database: Railway dashboard → PostgreSQL service → "Data" tab

## Custom Domain (Optional)

1. In Railway dashboard, select API service
2. Go to "Settings" → "Domains"
3. Click "Generate Domain" or add custom domain
4. Update `CORS_ORIGINS` with new domain

## Scaling

Railway auto-scales based on usage. For manual control:
- Go to service → "Settings" → "Resources"
- Adjust memory/CPU limits

## Troubleshooting

### Build Failures
- Check build logs in Railway dashboard
- Ensure `package.json` has correct scripts
- Verify Node version compatibility

### Database Connection Issues
- Verify `DATABASE_URL` is set correctly
- Check Prisma schema matches database
- Run migrations: `railway run npm run prisma:migrate:deploy`

### Worker Not Running Jobs
- Check worker logs for errors
- Verify `WORKER_MODE=true` is set
- Ensure database connection is working

## Backup & Recovery

Railway automatically backs up PostgreSQL databases. To restore:
1. Go to PostgreSQL service → "Backups"
2. Select backup and click "Restore"

## Cost Optimization

- Use Railway's free tier for development
- Upgrade to Pro for production ($5/month + usage)
- Monitor usage in "Usage" tab
- Consider Redis only if needed for performance

