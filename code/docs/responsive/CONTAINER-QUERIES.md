---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Responsive Design — Container Queries

**Project:** <%PROJECT_NAME%> **Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:**
<%ORG_NAME%> **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Container query patterns, container-type, size-responsive component layouts

---

## Container Queries

Container queries are best used for components that need to adapt based on the space they occupy
rather than the whole screen. A card component might sit in a narrow sidebar on one page and a
wide grid on another — container queries let it respond to its own container, so the same component
works everywhere without special cases.

---

## Declaring a Container

Before any child can run a container query, the parent HTML element must opt in with
`container-type`. Use `inline-size` in most cases — it enables querying the container's width
without also constraining the block axis:

```css
.card-wrapper {
  container-type: inline-size;
}
```

To name a container (useful when nested inside multiple containers):

```css
.card-wrapper {
  container: card / inline-size;
}
```

---

## Query Syntax and Units

Container query breakpoints use `ch` (character width) rather than pixels. This ties breakpoints
to the typography — they naturally adjust when font size changes:

```css
@container (min-width: 40ch) {
  .card {
    flex-direction: row;
  }
}

/* Targeting a named container */
@container card (min-width: 40ch) {
  .card {
    flex-direction: row;
  }
}
```

Container query units for property values that should scale with the container:

| Unit    | Definition                        |
| ------- | --------------------------------- |
| `cqi`   | 1% of the container's inline size |
| `cqb`   | 1% of the container's block size  |
| `cqw`   | 1% of the container's width       |
| `cqh`   | 1% of the container's height      |
| `cqmin` | Smaller of `cqi` / `cqb`          |
| `cqmax` | Larger of `cqi` / `cqb`           |

```css
@container card (min-width: 40ch) {
  .card {
    padding: clamp(0.5rem, 5cqi, 1.5rem);
    font-size: clamp(14px, 10px + 1.33cqi, 20px);
  }
}
```

---

## Custom Container Sizes

Define reusable `ch`-based container size values as CSS custom properties:

```css
/* code/src/django/static/css/global.css */
:root {
  --container-xs: 20ch;
  --container-sm: 40ch;
  --container-md: 60ch;
  --container-lg: 80ch;
  --container-xl: 100ch;
}
```

In django-component CSS, use the literal values (matching the tokens above) in `@container`
queries:

```css
/* Corresponds to --container-sm */
@container (min-width: 40ch) {
  .card {
    flex-direction: row;
  }
}
```

In a Django template, mark the container parent with an explicit CSS class:

```html
<div class="card-container">
  <p class="card-body">...</p>
</div>
```

```css
.card-container {
  container-type: inline-size;
}
```

---

## Three Query Types

| Type             | What it queries                                         | Browser support                  |
| ---------------- | ------------------------------------------------------- | -------------------------------- |
| **Size**         | Container dimensions — width, height, inline/block size | Baseline (all major since 2023)  |
| **Style**        | CSS custom property values                              | Partial — Firefox pending        |
| **Scroll-state** | Scroll conditions — `stuck`, `snapped`, `scrollable`    | Chrome, Edge, Opera only (2025+) |

Size queries are the primary type. Style and scroll-state queries are progressive enhancements —
wrap them in `@supports` when used:

```css
@supports (container-type: scroll-state) {
  .sticky-header {
    container-type: scroll-state;
  }

  @container scroll-state(stuck: top) {
    .sticky-header {
      box-shadow: 0 2px 8px hsl(0 0% 0% / 0.1);
    }
  }
}
```

---

## Key Limitations

- **No self-queries** — a container reads its ancestor's dimensions, not its own. Structure the HTML
  so the queried container wraps the component.
- **No `var()` in conditions** — custom properties cannot be used inside `@container (min-width:
var(--bp))`. Use literal values matched to the custom property definitions.
- **Flexbox sizing** — flex children need explicit or intrinsic sizing; without it, containment can
  cause content to collapse.

_Part of the `code/docs/` documentation family. See [`../RESPONSIVE-DESIGN.md`](../RESPONSIVE-DESIGN.md) for the full index._
