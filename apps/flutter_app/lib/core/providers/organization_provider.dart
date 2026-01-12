import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/organization.dart';
import '../api/organization_api.dart';

/// Provider for fetching all organizations (super admin only)
final allOrganizationsProvider =
    FutureProvider<List<Organization>>((ref) async {
  final organizationApi = ref.watch(organizationApiProvider);
  return organizationApi.getAllOrganizations();
});

/// Provider for fetching current user's organization
final myOrganizationProvider = FutureProvider<Organization>((ref) async {
  final organizationApi = ref.watch(organizationApiProvider);
  return organizationApi.getMyOrganization();
});

/// Provider for fetching current user's organization stats
final myOrganizationStatsProvider =
    FutureProvider<OrganizationStats>((ref) async {
  final organizationApi = ref.watch(organizationApiProvider);
  return organizationApi.getMyOrganizationStats();
});

