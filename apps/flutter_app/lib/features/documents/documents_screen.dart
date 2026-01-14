import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/documents_service.dart';
import 'widgets/document_list.dart';
import 'widgets/file_upload_button.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  final String? childId;
  final String? caseId;
  final String? clientId;
  final String? assessmentId;

  const DocumentsScreen({
    super.key,
    this.childId,
    this.caseId,
    this.clientId,
    this.assessmentId,
  });

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _listKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DocumentCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshList() {
    setState(() {
      // Force rebuild of DocumentList
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: DocumentCategory.values.map((category) {
            return Tab(
              text: '${category.emoji} ${category.label}',
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: DocumentCategory.values.map((category) {
          return DocumentList(
            key: ValueKey('${category.value}_$_listKey'),
            childId: widget.childId,
            caseId: widget.caseId,
            clientId: widget.clientId,
            assessmentId: widget.assessmentId,
            category: category.value,
            showUploadButton: true,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload'),
      ),
    );
  }

  void _showUploadDialog() {
    final currentCategory = DocumentCategory.values[_tabController.index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload ${currentCategory.label}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FileUploadButton(
              category: currentCategory,
              childId: widget.childId,
              caseId: widget.caseId,
              clientId: widget.clientId,
              assessmentId: widget.assessmentId,
              onUploadComplete: () {
                Navigator.pop(context);
                _refreshList();
              },
              showCamera: currentCategory == DocumentCategory.photo,
              buttonText: 'Choose File',
              icon: Icons.folder_open,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Standalone widget for adding documents to a child profile
class ChildDocumentsWidget extends ConsumerWidget {
  final String childId;

  const ChildDocumentsWidget({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentsScreen(childId: childId),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: DocumentList(
            childId: childId,
            showUploadButton: true,
          ),
        ),
      ],
    );
  }
}

