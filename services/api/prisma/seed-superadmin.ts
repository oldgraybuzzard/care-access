import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🔐 Creating SuperAdmin user...');

  // Create superadmin role if it doesn't exist
  const superadminRole = await prisma.role.upsert({
    where: { name: 'superadmin' },
    update: {},
    create: {
      name: 'superadmin',
      description: 'Platform administrator with NO access to organizational data',
    },
  });

  console.log('✅ SuperAdmin role created/verified');

  // Check if SuperAdmin user already exists
  const existingSuperAdmin = await prisma.user.findUnique({
    where: { email: 'admin@melkentechwork.com' },
  });

  if (existingSuperAdmin) {
    console.log('⚠️  SuperAdmin user already exists.');
    console.log(`   Email: admin@melkentechwork.com`);
    console.log('');
    console.log('To reset password, delete the user and run this script again.');
    return;
  }

  // Create SuperAdmin user with NO organizationId
  // IMPORTANT: Change this password immediately after first login!
  const superadminPasswordHash = await bcrypt.hash('SuperAdmin123!', 10);

  const superadminUser = await prisma.user.create({
    data: {
      organizationId: null, // ← KEY: No organization = platform admin
      email: 'admin@melkentechwork.com',
      name: 'Platform Administrator',
      passwordHash: superadminPasswordHash,
      isActive: true,
    },
  });

  // Assign superadmin role
  await prisma.userRole.create({
    data: {
      userId: superadminUser.id,
      roleId: superadminRole.id,
    },
  });

  console.log('✅ SuperAdmin user created');
  console.log('');
  console.log('⚠️  IMPORTANT: Change the default password immediately!');
  console.log('');
  console.log('📝 SuperAdmin Login Credentials:');
  console.log('   Email: admin@melkentechwork.com');
  console.log('   Password: SuperAdmin123!');
  console.log('');
  console.log('🔒 Security Notes:');
  console.log('   - This user has NO organizationId (null)');
  console.log('   - Cannot access any organizational data');
  console.log('   - Can only manage platform operations');
  console.log('   - All actions are logged separately');
  console.log('');
}

main()
  .catch((e) => {
    console.error('❌ SuperAdmin seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

