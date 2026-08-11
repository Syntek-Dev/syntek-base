---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Rendering Strategy — Common Pitfalls and Implementation Examples

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — HTMX / Alpine pitfalls and worked examples

---

## Common Pitfalls

### Using `hx-boost`

```html
<!-- WRONG — a blanket boost turns every link into an ajax swap -->
<body hx-boost="true">
  ...
</body>

<!-- CORRECT — an explicit hx-* on the element that owns the op -->
<button hx-post="{% url 'marketing:subscribe' %}" hx-target="#result">Subscribe</button>
```

`hx-boost` is banned: it hides which interactions hit the server and breaks the no-JS baseline.

### A server op with no feedback

Any HTMX op that is not near-instant must show progress, or the latency reads as broken.

```html
<!-- WRONG — no indicator, no disabled state; the user re-clicks -->
<form hx-post="{% url 'marketing:enquiry' %}" hx-target="#result">...</form>

<!-- CORRECT — indicator + disabled element while the request is in flight -->
<form
  hx-post="{% url 'marketing:enquiry' %}"
  hx-target="#result"
  hx-disabled-elt="find button"
  hx-indicator="#spinner"
>
  ...
  <span id="spinner" class="htmx-indicator" aria-hidden="true"></span>
</form>
```

### Breaking the no-JS baseline

Navigation and content must work with scripts blocked. HTMX and Alpine only _enhance_.

```html
<!-- WRONG — a button that only works via HTMX; dead with JS disabled -->
<button hx-get="/about/" hx-target="body">About</button>

<!-- CORRECT — a real link; enhance it, do not replace it -->
<a href="/about/">About</a>
```

### Inline `<script>` or `<style>` (CSP violation)

The site is CSP-clean. Alpine reads HTML attributes, htmx is configured via a meta tag, and any
per-page JS is a static file.

```html
<!-- WRONG — inline script/style is blocked by the CSP -->
<script>
  document.querySelector("nav").classList.toggle("open");
</script>

<!-- CORRECT — Alpine attributes; htmx config in a meta tag -->
<meta name="htmx-config" content='{"defaultSwapStyle":"outerHTML"}' />
<nav x-data="{ open: false }" :class="{ open }">...</nav>
```

### Per-visitor content baked into cached HTML

Anonymous GET pages are cached whole by `cache_marketing`. Anything that varies per visitor
(consent banner, analytics, greeting) must be decided **client-side** so the cached HTML is
identical for everyone — never render it server-side into a cached page.

### Alpine syncing per-keystroke

Rapid local UI belongs in Alpine with **no round-trip**. Do not fire an HTMX request on every
keystroke; hold state locally and sync on commit (blur, submit, explicit save).

### An HTMX write without a CSRF token

A `hx-delete` or `hx-patch` on a non-form element carries no `{% csrf_token %}` hidden input, so
Django rejects it with a `403` and the swap silently does nothing.

```django
{# WRONG — no token on a non-form element #}
<button hx-delete="/items/{{ item.pk }}/" hx-target="#item-{{ item.pk }}">Delete</button>

{# CORRECT — set the header once on <body>; every hx-* request inherits it #}
<body hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'>
```

The wrong fix is `@csrf_exempt` on the view. See `code/docs/api-design/CLIENT-PATTERNS.md`.

### A save endpoint without a permission check

Every state-changing Ninja endpoint needs an explicit permission check and must verify the caller
owns the record — a `page_id` from the client is untrusted (IDOR).

```python
# WRONG — trusts the client-supplied id, edits any page
@router.put("/admin/pages/{page_id}/blocks")
def save_blocks(request, page_id: str, payload: SaveBlocksIn):
    save_page_blocks(Page.objects.get(pk=page_id), payload.blocks)

# CORRECT — scope to the caller; get_owned_page raises 404 on a foreign id
@router.put("/admin/pages/{page_id}/blocks", auth=staff_session_auth)
def save_blocks(request, page_id: str, payload: SaveBlocksIn):
    page = get_owned_page(request.user, page_id)
    save_page_blocks(page, [b.dict() for b in payload.blocks])
    return {"status": "ok"}
```

### A partial that carries page chrome

A view that forgets to branch on `HX-Request` returns the full page into an `hx-target`, nesting a
second `<html>`/`<nav>` inside the element. It often looks almost right, which is why it survives
review.

