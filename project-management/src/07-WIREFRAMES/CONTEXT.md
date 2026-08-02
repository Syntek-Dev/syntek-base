# project-management/src/07-WIREFRAMES

Wireframes for the project — self-contained HTML screen prototypes. Each screen is
a single HTML file that opens directly in a browser over `file://`: no build step,
no CDN, no JavaScript framework, no external fonts or icon kits. Screens share one
stylesheet that carries the placeholder-brand palette and chrome.

## Directory Tree

```text
project-management/src/07-WIREFRAMES/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules for this folder
├── SHARED/           ← the shared stylesheet (palette + chrome)
│   ├── CONTEXT.md
│   ├── CLAUDE.md
│   └── wireframe.css
└── SCREENS/          ← one HTML file per screen
    ├── CONTEXT.md
    ├── CLAUDE.md
    └── WF-000-TEMPLATE.html   ← copy this to start a new screen
```

## How the wireframes work

Two things make up a wireframe: the **shared chrome** in `SHARED/wireframe.css`
(the `:root { --wf-* }` palette plus all `wf-*` classes — header, hero, cards,
form, footer, buttons, media placeholder, and the annotation system) and each
**screen** in `SCREENS/`, a plain HTML file that links that stylesheet and
composes its layout from those classes. A screen carries intent through numbered
`wf-note` markers keyed to a `wf-annotations` list — the wireframe way of saying
what each region is for, without finished copy.

The base template ships **one generic screen**, `SCREENS/WF-000-TEMPLATE.html`,
on a placeholder brand. A project creating wireframes copies it per screen
(`WF-001-…`, `WF-002-…`) and rebrands by editing the `--wf-*` tokens in
`SHARED/wireframe.css` — nothing references a raw colour.

## Naming Convention

| Pattern                     | Example                | Used for                    |
| --------------------------- | ---------------------- | --------------------------- |
| `WF-000-TEMPLATE.html`      | (as shipped)           | The starting-point template |
| `WF-###-<Screen-Name>.html` | `WF-001-Homepage.html` | One file per project screen |

## Dependencies

- **None external.** Screens depend only on `SHARED/wireframe.css`. Fonts are
  system stacks; icons are inline SVG. Everything opens over `file://`.

## Cross-references

- `SHARED/CONTEXT.md` · `SCREENS/CONTEXT.md` — the two sub-folders
- `../04-USER-FLOW/` — the user-flow narratives the wireframes visualise
- `../05-BRAND-GUIDE/` · `../06-COMPONENTS/` — the brand guide and component sheet
  the wireframe palette mirrors
- `project-management/workflows/07-wireframes/` — the wireframe workflow
- `code/docs/DESIGN-TOKENS.md` — the code-side, DB-canonical design-token system

**Last Updated**: <%DATE%>
