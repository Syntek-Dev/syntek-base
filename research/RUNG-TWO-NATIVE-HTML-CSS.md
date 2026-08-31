# Rung 2 — what native HTML and CSS can carry without JavaScript

**Written**: 31/08/2026 · **Driver**: `MAP-PROGRESSIVE-ENHANCEMENT` **N-024** ·
**Recovers**: Section 1 of **N-009**, lost twice to incomplete agent delivery

Rung 2 of the technology ladder: native HTML and CSS behaviour with **no JavaScript**. Assessed
against **Chromium + WebKit** (Firefox under review by `N-025`), no build step, no polyfill
pipeline, and **WCAG 2.2 AA as a hard gate**.

**This is the evidential basis of `N-012`** — the rung-2 adoption policy — and without it `N-012`
cannot be settled.

Verdicts take one of exactly three values: **SAFE TODAY** · **NEEDS FALLBACK** ·
**NOT YET VIABLE**.

---

## 1. The rung-2 feature table

| Feature                                               | Verdict            | Baseline                                                                   | What breaks where                                                                                                                                                                                                   | Fallback or guard                                                                                                                                                                                                                                           | WCAG 2.2 AA                                                                                                   |
| ----------------------------------------------------- | ------------------ | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `<details>`/`<summary>`                               | **SAFE TODAY**     | Widely, years                                                              | Nothing on the matrix. iOS VoiceOver has failed to announce the `summary` role and expanded state in some pairings                                                                                                  | None. Keep `<summary>` content simple. **Never** use it as a menu, dialog or tooltip substitute                                                                                                                                                             | Meets 4.1.2 natively for disclosure. The VoiceOver gap is a known AT bug, not an author failure               |
| `<details name>` exclusive accordion                  | **SAFE TODAY**     | Newly 03/09/2024                                                           | Nothing — both engines ~2.7 years. Pre-17.2 WebKit degrades to independent panels, which is harmless                                                                                                                | None                                                                                                                                                                                                                                                        | Avoid focus-holding content in a panel another `<summary>` will close                                         |
| `::details-content` + `interpolate-size`              | **NEEDS FALLBACK** | `::details-content` newly 16/09/2025; **`interpolate-size` Chromium-only** | Height animation does not run outside Chromium                                                                                                                                                                      | `@supports (interpolate-size: allow-keywords)`; degradation is **instant open/close**, fully functional                                                                                                                                                     | Must sit behind `prefers-reduced-motion`. No AA blocker                                                       |
| `<dialog>` modal (`showModal()`) + `::backdrop`       | **SAFE TODAY**     | **Widely 14/09/2024**                                                      | Nothing. Top layer, inert background, real focus containment, Esc-to-close — all native                                                                                                                             | `autofocus` on the right control. Never fake a modal with the `open` attribute                                                                                                                                                                              | **The strongest native a11y story on this list** — 2.4.3, 2.1.2 and inertness with no author ARIA             |
| `<dialog>` opened with no JS (`command`/`commandfor`) | **NEEDS FALLBACK** | Newly ~01/2026 — **Safari 26.2 (12/2025)** completed it                    | Safari 18.x–26.1: **the button does nothing.** A dead control — the worst failure class                                                                                                                             | Until 26.2 saturates: a two-line listener (a recorded step off rung 2 for the opener only). Re-verdict to SAFE once the floor is Safari 26.2+                                                                                                               | A visible control that does nothing fails users before it fails an SC                                         |
| `<dialog closedby>` light dismiss                     | **NOT YET VIABLE** | Limited — **no WebKit**                                                    | Safari ignores the attribute                                                                                                                                                                                        | Needs WebKit to ship it; on the Interop 2026 list                                                                                                                                                                                                           | Esc is already native to modal dialogs, so **AA is not blocked** — a convenience gap                          |
| `<dialog>` non-modal (`show()` / `open`)              | **NOT YET VIABLE** | n/a — not a compat verdict                                                 | By design: no focus management, no inertness, no `::backdrop`, no Esc                                                                                                                                               | Nothing to fix. A non-modal overlay is what `popover` is for                                                                                                                                                                                                | Unmanaged focus plus a floating `role="dialog"` is a reliable 2.4.3/1.3.2 failure                             |
| `popover="auto"` + `popovertarget`                    | **SAFE TODAY**     | Newly 27/01/2025                                                           | Nothing functional. **Safari does not create the `aria-details` relationship** and carries a tracked SR-translation deviation                                                                                       | Invoke only from a real `<button popovertarget>`. Browser assigns only a `group` role and moves no focus — **the role is the author's duty**                                                                                                                | 1.4.13 satisfied for toggled popovers (Esc + light dismiss native); 4.1.2 is on the author                    |
| `popover="manual"`                                    | **SAFE TODAY**     | As `auto`                                                                  | No light dismiss, no Esc, by definition                                                                                                                                                                             | Must ship its own visible focusable close control                                                                                                                                                                                                           | Without Esc, 1.4.13's dismissible arm rests on that control — put it first in tab order                       |
| `popover="hint"`                                      | **NOT YET VIABLE** | Limited — **no Safari**                                                    | Safari treats it as an invalid value                                                                                                                                                                                | Use `auto`                                                                                                                                                                                                                                                  | Hover-triggered, so full 1.4.13 duties apply and are not all native                                           |
| CSS anchor positioning                                | **NEEDS FALLBACK** | Disputed — caniuse says four-engine; web-features says limited             | Safari ≤ 18.7: no anchor properties at all — **the element lands top-left of the page**                                                                                                                             | **Two mandatory guards:** `@supports (anchor-name: --a)` with a designed non-anchored fallback position, and `position-try` fallbacks                                                                                                                       | Content rendered off-viewport is a 1.4.10 reflow failure — the designed fallback is what prevents it          |
| `:has()`                                              | **SAFE TODAY**     | **Widely 19/06/2026**                                                      | Nothing on the matrix                                                                                                                                                                                               | None. Keep selector complexity sane for style recalc                                                                                                                                                                                                        | None inherent — the risk is what you build with it                                                            |
| `:focus-within`                                       | **SAFE TODAY**     | Widely since 2017                                                          | Nothing, anywhere                                                                                                                                                                                                   | None                                                                                                                                                                                                                                                        | Useful **for** AA. Never the sole mechanism holding a menu open — focus loss collapses the UI mid-interaction |
| **CSS-only tabs**                                     | **NOT YET VIABLE** | Not a platform feature — every variant is a hack                           | The mechanism works visually everywhere; **the semantics exist nowhere.** Radio-hack tabs announce as form controls                                                                                                 | Needs a native tabs element that does not exist. Use an exclusive `<details name>` accordion or same-page navigation instead                                                                                                                                | **Hard AA failure without JS** — 4.1.2 and 2.1.1. The canonical case                                          |
| CSS-only accordions                                   | **SAFE TODAY**     | = `<details name>`                                                         | Radio/checkbox-hack accordions inherit the tabs row's failures and are banned                                                                                                                                       | Use `<details name>` only                                                                                                                                                                                                                                   | Native disclosure semantics satisfy APG's accordion pattern                                                   |
| CSS-only disclosure / dropdown menus                  | **NEEDS FALLBACK** | Building blocks all ship                                                   | Hover-only menus fail everywhere. `:focus-within` menus collapse on focus loss with no Esc. `<details>` menus have no light dismiss and iOS VoiceOver role gaps                                                     | **The honest shape is a popover disclosure**: `<button popovertarget>` + `popover="auto"` wrapping a plain `<ul>` of links. Esc, light dismiss, `aria-expanded`, top layer, focus-return — all native, zero JS. Arrow-key roving or `role="menu"` is rung 4 | Pure-hover menus fail 2.1.1 and 1.4.13 outright                                                               |
| Scroll-driven animations                              | **NEEDS FALLBACK** | Limited — **Firefox stable ships nothing**                                 | See Section 3 — the inactive-timeline trap drops the effect **even in supporting engines**                                                                                                                          | The two-rule pattern in Section 3. `@supports` alone is **not** sufficient                                                                                                                                                                                  | Invisible content fails 1.1.1 and 1.3.1 at once                                                               |
| CSS carousels (`::scroll-marker`)                     | **NOT YET VIABLE** | Limited — **Chrome only**                                                  | Outside Chromium: a plain scroller. **Inside** Chromium: markers exposed as `tab`s regardless of pattern, wrong item counts, invisible slides still focusable, generated content cannot carry real accessible names | Needs two more engines **and** the spec's semantics problems resolved. Use a scroll-snap scroller with real `<a>`/`<button>` markers                                                                                                                        | **Disqualified twice** — fails 4.1.2 and 2.1.1 in the one engine that ships it                                |

