@./CONTEXT.md

# CLAUDE.md — src/06-BRAND-GUIDE/USER-STORY-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/06-BRAND-GUIDE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-1 scope, "reused existing" — imported above) → this file.

## Purpose (one line)

Stage-1 per-story token records — one `BRAND-IDEA-US###-<DESCRIPTOR>.md` stating which brand
tokens a story reuses and which it needs that do not yet exist.

## How to work here

- **Routing:** produced by `workflows/06-brand-guides/` during the story's own specify pass.
  Read `../CONSOLIDATED-IDEAS/` (if a prior cycle ran) and every earlier record here first.
- **Model:** Fable when the story genuinely proposes a new token (that is a brand judgement);
  Opus when the record is "reused existing", which is most of them.
- **Concrete steps:** copy `BRAND-IDEA-US000-TEMPLATE.md` →
  `BRAND-IDEA-US###-<DESCRIPTOR>.md` → list the tokens reused → list any new token the story
  needs, with the reason and the nearest existing value → stop. Do not touch `../guide-build/`.
- **Definition of done:** every token the story's UI depends on is listed as reused or new;
  each new one names the nearest existing token and why it does not serve; British English.

## Guardrails

- **Never run the generator here.** `brand_guide.py` is re-run once, at consolidation. A story
  that regenerates the PDF produces churn in a deliverable nobody has decided yet.
- **Do not decide whether a new token joins the palette.** Record the ask; `17` decides it
  against every other story's asks. A story that unilaterally adds a fourth grey is exactly the
  drift the two-stage model exists to catch.
- **Always name the nearest existing token.** "We need a new grey" is unusable at consolidation;
  "closest is `--color-neutral-400`, too light for AA on our surface" is decidable.
- **Frozen once `17` runs** — corrections go to `../CONSOLIDATED-IDEAS/`.
- **Token-first** — no raw literals proposed for component CSS; a need is expressed as a token
  (`code/docs/DESIGN-TOKENS.md`).
- One record per story; keep it short.

## Output & naming

- **Hand-written:** `BRAND-IDEA-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Template:** `BRAND-IDEA-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none — `../guide-build/` is untouched at this stage.
- Descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
