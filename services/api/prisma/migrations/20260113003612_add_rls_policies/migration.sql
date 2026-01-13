-- Enable Row-Level Security (RLS) for multi-tenant isolation
-- This provides database-level enforcement of tenant boundaries

-- Enable RLS on all tenant-scoped tables (child-centered models)
ALTER TABLE "children" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "families" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "assessments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "education_records" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "medical_records" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "behavioral_incidents" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "goals" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "child_notes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "home_visits" ENABLE ROW LEVEL SECURITY;

-- Enable RLS on case management tables
ALTER TABLE "cases" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "clients" ENABLE ROW LEVEL SECURITY;

-- Enable RLS on reference data tables
ALTER TABLE "workers" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "programs" ENABLE ROW LEVEL SECURITY;

-- Enable RLS on vendor integration tables
ALTER TABLE "vendor_sources" ENABLE ROW LEVEL SECURITY;

-- Enable RLS on reporting tables
ALTER TABLE "report_definitions" ENABLE ROW LEVEL SECURITY;
-- Note: report_runs doesn't have organization_id, so no RLS

-- Create RLS policy for children table
-- Allows access only to rows where organization_id matches the session variable
-- SuperAdmins are explicitly blocked (app.is_superadmin = 'true' means NO ACCESS)
DROP POLICY IF EXISTS tenant_isolation_policy ON "children";
CREATE POLICY tenant_isolation_policy ON "children"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for families table
DROP POLICY IF EXISTS tenant_isolation_policy ON "families";
CREATE POLICY tenant_isolation_policy ON "families"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for assessments table
DROP POLICY IF EXISTS tenant_isolation_policy ON "assessments";
CREATE POLICY tenant_isolation_policy ON "assessments"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for education_records table
DROP POLICY IF EXISTS tenant_isolation_policy ON "education_records";
CREATE POLICY tenant_isolation_policy ON "education_records"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for medical_records table
DROP POLICY IF EXISTS tenant_isolation_policy ON "medical_records";
CREATE POLICY tenant_isolation_policy ON "medical_records"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for behavioral_incidents table
DROP POLICY IF EXISTS tenant_isolation_policy ON "behavioral_incidents";
CREATE POLICY tenant_isolation_policy ON "behavioral_incidents"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for goals table
DROP POLICY IF EXISTS tenant_isolation_policy ON "goals";
CREATE POLICY tenant_isolation_policy ON "goals"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for child_notes table
DROP POLICY IF EXISTS tenant_isolation_policy ON "child_notes";
CREATE POLICY tenant_isolation_policy ON "child_notes"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for home_visits table
DROP POLICY IF EXISTS tenant_isolation_policy ON "home_visits";
CREATE POLICY tenant_isolation_policy ON "home_visits"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for cases table
DROP POLICY IF EXISTS tenant_isolation_policy ON "cases";
CREATE POLICY tenant_isolation_policy ON "cases"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for clients table
DROP POLICY IF EXISTS tenant_isolation_policy ON "clients";
CREATE POLICY tenant_isolation_policy ON "clients"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for workers table
DROP POLICY IF EXISTS tenant_isolation_policy ON "workers";
CREATE POLICY tenant_isolation_policy ON "workers"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for programs table
DROP POLICY IF EXISTS tenant_isolation_policy ON "programs";
CREATE POLICY tenant_isolation_policy ON "programs"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for vendor_sources table
DROP POLICY IF EXISTS tenant_isolation_policy ON "vendor_sources";
CREATE POLICY tenant_isolation_policy ON "vendor_sources"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Create RLS policy for report_definitions table
DROP POLICY IF EXISTS tenant_isolation_policy ON "report_definitions";
CREATE POLICY tenant_isolation_policy ON "report_definitions"
  USING (
    "organization_id"::text = current_setting('app.organization_id', true)
    AND COALESCE(current_setting('app.is_superadmin', true), 'false') = 'false'
  );

-- Note: report_runs doesn't have organization_id - it gets org through reportDefinition relation
-- So we don't add RLS to report_runs

-- Note: SuperAdmins are blocked from accessing organizational data by the app.is_superadmin = 'false' check
-- This ensures that even at the database level, SuperAdmins cannot access tenant data
-- SuperAdmins can only access platform-level tables (organizations, users, roles, etc.)