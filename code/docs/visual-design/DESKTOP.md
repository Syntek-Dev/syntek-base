---
type: guide
skills: [stack-slint]
model: opus
---

# Visual Design — the Desktop Surface

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)

**Desktop-only.** Present only in a project generated with the desktop surface.

The **desktop** expression of the doctrine in [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — the
Slint application at `code/src/rust/crates/desktop/`.

**Read the index first.** The mandate (§1), the direction and its six axes (§3), the ban list
(§4.1 universal, §4.2 direction deviations) and the motion standard (§5) all live there.

---

## Desktop slop is stock Fluent

The tell on this surface is precise and verifiable, which makes it unlike the other two.

**From Slint 1.16, Fluent is the default style on every platform.** This project pins 1.17. An app
that sets no style and composes from bare `std-widgets` therefore ships as **stock Microsoft
Fluent** — on macOS and Linux as well as Windows. That is the desktop equivalent of shipping
untouched component-library defaults: not broken, not ugly, and not designed.

The other built-in styles (Cupertino, Material, Qt, Native) receive fewer updates and are being
deprecated, because maintaining five parallel widget implementations is expensive. **Do not treat
"pick a different built-in style" as the answer** — it is a slower path to the same defect, on a
style that is going away.

### The rule

**A desktop app states its style deliberately, and composes its own look from the design system
rather than inheriting a vendor's.** **[gate: fail]** — a build-config check (is a style set; are
bare `std-widgets` used), the cheapest deterministic clause on any surface. Tier scheme:
[`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) §6.

- The style is fixed at **compile time** — via the `SLINT_STYLE` environment variable or
  `slint_build::compile_with_config()`. It is a build decision, not a runtime one, so it cannot be
  deferred to "later".
- The documented route to a custom look is **consuming the `Palette` and `StyleMetrics` globals in
  your own components**, rather than leaning on `std-widgets` defaults. That is where the project's
  direction and tokens enter.
- Bare `std-widgets` in a screen that is meant to carry the brand is the defect. Using them as
  structural scaffolding beneath components that do set `Palette`/`StyleMetrics` is not.

**Ownership.** This guide owns the **rule**; the **compile-step mechanism** — where the style is
configured, how `build.rs` invokes `slint_build`, and the generated-code lint boundary — is owned by
[`../desktop/UI-AND-STATE.md`](../desktop/UI-AND-STATE.md). Change one and check the other.

This clause is a **universal tell for this surface**, not a direction deviation: stock Fluent is
wrong under `editorial` and `classical-symmetric` alike, because it is the absence of a choice
rather than a different one.

---

## The direction, expressed here

The direction is committed once, in index §3, and never per-surface. How each axis lands in Slint:

| Axis      | Desktop expression                                                        |
| --------- | ------------------------------------------------------------------------- |
| Alignment | `alignment` on layouts; window-content and dialog-header alignment        |
| Rhythm    | Background steps between regions via `Palette`, not full-bleed page bands |
| Contrast  | Type scale and weight through `StyleMetrics`                              |
| Ornament  | Border, separator and panel-chrome density                                |
| Density   | Layout `spacing` and `padding`, and control sizing                        |
| Motion    | Level only; the numbers are index §5                                      |

**Density carries more weight on this surface than on the other two.** A desktop window is resized
continuously and is often the app the user keeps open all day, so a `dense` direction is a more
defensible choice here than on a phone — and a `sparse` one costs more.

## Motion — the desktop expression

**The numbers are `../VISUAL-DESIGN.md` §5.** This section states only the expression.

- Slint `animate` blocks on properties, animating transform-equivalent and opacity properties only.
- Durations and easing come from the project's tokens, not from literals in `.slint` markup.
- **The frequency floor is at its strictest here.** A desktop app is keyboard-driven, and §5 names
  keyboard-initiated actions explicitly as the high-frequency case: those get no animation at all.
- Reduced motion still means fewer and gentler, not none — keep opacity and colour, drop movement.

---

## What this guide does not yet cover

Stated plainly rather than padded. The research behind this epic surfaced **one** solid,
citable desktop finding — the stock-Fluent tell above — against a documented taxonomy for web and
mobile. Desktop-specific composition questions that have **no evidenced rule yet**: window chrome
and title-bar treatment, native menu-bar conventions per OS, multi-window and dialog hierarchy, and
HiDPI/mixed-DPI behaviour.

They are absent because nothing published settles them, not because they do not matter. Adding a
clause here requires the same standard as every other clause in this doctrine: a citable source or
a decision recorded through grilling. **Do not fill this section by analogy with the web.**

## Cross-references

- [`../VISUAL-DESIGN.md`](../VISUAL-DESIGN.md) — the index: mandate, direction and axes, ban list, motion
- [`../desktop/UI-AND-STATE.md`](../desktop/UI-AND-STATE.md) — the compile step, the generated-code
  lint boundary, threading, and AccessKit accessibility
- [`../desktop/LICENSING.md`](../desktop/LICENSING.md) — the Royalty-free licence and the
  `AboutSlint` disclosure obligation
- `.claude/skills/stack-slint/SKILL.md` — the stack conventions
