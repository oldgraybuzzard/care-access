// Search result models for clients and cases

class SearchResponse {
  final List<SearchResultClient> data;
  final SearchMeta meta;

  SearchResponse({
    required this.data,
    required this.meta,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      data: (json['data'] as List)
          .map((item) => SearchResultClient.fromJson(item))
          .toList(),
      meta: SearchMeta.fromJson(json['meta']),
    );
  }
}

class SearchMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  SearchMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory SearchMeta.fromJson(Map<String, dynamic> json) {
    return SearchMeta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class SearchResultClient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String status;
  final String? programId;
  final Program? program;
  final List<Case> cases;

  SearchResultClient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.status,
    this.programId,
    this.program,
    this.cases = const [],
  });

  factory SearchResultClient.fromJson(Map<String, dynamic> json) {
    // Handle both 'dob' (from API) and 'dateOfBirth' (for compatibility)
    final dobField = json['dob'] ?? json['dateOfBirth'];

    return SearchResultClient(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dateOfBirth: dobField != null ? DateTime.parse(dobField) : DateTime.now(),
      status: json['status'] ?? 'Unknown',
      programId: json['programId'],
      program:
          json['program'] != null ? Program.fromJson(json['program']) : null,
      cases: json['cases'] != null
          ? (json['cases'] as List).map((c) => Case.fromJson(c)).toList()
          : [],
    );
  }

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Case? get mostRecentCase => cases.isNotEmpty ? cases.first : null;
}

class Program {
  final String id;
  final String name;
  final String? description;

  Program({
    required this.id,
    required this.name,
    this.description,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Program',
      description: json['description'],
    );
  }
}

class Case {
  final String id;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? assignedWorkerId;
  final Worker? worker;

  Case({
    required this.id,
    required this.status,
    required this.openedAt,
    this.closedAt,
    this.assignedWorkerId,
    this.worker,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id'] ?? '',
      status: json['status'] ?? 'Unknown',
      openedAt: json['openedAt'] != null
          ? DateTime.parse(json['openedAt'])
          : DateTime.now(),
      closedAt:
          json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
      assignedWorkerId: json['assignedWorkerId'],
      worker: json['worker'] != null ? Worker.fromJson(json['worker']) : null,
    );
  }
}

class Worker {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  Worker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
