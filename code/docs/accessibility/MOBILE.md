---
type: guide
skills: [stack-react-native]
model: opus
---

# Accessibility — The Mobile Surface

**Last Updated:** <%DATE%>
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Claude Model:** opus — React Native accessibility APIs, screen readers, touch targets

> **Mobile-only.** This guide governs `code/src/mobile/` alone. The `stack-react-native` skill it
> routes to exists only in a project generated with the mobile surface; on a web-only project this
> guide is inert and nothing routes here.

---

## One standard, two technique sets

**WCAG 2.2 Level AA is unchanged by the platform.** It is not a web-only standard: W3C/WAI's own
guidance is explicit that WCAG applies to mobile applications, and EN 301 549 — the European
accessibility requirement for public procurement — applies WCAG's success criteria to non-web
software. The global rule in `.claude/CLAUDE.md` §8 therefore needs no mobile exception.

What changes is **how** a criterion is satisfied. There is no DOM, no ARIA and no semantic HTML
here. `code/docs/ACCESSIBILITY.md` and its sub-documents describe the web techniques; this
document describes the React Native ones. Both serve the same success criteria.

---

## The core props

Every interactive element carries the accessibility props that make it comprehensible to a screen
reader. React Native has no equivalent of an implicitly-accessible `<button>`: a `Pressable`
wrapping a `Text` is, by default, two unrelated nodes.

| Prop                 | Purpose                                                                     |
| -------------------- | --------------------------------------------------------------------------- |
| `accessible`         | Groups children into ONE focusable element — the closest thing to semantics |
| `accessibilityLabel` | The name announced. Required whenever the visible text is absent or unclear |
| `accessibilityRole`  | What the element IS (`button`, `link`, `header`, `image`, `switch`, …)      |
| `accessibilityState` | Current state — `disabled`, `selected`, `checked`, `busy`, `expanded`       |
| `accessibilityValue` | For ranges — `min`, `max`, `now`, `text`                                    |
| `accessibilityHint`  | What happens on activation. Use sparingly; it is verbose in practice        |

Rules:

- **`accessibilityRole` is not optional on anything interactive.** Without it a control is
  announced as plain text and the user is given no affordance that it can be activated.
- **State goes in `accessibilityState`, never baked into the label.** A label of
  `"Submit (disabled)"` is announced as a name; a screen reader cannot reason about it, and it
  does not survive translation.
- **Set `accessible` on the composite, not the parts.** Marking both a wrapper and its children
  accessible produces duplicate stops for every element on screen.
- **Decorative elements are hidden**, not labelled — `accessibilityElementsHidden` (iOS) and
  `importantForAccessibility="no-hide-descendants"` (Android). Both are needed; neither is
  cross-platform on its own.

---

## Screen readers — VoiceOver and TalkBack

The two behave differently enough that testing one proves little about the other:

- **Focus order follows the view hierarchy**, not visual position. A layout that reads correctly
  by eye can read in a nonsensical order if the hierarchy disagrees with it — absolute
  positioning and reordered flex children are the usual culprits.
- **Announce dynamic changes explicitly** with `AccessibilityInfo.announceForAccessibility()`.
  There is no live-region equivalent that fires automatically; content that changes without a
  focus change is silent unless announced.
- **Check whether a screen reader is running** with `AccessibilityInfo.isScreenReaderEnabled()`
  before behaviour that depends on it. Never use it to serve a reduced experience — only to
  announce something that visual users get from the layout itself.
- **Modals must move focus** on open and restore it on close, as on the web. React Native does
  not do this for you.

---

## Touch targets

Two floors apply, and the platform ones are the stricter:

| Source                           | Minimum            |
| -------------------------------- | ------------------ |
| WCAG 2.2 SC 2.5.8 (AA)           | 24 × 24 CSS pixels |
| Apple Human Interface Guidelines | 44 × 44 points     |
| Android Material Design          | 48 × 48 dp         |

**Design to the platform minimum, not the WCAG one.** Meeting 24 × 24 satisfies the audit and
still produces a control that is unpleasant to hit on a real device.

Where a control must be visually smaller than its target, expand the target rather than the
control — `hitSlop` enlarges the touchable area without changing layout. Spacing between adjacent
targets matters as much as their size; two 48 dp buttons flush against each other still mis-fire.

---

## Motion, contrast and preferences

- **Respect reduced motion.** `AccessibilityInfo.isReduceMotionEnabled()` plus the
  `reduceMotionChanged` listener. Animation is opt-out, and the check is a runtime API here, not
  a media query.
- **Reduced transparency** via `AccessibilityInfo.isReduceTransparencyEnabled()`.
- **Contrast ratios are unchanged** — 4.5:1 for normal text, 3:1 for large text and UI
  components, exactly as on the web. Colour values come from the token module, so the contrast
  a designer signed off on the web surface carries across, provided the token pair is the same
  one (`code/docs/design-tokens/MOBILE.md`).
- **`contrast` and `forced_colors` have no React Native equivalent**, so those token variants
  collapse to BASE on this surface. That is a documented limitation, not something to work around
  with platform-specific hacks.

---

## Verification is manual here

**There is no React Native counterpart to `axe-core-python`.** The web surface has an automated
WCAG scan wired into its e2e suite; this surface does not, and no equivalent exists to wire in.

Consequences, which must be stated rather than assumed:

- **Mobile accessibility is never "scanned clean".** An absence of findings on this surface means
  nobody looked, not that nothing is wrong. QA reports must say so explicitly.
- **React Native Testing Library queries are the closest automatable proxy** — asserting on
  `getByRole`, `getByLabelText` and accessibility state catches missing or wrong props in unit
  tests, which is the largest single class of defect. It proves the props exist; it proves
  nothing about how the screen actually reads.
- **The remainder is device testing**, with VoiceOver on iOS and TalkBack on Android, on both
  platforms — not one as a proxy for the other.

---

## Cross-references

- `code/docs/ACCESSIBILITY.md` — the parent guide and the web technique set
- `accessibility/TESTING-AND-COMPONENTS.md` — touch targets and testing on the web surface
- `code/docs/design-tokens/MOBILE.md` — where mobile colour values come from
- `code/src/mobile/CLAUDE.md` — the operating rules for the surface this governs
- `project-management/docs/QA-GUIDE.md` — how a manual finding is recorded