```python
if request.headers.get("HX-Request"):
    return render(request, "marketing/_results.html", context)
return render(request, "marketing/results.html", context)
```

Assert both branches — the partial test asserts `<nav>` is _absent_
(`code/docs/testing/FRONTEND-TESTING.md`).

### An error the user never sees

HTMX swaps on **2xx only**. A `500` or `503` therefore replaces _nothing_: the indicator stops,
the page is unchanged, and the user re-clicks. It is invisible in review because the happy path
looks perfect — and it is exactly the silent failure [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)
exists to prevent. Split it by error class:

| Class                 | Status                        | What the user gets                                        |
| --------------------- | ----------------------------- | --------------------------------------------------------- |
| **User error**        | 200 with the re-rendered form | the form back with its messages — the admin example below |
| **Programmer error**  | 500                           | a real error region, swapped in by the global handler     |
| **Environment error** | 503                           | the same region, worded as retryable                      |

The user-error leg is per view. The other two are **one global listener, never per element**
**[gate: fail]** — the view nobody expected to fail is the one that will. The shipped handler is
`code/src/django/static/js/observability.js`, and it makes two corrections to the obvious
version that are worth knowing before you edit it:

```javascript
document.body.addEventListener("htmx:beforeSwap", (event) => {
  if (event.detail.xhr.status < 500) return;
  const region = errorRegion(); // creates #error-region when the page defines none
  event.detail.shouldSwap = true;
  event.detail.target = region;
  if (!isFragment(event.detail.serverResponse ?? "")) {
    region.textContent = FALLBACK_MESSAGE;
    event.detail.shouldSwap = false;
  }
});
```

- **The region is created, never assumed.** `document.getElementById("error-region")` is `null`
  on any page that has not defined one, and a swap into `null` fails silently — reproducing the
  exact defect the handler exists to close.
- **A 5xx from the edge is not a fragment.** The application returns a rendered partial; Nginx
  returning 502 or 504 returns a **complete HTML document**, and swapping one into a `div` nests
  a page inside a page. The doctype separates the two; neither the status nor the content type
  does.

`htmx:sendError` needs the same region: a request that never lands produces no response at all,
so no swap is attempted and nothing above fires.

`audits/negative-space.sh` carries the clause (`htmx-handler-absent`): any template using `hx-`
implies a `document.body` `htmx:beforeSwap` listener somewhere under `static/`. It keys on the
listener, **not** on this file's path, so moving the script is not a failure — and its honest
limit is that it proves a listener exists, never that it handles 500 and 503 correctly.

The server returns a **rendered partial** with the real 5xx status, never an empty body — the
listener decides _where_ it lands, not _what_ it says. That partial prints the `X-Request-ID`
value, so a user reporting "it broke" can quote the one identifier that finds the tracker event.

### The identifier a full-page error cannot be given

The partial above is rendered by a view, so it has a request and a context. **`500.html` has
neither.** Django's own documentation settles it: the default 500 view "passes no variables to
the `500.html` template and is rendered with an empty `Context` to lessen the chance of
additional errors". Two consequences, and both are easy to get wrong precisely because the
happy path never exercises them:

- **A context processor cannot reach it.** Context processors run only for a `RequestContext`,
  and there is no request. So the mechanism that would obviously carry the identifier is the one
  mechanism ruled out.
- **`{% extends %}` is a trap, not a convenience.** A base template that reads `request` —
  for navigation, the user, a CSRF token — renders **blanks** rather than failing, which is the
  silent failure [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) exists to prevent, on the one
  page a user reaches only when something has already broken.

The identifier therefore arrives through a **simple tag**, which takes its value from the
`ContextVar` in `apps.core.middleware` rather than from the context it is rendered with:

```django
{% load core %}
{% request_id as rid %}{% if rid %}<code>{{ rid }}</code>{% endif %}
```

One reader, every path — the 500 page, the error partial, and any ordinary view. The `{% if %}`
is the rule from `MOBILE-CODING-PRINCIPLES.md` § 4 applied here: show nothing rather than an
identifier that resolves to the wrong event. `apps/core/templatetags/CONTEXT.md` carries the
table of which paths have a context and which do not.

