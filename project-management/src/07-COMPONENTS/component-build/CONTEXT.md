# project-management/src/07-COMPONENTS/component-build

The component-library build. A single Python generator holds the shared token palette as its
source of truth, renders an indicative set of UI components with LaTeX/tcolorbox, and compiles
the deliverable PDF via xelatex.

## Directory Tree

```text
project-management/src/07-COMPONENTS/component-build/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for this folder
├── components.py         ← palette + preamble/macros + assembly + CLI (source of truth)
├── section-buttons.tex   ← SOURCE partial — buttons
├── section-forms.tex     ← SOURCE partial — form controls
├── section-badges.tex    ← SOURCE partial — badges and tags
├── section-alerts.tex    ← SOURCE partial — alerts and banners
├── section-cards.tex     ← SOURCE partial — cards
├── section-navigation.tex ← SOURCE partial — navigation
├── section-avfeedback.tex ← SOURCE partial — avatars and feedback states
├── components.tex        ← GENERATED — do not hand-edit
└── components.pdf        ← GENERATED — the deliverable component sheet (gitignored)
```

## How it works

Two things are source, and together they define the sheet: the **palette + macros** live in
`components.py` (its `INPUTS` hold the shared token palette — the same values as the brand guide,
so the two PDFs match — and its preamble defines the `tcolorbox` macros `\uibtn`, `\uibadge`,
`\uialert`, `uicard`, …); each **component section** is an editable `section-<name>.tex` partial
written against those macros. `components.py` assembles the preamble, cover, and the partials
(in `SECTION_ORDER`) into `components.tex`, then compiles `components.pdf`.

To change a component, edit its `section-<name>.tex` (colours resolve by name from the palette);
to add one, add a partial and its name to `SECTION_ORDER`. Running the generator reassembles both
outputs.

```text
python3 components.py            # regenerate components.tex + components.pdf
python3 components.py --no-pdf   # regenerate the .tex only (skip xelatex)
python3 components.py --check    # verify the committed .tex is up to date; writes nothing
```

The set is **indicative, not a production kit** — enough to give a client a feel for the
interface. The base template ships a generic placeholder brand.

## Dependencies

- **xelatex** (`texlive-xetex`) on `PATH`, the **tcolorbox** package, and the **TeX Gyre Heros**
  and **DejaVu Sans Mono** fonts — all ship with a standard texlive install. No Python
  dependencies (standard library only).

## Cross-references

- `../CONTEXT.md` — the components folder these build files belong to
- `../../06-BRAND-GUIDE/guide-build/brand_guide.py` — the brand guide, which shares this palette
- `code/docs/DESIGN-TOKENS.md` — the code-side (DB-canonical) design-token system

**Last Updated**: <%DATE%>
