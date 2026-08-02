# Workflow: GDPR Enforcement

## Directory Tree

```text
code/workflows/06-gdpr-enforcement/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing GDPR requirements in code — any feature that
collects, processes, or stores personal data. This is the code-level implementation
workflow; the compliance review happens first in
`project-management/workflows/08-gdpr-compliance/`.

## Prerequisites

- [ ] GDPR compliance review in `project-management/workflows/08-gdpr-compliance/` is complete
- [ ] Data flows are understood and documented in `project-management/src/08-GDPR/DATA-INVENTORY.md`
- [ ] Feature implementation is in place

## Key concepts

- PII fields must be encrypted at rest — see `code/docs/encryption/FIELD-ENCRYPTION.md`
- Consent must be verified before any PII is accessed in a resolver
- Deletion functions must anonymise rather than hard-delete where audit trails are required
- No PII in log output or error responses
- DSAR (Data Subject Access Request) deletion must be testable end-to-end

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/encryption/FIELD-ENCRYPTION.md` — PII fields must be encrypted at rest; AES-256-GCM (CLAUDE.md §6)
- `code/docs/encryption/LOOKUP-TOKENS.md` — unique-field lookup tokens required alongside encryption (email, phone)
- `project-management/workflows/08-gdpr-compliance/` — compliance review must be complete before entering this workflow

### Soft references — consult during execution

- `code/docs/security/AUTH-AND-AUTHZ.md` — permission and IDOR requirements
- `project-management/src/08-GDPR/` — live GDPR documentation
- `code/docs/rls/MIDDLEWARE-AND-NINJA.md` — RLS is GDPR-relevant for multi-tenant data
- `code/docs/logging/DJANGO-LOGGING.md` — no PII in log output or error responses (CLAUDE.md §6)
