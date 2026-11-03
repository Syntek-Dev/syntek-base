@./CONTEXT.md

# CLAUDE.md — code/docs/reliability/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The reliability sub-documents behind `code/docs/RELIABILITY.md` — idempotency and retries,
stated once for every surface that can fail or repeat.

## How to work here

- **Routing:** documentation, not code — `doc-writer` or `backend`.
- **Model:** Opus for a rule's substance and for mechanical touches alike.
- **Concrete steps:** edit the sub-doc that owns the rule → keep `code/docs/RELIABILITY.md` a thin
  index plus the one rule that binds both halves → where a surface guide gains its own expression
  of a rule, add its row to the sub-doc's _Per-surface expression_ table and leave the rule here.
- **Definition of done:** each rule stated in exactly one file of this family; every surface guide
  that touches the rule routes here rather than restating it; each file ≤ 300 code lines; British
  English.

## Guardrails

- **Cross-surface only.** A rule that holds for one transport alone — a Celery setting, a broker
  property, an exit code — belongs to that surface's guide, not here.
- **One rule, one home.** Before adding a rule here, remove it from wherever else it is stated,
  and replace that statement with a route. `doctrine-drift.sh` reads fenced code only, so it
  cannot catch a prose rule stated twice — a reader has to.
- **300-line instructional limit** — these are `**/docs/*.md`; the warn tier, the dated allowance
  and when to split are `code/docs/DOCUMENTATION-LENGTH.md`'s.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames, named for the doctrine rather than a surface; parent guide
  is `code/docs/RELIABILITY.md`.
