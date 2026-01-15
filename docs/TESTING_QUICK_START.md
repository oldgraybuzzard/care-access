# Testing Quick Start Guide

## 🚀 Get Started Testing in 2 Minutes

### Step 1: Seed the Database with Test Data

```bash
cd services/api
npm run seed:comprehensive
```

This creates:
- **144 children** across 3 organizations
- **706 documents** (photos, medical records, reports, etc.)
- **64 families** with realistic data
- **29 users** to test with

---

### Step 2: Start the API

```bash
npm run start:dev
```

API will be running at: `http://localhost:3001`

---

### Step 3: Login & Test

#### Option A: Use Prisma Studio (Visual Database Browser)

```bash
npx prisma studio
```

Opens at `http://localhost:5555` - Browse all data visually!

#### Option B: Use API Endpoints

**Login:**
```bash
curl -X POST http://localhost:3001/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@careaccess-demo.com",
    "password": "password123"
  }'
```

**Get Children:**
```bash
# Use the token from login response
curl http://localhost:3001/children \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Upload Document:**
```bash
curl -X POST http://localhost:3001/documents/upload \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -F "file=@test.jpg" \
  -F "category=photo" \
  -F "childId=CHILD_ID_HERE"
```

---

## 🔑 Test Accounts

### Organization 1: CareAccess Demo
- **Email:** `admin@careaccess-demo.com`
- **Password:** `password123`
- **Data:** ~48 children, ~235 documents

### Organization 2: Hope Family Services
- **Email:** `admin@hope-family-services.com`
- **Password:** `password123`
- **Data:** ~48 children, ~235 documents

### Organization 3: Caring Hearts
- **Email:** `admin@caring-hearts.com`
- **Password:** `password123`
- **Data:** ~48 children, ~235 documents

### SuperAdmin (Platform)
- **Email:** `admin@melkentechwork.com`
- **Password:** `SuperAdmin123!`
- **Access:** Platform management only (no org data)

---

## 🧪 What to Test

### 1. Multi-Tenancy Isolation
1. Login as `admin@careaccess-demo.com`
2. Note the children you see
3. Logout and login as `admin@hope-family-services.com`
4. Verify you see DIFFERENT children
5. ✅ **Pass:** No data leakage between orgs

### 2. Document Upload/Download
1. Login to any org
2. Get a child ID from `/children` endpoint
3. Upload a document to that child
4. List documents for that child
5. Download the document using the signed URL
6. ✅ **Pass:** Upload and download work

### 3. Search & Filtering
1. Login to org with most data
2. Search for children by name
3. Filter by status, custody status
4. Test pagination
5. ✅ **Pass:** Search returns correct results

### 4. Performance
1. Use comprehensive seed (100+ children)
2. Test list views
3. Monitor response times
4. Check database query performance
5. ✅ **Pass:** Queries complete in < 500ms

---

## 🔄 Reset Database

If you need to start fresh:

```bash
cd services/api
./scripts/reset-and-seed.sh
```

This will:
1. Delete ALL data (with confirmation)
2. Reset database to clean state
3. Run comprehensive seed
4. Verify data counts

---

## 📊 View Data

### Prisma Studio (Recommended)
```bash
npx prisma studio
```
- Visual interface
- Edit data directly
- See relationships
- Filter and search

### SQL Queries
```bash
# Count children
npx prisma db execute --stdin <<SQL
SELECT COUNT(*) FROM children;
SQL

# Count documents
npx prisma db execute --stdin <<SQL
SELECT COUNT(*) FROM documents;
SQL
```

---

## 🐛 Common Issues

### "Prisma Client not generated"
```bash
cd services/api
npx prisma generate
```

### "Database connection failed"
```bash
# Make sure Docker is running
docker-compose up -d postgres

# Check connection
npx prisma db pull
```

### "Seed fails with errors"
```bash
# Reset and try again
npx prisma migrate reset --force
npm run seed:comprehensive
```

---

## 📚 More Documentation

- [Database Seeding Guide](./DATABASE_SEEDING.md) - Detailed seeding options
- [Development Guide](./DEVELOPMENT.md) - Full dev setup
- [R2 Storage Setup](./R2_STORAGE_SETUP.md) - Document storage
- [Multi-Tenancy Guide](./MULTI_TENANCY.md) - Tenant isolation

---

## 🎯 Quick Commands Cheat Sheet

```bash
# Seed database
npm run seed:comprehensive

# Start API
npm run start:dev

# View data
npx prisma studio

# Reset database
./scripts/reset-and-seed.sh

# Run tests
npm test

# Check logs
docker-compose logs -f api
```

---

**Happy Testing! 🎉**

