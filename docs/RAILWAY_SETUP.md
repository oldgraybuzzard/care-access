# Railway Deployment Setup Guide

## Overview

This guide will help you deploy the FCF Platform to Railway with:
- PostgreSQL Database
- API Service (NestJS)
- Worker Service (NestJS)

### Build Configuration

The project uses **Nixpacks** for building on Railway:
- ✅ `services/api/nixpacks.toml` - API service build configuration
- ✅ `services/worker/nixpacks.toml` - Worker service build configuration
- ✅ Automatic Prisma migrations on API deployment
- ✅ Monorepo support with separate root directories

## Step 1: Create a New Project

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose **`oldgraybuzzard/care-access`**
5. Select the **`develop`** branch

## Step 2: Add PostgreSQL Database

1. In your Railway project, click **"+ New"**
2. Select **"Database"** → **"Add PostgreSQL"**
3. Railway will automatically create a PostgreSQL instance
4. Note: The `DATABASE_URL` will be automatically available as an environment variable

## Step 3: Deploy API Service

### 3.1 Create API Service

1. Click **"+ New"** → **"GitHub Repo"**
2. Select **`oldgraybuzzard/care-access`**
3. Railway will detect it's a monorepo

### 3.2 Configure API Service

1. Click on the service → **"Settings"**
2. Rename service to **"api"** (optional, for clarity)
3. Set **Root Directory**: `services/api`
4. Set **Watch Paths**: `services/api/**` (optional, to only redeploy on API changes)
5. Build and start commands are automatically detected from `nixpacks.toml`

### 3.3 Set Environment Variables

Go to **"Variables"** tab and add:

```bash
# Database (automatically set by Railway if you linked the database)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# JWT Configuration
JWT_SECRET=<generate-a-secure-random-string-here>
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# Node Environment
NODE_ENV=production
PORT=3000

# Optional: Redis (if you add Redis service)
# REDIS_URL=${{Redis.REDIS_URL}}
```

