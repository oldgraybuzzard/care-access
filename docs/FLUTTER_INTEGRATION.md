# Flutter App - Production Integration Guide

This guide explains how to run the Flutter app with the production API deployed on Railway.

---

## 🌐 API Environments

The app supports two environments:

### Development (Default)
- **API URL:** `http://localhost:3000`
- **Use when:** Running local API service
- **Logging:** Enabled

### Production
- **API URL:** `https://fcfapi-production.up.railway.app`
- **Use when:** Connecting to Railway deployment
- **Logging:** Disabled

---

## 🚀 Running the App

### Option 1: Development Mode (Local API)

```bash
cd apps/flutter_app

# Run on Chrome (Web)
flutter run -d chrome

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android
```

This will connect to `http://localhost:3000` by default.

---

### Option 2: Production Mode (Railway API)

#### For Web (Chrome):
```bash
cd apps/flutter_app

flutter run -d chrome \
  --dart-define=ENVIRONMENT=production
```

#### For iOS:
```bash
flutter run -d ios \
  --dart-define=ENVIRONMENT=production
```

#### For Android:
```bash
flutter run -d android \
  --dart-define=ENVIRONMENT=production
```

---

### Option 3: Custom API URL

You can override the API URL for any environment:

```bash
flutter run -d chrome \
  --dart-define=API_BASE_URL=https://your-custom-api.com
```

---

## 📱 Building for Release

### Web Build (Production)
```bash
cd apps/flutter_app

flutter build web \
  --dart-define=ENVIRONMENT=production \
  --release
```

Output will be in `build/web/`

### iOS Build (Production)
```bash
flutter build ios \
  --dart-define=ENVIRONMENT=production \
  --release
```

### Android Build (Production)
```bash
flutter build apk \
  --dart-define=ENVIRONMENT=production \
  --release
```

Or for App Bundle:
```bash
flutter build appbundle \
  --dart-define=ENVIRONMENT=production \
  --release
```

---

## 🔐 Login Credentials

### Production (Railway)
- **Email:** `admin@fcf.org`
- **Password:** `admin123`

⚠️ **Important:** Change this password after first login!

### Development (Local)
Same credentials if you've run the seed script locally.

---

## 🧪 Testing the Integration

### 1. Test Login Flow

```bash
# Run in production mode
cd apps/flutter_app
flutter run -d chrome --dart-define=ENVIRONMENT=production
```

1. App should load and show login screen
2. Enter credentials: `admin@fcf.org` / `admin123`
3. Should successfully authenticate and navigate to dashboard

### 2. Check Console Logs

In development mode, you'll see API logs:
```
🌐 API Client initialized
📍 Environment: production
🔗 Base URL: https://fcfapi-production.up.railway.app
🚀 POST /auth/login
✅ 200 /auth/login
```

---

## 🛠️ Configuration Files

### `lib/core/config/app_config.dart`
Manages environment configuration:
- API base URLs
- Timeouts
- Logging settings

### `lib/core/api/api_client.dart`
Dio HTTP client with:
- Automatic token injection
- Token refresh on 401
- Request/response logging (dev only)

---

## 🔧 Troubleshooting

### Issue: "Connection refused" or "Network error"

**Solution:**
1. Check if you're using the correct environment flag
2. Verify the API URL in console logs
3. Test the API directly:
   ```bash
   curl https://fcfapi-production.up.railway.app/health
   ```

### Issue: "401 Unauthorized" after login

**Solution:**
1. Check if credentials are correct
2. Verify database was seeded on Railway
3. Check API logs in Railway dashboard

### Issue: CORS errors (Web only)

**Solution:**
The API should already have CORS enabled. If you see CORS errors:
1. Check Railway API logs
2. Verify the API's CORS configuration includes your origin

### Issue: Token refresh not working

**Solution:**
1. Check secure storage is working
2. Verify refresh token endpoint exists: `/auth/refresh`
3. Check API logs for refresh errors

---

## 📊 API Endpoints

The app uses these main endpoints:

- `POST /auth/login` - User authentication
- `POST /auth/refresh` - Token refresh
- `GET /programs` - List programs
- `GET /workers` - List workers
- `GET /clients` - Search clients
- `GET /cases` - Get cases
- `GET /reports` - Generate reports

View all endpoints at: https://fcfapi-production.up.railway.app/api

---

## 🎯 Next Steps

1. **Test the app** with production API
2. **Update branding** (app name, icons, colors)
3. **Add error handling** for network failures
4. **Implement offline mode** (optional)
5. **Add analytics** (optional)
6. **Submit to app stores** (iOS/Android)

---

## 📝 Development Tips

### Hot Reload
Flutter's hot reload works in all modes. Just save your files!

### Switching Environments
You can switch between dev and prod by restarting with different flags:

```bash
# Development
flutter run -d chrome

# Production  
flutter run -d chrome --dart-define=ENVIRONMENT=production
```

### Debugging API Calls
Set `enableLogging: true` in `AppConfig.production` temporarily to see API logs in production mode.

---

**Happy coding! 🚀**

