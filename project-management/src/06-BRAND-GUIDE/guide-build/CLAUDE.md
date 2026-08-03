@./CONTEXT.md

# CLAUDE.md — src/06-BRAND-GUIDE/guide-build/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(build layout, run commands, requirements — imported above) → this file.

## Purpose (one line)

The brand-guide build — a Python generator (`brand_guide.py`) that holds the brand tokens
as its single source of truth, emits `brand-guide.tex`, and compiles the deliverable
`brand-guide.pdf` with xelatex.

## How to work here

- **Model:** Fable for brand-token decisions (colour roles, type scale, voice); Opus for
  mechanical touches — running the generator, a rename, a wording fix.
- **Concrete steps:** edit the `INPUTS` section of `brand_guide.py` (never the generated
  files) → run `python3 brand_guide.py` → visually check `brand-guide.pdf` → commit the
  `.py`, `.tex`, and `.pdf` together so they stay in lock-step.
- **Definition of done:** `brand_guide.py --check` passes (committed `.tex` matches the
  generator); the PDF compiles cleanly and reflects the current tokens; British English.

## Guardrails

- **`brand-guide.tex` and `brand-guide.pdf` are generated — never hand-edit them.** Change a
  value in `brand_guide.py` and re-run; a hand-edit is overwritten on the next run and breaks
  `--check`.
- **Standard library only** — the generator takes no Python dependencies; keep it that way so
  it runs anywhere with `texlive-xetex`.
- **Portable fonts only** — use fonts guaranteed by a stock texlive (TeX Gyre Heros, DejaVu
  Sans Mono). Do not hardcode a font that may be absent on another machine.
- The generator compiles in a temp directory, so no `.aux`/`.log`/`.out` should ever be left
  here — do not commit LaTeX intermediates.

## Output & naming

- **Hand-written:** `brand_guide.py` (the source of truth).
- **Generated (never hand-edit):** `brand-guide.tex`, `brand-guide.pdf` — both committed so
  the deliverable is viewable without a build step; regenerate from `brand_guide.py` on change.
