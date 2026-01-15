import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

// Faker-like data generators
const firstNames = {
  male: ['James', 'Michael', 'Robert', 'John', 'David', 'William', 'Richard', 'Joseph', 'Thomas', 'Christopher', 'Daniel', 'Matthew', 'Anthony', 'Mark', 'Donald', 'Steven', 'Andrew', 'Kenneth', 'Joshua', 'Kevin'],
  female: ['Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan', 'Jessica', 'Sarah', 'Karen', 'Lisa', 'Nancy', 'Betty', 'Margaret', 'Sandra', 'Ashley', 'Kimberly', 'Emily', 'Donna', 'Michelle'],
};

const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker'];

const cities = ['Springfield', 'Riverside', 'Franklin', 'Greenville', 'Bristol', 'Clinton', 'Fairview', 'Salem', 'Madison', 'Georgetown'];

const states = ['IL', 'CA', 'TX', 'FL', 'NY', 'PA', 'OH', 'GA', 'NC', 'MI'];

const streets = ['Main St', 'Oak Ave', 'Maple Dr', 'Cedar Ln', 'Pine Rd', 'Elm St', 'Washington Blvd', 'Park Ave', 'Lake Dr', 'Hill St'];

const raceEthnicities = ['Caucasian', 'African American', 'Hispanic/Latino', 'Asian', 'Native American', 'Pacific Islander', 'Multiracial'];

const custodyStatuses = ['Biological Family', 'Foster Care', 'Kinship Care', 'Adoptive Family', 'Group Home', 'Residential Treatment'];

const referralSources = ['School', 'DCF', 'Court', 'Hospital', 'Self-Referral', 'Community Agency', 'Police', 'Family Member'];

const mentalHealthDiagnoses = ['ADHD', 'Anxiety Disorder', 'Depression', 'PTSD', 'Bipolar Disorder', 'Autism Spectrum Disorder', 'Oppositional Defiant Disorder', 'Conduct Disorder'];

const interests = ['Sports', 'Art', 'Music', 'Reading', 'Video Games', 'Cooking', 'Dancing', 'Animals', 'Science', 'Technology', 'Theater', 'Photography'];

const strengths = ['Creative', 'Athletic', 'Intelligent', 'Empathetic', 'Resilient', 'Loyal', 'Funny', 'Artistic', 'Leader', 'Good listener'];

const programTypes = ['Individual Therapy', 'Family Therapy', 'Group Therapy', 'Case Management', 'Mentoring', 'Educational Support', 'Life Skills', 'Substance Abuse Treatment'];

// Helper functions
function randomItem<T>(array: T[]): T {
  return array[Math.floor(Math.random() * array.length)];
}

function randomItems<T>(array: T[], count: number): T[] {
  const shuffled = [...array].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}

function randomDate(start: Date, end: Date): Date {
  return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}

