import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityCreateDialog extends StatefulWidget {
  final String caseId;
  final Function(String activityType, DateTime occurredAt, String? summary)
      onCreate;

  const ActivityCreateDialog({
    super.key,
    required this.caseId,
    required this.onCreate,
  });

  @override
  State<ActivityCreateDialog> createState() => _ActivityCreateDialogState();
}

class _ActivityCreateDialogState extends State<ActivityCreateDialog> {
  final TextEditingController _summaryController = TextEditingController();
  String _selectedActivityType = 'Phone Call';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isCreating = false;

  final List<String> _activityTypes = [
    'Phone Call',
    'Home Visit',
    'Office Visit',
    'Email',
    'Text Message',
    'Court Appearance',
    'School Visit',
    'Medical Appointment',
    'Therapy Session',
    'Case Note',
    'Other',
  ];

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _create() async {
    setState(() {
      _isCreating = true;
    });

    try {
      final occurredAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await widget.onCreate(
        _selectedActivityType,
        occurredAt,
        _summaryController.text.trim().isEmpty
            ? null
            : _summaryController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create activity: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Activity'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedActivityType,
              decoration: const InputDecoration(
                labelText: 'Activity Type',
                border: OutlineInputBorder(),
              ),
              items: _activityTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: _isCreating
                  ? null
                  : (value) {
                      setState(() {
                        _selectedActivityType = value!;
                      });
                    },
            ),
            const SizedBox(height: 16),

            // Date and Time Pickers
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCreating ? null : _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('MMM d, yyyy').format(_selectedDate)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCreating ? null : _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary Field
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Summary (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Enter activity details...',
              ),
              maxLines: 3,
              enabled: !_isCreating,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _create,
          child: _isCreating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

