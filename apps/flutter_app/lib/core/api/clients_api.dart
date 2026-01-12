import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/client.dart';
import 'api_client.dart';

final clientsApiProvider = Provider<ClientsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ClientsApi(dio);
});

class ClientsApi {
  final Dio _dio;

  ClientsApi(this._dio);

  /// Get a single client by ID with full details
  Future<ClientDetail> getClient(String id) async {
    final response = await _dio.get('/clients/$id');
    return ClientDetail.fromJson(response.data);
  }

  /// Get all cases for a client
  Future<Map<String, dynamic>> getClientCases(
    String clientId, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (status != null) queryParams['status'] = status;

    final response = await _dio.get(
      '/clients/$clientId/cases',
      queryParameters: queryParams,
    );

    return response.data;
  }
}

