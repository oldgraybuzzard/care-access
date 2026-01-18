import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create the default FCF organization
  const FCF_ORG_ID = 'fcf-default-org-id';

  const fcfOrganization = await prisma.organization.upsert({
    where: { id: FCF_ORG_ID },
    update: {},
    create: {
      id: FCF_ORG_ID,
      name: 'Foster Care Foundation',
      slug: 'fcf',
      plan: 'enterprise',
      status: 'active',
    },
  });

  // Create CareAccess Demo organization
  const demoOrganization = await prisma.organization.upsert({
    where: { slug: 'careaccess-demo' },
    update: {},
    create: {
      name: 'CareAccess Demo Organization',
      slug: 'careaccess-demo',
      plan: 'enterprise',
      status: 'active',
    },
  });

  console.log('✅ Organizations created');

  // Create roles
  const adminRole = await prisma.role.upsert({
    where: { name: 'admin' },
    update: {},
    create: {
      name: 'admin',
      description: 'Administrator with full access',
    },
  });

  const userRole = await prisma.role.upsert({
    where: { name: 'user' },
    update: {},
    create: {
      name: 'user',
      description: 'Standard user with read access',
    },
  });

  const managerRole = await prisma.role.upsert({
    where: { name: 'manager' },
    update: {},
    create: {
      name: 'manager',
      description: 'Manager with reporting access',
    },
  });

  const superadminRole = await prisma.role.upsert({
    where: { name: 'superadmin' },
    update: {},
    create: {
      name: 'superadmin',
      description: 'Platform SuperAdmin with cross-organization access',
    },
  });

  console.log('✅ Roles created');

  // Create admin user
  const adminPasswordHash = await bcrypt.hash('admin123', 10);
  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@fcf.org' },
    update: {},
    create: {
      organizationId: FCF_ORG_ID,
      email: 'admin@fcf.org',
      name: 'Admin User',
      passwordHash: adminPasswordHash,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: adminUser.id,
        roleId: adminRole.id,
      },
    },
    update: {},
    create: {
      userId: adminUser.id,
      roleId: adminRole.id,
    },
  });

  console.log('✅ Admin user created (admin@fcf.org / admin123)');

  // Create admin user for CareAccess Demo
  const demoPasswordHash = await bcrypt.hash('password123', 10);
  const demoAdminUser = await prisma.user.upsert({
    where: { email: 'admin@careaccess-demo.com' },
    update: {},
    create: {
      organizationId: demoOrganization.id,
      email: 'admin@careaccess-demo.com',
      name: 'Demo Admin User',
      passwordHash: demoPasswordHash,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: demoAdminUser.id,
        roleId: adminRole.id,
      },
    },
    update: {},
    create: {
      userId: demoAdminUser.id,
      roleId: adminRole.id,
    },
  });

  console.log('✅ Demo admin user created (admin@careaccess-demo.com / password123)');

  // Create SuperAdmin user (no organization)
  const superadminPasswordHash = await bcrypt.hash('SuperAdmin123!', 10);
  const superadminUser = await prisma.user.upsert({
    where: { email: 'admin@melkentechwork.com' },
    update: {},
    create: {
      organizationId: null, // SuperAdmin has no organization
      email: 'admin@melkentechwork.com',
      name: 'Platform Administrator',
      passwordHash: superadminPasswordHash,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: superadminUser.id,
        roleId: superadminRole.id,
      },
    },
    update: {},
    create: {
      userId: superadminUser.id,
      roleId: superadminRole.id,
    },
  });

  console.log('✅ SuperAdmin user created (admin@melkentechwork.com / SuperAdmin123!)');

  // Create vendor source
  const vendorSource = await prisma.vendorSource.upsert({
    where: {
      organizationId_name: {
        organizationId: FCF_ORG_ID,
        name: 'extendedreach'
      }
    },
    update: {},
    create: {
      organizationId: FCF_ORG_ID,
      name: 'extendedreach',
    },
  });

  console.log('✅ Vendor source created');

  // Create programs
  const programs = await Promise.all([
    prisma.program.upsert({
      where: {
        organizationId_name: {
          organizationId: FCF_ORG_ID,
          name: 'Foster Care'
        }
      },
      update: {},
      create: {
        organizationId: FCF_ORG_ID,
        name: 'Foster Care'
      },
    }),
    prisma.program.upsert({
      where: {
        organizationId_name: {
          organizationId: FCF_ORG_ID,
          name: 'Adoption Services'
        }
      },
      update: {},
      create: {
        organizationId: FCF_ORG_ID,
        name: 'Adoption Services'
      },
    }),
    prisma.program.upsert({
      where: {
        organizationId_name: {
          organizationId: FCF_ORG_ID,
          name: 'Family Support'
        }
      },
      update: {},
      create: {
        organizationId: FCF_ORG_ID,
        name: 'Family Support'
      },
    }),
  ]);

  console.log('✅ Programs created');

  // Create workers
  const workers = await Promise.all([
    prisma.worker.upsert({
      where: {
        organizationId_email: {
          organizationId: FCF_ORG_ID,
          email: 'john.smith@fcf.org'
        }
      },
      update: {},
      create: {
        organizationId: FCF_ORG_ID,
        name: 'John Smith',
        email: 'john.smith@fcf.org',
      },
    }),
    prisma.worker.upsert({
      where: {
        organizationId_email: {
          organizationId: FCF_ORG_ID,
          email: 'jane.doe@fcf.org'
        }
      },
      update: {},
      create: {
        organizationId: FCF_ORG_ID,
        name: 'Jane Doe',
        email: 'jane.doe@fcf.org',
      },
    }),
  ]);

  console.log('✅ Workers created');

  // Create standard report definitions for both organizations
  const reportTypes = [
    {
      id: 'caseload-by-worker',
      name: 'Caseload by Worker',
      description: 'Shows active caseload grouped by worker',
    },
    {
      id: 'active-cases-by-program',
      name: 'Active Cases by Program/Status',
      description: 'Shows active cases grouped by program and status',
    },
    {
      id: 'intakes-vs-closures',
      name: 'Intakes vs Closures Trend',
      description: 'Monthly trend of intakes vs closures',
    },
    {
      id: 'overdue-compliance',
      name: 'Overdue/Compliance List',
      description: 'List of cases with overdue items or compliance issues',
    },
    {
      id: 'services-delivered',
      name: 'Services Delivered by Period',
      description: 'Services delivered grouped by type and period',
    },
  ];

  const organizations = [fcfOrganization, demoOrganization];
  const reportDefinitions = [];

  for (const org of organizations) {
    for (const reportType of reportTypes) {
      const report = await prisma.reportDefinition.upsert({
        where: { id: `${reportType.id}-${org.id}` },
        update: {},
        create: {
          id: `${reportType.id}-${org.id}`,
          organizationId: org.id,
          name: reportType.name,
          type: 'standard',
          definitionJson: {
            description: reportType.description,
          },
          isShared: true,
        },
      });
      reportDefinitions.push(report);
    }
  }

  console.log(`✅ Report definitions created (${reportDefinitions.length} reports for ${organizations.length} organizations)`);

  console.log('🎉 Database seed completed successfully!');
  console.log('\n📝 Login credentials:');
  console.log('\n   FCF Organization Admin:');
  console.log('   Email: admin@fcf.org');
  console.log('   Password: admin123');
  console.log('\n   CareAccess Demo Admin:');
  console.log('   Email: admin@careaccess-demo.com');
  console.log('   Password: password123');
  console.log('\n   Platform SuperAdmin:');
  console.log('   Email: admin@melkentechwork.com');
  console.log('   Password: SuperAdmin123!');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

