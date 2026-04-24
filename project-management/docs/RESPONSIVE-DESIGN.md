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

These media queries reflect explicit OS-level or browser-level settings the user has made. They are non-negotiable — always respect them. Ignoring them is an accessibility failure.

#### Quick Reference

| Query                          | Values                                    | What it signals                             |
| ------------------------------ | ----------------------------------------- | ------------------------------------------- |
| `prefers-color-scheme`         | `light`, `dark`                           | OS dark/light mode setting                  |
| `prefers-reduced-motion`       | `no-preference`, `reduce`                 | Reduced Motion enabled in OS                |
| `prefers-contrast`             | `no-preference`, `more`, `less`, `forced` | High or low contrast preference             |
| `forced-colors`                | `none`, `active`                          | Windows High Contrast / Forced Colours mode |
| `prefers-reduced-transparency` | `no-preference`, `reduce`                 | Reduce Transparency enabled (macOS/iOS)     |
| `prefers-reduced-data`         | `no-preference`, `reduce`                 | Data Saver / metered connection             |

---

#### Dark Mode — `prefers-color-scheme`

Design and implement for both light and dark at the same time. Never add dark mode as an afterthought.

**CSS custom properties — recommended approach:**

```css
:root {
  --colour-bg: #ffffff;
  --colour-text: #111111;
  --colour-surface: #f5f5f5;
  --colour-border: #d1d5db;
}

@media (prefers-color-scheme: dark) {
  :root {
    --colour-bg: #111111;
    --colour-text: #f5f5f5;
    --colour-surface: #1e1e1e;
    --colour-border: #374151;
  }
}
```

**Tailwind CSS — use the `dark:` variant:**

```tsx
<div className="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">...</div>
```

Tailwind's `dark:` variant uses `prefers-color-scheme` by default. If the project implements a manual dark mode toggle (via a class on `<html>`), configure `darkMode: 'class'` in `tailwind.config.ts`.

**JavaScript — reading and reacting to the preference:**

```typescript
const mq = window.matchMedia("(prefers-color-scheme: dark)");

if (mq.matches) {
  applyTheme("dark");
}

mq.addEventListener("change", (e) => {
  applyTheme(e.matches ? "dark" : "light");
});
```

**React hook:**

```typescript
function useColorScheme(): "light" | "dark" {
  const [scheme, setScheme] = useState<"light" | "dark">(
    window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light",
  );

  useEffect(() => {
    const mq = window.matchMedia("(prefers-color-scheme: dark)");
    const handler = (e: MediaQueryListEvent) => setScheme(e.matches ? "dark" : "light");
    mq.addEventListener("change", handler);
    return () => mq.removeEventListener("change", handler);
  }, []);

  return scheme;
}
```

**React Native — `useColorScheme`:**

```typescript
import { useColorScheme } from 'react-native';

function ThemedComponent() {
  const scheme = useColorScheme(); // 'light' | 'dark' | null
  const isDark = scheme === 'dark';

  return (
    <View style={{ backgroundColor: isDark ? '#111111' : '#ffffff' }}>
      ...
    </View>
  );
}
```

With NativeWind, use the `dark:` variant identically to the web — it reads from `useColorScheme` automatically.

**Rules:**

- Always verify contrast ratios in both light and dark palettes — they are independent checks.
- Never rely on colour alone to distinguish states. Icons, borders, and text must also work in both schemes.
- If implementing a manual theme toggle, persist the user's choice to `localStorage` (web) or `AsyncStorage` (mobile) and default to the OS preference when no override is set.

---

#### Reduced Motion — `prefers-reduced-motion`

Users enable this at the OS level when animations cause discomfort, dizziness, or distraction. See also the Motion and Animation section in `code/docs/ACCESSIBILITY.md` for the WCAG requirements that sit alongside this.

**CSS — global reset baseline:**

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Apply this reset globally. For individual components, provide a purposeful alternative rather than just removing the effect — a cross-fade is less disorienting than a slide, and an instant state change is better than breaking the feedback entirely:

```css
.slide-in {
  animation: slideIn 0.4s ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .slide-in {
    animation: fadeIn 0.15s ease-out;
  }
}
```

**Tailwind CSS — `motion-reduce:` and `motion-safe:` variants:**

