import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../models/kpi_data.dart';
import '../services/dashboard_service.dart';

/// Provider for the dashboard service
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardService(dio);
});

/// Provider for fetching KPI data
/// This is an AsyncNotifier that automatically handles loading, data, and error states
final kpiDataProvider = FutureProvider<KpiData>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return service.getKpis();
});

/// Provider for refreshing KPI data
/// Call ref.refresh(kpiDataProvider) to refresh the data
final refreshKpiProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(kpiDataProvider);
  };
});

