# FCF Platform - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Node.js 20+
- Docker Desktop
- Flutter 3.16+ (optional, for mobile app)

### Option 1: Automated Setup (Recommended)

```bash
# Run the setup script
./scripts/setup.sh

# Start all services
./scripts/dev.sh
```

### Option 2: Manual Setup

#### 1. Install Dependencies
```bash
npm install
cd services/api && npm install && cd ../..
cd services/worker && npm install && cd ../..
cd apps/flutter_app && flutter pub get && cd ../..
```

#### 2. Start Database
```bash
docker-compose up -d postgres redis
```

#### 3. Setup Database
```bash
cd services/api
cp .env.example .env
npx prisma migrate dev
npm run seed
cd ../..
```

#### 4. Start Services
```bash
# Terminal 1 - API
cd services/api
npm run start:dev

# Terminal 2 - Worker
cd services/worker
npm run start:dev

# Terminal 3 - Flutter (optional)
cd apps/flutter_app
flutter run -d chrome
```

## 🎯 Access the Application

- **API**: http://localhost:3000
- **Swagger Docs**: http://localhost:3000/api
- **Flutter Web**: http://localhost:8080 (if running)

## 🔑 Default Login Credentials

- **Admin**: admin@fcf.org / admin123
- **Manager**: manager@fcf.org / manager123
- **Worker**: worker@fcf.org / worker123

## 📚 Next Steps

1. **Explore the API**
   - Visit http://localhost:3000/api
   - Try the authentication endpoints
   - Test the search and reporting features

2. **Check the Documentation**
   - [Development Guide](docs/DEVELOPMENT.md)
   - [API Documentation](docs/API.md)
   - [Deployment Guide](docs/DEPLOYMENT.md)
   - [Project Summary](docs/PROJECT_SUMMARY.md)

3. **Customize Configuration**
   - Edit `services/api/.env` for API settings
   - Edit `services/worker/.env` for worker settings
   - Configure vendor API credentials

4. **Run Tests**
   ```bash
   cd services/api
   npm test
   ```

## 🛠️ Common Commands

### Database
```bash
# View data in Prisma Studio
cd services/api
npx prisma studio

# Reset database
npx prisma migrate reset

# Create new migration
npx prisma migrate dev --name <migration-name>
```

### Development
```bash
# Format code
npm run format

# Lint code
npm run lint

# Build for production
npm run build
```

### Docker
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart a service
docker-compose restart postgres
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Find and kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### PostgreSQL Port 5432 Conflict
If you have PostgreSQL already running locally, Docker uses port **5433** instead:
```bash
# The Docker PostgreSQL is accessible at localhost:5433
# Update your .env file if needed:
DATABASE_URL="postgresql://fcf_user:fcf_password@localhost:5433/fcf_platform?schema=public"
```

### Database Connection Error
```bash
# Restart PostgreSQL
docker-compose restart postgres

# Check if PostgreSQL is running
docker ps | grep postgres
```

### Prisma Client Not Generated
```bash
cd services/api
npx prisma generate
```

### Flutter Dependencies Issue
```bash
cd apps/flutter_app
flutter clean
flutter pub get
```

## 📖 Project Structure

```
fcf/
├── apps/
│   └── flutter_app/          # Flutter mobile app
├── services/
│   ├── api/                  # NestJS API service
│   └── worker/               # NestJS worker service
├── docs/                     # Documentation
├── scripts/                  # Setup and utility scripts
├── docker-compose.yml        # Local development
└── README.md                 # Main documentation
```

## 🎓 Learning Resources

- [NestJS Documentation](https://docs.nestjs.com/)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)

## 💡 Tips

1. **Use Prisma Studio** to visualize and edit database data
2. **Check Swagger UI** for interactive API documentation
3. **Enable hot reload** in NestJS for faster development
4. **Use Flutter DevTools** for debugging the mobile app
5. **Check logs** in `docker-compose logs` for issues

## 🤝 Need Help?

1. Check the [Development Guide](docs/DEVELOPMENT.md)
2. Review the [Checklist](docs/CHECKLIST.md)
3. Look at code comments
4. Contact the development team

## 🎉 You're Ready!

The FCF Platform is now running locally. Start exploring and building!