```tsx
<div className="transition-transform motion-reduce:transition-none">...</div>
```

**React hook:**

```typescript
function usePrefersReducedMotion(): boolean {
  const [prefersReduced, setPrefersReduced] = useState(
    window.matchMedia("(prefers-reduced-motion: reduce)").matches,
  );

  useEffect(() => {
    const mq = window.matchMedia("(prefers-reduced-motion: reduce)");
    const handler = (e: MediaQueryListEvent) => setPrefersReduced(e.matches);
    mq.addEventListener("change", handler);
    return () => mq.removeEventListener("change", handler);
  }, []);

  return prefersReduced;
}
```

**React Native:**

```typescript
import { AccessibilityInfo } from "react-native";
import { useState, useEffect } from "react";

function usePrefersReducedMotion(): boolean {
  const [isReduceMotionEnabled, setIsReduceMotionEnabled] = useState(false);

  useEffect(() => {
    AccessibilityInfo.isReduceMotionEnabled().then(setIsReduceMotionEnabled);
    const subscription = AccessibilityInfo.addEventListener(
      "reduceMotionChanged",
      setIsReduceMotionEnabled,
    );
    return () => subscription.remove();
  }, []);

  return isReduceMotionEnabled;
}
```

---

#### High Contrast — `prefers-contrast` and `forced-colors`

Two separate but related queries — use both.

**`prefers-contrast`** — user has requested higher or lower contrast at the OS or browser level:

```css
@media (prefers-contrast: more) {
  :root {
    --colour-text: #000000;
    --colour-bg: #ffffff;
    --colour-border: #000000;
  }

  .btn {
    border: 2px solid currentColor;
    outline-offset: 2px;
  }
}

@media (prefers-contrast: less) {
  :root {
    --colour-text: #444444;
  }
}
```

Tailwind provides `contrast-more:` and `contrast-less:` variants.

**`forced-colors`** — Windows High Contrast mode and equivalent OS forced-colour modes. The browser replaces all colours with a restricted system palette. Do not fight it:

```css
@media (forced-colors: active) {
  .btn {
    border: 2px solid ButtonText;
    background: ButtonFace;
    color: ButtonText;
    forced-color-adjust: none; /* only use when absolutely necessary */
  }

  /* Restore structure that was conveyed via background alone */
  .card {
    border: 1px solid CanvasText;
  }
}
```

System colour keywords available in forced-colours mode: `Canvas`, `CanvasText`, `LinkText`, `VisitedText`, `ActiveText`, `ButtonFace`, `ButtonText`, `ButtonBorder`, `Field`, `FieldText`, `Highlight`, `HighlightText`, `SelectedItem`, `SelectedItemText`, `Mark`, `MarkText`, `GrayText`.

**Rules:**

- Never use `forced-color-adjust: none` to opt out of the system palette without a strong reason — it overrides the user's accessibility need.
- Test in Windows High Contrast mode (Settings > Accessibility > Contrast themes) before every release.
- Borders and outlines are preserved in forced-colours mode; backgrounds and `box-shadow` are not. Design components so that borders convey structure, not just decoration.

---

#### Reduced Transparency — `prefers-reduced-transparency`

Users on macOS and iOS can enable Reduce Transparency (System Settings > Accessibility > Display). Frosted glass, blur effects, and translucent overlays can cause visual noise for users with certain cognitive or visual conditions.

```css
@media (prefers-reduced-transparency: reduce) {
  .frosted-panel {
    backdrop-filter: none;
    background-color: var(--colour-surface);
  }

  .modal-overlay {
    background-color: rgba(0, 0, 0, 0.85);
  }
}
```

**React Native:**

```typescript
import { AccessibilityInfo } from "react-native";

AccessibilityInfo.isReduceTransparencyEnabled().then((isEnabled) => {
  if (isEnabled) {
    // use fully opaque backgrounds
  }
});
```

---

#### Reduced Data — `prefers-reduced-data`

Users on metered connections or with Data Saver enabled. Browser support is limited (Chrome/Edge behind a flag as of 2026), but worth planning for. Skip decorative assets and lazy-load aggressively:

```css
@media (prefers-reduced-data: reduce) {
  .hero {
    background-image: none;
  }
}
```

