--
-- PostgreSQL database dump
--

\restrict cqzEbbOEI8NlcN8KqlLRNPB8cRrdfIa7PM7B3e7YKnAKsOmoWTvPgzxSAaSemVx

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO fcf_user;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.activities (
    id text NOT NULL,
    vendor_source_id text NOT NULL,
    vendor_activity_id text NOT NULL,
    case_id text NOT NULL,
    activity_type text NOT NULL,
    occurred_at timestamp(3) without time zone NOT NULL,
    summary text,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.activities OWNER TO fcf_user;

--
-- Name: assessments; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.assessments (
    id text NOT NULL,
    child_id text NOT NULL,
    assessment_type text NOT NULL,
    assessment_date timestamp(3) without time zone NOT NULL,
    assessor_id text,
    emotional_state jsonb,
    behavioral_concerns jsonb,
    trauma_indicators jsonb,
    family_dynamics jsonb,
    school_performance jsonb,
    social_relationships jsonb,
    risk_factors jsonb,
    protective_factors jsonb,
    recommendations text,
    next_review_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.assessments OWNER TO fcf_user;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.audit_logs (
    id text NOT NULL,
    user_id text,
    action text NOT NULL,
    entity_type text NOT NULL,
    entity_id text,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO fcf_user;

--
-- Name: behavioral_incidents; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.behavioral_incidents (
    id text NOT NULL,
    child_id text NOT NULL,
    incident_date timestamp(3) without time zone NOT NULL,
    incident_type text NOT NULL,
    severity text NOT NULL,
    description text NOT NULL,
    location text,
    trigger text,
    antecedent text,
    intervention_used text,
    outcome text,
    injuries_reported boolean DEFAULT false NOT NULL,
    police_involved boolean DEFAULT false NOT NULL,
    follow_up_actions text,
    parent_notified boolean DEFAULT false NOT NULL,
    reported_by text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.behavioral_incidents OWNER TO fcf_user;

--
-- Name: cases; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.cases (
    id text NOT NULL,
    vendor_source_id text NOT NULL,
    vendor_case_id text NOT NULL,
    client_id text NOT NULL,
    status text NOT NULL,
    opened_at timestamp(3) without time zone NOT NULL,
    closed_at timestamp(3) without time zone,
    assigned_worker_id text,
    program_id text,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.cases OWNER TO fcf_user;

--
-- Name: child_notes; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.child_notes (
    id text NOT NULL,
    child_id text NOT NULL,
    note_date timestamp(3) without time zone NOT NULL,
    note_type text NOT NULL,
    subject text NOT NULL,
    content text NOT NULL,
    is_confidential boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    author_id text NOT NULL
);


ALTER TABLE public.child_notes OWNER TO fcf_user;

--
-- Name: children; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.children (
    id text NOT NULL,
    client_id text,
    first_name text NOT NULL,
    middle_name text,
    last_name text NOT NULL,
    nickname text,
    date_of_birth timestamp(3) without time zone NOT NULL,
    gender text NOT NULL,
    race_ethnicity text,
    preferred_language text DEFAULT 'English'::text,
    photo_url text,
    ssn text,
    medicaid_id text,
    school_id text,
    status text DEFAULT 'Active'::text NOT NULL,
    custody_status text,
    legal_status text,
    referral_source text,
    referral_reason text,
    presenting_issues text,
    medications jsonb,
    allergies jsonb,
    medical_conditions jsonb,
    mental_health_dx jsonb,
    triggers jsonb,
    coping_mechanisms jsonb,
    trauma_history text,
    attachment_style text,
    interests jsonb,
    strengths jsonb,
    likes jsonb,
    dislikes jsonb,
    fears jsonb,
    emergency_contacts jsonb,
    family_id text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by text
);


ALTER TABLE public.children OWNER TO fcf_user;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.clients (
    id text NOT NULL,
    vendor_source_id text NOT NULL,
    vendor_client_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    dob timestamp(3) without time zone,
    program_id text,
    status text NOT NULL,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.clients OWNER TO fcf_user;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.documents (
    id text NOT NULL,
    vendor_source_id text NOT NULL,
    vendor_document_id text NOT NULL,
    case_id text NOT NULL,
    title text NOT NULL,
    doc_type text NOT NULL,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.documents OWNER TO fcf_user;

--
-- Name: education_records; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.education_records (
    id text NOT NULL,
    child_id text NOT NULL,
    school_year text NOT NULL,
    school_name text NOT NULL,
    grade_level text NOT NULL,
    gpa double precision,
    reading_level text,
    math_level text,
    struggling_subjects jsonb,
    days_present integer,
    days_absent integer,
    tardies integer,
    suspensions integer,
    detentions integer,
    has_iep boolean DEFAULT false NOT NULL,
    has_504_plan boolean DEFAULT false NOT NULL,
    special_services jsonb,
    teacher_feedback text,
    extracurricular jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.education_records OWNER TO fcf_user;

--
-- Name: families; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.families (
    id text NOT NULL,
    family_name text NOT NULL,
    primary_contact text,
    phone text,
    email text,
    address text,
    city text,
    state text,
    zip_code text,
    housing_type text,
    housing_status text,
    household_income text,
    employment_status text,
    family_composition jsonb,
    support_network jsonb,
    family_stressors jsonb,
    family_strengths jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.families OWNER TO fcf_user;

--
-- Name: goal_progress; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.goal_progress (
    id text NOT NULL,
    goal_id text NOT NULL,
    progress_date timestamp(3) without time zone NOT NULL,
    progress_percent integer NOT NULL,
    progress_note text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by text
);


ALTER TABLE public.goal_progress OWNER TO fcf_user;

--
-- Name: goals; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.goals (
    id text NOT NULL,
    child_id text NOT NULL,
    case_id text,
    goal_category text NOT NULL,
    goal_description text NOT NULL,
    start_date timestamp(3) without time zone NOT NULL,
    target_date timestamp(3) without time zone NOT NULL,
    completed_date timestamp(3) without time zone,
    status text DEFAULT 'Active'::text NOT NULL,
    progress_percent integer DEFAULT 0 NOT NULL,
    success_criteria jsonb,
    barriers jsonb,
    interventions jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by text
);


ALTER TABLE public.goals OWNER TO fcf_user;

--
-- Name: home_visits; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.home_visits (
    id text NOT NULL,
    family_id text NOT NULL,
    visit_date timestamp(3) without time zone NOT NULL,
    visit_type text NOT NULL,
    purpose text,
    observations text,
    home_condition text,
    family_interaction text,
    concerns_identified jsonb,
    action_items jsonb,
    follow_up_needed boolean DEFAULT false NOT NULL,
    follow_up_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    conducted_by text NOT NULL
);


ALTER TABLE public.home_visits OWNER TO fcf_user;

--
-- Name: kpi_daily; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.kpi_daily (
    id text NOT NULL,
    program_id text,
    worker_id text,
    date date NOT NULL,
    active_cases integer DEFAULT 0 NOT NULL,
    intakes integer DEFAULT 0 NOT NULL,
    closures integer DEFAULT 0 NOT NULL,
    overdue_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.kpi_daily OWNER TO fcf_user;

--
-- Name: medical_records; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.medical_records (
    id text NOT NULL,
    child_id text NOT NULL,
    record_type text NOT NULL,
    record_date timestamp(3) without time zone NOT NULL,
    provider text,
    diagnosis text,
    treatment text,
    prescriptions jsonb,
    follow_up_needed boolean DEFAULT false NOT NULL,
    follow_up_date timestamp(3) without time zone,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.medical_records OWNER TO fcf_user;

--
-- Name: programs; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.programs (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.programs OWNER TO fcf_user;

--
-- Name: report_definitions; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.report_definitions (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    owner_user_id text,
    definition_json jsonb NOT NULL,
    is_shared boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.report_definitions OWNER TO fcf_user;

--
-- Name: report_runs; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.report_runs (
    id text NOT NULL,
    report_definition_id text NOT NULL,
    requested_by text NOT NULL,
    status text NOT NULL,
    started_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    finished_at timestamp(3) without time zone,
    row_count integer,
    meta_json jsonb
);


ALTER TABLE public.report_runs OWNER TO fcf_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.roles (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.roles OWNER TO fcf_user;

--
-- Name: services; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.services (
    id text NOT NULL,
    vendor_source_id text NOT NULL,
    vendor_service_id text NOT NULL,
    case_id text NOT NULL,
    service_type text NOT NULL,
    start_at timestamp(3) without time zone NOT NULL,
    end_at timestamp(3) without time zone,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.services OWNER TO fcf_user;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.user_roles (
    user_id text NOT NULL,
    role_id text NOT NULL
);


ALTER TABLE public.user_roles OWNER TO fcf_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    password_hash text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO fcf_user;

--
-- Name: vendor_sources; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.vendor_sources (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.vendor_sources OWNER TO fcf_user;

--
-- Name: vendor_tokens; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.vendor_tokens (
    id text NOT NULL,
    source_id text NOT NULL,
    access_token text NOT NULL,
    refresh_token text,
    expires_at timestamp(3) without time zone,
    meta_json jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.vendor_tokens OWNER TO fcf_user;

--
-- Name: workers; Type: TABLE; Schema: public; Owner: fcf_user
--

CREATE TABLE public.workers (
    id text NOT NULL,
    name text NOT NULL,
    email text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workers OWNER TO fcf_user;

--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
8da51533-eff2-46c0-aa81-7a5935d4f8fd	d207ea0584687cfb22ab45869e2a0b33ebdd8ba180be89ec03c39669ab0d7741	2026-01-08 02:35:42.589078+00	20260108023542_init	\N	\N	2026-01-08 02:35:42.538719+00	1
0e98aef3-2606-4cb5-8196-6b7c1fe2d00f	1e78010a5a35e639dacc7d00d78ede247a7a824e4fa57178535ec7531333c8bd	2026-01-11 21:01:00.191207+00	20260111003007_add_child_centered_models	\N	\N	2026-01-11 21:01:00.15229+00	1
\.


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.activities (id, vendor_source_id, vendor_activity_id, case_id, activity_type, occurred_at, summary, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.assessments (id, child_id, assessment_type, assessment_date, assessor_id, emotional_state, behavioral_concerns, trauma_indicators, family_dynamics, school_performance, social_relationships, risk_factors, protective_factors, recommendations, next_review_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.audit_logs (id, user_id, action, entity_type, entity_id, meta_json, created_at) FROM stdin;
261fe8c3-f521-424b-a1a3-b1117bf69a4a	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 00:06:50.436
8830079f-b26b-4f32-b0a4-5d2824838735	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 00:06:52.533
43c89722-8610-4145-b114-f5f0b4cd927a	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 00:18:47.579
38cd267f-4338-4520-b43c-b3c3cc02d836	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 00:18:51.13
d04e17cb-bacb-406e-b2c2-7ad71c79ce84	170d734d-2617-4d7e-b2ef-802b35208303	view	child	5fbc2d84-2037-44c8-a64d-a8326721bf94	\N	2026-01-12 00:19:13.442
761e376e-a7c4-4509-8ec7-dbc23d8ab6e6	170d734d-2617-4d7e-b2ef-802b35208303	view	child	7940df87-c3f3-4d2a-8465-d9ad3e5e4026	\N	2026-01-12 00:19:24.803
98654e69-0f5c-4e9e-ad4a-d156203b6c8c	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 00:21:14.15
da7b4f8b-c974-4979-9904-dc03fc1d1dbd	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 00:21:36.879
06c9e350-9000-4e3e-9a26-d1ae60f19ee9	170d734d-2617-4d7e-b2ef-802b35208303	view	child	cf5716f3-73ad-4416-9f97-b08667a7fdc5	\N	2026-01-12 00:21:46.113
557439a4-c3e1-451f-b60a-b7ebcd282193	170d734d-2617-4d7e-b2ef-802b35208303	view	child	5fbc2d84-2037-44c8-a64d-a8326721bf94	\N	2026-01-12 00:41:14.558
442b78e2-6502-4fbf-8b41-56aa13c07f3f	170d734d-2617-4d7e-b2ef-802b35208303	view	child	7940df87-c3f3-4d2a-8465-d9ad3e5e4026	\N	2026-01-12 00:41:46.509
26185465-354b-4a18-8840-7b8f1eaf726f	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 00:52:56.53
03ff106f-5c77-4600-9ed3-fe010ade3d4e	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 00:53:18.361
4a7ccf1b-040f-43da-a60a-c7f20424b2d4	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 01:28:21.085
cfa089b7-30bc-4ecd-b46a-eb023e0fc9e7	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 01:28:39.517
1f710aca-18a4-405f-96ad-03aa20c20f61	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:28:41.286
1a730f7e-65c0-476e-a3a3-5e8eb49a3e6a	170d734d-2617-4d7e-b2ef-802b35208303	view	child	cf5716f3-73ad-4416-9f97-b08667a7fdc5	\N	2026-01-12 01:29:13.113
27adc7bd-244f-4a7e-9ca1-95bb78a1f2d0	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 01:29:28.188
6e961ecd-2a86-4e8c-916c-3bc9a430dc27	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:29:50.776
6039de0e-5ac2-4848-b8a7-12272089ec7c	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:29:59.298
cb2f1c69-70ec-445d-acd2-bd05f8b90a57	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:30:12.764
f3c1c358-6ac2-41ce-9f9f-84b8524b850c	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 01:45:15.513
656292d7-9b2f-4f29-bc18-2aa5bd697271	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:45:18.112
ebca96b2-ea34-4f74-82f5-b53bba45d3fa	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 01:50:12.287
89c2d186-eca3-479a-8894-1f473924fadd	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 02:00:43.207
cf323d2e-eb6e-49de-b110-7ac8bb18bbaf	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 02:01:02.844
f73080a9-6d22-491e-8120-d5a620d2f961	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 02:07:27.468
10e8752e-9ecd-4c51-a685-9325b483bdca	170d734d-2617-4d7e-b2ef-802b35208303	view	child	d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	2026-01-12 02:07:59.794
ee38de74-d9ce-4cbf-a756-aa6bfac053ff	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "doe"}	2026-01-12 02:21:43.998
1d283b84-f8d8-40bb-8ade-2cb6f6b5a73a	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 02:21:48.467
c7d22633-baac-4d45-a8b5-3828377212c0	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "doe"}	2026-01-12 02:21:54.187
e0d8f82e-ccdf-4fce-9777-26e1c065e4b2	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "johnson"}	2026-01-12 02:21:58.927
4d97ce50-bc95-40d5-bfd5-c145cdf39eb2	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "johnson"}	2026-01-12 02:22:04.907
cf2f9c83-7ef3-44da-96a3-153ec0cae264	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "smith"}	2026-01-12 02:22:19.634
90572cb8-9c58-4f9a-9ec5-f46c00f64625	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "johnson"}	2026-01-12 02:26:08.602
7d46ec6d-15a3-4bbc-8bb3-3497fedf7a87	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "smith"}	2026-01-12 02:26:16.076
250246b3-25b5-4c80-8a9b-7e1f5355fc16	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 02:26:19.64
f0bf96b6-1f9b-4fb3-930e-dd9ff0cf53cb	170d734d-2617-4d7e-b2ef-802b35208303	list	child	\N	\N	2026-01-12 02:29:30.1
a34a8722-084c-42de-8bfe-5252afe27ecc	170d734d-2617-4d7e-b2ef-802b35208303	search	client	\N	{"q": "johnson"}	2026-01-12 02:29:44.769
\.


--
-- Data for Name: behavioral_incidents; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.behavioral_incidents (id, child_id, incident_date, incident_type, severity, description, location, trigger, antecedent, intervention_used, outcome, injuries_reported, police_involved, follow_up_actions, parent_notified, reported_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cases; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.cases (id, vendor_source_id, vendor_case_id, client_id, status, opened_at, closed_at, assigned_worker_id, program_id, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: child_notes; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.child_notes (id, child_id, note_date, note_type, subject, content, is_confidential, created_at, updated_at, author_id) FROM stdin;
\.


--
-- Data for Name: children; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.children (id, client_id, first_name, middle_name, last_name, nickname, date_of_birth, gender, race_ethnicity, preferred_language, photo_url, ssn, medicaid_id, school_id, status, custody_status, legal_status, referral_source, referral_reason, presenting_issues, medications, allergies, medical_conditions, mental_health_dx, triggers, coping_mechanisms, trauma_history, attachment_style, interests, strengths, likes, dislikes, fears, emergency_contacts, family_id, created_at, updated_at, created_by) FROM stdin;
d947241e-2eec-47e3-8b18-46eb5d2259b7	\N	Emma	Grace	Johnson	Em	2015-03-15 00:00:00	Female	Caucasian	English	\N	\N	\N	\N	Active	Biological Family	No court involvement	School	Behavioral concerns at school	Difficulty focusing in class, occasional outbursts, anxiety about family situation	[{"name": "Adderall XR", "dosage": "10mg", "frequency": "Once daily", "prescriber": "Dr. Smith"}]	[{"type": "Food", "allergen": "Peanuts", "reaction": "Anaphylaxis", "severity": "Severe"}, {"type": "Environmental", "allergen": "Bee stings", "reaction": "Swelling", "severity": "Moderate"}]	[{"condition": "ADHD", "diagnosis_date": "2022-01-15", "treating_physician": "Dr. Smith"}]	[{"date": "2023-05-20", "diagnosis": "Anxiety Disorder", "diagnosed_by": "Dr. Williams"}]	["Loud noises", "Sudden changes in routine", "Talking about parents' separation"]	["Deep breathing exercises", "Drawing and art", "Talking to trusted adults", "Playing with therapy dog"]	Witnessed domestic violence between parents before separation. Parents divorced when she was 7 years old.	Anxious-Ambivalent	["Drawing", "Reading", "Animals", "Music"]	["Creative", "Empathetic", "Intelligent", "Artistic"]	["Pizza", "Cats", "Purple color", "Harry Potter books"]	["Loud noises", "Spicy food", "Being alone"]	["Thunderstorms", "Parents fighting", "Being abandoned"]	[{"name": "Sarah Johnson", "phone": "(555) 123-4567", "relationship": "Mother"}, {"name": "Mary Johnson", "phone": "(555) 987-6543", "relationship": "Grandmother"}]	8b3ee1bf-9f28-4460-917f-c7bded927267	2026-01-11 21:01:01.096	2026-01-11 21:01:01.096	\N
7940df87-c3f3-4d2a-8465-d9ad3e5e4026	\N	Marcus	\N	Thompson	Marc	2012-08-22 00:00:00	Male	African American	English	\N	\N	\N	\N	Active	Foster Care	Dependency case - reunification plan	DCF	Neglect and abuse	Trust issues, anger management, academic struggles, history of trauma	[]	[]	[]	[{"date": "2023-02-10", "diagnosis": "PTSD", "diagnosed_by": "Dr. Martinez"}, {"date": "2023-02-10", "diagnosis": "Oppositional Defiant Disorder", "diagnosed_by": "Dr. Martinez"}]	["Authority figures raising their voice", "Physical touch without warning", "Feeling trapped or cornered"]	["Basketball", "Listening to music", "Writing in journal", "Talking to mentor"]	Experienced physical abuse and neglect from biological parents. Multiple foster placements before current stable placement.	Disorganized	["Basketball", "Video games", "Rap music", "Cooking"]	["Athletic", "Loyal to friends", "Protective of younger kids", "Good at sports"]	["Basketball", "Pizza", "Video games", "Dogs"]	["Being told what to do", "Vegetables", "Reading"]	["Being sent back to biological parents", "Losing current foster family", "Failure"]	[{"name": "Jennifer Foster", "phone": "(555) 234-5678", "relationship": "Foster Mother"}, {"name": "Case Manager", "phone": "(555) 111-2222", "relationship": "DCF Worker"}]	\N	2026-01-11 21:01:01.101	2026-01-11 21:01:01.101	\N
cf5716f3-73ad-4416-9f97-b08667a7fdc5	\N	Emma	Grace	Johnson	Em	2015-03-15 00:00:00	Female	Caucasian	English	\N	\N	\N	\N	Active	Biological Family	No court involvement	School	Behavioral concerns at school	Difficulty focusing in class, occasional outbursts, anxiety about family situation	[{"name": "Adderall XR", "dosage": "10mg", "frequency": "Once daily", "prescriber": "Dr. Smith"}]	[{"type": "Food", "allergen": "Peanuts", "reaction": "Anaphylaxis", "severity": "Severe"}, {"type": "Environmental", "allergen": "Bee stings", "reaction": "Swelling", "severity": "Moderate"}]	[{"condition": "ADHD", "diagnosis_date": "2022-01-15", "treating_physician": "Dr. Smith"}]	[{"date": "2023-05-20", "diagnosis": "Anxiety Disorder", "diagnosed_by": "Dr. Williams"}]	["Loud noises", "Sudden changes in routine", "Talking about parents' separation"]	["Deep breathing exercises", "Drawing and art", "Talking to trusted adults", "Playing with therapy dog"]	Witnessed domestic violence between parents before separation. Parents divorced when she was 7 years old.	Anxious-Ambivalent	["Drawing", "Reading", "Animals", "Music"]	["Creative", "Empathetic", "Intelligent", "Artistic"]	["Pizza", "Cats", "Purple color", "Harry Potter books"]	["Loud noises", "Spicy food", "Being alone"]	["Thunderstorms", "Parents fighting", "Being abandoned"]	[{"name": "Sarah Johnson", "phone": "(555) 123-4567", "relationship": "Mother"}, {"name": "Mary Johnson", "phone": "(555) 987-6543", "relationship": "Grandmother"}]	0ce41c09-531c-428a-83b2-b577f6a398b0	2026-01-12 00:17:03.345	2026-01-12 00:17:03.345	\N
5fbc2d84-2037-44c8-a64d-a8326721bf94	\N	Marcus	\N	Thompson	Marc	2012-08-22 00:00:00	Male	African American	English	\N	\N	\N	\N	Active	Foster Care	Dependency case - reunification plan	DCF	Neglect and abuse	Trust issues, anger management, academic struggles, history of trauma	[]	[]	[]	[{"date": "2023-02-10", "diagnosis": "PTSD", "diagnosed_by": "Dr. Martinez"}, {"date": "2023-02-10", "diagnosis": "Oppositional Defiant Disorder", "diagnosed_by": "Dr. Martinez"}]	["Authority figures raising their voice", "Physical touch without warning", "Feeling trapped or cornered"]	["Basketball", "Listening to music", "Writing in journal", "Talking to mentor"]	Experienced physical abuse and neglect from biological parents. Multiple foster placements before current stable placement.	Disorganized	["Basketball", "Video games", "Rap music", "Cooking"]	["Athletic", "Loyal to friends", "Protective of younger kids", "Good at sports"]	["Basketball", "Pizza", "Video games", "Dogs"]	["Being told what to do", "Vegetables", "Reading"]	["Being sent back to biological parents", "Losing current foster family", "Failure"]	[{"name": "Jennifer Foster", "phone": "(555) 234-5678", "relationship": "Foster Mother"}, {"name": "Case Manager", "phone": "(555) 111-2222", "relationship": "DCF Worker"}]	\N	2026-01-12 00:17:03.349	2026-01-12 00:17:03.349	\N
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.clients (id, vendor_source_id, vendor_client_id, first_name, last_name, dob, program_id, status, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.documents (id, vendor_source_id, vendor_document_id, case_id, title, doc_type, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: education_records; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.education_records (id, child_id, school_year, school_name, grade_level, gpa, reading_level, math_level, struggling_subjects, days_present, days_absent, tardies, suspensions, detentions, has_iep, has_504_plan, special_services, teacher_feedback, extracurricular, created_at, updated_at) FROM stdin;
b1c9d89b-1ff9-4d56-acf0-078bec906d6b	cf5716f3-73ad-4416-9f97-b08667a7fdc5	2023-2024	Springfield Elementary School	3rd Grade	3.2	Grade Level	Below Grade Level	["Math", "Science"]	145	15	8	0	2	t	f	["Speech Therapy", "Counseling"]	Emma is a bright and creative student. She struggles with focus and completing assignments on time. She works well in small groups and responds positively to encouragement. Her anxiety sometimes interferes with her ability to participate in class.	["Art Club", "School Choir"]	2026-01-12 00:17:03.351	2026-01-12 00:17:03.351
59eb1e27-c340-441b-bc97-dcbac207f5d3	cf5716f3-73ad-4416-9f97-b08667a7fdc5	2022-2023	Springfield Elementary School	2nd Grade	3.5	Above Grade Level	Grade Level	[]	155	10	5	0	0	f	f	\N	Emma is doing well academically. She is a joy to have in class and gets along well with her peers.	["Art Club"]	2026-01-12 00:17:03.354	2026-01-12 00:17:03.354
424c40e9-2d92-4f2a-8767-88ed0aa4f11f	5fbc2d84-2037-44c8-a64d-a8326721bf94	2023-2024	Lincoln Middle School	7th Grade	2.1	Below Grade Level	Below Grade Level	["English", "Math", "History"]	120	35	22	3	8	t	t	["Special Education", "Behavioral Support", "Counseling"]	Marcus has significant behavioral challenges that interfere with his learning. He can be disruptive in class and has difficulty following directions. However, when engaged in topics he cares about (especially sports), he shows potential. He needs consistent structure and positive reinforcement.	["Basketball Team"]	2026-01-12 00:17:03.355	2026-01-12 00:17:03.355
bd84960b-41b6-4e58-ae2e-a6ab3900321a	5fbc2d84-2037-44c8-a64d-a8326721bf94	2022-2023	Lincoln Middle School	6th Grade	1.8	Below Grade Level	Below Grade Level	["All subjects"]	100	55	30	5	12	t	f	["Special Education", "Counseling"]	Marcus struggles significantly with attendance and behavior. Multiple interventions have been attempted with limited success.	[]	2026-01-12 00:17:03.357	2026-01-12 00:17:03.357
\.


--
-- Data for Name: families; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.families (id, family_name, primary_contact, phone, email, address, city, state, zip_code, housing_type, housing_status, household_income, employment_status, family_composition, support_network, family_stressors, family_strengths, created_at, updated_at) FROM stdin;
8b3ee1bf-9f28-4460-917f-c7bded927267	Johnson Family	Sarah Johnson	(555) 123-4567	sarah.johnson@example.com	123 Main Street	Springfield	IL	62701	House	Rented	$30,000 - $50,000	Employed	[{"age": 35, "name": "Sarah Johnson", "relationship": "Mother", "living_in_home": true}, {"age": 37, "name": "Michael Johnson", "relationship": "Father", "living_in_home": false}]	["Grandmother (Mary)", "Church Community", "School Counselor"]	["Financial stress", "Single parent household"]	["Strong family bonds", "Community support", "Resilience"]	2026-01-11 21:01:01.087	2026-01-11 21:01:01.087
0ce41c09-531c-428a-83b2-b577f6a398b0	Johnson Family	Sarah Johnson	(555) 123-4567	sarah.johnson@example.com	123 Main Street	Springfield	IL	62701	House	Rented	$30,000 - $50,000	Employed	[{"age": 35, "name": "Sarah Johnson", "relationship": "Mother", "living_in_home": true}, {"age": 37, "name": "Michael Johnson", "relationship": "Father", "living_in_home": false}]	["Grandmother (Mary)", "Church Community", "School Counselor"]	["Financial stress", "Single parent household"]	["Strong family bonds", "Community support", "Resilience"]	2026-01-12 00:17:03.341	2026-01-12 00:17:03.341
\.


--
-- Data for Name: goal_progress; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.goal_progress (id, goal_id, progress_date, progress_percent, progress_note, created_at, created_by) FROM stdin;
\.


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.goals (id, child_id, case_id, goal_category, goal_description, start_date, target_date, completed_date, status, progress_percent, success_criteria, barriers, interventions, created_at, updated_at, created_by) FROM stdin;
\.


--
-- Data for Name: home_visits; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.home_visits (id, family_id, visit_date, visit_type, purpose, observations, home_condition, family_interaction, concerns_identified, action_items, follow_up_needed, follow_up_date, created_at, updated_at, conducted_by) FROM stdin;
\.


--
-- Data for Name: kpi_daily; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.kpi_daily (id, program_id, worker_id, date, active_cases, intakes, closures, overdue_count, created_at) FROM stdin;
\.


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.medical_records (id, child_id, record_type, record_date, provider, diagnosis, treatment, prescriptions, follow_up_needed, follow_up_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: programs; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.programs (id, name, created_at) FROM stdin;
e5947932-dfb0-42b2-a4ef-dfd7beff90be	Foster Care	2026-01-08 02:36:02.837
54a1118c-5188-4dd7-996b-6bb3e925dd88	Family Support	2026-01-08 02:36:02.837
90359739-5877-48ca-8497-3d600ff8b653	Adoption Services	2026-01-08 02:36:02.837
\.


--
-- Data for Name: report_definitions; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.report_definitions (id, name, type, owner_user_id, definition_json, is_shared, created_at, updated_at) FROM stdin;
caseload-by-worker	Caseload by Worker	standard	\N	{"description": "Shows active caseload grouped by worker"}	t	2026-01-08 02:36:02.855	2026-01-08 02:36:02.855
intakes-vs-closures	Intakes vs Closures Trend	standard	\N	{"description": "Monthly trend of intakes vs closures"}	t	2026-01-08 02:36:02.855	2026-01-08 02:36:02.855
active-cases-by-program	Active Cases by Program/Status	standard	\N	{"description": "Shows active cases grouped by program and status"}	t	2026-01-08 02:36:02.855	2026-01-08 02:36:02.855
overdue-compliance	Overdue/Compliance List	standard	\N	{"description": "List of cases with overdue items or compliance issues"}	t	2026-01-08 02:36:02.855	2026-01-08 02:36:02.855
services-delivered	Services Delivered by Period	standard	\N	{"description": "Services delivered grouped by type and period"}	t	2026-01-08 02:36:02.855	2026-01-08 02:36:02.855
\.


--
-- Data for Name: report_runs; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.report_runs (id, report_definition_id, requested_by, status, started_at, finished_at, row_count, meta_json) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.roles (id, name, description, created_at) FROM stdin;
f72e82c7-0189-4955-abd1-3d586593e4d4	admin	Administrator with full access	2026-01-08 02:36:02.76
3b1c0f54-3669-40b4-9843-8f94d7d91258	user	Standard user with read access	2026-01-08 02:36:02.769
7ee0f34c-4f6c-45c9-947e-53eef681600b	manager	Manager with reporting access	2026-01-08 02:36:02.771
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.services (id, vendor_source_id, vendor_service_id, case_id, service_type, start_at, end_at, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.user_roles (user_id, role_id) FROM stdin;
170d734d-2617-4d7e-b2ef-802b35208303	f72e82c7-0189-4955-abd1-3d586593e4d4
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.users (id, email, name, password_hash, is_active, created_at, updated_at) FROM stdin;
170d734d-2617-4d7e-b2ef-802b35208303	admin@fcf.org	Admin User	$2b$10$skmQTMV3mcbibnmJnEv2x.AKDRV0kWUOfEhdMFXLHbOiTPUw.iXEK	t	2026-01-08 02:36:02.823	2026-01-08 02:36:02.823
\.


--
-- Data for Name: vendor_sources; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.vendor_sources (id, name, created_at) FROM stdin;
2e7e3e97-3bcb-4a26-8fb6-7fba05e240a1	extendedreach	2026-01-08 02:36:02.834
\.


--
-- Data for Name: vendor_tokens; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.vendor_tokens (id, source_id, access_token, refresh_token, expires_at, meta_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: public; Owner: fcf_user
--

COPY public.workers (id, name, email, created_at) FROM stdin;
42f16fb3-dc9f-410b-b184-ab192399ad96	Jane Doe	jane.doe@fcf.org	2026-01-08 02:36:02.853
d8c21e14-681f-4669-a684-a7e87d517746	John Smith	john.smith@fcf.org	2026-01-08 02:36:02.853
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: behavioral_incidents behavioral_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.behavioral_incidents
    ADD CONSTRAINT behavioral_incidents_pkey PRIMARY KEY (id);


--
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id);


--
-- Name: child_notes child_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.child_notes
    ADD CONSTRAINT child_notes_pkey PRIMARY KEY (id);


--
-- Name: children children_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: education_records education_records_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.education_records
    ADD CONSTRAINT education_records_pkey PRIMARY KEY (id);


--
-- Name: families families_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.families
    ADD CONSTRAINT families_pkey PRIMARY KEY (id);


--
-- Name: goal_progress goal_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.goal_progress
    ADD CONSTRAINT goal_progress_pkey PRIMARY KEY (id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: home_visits home_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.home_visits
    ADD CONSTRAINT home_visits_pkey PRIMARY KEY (id);


--
-- Name: kpi_daily kpi_daily_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.kpi_daily
    ADD CONSTRAINT kpi_daily_pkey PRIMARY KEY (id);


--
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: report_definitions report_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.report_definitions
    ADD CONSTRAINT report_definitions_pkey PRIMARY KEY (id);


--
-- Name: report_runs report_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.report_runs
    ADD CONSTRAINT report_runs_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendor_sources vendor_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.vendor_sources
    ADD CONSTRAINT vendor_sources_pkey PRIMARY KEY (id);


--
-- Name: vendor_tokens vendor_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.vendor_tokens
    ADD CONSTRAINT vendor_tokens_pkey PRIMARY KEY (id);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: activities_activity_type_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX activities_activity_type_idx ON public.activities USING btree (activity_type);


--
-- Name: activities_case_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX activities_case_id_idx ON public.activities USING btree (case_id);


--
-- Name: activities_occurred_at_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX activities_occurred_at_idx ON public.activities USING btree (occurred_at);


--
-- Name: activities_vendor_source_id_vendor_activity_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX activities_vendor_source_id_vendor_activity_id_key ON public.activities USING btree (vendor_source_id, vendor_activity_id);


--
-- Name: assessments_assessment_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX assessments_assessment_date_idx ON public.assessments USING btree (assessment_date);


--
-- Name: assessments_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX assessments_child_id_idx ON public.assessments USING btree (child_id);


--
-- Name: audit_logs_created_at_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX audit_logs_created_at_idx ON public.audit_logs USING btree (created_at);


--
-- Name: audit_logs_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX audit_logs_entity_type_entity_id_idx ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: audit_logs_user_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX audit_logs_user_id_idx ON public.audit_logs USING btree (user_id);


--
-- Name: behavioral_incidents_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX behavioral_incidents_child_id_idx ON public.behavioral_incidents USING btree (child_id);


--
-- Name: behavioral_incidents_incident_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX behavioral_incidents_incident_date_idx ON public.behavioral_incidents USING btree (incident_date);


--
-- Name: behavioral_incidents_severity_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX behavioral_incidents_severity_idx ON public.behavioral_incidents USING btree (severity);


--
-- Name: cases_assigned_worker_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX cases_assigned_worker_id_idx ON public.cases USING btree (assigned_worker_id);


--
-- Name: cases_client_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX cases_client_id_idx ON public.cases USING btree (client_id);


--
-- Name: cases_opened_at_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX cases_opened_at_idx ON public.cases USING btree (opened_at);


--
-- Name: cases_program_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX cases_program_id_idx ON public.cases USING btree (program_id);


--
-- Name: cases_status_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX cases_status_idx ON public.cases USING btree (status);


--
-- Name: cases_vendor_source_id_vendor_case_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX cases_vendor_source_id_vendor_case_id_key ON public.cases USING btree (vendor_source_id, vendor_case_id);


--
-- Name: child_notes_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX child_notes_child_id_idx ON public.child_notes USING btree (child_id);


--
-- Name: child_notes_note_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX child_notes_note_date_idx ON public.child_notes USING btree (note_date);


--
-- Name: child_notes_note_type_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX child_notes_note_type_idx ON public.child_notes USING btree (note_type);


--
-- Name: children_client_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX children_client_id_key ON public.children USING btree (client_id);


--
-- Name: children_date_of_birth_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX children_date_of_birth_idx ON public.children USING btree (date_of_birth);


--
-- Name: children_family_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX children_family_id_idx ON public.children USING btree (family_id);


--
-- Name: children_status_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX children_status_idx ON public.children USING btree (status);


--
-- Name: clients_program_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX clients_program_id_idx ON public.clients USING btree (program_id);


--
-- Name: clients_status_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX clients_status_idx ON public.clients USING btree (status);


--
-- Name: clients_vendor_source_id_vendor_client_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX clients_vendor_source_id_vendor_client_id_key ON public.clients USING btree (vendor_source_id, vendor_client_id);


--
-- Name: documents_case_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX documents_case_id_idx ON public.documents USING btree (case_id);


--
-- Name: documents_doc_type_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX documents_doc_type_idx ON public.documents USING btree (doc_type);


--
-- Name: documents_vendor_source_id_vendor_document_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX documents_vendor_source_id_vendor_document_id_key ON public.documents USING btree (vendor_source_id, vendor_document_id);


--
-- Name: education_records_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX education_records_child_id_idx ON public.education_records USING btree (child_id);


--
-- Name: education_records_school_year_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX education_records_school_year_idx ON public.education_records USING btree (school_year);


--
-- Name: goal_progress_goal_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX goal_progress_goal_id_idx ON public.goal_progress USING btree (goal_id);


--
-- Name: goal_progress_progress_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX goal_progress_progress_date_idx ON public.goal_progress USING btree (progress_date);


--
-- Name: goals_case_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX goals_case_id_idx ON public.goals USING btree (case_id);


--
-- Name: goals_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX goals_child_id_idx ON public.goals USING btree (child_id);


--
-- Name: goals_status_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX goals_status_idx ON public.goals USING btree (status);


--
-- Name: home_visits_family_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX home_visits_family_id_idx ON public.home_visits USING btree (family_id);


--
-- Name: home_visits_visit_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX home_visits_visit_date_idx ON public.home_visits USING btree (visit_date);


--
-- Name: kpi_daily_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX kpi_daily_date_idx ON public.kpi_daily USING btree (date);


--
-- Name: kpi_daily_date_program_id_worker_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX kpi_daily_date_program_id_worker_id_key ON public.kpi_daily USING btree (date, program_id, worker_id);


--
-- Name: kpi_daily_program_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX kpi_daily_program_id_idx ON public.kpi_daily USING btree (program_id);


--
-- Name: kpi_daily_worker_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX kpi_daily_worker_id_idx ON public.kpi_daily USING btree (worker_id);


--
-- Name: medical_records_child_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX medical_records_child_id_idx ON public.medical_records USING btree (child_id);


--
-- Name: medical_records_record_date_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX medical_records_record_date_idx ON public.medical_records USING btree (record_date);


--
-- Name: programs_name_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX programs_name_key ON public.programs USING btree (name);


--
-- Name: report_definitions_owner_user_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX report_definitions_owner_user_id_idx ON public.report_definitions USING btree (owner_user_id);


--
-- Name: report_definitions_type_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX report_definitions_type_idx ON public.report_definitions USING btree (type);


--
-- Name: report_runs_report_definition_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX report_runs_report_definition_id_idx ON public.report_runs USING btree (report_definition_id);


--
-- Name: report_runs_requested_by_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX report_runs_requested_by_idx ON public.report_runs USING btree (requested_by);


--
-- Name: report_runs_status_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX report_runs_status_idx ON public.report_runs USING btree (status);


--
-- Name: roles_name_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX roles_name_key ON public.roles USING btree (name);


--
-- Name: services_case_id_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX services_case_id_idx ON public.services USING btree (case_id);


--
-- Name: services_service_type_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX services_service_type_idx ON public.services USING btree (service_type);


--
-- Name: services_start_at_idx; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE INDEX services_start_at_idx ON public.services USING btree (start_at);


--
-- Name: services_vendor_source_id_vendor_service_id_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX services_vendor_source_id_vendor_service_id_key ON public.services USING btree (vendor_source_id, vendor_service_id);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: vendor_sources_name_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX vendor_sources_name_key ON public.vendor_sources USING btree (name);


--
-- Name: workers_email_key; Type: INDEX; Schema: public; Owner: fcf_user
--

CREATE UNIQUE INDEX workers_email_key ON public.workers USING btree (email);


--
-- Name: activities activities_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: activities activities_vendor_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_vendor_source_id_fkey FOREIGN KEY (vendor_source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: assessments assessments_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: behavioral_incidents behavioral_incidents_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.behavioral_incidents
    ADD CONSTRAINT behavioral_incidents_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cases cases_assigned_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_assigned_worker_id_fkey FOREIGN KEY (assigned_worker_id) REFERENCES public.workers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cases cases_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cases cases_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cases cases_vendor_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_vendor_source_id_fkey FOREIGN KEY (vendor_source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: child_notes child_notes_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.child_notes
    ADD CONSTRAINT child_notes_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: children children_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: children children_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_family_id_fkey FOREIGN KEY (family_id) REFERENCES public.families(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: clients clients_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: clients clients_vendor_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_vendor_source_id_fkey FOREIGN KEY (vendor_source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: documents documents_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: documents documents_vendor_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_vendor_source_id_fkey FOREIGN KEY (vendor_source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: education_records education_records_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.education_records
    ADD CONSTRAINT education_records_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: goal_progress goal_progress_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.goal_progress
    ADD CONSTRAINT goal_progress_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.goals(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: goals goals_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: goals goals_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: home_visits home_visits_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.home_visits
    ADD CONSTRAINT home_visits_family_id_fkey FOREIGN KEY (family_id) REFERENCES public.families(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: kpi_daily kpi_daily_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.kpi_daily
    ADD CONSTRAINT kpi_daily_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: kpi_daily kpi_daily_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.kpi_daily
    ADD CONSTRAINT kpi_daily_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES public.workers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: medical_records medical_records_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.children(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: report_definitions report_definitions_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.report_definitions
    ADD CONSTRAINT report_definitions_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_runs report_runs_report_definition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.report_runs
    ADD CONSTRAINT report_runs_report_definition_id_fkey FOREIGN KEY (report_definition_id) REFERENCES public.report_definitions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: report_runs report_runs_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.report_runs
    ADD CONSTRAINT report_runs_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: services services_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: services services_vendor_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_vendor_source_id_fkey FOREIGN KEY (vendor_source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vendor_tokens vendor_tokens_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fcf_user
--

ALTER TABLE ONLY public.vendor_tokens
    ADD CONSTRAINT vendor_tokens_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.vendor_sources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict cqzEbbOEI8NlcN8KqlLRNPB8cRrdfIa7PM7B3e7YKnAKsOmoWTvPgzxSAaSemVx

