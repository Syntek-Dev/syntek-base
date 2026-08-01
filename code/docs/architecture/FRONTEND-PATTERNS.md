---
type: guide
agent: planner
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Architecture Patterns — Frontend State, Routing, and Project Structure

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Frontend state, routing, project structure, SEO and JSON-LD patterns

---

## State Management (Frontend)

Every page is server-rendered Django templates + django-components enhanced with HTMX and
Alpine.js — there is **no Node server, no client-side framework, and no client-side router**.
State is the primary source of complexity, so minimise it and keep it in the right place.
**Django is the source of truth.**

### State categories

| Category                  | Where to store                                                | Examples                                             |
| ------------------------- | ------------------------------------------------------------- | ---------------------------------------------------- |
| **Server / domain state** | Database; rendered server-side (templates / HTMX partials)    | content blocks, orders, users                        |
| **Navigation state**      | URL path + query params (`hx-push-url`)                       | filters, pagination, sort order, active tab          |
| **Form state**            | HTML form + server validation (Django forms / Ninja `Schema`) | input values, validation errors                      |
| **Local UI state**        | Alpine `x-data` on the owning element                         | modal open/closed, dropdown expanded, sidebar toggle |

There is no fifth category. Anything that does not fit one of these four is a sign the interaction
is being designed for a stack this project does not have.

### Rules

- **Django is the source of truth.** Do not duplicate server data into a long-lived client store.
  The site holds no client-side data cache; HTMX swaps server-rendered fragments in place.
- **URL is the source of truth for navigation state.** Filters, pagination, sort order, and tab
  selections belong in the URL (HTMX `hx-push-url`, query params), never in Alpine state.
- **Alpine for local UI state.** Reach for `x-data` on the element that owns the interaction;
  scope it as narrowly as possible. Do not build a global Alpine store for server data.
- **State that must survive a reload belongs on the server.** Alpine state dies with the page —
  that is the test for whether a piece of state is in the right tier.

### Worked example (Alpine + HTMX)

```html
<!-- an Alpine dropdown driving an HTMX-filtered, URL-synced list -->
<div x-data="{ open: false }">
  <button @click="open = !open" :aria-expanded="open">Filter</button>
  <form
    x-show="open"
    hx-get="/orders/"
    hx-target="#order-list"
    hx-push-url="true"
    hx-trigger="change"
  >
    <select name="status">
      <option value="">All</option>
      <option value="draft">Draft</option>
    </select>
  </form>
</div>
<div id="order-list"><!-- server-rendered partial, swapped by HTMX --></div>
```

The dropdown is Alpine because it is local and instant; the filtered list is HTMX because it is a
server operation; the filter itself lives in the URL because it must survive a reload and be
shareable. Three tiers, one interaction, each piece in the tier that matches its lifetime.

---

## Routing Conventions

There is one URL space, owned by Django. See [`../API-DESIGN.md`](../API-DESIGN.md) and
[`../URL-STRATEGY.md`](../URL-STRATEGY.md).

- **Public pages** — Django views + templates registered in the URLconf. Create them with the
  project script (`bash code/src/scripts/development/new-django-view.sh <route_path>`), never by
  hand. Path segments carry resource identity (`/orders/<slug>/`); query params carry filters.
- **JSON API** — a single `NinjaAPI` mounted under `/api/`, split into per-app `Router`s. Ninja
  auto-generates interactive OpenAPI docs at `/api/docs`. Each endpoint declares its own auth and
  its request/response `Schema`. It serves machine clients; pages do not call it
  (`../api-design/CLIENT-PATTERNS.md`).
- **HTMX partials** — reached at the same view URL as the full page, distinguished by the
  `HX-Request` header rather than by a parallel `/partials/` URL space.

```python
# config/urls.py
from django.urls import include, path
from ninja import NinjaAPI
from apps.orders.api import router as orders_router

api = NinjaAPI(docs_url="/docs")  # interactive OpenAPI at /api/docs
api.add_router("/orders", orders_router)

urlpatterns = [
    path("api/", api.urls),
    path("", include("apps.marketing.urls")),  # public template pages
]
```

---

## Project Structure

### Django + Ninja

```text
code/src/django/
├── apps/
│   ├── marketing/
│   │   ├── models.py
│   │   ├── services.py       # business logic
│   │   ├── schemas.py        # Ninja (Pydantic) request/response models
│   │   ├── api.py            # Ninja Router (JSON endpoints)
│   │   ├── views.py          # Django template views (public pages)
│   │   ├── urls.py
│   │   ├── tasks.py          # Celery tasks
│   │   ├── templates/        # Django templates
│   │   ├── components/       # django-components
│   │   └── tests/
│   ├── media/
│   └── users/
├── config/
│   ├── settings/
│   │   ├── base.py
│   │   ├── dev.py
│   │   ├── test.py
│   │   └── production.py
│   ├── urls.py
│   └── celery.py
└── manage.py
```

