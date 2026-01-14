import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/documents_service.dart';

class FileUploadButton extends ConsumerStatefulWidget {
  final DocumentCategory category;
  final String? childId;
  final String? caseId;
  final String? clientId;
  final String? assessmentId;
  final String? description;
  final List<String>? tags;
  final VoidCallback? onUploadComplete;
  final bool showCamera;
  final String buttonText;
  final IconData? icon;

  const FileUploadButton({
    super.key,
    required this.category,
    this.childId,
    this.caseId,
    this.clientId,
    this.assessmentId,
    this.description,
    this.tags,
    this.onUploadComplete,
    this.showCamera = true,
    this.buttonText = 'Upload File',
    this.icon,
  });

  @override
  ConsumerState<FileUploadButton> createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends ConsumerState<FileUploadButton> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickAndUploadFile() async {
    try {
      // Show options if camera is available
      if (widget.showCamera && widget.category == DocumentCategory.photo) {
        final source = await _showImageSourceDialog();
        if (source == null) return;

        if (source == ImageSource.camera) {
          await _pickFromCamera();
        } else {
          await _pickFromGallery();
        }
      } else {
        await _pickFromFiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _uploadFile(File(image.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _uploadFile(File(image.path));
    }
  }

  Future<void> _pickFromFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _getAllowedExtensions(),
    );

    if (result != null && result.files.single.path != null) {
      await _uploadFile(File(result.files.single.path!));
    }
  }

  List<String> _getAllowedExtensions() {
    switch (widget.category) {
      case DocumentCategory.photo:
        return ['jpg', 'jpeg', 'png', 'gif', 'webp'];
      case DocumentCategory.medical:
      case DocumentCategory.legal:
      case DocumentCategory.report:
        return ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'];
      case DocumentCategory.import:
        return ['csv', 'xlsx', 'xls'];
      default:
        return ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'csv', 'zip'];
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final service = ref.read(documentsServiceProvider);
      await service.uploadFile(
        file: file,
        category: widget.category.value,
        description: widget.description,
        tags: widget.tags,
        childId: widget.childId,
        caseId: widget.caseId,
        clientId: widget.clientId,
        assessmentId: widget.assessmentId,
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully!')),
        );
        widget.onUploadComplete?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 8),
          Text('${(_uploadProgress * 100).toInt()}%'),
        ],
      );
    }

    return ElevatedButton.icon(
      onPressed: _pickAndUploadFile,
      icon: Icon(widget.icon ?? Icons.upload_file),
      label: Text(widget.buttonText),
    );
  }
}

