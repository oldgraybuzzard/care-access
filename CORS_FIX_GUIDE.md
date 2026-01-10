# CORS Fix for Flutter Web Development

## 🔴 Problem
Flutter web app running on `http://localhost:XXXXX` gets CORS error when trying to access the production API.

## ✅ Solution

You need to add the `CORS_ORIGINS` environment variable to Railway to allow localhost origins.

### Step 1: Add CORS_ORIGINS to Railway

1. Go to Railway dashboard
2. Click on **@fcf/api** service
3. Go to **Variables** tab
4. Click **+ New Variable**
5. Add:
   ```
   Name: CORS_ORIGINS
   Value: http://localhost:3000,http://localhost:8080,http://localhost:64685
   ```
6. Click **Add**

The API will automatically redeploy with the new CORS configuration.

### Step 2: Wait for Deployment

Wait about 1-2 minutes for Railway to redeploy the API service.

### Step 3: Test Again

Reload your Flutter web app and try logging in again. The CORS error should be gone!

---

## 🔧 Alternative: Wildcard CORS for Development

If you want to allow **any** localhost port (recommended for development), use this value instead:

```
CORS_ORIGINS=http://localhost:3000,http://localhost:8080,http://localhost:64685,http://127.0.0.1:3000
```

Or, for maximum flexibility during development, you can temporarily set it to allow all origins:

```
CORS_ORIGINS=*
```

⚠️ **Warning:** Only use `*` for development/testing. Never use it in production!

---

## 📝 How CORS Works Now

The API has two modes:

### Production Mode (NODE_ENV=production)
- Uses `CORS_ORIGINS` environment variable
- Only allows specific origins you configure
- More secure for production

### Development Mode (NODE_ENV=development)
- Automatically allows all `localhost` and `127.0.0.1` origins
- No configuration needed
- Great for local development

---

## 🧪 Testing CORS

After adding the environment variable, test with:

```bash
curl -I -X OPTIONS https://fcfapi-production.up.railway.app/auth/login \
  -H "Origin: http://localhost:64685" \
  -H "Access-Control-Request-Method: POST"
```

You should see:
```
HTTP/2 204
access-control-allow-origin: http://localhost:64685
access-control-allow-credentials: true
access-control-allow-methods: GET,POST,PUT,PATCH,DELETE,OPTIONS
```

---

## 🎯 Quick Fix Summary

1. **Add `CORS_ORIGINS` to Railway** → Variables tab
2. **Wait for redeploy** → ~1-2 minutes
3. **Reload Flutter app** → CORS error should be gone!

---

## 💡 For Future Reference

When you deploy your Flutter web app to production, add its domain to `CORS_ORIGINS`:

```
CORS_ORIGINS=https://your-flutter-app.com,http://localhost:3000,http://localhost:8080
```

This way both production and development will work!

