import 'package:freezed_annotation/freezed_annotation.dart';

part 'mfa_setup_response.freezed.dart';
part 'mfa_setup_response.g.dart';

@freezed
class MfaSetupResponse with _$MfaSetupResponse {
  const factory MfaSetupResponse({
    required String qrCode,
    required List<String> backupCodes,
    required String message,
  }) = _MfaSetupResponse;

  factory MfaSetupResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaSetupResponseFromJson(json);
}

