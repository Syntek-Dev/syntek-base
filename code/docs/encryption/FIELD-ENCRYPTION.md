---
type: guide
skills: [gdpr-mechanics, stack-django]
model: opus
---

# Encryption Guide — Field Encryption

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Field-level PII encryption: Fernet fields, AES-256-GCM service-layer pattern

**Applies to:** `code/src/django/apps/` **Reference implementation:**
`code/src/django/apps/users/`

> **What this codebase actually uses:** PII `EncryptedField`s in `apps.core.encryption`
> (`EncryptedCharField` / `EncryptedEmailField` / `EncryptedTextField`) are **Fernet**. The
> AES-256-GCM `encrypt_field(...)` examples below are the **portable service-layer pattern** for a
> new module; AES-256-GCM is wired in production only for MFA secrets
> (`apps/users/services/mfa_encryption.py`). Email lookup tokens are a keyed HMAC-SHA3-256 blind
> index — see [`LOOKUP-TOKENS.md`](LOOKUP-TOKENS.md).

---

## Zero-Plaintext Guarantee

**No plaintext sensitive data ever reaches the database.** This is a wholesale security policy,
not just a GDPR/PII compliance measure. Any field whose exposure would cause a security breach —
regardless of whether it identifies a person — must be encrypted at rest.

Sensitive fields are encrypted by the service layer before any DB write, using Python's
`cryptography` library (AES-256-GCM). The service layer is also the **single point of
decryption** on read — Django Ninja endpoints and Django templates only ever receive plaintext
the service has already decrypted. The model field itself is a storage type only.

The three actors and their responsibilities:

| Actor                                               | Responsibility                                                                                                                                 |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Django model field** (`EncryptedField`)           | Storage type — `TEXT` column, holds ciphertext only                                                                                            |
| **Service layer**                                   | Calls `encrypt_field` / `encrypt_fields_batch` before save; `decrypt_field` / `decrypt_fields_batch` after load — the sole decryption boundary |
| **Presentation layer** (Ninja endpoints, templates) | Only ever handles plaintext returned by the service layer; never reads or decrypts ciphertext directly                                         |

---

## EncryptedField

Every PII column on a Django model must use `EncryptedField` instead of `CharField`,
`TextField`, or `EmailField`.

```python
from apps.core.encryption import EncryptedField

class MyModel(models.Model):
    full_name = EncryptedField(blank=False, null=False)
    phone     = EncryptedField(blank=True, null=True)
```

`EncryptedField` extends `models.TextField`. The service layer handles encryption and decryption
using Python's `cryptography` library — the field itself is a storage type only.

**Rules:**

- Never use `unique=True` on an `EncryptedField` — see LOOKUP-TOKENS.md.
- Never use `db_index=True` on an `EncryptedField` — the ciphertext is random and unindexable.
- Never set `max_length` — the ciphertext is always longer than the plaintext.
- Never build a search vector over an `EncryptedField` — see below.
- `null=True` is allowed for optional fields.

### Encrypted columns cannot be searched, sorted, or filtered

Authenticated encryption is **non-deterministic** — the same plaintext encrypts to different
ciphertext every time. Everything the database does with a column's contents therefore stops
working:

| Operation                | Result on an encrypted column                          |
| ------------------------ | ------------------------------------------------------ |
| Equality / `LIKE` filter | Never matches — compare through a lookup token instead |
| `ORDER BY`               | Orders by ciphertext, i.e. arbitrarily                 |
| B-tree or GIN index      | Indexes noise; costs writes, serves no read            |
| Full-text search vector  | Indexes noise — the vector is meaningless              |
| `UNIQUE` constraint      | Passes for duplicate plaintext (LOOKUP-TOKENS.md)      |

Exact-match lookup is recovered with a keyed lookup token (LOOKUP-TOKENS.md). **Ordering and
full-text search are not recoverable** — no companion column restores them without storing the
plaintext that encryption exists to remove.

