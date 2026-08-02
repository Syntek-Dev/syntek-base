@./CONTEXT.md

# CLAUDE.md — scripts/rust/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/scripts/CONTEXT.md` → this
folder's `CONTEXT.md` (script table, host-execution rationale, the two-suite rule — imported
above) → this file.

## Purpose (one line)

The sanctioned entry point for every Rust operation — build, test, lint, audit — each running on
the host against the toolchain pinned in `code/src/rust/rust-toolchain.toml`.

## How to work here

- **Routing:** these scripts are the routing target for anything touching `code/src/rust/`.
  **Never invoke `cargo`, `rustc`, `maturin`, `clippy` or `cargo-deny` directly.** The `rust`
  agent and the `stack-rust` skill target them.
- **Model:** Opus to author or change a script and to run one.
- **Concrete steps:** `lint.sh` → `test.sh` → `audit.sh` → `build.sh --release` before a PR.
  `build.sh --check` is the fast inner loop while writing.
- **Definition of done:** the script is idempotent where sensible, honours the shared
  `--help`/`--fix`/`--path` conventions, exits `0`/`1`/`2` per the house contract, and
  `CONTEXT.md` lists it.

## Guardrails

- **Host execution is deliberate — do not "fix" it into Docker.** The pin in
  `rust-toolchain.toml` is what makes host and image agree; containerising cargo buys isolation
  that the loaded `.so` immediately gives back.
- **`_common.sh` is sourced, never executed**, and it hard-fails when `code/src/rust/` is absent.
  That failure is intended: these scripts should not exist on a project without the Rust surface,
  so reaching them there means something has gone wrong.
- **`audit.sh` is not optional and is never skipped to unblock a merge.** A crate shares its
  address space with Django — there is no sandbox between a malicious dependency and the database
  credentials. Suppress an advisory only in `deny.toml`, with a dated comment saying why it does
  not apply.
- **Clippy runs at `-D warnings`** so a local run and CI agree. Never soften it with a blanket
  `#[allow]` at crate root; scope an allow to the item and justify it.
- **Aggregates delegate here; they never reimplement.** Wire a new operation into
  `syntax/check.sh` or `tests/all.sh` behind the same directory-existence guard the mobile group
  uses, rather than duplicating logic.
- Shell scripts are exempt from the 750-line source limit but stay focused.

## Output & naming

- **Hand-written:** every `*.sh` here plus this pair.
- **Generated / gitignored:** `code/src/rust/target/` and the compiled extension module — never
  committed.
- Scripts `kebab-case.sh`; the sourced helper is `_common.sh` (underscore prefix, sourced never
  called); documentation `SCREAMING-SNAKE-CASE.md`.
