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
}
