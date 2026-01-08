#!/bin/bash

# FCF Platform Development Script
# Starts all services for local development

set -e

echo "🚀 Starting FCF Platform Development Environment"
echo "=============================================="
echo ""

# Start Docker services
echo "🐳 Starting Docker services (PostgreSQL + Redis)..."
docker-compose up -d postgres redis

echo "⏳ Waiting for services to be ready..."
sleep 3

# Check if services are running
if ! docker ps | grep -q fcf-postgres; then
    echo "❌ PostgreSQL failed to start"
    exit 1
fi

echo "✅ Docker services are running"
echo ""

# Start API in background
echo "🔧 Starting API service..."
cd services/api
npm run start:dev &
API_PID=$!
cd ../..

echo "✅ API service started (PID: $API_PID)"
echo ""

# Start Worker in background
echo "⚙️  Starting Worker service..."
cd services/worker
npm run start:dev &
WORKER_PID=$!
cd ../..

echo "✅ Worker service started (PID: $WORKER_PID)"
echo ""

echo "🎉 All services are running!"
echo ""
echo "📍 Service URLs:"
echo "- API: http://localhost:3000"
echo "- Swagger: http://localhost:3000/api"
echo "- PostgreSQL: localhost:5432"
echo "- Redis: localhost:6379"
echo ""
echo "📱 To start Flutter app:"
echo "cd apps/flutter_app && flutter run"
echo ""
echo "🛑 To stop all services:"
echo "Press Ctrl+C, then run: docker-compose down"
echo ""

# Wait for Ctrl+C
trap "echo ''; echo '🛑 Stopping services...'; kill $API_PID $WORKER_PID; docker-compose down; echo '✅ All services stopped'; exit 0" INT

# Keep script running
wait

