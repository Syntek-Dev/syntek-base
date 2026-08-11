---
type: guide
agent: desktop
skills: [stack-slint]
model: opus
---

# Desktop UI and State

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

Writing `.slint` markup, the boundary between generated and hand-written code, and how state
crosses it. Index: [`../DESKTOP.md`](../DESKTOP.md).

---

## Two files, one compile step

`build.rs` runs `slint_build::compile_with_config("ui/app.slint", config)`, which generates Rust
from the markup at build time and re-runs whenever a `.slint` file changes. Markup and generated
code therefore cannot drift.

`build.rs` returns `Result` rather than unwrapping — the crate denies `expect_used`, and cargo
prints a returned error far more legibly than a build-script panic.

**The style is fixed in this same compile step, and choosing it is not optional.** Slint 1.16
onwards defaults to Microsoft Fluent on every platform, so an app that sets nothing ships stock
Fluent on macOS and Linux too. The baseline therefore names one:

```rust
let config = slint_build::CompilerConfiguration::new().with_style("fluent".into());
slint_build::compile_with_config("ui/app.slint", config)?;
```

Fluent is chosen on the merits, being the only built-in style still actively maintained, and it is
**structural substrate only**: the app's own look is driven from the `Palette` and `StyleMetrics`
globals in `ui/app.slint`, not from bare `std-widgets` defaults.

Setting it here rather than through `SLINT_STYLE` is deliberate. The environment variable is the
fallback the compiler reads when no style is configured, so an explicit `with_style` overrides it,
and that precedence is the point: an appearance that varies with whoever ran the build is the
deferral this rule exists to stop. The gate is `code/src/scripts/desktop/style-check.sh`.

**This file owns the mechanism; the rule and its rationale are owned by
[`../visual-design/DESKTOP.md`](../visual-design/DESKTOP.md).** Change one and check the other.

## The generated-code lint boundary

This is the arrangement to understand before touching anything.

`slint::include_modules!()` pastes machine-generated code into the crate. That code uses
`unwrap()`, `panic!` and slice indexing freely — several hundred occurrences for a trivial window —
because it is generated and its invariants are guaranteed by the generator. The crate's lint table
denies exactly those, so the two cannot coexist unless the generated code is walled off:

```rust
#[allow(
    clippy::all,
    clippy::pedantic,
    clippy::unwrap_used,
    clippy::expect_used,
    clippy::panic,
    clippy::indexing_slicing,
    clippy::todo,
    clippy::unimplemented,
    clippy::unreachable
)]
mod ui {
    slint::include_modules!();
}

use slint::ComponentHandle;
use ui::AppWindow;
```

Three things follow, each of which will bite if forgotten:

- **Never move the allow to crate root.** At root it disarms the lints for your own code, which is
  the failure this exists to prevent. Scoped to a module, it covers only code you did not write.
- **Every restriction lint must be named individually, and the list must match the crate's
  `[lints.clippy]` table.** `clippy::all` does **not** include the restriction group, which is
  where all of these live, so listing only `clippy::all` leaves dozens of errors. A lint denied in
  `Cargo.toml` and missing here fails the build on code nobody in this repository wrote —
  `clippy::todo` is the live example, because `slint-build` emits
  `todo!("Components written in Rust can not get embedded yet.")` into `out/app.rs`. **Deny a new
  lint in the table and allow it here in the same change.**
- **`ComponentHandle` must be imported explicitly.** It supplies `new`, `as_weak` and `run`. When
  the generated code sat at crate root its re-exports were in scope; confined to a module, they are
  not.

## Markup: properties in, callbacks out

Never hardcode display strings in markup that Rust should own. Declare an `in` property and set it:

```slint
export component AppWindow inherits Window {
    in property <string> status: "Ready";
    callback refresh();

    Text { text: root.status; }
    Button { text: "Refresh"; clicked => { root.refresh(); } }
}
```

```rust
let handle = window.as_weak();
window.on_refresh(move || {
    if let Some(window) = handle.upgrade() {
        window.set_status(slint::SharedString::from("Refreshed"));
    }
});
```

**Callbacks hold a weak handle.** A strong clone captured in a closure the window itself owns is a
reference cycle, and the window never drops. `upgrade()` returning `None` is the normal
already-closed case — handle it, do not unwrap it.

Strings crossing the boundary are `slint::SharedString`. Prefer constructing it explicitly over
`.into()` where inference has nothing to work from.

## Never panic in hand-written code

A panic here is not a 500 someone retries — it is the user's window vanishing with no message. The
lint table denies the usual routes; return `Result` and render the failure:

```rust
fn main() -> Result<(), slint::PlatformError> {
    let window = AppWindow::new()?;
    window.run()
}
```

For recoverable failures — a request that timed out, a file that would not parse — set an error
property and let the UI show it. Terminating is almost never the right response to a fallible
operation in a GUI.

## Threading

The UI runs on one thread and Slint's types are not `Send`. Work that blocks — an API call, a file
read — must not run on it, or the window freezes.

Do the work on another thread and post the result back:

```rust
let handle = window.as_weak();
std::thread::spawn(move || {
    let result = fetch_from_api();
    let _ = slint::invoke_from_event_loop(move || {
        if let Some(window) = handle.upgrade() {
            window.set_status(result.into());
        }
    });
});
```

`invoke_from_event_loop` is the only sanctioned way back onto the UI thread. It returns a `Result`
because the loop may already have shut down; ignoring it deliberately with `let _ =` is correct,
unwrapping it is not.

## Accessibility

Slint ships **AccessKit**, which exposes the UI to screen readers (AT-SPI on Linux, UIA on Windows,
NSAccessibility on macOS). Keep it.

Set `accessible-role` and `accessible-label` on anything interactive that is not self-describing —
icon-only buttons especially. WCAG 2.2 AA is a web standard and does not transfer verbatim, but its
intent does: reachable by keyboard, labelled, and not colour-only.

Be honest in reports: there is no `axe-core` equivalent here, so desktop accessibility is verified
by hand with a screen reader, never "scanned clean".

AccessKit is also the reason `deny.toml` accepts two `quick-xml` advisories: they are reached only
through the AT-SPI stack. **Dropping accessibility is not the mitigation** — see
`code/docs/rust/SUPPLY-CHAIN.md`.

## Cross-references

- [`LICENSING.md`](LICENSING.md) — the `AboutSlint` widget this markup must keep
- [`../DESKTOP.md`](../DESKTOP.md) — the guide index and the surface boundary
- [`../visual-design/DESKTOP.md`](../visual-design/DESKTOP.md): the visual doctrine for this
  surface, covering the stock-Fluent tell, the style rule this file's compile step implements,
  and the axes
- `code/docs/rust/PYO3-BOUNDARY.md` — the sibling never-panic rule on the extension side

_Part of the `code/docs/desktop/` sub-document family._
