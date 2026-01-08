class User {
  final String id;
  final String email;
  final String name;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'roles': roles,
    };
  }
}

