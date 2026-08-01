---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Design Tokens — Preference Cascade & Delivery

**Last Updated:** {{DATE}}
**Maintained By:** {{ORG_NAME}}
**Language:** British English (en_GB)
**Claude Model:** opus — CSS cascade generation, preference axes, delivery pipeline

How `DesignToken` + `DesignTokenValue` rows become a single deterministic CSS file, and how that
file reaches the browser. The generator is `services/render.py`
(`render_tokens_css()` pure / `render_current_css()` DB-backed).

---

## The six preference axes

Each `DesignTokenValue` override is keyed by a combination of these axes. Each maps to a CSS
preference query; `base` means "no preference / inherit BASE".

| Axis            | Values                    | CSS query                               |
| --------------- | ------------------------- | --------------------------------------- |
| `color_scheme`  | `base` / `light` / `dark` | `prefers-color-scheme` + `[data-theme]` |
| `motion`        | `base` / `reduce`         | `prefers-reduced-motion: reduce`        |
| `contrast`      | `base` / `more` / `less`  | `prefers-contrast: more` / `less`       |
| `forced_colors` | `base` / `active`         | `forced-colors: active`                 |
| `transparency`  | `base` / `reduce`         | `prefers-reduced-transparency: reduce`  |
| `data_saver`    | `base` / `reduce`         | `prefers-reduced-data: reduce`          |

Full preference semantics live in
[../responsive/USER-PREFERENCES.md](../responsive/USER-PREFERENCES.md).

### The justification rule

A row with **more than one** non-BASE axis is a **compound variant** and emits an AND-joined
compound `@media` block. `DesignTokenValue.clean()` **requires `justification`** on these rows:
compound queries are the least intuitive cascade rules, so an explicit rationale is mandatory for
audit and review. Single-axis rows (exactly one non-BASE axis) do not require justification.

### The `theme_selector` dark-path qualifier

A single-axis dark row (`color_scheme=dark`, all else `base`) carries a `theme_selector`:

| `theme_selector` | Emits to                                                          |
| ---------------- | ----------------------------------------------------------------- |
| `base`           | **both** dark blocks (the common case — one value, two selectors) |
| `data_theme`     | only `[data-theme="dark"]`                                        |
| `media`          | only `@media (prefers-color-scheme: dark)`                        |

This lets `[data-theme="dark"]` and `@media (prefers-color-scheme: dark)` carry **intentionally
different** values for the same token. It is how surface **drift** (the badge / btn-secondary /
btn-soft keys that must differ between the two dark paths) is modelled: each drift key is two rows
(`data_theme` + `media`) instead of an impossible single `dark` value forced to emit identically to
both blocks. `theme_selector` is a dark-path qualifier, **not** a media axis — it is excluded from
the justification rule.

---

## Emission order

`render_tokens_css()` emits blocks in a fixed order so cascade specificity is deterministic and the
file is diff-stable:

1. `:root { … }` — every BASE value (`DesignToken.value`).
2. `[data-theme="light"]` / `[data-theme="dark"]` — scoped colour-scheme overrides.
3. `@media (prefers-color-scheme: dark)` — emits the dark rows alongside `[data-theme="dark"]`,
   so the two can **never hand-drift**. This is the core guarantee: one source, two selectors.
   Single-axis dark rows route by **`theme_selector`** (below) so the two paths can carry
   **intentionally different** values where they must.
4. Single-axis `@media` blocks — reduced-motion, contrast (`more` + `less`), forced-colors,
   reduced-transparency, reduced-data.
5. AND-joined compound `@media` blocks — for every ≥2-axis variant.

Rules:

- **Reference-only tokens are never emitted** to a rule (`breakpoint` category, plus any
  `is_reference_only=True` token).
- **Empty blocks are omitted** — if no token has a variant for a given axis combination, no `@media`
  block is generated.

---

## Delivery

Two delivery paths consume the rendered CSS; both come from the same `render_current_css()` output,
so live and persisted CSS cannot diverge.

### Live (Django-served stylesheet)

A Django view (or generated static file) serves the full rendered CSS at `/assets/tokens.css`, and
public templates link it in `<head>`. Because it is a plain stylesheet served by Django — there is
**no Node/Next server and no SSR fetch** — a token change is visible on the next request once the
page cache is invalidated, with no frontend rebuild.

### Git write-back + cache invalidation

`tasks.py` drives async regeneration (Celery):

- `queue_regenerate_tokens` — acquires a **fail-open** Valkey lock, then enqueues the work task.
- `regenerate_design_tokens` — renders, **skips on content-hash match** (no-op if nothing changed),
  writes the CSS back to the repo via `services/git_writeback.py`, then **bumps the versioned
  Valkey page-cache key** (`cache_marketing`) so cached pages re-render against the new stylesheet.

`git_writeback.py` is a **provider-agnostic Contents-API adapter** (GitHub / GitLab / Forgejo) and
is a **no-op when unconfigured**, so local and CI runs never attempt a write. Configuration is
environment-only: `{{ENV_PREFIX}}_DESIGN_TOKENS_GIT_*` — never hard-coded.

State-changing endpoints queue regeneration **post-commit** (after the atomic DB write succeeds),
so a failed transaction never triggers a publish.

---

## API surface — Django Ninja

All token reads and writes go through a Django Ninja router (`NinjaAPI` + `Router` + Pydantic
`Schema` models). Ninja auto-generates OpenAPI at `/api/docs`. The token editor reaches these
endpoints through HTMX against the Django views that wrap them.

| Endpoint                               | Purpose                                                            |
| -------------------------------------- | ------------------------------------------------------------------ |
| `GET  /api/design-tokens/`             | List tokens with their values, `is_reference_only`, `is_themeable` |
| `PATCH /api/design-tokens/{key}/value` | Update one token's BASE or a preference-variant value              |
| `POST /api/design-tokens/bulk-update`  | Update many token values in one atomic request                     |
| `POST /api/design-tokens/regenerate`   | Queue a CSS regeneration + git write-back                          |
| `POST /api/design-tokens/preview`      | Dry-run render — returns rendered CSS, writes nothing              |

The rendered CSS itself is served by the `/assets/tokens.css` view (above), not this JSON router.

Every state-changing endpoint runs, in order: permission check
`can_access_module(actor, 'tokens', 'edit')` first (OWASP A01) → existence check (no IDOR) →
reject reference-only / non-editable tokens → `value_kind` + justification validation via the Ninja
request `Schema` → atomic write + `AuditService.log` (`TOKEN.VALUE.UPDATED` / `TOKEN.REGEN.QUEUED`)
→ post-commit regeneration. Session auth (the editor is admin-only); throttling middleware caps
request rate. See `code/docs/SECURITY.md` and `code/docs/API-DESIGN.md`.

---

## Cross-references

- `code/docs/DESIGN-TOKENS.md` — entry point + the token-first law
- `design-tokens/MODEL.md` — the two models and their fields
- `design-tokens/EDITOR.md` — editor, governance, extension points, drift
- `code/docs/responsive/USER-PREFERENCES.md` — preference-query semantics
