---
name: stack-slint
description: Desktop stack reference for <%PROJECT_NAME%> — the Slint application at code/src/rust/crates/desktop/, the Royalty-free licence obligation and its AboutSlint disclosure, the generated-code lint boundary, properties and callbacks, threading off the UI thread, and AccessKit accessibility. Load when building or reviewing the desktop surface, or when a rust, security, or review agent needs Slint conventions without owning them. DESKTOP-ONLY — present only in a project generated with the desktop surface.
---

Reference for the **desktop surface** of <%PROJECT_NAME%> — `code/src/rust/crates/desktop/`. The
`desktop` agent loads this for stack idioms; `rust`, `security`, `test-writer` and `code-reviewer`
cite it at the desktop boundary without owning Slint conventions themselves. Aligns with
`code/workflows/13-desktop-app/` and `code/docs/DESKTOP.md`.

**This skill is desktop-only.** A project generated without the desktop surface has neither this
skill nor the crate it describes.

The **visual** language is `code/docs/VISUAL-DESIGN.md` — §3 names this project's **direction** and
its six axes, §4.1 the universal tells, §5 the motion numbers. Its desktop expression is
`code/docs/visual-design/DESKTOP.md`: Slint 1.16+ defaults to **Microsoft Fluent on every
platform**, so an app that sets no style ships stock Fluent. Style is fixed at **compile time** —
choose it deliberately and drive the look from `Palette`/`StyleMetrics`, never bare `std-widgets`.

