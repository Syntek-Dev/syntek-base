# project-management/src/08-WIREFRAMES/SHARED

Shared chrome and placeholder-brand tokens for every wireframe screen. A single
self-contained stylesheet — no CDN, no build step, no external fonts — that every
screen in `../USER-STORY-IDEAS/` and `../CONSOLIDATED-IDEAS/` links.

This folder sits **beside** the three stages rather than inside one, because the
stylesheet is cumulative: stage 1 and stage 2 share it, and stage 1 is frozen while
this file keeps changing.

## Directory Tree

```text
project-management/src/08-WIREFRAMES/SHARED/
├── CONTEXT.md      ← this file
├── CLAUDE.md       ← operating rules for this folder
└── wireframe.css   ← palette (:root --wf-* tokens) + chrome classes
```

## What it holds

`wireframe.css` is the one source of shared look-and-feel:

- **Palette** — the `:root { --wf-* }` custom properties. Hex values mirror the
  brand guide and component sheet (`../../06-BRAND-GUIDE/`, `../../07-COMPONENTS/`)
  so the whole design family reads as one system. Rebrand a project by editing
  these variables — nothing else references a raw colour.
- **Chrome classes** — `wf-header`/`wf-nav`, `wf-hero`, `wf-card`/`wf-grid`,
  `wf-form`/`wf-field`, `wf-footer`, `wf-btn` variants, the `wf-placeholder`
  media stand-in, and the `wf-note` / `wf-annotations` annotation system that
  carries wireframe intent.
- **Breakpoints** — mobile-first; cards and footer reflow at 48rem, a 3-up grid
  at 64rem, nav links collapse below 40rem.

These are **indicative wireframe tokens**, not the code-side DB-canonical design
tokens — those live in `code/docs/DESIGN-TOKENS.md` and are authoritative for the
built product.

## Gated by the slop audit

`wireframe.css` is in scope for `code/src/scripts/audits/css-slop.sh`, alongside
`../CONSOLIDATED-IDEAS/`. It is the only stylesheet the screens have, so gating their
markup without it would leave the audit reporting green having measured nothing. What
it enforces: `code/docs/VISUAL-DESIGN.md` § 4–§ 6, routed from `DESIGN.md` →
_The design-time gate_ — never restated here.

## Cross-references

- `../USER-STORY-IDEAS/CONTEXT.md` · `../CONSOLIDATED-IDEAS/CONTEXT.md` — the screens
  that link this stylesheet
- `../../06-BRAND-GUIDE/` — the brand guide this palette mirrors
- `../../07-COMPONENTS/` — the component sheet sharing the same placeholder palette

**Last Updated**: <%DATE%>
