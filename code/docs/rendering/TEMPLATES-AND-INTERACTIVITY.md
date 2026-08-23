---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Rendering Strategy — Templates and Interactivity

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — where each interaction runs: server, HTMX, or Alpine

---

## Overview

Every surface is **Django server-rendered templates** + django-components, enhanced by HTMX
(server ops) and Alpine (local interactivity). Django renders the finished HTML and sends it to
the browser — there is **no Node server, no client build step, and no client-side framework**. The
admin area is built exactly like the public site: Django templates, HTMX for server operations,
Alpine for local interactivity.

---

## The Decision Rule

> **Every surface is a Django template. Use HTMX when the interaction needs the server, and
> Alpine when it does not. Introducing a client framework is an architectural decision, not a
> frontend one — it reopens the no-build-step choice this project has already made.**

| Signal                                              | Surface                      |
| --------------------------------------------------- | ---------------------------- |
| First load, navigation, SEO-critical content        | Django template (server)     |
| Save / submit / load / moderate / publish           | HTMX fragment swap           |
| Menu, dropdown, tabs, consent banner, live toggle   | Alpine `x-data` (local)      |
| Rich admin editing (block, rich-text, board, inbox) | Alpine + HTMX, server-backed |

---

## Django templates (the default)

A public page is a view that renders a template extending `base.html`. Data comes from the service
layer — never a client-side fetch.

```python
# apps/marketing/views/services.py
from django.shortcuts import render

from apps.marketing.services import list_services


def services(request):
    return render(request, "marketing/services.html", {"services": list_services()})
```

```html
{% extends "marketing/base.html" %} {% block content %}
<h1>Our Services</h1>
<ul>
  {% for service in services %}
  <li><a href="{% url 'marketing:service' service.slug %}">{{ service.title }}</a></li>
  {% endfor %}
</ul>
{% endblock %}
```

Reusable UI is a **django-component**, not a template partial copied around. SEO `<head>` content
**will be** built by `build_seo()` and rendered through the `_seo_head.html` partial
(`code/docs/discoverability/WEB-METADATA.md`), so it arrives in the initial HTML for crawlers. New
public pages are scaffolded with `bash code/src/scripts/development/new-django-view.sh <route_path>`,
never hand-created.

---

## HTMX server operations

A meaningful server op posts to a view that returns an **HTML fragment**, swapped into the page.
Every op that is not near-instant shows feedback (`htmx-indicator` / `hx-disabled-elt`) and manages
focus / `aria-live` for the swapped region.

```html
<form
  hx-post="{% url 'marketing:enquiry' %}"
  hx-target="#enquiry-result"
  hx-disabled-elt="find button"
  hx-indicator="#enquiry-spinner"
>
  {% csrf_token %}
  <input name="name" required />
  <button type="submit">Send</button>
  <span id="enquiry-spinner" class="htmx-indicator" aria-hidden="true"></span>
</form>
<div id="enquiry-result" aria-live="polite"></div>
```

```python
# apps/marketing/views/enquiry.py
from django.shortcuts import render

from apps.marketing.forms import EnquiryForm
from apps.marketing.services import submit_enquiry


def enquiry(request):
    form = EnquiryForm(request.POST or None)
    if request.method == "POST" and form.is_valid():
        submit_enquiry(form.cleaned_data)
        return render(request, "marketing/_enquiry_success.html")
    return render(request, "marketing/_enquiry_form.html", {"form": form})
```

`hx-boost` is banned: attach an explicit `hx-*` to the element that owns the op. Navigation stays
real `<a href>` links so the page works with JS disabled.

---

## Alpine local interactivity

Rapid, fine-grained UI that should never touch the network lives in Alpine, driven by HTML
attributes (CSP-clean — no inline `<script>`). Sync to the server on commit, not per-keystroke.

A single boolean toggle with no methods is small enough to inline:

```html
<div x-data="{ open: false }">
  <button @click="open = !open" :aria-expanded="open">Menu</button>
  <nav x-show="open" x-cloak>
    <a href="/services/">Services</a>
    <a href="/about/">About</a>
  </nav>
</div>
```

**Past that, the component is registered rather than inlined.** More than one property, or any
method, and the object literal in `x-data` becomes an untyped state bag whose shape only the
markup knows — so it moves to `Alpine.data('name', () => ({ … }))` in a static `.js` file, and
`x-data` names it. The threshold, the store rule for shared state, and the frozen-constant
replacement for magic status strings are
[`../data-structures/TYPES-BROWSER.md`](../data-structures/TYPES-BROWSER.md).

---

## Where each surface will live

**The rows decide where an interaction runs, not what is on disk.** `cache_marketing` and
`build_seo()` arrive with the stories that need them.

| Data / interaction                    | Runs where               | How                                                        |
| ------------------------------------- | ------------------------ | ---------------------------------------------------------- |
| Public marketing content              | Server (Django template) | view → `render`; anonymous GET cached by `cache_marketing` |
| Dynamic per-request public content    | Server (Django template) | view → `render`; not cached / varied                       |
| Public server op (save, submit, load) | HTMX fragment swap       | `hx-post` → view returns a partial + indicator             |
| Rapid local interaction               | Alpine                   | `x-data`, no round-trip; commit-time sync only             |
| Admin rich editing                    | Alpine + HTMX            | `x-data` for local state; `hx-post` to persist via a view  |
| SEO-critical page content             | Server (Django template) | `build_seo` + `_seo_head.html` in the initial HTML         |

_Part of the `code/docs/` documentation family. See [`../RENDERING.md`](../RENDERING.md) for the full index._
