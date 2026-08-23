@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three stages + naming, imported above) → this file → the target stage folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The user-flow store, in three stages — per-story flow fragments (`USER-STORY-IDEAS/`), the whole
journeys they are stitched into (`CONSOLIDATED-IDEAS/`), and the per-story record of the flow as
built (`IMPLEMENTATION/`), with rendered PNGs in `DIAGRAMS/`.

## How to work here

- **Routing:** never author here free-hand. Stage 1 comes from `workflows/05-user-flow-design/`,
  stage 2 from `workflows/18-consolidate-design-work/`, stage 3 from
  `workflows/22-implementation-documentation/`.
- **Model:** Fable for mapping and for consolidation — journey design and gap-finding are
  substantive; Opus for mechanical touches (a rename, re-exporting a diagram, a stub edit).
- **Concrete steps:** pick the stage → copy that folder's template → write the narrative
  (screens, decision points, data touchpoints) → re-export the matching
  `DIAGRAMS/flow-<area>-<screen>.png` → cross-link the `US###` and, for stages 2 and 3, the
  fragments involved.
- **Definition of done:** the artefact is in the right stage folder and named to convention;
  every decision node resolves both outcomes; every GDPR data touchpoint noted for the
  compliance trace; diagram re-exported; British English.

## Guardrails

- **Documentation only** — narrative and journey maps, never code, secrets, or PII sample data.
  Personal-data touchpoints are _flagged_ here (for `../09-GDPR/`) and _enforced_ in `code/`.
- **Never edit a `USER-STORY-IDEAS/` file once `17` has run.** Stage 1 is the frozen record of
  what each story mapped; consolidation is additive and cross-links back.
- **A story maps its slice, not the journey.** Do not extend a fragment to cover ground another
  story owns — the seam between fragments is consolidation's job, and papering over it hides the
  gap that most needs finding.
- **Stubs stay stubs** — a redirect holds a single pointer line, never a second copy of the
  flow; one canonical narrative per journey.
- **Wireframes follow the consolidated flow.** A screen built from a stage-1 fragment
  reintroduces the discontinuity `17` removed.
- Keep flows consistent with their wireframes (`../08-WIREFRAMES/`) and stories
  (`../02-STORIES/`) — a flow that diverges from either is a defect.
- Instructional `.md` (`CONTEXT.md`/`CLAUDE.md`) ≤ 300 code lines; the flow artefacts and
  templates are exempt.

## Output & naming

- **Hand-written:** every flow narrative, consolidation, and record, from its stage template.
- **Templates:** `USER-FLOW-IDEA-US000-TEMPLATE.md`, `USER-FLOW-CONSOLIDATED-000-TEMPLATE.md`,
  `USER-FLOW-IMPL-US000-TEMPLATE.md` — the copy sources; do not delete or repurpose.
- **Generated (never hand-edit):** the PNGs under `DIAGRAMS/` — exported from Mermaid.
- `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md` · `USER-FLOW-CONSOLIDATED-<AREA>.md` ·
  `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; diagrams `flow-<area>-<screen>.png`;
  stories `US###`; dates DD/MM/YYYY.
