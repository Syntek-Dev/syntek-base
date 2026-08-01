@./CONTEXT.md

# CLAUDE.md — src/04-USER-FLOW/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(flow inventory, naming, cross-references — imported above) → this file → the
`DIAGRAMS/` sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The user-flow layer — one `USER-FLOW-<AREA>.md` per primary interaction area,
documenting the full sequence of screens, decisions, and transitions a user follows,
with the rendered PNG exports living in `DIAGRAMS/`.

## How to work here

- **Routing:** all flow work starts from
  `project-management/workflows/04-user-flow-design/` (`STEPS.md` + `CHECKLIST.md`);
  it maps a `US###` to its journey before wireframing. Opus for authoring a flow;
  Opus for a rename or a stub redirect edit.
- **Concrete steps:** read the story in `src/01-STORIES/` → copy `USER-FLOW-TEMPLATE.md`
  → name it `USER-FLOW-<AREA>.md` → write the narrative (screens, decision points, data
  touchpoints) → re-export the matching `DIAGRAMS/flow-<area>-<screen>.png` when the flow
  changes → satisfy the workflow `CHECKLIST.md`. A thin flow that belongs to a larger
  journey becomes a one-line **stub** pointing at the canonical section (the stub pattern
  is at the foot of the template) — do not duplicate content.
- **Definition of done:** flow named `USER-FLOW-<AREA>.md`, cross-linked to its
  `US###`; every GDPR data touchpoint noted for the compliance trace; diagram
  re-exported; British English throughout.

## Guardrails

- **Documentation only** — narrative and journey maps, never code, secrets, or PII
  sample data. Personal-data touchpoints are _flagged_ here (for `src/08-GDPR/`) and
  _enforced_ in `code/`.
- **Stubs stay stubs** — a redirect file holds a single pointer line, never a second
  copy of the flow; keep one canonical narrative per journey.
- **Every new directory needs a `CONTEXT.md`.** `CONTEXT.md` files here stay ≤ 300
  code lines; the flow artefacts themselves are exempt.
- Keep flows consistent with their wireframes (`src/07-WIREFRAMES/`) and stories
  (`src/01-STORIES/`) — a flow that diverges from either is a defect.

## Output & naming

- **Hand-written:** every `USER-FLOW-<AREA>.md` narrative and stub, and the
  `USER-FLOW-TEMPLATE.md` scaffold.
- **Template:** `USER-FLOW-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** the PNGs under `DIAGRAMS/` — exported from Mermaid/Figma, never
  hand-drawn; regenerate on change.
- Flow files `USER-FLOW-<AREA>.md` (SCREAMING-SNAKE-CASE area); diagrams
  `flow-<area>-<screen>.png` (kebab-case); stories referenced as `US###`; dates DD/MM/YYYY.
