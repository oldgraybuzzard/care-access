// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrgUser _$OrgUserFromJson(Map<String, dynamic> json) => OrgUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => UserRoleInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrgUserToJson(OrgUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'roles': instance.roles,
    };

UserRoleInfo _$UserRoleInfoFromJson(Map<String, dynamic> json) =>
    UserRoleInfo(
      role: RoleInfo.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRoleInfoToJson(UserRoleInfo instance) =>
    <String, dynamic>{
      'role': instance.role,
    };

RoleInfo _$RoleInfoFromJson(Map<String, dynamic> json) => RoleInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RoleInfoToJson(RoleInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

UpdateUserDto _$UpdateUserDtoFromJson(Map<String, dynamic> json) =>
    UpdateUserDto(
      name: json['name'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateUserDtoToJson(UpdateUserDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'isActive': instance.isActive,
    };

