@./CONTEXT.md

# CLAUDE.md — workflows/12-rust-extension/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-use, key concepts, cross-references — imported above) → this file.

## Purpose (one line)

The procedure for building and changing the Rust workspace at `code/src/rust/` — from the gate
question through dependencies, the plain-Rust logic, the thin PyO3 boundary, both test suites, and
the service-layer wiring.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Crates →
  `stack-rust` (Opus); the service-layer call sites → `backend`; the threat model and
  crypto audit → `security`; tests → `test-writer`. Read `CONTEXT.md` first. **Entered from
  `project-management/workflows/19-backend-code/`**, never directly from a design gate. Hard
  gates before Step 1: `code/docs/RUST.md`, `code/docs/rust/PYO3-BOUNDARY.md` and
  `code/docs/rust/SUPPLY-CHAIN.md`.
- **Grill first:** Step 1 is a grilling pass (`.claude/skills/grill-with-docs`), and its opening
  question is the workflow's own gate — does this need to be Rust at all? Never skip it; a Rust
  rewrite of working Python is a cost with no named benefit.
- **Model:** Opus throughout — design, code, tests, audit, and mechanical touches to these files.
- **Concrete steps:** grill → justify dependencies → plain Rust → thin boundary → both suites →
  service-layer wiring → verify. Every Rust operation goes through
  `code/src/scripts/rust/*.sh` — **never raw `cargo`, `rustc`, `maturin`, `clippy` or
  `cargo-deny`.**
- **Definition of done:** the `CHECKLIST.md` is satisfied end to end; lint, both suites, audit and
  the release build exit `0`; coverage floors met on the Python side; `08-security-hardening` run
  if crypto is involved; touched `CONTEXT.md` files and the code-review-graph refreshed.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (`.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **The gate is the workflow's whole point.** "It would probably be faster in Rust" fails it. Ask
  for the measurement or the named guarantee, and hand back to `backend` when neither exists.
- **Never panic across the FFI boundary.** The lint tables deny `unwrap`/`expect`/`panic!`/
  indexing; do not weaken them with a crate-root `#[allow]` to make a build pass.
- **`unsafe` needs a `SAFETY:` comment**, every time. A bare `#[allow(unsafe_code)]` is a review
  failure.
- **Both test suites, always.** A green `cargo test` proves nothing about the boundary — it never
  imports the module.
- **`audit.sh` is never skipped to unblock a merge.** A crate shares its address space with
  Django; there is no sandbox between it and the database credentials.
- **Fernet stays canonical for field encryption.** Native crypto is a branch for what Fernet
  structurally cannot do. Re-encrypting stored data is an ADR and a story, never an incidental
  improvement.
- **Never commit `target/`** or a built `.so`/`.pyd`/`.dylib` — binaries break Copier generation
  for every downstream project.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Produced by following it:** crates under `code/src/rust/crates/`, their Rust tests, the
  Python-side boundary tests, and the `services.py` call sites. The implementation record is
  written by `project-management/workflows/22-implementation-documentation/`, not here.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; crate directories
  `snake_case/` (a Python module name cannot contain a hyphen).
