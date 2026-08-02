# code/src/rust

The **Rust workspace** for <%PROJECT_NAME%>. Present only when the project was generated with
the Rust surface (`INCLUDE_RUST`); a project without it has no such directory, and a handful of
`_exclude` entries remove the tree, its scripts, its guides, its workflow, and its agent+skill
pair together.

**This tree is for authoring, not consuming.** A project that merely depends on a prebuilt PyO3
wheel installs it like any other dependency and needs no Rust toolchain at all. This directory
exists because **this repository compiles Rust itself**.

## Directory Tree

```text
code/src/rust/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── Cargo.toml              ← workspace root; shared pins in [workspace.dependencies]
├── rust-toolchain.toml     ← the pinned compiler — rustup reads it automatically
├── deny.toml               ← cargo-deny supply-chain policy (advisories, licences, bans)
├── clippy.toml             ← doc_markdown ident allow-list (PyO3, CPython, …)
├── .gitignore              ← target/ and build artefacts — never committed
└── crates/
    ├── nativecore/         ← the first-party PyO3 extension module
    └── desktop/            ← DESKTOP-ONLY — the native Slint app (absent unless opted in)
        ├── Cargo.toml      ← lint table: unsafe/unwrap/expect/panic/indexing denied
        ├── pyproject.toml  ← maturin build backend — this crate IS a distribution
        └── src/lib.rs      ← baseline: constant_time_eq + SecretBytes
```

## `nativecore` is a house constant

The crate and its Python module are called `nativecore` in **every** generated project — like
`apps.marketing`, `apps.seo` and `apps.design_tokens`, the name is deliberately not tokenised, so
`import nativecore` means the same thing across the estate and a guide can name it literally.

## Why the build backend lives in the crate, not the root

The root `pyproject.toml` sets `[tool.uv] package = false` — it is a **virtual project** that
declares dependencies and is never itself built into a wheel. This crate is the opposite: a real
distribution with a `[build-system]` requiring maturin. The root pulls it in through
`[tool.uv.sources]` as a path dependency.

The consequence is worth stating plainly: **on a project with `INCLUDE_RUST`, `rustup` becomes a
prerequisite for `uv sync`,** and the backend image gains a Rust build stage. That is the price of
authoring a native module, and it is why the flag defaults to false.

## What belongs here

Rust is the general-purpose native tier: PyO3 extension modules, standalone binaries, CLI tools
and services. The two things it earns its keep on:

- **Guarantees Python cannot make.** Constant-time comparison; wiping key material on drop.
  Python `bytes` are immutable and GC-managed, so you cannot erase a secret once it is in one.
- **Work Python is genuinely bad at.** Hot-path parsing, bulk hashing, heavy serialisation.

What does **not** belong: anything the service layer already does adequately. A Rust rewrite of
working Python is a cost with no named benefit, and every crate added here widens a supply-chain
surface that shares its address space with Django.

## The desktop crate is a member, not a second workspace

When `INCLUDE_DESKTOP` is on, the Slint application lives at `crates/desktop/`. `members =
["crates/*"]` is a glob, so the workspace adapts with no edit and there stays exactly one
`rust-toolchain.toml`, one `deny.toml` and one `clippy.toml`. A second workspace would mean two of
each, drifting apart.

`slint` is pinned in that crate rather than `[workspace.dependencies]` — one member uses it. The
shared `deny.toml` does carry Slint's licence exceptions and two AccessKit advisory notes
unconditionally; on a project without the desktop surface they match nothing, which cargo-deny
reports as an informational note rather than an error.

## Cross-references

- `code/docs/RUST.md` — the guide, and its `rust/` sub-docs (boundary, memory, supply chain)
- `code/docs/DESKTOP.md` — **desktop-only** — the Slint app and its licence obligation
- `code/src/scripts/rust/CONTEXT.md` — the scripts that drive this tree
- `code/workflows/12-rust-extension/CONTEXT.md` — the procedure for adding to it
- `code/docs/encryption/RUST-CRYPTO.md` — the rust-only branch of the encryption guide

**Last Updated**: <%DATE%>
