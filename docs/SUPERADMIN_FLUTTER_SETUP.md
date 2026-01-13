# SuperAdmin Flutter App Setup Guide

## Problem

The Flutter app is trying to connect to **production** (`https://fcfapi-production.up.railway.app`), but the SuperAdmin user only exists in the **local database**.

## Solution: Run Flutter App in Development Mode

### Option 1: Using the Helper Script (Recommended)

```bash
cd apps/flutter_app
./run-dev.sh chrome
```

This will:
- Start the Flutter app in development mode
- Connect to local API at `http://127.0.0.1:3001`
- Enable logging for debugging

### Option 2: Manual Command

```bash
cd apps/flutter_app
flutter run -d chrome --dart-define=ENVIRONMENT=development
```

### Option 3: For iOS Simulator

```bash
cd apps/flutter_app
./run-dev.sh ios
# or
flutter run -d "iPhone 15 Pro" --dart-define=ENVIRONMENT=development
```

### Option 4: For Android Emulator

```bash
cd apps/flutter_app
./run-dev.sh android
# or
flutter run -d android --dart-define=ENVIRONMENT=development
```

---

## Verify Local API is Running

Before running the Flutter app, make sure the local API server is running:

```bash
# Check if API is running
curl http://localhost:3001/health

# If not running, start it:
cd services/api
npm run start:dev
```

---

## SuperAdmin Login Credentials

Once the app is running in development mode, use these credentials:

- **Email:** `admin@melkentechwork.com`
- **Password:** `SuperAdmin123!`

---

## Troubleshooting

### Issue: "Unable to sign in"

**Cause:** Flutter app is connecting to production instead of local API.

**Solution:** Make sure you're running with `--dart-define=ENVIRONMENT=development`

### Issue: "Connection refused"

**Cause:** Local API server is not running.

**Solution:**
```bash
cd services/api
npm run start:dev
```

### Issue: "Invalid credentials"

**Cause:** SuperAdmin user doesn't exist in the database.

**Solution:**
```bash
cd services/api
npx prisma db seed
```

---

## Deploying SuperAdmin to Production (Optional)

If you want to use the SuperAdmin account in production:

### Step 1: Deploy Updated Code

```bash
git add -A
git commit -m "Add SuperAdmin user to seed script"
git push origin main
```

### Step 2: Run Seed Script on Railway

1. Go to Railway dashboard
2. Select your API service
3. Go to "Settings" → "Variables"
4. Add a new variable: `RUN_SEED=true`
5. Redeploy the service

Or run manually via Railway CLI:

```bash
railway run npx prisma db seed
```

### Step 3: Test Production Login

```bash
curl -X POST https://fcfapi-production.up.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@melkentechwork.com","password":"SuperAdmin123!"}'
```

---

## Environment Configuration Summary

### Development Mode
- **API URL:** `http://127.0.0.1:3001`
- **Logging:** Enabled
- **Database:** Local PostgreSQL
- **SuperAdmin:** ✅ Available

### Production Mode
- **API URL:** `https://fcfapi-production.up.railway.app`
- **Logging:** Disabled
- **Database:** Railway PostgreSQL
- **SuperAdmin:** ❌ Not yet deployed (needs seed script)

---

## Quick Reference

### Start Everything Locally

```bash
# Terminal 1: Start API
cd services/api
npm run start:dev

# Terminal 2: Start Flutter App
cd apps/flutter_app
./run-dev.sh chrome
```

### Login as SuperAdmin

1. Open app in browser (should auto-open)
2. Enter email: `admin@melkentechwork.com`
3. Enter password: `SuperAdmin123!`
4. Click "Sign In"

### Expected Behavior

- ✅ SuperAdmin can access platform management
- ✅ SuperAdmin can view all organizations
- ❌ SuperAdmin **cannot** access children, cases, or clients
- ❌ SuperAdmin **cannot** access organizational data

---

## Next Steps

1. **Test locally** with development mode
2. **Verify** SuperAdmin can login and access platform endpoints
3. **Deploy** to production when ready
4. **Change** SuperAdmin password in production

---

**Status:** ✅ Local development ready  
**Production:** 🔄 Pending deployment

