---
type: guide
skills: [stack-slint]
model: opus
---

# Desktop Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

**Applies to:** `code/src/rust/crates/desktop/` **Reference implementation:** the same
**Claude Model:** opus — Slint UI, the licence obligation, the surface boundary

The native desktop surface of <%PROJECT_NAME%>: a **Slint** application, written in Rust, living
as a member of the Cargo workspace. Not a webview and not an Electron shell — a native binary.

> **Desktop-only.** This guide and the crate it describes exist only in a project generated with
> `INCLUDE_DESKTOP`, which is itself only offered when `INCLUDE_RUST` is true (Slint is Rust).

## Sub-documents

| Document                                             | Covers                                                                                                           |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| [`desktop/LICENSING.md`](desktop/LICENSING.md)       | The Royalty-free tier, what attribution satisfies it, the two exclusions, and when you need a Commercial licence |
| [`desktop/UI-AND-STATE.md`](desktop/UI-AND-STATE.md) | `.slint` markup, the generated-code lint boundary, properties and callbacks, threading, accessibility            |

---

## Read this first: attribution is a licence obligation

Slint is tri-licensed — **GPL-3.0**, **Royalty-free**, or paid **Commercial**. This project takes
the **Royalty-free** arm, which permits proprietary desktop applications **and commercial sale**
at no cost, on one condition: **you must disclose that you use Slint.**

The baseline app satisfies that with the `AboutSlint` widget in `ui/app.slint`. Removing it
without buying a Commercial licence is a **licence breach**, not a style regression — so
`code/src/scripts/desktop/package.sh` refuses to build a release binary if it is missing.

Two things the Royalty-free tier does **not** cover:

- **Embedded systems** — a controller driving an appliance screen, a POS terminal, a car
  dashboard. That needs the Commercial licence. An app on a user's general-purpose computer or
  phone does not, however it is sold.
- **Redistributing something that exposes Slint's own APIs** — which is why the desktop
  components live here, in the application, and **not** in a reusable package layer.

Full detail, including the exact clause text: [`desktop/LICENSING.md`](desktop/LICENSING.md).
This is a reading of the licence, not legal advice.

## The surface boundary

The desktop app is a **peer of the web surface, not a layer on it**:

- It consumes the Django Ninja API at `/api/` exactly as a third-party client would.
- It **never** renders a Django page, and Django **never** serves it.
- Web doctrine — "no client-side build", the three-tier server/HTMX/Alpine rule in
  `code/docs/RENDERING.md` — is scoped to the **web** surface. Your work here neither weakens nor
  extends it.

Definition of _surface_: `code/src/CONTEXT.md` → _Surfaces_.

## Where it lives, and why not its own workspace

```text
code/src/rust/crates/desktop/
├── Cargo.toml     ← slint pinned here, not in [workspace.dependencies]
├── build.rs       ← compiles ui/*.slint via slint-build
├── src/main.rs    ← the entry point and the scoped generated-code module
└── ui/app.slint   ← the markup, including the required AboutSlint widget
```

It is a **member of the existing Rust workspace**, not a second one. `members = ["crates/*"]` is a
glob, so the workspace adapts with no edit, and there stays exactly one `rust-toolchain.toml`, one
`deny.toml` and one `clippy.toml`. A second workspace would mean two of each, drifting.

`slint` is pinned in this crate rather than in `[workspace.dependencies]` because exactly one
member uses it.

## Everything runs through the scripts

| Task                        | Script                                        |
| --------------------------- | --------------------------------------------- |
| Run the app                 | `code/src/scripts/desktop/run.sh`             |
| Build the release binary    | `code/src/scripts/desktop/package.sh`         |
| Lint / test / audit / build | `code/src/scripts/rust/*.sh` — workspace-wide |

There is no separate desktop lint or test script: the crate is a workspace member, so the Rust
group already covers it. `run.sh` and `package.sh` exist for what is genuinely desktop-specific —
launching a window, and the attribution check before a release build.

These run on the **host**: a desktop application needs a display server, which the app container
does not have.

## The generated-code lint boundary

`slint::include_modules!()` pastes machine-generated code into the crate, and that code uses
`unwrap()`, `panic!` and indexing freely — several hundred times for a trivial window. The crate's
lint table denies exactly those, so the generated code is confined to its own module carrying a
scoped `#[allow]`:

```rust
#[allow(clippy::all, clippy::pedantic, clippy::unwrap_used,
        clippy::expect_used, clippy::panic, clippy::indexing_slicing,
        clippy::todo, clippy::unimplemented, clippy::unreachable)]
mod ui {
    slint::include_modules!();
}
use slint::ComponentHandle;
use ui::AppWindow;
```

**Never move that allow to crate root.** At root it disarms the lints for your own code too, which
is the failure the arrangement exists to prevent. Note also that the four restriction lints must be
named individually — `clippy::all` does **not** include the restriction group.

Detail: [`desktop/UI-AND-STATE.md`](desktop/UI-AND-STATE.md).

## Non-negotiables

- **The `AboutSlint` disclosure stays.** Licence obligation; `package.sh` enforces it.
- **Never panic in hand-written code.** A panic kills the user's window with no error they can act
  on. Return `Result` and surface the failure in the UI.
- **No business logic in the app.** It calls the API; the service layer decides. A desktop client
  that reimplements a rule is a second source of truth that will drift.
- **No credentials in plaintext on disk.** Use the platform secure store; treat the app as a
  hostile environment, because the user controls the machine.
- **Accessibility is not optional.** Slint ships AccessKit; keep it. It also fixes the answer
  when an advisory arrives through it: removing the accessibility stack is not a mitigation.
  `deny.toml` carried two suppressions on that reasoning until 16/08/2026; the list is empty now.
- **Never commit `target/`** or a built binary.

## Cross-references

- `code/docs/RUST.md` — the workspace this crate belongs to, and its three rules
- `code/docs/rust/SUPPLY-CHAIN.md` — the audit policy and how an advisory may be suppressed
- `code/src/rust/CLAUDE.md` — the operating rules for the tree
- `code/workflows/13-desktop-app/` — the procedure for building on it
- `.claude/skills/stack-slint/SKILL.md` — the idioms condensed for an agent

_Part of the `code/docs/` documentation family._
