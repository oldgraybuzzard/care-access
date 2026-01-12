-- ROLLBACK SCRIPT FOR MULTI-TENANCY MIGRATION
-- WARNING: This will remove all organization data and revert to single-tenant mode
-- Only use this if you need to rollback the multi-tenancy changes

-- Step 1: Drop composite indexes
DROP INDEX IF EXISTS "clients_organization_id_status_idx";
DROP INDEX IF EXISTS "cases_organization_id_status_idx";
DROP INDEX IF EXISTS "children_organization_id_status_idx";

-- Step 2: Drop organization_id indexes
DROP INDEX IF EXISTS "users_organization_id_idx";
DROP INDEX IF EXISTS "vendor_sources_organization_id_idx";
DROP INDEX IF EXISTS "programs_organization_id_idx";
DROP INDEX IF EXISTS "workers_organization_id_idx";
DROP INDEX IF EXISTS "clients_organization_id_idx";
DROP INDEX IF EXISTS "cases_organization_id_idx";
DROP INDEX IF EXISTS "children_organization_id_idx";
DROP INDEX IF EXISTS "families_organization_id_idx";
DROP INDEX IF EXISTS "assessments_organization_id_idx";
DROP INDEX IF EXISTS "education_records_organization_id_idx";
DROP INDEX IF EXISTS "medical_records_organization_id_idx";
DROP INDEX IF EXISTS "behavioral_incidents_organization_id_idx";
DROP INDEX IF EXISTS "goals_organization_id_idx";
DROP INDEX IF EXISTS "child_notes_organization_id_idx";
DROP INDEX IF EXISTS "home_visits_organization_id_idx";
DROP INDEX IF EXISTS "report_definitions_organization_id_idx";
DROP INDEX IF EXISTS "kpi_daily_organization_id_idx";

-- Step 3: Drop org-scoped unique constraints
DROP INDEX IF EXISTS "vendor_sources_organization_id_name_key";
DROP INDEX IF EXISTS "programs_organization_id_name_key";
DROP INDEX IF EXISTS "workers_organization_id_email_key";
DROP INDEX IF EXISTS "kpi_daily_organization_id_date_program_id_worker_id_key";

-- Step 4: Recreate original unique constraints
CREATE UNIQUE INDEX "vendor_sources_name_key" ON "vendor_sources"("name");
CREATE UNIQUE INDEX "programs_name_key" ON "programs"("name");
CREATE UNIQUE INDEX "workers_email_key" ON "workers"("email");
CREATE UNIQUE INDEX "kpi_daily_date_program_id_worker_id_key" ON "kpi_daily"("date", "program_id", "worker_id");

-- Step 5: Drop foreign key constraints
ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_organization_id_fkey";
ALTER TABLE "vendor_sources" DROP CONSTRAINT IF EXISTS "vendor_sources_organization_id_fkey";
ALTER TABLE "programs" DROP CONSTRAINT IF EXISTS "programs_organization_id_fkey";
ALTER TABLE "workers" DROP CONSTRAINT IF EXISTS "workers_organization_id_fkey";
ALTER TABLE "clients" DROP CONSTRAINT IF EXISTS "clients_organization_id_fkey";
ALTER TABLE "cases" DROP CONSTRAINT IF EXISTS "cases_organization_id_fkey";
ALTER TABLE "children" DROP CONSTRAINT IF EXISTS "children_organization_id_fkey";
ALTER TABLE "families" DROP CONSTRAINT IF EXISTS "families_organization_id_fkey";
ALTER TABLE "assessments" DROP CONSTRAINT IF EXISTS "assessments_organization_id_fkey";
ALTER TABLE "education_records" DROP CONSTRAINT IF EXISTS "education_records_organization_id_fkey";
ALTER TABLE "medical_records" DROP CONSTRAINT IF EXISTS "medical_records_organization_id_fkey";
ALTER TABLE "behavioral_incidents" DROP CONSTRAINT IF EXISTS "behavioral_incidents_organization_id_fkey";
ALTER TABLE "goals" DROP CONSTRAINT IF EXISTS "goals_organization_id_fkey";
ALTER TABLE "child_notes" DROP CONSTRAINT IF EXISTS "child_notes_organization_id_fkey";
ALTER TABLE "home_visits" DROP CONSTRAINT IF EXISTS "home_visits_organization_id_fkey";
ALTER TABLE "report_definitions" DROP CONSTRAINT IF EXISTS "report_definitions_organization_id_fkey";
ALTER TABLE "kpi_daily" DROP CONSTRAINT IF EXISTS "kpi_daily_organization_id_fkey";

-- Step 6: Drop organization_id columns
ALTER TABLE "users" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "vendor_sources" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "programs" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "workers" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "clients" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "cases" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "children" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "families" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "assessments" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "education_records" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "medical_records" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "behavioral_incidents" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "goals" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "child_notes" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "home_visits" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "report_definitions" DROP COLUMN IF EXISTS "organization_id";
ALTER TABLE "kpi_daily" DROP COLUMN IF EXISTS "organization_id";

-- Step 7: Drop organizations table
DROP TABLE IF EXISTS "organizations";

