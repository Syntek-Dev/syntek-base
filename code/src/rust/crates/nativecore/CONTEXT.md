# crates/nativecore — The PyO3 Extension Module

**Rust-only.** The first-party native crate Django imports as `import nativecore`. It is the
one surface with no runtime of its own: the compiled library is loaded **into** the web
process and shares its address space, which is why its supply chain and its lint policy are
gated harder than anything on the Python side.

`nativecore` is a **house constant, not a token** — the name is identical in every generated
project so the import path is stable across the estate.

**Last Updated**: <%DATE%>

## Directory Tree

```text
nativecore/
├── Cargo.toml       ← crate manifest, and the lint policy that makes the rules enforceable
├── pyproject.toml   ← the maturin build definition that turns the crate into a wheel
├── src/             ← the crate source — one module, Cargo's own layout
│   └── lib.rs       ← the module: constant_time_eq + SecretBytes, and the unit tests
├── CONTEXT.md       ← this file
└── CLAUDE.md        ← operating rules
```

## What ships at baseline, and why only this

Two primitives, chosen because each demonstrates one of the two boundary rules and neither
can be written as well in Python:

| Item               | Exists because                                                                      |
| ------------------ | ----------------------------------------------------------------------------------- |
| `constant_time_eq` | Python's `bytes` `==` short-circuits, leaking the matching prefix length to a timer |
| `SecretBytes`      | Python `bytes` are immutable and collected — key material cannot be wiped in place  |

Nothing else lives here yet, deliberately. The gate question comes before the code: work
belongs in Rust when Python cannot express the guarantee, not when Rust would be faster.

## The lint policy is the doctrine

`Cargo.toml` denies `unwrap`, `expect`, `panic!`, `todo!`, `unimplemented!`, `unreachable!`
and slice indexing, and denies `unsafe_code` short of an explicit justified allow. That is
not style: a panic crossing the FFI boundary is a Python exception at best and a dead
Gunicorn worker at worst, so the compiler enforces what a reviewer would otherwise have to
catch.

## Cross-references

- `code/src/rust/CONTEXT.md` — the Rust surface: workspace layout, build rationale
- `code/docs/RUST.md` — the gate question, the PyO3 boundary, and the supply-chain policy
