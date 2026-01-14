import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/api/documents_api.dart';
import '../../../core/api/documents_service.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onDelete,
    this.onDownload,
  });

  IconData _getFileIcon() {
    if (document.isImage) return Icons.image;
    if (document.isPdf) return Icons.picture_as_pdf;
    if (document.isDocument) return Icons.description;
    if (document.isSpreadsheet) return Icons.table_chart;
    return Icons.insert_drive_file;
  }

  Color _getFileColor() {
    if (document.isImage) return Colors.blue;
    if (document.isPdf) return Colors.red;
    if (document.isDocument) return Colors.indigo;
    if (document.isSpreadsheet) return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final category = DocumentCategory.fromValue(document.category);
    final dateFormat = DateFormat('MMM d, y • h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getFileColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileIcon(),
                  color: _getFileColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filename
                    Text(
                      document.filename,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category and size
                    Row(
                      children: [
                        Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          document.sizeFormatted,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Upload date
                    Text(
                      'Uploaded ${dateFormat.format(document.uploadedAt)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),

                    // Description (if available)
                    if (document.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        document.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Tags (if available)
                    if (document.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: document.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'download') {
                    onDownload?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        SizedBox(width: 8),
                        Text('Download'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

