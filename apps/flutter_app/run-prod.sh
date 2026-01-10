#!/bin/bash

# Run Flutter app in production mode (Railway API)

echo "🚀 Starting Flutter app in PRODUCTION mode"
echo "📍 API: https://fcfapi-production.up.railway.app"
echo ""

# Default to chrome if no device specified
DEVICE=${1:-chrome}

flutter run -d $DEVICE \
  --dart-define=ENVIRONMENT=production


