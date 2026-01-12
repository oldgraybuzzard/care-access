/// Report models for the FCF app
class ReportDefinition {
  final String id;
  final String name;
  final String? description;
  final String type; // 'standard' or 'custom'
  final bool isShared;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportDefinition({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.isShared,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportDefinition.fromJson(Map<String, dynamic> json) {
    return ReportDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      isShared: json['isShared'] as bool? ?? false,
      metaJson: json['metaJson'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'isShared': isShared,
      'metaJson': metaJson,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ReportRun {
  final String id;
  final String? reportDefinitionId;
  final String requestedBy;
  final String status; // 'running', 'completed', 'failed'
  final DateTime requestedAt;
  final DateTime? finishedAt;
  final int? rowCount;
  final Map<String, dynamic>? metaJson;

  ReportRun({
    required this.id,
    this.reportDefinitionId,
    required this.requestedBy,
    required this.status,
    required this.requestedAt,
    this.finishedAt,
    this.rowCount,
    this.metaJson,
  });

  factory ReportRun.fromJson(Map<String, dynamic> json) {
    return ReportRun(
      id: json['id'] as String,
      reportDefinitionId: json['reportDefinitionId'] as String?,
      requestedBy: json['requestedBy'] as String,
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'] as String)
          : null,
      rowCount: json['rowCount'] as int?,
      metaJson: json['metaJson'] as Map<String, dynamic>?,
    );
  }
}

class ReportResult {
  final String reportRunId;
  final List<Map<String, dynamic>> data;
  final int rowCount;

  ReportResult({
    required this.reportRunId,
    required this.data,
    required this.rowCount,
  });

  factory ReportResult.fromJson(Map<String, dynamic> json) {
    return ReportResult(
      reportRunId: json['reportRunId'] as String,
      data: (json['data'] as List).cast<Map<String, dynamic>>(),
      rowCount: json['rowCount'] as int,
    );
  }
}

class ReportFilters {
  final String? programId;
  final String? workerId;
  final String? status;
  final String? activityType;
  final String? serviceType;
  final DateTime? startDate;
  final DateTime? endDate;

  ReportFilters({
    this.programId,
    this.workerId,
    this.status,
    this.activityType,
    this.serviceType,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (programId != null) json['programId'] = programId;
    if (workerId != null) json['workerId'] = workerId;
    if (status != null) json['status'] = status;
    if (activityType != null) json['activityType'] = activityType;
    if (serviceType != null) json['serviceType'] = serviceType;
    if (startDate != null) json['startDate'] = startDate!.toIso8601String();
    if (endDate != null) json['endDate'] = endDate!.toIso8601String();
    return json;
  }
}

