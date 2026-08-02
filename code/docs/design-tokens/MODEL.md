---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Design Tokens — Data Model

**Last Updated:** <%DATE%>
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Claude Model:** opus — Token schema design, category/value-kind modelling

The `design_tokens` app owns two models. Together they describe one CSS variable: its canonical
`:root` value and any preference-variant overrides. App detail lives in
`code/src/django/apps/design_tokens/CONTEXT.md`.

---

## `DesignToken` — identity + canonical BASE value

One row per CSS custom property. The `value` field holds the canonical `:root` (BASE) value that
every theme and preference inherits from.

| Field               | Notes                                                              |
| ------------------- | ------------------------------------------------------------------ |
| `key`               | CSS var name incl. `--`; unique; validated `^--[a-z0-9-]+$`        |
| `name`              | Human-readable label                                               |
| `value`             | Canonical `:root` (BASE) value                                     |
| `category`          | One of 9 (below)                                                   |
| `value_kind`        | Value grammar (below) — drives validation                          |
| `is_reference_only` | `True` = token references another var; **never emitted to a rule** |
| `is_themeable`      | `True` when `DesignTokenValue` overrides exist                     |
| `is_editable`       | `False` = system-locked; `True` = admin may edit                   |
| `sort_order`        | Sort position within category                                      |
| `updated_by`        | FK(User), SET_NULL — last editor                                   |

No PII — these are public UI values. No encryption, no RLS (not user-scoped).

### The 9 categories

`colour` · `typography` · `spacing` · `shadow` · `radius` · `motion` · `surface` · `zindex` ·
`breakpoint`.

`breakpoint` rows are always `is_reference_only=True`: CSS custom properties cannot appear inside
`@media` query conditions, so breakpoint tokens are reference/documentation rows only. See
[../responsive/BREAKPOINTS.md](../responsive/BREAKPOINTS.md).

### The 9 value kinds (`value_kind`)

`oklch` · `hex` · `length` · `number` · `duration` · `easing` · `shadow` · `reference` · `raw`.

`value_kind` is the validation contract: a Django Ninja endpoint that sets a value of the wrong
grammar for the token's kind is rejected before write (validated by the Ninja request `Schema`).
`reference` denotes a value that points at another `var(--…)` (used by reference-only tokens).
Colour tokens use `oklch` — see [../responsive/USER-PREFERENCES.md](../responsive/USER-PREFERENCES.md)
for the OKLCH rule.

---

## `DesignTokenValue` — NON-BASE preference overrides only

Zero or more rows per token, each an override for one combination of the six preference axes. The
canonical BASE value lives on `DesignToken.value`, **never** here — an all-BASE row is rejected.

| Field            | Notes                                                 |
| ---------------- | ----------------------------------------------------- |
| `token`          | FK → `DesignToken` (CASCADE)                          |
| `value`          | Override value for this axis combination              |
| `color_scheme`   | `base` / `light` / `dark`                             |
| `motion`         | `base` / `reduce`                                     |
| `contrast`       | `base` / `more` / `less`                              |
| `forced_colors`  | `base` / `active`                                     |
| `transparency`   | `base` / `reduce`                                     |
| `data_saver`     | `base` / `reduce`                                     |
| `theme_selector` | `base` / `data_theme` / `media` — dark-path qualifier |
| `justification`  | Required when **>1 axis** is non-BASE                 |
| `updated_by`     | FK(User), SET_NULL                                    |

### Invariants (`clean()`)

- A `UniqueConstraint` over the six-axis tuple guarantees **one row per axis combination** per
  token (`uniq_token_variant_axes`).
- All-BASE rows are **rejected** — the BASE value belongs on `DesignToken`.
- `justification` is **required when more than one axis is non-BASE** (a compound variant): these
  produce AND-joined compound `@media` blocks and need an explicit rationale, since they are the
  hardest cascade rules to reason about and audit.
- `theme_selector` is **not** a media axis — it is a **dark-path qualifier**, so it does **not**
  count toward the "at least one axis" / multi-axis justification invariants. `base` feeds both
  dark blocks; `data_theme` / `media` target one dark delivery path each. `clean()` rejects a
  non-`base` value unless the row is a **single-axis dark** row (`color_scheme=dark`, all else
  `base`). It is part of the `uniq_token_variant_axes` constraint (token + 6 axes + selector).

How these axes become CSS rules is in [CASCADE.md](CASCADE.md).

---

## Seeding

An initial migration adds the schema; a data migration seeds all 9 categories from the embedded
literals in `services/token_seed.py` (parsed from `shared/src/css/tokens/*.css` — no filesystem
reads at migration time). Dark-mode surface overrides are seeded as `theme_selector="base"`
`DesignTokenValue` rows where the value is byte-for-byte identical in both `[data-theme="dark"]`
and `@media (prefers-color-scheme: dark)`; the surface keys that drift between the two selectors are
seeded per-selector as `data_theme` + `media` row pairs (see [CASCADE.md](CASCADE.md),
[EDITOR.md](EDITOR.md)).

---

## Cross-references

- `code/docs/DESIGN-TOKENS.md` — entry point + the token-first law
- `design-tokens/CASCADE.md` — preference axes, render order, delivery
- `design-tokens/EDITOR.md` — editor, governance, extension points
- `code/src/django/apps/design_tokens/CONTEXT.md` — live models, Ninja endpoints, tasks
