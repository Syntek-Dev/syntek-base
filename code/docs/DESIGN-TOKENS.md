---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Design Token System

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Claude Model:** opus — Architecture review, schema design, frontend integration patterns
**MCP Servers:** code-review-graph (impact analysis before implementation)

**Status: declared, not wired.** The token layer, the `/assets/tokens.css` view and the git
write-back arrive with the `design_tokens` app; what exists today is this contract.

---

## Overview

The design-token system **will make** every UI value (colour, typography, spacing, shadow, radius,
motion, surface, z-index, breakpoint) **database-canonical** and editable from the custom `/admin/`
admin area. PostgreSQL will be the source of truth; a generator will render the values to a single
CSS cascade that Django serves as a stylesheet and persists back to the repo (git write-back).
There is **no Node server** — the CSS will be a plain file served by Django.

```text
PostgreSQL (DesignToken + DesignTokenValue rows)
  → services/render.py  (renders :root + theme + preference cascade)
    → Django-served CSS file (/assets/tokens.css)  +  git write-back (tokens CSS file)
      → CSS custom properties consumed by every component via var(--token)      [web surface]

  → services/render.py  (render_tokens_ts — same rows, second emitter)
    → typed TypeScript module, published by the same git write-back
      → StyleSheet values imported from @/tokens                            [mobile surface]
```

> **The no-rebuild promise is web-only.** Editing a token **will be** live on the web with no
> frontend rebuild. On the **mobile surface** the emitted module **will be** compiled into the
> application, so a token change reaches an installed app only via a rebuild and a store release. Never state the
> promise unqualified. See [design-tokens/MOBILE.md](design-tokens/MOBILE.md).

The seed source of the database **will be** the CSS token layer that arrives with it —
`surfaces.css` among those stylesheets — so the DB and the committed CSS stay two views of one
truth.

---

## The token-first law

Design values are **DB-canonical**. The rules below are non-negotiable across every template,
django-component, and CSS file:

1. **New design values enter via the editor** (`/admin/design-tokens`) **or a migration** — never
   as a raw literal (colour, length, shadow, duration, …) in component or page CSS.
2. **Component and page CSS only ever consume `var(--token)`.** No hard-coded visual values.
3. **The referenced var name must resolve** to a token defined in the styling layer
   (`surfaces.css` among those stylesheets), which becomes the DB seed source.

Rule 3 is **enforced in CI** by `code/src/scripts/audits/css-tokens.sh` (and the
`audit-css-tokens.yml` workflow): any `var(--x)` that resolves nowhere fails the build, because a
phantom custom property is silently dropped by Lightning CSS. There is **no separate raw-literal
gate** — `css-tokens.sh` is the single enforcement point. A raw-literal detector would only be
advisory; do not add it as a failing script.

### The law on the mobile surface

Rules 1–3 are written in CSS, so the **enforcement clause** — not the law — is restated for the
optional mobile surface. There, `StyleSheet` values **will come** only from the generated token
module, never a raw literal, enforced by `code/src/scripts/audits/mobile-tokens.sh`. Only the
no-raw-literals half needs a script: the emitted module is typed, so an unresolved token import
will not compile and `typecheck.sh` **will fail** the build. Detail:
[design-tokens/MOBILE.md](design-tokens/MOBILE.md).

Run the guard locally before raising a PR:

```bash
bash code/src/scripts/audits/css-tokens.sh
```

> **Adding a value:** add the token to the CSS token layer (the seed source) **and** via the
> editor/DB, then reference it with `var(--token)`. Do not write the literal inline.

### Locked tokens (dedicated, never aliased)

Some values must keep their OWN specific registered colour so a palette change can never shift
them. The **presence-status** tokens — `--presence-online` (a specific green), `--presence-unavailable`
(a specific amber), `--presence-offline` (a specific red) — are the canonical example:

- They are **literal specific values, NOT aliases** of a semantic token — never
  `--presence-online: var(--color-success)`. Each carries a locked hex.
- They are DB-canonical (a `design_tokens` migration **will seed** them with
  `is_editable=False` = system-locked, not editable via the editor) **and** declared in the token
  layer's `colours.css`, so `var(--presence-*)` **will resolve** for `css-tokens.sh` and
  `render_current_css` **will emit** them.
- Consuming CSS uses ONLY these tokens for the status colour (e.g. a presence dot in
  `components/chat_thread.css`); the non-colour dot SHAPE carries the a11y load (WCAG 1.4.1).

Use this pattern for any value whose meaning must survive an unrelated palette change.

---

## Sub-documents

The deep specification is split to stay within the 300-line instructional limit. Read the topic you
need:

| Document                                             | Covers                                                                              |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [design-tokens/MODEL.md](design-tokens/MODEL.md)     | The two models, 9 categories, `value_kind`, reference-only/themeable/editable flags |
| [design-tokens/CASCADE.md](design-tokens/CASCADE.md) | The six preference axes, the justification rule, the render cascade, and delivery   |
| [design-tokens/EDITOR.md](design-tokens/EDITOR.md)   | The `/admin/design-tokens` editor, governance, extension points, and known drift    |
| [design-tokens/MOBILE.md](design-tokens/MOBILE.md)   | The mobile bridge — six colour forms, gamut mapping, the TS emitter, what collapses |

---

## Critical constraint — breakpoints

CSS custom properties **cannot be used inside `@media` query conditions** (CSS specification
restriction). Breakpoint tokens **will be stored** as the `breakpoint` DB category with
`is_reference_only=True` — they are documentation/reference rows and are **never emitted to a CSS
rule**. The actual pixel values are baked into `@media` conditions in the CSS. See
[responsive/BREAKPOINTS.md](responsive/BREAKPOINTS.md). All other categories work as runtime CSS
variables.

---

## Cross-references

- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — token-first CSS consumption rules, component
  placement, and the BEM convention
- `code/docs/responsive/USER-PREFERENCES.md` — the preference cascade the generator emits
- `code/docs/responsive/BREAKPOINTS.md` — reference-only breakpoint tokens
- `code/src/scripts/audits/css-tokens.sh` — phantom-token enforcement (the token-first gate)
- `.claude/CLAUDE.md` Section 6 — the token-first non-negotiable
