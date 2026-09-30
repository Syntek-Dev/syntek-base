@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/05-USER-FLOW/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, the seam log — imported above) → this file.

## Purpose (one line)

Stage-2 whole journeys — one `USER-FLOW-CONSOLIDATED-<AREA>.md` per area, stitching the frozen
per-story fragments into the end-to-end flow that wireframes and code follow.

## How to work here

- **Routing:** produced only by `workflows/18-consolidate-design-work/`, after every story has
  cleared `17-story-plans`.
- **Model:** Opus throughout — finding the journey nobody owns is design judgement, not a merge;
  re-exporting a diagram or a rename is a mechanical touch.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` fragment for the area → sequence
  them into one journey → walk every seam and record whether it joined, gapped, or contradicted
  → resolve every node so both outcomes are answered across the whole journey → raise a new
  `US###` for any gap needing capability → re-export `../DIAGRAMS/flow-<area>-<screen>.png`.
- **Definition of done:** no dead end anywhere in the journey; every seam logged with its
  verdict; every gap either resolved or raised as a story; every affected
  `<exec-order>-STORY-PLAN-US###-*.md` corrected; every affected manual testing guide's `Flow`
  column set and any row the journey invalidated corrected; British English; DD/MM/YYYY.

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
- **A step number is cited, never keyed on.** `../IMPLEMENTATION/` Section 1 carries it and
  each manual testing guide's `Flow` column cites it as `<AREA> <step>`, so renumbering a step
  re-cites both in the same change; the guide's own row IDs never follow a step. Setting and
  correcting the guides: `workflows/18-consolidate-design-work/` Step 7; the column's rules:
  `../../18-TESTS/MANUAL/CLAUDE.md` → _The Flow and QA columns_.
- **Wireframes follow this folder**, not `../USER-STORY-IDEAS/`.
- **Documentation only** — never code, secrets, or PII sample data.

## Output & naming

- **Hand-written:** `USER-FLOW-CONSOLIDATED-<AREA>.md`, one per area, from the template.
- **Template:** `USER-FLOW-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete.
- **Generated (never hand-edit):** the PNGs in `../DIAGRAMS/`.
- `<AREA>` in `SCREAMING-KEBAB-CASE`; superseded fragments cited as `US###`; dates DD/MM/YYYY.

<!-- UPDATED 08/09/2026. The story-plan pattern in _Definition of done_ gained the `<exec-order>-`
     build-order prefix; it read "STORY-PLAN-US###-*.md" before.
     `code/src/scripts/audits/doc-references.sh` reads backticked tokens even inside a comment, so
     the superseded name is quoted in double quotes and never in backticks. The prefix is the
     story's position in the settled build order across the whole backlog and moves only on a
     re-plan — correct a plan's contents here, never its number (`../../17-STORY-PLANS/CLAUDE.md`).
-->

<!-- UPDATED 30/09/2026. _Definition of done_ and the guardrails gained the manual testing guide.
     It is now authored at 17-story-plans, before this folder holds any journey, so its Flow
     column starts as "—" and consolidation is the first point a step number exists to cite.
     The step number stays owned here; the guide cites it and never keys a row on it. Why the
     guide stopped reusing the step number as its row ID: "../../18-TESTS/MANUAL/CLAUDE.md". -->
