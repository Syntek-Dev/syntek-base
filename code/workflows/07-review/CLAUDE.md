@./CONTEXT.md

# CLAUDE.md — workflows/07-review/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, review concepts, prerequisites — imported above) → this file.

## Purpose (one line)

The code-quality review procedure applied before raising a PR — security, patterns,
coverage, and coding principles on the _content_ of the change, distinct from the PR
merge process in `project-management/workflows/20-pr-and-review/`.

## How to work here

- **Routing:** execute via `STEPS.md`, typically with the `review` skill/agent
  (Opus). Use `/code-review` on the working diff for a fast pass before the full
  workflow. Open the structural pass with the code-review-graph **review playbook**
  (`.claude/skills/review-changes.md`; guide `code/docs/CODE-REVIEW-GRAPH.md`).
- **Model:** Opus throughout — review judgement is substantive and
  mechanical edits to the workflow files.
- **Concrete steps:** confirm TDD is complete, linters clean, no open bugs → read the
  three hard-gate docs (`security/AUTH-AND-AUTHZ.md`,
  `security/OWASP-AND-CHECKLIST.md`, `testing/COVERAGE.md`) → review against
  OWASP A01–A10, coding principles, and coverage floors → complete `CHECKLIST.md`
  before handing to workflow 17.
- **Definition of done:** every state-changing Django Ninja endpoint authenticated and
  permission-checked via a named Policy class; no IDOR; coverage floors met; no duplicated
  the django-components library components; `CHECKLIST.md` signed off.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Catch the recurring bites:** M2M prefetches on soft-deleting models must use
  `Prefetch(..., deleted_at__isnull=True)` — a bare `prefetch_related()` leaks deleted
  records; constraint guards before a destructive operation must check **all** M2M
  consumer models; Django Ninja response Schema models must expose every writable input field.
- No hardcoded secrets, no bare `except:`, no undocumented inline imports.
- Frontend PRs must not duplicate an existing the django-components library component.
- Review only — do not run raw toolchain commands; use the shell scripts if you must
  re-run checks.

## Output & naming

- **Hand-written:** these workflow files; review notes travel with the PR, not into
  `code/src/`.
- Workflow files `SCREAMING-SNAKE-CASE.md`; stories referenced as `US###`.
