import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/child.dart';
import 'quick_edit_dialogs.dart';

class ChildBehavioralTab extends ConsumerWidget {
  final Child child;
  final VoidCallback? onUpdate;

  const ChildBehavioralTab({
    super.key,
    required this.child,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Edit Button
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonalIcon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => QuickEditBehavioralDialog(child: child),
              );
              if (result == true && onUpdate != null) {
                onUpdate!();
              }
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Quick Edit Behavioral'),
          ),
        ),
        const SizedBox(height: 16),

        // Trauma History
        if (child.traumaHistory != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history,
                          color: Theme.of(context).colorScheme.primary,),
                      const SizedBox(width: 8),
                      const Text(
                        'Trauma History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    child.traumaHistory!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Attachment Style
        if (child.attachmentStyle != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite,
                          color: Theme.of(context).colorScheme.primary,),
                      const SizedBox(width: 8),
                      const Text(
                        'Attachment Style',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    child.attachmentStyle!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Placeholder for incidents
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.report, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Behavioral Incidents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Coming soon...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
