# Railway Quick Reference

## 🚀 Quick Setup Checklist

### 1. Create Services in Railway

- [ ] PostgreSQL Database
- [ ] API Service (root: `services/api`)
- [ ] Worker Service (root: `services/worker`)

### 2. API Service Environment Variables

```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
JWT_SECRET=<generate-secure-random-string>
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
NODE_ENV=production
PORT=3000
```

**Generate JWT_SECRET:**
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### 3. Worker Service Environment Variables

```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
SYNC_INTERVAL_MINUTES=60
NODE_ENV=production
EXTENDEDREACH_BASE_URL=https://api.extendedreach.com
EXTENDEDREACH_CLIENT_ID=<your-client-id>
EXTENDEDREACH_CLIENT_SECRET=<your-client-secret>
```

### 4. Seed Database

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and link
railway login
railway link

# Select API service and run seed
railway run npm run seed
```

### 5. Verify Deployment

- API Health: `https://your-api.up.railway.app/health`
- API Docs: `https://your-api.up.railway.app/api`
- Check logs in Railway dashboard

## 📋 Service Configuration

### API Service Settings
- **Root Directory**: `services/api`
- **Build Command**: Auto (from railway.json)
- **Start Command**: Auto (from railway.json)
- **Health Check**: `/health`

### Worker Service Settings
- **Root Directory**: `services/worker`
- **Build Command**: Auto (from railway.json)
- **Start Command**: Auto (from railway.json)
- **Public Networking**: Can be disabled

## 🔗 Important Links

- **Railway Dashboard**: https://railway.app/dashboard
- **GitHub Repo**: https://github.com/oldgraybuzzard/care-access
- **Full Setup Guide**: [docs/RAILWAY_SETUP.md](docs/RAILWAY_SETUP.md)

## 🐛 Common Issues

### Build Fails
- Check root directory is set correctly
- Verify railway.json exists in service directory
- Check build logs for errors

### Database Connection Error
- Ensure PostgreSQL service is linked
- Verify DATABASE_URL is set
- Check database is running

### Migrations Don't Run
- API service runs migrations automatically on deploy
- Check logs for migration errors
- Manually run: `railway run npx prisma migrate deploy`

## 📊 Monitoring

- **Logs**: Service → Deployments → View Logs
- **Metrics**: Service → Metrics
- **Database**: PostgreSQL → Data tab

## 🔄 Deployment Flow

```
Push to develop branch
    ↓
Railway detects change
    ↓
Build services (API + Worker)
    ↓
Run migrations (API only)
    ↓
Deploy new versions
    ↓
Health check passes
    ↓
✅ Live!
```

## 💡 Pro Tips

1. **Use Railway CLI** for quick debugging and running commands
2. **Link services** to share environment variables
3. **Monitor logs** during first deployment
4. **Set up alerts** for production
5. **Use staging environment** for testing before production

## 📞 Support

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- Project Docs: [docs/](docs/)

