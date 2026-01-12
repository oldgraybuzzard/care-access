import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child.dart';
import 'api_client.dart';

final childrenApiProvider = Provider<ChildrenApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ChildrenApi(dio);
});

class ChildrenApi {
  final Dio _dio;

  ChildrenApi(this._dio);

  /// Get all children with optional filters
  Future<Map<String, dynamic>> getChildren({
    String? status,
    String? familyId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (status != null) queryParams['status'] = status;
    if (familyId != null) queryParams['familyId'] = familyId;
    if (search != null) queryParams['search'] = search;

    final response = await _dio.get(
      '/children',
      queryParameters: queryParams,
    );

    return {
      'data': (response.data['data'] as List)
          .map((json) => Child.fromJson(json))
          .toList(),
      'meta': response.data['meta'],
    };
  }

  /// Get a single child by ID with full profile
  Future<Child> getChild(String id) async {
    final response = await _dio.get('/children/$id');
    return Child.fromJson(response.data);
  }

  /// Create a new child profile
  Future<Child> createChild(Map<String, dynamic> data) async {
    final response = await _dio.post('/children', data: data);
    return Child.fromJson(response.data);
  }

  /// Update a child profile
  Future<Child> updateChild(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/children/$id', data: data);
    return Child.fromJson(response.data);
  }

  /// Delete a child (soft delete)
  Future<void> deleteChild(String id) async {
    await _dio.delete('/children/$id');
  }

  /// Get child's assessments
  Future<List<dynamic>> getChildAssessments(String childId) async {
    final response = await _dio.get('/children/$childId/assessments');
    return response.data['data'] as List;
  }

  /// Get child's education records
  Future<List<dynamic>> getChildEducationRecords(String childId) async {
    final response = await _dio.get('/children/$childId/education');
    return response.data['data'] as List;
  }

  /// Get child's medical records
  Future<List<dynamic>> getChildMedicalRecords(String childId) async {
    final response = await _dio.get('/children/$childId/medical');
    return response.data['data'] as List;
  }

  /// Get child's behavioral incidents
  Future<List<dynamic>> getChildIncidents(String childId) async {
    final response = await _dio.get('/children/$childId/incidents');
    return response.data['data'] as List;
  }

  /// Get child's goals
  Future<List<dynamic>> getChildGoals(String childId) async {
    final response = await _dio.get('/children/$childId/goals');
    return response.data['data'] as List;
  }

  /// Get child's notes
  Future<List<dynamic>> getChildNotes(String childId) async {
    final response = await _dio.get('/children/$childId/notes');
    return response.data['data'] as List;
  }
}
