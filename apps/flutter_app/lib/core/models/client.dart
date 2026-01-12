// Client detail models

class ClientDetail {
  final String id;
  final String vendorSourceId;
  final String vendorClientId;
  final String firstName;
  final String lastName;
  final DateTime? dob;
  final String? programId;
  final String status;
  final Map<String, dynamic>? metaJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VendorSource? vendorSource;
  final ClientProgram? program;
  final List<ClientCase> cases;

  ClientDetail({
    required this.id,
    required this.vendorSourceId,
    required this.vendorClientId,
    required this.firstName,
    required this.lastName,
    this.dob,
    this.programId,
    required this.status,
    this.metaJson,
    required this.createdAt,
    required this.updatedAt,
    this.vendorSource,
    this.program,
    this.cases = const [],
  });

  factory ClientDetail.fromJson(Map<String, dynamic> json) {
    return ClientDetail(
      id: json['id'] ?? '',
      vendorSourceId: json['vendorSourceId'] ?? '',
      vendorClientId: json['vendorClientId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      programId: json['programId'],
      status: json['status'] ?? 'Unknown',
      metaJson: json['metaJson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      vendorSource: json['vendorSource'] != null
          ? VendorSource.fromJson(json['vendorSource'])
          : null,
      program: json['program'] != null
          ? ClientProgram.fromJson(json['program'])
          : null,
      cases: json['cases'] != null
          ? (json['cases'] as List).map((c) => ClientCase.fromJson(c)).toList()
          : [],
    );
  }

  String get fullName => '$firstName $lastName';

  int? get age {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob!.year;
    if (now.month < dob!.month ||
        (now.month == dob!.month && now.day < dob!.day)) {
      age--;
    }
    return age;
  }

  ClientCase? get mostRecentCase => cases.isNotEmpty ? cases.first : null;
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

class ClientProgram {
  final String id;
  final String name;
  final DateTime? createdAt;

  ClientProgram({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory ClientProgram.fromJson(Map<String, dynamic> json) {
    return ClientProgram(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Program',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class ClientCase {
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
  final CaseWorker? worker;
  final ClientProgram? program;

  ClientCase({
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
    this.worker,
    this.program,
  });

  factory ClientCase.fromJson(Map<String, dynamic> json) {
    return ClientCase(
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
      worker:
          json['worker'] != null ? CaseWorker.fromJson(json['worker']) : null,
      program: json['program'] != null
          ? ClientProgram.fromJson(json['program'])
          : null,
    );
  }

  bool get isOpen => closedAt == null;
  bool get isClosed => closedAt != null;
}

class CaseWorker {
  final String id;
  final String name;
  final String? email;
  final DateTime? createdAt;

  CaseWorker({
    required this.id,
    required this.name,
    this.email,
    this.createdAt,
  });

  factory CaseWorker.fromJson(Map<String, dynamic> json) {
    return CaseWorker(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Worker',
      email: json['email'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
