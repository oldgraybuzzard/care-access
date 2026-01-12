import 'package:flutter/material.dart';
import '../../../../core/models/child.dart';

class ChildFamilyTab extends StatelessWidget {
  final Child child;

  const ChildFamilyTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child.family == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.family_restroom, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No family information available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final family = child.family!;

    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.home,
                        color: Theme.of(context).colorScheme.primary,),
                    const SizedBox(width: 8),
                    Text(
                      family.familyName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (family.primaryContact != null)
                  _buildInfoRow('Primary Contact', family.primaryContact!),
                if (family.phone != null) _buildInfoRow('Phone', family.phone!),
                if (family.email != null) _buildInfoRow('Email', family.email!),
                if (family.address != null) ...[
                  _buildInfoRow(
                    'Address',
                    '${family.address}, ${family.city ?? ''}, ${family.state ?? ''} ${family.zipCode ?? ''}'
                        .trim(),
                  ),
                ],
                if (family.housingType != null)
                  _buildInfoRow('Housing Type', family.housingType!),
                if (family.householdIncome != null)
                  _buildInfoRow('Household Income', family.householdIncome!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
