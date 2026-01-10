import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/date_range_filter.dart';
import '../widgets/trend_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiDataAsync = ref.watch(kpiDataProvider);
    final intakesTrendAsync = ref.watch(intakesTrendProvider);
    final closuresTrendAsync = ref.watch(closuresTrendProvider);
    final filters = ref.watch(dashboardFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(kpiDataProvider);
              ref.invalidate(intakesTrendProvider);
              ref.invalidate(closuresTrendProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Range Filter
            DateRangeFilter(
              fromDate: filters.fromDate,
              toDate: filters.toDate,
              onDateRangeChanged: (from, to) {
                ref.read(dashboardFiltersProvider.notifier).state =
                    DashboardFilters(fromDate: from, toDate: to);
              },
            ),
            const SizedBox(height: 16),

            // KPI Cards
            kpiDataAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => _ErrorCard(
                error: error.toString(),
                onRetry: () => ref.invalidate(kpiDataProvider),
              ),
              data: (kpiData) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _KpiCard(
                          title: 'Active Cases',
                          value: kpiData.activeCases.toString(),
                          icon: Icons.folder_open,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _KpiCard(
                          title: 'Intakes',
                          value: kpiData.intakes.toString(),
                          icon: Icons.add_circle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _KpiCard(
                          title: 'Closures',
                          value: kpiData.closures.toString(),
                          icon: Icons.check_circle,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _KpiCard(
                          title: 'Overdue',
                          value: kpiData.overdueCount.toString(),
                          icon: Icons.warning,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Trend Charts
            intakesTrendAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (trendData) => TrendChart(
                data: trendData,
                title: 'Intakes Trend',
                lineColor: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            closuresTrendAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (trendData) => TrendChart(
                data: trendData,
                title: 'Closures Trend',
                lineColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorCard({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
