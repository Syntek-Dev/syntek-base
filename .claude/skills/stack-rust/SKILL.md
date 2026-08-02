---
name: stack-rust
description: Rust stack reference for <%PROJECT_NAME%> — the Cargo workspace at code/src/rust/, PyO3 extension modules built with maturin, the never-panic FFI boundary, secret-wiping memory hygiene, and the cargo-deny supply-chain gate. Load when writing or reviewing anything under code/src/rust/, when deciding whether work belongs in Rust at all, or when a backend, security, or test agent needs Rust conventions without owning them. RUST-ONLY — present only in a project generated with the Rust surface.
---

Reference for the **Rust surface** of <%PROJECT_NAME%> — `code/src/rust/`. The `rust` agent loads
this for stack idioms; `backend`, `security`, `test-writer` and `code-reviewer` cite it at the FFI
boundary without owning Rust conventions themselves. Aligns with
`code/workflows/12-rust-extension/` and `code/src/rust/CLAUDE.md`.

**This skill is rust-only.** A project generated without the Rust surface has neither this skill
nor the tree it describes.

British English throughout (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## The gate: does this need to be Rust?

Ask before anything else. Rust earns its place on exactly two grounds:

| Ground                              | Example                                                              |
| ----------------------------------- | -------------------------------------------------------------------- |
| **A guarantee Python cannot make**  | Constant-time comparison; wiping key material on drop                |
| **Work Python is genuinely bad at** | Hot-path parsing, bulk hashing — with a measurement behind the claim |

Everything else stays in Python. A Rust rewrite of working Python is a cost with no named
benefit, and every crate widens a supply-chain surface that **shares its address space with
Django** — there is no sandbox between a malicious dependency and your database credentials.

**Authoring is not consuming.** A project that merely depends on a prebuilt PyO3 wheel installs it
like any other dependency and needs no toolchain. This surface exists because _this repository
compiles Rust_.

---

## Architecture

| Layer        | Technology                                                            |
| ------------ | --------------------------------------------------------------------- |
| Language     | **Rust**, edition 2024, toolchain pinned by `rust-toolchain.toml`     |
| Python FFI   | **PyO3** with `abi3-py314` — one wheel covers every CPython from 3.14 |
| Build        | **maturin** — the crate carries its own `[build-system]`              |
| Supply chain | **cargo-deny** against `deny.toml` — advisories, licences, bans       |
| Lints        | clippy at `-D warnings`; panic paths denied per crate                 |

**`nativecore` is a house constant**, not a token — like `apps.marketing` and `apps.seo`, the name
is identical in every generated project, so `import nativecore` means the same thing estate-wide.

**Why the build backend sits in the crate:** the root `pyproject.toml` is `package = false`, a
virtual project that is never built into a wheel. The crate is a real distribution and is pulled
in via `[tool.uv.sources]`. Consequence, stated plainly: **`rustup` becomes a prerequisite for
`uv sync`**, and the backend image gains a Rust stage.

---

## Everything runs through the scripts

Never invoke `cargo`, `rustc`, `maturin`, `clippy` or `cargo-deny` directly:

| Task              | Script                                   |
| ----------------- | ---------------------------------------- |
| Build / install   | `code/src/scripts/rust/build.sh`         |
| Fast type-check   | `code/src/scripts/rust/build.sh --check` |
| Test (Rust side)  | `code/src/scripts/rust/test.sh`          |
| Lint + format     | `code/src/scripts/rust/lint.sh`          |
| Supply-chain gate | `code/src/scripts/rust/audit.sh`         |

**They run on the host, not in Docker** — the second such exception after `mobile/`. The
toolchain pin is what makes a host run and the image's build stage agree.

---

## The boundary: never panic into Python

This is the rule everything else hangs off. A panic crossing FFI is a Python exception at best and
a dead Gunicorn worker at worst, so the lint table denies the ways it happens:

```toml
[lints.clippy]
unwrap_used = "deny"
expect_used = "deny"
panic = "deny"
indexing_slicing = "deny"
```

Keep the boundary **thin** — validate, delegate, map:

```rust
#[pyfunction]
fn parse_token(raw: &str) -> PyResult<String> {
    // Logic lives in a plain Rust function, testable without an interpreter.
    decode(raw).map_err(|e| PyValueError::new_err(e.to_string()))
}
```

`panic = "abort"` is **never** set for a profile the extension is built under.

---

## Memory hygiene: the reason this exists

Python `bytes` are immutable and garbage-collected — once key material is in one you cannot erase
it, and copies linger in the allocator until chance overwrites them. Rust can guarantee otherwise:

```rust
impl Drop for SecretBytes {
    fn drop(&mut self) {
        self.inner.zeroize();
    }
}
```

Three rules follow:

- **Never render a secret.** `__repr__` and `__str__` show a length, never contents — a secret
  that renders itself into a log line is the commonest way key material escapes.
- **Expose as late as possible.** The moment bytes cross back into Python, the guarantee stops
  applying to that copy. Name the method conspicuously so review catches it.
- **State the limit honestly.** Zeroizing wipes _this_ buffer. It does not retract copies Python
  already made, and it does not stop the OS paging the page to swap — that needs `mlock`, a
  per-deployment decision. Never imply more than it delivers.

Detail: `code/docs/rust/MEMORY-HYGIENE.md`.

---

## Testing: two suites, both required

`test.sh` runs the **Rust** tests. The tests that cross the PyO3 boundary are **pytest** tests and
run through `code/src/scripts/tests/`.

Both are required, because a crate can be entirely correct in Rust and still expose a broken
boundary — a wrong signature, a panic that should have been a `PyResult`, a `__repr__` that leaks.
The Rust suite cannot see any of those; only a test that imports the module can.

Coverage floors are the project's usual numbers, applied to the **Python-side** tests: 75% lines
and branches, 90% auth-adjacent. Rust coverage is not separately gated at baseline — say so rather
than implying a combined figure exists.

---

## Supply chain

`audit.sh` runs cargo-deny against `deny.toml`: advisories `deny`, permissive licences only,
`wildcards = "deny"`, unknown registries and git sources denied.

Suppress an advisory **only** in `deny.toml`, with a dated comment saying why it does not apply
here. Never skip the gate to unblock a merge. A copyleft dependency propagates to anything linking
the crate, so changing the allow-list is an ADR, never a config tweak.

---

## Guardrails recap

- Never panic across FFI; `unsafe_code = "deny"` per crate, with `SAFETY:` comments on any allow.
- Secrets zeroize on drop and never render.
- Never commit `target/` or a built `.so`/`.pyd`/`.dylib` — binaries break Copier generation.
- The toolchain pin and `rust-version` are a matched set; a bump is a template release.
- Source files ≤ 750 lines (800 grace).

## Governing procedures (route here — do not restate at length)

- `code/workflows/12-rust-extension/` — the procedure for this surface
- `code/workflows/02-tdd-cycle/` · `08-security-hardening/` — both suites, then the audit
- `project-management/workflows/16-backend-code/` — the build phase this is entered from
- `how-to/workflows/07-dependency-updates/` — the cadence a crate or toolchain bump follows

## Cross-references

- `code/docs/RUST.md` and its `rust/` sub-docs — the guide behind this skill
- `code/docs/encryption/RUST-CRYPTO.md` — how native crypto relates to the Fernet pipeline
- `code/src/rust/CLAUDE.md` — the operating rules for the tree itself
