import 'package:json_annotation/json_annotation.dart';

part 'org_user.g.dart';

@JsonSerializable()
class OrgUser {
  final String id;
  final String email;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserRoleInfo> roles;

  OrgUser({
    required this.id,
    required this.email,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
  });

  factory OrgUser.fromJson(Map<String, dynamic> json) =>
      _$OrgUserFromJson(json);

  Map<String, dynamic> toJson() => _$OrgUserToJson(this);

  List<String> get roleNames => roles.map((r) => r.role.name).toList();
  
  bool hasRole(String roleName) =>
      roles.any((r) => r.role.name == roleName);
}

@JsonSerializable()
class UserRoleInfo {
  final RoleInfo role;

  UserRoleInfo({required this.role});

  factory UserRoleInfo.fromJson(Map<String, dynamic> json) =>
      _$UserRoleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleInfoToJson(this);
}

@JsonSerializable()
class RoleInfo {
  final String id;
  final String name;
  final String? description;

  RoleInfo({
    required this.id,
    required this.name,
    this.description,
  });

  factory RoleInfo.fromJson(Map<String, dynamic> json) =>
      _$RoleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RoleInfoToJson(this);
}

@JsonSerializable()
class UpdateUserDto {
  final String? name;
  final String? email;
  final bool? isActive;

  UpdateUserDto({
    this.name,
    this.email,
    this.isActive,
  });

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);
}

