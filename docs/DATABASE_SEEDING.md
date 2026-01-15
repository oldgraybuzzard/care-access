# Database Seeding Guide

## 🌱 Overview

This guide explains how to seed your CareAccess database with test data for development and testing.

---

## 📋 Available Seed Scripts

### 1. **Basic Seed** (Default)
```bash
cd services/api
npm run prisma:seed
```

**Creates:**
- 1 organization (Foster Care Foundation)
- 2 users (admin, regular user)
- Basic roles and permissions
- Sample report definitions

**Use for:** Quick setup, minimal data

---

### 2. **Multi-Tenant Seed**
```bash
cd services/api
npm run prisma:seed:multi
```

**Creates:**
- 3 organizations
- 3 admin users (one per org)
- 3 children (one per org)
- Basic test data for multi-tenancy testing

**Use for:** Testing tenant isolation

---

### 3. **Comprehensive Seed** ⭐ **RECOMMENDED FOR TESTING**
```bash
cd services/api
npm run seed:comprehensive
```

**Creates:**
- **3 organizations** with different plans
- **30-50 users** across all organizations
- **45-75 families** (15-25 per org)
- **100-200+ children** (1-4 per family)
- **300-1000+ documents** (2-8 per child)
- **15-30 programs** (5-10 per org)
- **12 vendor sources** (4 per org)
- **15 report definitions** (5 per org)
- **Education records** for each child
- **Realistic data** with varied statuses, diagnoses, etc.

**Use for:** Deep testing, realistic scenarios, performance testing

---

### 4. **Production Seed**
```bash
cd services/api
npm run prisma:seed:production
```

**Creates:**
- 1 organization (if none exists)
- 1 admin user
- Basic roles

**Use for:** Production initialization (safe, minimal)

---

### 5. **SuperAdmin Only**
```bash
cd services/api
npm run prisma:seed:superadmin
```

**Creates:**
- 1 SuperAdmin user (no organization)

**Use for:** Adding platform admin

---

## 🔄 Reset & Seed (Fresh Start)

### Quick Reset
```bash
cd services/api
./scripts/reset-and-seed.sh
```

This script will:
1. ⚠️ **Delete ALL data** (with confirmation)
2. Reset database to clean state
3. Run comprehensive seed
4. Verify data counts

### Manual Reset
```bash
cd services/api
npx prisma migrate reset --force --skip-seed
npm run seed:comprehensive
```

---

## 🔑 Test Credentials

### After Comprehensive Seed:

**SuperAdmin (Platform):**
- Email: `admin@melkentechwork.com`
- Password: `SuperAdmin123!`
- Access: Platform management only (no org data)

**CareAccess Demo Organization:**
- Email: `admin@careaccess-demo.com`
- Password: `password123`
- Access: Full org admin

**Hope Family Services:**
- Email: `admin@hope-family-services.com`
- Password: `password123`
- Access: Full org admin

**Caring Hearts Foundation:**
- Email: `admin@caring-hearts.com`
- Password: `password123`
- Access: Full org admin

**Staff Users:**
- Email: `firstname.lastname@{org-slug}.com`
- Password: `password123`
- Access: Standard user

---

## 📊 Data Statistics (Comprehensive Seed)

| Entity | Count | Notes |
|--------|-------|-------|
| Organizations | 3 | Different plans (enterprise, professional, basic) |
| Users | 30-50 | 5-10 staff per org + admins |
| Families | 45-75 | 15-25 per org |
| Children | 100-200+ | 1-4 per family |
| Documents | 300-1000+ | 2-8 per child, various categories |
| Programs | 15-30 | 5-10 per org |
| Education Records | 200-600 | 1-3 per child |
| Vendor Sources | 12 | 4 per org |
| Report Definitions | 15 | 5 per org |

---

## 🧪 Testing Scenarios

### Multi-Tenancy Testing
1. Login as `admin@careaccess-demo.com`
2. Note the children/families you can see
3. Logout and login as `admin@hope-family-services.com`
4. Verify you see DIFFERENT children/families
5. Verify no data leakage between orgs

### Document Upload/Download
1. Login to any org
2. Navigate to a child's profile
3. Upload a document
4. Verify it appears in the list
5. Download the document
6. Verify signed URL works

### Search & Filtering
1. Login to org with most data
2. Search for children by name
3. Filter by status, custody status, etc.
4. Test pagination with large datasets

### Performance Testing
1. Use comprehensive seed for realistic data volume
2. Test list views with 50+ children
3. Test search with 100+ records
4. Monitor query performance

---

## 🛠️ Customizing Seed Data

### Modify Comprehensive Seed

Edit `services/api/prisma/seed-comprehensive.ts`:

```typescript
// Change number of families per org
const familyCount = randomAge(15, 25); // Change these numbers

// Change number of children per family
const childCount = randomAge(1, 4); // Change these numbers

// Change number of documents per child
const docCount = randomAge(2, 8); // Change these numbers
```

### Create Custom Seed

1. Copy `seed-comprehensive.ts` to `seed-custom.ts`
2. Modify as needed
3. Add to `package.json`:
   ```json
   "prisma:seed:custom": "ts-node prisma/seed-custom.ts"
   ```
4. Run: `npm run prisma:seed:custom`

---

## 🔍 Viewing Seeded Data

### Prisma Studio (Recommended)
```bash
cd services/api
npx prisma studio
```
Opens GUI at `http://localhost:5555`

### SQL Query
```bash
cd services/api
npx prisma db execute --stdin <<SQL
SELECT COUNT(*) FROM children;
SQL
```

### API Endpoints
```bash
# Login
curl -X POST http://localhost:3001/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@careaccess-demo.com","password":"password123"}'

# Get children (use token from login)
curl http://localhost:3001/children \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## ⚠️ Important Notes

1. **Never run comprehensive seed in production!**
   - Use `prisma:seed:production` for production
   - Comprehensive seed is for development/testing only

2. **Reset deletes ALL data**
   - Always backup production data before reset
   - Use `--skip-seed` flag to reset without seeding

3. **Seed is idempotent (mostly)**
   - Basic seed uses `upsert` for safety
   - Comprehensive seed creates new records each time
   - Reset before re-running comprehensive seed

4. **Performance**
   - Comprehensive seed takes 30-60 seconds
   - Creates 500-1500+ database records
   - Good for testing, but not for every test run

---

## 🚀 Quick Start

**For new developers:**
```bash
cd services/api
./scripts/reset-and-seed.sh
npm run start:dev
```

**For testing:**
```bash
cd services/api
npm run seed:comprehensive
npx prisma studio
```

**For production:**
```bash
cd services/api
npm run prisma:seed:production
```

---

## 📚 Related Documentation

- [Development Guide](./DEVELOPMENT.md)
- [Testing Guide](./TESTING.md)
- [Multi-Tenancy Guide](./MULTI_TENANCY.md)
- [Database Schema](../services/api/prisma/schema.prisma)

---

**Happy Testing! 🎉**

