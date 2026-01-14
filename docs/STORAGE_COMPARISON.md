# Storage Solution Comparison: Cloudflare R2 vs Supabase Storage

**Context:** CareAccess needs file storage for document management (child photos, case documents, reports, etc.)

**Current Infrastructure:** Railway (PostgreSQL + NestJS API)

---

## Quick Recommendation

### 🏆 **Cloudflare R2** (Recommended)

**Why:**
- ✅ **Zero egress fees** (Supabase charges for downloads)
- ✅ **S3-compatible** (easy to migrate later if needed)
- ✅ **Simpler architecture** (just storage, not a whole backend)
- ✅ **Better pricing** at scale
- ✅ **Works perfectly with Railway**
- ✅ **No vendor lock-in** (S3-compatible)

**Use Cloudflare R2 if:**
- You want the cheapest option long-term ✅
- You already have Railway for database/API ✅ (you do!)
- You want S3 compatibility ✅
- You need to serve lots of files (photos, documents) ✅

---

## Detailed Comparison

### Cloudflare R2

#### Pros
- ✅ **Zero egress fees** - Download files for free (huge savings)
- ✅ **S3-compatible API** - Use existing AWS SDK libraries
- ✅ **Cheap storage** - $0.015/GB/month (same as S3)
- ✅ **Fast global CDN** - Cloudflare's network
- ✅ **Simple** - Just storage, nothing else
- ✅ **No vendor lock-in** - Can migrate to S3/MinIO/etc.
- ✅ **Works with Railway** - No conflicts

#### Cons
- ❌ **No built-in image transformations** (need to do yourself)
- ❌ **No built-in access control** (need to implement in your API)
- ❌ **Separate service** (one more thing to manage)

#### Pricing
```
Storage:    $0.015/GB/month
Operations: $4.50 per million writes
            $0.36 per million reads
Egress:     $0 (FREE!)

Example (100 users, 10GB storage, 100K downloads/month):
- Storage: 10GB × $0.015 = $0.15/month
- Reads: 100K × $0.36/1M = $0.036/month
- Egress: $0 (FREE!)
Total: ~$0.20/month

Compare to S3:
- Storage: $0.15/month
- Egress: 10GB × $0.09 = $0.90/month
Total: ~$1.05/month (5x more expensive!)
```

#### Setup Complexity
```typescript
// 1. Install AWS SDK
npm install @aws-sdk/client-s3

// 2. Configure R2
const s3Client = new S3Client({
  region: 'auto',
  endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: process.env.R2_ACCESS_KEY_ID,
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY,
  },
});

// 3. Upload file
await s3Client.send(new PutObjectCommand({
  Bucket: 'careaccess-documents',
  Key: `children/${childId}/photo.jpg`,
  Body: fileBuffer,
  ContentType: 'image/jpeg',
}));

// 4. Generate signed URL (for secure downloads)
const url = await getSignedUrl(s3Client, new GetObjectCommand({
  Bucket: 'careaccess-documents',
  Key: `children/${childId}/photo.jpg`,
}), { expiresIn: 3600 });
```

**Setup Time:** 30 minutes

---

### Supabase Storage

#### Pros
- ✅ **Built-in access control** (Row Level Security)
- ✅ **Image transformations** (resize, crop, optimize)
- ✅ **Integrated with Supabase** (if you use Supabase DB)
- ✅ **Nice dashboard** (easy to browse files)
- ✅ **Automatic backups** (if on paid plan)

#### Cons
- ❌ **Egress fees** - $0.09/GB for downloads (expensive!)
- ❌ **Vendor lock-in** - Harder to migrate away
- ❌ **More expensive** at scale
- ❌ **Overkill** if you don't use Supabase for database
- ❌ **Another service** to manage (you already have Railway)

#### Pricing
```
Free Tier:
- 1GB storage
- 2GB egress/month
- Then $0.021/GB storage + $0.09/GB egress

Pro Plan ($25/month):
- 100GB storage included
- 200GB egress included
- Then $0.125/GB storage + $0.09/GB egress

Example (100 users, 10GB storage, 100GB downloads/month):
Free Tier:
- Storage: 9GB × $0.021 = $0.19/month
- Egress: 98GB × $0.09 = $8.82/month
Total: ~$9/month

Pro Plan ($25/month):
- Included in plan
Total: $25/month
```

#### Setup Complexity
```typescript
// 1. Install Supabase client
npm install @supabase/supabase-js

// 2. Configure Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

// 3. Upload file
const { data, error } = await supabase.storage
  .from('documents')
  .upload(`children/${childId}/photo.jpg`, fileBuffer, {
    contentType: 'image/jpeg',
    upsert: true,
  });

// 4. Get public URL
const { data: { publicUrl } } = supabase.storage
  .from('documents')
  .getPublicUrl(`children/${childId}/photo.jpg`);
```

