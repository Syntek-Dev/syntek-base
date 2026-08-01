---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Accessibility — Semantic HTML and ARIA

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Semantic HTML element choice and ARIA attribute patterns for WCAG 2.2 AA

---

## Standards and Compliance

All work targets **WCAG 2.2 Level AA** as the minimum standard. This covers the vast majority
of accessibility requirements and is the standard referenced by UK public sector regulations and the
Equality Act 2010. It applies to every surface — the site is Django-templated throughout, so there
is no second stack with a second standard.

Reference: [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)

---

## Semantic HTML

Use the correct HTML element for the job. Semantic elements communicate meaning to assistive
technology without any additional attributes. This holds whether the markup is authored in a Django
template, a django-component, or an HTMX partial.

### Rules

- Use `<button>` for actions, `<a>` for navigation. Never use `<div onclick>` or `<span onclick>` —
  they have no keyboard support, no role, and no focus by default.
- Use heading levels (`<h1>` through `<h6>`) in logical order. Do not skip levels. Every page has
  exactly one `<h1>`.
- Use `<nav>`, `<main>`, `<aside>`, `<header>`, and `<footer>` for their respective regions.
- Use `<ul>` or `<ol>` for lists.
- Use `<table>` for tabular data with `<thead>`, `<tbody>`, `<th scope="col">` and `<th scope="row">`. Never use tables for layout.
- Use `<fieldset>` and `<legend>` for related groups of form controls.
- Use `<dialog>` for modal dialogs — it manages focus trapping and inert background natively.

### Common mistakes

```html
<!-- BAD: div as a button -->
<div class="btn" onclick="handleClick()">Submit</div>

<!-- GOOD: actual button (Alpine handler on the public site) -->
<button type="button" @click="handleClick()">Submit</button>

<!-- BAD: skipped heading levels -->
<h1>Dashboard</h1>
<h3>Recent Orders</h3>

<!-- GOOD: logical heading order -->
<h1>Dashboard</h1>
<h2>Recent Orders</h2>
```

---

## ARIA — When and How

**The first rule of ARIA is: don't use ARIA if a native HTML element can do the job.**

### When to use ARIA

- Custom components with no native HTML equivalent (tabs, tree views, comboboxes, carousels).
- Dynamic content that changes without a full page reload — HTMX partial swaps and Alpine-driven
  visibility changes (live regions, status messages).
- Relationships between elements not expressed by the DOM structure.

### When NOT to use ARIA

- To replicate what a native element already provides. `<button>` already has `role="button"`.
- To fix a broken component. If a `<div>` needs ARIA to work like a button, use a `<button>`.

### Essential patterns

**Live regions** — for dynamic content updates (HTMX swaps, Alpine state changes):

```html
<!-- Polite: announced when the user is idle -->
<div aria-live="polite" aria-atomic="true">3 items in your basket</div>

<!-- Assertive: announced immediately (use sparingly) -->
<div aria-live="assertive" role="alert">Payment failed. Please check your card details.</div>
```

A live region must already exist in the DOM before its content changes, so place it outside any
HTMX swap target (see the server-rendered section below).

**Described by** — for supplementary descriptions:

```html
<input type="password" id="password" aria-describedby="password-hint" />
<p id="password-hint">Must be at least 12 characters.</p>
```

**Expanded/collapsed** — for disclosure widgets:

```html
<button aria-expanded="false" aria-controls="menu-content" x-data x-on:click="open = !open">
  Menu
</button>
<div id="menu-content" hidden><!-- menu items --></div>
```

**Current page** — for navigation:

```html
<nav aria-label="Main navigation">
  <a href="/" aria-current="page">Home</a>
  <a href="/about">About</a>
</nav>
```

---

## Colour and Contrast

- **Normal text** (under 24px, or under 18.66px bold): minimum contrast ratio of **4.5:1**.
- **Large text** (24px+, or 18.66px+ bold): minimum contrast ratio of **3:1**.
- **UI components and graphical objects**: minimum contrast ratio of **3:1**.
- **Never use colour alone** to convey information. A red error message must also include an icon
  or text prefix.
