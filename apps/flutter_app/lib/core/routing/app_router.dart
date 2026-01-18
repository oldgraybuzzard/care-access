import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/mfa_setup_screen.dart';
import '../../features/auth/presentation/mfa_verify_screen.dart';
import '../../features/auth/presentation/mfa_login_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/clients/presentation/client_detail_screen.dart';
import '../../features/cases/presentation/case_detail_screen.dart';
import '../../features/children/presentation/children_list_screen.dart';
import '../../features/children/presentation/child_profile_screen.dart';
import '../../features/children/presentation/child_form_screen.dart';
import '../../features/children/presentation/child_intake_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/dashboards/presentation/dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/organization_settings_screen.dart';
import '../../features/settings/presentation/change_password_screen.dart';
import '../../features/settings/presentation/organization_edit_screen.dart';
import '../../features/settings/presentation/user_management_screen.dart';
import '../../features/settings/presentation/about_screen.dart';
import '../../features/settings/presentation/policies_screen.dart';
import '../../features/admin/presentation/admin_organizations_screen.dart';
import '../../features/admin/presentation/superadmin_dashboard_screen.dart';
import '../providers/auth_provider.dart';

/// Notifier that listens to auth state changes and notifies GoRouter
class AuthNotifier extends ChangeNotifier {
  final Ref _ref;
  ProviderSubscription? _subscription;

  AuthNotifier(this._ref) {
    // Listen to auth state changes
    _subscription = _ref.listen(
      authStateProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.value?.isAuthenticated ?? false;
      final user = authState.value?.user;
      final isLoggingIn = state.matchedLocation == '/login';
      final isMfaRoute = state.matchedLocation.startsWith('/mfa');
      final isSuperAdmin = user?.isSuperAdmin ?? false;

      // Allow MFA routes without authentication
      if (isMfaRoute) {
        return null;
      }

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        // Redirect SuperAdmins to their dashboard, org users to search
        if (isSuperAdmin) {
          return '/admin/dashboard';
        }
        return '/search';
      }

      // Block SuperAdmins from accessing org-specific routes
      if (isLoggedIn && isSuperAdmin) {
        final orgRoutes = [
          '/search',
          '/children',
          '/clients',
          '/cases',
          '/reports',
          '/dashboard',
        ];

        // Check if current route starts with any org-specific route
        if (orgRoutes.any((route) => state.matchedLocation.startsWith(route))) {
          return '/admin/dashboard';
        }
      }

      // Block org users from accessing SuperAdmin routes
      if (isLoggedIn &&
          !isSuperAdmin &&
          state.matchedLocation.startsWith('/admin')) {
        return '/search';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/mfa/setup',
        builder: (context, state) => const MfaSetupScreen(),
      ),
      GoRoute(
        path: '/mfa/verify',
        builder: (context, state) => const MfaVerifyScreen(),
      ),
      GoRoute(
        path: '/mfa/login',
        builder: (context, state) {
          final tempToken = state.extra as String;
          return MfaLoginScreen(tempToken: tempToken);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/clients/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ClientDetailScreen(clientId: id);
        },
      ),
      GoRoute(
        path: '/cases/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CaseDetailScreen(caseId: id);
        },
      ),
      GoRoute(
        path: '/children',
        builder: (context, state) => const ChildrenListScreen(),
      ),
      GoRoute(
        path: '/children/new',
        builder: (context, state) => const ChildFormScreen(),
      ),
      GoRoute(
        path: '/children/intake',
        builder: (context, state) => const ChildIntakeScreen(),
      ),
      GoRoute(
        path: '/children/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChildProfileScreen(childId: id);
        },
      ),
      GoRoute(
        path: '/children/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChildFormScreen(childId: id);
        },
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/organization',
        builder: (context, state) => const OrganizationSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/settings/organization/edit',
        builder: (context, state) => const OrganizationEditScreen(),
      ),
      GoRoute(
        path: '/settings/users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/settings/policies',
        builder: (context, state) => const PoliciesScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const SuperAdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/organizations',
        builder: (context, state) => const AdminOrganizationsScreen(),
      ),
    ],
  );
});
