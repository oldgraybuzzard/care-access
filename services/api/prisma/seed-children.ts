import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding children data...');

  // Create a family
  const family = await prisma.family.create({
    data: {
      familyName: 'Johnson Family',
      primaryContact: 'Sarah Johnson',
      phone: '(555) 123-4567',
      email: 'sarah.johnson@example.com',
      address: '123 Main Street',
      city: 'Springfield',
      state: 'IL',
      zipCode: '62701',
      housingType: 'House',
      housingStatus: 'Rented',
      householdIncome: '$30,000 - $50,000',
      employmentStatus: 'Employed',
      familyComposition: [
        { name: 'Sarah Johnson', relationship: 'Mother', age: 35, living_in_home: true },
        { name: 'Michael Johnson', relationship: 'Father', age: 37, living_in_home: false },
      ],
      supportNetwork: ['Grandmother (Mary)', 'Church Community', 'School Counselor'],
      familyStressors: ['Financial stress', 'Single parent household'],
      familyStrengths: ['Strong family bonds', 'Community support', 'Resilience'],
    },
  });

  // Create children
  const child1 = await prisma.child.create({
    data: {
      firstName: 'Emma',
      middleName: 'Grace',
      lastName: 'Johnson',
      nickname: 'Em',
      dateOfBirth: new Date('2015-03-15'),
      gender: 'Female',
      raceEthnicity: 'Caucasian',
      preferredLanguage: 'English',
      status: 'Active',
      custodyStatus: 'Biological Family',
      legalStatus: 'No court involvement',
      referralSource: 'School',
      referralReason: 'Behavioral concerns at school',
      presentingIssues: 'Difficulty focusing in class, occasional outbursts, anxiety about family situation',
      familyId: family.id,
      medications: [
        { name: 'Adderall XR', dosage: '10mg', frequency: 'Once daily', prescriber: 'Dr. Smith' },
      ],
      allergies: [
        { type: 'Food', allergen: 'Peanuts', severity: 'Severe', reaction: 'Anaphylaxis' },
        { type: 'Environmental', allergen: 'Bee stings', severity: 'Moderate', reaction: 'Swelling' },
      ],
      medicalConditions: [
        { condition: 'ADHD', diagnosis_date: '2022-01-15', treating_physician: 'Dr. Smith' },
      ],
      mentalHealthDx: [
        { diagnosis: 'Anxiety Disorder', diagnosed_by: 'Dr. Williams', date: '2023-05-20' },
      ],
      triggers: [
        'Loud noises',
        'Sudden changes in routine',
        'Talking about parents\' separation',
      ],
      copingMechanisms: [
        'Deep breathing exercises',
        'Drawing and art',
        'Talking to trusted adults',
        'Playing with therapy dog',
      ],
      traumaHistory: 'Witnessed domestic violence between parents before separation. Parents divorced when she was 7 years old.',
      attachmentStyle: 'Anxious-Ambivalent',
      interests: ['Drawing', 'Reading', 'Animals', 'Music'],
      strengths: ['Creative', 'Empathetic', 'Intelligent', 'Artistic'],
      likes: ['Pizza', 'Cats', 'Purple color', 'Harry Potter books'],
      dislikes: ['Loud noises', 'Spicy food', 'Being alone'],
      fears: ['Thunderstorms', 'Parents fighting', 'Being abandoned'],
      emergencyContacts: [
        { name: 'Sarah Johnson', relationship: 'Mother', phone: '(555) 123-4567' },
        { name: 'Mary Johnson', relationship: 'Grandmother', phone: '(555) 987-6543' },
      ],
    },
  });

  const child2 = await prisma.child.create({
    data: {
      firstName: 'Marcus',
      lastName: 'Thompson',
      nickname: 'Marc',
      dateOfBirth: new Date('2012-08-22'),
      gender: 'Male',
      raceEthnicity: 'African American',
      preferredLanguage: 'English',
      status: 'Active',
      custodyStatus: 'Foster Care',
      legalStatus: 'Dependency case - reunification plan',
      referralSource: 'DCF',
      referralReason: 'Neglect and abuse',
      presentingIssues: 'Trust issues, anger management, academic struggles, history of trauma',
      medications: [],
      allergies: [],
      medicalConditions: [],
      mentalHealthDx: [
        { diagnosis: 'PTSD', diagnosed_by: 'Dr. Martinez', date: '2023-02-10' },
        { diagnosis: 'Oppositional Defiant Disorder', diagnosed_by: 'Dr. Martinez', date: '2023-02-10' },
      ],
      triggers: [
        'Authority figures raising their voice',
        'Physical touch without warning',
        'Feeling trapped or cornered',
      ],
      copingMechanisms: [
        'Basketball',
        'Listening to music',
        'Writing in journal',
        'Talking to mentor',
      ],
      traumaHistory: 'Experienced physical abuse and neglect from biological parents. Multiple foster placements before current stable placement.',
      attachmentStyle: 'Disorganized',
      interests: ['Basketball', 'Video games', 'Rap music', 'Cooking'],
      strengths: ['Athletic', 'Loyal to friends', 'Protective of younger kids', 'Good at sports'],
      likes: ['Basketball', 'Pizza', 'Video games', 'Dogs'],
      dislikes: ['Being told what to do', 'Vegetables', 'Reading'],
      fears: ['Being sent back to biological parents', 'Losing current foster family', 'Failure'],
      emergencyContacts: [
        { name: 'Jennifer Foster', relationship: 'Foster Mother', phone: '(555) 234-5678' },
        { name: 'Case Manager', relationship: 'DCF Worker', phone: '(555) 111-2222' },
      ],
    },
  });

  console.log('✅ Created family:', family.familyName);
  console.log('✅ Created child:', child1.firstName, child1.lastName);
  console.log('✅ Created child:', child2.firstName, child2.lastName);
  console.log('🎉 Seeding complete!');
}

main()
  .catch((e) => {
    console.error('❌ Error seeding data:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

