---
type: guide
agent: planner
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Architecture Patterns — Frontend State, Routing, and Project Structure

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Frontend state, routing, and project structure
(discoverability moved to [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md))

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

## Discoverability — moved

The SEO metadata pattern (`build_seo()`, `_seo_head.html`), the JSON-LD builders, and the static
`.well-known` files were documented here until they outgrew a guide named for state and routing.
They now live in their own family:

| Was here                        | Now                                                                                                                   |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| SEO Metadata Pattern (Django)   | [`../discoverability/WEB-METADATA.md`](../discoverability/WEB-METADATA.md)                                            |
| JSON-LD Structured Data Pattern | [`../discoverability/STRUCTURED-DATA.md`](../discoverability/STRUCTURED-DATA.md)                                      |
| Static `.well-known` Files      | [`../discoverability/ROOT-SURFACE.md`](../discoverability/ROOT-SURFACE.md) § 2                                        |
| _(was in the `seo` agent only)_ | `robots.txt` / sitemaps / `llms.txt` → [`../discoverability/ROOT-SURFACE.md`](../discoverability/ROOT-SURFACE.md) § 1 |

Index: [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md).

**The routing rules above still apply to those pages** — a marketing route is declared here, and
its `<head>` is built there.

_Part of the `code/docs/` documentation family. See [`../ARCHITECTURE-PATTERNS.md`](../ARCHITECTURE-PATTERNS.md) for the full index._
