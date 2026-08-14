---
type: guide
skills: [backend, stack-django, stack-react-native]
model: opus
---

# Design Tokens — The Mobile Bridge

**Last Updated:** <%DATE%>
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Claude Model:** opus — Cross-surface token emission, colour conversion, mobile token-first law

How the database-canonical design tokens reach the **mobile surface** (`code/src/mobile/`), which
cannot consume CSS. The emitter specified here is Django-side work (`backend` + `stack-django`);
the consuming side is `stack-react-native`, which is **mobile-only** and absent from a web-only
project. This guide is present either way — it specifies a capability, and
a project without the mobile surface simply never builds it.

---

## Why the CSS cannot cross

The web delivery path ends in a stylesheet of CSS custom properties. **Every part of that
mechanism is unavailable in React Native**, so the bridge is a _second emitter over the same
rows_, never a consumer of the rendered CSS:

| Web mechanism            | React Native reality                                                            |
| ------------------------ | ------------------------------------------------------------------------------- |
| `var(--token)`           | No custom properties and no `var()` — nothing to reference                      |
| `oklch(…)` colour values | Not a parseable colour format in any documented version, including 0.86         |
| `px` / `rem` / `vh`      | All dimensions are unitless density-independent pixels; percentages are strings |
| `@media (prefers-…)`     | No media queries at all — preferences are runtime APIs, not query conditions    |

The consequence is structural, not cosmetic: an `oklch(...)` string reaching a React Native style
property is not a colour React Native can parse. **Conversion happens at emission time**, in
Python, before the value ever reaches the app.

---

## Storage — six forms, one canonical

`DesignToken` and `DesignTokenValue` each carry **all six colour forms** — OKLCH, HSL, HSLA, RGB,
RGBA and HEX. **OKLCH is canonical**; the service derives the other five on every write.

This is the load-bearing choice. The alternative — storing one form and converting on read —
means each consumer converts independently and they drift. Deriving on write makes drift
**structurally impossible**: five of the six forms are never hand-authored, so there is no edit
path that can desynchronise them. `value_kind` stays coherent because it describes the
**canonical** form, not the emitted one.

Rules that follow:

- **Never hand-author a derived form.** The editor exposes OKLCH; the rest are computed. A
  migration that writes a derived column without recomputing the set is a bug.
- **A write is atomic across all six.** Deriving five values and persisting them is part of the
  same transaction as the canonical write, never a follow-up task.
- Non-colour kinds (`length`, `number`, `duration`, `easing`, `shadow`, `reference`, `raw`) are
  unaffected — they have one form each.

### Gamut — out-of-sRGB colours

OKLCH can express colours no sRGB device can show. Those are resolved by **CSS Color 4 gamut
mapping**: chroma reduction at constant hue and lightness, until the colour falls inside the
destination gamut.

Chosen because it is **what a browser already does** with the same value, so the web and mobile
surfaces stay visually aligned rather than diverging on exactly the colours most likely to be
brand colours. Naive clipping per channel was rejected — it shifts hue, and it shifts it most on
saturated colours.

This requires a **colour-science dependency** in the Django application. That is a real cost and
belongs in the dependency review, not an incidental import.

---

## Mobile's form — 8-digit hex

The emitter writes colours as **`#rrggbbaa`**. Three reasons, in order of weight:

1. **Always-explicit alpha.** No pair of "the same colour, one with opacity" that silently differ.
2. **Fixed length**, so a malformed value is visible on sight and trivially validated.
3. **Widest parse compatibility** across React Native versions and third-party components —
   functional notations have varied in support; hex has not.

---

## The preference axes do not survive intact

Of the six axes, **three resolve at runtime, three do not**:

| Axis            | Mobile equivalent                                             | Emitted? |
| --------------- | ------------------------------------------------------------- | -------- |
| `color_scheme`  | `useColorScheme()` — returns the scheme, updates on change    | Yes      |
| `motion`        | `AccessibilityInfo.isReduceMotionEnabled()` + change listener | Yes      |
| `transparency`  | `AccessibilityInfo.isReduceTransparencyEnabled()`             | Yes      |
| `contrast`      | No React Native equivalent                                    | **No**   |
| `forced_colors` | No equivalent — a web and Windows platform concept            | **No**   |
| `data_saver`    | No equivalent — a web platform concept                        | **No**   |

The three unsupported axes **collapse to BASE** on mobile and the emitter **drops those
variants**. The editor marks them web-only so the asymmetry is visible at the point of authoring
rather than discovered later.

Mapping `contrast` onto iOS-only APIs was rejected: it would make the token system behave
differently on iOS and Android for the same row, which is worse than a documented, symmetrical
absence.

**Compound (multi-axis) variants have no mobile analogue whatsoever.** They emit AND-joined
`@media` blocks, and there is nothing to AND against. A compound variant whose axes are all
supported still collapses, because the cascade that combines them is a CSS mechanism.

`breakpoint` tokens stay `is_reference_only=True` here too — for a different reason than on the
web. On the web they are excluded because custom properties cannot appear inside `@media`
conditions; on mobile, because there are no media queries at all.

---

## Delivery — a static emitter, not a runtime feed

`render_tokens_ts()` is a **sibling of `render_tokens_css()`**, reading the same
`DesignToken`/`DesignTokenValue` rows and sharing the same purity boundary (pure renderer,
DB-backed wrapper). It emits a **typed TypeScript module** consumed by the app as `@/tokens`.

It rides the **existing provider-agnostic git write-back** — the same Contents-API adapter that
publishes the CSS, which is a no-op when unconfigured. The generated module is therefore
committed and compiled into the app like any other source file.

**The existing JSON endpoint is not a runtime feed.** `GET /api/design-tokens/` is session
authenticated and admin-only; it is an editor surface, not a public token API. Do not reach for
it as a shortcut to live mobile theming — that is a different feature with its own auth,
caching, and offline design, and it is not this.

### Consequence: the no-rebuild promise is web-only

The token system's headline property — change a value in the editor and see it live with no
frontend rebuild — **holds for the web surface only**. On mobile, a token change reaches an
installed application only via a **rebuild and a store release**.

State this plainly whenever the system is described. It is the single most likely
misunderstanding, because the promise is stated unqualified everywhere it predates the mobile
surface, and because the two surfaces otherwise share one source of truth.

---

## The token-first law on mobile

The law is unchanged in force; its **enforcement clause is CSS-shaped** and needs restating:

- **Web:** component CSS only ever consumes `var(--token)`, and the name must resolve in the
  token layer — both halves enforced by `code/src/scripts/audits/css-tokens.sh`.
- **Mobile:** `StyleSheet` values only ever come from the generated token module — never a raw
  literal. Enforced by `code/src/scripts/audits/mobile-tokens.sh` and its workflow.

**Only the no-raw-literals half needs a script on mobile.** The "name resolves" half is free:
the emitted module is typed, so an unresolved token import does not compile, and `typecheck.sh`
already fails the build. This is why the mobile audit is the smaller of the two, not because the
law is weaker here.

---

## Cross-references

- `code/docs/DESIGN-TOKENS.md` — entry point + the token-first law
- `design-tokens/MODEL.md` — the two models, the six colour forms, categories and value kinds
- `design-tokens/CASCADE.md` — the web cascade, emission order, and delivery
- `code/src/mobile/CONTEXT.md` — the mobile surface this emitter serves
- `code/src/scripts/audits/mobile-tokens.sh` — the mobile token-first gate