### Frontend assets

```text
code/src/
└── shared/
    └── src/css/tokens/      # design-token CSS (var(--token) source of truth)
```

### Rules

- Group by feature/domain, not by technical layer. A `marketing/` app holding its models,
  services, API, views, and tests is easier to navigate than split `models/`, `services/` trees.
- Keep test files adjacent to or mirroring the source structure.
- Configuration lives in `config/`. There is no separate client-side source tree — every surface
  is rendered from `templates/` and `components/`.

---

## SEO Metadata Pattern (Django)

All public-facing pages set metadata through the `build_seo()` helper and render it via the
`_seo_head.html` partial included in the base template `<head>`. Never hand-write `<meta>` tags
in a page template.

### Rules

- **`build_seo(opts)`** is the only authorised way to produce the SEO context. It caps descriptions
  at 160 chars, forces `twitter:card` to `summary_large_image`, and always sets a valid OG image.
- **Canonical URL**: derive from the `SITE_URL` setting — never from the request `Host` header.
- **Article pages**: pass the article fields (published/modified time, tags) so `build_seo()`
  emits the `og:type=article` block.
- Include `_seo_head.html` once, in the base template `<head>`; pages only supply the context.

### Usage

```python
# apps/marketing/views.py
from django.conf import settings
from django.shortcuts import render
from apps.marketing.seo import build_seo

def blog_post(request, slug):
    post = get_published_post(slug)
    seo = build_seo(
        title=f"{post.title} — {{ORG_NAME}}",
        description=post.excerpt,
        canonical=f"{settings.SITE_URL}/blog/{post.slug}",
        image=post.hero_image_url,
        og_type="article",
        published_time=post.published_at,
        modified_time=post.updated_at,
        tags=post.tags,
    )
    return render(request, "marketing/blog_post.html", {"post": post, "seo": seo})
```

```django
{# templates/base.html #}
<head>
  {% include "marketing/_seo_head.html" with seo=seo %}
</head>
```

`SITE_URL` defaults to `https://{{PRIMARY_DOMAIN}}` and is overridden per environment. The
`build_seo()` helper and `_seo_head.html` partial live in `apps/marketing/`.

---

## Static `.well-known` Files

RFC-defined discovery files (e.g. `security.txt` per RFC 9116, `change-password` per RFC 8615) are
served as static files. No application logic, no database queries, no view.

### Serving

Place the files under a collected static directory and let **Whitenoise** serve them (via
`collectstatic`), or serve them at the **edge** (reverse proxy / CDN). Either way they need no
Django view:

```text
code/src/django/static/.well-known/
└── security.txt    # RFC 9116 responsible-disclosure contact
```

`static/.well-known/security.txt` is delivered at `/.well-known/security.txt` with
`Content-Type: text/plain; charset=utf-8`.

### Legacy redirect

Add HTTP 301 redirects for legacy path variations in the Django URLconf (or at the edge), not in
application logic:

```python
# config/urls.py
from django.views.generic import RedirectView

path(".well-known/", RedirectView.as_view(url="/.well-known/security.txt", permanent=True))
```

---

## JSON-LD Structured Data Pattern (Django)

All public pages eligible for Google Rich Results render a `<script type="application/ld+json">`
tag built by typed helpers in `apps/marketing/jsonld.py`. Never hand-write JSON-LD strings in a
template.

### Rules

- **Builder functions** (`build_organization_schema`, `build_article_schema`,
  `build_service_schema`, `build_howto_schema`) return plain Python dicts — pure functions, no
  side effects.
- **The `json_ld` template filter/util is the only authorised serialiser.** It escapes `<` to
  `<` so `</script>` cannot terminate the surrounding script block.
- **Render in the template**, so the JSON-LD is present in the static HTML the server returns —
  crawlable without JavaScript. Never inject it from an Alpine or other client-side runtime.
- **Optional fields use conditional keys** — omit the whole `<script>` tag rather than emit
  malformed JSON-LD when a required field is missing.
- **Do not store JSON-LD blobs in the database.** Generate from typed model fields at render time.
- **Multiple schemas on one page**: use separate `<script>` tags — one per schema.

```django
{# render a schema dict passed from the view #}
{% if org_schema %}
<script type="application/ld+json">{{ org_schema|json_ld }}</script>
{% endif %}
```

### Reference

- `apps/marketing/jsonld.py` — builder functions and the XSS-safe serialiser
- `apps/marketing/seo.py` — `build_seo()` helper and `_seo_head.html` context

_Part of the `code/docs/` documentation family. See [`../ARCHITECTURE-PATTERNS.md`](../ARCHITECTURE-PATTERNS.md) for the full index._
