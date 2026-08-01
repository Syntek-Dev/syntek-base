@./CONTEXT.md

# CLAUDE.md — src/07-WIREFRAMES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(structure, naming, dependencies — imported above) → this file → the target
sub-folder's `CONTEXT.md`/`CLAUDE.md` (`SHARED/` or `SCREENS/`).

## Purpose (one line)

The wireframe layer — self-contained HTML screen prototypes (`SCREENS/`) composed
from one shared stylesheet (`SHARED/wireframe.css`), derived from the user stories
and user flows and carrying the placeholder-brand palette.

## How to work here

- **Routing:** all wireframe work follows `project-management/workflows/07-wireframes/`
  (`STEPS.md` + `CHECKLIST.md`). A wireframe visualises a user story and its
  `../04-USER-FLOW/` narrative and consumes `SHARED/wireframe.css`. No build step —
  screens open directly in a browser over `file://`.
- **Model:** Fable for designing a new screen or extending the shared chrome; Opus
  for mechanical touches — renaming a `WF-###` file, a copy fix, a header-date bump.
- **Concrete steps:** copy `SCREENS/WF-000-TEMPLATE.html` → `WF-###-<Screen-Name>.html`
  → compose from the `wf-*` classes → number key regions with `wf-note` and explain
  them in `wf-annotations` → open in a browser across breakpoints → cross-link the
  story → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** the screen renders cleanly over `file://` at every declared
  breakpoint; links to its story; new sub-folders carry a `CONTEXT.md` and `CLAUDE.md`;
  British English throughout.

## Guardrails

- **Self-contained only.** No CDN, no JavaScript framework or transpiler, no external
  fonts or icon kits — screens must open over `file://` with nothing to fetch. Fonts are
  system stacks; icons are inline SVG; the only dependency is `SHARED/wireframe.css`.
- **Documentation, not shipped code** — these prototypes never import from or deploy
  with `code/src/`. They inform the implementation; they are not it. What ships is a
  Django template plus django-components (HTMX/Alpine, token CSS) under
  `code/src/django/`, built from this screen — never the wireframe markup itself.
- **Token-first.** Wireframe CSS consumes the `--wf-*` custom properties in
  `SHARED/wireframe.css` — never raw colour or spacing literals. These are indicative
  wireframe tokens, distinct from the DB-canonical `code/docs/DESIGN-TOKENS.md`.
- **Placeholder brand.** The base template ships one generic screen; keep the palette
  in step with `../05-BRAND-GUIDE/` and `../06-COMPONENTS/` so the family reads as one
  system. Every new directory here needs a `CONTEXT.md` and a `CLAUDE.md`.

## Output & naming

- **Hand-written:** `SHARED/wireframe.css`, `SCREENS/*.html`.
- **Generated:** none — screens are authored by hand from the template.
- Screens `WF-###-<Screen-Name>.html` (zero-padded number); sub-folders
  `SCREAMING-SNAKE-CASE/`; dates DD/MM/YYYY.
