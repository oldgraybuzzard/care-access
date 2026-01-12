import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/brand_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/brand_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About CareAccess'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CareAccess Logo and Branding
            Center(
              child: Column(
                children: [
                  // Logo
                  const BrandLogo.lockup(
                    height: 100,
                  ),
                  const SizedBox(height: 24),
                  // Tagline
                  Text(
                    BrandInfo.tagline,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: CareAccessColors.warmGray,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Product Owner
                  Text(
                    BrandInfo.attribution,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: CareAccessColors.warmGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Ethics Statement Section
            _SectionCard(
              title: 'Our Commitment',
              icon: Icons.verified_user,
              iconColor: colorScheme.primary,
              child: Text(
                AppStrings.ethicsStatement,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Audit Notice Section
            _SectionCard(
              title: 'Transparency & Accountability',
              icon: Icons.security,
              iconColor: colorScheme.secondary,
              child: Text(
                AppStrings.auditNotice,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Core Principles Section
            _SectionCard(
              title: 'Core Principles',
              icon: Icons.favorite,
              iconColor: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PrincipleItem(
                    icon: Icons.child_care,
                    title: 'Child-First',
                    description:
                        'Every decision prioritizes child safety and dignity',
                  ),
                  const SizedBox(height: 12),
                  _PrincipleItem(
                    icon: Icons.lock,
                    title: 'Secure by Design',
                    description:
                        'Encryption, secure storage, and monitored access',
                  ),
                  const SizedBox(height: 12),
                  _PrincipleItem(
                    icon: Icons.visibility_off,
                    title: 'Least-Privilege Access',
                    description: 'Users see only what they need for their role',
                  ),
                  const SizedBox(height: 12),
                  _PrincipleItem(
                    icon: Icons.remove_red_eye,
                    title: 'Read-Only by Default',
                    description:
                        'View information without altering official records',
                  ),
                  const SizedBox(height: 12),
                  _PrincipleItem(
                    icon: Icons.policy,
                    title: 'Purpose-Limited Use',
                    description:
                        'Data accessed only for legitimate care purposes',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Full Policies Link
            Card(
              color: Colors.blue[50],
              child: InkWell(
                onTap: () {
                  context.push('/settings/policies');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.policy, color: Colors.blue[700]),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.viewFullPolicy,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View complete Data Ethics Framework and User Access Policy',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.blue[700]),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Version and Copyright Info
            Center(
              child: Column(
                children: [
                  Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CareAccessColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    BrandInfo.copyright,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CareAccessColors.warmGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PrincipleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrincipleItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
