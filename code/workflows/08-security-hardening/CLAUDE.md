@./CONTEXT.md

# CLAUDE.md — workflows/08-security-hardening/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, OWASP/NIST baseline — imported above) → this file.

## Purpose (one line)

The procedure for auditing and hardening existing code against the OWASP A01–A10 and
NIST SP 800-63B baselines — for a security pass, a release gate, or a reported issue.

## How to work here

- **Routing:** execute via `STEPS.md`, usually with the `security` skill
  (Opus). Backend fixes through `stack-django`; frontend through `stack-htmx-templates`.
- **Model:** Opus throughout — security judgement is substantive and
  mechanical edits to the workflow files.
- **Concrete steps:** confirm feature code is implemented and tests green → read the
  two hard-gate docs (`security/AUTH-AND-AUTHZ.md`, `security/OWASP-AND-CHECKLIST.md`)
  → walk A01–A10, fixing findings → add security/property tests
  (`code/docs/testing/ADVANCED-TESTING.md`) → run `code/src/scripts/tests/*.sh` and
  syntax scripts → complete `CHECKLIST.md`.
- **Definition of done:** every state-changing Django Ninja endpoint permission-checked, no IDOR, `DEBUG=False`
  and explicit CORS allowlist confirmed for non-local, secrets env-only,
  `CHECKLIST.md` signed off.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **The non-negotiables ARE the deliverable here:** explicit permission check on
  every state-changing Django Ninja endpoint; user-supplied IDs verified against caller ownership;
  `DEBUG=False` outside local; `CORS_ALLOWED_ORIGINS` an explicit allowlist, never
  `*` in production; secrets via environment only; Django admin never at `/admin/`.
- PII must be encrypted at rest; no PII in logs or error responses.
- Never invoke `pytest`, `python`, or `docker` directly — only the shell scripts.

## Output & naming

- **Hand-written:** these workflow files; the hardening changes land in
  `code/src/django/`.
- Security audit artefacts belong under `project-management/`; workflow files
  `SCREAMING-SNAKE-CASE.md`.
