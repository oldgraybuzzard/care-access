-- DropIndex
DROP INDEX "cases_status_idx";

-- DropIndex
DROP INDEX "children_status_idx";

-- DropIndex
DROP INDEX "clients_status_idx";

-- AlterTable
ALTER TABLE "organizations" ADD COLUMN     "address" TEXT,
ADD COLUMN     "city" TEXT,
ADD COLUMN     "country" TEXT DEFAULT 'USA',
ADD COLUMN     "description" TEXT,
ADD COLUMN     "email" TEXT,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "state" TEXT,
ADD COLUMN     "website" TEXT,
ADD COLUMN     "zip_code" TEXT;
