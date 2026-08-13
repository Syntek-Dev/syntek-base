---
type: guide
skills: [stack-react-native]
model: opus
---

# Visual Design — the Mobile Surface

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)

**Mobile-only.** Present only in a project generated with the mobile surface.

The **mobile** expression of the doctrine in [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — React
Native (Expo), TypeScript, expo-router, StyleSheet over the generated token module.

**Read the index first.** The mandate (§1), the direction and its six axes (§3), the ban list
(§4.1 universal, §4.2 direction deviations) and the motion standard (§5) all live there.

---

## Mobile slop is a different taxonomy, not a translation

The web's layout-composition rules have **no native analogue**, and platform conformance has no web
analogue. The two rule sets overlap only on colour tokens, contrast, and motion. Do not port a web
clause here and do not assume a web clean bill means anything on this surface.

**Mobile slop is platform non-conformance** — a screen that is competent, accessible, and still
unmistakably a web page wearing a native shell.

## This file's scope — two dimensions, deliberately

Three of the five dimensions a native audit covers are **already owned elsewhere in this repo**, and
restating them here would put the same law in two places with no gate behind the copy:

| Dimension                                         | Owner                                                        |
| ------------------------------------------------- | ------------------------------------------------------------ |
| Accessibility — VoiceOver/TalkBack, touch targets | `../accessibility/MOBILE.md`                                 |
| Appearance — hard-coded values, dark mode         | `../design-tokens/MOBILE.md`, enforced by `mobile-tokens.sh` |
| Performance — list virtualisation, frame drops    | `../PERFORMANCE.md`                                          |

This guide owns the remaining two: **platform conformance** and **adaptivity**.

---

## Platform conformance

A screen is off-brand here when it announces that it was designed for a browser.

- **Web-shaped controls.** Buttons, inputs and selects styled as HTML rather than composed from the
  platform's own control vocabulary. A pill button with a CSS-shaped hover state is the tell.
- **Hover-dependent affordances.** There is no hover on a touch device. Any state or information
  that only appears on hover is unreachable — it is a functional defect, not only a visual one.
- **Non-native navigation.** A custom drawer or tab bar that ignores the platform's navigation
  idiom, its transitions, and its back semantics.
- **Hijacked system gestures.** Edge-swipe-back on iOS and predictive Back on Android belong to the
  OS. Intercepting either breaks the user's model of the whole device, not just this app.
- **Content under the system furniture** — the notch, Dynamic Island, status bar, or home
  indicator. Respect the safe-area insets; do not approximate them with fixed padding.
- **Mixed icon sets.** One family per platform — SF Symbols on iOS, Material Symbols on Android.
  Importing a web icon font is the same defect as importing a web layout.

**None of these read off a direction axis.** They are the mobile half of §4.1 — universal tells for
this surface, wrong under `editorial` and `classical-symmetric` alike. A direction changes how a
native control _looks_; it never licenses a web-shaped one.

## Adaptivity

The mobile viewport changes underneath a running app in ways a browser viewport does not.

- **Size classes and orientation.** Landscape is not a scaled portrait; a layout that only works in
  one orientation is unfinished unless the app locks orientation deliberately.
- **The keyboard occludes.** An IME covering the field being typed into is the most common
  adaptivity defect. Inputs stay visible when the keyboard is up.
- **Split View and multitasking** on tablets, and **foldable hinge posture** — the window can be a
  fraction of the screen, or spanned across a fold, at any moment.

**Adaptivity does read the density axis.** A `dense` direction has less room to absorb a keyboard
or a halved window, so it carries more of this burden — that is a consequence of the axis, not an
exemption from the rule.

---

## The direction, expressed here

The direction is committed once, in index §3, and never per-surface — a project is not `editorial`
on the web and something else on mobile. What changes is how each axis lands in StyleSheet:

| Axis      | Mobile expression                                                                   |
| --------- | ----------------------------------------------------------------------------------- |
| Alignment | `textAlign` and flex alignment on screen headers and list rows                      |
| Rhythm    | Section separation through background steps or dividers — not full-bleed page bands |
| Contrast  | Heading weight and size relative to the Dynamic Type scale, never fixed point sizes |
| Ornament  | Border, divider and card-chrome density                                             |
| Density   | Spacing scale and list row height                                                   |
| Motion    | Level only; the numbers are index §5                                                |

**Rhythm is the axis that translates least directly.** Alternating full-bleed bands are a web device
that reads as heavy on a phone; the same `banded` intent is expressed through grouped sections with
background steps, in the platform's own idiom.

## Motion — the mobile expression

**The numbers are `../VISUAL-DESIGN.md` §5.** This section states only the expression.

- **Reanimated on the UI thread**, animating transform and opacity only — the same two properties,
  for the same reason.
- Durations and easing come from the generated token module's `motion` category, not from literals.
- **`AccessibilityInfo.isReduceMotionEnabled()` plus its change listener** selects the `reduce`
  axis at runtime (`../design-tokens/MOBILE.md`). Reduced still means fewer and gentler, not none.
- The frequency floor applies unchanged, and bites harder here: a gesture repeated all day is the
  common case on a phone, not the exception.

---

## Verification is judgement, not a script

**[judgement]** — every clause in this file, both dimensions. Tier scheme:
[`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) §6.

There is no browser to drive and no rendered scan for this surface. Platform conformance is
assessed by a person on a device, in both orientations, with the keyboard up — the same position
`../accessibility/MOBILE.md` takes on mobile accessibility, and for the same reason. Treat a clean
`mobile-tokens.sh` run as evidence about **values**, never about conformance.

## Cross-references

- [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — the index: mandate, direction and axes, ban list, motion
- `../accessibility/MOBILE.md` — the accessibility dimension, and the manual-verification doctrine
- `../design-tokens/MOBILE.md` — the token bridge and the `reduce` axis at runtime
- `../PERFORMANCE.md` — the performance dimension
- `.claude/skills/stack-react-native/SKILL.md` — the stack conventions
