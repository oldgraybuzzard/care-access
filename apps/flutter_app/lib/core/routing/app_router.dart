import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/clients/presentation/client_detail_screen.dart';
import '../../features/cases/presentation/case_detail_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/dashboards/presentation/dashboard_screen.dart';
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
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
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
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
