@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/USER-STORY-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/05-USER-FLOW/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-1 scope, the seam rule — imported above) → this file.

## Purpose (one line)

Stage-1 per-story flow fragments — one `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md` mapping only the
journey slice that story introduces, written before it reaches `14-decisions`.

## How to work here

- **Routing:** produced by `workflows/05-user-flow-design/` during the story's own pass through
  the specify tier. Read the story in `../../02-STORIES/US###.md` and every earlier fragment
  here first.
- **Model:** Fable — journey mapping is design judgement; Opus for a rename or a date bump.
- **Concrete steps:** copy `USER-FLOW-IDEA-US000-TEMPLATE.md` →
  `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md` → map this story's screens, decision points, and
  transitions → flag every personal-data touchpoint → note the seams where the slice hands off
  to another story → re-export `../DIAGRAMS/flow-<area>-<screen>.png`.
- **Definition of done:** every decision node in the slice resolves both outcomes; every data
  touchpoint flagged for `../../09-GDPR/`; seams noted; diagram re-exported; British English.

## Guardrails

- **Map the slice, not the journey.** Do not extend a fragment over ground another story owns —
  the seam is consolidation's to resolve, and absorbing it hides the discontinuity.
- **Note seams, do not close them.** A handoff to another story's slice is recorded for `16`.
- **Both outcomes, always.** A dangling failure path inside your own slice is incomplete work,
  not something deferred to consolidation.
- **Frozen once `17` runs** — corrections go to `../CONSOLIDATED-IDEAS/`, never here.
- **Documentation only** — narrative and journey maps; never code, secrets, or PII sample data.
- One fragment per story; do not batch stories into one file.

## Output & naming

- **Hand-written:** `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Template:** `USER-FLOW-IDEA-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none here; PNGs are re-exported into `../DIAGRAMS/`.
- Descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
