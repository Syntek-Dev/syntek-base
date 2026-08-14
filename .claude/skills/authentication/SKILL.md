---
name: authentication
description: >-
  Build <%PROJECT_NAME%>'s credential and session layer — password validation, MFA with TOTP
  and backup codes, session and token issuance and invalidation, brute-force lockout, and
  secure password reset, on Django's own auth framework. Load when a story needs login,
  registration, credential handling, or session plumbing. Not auditing the surface once it is
  built (`security`), not the login screens over it (`frontend`), not lawful basis or retention
  for auth PII (`gdpr-mechanics`), and not the delivery of a reset or MFA email
  (`notifications`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django
---

# Build the Auth Layer (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is the credential and
session layer).

> **Use Django's own auth.** Its authentication system, its configured password hasher
> (Argon2, then PBKDF2), and its session framework. **Never hand-roll crypto and never write a
> bespoke hasher** — the failure is silent and total.

---

## The brief arrives settled

The credential layer is expensive to get wrong, and a fork cannot ask. **These five must be in
the brief**, decided before dispatch:

1. **Session versus token** — a web session cookie, an API token, or both — and the lifetime of
   each.
2. **MFA scope** — every user, admins only, or optional.
3. **Registration model** — self-service or invite-only, and whether email verification is
   required.
4. **Lockout threshold and window.**
5. **Password-reset token TTL.**

**If any is missing, return and say so.** Choosing one here makes a security decision nobody
reviewed. Where they are still open, the pass is `grilling`, run inline before this skill is
dispatched — it inverts the usual proceed-by-default posture precisely because this layer is
the one that cannot be quietly corrected later.

## What to build

**Password security** — Django's validators, enforcing the floor in
`code/docs/security/AUTH-AND-AUTHZ.md`: at least 12 characters, common and breached passwords
rejected, similarity to the username rejected, all characters including Unicode and whitespace
accepted, and **never silently truncated**.

**MFA** — TOTP secrets encrypted at rest through the Fernet pipeline (they are long-lived
cryptographic secrets, `code/docs/encryption/FIELD-ENCRYPTION.md`), QR provisioning URIs for
enrolment, verification with a tolerance window either side of the current step, and
**single-use backup codes stored hashed, never encrypted** — they are credentials, not data.

**Sessions and tokens** — `HttpOnly`, `Secure` and `SameSite` cookies with the settings in
`AUTH-AND-AUTHZ.md` Section _Django Security Settings_; per-device and all-device invalidation; and
**session regeneration on every privilege change** — login, role change, password reset.

**Brute-force protection** — count failed attempts, lock out at the agreed threshold, clear the
counter on success, and answer with `429` plus a `Retry-After` header. The per-route baselines
are `code/docs/security/INPUT-AND-API.md` Section _Throttling_.

**Password reset** — cryptographically random single-use tokens, hashed at rest, short TTL,
**every session invalidated on completion**, and a uniform response whether or not the address
exists. That last one is anti-enumeration, and `AUTH-AND-AUTHZ.md` Section _Anti-Enumeration_ is its
owner: identical shapes across every authentication outcome, no exception class names, no
internal identifiers.

**Auth event logging** — every login, failure, lockout, reset and MFA change is an audit event.
**An IP address is personal data and is stored one-way hashed**, named for what it holds
(`code/docs/security/AUDIT-TRAIL.md`) — never in the clear, and never reversibly encrypted for
display.

## Definition of done

Passwords hashed by Django's configured hasher with the validation floor enforced; MFA
available, secrets encrypted, backup codes hashed and single-use; session cookies carrying all
three flags with CSRF intact and regeneration on privilege change; rate limiting and lockout on
login and registration; reset tokens single-use, hashed and expiring, with enumeration closed
off; every new endpoint guarded by its named Policy and no user-supplied ID trusted; every auth
event audit-logged with the IP hashed.

**Auth code carries the 90% coverage floor** (`code/docs/testing/COVERAGE.md`) — name it in the
handoff; `test-writer` meets it.

## Handoff

Report the **security configuration chosen** (hasher, MFA type, session lifetime, lockout
policy), the files created or changed, every new environment variable with its
`.env.*.example` entry, the migrations, and any trade-off taken. Then name what is owed:
`test-writer` for the coverage floor, `frontend` for the login and registration screens,
`security` and `qa-tester` for the audit and the hostile pass, `notifications` to deliver the
reset and MFA messages, `gdpr-mechanics` for retention and lawful basis over auth PII, and
`cicd` for the deployment secrets.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/08-security-hardening/` — hardening the built auth surface
- `project-management/workflows/10-security-checks/` — the design-stage threat model for it
- `code/workflows/04-api-design/` — the auth endpoints and their Schemas
- `code/workflows/02-tdd-cycle/` — auth code carries the 90% coverage floor

## Cross-references

- `code/docs/security/AUTH-AND-AUTHZ.md` — the authentication and authorisation floor, the
  anti-enumeration rules, and the Django security settings
- `code/docs/security/INPUT-AND-API.md` — boundary validation and the throttling baselines
- `code/docs/security/AUDIT-TRAIL.md` — what an auth event records, and the IP rule
- `code/docs/ENCRYPTION-GUIDE.md` — the pipeline the TOTP secret is stored through
- `code/docs/API-DESIGN.md` — the endpoint and Policy-class patterns
- `code/docs/LOGGING.md` — the channels an auth event reaches
