import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaseDetailScreen extends ConsumerWidget {
  final String caseId;

  const CaseDetailScreen({
    super.key,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
      ),
      body: Center(
        child: Text('Case ID: $caseId'),
      ),
    );
  }
}

