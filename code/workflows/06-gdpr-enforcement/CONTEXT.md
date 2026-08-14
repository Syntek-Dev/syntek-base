# Workflow: GDPR Enforcement

Compliance decided on paper and compliance present in code are two different things, and only
the second one protects anybody. This workflow is where the obligations recorded in the PM
layer become encryption, consent gates, and erasure paths.

## Directory Tree

```text
code/workflows/06-gdpr-enforcement/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing GDPR requirements in code — any feature that
collects, processes, or stores personal data. This is the code-level implementation
workflow; the compliance review happens first in
`project-management/workflows/09-gdpr-compliance/`.

## Key concepts

- **Encryption at rest** is the baseline for a PII field, and a unique one needs a lookup token
  beside it or it becomes unsearchable (`code/docs/encryption/FIELD-ENCRYPTION.md`,
  `code/docs/encryption/LOOKUP-TOKENS.md`)
- **Consent is a precondition of access**, not a flag recorded at collection time — the gate sits
  where the data is read
- **Anonymisation and deletion are different remedies.** Where an audit trail has to survive, the
  erasure path anonymises; a hard delete would take the evidence with it
- **Logs and error responses are an exfiltration path** for PII as surely as an endpoint is
- **A DSAR is a deadline, not a feature.** Erasure and export count as compliant only when they
  can be demonstrated end to end, which is why they carry tests rather than a description

## Cross-references

### Governing documents

- `code/docs/encryption/FIELD-ENCRYPTION.md` — PII fields must be encrypted at rest; AES-256-GCM (CLAUDE.md Section 6)
- `code/docs/encryption/LOOKUP-TOKENS.md` — unique-field lookup tokens required alongside encryption (email, phone)
- `project-management/workflows/09-gdpr-compliance/` — compliance review must be complete before entering this workflow

### Related reading

- `code/docs/security/AUTH-AND-AUTHZ.md` — permission and IDOR requirements
- `project-management/src/09-GDPR/` — live GDPR documentation
- `code/docs/rls/MIDDLEWARE-AND-NINJA.md` — RLS is GDPR-relevant for multi-tenant data
- `code/docs/logging/DJANGO-LOGGING.md` — no PII in log output or error responses (CLAUDE.md Section 6)
