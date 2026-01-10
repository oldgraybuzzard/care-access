import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../models/kpi_data.dart';
import '../models/trend_data.dart';
import '../services/dashboard_service.dart';

/// Provider for the dashboard service
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardService(dio);
});

/// State for dashboard filters
class DashboardFilters {
  final DateTime? fromDate;
  final DateTime? toDate;

  const DashboardFilters({
    this.fromDate,
    this.toDate,
  });

  DashboardFilters copyWith({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return DashboardFilters(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

/// Provider for dashboard filters
final dashboardFiltersProvider =
    StateProvider<DashboardFilters>((ref) => const DashboardFilters());

/// Provider for fetching KPI data with filters
final kpiDataProvider = FutureProvider<KpiData>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  return service.getKpis(
    from: filters.fromDate,
    to: filters.toDate,
  );
});

/// Provider for fetching trend data (intakes)
final intakesTrendProvider = FutureProvider<List<TrendDataPoint>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  return service.getTrends(
    metric: 'intakes',
    interval: 'day',
    from: filters.fromDate,
    to: filters.toDate,
  );
});

/// Provider for fetching trend data (closures)
final closuresTrendProvider = FutureProvider<List<TrendDataPoint>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  return service.getTrends(
    metric: 'closures',
    interval: 'day',
    from: filters.fromDate,
    to: filters.toDate,
  );
});

/// Provider for fetching cases by program
final casesByProgramProvider =
    FutureProvider<List<CasesByProgram>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return service.getCasesByProgram();
});
