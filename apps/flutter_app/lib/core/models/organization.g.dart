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
      logoUrl: json['logoUrl'] as String?,
      primaryColor: json['primaryColor'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      description: json['description'] as String?,
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
      'logoUrl': instance.logoUrl,
      'primaryColor': instance.primaryColor,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'description': instance.description,
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
      stats:
          OrganizationStatsData.fromJson(json['stats'] as Map<String, dynamic>),
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
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      description: json['description'] as String?,
      primaryColor: json['primaryColor'] as String?,
    );

Map<String, dynamic> _$UpdateOrganizationDtoToJson(
        UpdateOrganizationDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'description': instance.description,
      'primaryColor': instance.primaryColor,
    };
