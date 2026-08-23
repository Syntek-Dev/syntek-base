@./CONTEXT.md

# CLAUDE.md — src/22-REFACTORING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(naming, tier position, what the record captures — imported above) → this file.

## Purpose (one line)

The refactoring record store — one behaviour-preserving record per story, capturing a
structural change (its before → after and the proof nothing observable changed), written
during or after the code/PR phase.

## How to work here

- **Routing:** this is the PM-side record; the refactor itself is executed under `code/` via
  code workflow `11-refactor` (or the `refactor` skill), and the record is filed during PM
  workflow `23-pr-and-review`. Draft it with **Opus** — an implementation record, not a
  planning artefact.
- **Concrete steps:** copy `REFACTORING-US000-TEMPLATE.md` →
  `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (or the cross-cutting
  `REFACTORING-<DESCRIPTOR>-DD-MM-YYYY.md`) → fill the metadata, motivation, scope, before →
  after, and the behaviour-preservation proof → cross-link the `US###`, its
  `../17-STORY-PLANS/` plan, and the driving review → record the verification results.
- **Definition of done:** record named to convention, dated DD/MM/YYYY, linked to its story
  and plan; the behaviour-preservation proof complete with evidence; British English throughout.

## Guardrails

- **Documentation only** — no source, diffs, secrets, or `.env` content lands here; the record
  describes the change, the change ships through `code/`.
- **Refactors preserve behaviour** — the same tests must pass before and after with no
  assertion edits, coverage must not drop, and the change ships as its **own commit**. If a
  test had to change, it is a feature change — route it to a story, not this record.
- Every developer command in a record is a project script under `code/src/scripts/**/*.sh`
  (`syntax/lint.sh`, `syntax/check.sh`, `audits/cloc.sh`, `tests/all.sh`) — never raw
  pytest / pnpm / docker / python.
- Any security/token/IDOR concern surfaced by a refactor stays consistent with
  `code/docs/SECURITY.md`. This folder is a flat leaf; every new directory still needs a
  `CONTEXT.md` + `CLAUDE.md`, and instructional files stay ≤ 300 code lines.

## Output & naming

- **Hand-written:** every `REFACTORING-*.md` record, copied from the template — nothing here
  is generated.
- **Template:** `REFACTORING-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Naming:** `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (primary), or cross-cutting
  `REFACTORING-<DESCRIPTOR>-DD-MM-YYYY.md`; descriptors SCREAMING-KEBAB-CASE; dates DD-MM-YYYY
  in filenames, DD/MM/YYYY in prose; British English.
