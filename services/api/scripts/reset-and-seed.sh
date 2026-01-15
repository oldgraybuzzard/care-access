#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   CareAccess Database Reset & Comprehensive Seed${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: Must run from services/api directory${NC}"
    exit 1
fi

# Warning
echo -e "${YELLOW}⚠️  WARNING: This will DELETE ALL DATA and reseed the database!${NC}"
echo -e "${YELLOW}   This action cannot be undone.${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${BLUE}Cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🗄️  Step 1: Resetting database...${NC}"
npx prisma migrate reset --force --skip-seed

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Database reset failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Database reset complete${NC}"
echo ""

echo -e "${BLUE}🌱 Step 2: Running comprehensive seed...${NC}"
npm run prisma:seed:comprehensive

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Seed failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Seed complete${NC}"
echo ""

echo -e "${BLUE}📊 Step 3: Verifying data...${NC}"
npx prisma db execute --schema=./prisma/schema.prisma --stdin <<SQL
SELECT
    'Organizations' as table_name, COUNT(*)::text as count FROM organizations
UNION ALL
SELECT 'Users', COUNT(*)::text FROM users
UNION ALL
SELECT 'Families', COUNT(*)::text FROM families
UNION ALL
SELECT 'Children', COUNT(*)::text FROM children
UNION ALL
SELECT 'Documents', COUNT(*)::text FROM documents
UNION ALL
SELECT 'Programs', COUNT(*)::text FROM programs
ORDER BY table_name;
SQL

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✅ Database Reset & Seed Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo -e "   1. Start the API: ${GREEN}npm run start:dev${NC}"
echo -e "   2. Open Prisma Studio: ${GREEN}npx prisma studio${NC}"
echo -e "   3. Login with test credentials (see seed output above)"
echo ""

