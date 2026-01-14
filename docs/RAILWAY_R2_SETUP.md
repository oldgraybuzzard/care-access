# Railway R2 Environment Variables Setup

## 🚀 Quick Setup

Add these environment variables to your Railway `@fcf/api` service:

### Required R2 Variables

```bash
R2_ACCOUNT_ID=c854bec2c9a8d7f65c5171d247e1385b
R2_ACCESS_KEY_ID=1c691edfeba3c8db1135f45482de2be9
R2_SECRET_ACCESS_KEY=bc02f7dcbc48741b2a3bef80a59aaa96ed1bedff9c4b957833aab507a5207d0e
R2_S3_URL=https://c854bec2c9a8d7f65c5171d247e1385b.r2.cloudflarestorage.com
R2_BUCKET_NAME=careaccess-documents
```

---

## 📋 Step-by-Step Instructions

### 1. Open Railway Dashboard
1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Select your project: **superb-quietude**
3. Click on the **@fcf/api** service

### 2. Add Environment Variables
1. Click on the **Variables** tab
2. Click **+ New Variable** for each variable below:

#### Variable 1: R2_ACCOUNT_ID
- **Name:** `R2_ACCOUNT_ID`
- **Value:** `c854bec2c9a8d7f65c5171d247e1385b`

#### Variable 2: R2_ACCESS_KEY_ID
- **Name:** `R2_ACCESS_KEY_ID`
- **Value:** `1c691edfeba3c8db1135f45482de2be9`

#### Variable 3: R2_SECRET_ACCESS_KEY
- **Name:** `R2_SECRET_ACCESS_KEY`
- **Value:** `bc02f7dcbc48741b2a3bef80a59aaa96ed1bedff9c4b957833aab507a5207d0e`

#### Variable 4: R2_S3_URL
- **Name:** `R2_S3_URL`
- **Value:** `https://c854bec2c9a8d7f65c5171d247e1385b.r2.cloudflarestorage.com`

#### Variable 5: R2_BUCKET_NAME
- **Name:** `R2_BUCKET_NAME`
- **Value:** `careaccess-documents`

### 3. Deploy
1. After adding all variables, Railway will automatically redeploy
2. Or click **Deploy** to trigger a new deployment

---

## ✅ Verification

Once deployed, test the document upload endpoint:

```bash
# Get your Railway API URL
RAILWAY_URL="https://fcfapi-production.up.railway.app"

# Test upload (replace with actual auth token)
curl -X POST $RAILWAY_URL/documents/upload \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "file=@test.jpg" \
  -F "category=photo" \
  -F "name=Test Photo"
```

---

## 🔒 Security Notes

1. **Never commit these values to git** - They're in `.env` which is gitignored
2. **Rotate keys regularly** - Generate new R2 API keys periodically
3. **Use Railway's secret variables** - They're encrypted at rest
4. **Limit R2 permissions** - The API key should only have access to the specific bucket

---

## 📊 Expected Costs

With these settings, your R2 costs will be:

- **Storage (50GB):** $0.75/month = $9/year
- **Egress:** $0 (R2 has zero egress fees!)
- **Operations:** ~$0 (10M free operations/month)

**Total:** ~$9/year vs $792/year with Supabase Storage (98% savings!)

---

## 🐛 Troubleshooting

### Build Still Failing?
- Check that all 5 variables are added correctly
- Verify no typos in variable names (case-sensitive!)
- Check Railway build logs for specific errors

### Upload Failing?
- Verify R2 bucket exists: `careaccess-documents`
- Check R2 API key has write permissions
- Verify S3 URL is correct for your account

### Can't Download Files?
- Check signed URL expiration (default: 1 hour)
- Verify R2 API key has read permissions
- Check CORS settings in R2 bucket

---

## 📚 Related Documentation

- [R2 Storage Setup Guide](./R2_STORAGE_SETUP.md)
- [Storage Cost Comparison](./STORAGE_COMPARISON.md)
- [Implementation Summary](./R2_IMPLEMENTATION_SUMMARY.md)

---

**Status:** Ready to deploy with R2 storage! 🎉