So: **if a field must be both encrypted and searchable, that is an encryption decision, not a
search one.** Reopen it through a grilling pass and choose deliberately — accept that the field
is not searchable, narrow what is encrypted to the genuinely sensitive part, or search a
different, non-sensitive field. Never quietly add a plaintext mirror of an encrypted column to
make search work; that reintroduces exactly the exposure the encryption was for.

### Encryption and observability

Encrypted values reach the database as query parameters. Statement logging that captures
parameters will therefore write ciphertext — and, on the write path, sometimes plaintext — into
logs that are retained and shipped. Resolve that conflict explicitly rather than by disabling
observability outright: see `code/docs/performance/DATABASE-PERFORMANCE.md` — _Finding the slow
queries in the first place_.

---

## Encryption and Decryption Paths

### Write path

```text
Django Ninja endpoint / HTMX form handler / service call
    │
    ├── encrypt_field(plaintext, key, model, field)        ← individual
    │   OR
    └── encrypt_fields_batch([(field, value), ...], key, model)  ← batch
            │
            ▼
    model.field = ciphertext
    model.field_token = make_field_token(plaintext)   ← if unique
    model.save()
            │
            ▼
         PostgreSQL (TEXT column — ciphertext only, never plaintext)
```

### Read path

```text
PostgreSQL (ciphertext)
    │
    ▼
model.field  →  raw ciphertext (EncryptedField.from_db_value passthrough)
    │
    ▼
Service layer: decrypt_field(ciphertext, key, model, field)   ← the only decryption boundary
    │
    ▼
plaintext returned to the caller (Ninja endpoint response schema / Django template context)
```

---

## Individual Field Encryption

Use `encrypt_field` / `decrypt_field` when a model has **one or two** sensitive fields, or
when fields have different keys.

```python
import base64
import os

from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from django.conf import settings


def _load_field_key(setting_path: str) -> bytes:
    """Load and validate a 32-byte AES-256 field key from settings."""
    cfg = getattr(settings, "<%ENV_PREFIX%>_<MODULE>", {})
    raw = cfg.get("FIELD_KEY", "")
    key: bytes = raw.encode("utf-8") if isinstance(raw, str) else bytes(raw)
    if len(key) < 32:
        raise ImproperlyConfigured(f"{setting_path} must be at least 32 bytes.")
    return key


def encrypt_field(plaintext: str, key: bytes, model: str, field: str) -> str:
    """Encrypt *plaintext* with AES-256-GCM, binding it to *model* and *field* via AAD."""
    aad = f"{model}:{field}".encode()
    nonce = os.urandom(12)
    ct = AESGCM(key).encrypt(nonce, plaintext.encode(), aad)
    return base64.b64encode(nonce + ct).decode()


def decrypt_field(ciphertext: str, key: bytes, model: str, field: str) -> str:
    """Decrypt a value produced by *encrypt_field*."""
    aad = f"{model}:{field}".encode()
    raw = base64.b64decode(ciphertext)
    nonce, ct = raw[:12], raw[12:]
    return AESGCM(key).decrypt(nonce, ct, aad).decode()


# ── Usage ────────────────────────────────────────────────────────────────────

_key = _load_field_key("<%ENV_PREFIX%>_<MODULE>['FIELD_KEY']")

# Encrypt before save
model.full_name = encrypt_field(plaintext_name, _key, "MyModel", "full_name")
model.save()

# Decrypt after load
plaintext_name = decrypt_field(model.full_name, _key, "MyModel", "full_name")
```

The `model` and `field` arguments are used as AAD (Additional Authenticated Data) so a
ciphertext from one field cannot be replayed into another.

---

## Batch Field Encryption

Use `encrypt_fields_batch` / `decrypt_fields_batch` when a model has **three or more** sensitive
fields that share the same key.

