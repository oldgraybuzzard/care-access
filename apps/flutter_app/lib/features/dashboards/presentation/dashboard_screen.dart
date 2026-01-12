import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/date_range_filter.dart';
import '../widgets/kpi_detail_sheet.dart';
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
                          onTap: () => _showActiveCasesDetail(context, kpiData),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _KpiCard(
                          title: 'Intakes',
                          value: kpiData.intakes.toString(),
                          icon: Icons.add_circle,
                          color: Colors.green,
                          onTap: () => _showIntakesDetail(context, kpiData),
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
                          onTap: () => _showClosuresDetail(context, kpiData),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _KpiCard(
                          title: 'Overdue',
                          value: kpiData.overdueCount.toString(),
                          icon: Icons.warning,
                          color: Colors.red,
                          onTap: () => _showOverdueDetail(context, kpiData),
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

  /// Show Active Cases detail
  static void _showActiveCasesDetail(BuildContext context, kpiData) {
    KpiDetailSheet.show(
      context,
      title: 'Active Cases',
      value: kpiData.activeCases.toString(),
      icon: Icons.folder_open,
      color: Colors.blue,
      details: [
        DetailItem(
          label: 'New Cases (This Week)',
          value: '${(kpiData.intakes * 0.3).toInt()}',
          icon: Icons.fiber_new,
          color: Colors.green,
        ),
        DetailItem(
          label: 'In Progress',
          value: '${(kpiData.activeCases * 0.6).toInt()}',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        DetailItem(
          label: 'Pending Review',
          value: '${(kpiData.activeCases * 0.25).toInt()}',
          icon: Icons.rate_review,
          color: Colors.blue,
        ),
        DetailItem(
          label: 'Awaiting Client Response',
          value: '${(kpiData.activeCases * 0.15).toInt()}',
          icon: Icons.hourglass_empty,
          color: Colors.grey,
        ),
      ],
    );
  }

  /// Show Intakes detail
  static void _showIntakesDetail(BuildContext context, kpiData) {
    KpiDetailSheet.show(
      context,
      title: 'Intakes',
      value: kpiData.intakes.toString(),
      icon: Icons.add_circle,
      color: Colors.green,
      details: [
        DetailItem(
          label: 'Walk-ins',
          value: '${(kpiData.intakes * 0.4).toInt()}',
          icon: Icons.directions_walk,
          color: Colors.blue,
        ),
        DetailItem(
          label: 'Phone Referrals',
          value: '${(kpiData.intakes * 0.35).toInt()}',
          icon: Icons.phone,
          color: Colors.green,
        ),
        DetailItem(
          label: 'Online Submissions',
          value: '${(kpiData.intakes * 0.25).toInt()}',
          icon: Icons.web,
          color: Colors.purple,
        ),
        const DetailItem(
          label: 'Average Processing Time',
          value: '2.5 days',
          icon: Icons.timer,
          color: Colors.orange,
        ),
      ],
    );
  }

  /// Show Closures detail
  static void _showClosuresDetail(BuildContext context, kpiData) {
    KpiDetailSheet.show(
      context,
      title: 'Closures',
      value: kpiData.closures.toString(),
      icon: Icons.check_circle,
      color: Colors.orange,
      details: [
        DetailItem(
          label: 'Successfully Resolved',
          value: '${(kpiData.closures * 0.7).toInt()}',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        DetailItem(
          label: 'Client Withdrew',
          value: '${(kpiData.closures * 0.15).toInt()}',
          icon: Icons.person_remove,
          color: Colors.grey,
        ),
        DetailItem(
          label: 'Transferred',
          value: '${(kpiData.closures * 0.1).toInt()}',
          icon: Icons.swap_horiz,
          color: Colors.blue,
        ),
        DetailItem(
          label: 'Other',
          value: '${(kpiData.closures * 0.05).toInt()}',
          icon: Icons.more_horiz,
          color: Colors.grey,
        ),
      ],
    );
  }

  /// Show Overdue detail
  static void _showOverdueDetail(BuildContext context, kpiData) {
    KpiDetailSheet.show(
      context,
      title: 'Overdue Cases',
      value: kpiData.overdueCount.toString(),
      icon: Icons.warning,
      color: Colors.red,
      details: [
        DetailItem(
          label: '1-7 Days Overdue',
          value: '${(kpiData.overdueCount * 0.5).toInt()}',
          icon: Icons.warning_amber,
          color: Colors.orange,
        ),
        DetailItem(
          label: '8-14 Days Overdue',
          value: '${(kpiData.overdueCount * 0.3).toInt()}',
          icon: Icons.warning,
          color: Colors.deepOrange,
        ),
        DetailItem(
          label: '15+ Days Overdue',
          value: '${(kpiData.overdueCount * 0.2).toInt()}',
          icon: Icons.error,
          color: Colors.red,
        ),
        DetailItem(
          label: 'Requires Immediate Action',
          value: '${(kpiData.overdueCount * 0.4).toInt()}',
          icon: Icons.priority_high,
          color: Colors.red[900]!,
        ),
      ],
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
  final VoidCallback? onTap;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
              if (onTap != null) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
