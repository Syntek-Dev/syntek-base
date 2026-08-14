---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Responsive Design — Media Queries

**Project:** <%PROJECT_NAME%> **Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:**
<%ORG_NAME%> **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Media query syntax, breakpoint tokens, mobile-first layout strategy

---

## Media Queries vs Container Queries

**Media queries** respond to the viewport or device characteristics — use them for overall page
layout. **Container queries** respond to the size or state of a parent element — use them for
individual components. They complement each other; neither replaces the other.

---

## Syntax

```css
@media [media-type] [logical-operator] (media-feature) {
  /* styles */
}
```

The media type is optional and defaults to `all`. Valid types: `screen`, `print`, `all`.

---

## Breakpoints and Mobile-First

Always use the named pixel tokens from the project's CSS custom property token system — never write
ad-hoc pixel values inline. Use modern range syntax rather than `min-width`/`max-width` prefixes:

```css
/* Traditional — still valid */
@media (min-width: 768px) {
}

/* Modern range syntax — preferred */
@media (width >= 768px) {
}
@media (600px <= width <= 1024px) {
}
```

Write base styles for the smallest viewport first, then layer `min-width` queries upward. Never
use `max-width` for new layouts — only when retrofitting a legacy desktop-first stylesheet:

```css
/* Mobile base — no query needed */
.layout {
  display: block;
}

/* Tablet and above */
@media (width >= 768px) {
  .layout {
    display: grid;
    grid-template-columns: 3fr 1fr;
  }
}

/* Desktop and above */
@media (width >= 1280px) {
  .layout {
    grid-template-columns: 5fr 2fr;
  }
}
```

---

## Orientation

Use orientation queries for layouts that change fundamentally between portrait and landscape — not
as a substitute for width breakpoints:

```css
@media (orientation: landscape) {
}
@media (orientation: portrait) {
}
```

---

## Pointer and Hover

Adapt touch targets based on the primary input device rather than screen size alone:

```css
/* Mouse or stylus: fine pointer, hover available */
@media (pointer: fine) and (hover: hover) {
  .btn {
    padding: 0.5rem 1rem;
  }
}

/* Touchscreen: coarse pointer, no reliable hover */
@media (pointer: coarse) {
  .btn {
    min-height: 44px;
    padding: 0.75rem 1.25rem;
  }
}
```

---

## Resolution

Use for serving high-DPI image assets — do not use to infer device type:

```css
@media (min-resolution: 2dppx) {
  /* Retina / HiDPI displays — serve 2× assets */
}
```

---

## Display Mode

Use for PWA-specific layout adjustments when the app is running outside the browser:

```css
@media (display-mode: standalone) {
}
```

---

## Logical Operators

| Operator | Example                                      | Meaning                                            |
| -------- | -------------------------------------------- | -------------------------------------------------- |
| `and`    | `screen and (width >= 768px)`                | All conditions must be true                        |
| `,`      | `(width >= 768px), (orientation: landscape)` | Any condition can be true (acts as `or`)           |
| `not`    | `not (width >= 768px)`                       | Inverts the query                                  |
| `only`   | `only screen and (color)`                    | Hides from legacy browsers lacking feature support |

---

## HTML Integration

Always include the viewport meta tag — without it, mobile browsers render at 980px width:

```html
<meta name="viewport" content="width=device-width, initial-scale=1" />
```

Responsive images using `<picture>` with media queries:

```html
<picture>
  <source media="(width >= 768px)" srcset="hero-large.webp" />
  <img src="hero-small.webp" alt="..." />
</picture>
```

---

## Print Styles

There is no separate `print.css` file in this project. Add `@media print {}` blocks directly to the
global stylesheet (`code/src/django/static/css/`) or to the relevant django-component CSS file.

```css
@media print {
  nav {
    display: none;
  }
}
```

For component-level print overrides, add the `@media print` block alongside the component's other
styles. Print styles are web-only — never add print styles to shared or mobile CSS files.

---

## JavaScript

Prefer CSS media queries — reach for JavaScript only when a layout decision genuinely cannot be
expressed in CSS. That JavaScript lives in an Alpine.js component, or a static per-page script, and
uses the standard `matchMedia()` API:

```javascript
const wide = window.matchMedia("(width >= 768px)");

if (wide.matches) {
  /* already wide at page load */
}

wide.addEventListener("change", (e) => {
  if (e.matches) {
    /* viewport just crossed into wide */
  }
});
```

Alpine.js equivalent — expose the match as reactive state on the component:

```html
<div
  x-data="{ wide: window.matchMedia('(width >= 768px)').matches }"
  x-init="const mq = window.matchMedia('(width >= 768px)');
          mq.addEventListener('change', (e) => { wide = e.matches })"
>
  <template x-if="wide"><!-- wide-only markup --></template>
</div>
```

_Part of the `code/docs/` documentation family. See [`../RESPONSIVE-DESIGN.md`](../RESPONSIVE-DESIGN.md) for the full index._