```python
def encrypt_fields_batch(
    fields: Sequence[tuple[str, str]],
    key: bytes,
    model: str,
) -> list[str]:
    """Encrypt multiple fields in order. Returns ciphertexts in the same order as *fields*."""
    return [encrypt_field(value, key, model, field_name) for field_name, value in fields]


def decrypt_fields_batch(
    fields: Sequence[tuple[str, str]],
    key: bytes,
    model: str,
) -> list[str]:
    """Decrypt multiple fields in order. Returns plaintexts in the same order as *fields*."""
    return [decrypt_field(ciphertext, key, model, field_name) for field_name, ciphertext in fields]


# ── Usage ────────────────────────────────────────────────────────────────────

encrypted = encrypt_fields_batch(
    [
        ("full_name", plaintext_name),
        ("address_line_1", plaintext_addr1),
        ("address_line_2", plaintext_addr2),
        ("postcode", plaintext_postcode),
    ],
    _key,
    "MyModel",
)
model.full_name, model.address_line_1, model.address_line_2, model.postcode = encrypted
model.save()
```

**Rule of thumb:**

| Number of encrypted fields | Use                                             |
| -------------------------- | ----------------------------------------------- |
| 1–2                        | `encrypt_field` / `decrypt_field`               |
| 3 or more                  | `encrypt_fields_batch` / `decrypt_fields_batch` |

---

## Settings Required

Every module that uses encrypted fields must define two keys in its `<%ENV_PREFIX%>_<MODULE>`
settings dict, both read from environment variables. The `cryptography` package
(`cryptography>=42.0`) must be listed in the app's Python dependencies.

```python
<%ENV_PREFIX%>_PAYMENTS = {
    # 32-byte key for field encryption (AES-256-GCM via cryptography.hazmat)
    "FIELD_KEY": env("<%ENV_PREFIX%>_PAYMENTS_FIELD_KEY"),

    # 32-byte key for HMAC lookup tokens (only needed when unique fields exist)
    "FIELD_HMAC_KEY": env("<%ENV_PREFIX%>_PAYMENTS_FIELD_HMAC_KEY"),
}
```

`FIELD_KEY` and `FIELD_HMAC_KEY` **must be different keys**. Using the same key for both
encryption and HMAC is a cryptographic mistake.

Minimum lengths validated at startup (`AppConfig.ready()`):

| Setting          | Minimum  | Why                            |
| ---------------- | -------- | ------------------------------ |
| `FIELD_KEY`      | 32 bytes | AES-256 requires a 256-bit key |
| `FIELD_HMAC_KEY` | 32 bytes | HMAC-SHA3-256 security margin  |

---

## Versioned Key Approach

Keys are versioned via environment variables. The highest version present is used for new
encryptions; all loaded versions remain available for decrypting existing ciphertexts.

```bash
# Initial deployment (V1 only):
<%ENV_PREFIX%>_FIELD_KEY_V1_USER_EMAIL=<base64-key-1>

# After rotation (V1 + V2 — new encryptions use V2):
<%ENV_PREFIX%>_FIELD_KEY_V1_USER_EMAIL=<base64-key-1>
<%ENV_PREFIX%>_FIELD_KEY_V2_USER_EMAIL=<base64-key-2>
```

```python
def load_versioned_keys(field: str, *, env_prefix: str = "<%ENV_PREFIX%>_FIELD_KEY") -> dict[int, bytes]:
    """Return a ``{version: key_bytes}`` mapping for *field*.

    Scans ``{env_prefix}_{FIELD}_V1``, ``_V2``, … stopping at the first gap.
    Raises ``ImproperlyConfigured`` if no keys are found.
    """
    keys: dict[int, bytes] = {}
    version = 1
    while raw := os.environ.get(f"{env_prefix}_{field.upper()}_V{version}"):
        keys[version] = base64.b64decode(raw)
        version += 1
    if not keys:
        raise ImproperlyConfigured(
            f"No encryption key found for field '{field}'. "
            f"Set {env_prefix}_{field.upper()}_V1 in your environment."
        )
    return keys


def active_key(versioned_keys: dict[int, bytes]) -> bytes:
    """Return the highest-version key (used for new encryptions)."""
    return versioned_keys[max(versioned_keys)]
```

