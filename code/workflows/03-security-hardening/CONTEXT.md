# Workflow: Security Hardening

> **Agent hints — Model:** Opus · **MCP:** `code-review-graph`, `docfork` + `context7` (OWASP, Django security)

## Directory Tree

```text
code/workflows/03-security-hardening/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when:

- Completing a security audit on an existing feature
- Preparing for a release and need a security pass
- A security issue has been identified in a bug report

## Prerequisites

- [ ] Feature code is implemented and tests are green
- [ ] `code/docs/SECURITY.md` has been read

## Key concepts

- OWASP A01–A10 are the security baseline — all must be addressed
- NIST SP 800-63B governs authentication, password policy, and MFA requirements
- Every GraphQL mutation must verify permissions explicitly
- User-supplied IDs must be validated against caller ownership
- `DEBUG=False` enforced in all non-local environments
- CORS `ALLOWED_ORIGINS` must be explicit — never `*` in production

## Cross-references

- `code/docs/SECURITY.md` — full security rules
