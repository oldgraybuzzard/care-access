import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_drawer.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ReportCard(
            title: 'Caseload by Worker',
            description: 'View active caseload grouped by worker',
            icon: Icons.people,
            onTap: () {
              // TODO: Navigate to report
            },
          ),
          _ReportCard(
            title: 'Active Cases by Program/Status',
            description: 'View cases grouped by program and status',
            icon: Icons.folder,
            onTap: () {
              // TODO: Navigate to report
            },
          ),
          _ReportCard(
            title: 'Intakes vs Closures Trend',
            description: 'Monthly trend of intakes vs closures',
            icon: Icons.trending_up,
            onTap: () {
              // TODO: Navigate to report
            },
          ),
          _ReportCard(
            title: 'Custom Report Builder',
            description: 'Build your own custom reports',
            icon: Icons.build,
            onTap: () {
              // TODO: Navigate to custom report builder
            },
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

