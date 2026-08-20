@./CONTEXT.md

# CLAUDE.md — workflows/06-brand-guides/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, four-stage brand flow, key concepts — imported above) → this file.

## Purpose (one line)

Establish or update the visual brand identity — colour palette, typography, spacing,
logos — as internal decision records that feed the DB-driven design token system, before
component design begins.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. Design phase — no code safety
  gates. Four stages: ideate (Claude Design) → record (`src/06-BRAND-GUIDE/`) → present
  (Brand Guide Figma, client-facing) → implement (Component Library + token system).
- **Model:** Fable — brand and token decisions are substantive.
- **Concrete steps:** confirm no in-progress component design depends on tokens you are
  changing → document finalised values (hex, typeface names, spacing scale, logo
  variants) as the `BRAND-*.md` records → check contrast and legibility
  (`code/docs/ACCESSIBILITY.md`) → these records are the spec Claude reads when building
  the Figma Component Library.
- **Definition of done:** decision records complete and self-consistent; any change to
  existing tokens carries a token migration plan; checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Token-first.** Brand values are DB-canonical; how a value enters the token layer is
  `code/docs/DESIGN-TOKENS.md`. Never a raw literal in component CSS. Breakpoints are
  build-time only, **not** DB-driven.
- **A change that alters existing tokens requires a token migration plan** — do not
  silently rewrite live values.
- Colour contrast WCAG AA 4.5:1; the Brand Guide Figma file is client-facing — keep it
  presentation-ready.
- Documentation only — no code.

## Output & naming

- **Hand-written:** `BRAND-COLOURS.md`, `BRAND-TYPOGRAPHY.md`, `BRAND-SPACING.md`,
  `BRAND-LOGOS.md` in `src/06-BRAND-GUIDE/`; `STEPS.md`/`CHECKLIST.md` updates.
- **Downstream (not in this folder):** Figma files, and the design token models a later story will
  build to the contract in `code/docs/DESIGN-TOKENS.md`.
- Documentation files `SCREAMING-SNAKE-CASE.md`; dates DD/MM/YYYY.
