import 'package:flutter/material.dart';
import '../../../../core/models/child.dart';

class ChildGoalsTab extends StatelessWidget {
  final Child child;

  const ChildGoalsTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Goals & Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

