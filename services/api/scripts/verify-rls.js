#!/usr/bin/env node
/**
 * Verify Row-Level Security (RLS) is properly configured
 * 
 * Usage: node scripts/verify-rls.js
 */

const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

const EXPECTED_TABLES = [
  'children',
  'families',
  'assessments',
  'education_records',
  'medical_records',
  'behavioral_incidents',
  'goals',
  'child_notes',
  'home_visits',
  'cases',
  'clients',
  'workers',
  'programs',
  'vendor_sources',
  'report_definitions',
];

async function main() {
  console.log('🔒 Verifying Row-Level Security (RLS) Configuration\n');

  // Check RLS is enabled
  const rlsStatus = await prisma.$queryRaw`
    SELECT tablename, rowsecurity 
    FROM pg_tables 
    WHERE schemaname = 'public' 
      AND tablename = ANY(${EXPECTED_TABLES})
    ORDER BY tablename;
  `;

  const enabledTables = rlsStatus.filter(row => row.rowsecurity);
  const disabledTables = rlsStatus.filter(row => !row.rowsecurity);

  console.log(`✅ RLS Enabled: ${enabledTables.length}/${EXPECTED_TABLES.length} tables`);
  
  if (disabledTables.length > 0) {
    console.log(`❌ RLS Disabled on: ${disabledTables.map(t => t.tablename).join(', ')}`);
    process.exit(1);
  }

  // Check policies exist
  const policies = await prisma.$queryRaw`
    SELECT tablename, policyname
    FROM pg_policies
    WHERE schemaname = 'public'
      AND policyname = 'tenant_isolation_policy'
      AND tablename = ANY(${EXPECTED_TABLES})
    ORDER BY tablename;
  `;

  console.log(`✅ RLS Policies: ${policies.length}/${EXPECTED_TABLES.length} tables`);

  if (policies.length !== EXPECTED_TABLES.length) {
    const missingPolicies = EXPECTED_TABLES.filter(
      table => !policies.find(p => p.tablename === table)
    );
    console.log(`❌ Missing policies on: ${missingPolicies.join(', ')}`);
    process.exit(1);
  }

  console.log('\n🎉 RLS is properly configured!');
  console.log('   - All tenant-scoped tables have RLS enabled');
  console.log('   - All tables have tenant_isolation_policy');
  console.log('   - Database-level tenant isolation is active');
}

main()
  .catch((error) => {
    console.error('\n❌ Verification failed:', error.message);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());

