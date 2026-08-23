---
type: guide
skills: [backend, stack-django, stack-htmx-templates]
model: opus
---

# API Design — Client-Side Consumption Patterns

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — how the browser consumes the server: HTMX partials, CSRF, errors, swaps

---

There is no JavaScript API client. The browser consumes the server through **HTMX**, which issues
ordinary HTTP requests to Django views and swaps the returned **HTML fragment** into the page.

That splits the server's surface in two, and the split is the load-bearing rule of this document:

| Surface                | Consumer                                         | Returns                | Lives in              |
| ---------------------- | ------------------------------------------------ | ---------------------- | --------------------- |
| Django views           | The page, via HTMX                               | HTML (full or partial) | `apps/<app>/views.py` |
| Django Ninja endpoints | Machine clients — integrations, webhooks, mobile | JSON                   | `apps/<app>/api.py`   |

**A page never calls the JSON API.** If a template needs data, the view provides it; if an
interaction needs a server round-trip, it targets a view that returns the fragment to swap. Routing
page interactions through JSON would mean rendering HTML in the browser, which is the architecture
this stack exists to avoid. See [`../rendering/TEMPLATES-AND-INTERACTIVITY.md`](../rendering/TEMPLATES-AND-INTERACTIVITY.md).

---

## The partial endpoint

An HTMX-facing view answers two callers: a full-page navigation, and an HTMX swap. Branch on the
`HX-Request` header and return the smallest fragment that satisfies the swap.

```python
# apps/marketing/views.py
from django.shortcuts import render

# The caller picks a filter from this map; it never supplies a lookup of its own.
_FILTERS = {"category": "category__slug", "year": "published_at__year"}


def _filters_from(request) -> dict[str, str]:
    return {
        _FILTERS[name]: value for name, value in request.GET.items() if name in _FILTERS and value
    }


def portfolio(request):
    items = PortfolioItem.objects.filter(**_filters_from(request)).select_related("category")
    context = {"items": items}

    if request.headers.get("HX-Request"):
        return render(request, "marketing/_portfolio_results.html", context)

    return render(request, "marketing/portfolio.html", context)
```

**Rules:**

- Partial templates are prefixed `_` and contain no page chrome — no `<html>`, no `<nav>`.
- The full-page template `{% include %}`s the same partial, so one fragment serves both paths and
  cannot drift.
- The partial is the response contract. Changing its outer element or `id` is a breaking change to
  every `hx-target` that points at it.
- **A query-string name is chosen from an allowlist, never expanded into a lookup.** Passing
  `request.GET` straight into `filter(**…)` lets the caller write the lookup as well as the value:
  `?category__owner__email__contains=@` traverses a relation this view never meant to expose, and
  `__gt` on a hidden column reads it a character at a time. Map each accepted name to a lookup you
  wrote, as `_FILTERS` does above, and drop everything else. The rule holds for `order_by()`,
  `values()` and `annotate()` too — they take field names, and a field name from a caller is a
  read of whatever it resolves to.

---

## Requesting from the template

Attributes live on the element that owns the interaction, not on a wrapper:

```html
<form
  hx-post="{% url 'marketing:subscribe' %}"
  hx-target="#subscribe-panel"
  hx-swap="outerHTML"
  hx-indicator="#subscribe-spinner"
>
  {% csrf_token %}
  <label for="email">Email address</label>
  <input id="email" name="email" type="email" required />
  <button type="submit">Subscribe</button>
</form>
```

**Rules:**

- `hx-target` names an `id` the response actually returns — a target that no longer exists fails
  silently, which is the single most common HTMX bug.
- Prefer `outerHTML` swaps on a self-contained panel; `innerHTML` leaves a stale wrapper whose
  attributes can no longer be updated by the server.
- Give every request an `hx-indicator` — an interaction with no feedback reads as a dead click.

---

## CSRF

Django's CSRF protection applies to every unsafe HTMX request exactly as it does to a normal form
POST. Two ways to satisfy it:

```html
<!-- Per-form: the token Django already renders -->
<form hx-post="/subscribe/">{% csrf_token %} …</form>
```

```html
<!-- Site-wide: set the header once on <body> and inherit it everywhere -->
<body hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'></body>
```

Use the `<body>` form as the default — it covers `hx-delete` and `hx-patch` on elements that are
not forms and cannot carry a hidden input. Never disable CSRF on a view to make a swap work.

---

## Errors

HTMX only swaps `2xx` responses by default. This makes the status code a deliberate choice, not an
afterthought:

| Situation            | Status | Body                              |
| -------------------- | ------ | --------------------------------- |
| Validation failed    | `200`  | The re-rendered form, with errors |
| Not permitted        | `403`  | Nothing to swap                   |
| Genuine server fault | `500`  | Nothing to swap                   |

**Validation errors return `200`.** The swap has to put something back on the page, and that
something is the form with its error messages attached — the same partial, re-rendered:

```python
def subscribe(request):
    form = SubscribeForm(request.POST)

    if not form.is_valid():
        return render(request, "marketing/_subscribe_form.html", {"form": form})

    form.save()
    response = render(request, "marketing/_subscribe_done.html")
    response["HX-Trigger"] = "subscribed"
    return response
```

This differs from the JSON API, which returns `422` with the error envelope in
[`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md). Two surfaces, two contracts — do not blend them.

For `4xx`/`5xx`, handle the failure globally rather than per-element:

```html
<body hx-on:htmx:response-error="showToast('Something went wrong. Please try again.')"></body>
```

---

## Response headers

The response headers are how the server drives the page beyond the swap. Treat them as part of the
endpoint's signature and assert on them in tests:

| Header        | Use                                                              |
| ------------- | ---------------------------------------------------------------- |
| `HX-Trigger`  | Fire a client event after the swap — toasts, counters, analytics |
| `HX-Redirect` | Full-page navigation after a successful action                   |
| `HX-Retarget` | Redirect the swap to a different element (e.g. an error region)  |
| `HX-Reswap`   | Override the swap style for this response                        |

```python
response["HX-Trigger"] = json.dumps({"itemDeleted": {"id": str(item.pk)}})
```

Prefer `HX-Trigger` over returning markup whose only job is to run a script.

---

## Alpine.js — the client-only tier

Alpine covers interactions that never need the server: disclosure toggles, tab selection,
copy-to-clipboard, dismissing a panel. The boundary is a hard one — **if the state must survive a
reload or be seen by anyone else, it belongs on the server**, reached by HTMX.

```html
<div x-data="{ open: false }">
  <button @click="open = !open" :aria-expanded="open">Details</button>
  <div x-show="open">…</div>
</div>
```

Alpine has no test runner in this template (see
[`../testing/FRONTEND-TESTING.md`](../testing/FRONTEND-TESTING.md)), which is the practical reason
to keep it thin: untestable logic should also be inconsequential logic.

---

## When a real JSON client appears

A mobile app or third-party integration consumes `apps/<app>/api.py` directly. That client owns its
own transport layer and is out of this repository's scope — but the server-side obligations do not
change: an explicit permission check on every state-changing endpoint, ownership verified on every
user-supplied ID, and the error envelope from [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md).
See [`./AUTH-STRATEGY.md`](./AUTH-STRATEGY.md) for choosing that client's auth scheme.

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
