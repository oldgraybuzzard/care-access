#!/bin/bash

# Restart Flutter app in development mode

echo "🛑 Stopping any running Flutter processes..."
pkill -f "flutter run" || true
pkill -f "dart.*flutter_tools" || true
sleep 2

echo ""
echo "🚀 Starting Flutter app in DEVELOPMENT mode"
echo "📍 API: http://127.0.0.1:3001"
echo ""
echo "🔐 Demo Login Credentials:"
echo ""
echo "   Foster Care Foundation Admin:"
echo "   Email: admin@fcf.org"
echo "   Password: admin123"
echo ""
echo "   CareAccess Demo Admin:"
echo "   Email: admin@careaccess-demo.com"
echo "   Password: password123"
echo ""
echo "   Platform SuperAdmin:"
echo "   Email: admin@melkentechwork.com"
echo "   Password: SuperAdmin123!"
echo ""

# Default to chrome if no device specified
DEVICE=${1:-chrome}

flutter run -d $DEVICE \
  --dart-define=ENVIRONMENT=development

