# CareAccess Import System - Design Document

**Purpose:** Enable seamless migration from extendedReach (and other legacy systems) to CareAccess

**Target Customer:** Organization currently using extendedReach, ready to migrate to CareAccess MVP

---

## Overview

The import system allows organizations to:
1. **Export data** from extendedReach (CSV/Excel)
2. **Upload files** to CareAccess
3. **Map fields** from extendedReach schema to CareAccess schema
4. **Validate data** before import
5. **Import data** with rollback capability
6. **Review results** and fix errors

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Import System Flow                        │
└─────────────────────────────────────────────────────────────┘

1. EXPORT FROM EXTENDEDREACH
   ┌──────────────────┐
   │ extendedReach    │ → Export to CSV/Excel
   │ (Legacy System)  │
   └──────────────────┘
           ↓
   ┌──────────────────┐
   │ CSV/Excel Files  │
   │ - children.csv   │
   │ - cases.csv      │
   │ - placements.csv │
   │ - etc.           │
   └──────────────────┘

2. UPLOAD TO CAREACCESS
           ↓
   ┌──────────────────┐
   │ Upload API       │ → POST /api/v1/import/upload
   │ (File Storage)   │
   └──────────────────┘
           ↓
   ┌──────────────────┐
   │ S3/R2 Storage    │
   │ (Temporary)      │
   └──────────────────┘

3. FIELD MAPPING
           ↓
   ┌──────────────────┐
   │ Mapping UI       │ → Map extendedReach fields to CareAccess
   │ (Flutter App)    │    - Auto-detect common fields
   └──────────────────┘    - Manual mapping for custom fields
           ↓
   ┌──────────────────┐
   │ Mapping Config   │
   │ (JSON)           │
   └──────────────────┘

4. VALIDATION
           ↓
   ┌──────────────────┐
   │ Validation API   │ → POST /api/v1/import/validate
   │ (Data Quality)   │    - Check required fields
   └──────────────────┘    - Validate formats
           ↓                - Check relationships
   ┌──────────────────┐
   │ Validation Report│
   │ - Errors         │
   │ - Warnings       │
   │ - Stats          │
   └──────────────────┘

5. IMPORT
           ↓
   ┌──────────────────┐
   │ Import API       │ → POST /api/v1/import/execute
   │ (Transaction)    │    - Create records
   └──────────────────┘    - Link relationships
           ↓                - Rollback on error
   ┌──────────────────┐
   │ CareAccess DB    │
   │ (PostgreSQL)     │
   └──────────────────┘

6. REVIEW
           ↓
   ┌──────────────────┐
   │ Import Report    │
   │ - Success count  │
   │ - Error count    │
   │ - Warnings       │
   │ - Next steps     │
   └──────────────────┘
```

---

## Data Entities to Import

### Priority 1 (MVP - Must Have)
1. **Children** - Core child profiles
2. **Cases** - Case records
3. **Placements** - Placement history
4. **Workers** - Case workers/staff
5. **Programs** - Service programs

### Priority 2 (Important)
6. **Families** - Family information
7. **Assessments** - Child assessments
8. **Goals** - Case plan goals
9. **Education Records** - School information
10. **Medical Records** - Health information

### Priority 3 (Nice to Have)
11. **Behavioral Incidents** - Incident reports
12. **Case Notes** - Progress notes
13. **Documents** - File attachments
14. **Services** - Service records
15. **Court Dates** - Legal information

---

## Field Mapping Strategy

### Approach 1: Pre-built Templates (Recommended)
Create pre-configured mapping templates for common systems:

**extendedReach Template:**
```json
{
  "system": "extendedReach",
  "version": "2024",
  "entities": {
    "children": {
      "source_file": "children.csv",
      "mappings": {
        "Child_ID": "id",
        "First_Name": "firstName",
        "Last_Name": "lastName",
        "DOB": "dateOfBirth",
        "Gender": "gender",
        "SSN": "ssn",
        "Medicaid_Number": "medicaidId"
      },
      "transformations": {
        "dateOfBirth": "parseDate(DOB, 'MM/DD/YYYY')",
        "gender": "mapGender(Gender)"
      }
    }
  }
}
```

### Approach 2: Auto-Detection
Use fuzzy matching to auto-detect field mappings:
- "First_Name" → "firstName"
- "DOB" → "dateOfBirth"
- "Child_ID" → "id"

### Approach 3: Manual Mapping UI
Allow users to drag-and-drop or select mappings in UI

---

## API Endpoints

### 1. Upload Files
```
POST /api/v1/import/upload
Content-Type: multipart/form-data

Body:
- files: File[] (CSV/Excel)
- importType: "extendedReach" | "charms" | "famcare" | "custom"

Response:
{
  "uploadId": "uuid",
  "files": [
    {
      "filename": "children.csv",
      "rows": 150,
      "columns": ["Child_ID", "First_Name", "Last_Name", ...],
      "preview": [...]
    }
  ]
}
```

### 2. Get Mapping Template
```
GET /api/v1/import/templates/:system

