# code/docs/rust

Sub-documents of [`code/docs/RUST.md`](../RUST.md), split out because the index would otherwise
exceed the 300-line instructional limit. Present only in a project generated with the Rust
surface (`INCLUDE_RUST`).

## Directory Tree

```text
code/docs/rust/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── PYO3-BOUNDARY.md    ← the FFI seam
├── MEMORY-HYGIENE.md   ← secret material in memory
└── SUPPLY-CHAIN.md     ← the dependency gate
```

## Which document, when

| Document            | Read before                                                                                         |
| ------------------- | --------------------------------------------------------------------------------------------------- |
| `PYO3-BOUNDARY.md`  | Writing or changing any `#[pyfunction]`/`#[pyclass]` — the never-panic rule, error mapping, the GIL |
| `MEMORY-HYGIENE.md` | Handling a key, token, or plaintext in Rust — zeroize-on-drop, constant-time comparison, the limits |
| `SUPPLY-CHAIN.md`   | Adding any crate, or reading an `audit.sh` failure                                                  |

## The three rules these develop

1. Never panic across the FFI boundary — `PYO3-BOUNDARY.md`
2. Secret material is wrapped, never bare — `MEMORY-HYGIENE.md`
3. Every dependency is a supply-chain decision — `SUPPLY-CHAIN.md`

## Cross-references

- `code/docs/RUST.md` — the index these belong to
- `code/src/rust/CONTEXT.md` — the tree they describe
- `code/docs/encryption/RUST-CRYPTO.md` — the rust-only branch of the encryption guide

**Last Updated**: <%DATE%>
