import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_result.dart';
import 'api_client.dart';

final searchApiProvider = Provider<SearchApi>((ref) {
  final dio = ref.watch(dioProvider);
  return SearchApi(dio);
});

class SearchApi {
  final Dio _dio;

  SearchApi(this._dio);

  /// Search for clients and cases
  Future<SearchResponse> search({
    String? query,
    String? program,
    String? status,
    String? worker,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
    }
    if (program != null && program.isNotEmpty) {
      queryParams['program'] = program;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (worker != null && worker.isNotEmpty) {
      queryParams['worker'] = worker;
    }

    final response = await _dio.get(
      '/search',
      queryParameters: queryParams,
    );

    return SearchResponse.fromJson(response.data);
  }
}
