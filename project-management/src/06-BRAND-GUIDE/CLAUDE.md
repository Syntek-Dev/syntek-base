@./CONTEXT.md

# CLAUDE.md — src/06-BRAND-GUIDE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three stages over one deliverable, imported above) → this file → the target sub-folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The brand store — per-story token needs (`USER-STORY-IDEAS/`), the unified token set they are
reconciled into (`CONSOLIDATED-IDEAS/`), the per-story record of what shipped
(`IMPLEMENTATION/`), and the one cumulative PDF deliverable in `guide-build/`.

## How to work here

- **Routing:** stage 1 from `workflows/06-brand-guides/`, stage 2 from
  `workflows/18-consolidate-design-work/`, stage 3 from
  `workflows/22-implementation-documentation/`. Build mechanics: `guide-build/CLAUDE.md`.
- **Model:** Fable for token decisions (colour roles, type scale, voice) and for consolidation;
  Opus for mechanical touches — running the generator, a version bump, a wording fix.
- **Concrete steps:** pick the stage → copy that folder's template → record the tokens →
  **at consolidation only**, edit `INPUTS` in `guide-build/brand_guide.py`, run
  `python3 brand_guide.py`, check `--check` passes, and commit `.py`, `.tex`, `.pdf` together.
- **Definition of done:** the artefact is in the right stage folder and named to convention;
  after consolidation the PDF reflects the current tokens; contrast verified; British English.

## Guardrails

- **The PDF is regenerated at consolidation, not per story.** A stage-1 record states what a
  story needs; it does not touch `guide-build/`. Re-running the generator for every story
  produces a deliverable that churns without ever being decided.
- **Generated artefacts are never hand-edited.** `brand-guide.tex` and `brand-guide.pdf` come
  from `brand_guide.py`; change a token and re-run. A hand-edit breaks `--check`.
- **Never edit `USER-STORY-IDEAS/` once `17` has run** — stage 1 is the frozen record of what
  each story asked for.
- **Token-first.** For values that also live in code the DB-canonical token layer is
  authoritative (`code/docs/DESIGN-TOKENS.md`); this folder documents the brand, it does not
  sanction raw literals in component CSS.
- **Keep the palette in step with `../07-COMPONENTS/`** — the two PDFs must read as one system.
- **Contrast is a gate, not a preference** — WCAG AA 4.5:1 (`code/docs/ACCESSIBILITY.md`).
  A consolidated palette that fails it is not consolidated.
- **Documentation only** — no application code or secrets. `CONTEXT.md`/`CLAUDE.md` files stay
  ≤ 300 code lines; the generator and its outputs are exempt.

## Output & naming

- **Hand-written:** the stage records from their templates, and `guide-build/brand_guide.py`.
- **Templates:** `BRAND-IDEA-US000-TEMPLATE.md`, `BRAND-CONSOLIDATED-000-TEMPLATE.md`,
  `BRAND-IMPL-US000-TEMPLATE.md` — the copy sources; do not delete or repurpose.
- **Generated (never hand-edit):** `guide-build/brand-guide.tex` and `brand-guide.pdf`, both
  committed so the deliverable is viewable without a build.
- `BRAND-IDEA-US###-<DESCRIPTOR>.md` · `BRAND-CONSOLIDATED-<DOMAIN>.md` ·
  `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; stories `US###`; dates DD/MM/YYYY.
