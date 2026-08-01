---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Design Token System

**Last Updated:** {{DATE}}
**Version:** 0.1.0
**Maintained By:** {{ORG_NAME}}
**Language:** British English (en_GB)
**Status:** Django-served token CSS + git write-back delivery in place.
**Claude Model:** opus — Architecture review, schema design, frontend integration patterns
**MCP Servers:** code-review-graph (impact analysis before implementation)

---

## Overview

The design-token system makes every UI value (colour, typography, spacing, shadow, radius, motion,
surface, z-index, breakpoint) **database-canonical** and editable from the custom `/admin/` admin
area without a frontend rebuild. PostgreSQL is the source of truth; a generator renders the values
to a single CSS cascade that Django serves as a stylesheet and persists back to the repo (git
write-back). There is **no Node server** — the CSS is a plain file served by Django.

```text
PostgreSQL (DesignToken + DesignTokenValue rows)
  → services/render.py  (renders :root + theme + preference cascade)
    → Django-served CSS file (/assets/tokens.css)  +  git write-back (tokens CSS file)
      → CSS custom properties consumed by every component via var(--token)
```

The seed source of the database is the CSS token layer at
`code/src/django/static/css/tokens/*.css` (plus `surfaces.css`), so the DB and the committed CSS
stay two views of one truth.

---

## The token-first law

Design values are **DB-canonical**. The rules below are non-negotiable across every template,
django-component, and CSS file:

1. **New design values enter via the editor** (`/admin/design-tokens`) **or a migration** — never
   as a raw literal (colour, length, shadow, duration, …) in component or page CSS.
2. **Component and page CSS only ever consume `var(--token)`.** No hard-coded visual values.
3. **The referenced var name must resolve** to a token in the styling layer
   (`code/src/django/static/css/tokens/*.css` + `surfaces.css`), which is the DB seed source.

Rule 3 is **enforced in CI** by `code/src/scripts/audits/css-tokens.sh` (and the
`audit-css-tokens.yml` workflow): any `var(--x)` that resolves nowhere fails the build, because a
phantom custom property is silently dropped by Lightning CSS. There is **no separate raw-literal
gate** — `css-tokens.sh` is the single enforcement point. A raw-literal detector would only be
advisory; do not add it as a failing script.

Run the guard locally before raising a PR:

```bash
bash code/src/scripts/audits/css-tokens.sh
```

> **Adding a value:** add the token in `shared/src/css/tokens/` (the seed source) **and** via the
> editor/DB, then reference it with `var(--token)`. Do not write the literal inline.

### Locked tokens (dedicated, never aliased)

Some values must keep their OWN specific registered colour so a palette change can never shift
them. The **presence-status** tokens — `--presence-online` (a specific green), `--presence-unavailable`
(a specific amber), `--presence-offline` (a specific red) — are the canonical example:

- They are **literal specific values, NOT aliases** of a semantic token — never
  `--presence-online: var(--color-success)`. Each carries a locked hex.
- They are DB-canonical (an `apps/design_tokens` migration seeds them with `is_editable=False` =
  system-locked, not editable via the editor) **and** declared in
  `shared/src/css/tokens/colours.css`, so `var(--presence-*)` resolves for `css-tokens.sh` and
  `render_current_css` emits them.
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

---

## Critical constraint — breakpoints

CSS custom properties **cannot be used inside `@media` query conditions** (CSS specification
restriction). Breakpoint tokens are stored as the `breakpoint` DB category with
`is_reference_only=True` — they are documentation/reference rows and are **never emitted to a CSS
rule**. The actual pixel values are baked into `@media` conditions in the CSS. See
[responsive/BREAKPOINTS.md](responsive/BREAKPOINTS.md). All other categories work as runtime CSS
variables.

---

## Cross-references

- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — token-first CSS consumption rules
- `code/docs/responsive/USER-PREFERENCES.md` — the preference cascade the generator emits
- `code/docs/responsive/BREAKPOINTS.md` — reference-only breakpoint tokens
- `code/src/django/apps/design_tokens/CONTEXT.md` — the live app, models, Ninja endpoints, and tasks
- `code/src/django/components/CONTEXT.md` — the django-components library and its BEM conventions
- `code/src/scripts/audits/css-tokens.sh` — phantom-token enforcement (the token-first gate)
- `.claude/CLAUDE.md` §6 — the token-first non-negotiable
