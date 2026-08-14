@./CONTEXT.md

# CLAUDE.md — workflows/13-desktop-app/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-use, key concepts, cross-references — imported above) → this file.

## Purpose (one line)

The procedure for building and changing the native Slint desktop application — from the grilling
pass through markup, state, threading, accessibility and the release build that enforces the
Slint attribution.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Windows and
  markup → `stack-slint` (Opus); native primitives behind them → `stack-rust`; the API the
  app calls → `backend`; tests → `test-writer`. Read `CONTEXT.md` first. **Entered from
  `project-management/workflows/20-frontend-code/`**, never directly from a design gate. Hard
  gates before Step 1: `code/docs/desktop/LICENSING.md` and `code/docs/desktop/UI-AND-STATE.md`.
- **Grill first:** Step 1 is a grilling pass (`.claude/skills/grill-with-docs`) — window
  structure, every state, keyboard and screen-reader behaviour — before any markup is written.
- **Model:** Opus throughout, including mechanical touches to these files.
- **Concrete steps:** grill → markup → state and callbacks → threading → accessibility → verify.
  Every operation goes through `code/src/scripts/desktop/*.sh` and `code/src/scripts/rust/*.sh` —
  **never raw `cargo` or `slint-viewer`.**
- **Definition of done:** the `CHECKLIST.md` is satisfied end to end; lint, tests, audit and
  `package.sh` exit `0`; the About dialog is reachable by eye; screen-reader behaviour checked;
  touched `CONTEXT.md` files and the code-review-graph refreshed.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (`.claude/CLAUDE.md` §2.5).

## Guardrails

- **The `AboutSlint` check is a licence gate, not a lint.** If `package.sh` fails on it, restore
  the widget or buy a Commercial licence — never edit the check to pass, and never describe it in
  these files as advisory.
- **Never panic in hand-written code**, and never move the generated-code `#[allow]` to crate root
  to make a build pass.
- **Never block the UI thread.** Blocking work goes on another thread and returns through
  `slint::invoke_from_event_loop`.
- **No business logic in the app** — it calls the API; the service layer decides.
- **Never move desktop components into a shared package layer.** The Royalty-free tier forbids
  redistributing anything that exposes Slint's APIs, so the duplication across apps is deliberate.
- **Accessibility is never reported as scanned.** There is no `axe-core` equivalent; say what was
  checked, with which screen reader.
- **Never commit `target/`** or a built binary.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Produced by following it:** `ui/*.slint`, `src/*.rs` in the desktop crate, and their tests.
  The implementation record is written by
  `project-management/workflows/21-implementation-documentation/`, not here.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; markup files
  `kebab-case.slint`.
