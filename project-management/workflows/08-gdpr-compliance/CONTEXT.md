# Workflow: GDPR Compliance Review

**Last Updated**: {{DATE}}

## Directory Tree

```text
project-management/workflows/08-gdpr-compliance/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when:

- A new feature collects, processes, or stores personal data
- Preparing for a release that touches user data
- Responding to a data subject request

## Prerequisites

- [ ] Feature is implemented and the data flows are understood

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/gdpr/DATA-RIGHTS.md` — lawful basis check is blocking; right to erasure, SAR, data portability, consent management
- `project-management/docs/gdpr/COMPLIANCE.md` — retention rules are blocking; retention tasks, encryption at rest, audit logging, breach notification

### Downstream — the code-layer counterpart

- `code/workflows/05-gdpr-enforcement/` — **enforces in code what this workflow specifies**:
  field encryption, consent gating, anonymising deletion, DSAR support. It names this review as
  a hard prerequisite and will not start until it is complete. Obligations are specified here
  and enforced there — keep the two consistent.
- `project-management/workflows/19-implementation-documentation/` — writes the
  `GDPR-IMPL-US###-*.md` record that closes this workflow's `PLANNING/` artefact.

### Soft references — consult during execution

- `project-management/src/08-GDPR/` — live GDPR documentation
- `project-management/src/04-USER-FLOW/` — data touchpoints annotated in flows
- `project-management/docs/GDPR-GUIDE.md` — thin index for all GDPR docs
- `code/docs/encryption/FIELD-ENCRYPTION.md` — field-level encryption requirements for PII storage
- `code/docs/security/AUTH-AND-AUTHZ.md` — data access controls and IDOR prevention
- `code/docs/logging/DJANGO-LOGGING.md` — no PII in log output or error responses
