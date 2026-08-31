# Browser divergence on a no-build CSS stack

**Written**: 31/08/2026 · **Driver**: `MAP-PROGRESSIVE-ENHANCEMENT` **N-024** ·
**Recovers**: the main body of **N-008**, lost twice to incomplete agent delivery

The stack this is measured against: hand-written CSS, plain `<script type="module">`, **no
bundler, no PostCSS, no autoprefixer**. Divergence is answered by authoring rules only — a
`@supports` guard, a declaration-order fallback, or an avoidance rule. Declared matrix is
**Chromium + WebKit**; the Firefox column is carried because `N-025` reopens its inclusion.
On iOS every browser is WebKit, so the WebKit column is the floor for UK mobile.

**Why this note exists rather than a map section.** The map is an index; this is the evidence
behind two of its open nodes (`N-010`, `N-012`). It was lost twice before it was written down.

---

## 1. The Edge verdict — substantiated, with one caveat that confirms it

**Edge ships upstream Blink and exposes no rendering divergence a CSS or DOM author must code
around.** Every Edge-specific breakage vector is a policy or privacy layer, not an engine one.

- Chromium-based since Edge 79 (01/2020). MDN's browser-compat-data carries no Edge-specific
  rendering delta — Edge entries track Chrome's with a version offset only.
- **The caveat is IE mode**, and it proves the thesis rather than denting it: an administrator can
  force _named_ sites into the Trident engine via `InternetExplorerIntegrationSiteList`. It targets
  legacy intranet apps and is invoked by **policy**. Even Edge's one engine risk is a policy artefact.
- One cosmetic watch-item: Edge enables Chromium flags on its own schedule, so overlay-scrollbar
  behaviour can differ from Chrome on the same OS. **Rule: never let a layout depend on classic
  scrollbar width; use `scrollbar-gutter: stable` where a scrollbar would shift content.**

### Tracking Prevention — what each level actually does

Two enforcement actions: **restrict storage** (cookies, `localStorage`, IndexedDB) and **block the
resource load**. Classification is by tracker hostname against the Disconnect lists.
S = storage blocked · B = storage **and** load blocked · – = untouched.

| Level                  | Advertising | Analytics | Content | Cryptomining | Fingerprinting | Social | Other |
| ---------------------- | ----------- | --------- | ------- | ------------ | -------------- | ------ | ----- |
| Basic                  | –           | –         | –       | B            | B              | –      | –     |
| **Balanced** (default) | S           | –         | S       | B            | B              | S      | S     |
| Strict                 | B           | B         | S       | B            | B              | B      | B     |

**The finding that matters: first-party self-hosted assets are outside the blast radius entirely.**
Classification is by tracker hostname; your own origin is not on the Disconnect lists, so **no
level touches a self-hosted script, font or stylesheet**. The self-hosted asset strategy is a
complete defence here and needs no further rule.

At **Strict**, third-party Advertising / Analytics / Social / Other scripts never reach the
network. **Rule: any third-party-origin script or embed is progressive enhancement by definition.**
Enterprises can force Strict fleet-wide via the `TrackingPrevention` policy, so it is not a
power-user edge case.

### Enterprise policies that reach the no-JS floor

| Policy                                                    | Effect                     | Floor impact                                                                                                                            |
| --------------------------------------------------------- | -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `DefaultJavaScriptSetting=2` · `JavaScriptBlockedForUrls` | JS off, globally or by URL | HTMX and Alpine vanish. The floor holds **only if** every link is `<a>` and every form `<form>`                                         |
| `DefaultCookiesSetting` block · `CookiesBlockedForUrls`   | Cookies denied             | Django sessions, auth and CSRF fail. No authoring rule saves a logged-in surface; anonymous pages must not _require_ a cookie to render |
| `ExtensionInstallForcelist`                               | Forced content blockers    | Same posture as Strict — third-party assets are best-effort                                                                             |
| `DefaultJavaScriptJitSetting`                             | JIT off                    | Performance only. No rule needed                                                                                                        |

