import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/case_provider.dart';
import '../../../core/models/case.dart';
import '../../../core/api/cases_api.dart';
import 'widgets/document_viewer.dart';
import 'widgets/timeline_filters.dart';
import 'widgets/document_upload_dialog.dart';
import 'widgets/activity_create_dialog.dart';
import 'widgets/case_notes_widget.dart';
import '../services/case_export_service.dart';

class CaseDetailScreen extends ConsumerStatefulWidget {
  final String caseId;

  const CaseDetailScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends ConsumerState<CaseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _typeFilter;
  DateTimeRange? _dateRangeFilter;
  String _searchQuery = '';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(caseDetailProvider(widget.caseId));
      ref.invalidate(caseActivitiesProvider(widget.caseId));
      ref.invalidate(caseNotesProvider(widget.caseId));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final caseAsync = ref.watch(caseDetailProvider(widget.caseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export',
            onPressed: () => _showExportOptions(context, caseAsync.value),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Overview'),
            Tab(icon: Icon(Icons.event_note), text: 'Activities'),
            Tab(icon: Icon(Icons.description), text: 'Documents'),
            Tab(icon: Icon(Icons.note), text: 'Notes'),
          ],
        ),
      ),
      body: caseAsync.when(
        data: (caseDetail) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(caseDetailProvider(widget.caseId));
            ref.invalidate(caseActivitiesProvider(widget.caseId));
            ref.invalidate(caseServicesProvider(widget.caseId));
            ref.invalidate(caseDocumentsProvider(widget.caseId));
            ref.invalidate(caseNotesProvider(widget.caseId));
            // Wait for the case detail to reload
            await ref.read(caseDetailProvider(widget.caseId).future);
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context, caseDetail),
              _buildActivitiesTab(context),
              _buildDocumentsTab(context),
              _buildNotesTab(context),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading case: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(caseDetailProvider(widget.caseId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, CaseDetail caseDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case Header Card
          _buildHeaderCard(caseDetail),
          const SizedBox(height: 16),

          // Client Information
          if (caseDetail.client != null) ...[
            _buildClientSection(context, caseDetail.client!),
            const SizedBox(height: 16),
          ],

          // Case Information
          _buildCaseInfoSection(caseDetail),
          const SizedBox(height: 16),

          // Worker & Program Information
          _buildWorkerProgramSection(caseDetail),
          const SizedBox(height: 16),

          // Recent Activity (Audit Log)
          _buildRecentActivitySection(),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Audit logging is enabled. All case views, edits, and actions are tracked.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Contact your administrator to view detailed audit logs.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(CaseDetail caseDetail) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Case: ${caseDetail.vendorCaseId}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusBadge(caseDetail),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Opened: ${DateFormat('MMM d, yyyy').format(caseDetail.openedAt)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (caseDetail.closedAt != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.event_busy, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Closed: ${DateFormat('MMM d, yyyy').format(caseDetail.closedAt!)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Duration: ${caseDetail.daysOpen} days',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(CaseDetail caseDetail) {
    final isOpen = caseDetail.isOpen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        caseDetail.status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildClientSection(BuildContext context, CaseClient client) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Client Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('Name', client.fullName),
            if (client.dob != null)
              _buildInfoRow(
                'Date of Birth',
                DateFormat('MMM d, yyyy').format(client.dob!),
              ),
            _buildInfoRow('Status', client.status),
            if (client.program != null)
              _buildInfoRow('Program', client.program!.name),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseInfoSection(CaseDetail caseDetail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Case Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('Case ID', caseDetail.id),
            _buildInfoRow('Vendor Case ID', caseDetail.vendorCaseId),
            if (caseDetail.vendorSource != null)
              _buildInfoRow('Source', caseDetail.vendorSource!.name),
            _buildInfoRow('Status', caseDetail.status),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerProgramSection(CaseDetail caseDetail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assignment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (caseDetail.worker != null) ...[
              _buildInfoRow('Assigned Worker', caseDetail.worker!.name),
              if (caseDetail.worker!.email != null)
                _buildInfoRow('Worker Email', caseDetail.worker!.email!),
            ] else
              _buildInfoRow('Assigned Worker', 'Unassigned'),
            if (caseDetail.program != null)
              _buildInfoRow('Program', caseDetail.program!.name),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab(BuildContext context) {
    final activitiesAsync = ref.watch(caseActivitiesProvider(widget.caseId));

    return activitiesAsync.when(
      data: (data) {
        final activities = data['data'] as List<Activity>;
        final servicesAsync = ref.watch(caseServicesProvider(widget.caseId));

        return servicesAsync.when(
          data: (servicesData) {
            final services = servicesData['data'] as List<Service>;

            // Get unique types for filter
            final activityTypes =
                activities.map((a) => a.activityType).toSet().toList();
            final serviceTypes =
                services.map((s) => s.serviceType).toSet().toList();
            final allTypes = [...activityTypes, ...serviceTypes]..sort();

            return Stack(
              children: [
                Column(
                  children: [
                    TimelineFilters(
                      availableTypes: allTypes,
                      onTypeFilterChanged: (type) {
                        setState(() {
                          _typeFilter = type;
                        });
                      },
                      onDateRangeChanged: (range) {
                        setState(() {
                          _dateRangeFilter = range;
                        });
                      },
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                    Expanded(
                      child: _buildTimelineView(
                        _filterActivities(activities),
                        _filterServices(services),
                      ),
                    ),
                  ],
                ),
                // Floating Action Button for Adding Activity
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: () => _showActivityCreateDialog(context),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading activities: $error'),
          ],
        ),
      ),
    );
  }

  List<Activity> _filterActivities(List<Activity> activities) {
    return activities.where((activity) {
      // Type filter
      if (_typeFilter != null && activity.activityType != _typeFilter) {
        return false;
      }

      // Date range filter
      if (_dateRangeFilter != null) {
        if (activity.occurredAt.isBefore(_dateRangeFilter!.start) ||
            activity.occurredAt.isAfter(_dateRangeFilter!.end)) {
          return false;
        }
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return activity.activityType.toLowerCase().contains(query) ||
            (activity.summary?.toLowerCase().contains(query) ?? false);
      }

      return true;
    }).toList();
  }

  List<Service> _filterServices(List<Service> services) {
    return services.where((service) {
      // Type filter
      if (_typeFilter != null && service.serviceType != _typeFilter) {
        return false;
      }

      // Date range filter
      if (_dateRangeFilter != null) {
        if (service.startAt.isBefore(_dateRangeFilter!.start) ||
            service.startAt.isAfter(_dateRangeFilter!.end)) {
          return false;
        }
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return service.serviceType.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  Widget _buildTimelineView(List<Activity> activities, List<Service> services) {
    // Combine activities and services into a timeline
    final timelineItems = <_TimelineItem>[];

    for (final activity in activities) {
      timelineItems.add(
        _TimelineItem(
          date: activity.occurredAt,
          type: 'Activity',
          title: activity.activityType,
          subtitle: activity.summary,
          icon: Icons.event_note,
          color: Colors.blue,
        ),
      );
    }

    for (final service in services) {
      timelineItems.add(
        _TimelineItem(
          date: service.startAt,
          type: 'Service',
          title: service.serviceType,
          subtitle: service.isActive ? 'Active' : 'Completed',
          icon: Icons.medical_services,
          color: service.isActive ? Colors.green : Colors.grey,
        ),
      );
    }

    // Sort by date descending
    timelineItems.sort((a, b) => b.date.compareTo(a.date));

    if (timelineItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No activities or services yet'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timelineItems.length,
      itemBuilder: (context, index) {
        final item = timelineItems[index];
        final isLast = index == timelineItems.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 20),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: item.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(item.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final documentsAsync = ref.watch(caseDocumentsProvider(widget.caseId));

    return documentsAsync.when(
      data: (data) {
        final documents = data['data'] as List<Document>;

        return Stack(
          children: [
            if (documents.isEmpty)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No documents available'),
                    SizedBox(height: 8),
                    Text(
                      'Tap + to upload a document',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          _getDocumentIcon(doc.docType),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(doc.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.docType),
                          Text(
                            'Updated: ${DateFormat('MMM d, yyyy').format(doc.updatedAt)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DocumentViewer(document: doc),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            // Floating Action Button for Upload
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () => _showUploadDialog(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading documents: $error'),
          ],
        ),
      ),
    );
  }

  Future<void> _showUploadDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DocumentUploadDialog(
        caseId: widget.caseId,
        onUpload: _uploadDocument,
      ),
    );

    if (result == true) {
      // Refresh documents list
      ref.invalidate(caseDocumentsProvider(widget.caseId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded successfully')),
        );
      }
    }
  }

  Future<void> _uploadDocument(File file, String title, String docType) async {
    final casesApi = ref.read(casesApiProvider);
    await casesApi.uploadDocument(widget.caseId, file, title, docType);
  }

  Future<void> _showActivityCreateDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ActivityCreateDialog(
        caseId: widget.caseId,
        onCreate: _createActivity,
      ),
    );

    if (result == true) {
      // Refresh activities list
      ref.invalidate(caseActivitiesProvider(widget.caseId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity created successfully')),
        );
      }
    }
  }

  Future<void> _createActivity(
      String activityType, DateTime occurredAt, String? summary) async {
    final casesApi = ref.read(casesApiProvider);
    await casesApi.createActivity(
      widget.caseId,
      activityType: activityType,
      occurredAt: occurredAt,
      summary: summary,
    );
  }

  Widget _buildNotesTab(BuildContext context) {
    final notesAsync = ref.watch(caseNotesProvider(widget.caseId));

    return notesAsync.when(
      data: (data) {
        final notes = data['data'] as List<CaseNote>;
        return CaseNotesWidget(
          notes: notes,
          onAddNote: _createNote,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading notes: $error'),
          ],
        ),
      ),
    );
  }

  Future<void> _createNote(String content) async {
    final casesApi = ref.read(casesApiProvider);
    await casesApi.createNote(widget.caseId, content);
    // Refresh notes list
    ref.invalidate(caseNotesProvider(widget.caseId));
  }

  void _showExportOptions(BuildContext context, CaseDetail? caseDetail) {
    if (caseDetail == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export to PDF'),
              subtitle: const Text('Export case details as PDF'),
              onTap: () async {
                Navigator.pop(context);
                final exportService = CaseExportService();
                await exportService.exportToPdf(caseDetail);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export Activities to CSV'),
              subtitle: const Text('Export activities as CSV file'),
              onTap: () async {
                Navigator.pop(context);
                final activitiesAsync = await ref
                    .read(caseActivitiesProvider(widget.caseId).future);
                final activities = activitiesAsync['data'] as List<Activity>;
                final exportService = CaseExportService();
                await exportService.exportActivitiesToCsv(
                  widget.caseId,
                  activities,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Activities exported to CSV'),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export Services to CSV'),
              subtitle: const Text('Export services as CSV file'),
              onTap: () async {
                Navigator.pop(context);
                final servicesAsync =
                    await ref.read(caseServicesProvider(widget.caseId).future);
                final services = servicesAsync['data'] as List<Service>;
                final exportService = CaseExportService();
                await exportService.exportServicesToCsv(
                  widget.caseId,
                  services,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Services exported to CSV'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String docType) {
    switch (docType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'form':
        return Icons.assignment;
      default:
        return Icons.description;
    }
  }
}

class _TimelineItem {
  final DateTime date;
  final String type;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  _TimelineItem({
    required this.date,
    required this.type,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });
}
