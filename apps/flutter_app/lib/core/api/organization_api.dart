import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/organization.dart';
import 'api_client.dart';

class OrganizationApi {
  final Dio _dio;

  OrganizationApi(this._dio);

  /// Get current user's organization
  Future<Organization> getMyOrganization() async {
    final response = await _dio.get('/organizations/me');
    return Organization.fromJson(response.data);
  }

  /// Get current user's organization statistics
  Future<OrganizationStats> getMyOrganizationStats() async {
    final response = await _dio.get('/organizations/me/stats');
    return OrganizationStats.fromJson(response.data);
  }

  /// Update current user's organization (admin only)
  Future<Organization> updateMyOrganization(
      UpdateOrganizationDto updateDto) async {
    final response = await _dio.patch(
      '/organizations/me',
      data: updateDto.toJson(),
    );
    return Organization.fromJson(response.data);
  }
}

final organizationApiProvider = Provider<OrganizationApi>((ref) {
  final dio = ref.watch(dioProvider);
  return OrganizationApi(dio);
});

