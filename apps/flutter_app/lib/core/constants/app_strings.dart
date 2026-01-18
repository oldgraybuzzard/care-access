/// CareAccess UI Copy - Nonprofit-Appropriate, Child-Centered Language
///
/// This file contains all user-facing text for the CareAccess platform.
/// Language is intentionally:
/// - Child- and family-centered
/// - Calm, supportive, and non-technical
/// - Appropriate for nonprofits, boards, auditors, and funders
/// - Avoids jargon and "enterprise software" tone
library;

class AppStrings {
  // ========================================
  // App Identity
  // ========================================
  static const String appName = 'CareAccess';
  static const String appSubtitle =
      'Secure access for teams supporting children and families';

  // ========================================
  // Authentication Screens
  // ========================================
  static const String loginHeader = 'Welcome to CareAccess';
  static const String loginSubtext =
      'Secure access to information that helps support children and families.';
  static const String emailFieldLabel = 'Email address';
  static const String passwordFieldLabel = 'Password';
  static const String loginButton = 'Sign In';
  static const String forgotPassword = 'Forgot your password?';
  static const String securityNotice =
      'This system contains confidential information and is monitored for appropriate use.';

  // Login validation messages
  static const String emailRequired = 'Email address is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String loginFailed =
      'Unable to sign in. Please check your credentials and try again.';

  // ========================================
  // Home / Dashboard
  // ========================================
  static const String dashboardHeader = 'Program Snapshot';
  static const String dashboardSubheader =
      'A real-time overview of services supporting children and families.';
  static const String dashboardEmptyState =
      'No data available for the selected time period.';
  static const String filterLabel =
      'Filter by program, date range, or staff member';

  // ========================================
  // Navigation Labels
  // ========================================
  static const String navHome = 'Home';
  static const String navSearch = 'Search';
  static const String navChildrenFamilies = 'Children & Families';
  static const String navCases = 'Cases';
  static const String navReports = 'Reports';
  static const String navDashboards = 'Dashboards';
  static const String navAdministration = 'Administration';
  static const String navSettings = 'Settings';
  static const String navLogout = 'Sign Out';

  // ========================================
  // Search
  // ========================================
  static const String searchPlaceholder =
      'Search children, families, case IDs, or programs…';
  static const String searchNoResults = 'No matching records were found.';
  static const String searchNoResultsHint =
      'Try adjusting your search or filters.';

  // ========================================
  // Child / Family Profile View
  // ========================================
  static const String profileHeader = 'Child & Family Overview';
  static const String profileNameLabel = 'Name';
  static const String profileProgramLabel = 'Program';
  static const String profileAssignedStaffLabel = 'Assigned Staff';
  static const String profileCaseStatusLabel = 'Case Status';
  static const String profileEnrollmentDateLabel = 'Enrollment Date';
  static const String profileReadOnlyNotice =
      'This information is view-only and reflects the most recent available data.';

  // ========================================
  // Case Detail View
  // ========================================
  static const String caseHeader = 'Case Summary';
  static const String caseStatusLabel = 'Current Case Status';
  static const String caseTimelineHeader = 'Case Activity Timeline';
  static const String caseComplianceHeader = 'Compliance Items';

  // Compliance status messages
  static const String complianceAllCurrent = '✔ All required items are current';
  static const String complianceAttentionNeeded = '⚠ Attention needed';
  static const String complianceOverdue = '⛔ Overdue items present';

  // Case notes
  static const String caseNotesHeader = 'Case Notes (Summary View)';
  static const String caseNotesDisclaimer =
      'Notes are shown for awareness and continuity of care. Editing is not available in this application.';

  // ========================================
  // Activities / Contacts
  // ========================================
  static const String activitiesHeader = 'Recent Activities';
  static const String activitiesEmptyState =
      'No activities recorded during this period.';

  // ========================================
  // Documents (Metadata Only)
  // ========================================
  static const String documentsHeader = 'Documents';
  static const String documentsDescription =
      'This list shows document titles and dates. File editing and uploads are managed in the primary case system.';

  // ========================================
  // Reports
  // ========================================
  static const String reportsHomeHeader = 'Reports & Exports';
  static const String reportsStandardSection = 'Common Reports';
  static const String reportsCustomBuilderHeader = 'Build a Custom Report';
  static const String reportsBuilderHelperText =
      'Select criteria to generate a report based on available case and service data.';
  static const String reportsNoResults =
      'No data matched your selected criteria.';

  // Report action buttons
  static const String reportRunButton = 'Run Report';
  static const String reportViewResults = 'View Results';
  static const String reportExportCsv = 'Export (CSV)';
  static const String reportExportExcel = 'Export (Excel)';

  // ========================================
  // Dashboards
  // ========================================
  static const String dashboardsHeader = 'Outcomes & Trends';
  static const String dashboardsSubheader =
      'Visual summaries to support program oversight and decision-making.';
  static const String chartTooltip =
      'Data reflects reported activity for the selected period.';

