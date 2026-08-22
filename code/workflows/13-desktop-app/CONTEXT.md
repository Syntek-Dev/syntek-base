# Workflow: Desktop Application (Slint)

The desktop app is a separate delivery target with its own release cycle, and a licence
obligation that free commercial use depends on. Both are easy to forget from inside the Rust
workspace, so the workflow states them first.

## Directory Tree

```text
code/workflows/13-desktop-app/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when building or changing the **native desktop application** at
`code/src/rust/crates/desktop/` — a new window, a new panel, a change to how the app talks to the
API, or a release build.

Use it only when the work belongs on the desktop **surface**. A feature that should be a web page
belongs in `01-implement-story`; a native primitive with no UI belongs in `12-rust-extension`.

**Desktop-only.** This workflow exists only in a project generated with `INCLUDE_DESKTOP`, which is
itself only offered when `INCLUDE_RUST` is true.

## Key concepts

- **Attribution is a licence obligation.** The Royalty-free tier is free for proprietary and
  commercially sold apps _provided you disclose your use of Slint_. `AboutSlint` is that
  disclosure; `package.sh` refuses a release build without it.
- **Peer, not layer.** The app consumes `/api/` exactly as a third-party client would. It never
  renders a Django page and Django never serves it.
- **A workspace member, not a second workspace.** One toolchain pin, one `deny.toml`, one
  `clippy.toml`. Lint, test and audit come from the Rust script group.
- **The generated-code allow is scoped to `mod ui`.** Slint's codegen uses `unwrap`/`panic`/
  indexing freely; the crate denies them. Moving that allow to crate root disarms your own code.
- **Never panic, never block the UI thread.** A panic is the user's window vanishing; a blocking
  call is a frozen window. Return `Result`; use `invoke_from_event_loop`.
- **No business logic in the app.** A rule reimplemented here is a second source of truth.
- **Accessibility is manual.** AccessKit is kept; there is no `axe-core` equivalent, so it is
  verified with a screen reader and never reported as scanned.

## Cross-references

### Governing documents

- `code/docs/desktop/LICENSING.md` — the obligation, its two exclusions, and the audit exceptions
- `code/docs/desktop/UI-AND-STATE.md` — the lint boundary, callbacks, threading, accessibility
- `code/docs/DESKTOP.md` — the surface boundary and the non-negotiables

### Related reading

- `code/docs/RUST.md` — the workspace this crate belongs to
- `code/docs/rust/SUPPLY-CHAIN.md` — why two AccessKit advisories are accepted
- `code/src/scripts/desktop/CONTEXT.md` — the desktop scripts and the attribution gate
- `code/workflows/12-rust-extension/` — when the window needs a native primitive behind it
- `code/workflows/02-tdd-cycle/` — the cycle tests are written through
- `project-management/workflows/08-wireframes/` — the screen designs consumed here
- `project-management/workflows/21-frontend-code/` — **this workflow is entered from there**
- `project-management/workflows/22-implementation-documentation/` — writes the implementation
  record and refreshes the graph; do not write it here
