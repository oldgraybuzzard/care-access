import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../api/mfa_api.dart';
import '../storage/secure_storage.dart';
import '../models/auth_state.dart';
import '../models/user.dart';
import '../../features/auth/models/mfa_login_response.dart';

/// Provider that checks if user is authenticated
/// This is a FutureProvider that gets invalidated when auth state changes
final authStateProvider = FutureProvider<AuthState>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.getAccessToken();
  final userJson = await storage.getUser();

  if (token != null && userJson != null) {
    final user = User.fromJson(jsonDecode(userJson));
    return AuthState(isAuthenticated: true, user: user);
  } else {
    return const AuthState(isAuthenticated: false);
  }
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref _ref;

  AuthService(this._ref);

  /// Login with email and password
  /// Returns MfaLoginResponse if MFA is required, null otherwise
  Future<MfaLoginResponse?> login(String email, String password) async {
    final dio = _ref.read(dioProvider);
    final storage = _ref.read(secureStorageProvider);

    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    // Check if MFA is required
    if (response.data['mfaRequired'] == true) {
      return MfaLoginResponse.fromJson(response.data);
    }

    // Normal login flow (no MFA)
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    final user = response.data['user'];

    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    await storage.saveUser(jsonEncode(user));

    // Invalidate auth state to trigger re-check
    _ref.invalidate(authStateProvider);

    return null;
  }

  /// Complete MFA login with temp token and TOTP token
  Future<void> completeMfaLogin(String tempToken, String token) async {
    final mfaApi = _ref.read(mfaApiProvider);
    final storage = _ref.read(secureStorageProvider);

    final response = await mfaApi.verifyMfaLogin(
      tempToken: tempToken,
      token: token,
    );

    final accessToken = response['accessToken'];
    final refreshToken = response['refreshToken'];
    final user = response['user'];

    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    await storage.saveUser(jsonEncode(user));

    // Invalidate auth state to trigger re-check
    _ref.invalidate(authStateProvider);
  }

  Future<void> logout() async {
    final dio = _ref.read(dioProvider);
    final storage = _ref.read(secureStorageProvider);

    try {
      await dio.post('/auth/logout');
    } catch (e) {
      // Ignore errors on logout
    }

    await storage.clearTokens();

    // Invalidate auth state to trigger re-check
    _ref.invalidate(authStateProvider);
  }

  Future<User?> getCurrentUser() async {
    final storage = _ref.read(secureStorageProvider);
    final userJson = await storage.getUser();

    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }

    return null;
  }
}
