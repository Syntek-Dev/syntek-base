---
workflow: 12-rust-extension
phase: build
agent: rust
skills: [stack-rust, stack-django]
model: opus
---

# Rust Extension — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                  |
| ---- | ------------------------------------------------------------------------ |
| 1    | **Guides in code/docs/** → RUST.md (the gate question)                   |
| 2    | **Guides in code/docs/** → RUST.md (supply chain), SECURITY.md           |
| 3    | **Guides in code/docs/** → RUST.md (PyO3 boundary), DATA-STRUCTURES.md   |
| 4    | **External — Framework & Language Docs** → Rust, PyO3, maturin           |
| 5    | **External — Testing** → pytest, pytest-django                           |
| 6    | **Guides in code/docs/** → RUST.md (memory hygiene), ENCRYPTION-GUIDE.md |

Step 2 is **first-crate only** when no new dependency is involved — skip it when adding a
function to an existing crate with no new crate in the tree.

---

## Step 1 — Grill the design, starting at the gate

Load `.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%>.
The **first** question is the workflow's gate, and a wrong answer here wastes everything after it:

> Does this need to be Rust at all — a guarantee Python cannot make, or a measured hot path?

"It would probably be faster" is not an answer. Ask for the measurement, or for the specific
guarantee. If neither exists, stop and hand back to `backend`.

Then resolve, one at a time:

- The **exact boundary signature** — what crosses, in which direction, borrowed or copied
- **Error mapping** — which Python exception each failure raises
- **What must be zeroized**, and where the exposing call sites are
- Whether the operation is long enough to need `py.allow_threads`
- Whether it is a batch call or a per-item call (per-item in a Python loop is often a net loss)

No code until <%DEVELOPER_NAME%> confirms (`.claude/CLAUDE.md` §10).

## Step 2 — Justify and add any dependency

Only if the design needs a crate that is not already in `[workspace.dependencies]`.

- Justify it against the gate — a convenience crate saving twenty lines is not a justification
- Prefer the **shallower dependency tree** between two candidates; depth is the risk multiplier
- For anything cryptographic, use an audited implementation (RustCrypto or a published audit) —
  never implement a primitive
- Pin it in `[workspace.dependencies]`, never per-crate, so a patch lands in one place
- Run the gate:

```bash
bash code/src/scripts/rust/audit.sh
```

A licence outside the allow-list stops the step. Widening it is an ADR, not a config change.

## Step 3 — Write the plain Rust first

Write the logic as ordinary Rust functions with **no PyO3 types** — that keeps it testable at full
speed without an interpreter, and it is where the real work belongs.

Respect the lint table: no `unwrap`, no `expect`, no `panic!`, no slice indexing. Return `Result`
and let the boundary map it.

## Step 4 — Add the thin boundary

Wrap the logic in `#[pyfunction]` / `#[pymethods]` that validate, delegate and map:

```rust
#[pyfunction]
fn parse_token(raw: &str) -> PyResult<String> {
    decode(raw).map_err(|e| PyValueError::new_err(e.to_string()))
}
```

- Map to the exception a Python author would expect — never a sentinel return value
- Put **no secret material** in an error message
- Anything holding key or plaintext bytes zeroizes on drop and renders as a length, never contents
- Release the GIL with `py.allow_threads` for anything measured in milliseconds
- Any `unsafe` needs an explicit `#[allow(unsafe_code)]` and a `SAFETY:` comment

Build it:

```bash
bash code/src/scripts/rust/build.sh --check     # fast inner loop
bash code/src/scripts/rust/build.sh             # install into the venv
```

## Step 5 — Write both test suites

**Rust tests**, beside the code, for logic:

```bash
bash code/src/scripts/rust/test.sh
```

**Python tests**, for the boundary — these are pytest tests and run through
`code/src/scripts/tests/`. Write at least one per exported function asserting the **failure** path
raises the documented exception, not merely that the happy path returns.

The Python suite is not optional. `cargo test` never imports the module, so it structurally cannot
see a wrong signature, a panic that should have been a `PyResult`, an error mapped to the wrong
type, or a `__repr__` that leaks a secret.

Coverage floors (75% lines and branches, 90% auth-adjacent) apply to the Python-side tests.

## Step 6 — Wire it into the service layer

Call the extension from `apps/<app>/services.py`, never from a view, an endpoint or a template.
The crate is a primitive; the service layer is where it is composed into behaviour.

If the work touches secrets or crypto, read `code/docs/encryption/RUST-CRYPTO.md` first:
**Fernet stays canonical** for field encryption, and native crypto is a branch for what Fernet
structurally cannot do — not a replacement.

## Step 7 — Verify and hand off

```bash
bash code/src/scripts/rust/lint.sh
bash code/src/scripts/rust/test.sh
bash code/src/scripts/rust/audit.sh
bash code/src/scripts/rust/build.sh --release
```

Then the Python side through `code/src/scripts/syntax/*.sh` and `code/src/scripts/tests/*.sh`.

Work through `CHECKLIST.md`. If the crate touches crypto or secret material, run
`code/workflows/08-security-hardening/` before it ships.

Hand off to `project-management/workflows/21-implementation-documentation/` for the
implementation record, the `CONTEXT.md` closeout and the code-review-graph refresh — do not write
those here.
