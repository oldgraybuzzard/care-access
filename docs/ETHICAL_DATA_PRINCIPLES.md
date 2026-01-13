# CareAccess Ethical Data & Child Privacy Principles

These principles guide all architecture, UI decisions, logging, governance, and documentation for CareAccess. They strengthen grant proposals, board confidence, and ensure we maintain the highest standards of care for children and families.

---

## 1. Child-First Data Principle

**Design Assumption:**  
Every data decision must prioritize the safety, dignity, and well-being of children and families.

**Implementation:**
- No unnecessary exposure of sensitive fields
- Avoid showing data "just because it's available"
- Default to minimal views with progressive disclosure
- UI language is respectful and child-centered

---

## 2. Least-Privilege Access

**Principle:**  
Users only see what they need to do their role—nothing more.

**Implementation:**
- Strong role-based access control (RBAC)
- Field-level masking if needed (e.g., SSNs never shown)
- Admin-only access to exports and bulk data
- Scoped views tied to user role and program

---

## 3. Read-Only by Default

**Principle:**  
CareAccess informs care—it does not alter official records unless explicitly authorized.

**Implementation:**
- MVP is view-only
- Clear UI messaging: "This information is view-only"
- No accidental edits or shadow records
- ExtendedReach remains the system of record

---

## 4. Transparency & Accountability

**Principle:**  
All access to child and family data should be accountable.

**Implementation:**
- Audit logs for:
  - Logins
  - Record views
  - Report runs
  - Exports
- Clear policy: access is monitored and reviewed
- Transparency notices in UI

---

## 5. Purpose-Limited Data Use

**Principle:**  
Data is accessed only for legitimate program, compliance, or care-related purposes.

**Implementation:**
- No "free-browse" access
- Filters and scoped views tied to user role/program
- Explicit language in UI and policy
- Clear purpose statements in documentation

---

## 6. Secure by Design

**Principle:**  
Security is foundational, not optional.

**Implementation:**
- Encryption in transit (HTTPS/TLS)
- Encryption at rest (database encryption)
- Secure token storage (Flutter Secure Storage)
- Short-lived sessions with automatic timeouts
- Environment-based secrets (Railway, .env)
- JWT-based authentication with refresh tokens

---

## 7. Respectful Language & Framing

**Principle:**  
Language should reinforce dignity and respect.

**Implementation:**
- "Children & Families" vs "Records" where appropriate
- Avoid criminal-justice or enforcement-style language
- Clear, calm messaging for errors and access denial
- Supportive, non-technical tone throughout UI

---

## 8. Data Minimization & Retention Awareness

**Principle:**  
Retain only what is necessary and understand where authoritative data lives.

**Implementation:**
- ExtendedReach remains system of record
- Cached data refreshed regularly
- No long-term storage beyond reporting needs unless approved
- Clear data retention policies

---

## 9. Non-Commercial Use Commitment

**Principle:**  
Child and family data will never be monetized or repurposed.

**Implementation:**
- Explicit policy statement
- No analytics tracking beyond operational metrics
- If SaaS expands, strict tenant isolation and data ownership guarantees
- Clear terms of service for nonprofit use

---

## 10. Explainability for Non-Technical Users

**Principle:**  
Staff should understand what they're seeing and why.

**Implementation:**
- Tooltips and plain-language explanations
- Clear labels for "snapshot," "summary," and "trend"
- Avoid black-box analytics
- Help text and contextual guidance throughout UI

---

## Ethics Statement (User-Facing)

> CareAccess is designed to support nonprofit organizations serving children and families. It provides secure, role-based access to information for legitimate care, compliance, and oversight purposes. All access is monitored, and data is handled with respect for privacy, dignity, and safety.

---

## For Developers

When building features for CareAccess:

1. **Ask:** Does this feature prioritize child safety and dignity?
2. **Verify:** Does the user need to see this data for their role?
3. **Confirm:** Is the language respectful and non-technical?
4. **Check:** Are we logging access appropriately?
5. **Ensure:** Is this data secured in transit and at rest?
6. **Document:** Can a non-technical user understand what they're seeing?

These principles are not optional—they are core to CareAccess's mission and values.

