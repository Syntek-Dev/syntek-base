@./CONTEXT.md

# CLAUDE.md — crates/nativecore/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what ships and why the lint policy is the doctrine — imported above) → this file →
`code/docs/RUST.md`.

## Purpose (one line)

The PyO3 extension module loaded into the Django process — native primitives that exist only
where Python cannot make the guarantee.

## How to work here

- **Routing:** `stack-rust` skill (Opus). **The gate question comes first**: if Python can
  express the guarantee, the work does not belong here, and speed alone is not the argument.
- **Model:** Opus.
- **Concrete steps:** answer the gate question → add the primitive with its unit tests in the
  same file → build, test, lint and audit through `code/src/scripts/rust/*.sh` → record the
  new surface in `CONTEXT.md`.
- **Definition of done:** no panicking path reachable from Python; secrets zeroized on drop;
  `cargo-deny` clean; the `CONTEXT.md` table names the new item and why Python was not enough.

## Guardrails

- **Never panic across the boundary.** Return `PyResult` and let PyO3 raise. `unwrap`,
  `expect`, `panic!`, `todo!`, `unimplemented!`, `unreachable!` and slice indexing are denied
  in `Cargo.toml`; an allow needs a written proof in a comment beside it.
- **`unsafe` is not banned but is denied by default** — an explicit `#[allow(unsafe_code)]`
  with a `SAFETY` comment is the only way in, so every block is reviewable.
- **Secret material never reaches the allocator unzeroed**, and a type holding it never
  renders its contents in `repr()` or `str()` — a secret that logs itself is the commonest
  way key material escapes.
- **This crate is never published.** `publish = false` is load-bearing: it is a first-party
  crypto crate consumed as a path dependency.
- **Never invoke `cargo` directly** — use `code/src/scripts/rust/*.sh`.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** `src/lib.rs`, `Cargo.toml`, `pyproject.toml`.
- **Generated (never hand-edit):** the built wheel and `target/`.
- The crate and module name is the house constant `nativecore`; functions `snake_case`,
  types `PascalCase`, Python-facing names set explicitly via `#[pyclass(name = ...)]`.
