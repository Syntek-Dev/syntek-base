@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/05-USER-FLOW/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, the seam log — imported above) → this file.

## Purpose (one line)

Stage-2 whole journeys — one `USER-FLOW-CONSOLIDATED-<AREA>.md` per area, stitching the frozen
per-story fragments into the end-to-end flow that wireframes and code follow.

## How to work here

- **Routing:** produced only by `workflows/17-consolidate-design-work/`, after every story has
  cleared `16-story-plans`.
- **Model:** Fable throughout — finding the journey nobody owns is design judgement, not a
  merge. Opus only for re-exporting a diagram or a rename.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` fragment for the area → sequence
  them into one journey → walk every seam and record whether it joined, gapped, or contradicted
  → resolve every node so both outcomes are answered across the whole journey → raise a new
  `US###` for any gap needing capability → re-export `../DIAGRAMS/flow-<area>-<screen>.png`.
- **Definition of done:** no dead end anywhere in the journey; every seam logged with its
  verdict; every gap either resolved or raised as a story; every affected
  `STORY-PLAN-US###-*.md` corrected; British English; DD/MM/YYYY.

## Guardrails

- **Never edit `../USER-STORY-IDEAS/`.** Stage 1 is frozen; consolidation cross-links back.
- **A dead end is a defect, not an edge case.** A state the journey can reach with no path
  onward ships as a stuck user.
- **Log the seams, not just the result.** A clean journey with no record of what was joined is
  un-reviewable, and the next consolidation re-derives it.
- **Consolidation never adds scope.** A gap needing new capability becomes a `US###` through
  `02-story-creation/`.
- **A journey change must correct the affected story plans** — the developer codes from the
  plan, so a plan asserting a superseded flow silently undoes this work.
- **Wireframes follow this folder**, not `../USER-STORY-IDEAS/`.
- **Documentation only** — never code, secrets, or PII sample data.

## Output & naming

- **Hand-written:** `USER-FLOW-CONSOLIDATED-<AREA>.md`, one per area, from the template.
- **Template:** `USER-FLOW-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete.
- **Generated (never hand-edit):** the PNGs in `../DIAGRAMS/`.
- `<AREA>` in `SCREAMING-KEBAB-CASE`; superseded fragments cited as `US###`; dates DD/MM/YYYY.
