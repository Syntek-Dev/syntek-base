@./CONTEXT.md

# CLAUDE.md — src/13-API-DESIGN/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each record, the design-contract relationship — imported
above) → this file.

## Purpose (one line)

Post-implementation API verification records — one per story, confirming the shipped
Django Ninja API matches the design contract in `../PLANNING/` and closing it with evidence
before the story merges.

## How to work here

- **Routing:** written during `project-management/workflows/22-implementation-documentation/`, after the
  feature's Ninja API ships and before it moves to `../../18-TESTS/`, against the story's
  contract in `../PLANNING/API-PLAN-US###-*.md`; governed by `code/docs/API-DESIGN.md`.
- **Model:** Fable — the contract diff, permission-matrix check, and breaking-change
  assessment are substantive judgement; Opus only for a rename, filing, or date-stamp.
- **Concrete steps:** copy `API-IMPL-US000-TEMPLATE.md` →
  `API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the design contract → mark each
  endpoint and Schema Present / Changed / Missing with a Python symbol and handler file as
  evidence → verify every write endpoint's permission rule and ownership/IDOR check →
  verify error types and pagination → justify deviations and track follow-ups → complete
  the sign-off checklist.
- **Definition of done:** every contract element addressed; permissions verified;
  deviations justified; the `US###`, design-doc link, sprint, and date present; sign-off
  complete; British English; DD/MM/YYYY.

## Guardrails

- **Verify the permission matrix as built (OWASP A01)** — every write endpoint carries an
  explicit named permission rule and an ownership check on user-supplied IDs (no IDOR). A
  write endpoint with no permission rule, or an unchecked user-supplied ID, is a
  **blocker**, not a footnote; flag any drift from `code/docs/SECURITY.md`.
- **Verify against the shipped API, never restate the contract** — mark an element Present
  only with evidence (a Python symbol, handler file, or test). Any Schema change gets an
  explicit breaking-change assessment.
- **Post-development phase only** — the design contract lives in the sibling
  `../PLANNING/`; this record verifies it, never backfills it.
- **Documentation only — no source, secrets, or `.env` content.** One record per story;
  do not batch multiple stories into one file, nor pre-create stubs for unstarted stories.

## Output & naming

- **Hand-written:** one `API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per verified story,
  from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
