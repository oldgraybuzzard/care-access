# Railway Setup Checklist

Use this checklist to deploy the FCF Platform to Railway step by step.

## 📋 Important Notes

- ✅ **Nixpacks Configuration**: Both `services/api/nixpacks.toml` and `services/worker/nixpacks.toml` are configured
- ✅ **Prisma Setup**: Database migrations run automatically on API deployment
- ✅ **Monorepo Support**: Each service has its own root directory configuration

## ✅ Pre-Deployment

- [x] GitHub repository created: `oldgraybuzzard/care-access`
- [x] Code pushed to `develop` branch
- [x] Railway account connected to GitHub
- [x] Nixpacks configuration files created
- [ ] ExtendedReach API credentials obtained
- [ ] Zoho API credentials obtained (optional)

## 📦 Step 1: Create Railway Project

- [x] Go to https://railway.app/dashboard
- [x] Click "New Project"
- [x] Select "Deploy from GitHub repo"
- [x] Choose `oldgraybuzzard/care-access`
- [x] Select `develop` branch

## 🗄️ Step 2: Add PostgreSQL Database

- [x] In Railway project, click "+ New"
- [x] Select "Database" → "Add PostgreSQL"
- [x] Wait for database to provision
- [x] Note: DATABASE_URL is automatically created

## 🔧 Step 3: Deploy API Service ✅ COMPLETE

### Create Service
- [x] Click "+ New" → "GitHub Repo"
- [x] Select `oldgraybuzzard/care-access`
- [x] Service is created

### Configure Service
- [x] Click on service → "Settings"
- [x] Rename to "@fcf/api"
- [x] Set Root Directory: `services/api`
- [x] Set Watch Paths: `services/api/**`
- [x] Build and start commands are auto-detected from `nixpacks.toml`

### Link Database
- [x] Go to "Service" tab
- [x] Click "Connect" under PostgreSQL
- [x] DATABASE_URL is now available

### Set Environment Variables
- [x] Go to "Variables" tab
- [x] Add the following variables:

```
DATABASE_URL=${{Postgres.DATABASE_URL}}
JWT_ACCESS_SECRET=<paste-generated-secret-here>
JWT_REFRESH_SECRET=<paste-generated-secret-here>
JWT_ACCESS_EXPIRATION=15m
JWT_REFRESH_EXPIRATION=7d
NODE_ENV=production
PORT=3000
```

**Generate JWT secrets:**
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

- [x] JWT secrets generated and added
- [x] All variables configured

### Deploy
- [x] Click "Deploy" or wait for auto-deploy
- [x] Monitor deployment logs
- [x] Wait for "✅ Deployment successful"

### Verify API
- [x] Click "Deployments" → Copy domain URL
- [x] Visit: `https://your-api.up.railway.app/health`
- [x] Should return: `{"status":"ok"}`
- [x] Visit: `https://your-api.up.railway.app/api`
- [x] Swagger docs should load

## ⚙️ Step 4: Deploy Worker Service ✅ COMPLETE

### Create Service
- [x] Click "+ New" → "GitHub Repo"
- [x] Select `oldgraybuzzard/care-access` again
- [x] Second service is created

### Configure Service
- [x] Click on service → "Settings"
- [x] Rename to "@fcf/worker"
- [x] Set Root Directory: `services/worker`
- [x] Set Watch Paths: `services/worker/**`
- [x] Build and start commands are auto-detected from `nixpacks.toml`

### Link Database
- [x] Go to "Service" tab
- [x] Click "Connect" under PostgreSQL
- [x] DATABASE_URL is now available

### Set Environment Variables
- [x] Go to "Variables" tab
- [x] Add the following variables:

```
DATABASE_URL=${{Postgres.DATABASE_URL}}
SYNC_INTERVAL_MINUTES=60
NODE_ENV=production
WORKER_MODE=true
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=placeholder
EXTENDEDREACH_CLIENT_SECRET=placeholder
ZOHO_BASE_URL=https://www.zohoapis.com
ZOHO_CLIENT_ID=placeholder
ZOHO_CLIENT_SECRET=placeholder
```

- [x] All variables configured
- [x] Vendor credentials added (placeholders for now)

