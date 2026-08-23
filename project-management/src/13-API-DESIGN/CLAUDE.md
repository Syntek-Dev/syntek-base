@./CONTEXT.md

# CLAUDE.md — src/13-API-DESIGN/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the 10-step design, the per-story PLANNING/IMPLEMENTATION split — imported above) →
this file → the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The API-design artefact store, per story — a `PLANNING/` Django Ninja contract agreed
before code, and an `IMPLEMENTATION/` verification that the shipped API matches it, gating
a story's API surface from design into implemented, permission-checked endpoints.

## How to work here

- **Routing:** never write here free-hand — `PLANNING/` designs come from
  `workflows/13-api-design/` (after `src/04-DATABASE/` schema is agreed, before
  `src/16-SPRINT-PLANS/`); `IMPLEMENTATION/` verifications from `workflows/23-pr-and-review/`.
  The contract is written against `code/docs/API-DESIGN.md` (Django Ninja conventions); use
  the `planner` skill for the heavier design work.
- **Model:** Fable for the design documents (they define the shared interface); Opus only
  for mechanical touches — status flips, moving a file, header bumps.
- **Concrete steps:** pick the phase → copy that folder's `US000-TEMPLATE.md` to
  `API-<PLAN|IMPL>-US###-<DESCRIPTOR>.md` → complete the 10-step contract (or verify it
  against the shipped endpoints) → cross-link the `US###` and the paired design/verification
  → satisfy the workflow `CHECKLIST.md`. The design feeds `workflows/20-api-code/`.
- **Definition of done:** contract complete and named to convention; a permission matrix
  present for every endpoint; consistent with `code/docs/API-DESIGN.md`; British English.

## Guardrails

- **Every write endpoint in the contract carries an explicit permission rule** and an
  ownership check for user-supplied IDs — the design specifies what `code/` then _enforces_
  (OWASP A01, no IDOR). Keep it consistent with `code/docs/SECURITY.md`.
- **Documentation only** — no implementation code (`code/src/django/`), no migration SQL
  or ERDs (`src/04-DATABASE/`), no user stories (`src/02-STORIES/`).
- **PLANNING/ precedes IMPLEMENTATION/** — the design is agreed first; the verification
  answers it with evidence and never backfills the contract.
- **Per story** — one design and one verification per story; there is no cross-cutting
  report folder. Every new directory needs a `CONTEXT.md`; instructional files ≤ 300 lines.

## Output & naming

- **Hand-written:** the per-story API designs and verifications under the two sub-folders.
- **Generated:** none here — the client-facing `API-DESIGN.pdf` lives in
  `project-management/export/` and is regenerated from these sources, never hand-edited.
- `PLANNING/API-PLAN-US###-<DESCRIPTOR>.md`; `IMPLEMENTATION/API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`;
  stories referenced as `US###`; dates DD/MM/YYYY.
