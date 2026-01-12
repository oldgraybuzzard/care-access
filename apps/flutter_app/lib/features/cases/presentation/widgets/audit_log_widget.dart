import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/case.dart';

class AuditLogWidget extends StatelessWidget {
  final List<AuditLog> logs;
  final bool isLoading;

  const AuditLogWidget({
    super.key,
    required this.logs,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No audit logs available'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getActionColor(log.action),
              child: Icon(
                _getActionIcon(log.action),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              log.actionDescription,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.userName ?? log.userEmail ?? 'Unknown User'),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy h:mm a').format(log.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'view':
      case 'view_activities':
      case 'view_services':
      case 'view_documents':
        return Icons.visibility;
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.info;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'view':
      case 'view_activities':
      case 'view_services':
      case 'view_documents':
        return Colors.blue;
      case 'create':
        return Colors.green;
      case 'update':
        return Colors.orange;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

