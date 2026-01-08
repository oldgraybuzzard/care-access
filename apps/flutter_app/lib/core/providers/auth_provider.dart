import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../storage/secure_storage.dart';
import '../models/auth_state.dart';
import '../models/user.dart';

final authStateProvider = StreamProvider<AuthState>((ref) async* {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.getAccessToken();
  final userJson = await storage.getUser();

  if (token != null && userJson != null) {
    final user = User.fromJson(jsonDecode(userJson));
    yield AuthState(isAuthenticated: true, user: user);
  } else {
    yield const AuthState(isAuthenticated: false);
  }
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref _ref;

  AuthService(this._ref);

  Future<void> login(String email, String password) async {
    final dio = _ref.read(dioProvider);
    final storage = _ref.read(secureStorageProvider);

    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    final user = response.data['user'];

    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    await storage.saveUser(jsonEncode(user));
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

