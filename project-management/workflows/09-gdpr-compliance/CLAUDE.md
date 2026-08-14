@./CONTEXT.md

# CLAUDE.md — workflows/09-gdpr-compliance/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

Review a feature for UK GDPR compliance — lawful basis, retention, encryption, data
subject rights — when it collects, processes, or stores personal data, before release.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`; load `gdpr-mechanics`.
  **Hard gates (blocking):** `docs/gdpr/DATA-RIGHTS.md` (lawful basis, erasure, SAR,
  portability, consent) and `docs/gdpr/COMPLIANCE.md` (retention, encryption at rest,
  audit logging, breach notification).
- **Model:** Fable — compliance judgement is substantive.
- **Concrete steps:** confirm the feature is implemented and data flows are understood →
  trace each data touchpoint from `src/05-USER-FLOW/` to a lawful basis and retention
  rule → verify PII is encrypted (`code/docs/encryption/FIELD-ENCRYPTION.md`), access is
  controlled with no IDOR (`AUTH-AND-AUTHZ.md`), and no PII leaks into logs
  (`DJANGO-LOGGING.md`) → record the outcome under `project-management/src/09-GDPR/`.
- **Definition of done:** every personal-data field has a lawful basis and retention
  rule; encryption, access control, and logging checks pass; record filed; checklist
  satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Lawful basis and retention are blocking gates** — a field without either fails the
  review. Right to erasure, SAR, and portability must be satisfiable.
- **No PII in log output or error responses** (`code/docs/logging/DJANGO-LOGGING.md`);
  PII at rest is Fernet-encrypted; access is ownership-verified (no IDOR).
- This folder _specifies_ compliance; enforcement lives in `code/` — keep the two
  consistent. Documentation only, no code or `.env` content.

## Output & naming

- **Hand-written:** planning gap reports under `src/09-GDPR/PLANNING/`; post-
  implementation records `GDPR-IMPL-US###-*.md` under `src/09-GDPR/IMPLEMENTATION/`;
  `STEPS.md`/`CHECKLIST.md` updates.
- Documentation files `SCREAMING-SNAKE-CASE.md`; stories referenced as `US###`;
  dates DD/MM/YYYY.
