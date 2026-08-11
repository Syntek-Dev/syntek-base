---
type: guide
agent: rust
skills: [stack-rust]
model: opus
---

# PyO3 Boundary

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

The seam between Rust and Python: how it is shaped, what may never cross it, and how it is tested.
Index: [`../RUST.md`](../RUST.md).

---

## Never panic across the boundary

A Rust panic unwinding into CPython is undefined territory. PyO3 catches what it can and converts
it to `pyo3_runtime.PanicException`, but the process may already be in an inconsistent state — and
under `panic = "abort"` there is no catching at all: the whole **Gunicorn worker** dies, taking
every in-flight request with it.

So the panicking paths are denied at the lint level in every crate:

```toml
[lints.clippy]
unwrap_used = "deny"
expect_used = "deny"
panic = "deny"
indexing_slicing = "deny"
todo = "deny"
unimplemented = "deny"
unreachable = "deny"
```

`indexing_slicing` is in that list because `data[i]` panics on an out-of-range index. Use
`.get(i)`, iterators, or `zip` — the baseline `constant_time_eq` folds over `zip` for exactly this
reason.

**`panic = "deny"` covers the `panic!` macro and nothing else.** `todo!()`, `unimplemented!()` and
`unreachable!()` each expand to a panic and each needs denying by name. All three sit in clippy's
`restriction` group, which `all` deliberately does not include — which is why every lint in that
block is listed individually rather than inherited from a group.

**`panic = "abort"` is never set** in a profile the extension module is built under.

### `unreachable!()` is not an exception to this

It is tempting to treat `unreachable!()` as a claim about the code rather than a gap in it — an
assertion that the type system could not express. The boundary does not care about the
distinction. If the branch is ever reached, CPython gets an unwind, and the fact that the author
believed it could not happen is what made it worth asserting in the first place.

Where a branch really is provably dead — closing a `match` the compiler cannot see is exhaustive —
the escape hatch is per-site and reviewable, on exactly the same rule as `unsafe` below:

```rust
// The parser guarantees `kind` is one of the three variants above; a fourth would be a
// bug in `parse_kind`, not in this match.
#[allow(clippy::unreachable)]
_ => unreachable!("parse_kind returned an unhandled variant"),
```

An `#[allow]` with no comment is not a justification, and a reviewer should treat it as one of the
panicking paths that slipped through.

**`todo!()` in a TDD red phase takes the same treatment.** `STUBS_TDD_RED=1` skips `stubs.sh`; it
has no effect on `cargo clippy`, and there is deliberately no environment variable that does. A
red-phase stub carries `#[allow(clippy::todo)]` on the item, which is scoped to the stub, visible
in the diff, and has to be deleted to reach green.

## Keep the boundary thin

A `#[pyfunction]` does three things and no more: validate, delegate, map the error.

```rust
#[pyfunction]
fn parse_token(raw: &str) -> PyResult<String> {
    decode(raw).map_err(|e| PyValueError::new_err(e.to_string()))
}

// Plain Rust. No PyO3 types, so it is testable without an interpreter.
fn decode(raw: &str) -> Result<String, DecodeError> { /* … */ }
```

Logic that lives in plain functions is testable by `cargo test` at full speed. Logic that lives in
`#[pyfunction]` bodies can only be reached through Python, which is slower to run and awkward to
cover.

## Map errors to the right Python exception

Callers write `except ValueError:`, not `except PanicException:`. Choose the exception a Python
author would expect:

| Rust condition             | Python exception              |
| -------------------------- | ----------------------------- |
| Malformed or invalid input | `PyValueError`                |
| Wrong type supplied        | `PyTypeError`                 |
| Index or key out of range  | `PyIndexError` / `PyKeyError` |
| I/O failure                | `PyIOError`                   |
| Not yet supported          | `PyNotImplementedError`       |

Never encode a failure as a sentinel return value (`-1`, empty string) — Python has exceptions and
the caller will not check.

**Do not put secret material in an error message.** The message reaches logs and, in `DEBUG`,
possibly a response body.

## The GIL and long operations

PyO3 holds the GIL for the duration of a call, so a long-running Rust function blocks every other
thread in the interpreter. For anything measured in milliseconds, release it:

```rust
#[pyfunction]
fn hash_bulk(py: Python<'_>, data: &[u8]) -> PyResult<Vec<u8>> {
    py.allow_threads(|| expensive_hash(data))
}
```

Inside `allow_threads` you may not touch any Python object — the closure takes only plain Rust
data. That is a compile-time guarantee, not a convention.

## Conversion is not free

Every argument crossing the boundary is converted. `&[u8]` and `&str` borrow; `Vec<u8>` and
`String` copy. A function called in a tight Python loop can spend more time converting than
computing — at which point the Rust rewrite is a net loss.

**Measure the whole call from Python**, not the Rust function in isolation. Prefer one call
handling a batch over N calls handling one item each.

## `abi3` and why the wheel is portable

The workspace enables `abi3-py314`, so the extension builds against Python's stable ABI: one wheel
covers **every CPython from 3.14 upward**, rather than one wheel per minor version.

The cost is a smaller API surface — some PyO3 features that reach into version-specific internals
are unavailable. That trade is deliberate: the packaging simplification is worth more here than
the last few percent of API access.

## `unsafe` is denied, not forbidden

`unsafe_code = "deny"` under `[lints.rust]` means an author must write an explicit
`#[allow(unsafe_code)]` with a `SAFETY:` comment naming the invariant being upheld:

```rust
#[allow(unsafe_code)]
// SAFETY: `ptr` is non-null and points to `len` initialised bytes for the lifetime of
// `owner`, which outlives the returned slice.
let bytes = unsafe { std::slice::from_raw_parts(ptr, len) };
```

An `unsafe` block with no `SAFETY:` comment is a review failure, not a style nit.

## Two test suites, both required

| Suite      | Runs via                        | Catches                                                 |
| ---------- | ------------------------------- | ------------------------------------------------------- |
| **Rust**   | `code/src/scripts/rust/test.sh` | Logic errors inside the crate                           |
| **Python** | `code/src/scripts/tests/`       | Boundary defects the Rust suite structurally cannot see |

The Python suite is not optional. A crate can be entirely correct in Rust while its boundary is
broken — a wrong signature, a panic that should have been a `PyResult`, a `__repr__` that leaks a
secret, an error mapped to the wrong exception type. `cargo test` never imports the module, so it
sees none of that.

Write at least one Python test per exported function that asserts the **failure** path raises the
documented exception, not merely that the happy path returns.

## Cross-references

- [`MEMORY-HYGIENE.md`](MEMORY-HYGIENE.md) — what may cross the boundary and what must not
- [`SUPPLY-CHAIN.md`](SUPPLY-CHAIN.md) — the dependency gate
- `code/docs/TESTING.md` — coverage floors the Python-side tests count towards

_Part of the `code/docs/rust/` sub-document family._
