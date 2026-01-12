import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/child.dart';

class ChildOverviewTab extends StatelessWidget {
  final Child child;

  const ChildOverviewTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Stats
        _buildQuickStats(context),
        const SizedBox(height: 24),

        // Referral Information
        if (child.referralReason != null || child.presentingIssues != null) ...[
          _buildSection(
            context,
            'Referral Information',
            Icons.info_outline,
            [
              if (child.referralSource != null)
                _buildInfoRow('Referral Source', child.referralSource!),
              if (child.referralReason != null)
                _buildInfoRow('Reason', child.referralReason!),
              if (child.presentingIssues != null)
                _buildInfoRow('Presenting Issues', child.presentingIssues!),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Strengths & Interests
        if (child.strengths != null || child.interests != null) ...[
          _buildSection(
            context,
            'Strengths & Interests',
            Icons.star,
            [
              if (child.strengths != null && child.strengths!.isNotEmpty)
                _buildChipList('Strengths', child.strengths!, Colors.green),
              if (child.interests != null && child.interests!.isNotEmpty)
                _buildChipList('Interests', child.interests!, Colors.blue),
              if (child.likes != null && child.likes!.isNotEmpty)
                _buildChipList('Likes', child.likes!, Colors.purple),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Challenges & Triggers
        if (child.triggers != null ||
            child.fears != null ||
            child.dislikes != null) ...[
          _buildSection(
            context,
            'Important to Know',
            Icons.warning_amber,
            [
              if (child.triggers != null && child.triggers!.isNotEmpty)
                _buildChipList('Triggers', child.triggers!, Colors.red),
              if (child.fears != null && child.fears!.isNotEmpty)
                _buildChipList('Fears', child.fears!, Colors.orange),
              if (child.dislikes != null && child.dislikes!.isNotEmpty)
                _buildChipList('Dislikes', child.dislikes!, Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Coping Mechanisms
        if (child.copingMechanisms != null &&
            child.copingMechanisms!.isNotEmpty) ...[
          _buildSection(
            context,
            'Coping Mechanisms',
            Icons.psychology,
            [
              _buildChipList(
                  'Strategies', child.copingMechanisms!, Colors.teal,),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Basic Information
        _buildSection(
          context,
          'Basic Information',
          Icons.person_outline,
          [
            _buildInfoRow('Full Name', child.fullName),
            _buildInfoRow('Date of Birth',
                DateFormat('MMMM d, yyyy').format(child.dateOfBirth),),
            _buildInfoRow('Age', '${child.age} years old'),
            _buildInfoRow('Gender', child.gender),
            if (child.raceEthnicity != null)
              _buildInfoRow('Race/Ethnicity', child.raceEthnicity!),
            if (child.preferredLanguage != null)
              _buildInfoRow('Preferred Language', child.preferredLanguage!),
            _buildInfoRow('Status', child.status),
            if (child.custodyStatus != null)
              _buildInfoRow('Custody Status', child.custodyStatus!),
            if (child.legalStatus != null)
              _buildInfoRow('Legal Status', child.legalStatus!),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              Icons.calendar_today,
              '${child.age}',
              'Years Old',
            ),
            _buildStatItem(
              context,
              Icons.home,
              child.custodyStatus ?? 'N/A',
              'Custody',
            ),
            _buildStatItem(
              context,
              Icons.check_circle,
              child.status,
              'Status',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, IconData icon, String value, String label,) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon,
      List<Widget> children,) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
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
            ...children,
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

  Widget _buildChipList(String label, List<dynamic> items, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Chip(
                label: Text(
                  item.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
                backgroundColor: color.withOpacity(0.1),
                side: BorderSide(color: color.withOpacity(0.3)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
