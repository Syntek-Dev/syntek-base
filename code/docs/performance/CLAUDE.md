@./CONTEXT.md

# CLAUDE.md — code/docs/performance/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The performance sub-documents behind `code/docs/PERFORMANCE.md` — API and
background-job monitoring, database query optimisation, and frontend bundle/rendering
tuning.

## How to work here

- **Routing:** documentation, not code — reach for the `doc-writer` agent
  (Opus for substantive guidance; Opus for typo/header/version touches).
  Back-end tuning advice ties to `stack-django`, front-end to `stack-htmx-templates`.
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/PERFORMANCE.md` a
  thin index → record the measured target (N+1 counts, page weight, response-time
  budget) rather than vague guidance. Profiling and benchmark commands
  must call a `code/src/scripts/**/*.sh` script, never raw `pytest` or `docker`.
- **Definition of done:** advice reflects the current stack and real budgets; each
  file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- Performance guidance must never trade away a non-negotiable — no dropping a
  permission check, widening CORS, or bypassing IDOR verification for speed.
- Keep the three concerns separate (`API-AND-MONITORING`, `DATABASE-PERFORMANCE`,
  `FRONTEND-PERFORMANCE`) — do not let one file absorb another's scope.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/PERFORMANCE.md`.
