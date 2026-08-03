@./CONTEXT.md

# CLAUDE.md — docs/gdpr/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file list, imported above) → this file.

## Purpose (one line)

The GDPR sub-documents split out of `GDPR-GUIDE.md` — `COMPLIANCE.md` (obligations
and requirements) and `DATA-RIGHTS.md` (data subject rights and implementation) —
read via the parent index `project-management/docs/GDPR-GUIDE.md`.

## How to work here

- **Routing:** substantive GDPR content → `gdpr` (Fable), driven by
  `workflows/09-gdpr-compliance/`. Enter through the `GDPR-GUIDE.md` index, not these
  files directly.
- **Model:** Fable for lawful-basis, retention, and DSAR content; Opus for a
  version-header bump or a cross-link fix.
- **Concrete steps:** edit the relevant sub-document → keep it ≤ 300 code lines →
  ensure `GDPR-GUIDE.md` still links it and the split stays coherent → check
  consistency with the enforcing code in `apps.<%LEGAL_APP%>` and `code/docs/SECURITY.md`.
- **Definition of done:** obligation or right accurately documented, linked from the
  parent index, ≤ 300 code lines, British English.

## Guardrails

- **Specify, do not implement.** These docs state GDPR obligations; enforcement lives
  in `code/` (`apps.<%LEGAL_APP%>` cookie consent, Fernet PII encryption) — keep the two in
  step, never contradictory.
- **Instructional cap: ≤ 300 code lines** per file — split further if either grows.
- No personal data, secrets, or `.env` content ever appears in these guides.
- Stay aligned with the ICO UK GDPR guidance the parent index cites.

## Output & naming

- **Hand-written:** `COMPLIANCE.md`, `DATA-RIGHTS.md`. Nothing generated here.
- Documentation files `SCREAMING-SNAKE-CASE.md`; parent guide is `GDPR-GUIDE.md`;
  dates DD/MM/YYYY.
