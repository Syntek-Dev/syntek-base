---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Design Tokens — Editor, Governance & Known Limits

**Last Updated:** <%DATE%>
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Claude Model:** opus — Admin editor UX, token governance, extension tracking

The admin surface for editing tokens, the governance that keeps the system honest, and the
extension points and known drift.

---

## The editor — `/admin/design-tokens`

A three-pane editor in the custom `/admin/` admin area — server-rendered Django templates with
django-components, each pane an HTMX-swapped fragment, saved through ABAC-gated (`tokens.edit`)
Django views:

| Pane                         | Purpose                                                           |
| ---------------------------- | ----------------------------------------------------------------- |
| **Token tree**               | Browse tokens grouped by the 9 categories; select a token to edit |
| **Values / Variants editor** | Edit the BASE value and add/remove preference-variant overrides   |
| **Accessibility tab**        | WCAG contrast checks for the selected colour token across themes  |

Edits go through the Django Ninja endpoints in [CASCADE.md](CASCADE.md) — every save is
permission-gated, value-kind-validated, audited, and queues a post-commit CSS regeneration.
Reference-only and non-editable tokens are read-only in the UI and rejected server-side.

---

## Governance — the enforcement point

The token-first law (see [../DESIGN-TOKENS.md](../DESIGN-TOKENS.md)) is enforced by one script, not
by convention:

- `code/src/scripts/audits/css-tokens.sh` + the `audit-css-tokens.yml` CI workflow scan all three
  CSS scopes and **fail the build** if any component `var(--x)` does not resolve to a token defined
  in the styling layer (`shared/src/css/tokens/*.css` + `surfaces.css`) — which is the DB seed
  source. A phantom custom property is silently dropped by Lightning CSS, so this guard is the
  regression gate that keeps the cascade honest.

Run it before raising a PR:

```bash
bash code/src/scripts/audits/css-tokens.sh
```

Lightning CSS autoprefixes from the project browserslist config (no PostCSS). There is **no
separate raw-literal gate**: a detector that flagged inline literals could only ever be advisory,
because legitimate one-off values exist in non-token CSS. Do **not** add a failing raw-literal
script — `css-tokens.sh` is the single blocking enforcement. Reviewers enforce "no raw literal,
add a token first" by inspection.

---

## Extension points (not yet built)

Two features are wired at the data/endpoint layer but have no UI yet:

| Item                    | State                                                                                                                                  |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **Live iframe preview** | The `preview` dry-run endpoint and the `/assets/tokens.css` view already exist; only the iframe UI + live-rebind in the editor remain. |
| **Usage index**         | A static-analysis pass mapping which components/blocks reference each `--token`, to surface "used in N places" per token.              |

---

## Known drift — modelled by the `theme_selector` axis

A set of surface keys differ between `[data-theme="dark"]` and `@media (prefers-color-scheme: dark)`
in `shared/src/css/tokens/surfaces.css` (the `--badge-*`, `--btn-secondary-*`, and `--btn-soft-*`
variants). A byte-for-byte seed could only import keys identical across both selectors, so these
drifting keys need per-selector variant support.

The `theme_selector` axis (`base` / `data_theme` / `media`) on `DesignTokenValue` solves this: a
single-axis dark row targets one dark delivery path, and the drift keys are seeded as `data_theme` +
`media` row pairs, so each selector carries its own value and the OS-preference and `[data-theme]`
paths can no longer hand-drift. See [CASCADE.md](CASCADE.md) for the routing model.

---

## Cross-references

- `code/docs/DESIGN-TOKENS.md` — entry point + the token-first law
- `design-tokens/MODEL.md` — the two models and their fields
- `design-tokens/CASCADE.md` — render order, axes, delivery, endpoint flow
- `code/src/django/apps/design_tokens/CONTEXT.md` — live app, audit actions, permission key
