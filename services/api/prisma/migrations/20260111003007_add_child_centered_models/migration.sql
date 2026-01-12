-- CreateTable
CREATE TABLE "children" (
    "id" TEXT NOT NULL,
    "client_id" TEXT,
    "first_name" TEXT NOT NULL,
    "middle_name" TEXT,
    "last_name" TEXT NOT NULL,
    "nickname" TEXT,
    "date_of_birth" TIMESTAMP(3) NOT NULL,
    "gender" TEXT NOT NULL,
    "race_ethnicity" TEXT,
    "preferred_language" TEXT DEFAULT 'English',
    "photo_url" TEXT,
    "ssn" TEXT,
    "medicaid_id" TEXT,
    "school_id" TEXT,
    "status" TEXT NOT NULL DEFAULT 'Active',
    "custody_status" TEXT,
    "legal_status" TEXT,
    "referral_source" TEXT,
    "referral_reason" TEXT,
    "presenting_issues" TEXT,
    "medications" JSONB,
    "allergies" JSONB,
    "medical_conditions" JSONB,
    "mental_health_dx" JSONB,
    "triggers" JSONB,
    "coping_mechanisms" JSONB,
    "trauma_history" TEXT,
    "attachment_style" TEXT,
    "interests" JSONB,
    "strengths" JSONB,
    "likes" JSONB,
    "dislikes" JSONB,
    "fears" JSONB,
    "emergency_contacts" JSONB,
    "family_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT,

    CONSTRAINT "children_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "families" (
    "id" TEXT NOT NULL,
    "family_name" TEXT NOT NULL,
    "primary_contact" TEXT,
    "phone" TEXT,
    "email" TEXT,
    "address" TEXT,
    "city" TEXT,
    "state" TEXT,
    "zip_code" TEXT,
    "housing_type" TEXT,
    "housing_status" TEXT,
    "household_income" TEXT,
    "employment_status" TEXT,
    "family_composition" JSONB,
    "support_network" JSONB,
    "family_stressors" JSONB,
    "family_strengths" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "families_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessments" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "assessment_type" TEXT NOT NULL,
    "assessment_date" TIMESTAMP(3) NOT NULL,
    "assessor_id" TEXT,
    "emotional_state" JSONB,
    "behavioral_concerns" JSONB,
    "trauma_indicators" JSONB,
    "family_dynamics" JSONB,
    "school_performance" JSONB,
    "social_relationships" JSONB,
    "risk_factors" JSONB,
    "protective_factors" JSONB,
    "recommendations" TEXT,
    "next_review_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "assessments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "education_records" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "school_year" TEXT NOT NULL,
    "school_name" TEXT NOT NULL,
    "grade_level" TEXT NOT NULL,
    "gpa" DOUBLE PRECISION,
    "reading_level" TEXT,
    "math_level" TEXT,
    "struggling_subjects" JSONB,
    "days_present" INTEGER,
    "days_absent" INTEGER,
    "tardies" INTEGER,
    "suspensions" INTEGER,
    "detentions" INTEGER,
    "has_iep" BOOLEAN NOT NULL DEFAULT false,
    "has_504_plan" BOOLEAN NOT NULL DEFAULT false,
    "special_services" JSONB,
    "teacher_feedback" TEXT,
    "extracurricular" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "education_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_records" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "record_type" TEXT NOT NULL,
    "record_date" TIMESTAMP(3) NOT NULL,
    "provider" TEXT,
    "diagnosis" TEXT,
    "treatment" TEXT,
    "prescriptions" JSONB,
    "follow_up_needed" BOOLEAN NOT NULL DEFAULT false,
    "follow_up_date" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "medical_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "behavioral_incidents" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "incident_date" TIMESTAMP(3) NOT NULL,
    "incident_type" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "location" TEXT,
    "trigger" TEXT,
    "antecedent" TEXT,
    "intervention_used" TEXT,
    "outcome" TEXT,
    "injuries_reported" BOOLEAN NOT NULL DEFAULT false,
    "police_involved" BOOLEAN NOT NULL DEFAULT false,
    "follow_up_actions" TEXT,
    "parent_notified" BOOLEAN NOT NULL DEFAULT false,
    "reported_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "behavioral_incidents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "goals" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "case_id" TEXT,
    "goal_category" TEXT NOT NULL,
    "goal_description" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "target_date" TIMESTAMP(3) NOT NULL,
    "completed_date" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'Active',
    "progress_percent" INTEGER NOT NULL DEFAULT 0,
    "success_criteria" JSONB,
    "barriers" JSONB,
    "interventions" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT,

    CONSTRAINT "goals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "goal_progress" (
    "id" TEXT NOT NULL,
    "goal_id" TEXT NOT NULL,
    "progress_date" TIMESTAMP(3) NOT NULL,
    "progress_percent" INTEGER NOT NULL,
    "progress_note" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT,

    CONSTRAINT "goal_progress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "child_notes" (
    "id" TEXT NOT NULL,
    "child_id" TEXT NOT NULL,
    "note_date" TIMESTAMP(3) NOT NULL,
    "note_type" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "is_confidential" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "author_id" TEXT NOT NULL,

    CONSTRAINT "child_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "home_visits" (
    "id" TEXT NOT NULL,
    "family_id" TEXT NOT NULL,
    "visit_date" TIMESTAMP(3) NOT NULL,
    "visit_type" TEXT NOT NULL,
    "purpose" TEXT,
    "observations" TEXT,
    "home_condition" TEXT,
    "family_interaction" TEXT,
    "concerns_identified" JSONB,
    "action_items" JSONB,
    "follow_up_needed" BOOLEAN NOT NULL DEFAULT false,
    "follow_up_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "conducted_by" TEXT NOT NULL,

    CONSTRAINT "home_visits_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "children_client_id_key" ON "children"("client_id");

-- CreateIndex
CREATE INDEX "children_status_idx" ON "children"("status");

-- CreateIndex
CREATE INDEX "children_family_id_idx" ON "children"("family_id");

-- CreateIndex
CREATE INDEX "children_date_of_birth_idx" ON "children"("date_of_birth");

-- CreateIndex
CREATE INDEX "assessments_child_id_idx" ON "assessments"("child_id");

-- CreateIndex
CREATE INDEX "assessments_assessment_date_idx" ON "assessments"("assessment_date");

-- CreateIndex
CREATE INDEX "education_records_child_id_idx" ON "education_records"("child_id");

-- CreateIndex
CREATE INDEX "education_records_school_year_idx" ON "education_records"("school_year");

-- CreateIndex
CREATE INDEX "medical_records_child_id_idx" ON "medical_records"("child_id");

-- CreateIndex
CREATE INDEX "medical_records_record_date_idx" ON "medical_records"("record_date");

-- CreateIndex
CREATE INDEX "behavioral_incidents_child_id_idx" ON "behavioral_incidents"("child_id");

-- CreateIndex
CREATE INDEX "behavioral_incidents_incident_date_idx" ON "behavioral_incidents"("incident_date");

-- CreateIndex
CREATE INDEX "behavioral_incidents_severity_idx" ON "behavioral_incidents"("severity");

-- CreateIndex
CREATE INDEX "goals_child_id_idx" ON "goals"("child_id");

-- CreateIndex
CREATE INDEX "goals_case_id_idx" ON "goals"("case_id");

-- CreateIndex
CREATE INDEX "goals_status_idx" ON "goals"("status");

-- CreateIndex
CREATE INDEX "goal_progress_goal_id_idx" ON "goal_progress"("goal_id");

-- CreateIndex
CREATE INDEX "goal_progress_progress_date_idx" ON "goal_progress"("progress_date");

-- CreateIndex
CREATE INDEX "child_notes_child_id_idx" ON "child_notes"("child_id");

-- CreateIndex
CREATE INDEX "child_notes_note_date_idx" ON "child_notes"("note_date");

-- CreateIndex
CREATE INDEX "child_notes_note_type_idx" ON "child_notes"("note_type");

-- CreateIndex
CREATE INDEX "home_visits_family_id_idx" ON "home_visits"("family_id");

-- CreateIndex
CREATE INDEX "home_visits_visit_date_idx" ON "home_visits"("visit_date");

-- AddForeignKey
ALTER TABLE "children" ADD CONSTRAINT "children_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "children" ADD CONSTRAINT "children_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "families"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessments" ADD CONSTRAINT "assessments_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "education_records" ADD CONSTRAINT "education_records_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "behavioral_incidents" ADD CONSTRAINT "behavioral_incidents_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "goals" ADD CONSTRAINT "goals_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "goals" ADD CONSTRAINT "goals_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "goal_progress" ADD CONSTRAINT "goal_progress_goal_id_fkey" FOREIGN KEY ("goal_id") REFERENCES "goals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "child_notes" ADD CONSTRAINT "child_notes_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "children"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "home_visits" ADD CONSTRAINT "home_visits_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "families"("id") ON DELETE CASCADE ON UPDATE CASCADE;
