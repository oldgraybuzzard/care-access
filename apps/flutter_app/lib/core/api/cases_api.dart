import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/case.dart';
import 'api_client.dart';

final casesApiProvider = Provider<CasesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CasesApi(dio);
});

class CasesApi {
  final Dio _dio;

  CasesApi(this._dio);

  /// Get a single case by ID with full details
  Future<CaseDetail> getCase(String id) async {
    final response = await _dio.get('/cases/$id');
    return CaseDetail.fromJson(response.data);
  }

  /// Get all activities for a case
  Future<Map<String, dynamic>> getCaseActivities(
    String caseId, {
    String? type,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (type != null) queryParams['type'] = type;

    final response = await _dio.get(
      '/cases/$caseId/activities',
      queryParameters: queryParams,
    );

    return {
      'data': (response.data['data'] as List)
          .map((json) => Activity.fromJson(json))
          .toList(),
      'meta': response.data['meta'],
    };
  }

  /// Get all services for a case
  Future<Map<String, dynamic>> getCaseServices(
    String caseId, {
    String? type,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (type != null) queryParams['type'] = type;

    final response = await _dio.get(
      '/cases/$caseId/services',
      queryParameters: queryParams,
    );

    return {
      'data': (response.data['data'] as List)
          .map((json) => Service.fromJson(json))
          .toList(),
      'meta': response.data['meta'],
    };
  }

  /// Get all documents for a case
  Future<Map<String, dynamic>> getCaseDocuments(
    String caseId, {
    String? type,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (type != null) queryParams['type'] = type;

    final response = await _dio.get(
      '/cases/$caseId/documents',
      queryParameters: queryParams,
    );

    return {
      'data': (response.data['data'] as List)
          .map((json) => Document.fromJson(json))
          .toList(),
      'meta': response.data['meta'],
    };
  }

  /// Upload a document for a case
  Future<Document> uploadDocument(
    String caseId,
    File file,
    String title,
    String docType,
  ) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'title': title,
      'docType': docType,
    });

    final response = await _dio.post(
      '/cases/$caseId/documents',
      data: formData,
    );

    return Document.fromJson(response.data);
  }

  /// Create a new activity for a case
  Future<Activity> createActivity(
    String caseId, {
    required String activityType,
    required DateTime occurredAt,
    String? summary,
    Map<String, dynamic>? metaJson,
  }) async {
    final response = await _dio.post(
      '/cases/$caseId/activities',
      data: {
        'activityType': activityType,
        'occurredAt': occurredAt.toIso8601String(),
        if (summary != null) 'summary': summary,
        if (metaJson != null) 'metaJson': metaJson,
      },
    );

    return Activity.fromJson(response.data);
  }

  /// Update a case
  Future<CaseDetail> updateCase(
    String caseId, {
    String? status,
    DateTime? closedAt,
    String? assignedWorkerId,
    String? programId,
  }) async {
    final response = await _dio.patch(
      '/cases/$caseId',
      data: {
        if (status != null) 'status': status,
        if (closedAt != null) 'closedAt': closedAt.toIso8601String(),
        if (assignedWorkerId != null) 'assignedWorkerId': assignedWorkerId,
        if (programId != null) 'programId': programId,
      },
    );

    return CaseDetail.fromJson(response.data);
  }

  /// Get all notes for a case
  Future<Map<String, dynamic>> getCaseNotes(
    String caseId, {
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    final response = await _dio.get(
      '/cases/$caseId/notes',
      queryParameters: queryParams,
    );

    return {
      'data': (response.data['data'] as List)
          .map((json) => CaseNote.fromJson(json))
          .toList(),
      'meta': response.data['meta'],
    };
  }

  /// Create a note for a case
  Future<CaseNote> createNote(String caseId, String content) async {
    final response = await _dio.post(
      '/cases/$caseId/notes',
      data: {'content': content},
    );

    return CaseNote.fromJson(response.data);
  }
}