function randomAge(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function generateEmail(firstName: string, lastName: string, domain: string = 'example.com'): string {
  return `${firstName.toLowerCase()}.${lastName.toLowerCase()}@${domain}`;
}

function generatePhone(): string {
  const area = Math.floor(Math.random() * 900) + 100;
  const prefix = Math.floor(Math.random() * 900) + 100;
  const line = Math.floor(Math.random() * 9000) + 1000;
  return `(${area}) ${prefix}-${line}`;
}

async function main() {
  console.log('🌱 Starting comprehensive database seed...');
  console.log('⚠️  This will create LOTS of test data for deep testing\n');

  const passwordHash = await bcrypt.hash('password123', 10);

  // Create roles
  console.log('📋 Creating roles...');
  const roles = await Promise.all([
    prisma.role.upsert({
      where: { name: 'superadmin' },
      update: {},
      create: { name: 'superadmin', description: 'Platform administrator' },
    }),
    prisma.role.upsert({
      where: { name: 'admin' },
      update: {},
      create: { name: 'admin', description: 'Organization administrator' },
    }),
    prisma.role.upsert({
      where: { name: 'case_manager' },
      update: {},
      create: { name: 'case_manager', description: 'Case manager' },
    }),
    prisma.role.upsert({
      where: { name: 'therapist' },
      update: {},
      create: { name: 'therapist', description: 'Therapist' },
    }),
    prisma.role.upsert({
      where: { name: 'user' },
      update: {},
      create: { name: 'user', description: 'Standard user' },
    }),
  ]);
  console.log(`✅ Created ${roles.length} roles\n`);

  // Create organizations
  console.log('🏢 Creating organizations...');
  const organizations = await Promise.all([
    prisma.organization.upsert({
      where: { slug: 'careaccess-demo' },
      update: {},
      create: {
        name: 'CareAccess Demo Organization',
        slug: 'careaccess-demo',
        plan: 'enterprise',
        status: 'active',
      },
    }),
    prisma.organization.upsert({
      where: { slug: 'hope-family-services' },
      update: {},
      create: {
        name: 'Hope Family Services',
        slug: 'hope-family-services',
        plan: 'professional',
        status: 'active',
      },
    }),
    prisma.organization.upsert({
      where: { slug: 'caring-hearts' },
      update: {},
      create: {
        name: 'Caring Hearts Foundation',
        slug: 'caring-hearts',
        plan: 'basic',
        status: 'active',
      },
    }),
  ]);
  console.log(`✅ Created ${organizations.length} organizations\n`);

  // Create users for each organization
  console.log('👥 Creating users...');
  const users = [];

  for (const org of organizations) {
    // Admin user
    const adminUser = await prisma.user.upsert({
      where: { email: `admin@${org.slug}.com` },
      update: {},
      create: {
        organizationId: org.id,
        email: `admin@${org.slug}.com`,
        name: `${org.name} Admin`,
        passwordHash,
        isActive: true,
      },
    });
    users.push(adminUser);

    // Create 5-10 staff users per organization
    const staffCount = randomAge(5, 10);
    for (let i = 0; i < staffCount; i++) {
      const gender = Math.random() > 0.5 ? 'male' : 'female';
      const firstName = randomItem(firstNames[gender]);
      const lastName = randomItem(lastNames);

      const user = await prisma.user.create({
        data: {
          organizationId: org.id,
          email: generateEmail(firstName, lastName, `${org.slug}.com`),
          name: `${firstName} ${lastName}`,
          passwordHash,
          isActive: Math.random() > 0.1, // 90% active
        },
      });
      users.push(user);
    }
  }
  console.log(`✅ Created ${users.length} users\n`);

  // Create families and children for each organization
  console.log('👨‍👩‍👧‍👦 Creating families and children...');
  let totalFamilies = 0;
  let totalChildren = 0;
  let totalDocuments = 0;

  for (const org of organizations) {
    const familyCount = randomAge(15, 25); // 15-25 families per org

    for (let f = 0; f < familyCount; f++) {
      const familyLastName = randomItem(lastNames);
      const primaryFirstName = randomItem(firstNames.female);

      // Create family
      const family = await prisma.family.create({
        data: {
          organizationId: org.id,
          familyName: `${familyLastName} Family`,
          primaryContact: `${primaryFirstName} ${familyLastName}`,
          phone: generatePhone(),
          email: generateEmail(primaryFirstName, familyLastName),
          address: `${randomAge(100, 9999)} ${randomItem(streets)}`,
          city: randomItem(cities),
          state: randomItem(states),
          zipCode: String(randomAge(10000, 99999)),
          housingType: randomItem(['House', 'Apartment', 'Townhouse', 'Mobile Home']),
          housingStatus: randomItem(['Owned', 'Rented', 'Subsidized', 'Temporary']),
          householdIncome: randomItem(['< $20,000', '$20,000 - $40,000', '$40,000 - $60,000', '$60,000 - $80,000', '> $80,000']),
          employmentStatus: randomItem(['Employed Full-time', 'Employed Part-time', 'Unemployed', 'Disabled', 'Retired']),
          familyComposition: [
            { name: `${primaryFirstName} ${familyLastName}`, relationship: 'Mother', age: randomAge(25, 50), living_in_home: true },
          ],
        },
      });
      totalFamilies++;

      // Create 1-4 children per family
      const childCount = randomAge(1, 4);

      for (let c = 0; c < childCount; c++) {
        const childGender = Math.random() > 0.5 ? 'Male' : 'Female';
        const childFirstName = randomItem(firstNames[childGender.toLowerCase() as 'male' | 'female']);
        const childAge = randomAge(3, 17);
        const childDOB = new Date();
        childDOB.setFullYear(childDOB.getFullYear() - childAge);

        const hasMentalHealth = Math.random() > 0.4; // 60% have mental health dx
        const mentalHealthDxList = hasMentalHealth
          ? randomItems(mentalHealthDiagnoses, randomAge(1, 3)).map(dx => ({
              diagnosis: dx,
              diagnosed_by: `Dr. ${randomItem(lastNames)}`,
              date: randomDate(new Date(2020, 0, 1), new Date()).toISOString().split('T')[0],
            }))
          : [];

        const child = await prisma.child.create({
          data: {
            organizationId: org.id,
            familyId: family.id,
            firstName: childFirstName,
            lastName: familyLastName,
            nickname: Math.random() > 0.5 ? childFirstName.substring(0, 3) : undefined,
            dateOfBirth: childDOB,
            gender: childGender,
            raceEthnicity: randomItem(raceEthnicities),
            preferredLanguage: 'English',
            status: randomItem(['Active', 'Inactive', 'Discharged']),
            custodyStatus: randomItem(custodyStatuses),
            legalStatus: randomItem(['No court involvement', 'Dependency case', 'Delinquency case', 'Guardianship']),
            referralSource: randomItem(referralSources),
            referralReason: 'Behavioral and emotional support needed',
            presentingIssues: 'Various behavioral and emotional challenges',
            medications: [],
            allergies: Math.random() > 0.7 ? ['Peanuts'] : [],
            medicalConditions: [],
            mentalHealthDx: mentalHealthDxList,
            triggers: randomItems(['Loud noises', 'Crowds', 'Authority figures', 'Physical touch', 'Abandonment'], randomAge(0, 3)),
            copingMechanisms: randomItems(['Deep breathing', 'Exercise', 'Music', 'Art', 'Talking to trusted adult'], randomAge(1, 3)),
            traumaHistory: Math.random() > 0.5 ? 'History of family instability and trauma' : undefined,
            attachmentStyle: randomItem(['Secure', 'Anxious', 'Avoidant', 'Disorganized']),
            interests: randomItems(interests, randomAge(2, 5)),
            strengths: randomItems(strengths, randomAge(2, 4)),
            likes: randomItems(['Pizza', 'Ice cream', 'Video games', 'Sports', 'Music'], randomAge(2, 4)),
            dislikes: randomItems(['Vegetables', 'Homework', 'Bedtime', 'Chores'], randomAge(1, 3)),
            fears: randomItems(['Dark', 'Separation', 'Failure', 'Rejection'], randomAge(0, 2)),
            emergencyContacts: [
              { name: `${primaryFirstName} ${familyLastName}`, relationship: 'Mother', phone: generatePhone() },
            ],
          },
        });
        totalChildren++;

        // Create education records (1-3 per child)
        const eduCount = randomAge(1, 3);
        for (let e = 0; e < eduCount; e++) {
          const schoolYear = 2024 - e;
          await prisma.educationRecord.create({
            data: {
              organizationId: org.id,
              childId: child.id,
              schoolYear: `${schoolYear}-${schoolYear + 1}`,
              schoolName: `${randomItem(cities)} ${randomItem(['Elementary', 'Middle', 'High'])} School`,
              gradeLevel: String(Math.max(1, childAge - 5 - e)),
              gpa: Math.random() > 0.3 ? parseFloat((2.0 + Math.random() * 2.0).toFixed(2)) : undefined,
              daysPresent: randomAge(150, 180),
              daysAbsent: randomAge(0, 15),
              tardies: randomAge(0, 10),
              suspensions: randomAge(0, 2),
              hasIep: Math.random() > 0.7,
              has504Plan: Math.random() > 0.8,
            },
          });
        }

        // Create documents (2-8 per child)
        const docCount = randomAge(2, 8);
        for (let d = 0; d < docCount; d++) {
          const category = randomItem(['photo', 'medical', 'legal', 'education', 'case_note', 'report', 'other']);
          const mimeType = randomItem(['application/pdf', 'image/jpeg', 'image/png']);
          const ext = mimeType === 'application/pdf' ? 'pdf' : mimeType === 'image/jpeg' ? 'jpg' : 'png';

          await prisma.document.create({
            data: {
              organizationId: org.id,
              childId: child.id,
              filename: `${category}-${childFirstName}-${d}.${ext}`,
              storageKey: `test-documents/${org.slug}/${child.id}/${Date.now()}-${d}.${ext}`,
              mimetype: mimeType,
              size: randomAge(50000, 5000000),
              category: category,
              description: `${category.charAt(0).toUpperCase() + category.slice(1)} document for ${childFirstName}`,
              tags: randomItems(['important', 'reviewed', 'archived', 'pending'], randomAge(0, 2)),
              uploadedBy: users.find(u => u.organizationId === org.id)?.id || users[0].id,
            },
          });
          totalDocuments++;
        }
      }
    }
  }

  console.log(`✅ Created ${totalFamilies} families`);
  console.log(`✅ Created ${totalChildren} children`);
  console.log(`✅ Created ${totalDocuments} documents\n`);

  // Create programs
  console.log('📚 Creating programs...');
  let totalPrograms = 0;
  for (const org of organizations) {
    const programCount = randomAge(5, 10);
    for (let p = 0; p < programCount; p++) {
      await prisma.program.create({
        data: {
          organizationId: org.id,
          name: `${randomItem(programTypes)} ${p + 1}`,
        },
      });
      totalPrograms++;
    }
  }
  console.log(`✅ Created ${totalPrograms} programs\n`);

  // Create vendor sources
  console.log('🏪 Creating vendor sources...');
  const vendors = ['ExtendedReach', 'Zoho', 'Internal System', 'Legacy Database'];
  let totalVendors = 0;
  for (const org of organizations) {
    for (const vendor of vendors) {
      await prisma.vendorSource.create({
        data: {
          organizationId: org.id,
          name: vendor,
        },
      });
      totalVendors++;
    }
  }
  console.log(`✅ Created ${totalVendors} vendor sources\n`);

  // Create report definitions
  console.log('📊 Creating report definitions...');
  const reportTypes = [
    { name: 'Children by Status', type: 'standard' },
    { name: 'Services Delivered', type: 'standard' },
    { name: 'Program Enrollment', type: 'standard' },
    { name: 'Monthly Activity Summary', type: 'custom' },
    { name: 'Outcome Metrics', type: 'custom' },
  ];

  let totalReports = 0;
  for (const org of organizations) {
    for (const report of reportTypes) {
      await prisma.reportDefinition.create({
        data: {
          organizationId: org.id,
          name: report.name,
          type: report.type,
          definitionJson: {
            description: `${report.name} report for ${org.name}`,
            filters: ['dateRange', 'status'],
          },
          isShared: Math.random() > 0.5,
        },
      });
      totalReports++;
    }
  }
  console.log(`✅ Created ${totalReports} report definitions\n`);

  // Create SuperAdmin user
  console.log('🔐 Creating SuperAdmin...');
  const superAdmin = await prisma.user.upsert({
    where: { email: 'admin@melkentechwork.com' },
    update: {},
    create: {
      email: 'admin@melkentechwork.com',
      name: 'Platform SuperAdmin',
      passwordHash: await bcrypt.hash('SuperAdmin123!', 10),
      isActive: true,
      organizationId: null, // No organization = SuperAdmin
    },
  });
  console.log('✅ SuperAdmin created\n');

  // Summary
  console.log('═══════════════════════════════════════════════════════');
  console.log('🎉 COMPREHENSIVE DATABASE SEED COMPLETED!');
  console.log('═══════════════════════════════════════════════════════\n');

  console.log('📊 DATA SUMMARY:');
  console.log(`   Organizations: ${organizations.length}`);
  console.log(`   Users: ${users.length}`);
  console.log(`   Families: ${totalFamilies}`);
  console.log(`   Children: ${totalChildren}`);
  console.log(`   Documents: ${totalDocuments}`);
  console.log(`   Programs: ${totalPrograms}`);
  console.log(`   Vendor Sources: ${totalVendors}`);
  console.log(`   Report Definitions: ${totalReports}`);
  console.log(`   Roles: ${roles.length}\n`);

  console.log('🔑 LOGIN CREDENTIALS:\n');
  console.log('   SuperAdmin (Platform):');
  console.log('   📧 Email: admin@melkentechwork.com');
  console.log('   🔒 Password: SuperAdmin123!\n');

  for (const org of organizations) {
    console.log(`   ${org.name}:`);
    console.log(`   📧 Email: admin@${org.slug}.com`);
    console.log(`   🔒 Password: password123\n`);
  }

  console.log('💡 TESTING TIPS:');
  console.log('   • Each organization has 15-25 families');
  console.log('   • Each family has 1-4 children');
  console.log('   • Each child has 2-8 documents');
  console.log('   • 60% of children have mental health diagnoses');
  console.log('   • Documents are in various categories');
  console.log('   • Use different org logins to test multi-tenancy\n');

  console.log('🧪 NEXT STEPS:');
  console.log('   1. Start the API: npm run start:dev');
  console.log('   2. Login with any org admin credentials');
  console.log('   3. Test document upload/download');
  console.log('   4. Test multi-tenant isolation');
  console.log('   5. Run reports and analytics\n');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });


