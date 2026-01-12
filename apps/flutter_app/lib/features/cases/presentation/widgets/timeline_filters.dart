import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineFilters extends StatefulWidget {
  final Function(String?) onTypeFilterChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final Function(String) onSearchChanged;
  final List<String> availableTypes;

  const TimelineFilters({
    super.key,
    required this.onTypeFilterChanged,
    required this.onDateRangeChanged,
    required this.onSearchChanged,
    required this.availableTypes,
  });

  @override
  State<TimelineFilters> createState() => _TimelineFiltersState();
}

class _TimelineFiltersState extends State<TimelineFilters> {
  String? _selectedType;
  DateTimeRange? _dateRange;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: widget.onSearchChanged,
            ),
            const SizedBox(height: 16),

            // Type Filter and Date Range in a Row
            Row(
              children: [
                // Type Filter
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Types'),
                      ),
                      ...widget.availableTypes.map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                      widget.onTypeFilterChanged(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Date Range Picker
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDateRange,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _dateRange == null
                          ? 'Date Range'
                          : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Clear Filters Button
            if (_selectedType != null || _dateRange != null || _searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Filters'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      widget.onDateRangeChanged(picked);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _dateRange = null;
      _searchController.clear();
    });
    widget.onTypeFilterChanged(null);
    widget.onDateRangeChanged(null);
    widget.onSearchChanged('');
  }
}

