import 'user.dart';

class AuthState {
  final bool isAuthenticated;
  final User? user;

  const AuthState({
    required this.isAuthenticated,
    this.user,
  });
}

