# Responsive Design

## Device Split

The gap between mobile and desktop/laptop is still growing, but tablets remain minimal.

| Device         | Share |
| -------------- | ----- |
| Mobile         | ~62%  |
| Desktop/Laptop | ~36%  |
| Tablet         | ~2%   |

_Source: StatCounter, early 2026_

## Screen Size and Resolution

**Desktop:** 1920×1080 is still the most common resolution by a wide margin.

**Mobile:** The most common viewport is around 360×800. Modern Androids and iPhones sit in a narrow 360–430px range.

## Orientation

No tracker publishes this directly, but piecing it together from available data:

| Orientation | Share   | Notes                                       |
| ----------- | ------- | ------------------------------------------- |
| Portrait    | ~58–60% | Nearly all mobile sessions                  |
| Landscape   | ~40–42% | Desktop (always landscape) plus some tablet |

On smartphones specifically, ~90% of use is portrait — even on video sites it remains ~82% portrait.

## What This Means

If something needs to be usable by the majority of users, it must be portrait-oriented and mobile-friendly first. **Design mobile-first and scale up.** Wireframes and Figma designs should always start from a mobile viewport and work upward.

## Media Queries vs Container Queries

**Media queries** respond to the viewport or device characteristics — use them for overall page layout. **Container queries** respond to the size or state of a parent element — use them for individual components. They complement each other; neither replaces the other.

## Media Queries

### Syntax

```css
@media [media-type] [logical-operator] (media-feature) {
  /* styles */
}
```

The media type is optional and defaults to `all`. The three valid types:

| Type     | Purpose                            |
| -------- | ---------------------------------- |
| `screen` | All screen displays                |
| `print`  | Printers and print preview         |
| `all`    | All devices (default when omitted) |

### Breakpoints

Width is the most-used media feature. Always use the named pixel tokens from the project's Tailwind CSS config for web and the NativeWind CSS config for mobile — never write ad-hoc pixel values inline. Use modern range syntax rather than `min-width`/`max-width` prefixes:

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

### Mobile-First

Write base styles for the smallest viewport first, then layer `min-width` queries upward. This produces smaller CSS for mobile devices and aligns with the project's mobile-first design principle. Never use `max-width` for new layouts — only when retrofitting a legacy desktop-first stylesheet:

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

### Orientation

Use orientation queries for layouts that change fundamentally between portrait and landscape — not as a substitute for width breakpoints:

```css
@media (orientation: landscape) {
}
@media (orientation: portrait) {
}
```

### Pointer and Hover

Adapt touch targets and hover interactions based on the primary input device rather than screen size alone — a large tablet can still be touch-only:

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

### User Preferences

These are non-negotiable — they reflect explicit accessibility settings the user has made at the OS or browser level:

```css
@media (prefers-color-scheme: dark) {
}
@media (prefers-color-scheme: light) {
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

@media (prefers-contrast: more) {
}
```

### Resolution

Use for serving high-DPI image assets — do not use to infer device type:

```css
@media (min-resolution: 2dppx) {
  /* Retina / HiDPI displays — serve 2× assets */
}
```

### Display Mode

Use for PWA-specific layout adjustments when the app is running outside the browser:

```css
@media (display-mode: standalone) {
}
```

### Logical Operators

| Operator | Example                                      | Meaning                                            |
| -------- | -------------------------------------------- | -------------------------------------------------- |
| `and`    | `screen and (width >= 768px)`                | All conditions must be true                        |
| `,`      | `(width >= 768px), (orientation: landscape)` | Any condition can be true (acts as `or`)           |
| `not`    | `not (width >= 768px)`                       | Inverts the query                                  |
| `only`   | `only screen and (color)`                    | Hides from legacy browsers lacking feature support |

### HTML Integration

Always include the viewport meta tag — without it, mobile browsers render at a default 980px width and media queries fire at the wrong sizes:

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

### Print Styles

There is no separate `print.css` file in this project. Tailwind's built-in `print:` variant handles print styles directly on elements — this is the preferred approach for most cases:

```tsx
<nav className="print:hidden">...</nav>
<footer className="print:block hidden">...</footer>
```

For anything too complex for utility classes, add an `@media print {}` block directly to `global.css` on the web side. Do not create a standalone print stylesheet.

Print styles are web-only — NativeWind and React Native have no print concept, so never add print styles to the shared or mobile `global.css`.

### JavaScript

Test and react to media query changes programmatically with `matchMedia()`:

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

## Container Queries

**Container queries** are best used for components that need to adapt based on the space they occupy rather than the whole screen. A card component might sit in a narrow sidebar on one page and a wide grid on another — container queries let it respond to its own container, so the same component works everywhere without special cases.

### Declaring a Container

Before any child can run a container query, the parent HTML element must opt in with `container-type`. Use `inline-size` in most cases — it enables querying the container's width without also constraining the block axis:

```css
.card-wrapper {
  container-type: inline-size;
}
```

To name a container (useful when elements are nested inside multiple containers and you need to target a specific ancestor):

```css
.card-wrapper {
  container: card / inline-size;
}
```

### Query Syntax and Units

Container query breakpoints use `ch` (character width) rather than pixels. This ties breakpoints to the typography — they naturally adjust when font size changes and make it easier to reason about how much text fits at each breakpoint:

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

Inside a query block, use container query units for property values that should scale with the container rather than the viewport:

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

### Custom Container Sizes

Define reusable `ch`-based container sizes using `--container-*` theme variables in each `global.css`. Tailwind and NativeWind automatically expose each one as a `@{name}:` variant usable directly in class names.

**Web** — `code/src/frontend/src/app/global.css`:

```css
@theme {
  --container-xs: 20ch;
  --container-sm: 40ch;
  --container-md: 60ch;
  --container-lg: 80ch;
  --container-xl: 100ch;
}
```

