import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
}

class PasswordApi {
  final Dio _dio;

  PasswordApi(this._dio);

  /// Change current user's password
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.patch(
      '/auth/change-password',
      data: request.toJson(),
    );
  }
}

final passwordApiProvider = Provider<PasswordApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PasswordApi(dio);
});

