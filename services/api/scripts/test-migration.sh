#!/bin/bash

# Multi-Tenancy Migration Test Script
# This script validates the multi-tenancy migration

set -e  # Exit on error

echo "🧪 Multi-Tenancy Migration Test Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}❌ ERROR: DATABASE_URL environment variable is not set${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Pre-Migration Checks${NC}"
echo "-----------------------------------"

# Check if organizations table exists
echo -n "Checking if organizations table exists... "
if psql "$DATABASE_URL" -tAc "SELECT to_regclass('public.organizations');" | grep -q "organizations"; then
    echo -e "${GREEN}✅ EXISTS${NC}"
    ORG_EXISTS=true
else
    echo -e "${YELLOW}⚠️  NOT FOUND (will be created)${NC}"
    ORG_EXISTS=false
fi

# Count existing records
echo ""
echo -e "${YELLOW}📊 Current Data Counts${NC}"
echo "-----------------------------------"
psql "$DATABASE_URL" -c "
SELECT 
    'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Clients', COUNT(*) FROM clients
UNION ALL
SELECT 'Cases', COUNT(*) FROM cases
UNION ALL
SELECT 'Children', COUNT(*) FROM children
UNION ALL
SELECT 'Families', COUNT(*) FROM families
ORDER BY table_name;
"

echo ""
echo -e "${YELLOW}🔄 Running Migration${NC}"
echo "-----------------------------------"

# Run Prisma migration
cd "$(dirname "$0")/.."
npx prisma migrate deploy

echo ""
echo -e "${YELLOW}✅ Post-Migration Validation${NC}"
echo "-----------------------------------"

# Check organizations table
echo "1. Checking organizations table..."
ORG_COUNT=$(psql "$DATABASE_URL" -tAc "SELECT COUNT(*) FROM organizations;")
echo "   Organizations: $ORG_COUNT"

if [ "$ORG_COUNT" -eq 0 ]; then
    echo -e "   ${RED}❌ FAIL: No organizations found${NC}"
    exit 1
else
    echo -e "   ${GREEN}✅ PASS${NC}"
fi

# Check default FCF organization
echo ""
echo "2. Checking default FCF organization..."
FCF_ORG=$(psql "$DATABASE_URL" -tAc "SELECT id FROM organizations WHERE slug = 'fcf';")
if [ -z "$FCF_ORG" ]; then
    echo -e "   ${RED}❌ FAIL: FCF organization not found${NC}"
    exit 1
else
    echo "   FCF Organization ID: $FCF_ORG"
    echo -e "   ${GREEN}✅ PASS${NC}"
fi

# Check organization_id columns exist
echo ""
echo "3. Checking organization_id columns..."
TABLES=("users" "clients" "cases" "children" "families" "programs" "workers")
for table in "${TABLES[@]}"; do
    HAS_COL=$(psql "$DATABASE_URL" -tAc "
        SELECT COUNT(*) 
        FROM information_schema.columns 
        WHERE table_name = '$table' 
        AND column_name = 'organization_id';
    ")
    if [ "$HAS_COL" -eq 1 ]; then
        echo -e "   $table: ${GREEN}✅${NC}"
    else
        echo -e "   $table: ${RED}❌ MISSING${NC}"
        exit 1
    fi
done

# Check data migration
echo ""
echo "4. Checking data migration to FCF organization..."
psql "$DATABASE_URL" -c "
SELECT 
    'Users' as table_name, 
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE organization_id = '$FCF_ORG') as in_fcf_org
FROM users
UNION ALL
SELECT 'Clients', COUNT(*), COUNT(*) FILTER (WHERE organization_id = '$FCF_ORG') FROM clients
UNION ALL
SELECT 'Cases', COUNT(*), COUNT(*) FILTER (WHERE organization_id = '$FCF_ORG') FROM cases
UNION ALL
SELECT 'Children', COUNT(*), COUNT(*) FILTER (WHERE organization_id = '$FCF_ORG') FROM children
UNION ALL
SELECT 'Families', COUNT(*), COUNT(*) FILTER (WHERE organization_id = '$FCF_ORG') FROM families
ORDER BY table_name;
"

# Check indexes
echo ""
echo "5. Checking indexes..."
INDEX_COUNT=$(psql "$DATABASE_URL" -tAc "
    SELECT COUNT(*) 
    FROM pg_indexes 
    WHERE indexname LIKE '%organization_id%';
")
echo "   Organization indexes: $INDEX_COUNT"
if [ "$INDEX_COUNT" -gt 15 ]; then
    echo -e "   ${GREEN}✅ PASS${NC}"
else
    echo -e "   ${YELLOW}⚠️  WARNING: Expected 17+ indexes, found $INDEX_COUNT${NC}"
fi

# Check foreign keys
echo ""
echo "6. Checking foreign key constraints..."
FK_COUNT=$(psql "$DATABASE_URL" -tAc "
    SELECT COUNT(*) 
    FROM information_schema.table_constraints 
    WHERE constraint_type = 'FOREIGN KEY' 
    AND constraint_name LIKE '%organization_id_fkey';
")
echo "   Organization foreign keys: $FK_COUNT"
if [ "$FK_COUNT" -gt 15 ]; then
    echo -e "   ${GREEN}✅ PASS${NC}"
else
    echo -e "   ${YELLOW}⚠️  WARNING: Expected 17 foreign keys, found $FK_COUNT${NC}"
fi

# Regenerate Prisma Client
echo ""
echo -e "${YELLOW}🔧 Regenerating Prisma Client${NC}"
echo "-----------------------------------"
npx prisma generate

echo ""
echo -e "${GREEN}✅ Migration Test Complete!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Review the results above"
echo "2. Test your API endpoints"
echo "3. Proceed to Phase 2 (Backend Implementation)"
echo ""
echo "See: docs/PHASE_1_COMPLETE.md for details"

