import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'documents_api.dart';
import 'api_client.dart';

final documentsServiceProvider = Provider<DocumentsService>((ref) {
  final dio = ref.watch(dioProvider);
  return DocumentsService(dio);
});

class DocumentsService {
  final Dio _dio;
  late final DocumentsApi _api;

  DocumentsService(this._dio) {
    _api = DocumentsApi(_dio);
  }

  /// Upload a file with progress callback
  Future<DocumentModel> uploadFile({
    required File file,
    required String category,
    String? description,
    List<String>? tags,
    String? childId,
    String? caseId,
    String? clientId,
    String? assessmentId,
    void Function(double progress)? onProgress,
  }) async {
    // Get file info
    final filename = file.path.split('/').last;
    final bytes = await file.readAsBytes();
    final mimeType = lookupMimeType(filename) ?? 'application/octet-stream';

    // Create multipart file
    final multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: MediaType.parse(mimeType),
    );

    // Create form data with progress tracking
    final formData = FormData.fromMap({
      'file': multipartFile,
      'category': category,
      if (description != null) 'description': description,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
      if (childId != null) 'childId': childId,
      if (caseId != null) 'caseId': caseId,
      if (clientId != null) 'clientId': clientId,
      if (assessmentId != null) 'assessmentId': assessmentId,
    });

    // Upload with progress
    final response = await _dio.post<Map<String, dynamic>>(
      '/documents/upload',
      data: formData,
      onSendProgress: (sent, total) {
        if (onProgress != null && total > 0) {
          onProgress(sent / total);
        }
      },
    );

    return DocumentModel.fromJson(response.data!);
  }

  /// Get all documents with optional filters
  Future<List<DocumentModel>> getDocuments({
    String? childId,
    String? caseId,
    String? clientId,
    String? assessmentId,
    String? category,
  }) {
    return _api.getDocuments(
      childId: childId,
      caseId: caseId,
      clientId: clientId,
      assessmentId: assessmentId,
      category: category,
    );
  }

  /// Get a single document
  Future<DocumentModel> getDocument(String id) {
    return _api.getDocument(id);
  }

  /// Delete a document
  Future<void> deleteDocument(String id) {
    return _api.deleteDocument(id);
  }

  /// Download a file to local storage
  Future<File> downloadFile(DocumentModel document, String savePath) async {
    final response = await _dio.get(
      document.downloadUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final file = File(savePath);
    await file.writeAsBytes(response.data);
    return file;
  }
}

/// Document categories enum
enum DocumentCategory {
  photo('photo', 'Photo', '📷'),
  medical('medical', 'Medical', '🏥'),
  legal('legal', 'Legal', '⚖️'),
  education('education', 'Education', '🎓'),
  caseNote('case_note', 'Case Note', '📝'),
  report('report', 'Report', '📊'),
  import('import', 'Import', '📥'),
  other('other', 'Other', '📄');

  final String value;
  final String label;
  final String emoji;

  const DocumentCategory(this.value, this.label, this.emoji);

  static DocumentCategory fromValue(String value) {
    return DocumentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DocumentCategory.other,
    );
  }
}

/// Upload progress state
class UploadProgress {
  final String filename;
  final double progress;
  final UploadStatus status;
  final String? error;

  UploadProgress({
    required this.filename,
    required this.progress,
    required this.status,
    this.error,
  });

  UploadProgress copyWith({
    String? filename,
    double? progress,
    UploadStatus? status,
    String? error,
  }) {
    return UploadProgress(
      filename: filename ?? this.filename,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

enum UploadStatus {
  idle,
  uploading,
  success,
  error,
}