**Mobile** — `code/src/mobile/global.css`:

```css
@theme {
  --container-xs: 20ch;
  --container-sm: 40ch;
  --container-md: 60ch;
  --container-lg: 80ch;
  --container-xl: 100ch;
}
```

Use them in JSX by marking the parent as `@container` and applying `@{name}:` variants to children:

```tsx
<div className="@container">
  <p className="@sm:flex-row @md:grid-cols-2 flex-col">...</p>
</div>
```

> **NativeWind caveat:** `ch` is a browser font-metric unit. React Native's layout engine (Yoga) does not natively understand it — NativeWind may silently fall back to pixels for `ch` values on the native side. Verify container query behaviour on device when implementing for the first time.

### Three Query Types

| Type             | What it queries                                                                 | Browser support                          |
| ---------------- | ------------------------------------------------------------------------------- | ---------------------------------------- |
| **Size**         | Container dimensions — width, height, inline/block size                         | Baseline (all major browsers since 2023) |
| **Style**        | CSS custom property values — `@container style(--variant: compact)`             | Partial — Firefox pending                |
| **Scroll-state** | Scroll conditions — `stuck`, `snapped`, `scrollable` on sticky/snapped elements | Chrome, Edge, Opera only (2025+)         |

Size queries are the primary type and what you will use day-to-day. Style and scroll-state queries are progressive enhancements — wrap them in `@supports` when used:

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

### Key Limitations

- **No self-queries** — a container reads its ancestor's dimensions, not its own. Structure the HTML so the queried container wraps the component, not the component itself.
- **No `var()` in conditions** — custom properties cannot be used inside `@container (min-width: var(--bp))`. Define named container sizes in the config instead.
- **Flexbox sizing** — flex children need explicit or intrinsic sizing; without it, containment can cause content to collapse.

> Kevin Powell covers both of these well on his YouTube channel — genuinely the best CSS content available on these topics.

## Web Breakpoints

```text
┌───────┬───────────┬──────────────────────────────────────────────────┐
│ Token │ Min width │                 Typical devices                  │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ base  │ 320px     │ Smallest phones — iPhone SE 1st gen, Galaxy S5   │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xs    │ 360px     │ Standard Android phones — Galaxy S series, Pixel │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ sm    │ 430px     │ Large phones — iPhone Pro Max, Pixel 7 Pro       │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xmd   │ 600px     │ Small tablets portrait, large phones landscape   │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ md    │ 768px     │ iPad mini / Air portrait, WXGA monitors          │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xlg   │ 1024px    │ Large tablets landscape, small laptops           │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ hd    │ 1280px    │ 720p HD, most common laptop (1280×720, 1366×768) │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ lg    │ 1920px    │ 1080p Full HD                                    │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ xl    │ 2560px    │ 1440p QHD                                        │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ 2xl   │ 3840px    │ 4K UHD                                           │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ 3xl   │ 5760px    │ 6K                                               │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ 4xl   │ 7680px    │ 8K UHD                                           │
├───────┼───────────┼──────────────────────────────────────────────────┤
│ 5xl   │ 10240px   │ 10K                                              │
└───────┴───────────┴──────────────────────────────────────────────────┘
```

## Mobile App Viewports

### Portrait — cover each breakpoint tier

```text
┌────────────────┬────────────────┬─────────────────────────────────────────────┐
│ Viewport (W×H) │ Breakpoint hit │            Representative device            │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 320×568        │ base           │ iPhone SE 1st gen                           │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 360×780        │ xs             │ Galaxy S24 / Pixel 7a                       │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 390×844        │ xs–sm          │ iPhone 15 / Pixel 8 — high real-world share │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 430×932        │ sm             │ iPhone 15 Pro Max / Plus                    │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 600×960        │ xmd            │ Galaxy Tab A7 Lite portrait                 │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 768×1024       │ md             │ iPad mini / Air portrait                    │
├────────────────┼────────────────┼─────────────────────────────────────────────┤
│ 1024×1366      │ xlg            │ iPad Pro 12.9" portrait                     │
└────────────────┴────────────────┴─────────────────────────────────────────────┘
```

### Landscape — critical for xmd and above

```text
┌────────────────┬────────────────┬─────────────────────────────┐
│ Viewport (W×H) │ Breakpoint hit │            Notes            │
├────────────────┼────────────────┼─────────────────────────────┤
│ 568×320        │ xs             │ iPhone SE landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 844×390        │ xlg            │ iPhone 15 landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 932×430        │ xlg            │ iPhone 15 Pro Max landscape │
├────────────────┼────────────────┼─────────────────────────────┤
│ 1024×768       │ xlg            │ iPad mini landscape         │
├────────────────┼────────────────┼─────────────────────────────┤
│ 1366×1024      │ lg             │ iPad Pro landscape          │
└────────────────┴────────────────┴─────────────────────────────┘
```

### Why these viewports specifically

- **390×844** is the single most important — it is the most common real-world phone size but sits between `xs` and `sm`, so it catches off-by-one errors in breakpoint hooks.
- **xmd (600px)** is the most commonly missed tier — it only activates on landscape phones and small tablets, which are easy to skip in testing.
- **768px** is where tablet layouts kick in via `md` — always test portrait and landscape separately at this size as they represent fundamentally different UX modes.
- **Everything above xlg (1024px)** is iPad Pro territory; one size is sufficient unless the app has a dedicated large-tablet layout.

### Maestro E2E minimum viable set

Prioritise these portrait viewports as the minimum for Maestro E2E tests:

- 360×780
- 390×844
- 430×932
- 768×1024

Add **932×430 landscape** if the app has any landscape-specific layouts.
