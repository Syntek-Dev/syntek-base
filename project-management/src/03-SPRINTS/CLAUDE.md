@./CONTEXT.md

# CLAUDE.md — src/03-SPRINTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sprint format + naming, imported above) → this file.

## Purpose (one line)

The high-level sprint records — one `SPRINT-##.md` per sprint carrying goal, timeline,
capacity, story table, and dependency notes; the detailed per-sprint plans live one
folder along in `16-SPRINT-PLANS/`.

## How to work here

- **Routing:** never write here free-hand — start from
  `project-management/workflows/03-sprint-planning/` (`STEPS.md` + `CHECKLIST.md`),
  governed by `docs/PLANNING-GUIDE.md`. Use `sprint` to organise stories into a
  balanced sprint; `completion` to flip a sprint's stories to In Review / Done.
- **Model:** Fable for composing or re-balancing a sprint (capacity, MoSCoW, the
  dependency chain); Opus for mechanical touches — a status flip or a version-header bump.
- **Concrete steps:** copy `SPRINT-00-TEMPLATE.md` → `SPRINT-##.md` (2-digit zero-padded)
  → fill the fixed format (goal · status · timeline · capacity · story table ·
  dependencies · optional notes) → cross-link every `US###`.
- **Definition of done:** file named to convention; capacity within the team ceiling;
  every story links to its `US###`; blocking/unblocking relationships stated; British
  English; DD/MM/YYYY dates.

## Guardrails

- **Respect the team capacity ceiling** — record capacity as `used / total SP`; call out
  an under-capacity sprint in the notes.
- **Honour the dependency chain** — sprint numbering is not execution order; never
  schedule a story ahead of its blocker. Flag any data-migration risk in the notes.
- **High-level records only** — detailed plans belong in `16-SPRINT-PLANS/`; do not
  duplicate them here.
- **Documentation only** — no code, secrets, or `.env` content. These records are exempt
  from the 300-line instructional limit, but `CONTEXT.md` is not.

## Output & naming

- **Hand-written:** every `SPRINT-##.md` and the `CONTEXT.md`.
- **Template:** `SPRINT-00-TEMPLATE.md` — the copy source; do not delete or repurpose.
- Files `SPRINT-##.md` (2-digit zero-padded); stories referenced as `US###`; dates DD/MM/YYYY.