Call `load_versioned_keys` once in `AppConfig.ready()` and store the result on a module-level
singleton. Document the full manual key-rotation procedure in the project's operational runbook.

---

## Migrations

When adding encrypted fields to a new or existing model:

1. **Add** `EncryptedField` columns — no `unique=True`, no `db_index=True`.
2. **Add** `*_token` columns as `null=True` initially (no `unique` yet).
3. **RunPython** to backfill tokens for existing rows using `FIELD_HMAC_KEY`.
4. **AlterField** token columns to `null=False, unique=True` (or keep `null=True` for optional
   fields — PostgreSQL allows multiple `NULL` values under a `UNIQUE` constraint).
5. **AlterField** the encrypted columns to remove any `unique` / `db_index` that may have been
   set before the token pattern was applied.

See the encrypted-unique-tokens migration in the `users` app for the canonical example.

---

## What Needs Encryption

Encrypt any field that, if read directly from the database, would cause a security or privacy
breach:

- **PII** — name, email, phone, address, national insurance number, date of birth, any government
  ID
- **Long-lived cryptographic secrets** — TOTP secrets, API keys, OAuth client secrets, webhook
  signing keys. A DB read leaks them permanently, enabling ongoing attacks (e.g. a stolen TOTP
  secret allows MFA bypass indefinitely).
- **Session-adjacent secrets** — anything whose exposure allows account takeover

The test: _"If an attacker reads this value from a DB dump, what can they do?"_ If the answer is
"access accounts", "impersonate users", or "contact/identify someone", encrypt it.

## What Does NOT Need Encryption

- **Non-sensitive flags and metadata** — `is_active`, `is_staff`, `created_at`, `updated_at`
- **Already hashed** — password hashes, backup code hashes. Hashing is non-reversible; do not
  double-encrypt hashed values.
- **Short-lived single-use tokens** — JWT JTIs, email verification tokens (expire within
  minutes/hours and are single-use). High-entropy and become worthless shortly after creation.
- **Foreign keys** — encrypt the referenced row's PII, not the FK integer
- **Enum / choice fields** — `code_type`, `status` — low cardinality, no sensitive information

**Key distinction:** A value being cryptographically random does not make it safe to store as
plaintext. A TOTP secret is random, but it is also long-lived and its exposure enables indefinite
MFA bypass. Ask the consequence question, not the derivation question.

---

## Quick Checklist

When adding a new encrypted field to any Django model:

- [ ] Field uses `EncryptedField` (not `CharField`, `TextField`, etc.)
- [ ] No `unique=True` on the `EncryptedField` column
- [ ] No `db_index=True` on the `EncryptedField` column
- [ ] If unique: companion `*_token` column added (`CharField(max_length=64, unique=True)`)
- [ ] If unique: token computed in the manager / service layer before `save()`
- [ ] If unique: DB lookups use `filter(field_token=make_field_token(value))`, not
      `filter(field=value)`
- [ ] `FIELD_KEY` and `FIELD_HMAC_KEY` settings defined, read from env vars, validated in
      `AppConfig.ready()`
- [ ] `FIELD_KEY` ≠ `FIELD_HMAC_KEY` — different keys for encryption and HMAC
- [ ] `cryptography` package listed in Python dependencies (`cryptography>=42.0`)
- [ ] 3+ encrypted fields → use `encrypt_fields_batch` / `decrypt_fields_batch`
- [ ] Migration follows the 5-step pattern (add nullable → backfill → tighten)
- [ ] Tests set `FIELD_HMAC_KEY` in the conftest `<%ENV_PREFIX%>_<MODULE>` dict

_Part of the `code/docs/` documentation family. See [`../ENCRYPTION-GUIDE.md`](../ENCRYPTION-GUIDE.md) for the full index._
