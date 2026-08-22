@./CONTEXT.md

# CLAUDE.md — src/06-BRAND-GUIDE/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/06-BRAND-GUIDE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, the resolution log — imported above) → this file.

## Purpose (one line)

Stage-2 decided token set — one `BRAND-CONSOLIDATED-<DOMAIN>.md` per domain, settling every
per-story ask and driving the single regeneration of `../guide-build/`.

## How to work here

- **Routing:** produced only by `workflows/18-consolidate-design-work/`, after every story has
  cleared `17-story-plans`. Consolidate alongside `../../07-COMPONENTS/CONSOLIDATED-IDEAS/` —
  the two share a palette and drift apart if done separately.
- **Model:** Fable throughout — deciding that three near-identical greys are one token is brand
  judgement. Opus only for running the generator and committing its outputs.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` ask → group near-duplicates →
  decide the canonical value for each → record accepted and rejected asks with reasons →
  verify every contrast pairing → edit `INPUTS` in `../guide-build/brand_guide.py` → run
  `python3 brand_guide.py` → confirm `--check` passes → commit `.py`, `.tex`, `.pdf` together.
- **Definition of done:** every stage-1 ask is accepted or rejected with a reason; no two tokens
  in the set are functionally interchangeable; every pairing meets AA; the PDF reflects the
  decided set; the component palette matches; British English.

## Guardrails

- **Never edit `../USER-STORY-IDEAS/`.** Stage 1 is the frozen record of what each story asked.
- **Record rejections, not just acceptances.** A rejected ask with no reason gets re-proposed
  next cycle, and the same conversation happens again.
- **Contrast is a gate.** A consolidated value that fails WCAG AA 4.5:1 on a stated pairing is
  changed, not annotated (`code/docs/ACCESSIBILITY.md`).
- **Keep the palette identical to `../../07-COMPONENTS/`** — two PDFs that disagree on the brand
  read as two brands.
- **Regenerate exactly once per cycle.** The generator run belongs here and nowhere else.
- **Generated artefacts are never hand-edited** — change `brand_guide.py` and re-run; a
  hand-edit breaks `--check`.
- **Consolidation never adds scope.** A token nobody asked for is not consolidation.
- **A token change must correct any story plan that assumed the old value.**

## Output & naming

- **Hand-written:** `BRAND-CONSOLIDATED-<DOMAIN>.md`, from the template; and the `INPUTS` edit
  in `../guide-build/brand_guide.py`.
- **Template:** `BRAND-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete.
- **Generated (never hand-edit):** `../guide-build/brand-guide.tex` and `brand-guide.pdf`.
- `<DOMAIN>` in `SCREAMING-KEBAB-CASE`; asking stories cited as `US###`; dates DD/MM/YYYY.