British English throughout (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## Read this first: attribution is a licence obligation

Slint is tri-licensed — GPL-3.0, **Royalty-free**, or paid Commercial. This project takes the
Royalty-free arm: free for proprietary applications **and commercial sale**, on one condition —
**you must disclose that you use Slint.**

The `AboutSlint` widget in `ui/app.slint` is that disclosure, and
`code/src/scripts/desktop/package.sh` refuses a release build without it. If the check fires,
restore the widget; **never edit the check to pass.**

Two exclusions:

| Not covered                                       | Consequence                                                      |
| ------------------------------------------------- | ---------------------------------------------------------------- |
| **Embedded systems**                              | Appliance screens, POS terminals, car dashboards need Commercial |
| **Redistributing anything exposing Slint's APIs** | Desktop UI is never moved into a shared package layer            |

Selling the app is fine — the paid tier is triggered by _embedded_, not by charging money. Detail:
`code/docs/desktop/LICENSING.md`. That is a reading of the licence, not legal advice.

---

## The surface model

| Surface     | Lives in                        | Runtime                          |
| ----------- | ------------------------------- | -------------------------------- |
| **Web**     | `code/src/django/`              | Django ASGI — pages + `/api/`    |
| **Mobile**  | `code/src/mobile/`              | React Native (Expo) on device    |
| **Desktop** | `code/src/rust/crates/desktop/` | A native binary on the user's OS |

Peers, not layers. The desktop app consumes the Django Ninja API exactly as a third-party client
would; it never renders a Django page. Every web doctrine statement is scoped to the web surface.

---

## Where it lives, and why not its own workspace

A **member of the existing Rust workspace**, not a second one. `members = ["crates/*"]` is a glob,
so the workspace adapts with no edit, and there stays exactly one `rust-toolchain.toml`, one
`deny.toml` and one `clippy.toml`. Two workspaces would mean two of each, drifting.

`slint` is pinned in this crate rather than `[workspace.dependencies]` — exactly one member uses it.

---

## Everything runs through the scripts

| Task                            | Script                                        |
| ------------------------------- | --------------------------------------------- |
| Run the app                     | `code/src/scripts/desktop/run.sh`             |
| Release binary (+ licence gate) | `code/src/scripts/desktop/package.sh`         |
| Lint · test · audit · build     | `code/src/scripts/rust/*.sh` — workspace-wide |

There is deliberately **no desktop lint/test/audit script**: the crate is a workspace member, so
the Rust group already covers it, and a duplicate would drift. These run on the **host** — a
desktop app needs a display server the app container does not have.

---

## The generated-code lint boundary

The single most important structural detail. `slint::include_modules!()` pastes generated code that
uses `unwrap()`, `panic!` and indexing freely — hundreds of times for a trivial window — into a
crate whose lint table denies exactly those. Wall it off:

```rust
#[allow(
    clippy::all, clippy::pedantic, clippy::unwrap_used,
    clippy::expect_used, clippy::panic, clippy::indexing_slicing,
    clippy::todo, clippy::unimplemented, clippy::unreachable
)]
mod ui {
    slint::include_modules!();
}

use slint::ComponentHandle;
use ui::AppWindow;
```

- **Never move the allow to crate root** — there it disarms the lints for your own code, which is
  the failure this prevents.
- **Name the four restriction lints individually.** `clippy::all` does **not** include the
  restriction group.
- **Import `ComponentHandle` explicitly.** It supplies `new`, `as_weak`, `run`; confined to a
  module, the generated re-exports no longer reach your scope.

`build.rs` returns `Result` rather than unwrapping — `expect_used` is denied there too, and cargo
prints a returned error better than a build-script panic.

---

## Markup declares, Rust decides

```slint
in property <string> status: "Ready";
callback refresh();
```

```rust
let handle = window.as_weak();
window.on_refresh(move || {
    if let Some(window) = handle.upgrade() {
        window.set_status(slint::SharedString::from("Refreshed"));
    }
});
```

**Callbacks hold a weak handle** — a strong clone captured in a closure the window owns is a
reference cycle and the window never drops. `upgrade()` returning `None` is the normal
already-closed case: handle it, never unwrap it.

Never hardcode a display string in markup that Rust should own.

---

## Never panic; never block the UI thread

A panic here is the user's window vanishing with no message — not a 500 someone retries. Return
`Result` and render the failure.

Slint types are not `Send` and the UI runs on one thread, so blocking work freezes the window:

```rust
std::thread::spawn(move || {
    let result = fetch_from_api();
    let _ = slint::invoke_from_event_loop(move || { /* ...update... */ });
});
```

`invoke_from_event_loop` is the only sanctioned way back. It returns `Result` because the loop may
have shut down — ignoring it with `let _ =` is correct; unwrapping it is not.

---

## Accessibility

Slint ships **AccessKit** (AT-SPI, UIA, NSAccessibility). Keep it. Set `accessible-role` and
`accessible-label` on anything interactive that is not self-describing.

WCAG 2.2 AA is a web standard and does not transfer verbatim, but its intent does: keyboard
reachable, labelled, not colour-only. **There is no `axe-core` equivalent** — verification is
manual with a screen reader, so never report desktop a11y as "scanned clean".

AccessKit is also why `deny.toml` accepts two `quick-xml` advisories: they are reached only through
the AT-SPI stack, and dropping accessibility is not the mitigation.

---

## Guardrails recap

- The `AboutSlint` disclosure stays; `package.sh` enforces it.
- Never panic in hand-written code; keep the generated-code allow scoped to `mod ui`.
- No business logic in the app — it calls the API, the service layer decides.
- No credentials in plaintext on disk; the user controls the machine.
- Never commit `target/` or a built binary — binaries break Copier generation.
- Source files ≤ 750 lines (800 grace).

## Governing procedures (route here — do not restate at length)

- `code/workflows/13-desktop-app/` — the procedure for this surface
- `code/workflows/12-rust-extension/` — when a window needs a native primitive behind it
- `project-management/workflows/20-frontend-code/` — the build phase this is entered from
- `how-to/workflows/07-dependency-updates/` — the cadence a Slint bump follows

## Cross-references

- `code/docs/DESKTOP.md` and its `desktop/` sub-docs — the guide behind this skill
- `code/docs/rust/SUPPLY-CHAIN.md` — the audit policy, including the AccessKit advisories
- `code/src/rust/CLAUDE.md` — the operating rules for the workspace
