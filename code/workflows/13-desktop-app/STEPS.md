---
workflow: 13-desktop-app
phase: build
agent: desktop
skills: [stack-slint, stack-rust]
model: opus
---

# Desktop Application — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                             |
| ---- | ------------------------------------------------------------------- |
| 1    | **Guides in code/docs/** → DESKTOP.md (surface boundary, licensing) |
| 2    | **Guides in code/docs/** → DESKTOP.md (UI and state)                |
| 3    | **External — Native (rust-only)** → Slint                           |
| 4    | **Guides in code/docs/** → API-DESIGN.md, SECURITY.md               |
| 5    | **Guides in code/docs/** → ACCESSIBILITY.md, DESKTOP.md (a11y)      |
| 6    | **Guides in code/docs/** → DESKTOP.md (licensing), TESTING.md       |

---

## Step 1 — Grill the screen

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%> one question at a time,
against the wireframe rather than a blank page. Resolve:

- The **window structure** — panels, navigation, what is modal and what is not
- **Every state**: loading, empty, error, offline. A desktop app is offline more often than a web
  page, and "what does this look like with no connection?" is not an edge case here
- Which values are `in` properties set from Rust, and which are static markup
- **Keyboard and screen-reader behaviour** — tab order, shortcuts, what each control announces
- What the app caches locally, and whether any of it is sensitive

No markup until <%DEVELOPER_NAME%> confirms (`.claude/CLAUDE.md` §10).

## Step 2 — Write the markup

Edit `ui/*.slint`. Declare `in` properties and `callback`s rather than hardcoding display strings:

```slint
in property <string> status: "Ready";
callback refresh();
```

**Leave the `AboutSlint` widget in place.** It is the disclosure Slint's Royalty-free licence
requires in exchange for free commercial use — see `code/docs/desktop/LICENSING.md`. If you
restructure the UI, confirm a user can still reach it.

Set `accessible-role` and `accessible-label` on anything interactive that is not self-describing.

## Step 3 — Wire the state in Rust

In `src/`, connect callbacks and set properties. Two rules that are easy to get wrong:

```rust
// Weak handle: a strong clone captured in a closure the window owns is a reference cycle.
let handle = window.as_weak();
window.on_refresh(move || {
    if let Some(window) = handle.upgrade() {
        window.set_status(slint::SharedString::from("Refreshed"));
    }
});
```

- `upgrade()` returning `None` is the normal already-closed case — handle it, never unwrap it.
- The generated-code `#[allow]` stays scoped to `mod ui`. Do not move it to crate root to make a
  build pass; that disarms the lints for your own code.

Iterate with:

```bash
bash code/src/scripts/desktop/run.sh
```

## Step 4 — Talk to the API, and hold nothing secret in the clear

The app consumes the Django Ninja API at `/api/` exactly as a third-party client would. It holds
**no business logic** — a rule reimplemented here is a second source of truth that will drift.

Blocking work never runs on the UI thread:

```rust
std::thread::spawn(move || {
    let result = fetch_from_api();
    let _ = slint::invoke_from_event_loop(move || { /* ...update... */ });
});
```

Credentials and tokens go to the **platform secure store**, never a plaintext file. The user
controls the machine; treat it as a hostile environment. Nothing sensitive reaches a log.

## Step 5 — Accessibility pass

Keep AccessKit. Then check by hand, because there is no `axe-core` equivalent:

- Every control reachable and operable by keyboard alone; visible focus
- Each control announces a meaningful name and role under a screen reader (Orca on Linux,
  Narrator on Windows, VoiceOver on macOS)
- No information carried by colour alone; text remains legible at OS scaling

Report what you checked and with which screen reader. **Never write "accessibility scanned".**

## Step 6 — Verify and hand off

```bash
bash code/src/scripts/rust/lint.sh
bash code/src/scripts/rust/test.sh
bash code/src/scripts/rust/audit.sh
bash code/src/scripts/desktop/package.sh
```

`package.sh` fails if the `AboutSlint` disclosure is missing. If it does, **restore the widget** —
never edit the check. That is a licence breach, not a lint failure.

Work through `CHECKLIST.md`. Hand off to
`project-management/workflows/21-implementation-documentation/` for the implementation record, the
`CONTEXT.md` closeout and the code-review-graph refresh — do not write those here.
