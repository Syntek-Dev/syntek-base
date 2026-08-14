---
name: security
description: >-
  Audit and harden <%PROJECT_NAME%> against OWASP, NIST and UK Cyber Essentials — access
  control and IDOR, enumeration defence, irreversible routing, security headers, rate limiting,
  and enforcement of the PII rules. Load for a security review of built code, a threat model
  before it is built, or hardening after a finding. Not building login, MFA or session handling
  (`authentication`), not designing lawful basis, retention or consent — this enforces what
  `gdpr-mechanics` designs — and not the hostile break-it pass it dispatches (`qa-tester`).
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-htmx-templates
---

# Security Audit and Hardening (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the assets, trust boundaries and abuse cases that scope an
audit are settled in the conversation, and the peer audit and QA passes are dispatched).

**This skill enforces; it does not restate.** `code/docs/SECURITY.md` and its sub-documents own
every control below — read them rather than working from memory, and add a rule there rather
than here.

**Policy decisions on _who_ should have access are surfaced to <%DEVELOPER_NAME%>**, never
decided in an audit.

---

## Open with a grilling pass

Settle the **assets** worth protecting, the **trust boundaries** between them, the **roles**,
the **STRIDE surface**, and the **abuse cases** before any audit or hardening plan. The
`grilling` skill owns the round shape (`.claude/CLAUDE.md` Section 10).

## The baselines an audit is held to

A finding that fails any of these is **release-blocking until triaged**: **OWASP Top 10 (2025)**
as the primary web-application risk baseline, with every finding mapped to a category; and the
NIST and Cyber Essentials baselines owned by `project-management/docs/SECURITY-GUIDE.md`, which
carries CSF 2.0's functions, SP 800-53's control families, SP 800-63B for authentication, and
the five CE technical controls with CE Plus's hands-on assessment.

## What this skill enforces

- **Access control is two checks, never one (A01).** A permission check answers _may this role
  act_; an ownership check answers _may this caller touch this row_. Both are required on every
  state-changing endpoint and on anything returning another user's data. **Role alone is never
  sufficient.** Ninja endpoints gate through a named Policy class; the server check is
  authoritative. Prefer **404 over 403** where the caller should not learn the resource exists,
  and log every authorisation failure.
- **The `/mcp/` FastMCP surface is audited separately, to the same standard.** It is mounted
  beside Django in `config/asgi.py`, so **no Django middleware runs** — no session, no
  `login_required`, no CSRF, no API throttle. Two checks are specific to it: identity comes from
  the verified token and **never** from a tool argument (a `user_id` parameter is an IDOR by
  construction, because the caller is a language model), and every state-changing tool calls the
  same named Policy as its Ninja twin. Threat model:
  `code/docs/mcp-server/AUTH-AND-THREATS.md`.
- **A slug is an identifier, not an access grant (A01/A04).** Match the identifier to the
  surface's exposure per `code/docs/URL-STRATEGY.md`: slugs on public marketing pages, UUIDv4 in
  the admin, slug **plus** a server-side ownership check in the portal, signed single-use tokens
  for one-time actions, and expiring signed URLs for downloads. **No sequential integer primary
  key ever appears in a public or portal URL.**
- **Misconfiguration (A05).** Security headers and the per-route-class rate limits are
  `code/docs/security/INPUT-AND-API.md`'s; the edge-enforced half — TLS, routing, body size and
  the header catalogue the edge sets — is the deploy contract in
  `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`. This repository specifies it; the
  `<%DEPLOY_REPO%>` repository implements it.
- **PII enforcement (A02, UK GDPR).** `gdpr-mechanics` designs the storage; this verifies it
  against `code/docs/ENCRYPTION-GUIDE.md` — hashed for lookup, encrypted for storage, lookups
  querying the hash column and never the plaintext, no PII in logs, error responses or
  serialised output, and every access permission-gated and audit-logged against the permission
  classes in `code/docs/security/AUTH-AND-AUTHZ.md`.

**Fast verification greps** — a first pass, never the whole audit:

```bash
# plaintext PII columns should not exist — expect only *_encrypted / *_hash
grep -rn "models.EmailField\|models.CharField" code/src/django/apps/*/models/ | grep -i "email\|phone"
# lookups must go through the hash column, never the raw value
grep -rn "\.filter(email=\|\.get(email=" code/src/django/
# PII must never reach the logger
grep -rn "logger\.\(info\|debug\|warning\).*email\|\.phone" code/src/django/
```

## The sequence

Phases 1, 2 and 4 are separate Agent tool calls to `general-purpose`, naming the skill to load.
**They dispatch separately so that no pass checks its own output.**

1. **Peer audit** — the `security` skill again, as a **separate dispatch from this run**.
   Cover access control, IDOR and enumeration, injection, PII at rest, misconfiguration
   (`DEBUG`, CORS, headers) and secret handling. Findings to
   `project-management/src/10-SECURITY/ASSESSMENTS/`.
2. **Hostile QA** — the `qa-tester` skill, **a separate dispatch from phase 1**, aimed at the
   attack surface: auth bypass, IDOR, enumeration through predictable IDs, privilege escalation,
   injection, and endpoints missing a Policy.
3. **Documentation** — no dispatch, and a hard gate before the commit. Update every
   `CONTEXT.md` a security change affects; confirm the phase-1 records landed in
   `ASSESSMENTS/` and `AUDITS/`; promote any reusable pattern into `code/docs/SECURITY.md`; add
   any Critical or High finding that cannot close in this change to `GAPS.md`, and any hardening
   deferred to a named future story to `DEFERRED.md`.
4. **Commit the hardening** — the `git` skill.

## Handoff

What this skill does **not** do, each a separate dispatch: implementing authentication or MFA
(`authentication`), building permission-management UI (`frontend`), writing the tests
(`test-writer`), and designing PII storage, lawful basis or retention (`gdpr-mechanics` — that
skill designs, this one enforces).

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/10-security-checks/` — the design-stage threat model
- `code/workflows/08-security-hardening/` — **the procedure of record** for auditing and
  hardening built code against OWASP A01–A10
- `code/workflows/06-gdpr-enforcement/` — when the surface touches personal data
- `code/workflows/05-mcp-server/` — auditing the `/mcp/` surface, which no Django middleware
  protects

## Cross-references

- `code/docs/SECURITY.md` — OWASP controls, permission checks, IDOR prevention
- `code/docs/security/INPUT-AND-API.md` — headers, throttling baselines, upload validation
- `code/docs/security/AUTH-AND-AUTHZ.md` — the authorisation and PII permission classes
- `code/docs/ENCRYPTION-GUIDE.md` · `code/docs/RLS-GUIDE.md` · `code/docs/URL-STRATEGY.md`
- `project-management/docs/SECURITY-GUIDE.md` — the frameworks, severities, and sign-off criteria
