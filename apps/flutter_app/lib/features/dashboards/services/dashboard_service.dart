import 'package:dio/dio.dart';
import '../models/kpi_data.dart';

/// Service for fetching dashboard data from the API
class DashboardService {
  final Dio _dio;

  DashboardService(this._dio);

  /// Fetch KPI data from the API
  Future<KpiData> getKpis({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) {
        queryParams['from'] = from.toIso8601String();
      }
      if (to != null) {
        queryParams['to'] = to.toIso8601String();
      }

      final response = await _dio.get(
        '/dashboards/kpis',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return KpiData.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data?['message'] ?? 'Unknown error';

      switch (statusCode) {
        case 401:
          return Exception('Unauthorized. Please log in again.');
        case 403:
          return Exception('Access denied.');
        case 404:
          return Exception('Resource not found.');
        case 500:
          return Exception('Server error. Please try again later.');
        default:
          return Exception('Error: $message');
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please check your internet connection.');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Connection error. Please check your internet connection.');
    } else {
      return Exception('An unexpected error occurred: ${error.message}');
    }
  }
}

