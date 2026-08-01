---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Rendering Strategy — Common Pitfalls and Implementation Examples

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
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
