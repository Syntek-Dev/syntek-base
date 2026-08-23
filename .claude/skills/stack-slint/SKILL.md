---
name: stack-slint
description: >-
  Build and review the native desktop surface of <%PROJECT_NAME%> — the Slint application at
  `code/src/rust/crates/desktop/`, carrying the Royalty-free licence obligation and its
  AboutSlint disclosure, the generated-code lint boundary, properties and callbacks, threading
  off the UI thread, and AccessKit accessibility. Load when a story needs its windows built, an
  existing window needs a UI or accessibility pass, or when a rust, security or review skill
  needs Slint conventions without owning them. Not the Django-templated web pages (`frontend`),
  not the PyO3 extensions in the same workspace (`stack-rust`), and not the API it consumes
  (`backend`). DESKTOP-ONLY — present only in a project generated with the desktop surface.
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Build the Desktop Surface (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is a native application).
You own the desktop layer of a feature and hand back. `stack-rust`, `security`, `test-writer` and
`code-reviewer` cite this at the desktop boundary without owning Slint conventions themselves.

**Desktop-only.** A project generated without the desktop surface has neither this skill nor the
crate it describes. If `code/src/rust/crates/desktop/` is absent, **say so and hand back** rather
than scaffolding it.

The standing conventions are **not** here: they are `code/docs/DESKTOP.md` and its two
sub-documents — `code/docs/desktop/LICENSING.md` (the three tiers and what triggers the paid
one) and `code/docs/desktop/UI-AND-STATE.md` (properties, callbacks, threading, state). Read
the guide first; everything below sequences it.

