@./CONTEXT.md

# CLAUDE.md — src/05-BRAND-GUIDE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what the guide covers, build layout — imported above) → this file → the
`guide-build/` sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The brand guidelines — delivered as a PDF generated from `guide-build/brand_guide.py`, which
holds the brand tokens (colour, typography, spacing, logo rules, voice) as its single source of
truth and typesets them with LaTeX.

## How to work here

- **Routing:** brand work starts from `project-management/workflows/05-brand-guides/`
  (`STEPS.md` + `CHECKLIST.md`). All authoring happens in `guide-build/brand_guide.py` — see
  `guide-build/CLAUDE.md` for the build mechanics.
- **Model:** Fable for brand-token decisions (colour roles, type scale, voice); Opus for
  mechanical touches — running the generator, a version bump, a wording fix.
- **Concrete steps:** edit the `INPUTS` in `guide-build/brand_guide.py` → run
  `python3 brand_guide.py` → visually check `brand-guide.pdf` → cross-link the driving `US###`
  → commit the `.py`, `.tex`, and `.pdf` together.
- **Definition of done:** the PDF compiles cleanly and reflects the current tokens;
  `brand_guide.py --check` passes; British English; DD/MM/YYYY dates.

## Guardrails

- **Generated artefacts are never hand-edited.** `brand-guide.tex` and `brand-guide.pdf` are
  produced from `brand_guide.py`; change a token in the script and re-run.
- **Token-first still applies.** For values that also live in code, the DB-canonical token
  layer is authoritative (`code/docs/DESIGN-TOKENS.md`); the guide documents the brand, it does
  not sanction raw literals in component CSS.
- **Documentation only** — no application code or secrets. `CONTEXT.md`/`CLAUDE.md` files stay
  ≤ 300 code lines; the generator script and its outputs are exempt. Every new directory needs
  a `CONTEXT.md` and a `CLAUDE.md`.

## Output & naming

- **Hand-written:** `guide-build/brand_guide.py` (the source of truth).
- **Generated (never hand-edit):** `guide-build/brand-guide.tex` and
  `guide-build/brand-guide.pdf` — both committed so the deliverable is viewable without a build.