**Important**: Generate a secure JWT_SECRET:
```bash
# Run this locally to generate a secure secret
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### 3.4 Link Database

1. In the API service settings, go to **"Service"** tab
2. Click **"Connect"** under the PostgreSQL database
3. This will automatically add `DATABASE_URL` to your environment variables

### 3.5 Deploy

1. Click **"Deploy"** or push to the `develop` branch
2. Railway will automatically:
   - Install dependencies
   - Generate Prisma Client
   - Build the application
   - Run migrations (`npx prisma migrate deploy`)
   - Start the server

## Step 4: Deploy Worker Service

### 4.1 Create Worker Service

1. Click **"+ New"** → **"GitHub Repo"**
2. Select **`oldgraybuzzard/care-access`** again
3. This creates a second service from the same repo

### 4.2 Configure Worker Service

1. Click on the service → **"Settings"**
2. Rename service to **"worker"** (for clarity)
3. Set **Root Directory**: `services/worker`
4. Set **Watch Paths**: `services/worker/**,services/api/prisma/**` (to redeploy on worker or schema changes)
5. Build and start commands are automatically detected from `nixpacks.toml`

### 4.3 Set Environment Variables

Go to **"Variables"** tab and add:

```bash
# Database (link to the same PostgreSQL)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Worker Configuration
SYNC_INTERVAL_MINUTES=60
NODE_ENV=production

# ExtendedReach Integration
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=<your-client-id>
EXTENDEDREACH_CLIENT_SECRET=<your-client-secret>

# Zoho Integration (optional)
ZOHO_BASE_URL=https://www.zohoapis.com
ZOHO_CLIENT_ID=<your-client-id>
ZOHO_CLIENT_SECRET=<your-client-secret>

# Optional: Redis
# REDIS_URL=${{Redis.REDIS_URL}}
```

### 4.4 Link Database

1. In the Worker service settings, go to **"Service"** tab
2. Click **"Connect"** under the PostgreSQL database
3. This ensures the worker uses the same database as the API

### 4.5 Deploy

1. Click **"Deploy"**
2. Railway will build and start the worker service

## Step 5: Seed the Database

After the API service is deployed and migrations have run:

### Option 1: Using Railway CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Select the API service
railway service

# Run seed command
railway run npm run seed
```

### Option 2: Using Local Connection

```bash
# Get the DATABASE_URL from Railway
# Go to PostgreSQL service → Connect → Copy DATABASE_URL

# Run seed locally
cd services/api
DATABASE_URL="<railway-database-url>" npm run seed
```

## Step 6: Configure Custom Domain (Optional)

### For API Service:

1. Go to API service → **"Settings"** → **"Networking"**
2. Click **"Generate Domain"** (Railway provides a free domain)
3. Or add your custom domain

### For Worker Service:

- Worker doesn't need a public domain (it's a background service)
- You can disable public networking if desired

## Step 7: Verify Deployment

### Check API Service:

1. Visit your Railway-provided URL (e.g., `https://your-api.up.railway.app`)
2. Check health endpoint: `https://your-api.up.railway.app/health`
3. Check Swagger docs: `https://your-api.up.railway.app/api`

### Check Worker Service:

1. Go to Worker service → **"Deployments"** → **"Logs"**
2. You should see:
   ```
   🔧 FCF Platform Worker Service starting...
   📅 Sync interval: 60 minutes
   ✅ Worker service is running
   ```

### Check Database:

1. Go to PostgreSQL service → **"Data"**
2. You should see all tables created by Prisma migrations

## Step 8: Monitor and Maintain

### View Logs:

- Click on each service → **"Deployments"** → Select deployment → **"View Logs"**

### Monitor Resources:

- Click on each service → **"Metrics"**
- Monitor CPU, Memory, and Network usage

### Set Up Alerts:

- Go to Project Settings → **"Integrations"**
- Add Slack, Discord, or email notifications

## Environment Variables Reference

### API Service Required Variables:
- `DATABASE_URL` - PostgreSQL connection (auto-set when linked)
- `JWT_SECRET` - Secret for JWT tokens (generate securely)
- `JWT_EXPIRES_IN` - Access token expiration (e.g., "15m")
- `JWT_REFRESH_EXPIRES_IN` - Refresh token expiration (e.g., "7d")
- `NODE_ENV` - Set to "production"

### Worker Service Required Variables:
- `DATABASE_URL` - PostgreSQL connection (auto-set when linked)
- `SYNC_INTERVAL_MINUTES` - How often to sync (e.g., 60)
- `EXTENDEDREACH_BASE_URL` - Vendor API URL
- `EXTENDEDREACH_CLIENT_ID` - Vendor OAuth client ID
- `EXTENDEDREACH_CLIENT_SECRET` - Vendor OAuth secret
- `NODE_ENV` - Set to "production"

## Troubleshooting

### Build Fails:

- Check **"Deployments"** → **"Build Logs"**
- Ensure `railway.json` is in the correct directory
- Verify `package.json` has all required scripts

### Migration Fails:

- Check if DATABASE_URL is set correctly
- Ensure PostgreSQL service is running
- Check migration files for errors

### Worker Not Running Jobs:

- Check Worker logs for errors
- Verify cron schedule is correct
- Ensure DATABASE_URL is accessible

### API Returns 500 Errors:

- Check API logs for stack traces
- Verify all environment variables are set
- Check database connection

## Automatic Deployments

Railway automatically deploys when you push to the `develop` branch:

```bash
# Make changes locally
git add .
git commit -m "Your changes"
git push origin develop

# Railway will automatically:
# 1. Detect the push
# 2. Build both services
# 3. Run migrations (API only)
# 4. Deploy new versions
```

## Rollback

If a deployment fails:

1. Go to service → **"Deployments"**
2. Find the last working deployment
3. Click **"⋮"** → **"Redeploy"**

## Cost Optimization

- **Starter Plan**: $5/month includes $5 credit
- **Database**: ~$5/month for PostgreSQL
- **Services**: Pay for what you use
- **Tip**: Use Railway's sleep feature for non-production environments

## Next Steps

1. ✅ Set up monitoring and alerts
2. ✅ Configure custom domain
3. ✅ Set up staging environment (optional)
4. ✅ Configure backups for PostgreSQL
5. ✅ Add CI/CD with GitHub Actions (optional)