The Network Information API provides a complementary signal with broader current support:

```typescript
const connection = (navigator as Navigator & { connection?: { saveData: boolean } }).connection;
if (connection?.saveData) {
  // skip non-essential resource loads
}
```

---

#### React Native — Accessibility Preferences Hook

React Native exposes OS-level accessibility preferences via `AccessibilityInfo`. Subscribe to changes rather than reading once at mount — users can toggle these settings without restarting the app:

```typescript
import { AccessibilityInfo } from "react-native";
import { useState, useEffect } from "react";

interface AccessibilityPreferences {
  reduceMotion: boolean;
  reduceTransparency: boolean;
  screenReaderEnabled: boolean;
  boldText: boolean;
  grayscale: boolean;
}

function useAccessibilityPreferences(): AccessibilityPreferences {
  const [prefs, setPrefs] = useState<AccessibilityPreferences>({
    reduceMotion: false,
    reduceTransparency: false,
    screenReaderEnabled: false,
    boldText: false,
    grayscale: false,
  });

  useEffect(() => {
    Promise.all([
      AccessibilityInfo.isReduceMotionEnabled(),
      AccessibilityInfo.isReduceTransparencyEnabled(),
      AccessibilityInfo.isScreenReaderEnabled(),
      AccessibilityInfo.isBoldTextEnabled(),
      AccessibilityInfo.isGrayscaleEnabled(),
    ]).then(([reduceMotion, reduceTransparency, screenReaderEnabled, boldText, grayscale]) => {
      setPrefs({ reduceMotion, reduceTransparency, screenReaderEnabled, boldText, grayscale });
    });

    const subscriptions = [
      AccessibilityInfo.addEventListener("reduceMotionChanged", (v) =>
        setPrefs((p) => ({ ...p, reduceMotion: v })),
      ),
      AccessibilityInfo.addEventListener("reduceTransparencyChanged", (v) =>
        setPrefs((p) => ({ ...p, reduceTransparency: v })),
      ),
      AccessibilityInfo.addEventListener("screenReaderChanged", (v) =>
        setPrefs((p) => ({ ...p, screenReaderEnabled: v })),
      ),
      AccessibilityInfo.addEventListener("boldTextChanged", (v) =>
        setPrefs((p) => ({ ...p, boldText: v })),
      ),
      AccessibilityInfo.addEventListener("grayscaleChanged", (v) =>
        setPrefs((p) => ({ ...p, grayscale: v })),
      ),
    ];

    return () => subscriptions.forEach((s) => s.remove());
  }, []);

  return prefs;
}
```

| Preference                           | iOS | Android | `AccessibilityInfo` API       |
| ------------------------------------ | --- | ------- | ----------------------------- |
| Reduce Motion                        | ✓   | ✓       | `isReduceMotionEnabled`       |
| Reduce Transparency                  | ✓   | —       | `isReduceTransparencyEnabled` |
| Screen Reader (VoiceOver / TalkBack) | ✓   | ✓       | `isScreenReaderEnabled`       |
| Bold Text                            | ✓   | —       | `isBoldTextEnabled`           |
| Grayscale                            | ✓   | ✓       | `isGrayscaleEnabled`          |
| Invert Colours                       | ✓   | —       | `isInvertColorsEnabled`       |

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

## Design Toolchain

These breakpoints and viewports feed directly into the design process. The flow is:

1. **Brand phase** — Use [Claude Design by Anthropic Labs](https://www.anthropic.com/news/claude-design-anthropic-labs) to generate logo concepts, colour palettes, and typography. Document agreed decisions in `project-management/src/05-BRAND-GUIDE/`. Then port them into Figma as the brand guide file (see step 2).

2. **Design phase** — All brand guide files, component designs, and wireframes are built in Figma using the [Syntek Studio team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629):
   - **Brand guide template** — colours, typography, spacing, logo rules
   - **Component template** — all component variants and states
   - **Web wireframe template** — Next.js screen layouts starting at 360px and scaling up
   - **Mobile wireframe template** — Expo screen layouts using the portrait viewport tiers above

Wireframes must be produced mobile-first using the viewport tiers in this document. The final signed-off wireframes live in Figma; exported or linked from `project-management/src/07-WIREFRAMES/`.
