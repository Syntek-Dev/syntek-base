@./CONTEXT.md

# CLAUDE.md — scripts/desktop/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/scripts/CONTEXT.md` → this
folder's `CONTEXT.md` (script table, host-execution rationale, the attribution gate — imported
above) → this file.

## Purpose (one line)

The two desktop-specific operations — run the app, and build a release binary that carries the
Slint attribution the licence requires.

## How to work here

- **Routing:** these drive `code/src/rust/crates/desktop/`. Lint, test, audit and workspace builds
  belong to `code/src/scripts/rust/` — do not duplicate them here. **Never invoke `cargo` or
  `slint-viewer` directly.**
- **Model:** Opus to author or change a script and to run one.
- **Concrete steps:** `run.sh` while developing → the Rust group's `lint.sh`, `test.sh`,
  `audit.sh` before a PR → `package.sh` last, because it is the release gate.
- **Definition of done:** idempotent where sensible, honours the shared `--help`/`--release`
  conventions, exits `0`/`1`/`2` per the house contract, and `CONTEXT.md` lists it.

## Guardrails

- **Never weaken or remove the `AboutSlint` check in `package.sh`.** It is a licence gate, not a
  lint. If it fires, restore the widget or buy a Commercial licence — never edit the check to pass.
- **Host execution is deliberate.** A desktop app needs a display server; containerising it means
  it cannot open a window.
- **`_common.sh` is sourced, never executed**, and hard-fails when the desktop crate is absent.
  That failure is intended: these scripts should not exist on a project without the surface.
- **Do not add a lint, test or dependency-audit script here.** The crate is a workspace member and
  the Rust group already covers it; a duplicate is a second answer that will drift from the first.
  **`style-check.sh` is not that duplicate** — it reads Slint build configuration for a design
  decision, which no Rust script asks and none should start asking. Do not delete it citing this
  rule, and do not weaken its `[gate: fail]` tier: an app that ships stock Fluent by accident is
  the one thing `code/docs/visual-design/DESKTOP.md` bans. A deliberate platform default carries a
  `style-allow` comment with a reason.
- **Never hardcode a display.** Warn when `DISPLAY`/`WAYLAND_DISPLAY` are unset and let the app
  report the platform error; guessing one produces a worse message.
- Shell scripts are exempt from the 750-line source limit but stay focused.

## Output & naming

- **Hand-written:** every `*.sh` here plus this pair.
- **Generated / gitignored:** `code/src/rust/target/` and the built binary — never committed.
- Scripts `kebab-case.sh`; the sourced helper is `_common.sh`; documentation
  `SCREAMING-SNAKE-CASE.md`.
