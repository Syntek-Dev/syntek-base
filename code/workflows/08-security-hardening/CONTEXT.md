# Workflow: Security Hardening

Security findings are cheapest to fix while the feature is still open. A standing pass over
A01-A10 exists so hardening is a scheduled step rather than something remembered under release
pressure.

## Directory Tree

```text
code/workflows/08-security-hardening/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when:

- Completing a security audit on an existing feature
- Preparing for a release and need a security pass
- A security issue has been identified in a bug report

## Key concepts

- **OWASP A01–A10** is the baseline this pass walks in order, and **NIST SP 800-63B** governs
  authentication, password policy and MFA (`code/docs/security/OWASP-AND-CHECKLIST.md`)
- **A01 is the one that bites most often**: an explicit permission check on every state-changing
  Django Ninja endpoint, with ownership verified against the caller — a valid ID belonging to
  someone else is the whole of IDOR
- **`DEBUG=False` and an explicit CORS allowlist are production-only traps.** Both are
  indistinguishable from a correct configuration in dev, and differ only where it matters
  (`.claude/CLAUDE.md` Section 6 owns both as non-negotiables)

## Cross-references

### Governing documents

- `code/docs/security/AUTH-AND-AUTHZ.md` — authentication, authorisation, permission checks, anti-enumeration
- `code/docs/security/OWASP-AND-CHECKLIST.md` — OWASP Top 10 baseline and the pre-release checklist

### Upstream — the PM-layer counterpart

- `project-management/workflows/10-security-checks/` — the **design-stage** threat model
  (STRIDE + OWASP + NIST CSF) whose findings this workflow verifies in built code. Read the
  story's `src/10-SECURITY/` artefacts before auditing: they name what was supposed to be built.
- Entered from `project-management/workflows/19-api-code/` once mutating endpoints exist, or as
  a release gate (`23-release/`) or a reported-issue pass.
- `project-management/workflows/21-implementation-documentation/` — writes the post-build audit
  record that closes the `PLANNING/` artefact; do not write it here.

### Related reading

- `code/docs/security/INPUT-AND-API.md` — input validation, Django Ninja hardening, file upload security
- `code/docs/security/SUPPLY-CHAIN.md` — dependency and supply chain security
- `code/docs/SECURITY.md` — full security rules (thin index)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — field-level encryption for PII
- `code/docs/rls/TESTING-AND-AUDIT.md` — RLS policy testing and new module checklist
- `code/docs/logging/DJANGO-LOGGING.md` — security event logging configuration
- `code/docs/logging/FRONTEND-LOGGING.md` — frontend security event logging
- `code/docs/testing/ADVANCED-TESTING.md` — security and property-based test coverage
- `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — where edge-enforced controls (headers, TLS, body-size, CF/CF-Tunnel) are specified as the deploy contract for `<%DEPLOY_REPO%>`
