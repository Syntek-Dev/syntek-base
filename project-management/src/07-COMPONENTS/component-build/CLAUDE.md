@./CONTEXT.md

# CLAUDE.md — src/07-COMPONENTS/component-build/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(build layout, run commands, requirements — imported above) → this file.

## Purpose (one line)

The component-library build — a Python generator (`components.py`) that holds the shared token
palette as its source of truth, renders an indicative UI kit with LaTeX/tcolorbox, and compiles
the deliverable `components.pdf` with xelatex.

## How to work here

- **Model:** Fable for component/token decisions (which components, variants, states); Opus for
  mechanical touches — running the generator, a rename, a wording fix.
- **Concrete steps:** edit the palette `INPUTS` in `components.py`, or a `section-<name>.tex`
  partial (never the generated files) → run `python3 components.py` → visually check
  `components.pdf` → commit the `.py`, the `section-*.tex`, the `.tex`, and the `.pdf` together.
- **Definition of done:** `components.py --check` passes; the PDF compiles cleanly and matches
  the current tokens; the palette stays in step with the brand guide; British English.

## Guardrails

- **`components.tex` and `components.pdf` are generated — never hand-edit them.** Change the
  Python source and re-run; a hand-edit is overwritten and breaks `--check`.
- **Shared palette.** The colour palette mirrors
  `../../06-BRAND-GUIDE/guide-build/brand_guide.py`; keep the two in sync so the brand guide and
  component sheet look like one system.
- **Section macros only.** Component sections are written against the `tcolorbox` macro contract
  defined in the preamble (`\uibtn`, `\uibadge`, `\uialert`, `uicard`, …). Add a new macro to
  the preamble rather than scattering raw `tcolorbox` options through sections.
- **Standard library + portable fonts only** — no Python dependencies; fonts guaranteed by a
  stock texlive (TeX Gyre Heros, DejaVu Sans Mono). The generator compiles in a temp directory,
  so no `.aux`/`.log`/`.out` is ever left here.

## Output & naming

- **Hand-written:** `components.py` (palette + assembly) and the `section-<name>.tex` partials.
- **Generated (never hand-edit):** `components.tex`, `components.pdf` — both committed so the
  deliverable is viewable without a build step; regenerate from the source on change.
