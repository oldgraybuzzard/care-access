# Documents Feature

Flutter UI for file upload, download, and management with Cloudflare R2 storage.

## Features

- ✅ File picker with camera support
- ✅ Upload progress tracking
- ✅ Document categorization (photos, medical, legal, etc.)
- ✅ Image preview
- ✅ File type validation
- ✅ Download and delete documents
- ✅ Multi-tenant support

## Usage

### 1. Add Documents Screen to a Child Profile

```dart
import 'package:careaccess/features/documents/documents_screen.dart';

// Navigate to documents screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DocumentsScreen(childId: childId),
  ),
);
```

### 2. Add Documents Widget to Existing Screen

```dart
import 'package:careaccess/features/documents/documents_screen.dart';

// Add to your widget tree
ChildDocumentsWidget(childId: childId)
```

### 3. Upload Button Only

```dart
import 'package:careaccess/features/documents/widgets/file_upload_button.dart';
import 'package:careaccess/core/api/documents_service.dart';

FileUploadButton(
  category: DocumentCategory.photo,
  childId: childId,
  description: 'School photo 2024',
  tags: ['school', '2024'],
  onUploadComplete: () {
    print('Upload complete!');
  },
  showCamera: true,
)
```

### 4. Document List Only

```dart
import 'package:careaccess/features/documents/widgets/document_list.dart';

DocumentList(
  childId: childId,
  category: 'photo', // Optional filter
  showUploadButton: true,
)
```

## Document Categories

- 📷 **Photo** - Child photos, family photos
- 🏥 **Medical** - Medical records, vaccination cards
- ⚖️ **Legal** - Court documents, custody papers
- 🎓 **Education** - Report cards, IEPs
- 📝 **Case Note** - Case worker notes
- 📊 **Report** - Assessment reports
- 📥 **Import** - CSV imports, data exports
- 📄 **Other** - Miscellaneous documents

## API Service

The `DocumentsService` handles all API calls:

```dart
final service = ref.read(documentsServiceProvider);

// Upload file
await service.uploadFile(
  file: File('/path/to/file.jpg'),
  category: 'photo',
  childId: childId,
  onProgress: (progress) {
    print('Upload: ${(progress * 100).toInt()}%');
  },
);

// Get documents
final docs = await service.getDocuments(childId: childId);

// Delete document
await service.deleteDocument(documentId);

// Download file
final file = await service.downloadFile(document, '/path/to/save');
```

## File Type Support

### Images
- JPG, JPEG, PNG, GIF, WebP

### Documents
- PDF
- Word (DOC, DOCX)
- Excel (XLS, XLSX)

### Data
- CSV

### Archives
- ZIP

## Size Limits

- Maximum file size: **50 MB**
- Enforced on both client and server

## Security

- ✅ Signed URLs (1-hour expiration)
- ✅ Organization isolation
- ✅ File type validation
- ✅ Size validation
- ✅ Audit trail (who uploaded, when)

## Next Steps

1. Add image optimization (resize/compress before upload)
2. Add document viewer (PDF, images)
3. Add bulk upload
4. Add document sharing
5. Add document versioning

