#!/bin/bash

# FCF Platform Setup Script
# This script sets up the development environment

set -e

echo "🚀 FCF Platform Setup"
echo "===================="
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 20+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm"
    exit 1
fi

if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter is not installed. Flutter app setup will be skipped."
    SKIP_FLUTTER=true
fi

if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker is not installed. You'll need to setup PostgreSQL manually."
    SKIP_DOCKER=true
fi

echo "✅ Prerequisites check complete"
echo ""

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install
echo "✅ Root dependencies installed"
echo ""

# Setup API service
echo "🔧 Setting up API service..."
cd services/api

if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit services/api/.env with your configuration"
fi

echo "📦 Installing API dependencies..."
npm install

echo "✅ API service setup complete"
cd ../..
echo ""

# Setup Worker service
echo "🔧 Setting up Worker service..."
cd services/worker

if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit services/worker/.env with your configuration"
fi

echo "📦 Installing Worker dependencies..."
npm install

echo "✅ Worker service setup complete"
cd ../..
echo ""

# Setup Flutter app
if [ "$SKIP_FLUTTER" != true ]; then
    echo "📱 Setting up Flutter app..."
    cd apps/flutter_app
    
    echo "📦 Installing Flutter dependencies..."
    flutter pub get
    
    echo "✅ Flutter app setup complete"
    cd ../..
    echo ""
fi

# Start Docker services
if [ "$SKIP_DOCKER" != true ]; then
    echo "🐳 Starting Docker services..."
    docker-compose up -d postgres redis
    
    echo "⏳ Waiting for PostgreSQL to be ready..."
    sleep 5
    
    echo "✅ Docker services started"
    echo ""
fi

# Run database migrations
echo "🗄️  Setting up database..."
cd services/api

echo "🔄 Running Prisma migrations..."
npx prisma migrate dev --name init

echo "🌱 Seeding database..."
npm run seed

echo "✅ Database setup complete"
cd ../..
echo ""

# Summary
echo "✅ Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env files in services/api and services/worker"
echo "2. Start the API: cd services/api && npm run start:dev"
echo "3. Start the Worker: cd services/worker && npm run start:dev"
if [ "$SKIP_FLUTTER" != true ]; then
    echo "4. Run Flutter app: cd apps/flutter_app && flutter run"
fi
echo ""
echo "📚 Documentation:"
echo "- README.md - Quick start guide"
echo "- docs/DEVELOPMENT.md - Development guide"
echo "- docs/API.md - API documentation"
echo ""
echo "🎉 Happy coding!"

