-- CreateTable: Organization
CREATE TABLE "organizations" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "domain" TEXT,
    "plan" TEXT NOT NULL DEFAULT 'trial',
    "status" TEXT NOT NULL DEFAULT 'active',
    "trial_ends_at" TIMESTAMP(3),
    "logo_url" TEXT,
    "primary_color" TEXT,
    "settings" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "organizations_slug_key" ON "organizations"("slug");
CREATE UNIQUE INDEX "organizations_domain_key" ON "organizations"("domain");
CREATE INDEX "organizations_slug_idx" ON "organizations"("slug");
CREATE INDEX "organizations_status_idx" ON "organizations"("status");

-- Step 1: Create default FCF organization
INSERT INTO "organizations" ("id", "name", "slug", "plan", "status", "created_at", "updated_at")
VALUES (
    'fcf-default-org-id',
    'Foster Care Foundation',
    'fcf',
    'enterprise',
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Step 2: Add organization_id columns (nullable first)
ALTER TABLE "users" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "vendor_sources" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "programs" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "workers" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "clients" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "cases" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "children" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "families" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "assessments" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "education_records" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "medical_records" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "behavioral_incidents" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "goals" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "child_notes" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "home_visits" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "report_definitions" ADD COLUMN "organization_id" TEXT;
ALTER TABLE "kpi_daily" ADD COLUMN "organization_id" TEXT;

-- Step 3: Populate organization_id with FCF default
UPDATE "users" SET "organization_id" = 'fcf-default-org-id';
UPDATE "vendor_sources" SET "organization_id" = 'fcf-default-org-id';
UPDATE "programs" SET "organization_id" = 'fcf-default-org-id';
UPDATE "workers" SET "organization_id" = 'fcf-default-org-id';
UPDATE "clients" SET "organization_id" = 'fcf-default-org-id';
UPDATE "cases" SET "organization_id" = 'fcf-default-org-id';
UPDATE "children" SET "organization_id" = 'fcf-default-org-id';
UPDATE "families" SET "organization_id" = 'fcf-default-org-id';
UPDATE "assessments" SET "organization_id" = 'fcf-default-org-id';
UPDATE "education_records" SET "organization_id" = 'fcf-default-org-id';
UPDATE "medical_records" SET "organization_id" = 'fcf-default-org-id';
UPDATE "behavioral_incidents" SET "organization_id" = 'fcf-default-org-id';
UPDATE "goals" SET "organization_id" = 'fcf-default-org-id';
UPDATE "child_notes" SET "organization_id" = 'fcf-default-org-id';
UPDATE "home_visits" SET "organization_id" = 'fcf-default-org-id';
UPDATE "report_definitions" SET "organization_id" = 'fcf-default-org-id';
UPDATE "kpi_daily" SET "organization_id" = 'fcf-default-org-id';

-- Step 4: Make organization_id NOT NULL
ALTER TABLE "users" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "vendor_sources" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "programs" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "workers" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "clients" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "cases" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "children" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "families" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "assessments" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "education_records" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "medical_records" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "behavioral_incidents" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "goals" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "child_notes" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "home_visits" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "report_definitions" ALTER COLUMN "organization_id" SET NOT NULL;
ALTER TABLE "kpi_daily" ALTER COLUMN "organization_id" SET NOT NULL;

-- Step 5: Add foreign key constraints
ALTER TABLE "users" ADD CONSTRAINT "users_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "vendor_sources" ADD CONSTRAINT "vendor_sources_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "programs" ADD CONSTRAINT "programs_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "workers" ADD CONSTRAINT "workers_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "clients" ADD CONSTRAINT "clients_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cases" ADD CONSTRAINT "cases_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "children" ADD CONSTRAINT "children_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "families" ADD CONSTRAINT "families_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "assessments" ADD CONSTRAINT "assessments_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "education_records" ADD CONSTRAINT "education_records_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "behavioral_incidents" ADD CONSTRAINT "behavioral_incidents_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "goals" ADD CONSTRAINT "goals_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "child_notes" ADD CONSTRAINT "child_notes_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "home_visits" ADD CONSTRAINT "home_visits_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "report_definitions" ADD CONSTRAINT "report_definitions_organization_id_fkey" 
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "kpi_daily" ADD CONSTRAINT "kpi_daily_organization_id_fkey"
    FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Step 6: Create indexes for organization_id
CREATE INDEX "users_organization_id_idx" ON "users"("organization_id");
CREATE INDEX "vendor_sources_organization_id_idx" ON "vendor_sources"("organization_id");
CREATE INDEX "programs_organization_id_idx" ON "programs"("organization_id");
CREATE INDEX "workers_organization_id_idx" ON "workers"("organization_id");
CREATE INDEX "clients_organization_id_idx" ON "clients"("organization_id");
CREATE INDEX "cases_organization_id_idx" ON "cases"("organization_id");
CREATE INDEX "children_organization_id_idx" ON "children"("organization_id");
CREATE INDEX "families_organization_id_idx" ON "families"("organization_id");
CREATE INDEX "assessments_organization_id_idx" ON "assessments"("organization_id");
CREATE INDEX "education_records_organization_id_idx" ON "education_records"("organization_id");
CREATE INDEX "medical_records_organization_id_idx" ON "medical_records"("organization_id");
CREATE INDEX "behavioral_incidents_organization_id_idx" ON "behavioral_incidents"("organization_id");
CREATE INDEX "goals_organization_id_idx" ON "goals"("organization_id");
CREATE INDEX "child_notes_organization_id_idx" ON "child_notes"("organization_id");
CREATE INDEX "home_visits_organization_id_idx" ON "home_visits"("organization_id");
CREATE INDEX "report_definitions_organization_id_idx" ON "report_definitions"("organization_id");
CREATE INDEX "kpi_daily_organization_id_idx" ON "kpi_daily"("organization_id");

-- Step 7: Create composite indexes for common queries
CREATE INDEX "clients_organization_id_status_idx" ON "clients"("organization_id", "status");
CREATE INDEX "cases_organization_id_status_idx" ON "cases"("organization_id", "status");
CREATE INDEX "children_organization_id_status_idx" ON "children"("organization_id", "status");

-- Step 8: Update unique constraints to be org-scoped
-- Drop old unique constraints
DROP INDEX IF EXISTS "vendor_sources_name_key";
DROP INDEX IF EXISTS "programs_name_key";
DROP INDEX IF EXISTS "workers_email_key";
DROP INDEX IF EXISTS "kpi_daily_date_program_id_worker_id_key";

-- Create new org-scoped unique constraints
CREATE UNIQUE INDEX "vendor_sources_organization_id_name_key" ON "vendor_sources"("organization_id", "name");
CREATE UNIQUE INDEX "programs_organization_id_name_key" ON "programs"("organization_id", "name");
CREATE UNIQUE INDEX "workers_organization_id_email_key" ON "workers"("organization_id", "email");
CREATE UNIQUE INDEX "kpi_daily_organization_id_date_program_id_worker_id_key"
    ON "kpi_daily"("organization_id", "date", "program_id", "worker_id");