### Deploy
- [x] Click "Deploy" or wait for auto-deploy
- [x] Monitor deployment logs
- [x] Wait for "✅ Deployment successful"

### Verify Worker
- [x] Click "Deployments" → "View Logs"
- [x] Should see: "🔧 FCF Platform Worker Service starting..."
- [x] Should see: "✅ Worker service is running"

## 🌱 Step 5: Seed Database ✅ COMPLETE

### Option A: Using Railway CLI
```bash
# Install CLI
npm i -g @railway/cli

# Login
railway login

# Link to project
railway link

# Select API service
railway service

# Run seed
railway run npm run seed
```

- [x] Railway CLI installed
- [x] Logged in and linked
- [x] Seed command executed
- [x] Seed successful

### Option B: Using Local Connection (USED)
```bash
# Get DATABASE_URL from Railway PostgreSQL service
cd services/api
DATABASE_URL="postgresql://postgres:...@metro.proxy.rlwy.net:37708/railway" npm run prisma:seed
```

- [x] DATABASE_URL copied from Railway
- [x] Seed command executed locally
- [x] Seed successful

**Seed Results:**
- ✅ Roles created
- ✅ Admin user created (admin@fcf.org / admin123)
- ✅ Vendor source created
- ✅ Programs created
- ✅ Workers created
- ✅ Report definitions created

## 🧪 Step 6: Test the Deployment

### Test API Endpoints
- [ ] Health check: `GET /health`
- [ ] Login: `POST /auth/login` with admin@fcf.org / admin123
- [ ] Get clients: `GET /clients` (with auth token)
- [ ] Swagger docs accessible

### Test Worker
- [ ] Check logs for sync job execution
- [ ] Verify data is being synced (if vendor APIs configured)
- [ ] Check KPI rollup job logs

### Test Database
- [ ] Go to PostgreSQL service → "Data"
- [ ] Verify tables exist
- [ ] Check seed data is present (users, programs, workers)

## 🔍 Step 7: Configure Monitoring

- [ ] Set up deployment notifications
  - [ ] Go to Project Settings → "Integrations"
  - [ ] Add Slack/Discord/Email
- [ ] Enable metrics monitoring
  - [ ] Check each service → "Metrics"
- [ ] Set up log retention
  - [ ] Configure log settings if needed

## 🌐 Step 8: Configure Domain (Optional)

### API Service
- [ ] Go to API service → "Settings" → "Networking"
- [ ] Click "Generate Domain" (free Railway domain)
- [ ] Or add custom domain
- [ ] Update Flutter app API_BASE_URL

### Worker Service
- [ ] Disable public networking (not needed)
- [ ] Go to "Settings" → "Networking"
- [ ] Toggle off "Public Networking"

## 📝 Step 9: Update Documentation

- [ ] Save API URL in team documentation
- [ ] Update Flutter app configuration with production API URL
- [ ] Document environment variables
- [ ] Share credentials securely with team

## ✅ Final Verification

- [ ] API service is running
- [ ] Worker service is running
- [ ] Database is accessible
- [ ] Migrations completed successfully
- [ ] Seed data loaded
- [ ] Health checks passing
- [ ] Logs show no errors
- [ ] Auto-deployment working (push to develop triggers deploy)

## 🎉 Deployment Complete!

Your FCF Platform is now live on Railway!

- **API URL**: https://your-api.up.railway.app
- **Swagger Docs**: https://your-api.up.railway.app/api
- **GitHub**: https://github.com/oldgraybuzzard/care-access

## 📚 Next Steps

- [ ] Configure Flutter app with production API URL
- [ ] Set up staging environment (optional)
- [ ] Configure database backups
- [ ] Set up error tracking (Sentry)
- [ ] Add CI/CD with GitHub Actions
- [ ] Perform load testing
- [ ] User acceptance testing

## 🆘 Need Help?

- See [docs/RAILWAY_SETUP.md](docs/RAILWAY_SETUP.md) for detailed guide
- See [RAILWAY_QUICK_REFERENCE.md](RAILWAY_QUICK_REFERENCE.md) for quick tips
- Check Railway docs: https://docs.railway.app
- Join Railway Discord: https://discord.gg/railway

