import 'package:flutter/material.dart';

/// Bottom sheet showing detailed information about a KPI
class KpiDetailSheet extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final List<DetailItem> details;

  const KpiDetailSheet({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Details list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: details.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final detail = details[index];
                return ListTile(
                  leading: detail.icon != null
                      ? Icon(detail.icon, color: detail.color ?? Colors.grey)
                      : null,
                  title: Text(detail.label),
                  trailing: Text(
                    detail.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: detail.color,
                        ),
                  ),
                );
              },
            ),
          ),

          // Action buttons (optional)
          if (details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to detailed view or export data
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Full Report'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Show the KPI detail sheet
  static void show(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required List<DetailItem> details,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KpiDetailSheet(
        title: title,
        value: value,
        icon: icon,
        color: color,
        details: details,
      ),
    );
  }
}

/// Model for detail items in the KPI detail sheet
class DetailItem {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const DetailItem({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });
}

