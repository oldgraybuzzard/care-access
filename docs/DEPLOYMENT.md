# Deployment Guide

## Railway Deployment

### Prerequisites

- Railway account
- GitHub repository connected to Railway
- PostgreSQL addon enabled

### 1. Database Setup

1. Create a new PostgreSQL database in Railway
2. Note the connection string from the database settings
3. Set the `DATABASE_URL` environment variable in all services

### 2. API Service Deployment

1. Create a new service in Railway
2. Connect to your GitHub repository
3. Set the root directory to `services/api`
4. Configure environment variables:
   ```
   DATABASE_URL=<from Railway Postgres>
   JWT_SECRET=<generate-secure-random-string>
   JWT_EXPIRES_IN=15m
   JWT_REFRESH_EXPIRES_IN=7d
   PORT=3000
   NODE_ENV=production
   ```
5. Add build command: `npm install && npx prisma generate && npm run build`
6. Add start command: `npm run start:prod`
7. Deploy

### 3. Worker Service Deployment

1. Create another service in Railway
2. Connect to the same GitHub repository
3. Set the root directory to `services/worker`
4. Configure environment variables:
   ```
   DATABASE_URL=<same as API>
   SYNC_INTERVAL_MINUTES=60
   EXTENDEDREACH_BASE_URL=<vendor-api-url>
   EXTENDEDREACH_CLIENT_ID=<vendor-client-id>
   EXTENDEDREACH_CLIENT_SECRET=<vendor-client-secret>
   NODE_ENV=production
   ```
5. Add build command: `npm install && npx prisma generate && npm run build`
6. Add start command: `npm run start:prod`
7. Deploy

### 4. Database Migrations

After deploying the API service:

```bash
# From your local machine
cd services/api
DATABASE_URL=<railway-database-url> npx prisma migrate deploy
DATABASE_URL=<railway-database-url> npm run seed
```

### 5. Flutter App Deployment

#### iOS (App Store)

1. Update `apps/flutter_app/ios/Runner/Info.plist` with production API URL
2. Build release:
   ```bash
   cd apps/flutter_app
   flutter build ios --release
   ```
3. Open Xcode and archive
4. Upload to App Store Connect

#### Android (Google Play)

1. Update `apps/flutter_app/android/app/src/main/AndroidManifest.xml`
2. Build release:
   ```bash
   cd apps/flutter_app
   flutter build appbundle --release
   ```
3. Upload to Google Play Console

#### Web

1. Build web version:
   ```bash
   cd apps/flutter_app
   flutter build web --release
   ```
2. Deploy `build/web` to Railway static hosting or Vercel

## Environment-Specific Configuration

### Development
- Local PostgreSQL
- Mock vendor integrations
- Debug logging enabled

### Staging
- Railway PostgreSQL
- Sandbox vendor APIs
- Info logging

### Production
- Railway PostgreSQL with backups
- Production vendor APIs
- Error logging only
- Rate limiting enabled
- CORS restricted to app domains

## Monitoring

### Railway Dashboard
- View logs for each service
- Monitor resource usage
- Set up alerts for errors

### Database Backups
- Enable automatic backups in Railway
- Schedule: Daily at 2 AM UTC
- Retention: 7 days

### Health Checks

API health endpoint: `https://your-api.railway.app/health`

Expected response:
```json
{
  "status": "ok",
  "database": "connected",
  "timestamp": "2024-01-08T12:00:00Z"
}
```

## Rollback Procedure

1. In Railway dashboard, go to the service
2. Click on "Deployments"
3. Find the last working deployment
4. Click "Redeploy"

## Troubleshooting

### Database Connection Issues
- Verify `DATABASE_URL` is set correctly
- Check Railway PostgreSQL is running
- Verify network connectivity

### Migration Failures
- Check migration files for errors
- Verify database schema state
- Run `npx prisma migrate resolve` if needed

### Worker Not Running
- Check environment variables
- Verify cron schedule syntax
- Check logs for errors

## Security Checklist

- [ ] JWT_SECRET is a strong random string
- [ ] Database credentials are secure
- [ ] CORS is configured for production domains only
- [ ] Rate limiting is enabled
- [ ] Audit logging is active
- [ ] HTTPS is enforced
- [ ] Environment variables are not committed to git

