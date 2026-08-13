@./CONTEXT.md

# CLAUDE.md — 10-SECURITY/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree, frameworks, per-story naming — imported above) → this file → the target
category's `CONTEXT.md`/`CLAUDE.md`, then its `PLANNING/` or `IMPLEMENTATION/`.

## Purpose (one line)

The security artefact store — STRIDE threat models, OWASP/NIST posture assessments,
code audits, and vulnerability records, scaffolded per story across four categories
that gate a feature through `workflows/10-security-checks/` before code ships.

## How to work here

- **Routing:** never author here free-hand — run `workflows/10-security-checks/`
  (`STEPS.md` + `CHECKLIST.md`) after wireframes are signed off and the GDPR review is
  complete, before sprint planning. Heavier reviews go through the `security` and
  `qa-tester` skills (Fable). `docs/SECURITY-GUIDE.md` governs STRIDE, OWASP A01–A10,
  and NIST CSF 2.0.
- **Model:** Fable for every threat model, assessment, audit, and vulnerability
  write-up; Opus for mechanical touches — status flips, moving a file, header bumps.
- **Concrete steps:** pick the category (`THREAT-MODEL/`, `ASSESSMENTS/`, `AUDITS/`,
  `VULNERABILITIES/`) and phase (`PLANNING/` vs `IMPLEMENTATION/`) → copy that folder's
  `US000-TEMPLATE.md` to `<TYPE>-<PLAN|IMPL>-US###-<DESCRIPTOR>.md` → apply all three
  frameworks per finding → escalate Critical/High to `VULNERABILITIES/` → cross-link the
  `US###` and the paired PLANNING↔IMPLEMENTATION artefacts.
- **Definition of done:** every finding carries STRIDE + OWASP + NIST columns and a
  severity; Critical/High escalated; artefact in the right category and phase; British
  English; DD/MM/YYYY dates; every new directory carries a `CONTEXT.md` + `CLAUDE.md`.

## Guardrails

- **Documentation only — never code, secrets, credentials, or live exploit payloads
  land here.** Obligations are _specified_ here and _enforced_ in `code/`; keep them
  consistent with `code/docs/SECURITY.md` (permission checks, IDOR, CORS, `DEBUG`).
- **PLANNING/ precedes IMPLEMENTATION/** — the pre-implementation artefact must exist
  before its post-implementation counterpart; the IMPLEMENTATION record closes the plan
  with evidence.
- **Per story** — security analysis is tied to a `US###` at both ends, like 09-GDPR;
  there is no top-level cross-cutting report folder.
- `CONTEXT.md`/`CLAUDE.md` files stay ≤ 300 code lines; the artefacts and templates are
  exempt.

## Output & naming

- **Hand-written:** every threat model, assessment, audit, and vuln record, from the
  per-story templates.
- **Generated:** none here — `SECURITY.pdf` under `project-management/export/` is
  regenerated from these sources, never hand-edited.
- Categories `SCREAMING-CASE/`; artefacts `<TYPE>-PLAN-US###-<DESCRIPTOR>.md` (planning)
  and `<TYPE>-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (implementation); stories `US###`.
