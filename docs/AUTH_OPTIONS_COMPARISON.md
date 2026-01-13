# Authentication Options for CareAccess

## Current State (Railway-Only)

✅ **Email + Password** (bcrypt hashed)  
✅ **JWT access tokens** (15 min expiry)  
✅ **JWT refresh tokens** (7 day expiry)  
✅ **Password change** endpoint  

---

## Auth Methods You Can Add (Railway-Only)

### 1. Multi-Factor Authentication (MFA) ⭐ **RECOMMENDED**

**What**: TOTP codes from Google Authenticator, Authy, 1Password

**Why**: 
- ✅ Required for SOC 2 / HIPAA compliance
- ✅ Expected by county/state partners
- ✅ Prevents unauthorized access

**Implementation**: 2-3 days  
**Libraries**: `speakeasy`, `qrcode`  
**Guide**: See `ADD_MFA_TO_RAILWAY.md`

---

### 2. Magic Links (Passwordless Email)

**What**: Click email link to login (no password needed)

**Why**:
- ✅ Better UX for mobile users
- ✅ No password to remember
- ✅ Reduces support burden

**Implementation**: 1-2 days  
**How**:
1. User enters email
2. System sends one-time login link (JWT in URL)
3. Click link → auto-login
4. Token expires after 15 minutes

**Example**:
```
https://app.careaccess.com/auth/verify?token=eyJhbGci...
```

---

### 3. SSO / SAML (Enterprise)

**What**: Login with Google Workspace, Microsoft Azure AD, Okta

**Why**:
- ✅ Required by large nonprofits
- ✅ Required by county/state partners
- ✅ Centralized user management

**Implementation**: 3-5 days per provider  
**Libraries**: `passport-saml`, `passport-google-oauth20`, `passport-azure-ad`

**Providers**:
- Google Workspace (most common for nonprofits)
- Microsoft Azure AD (government agencies)
- Okta (enterprise)

---

### 4. Social Login

**What**: Login with Google, Microsoft, Apple

**Why**:
- ✅ Faster signup
- ✅ Familiar UX
- ✅ No password to manage

**Implementation**: 1-2 days per provider  
**Libraries**: Passport.js OAuth strategies

**Providers**:
- Google (most common)
- Microsoft (enterprise)
- Apple (iOS requirement for App Store)

---

### 5. API Keys (for integrations)

**What**: Generate API keys for programmatic access

**Why**:
- ✅ ExtendedReach sync
- ✅ Report generation
- ✅ Third-party integrations

**Implementation**: 1 day  
**How**:
1. User generates API key in settings
2. Key is hashed and stored in database
3. Use key in `Authorization: Bearer <api-key>` header

---

### 6. Email Verification

**What**: Verify email address before allowing login

**Why**:
- ✅ Prevents fake accounts
- ✅ Ensures valid contact info
- ✅ Required for password reset

**Implementation**: 1 day  
**How**:
1. Send verification email on signup
2. User clicks link to verify
3. Account activated

---

### 7. Password Reset

**What**: Reset forgotten password via email

**Why**:
- ✅ User convenience
- ✅ Reduces support burden
- ✅ Standard feature

**Implementation**: 1 day  
**How**:
1. User requests password reset
2. System sends reset link (JWT in URL)
3. User sets new password
4. Token expires after 1 hour

---

## What Supabase Gives You (Out of the Box)

If you switch to **Supabase Auth**:

✅ Email + Password  
✅ Magic Links  
✅ Social Login (Google, GitHub, Facebook, etc.)  
✅ Phone/SMS  
✅ SAML SSO (Enterprise plan)  
✅ MFA (TOTP)  
✅ Email verification  
✅ Password reset flows  
✅ Session management  
✅ Admin UI for user management  
✅ Rate limiting  
✅ Captcha integration  

**But**: You'd need to refactor your auth system.

---

## Recommended Auth Roadmap for CareAccess

### Phase 1 (Now): Core Security ⭐

**Priority**: High  
**Timeline**: 1 week

1. ✅ **Email + Password** (you have this)
2. ✅ **MFA (TOTP)** - 2-3 days
3. ✅ **Email verification** - 1 day
4. ✅ **Password reset** - 1 day

**Why**: Covers 95% of nonprofit use cases and meets compliance requirements.

---

### Phase 2 (3-6 months): Enterprise Features

**Priority**: Medium  
**Timeline**: 2 weeks

1. ✅ **Google Workspace SSO** - 3 days
2. ✅ **Microsoft Azure AD SSO** - 3 days
3. ✅ **API Keys** - 1 day

**Why**: Required for county/state partners and large nonprofits.

---

### Phase 3 (6-12 months): UX Improvements

**Priority**: Low  
**Timeline**: 1 week

1. ✅ **Magic Links** - 2 days
2. ✅ **Social Login (Google)** - 1 day
3. ✅ **Social Login (Microsoft)** - 1 day

**Why**: Better UX, faster signup, reduced support burden.

---

## Cost Comparison

### Railway-Only (DIY Auth)

| Feature | Cost | Implementation |
|---------|------|----------------|
| Email + Password | Free | ✅ Done |
| MFA | Free | 2-3 days |
| Email Verification | Free | 1 day |
| Password Reset | Free | 1 day |
| SSO (per provider) | Free | 3-5 days |
| **Total** | **$0/mo** | **1-2 weeks** |

### Supabase Auth

| Feature | Cost | Implementation |
|---------|------|----------------|
| All auth methods | $25/mo (Pro) | 2-4 weeks refactor |
| SAML SSO | $599/mo (Enterprise) | Included |
| **Total** | **$25-599/mo** | **2-4 weeks** |

---

## My Recommendation

### For CareAccess Right Now

**Use Railway-Only + Add MFA**

**Reasons**:
1. ✅ You already have email + password
2. ✅ MFA is critical for compliance
3. ✅ Total cost: $0/mo
4. ✅ Implementation: 1 week
5. ✅ Full control over auth logic

**Next Steps**:
1. Add MFA (2-3 days) - see `ADD_MFA_TO_RAILWAY.md`
2. Add email verification (1 day)
3. Add password reset (1 day)
4. Deploy to production

---

### When to Add SSO

Add SSO when you have:
- ✅ A customer that requires it (county/state partner)
- ✅ 10+ users at a single organization
- ✅ Enterprise sales opportunity

**Don't build it until you need it** - focus on core features first.

---

### When to Consider Supabase Auth

Consider Supabase when:
- ✅ You have 10+ organizations
- ✅ You want self-serve signup
- ✅ You're tired of maintaining auth code
- ✅ You need SAML SSO for multiple customers

**Migration path**: Keep NestJS API, just swap auth provider.

---

## Summary

| Auth Method | Priority | Timeline | Cost |
|-------------|----------|----------|------|
| Email + Password | ✅ Done | - | Free |
| **MFA (TOTP)** | ⭐ **High** | 2-3 days | Free |
| Email Verification | High | 1 day | Free |
| Password Reset | High | 1 day | Free |
| Google SSO | Medium | 3 days | Free |
| Azure AD SSO | Medium | 3 days | Free |
| Magic Links | Low | 2 days | Free |
| Social Login | Low | 1-2 days | Free |
| API Keys | Low | 1 day | Free |

**Total for Phase 1**: 1 week, $0/mo

---

**Bottom line**: You have solid auth now. Add MFA this week for compliance, then add SSO when customers ask for it. No need for Supabase Auth unless you want to outsource auth maintenance.

