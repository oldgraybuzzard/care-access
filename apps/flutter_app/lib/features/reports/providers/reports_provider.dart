import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/reports_api.dart';
import '../../../core/models/report.dart';

/// Provider for report definitions
final reportDefinitionsProvider =
    FutureProvider<List<ReportDefinition>>((ref) async {
  final api = ref.watch(reportsApiProvider);
  return api.getDefinitions();
});

/// Provider for running a standard report
final runStandardReportProvider = FutureProvider.family<ReportResult,
    ({String reportDefinitionId, Map<String, dynamic>? filters})>(
  (ref, params) async {
    final api = ref.watch(reportsApiProvider);
    return api.runStandardReport(
      reportDefinitionId: params.reportDefinitionId,
      filters: params.filters,
    );
  },
);

/// Provider for running a custom report
final runCustomReportProvider = FutureProvider.family<ReportResult,
    ({
      String dataset,
      Map<String, dynamic>? filters,
      List<String>? groupBy
    })>(
  (ref, params) async {
    final api = ref.watch(reportsApiProvider);
    return api.runCustomReport(
      dataset: params.dataset,
      filters: params.filters,
      groupBy: params.groupBy,
    );
  },
);

/// State provider for custom report builder
class CustomReportState {
  final String? dataset;
  final Map<String, dynamic> filters;
  final List<String> groupBy;

  CustomReportState({
    this.dataset,
    this.filters = const {},
    this.groupBy = const [],
  });

  CustomReportState copyWith({
    String? dataset,
    Map<String, dynamic>? filters,
    List<String>? groupBy,
  }) {
    return CustomReportState(
      dataset: dataset ?? this.dataset,
      filters: filters ?? this.filters,
      groupBy: groupBy ?? this.groupBy,
    );
  }
}

class CustomReportNotifier extends StateNotifier<CustomReportState> {
  CustomReportNotifier() : super(CustomReportState());

  void setDataset(String dataset) {
    state = state.copyWith(dataset: dataset);
  }

  void updateFilter(String key, dynamic value) {
    final newFilters = Map<String, dynamic>.from(state.filters);
    if (value == null) {
      newFilters.remove(key);
    } else {
      newFilters[key] = value;
    }
    state = state.copyWith(filters: newFilters);
  }

  void clearFilters() {
    state = state.copyWith(filters: {});
  }

  void setGroupBy(List<String> groupBy) {
    state = state.copyWith(groupBy: groupBy);
  }

  void reset() {
    state = CustomReportState();
  }
}

final customReportProvider =
    StateNotifierProvider<CustomReportNotifier, CustomReportState>((ref) {
  return CustomReportNotifier();
});

