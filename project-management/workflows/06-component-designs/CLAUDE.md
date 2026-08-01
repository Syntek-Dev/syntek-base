@./CONTEXT.md

# CLAUDE.md — workflows/06-component-designs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(constraint-based layout rules, 13 breakpoints, key concepts — imported above) → this
file.

## Purpose (one line)

Design reusable UI components in Figma from brand tokens — after brand guides are agreed
and before wireframing feature screens.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. **Hard gate:**
  `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA must inform every component from the start.
- **Model:** Fable — component and state design is substantive.
- **Concrete steps:** confirm brand tokens exist and user flows are agreed → **check
  the django-components library (`code/src/django/components/`) first and reuse** if a
  component covers the need → design every state (default, hover, focus, disabled, error, success,
  empty) → build with `layoutMode: 'NONE'` and explicit Figma child constraints per the
  CONTEXT.md table → map to code via Figma Code Connect.
- **Definition of done:** all states designed; tokens (no raw hex) used throughout;
  Code Connect mapping in place; checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Reuse before design** — the django-components library (`code/src/django/components/`) is
  checked first; a token override on an existing component beats a new one.
- **Tokens only, never raw hex** in component designs (`code/docs/DESIGN-TOKENS.md`) —
  mirrors the token-first CSS rule that binds the eventual implementation.
- **Constraint-based responsiveness only:** `layoutMode: 'NONE'` with explicit child
  constraints; instances resized `inst.resize(breakpointWidth, inst.height)`. Do **not**
  use proportional scaling — tall components balloon at large breakpoints. Correct an
  existing component by in-place rebuild on the same COMPONENT node so instances
  auto-update.
- Desktop threshold W ≥ 1024 → `Navbar/Desktop`; below → `Navbar/Mobile`.
- Documentation and design only — no code in this folder.

## Output & naming

- **Hand-written:** component design specs in `src/06-COMPONENTS/`; `STEPS.md`/
  `CHECKLIST.md` updates.
- **Downstream (not here):** Figma component library; implemented components in
  `code/src/django/components/`.
- Documentation files `SCREAMING-SNAKE-CASE.md`; dates DD/MM/YYYY.
