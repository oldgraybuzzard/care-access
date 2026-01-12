#!/bin/bash

# Run Flutter app in development mode (local API)

echo "🚀 Starting Flutter app in DEVELOPMENT mode"
echo "📍 API: http://localhost:3001"
echo ""

# Default to chrome if no device specified
DEVICE=${1:-chrome}

flutter run -d $DEVICE \
  --dart-define=ENVIRONMENT=development


