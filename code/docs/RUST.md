---
type: guide
skills: [stack-rust]
model: opus
---

# Rust Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

**Applies to:** `code/src/rust/` **Reference implementation:**
`code/src/rust/crates/nativecore/`
**Claude Model:** opus — PyO3 boundary, memory hygiene, supply-chain policy

The native tier of <%PROJECT_NAME%>: a Cargo workspace whose flagship member is a **PyO3**
extension module Django imports directly. Covers when Rust is warranted, how the FFI boundary is
kept safe, how secret material is handled, and the supply-chain gate every dependency passes.

> **Rust-only.** This guide and the tree it describes exist only in a project generated with
> `INCLUDE_RUST`. On a project without it, `code/src/rust/` is absent and nothing here applies.

## Sub-documents

| Document                                           | Covers                                                                                                                                          |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| [`rust/PYO3-BOUNDARY.md`](rust/PYO3-BOUNDARY.md)   | The never-panic rule, thin-boundary shape, error mapping, GIL and long operations, type conversion costs, the two test suites                   |
| [`rust/MEMORY-HYGIENE.md`](rust/MEMORY-HYGIENE.md) | Why Python cannot erase a secret, zeroize-on-drop, never rendering secrets, the honest limits (copies, swap, `mlock`), constant-time comparison |
| [`rust/SUPPLY-CHAIN.md`](rust/SUPPLY-CHAIN.md)     | `deny.toml` policy, why a crate is more dangerous than a Python package, adding a dependency, toolchain pinning, advisory suppression           |

## The gate: does this need to be Rust?

Answer this before writing a line. Rust earns its place on exactly two grounds:

| Ground                              | Example                                                              |
| ----------------------------------- | -------------------------------------------------------------------- |
| **A guarantee Python cannot make**  | Constant-time comparison; wiping key material on drop                |
| **Work Python is genuinely bad at** | Hot-path parsing, bulk hashing — with a measurement behind the claim |

Everything else stays in Python. Two costs make this a real gate rather than a formality:

- **Supply chain.** crates.io has no review process, and the extension shares its address space
  with Django. There is no sandbox between a malicious crate and the database credentials.
- **Build friction.** `rustup` becomes a prerequisite for `uv sync` and the backend image gains a
  Rust stage. Every contributor pays that, for every crate.

A rewrite of working Python is a cost with no named benefit. If neither ground holds, the answer
is no.

## Authoring is not consuming

The `INCLUDE_RUST` flag gates **authoring**. A project that merely depends on a prebuilt PyO3
wheel installs it like any other dependency and needs no toolchain at all — such a project answers
`false`.

That asymmetry is why the flag defaults to `false`, and why a shared native primitive is better
published once as a wheel than compiled in every project that uses it.

## The workspace

```text
code/src/rust/
├── Cargo.toml            ← workspace; shared pins in [workspace.dependencies]
├── rust-toolchain.toml   ← the pinned compiler — rustup reads it automatically
├── deny.toml             ← supply-chain policy
└── crates/nativecore/    ← the PyO3 extension module
```

`nativecore` is a **house constant**, not a token: like `apps.marketing` and `apps.design_tokens`,
the name is identical in every generated project so `import nativecore` means the same thing
across the estate.

**The build backend lives in the crate, not the root**, because the root `pyproject.toml` sets
`[tool.uv] package = false` — a virtual project that declares dependencies and is never itself
built. The crate is a real distribution with `[build-system] build-backend = "maturin"`, pulled in
through `[tool.uv.sources]` as a path dependency.

## Everything runs through the scripts

Never invoke `cargo`, `rustc`, `maturin`, `clippy` or `cargo-deny` directly:

| Task              | Script                                   |
| ----------------- | ---------------------------------------- |
| Build / install   | `code/src/scripts/rust/build.sh`         |
| Fast type-check   | `code/src/scripts/rust/build.sh --check` |
| Test (Rust side)  | `code/src/scripts/rust/test.sh`          |
| Lint + format     | `code/src/scripts/rust/lint.sh`          |
| Supply-chain gate | `code/src/scripts/rust/audit.sh`         |

These run on the **host**, not in Docker — the second such exception after the mobile scripts. The
toolchain pin is what keeps a host run and the image's build stage compiling identically.
Rationale: `code/src/scripts/rust/CONTEXT.md`.

## The three rules, in one place

Each is developed in a sub-document; none of them is optional.

1. **Never panic across the FFI boundary.** `unwrap`, `expect`, `panic!` and slice indexing are
   denied per crate. Return `PyResult` and let PyO3 raise. `panic = "abort"` is never set for a
   profile the extension is built under — it kills the worker instead of raising.
2. **Secret material is wrapped, never bare.** It zeroizes on drop, and never renders itself:
   `__repr__` shows a length. Be honest about what that does not cover — copies Python already
   made, and pages the OS may have swapped.
3. **Every dependency is a supply-chain decision.** `audit.sh` passes before merge. Copyleft is
   denied by `deny.toml`; changing the allow-list is an ADR, not a config tweak.

## `unsafe` is denied, not forbidden

Each crate sets `unsafe_code = "deny"` under `[lints.rust]`. PyO3 and FFI legitimately need
`unsafe` sometimes, so the rule is not a ban — it forces an explicit `#[allow(unsafe_code)]` with
a `SAFETY:` comment stating the invariant being upheld. That comment is what review reads. An
`unsafe` block with no `SAFETY:` comment is a review failure, not a style nit.

## Two test suites, both required

`test.sh` runs the Rust tests. The tests that cross the PyO3 boundary are **pytest** tests, run
through `code/src/scripts/tests/`.

Both are required, because a crate can be entirely correct in Rust and still expose a broken
boundary — a wrong signature, a panic that should have been a `PyResult`, a `__repr__` that leaks
a secret. The Rust suite cannot see any of those. Coverage floors (75% lines and branches, 90%
auth-adjacent) apply to the **Python-side** tests; Rust coverage is not separately gated at
baseline.

## Cross-references

- `code/docs/encryption/RUST-CRYPTO.md` — how native crypto relates to the Fernet pipeline
- `code/docs/SECURITY.md` — the OWASP controls a crypto crate is audited against
- `code/src/rust/CLAUDE.md` — the operating rules for the tree
- `code/workflows/12-rust-extension/` — the procedure for adding to it
- `.claude/skills/stack-rust/SKILL.md` — the idioms condensed for an agent

_Part of the `code/docs/` documentation family._
