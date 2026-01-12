import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/report.dart';
import '../../../core/api/reports_api.dart';

class ReportResultsScreen extends ConsumerWidget {
  final String title;
  final ReportResult result;

  const ReportResultsScreen({
    super.key,
    required this.title,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showExportOptions(context, ref),
            tooltip: 'Export',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Total Rows', result.rowCount.toString()),
                  _buildStat('Columns', _getColumnCount().toString()),
                ],
              ),
            ),
          ),

          // Results Table
          Expanded(
            child: result.data.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No data found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: _buildDataTable(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  int _getColumnCount() {
    if (result.data.isEmpty) return 0;
    return result.data.first.keys.length;
  }

  Widget _buildDataTable() {
    if (result.data.isEmpty) return const SizedBox.shrink();

    final columns = result.data.first.keys.toList();

    return DataTable(
      columns: columns
          .map((col) => DataColumn(
                label: Text(
                  col.toString().toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
      rows: result.data
          .map((row) => DataRow(
                cells: columns
                    .map((col) => DataCell(
                          Text(row[col]?.toString() ?? 'N/A'),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }

  void _showExportOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export to CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportReport(context, ref, 'csv');
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Export to Excel'),
              onTap: () {
                Navigator.pop(context);
                _exportReport(context, ref, 'xlsx');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport(
      BuildContext context, WidgetRef ref, String format) async {
    try {
      final api = ref.read(reportsApiProvider);
      final response = await api.exportReport(
        runId: result.reportRunId,
        format: format,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report exported as $format'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}
