# Workflow: Security Hardening

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
- Every state-changing Django Ninja endpoint must verify permissions explicitly
- User-supplied IDs must be validated against caller ownership
- `DEBUG=False` enforced in all non-local environments
- CORS `ALLOWED_ORIGINS` must be explicit — never `*` in production

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/security/AUTH-AND-AUTHZ.md` — authentication, authorisation, permission checks, anti-enumeration
- `code/docs/security/OWASP-AND-CHECKLIST.md` — OWASP Top 10 baseline and the pre-release checklist

### Upstream — the PM-layer counterpart

- `project-management/workflows/09-security-checks/` — the **design-stage** threat model
  (STRIDE + OWASP + NIST CSF) whose findings this workflow verifies in built code. Read the
  story's `src/09-SECURITY/` artefacts before auditing: they name what was supposed to be built.
- Entered from `project-management/workflows/17-api-code/` once mutating endpoints exist, or as
  a release gate (`21-release/`) or a reported-issue pass.
- `project-management/workflows/19-implementation-documentation/` — writes the post-build audit
  record that closes the `PLANNING/` artefact; do not write it here.

### Soft references — consult during execution

- `code/docs/security/INPUT-AND-API.md` — input validation, Django Ninja hardening, file upload security
- `code/docs/security/SUPPLY-CHAIN.md` — dependency and supply chain security
- `code/docs/SECURITY.md` — full security rules (thin index)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — field-level encryption for PII
- `code/docs/rls/TESTING-AND-AUDIT.md` — RLS policy testing and new module checklist
- `code/docs/logging/DJANGO-LOGGING.md` — security event logging configuration
- `code/docs/logging/FRONTEND-LOGGING.md` — frontend security event logging
- `code/docs/testing/ADVANCED-TESTING.md` — security and property-based test coverage
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — where edge-enforced controls (headers, TLS, body-size, CF/CF-Tunnel) are specified as the deploy contract for `<%DEPLOY_REPO%>`
