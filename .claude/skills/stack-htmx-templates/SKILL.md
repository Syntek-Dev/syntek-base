---
name: stack-htmx-templates
description: Frontend stack reference for <%PROJECT_NAME%> — Django templates + django-components + HTMX + Alpine + token-driven vanilla CSS, served by the `apps.marketing` app. Load when building or reviewing public frontend pages/components, choosing where an interaction runs (server vs HTMX vs Alpine), wiring per-page SEO/JSON-LD, or the page cache. Cited by the frontend, seo, backend, security, and review skills.
---

Reference for the **Django-templated** frontend of <%PROJECT_NAME%>. The `frontend` skill loads
this for stack idioms; `seo`, `backend`, `security`, and
`review` cite it at the UI boundary. Aligns with `project-management/workflows/21-frontend-code/`,
`code/docs/RENDERING.md` (the interaction doctrine), and
`code/docs/architecture/FRONTEND-PATTERNS.md` (where a page's modules sit inside the app).

British English throughout (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>) — in templates, Python, and copy.
All user-facing copy follows the brand voice — `how-to/src/BRAND-VOICE.md`
(direct, considered, plainly British; substantiate or cut). Load it when writing or reviewing page
copy or microcopy.

The **visual** language is `code/docs/VISUAL-DESIGN.md` — Section 3 names this project's **direction** and
its six axes, Section 4.1 the universal tells, Section 4.2 the deviations that read off those axes, Section 5 the motion
numbers. Its web
expression is `code/docs/visual-design/WEB.md` — the signature (under the default `editorial`
direction: alternating page/sunken bands, left-oriented headings, the 3px hero/CTA accent border,
per-sector gradient tones). Build each screen against its wireframe (`08-WIREFRAMES/WF-###`) and
component design (`07-COMPONENTS`); never invent a generic layout.

---

## Architecture

This is the shape a page takes, not an inventory of what is built — each row says when what it
names arrives, or that it is already here.

| Layer          | Technology                                                                                                                                                                                                  |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Render         | Django Templates (DTL), one process, no Node. The `apps.marketing` app that serves the public pages **arrives with the first story that needs a page**                                                      |
| Components     | **django-components** (`{% component %}`) — installed and configured (`code/src/django/config/settings/base.py`); placement: `code/docs/FRONTEND-CODING-PRINCIPLES.md`                                      |
| Server ops     | **HTMX** (fragment swaps) — always with a visible indicator; `django-htmx` is pinned, and the vendored library **arrives with the first page that loads it**                                                |
| Local interact | **Alpine.js** (`x-data`) — self-hosted, never a CDN, and **vendored by the first page that uses it** (`code/src/django/static/CONTEXT.md`)                                                                  |
| Styling        | Vanilla CSS, 100% `var(--token)` — the catalogue and the var-only rule are `code/docs/DESIGN-TOKENS.md`; the stylesheet tree **arrives with the first page** (`code/src/django/static/CONTEXT.md`)          |
| Icons          | Self-hosted Font Awesome Free through an `{% icon %}` tag (`code/docs/visual-design/WEB.md`), which **arrives with the first story needing one** — `apps.core`'s tag library holds `{% request_id %}` today |
| SEO            | `build_seo()` + `_seo_head.html` **arrive with the first public page** (contract: `code/docs/discoverability/WEB-METADATA.md`)                                                                              |
| Cache          | `cache_marketing` — a versioned Valkey page cache, **written by the story that first needs one** (`code/docs/RENDERING.md`)                                                                                 |
| Rich admin     | Django templates + HTMX + Alpine, same as the public site                                                                                                                                                   |

Static files: **WhiteNoise** in staging and production (hashed, pre-compressed, served from the app
process) — the package is pinned in `pyproject.toml` and is not yet wired into `MIDDLEWARE` or
`STORAGES`. There is no client build step anywhere in the project. Run everything through
`code/src/scripts/**` — never `python`/`pytest`/`docker` direct.

---

## The interaction-model doctrine (governing rule — full text in `code/docs/RENDERING.md`)

| Interaction class                                                | Runs where                   | Rule                                                |
| ---------------------------------------------------------------- | ---------------------------- | --------------------------------------------------- |
| First load / navigation / content                                | Server (full template)       | Default. Fast TTI, no hydration.                    |
| Meaningful server op (save, submit, load, moderate, publish)     | HTMX fragment swap           | **Always** an `htmx-indicator` / `hx-disabled-elt`. |
| Rapid / fine-grained (live-filter, drag-reorder, menus, toggles) | Alpine, local, no round-trip | Sync to server on commit, not per-keystroke.        |

**Non-negotiable:** every HTMX server op that isn't near-instant shows feedback — un-fed-back
latency reads as broken. **`hx-boost` is BANNED** — every server op is an explicit `hx-*` element.
Content must be usable with JS disabled (all links are real `<a>`; Alpine only enhances).
No inline `<script>`/`<style>` (CSP-clean); Alpine reads HTML attributes, htmx is configured via a
`<meta>` tag; per-page JS is a static file.

---

## django-components pattern

One folder per component — `<snake>/<snake>.py` + `<snake>.html` + `<snake>.css` — inside
whichever of the two component roots owns it (`code/docs/FRONTEND-CODING-PRINCIPLES.md` Section
_Component & Code Placement_).

```python
# components/feature_card/feature_card.py
from django.template import Context
from django_components import Component, register

@register("feature_card")
class FeatureCard(Component):
    template_file = "feature_card.html"

    class Kwargs:                       # typed; plain annotations + defaults
        icon: str = ""
        heading: str = ""
        heading_level: str = "h4"

    def get_template_data(self, args, kwargs, slots, context: Context):
        return {"icon": kwargs.icon, "heading": kwargs.heading, "level": kwargs.heading_level}
```

- **Do NOT define a typed `class Slots`** — it errors on default children. Use an untyped
  `{% slot "default" default %}{% endslot %}` in the template; consumers fill it between
  `{% component %}…{% endcomponent %}`. Self-close leaf components: `{% component "x" a=1 / %}`.
- The `.html` only assembles BEM class strings; the visual logic is in the component's own CSS,
  co-located in the component's folder as `<snake>.css`. There is no build step to aggregate it.
- **Component props are plain Python:** an `icon` name → `{% icon "name" style="solid" cls="…" %}`;
  list props (items/tiers) → Python lists of dicts looped in the template.
- Verify a component renders through the test suite (`bash code/src/scripts/tests/backend.sh`) —
  a render assertion in a test, never an ad-hoc shell invocation.

---

## Building a marketing page

`bash code/src/scripts/development/new-django-view.sh <route_path>` writes the route files. It
refuses until the marketing app and its packages exist and names each missing piece, so the shape
below is what a story fills in rather than what it finds:

1. **View** — thin: build the SEO context, pull published content from a **public** service,
   render a template. Never call an admin-gated resolver, and replicate its field masks rather
   than widening them. Clear eager loads you do not render (`.prefetch_related(None)` /
   `.select_related(None)`) — the dev-only `nplusone` guard **raises** on an unnecessary one
   (`code/docs/performance/DATABASE-PERFORMANCE.md`).
2. **SEO** — one `build_seo()` call per page; JSON-LD from the structured-data builders, emitted
   safe-escaped. Contract: `code/docs/discoverability/WEB-METADATA.md`.
3. **Template** extends `marketing/base.html`, fills `{% block marketing_content %}`, loads page CSS
   via `{% block page_css %}`. Static page copy is a `pagedata/` module — the scope
   `code/src/scripts/audits/copy-slop.sh` scans.
4. **URL** — wrap cacheable anonymous GET views with `cache_marketing`. A page carrying a
   per-request CSRF token or a POST is never cached.

Shared chrome (nav, footer, CTA) is rendered once by the base template and never re-supplied by a
page; the legal set inside the shared footer is data, not markup
(`code/docs/FRONTEND-CODING-PRINCIPLES.md`).

---

## HTMX form pattern (the enquiry form is the worked example)

- `hx-post` on the form, `hx-target` on its container, `hx-disabled-elt="this"` +
  a visible `.htmx-indicator` (mandatory latency feedback). On success return a success fragment;
  on error re-render the form fragment with errors. **Non-HTMX POST must also work** (full-page
  re-render) as progressive enhancement.
- CSRF: the marketing base template **will set**
  `hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'` and forms include `{% csrf_token %}`. A POST
  view calls the same service as the Ninja endpoint, resolving the client IP through the shared
  helper. CSRF spelling and the write rule: `code/docs/rendering/PITFALLS-AND-EXAMPLES.md`
  Section _An HTMX write without a CSRF token_. The form and POST-view shape:
  `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` Section _HTMX server operations_.

---

## When a swap would show nothing

The pattern above is the **user-error** half, and it is complete. The other two classes need a
different mechanism, because **HTMX swaps on 2xx only** — on a 500 the indicator stops, nothing
is replaced, and the page a user is looking at silently lies about what happened.

- **One global `htmx:beforeSwap` listener handles 5xx, never a per-element handler** — the view
  nobody expected to fail is the one that will. `htmx:sendError` shares the region: a request
  that never lands attempts no swap, so nothing else fires. It ships in
  `code/src/django/static/js/observability.js`, and
  `code/src/scripts/audits/negative-space.sh` fails a template using `hx-` with no handler
  present.
- **The handler creates its target region rather than assuming one.** A swap into a `null`
  element fails silently, which reproduces the exact defect the handler exists to close.
- **A complete HTML document is never swapped into a fragment.** An application 5xx is a
  rendered partial, but an edge 502 or 504 is a whole page — neither the status nor the content
  type separates them, so the handler tests the doctype.
- **`{% request_id %}` puts the correlation identifier where a user can quote it.** Django
  renders `500.html` with an **empty `Context` and no request**, so a context processor cannot
  reach that page and `{% extends %}` on a request-reading base renders blanks rather than
  failing. The tag reads a `ContextVar`, so it works in every rendering path.

Full text: `code/docs/rendering/PITFALLS-AND-EXAMPLES.md` Section _An error the user never sees_,
over the taxonomy in `code/docs/NEGATIVE-SPACE.md`.

---

## Caching

`cache_marketing(ttl)` **will** read-through-cache anonymous GET 200 responses in Valkey,
namespaced by a version counter that any content publish bumps — so the whole surface invalidates
in one write rather than key by key. Nothing that varies per visitor may reach a cached page:
consent and analytics stay client-side, so one cached response is correct for everybody.

Version-counter invalidation: `code/docs/performance/DATABASE-PERFORMANCE.md` Section _Cache
Invalidation_. Why nothing per-visitor may reach a cached page:
`code/docs/rendering/PITFALLS-AND-EXAMPLES.md` Section _Per-visitor content baked into cached
HTML_.

---

## Testing & tooling

- Page/view/template correctness → **backend pytest** (fragment assertions, golden-fixture parity
  for the Python `render_blocks`). There is no JavaScript unit-test layer.
- Alpine has no unit layer → interactive coverage is **Playwright**; keep the axe scan green as
  routes land (`code/src/django/tests/e2e/test_e2e_a11y.py` — `PAGES` is empty at baseline, so
  every scan skips until the first marketing route is added to it).
- Ban `hx-boost`; focus + `aria-live` conventions for swaps (`code/docs/ACCESSIBILITY.md`).

---

## Guardrails recap

- Token-first CSS (`var(--token)` only; enforced by `code/src/scripts/audits/css-tokens.sh`).
- WCAG 2.2 AA on every interactive element; `<html lang="en-GB">`.
- Every public page: canonical + robots + OG; no PII leak (mask at the view).
- Files ≤ 750 lines; every new package dir gets a `CONTEXT.md`.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/21-frontend-code/` — the frontend build phase
- `code/workflows/01-implement-story/` — the full-stack feature procedure
- `code/workflows/02-tdd-cycle/` — template, component, and HTMX-partial tests

## Cross-references

- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — the template, component, HTMX and CSS specifics
- `code/docs/data-structures/TYPES-BROWSER.md` — the typed view-model a handler renders, the
  request type `hx-vals` maps onto, `Alpine.data` registration past a single boolean, and the
  shared constants for swap targets and `HX-*` event names
- `code/docs/ARCHITECTURE-PATTERNS.md` — the layered boundaries a rendered page sits inside
- `code/docs/DESIGN-TOKENS.md` — the token catalogue and the `var(--token)`-only rule
- `code/docs/RESPONSIVE-DESIGN.md` — breakpoints, fluid layout, mobile-first
- `code/docs/DISCOVERABILITY.md` — the per-page head pipeline and JSON-LD structured data
- `code/docs/PERFORMANCE.md` — caching and the response-time targets a page is held to
- `code/docs/SECURITY.md` — the escaping, CSRF and upload rules a template must not undo
- `code/docs/TESTING.md` — the coverage floors, and where a template test belongs
- `project-management/docs/SEO-CHECKLIST.md` — what must be true per page before a story closes
- `project-management/docs/QA-GUIDE.md` · `project-management/docs/SECURITY-GUIDE.md` · `project-management/docs/RESPONSIVE-DESIGN.md` — the PM-side gates a page is judged against
