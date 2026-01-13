# Architecture Decision: Railway vs Supabase for CareAccess

## Decision: **Railway-Only (Phase 1)** → **Evaluate Supabase (Phase 2)**

---

## Current State (What You Have)

✅ **NestJS API** with Prisma ORM  
✅ **Multi-tenancy** enforced in application layer  
✅ **JWT authentication** with refresh tokens  
✅ **Role-based access control** (admin, user, manager, superadmin)  
✅ **Audit logging** for compliance  
✅ **SuperAdmin isolation** (`organizationId = null`)  
✅ **Railway deployment** configured and working  
✅ **Defense-in-depth security** (database + guards + middleware)  

**Status**: Production-ready for initial customers

---

## Phase 1: Railway-Only (Recommended for Now)

### Why Railway-Only?

1. **Already Built**: Your entire stack is designed for Railway
2. **No Refactoring**: Switching to Supabase requires rewriting auth, guards, data access
3. **Faster to Market**: Deploy what you have, get customers, iterate
4. **Full Control**: Own your auth logic, RBAC, tenant isolation
5. **Simpler Ops**: One platform for everything

### Architecture

```
┌─────────────────────────────────────────────────┐
│                   Railway                        │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐  ┌──────────────┐            │
│  │  NestJS API  │  │    Worker    │            │
│  │  (Port 3001) │  │   Service    │            │
│  └──────┬───────┘  └──────┬───────┘            │
│         │                  │                     │
│         └────────┬─────────┘                     │
│                  │                               │
│         ┌────────▼─────────┐                    │
│         │  PostgreSQL 15   │                    │
│         │  (Managed)       │                    │
│         └──────────────────┘                    │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Security Layers

1. **Database**: `organizationId` on every tenant table
2. **Guards**: `RequireOrganizationGuard` blocks cross-tenant access
3. **Middleware**: Prisma middleware scopes queries
4. **RLS** (optional): Add Postgres RLS for extra protection

### What You Need to Add

✅ **Postgres RLS** (see `POSTGRES_RLS_GUIDE.md`)  
✅ **Document storage** (S3/R2 + signed URLs)  
✅ **Monitoring** (Sentry, LogRocket, or Railway logs)  
✅ **Backups** (Railway automatic + manual exports)  

---

## Phase 2: Evaluate Supabase (Later)

### When to Consider Supabase

- ✅ You have 10+ organizations
- ✅ You need self-serve signup
- ✅ You want built-in Auth UI
- ✅ You need document storage with access policies
- ✅ You want realtime features
- ✅ You're pursuing SOC 2 / HIPAA compliance

### Hybrid Architecture (Best of Both)

```
┌─────────────────────────────────────────────────┐
│                   Railway                        │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐  ┌──────────────┐            │
│  │  NestJS API  │  │    Worker    │            │
│  │  (Business   │  │   (Reports,  │            │
│  │   Logic)     │  │    Sync)     │            │
│  └──────┬───────┘  └──────┬───────┘            │
│         │                  │                     │
│         └────────┬─────────┘                     │
│                  │                               │
└──────────────────┼───────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                 Supabase                         │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐  ┌──────────────┐            │
│  │  PostgreSQL  │  │     Auth     │            │
│  │   + RLS      │  │  (JWT/SSO)   │            │
│  └──────────────┘  └──────────────┘            │
│                                                  │
│  ┌──────────────┐  ┌──────────────┐            │
│  │   Storage    │  │   Realtime   │            │
│  │  (Documents) │  │  (Optional)  │            │
│  └──────────────┘  └──────────────┘            │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Migration Path

1. **Keep NestJS API on Railway** (business logic, integrations)
2. **Move Postgres to Supabase** (change connection string)
3. **Optionally use Supabase Auth** (or keep your JWT system)
4. **Use Supabase Storage** for documents
5. **Use Supabase RLS** (easier management than raw SQL)

**Key**: This is a **gradual migration**, not a rewrite.

---

## Comparison Table

| Feature | Railway-Only | Railway + Supabase |
|---------|--------------|-------------------|
| **Time to Deploy** | ✅ Ready now | ⚠️ 2-4 weeks refactor |
| **Auth** | Custom JWT | Supabase Auth (easier) |
| **Multi-tenancy** | App-layer + RLS | RLS + Auth claims |
| **Document Storage** | S3/R2 | Supabase Storage |
| **Realtime** | Custom WebSockets | Built-in |
| **Admin UI** | Custom | Supabase Studio |
| **Cost (10 orgs)** | ~$50/mo | ~$75/mo |
| **Control** | ✅ Full | ⚠️ Some vendor lock-in |
| **Complexity** | Medium | Low (for DB/Auth) |

---

## My Recommendation

### For CareAccess Right Now

**Use Railway-Only** because:

1. ✅ You're already built for it
2. ✅ You can ship to customers **this week**
3. ✅ Your security is already strong
4. ✅ You can add RLS in 1 day
5. ✅ You maintain full control

### Add These to Railway-Only

1. **Postgres RLS** (see guide) - 1 day
2. **Document storage** (S3/R2) - 2 days
3. **Monitoring** (Sentry) - 1 day
4. **Automated backups** - 1 day

**Total**: 1 week to production-hardened

### When to Revisit Supabase

- ✅ After 10+ organizations
- ✅ When you need self-serve signup
- ✅ When you want to reduce auth maintenance
- ✅ When you're pursuing SOC 2 compliance

---

## Action Plan (Next 7 Days)

### Day 1-2: Add RLS to Railway Postgres
- [ ] Create RLS migration
- [ ] Add RLS interceptor
- [ ] Test cross-tenant isolation

### Day 3-4: Add Document Storage
- [ ] Set up S3/R2 bucket
- [ ] Add signed URL generation
- [ ] Test upload/download

### Day 5: Add Monitoring
- [ ] Set up Sentry
- [ ] Add error tracking
- [ ] Add performance monitoring

### Day 6: Add Backups
- [ ] Configure Railway automatic backups
- [ ] Set up manual backup script
- [ ] Test restore process

### Day 7: Deploy to Production
- [ ] Run final security audit
- [ ] Deploy to Railway
- [ ] Test with first customer

---

## Final Answer

**Use Railway-Only for Phase 1**. You're production-ready now with strong multi-tenancy. Add RLS for extra security, then ship to customers.

**Evaluate Supabase for Phase 2** when you have 10+ organizations and want to reduce auth/storage maintenance.

---

## Questions to Ask Yourself

1. **Do I need to ship this month?** → Railway-Only
2. **Do I want self-serve signup in v1?** → Consider Supabase
3. **Do I need document storage now?** → S3/R2 (Railway) or Supabase Storage
4. **Am I comfortable managing auth?** → Yes = Railway, No = Supabase
5. **Do I want maximum control?** → Railway-Only

---

**My vote**: Railway-Only + RLS. Ship fast, iterate, migrate to Supabase later if needed.

