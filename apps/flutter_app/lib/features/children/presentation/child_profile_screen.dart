import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/children_api.dart';
import '../../../core/models/child.dart';
import 'widgets/child_header.dart';
import 'widgets/child_overview_tab.dart';
import 'widgets/child_medical_tab.dart';
import 'widgets/child_education_tab.dart';
import 'widgets/child_behavioral_tab.dart';
import 'widgets/child_family_tab.dart';
import 'widgets/child_goals_tab.dart';

final childProfileProvider = FutureProvider.family<Child, String>((ref, childId) async {
  final api = ref.watch(childrenApiProvider);
  return api.getChild(childId);
});

class ChildProfileScreen extends ConsumerWidget {
  final String childId;

  const ChildProfileScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProfileProvider(childId));

    return Scaffold(
      body: childAsync.when(
        data: (child) => _buildProfile(context, child),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading child profile: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(childProfileProvider(childId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, Child child) {
    return DefaultTabController(
      length: 6,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ChildHeader(child: child),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(icon: Icon(Icons.person), text: 'Overview'),
                    Tab(icon: Icon(Icons.medical_services), text: 'Medical'),
                    Tab(icon: Icon(Icons.school), text: 'Education'),
                    Tab(icon: Icon(Icons.psychology), text: 'Behavioral'),
                    Tab(icon: Icon(Icons.family_restroom), text: 'Family'),
                    Tab(icon: Icon(Icons.flag), text: 'Goals'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            ChildOverviewTab(child: child),
            ChildMedicalTab(child: child),
            ChildEducationTab(child: child),
            ChildBehavioralTab(child: child),
            ChildFamilyTab(child: child),
            ChildGoalsTab(child: child),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

