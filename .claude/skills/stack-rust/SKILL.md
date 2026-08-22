---
name: stack-rust
description: >-
  Build and review the Rust surface of <%PROJECT_NAME%> — PyO3 extension modules, binaries and
  CLI tools in the Cargo workspace at `code/src/rust/`, built with maturin behind a never-panic
  FFI boundary, with secret-wiping memory hygiene and a cargo-deny supply-chain gate. Load when
  native code has to be written or audited — constant-time comparison, secret-wiping key
  handling, a hot path Python is too slow for — when deciding whether work belongs in Rust at
  all, or when a backend, security or test skill needs Rust conventions without owning them.
  Not the Django models, services or endpoints that call it (`backend`), not the threat model
  over it (`security`), and not the desktop app in the same workspace (`stack-slint`).
  RUST-ONLY — present only in a project generated with the Rust surface.
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Build the Rust Surface (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is native code). You own
the native layer and hand back. `backend`, `security`, `test-writer` and `code-reviewer` cite
this at the FFI boundary without owning Rust conventions themselves.

**Rust-only.** A project generated without the Rust surface has neither this skill nor the tree
it describes. If `code/src/rust/` is absent, **say so and hand back** rather than scaffolding it.

The standing conventions are **not** here: they are `code/docs/RUST.md` and its three
sub-documents — `code/docs/rust/PYO3-BOUNDARY.md` (the never-panic rule, the thin boundary,
error mapping, the GIL, the two suites), `code/docs/rust/MEMORY-HYGIENE.md` (why Python cannot
erase a secret, zeroize on drop, the honest limits) and `code/docs/rust/SUPPLY-CHAIN.md`
(`deny.toml`, adding a dependency, advisory suppression). Read the guide first; everything
below sequences it.

