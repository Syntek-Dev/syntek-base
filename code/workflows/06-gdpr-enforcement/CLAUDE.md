@./CONTEXT.md

# CLAUDE.md — workflows/06-gdpr-enforcement/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, PII/consent/deletion concepts, prerequisites — imported above) → this
file.

## Purpose (one line)

The code-level procedure for implementing GDPR requirements — field encryption,
consent gating, anonymising deletion, and DSAR support — for any feature touching
personal data.

## How to work here

- **Routing:** execute via `STEPS.md`, typically with the `gdpr` skill/agent (Opus)
  and `stack-django`. The PM-layer compliance review in
  `project-management/workflows/08-gdpr-compliance/` must finish first.
- **Model:** Opus throughout — data-protection decisions are substantive
  and mechanical edits to the workflow files.
- **Concrete steps:** confirm the compliance review is complete and data flows are in
  `project-management/src/08-GDPR/DATA-INVENTORY.md` → read the hard-gate docs
  (`encryption/FIELD-ENCRYPTION.md`, `encryption/LOOKUP-TOKENS.md`) → encrypt PII at
  rest, gate access on consent, make deletion anonymise where audit trails are
  required → test DSAR deletion end-to-end via `code/src/scripts/tests/*.sh` →
  complete `CHECKLIST.md`.
- **Definition of done:** every PII field encrypted with a lookup token where the
  field is unique; consent verified before PII access; no PII in logs or errors; DSAR
  deletion testable end-to-end.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **PII is encrypted at rest** (AES-256-GCM) with lookup tokens for unique fields
  (email, phone); **no PII in log output or error responses.**
- Consent must be verified before any endpoint reads PII; deletion anonymises rather
  than hard-deletes where an audit trail is required.
- Permission checks and IDOR prevention still apply to every PII-touching endpoint.
- Never invoke `python`, `pytest`, or `docker` directly — only the shell scripts.

## Output & naming

- **Hand-written:** these workflow files; the GDPR code lands in
  `code/src/django/apps/`; live GDPR documentation sits under
  `project-management/src/08-GDPR/`.
- Workflow files `SCREAMING-SNAKE-CASE.md`.
