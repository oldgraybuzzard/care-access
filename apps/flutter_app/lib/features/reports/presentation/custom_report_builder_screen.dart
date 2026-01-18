import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reports_provider.dart';
import 'report_results_screen.dart';

class CustomReportBuilderScreen extends ConsumerStatefulWidget {
  const CustomReportBuilderScreen({super.key});

  @override
  ConsumerState<CustomReportBuilderScreen> createState() =>
      _CustomReportBuilderScreenState();
}

class _CustomReportBuilderScreenState
    extends ConsumerState<CustomReportBuilderScreen> {
  bool _isRunning = false;

  final List<Map<String, String>> _datasets = [
    {'value': 'clients', 'label': 'Clients', 'icon': '👤'},
    {'value': 'cases', 'label': 'Cases', 'icon': '📁'},
    {'value': 'activities', 'label': 'Activities', 'icon': '📝'},
    {'value': 'services', 'label': 'Services', 'icon': '🔧'},
    {'value': 'children', 'label': 'Children', 'icon': '👶'},
    {'value': 'education', 'label': 'Education', 'icon': '📚'},
    {
      'value': 'behavioral_incidents',
      'label': 'Behavioral Incidents',
      'icon': '⚠️'
    },
    {'value': 'goals', 'label': 'Goals & Progress', 'icon': '🎯'},
    {'value': 'assessments', 'label': 'Assessments', 'icon': '📋'},
    {'value': 'medical_records', 'label': 'Medical Records', 'icon': '🏥'},
    {'value': 'home_visits', 'label': 'Home Visits', 'icon': '🏠'},
    {'value': 'families', 'label': 'Families', 'icon': '👨‍👩‍👧‍👦'},
  ];

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _runReport() async {
    final state = ref.read(customReportProvider);

    if (state.dataset == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a dataset')),
      );
      return;
    }

    setState(() => _isRunning = true);

    try {
      final result = await ref.read(
        runCustomReportProvider(
          (
            dataset: state.dataset!,
            filters: state.filters,
            groupBy: state.groupBy,
          ),
        ).future,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportResultsScreen(
              title: '${state.dataset} Report',
              result: result,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error running report: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRunning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Report Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(customReportProvider.notifier).reset(),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dataset Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Select Data Source',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _datasets.map((dataset) {
                      final isSelected = state.dataset == dataset['value'];
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(dataset['icon']!),
                            const SizedBox(width: 8),
                            Text(dataset['label']!),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            ref
                                .read(customReportProvider.notifier)
                                .setDataset(dataset['value']!);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filters
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2. Add Filters (Optional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (state.filters.isNotEmpty)
                        TextButton(
                          onPressed: () => ref
                              .read(customReportProvider.notifier)
                              .clearFilters(),
                          child: const Text('Clear All'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFiltersSection(state),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _isRunning ? null : _runReport,
            icon: _isRunning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_isRunning ? 'Running Report...' : 'Run Report'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection(CustomReportState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Status Filter
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.filter_list),
          ),
          initialValue: state.filters['status'] as String?,
          items: const [
            DropdownMenuItem(value: null, child: Text('All Statuses')),
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
            DropdownMenuItem(value: 'closed', child: Text('Closed')),
          ],
          onChanged: (value) {
            ref
                .read(customReportProvider.notifier)
                .updateFilter('status', value);
          },
        ),
        const SizedBox(height: 12),

        // Date Range
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                    ref.read(customReportProvider.notifier).updateFilter(
                          'startDate',
                          date.toIso8601String(),
                        );
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _startDate != null
                      ? 'From: ${_startDate!.toString().split(' ')[0]}'
                      : 'Start Date',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _endDate = date);
                    ref.read(customReportProvider.notifier).updateFilter(
                          'endDate',
                          date.toIso8601String(),
                        );
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _endDate != null
                      ? 'To: ${_endDate!.toString().split(' ')[0]}'
                      : 'End Date',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Active Filters Summary
        if (state.filters.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.filters.entries.map((entry) {
              return Chip(
                label: Text('${entry.key}: ${entry.value}'),
                onDeleted: () {
                  ref
                      .read(customReportProvider.notifier)
                      .updateFilter(entry.key, null);
                  if (entry.key == 'startDate') {
                    setState(() => _startDate = null);
                  } else if (entry.key == 'endDate') {
                    setState(() => _endDate = null);
                  }
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