Response:
{
  "system": "extendedReach",
  "entities": {...},
  "mappings": {...}
}
```

### 3. Save Mapping Configuration
```
POST /api/v1/import/:uploadId/mapping

Body:
{
  "mappings": {
    "children": {
      "Child_ID": "id",
      "First_Name": "firstName",
      ...
    }
  }
}

Response:
{
  "mappingId": "uuid",
  "status": "saved"
}
```

### 4. Validate Import
```
POST /api/v1/import/:uploadId/validate

Response:
{
  "valid": false,
  "errors": [
    {
      "entity": "children",
      "row": 15,
      "field": "dateOfBirth",
      "error": "Invalid date format",
      "value": "13/45/2020"
    }
  ],
  "warnings": [
    {
      "entity": "children",
      "row": 23,
      "field": "ssn",
      "warning": "SSN is missing"
    }
  ],
  "stats": {
    "children": {
      "total": 150,
      "valid": 148,
      "errors": 2,
      "warnings": 5
    }
  }
}
```

### 5. Execute Import
```
POST /api/v1/import/:uploadId/execute

Body:
{
  "dryRun": false,
  "skipErrors": false,
  "createMissing": true
}

Response:
{
  "importId": "uuid",
  "status": "in_progress",
  "progress": {
    "current": 0,
    "total": 150,
    "percent": 0
  }
}
```

### 6. Get Import Status
```
GET /api/v1/import/:importId/status

Response:
{
  "importId": "uuid",
  "status": "completed",
  "progress": {
    "current": 150,
    "total": 150,
    "percent": 100
  },
  "results": {
    "children": {
      "created": 148,
      "updated": 0,
      "skipped": 2,
      "errors": 2
    },
    "cases": {
      "created": 200,
      "updated": 0,
      "skipped": 0,
      "errors": 0
    }
  },
  "errors": [...]
}
```

### 7. Rollback Import
```
POST /api/v1/import/:importId/rollback

Response:
{
  "status": "rolled_back",
  "deleted": {
    "children": 148,
    "cases": 200
  }
}
```

---

## Database Schema for Import Tracking

```sql
-- Import Jobs
CREATE TABLE import_jobs (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  created_by UUID NOT NULL REFERENCES users(id),

  -- Source System
  source_system VARCHAR(50) NOT NULL, -- 'extendedReach', 'charms', etc.
  source_version VARCHAR(20),

  -- Status
  status VARCHAR(20) NOT NULL, -- 'uploaded', 'mapped', 'validated', 'importing', 'completed', 'failed', 'rolled_back'

  -- Files
  files JSONB NOT NULL, -- [{filename, path, rows, columns}]

  -- Mapping Configuration
  mapping_config JSONB, -- Field mappings

  -- Validation Results
  validation_results JSONB,

  -- Import Results
  import_results JSONB,

  -- Metadata
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,

  -- Progress
  total_records INT,
  processed_records INT,
  successful_records INT,
  failed_records INT
);

