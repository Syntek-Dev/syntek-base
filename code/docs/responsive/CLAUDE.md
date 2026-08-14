@./CONTEXT.md

# CLAUDE.md — code/docs/responsive/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The responsive-design sub-documents behind `code/docs/RESPONSIVE-DESIGN.md` —
breakpoints, container queries, media queries, and user-preference handling
(dark mode, reduced motion).

## How to work here

- **Routing:** documentation, not code — `doc-writer` or
  `frontend` skill; governs `stack-htmx-templates` layout work. Opus for
  substantive edits; Opus for mechanical touches.
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/RESPONSIVE-DESIGN.md`
  a thin index → breakpoint and query values must match the shipped token layer, not
  invented numbers. CSS examples are mobile-first.
- **Definition of done:** breakpoints and preference queries match the design-token
  source of truth; each file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- **Token-first CSS in every example** — breakpoints and spacings come from
  `var(--token)`; never document a raw literal that would bypass the token layer.
- Keep the four concerns distinct (`BREAKPOINTS`, `CONTAINER-QUERIES`,
  `MEDIA-QUERIES`, `USER-PREFERENCES`) — do not merge scope.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/RESPONSIVE-DESIGN.md`.
