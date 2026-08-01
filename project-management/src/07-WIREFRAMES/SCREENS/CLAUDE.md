@./CONTEXT.md

# CLAUDE.md — src/07-WIREFRAMES/SCREENS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the template, authoring steps — imported above) → this file.

## Purpose (one line)

The wireframe screens — one self-contained `WF-###-<Screen-Name>.html` per screen,
composed from the shared chrome and opening directly over `file://`.

## How to work here

- **Routing:** wireframe work follows `project-management/workflows/07-wireframes/`
  (`STEPS.md` + `CHECKLIST.md`). A screen visualises a user story and its
  `../../04-USER-FLOW/` narrative; it consumes `../SHARED/wireframe.css`.
- **Model:** Fable for designing a new screen (layout, hierarchy, annotations);
  Opus for mechanical touches — renaming a `WF-###` file, a copy fix, a date bump.
- **Concrete steps:** copy `WF-000-TEMPLATE.html` → `WF-###-<Screen-Name>.html` →
  compose from the `wf-*` classes → number regions with `wf-note` and explain them
  in `wf-annotations` → open in a browser across breakpoints → cross-link the story.
- **Definition of done:** the screen renders cleanly over `file://` at every
  declared breakpoint; links to its story; annotations explain each key region;
  British English throughout.

## Guardrails

- **Self-contained only.** No CDN, no JavaScript framework or transpiler, no external
  fonts or icon kits; icons are inline SVG. The only dependency is
  `../SHARED/wireframe.css`.
- **Documentation, not shipped code** — these prototypes never import from or
  deploy with `code/src/`. They inform the build; they are not it. The build is a
  Django template + django-components (HTMX/Alpine, token CSS) under `code/src/django/`.
- **Token-first.** Screens reference only `--wf-*` variables and `wf-*` classes —
  never a raw colour or spacing literal. Rebrand via `../SHARED/wireframe.css`.
- **Placeholder brand.** The base template ships one generic screen; a project
  adds its own screens. Keep the look in step with the brand guide and components.
- Every new directory needs a `CONTEXT.md` and a `CLAUDE.md`.

## Output & naming

- **Hand-written:** `WF-000-TEMPLATE.html` and each `WF-###-<Screen-Name>.html`.
- **Generated:** none — screens are authored by hand from the template.
- Screens `WF-###-<Screen-Name>.html` (zero-padded number); dates DD/MM/YYYY.
