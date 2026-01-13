const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  // Check if children table exists and has organization_id column
  const result = await prisma.$queryRaw`
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name = 'children' 
    ORDER BY ordinal_position;
  `;
  
  console.log('Children table columns:');
  console.log(result);
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());

