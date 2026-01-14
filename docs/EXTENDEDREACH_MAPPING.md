# extendedReach to CareAccess Field Mapping

**Purpose:** Document field mappings from extendedReach to CareAccess for data migration

**Status:** 🔍 RESEARCH NEEDED - We need sample exports from extendedReach to complete this

---

## How to Get extendedReach Data

### Option 1: Ask Pilot Customer
Contact your pilot customer who is currently using extendedReach and ask them to:

1. **Export sample data** (with fake/anonymized data if possible)
2. **Provide screenshots** of extendedReach screens
3. **Share field names** and data types
4. **Describe their workflow** in extendedReach

### Option 2: Request Demo from extendedReach
- Sign up for extendedReach demo
- Explore the system
- Document field names and structure
- Export sample data

### Option 3: Research Online
- Search for extendedReach documentation
- Look for user manuals
- Check forums/support sites
- Find sample reports

---

## Estimated extendedReach Schema (To Be Verified)

### Children/Youth Table
Based on typical child welfare systems, extendedReach likely has:

```
extendedReach Field          → CareAccess Field         Notes
─────────────────────────────────────────────────────────────────
Child_ID                     → id (or generate new)     Primary key
First_Name                   → firstName
Middle_Name                  → middleName
Last_Name                    → lastName
Nickname                     → nickname
Date_of_Birth                → dateOfBirth              Format: MM/DD/YYYY
Age                          → (calculated)             Don't import, calculate from DOB
Gender                       → gender                   Map: M→Male, F→Female
Race                         → raceEthnicity
Ethnicity                    → raceEthnicity            Combine with race
Primary_Language             → preferredLanguage
SSN                          → ssn                      Encrypt!
Medicaid_Number              → medicaidId
School_ID                    → schoolId
Photo_Path                   → photoUrl                 Need to migrate files
Status                       → status                   Map to: Active, Inactive, Discharged
Custody_Status               → custodyStatus
Legal_Status                 → legalStatus
Referral_Source              → referralSource
Referral_Date                → referralDate
Referral_Reason              → referralReason
Presenting_Issues            → presentingIssues
Intake_Date                  → intakeDate
Discharge_Date               → dischargeDate
```

### Cases Table
```
extendedReach Field          → CareAccess Field         Notes
─────────────────────────────────────────────────────────────────
Case_ID                      → vendorCaseId             Keep original ID
Child_ID                     → childId                  Foreign key
Case_Number                  → caseNumber
Case_Status                  → status
Opened_Date                  → openedAt
Closed_Date                  → closedAt
Assigned_Worker_ID           → assignedWorkerId
Program_ID                   → programId
Case_Type                    → caseType
Priority                     → priority
```

### Placements Table
```
extendedReach Field          → CareAccess Field         Notes
─────────────────────────────────────────────────────────────────
Placement_ID                 → id (or generate new)
Child_ID                     → childId
Placement_Type               → placementType            Foster, Kinship, Group Home, etc.
Placement_Start_Date         → startDate
Placement_End_Date           → endDate
Placement_Provider           → providerName
Placement_Address            → address
Placement_Status             → status
Removal_Reason               → removalReason
```

### Workers/Staff Table
```
extendedReach Field          → CareAccess Field         Notes
─────────────────────────────────────────────────────────────────
Worker_ID                    → id (or generate new)
First_Name                   → firstName
Last_Name                    → lastName
Email                        → email
Phone                        → phone
Title                        → title
Department                   → department
Status                       → status
Hire_Date                    → hireDate
```

### Programs/Services Table
```
extendedReach Field          → CareAccess Field         Notes
─────────────────────────────────────────────────────────────────
Program_ID                   → id (or generate new)
Program_Name                 → name
Program_Type                 → programType
Description                  → description
Status                       → status
```

---

## Questions for Pilot Customer

Send these questions to your pilot customer:

### 1. Data Export Capabilities
- ✅ Can you export data from extendedReach to CSV or Excel?
- ✅ What tables/modules can you export?
- ✅ Are there any limitations on what data can be exported?
- ✅ Can you provide sample exports (with fake data)?

### 2. Data Structure
- ✅ What are the main tables/modules in extendedReach?
- ✅ What fields are in the Children/Youth module?
- ✅ What fields are in the Cases module?
- ✅ What fields are in the Placements module?
- ✅ How are relationships structured (child → case → placement)?

### 3. Data Volume
- ✅ How many children records do you have?
- ✅ How many cases?
- ✅ How many placements?
- ✅ How many workers?
- ✅ How far back does your data go?

### 4. Data Quality
- ✅ Are there required fields in extendedReach?
- ✅ Are there any data quality issues we should know about?
- ✅ Are there custom fields you've added?
- ✅ Are there fields you don't use?

### 5. Migration Priorities
- ✅ What data is most critical to migrate?
- ✅ What data can we skip or import later?
- ✅ Do you need historical data or just active cases?
- ✅ What's your timeline for migration?

---

## Sample Data Request Template

**Email to Pilot Customer:**

```
Subject: CareAccess Migration - Sample Data Request

Hi [Customer Name],

We're excited to help you migrate from extendedReach to CareAccess! To ensure a smooth migration, we need to understand extendedReach's data structure.

Could you please provide:

1. **Sample CSV/Excel exports** from extendedReach (with fake/anonymized data):
   - Children/Youth
   - Cases
   - Placements
   - Workers
   - Programs

2. **Screenshots** of key extendedReach screens:
   - Child profile
   - Case details
   - Placement history
   - Reports

3. **Data volume estimates**:
   - Number of children
   - Number of cases
   - Number of placements
   - Number of workers

4. **Migration priorities**:
   - What data is most critical?
   - What can we import later?
   - Do you need all historical data?

Please anonymize any sensitive information (names, SSNs, addresses, etc.) before sharing.

Thanks!
[Your Name]
```

---

## Mapping Template (To Be Completed)

Once we receive sample data, we'll create a complete mapping template:

```json
{
  "system": "extendedReach",
  "version": "2024",
  "entities": {
    "children": {
      "source_file": "children.csv",
      "primary_key": "Child_ID",
      "mappings": {
        "Child_ID": {
          "target": "vendorChildId",
          "type": "string",
          "required": true
        },
        "First_Name": {
          "target": "firstName",
          "type": "string",
          "required": true
        },
        "Date_of_Birth": {
          "target": "dateOfBirth",
          "type": "date",
          "format": "MM/DD/YYYY",
          "required": true,
          "transform": "parseDate"
        },
        "Gender": {
          "target": "gender",
          "type": "enum",
          "required": true,
          "transform": "mapGender",
          "mapping": {
            "M": "Male",
            "F": "Female",
            "NB": "Non-binary",
            "O": "Other"
          }
        }
      }
    }
  }
}
```

---

## Next Steps

1. ✅ **Contact pilot customer** - Request sample exports
2. ⏭️ **Analyze sample data** - Document actual field names
3. ⏭️ **Create mapping template** - Complete field mappings
4. ⏭️ **Build transformation logic** - Handle data conversions
5. ⏭️ **Test with sample data** - Validate import process
6. ⏭️ **Refine based on feedback** - Iterate with customer

---

*Last Updated: January 14, 2026*

