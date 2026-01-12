// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      plan: json['plan'] as String,
      status: json['status'] as String,
      branding: json['branding'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      count: json['_count'] == null
          ? null
          : OrganizationCount.fromJson(json['_count'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'plan': instance.plan,
      'status': instance.status,
      'branding': instance.branding,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '_count': instance.count,
    };

OrganizationCount _$OrganizationCountFromJson(Map<String, dynamic> json) =>
    OrganizationCount(
      users: json['users'] as int,
      children: json['children'] as int,
      families: json['families'] as int,
      cases: json['cases'] as int,
    );

Map<String, dynamic> _$OrganizationCountToJson(OrganizationCount instance) =>
    <String, dynamic>{
      'users': instance.users,
      'children': instance.children,
      'families': instance.families,
      'cases': instance.cases,
    };

OrganizationStats _$OrganizationStatsFromJson(Map<String, dynamic> json) =>
    OrganizationStats(
      organization:
          Organization.fromJson(json['organization'] as Map<String, dynamic>),
      stats: OrganizationStatsData.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrganizationStatsToJson(OrganizationStats instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'stats': instance.stats,
    };

OrganizationStatsData _$OrganizationStatsDataFromJson(
        Map<String, dynamic> json) =>
    OrganizationStatsData(
      users: json['users'] as int,
      children: json['children'] as int,
      families: json['families'] as int,
      cases: json['cases'] as int,
    );

Map<String, dynamic> _$OrganizationStatsDataToJson(
        OrganizationStatsData instance) =>
    <String, dynamic>{
      'users': instance.users,
      'children': instance.children,
      'families': instance.families,
      'cases': instance.cases,
    };

UpdateOrganizationDto _$UpdateOrganizationDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateOrganizationDto(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      plan: json['plan'] as String?,
      status: json['status'] as String?,
      branding: json['branding'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UpdateOrganizationDtoToJson(
        UpdateOrganizationDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'plan': instance.plan,
      'status': instance.status,
      'branding': instance.branding,
      'settings': instance.settings,
    };