**Locale:** British English (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## The gate: does this need to be Rust at all?

Answer this before writing a line, and answer it out loud in the handoff. Rust earns its place on
exactly two grounds:

| Ground                              | Example                                                              |
| ----------------------------------- | -------------------------------------------------------------------- |
| **A guarantee Python cannot make**  | Constant-time comparison; wiping key material on drop                |
| **Work Python is genuinely bad at** | Hot-path parsing, bulk hashing — with a measurement behind the claim |

Everything else stays in Python. A rewrite of working Python is a cost with no named benefit, and
every crate widens a supply-chain surface that **shares its address space with Django** — there is
no sandbox between a malicious dependency and your database credentials. `rustup` also becomes a
prerequisite for `uv sync`, and every contributor pays that. **If neither ground holds, say so and
hand back to `backend`.** Full argument: `code/docs/RUST.md` Section _The gate_.

**Authoring is not consuming.** A project that merely depends on a prebuilt PyO3 wheel installs it
like any other dependency and needs no toolchain. This surface exists because _this repository
compiles Rust_.

## The brief arrives settled

A fork has no conversation behind it and **cannot open a grilling pass**, so the design must
already be made. The brief must carry:

- **The gate answer** — which of the two grounds this crate stands on, and the measurement behind
  it where the ground is performance.
- **The boundary signature** — what crosses into Rust, what comes back, and the Python exception
  each failure maps to.
- **What must be zeroized**, where secret material is in play.

**If the gate answer is missing, return and say so** — a crate written without one is a
supply-chain cost nobody agreed to. Where the caller wants that settled first, the pass is
`grilling`, run inline before this skill is dispatched.

---

## Architecture

| Layer        | Technology                                                            |
| ------------ | --------------------------------------------------------------------- |
| Language     | **Rust**, edition 2024, toolchain pinned by `rust-toolchain.toml`     |
| Python FFI   | **PyO3** with `abi3-py314` — one wheel covers every CPython from 3.14 |
| Build        | **maturin** — the crate carries its own `[build-system]`              |
| Supply chain | **cargo-deny** against `deny.toml` — advisories, licences, bans       |
| Lints        | clippy at `-D warnings`; panic paths denied per crate                 |

**`nativecore` is a house constant**, not a token — like `apps.marketing` and `apps.design_tokens`,
the name is identical in every generated project, so `import nativecore` means the same thing
estate-wide. The build backend sits in the crate rather than the root because the root
`pyproject.toml` is `package = false`, a virtual project never built into a wheel; the crate is a
real distribution pulled in via `[tool.uv.sources]`.

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

**They run on the host, not in Docker** — the second such exception after `mobile/`. The toolchain
pin is what makes a host run and the image's build stage agree.

---

## The boundary: never panic into Python

This is the rule everything else hangs off. A panic crossing FFI is a Python exception at best and
a dead Gunicorn worker at worst, so each crate's `[lints.clippy]` table denies the ways it
happens — `unwrap_used`, `expect_used`, `panic`, `indexing_slicing`, `todo`, `unimplemented`,
`unreachable`. All seven are **restriction** lints, which `clippy::all` does not include, so each
is denied by name; `panic = "deny"` covers the `panic!` macro only. Rule, the exact table, and the
per-site `#[allow]` escape: `code/docs/rust/PYO3-BOUNDARY.md`.

Keep the boundary **thin** — validate, delegate, map:

```rust
#[pyfunction]
fn parse_token(raw: &str) -> PyResult<String> {
    // Logic lives in a plain Rust function, testable without an interpreter.
    decode(raw).map_err(|e| PyValueError::new_err(e.to_string()))
}
```

`panic = "abort"` is **never** set for a profile the extension is built under — it kills the
worker instead of raising.

---

## Memory hygiene: the reason this exists

Python `bytes` are immutable and garbage-collected — once key material is in one you cannot erase
it. Rust can guarantee otherwise, with a `Drop` impl that zeroizes. Three rules follow, and
`code/docs/rust/MEMORY-HYGIENE.md` develops each:

- **Never render a secret.** `__repr__` and `__str__` show a length, never contents — a secret
  that renders itself into a log line is the commonest way key material escapes.
- **Expose as late as possible.** The moment bytes cross back into Python the guarantee stops
  applying to that copy. Name the method conspicuously so review catches it.
- **State the limit honestly.** Zeroizing wipes _this_ buffer. It does not retract copies Python
  already made, and it does not stop the OS paging the page to swap — that needs `mlock`, a
  per-deployment decision. Never imply more than it delivers.

---

## Two suites, both required

`test.sh` runs the **Rust** tests. The tests that cross the PyO3 boundary are **pytest** tests and
run through `code/src/scripts/tests/`. Both are required, because a crate can be entirely correct
in Rust and still expose a broken boundary — a wrong signature, a panic that should have been a
`PyResult`, a `__repr__` that leaks. The Rust suite cannot see any of those.

Coverage floors are the project's usual numbers applied to the **Python-side** tests: 75% lines
and branches, 90% auth-adjacent. Rust coverage is not separately gated at baseline — say so rather
than implying a combined figure exists.

---

## Steps

1. **Answer the gate**, and record the answer.
2. **Keep the boundary thin.** A `#[pyfunction]` validates, delegates to plain Rust, and maps
   errors. Logic lives in ordinary functions testable without a Python interpreter.
3. **Write both suites** — Rust unit tests beside the code, pytest tests that import the module
   and exercise the real boundary.
4. **Treat every dependency as a decision.** `audit.sh` passes before merge; suppress an advisory
   only in `deny.toml`, with a dated comment saying why it does not apply here. Never skip the
   gate to unblock a merge.
5. **Verify before hand-off:**

   ```bash
   bash code/src/scripts/rust/lint.sh
   bash code/src/scripts/rust/test.sh
   bash code/src/scripts/rust/audit.sh
   bash code/src/scripts/rust/build.sh --release
   ```

**Definition of done:** lint, tests, audit and the release build all exit `0`; the Python-side
boundary tests pass to the coverage floors; every `unsafe` block carries a `SAFETY:` comment; no
panicking path reachable from Python; `CONTEXT.md` updated if structure changed; British English.

## Guardrails recap

- Never panic across FFI. `unsafe_code = "deny"` per crate — **denied, not forbidden**: PyO3 and
  FFI sometimes need it, so an author writes an explicit `#[allow(unsafe_code)]` with a `SAFETY:`
  comment that survives review. Never add one silently.
- Secrets zeroize on drop and never render.
- Never commit `target/` or a built `.so`/`.pyd`/`.dylib` — binaries break Copier generation for
  every downstream project.
- The toolchain `channel` and `rust-version` are **not** a matched set — the first is the compiler
  everyone builds with, the second the MSRV our source needs (`code/docs/rust/SUPPLY-CHAIN.md`).
- Source files ≤ 750 lines (800 grace).

## Handoff

Report the **gate answer**, the crates and files touched, the **boundary signature** as it now
stands, what is zeroized and what that does not cover, and any dependency added with its
`deny.toml` consequence. Then name what is owed next: `test-writer` for the boundary tests,
`security` for the audit where the crate touches crypto or secrets, `backend` for the Python side
that calls it, and `cicd` where the image's Rust stage or a toolchain pin moves.
**Suggest, do not chain**, unless the caller said to.

## Governing procedures (route here — do not restate at length)

- `code/workflows/12-rust-extension/` — the procedure for this surface
- `code/workflows/02-tdd-cycle/` · `08-security-hardening/` — both suites, then the audit
- `project-management/workflows/19-backend-code/` — the build phase this is entered from
- `project-management/workflows/22-implementation-documentation/` — the closeout before commit
- `how-to/workflows/07-dependency-updates/` — the cadence a crate or toolchain bump follows

## Cross-references

- `code/docs/RUST.md` and its `rust/` sub-docs — the guide behind this skill
- `code/docs/data-structures/TYPES-RUST.md` — newtypes for identifiers and units, enums carrying
  data per variant so illegal states cannot be constructed, and the wire/domain seam: a
  `#[serde(deny_unknown_fields)]` DTO converted through `TryFrom`, with the domain type deriving
  no serde at all. `serde` is not a workspace dependency, so adding it is a supply-chain event
- `code/docs/encryption/RUST-CRYPTO.md` — how native crypto relates to the Fernet pipeline
- `code/src/rust/CLAUDE.md` — the operating rules for the tree itself
- `code/src/scripts/rust/CONTEXT.md` — why these scripts run on the host