  // ========================================
  // Permissions & Access Messages
  // ========================================
  static const String unauthorizedAccess =
      'You do not have permission to view this information.';
  static const String sessionTimeout =
      'Your session has expired to protect confidential information. Please sign in again.';
  static const String notAuthenticated = 'Please sign in to continue.';

  // ========================================
  // Audit & Transparency Notices
  // ========================================
  static const String auditNotice =
      'CareAccess is a read-only access and reporting tool designed to support nonprofit organizations serving children and families. All access is logged to ensure appropriate use.';

  static const String ethicsStatement =
      '''CareAccess is designed to support nonprofit organizations serving children and families. It provides secure, role-based access to information for legitimate care, compliance, and oversight purposes. All access is monitored, and data is handled with respect for privacy, dignity, and safety.''';

  // ========================================
  // General UI Elements
  // ========================================
  static const String loading = 'Loading...';
  static const String retry = 'Try Again';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String close = 'Close';
  static const String ok = 'OK';

  // Error messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Unable to connect. Please check your internet connection.';
  static const String errorLoadingData = 'Unable to load data at this time.';

  // ========================================
  // POLICY & FRAMEWORK
  // ========================================
  static const String dataEthicsFramework =
      'Data Ethics & Child Privacy Framework';
  static const String userAccessPolicy = 'User Access & Data Use Policy';
  static const String viewFullPolicy = 'View Full Policy';
  static const String policies = 'Policies';
  static const String viewPolicies = 'View Policies';

  // Policy Acknowledgement
  static const String policyAcknowledgementTitle =
      'User Access & Data Use Policy';
  static const String policyAcknowledgementMessage =
      'By accessing CareAccess, you acknowledge your responsibility to protect the privacy, dignity, '
      'and confidentiality of children and families and to use the platform in alignment with your '
      'organization\'s mission and policies.';
  static const String iAcknowledge = 'I Acknowledge';
  static const String mustAcknowledgePolicy =
      'You must acknowledge the User Access & Data Use Policy to continue';

  // Framework Sections
  static const String foundationalCommitments = 'Foundational Commitments';
  static const String childFirstDataEthic = 'Child-First Data Ethic';
  static const String nonprofitMissionAlignment = 'Nonprofit Mission Alignment';
  static const String purposeLimitedUse = 'Purpose-Limited Use';
  static const String tenantDataIsolation = 'Tenant Data Isolation';
  static const String readOnlyByDefault = 'Read-Only by Default';
  static const String dataMinimization =
      'Data Minimization & Retention Awareness';
  static const String nonCommercialUse = 'Non-Commercial Data Use Guarantee';

  // Policy Sections
  static const String authorizedUsers = 'Authorized Users';
  static const String organizationalScope = 'Organizational Scope';
  static const String roleBasedAccess = 'Role-Based Access Levels';
  static const String appropriateUse = 'Appropriate Use';
  static const String reportingExports = 'Reporting & Exports';
  static const String monitoringEnforcement = 'Monitoring & Enforcement';

  // Product Owner
  static const String productOwner = 'Melken TechWork';
  static const String platformVersion = '1.0';

  // ========================================
  // Governance & Compliance UX
  // ========================================

  // First-Login Acknowledgement
  static const String firstLoginTitle = 'Data Access Acknowledgement';
  static const String firstLoginMessage =
      'This system contains confidential information about children and families.\n\n'
      'Access is role-based, monitored, and permitted only for legitimate work-related purposes.\n\n'
      'By continuing, you acknowledge that you will protect the privacy and dignity of all individuals in this system.';
  static const String acknowledgeButton = 'I Acknowledge';

  // Read-Only Banner
  static const String readOnlyBannerTitle = 'Read-Only View';
  static const String readOnlyBannerMessage =
      'You are viewing a read-only snapshot of this information.\n'
      'Updates must be made in the primary case management system.';

  // Export Warning
  static const String exportWarningTitle = 'Export Data Warning';
  static const String exportWarningMessage =
      'Exported data may contain sensitive information about children and families.\n\n'
      'Please ensure it is stored and shared according to your organization\'s privacy and security policies.\n\n'
      'All exports are logged and monitored.';
  static const String exportContinueButton = 'Continue Export';
  static const String exportCancelButton = 'Cancel';

  // Unauthorized Access
  static const String unauthorizedAccessTitle = 'Access Denied';
  static const String unauthorizedAccessMessage =
      'You do not have permission to view this information.\n\n'
      'If you believe this is an error, please contact your organization administrator.';

  // Admin Settings Copy
  static const String adminResponsibilityNotice =
      'Organization administrators are responsible for managing user access and ensuring permissions align with job responsibilities.';

  // Audit Log Notice
  static const String auditLogNotice =
      'All activity is logged and auditable. Access is monitored for compliance and security.';
}
