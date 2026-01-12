import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/child.dart';
import 'quick_edit_dialogs.dart';

class ChildMedicalTab extends ConsumerWidget {
  final Child child;
  final VoidCallback? onUpdate;

  const ChildMedicalTab({
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
                builder: (context) => QuickEditMedicalDialog(child: child),
              );
              if (result == true && onUpdate != null) {
                onUpdate!();
              }
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Quick Edit Medical'),
          ),
        ),
        const SizedBox(height: 16),

        // Medications
        if (child.medications != null && child.medications!.isNotEmpty) ...[
          _buildSection(
            context,
            'Current Medications',
            Icons.medication,
            child.medications!,
          ),
          const SizedBox(height: 16),
        ],

        // Allergies
        if (child.allergies != null && child.allergies!.isNotEmpty) ...[
          _buildSection(
            context,
            'Allergies',
            Icons.warning,
            child.allergies!,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
        ],

        // Medical Conditions
        if (child.medicalConditions != null &&
            child.medicalConditions!.isNotEmpty) ...[
          _buildSection(
            context,
            'Medical Conditions',
            Icons.local_hospital,
            child.medicalConditions!,
          ),
          const SizedBox(height: 16),
        ],

        // Mental Health Diagnoses
        if (child.mentalHealthDx != null &&
            child.mentalHealthDx!.isNotEmpty) ...[
          _buildSection(
            context,
            'Mental Health Diagnoses',
            Icons.psychology,
            child.mentalHealthDx!,
          ),
          const SizedBox(height: 16),
        ],

        // Identifiers
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.badge,
                        color: Theme.of(context).colorScheme.primary,),
                    const SizedBox(width: 8),
                    const Text(
                      'Medical Identifiers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (child.medicaidId != null)
                  _buildInfoRow('Medicaid ID', child.medicaidId!),
                if (child.ssn != null)
                  _buildInfoRow('SSN',
                      '***-**-${child.ssn!.substring(child.ssn!.length - 4)}',),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<dynamic> items, {
    Color? color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    color: color ?? Theme.of(context).colorScheme.primary,),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: color ?? Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
