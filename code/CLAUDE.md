@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — code/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + key docs, imported above) → this file → the target sub-layer's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The code layer — all deployable source (`src/`), the coding reference guides
(`docs/`), and the step-by-step coding workflows (`workflows/`) that govern how
anything in `src/` is designed, written, tested, and reviewed.

## How to work here

- **Routing:** start any coding task from the matching `workflows/NN-…/` procedure
  (`STEPS.md` + `CHECKLIST.md`); it points you at the governing `docs/` guide.
  Backend work → `stack-django` skill; frontend → `stack-htmx-templates` skill.
  **Never run `pytest`, `python`, or `docker` directly** — only the shell scripts
  under `src/scripts/`.
- **Grill first:** any substantial task — design, code, tests, review, refactor, debug —
  opens with a grilling pass (the running skill loads `.claude/skills/grill-with-docs`, which owns the round shape and question format) before code is written; only trivial/mechanical work skips it
  (`.claude/CLAUDE.md` Section 10).
- **Model:** Opus for all substantive work (design, code, tests, reviews, security)
  and mechanical touches (renames, version bumps, running scripts).
- **Concrete steps:** read the relevant `docs/` guide → implement under
  `src/django/` → tests to the coverage floor → run
  `src/scripts/syntax/*.sh` and `src/scripts/tests/*.sh` → update the touched
  directory's `CONTEXT.md` if structure changed → refresh the code-review-graph
  (`code-review-graph update`) so it matches → docs hard-gate before any commit.
- **Definition of done:** file within the length limit (`docs/CODING-PRINCIPLES.md`);
  coverage floors met (`docs/testing/COVERAGE.md`); every state-changing Django Ninja
  endpoint permission-checked; no IDOR; British English; the touched `CONTEXT.md` and
  `CLAUDE.md` updated; quality gates green.

## Guardrails

- **Non-negotiables (`.claude/CLAUDE.md` Section 6):** explicit permission check on every
  state-changing Django Ninja endpoint; user IDs verified against caller ownership;
  `DEBUG=False` outside local;
  no `CORS *` in production; secrets via env only; Django admin never at `/admin/`;
  token-first CSS (components consume `var(--token)` only).
- **File length 750** (800 grace); **every new `src/` directory gets a `CONTEXT.md` +
  `CLAUDE.md` pair** (`docs/DOCUMENTATION-PAIRING.md`).
- **Never read** `node_modules/`, `src/django/staticfiles/`, `.git/`.

## Output & naming

- **Hand-written:** source under `src/`, guides under `docs/`, workflow
  `STEPS.md`/`CHECKLIST.md`.
- **Generated (never hand-edit):** coverage and audit reports under
  `src/scripts/**/reports/`, the auto-generated OpenAPI schema (`/api/docs`).
- Directories `kebab-case/`; documentation files `SCREAMING-SNAKE-CASE.md`.
