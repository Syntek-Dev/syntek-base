# project-management/src/06-BRAND-GUIDE/guide-build

The brand-guide build. A single Python generator holds the brand tokens as its source of
truth, emits a LaTeX document, and compiles it to the deliverable PDF via xelatex.

## Directory Tree

```text
project-management/src/06-BRAND-GUIDE/guide-build/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules for this folder
├── brand_guide.py      ← SOURCE OF TRUTH — brand tokens + rules, and the LaTeX renderer
├── brand-guide.tex     ← GENERATED — do not hand-edit
└── brand-guide.pdf     ← GENERATED — the deliverable brand guide (gitignored)
```

## How it works

`brand_guide.py` is the only file you edit. Its `INPUTS` section holds the brand tokens
(colour, typography, spacing, radius, logo rules, voice, and the appendix tokens). Running it
regenerates `brand-guide.tex` and compiles `brand-guide.pdf`; swatches, type specimens, and
spacing bars are drawn from the token data, so the PDF always matches the values in the script.

```text
python3 brand_guide.py            # regenerate brand-guide.tex + brand-guide.pdf
python3 brand_guide.py --no-pdf   # regenerate the .tex only (skip xelatex)
python3 brand_guide.py --check    # verify the committed .tex is up to date; writes nothing
```

## Dependencies

- **xelatex** (`texlive-xetex`) on `PATH`, plus the **TeX Gyre Heros** and **DejaVu Sans Mono**
  fonts (both ship with a standard texlive install). No Python dependencies — standard library only.

## Sibling & cross-references

- `../CONTEXT.md` — the brand-guide folder these build files belong to
- `../../00-ASSETS/LOGOS/` — logo source files referenced by the guide's logo rules
- `code/docs/DESIGN-TOKENS.md` — the code-side (DB-canonical) design-token system

**Last Updated**: <%DATE%>
