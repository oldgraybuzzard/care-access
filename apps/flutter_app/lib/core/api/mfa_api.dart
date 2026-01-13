import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/models/mfa_setup_response.dart';
import 'api_client.dart';

class MfaApi {
  final Dio _dio;

  MfaApi(this._dio);

  /// Setup MFA for current user
  /// Returns QR code and backup codes
  Future<MfaSetupResponse> setupMfa() async {
    final response = await _dio.post('/auth/mfa/setup');
    return MfaSetupResponse.fromJson(response.data);
  }

  /// Verify TOTP token and enable MFA
  Future<Map<String, dynamic>> verifyMfa(String token) async {
    final response = await _dio.post(
      '/auth/mfa/verify',
      data: {'token': token},
    );
    return response.data;
  }

  /// Verify MFA token during login
  /// Returns access and refresh tokens
  Future<Map<String, dynamic>> verifyMfaLogin({
    required String tempToken,
    required String token,
  }) async {
    final response = await _dio.post(
      '/auth/mfa/verify-login',
      data: {
        'tempToken': tempToken,
        'token': token,
      },
    );
    return response.data;
  }

  /// Disable MFA for current user
  Future<Map<String, dynamic>> disableMfa(String password) async {
    final response = await _dio.post(
      '/auth/mfa/disable',
      data: {'password': password},
    );
    return response.data;
  }
}

final mfaApiProvider = Provider<MfaApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MfaApi(dio);
});

