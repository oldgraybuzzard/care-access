import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/search_api.dart';
import '../../../core/models/search_result.dart';

/// Search filters state
class SearchFilters {
  final String query;
  final String? program;
  final String? status;
  final String? worker;
  final int page;

  const SearchFilters({
    this.query = '',
    this.program,
    this.status,
    this.worker,
    this.page = 1,
  });

  SearchFilters copyWith({
    String? query,
    String? program,
    String? status,
    String? worker,
    int? page,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      program: program ?? this.program,
      status: status ?? this.status,
      worker: worker ?? this.worker,
      page: page ?? this.page,
    );
  }

  bool get hasFilters =>
      query.isNotEmpty ||
      program != null ||
      status != null ||
      worker != null;
}

/// Search filters provider
final searchFiltersProvider =
    StateProvider<SearchFilters>((ref) => const SearchFilters());

/// Search results provider
final searchResultsProvider =
    FutureProvider.autoDispose<SearchResponse?>((ref) async {
  final filters = ref.watch(searchFiltersProvider);
  
  // Don't search if no query or filters
  if (!filters.hasFilters) {
    return null;
  }

  final api = ref.watch(searchApiProvider);
  
  return await api.search(
    query: filters.query.isNotEmpty ? filters.query : null,
    program: filters.program,
    status: filters.status,
    worker: filters.worker,
    page: filters.page,
  );
});

