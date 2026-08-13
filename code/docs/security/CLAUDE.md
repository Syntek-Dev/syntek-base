@./CONTEXT.md

# CLAUDE.md — code/docs/security/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The security sub-documents behind `code/docs/SECURITY.md` — auth and authorisation,
crypto and data classification, input and API security, monitoring and incident
response, the OWASP checklist, secrets and transport, and supply-chain security.

## How to work here

- **Routing:** documentation, not code — `security` or `doc-writer`
  (Opus always; security is never a mechanical task). Governs every Django Ninja
  endpoint, service, and auth path under `stack-django`.
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/SECURITY.md` a thin
  index → any rule here must be enforceable and mirror the repo non-negotiables in
  `.claude/CLAUDE.md` §6. Audit and scan commands invoke `code/src/scripts/audits/*.sh`,
  never raw tools.
- **Definition of done:** guidance is consistent with the shipped controls and OWASP
  2021/2025 baseline; each file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- This folder is the canonical statement of the non-negotiables — explicit permission
  check on every state-changing Django Ninja endpoint, IDOR verification, `DEBUG=False`
  outside local, no `CORS *` in production, secrets via env only, the built-in Django
  admin mounted at `/control/` and never at `/admin/`. Never soften or contradict them here.
- **No real secrets or live payloads in examples** — placeholders only.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/SECURITY.md`.
