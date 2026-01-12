import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  final String id;
  final String name;
  final String slug;
  final String plan;
  final String status;
  final Map<String, dynamic>? branding;
  final Map<String, dynamic>? settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Optional count fields when fetched with stats
  @JsonKey(name: '_count')
  final OrganizationCount? count;

  Organization({
    required this.id,
    required this.name,
    required this.slug,
    required this.plan,
    required this.status,
    this.branding,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
    this.count,
  });

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  String get planDisplayName {
    switch (plan) {
      case 'free':
        return 'Free';
      case 'basic':
        return 'Basic';
      case 'professional':
        return 'Professional';
      case 'enterprise':
        return 'Enterprise';
      default:
        return plan;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'active':
        return 'Active';
      case 'suspended':
        return 'Suspended';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

@JsonSerializable()
class OrganizationCount {
  final int users;
  final int children;
  final int families;
  final int cases;

  OrganizationCount({
    required this.users,
    required this.children,
    required this.families,
    required this.cases,
  });

  factory OrganizationCount.fromJson(Map<String, dynamic> json) =>
      _$OrganizationCountFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationCountToJson(this);
}

@JsonSerializable()
class OrganizationStats {
  final Organization organization;
  final OrganizationStatsData stats;

  OrganizationStats({
    required this.organization,
    required this.stats,
  });

  factory OrganizationStats.fromJson(Map<String, dynamic> json) =>
      _$OrganizationStatsFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationStatsToJson(this);
}

@JsonSerializable()
class OrganizationStatsData {
  final int users;
  final int children;
  final int families;
  final int cases;

  OrganizationStatsData({
    required this.users,
    required this.children,
    required this.families,
    required this.cases,
  });

  factory OrganizationStatsData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationStatsDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationStatsDataToJson(this);
}

@JsonSerializable()
class UpdateOrganizationDto {
  final String? name;
  final String? slug;
  final String? plan;
  final String? status;
  final Map<String, dynamic>? branding;
  final Map<String, dynamic>? settings;

  UpdateOrganizationDto({
    this.name,
    this.slug,
    this.plan,
    this.status,
    this.branding,
    this.settings,
  });

  factory UpdateOrganizationDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrganizationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrganizationDtoToJson(this);
}

