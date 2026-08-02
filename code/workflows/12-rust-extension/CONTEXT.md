# Workflow: Rust Extension (PyO3)

## Directory Tree

```text
code/workflows/12-rust-extension/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding or changing anything in the **Rust workspace at
`code/src/rust/`** — the first crate, a new `#[pyfunction]`, a change to an existing signature, or
a new dependency.

Use it only when the work meets one of the two grounds in `code/docs/RUST.md`: **a guarantee
Python cannot make** (constant-time comparison, wiping key material), or **work Python is
genuinely bad at** (a hot path, with a measurement behind the claim). If neither holds, the work
belongs in the service layer — use `project-management/workflows/16-backend-code/` and the
`backend` agent.

**Rust-only.** This workflow exists only in a project generated with `INCLUDE_RUST`.

## Prerequisites

- [ ] `code/docs/RUST.md` and its `rust/` sub-docs have been read
- [ ] The gate question is answered — and the answer is not "it would be faster in Rust, probably"
- [ ] The service layer the extension supports already exists — a crate is a primitive, not a
      place for business logic
- [ ] Entered from `project-management/workflows/16-backend-code/`, never directly from a design
      gate
- [ ] `rustup` installed; the toolchain pin in `code/src/rust/rust-toolchain.toml` resolves

## Key concepts

- **Authoring, not consuming.** This surface exists because the repository compiles Rust. Merely
  depending on a prebuilt wheel needs none of it.
- **The boundary is thin.** A `#[pyfunction]` validates, delegates to plain Rust, and maps the
  error. Logic in plain functions is testable without an interpreter.
- **Never panic across FFI.** `unwrap`, `expect`, `panic!` and slice indexing are denied per
  crate. A panic in a Gunicorn worker is a 500 at best; under `panic = "abort"` it kills the
  worker.
- **`unsafe` is denied, not forbidden.** An explicit `#[allow(unsafe_code)]` with a `SAFETY:`
  comment is required, and that comment is what review reads.
- **Two test suites, both required.** `cargo test` for crate logic; **pytest** for the boundary.
  A crate can be entirely correct in Rust and still expose a broken boundary.
- **Every dependency is a supply-chain decision.** The extension shares its address space with
  Django — there is no sandbox between a crate and the database credentials.
- **Fernet stays canonical.** Native crypto is a branch for what Fernet structurally cannot do,
  never a replacement for the field-encryption pipeline.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/RUST.md` — the gate question, the workspace, the three rules
- `code/docs/rust/PYO3-BOUNDARY.md` — never-panic, error mapping, the GIL, `abi3`
- `code/docs/rust/SUPPLY-CHAIN.md` — the dependency policy `audit.sh` enforces

### Soft references — consult during execution

- `code/docs/rust/MEMORY-HYGIENE.md` — zeroize-on-drop, constant-time comparison, honest limits
- `code/docs/encryption/RUST-CRYPTO.md` — the boundary with the Fernet pipeline
- `code/docs/TESTING.md` — the coverage floors the Python-side tests count towards
- `code/src/scripts/rust/CONTEXT.md` — the scripts every operation runs through
- `code/workflows/02-tdd-cycle/` — the Red → Green → Refactor cycle both suites are built through
- `code/workflows/08-security-hardening/` — the audit any crypto crate must pass
- `project-management/workflows/16-backend-code/` — **this workflow is entered from there**
- `project-management/workflows/19-implementation-documentation/` — writes the implementation
  record and refreshes the graph; do not write it here