-- Import Errors
CREATE TABLE import_errors (
  id UUID PRIMARY KEY,
  import_job_id UUID NOT NULL REFERENCES import_jobs(id),

  entity_type VARCHAR(50) NOT NULL, -- 'child', 'case', etc.
  row_number INT,

  error_type VARCHAR(50) NOT NULL, -- 'validation', 'constraint', 'relationship'
  error_message TEXT NOT NULL,

  source_data JSONB, -- Original row data

  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Import Audit Trail
CREATE TABLE import_audit (
  id UUID PRIMARY KEY,
  import_job_id UUID NOT NULL REFERENCES import_jobs(id),

  entity_type VARCHAR(50) NOT NULL,
  entity_id UUID NOT NULL,
  action VARCHAR(20) NOT NULL, -- 'created', 'updated', 'deleted'

  old_data JSONB,
  new_data JSONB,

  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

---

## Validation Rules

### Children
- ✅ **Required:** firstName, lastName, dateOfBirth, gender
- ✅ **Format:** dateOfBirth must be valid date
- ✅ **Range:** dateOfBirth must be < today
- ✅ **Enum:** gender must be in ['Male', 'Female', 'Non-binary', 'Other']
- ⚠️ **Warning:** SSN missing (not required but recommended)
- ⚠️ **Warning:** Photo missing

### Cases
- ✅ **Required:** childId, status, openedAt
- ✅ **Relationship:** childId must exist in children table
- ✅ **Relationship:** assignedWorkerId must exist in workers table
- ✅ **Enum:** status must be in ['Open', 'Active', 'Closed', 'Transferred']
- ⚠️ **Warning:** No assigned worker

### Placements
- ✅ **Required:** childId, placementType, startDate
- ✅ **Relationship:** childId must exist
- ✅ **Logic:** endDate must be > startDate (if provided)
- ✅ **Logic:** No overlapping placements for same child

---

## Data Transformations

### Date Formats
```typescript
// extendedReach uses MM/DD/YYYY
"01/15/2020" → new Date("2020-01-15")

// Handle various formats
parseDate(value, format) {
  if (format === 'MM/DD/YYYY') return moment(value, 'MM/DD/YYYY').toDate();
  if (format === 'YYYY-MM-DD') return new Date(value);
  // ... more formats
}
```

### Gender Mapping
```typescript
mapGender(value) {
  const mapping = {
    'M': 'Male',
    'F': 'Female',
    'Male': 'Male',
    'Female': 'Female',
    'NB': 'Non-binary',
    'O': 'Other'
  };
  return mapping[value] || 'Other';
}
```

### SSN Encryption
```typescript
encryptSSN(ssn) {
  // Remove dashes/spaces
  const clean = ssn.replace(/[-\s]/g, '');

  // Validate format (9 digits)
  if (!/^\d{9}$/.test(clean)) throw new Error('Invalid SSN');

  // Encrypt
  return encrypt(clean, process.env.SSN_ENCRYPTION_KEY);
}
```

---

## Import Process Flow

### Phase 1: Upload (5 minutes)
1. User uploads CSV/Excel files
2. System parses files and extracts metadata
3. System stores files in temporary storage
4. System returns preview of data

### Phase 2: Mapping (10-15 minutes)
1. System suggests field mappings (auto-detect)
2. User reviews and adjusts mappings
3. User saves mapping configuration
4. System validates mapping completeness

### Phase 3: Validation (5-10 minutes)
1. System validates all data against rules
2. System checks relationships
3. System generates validation report
4. User reviews errors/warnings
5. User fixes errors in source files OR skips invalid rows

### Phase 4: Import (10-30 minutes depending on size)
1. User initiates import
2. System creates database transaction
3. System imports data in order:
   - Workers (no dependencies)
   - Programs (no dependencies)
   - Families (no dependencies)
   - Children (depends on families)
   - Cases (depends on children, workers, programs)
   - Placements (depends on children)
   - Assessments (depends on children)
   - Goals (depends on children, cases)
   - Education Records (depends on children)
   - Medical Records (depends on children)
   - Behavioral Incidents (depends on children)
4. System commits transaction
5. System generates import report

### Phase 5: Review (5 minutes)
1. User reviews import results
2. User verifies data in CareAccess
3. User can rollback if needed (within 24 hours)

**Total Time: 35-65 minutes for typical organization**

---

## Error Handling

### Strategy 1: Fail Fast (Recommended for MVP)
- Stop import on first error
- Rollback all changes
- User fixes errors and re-imports

### Strategy 2: Skip Errors
- Continue import, skip invalid rows
- Log all errors
- User can fix and re-import failed rows later

### Strategy 3: Best Effort
- Import what's valid
- Create placeholder records for missing relationships
- User fixes relationships later

**Recommendation:** Use Strategy 1 for MVP, add Strategy 2 later

---

## Security Considerations

### 1. File Upload Security
- ✅ Validate file types (CSV, XLSX only)
- ✅ Scan for malware
- ✅ Limit file size (100MB max)
- ✅ Store in isolated temporary storage
- ✅ Delete files after 24 hours

### 2. Data Privacy
- ✅ Encrypt SSN during import
- ✅ Hash sensitive fields
- ✅ Audit all imports
- ✅ Require admin role for imports

### 3. Multi-tenancy
- ✅ Ensure all imported data has organizationId
- ✅ Prevent cross-tenant data leaks
- ✅ Validate user has permission to import

---

## Testing Strategy

### Unit Tests
- ✅ Field mapping logic
- ✅ Data transformations
- ✅ Validation rules
- ✅ Date parsing

### Integration Tests
- ✅ File upload
- ✅ CSV parsing
- ✅ Database transactions
- ✅ Rollback functionality

### End-to-End Tests
- ✅ Complete import flow
- ✅ Error handling
- ✅ Large dataset (1000+ records)

### Test Data
Create sample extendedReach exports:
- `test-data/extendedreach/children.csv` (100 rows)
- `test-data/extendedreach/cases.csv` (150 rows)
- `test-data/extendedreach/placements.csv` (200 rows)

---

## MVP Scope (First Release)

### Must Have
- ✅ Upload CSV files
- ✅ Auto-detect field mappings
- ✅ Validate data
- ✅ Import children, cases, workers, programs
- ✅ Error reporting
- ✅ Rollback capability

### Nice to Have (Later)
- ⏭️ Excel (.xlsx) support
- ⏭️ Manual field mapping UI
- ⏭️ Import templates for multiple systems
- ⏭️ Incremental imports (updates)
- ⏭️ Import scheduling
- ⏭️ Import history

---

## Next Steps

1. ✅ **Create database migrations** for import_jobs, import_errors, import_audit
2. ⏭️ **Build import service** (NestJS)
3. ⏭️ **Create API endpoints** for upload, validate, execute
4. ⏭️ **Build import UI** (Flutter)
5. ⏭️ **Create test data** from extendedReach
6. ⏭️ **Test with pilot customer**

---

*Last Updated: January 14, 2026*
