import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/brand_assets.dart';
import '../../core/theme/app_theme.dart';
import 'brand_logo.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value?.user;
    final isSuperAdmin = user?.isSuperAdmin ?? false;

    // SuperAdmins get a completely different drawer
    if (isSuperAdmin) {
      return _buildSuperAdminDrawer(context, ref, user);
    }

    // Organization users get the standard drawer
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: CareAccessColors.teal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CareAccess Logo
                const BrandLogo.wordmark(
                  height: 32,
                  color: Colors.white,
                ),
                const Spacer(),
                // User Info
                Text(
                  user?.name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(AppStrings.navHome),
            onTap: () {
              context.go('/dashboard');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text(AppStrings.navSearch),
            onTap: () {
              context.go('/search');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.child_care),
            title: const Text(AppStrings.navChildrenFamilies),
            onTap: () {
              context.go('/children');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text(AppStrings.navReports),
            onTap: () {
              context.go('/reports');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(AppStrings.navDashboards),
            onTap: () {
              context.go('/dashboard');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.navSettings),
            onTap: () {
              context.go('/settings');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(AppStrings.navLogout),
            onTap: () async {
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const Divider(),
          // Brand Attribution Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  BrandInfo.attribution,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CareAccessColors.warmGray,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  BrandInfo.tagline,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CareAccessColors.warmGray,
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build SuperAdmin-specific drawer
  Widget _buildSuperAdminDrawer(BuildContext context, WidgetRef ref, user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: CareAccessColors.teal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo.wordmark(
                  height: 32,
                  color: Colors.white,
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.admin_panel_settings,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'SuperAdmin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              context.go('/admin/dashboard');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Organizations'),
            onTap: () {
              context.go('/admin/organizations');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.navSettings),
            onTap: () {
              context.go('/settings');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(AppStrings.navLogout),
            onTap: () async {
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
