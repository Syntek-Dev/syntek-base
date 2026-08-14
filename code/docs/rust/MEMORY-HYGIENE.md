---
type: guide
skills: [stack-rust]
model: opus
---

# Memory Hygiene

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

Handling secret material in memory: what Rust can guarantee that Python cannot, and — just as
important — what it still cannot guarantee. Index: [`../RUST.md`](../RUST.md).

---

## The problem Python cannot solve

Python `bytes` are **immutable** and **garbage-collected**. Together those two facts mean:

- You cannot overwrite a secret in place. There is no API for it; the object is immutable.
- You cannot control when the object is freed, only when it becomes unreachable.
- Every operation that "transforms" a secret — slicing, concatenating, decoding, `.strip()` —
  leaves the original in the allocator, untouched, until chance overwrites it.

A key read into a Python `bytes` is therefore resident in process memory for an unbounded period,
in an unknown number of copies. A core dump, a heap-inspecting exploit, or a swapped page can
surface it long after the code "finished" with it.

**This is the single strongest argument for the Rust surface existing at all.** It is a guarantee
the host language cannot make, not a performance optimisation.

## What Rust guarantees: zeroize on drop

```rust
use zeroize::Zeroize;

impl Drop for SecretBytes {
    fn drop(&mut self) {
        self.inner.zeroize();
    }
}
```

`zeroize` writes zeroes with a volatile store and a compiler fence, so the optimiser **cannot**
elide the write as dead code — which is exactly what a plain loop assigning zeroes would suffer.
`Drop` runs deterministically at end of scope, so the wipe happens at a known point, not whenever a
collector next runs.

Reach for the wrapper any time a value holds: encryption keys, key-derivation output, plaintext
being encrypted, session tokens, password material, TOTP seeds, or recovery codes.

## Never render a secret

The commonest way key material escapes is not an exploit — it is a log line.

```rust
fn __repr__(&self) -> String {
    format!("<SecretBytes len={}>", self.inner.len())
}
```

Show a length; never contents. This matters more than it looks, because a secret reaches a log
through paths nobody wrote deliberately: an f-string in a debug statement, an exception message
including its arguments, a Sentry frame-local capture, a `pytest` assertion diff.

Length is safe to expose here because the caller is comparing against a value of known, fixed
width. If length is genuinely secret in your use case, do not expose `__len__` either.

## Expose late, drop early

Crossing back into Python ends the guarantee **for that copy** — the returned `bytes` is an
ordinary immutable object with all the problems above.

So the exposing method is named conspicuously (`expose`, not `value` or `data`), to make it stand
out in review. Call it as late as possible, use the result immediately, and let it go out of scope.

## The honest limits

State these plainly rather than implying more protection than exists. Overstating them is worse
than not having them, because it stops people looking for the real mitigation.

| Limit                                        | What it means                                                                                                        |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Copies already made are not retracted**    | Wiping this buffer does nothing about a `bytes` Python made from it earlier                                          |
| **Swap is not covered**                      | The OS may have written the page to disk before the wipe. That needs `mlock` — a deployment decision, not a code one |
| **Core dumps are not covered**               | A dump taken while the secret is live contains it. Disable dumps for the app process                                 |
| **The compiler moves values**                | A value may be memcpy'd during a move; only the final location is wiped                                              |
| **Hibernation writes RAM to disk wholesale** | Nothing in the process can prevent it                                                                                |

`mlock` is deliberately **not** applied in this crate. It requires a raised `RLIMIT_MEMLOCK`,
behaves differently across container runtimes, and silently fails in ways that look like success.
If a threat model needs it, it is configured in the deployment and argued in an ADR.

## Constant-time comparison

Comparing a secret with `==` leaks through timing: both Python's `bytes.__eq__` and Rust's
`PartialEq` short-circuit at the first differing byte, so response time correlates with the length
of the matching prefix. Given enough samples, that recovers the value byte by byte.

```rust
let differences = left.iter().zip(right.iter()).fold(0u8, |acc, (a, b)| acc | (a ^ b));
differences == 0
```

The fold must not short-circuit — that is the entire point, and it is why this cannot be written
with `.all()` or an early `return`.

Use it for **any** comparison against a secret: MAC tags, session tokens, password-reset nonces,
API keys, webhook signatures, TOTP codes.

Differing lengths return `false` immediately. That is acceptable here because the caller compares
against a value of known fixed width; if length were secret, the comparison would need to be over
a fixed-size digest of both inputs instead.

## Cross-references

- [`PYO3-BOUNDARY.md`](PYO3-BOUNDARY.md) — the boundary these values cross, and error mapping
- `code/docs/ENCRYPTION-GUIDE.md` — the field-encryption pipeline this supports
- `code/docs/encryption/RUST-CRYPTO.md` — how the native path relates to the Fernet one
- `code/docs/LOGGING.md` — the log channels a leaked secret would reach

_Part of the `code/docs/rust/` sub-document family._