---

## 2. Where the accessibility story is worse than the compatibility story

Three cases where AT support, not browser support, sets the verdict:

1. **CSS-only tabs fail AA everywhere, including in fully supporting browsers.** No CSS mechanism
   sets `aria-selected`, moves a roving tabindex, or answers an arrow key. No shipping work will
   close this — it needs a native element that does not exist.
2. **CSS carousels are disqualified twice.** Even ignoring single-engine support, the Chromium
   implementation's semantics fail screen-reader users today, per published testing.
3. **Popover and `<dialog>` are near-misses handled by authoring, not disqualifications.** The
   browser gives a popover only `aria-expanded` wiring, a `group` role and focus-return; role and
   labels remain the author's. Modal `<dialog>` is the list's strongest native story.

---

## 3. Scroll-driven animations — `N-023` adjudicated

**The #1 ranking is confirmed on both grounds.**

**(a) Firefox stable ships no `animation-timeline`** as of 31/08/2026 — the sole Baseline blocker
for eleven months, still flag-gated. A claim circulating in secondary sources that Firefox 132+
supports it is contradicted by the primary data and is wrong.

**(b) The inactive-timeline behaviour is spec-mandated, not a bug.** A timeline whose scroller has
no scrollable overflow, or whose named reference does not resolve, is **inactive**: its
`currentTime` is null and the effect is not applied. **Both Chromium and Safari silently drop it,
so any hidden state authored in base CSS persists forever — even inside an `@supports` guard.**