**Locale:** British English (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## Read this first: attribution is a licence obligation

Slint is tri-licensed — GPL-3.0, **Royalty-free**, or paid Commercial. This project takes the
Royalty-free arm: free for proprietary applications **and commercial sale**, on one condition —
**you must disclose that you use Slint.**

The `AboutSlint` widget in `ui/app.slint` is that disclosure, and
`code/src/scripts/desktop/package.sh` refuses a release build without it. If the check fires,
restore the widget; **never edit the check to pass.**

Two exclusions: **embedded systems** (appliance screens, POS terminals, car dashboards) need the
Commercial tier, and **redistributing anything that exposes Slint's APIs** is not covered — which
is why desktop UI is never moved into a shared package layer. Selling the app is fine; the paid
tier is triggered by _embedded_, not by charging money. Detail: `code/docs/desktop/LICENSING.md`.
That is a reading of the licence, not legal advice.

## The brief arrives settled

A fork has no conversation behind it and **cannot open a grilling pass**, so the UI design must
already be made. The brief must carry:

- **The window or component**, and its **wireframe** — `project-management/src/08-WIREFRAMES/`.
  Build the designed screen; do not reinvent it.
- **Every state** — loading, empty, error, success — and the navigation between windows.
- **Keyboard and screen-reader behaviour**, which is not inferable from a static wireframe.

**If the wireframe or the state set is missing, return and say so.** Where the caller wants the
design settled first, the pass is `grilling`, run inline before this skill is dispatched.

---

## The surface model

| Surface     | Lives in                        | Runtime                          |
| ----------- | ------------------------------- | -------------------------------- |
| **Web**     | `code/src/django/`              | Django ASGI — pages + `/api/`    |
| **Mobile**  | `code/src/mobile/`              | React Native (Expo) on device    |
| **Desktop** | `code/src/rust/crates/desktop/` | A native binary on the user's OS |

Peers, not layers. The desktop app is a native binary — not a webview and not an Electron shell —
and it consumes the Django Ninja API exactly as a third-party client would. It never renders a
Django page and Django never serves it. Every web doctrine statement is scoped to the web surface:
do not cite it here, and never carry desktop patterns back.

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
desktop app needs a display server the app container does not have. Never raw `cargo` or
`slint-viewer`.

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
already-closed case: handle it, never unwrap it. Never hardcode a display string in markup that
Rust should own.

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

AccessKit also sets the standing answer when an advisory arrives **through** it: an advisory
reached only via the AT-SPI stack is not answered by dropping accessibility. `deny.toml` carried
two `quick-xml` suppressions on exactly that reasoning until 16/08/2026, when an MSRV bump took
the chain out of the graph; the list is empty now and its comment keeps the worked precedent.

---

## Steps

1. **Reuse before you build.** Check the existing components before authoring a new one.
2. **Markup declares, Rust decides.** Display strings are `in` properties set from Rust.
3. **Set the style deliberately.** Slint 1.16+ defaults to Microsoft Fluent on every platform, so
   an app that sets nothing ships stock Fluent — the desktop equivalent of untouched
   component-library defaults. Style is a **compile-time** decision; drive the look from
   `Palette`/`StyleMetrics`, never bare `std-widgets`
   (`code/docs/visual-design/DESKTOP.md`).
4. **Verify before hand-off:**

   ```bash
   bash code/src/scripts/rust/lint.sh
   bash code/src/scripts/rust/test.sh
   bash code/src/scripts/rust/audit.sh
   bash code/src/scripts/desktop/package.sh
   ```

**Definition of done:** lint, tests, audit and `package.sh` all exit `0`; the attribution check
passes and the About dialog is reachable by eye; no panicking path in hand-written code; keyboard
and screen-reader behaviour checked on device; built to the screen's wireframe; no em dash in
user-facing copy (`how-to/src/BRAND-VOICE.md`); `CONTEXT.md` updated if structure changed;
British English.

## Guardrails recap

- The `AboutSlint` disclosure stays; `package.sh` enforces it.
- Never panic in hand-written code; keep the generated-code allow scoped to `mod ui`.
- **No business logic in the app** — it calls the API, the service layer decides. A rule
  reimplemented here is a second source of truth that will drift.
- **No credentials in plaintext on disk.** Platform secure store only — the user controls the
  machine, so treat it as hostile.
- Never move desktop components into a shared package layer — the licence forbids redistributing
  anything that exposes Slint's APIs.
- Never commit `target/` or a built binary — binaries break Copier generation.
- Source files ≤ 750 lines (800 grace).

## Handoff

Report the **files touched**, whether `package.sh` and its attribution gate passed, what was
**reused versus newly built**, and how keyboard and screen-reader behaviour was checked and on
what. Then name what is owed next: `test-writer` for the tests, `qa-tester` for the accessibility
and edge-case pass, `stack-rust` where the window needs a native primitive behind it, and
`backend` where the API contract it consumes is missing. **Suggest, do not chain**, unless the
caller said to.

## Governing procedures (route here — do not restate at length)

- `code/workflows/13-desktop-app/` — the procedure for this surface
- `code/workflows/12-rust-extension/` — when a window needs a native primitive behind it
- `code/workflows/02-tdd-cycle/` — the cycle tests are written through
- `project-management/workflows/21-frontend-code/` — the build phase this is entered from
- `project-management/workflows/08-wireframes/` — the screen designs consumed here
- `project-management/workflows/22-implementation-documentation/` — the closeout before commit
- `how-to/workflows/07-dependency-updates/` — the cadence a Slint bump follows

## Cross-references

- `code/docs/DESKTOP.md` and its `desktop/` sub-docs — the guide behind this skill
- `code/docs/VISUAL-DESIGN.md` — Section 3 the direction and its six axes, Section 4.1 the universal tells,
  Section 5 the motion numbers (read every time)
- `code/docs/visual-design/DESKTOP.md` — the desktop expression and the stock-Fluent tell
- `code/docs/rust/SUPPLY-CHAIN.md` — the audit policy and how an advisory may be suppressed
- `code/src/rust/CLAUDE.md` — the operating rules for the workspace
- `code/src/scripts/desktop/CONTEXT.md` — why these run on the host, and the attribution gate
- `how-to/src/BRAND-VOICE.md` — the voice for user-facing copy