**Setup Time:** 20 minutes (slightly easier)

---

## Feature Comparison Matrix

| Feature | Cloudflare R2 | Supabase Storage |
|---------|---------------|------------------|
| **Storage Cost** | $0.015/GB | $0.021/GB (free) / $0.125/GB (pro) |
| **Egress Cost** | $0 (FREE!) | $0.09/GB |
| **S3 Compatible** | ✅ Yes | ❌ No |
| **Image Transforms** | ❌ No | ✅ Yes |
| **Access Control** | Manual (in your API) | Built-in (RLS) |
| **CDN** | ✅ Cloudflare | ✅ Included |
| **Dashboard** | Basic | ✅ Nice UI |
| **Vendor Lock-in** | ❌ No (S3 API) | ⚠️ Yes |
| **Works with Railway** | ✅ Perfect | ✅ Yes |
| **Setup Complexity** | Medium | Easy |
| **Migration Path** | Easy (S3 compatible) | Hard (proprietary) |

---

## Cost Comparison at Scale

### Scenario: 500 users, 100GB storage, 1TB downloads/month

**Cloudflare R2:**
```
Storage: 100GB × $0.015 = $1.50/month
Reads: 1M × $0.36/1M = $0.36/month
Egress: $0 (FREE!)
Total: ~$2/month
```

**Supabase Storage (Pro Plan):**
```
Base: $25/month
Storage: Included (100GB)
Egress: 800GB × $0.09 = $72/month
Total: ~$97/month
```

**Savings with R2: $95/month = $1,140/year** 💰

---

## Recommendation for CareAccess

### Use **Cloudflare R2** ✅

**Reasons:**
1. **You're already on Railway** - No need for Supabase
2. **Zero egress fees** - Huge savings as you scale
3. **S3-compatible** - Easy to migrate if needed
4. **Simple** - Just storage, nothing else
5. **Cheaper** - 50x cheaper at scale

### Implementation Plan

#### Phase 1: Basic Setup (1 day)
1. Create Cloudflare account
2. Create R2 bucket: `careaccess-documents`
3. Generate API keys
4. Add to Railway environment variables

#### Phase 2: NestJS Integration (2 days)
1. Install `@aws-sdk/client-s3`
2. Create `StorageService` in NestJS
3. Add upload/download endpoints
4. Implement signed URLs for security

#### Phase 3: Flutter Integration (2 days)
1. Add file picker
2. Upload to API endpoint
3. Display images from signed URLs
4. Add progress indicators

**Total Time: 5 days**

---

## When to Use Supabase Instead

Use Supabase Storage if:
- ❌ You're already using Supabase for database (you're not - you use Railway)
- ❌ You need built-in image transformations (you can do this yourself)
- ❌ You have < 100 users and low download volume (you're planning to scale)
- ❌ You want the easiest setup (R2 is only slightly harder)

**None of these apply to CareAccess** → Use R2

---

## Alternative: Railway Volumes (Not Recommended)

Railway also supports persistent volumes, but:
- ❌ **Not designed for file storage** (meant for databases)
- ❌ **No CDN** (slow downloads)
- ❌ **No redundancy** (single point of failure)
- ❌ **Expensive** ($0.25/GB/month vs $0.015/GB for R2)
- ❌ **Not scalable** (limited to single region)

**Don't use Railway volumes for file storage.**

---

## Next Steps

### 1. Set Up Cloudflare R2 (30 minutes)
```bash
# 1. Go to Cloudflare Dashboard
https://dash.cloudflare.com/

# 2. Navigate to R2
Click "R2" in sidebar

# 3. Create Bucket
- Name: careaccess-documents
- Location: Automatic (global)

# 4. Generate API Token
- Click "Manage R2 API Tokens"
- Create API Token
- Permissions: Read & Write
- Copy Access Key ID and Secret Access Key
```

### 2. Add to Railway Environment Variables
```bash
R2_ACCOUNT_ID=your-account-id
R2_ACCESS_KEY_ID=your-access-key
R2_SECRET_ACCESS_KEY=your-secret-key
R2_BUCKET_NAME=careaccess-documents
R2_PUBLIC_URL=https://pub-xxxxx.r2.dev
```

### 3. Install Dependencies
```bash
cd services/api
npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner
```

### 4. Create Storage Service
I can help you build this! Just say the word.

---

## Conclusion

**Use Cloudflare R2** for CareAccess because:
- ✅ Zero egress fees = massive savings
- ✅ S3-compatible = no vendor lock-in
- ✅ Works perfectly with Railway
- ✅ Simple and scalable
- ✅ 50x cheaper than Supabase at scale

**Estimated Cost:**
- **Year 1:** ~$5-10/month
- **Year 2 (500 users):** ~$20-30/month
- **vs Supabase:** $300-500/month

**Savings: $3,000-5,000/year** 💰

---

*Last Updated: January 14, 2026*

