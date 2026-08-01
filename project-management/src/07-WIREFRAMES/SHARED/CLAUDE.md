@./CONTEXT.md

# CLAUDE.md — src/07-WIREFRAMES/SHARED/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what `wireframe.css` holds — imported above) → this file.

## Purpose (one line)

The shared wireframe stylesheet — one self-contained `wireframe.css` holding the
placeholder-brand palette and all chrome classes that every screen links.

## How to work here

- **Model:** Fable for palette/chrome decisions (which tokens, which components
  the wireframes need); Opus for mechanical touches — a colour tweak, a new
  utility class, a wording fix.
- **Concrete steps:** edit `:root { --wf-* }` to rebrand, or add a chrome class →
  open any `../SCREENS/*.html` over `file://` to check it renders → keep the hex
  in step with the brand guide.
- **Definition of done:** screens still render cleanly; the palette matches
  `../../05-BRAND-GUIDE/`; no external dependency introduced; British English.

## Guardrails

- **Self-contained only.** No CDN, no `@import`, no external fonts — screens must
  open over `file://` with nothing to fetch. Fonts are system stacks; icons are
  inline SVG in the screens.
- **Token-first.** Every colour in the chrome resolves to a `--wf-*` variable;
  never hard-code a hex outside `:root`. These are indicative wireframe tokens,
  distinct from the DB-canonical `code/docs/DESIGN-TOKENS.md`.
- **Shared palette.** Keep the hex values in step with
  `../../05-BRAND-GUIDE/guide-build/brand_guide.py` and
  `../../06-COMPONENTS/component-build/components.py` so the family stays one system.
- **Documentation, not shipped code** — this stylesheet never deploys with
  `code/src/`. Every new directory needs a `CONTEXT.md` and a `CLAUDE.md`.

## Output & naming

- **Hand-written:** `wireframe.css` — the single shared stylesheet.
- **Generated:** none. Nothing here is machine-produced.