**The guaranteed-visible pattern. Two rules; either alone is insufficient.**

1. **Base styles show the finished state.** `opacity: 0` never appears in the element's base rule.
2. **The hidden state lives only in the keyframes**, so an inactive timeline leaves the visible
   base styles in force. This is what `@supports` alone cannot protect against, because
   inactivity happens _in supporting browsers_.

```css
.reveal {
  opacity: 1;
} /* rule 1: visible with no animation at all */

@supports (animation-timeline: view()) {
  /* excludes Firefox, Safari <= 18.7 */
  @media (prefers-reduced-motion: no-preference) {
    .reveal {
      animation: reveal-in linear both;
      animation-timeline: view();
      animation-range: entry 0% entry 100%;
    }
  }
}

@keyframes reveal-in {
  from {
    opacity: 0;
    transform: translateY(1rem);
  } /* rule 2: hidden only here */
  to {
    opacity: 1;
    transform: none;
  }
}
```

**Authoring trap:** the `animation` shorthand resets `animation-timeline`, so the timeline must be
declared _after_ the shorthand.

---

## 4. The thesis — supported, with a correction that matters

_"Rung 2 is the rung most often skipped"_ is **supported**. Six of seventeen rows are SAFE TODAY
and five more are usable with a named guard — exclusive accordions, disclosure widgets, modal
dialogs, auto popovers, popover-based dropdown menus and `:has()`-driven state styling. **This
repository's own `code/docs/RENDERING.md` routes "nav menu, dropdowns, consent banner, tabs" and
"menus, toggles" to Alpine**, and defines three rungs with no rung-2 row at all. The skip is
evidenced here, in this tree.

**The correction: the skip is sometimes right.** For tabs, carousels and arrow-key menus, rung 2 is
not skipped but **correctly refused** — the accessibility semantics cannot exist without
JavaScript. The popular framing that native CSS "now does tabs and carousels" is the thesis
over-rotating, not being vindicated.

**So the doctrine `N-012` should write is not "always try rung 2 first". It is: rung 2 exists, it
is larger than this repo currently assumes, and its boundary is drawn by WCAG, not by caniuse.**

---

## 5. What this feeds

| Node    | Use                                                                                             |
| ------- | ----------------------------------------------------------------------------------------------- |
| `N-012` | **The whole evidential basis** — the verdict column is the adoption policy                      |
| `N-011` | Guide structure — the three-verdict vocabulary is a section shape                               |
| `N-023` | **Adjudicated in Section 3** — confirmed on both grounds, with the exact fallback pattern       |
| `N-015` | `RENDERING.md`'s demotion — its three rungs and its Alpine routing are named here as the defect |