---

## 2. The per-feature CSS divergence table

Versions are first-unflagged-ship. Checked against Chromium ~139, **Safari 26.5** (11/05/2026) and
**Firefox 153** (21/07/2026). Dates marked _(projected)_ are +30-month arithmetic, not announcements.

| Feature                               | Chromium                                        | WebKit/Safari                     | Firefox                             | Baseline                                        | What a no-build author must do                                                                                                                                                                                                                                                                              |
| ------------------------------------- | ----------------------------------------------- | --------------------------------- | ----------------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `:has()`                              | 105                                             | 15.4                              | 121                                 | Widely 06/2026                                  | **Nothing — use freely.** Non-forgiving in all three: never comma-chain an experimental selector inside it                                                                                                                                                                                                  |
| `:focus-within`                       | 60                                              | 10.1                              | 52                                  | Widely                                          | **Nothing**                                                                                                                                                                                                                                                                                                 |
| `:focus-visible`                      | 86                                              | 15.4                              | 85                                  | Widely 09/2024                                  | Universal support, but _when it matches_ is a UA heuristic that differs on programmatic focus. **Keep a `:focus` fallback where a visible indicator is a WCAG 2.4.7 requirement**                                                                                                                           |
| Container queries (size)              | 105                                             | 16.0                              | 110                                 | Widely 08/2025                                  | **Nothing**                                                                                                                                                                                                                                                                                                 |
| Container **style** queries           | 111                                             | 18.0                              | **151 (05/2026)**                   | **Newly 05/2026**                               | Custom properties only — no engine supports `style(font-weight: bold)`. Pre-18 WebKit ignores the block. **Style queries may only enhance; base appearance is declared outside them**                                                                                                                       |
| Subgrid                               | 117                                             | 16.0                              | 71                                  | **Widely 03/2026**                              | **Nothing.** Unsupporting engines fall back to a nested grid — check reading order degrades acceptably                                                                                                                                                                                                      |
| CSS nesting                           | 112 · relaxed 120 · `CSSNestedDeclarations` 130 | 16.5 · 17.2 · 18.2                | 117 · · 132                         | Widely ~06/2026                                 | **Two rules. (1) Declarations first, nested rules after** — pre-`CSSNestedDeclarations` engines hoist trailing bare declarations above the nested rule, changing the cascade. **(2)** Start nested selectors with `&` for the pre-relaxed tail; an unsupporting engine drops the whole block silently       |
| `@layer`                              | 99                                              | 15.4                              | 97                                  | Widely 09/2024                                  | **Nothing.** Don't mix layered and unlayered declarations for one property — unlayered wins                                                                                                                                                                                                                 |
| `:is()` / `:where()`                  | 88                                              | 14                                | 78/82                               | Widely                                          | **Nothing.** Forgiving — this is where to wrap an experimental selector so it cannot invalidate the rule                                                                                                                                                                                                    |
| `color-mix()`                         | 111                                             | 16.2                              | 113                                 | Widely 11/2025                                  | Solid literal first, `color-mix()` second. **The fallback lives in the token definition, never in component CSS**                                                                                                                                                                                           |
| `oklch()`                             | 111                                             | 15.4                              | 113                                 | Widely 11/2025                                  | Same double-declaration. **Keep token values inside sRGB unless a P3 enhancement is deliberate and wrapped in `@media (color-gamut: p3)`**                                                                                                                                                                  |
| **Scroll-driven animations**          | 115                                             | **26.0 (09/2025)**; threaded 26.4 | **Not shipped** (flagged at Fx 153) | **Not Baseline**                                | **Enhancement only, always.** Unsupporting engines ignore `animation-timeline` and will play a _time-based_ animation if one is declared. **Attach the timeline inside `@supports (animation-timeline: scroll())`, give the keyframes no autoplay duration, and make the static state the complete design** |
| View Transitions — same-document      | 111                                             | 18.0                              | 144 (10/2025)                       | Newly 10/2025                                   | **Never call `document.startViewTransition()` bare** — feature-test so the DOM update runs unwrapped where unsupported                                                                                                                                                                                      |
| View Transitions — cross-document     | 126                                             | 18.2                              | **Not shipped**                     | **Not Baseline**                                | Pure CSS enhancement; the at-rule is ignored where unsupported. **Write nothing that assumes the transition happened**                                                                                                                                                                                      |
| `text-wrap: balance` / `pretty`       | 114 / 117                                       | 17.5 / 26.0                       | 121 / **not shipped**               | balance Newly 05/2024 · pretty **not Baseline** | No guard needed. But **line-count caps differ** (Chromium ≤ 6, Firefox ≤ 10) — **apply `balance` to headings only, never body copy** — and `pretty` produces visibly different rag between engines, so **do not pixel-match paragraph rag in visual QA**                                                    |
| **`field-sizing`**                    | 123                                             | **Not shipped** thru 26.5         | **Not shipped**                     | **Chromium-only**                               | **Avoidance rule: never design a form around auto-growing controls.** The WebKit rendering — fixed size, half of UK mobile — is the design of record                                                                                                                                                        |
| Anchor positioning                    | 125                                             | 26.0; fixes 26.4/26.5             | **147 (01/2026)**                   | **Newly ~01/2026**                              | Ships in all three, but interop is still settling and the pre-26 WebKit tail is large. **Guard with `@supports (anchor-name: --a)`, give every anchored element a usable static fallback, and keep `position-try-fallbacks` to a single simple list**                                                       |
| Popover                               | 114                                             | 17.0                              | 125                                 | Widely 10/2026 _(projected)_                    | **Use only `auto` and `manual`** — `hint` is Chromium-only. On the pre-17 WebKit tail the attribute is inert and **content renders inline and visible**: either guard the default-hidden style or accept visible-inline as the degraded state                                                               |
| `@starting-style`                     | 117                                             | 17.5 (partial) / **18.0**         | 129                                 | Newly 08/2024                                   | Unsupported → element appears instantly, an acceptable floor. **Never put load-bearing styles inside the block.** Treat Safari 17.5 as unsupporting for entry-from-`display:none`                                                                                                                           |
| `transition-behavior: allow-discrete` | 117                                             | 17.4                              | 129                                 | Newly 08/2024                                   | Safe unguarded for show/hide polish. **Never sequence logic on `transitionend` for a discrete transition** — on the unsupporting tail it never fires                                                                                                                                                        |
| `@property`                           | 85                                              | 16.4                              | 128                                 | Newly 07/2024                                   | Unsupported → the property still works, but loses animation, `initial-value` and inheritance control. **Treat it as animation-enablement only; give every `var(--x, fallback)` an explicit fallback. Register design-token properties in the token layer, keeping component CSS `var()`-only**              |

---

## 3. Honest gaps

Stated so a later reader does not mistake silence for verification:

- Edge/Chrome Fluent-scrollbar flag history — direction confirmed, versions not.
- Engine-specific `oklch()` gamut-mapping behaviour on sRGB displays.
- `popover="hint"` status in Safari 26.5 / Firefox 154.
- Firefox **154** (08/2026) release notes were not individually checked; 153's were. Anything
  marked "not shipped as of Fx 153" may have moved.
- Baseline "widely" dates marked _(projected)_ are arithmetic, not observed announcements.

---

## 4. What this feeds

| Node    | Use                                                                                                                                       |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `N-010` | The support policy's expression — the Baseline column is the evidence for the matrix                                                      |
| `N-012` | The rung-2 adoption policy — **partial only**; the rung-2 feature table is N-009's half                                                   |
| `N-023` | Scroll-driven animations — confirms Firefox has not shipped, and adds the pre-26 WebKit tail                                              |
| `N-025` | Firefox in the e2e matrix — Firefox is alone in lacking scroll-driven animations, `text-wrap: pretty` and cross-document view transitions |
