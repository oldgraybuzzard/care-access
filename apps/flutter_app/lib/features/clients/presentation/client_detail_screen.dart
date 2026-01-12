import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/client_provider.dart';
import '../../../core/models/client.dart';

class ClientDetailScreen extends ConsumerWidget {
  final String clientId;

  const ClientDetailScreen({
    super.key,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(clientDetailProvider(clientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
      ),
      body: clientAsync.when(
        data: (client) => _buildClientDetail(context, client),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading client: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(clientDetailProvider(clientId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientDetail(BuildContext context, ClientDetail client) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Header Card
          _buildHeaderCard(client),
          const SizedBox(height: 16),

          // Basic Information
          _buildInfoSection('Basic Information', [
            _buildInfoRow('Full Name', client.fullName),
            if (client.age != null) _buildInfoRow('Age', '${client.age} years'),
            if (client.dob != null)
              _buildInfoRow('Date of Birth',
                  DateFormat('MMM d, yyyy').format(client.dob!)),
            _buildInfoRow('Status', client.status, statusBadge: true),
            if (client.vendorClientId.isNotEmpty)
              _buildInfoRow('Vendor Client ID', client.vendorClientId),
          ]),
          const SizedBox(height: 16),

          // Program Information
          if (client.program != null) ...[
            _buildInfoSection('Program', [
              _buildInfoRow('Program Name', client.program!.name),
            ]),
            const SizedBox(height: 16),
          ],

          // Cases Section
          _buildCasesSection(context, client),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ClientDetail client) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: _getStatusColor(client.status).withOpacity(0.2),
              child: Text(
                client.firstName.isNotEmpty
                    ? client.firstName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(client.status),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(client.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool statusBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: statusBadge
                ? _buildStatusBadge(value)
                : Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildCasesSection(BuildContext context, ClientDetail client) {
    if (client.cases.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cases',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No cases found'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cases',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${client.cases.length} total',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...client.cases
                .map((caseItem) => _buildCaseCard(context, caseItem)),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, ClientCase caseItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: InkWell(
        onTap: () => context.push('/cases/${caseItem.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Case: ${caseItem.vendorCaseId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildCaseStatusBadge(caseItem),
                ],
              ),
              const SizedBox(height: 8),
              _buildCaseInfoRow(
                Icons.calendar_today,
                'Opened',
                DateFormat('MMM d, yyyy').format(caseItem.openedAt),
              ),
              if (caseItem.closedAt != null)
                _buildCaseInfoRow(
                  Icons.event_busy,
                  'Closed',
                  DateFormat('MMM d, yyyy').format(caseItem.closedAt!),
                ),
              if (caseItem.worker != null)
                _buildCaseInfoRow(
                  Icons.person,
                  'Worker',
                  caseItem.worker!.name,
                ),
              if (caseItem.program != null)
                _buildCaseInfoRow(
                  Icons.business,
                  'Program',
                  caseItem.program!.name,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseStatusBadge(ClientCase caseItem) {
    final isOpen = caseItem.isOpen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withOpacity(0.2)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        caseItem.status.toUpperCase(),
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildCaseInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
