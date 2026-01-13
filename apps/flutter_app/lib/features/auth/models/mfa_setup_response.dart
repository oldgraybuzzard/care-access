class MfaSetupResponse {
  final String qrCode;
  final List<String> backupCodes;
  final String message;

  MfaSetupResponse({
    required this.qrCode,
    required this.backupCodes,
    required this.message,
  });

  factory MfaSetupResponse.fromJson(Map<String, dynamic> json) {
    return MfaSetupResponse(
      qrCode: json['qrCode'],
      backupCodes: List<String>.from(json['backupCodes'] ?? []),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
      'backupCodes': backupCodes,
      'message': message,
    };
  }
}
