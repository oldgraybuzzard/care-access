# Cloudflare R2 Storage - Setup Complete! ✅

## What We Built

You now have a **complete document management system** integrated with Cloudflare R2 storage!

### Features
- ✅ **File Upload** - Upload documents, photos, PDFs, etc.
- ✅ **Secure Storage** - Files stored in Cloudflare R2 (S3-compatible)
- ✅ **Signed URLs** - Temporary download links (1 hour expiration)
- ✅ **Multi-tenant** - Organization-scoped documents
- ✅ **Categorization** - Photo, medical, legal, education, etc.
- ✅ **Relationships** - Attach to children, cases, clients, assessments
- ✅ **File Validation** - Type and size validation
- ✅ **Audit Trail** - Track who uploaded what and when

---

## API Endpoints

### 1. Upload a Document
```http
POST /documents/upload
Content-Type: multipart/form-data
Authorization: Bearer <token>

Body (form-data):
- file: <binary file>
- category: "photo" | "medical" | "legal" | "education" | "case_note" | "report" | "import" | "other"
- description: "Optional description"
- tags: ["tag1", "tag2"]
- childId: "uuid" (optional)
- caseId: "uuid" (optional)
- clientId: "uuid" (optional)
- assessmentId: "uuid" (optional)
```

**Response:**
```json
{
  "id": "doc-uuid",
  "filename": "photo.jpg",
  "storageKey": "org-123/photo/child-456/abc123.jpg",
  "mimetype": "image/jpeg",
  "size": 1024000,
  "category": "photo",
  "description": "Child's school photo",
  "tags": ["school", "2024"],
  "childId": "child-uuid",
  "uploadedBy": "user-uuid",
  "uploadedAt": "2026-01-14T10:00:00Z",
  "downloadUrl": "https://signed-url.r2.dev/..."
}
```

### 2. Get All Documents
```http
GET /documents?childId=<uuid>&category=photo
Authorization: Bearer <token>
```

**Query Parameters:**
- `childId` - Filter by child
- `caseId` - Filter by case
- `clientId` - Filter by client
- `assessmentId` - Filter by assessment
- `category` - Filter by category

### 3. Get Single Document
```http
GET /documents/:id
Authorization: Bearer <token>
```

### 4. Delete Document
```http
DELETE /documents/:id
Authorization: Bearer <token>
```

---

## Database Schema

### Document Model
```prisma
model Document {
  id             String   @id @default(uuid())
  organizationId String
  
  // File metadata
  filename       String
  storageKey     String   @unique
  mimetype       String
  size           Int
  
  // Categorization
  category       String   // photo, medical, legal, etc.
  description    String?
  tags           String[]
  
  // Relationships
  childId        String?
  caseId         String?
  clientId       String?
  assessmentId   String?
  
  // Audit
  uploadedBy     String
  uploadedAt     DateTime
  updatedAt      DateTime
}
```

---

## File Storage Structure

Files are organized in R2 by organization and category:

```
careaccess-documents/
├── org-{orgId}/
│   ├── photo/
│   │   ├── child-{childId}/
│   │   │   └── {uuid}.jpg
│   │   └── {uuid}.png
│   ├── medical/
│   │   ├── child-{childId}/
│   │   │   └── {uuid}.pdf
│   ├── legal/
│   ├── education/
│   ├── case_note/
│   ├── report/
│   └── import/
│       └── {uuid}.csv
```

---

## Security Features

### 1. File Type Validation
Only allowed file types:
- **Images:** jpg, jpeg, png, gif, webp
- **Documents:** pdf, doc, docx, xls, xlsx, csv, txt
- **Archives:** zip

### 2. File Size Limit
- Maximum: **50MB** per file

### 3. Signed URLs
- Download URLs expire after **1 hour**
- Prevents unauthorized access
- No direct public access to files

### 4. Multi-tenant Isolation
- Files scoped to organization
- Users can only access their org's files
- Enforced at API and database level

---

## Next Steps

