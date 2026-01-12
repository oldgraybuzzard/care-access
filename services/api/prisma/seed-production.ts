import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting production database seed...');

  // Check if organization already exists
  const existingOrg = await prisma.organization.findFirst();
  
  if (existingOrg) {
    console.log('⚠️  Organization already exists. Skipping organization creation.');
    console.log(`   Existing organization: ${existingOrg.name} (${existingOrg.id})`);
  } else {
    // Create the production organization
    const organization = await prisma.organization.create({
      data: {
        name: 'Foster Care Foundation',
        slug: 'fcf',
        plan: 'enterprise',
        status: 'active',
      },
    });
    console.log(`✅ Organization created: ${organization.name} (${organization.id})`);
  }

  // Get the organization (either existing or newly created)
  const organization = await prisma.organization.findFirst();
  
  if (!organization) {
    throw new Error('Failed to find or create organization');
  }

  // Create roles if they don't exist
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

  console.log('✅ Roles created/verified');

  // Check if admin user already exists
  const existingAdmin = await prisma.user.findUnique({
    where: { email: 'admin@fcf.org' },
  });

  if (existingAdmin) {
    console.log('⚠️  Admin user already exists. Skipping user creation.');
    console.log(`   Email: admin@fcf.org`);
  } else {
    // Create admin user with a secure password
    // IMPORTANT: Change this password immediately after first login!
    const adminPasswordHash = await bcrypt.hash('ChangeMe123!', 10);
    
    const adminUser = await prisma.user.create({
      data: {
        organizationId: organization.id,
        email: 'admin@fcf.org',
        name: 'System Administrator',
        passwordHash: adminPasswordHash,
        isActive: true,
      },
    });

    // Assign admin role
    await prisma.userRole.create({
      data: {
        userId: adminUser.id,
        roleId: adminRole.id,
      },
    });

    console.log('✅ Admin user created');
    console.log('');
    console.log('⚠️  IMPORTANT: Change the default password immediately!');
    console.log('');
    console.log('📝 Login credentials:');
    console.log('   Email: admin@fcf.org');
    console.log('   Password: ChangeMe123!');
    console.log('');
    console.log('🔒 Please change this password after first login!');
  }

  // Create vendor source if it doesn't exist
  const existingVendorSource = await prisma.vendorSource.findFirst({
    where: {
      organizationId: organization.id,
      name: 'Manual Entry',
    },
  });

  if (!existingVendorSource) {
    await prisma.vendorSource.create({
      data: {
        organizationId: organization.id,
        name: 'Manual Entry',
      },
    });
    console.log('✅ Vendor source created');
  } else {
    console.log('✅ Vendor source already exists');
  }

  console.log('');
  console.log('🎉 Production database seed completed successfully!');
  console.log('');
  console.log('📊 Summary:');
  console.log(`   Organization: ${organization.name}`);
  console.log(`   Organization ID: ${organization.id}`);
  console.log(`   Roles: admin, user, manager`);
  console.log(`   Admin user: ${existingAdmin ? 'Already exists' : 'Created'}`);
  console.log('');
  console.log('🚀 Next steps:');
  console.log('   1. Login with admin credentials');
  console.log('   2. Change the default password');
  console.log('   3. Create additional users as needed');
  console.log('   4. Configure organization settings');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

