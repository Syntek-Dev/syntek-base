---
workflow: 13-desktop-app
phase: build
skills: [stack-slint, stack-rust]
model: opus
---

# Desktop Application — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (DESKTOP.md, RUST.md, ACCESSIBILITY.md, SECURITY.md, TESTING.md) · **External — Native (rust-only)** (Slint) for supporting references.

## Gate

- [ ] The work belongs on the **desktop surface** — not a web page (`01-implement-story`) and not a
      headless native primitive (`12-rust-extension`) · _opus_
- [ ] The screen was grilled against its wireframe and confirmed before markup was written
- [ ] Entered from `project-management/workflows/21-frontend-code/`, not from a design gate

## Licence — the hard gate

- [ ] The `AboutSlint` widget is present in `ui/`
- [ ] A user can actually **reach** it in the running app (the script greps; it cannot see the UI)
- [ ] `bash code/src/scripts/desktop/package.sh` exits `0` — the check was **not** edited to pass
- [ ] Nothing here redistributes a library exposing Slint's APIs; desktop components stay in the
      application, never in a shared package layer
- [ ] No target added that is an **embedded system** (appliance screen, POS terminal, dashboard)
      without a Commercial licence

## UI and state

- [ ] Display strings are `in` properties set from Rust, not hardcoded in markup
- [ ] Callbacks hold a **weak** handle; `upgrade()` returning `None` is handled, never unwrapped
- [ ] The generated-code `#[allow]` is still scoped to `mod ui` — not moved to crate root
- [ ] No reachable panicking path in hand-written code (`unwrap`, `expect`, `panic!`, indexing)
- [ ] Every state is implemented: loading, empty, error, **offline**
- [ ] No blocking work on the UI thread; results return via `slint::invoke_from_event_loop`

## Boundary and security

- [ ] The app calls `/api/` as a third-party client would — it renders no Django page
- [ ] **No business logic in the app**; rules live in the service layer
- [ ] Credentials and tokens in the platform secure store, never a plaintext file
- [ ] Nothing sensitive reaches a log or an error message shown to the user
- [ ] Every state-changing call the app makes hits an endpoint with its own permission check —
      client-side gating is presentation, never authorisation

## Accessibility

- [ ] AccessKit still enabled
- [ ] `accessible-role` / `accessible-label` set on every interactive control that is not
      self-describing
- [ ] Fully operable by keyboard alone, with visible focus
- [ ] Verified with a named screen reader — and **reported as manual**, never "scanned"
- [ ] No information carried by colour alone; legible at OS scaling

## Quality gates

- [ ] `bash code/src/scripts/rust/lint.sh` exits `0` (rustfmt clean, clippy at `-D warnings`)
- [ ] `bash code/src/scripts/rust/test.sh` exits `0`
- [ ] `bash code/src/scripts/rust/audit.sh` exits `0` — no advisory newly suppressed to pass
- [ ] Source files ≤ 750 lines (800 grace)

## Closeout

- [ ] Built to the wireframe; brand voice followed in user-facing copy
- [ ] `target/` and every built binary excluded from the commit
- [ ] `code/src/rust/CONTEXT.md` updated if the tree changed
- [ ] Handed to `22-implementation-documentation` for the record, docs closeout and graph refresh
