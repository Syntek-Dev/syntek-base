@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/DIAGRAMS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(image inventory + naming, imported above) → this file.

## Purpose (one line)

Rendered user-flow diagram images — PNG exports (from Mermaid or Figma) of the flow
narratives in the parent `05-USER-FLOW/` folder.

## How to work here

- **Model:** Opus — this is a re-export, not authoring. The source of truth is the
  `USER-FLOW-<AREA>.md` narrative one level up.
- **Concrete steps:** edit the parent flow narrative first → re-export the affected
  `flow-<area>-<screen>.png` here → confirm the filename matches the flow it depicts.
  **Never edit a PNG directly** — regenerate it from source.
- **Definition of done:** the image reflects the current narrative, is named to
  convention, and no stale diagram remains for a flow that changed.

## Guardrails

- **Generated assets only** — no hand-editing pixels; a diagram is only ever
  re-exported from its Mermaid/Figma source.
- Keep every PNG in lock-step with its parent narrative — a diagram that drifts from
  `USER-FLOW-<AREA>.md` is a defect.
- No PII or secrets rendered into an image; flows are illustrative, not real data.

## Output & naming

- **Generated:** `flow-<area>-<screen>.png` — kebab-case, matching the flow area and
  screen it depicts. Nothing here is hand-authored.
