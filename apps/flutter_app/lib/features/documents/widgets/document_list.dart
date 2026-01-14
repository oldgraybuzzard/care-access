import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/documents_api.dart';
import '../../../core/api/documents_service.dart';
import 'document_card.dart';

class DocumentList extends ConsumerStatefulWidget {
  final String? childId;
  final String? caseId;
  final String? clientId;
  final String? assessmentId;
  final String? category;
  final bool showUploadButton;

  const DocumentList({
    super.key,
    this.childId,
    this.caseId,
    this.clientId,
    this.assessmentId,
    this.category,
    this.showUploadButton = false,
  });

  @override
  ConsumerState<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends ConsumerState<DocumentList> {
  List<DocumentModel>? _documents;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(documentsServiceProvider);
      final documents = await service.getDocuments(
        childId: widget.childId,
        caseId: widget.caseId,
        clientId: widget.clientId,
        assessmentId: widget.assessmentId,
        category: widget.category,
      );

      setState(() {
        _documents = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDocument(DocumentModel document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document.filename}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(documentsServiceProvider);
        await service.deleteDocument(document.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document deleted')),
          );
          _loadDocuments();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Delete failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDocuments,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_documents == null || _documents!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No documents found'),
            if (widget.showUploadButton) ...[
              const SizedBox(height: 16),
              const Text('Upload your first document to get started'),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDocuments,
      child: ListView.builder(
        itemCount: _documents!.length,
        itemBuilder: (context, index) {
          final document = _documents![index];
          return DocumentCard(
            document: document,
            onDelete: () => _deleteDocument(document),
            onTap: () {
              // TODO: Open document viewer
            },
          );
        },
      ),
    );
  }
}

