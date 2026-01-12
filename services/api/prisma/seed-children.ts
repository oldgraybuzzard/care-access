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

  // Create education records for Emma
  const emmaEd1 = await prisma.educationRecord.create({
    data: {
      childId: child1.id,
      schoolYear: '2023-2024',
      schoolName: 'Springfield Elementary School',
      gradeLevel: '3rd Grade',
      gpa: 3.2,
      readingLevel: 'Grade Level',
      mathLevel: 'Below Grade Level',
      strugglingSubjects: ['Math', 'Science'],
      daysPresent: 145,
      daysAbsent: 15,
      tardies: 8,
      suspensions: 0,
      detentions: 2,
      hasIep: true,
      has504Plan: false,
      specialServices: ['Speech Therapy', 'Counseling'],
      teacherFeedback: 'Emma is a bright and creative student. She struggles with focus and completing assignments on time. She works well in small groups and responds positively to encouragement. Her anxiety sometimes interferes with her ability to participate in class.',
      extracurricular: ['Art Club', 'School Choir'],
    },
  });

  const emmaEd2 = await prisma.educationRecord.create({
    data: {
      childId: child1.id,
      schoolYear: '2022-2023',
      schoolName: 'Springfield Elementary School',
      gradeLevel: '2nd Grade',
      gpa: 3.5,
      readingLevel: 'Above Grade Level',
      mathLevel: 'Grade Level',
      strugglingSubjects: [],
      daysPresent: 155,
      daysAbsent: 10,
      tardies: 5,
      suspensions: 0,
      detentions: 0,
      hasIep: false,
      has504Plan: false,
      teacherFeedback: 'Emma is doing well academically. She is a joy to have in class and gets along well with her peers.',
      extracurricular: ['Art Club'],
    },
  });

  // Create education records for Marcus
  const marcusEd1 = await prisma.educationRecord.create({
    data: {
      childId: child2.id,
      schoolYear: '2023-2024',
      schoolName: 'Lincoln Middle School',
      gradeLevel: '7th Grade',
      gpa: 2.1,
      readingLevel: 'Below Grade Level',
      mathLevel: 'Below Grade Level',
      strugglingSubjects: ['English', 'Math', 'History'],
      daysPresent: 120,
      daysAbsent: 35,
      tardies: 22,
      suspensions: 3,
      detentions: 8,
      hasIep: true,
      has504Plan: true,
      specialServices: ['Special Education', 'Behavioral Support', 'Counseling'],
      teacherFeedback: 'Marcus has significant behavioral challenges that interfere with his learning. He can be disruptive in class and has difficulty following directions. However, when engaged in topics he cares about (especially sports), he shows potential. He needs consistent structure and positive reinforcement.',
      extracurricular: ['Basketball Team'],
    },
  });

  const marcusEd2 = await prisma.educationRecord.create({
    data: {
      childId: child2.id,
      schoolYear: '2022-2023',
      schoolName: 'Lincoln Middle School',
      gradeLevel: '6th Grade',
      gpa: 1.8,
      readingLevel: 'Below Grade Level',
      mathLevel: 'Below Grade Level',
      strugglingSubjects: ['All subjects'],
      daysPresent: 100,
      daysAbsent: 55,
      tardies: 30,
      suspensions: 5,
      detentions: 12,
      hasIep: true,
      has504Plan: false,
      specialServices: ['Special Education', 'Counseling'],
      teacherFeedback: 'Marcus struggles significantly with attendance and behavior. Multiple interventions have been attempted with limited success.',
      extracurricular: [],
    },
  });

  console.log('✅ Created family:', family.familyName);
  console.log('✅ Created child:', child1.firstName, child1.lastName);
  console.log('✅ Created child:', child2.firstName, child2.lastName);
  console.log('✅ Created education records for Emma:', 2);
  console.log('✅ Created education records for Marcus:', 2);
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

