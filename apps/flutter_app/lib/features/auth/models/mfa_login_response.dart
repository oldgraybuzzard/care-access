class MfaLoginResponse {
  final bool mfaRequired;
  final String? tempToken;
  final String? message;

  MfaLoginResponse({
    required this.mfaRequired,
    this.tempToken,
    this.message,
  });

  factory MfaLoginResponse.fromJson(Map<String, dynamic> json) {
    return MfaLoginResponse(
      mfaRequired: json['mfaRequired'] ?? false,
      tempToken: json['tempToken'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mfaRequired': mfaRequired,
      'tempToken': tempToken,
      'message': message,
    };
  }
}
