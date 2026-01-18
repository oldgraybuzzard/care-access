class User {
  final String id;
  final String email;
  final String name;
  final List<String> roles;
  final String organizationId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
    required this.organizationId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      roles: List<String>.from(json['roles'] ?? []),
      organizationId: json['organizationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'roles': roles,
      'organizationId': organizationId,
    };
  }

  /// Check if user is a SuperAdmin (platform administrator)
  /// SuperAdmins have 'superadmin' role and NO organizationId
  bool get isSuperAdmin =>
      roles.contains('superadmin') && organizationId.isEmpty;

  /// Check if user is an organization admin
  bool get isOrgAdmin => roles.contains('admin') && organizationId.isNotEmpty;

  /// Check if user belongs to an organization
  bool get hasOrganization => organizationId.isNotEmpty;
}
