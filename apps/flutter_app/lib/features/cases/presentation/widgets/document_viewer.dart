import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/case.dart';

class DocumentViewer extends StatelessWidget {
  final Document document;

  const DocumentViewer({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadDocument(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareDocument(context),
          ),
        ],
      ),
      body: _buildDocumentContent(context),
    );
  }

  Widget _buildDocumentContent(BuildContext context) {
    final docType = document.docType.toLowerCase();

    // For now, we'll show a placeholder since we don't have actual document URLs
    // In a real app, you would fetch the document URL from the API
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getDocumentIcon(docType),
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            document.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${document.docType}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _openExternalViewer(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open in External Viewer'),
          ),
          const SizedBox(height: 16),
          Text(
            'Document ID: ${document.id}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String docType) {
    switch (docType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'form':
        return Icons.assignment;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _downloadDocument(BuildContext context) async {
    // TODO: Implement actual download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${document.title}...'),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _shareDocument(BuildContext context) async {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${document.title}...'),
      ),
    );
  }

  Future<void> _openExternalViewer(BuildContext context) async {
    // TODO: In a real app, you would have a document URL
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document URL not available in demo mode'),
      ),
    );

    // Example of how to open a URL:
    // final url = Uri.parse(document.url);
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url, mode: LaunchMode.externalApplication);
    // }
  }
}

/// Widget for viewing images
class ImageDocumentViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImageDocumentViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}

