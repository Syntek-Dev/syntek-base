@./CONTEXT.md

# CLAUDE.md — src/07-COMPONENTS/USER-STORY-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/07-COMPONENTS/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-1 scope, describe-the-need — imported above) → this file.

## Purpose (one line)

Stage-1 per-story component records — one `COMP-IDEA-US###-<DESCRIPTOR>.md` stating which
components a story reuses and describing any it needs that do not yet exist.

## How to work here

- **Routing:** produced by `workflows/07-component-designs/` during the story's own specify pass.
  Check `code/src/django/components/` and `../CONSOLIDATED-IDEAS/` before proposing anything.
- **Model:** Fable when the story proposes a new component; Opus when the record is "reused
  existing", which is most of them.
- **Concrete steps:** copy `COMP-IDEA-US000-TEMPLATE.md` → `COMP-IDEA-US###-<DESCRIPTOR>.md` →
  list components reused → for anything new, describe what it must **do**, its states, and the
  nearest existing component → note similarities to earlier stories' records → stop.
- **Definition of done:** every component the story's UI needs is listed as reused or described
  as new; each new one names its nearest existing neighbour; all required states enumerated.

## Guardrails

- **Never run the generator here.** `components.py` is re-run once, at consolidation.
- **Describe the need, do not design the component.** A finished design makes two stories'
  near-identical needs look like two deliberate components at consolidation, which is exactly
  the merge that then gets missed.
- **Do not merge with an earlier story's record.** Note the similarity; `17` decides.
- **Reuse before proposing** — check the django-components library first.
- **Enumerate every state** the component needs (default, hover, focus, disabled, error,
  success, empty). A need described only in its resting state cannot be consolidated safely.
- **Accessibility is part of the need** — state the keyboard interaction and focus behaviour,
  not just the visual (`code/docs/ACCESSIBILITY.md`).
- **Frozen once `17` runs** — corrections go to `../CONSOLIDATED-IDEAS/`.
- One record per story; keep it short.

## Output & naming

- **Hand-written:** `COMP-IDEA-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Template:** `COMP-IDEA-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none — `../component-build/` is untouched at this stage.
- Descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
