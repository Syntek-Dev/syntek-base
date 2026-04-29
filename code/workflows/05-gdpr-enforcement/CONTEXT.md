# Workflow: GDPR Enforcement

> **Agent hints — Model:** Opus · **MCP:** `code-review-graph`, `docfork` + `context7` (Django encryption, GDPR)

## Directory Tree

```text
code/workflows/05-gdpr-enforcement/
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

- PII fields must be encrypted at rest — see `code/docs/ENCRYPTION-GUIDE.md`
- Consent must be verified before any PII is accessed in a resolver
- Deletion functions must anonymise rather than hard-delete where audit trails are required
- No PII in log output or error responses
- DSAR (Data Subject Access Request) deletion must be testable end-to-end

## Cross-references

- `code/docs/ENCRYPTION-GUIDE.md` — field-level encryption patterns
- `code/docs/SECURITY.md` — permission and IDOR requirements
- `project-management/src/08-GDPR/` — live GDPR documentation
- `project-management/workflows/08-gdpr-compliance/` — the preceding PM-layer compliance review
