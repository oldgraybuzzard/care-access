import 'package:flutter/material.dart';

/// Widget for selecting a date range filter
class DateRangeFilter extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const DateRangeFilter({
    super.key,
    this.fromDate,
    this.toDate,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range Filter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    label: 'From',
                    date: fromDate,
                    onPressed: () => _selectFromDate(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DateButton(
                    label: 'To',
                    date: toDate,
                    onPressed: () => _selectToDate(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => onDateRangeChanged(null, null),
                  child: const Text('Clear'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => _setThisMonth(),
                  child: const Text('This Month'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => _setLast30Days(),
                  child: const Text('Last 30 Days'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onDateRangeChanged(picked, toDate);
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onDateRangeChanged(fromDate, picked);
    }
  }

  void _setThisMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    onDateRangeChanged(firstDay, lastDay);
  }

  void _setLast30Days() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    onDateRangeChanged(thirtyDaysAgo, now);
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onPressed;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            date != null
                ? '${date!.month}/${date!.day}/${date!.year}'
                : 'Select date',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

