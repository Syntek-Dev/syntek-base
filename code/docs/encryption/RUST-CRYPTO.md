---
type: guide
skills: [stack-rust, stack-django]
model: opus
---

# Native Crypto — the Rust Path

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

**Applies to:** `code/src/rust/crates/nativecore/` and the call sites in `apps/core/`
Index: [`../ENCRYPTION-GUIDE.md`](../ENCRYPTION-GUIDE.md).

How the first-party native crypto relates to the Fernet field-encryption pipeline — which is
canonical, which is optional, and where the boundary between them sits.

> **Rust-only.** This document exists only in a project generated with `INCLUDE_RUST`. On a
> project without it, the Fernet pipeline described in
> [`FIELD-ENCRYPTION.md`](FIELD-ENCRYPTION.md) is the whole story and nothing here applies.

---

## The dual-path rule

**Fernet stays canonical for field encryption.** `EncryptedField`, the zero-plaintext guarantee,
versioned keys, and the HMAC-SHA3-256 lookup tokens are unchanged by the presence of this crate.
Do not migrate a working field to native crypto because native crypto exists.

The native path exists for the things Fernet and `cryptography` structurally cannot do:

| Concern                                   | Owner                                              |
| ----------------------------------------- | -------------------------------------------------- |
| Field-level PII encryption at rest        | **Fernet** — `FIELD-ENCRYPTION.md`                 |
| Unique-field lookup                       | **HMAC-SHA3-256 blind index** — `LOOKUP-TOKENS.md` |
| MFA secret storage                        | **AES-256-GCM** in the MFA service layer           |
| Comparing a secret without leaking timing | **`nativecore.constant_time_eq`**                  |
| Holding key material that must be wiped   | **`nativecore.SecretBytes`**                       |

That split is deliberate and load-bearing. Two crypto implementations covering the _same_ concern
is a parity burden that drifts; two implementations covering _different_ concerns is a boundary.

## Why this is a branch and not a replacement

`INCLUDE_RUST` is optional, and `<%PROJECT_NAME%>` must work without it. If native crypto replaced
Fernet, every project would depend on a compiled artefact and a registry to fetch it from — which
would also make the template unusable for anyone outside <%ORG_NAME%>.

Keeping Fernet canonical means a project without the Rust surface is complete, not degraded.

**The cost, stated plainly:** on a project _with_ the Rust surface there are two places secret
material is handled, and they must not drift. Read both documents before touching either, and
never let a helper in one silently duplicate a helper in the other.

## What native crypto is genuinely better at

Both entries below are guarantees Python cannot make — not optimisations.

**Constant-time comparison.** `bytes.__eq__` short-circuits at the first differing byte, so
response time correlates with the length of the matching prefix. Use `constant_time_eq` for MAC
tags, session tokens, password-reset nonces, API keys, webhook signatures and TOTP codes.

```python
from nativecore import constant_time_eq

if not constant_time_eq(supplied_token.encode(), expected_token.encode()):
    raise PermissionDenied
```

**Wiping key material.** Python `bytes` are immutable and garbage-collected, so a key read into
one cannot be erased and lingers in the allocator in an unknown number of copies. `SecretBytes`
zeroizes on drop.

```python
from nativecore import SecretBytes

secret = SecretBytes(key_bytes)
try:
    ciphertext = encrypt(secret.expose(), plaintext)
finally:
    secret.clear()
```

`expose()` is named to be conspicuous: the copy it returns is an ordinary `bytes` with none of the
guarantee. Call it late, use it immediately.

## Rules for the call sites

- **Never implement a primitive.** Use an audited implementation — RustCrypto, or a crate with a
  published third-party audit. Memory safety is not construction soundness
  ([`../rust/SUPPLY-CHAIN.md`](../rust/SUPPLY-CHAIN.md)).
- **Never put secret material in an error message.** It reaches logs, and in `DEBUG` possibly a
  response body.
- **Never log a `SecretBytes`.** Its `__repr__` is deliberately opaque; do not defeat that by
  logging `.expose()`.
- **Keys still come from the environment**, never hardcoded, and the versioned-key scheme in
  `FIELD-ENCRYPTION.md` applies unchanged to anything the native path holds.
- **Every state-changing endpoint keeps its named permission check.** Native crypto changes how a
  value is handled, never whether the caller was authorised (`.claude/CLAUDE.md` Section 6).

## Migrating an existing field — don't, unless

There is one trigger worth acting on: a **measured** timing side-channel in a secret comparison.
That is a real vulnerability, and swapping the comparison for `constant_time_eq` is a small,
contained change requiring no data migration.

Re-encrypting stored data to a native implementation is a different proposition entirely —
key rotation, a backfill migration, a dual-read window, and a rollback plan. It is an ADR
(`project-management/src/14-DECISIONS/`) and a story, never an incidental improvement.

## Cross-references

- [`FIELD-ENCRYPTION.md`](FIELD-ENCRYPTION.md) — the canonical Fernet pipeline
- [`LOOKUP-TOKENS.md`](LOOKUP-TOKENS.md) — the blind-index scheme for unique fields
- [`../rust/MEMORY-HYGIENE.md`](../rust/MEMORY-HYGIENE.md) — what zeroize does and does not cover
- `code/docs/SECURITY.md` — the OWASP controls this is audited against
- `code/workflows/08-security-hardening/` — the audit any crypto change must pass

_Part of the `code/docs/encryption/` sub-document family._
