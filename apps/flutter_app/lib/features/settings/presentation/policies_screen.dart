import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.policies),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Data Ethics Framework'),
              Tab(text: 'User Access Policy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DataEthicsFrameworkTab(),
            _UserAccessPolicyTab(),
          ],
        ),
      ),
    );
  }
}

class _DataEthicsFrameworkTab extends StatelessWidget {
  const _DataEthicsFrameworkTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildPurposeSection(context),
        const SizedBox(height: 24),
        _buildCommitmentsSection(context),
        const SizedBox(height: 24),
        _buildEthicalStatement(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dataEthicsFramework,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Product Owner: ${AppStrings.productOwner}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          'Version: ${AppStrings.platformVersion}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildPurposeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purpose',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'CareAccess is a multi-tenant SaaS platform developed by Melken TechWork to support '
              'nonprofit organizations that serve children and families. This framework defines the '
              'principles governing how sensitive data is accessed, processed, protected, and governed.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'These principles ensure that CareAccess:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(context,
                'Protects the safety, dignity, and privacy of children and families'),
            _buildBulletPoint(context,
                'Supports nonprofit missions without commercial exploitation of data'),
            _buildBulletPoint(context,
                'Meets expectations of funders, boards, regulators, and partners'),
            _buildBulletPoint(context,
                'Maintains strict separation of data between organizations'),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.foundationalCommitments,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildCommitmentCard(
          context,
          '1. ${AppStrings.childFirstDataEthic}',
          'All CareAccess design and operational decisions prioritize the best interests of children and families. '
              'Data is surfaced only when it supports care delivery, compliance, or oversight. '
              'Convenience never outweighs safety or dignity.',
          Icons.child_care,
          Colors.blue,
        ),
        _buildCommitmentCard(
          context,
          '2. ${AppStrings.nonprofitMissionAlignment}',
          'CareAccess is purpose-built for nonprofit organizations. Data is used solely to support service delivery, '
              'accountability, and outcomes. No data is used for advertising, profiling, or behavioral targeting.',
          Icons.volunteer_activism,
          Colors.green,
        ),
        _buildCommitmentCard(
          context,
          '3. ${AppStrings.purposeLimitedUse}',
          'Data is used only for legitimate organizational purposes: supporting children and families, '
              'program oversight and quality improvement, and compliance reporting.',
          Icons.assignment,
          Colors.orange,
        ),
        _buildCommitmentCard(
          context,
          '4. Least-Privilege Access',
          'CareAccess enforces strict role-based access control. Users see only the data necessary for their role, '
              'scoped to their organization and program.',
          Icons.lock,
          Colors.red,
        ),
        _buildCommitmentCard(
          context,
          '5. ${AppStrings.tenantDataIsolation}',
          'Each subscribing organization\'s data is logically isolated. All queries are automatically scoped to the '
              'requesting organization. Cross-tenant data access is technically and contractually prohibited.',
          Icons.business,
          Colors.purple,
        ),
        _buildCommitmentCard(
          context,
          '6. ${AppStrings.readOnlyByDefault}',
          'CareAccess is designed as a read-only access, reporting, and analytics platform. Customer case management '
              'systems remain the system of record, reducing risk of accidental changes.',
          Icons.visibility,
          Colors.teal,
        ),
        _buildCommitmentCard(
          context,
          '7. Transparency & Accountability',
          'All access to sensitive data is logged and auditable. Logins, record views, report executions, and exports '
              'are recorded and available to authorized administrators.',
          Icons.fact_check,
          Colors.indigo,
        ),
        _buildCommitmentCard(
          context,
          '8. Security by Design',
          'CareAccess incorporates encryption in transit and at rest, secure authentication, automatic session timeouts, '
              'and regular security monitoring.',
          Icons.security,
          Colors.blueGrey,
        ),
        _buildCommitmentCard(
          context,
          '9. ${AppStrings.dataMinimization}',
          'CareAccess stores only the data required to provide services. Source systems remain authoritative, '
              'and cached data is refreshed regularly.',
          Icons.minimize,
          Colors.brown,
        ),
        _buildCommitmentCard(
          context,
          '10. ${AppStrings.nonCommercialUse}',
          'Customer data is never sold, rented, or shared. Customer data is never used to train AI models. '
              'Customer data remains the exclusive property of the subscribing organization.',
          Icons.verified_user,
          Colors.green[700]!,
        ),
      ],
    );
  }

  Widget _buildEthicalStatement(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[400]),
                const SizedBox(width: 8),
                Text(
                  'Ethical Commitment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'CareAccess exists to support nonprofit organizations serving children and families. '
              'Melken TechWork is committed to ethical data stewardship, strong tenant isolation, '
              'and the responsible use of sensitive information in service of care, accountability, and trust.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAccessPolicyTab extends StatelessWidget {
  const _UserAccessPolicyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildPurposeSection(context),
        const SizedBox(height: 16),
        _buildAuthorizedUsersSection(context),
        const SizedBox(height: 16),
        _buildRoleBasedAccessSection(context),
        const SizedBox(height: 16),
        _buildAppropriateUseSection(context),
        const SizedBox(height: 16),
        _buildMonitoringSection(context),
        const SizedBox(height: 24),
        _buildAcknowledgement(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.userAccessPolicy,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Defines how users may access and use CareAccess',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildPurposeSection(BuildContext context) {
    return _buildPolicyCard(
      context,
      'Purpose',
      'This policy ensures that access aligns with organizational roles, protects child and family '
          'confidentiality, and supports ethical and compliant use of data in a multi-tenant SaaS environment.',
      Icons.info_outline,
      Colors.blue,
    );
  }

  Widget _buildAuthorizedUsersSection(BuildContext context) {
    return _buildPolicyCard(
      context,
      AppStrings.authorizedUsers,
      'Access to CareAccess is limited to:\n\n'
      '• Employees of subscribing organizations\n'
      '• Authorized contractors or volunteers\n'
      '• Organizational leadership and administrators\n\n'
      'Each user must use unique credentials, complete required training, and acknowledge this policy.',
      Icons.people,
      Colors.green,
    );
  }

  Widget _buildRoleBasedAccessSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.admin_panel_settings,
                      color: Colors.purple, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.roleBasedAccess,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoleItem(
              context,
              'Field Staff / Caseworkers',
              'View assigned children, families, and cases. No bulk exports or admin privileges.',
            ),
            _buildRoleItem(
              context,
              'Supervisors / Program Leadership',
              'View program-level data, run standard reports, view dashboards and trends.',
            ),
            _buildRoleItem(
              context,
              'Organization Administrators',
              'Manage users and roles, review audit logs, approve exports, configure settings.',
            ),
            _buildRoleItem(
              context,
              'Platform Administrators (Melken TechWork)',
              'Maintain infrastructure and security. Access is logged and restricted.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppropriateUseSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle,
                      color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.appropriateUse,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Permitted Uses:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(context, 'Supporting children and families'),
            _buildBulletPoint(context, 'Managing and overseeing programs'),
            _buildBulletPoint(context, 'Compliance and reporting obligations'),
            const SizedBox(height: 16),
            Text(
              'Prohibited:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
                context, 'Accessing records without legitimate work purpose'),
            _buildBulletPoint(context, 'Sharing credentials or exported data'),
            _buildBulletPoint(
                context, 'Downloading data to unsecured or personal devices'),
            _buildBulletPoint(
                context, 'Attempting to access data from other organizations'),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringSection(BuildContext context) {
    return _buildPolicyCard(
      context,
      AppStrings.monitoringEnforcement,
      'All user activity is monitored for compliance. Violations may result in access suspension or termination. '
      'Serious violations may trigger investigation and customer notification.',
      Icons.monitor,
      Colors.red,
    );
  }

  Widget _buildAcknowledgement(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Acknowledgement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.policyAcknowledgementMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleItem(BuildContext context, String role, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
