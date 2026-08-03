---
name: stack-htmx-templates
description: Frontend stack reference for <%PROJECT_NAME%> — Django templates + django-components + HTMX + Alpine + token-driven vanilla CSS, served by the `apps.marketing` app. Load when building or reviewing public frontend pages/components, choosing where an interaction runs (server vs HTMX vs Alpine), wiring per-page SEO/JSON-LD, or the page cache. Cited by the frontend, seo, backend, security, and review agents.
---

Reference for the **Django-templated** frontend of <%PROJECT_NAME%>. The `frontend` agent loads
this for stack idioms; `seo`, `backend`, `security`, and
`review` cite it at the UI boundary. Aligns with `project-management/workflows/20-frontend-code/`,
`code/docs/RENDERING.md` (the interaction doctrine), and `apps/marketing/CONTEXT.md`.

British English throughout (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>) — in templates, Python, and copy.
All user-facing copy follows the brand voice — `project-management/src/06-BRAND-GUIDE/BRAND-VOICE.md`
(direct, considered, plainly British; substantiate or cut). Load it when writing or reviewing page
copy or microcopy.

The **visual** language is `code/docs/VISUAL-DESIGN.md` — the <%ORG_NAME%> signature (alternating
page/sunken bands, left-oriented editorial headings, the 3px hero/CTA accent border, per-sector
gradient tones) and the banned generic "AI-look". Build each screen against its wireframe
(`08-WIREFRAMES/WF-###`) and component design (`07-COMPONENTS`); never invent a generic layout.

---

## Architecture

| Layer          | Technology                                                                     |
| -------------- | ------------------------------------------------------------------------------ |
| Render         | Django Templates (DTL) served by `apps.marketing`; one process, no Node        |
| Components     | **django-components** in `code/src/django/components/` (`{% component %}`)     |
| Server ops     | **HTMX** (fragment swaps) — always with a visible indicator                    |
| Local interact | **Alpine.js** (`x-data`), vendored at `static/vendor/alpine/alpine.min.js`     |
| Styling        | Vanilla CSS, 100% `var(--token)`; tokens served live from `/assets/tokens.css` |
| Icons          | Self-hosted FontAwesome Free via the `{% icon %}` builtin tag                  |
| SEO            | `apps.marketing.seo.build_seo` + `_seo_head.html`                              |
| Cache          | `apps.marketing.cache.cache_marketing` — versioned Valkey page cache           |
| Rich admin     | Django templates + HTMX + Alpine, same as the public site                      |

Static files: WhiteNoise (hashed + pre-compressed in staging/prod). There is no client
build step anywhere in the project. Run everything through `code/src/scripts/**` — never `python`/`pytest`/`docker` direct.

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

One folder per component: `components/<snake>/<snake>.py` + `<snake>.html`.

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
  co-located at `code/src/django/components/<snake>/<snake>.css` and aggregated by
  `static/css/marketing.css`.
- **Component props are plain Python:** an `icon` name → `{% icon "name" style="solid" cls="…" %}`;
  list props (items/tiers) → Python lists of dicts looped in the template.
- Verify a component renders: `docker compose … exec … backend python -c "…Template('{% load component_tags %}{% component \"x\" / %}').render(Context({}))"`.

---

## Building a marketing page

1. **View** in `apps/marketing/views/<area>.py` — thin: build `seo`, pull published content from a
   **public** service (`published_blog_posts`, `portfolio_item_by_slug`, …), render a template.
   - Never call an admin-gated resolver. Replicate the two resolver masks: portfolio `client_name`
     only when `client_name_permitted`; blog author `display_name`/`public_id` only.
   - Clear eager loads you don't render: `.prefetch_related(None)` / `.select_related(None)` — the
     dev `nplusone` guard **raises** on unnecessary eager loads.
2. **SEO** — `seo.build_seo(title=…, description=…, path=…, robots=…, og_image=…, json_ld=[…])`;
   overlay an admin `SeoRecord` with `seo.overlay_record`. JSON-LD via the builders in `seo.py`
   (`organization_schema`, `webpage_schema`, `breadcrumb_schema`) — emitted safe-escaped.
3. **Template** extends `marketing/base.html`, fills `{% block marketing_content %}`, loads page CSS
   via `{% block page_css %}`. Static copy lives in `apps/marketing/pagedata/`.
4. **URL** in `apps/marketing/urls.py` (I own it); wrap cacheable GET views with `cache_marketing`.
   `/contact/` is NOT cached (per-request CSRF + POST).

Chrome (nav/footer/CTA) is injected by the `marketing_chrome` context processor and rendered by the
`site_nav` / `site_footer` components in `base.html` — pages never re-supply it.

---

## HTMX form pattern (the contact enquiry is the reference)

- `hx-post` on the form, `hx-target` on its container, `hx-disabled-elt="this"` +
  a visible `.htmx-indicator` (mandatory latency feedback). On success return a success fragment;
  on error re-render the form fragment with errors. **Non-HTMX POST must also work** (full-page
  re-render) as progressive enhancement.
- CSRF: `base.html` sets `hx-headers='{"x-csrftoken": "{{ csrf_token }}"}'` and forms include
  `{% csrf_token %}`. POST views call the same service the Ninja endpoint wrapped
  (`submit_enquiry`), resolving the IP via `apps.core.utils.get_client_ip`.

---

## Caching

`cache_marketing(ttl)` (in `urls.py`) read-through-caches anonymous GET 200 responses in Valkey,
namespaced by a `marketing:cache-version` counter. Any content publish
(BlogPost / PortfolioItem / Testimonial / SectorPage save) bumps the version via
`apps/marketing/signals.py` → the whole surface invalidates. Consent + analytics are **client-side**
(`_consent_banner.html` / `analytics.js`) so a cached page is identical for every visitor.

---

## Testing & tooling

- Page/view/template correctness → **backend pytest** (fragment assertions, golden-fixture parity
  for the Python `render_blocks`). There is no JavaScript unit-test layer.
- Alpine has no unit layer → interactive coverage is **Playwright**; keep the 51-route axe scan.
- Ban `hx-boost`; focus + `aria-live` conventions for swaps (`code/docs/ACCESSIBILITY.md`).

---

## Guardrails recap

- Token-first CSS (`var(--token)` only; enforced by `code/src/scripts/audits/css-tokens.sh`).
- WCAG 2.2 AA on every interactive element; `<html lang="en-GB">`.
- Every public page: canonical + robots + OG; no PII leak (mask at the view).
- Files ≤ 750 lines; every new package dir gets a `CONTEXT.md`.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/20-frontend-code/` — the frontend build phase
- `code/workflows/01-new-feature/` — the full-stack feature procedure
- `code/workflows/02-tdd-cycle/` — template, component, and HTMX-partial tests
