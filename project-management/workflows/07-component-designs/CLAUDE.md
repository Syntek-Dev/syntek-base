@./CONTEXT.md

# CLAUDE.md — workflows/07-component-designs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(responsive behaviour, the 13 breakpoints, key concepts — imported above) → this
file.

## Purpose (one line)

Design reusable UI components from brand tokens — after brand guides are agreed
and before wireframing feature screens.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. **Hard gate:**
  `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA must inform every component from the start.
- **Model:** Fable — component and state design is substantive.
- **Concrete steps:** confirm brand tokens exist and user flows are agreed → **check
  the django-components library (`code/src/django/components/`) first and reuse** if a
  component covers the need → design every state (default, hover, focus, disabled, error, success,
  empty) → hold the design across the CONTEXT.md breakpoint set → record it in
  `src/07-COMPONENTS/USER-STORY-IDEAS/`, naming the django-component it maps to.
- **Definition of done:** all states designed; tokens (no raw hex) used throughout; every
  component mapped to a django-component or recorded as new; checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Reuse before design** — the django-components library (`code/src/django/components/`) is
  checked first; a token override on an existing component beats a new one.
- **Tokens only, never raw hex** in component designs (`code/docs/DESIGN-TOKENS.md`) —
  mirrors the token-first CSS rule that binds the eventual implementation.
- **Mobile-first, and checked at both ends** — designed at 360 px portrait, sanity-checked
  at 320 px and 10240 px. A component adapts to its container, not the viewport
  (`code/docs/responsive/CONTAINER-QUERIES.md`).
- Desktop threshold W ≥ 1024 takes the desktop navbar; below it, the mobile navbar.
- Documentation and design only — no code in this folder.

## Output & naming

- **Hand-written:** component design specs in `src/07-COMPONENTS/`; `STEPS.md`/
  `CHECKLIST.md` updates.
- **Downstream (not here):** the `component-build/` PDF, regenerated at consolidation;
  implemented components in `code/src/django/components/`.
- Documentation files `SCREAMING-SNAKE-CASE.md`; dates DD/MM/YYYY.
