import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create the default FCF organization
  const FCF_ORG_ID = 'fcf-default-org-id';

  const organization = await prisma.organization.upsert({
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

  console.log('✅ Organization created');

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

  // Create standard report definitions
  const reportDefinitions = await Promise.all([
    prisma.reportDefinition.upsert({
      where: { id: 'caseload-by-worker' },
      update: {},
      create: {
        id: 'caseload-by-worker',
        organizationId: FCF_ORG_ID,
        name: 'Caseload by Worker',
        type: 'standard',
        definitionJson: {
          description: 'Shows active caseload grouped by worker',
        },
        isShared: true,
      },
    }),
    prisma.reportDefinition.upsert({
      where: { id: 'active-cases-by-program' },
      update: {},
      create: {
        id: 'active-cases-by-program',
        organizationId: FCF_ORG_ID,
        name: 'Active Cases by Program/Status',
        type: 'standard',
        definitionJson: {
          description: 'Shows active cases grouped by program and status',
        },
        isShared: true,
      },
    }),
    prisma.reportDefinition.upsert({
      where: { id: 'intakes-vs-closures' },
      update: {},
      create: {
        id: 'intakes-vs-closures',
        organizationId: FCF_ORG_ID,
        name: 'Intakes vs Closures Trend',
        type: 'standard',
        definitionJson: {
          description: 'Monthly trend of intakes vs closures',
        },
        isShared: true,
      },
    }),
    prisma.reportDefinition.upsert({
      where: { id: 'overdue-compliance' },
      update: {},
      create: {
        id: 'overdue-compliance',
        organizationId: FCF_ORG_ID,
        name: 'Overdue/Compliance List',
        type: 'standard',
        definitionJson: {
          description: 'List of cases with overdue items or compliance issues',
        },
        isShared: true,
      },
    }),
    prisma.reportDefinition.upsert({
      where: { id: 'services-delivered' },
      update: {},
      create: {
        id: 'services-delivered',
        organizationId: FCF_ORG_ID,
        name: 'Services Delivered by Period',
        type: 'standard',
        definitionJson: {
          description: 'Services delivered grouped by type and period',
        },
        isShared: true,
      },
    }),
  ]);

  console.log('✅ Report definitions created');

  console.log('🎉 Database seed completed successfully!');
  console.log('\n📝 Login credentials:');
  console.log('   Email: admin@fcf.org');
  console.log('   Password: admin123');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

