# Responsive Design

## Device Split

The gap between mobile and desktop/laptop is still growing, but tablets remain minimal.

| Device          | Share |
| --------------- | ----- |
| Mobile          | ~62%  |
| Desktop/Laptop  | ~36%  |
| Tablet          | ~2%   |

_Source: StatCounter, early 2026_

## Screen Size and Resolution

**Desktop:** 1920×1080 is still the most common resolution by a wide margin.

**Mobile:** The most common viewport is around 360×800. Modern Androids and iPhones sit in a narrow 360–430px range.

## Orientation

No tracker publishes this directly, but piecing it together from available data:

| Orientation | Share       | Notes                                       |
| ----------- | ----------- | ------------------------------------------- |
| Portrait    | ~58–60%     | Nearly all mobile sessions                  |
| Landscape   | ~40–42%     | Desktop (always landscape) plus some tablet |

On smartphones specifically, ~90% of use is portrait — even on video sites it remains ~82% portrait.

## What This Means

If something needs to be usable by the majority of users, it must be portrait-oriented and mobile-friendly first. **Design mobile-first and scale up.** Wireframes and Figma designs should always start from a mobile viewport and work upward.

## Media Queries vs Container Queries

**Media queries** are best used for overall page layout — changing the structure of the whole page based on viewport size. Examples: swapping a sidebar for a stacked layout on mobile, changing font scales, adjusting global spacing.

**Container queries** are best used for components that need to adapt based on the space they occupy rather than the whole screen. A card component might sit in a narrow sidebar on one page and a wide grid on another — container queries let it respond to its own container, so the same component works everywhere without special cases.

> Kevin Powell covers both of these well on his blog and YouTube channel — genuinely the best CSS content available on these topics.

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
