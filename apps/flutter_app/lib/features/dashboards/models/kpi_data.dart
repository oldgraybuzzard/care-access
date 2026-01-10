/// Model for dashboard KPI data
class KpiData {
  final int activeCases;
  final int intakes;
  final int closures;
  final int totalClients;
  final int overdueCount;
  final KpiPeriod? period;

  const KpiData({
    required this.activeCases,
    required this.intakes,
    required this.closures,
    required this.totalClients,
    required this.overdueCount,
    this.period,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      activeCases: json['activeCases'] as int? ?? 0,
      intakes: json['intakes'] as int? ?? 0,
      closures: json['closures'] as int? ?? 0,
      totalClients: json['totalClients'] as int? ?? 0,
      overdueCount: json['overdueCount'] as int? ?? 0,
      period: json['period'] != null
          ? KpiPeriod.fromJson(json['period'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeCases': activeCases,
      'intakes': intakes,
      'closures': closures,
      'totalClients': totalClients,
      'overdueCount': overdueCount,
      'period': period?.toJson(),
    };
  }
}

/// Model for KPI period information
class KpiPeriod {
  final DateTime? from;
  final DateTime? to;

  const KpiPeriod({
    this.from,
    this.to,
  });

  factory KpiPeriod.fromJson(Map<String, dynamic> json) {
    return KpiPeriod(
      from: json['from'] != null ? DateTime.parse(json['from'] as String) : null,
      to: json['to'] != null ? DateTime.parse(json['to'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from?.toIso8601String(),
      'to': to?.toIso8601String(),
    };
  }
}