**There is no `503.html`.** Django defines no 503 handler and no template name for one, and the
503 that matters is served when Django is not answering at all — which only the edge can do
(`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` § 14).

### A template variable the view never passed

Django renders an unresolved variable as an empty string, so `{{ user.emial }}` leaves a blank
where the address should be and nothing anywhere records it. Make it visible in dev and test:

```python
# config/settings/dev.py
TEMPLATES[0]["OPTIONS"]["string_if_invalid"] = "[INVALID TEMPLATE VARIABLE: %s]"
```

**It stays out of staging and production, and it is only a partial aid even here.** A non-empty
value stops filters applying to invalid variables — `{{ missing|default:"x" }}` renders the
marker rather than `"x"` — which is a behaviour change, not a diagnostic. And `{% if %}`,
`{% for %}` and `{% regroup %}` read an invalid variable as `None` and never consult it, so the
commonest case still fails silently. There is no loud failure for this on a production page; the
defence is the test that renders the template.

Component props need none of this. `get_context_data(self, *, icon: str, label: str)` is
keyword-only with no default, so a missing prop is already a loud `TypeError` at the call site —
adding an explicit `raise` on top would be a second enforcement point for the same rule.

---

## Implementation Examples

### A server-rendered page with an HTMX op and an Alpine enhancement

```html
{% extends "marketing/base.html" %} {% block content %}
<article>
  <h1>{{ post.title }}</h1>
  <time datetime="{{ post.published_at|date:'c' }}">{{ post.published_at|date:'j M Y' }}</time>
  <div>{{ post.body|safe }}</div>

  <!-- Local, rapid: share menu toggles with no round-trip -->
  <div x-data="{ open: false }">
    <button @click="open = !open" :aria-expanded="open">Share</button>
    <ul x-show="open" x-cloak>
      <li><a href="mailto:?subject={{ post.title|urlencode }}">Email</a></li>
    </ul>
  </div>

  <!-- Server op: post a comment, swap in the rendered fragment -->
  <form
    hx-post="{% url 'marketing:comment' post.slug %}"
    hx-target="#comments"
    hx-swap="beforeend"
    hx-disabled-elt="find button"
    hx-indicator="#comment-spinner"
  >
    {% csrf_token %}
    <textarea name="body" required></textarea>
    <button type="submit">Comment</button>
    <span id="comment-spinner" class="htmx-indicator" aria-hidden="true"></span>
  </form>
  <ul id="comments" aria-live="polite">
    {% include "marketing/_comments.html" %}
  </ul>
</article>
{% endblock %}
```

```python
# apps/marketing/views/comment.py
from django.shortcuts import get_object_or_404, render

from apps.marketing.models import Post
from apps.marketing.services import add_comment


def comment(request, slug: str):
    post = get_object_or_404(Post, slug=slug)
    comment = add_comment(post, request.user, request.POST["body"])
    return render(request, "marketing/_comment.html", {"comment": comment})
```

### An admin edit form saving through HTMX

```django
{# templates/admin/_edit_form.html — the partial is both the initial render and the swap target #}
<form
  id="edit-form"
  hx-post="{% url 'admin:item-edit' item.pk %}"
  hx-target="#edit-form"
  hx-swap="outerHTML"
  hx-indicator="#edit-spinner"
  hx-disabled-elt="find button[type=submit]"
>
  {% csrf_token %}
  {{ form.as_div }}
  <button type="submit">Save</button>
  <span id="edit-spinner" class="htmx-indicator" role="status">Saving…</span>
</form>
```

```python
def item_edit(request, pk):
    item = get_owned_item(request.user, pk)   # ownership check — no IDOR
    form = ItemForm(request.POST or None, instance=item)

    if request.method == "POST" and form.is_valid():
        form.save()
        response = render(request, "admin/_edit_form.html", {"form": form, "item": item})
        response["HX-Trigger"] = "itemSaved"   # drives the toast; no markup needed for it
        return response

    # Invalid: 200 with the re-rendered form, so the swap has something to put back
    return render(request, "admin/_edit_form.html", {"form": form, "item": item})
```

One template serves the first render, the success swap, and the error swap — so the three states
cannot drift apart.

_Part of the `code/docs/` documentation family. See [`../RENDERING.md`](../RENDERING.md) for the full index._
</content>