- Ensure sufficient contrast in both light and dark modes. Contrast is a property of the resolved
  design-token values — check the token pairs, not raw literals.
- Test with colour blindness simulation tools.

---

## Images, Icons, and Media

### Images

```html
<!-- Informative -->
<img src="chart.png" alt="Revenue increased 23% from Q3 to Q4 2025" />

<!-- Decorative -->
<img src="divider.svg" alt="" />

<!-- Complex with extended description -->
<figure>
  <img src="architecture.png" alt="System architecture diagram" aria-describedby="arch-desc" />
  <figcaption id="arch-desc">
    The system consists of Django server-rendered templates, a Django Ninja JSON API, a PostgreSQL
    database, and a Valkey cache, all connected via a private Docker network.
  </figcaption>
</figure>
```

### Icons

Font Awesome icons are decorative by default — hide them from assistive technology and give the
control its own accessible name.

```html
<!-- Django template / public site: icon with accessible label -->
<button type="button" aria-label="Delete item">
  <i class="fa-solid fa-trash" aria-hidden="true"></i>
</button>

<!-- Icon alongside visible text (icon is decorative) -->
<button type="button">
  <i class="fa-solid fa-trash" aria-hidden="true"></i>
  <span>Delete</span>
</button>
```

The same rule holds inside a django-component — render the icon with `aria-hidden="true"` and label
the button with `aria-label` or visible text. See
[`TESTING-AND-COMPONENTS.md`](TESTING-AND-COMPONENTS.md) for making the label a required component
argument.

### Video and audio

- All video content must have captions.
- All audio-only content must have a transcript.
- Auto-playing media must be avoidable — provide a pause/stop control. Cloudinary-delivered video
  players must expose native controls.

---

## Typography and Readability

- Text must be resizable up to 200% without loss of content or functionality (WCAG 1.4.4). Use
  relative units (`rem`, `em`, `%`) for font sizes — resolved from design tokens.
- Line height should be at least 1.5 times the font size for body text.
- Text blocks should not exceed approximately 80 characters per line.
- Do not justify text (`text-align: justify`) — uneven word spacing makes text harder to read for
  users with dyslexia.
- Ensure the page is usable at 400% zoom in a 1280px viewport (WCAG 1.4.10 — Reflow).

---

## Server-Rendered Accessibility (Django + HTMX)

```html
{# Accessible form with error handling (Django template) #}
<form method="post" novalidate>
  {% csrf_token %} {% for field in form %}
  <div>
    <label for="{{ field.id_for_label }}">{{ field.label }}</label>
    {{ field }} {% if field.errors %}
    <p id="{{ field.id_for_label }}-error" role="alert">{{ field.errors.0 }}</p>
    {% endif %}
  </div>
  {% endfor %}
  <button type="submit">Submit</button>
</form>
```

### Rules for server-rendered pages

- Set the `lang` attribute on the `<html>` element (`<html lang="en-GB">`).
- Include a descriptive `<title>` that reflects the current page content (via the `build_seo`
  helper and the `_seo_head.html` partial).
- Use semantic landmarks (`<nav>`, `<main>`, `<aside>`, `<footer>`).
- Ensure all form fields generated by Django forms have associated labels.

### Announcing HTMX partial swaps

An HTMX swap replaces DOM inside a target but does not move focus or announce the change. Keep a
persistent live region **outside** any swap target so it survives every swap, then write a message
after the swap settles:

```html
<div id="a11y-status" aria-live="polite" aria-atomic="true" class="sr-only"></div>

<form hx-get="/search/" hx-target="#results" hx-swap="innerHTML">
  <label for="q">Search</label>
  <input type="search" id="q" name="q" />
</form>
<div id="results"><!-- server-rendered results swapped in here --></div>

<script>
  document.body.addEventListener("htmx:afterSettle", (e) => {
    if (e.detail.target.id !== "results") return;
    const count = e.detail.target.querySelectorAll("[data-result]").length;
    document.getElementById("a11y-status").textContent = `${count} results`;
  });
</script>
```

Where the swap replaces the primary content region, manage focus as well — see
[`INTERACTION.md`](INTERACTION.md).

_Part of the `code/docs/` documentation family. See [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md) for the full index._
