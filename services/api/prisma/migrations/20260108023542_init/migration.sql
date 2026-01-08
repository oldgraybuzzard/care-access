-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "user_id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("user_id","role_id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "action" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" TEXT,
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendor_sources" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "vendor_sources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendor_tokens" (
    "id" TEXT NOT NULL,
    "source_id" TEXT NOT NULL,
    "access_token" TEXT NOT NULL,
    "refresh_token" TEXT,
    "expires_at" TIMESTAMP(3),
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vendor_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "programs" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "programs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clients" (
    "id" TEXT NOT NULL,
    "vendor_source_id" TEXT NOT NULL,
    "vendor_client_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "dob" TIMESTAMP(3),
    "program_id" TEXT,
    "status" TEXT NOT NULL,
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cases" (
    "id" TEXT NOT NULL,
    "vendor_source_id" TEXT NOT NULL,
    "vendor_case_id" TEXT NOT NULL,
    "client_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "opened_at" TIMESTAMP(3) NOT NULL,
    "closed_at" TIMESTAMP(3),
    "assigned_worker_id" TEXT,
    "program_id" TEXT,
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activities" (
    "id" TEXT NOT NULL,
    "vendor_source_id" TEXT NOT NULL,
    "vendor_activity_id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "activity_type" TEXT NOT NULL,
    "occurred_at" TIMESTAMP(3) NOT NULL,
    "summary" TEXT,
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "activities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" TEXT NOT NULL,
    "vendor_source_id" TEXT NOT NULL,
    "vendor_service_id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "service_type" TEXT NOT NULL,
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3),
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" TEXT NOT NULL,
    "vendor_source_id" TEXT NOT NULL,
    "vendor_document_id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "doc_type" TEXT NOT NULL,
    "meta_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "report_definitions" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "owner_user_id" TEXT,
    "definition_json" JSONB NOT NULL,
    "is_shared" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "report_definitions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "report_runs" (
    "id" TEXT NOT NULL,
    "report_definition_id" TEXT NOT NULL,
    "requested_by" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMP(3),
    "row_count" INTEGER,
    "meta_json" JSONB,

    CONSTRAINT "report_runs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kpi_daily" (
    "id" TEXT NOT NULL,
    "program_id" TEXT,
    "worker_id" TEXT,
    "date" DATE NOT NULL,
    "active_cases" INTEGER NOT NULL DEFAULT 0,
    "intakes" INTEGER NOT NULL DEFAULT 0,
    "closures" INTEGER NOT NULL DEFAULT 0,
    "overdue_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kpi_daily_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE INDEX "audit_logs_user_id_idx" ON "audit_logs"("user_id");

-- CreateIndex
CREATE INDEX "audit_logs_entity_type_entity_id_idx" ON "audit_logs"("entity_type", "entity_id");

-- CreateIndex
CREATE INDEX "audit_logs_created_at_idx" ON "audit_logs"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "vendor_sources_name_key" ON "vendor_sources"("name");

-- CreateIndex
CREATE UNIQUE INDEX "programs_name_key" ON "programs"("name");

-- CreateIndex
CREATE UNIQUE INDEX "workers_email_key" ON "workers"("email");

-- CreateIndex
CREATE INDEX "clients_status_idx" ON "clients"("status");

-- CreateIndex
CREATE INDEX "clients_program_id_idx" ON "clients"("program_id");

-- CreateIndex
CREATE UNIQUE INDEX "clients_vendor_source_id_vendor_client_id_key" ON "clients"("vendor_source_id", "vendor_client_id");

-- CreateIndex
CREATE INDEX "cases_client_id_idx" ON "cases"("client_id");

-- CreateIndex
CREATE INDEX "cases_status_idx" ON "cases"("status");

-- CreateIndex
CREATE INDEX "cases_assigned_worker_id_idx" ON "cases"("assigned_worker_id");

-- CreateIndex
CREATE INDEX "cases_program_id_idx" ON "cases"("program_id");

-- CreateIndex
CREATE INDEX "cases_opened_at_idx" ON "cases"("opened_at");

-- CreateIndex
CREATE UNIQUE INDEX "cases_vendor_source_id_vendor_case_id_key" ON "cases"("vendor_source_id", "vendor_case_id");

-- CreateIndex
CREATE INDEX "activities_case_id_idx" ON "activities"("case_id");

-- CreateIndex
CREATE INDEX "activities_activity_type_idx" ON "activities"("activity_type");

-- CreateIndex
CREATE INDEX "activities_occurred_at_idx" ON "activities"("occurred_at");

-- CreateIndex
CREATE UNIQUE INDEX "activities_vendor_source_id_vendor_activity_id_key" ON "activities"("vendor_source_id", "vendor_activity_id");

-- CreateIndex
CREATE INDEX "services_case_id_idx" ON "services"("case_id");

-- CreateIndex
CREATE INDEX "services_service_type_idx" ON "services"("service_type");

-- CreateIndex
CREATE INDEX "services_start_at_idx" ON "services"("start_at");

-- CreateIndex
CREATE UNIQUE INDEX "services_vendor_source_id_vendor_service_id_key" ON "services"("vendor_source_id", "vendor_service_id");

-- CreateIndex
CREATE INDEX "documents_case_id_idx" ON "documents"("case_id");

-- CreateIndex
CREATE INDEX "documents_doc_type_idx" ON "documents"("doc_type");

-- CreateIndex
CREATE UNIQUE INDEX "documents_vendor_source_id_vendor_document_id_key" ON "documents"("vendor_source_id", "vendor_document_id");

-- CreateIndex
CREATE INDEX "report_definitions_type_idx" ON "report_definitions"("type");

-- CreateIndex
CREATE INDEX "report_definitions_owner_user_id_idx" ON "report_definitions"("owner_user_id");

-- CreateIndex
CREATE INDEX "report_runs_report_definition_id_idx" ON "report_runs"("report_definition_id");

-- CreateIndex
CREATE INDEX "report_runs_requested_by_idx" ON "report_runs"("requested_by");

-- CreateIndex
CREATE INDEX "report_runs_status_idx" ON "report_runs"("status");

-- CreateIndex
CREATE INDEX "kpi_daily_date_idx" ON "kpi_daily"("date");

-- CreateIndex
CREATE INDEX "kpi_daily_program_id_idx" ON "kpi_daily"("program_id");

-- CreateIndex
CREATE INDEX "kpi_daily_worker_id_idx" ON "kpi_daily"("worker_id");

-- CreateIndex
CREATE UNIQUE INDEX "kpi_daily_date_program_id_worker_id_key" ON "kpi_daily"("date", "program_id", "worker_id");

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendor_tokens" ADD CONSTRAINT "vendor_tokens_source_id_fkey" FOREIGN KEY ("source_id") REFERENCES "vendor_sources"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clients" ADD CONSTRAINT "clients_vendor_source_id_fkey" FOREIGN KEY ("vendor_source_id") REFERENCES "vendor_sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clients" ADD CONSTRAINT "clients_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_vendor_source_id_fkey" FOREIGN KEY ("vendor_source_id") REFERENCES "vendor_sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_assigned_worker_id_fkey" FOREIGN KEY ("assigned_worker_id") REFERENCES "workers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activities" ADD CONSTRAINT "activities_vendor_source_id_fkey" FOREIGN KEY ("vendor_source_id") REFERENCES "vendor_sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activities" ADD CONSTRAINT "activities_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_vendor_source_id_fkey" FOREIGN KEY ("vendor_source_id") REFERENCES "vendor_sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_vendor_source_id_fkey" FOREIGN KEY ("vendor_source_id") REFERENCES "vendor_sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_definitions" ADD CONSTRAINT "report_definitions_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_runs" ADD CONSTRAINT "report_runs_report_definition_id_fkey" FOREIGN KEY ("report_definition_id") REFERENCES "report_definitions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_runs" ADD CONSTRAINT "report_runs_requested_by_fkey" FOREIGN KEY ("requested_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kpi_daily" ADD CONSTRAINT "kpi_daily_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kpi_daily" ADD CONSTRAINT "kpi_daily_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "workers"("id") ON DELETE SET NULL ON UPDATE CASCADE;
