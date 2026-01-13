import 'package:freezed_annotation/freezed_annotation.dart';

part 'mfa_login_response.freezed.dart';
part 'mfa_login_response.g.dart';

@freezed
class MfaLoginResponse with _$MfaLoginResponse {
  const factory MfaLoginResponse({
    required bool mfaRequired,
    String? tempToken,
    String? message,
  }) = _MfaLoginResponse;

  factory MfaLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaLoginResponseFromJson(json);
}

