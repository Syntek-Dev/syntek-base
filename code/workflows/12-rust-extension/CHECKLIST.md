---
workflow: 12-rust-extension
phase: build
skills: [stack-rust, stack-django]
model: opus
---

# Rust Extension — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (RUST.md, ENCRYPTION-GUIDE.md, SECURITY.md, TESTING.md) · **External — Framework & Language Docs** (Rust, PyO3, maturin) · **External — Testing** for supporting references.

## Gate

- [ ] The work meets one of the two grounds — a guarantee Python cannot make, or a **measured**
      hot path (else use `18-backend-code` and the `backend` skill) · _opus_
- [ ] The design was grilled and confirmed before any code was written · _opus_
- [ ] Entered from `project-management/workflows/18-backend-code/`, not from a design gate

## Boundary

- [ ] Every `#[pyfunction]` validates, delegates to plain Rust, and maps the error — no logic in
      the boundary itself
- [ ] No reachable panicking path: no `unwrap`, `expect`, `panic!`, or slice indexing
- [ ] `panic = "abort"` is **not** set for any profile the extension is built under
- [ ] Each failure maps to the Python exception a Python author would expect — no sentinel
      return values
- [ ] No secret material appears in any error message
- [ ] `py.allow_threads` used for any operation measured in milliseconds
- [ ] Every `unsafe` block carries `#[allow(unsafe_code)]` **and** a `SAFETY:` comment naming the
      invariant

## Secret material

- [ ] Anything holding key or plaintext bytes zeroizes on drop
- [ ] `__repr__`/`__str__` show a length, never contents
- [ ] The exposing method is called as late as possible, and its result dropped immediately
- [ ] Comparisons against a secret use constant-time comparison, not `==`
- [ ] The documented limits are not overstated — copies, swap and core dumps are still uncovered
- [ ] Keys come from the environment; the versioned-key scheme still applies

## Supply chain

- [ ] `bash code/src/scripts/rust/audit.sh` exits `0`
- [ ] Any new crate is justified against the gate, not by convenience
- [ ] Cryptographic work uses an audited implementation — no primitive was implemented here
- [ ] New dependencies are pinned in `[workspace.dependencies]`, not per-crate
- [ ] No advisory suppressed without a dated comment and a re-check date in `deny.toml`
- [ ] No licence added outside the allow-list without an ADR

## Tests — both suites

- [ ] `bash code/src/scripts/rust/test.sh` exits `0`
- [ ] Python-side pytest tests import the module and exercise the **real** boundary
- [ ] At least one Python test per exported function asserts the **failure** path raises the
      documented exception
- [ ] Coverage floors met on the Python side: 75% lines and branches, 90% auth-adjacent

## Quality gates

- [ ] `bash code/src/scripts/rust/lint.sh` exits `0` (rustfmt clean, clippy at `-D warnings`)
- [ ] `bash code/src/scripts/rust/build.sh --release` exits `0`
- [ ] Python syntax and test scripts under `code/src/scripts/` all green
- [ ] Source files ≤ 750 lines (800 grace)

## Integration

- [ ] The extension is called from `services.py`, never from a view, endpoint or template
- [ ] Fernet remains canonical for field encryption — nothing was migrated without an ADR
- [ ] Every state-changing endpoint still carries its named permission check
- [ ] `08-security-hardening` run if the crate touches crypto or secret material

## Closeout

- [ ] `target/` and every built `.so`/`.pyd`/`.dylib` excluded from the commit
- [ ] `code/src/rust/CONTEXT.md` updated if the tree changed
- [ ] Handed to `21-implementation-documentation` for the record, docs closeout and graph refresh
