import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/organization.dart';
import '../models/org_user.dart';
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
    UpdateOrganizationDto updateDto,
  ) async {
    final response = await _dio.patch(
      '/organizations/me',
      data: updateDto.toJson(),
    );
    return Organization.fromJson(response.data);
  }

  /// Get all users in current organization (admin only)
  Future<List<OrgUser>> getMyOrganizationUsers() async {
    final response = await _dio.get('/organizations/me/users');
    return (response.data as List)
        .map((json) => OrgUser.fromJson(json))
        .toList();
  }

  /// Update a user in current organization (admin only)
  Future<OrgUser> updateOrganizationUser(
    String userId,
    UpdateUserDto updateDto,
  ) async {
    final response = await _dio.patch(
      '/organizations/me/users/$userId',
      data: updateDto.toJson(),
    );
    return OrgUser.fromJson(response.data);
  }

  /// Assign role to user (admin only)
  Future<OrgUser> assignRoleToUser(String userId, String roleId) async {
    final response = await _dio.post(
      '/organizations/me/users/$userId/roles',
      data: {'roleId': roleId},
    );
    return OrgUser.fromJson(response.data);
  }

  /// Remove role from user (admin only)
  Future<OrgUser> removeRoleFromUser(String userId, String roleId) async {
    final response = await _dio.delete(
      '/organizations/me/users/$userId/roles/$roleId',
    );
    return OrgUser.fromJson(response.data);
  }

  /// Get all available roles
  Future<List<RoleInfo>> getAllRoles() async {
    final response = await _dio.get('/organizations/roles');
    return (response.data as List)
        .map((json) => RoleInfo.fromJson(json))
        .toList();
  }
}

final organizationApiProvider = Provider<OrganizationApi>((ref) {
  final dio = ref.watch(dioProvider);
  return OrganizationApi(dio);
});
