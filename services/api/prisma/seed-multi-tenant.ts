import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding multi-tenant test data...');

  // Create Organization 1: Foster Care Foundation
  const org1 = await prisma.organization.upsert({
    where: { slug: 'fcf' },
    update: {},
    create: {
      id: 'fcf-default-org-id',
      name: 'Foster Care Foundation',
      slug: 'fcf',
      plan: 'enterprise',
      status: 'active',
    } as any,
  });

  // Create Organization 2: Hope Family Services
  const org2 = await prisma.organization.upsert({
    where: { slug: 'hope' },
    update: {},
    create: {
      name: 'Hope Family Services',
      slug: 'hope',
      plan: 'professional',
      status: 'active',
    } as any,
  });

  // Create Organization 3: Caring Hearts
  const org3 = await prisma.organization.upsert({
    where: { slug: 'caring-hearts' },
    update: {},
    create: {
      name: 'Caring Hearts',
      slug: 'caring-hearts',
      plan: 'basic',
      status: 'active',
    } as any,
  });

  console.log('✅ Organizations created');

  // Create users for each organization
  const passwordHash = await bcrypt.hash('password123', 10);

  const user1 = await prisma.user.upsert({
    where: { email: 'admin@fcf.org' },
    update: {},
    create: {
      organizationId: org1.id,
      email: 'admin@fcf.org',
      name: 'FCF Admin',
      passwordHash,
      isActive: true,
    },
  });

  const user2 = await prisma.user.upsert({
    where: { email: 'admin@hope.org' },
    update: {},
    create: {
      organizationId: org2.id,
      email: 'admin@hope.org',
      name: 'Hope Admin',
      passwordHash,
      isActive: true,
    },
  });

  const user3 = await prisma.user.upsert({
    where: { email: 'admin@caring.org' },
    update: {},
    create: {
      organizationId: org3.id,
      email: 'admin@caring.org',
      name: 'Caring Admin',
      passwordHash,
      isActive: true,
    },
  });

  console.log('✅ Users created');

  // Create test children for each organization
  const child1 = await prisma.child.create({
    data: {
      organizationId: org1.id,
      firstName: 'Emma',
      lastName: 'Johnson',
      dateOfBirth: new Date('2015-03-15'),
      gender: 'Female',
      status: 'Active',
      medications: [],
      allergies: [],
      medicalConditions: [],
      mentalHealthDx: [],
      triggers: [],
      copingMechanisms: [],
      interests: ['Art', 'Reading'],
      strengths: ['Creative', 'Kind'],
      likes: ['Drawing'],
      dislikes: ['Loud noises'],
      fears: [],
    } as any,
  });

  const child2 = await prisma.child.create({
    data: {
      organizationId: org2.id,
      firstName: 'Michael',
      lastName: 'Smith',
      dateOfBirth: new Date('2014-07-22'),
      gender: 'Male',
      status: 'Active',
      medications: [],
      allergies: [],
      medicalConditions: [],
      mentalHealthDx: [],
      triggers: [],
      copingMechanisms: [],
      interests: ['Sports', 'Music'],
      strengths: ['Athletic', 'Friendly'],
      likes: ['Basketball'],
      dislikes: ['Homework'],
      fears: [],
    } as any,
  });

  const child3 = await prisma.child.create({
    data: {
      organizationId: org3.id,
      firstName: 'Sophia',
      lastName: 'Williams',
      dateOfBirth: new Date('2016-11-08'),
      gender: 'Female',
      status: 'Active',
      medications: [],
      allergies: [],
      medicalConditions: [],
      mentalHealthDx: [],
      triggers: [],
      copingMechanisms: [],
      interests: ['Dance', 'Animals'],
      strengths: ['Energetic', 'Caring'],
      likes: ['Pets'],
      dislikes: ['Being alone'],
      fears: [],
    } as any,
  });

  console.log('✅ Children created');

  console.log('\n🎉 Multi-tenant test data seeded successfully!');
  console.log('\n📝 Test Accounts:');
  console.log('   Org 1 (FCF): admin@fcf.org / password123');
  console.log('   Org 2 (Hope): admin@hope.org / password123');
  console.log('   Org 3 (Caring): admin@caring.org / password123');
  console.log('\n📊 Test Data:');
  console.log(`   Org 1: ${child1.firstName} ${child1.lastName}`);
  console.log(`   Org 2: ${child2.firstName} ${child2.lastName}`);
  console.log(`   Org 3: ${child3.firstName} ${child3.lastName}`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

