@./CONTEXT.md

# CLAUDE.md — src/08-WIREFRAMES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three stages, mobile constraints — imported above) → this file → the target sub-folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The wireframe store — per-story screens (`USER-STORY-IDEAS/`), the unified screen set rebuilt on
the consolidated components (`CONSOLIDATED-IDEAS/`), the per-story record of what shipped
(`IMPLEMENTATION/`), and the cumulative `SHARED/wireframe.css` every screen links.

## How to work here

- **Routing:** stage 1 from `workflows/08-wireframes/`, stage 2 from
  `workflows/17-consolidate-design-work/`, stage 3 from
  `workflows/21-implementation-documentation/`. A screen visualises a story and its
  `../05-USER-FLOW/` narrative.
- **Model:** Fable for designing a screen or extending the shared chrome; Opus for mechanical
  touches — renaming a `WF-###` file, a copy fix, a date bump.
- **Concrete steps:** pick the stage → copy the relevant template → compose from the `wf-*`
  classes → number key regions with `wf-note` and explain them in `wf-annotations` → open in a
  browser at every declared breakpoint → cross-link the story.
- **Definition of done:** the screen renders cleanly over `file://` at every breakpoint; links
  to its story; annotations explain each key region; British English.

## Guardrails

- **Self-contained only.** No CDN, no JavaScript framework or transpiler, no external fonts or
  icon kits — screens must open over `file://` with nothing to fetch. Fonts are system stacks;
  icons are inline SVG; the only dependency is `SHARED/wireframe.css`.
- **Documentation, not shipped code** — these prototypes never import from or deploy with
  `code/src/`. They inform the build; they are not it.
- **Token-first.** Screens reference only `--wf-*` variables and `wf-*` classes — never a raw
  colour or spacing literal. Rebrand via `SHARED/wireframe.css`.
- **Stage 2 rebuilds on the consolidated components.** A consolidated screen still carrying a
  story's bespoke card or badge has not been consolidated.
- **Never edit `USER-STORY-IDEAS/` once `17` has run.**
- **A mobile wireframe must not depend on hover, scrollbars, or browser chrome** — none exists
  natively, so intent carried by them does not survive the crossing.
- **Keep the palette in step with `../06-BRAND-GUIDE/` and `../07-COMPONENTS/`** so the design
  family reads as one system.
- Every new directory needs a `CONTEXT.md` and a `CLAUDE.md`; instructional files ≤ 300 code
  lines (the screens and templates are exempt).

## Output & naming

- **Hand-written:** `SHARED/wireframe.css` and every screen; the stage records from their
  templates.
- **Generated:** none — screens are authored by hand.
- Stage 1 `WF-IDEA-US###-<Screen-Name>.html`; stage 2 `WF-###-<Screen-Name>.html` plus
  `WF-CONSOLIDATED-<AREA>.md`; stage 3 `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Mobile
  screens carry a `MOBILE` marker and share their web counterpart's number. Dates DD/MM/YYYY.
