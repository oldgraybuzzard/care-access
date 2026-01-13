# FCF Platform - Production URLs & Testing Guide

**Deployment Date:** January 9, 2026  
**Environment:** Production (Railway)

---

## 🌐 Service URLs

### API Service
- **Base URL:** `https://fcfapi-production.up.railway.app`
- **Health Check:** `https://fcfapi-production.up.railway.app/health`
- **API Documentation:** `https://fcfapi-production.up.railway.app/api`
- **Status:** ✅ Healthy

### Worker Service
- **URL:** `https://fcfworker-production.up.railway.app` (public access not needed)
- **Status:** ✅ Running
- **Recommendation:** Disable public networking for security

### Database
- **Internal URL:** `fcfapi.railway.internal` (private networking)
- **Status:** ✅ Connected

---

## 🧪 API Testing

### 1. Health Check
```bash
curl https://fcfapi-production.up.railway.app/health
```

**Expected Response:**
```json
{
  "status": "ok",
  "timestamp": "2026-01-09T03:16:12.450Z",
  "database": "connected"
}
```

✅ **Verified Working**

---

### 2. Login (Authentication)
```bash
curl -X POST https://fcfapi-production.up.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@fcf.org",
    "password": "admin123"
  }'
```

**Expected Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "0413bced-a659-46ef-9288-a60ba310aac3",
    "email": "admin@fcf.org",
    "name": "Admin User",
    "roles": ["admin"]
  }
}
```

✅ **Verified Working**

---

### 3. Using the Access Token

Save the access token from the login response and use it in subsequent requests:

```bash
# Set the token (replace with your actual token)
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Make authenticated requests
curl https://fcfapi-production.up.railway.app/programs \
  -H "Authorization: Bearer $TOKEN"
```

---

## 📚 API Documentation

Open in your browser:
**https://fcfapi-production.up.railway.app/api**

This will show the interactive Swagger UI with all available endpoints.

---

## 🔐 Default Credentials

**Admin User:**
- Email: `admin@fcf.org`
- Password: `admin123`

⚠️ **IMPORTANT:** Change this password immediately after first login!

---

## 🔧 For Flutter App Integration

Update your Flutter app's API configuration:

```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://fcfapi-production.up.railway.app';
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String programs = '/programs';
  static const String workers = '/workers';
  static const String reports = '/reports';
}
```

---

## 🛡️ Security Recommendations

### 1. Disable Worker Public Access
The worker service doesn't need to be publicly accessible:

1. Go to Railway → **@fcf/worker** service
2. Settings → Networking
3. Toggle **OFF** "Public Networking"
4. Worker will still communicate with database via private networking

### 2. Change Admin Password
```bash
# Login first to get token
TOKEN=$(curl -s -X POST https://fcfapi-production.up.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@fcf.org","password":"admin123"}' | jq -r '.accessToken')

# Change password (check API docs for exact endpoint)
curl -X PATCH https://fcfapi-production.up.railway.app/users/me/password \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "currentPassword": "admin123",
    "newPassword": "your-secure-password"
  }'
```

### 3. Update Vendor API Credentials
Go to Railway → **@fcf/worker** → Variables and update:
- `EXTENDEDREACH_CLIENT_ID`
- `EXTENDEDREACH_CLIENT_SECRET`
- `ZOHO_CLIENT_ID`
- `ZOHO_CLIENT_SECRET`

---

## 📊 Monitoring

### Check Service Health
```bash
# API Health
curl https://fcfapi-production.up.railway.app/health

# Check if worker is running (view logs in Railway dashboard)
# Railway → @fcf/worker → Deployments → View Logs
```

### View Logs
1. Go to Railway dashboard
2. Click on service (@fcf/api or @fcf/worker)
3. Click "Deployments"
4. Click "View Logs"

---

## 🚨 Troubleshooting

### API Returns 502/503
- Check Railway dashboard for service status
- View deployment logs for errors
- Verify DATABASE_URL is connected

### Authentication Fails
- Verify credentials are correct
- Check if database was seeded properly
- View API logs for error details

### Worker Not Syncing
- Check worker logs in Railway
- Verify vendor API credentials are set
- Check SYNC_INTERVAL_MINUTES setting

---

## 📝 Next Steps

- [ ] Test all API endpoints via Swagger UI
- [ ] Disable public networking for worker service
- [ ] Change admin password
- [ ] Update Flutter app with production URL
- [ ] Add real vendor API credentials
- [ ] Test end-to-end flow with Flutter app
- [ ] Set up monitoring/alerts (optional)
- [ ] Configure custom domain (optional)

---

**All systems operational! 🚀**