### 1. Run Database Migration
```bash
cd services/api
npx prisma migrate dev --name add_document_management
```

### 2. Test the API
```bash
# Start the API
npm run start:dev

# Upload a test file
curl -X POST http://localhost:3000/documents/upload \
  -H "Authorization: Bearer <your-token>" \
  -F "file=@test-photo.jpg" \
  -F "category=photo" \
  -F "description=Test photo" \
  -F "childId=<child-uuid>"
```

### 3. Add to Railway
Make sure these environment variables are set in Railway:
```bash
R2_ACCOUNT_ID=c854bec2c9a8d7f65c5171d247e1385b
R2_ACCESS_KEY_ID=1c691edfeba3c8db1135f45482de2be9
R2_SECRET_ACCESS_KEY=bc02f7dcbc48741b2a3bef80a59aaa96ed1bedff9c4b957833aab507a5207d0e
R2_S3_URL=https://c854bec2c9a8d7f65c5171d247e1385b.r2.cloudflarestorage.com
R2_BUCKET_NAME=careaccess-documents
```

### 4. Build Flutter UI (Next Task)
- File picker
- Upload progress
- Image preview
- Document list

---

## Cost Estimate

Based on your usage:

### Year 1 (100 users, 50GB storage, 500GB downloads/month)
```
Storage:    50GB × $0.015 = $0.75/month
Operations: ~1M reads × $0.36/1M = $0.36/month
Egress:     $0 (FREE!)
Total:      ~$1/month = $12/year
```

### Year 2 (500 users, 200GB storage, 2TB downloads/month)
```
Storage:    200GB × $0.015 = $3.00/month
Operations: ~5M reads × $0.36/1M = $1.80/month
Egress:     $0 (FREE!)
Total:      ~$5/month = $60/year
```

**Compare to Supabase:** $600-1,200/year  
**Savings:** $540-1,140/year 💰

---

## Files Created

### Backend (NestJS)
1. `services/api/src/storage/storage.service.ts` - R2 integration
2. `services/api/src/storage/storage.module.ts` - Storage module
3. `services/api/src/documents/documents.service.ts` - Document business logic
4. `services/api/src/documents/documents.controller.ts` - REST API endpoints
5. `services/api/src/documents/documents.module.ts` - Documents module
6. `services/api/src/documents/dto/upload-document.dto.ts` - DTOs

### Database
7. `services/api/prisma/schema.prisma` - Updated with Document model

### Documentation
8. `docs/STORAGE_COMPARISON.md` - R2 vs Supabase comparison
9. `docs/R2_STORAGE_SETUP.md` - This file

---

## Testing Checklist

- [ ] Run database migration
- [ ] Start API server
- [ ] Upload a photo (jpg/png)
- [ ] Upload a PDF document
- [ ] Get all documents
- [ ] Get documents filtered by childId
- [ ] Download a document (verify signed URL works)
- [ ] Delete a document
- [ ] Verify file is deleted from R2
- [ ] Test file size limit (try uploading 51MB file)
- [ ] Test file type validation (try uploading .exe file)

---

## Troubleshooting

### Error: "Missing required R2 configuration"
- Check that all R2 environment variables are set in `.env`
- Restart the API server after adding variables

### Error: "File type not allowed"
- Check the `ALLOWED_MIMETYPES` in `storage.service.ts`
- Add new file types if needed

### Error: "Failed to upload file"
- Check R2 credentials are correct
- Verify bucket name is correct
- Check Cloudflare R2 dashboard for errors

### Signed URLs not working
- Check that R2_S3_URL is correct
- Verify bucket has public access disabled (we use signed URLs)
- Check URL hasn't expired (1 hour default)

---

## What's Next?

1. **Run the migration** to create the documents table
2. **Test the API** with Postman or curl
3. **Build Flutter UI** for file upload/download
4. **Add image optimization** (optional - resize/compress photos)
5. **Add virus scanning** (optional - ClamAV integration)

---

*Last Updated: January 14, 2026*

