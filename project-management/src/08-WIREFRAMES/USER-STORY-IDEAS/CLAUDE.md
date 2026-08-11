@./CONTEXT.md

# CLAUDE.md — src/08-WIREFRAMES/USER-STORY-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/08-WIREFRAMES/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-1 scope, authoring steps — imported above) → this file.

## Purpose (one line)

Stage-1 per-story screens — self-contained `WF-IDEA-US###-<Screen-Name>.html` wireframes for the
screens one story introduces, composed from `../SHARED/wireframe.css`.

## How to work here

- **Routing:** produced by `workflows/08-wireframes/` during the story's own specify pass. A
  screen visualises the story and its `../../05-USER-FLOW/USER-STORY-IDEAS/` fragment.
- **Model:** Fable for designing a screen (layout, hierarchy, annotations); Opus for mechanical
  touches — a rename, a copy fix, a date bump.
- **Concrete steps:** copy `WF-IDEA-US000-TEMPLATE.html` → `WF-IDEA-US###-<Screen-Name>.html` →
  compose from the `wf-*` classes → number regions with `wf-note` and explain them in
  `wf-annotations` → open in a browser across breakpoints → cross-link the story.
- **Definition of done:** renders cleanly over `file://` at every declared breakpoint;
  annotations explain each key region; every interactive element has a defined state; links to
  its story; British English.

## Guardrails

- **Self-contained only.** No CDN, no JS framework, no external fonts or icon kits; icons are
  inline SVG. The only dependency is `../SHARED/wireframe.css`.
- **Token-first** — only `--wf-*` variables and `wf-*` classes; never a raw colour or spacing
  literal.
- **Do not invent a component here.** Use the nearest existing one and note the shortfall in the
  annotations; the need is recorded in `../../07-COMPONENTS/USER-STORY-IDEAS/`. A bespoke
  component drawn into a wireframe is a design decision made in the wrong place.
- **Do not reconcile with another story's screens.** Inconsistency between stories is expected
  and is `17`'s to resolve — smoothing it over here hides what consolidation needs to see.
- **Mobile screens must not rest intent on hover, scrollbars, or browser chrome** — none exists
  natively. Compose at 390 × 844.
- **Documentation, not shipped code** — never imports from or deploys with `code/src/`.
- **Frozen once `17` runs** — the built screens live in `../CONSOLIDATED-IDEAS/`.

## Output & naming

- **Hand-written:** `WF-IDEA-US000-TEMPLATE.html` and each screen.
- **Generated:** none — screens are authored by hand.
- `WF-IDEA-US###-<Screen-Name>.html`; mobile `WF-IDEA-US###-MOBILE-<Screen-Name>.html`, sharing
  its web counterpart's number; story `US###`; dates DD/MM/YYYY.
