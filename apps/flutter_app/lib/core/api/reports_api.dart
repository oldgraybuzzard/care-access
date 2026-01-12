import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report.dart';
import 'api_client.dart';

final reportsApiProvider = Provider<ReportsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ReportsApi(dio);
});

class ReportsApi {
  final Dio _dio;

  ReportsApi(this._dio);

  /// Get all available report definitions
  Future<List<ReportDefinition>> getDefinitions() async {
    final response = await _dio.get('/reports/definitions');
    return (response.data as List)
        .map((json) => ReportDefinition.fromJson(json))
        .toList();
  }

  /// Run a standard report
  Future<ReportResult> runStandardReport({
    required String reportDefinitionId,
    Map<String, dynamic>? filters,
  }) async {
    final response = await _dio.post(
      '/reports/run',
      data: {
        'reportDefinitionId': reportDefinitionId,
        if (filters != null) 'filters': filters,
      },
    );
    return ReportResult.fromJson(response.data);
  }

  /// Run a custom ad-hoc report
  Future<ReportResult> runCustomReport({
    required String dataset,
    Map<String, dynamic>? filters,
    List<String>? groupBy,
  }) async {
    final response = await _dio.post(
      '/reports/custom/run',
      data: {
        'dataset': dataset,
        if (filters != null) 'filters': filters,
        if (groupBy != null) 'groupBy': groupBy,
      },
    );
    return ReportResult.fromJson(response.data);
  }

  /// Get report run results
  Future<Map<String, dynamic>> getReportRunResults({
    required String runId,
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _dio.get(
      '/reports/runs/$runId/results',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return response.data;
  }

  /// Export report to CSV or XLSX
  Future<Response> exportReport({
    required String runId,
    String format = 'csv',
  }) async {
    final response = await _dio.get(
      '/reports/runs/$runId/export',
      queryParameters: {'format': format},
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    return response;
  }
}

