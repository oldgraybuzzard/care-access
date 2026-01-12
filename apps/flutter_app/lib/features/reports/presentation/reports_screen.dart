import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../providers/reports_provider.dart';
import 'custom_report_builder_screen.dart';
import 'report_results_screen.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionsAsync = ref.watch(reportDefinitionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: const AppDrawer(),
      body: definitionsAsync.when(
        data: (definitions) => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Custom Report Builder - Always first
            _ReportCard(
              title: 'Custom Report Builder',
              description: 'Build your own custom reports with filters',
              icon: Icons.build,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomReportBuilderScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Standard Reports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Standard Reports from API
            ...definitions.map((def) => _ReportCard(
                  title: def.name,
                  description: def.description ?? 'Run ${def.name}',
                  icon: _getIconForReport(def.name),
                  onTap: () => _runStandardReport(context, ref, def),
                )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading reports: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(reportDefinitionsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForReport(String name) {
    if (name.contains('Caseload')) return Icons.people;
    if (name.contains('Cases')) return Icons.folder;
    if (name.contains('Trend')) return Icons.trending_up;
    if (name.contains('Compliance')) return Icons.warning;
    if (name.contains('Services')) return Icons.medical_services;
    return Icons.assessment;
  }

  Future<void> _runStandardReport(
    BuildContext context,
    WidgetRef ref,
    dynamic def,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Running report...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await ref.read(
        runStandardReportProvider((
          reportDefinitionId: def.id,
          filters: null,
        )).future,
      );

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportResultsScreen(
              title: def.name,
              result: result,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error running report: $e')),
        );
      }
    }
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: color?.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
