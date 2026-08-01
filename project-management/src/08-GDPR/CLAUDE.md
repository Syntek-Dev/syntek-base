@./CONTEXT.md

# CLAUDE.md — src/08-GDPR/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the six registers, the per-story PLANNING/IMPLEMENTATION split — imported above) →
this file → the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The GDPR compliance store — six fillable register skeletons (data inventory, lawful
basis, retention/deletion, data-subject rights, breach notification, third-party
processors) plus per-story `PLANNING/` plans and `IMPLEMENTATION/` records that gate any
PII-handling feature into code.

## How to work here

- **Routing:** GDPR work runs through `project-management/workflows/08-gdpr-compliance/`
  (`STEPS.md` + `CHECKLIST.md`) against `project-management/docs/GDPR-GUIDE.md`, using
  the `gdpr` agent (Fable). Write a story's `PLANNING/` plan before implementing it; the
  code-side enforcement lives in `code/workflows/05-gdpr-enforcement/`.
- **Model:** Fable for all register content, plans, and records; Opus for mechanical
  touches — a date-header bump, moving a file, a status flip.
- **Concrete steps:** fill the relevant register skeleton (replace `[EXAMPLE]` rows and
  `{PLACEHOLDER}` values) → write the story's `PLANNING/` plan → after the PR, write the
  `IMPLEMENTATION/` record closing each planned task with evidence → cross-link the
  `US###` and the lawful basis.
- **Definition of done:** every processing activity names its lawful basis, retention
  period, and erasure path; the artefact is consistent with `code/docs/SECURITY.md`;
  British English; DD/MM/YYYY dates; every new sub-directory carries a `CONTEXT.md`.

## Guardrails

- **Documentation only — never real personal data, secrets, or `.env` content lands
  here.** Obligations are _specified_ in these files and _enforced_ in `code/`; keep the
  two in step. The register skeletons ship with `[EXAMPLE]` data only.
- **A story's plan gates its code** — the GDPR tasks in a `PLANNING/` plan must be closed
  (with evidence) in the matching `IMPLEMENTATION/` record before that story's PII code
  ships. Do not close a task without pointing at the code that satisfies it.
- Every processing activity documented here needs a lawful basis and a retention period
  — no orphaned PII.
- Instructional `CONTEXT.md`/`CLAUDE.md` files stay ≤ 300 code lines; the register
  documents and templates themselves are exempt.

## Output & naming

- **Hand-written:** the six register documents (`SCREAMING-SNAKE-CASE.md`), and the
  per-story `PLANNING/GDPR-PLAN-US###-*.md` and `IMPLEMENTATION/GDPR-IMPL-US###-*.md`.
- **Generated:** none here — the client-facing `GDPR.pdf` lives in
  `project-management/export/` and is regenerated from these sources, never hand-edited.
- Registers `SCREAMING-SNAKE-CASE.md`; sub-folders `PLANNING/` and `IMPLEMENTATION/`;
  stories referenced as `US###`; dates DD/MM/YYYY.
