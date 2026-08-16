@./CONTEXT.md

# CLAUDE.md — code/src/rust/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/CONTEXT.md` → this folder's
`CONTEXT.md` (tree, the house-constant name, the build-backend rationale — imported above) →
this file.

## Purpose (one line)

The Rust workspace — PyO3 extension modules, binaries and CLI tools — where this project
compiles native code that Python either cannot express safely or is too slow to run.

## How to work here

- **Routing:** the `stack-rust` skill owns this tree. Enter through
  `code/workflows/12-rust-extension/`, which is itself entered from
  `project-management/workflows/18-backend-code/` — never directly from a design gate.
- **Grill first:** the workflow's Step 1 is a grilling pass, and its opening question is the
  gate — _does this need to be Rust at all?_ A rewrite of working Python is a cost with no named
  benefit (`.claude/CLAUDE.md` Section 10).
- **Model:** Opus for design, code, tests and mechanical touches alike.
- **Every operation runs through `code/src/scripts/rust/*.sh`** — never raw `cargo`, `rustc`,
  `maturin`, `clippy` or `cargo-deny`.
- **Concrete steps:** read `code/docs/RUST.md` and `code/docs/rust/PYO3-BOUNDARY.md` → write the
  crate with its Rust unit tests → write the **pytest** tests that cross the boundary → `lint.sh`
  → `test.sh` → `audit.sh` → `build.sh --release` → update this `CONTEXT.md` if the tree changed.
- **Definition of done:** clippy clean at `-D warnings`; `cargo fmt --check` clean; Rust tests and
  the Python-side boundary tests both pass; `cargo deny` clean; every `unsafe` block carries a
  `SAFETY:` comment; British English in all prose.

## Guardrails

- **Never panic across the FFI boundary.** `unwrap`, `expect`, `panic!` and slice indexing are
  denied at the lint level in every crate's `[lints.clippy]` table. Return `PyResult` and let PyO3
  raise a Python exception. A panic in a Gunicorn worker is a 500 at best.
- **`panic = "abort"` is never set** in a profile that the extension module is built under — it
  would take the whole worker process down instead of raising.
- **`unsafe_code = "deny"`** per crate. PyO3 and FFI sometimes need it, so it is denied rather
  than forbidden: an author must write an explicit `#[allow(unsafe_code)]` with a `SAFETY:`
  comment that survives review.
- **Secret material is wrapped, never bare.** Anything holding key or plaintext bytes zeroizes on
  drop. Exposing it back to Python ends the guarantee for that copy — call the exposing method as
  late as possible (`code/docs/rust/MEMORY-HYGIENE.md`).
- **Every dependency is a supply-chain decision.** crates.io has no review process and this code
  shares an address space with Django. Add a crate only through the workflow, and `audit.sh` must
  pass. Copyleft licences are denied by `deny.toml` — a licence change here is an ADR.
- **The channel and the MSRV are not a matched set** — they answer different questions.
  `rust-toolchain.toml`'s channel is the compiler everyone builds with, and bumping it is a
  template release rather than a routine dependency bump. `Cargo.toml`'s `rust-version` (1.92) is
  what **`resolver = "3"` resolves against** — MSRV-aware, so the floor decides which dependency
  versions the graph may use whatever compiler is pinned. Move it when the graph needs it, naming
  the crate that forced it (`code/docs/rust/SUPPLY-CHAIN.md` → _Toolchain pinning_).
- **Never commit `target/`** or a built `.so`/`.pyd`/`.dylib` — they are binaries, and this
  repository is a Copier template that cannot render binaries.
- Source files ≤ 750 lines (800 grace), as everywhere in `code/src/`.

## Output & naming

- **Hand-written:** every `Cargo.toml`, `pyproject.toml`, `deny.toml`, `rust-toolchain.toml` and
  `src/**/*.rs`.
- **Generated / gitignored:** `target/`, and the compiled extension maturin installs into the
  virtual environment.
- Crate directories `snake_case/` under `crates/` (Cargo's convention, and a Python module name
  cannot contain a hyphen); Rust modules `snake_case.rs`; documentation
  `SCREAMING-SNAKE-CASE.md`.
