# FCF Platform - Railway Deployment Summary

**Deployment Date:** January 8-9, 2026  
**Environment:** Production  
**Platform:** Railway.app  
**Repository:** https://github.com/oldgraybuzzard/care-access  
**Branch:** develop

---

## 🎉 Deployment Status: SUCCESSFUL ✅

All services are deployed and running successfully on Railway!

---

## 📦 Deployed Services

### 1. PostgreSQL Database ✅
- **Service Name:** Postgres
- **Status:** Running
- **Connection:** Internal + TCP Proxy enabled
- **Migrations:** Applied successfully
- **Seed Data:** Loaded successfully

### 2. API Service ✅
- **Service Name:** @fcf/api
- **Status:** Healthy
- **Root Directory:** `services/api`
- **Builder:** Nixpacks
- **Health Check:** `/health` - Passing
- **Documentation:** `/api` - Swagger UI available

### 3. Worker Service ✅
- **Service Name:** @fcf/worker
- **Status:** Running
- **Root Directory:** `services/worker`
- **Builder:** Nixpacks
- **Sync Interval:** 60 minutes
- **Jobs:** Scheduled and running

---

## 🔧 Configuration Details

### API Service Environment Variables
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
JWT_ACCESS_SECRET=<configured>
JWT_REFRESH_SECRET=<configured>
JWT_ACCESS_EXPIRATION=15m
JWT_REFRESH_EXPIRATION=7d
NODE_ENV=production
PORT=3000
```

### Worker Service Environment Variables
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
NODE_ENV=production
SYNC_INTERVAL_MINUTES=60
WORKER_MODE=true
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=placeholder
EXTENDEDREACH_CLIENT_SECRET=placeholder
ZOHO_BASE_URL=https://www.zohoapis.com
ZOHO_CLIENT_ID=placeholder
ZOHO_CLIENT_SECRET=placeholder
```

---

## 🗄️ Database

### Seeded Data
- ✅ Roles (admin, case_manager, supervisor, viewer)
- ✅ Admin user (admin@fcf.org / admin123)
- ✅ Vendor sources (ExtendedReach, Zoho)
- ✅ Programs
- ✅ Workers
- ✅ Report definitions

### Migrations
- All migrations applied successfully
- Schema version: Latest

---

## 🚀 Key Issues Resolved

1. **Nixpacks Configuration**
   - Changed from `npm ci` to `npm install` (no package-lock.json in monorepo subdirectories)
   - Configured proper build commands in `nixpacks.toml`

2. **Railway Config Conflicts**
   - Removed root `railway.json` to use service-specific configs
   - Each service now has its own `railway.json`

3. **Build Output Path**
   - Fixed start command to use `dist/src/main` instead of `dist/main`
   - NestJS builds to `dist/src/` by default

4. **Container Networking**
   - Changed `app.listen()` to bind to `0.0.0.0` instead of `localhost`
   - Required for Railway health checks to work

5. **Environment Variables**
   - Added all required JWT secrets and database variables
   - Configured worker-specific environment variables

6. **Prisma Schema for Worker**
   - Copied `schema.prisma` from API to worker service
   - Symlinks don't work reliably in Railway deployments

7. **Dockerfile Removal**
   - Removed Dockerfiles in favor of Nixpacks
   - More flexible and handles monorepo structure better

---

## 📝 Login Credentials

**Admin User:**
- Email: `admin@fcf.org`
- Password: `admin123`

⚠️ **Important:** Change the admin password after first login!

---

## 🔗 Service URLs

Get your service URLs from Railway dashboard:
1. Go to Railway → @fcf/api service
2. Settings → Networking → Generate Domain
3. Your API will be available at: `https://your-service.railway.app`

**Endpoints:**
- Health Check: `https://your-service.railway.app/health`
- API Documentation: `https://your-service.railway.app/api`
- Login: `POST https://your-service.railway.app/auth/login`

---

## ⚠️ Important Notes

### Prisma Schema Sync
The worker service has its own copy of `schema.prisma`. When you update the API schema:
```bash
# After updating services/api/prisma/schema.prisma
cp services/api/prisma/schema.prisma services/worker/prisma/schema.prisma
git add services/worker/prisma/schema.prisma
git commit -m "Sync Prisma schema to worker"
git push
```

### Vendor API Credentials
The worker service currently has placeholder credentials for:
- ExtendedReach API
- Zoho API

Update these in Railway → @fcf/worker → Variables when you have the real credentials.

---

## 📊 Next Steps

- [ ] Generate domain for API service
- [ ] Update Flutter app with production API URL
- [ ] Change admin password
- [ ] Add real vendor API credentials
- [ ] Configure monitoring/alerts
- [ ] Set up database backups
- [ ] Disable public networking for worker (optional)
- [ ] Configure custom domain (optional)

---

## 🆘 Troubleshooting

### If API service fails to start:
1. Check environment variables are set correctly
2. Verify DATABASE_URL is connected
3. Check deploy logs for errors

### If worker service fails:
1. Verify Prisma schema exists at `services/worker/prisma/schema.prisma`
2. Check DATABASE_URL is set
3. Review build logs for Prisma generation errors

### If health checks fail:
1. Verify app is listening on `0.0.0.0` not `localhost`
2. Check PORT environment variable
3. Ensure `/health` endpoint exists

---

## 📚 Documentation

- [Railway Setup Checklist](RAILWAY_SETUP_CHECKLIST.md)
- [Railway Quick Reference](RAILWAY_QUICK_REFERENCE.md)
- [Railway Documentation](https://docs.railway.app)

---

**Deployment completed successfully! 🎉**

