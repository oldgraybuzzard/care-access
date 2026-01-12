# Security & Compliance Readiness Overview

**CareAccess Platform**  
Owned & Operated by Melken TechWork

---

## Purpose

This document maps CareAccess security controls to industry-standard compliance frameworks. While CareAccess is not currently certified, it is designed with SOC 2 and HIPAA-adjacent safeguards to support nonprofit governance, grant compliance, and future certification readiness.

---

## SOC 2 Trust Service Criteria Alignment

CareAccess aligns with the five SOC 2 Trust Service Criteria:

### Security

**Objective:** The system is protected against unauthorized access (both physical and logical).

**CareAccess Controls:**
- ✅ **JWT-based authentication** - Secure token-based authentication
- ✅ **Role-based access control (RBAC)** - Users see only what they need
- ✅ **Audit logging** - All access is logged and reviewable
- ✅ **Encryption in transit** - TLS for all data transmission
- ✅ **Encryption at rest** - Stored data is encrypted
- ✅ **Session management** - Secure session handling and timeout
- ✅ **Password policies** - Strong password requirements

---

### Availability

**Objective:** The system is available for operation and use as committed or agreed.

**CareAccess Controls:**
- ✅ **99.9% uptime target** - Monitored and measured
- ✅ **Monitored services** - Real-time infrastructure monitoring
- ✅ **Incident response** - Documented procedures for outages
- ✅ **Backup and recovery** - Regular database backups
- ✅ **Redundancy** - Cloud infrastructure with failover capabilities

---

### Confidentiality

**Objective:** Information designated as confidential is protected as committed or agreed.

**CareAccess Controls:**
- ✅ **Tenant isolation** - Strict organizational data separation
- ✅ **Least-privilege access** - Users see minimum necessary data
- ✅ **No cross-tenant access** - Technically and contractually prohibited
- ✅ **Secure data transmission** - TLS encryption
- ✅ **Access logging** - All data access is auditable
- ✅ **Export controls** - Monitored and logged

---

### Processing Integrity

**Objective:** System processing is complete, valid, accurate, timely, and authorized.

**CareAccess Controls:**
- ✅ **Read-only by default** - Protects source data integrity
- ✅ **Source-of-record clarity** - Source systems remain authoritative
- ✅ **Data validation** - Input validation and error handling
- ✅ **Audit trails** - Complete activity logging
- ✅ **Change management** - Controlled deployment processes

---

### Privacy

**Objective:** Personal information is collected, used, retained, disclosed, and disposed of in conformity with commitments.

**CareAccess Controls:**
- ✅ **Purpose-limited use** - Data used only for stated purposes
- ✅ **Retention awareness** - Customer-controlled retention policies
- ✅ **Data minimization** - Only necessary data is cached
- ✅ **No monetization** - Data never sold or shared
- ✅ **User consent** - Policy acknowledgement required
- ✅ **Data deletion** - Upon termination, data is deleted per policy

---

## HIPAA-Adjacent Safeguards

While CareAccess is **not marketed as a HIPAA-compliant system**, it aligns with many HIPAA safeguards. This positioning is ideal for nonprofits that handle sensitive child and family information without over-claiming compliance.

### Administrative Safeguards

**CareAccess Alignment:**
- ✅ **Security management process** - Documented policies and procedures
- ✅ **Workforce security** - Role-based access and training requirements
- ✅ **Information access management** - Least-privilege access controls
- ✅ **Security awareness and training** - User acknowledgement and training
- ✅ **Security incident procedures** - Documented incident response

---

### Physical Safeguards

**CareAccess Alignment:**
- ✅ **Facility access controls** - Cloud infrastructure with physical security
- ✅ **Workstation security** - Secure authentication and session management
- ✅ **Device and media controls** - Encrypted data storage

---

### Technical Safeguards

**CareAccess Alignment:**
- ✅ **Access controls** - Unique user identification, RBAC, session timeout
- ✅ **Audit controls** - Comprehensive activity logging
- ✅ **Integrity controls** - Data validation and error handling
- ✅ **Transmission security** - TLS encryption for all data transmission

---

### Organizational Requirements

**CareAccess Alignment:**
- ✅ **Business associate agreements** - Data Processing Addendum (DPA) available
- ✅ **Written contract requirements** - Terms of Service and DPA

---

## Additional Security Controls

### Authentication & Access

- **Multi-factor authentication (MFA)** - Available for enhanced security
- **Password complexity** - Enforced strong password requirements
- **Session timeout** - Automatic logout after inactivity
- **Failed login protection** - Account lockout after failed attempts

### Data Protection

- **Encryption at rest** - AES-256 encryption for stored data
- **Encryption in transit** - TLS 1.2+ for all data transmission
- **Secure key management** - Industry-standard key storage
- **Data masking** - Sensitive data masked in logs and exports

### Monitoring & Logging

- **Comprehensive audit logs** - All user and system activity
- **Real-time monitoring** - Infrastructure and application monitoring
- **Alerting** - Automated alerts for security events
- **Log retention** - Logs retained per policy and regulations

### Incident Response

- **Documented procedures** - Incident response plan
- **Customer notification** - Prompt notification of confirmed incidents
- **Post-incident review** - Root cause analysis and remediation
- **Continuous improvement** - Lessons learned incorporated

### Vulnerability Management

- **Regular updates** - Security patches applied promptly
- **Dependency scanning** - Automated vulnerability scanning
- **Penetration testing** - Periodic security assessments
- **Code review** - Security-focused code review process

---

## Compliance Readiness Roadmap

### Current State (v1.0)
- ✅ Core security controls implemented
- ✅ Audit logging and monitoring
- ✅ Tenant isolation and RBAC
- ✅ Encryption in transit and at rest
- ✅ Documented policies and procedures

### Near-Term (6-12 months)
- 🔄 SOC 2 Type I certification
- 🔄 Enhanced monitoring and alerting
- 🔄 Formal penetration testing
- 🔄 Third-party security audit

### Long-Term (12-24 months)
- 🔄 SOC 2 Type II certification
- 🔄 HIPAA compliance (if market demands)
- 🔄 ISO 27001 certification
- 🔄 FedRAMP readiness (if serving government-funded nonprofits)

---

## Subprocessors & Third Parties

CareAccess uses the following subprocessors:

| Subprocessor | Purpose | Data Access | Location |
|--------------|---------|-------------|----------|
| Railway | Cloud hosting | Infrastructure | United States |
| PostgreSQL | Database services | Data storage | United States |
| Supabase | Auth & database | Authentication | United States |

**Note:** Full subprocessor list available upon request. Customers are notified of changes to subprocessors.

---

## Customer Responsibilities

To maintain security and compliance, customers are responsible for:

- **User management** - Adding, removing, and updating user access
- **Training** - Ensuring users complete required privacy training
- **Monitoring** - Reviewing audit logs for unusual activity
- **Incident reporting** - Reporting suspected security incidents
- **Policy compliance** - Enforcing organizational data handling policies

---

## Melken TechWork Commitments

Melken TechWork commits to:

- **Continuous improvement** - Regular security enhancements
- **Transparency** - Clear communication about security practices
- **Incident response** - Prompt investigation and notification
- **Compliance readiness** - Ongoing alignment with industry standards
- **Customer support** - Assistance with security and compliance questions

---

**Last Updated:** January 2026  
**Version:** 1.0  
**Product Owner:** Melken TechWork

For questions about security controls or compliance, please contact: [security@melkentech.com](mailto:security@melkentech.com)

