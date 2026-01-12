// Case detail models

class CaseDetail {
  final String id;
  final String vendorSourceId;
  final String vendorCaseId;
  final String clientId;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? assignedWorkerId;
  final String? programId;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CaseClient? client;
  final CaseWorker? worker;
  final CaseProgram? program;
  final VendorSource? vendorSource;

  CaseDetail({
    required this.id,
    required this.vendorSourceId,
    required this.vendorCaseId,
    required this.clientId,
    required this.status,
    required this.openedAt,
    this.closedAt,
    this.assignedWorkerId,
    this.programId,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
    this.client,
    this.worker,
    this.program,
    this.vendorSource,
  });

  factory CaseDetail.fromJson(Map<String, dynamic> json) {
    return CaseDetail(
      id: json['id'] ?? '',
      vendorSourceId: json['vendorSourceId'] ?? '',
      vendorCaseId: json['vendorCaseId'] ?? '',
      clientId: json['clientId'] ?? '',
      status: json['status'] ?? 'Unknown',
      openedAt: json['openedAt'] != null
          ? DateTime.parse(json['openedAt'])
          : DateTime.now(),
      closedAt:
          json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      assignedWorkerId: json['assignedWorkerId'],
      programId: json['programId'],
      metaJson: json['metaJson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      client:
          json['client'] != null ? CaseClient.fromJson(json['client']) : null,
      worker:
          json['worker'] != null ? CaseWorker.fromJson(json['worker']) : null,
      program: json['program'] != null
          ? CaseProgram.fromJson(json['program'])
          : null,
      vendorSource: json['vendorSource'] != null
          ? VendorSource.fromJson(json['vendorSource'])
          : null,
    );
  }

  bool get isOpen => closedAt == null;
  bool get isClosed => closedAt != null;

  int get daysOpen {
    final endDate = closedAt ?? DateTime.now();
    return endDate.difference(openedAt).inDays;
  }
}

class CaseClient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime? dob;
  final String status;
  final CaseProgram? program;

  CaseClient({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.dob,
    required this.status,
    this.program,
  });

  factory CaseClient.fromJson(Map<String, dynamic> json) {
    return CaseClient(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      status: json['status'] ?? 'Unknown',
      program: json['program'] != null
          ? CaseProgram.fromJson(json['program'])
          : null,
    );
  }

  String get fullName => '$firstName $lastName';
}

class CaseWorker {
  final String id;
  final String name;
  final String? email;

  CaseWorker({
    required this.id,
    required this.name,
    this.email,
  });

  factory CaseWorker.fromJson(Map<String, dynamic> json) {
    return CaseWorker(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Worker',
      email: json['email'],
    );
  }
}

class CaseProgram {
  final String id;
  final String name;

  CaseProgram({
    required this.id,
    required this.name,
  });

  factory CaseProgram.fromJson(Map<String, dynamic> json) {
    return CaseProgram(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Program',
    );
  }
}

class VendorSource {
  final String id;
  final String name;

  VendorSource({
    required this.id,
    required this.name,
  });

  factory VendorSource.fromJson(Map<String, dynamic> json) {
    return VendorSource(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }
}

class Activity {
  final String id;
  final String vendorSourceId;
  final String vendorActivityId;
  final String caseId;
  final String activityType;
  final DateTime occurredAt;
  final String? summary;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.vendorSourceId,
    required this.vendorActivityId,
    required this.caseId,
    required this.activityType,
    required this.occurredAt,
    this.summary,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      vendorSourceId: json['vendorSourceId'] ?? '',
      vendorActivityId: json['vendorActivityId'] ?? '',
      caseId: json['caseId'] ?? '',
      activityType: json['activityType'] ?? 'Unknown',
      occurredAt: json['occurredAt'] != null
          ? DateTime.parse(json['occurredAt'])
          : DateTime.now(),
      summary: json['summary'],
      metaJson: json['metaJson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class Service {
  final String id;
  final String vendorSourceId;
  final String vendorServiceId;
  final String caseId;
  final String serviceType;
  final DateTime startAt;
  final DateTime? endAt;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.vendorSourceId,
    required this.vendorServiceId,
    required this.caseId,
    required this.serviceType,
    required this.startAt,
    this.endAt,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      vendorSourceId: json['vendorSourceId'] ?? '',
      vendorServiceId: json['vendorServiceId'] ?? '',
      caseId: json['caseId'] ?? '',
      serviceType: json['serviceType'] ?? 'Unknown',
      startAt: json['startAt'] != null
          ? DateTime.parse(json['startAt'])
          : DateTime.now(),
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      metaJson: json['metaJson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  bool get isActive => endAt == null || endAt!.isAfter(DateTime.now());
}

class Document {
  final String id;
  final String vendorSourceId;
  final String vendorDocumentId;
  final String caseId;
  final String title;
  final String docType;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    required this.id,
    required this.vendorSourceId,
    required this.vendorDocumentId,
    required this.caseId,
    required this.title,
    required this.docType,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? '',
      vendorSourceId: json['vendorSourceId'] ?? '',
      vendorDocumentId: json['vendorDocumentId'] ?? '',
      caseId: json['caseId'] ?? '',
      title: json['title'] ?? 'Untitled',
      docType: json['docType'] ?? 'Unknown',
      metaJson: json['metaJson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class CaseNote {
  final String id;
  final String caseId;
  final String? userId;
  final String content;
  final String? userName;
  final DateTime createdAt;
  final DateTime updatedAt;

  CaseNote({
    required this.id,
    required this.caseId,
    this.userId,
    required this.content,
    this.userName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaseNote.fromJson(Map<String, dynamic> json) {
    return CaseNote(
      id: json['id'] ?? '',
      caseId: json['caseId'] ?? '',
      userId: json['userId'],
      content: json['content'] ?? '',
      userName: json['user']?['name'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class AuditLog {
  final String id;
  final String? userId;
  final String action;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic>? metaJson;
  final String? userName;
  final String? userEmail;
  final DateTime createdAt;

  AuditLog({
    required this.id,
    this.userId,
    required this.action,
    required this.entityType,
    this.entityId,
    this.metaJson,
    this.userName,
    this.userEmail,
    required this.createdAt,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'] ?? '',
      userId: json['userId'],
      action: json['action'] ?? '',
      entityType: json['entityType'] ?? '',
      entityId: json['entityId'],
      metaJson: json['metaJson'],
      userName: json['user']?['name'],
      userEmail: json['user']?['email'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  String get actionDescription {
    switch (action) {
      case 'view':
        return 'Viewed';
      case 'create':
        return 'Created';
      case 'update':
        return 'Updated';
      case 'delete':
        return 'Deleted';
      case 'view_activities':
        return 'Viewed activities';
      case 'view_services':
        return 'Viewed services';
      case 'view_documents':
        return 'Viewed documents';
      default:
        return action;
    }
  }
}
