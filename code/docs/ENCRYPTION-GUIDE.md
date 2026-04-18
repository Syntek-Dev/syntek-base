# Encryption Guide

**Applies to:** `code/src/backend/apps/` **Reference implementation:**
`code/src/backend/apps/users/`

---

## Table of Contents

- [Zero-Plaintext Guarantee](#zero-plaintext-guarantee)
- [EncryptedField](#encryptedfield)
- [Encryption and Decryption Paths](#encryption-and-decryption-paths)
- [Individual Field Encryption](#individual-field-encryption)
- [Batch Field Encryption](#batch-field-encryption)
- [Unique Fields — Lookup Tokens](#unique-fields--lookup-tokens)
- [Field Key Naming Convention](#field-key-naming-convention)
- [Versioned Key Approach](#versioned-key-approach)
- [Settings Required](#settings-required)
- [Migrations](#migrations)
- [What Does NOT Need Encryption](#what-does-not-need-encryption)
- [Quick Checklist](#quick-checklist)

---

## Zero-Plaintext Guarantee

**No plaintext sensitive data ever reaches the database.** This is a wholesale security policy, not
just a GDPR/PII compliance measure. Any field whose exposure would cause a security breach —
regardless of whether it identifies a person — must be encrypted at rest.

Sensitive fields are encrypted by the service layer before any DB write, using Python's
`cryptography` library (AES-256-GCM). The GraphQL middleware decrypts on the way out. The model
field itself is a storage type only.

The three actors and their responsibilities:

| Actor                                           | Responsibility                                                                                                  |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Django model field** (`EncryptedField`)       | Storage type — `TEXT` column, holds ciphertext only                                                             |
| **Service layer**                               | Calls `encrypt_field` / `encrypt_fields_batch` before save; `decrypt_field` / `decrypt_fields_batch` after load |
| **GraphQL middleware** (`apps.core.middleware`) | Intercepts resolvers marked `@encrypted` and decrypts before returning to the client                            |

---

## EncryptedField

Every PII column on a Django model must use `EncryptedField` instead of `CharField`, `TextField`, or
`EmailField`.

```python
from code.src.backend.apps.users.models import EncryptedField  # or import from your app's models

class MyModel(models.Model):
    full_name = EncryptedField(blank=False, null=False)
    phone     = EncryptedField(blank=True, null=True)
```

`EncryptedField` extends `models.TextField`. The service layer handles encryption and decryption
using Python's `cryptography` library — the field itself is a storage type only.

**Rules:**

- Never use `unique=True` on an `EncryptedField` — see
  [Unique Fields](#unique-fields--lookup-tokens).
- Never use `db_index=True` on an `EncryptedField` — the ciphertext is random and unindexable.
- Never set `max_length` — the ciphertext is always longer than the plaintext.
- `null=True` is allowed for optional fields.

---

## Encryption and Decryption Paths

### Write path

```text
GraphQL mutation / service call
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
    ├── Service layer: decrypt_field(ciphertext, key, model, field)
    │   OR
    └── GraphQL middleware: intercepts @encrypted resolvers, calls decrypt_field
            │
            ▼
         plaintext returned to caller / client
```

---

## Individual Field Encryption

Use `encrypt_field` / `decrypt_field` when a model has **one or two** sensitive fields, or when
fields have different keys.

The key is a 32-byte `bytes` object loaded from settings. Use `_load_field_key` (or an equivalent
helper in your app) to read and validate it at startup.

```python
import base64
import os

from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from django.conf import settings


def _load_field_key(setting_path: str) -> bytes:
    """Load and validate a 32-byte AES-256 field key from settings."""
    cfg = getattr(settings, "SYNTEK_<MODULE>", {})
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

_key = _load_field_key("SYNTEK_<MODULE>['FIELD_KEY']")

# Encrypt before save
model.full_name = encrypt_field(plaintext_name, _key, "MyModel", "full_name")
model.save()

# Decrypt after load
plaintext_name = decrypt_field(model.full_name, _key, "MyModel", "full_name")
```

The `model` and `field` arguments are used as AAD (Additional Authenticated Data) so a ciphertext
from one field cannot be replayed into another.

---

## Batch Field Encryption

Use `encrypt_fields_batch` / `decrypt_fields_batch` when a model has **three or more** sensitive
fields that share the same key. Batch helpers are thin loops over `encrypt_field` /
`decrypt_field` — they exist for call-site readability and to keep batch logic consistent.

```python
import base64
import os
from typing import Sequence

from cryptography.hazmat.primitives.ciphers.aead import AESGCM


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

# Encrypt before save
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
# encrypted is a list[str] in the same order as the input
model.full_name, model.address_line_1, model.address_line_2, model.postcode = encrypted
model.save()

# Decrypt after load
decrypted = decrypt_fields_batch(
    [
        ("full_name", model.full_name),
        ("address_line_1", model.address_line_1),
        ("address_line_2", model.address_line_2),
        ("postcode", model.postcode),
    ],
    _key,
    "MyModel",
)
plaintext_name, plaintext_addr1, plaintext_addr2, plaintext_postcode = decrypted
```

**Rule of thumb:**

| Number of encrypted fields | Use                                             |
| -------------------------- | ----------------------------------------------- |
| 1–2                        | `encrypt_field` / `decrypt_field`               |
| 3 or more                  | `encrypt_fields_batch` / `decrypt_fields_batch` |

---

## Unique Fields — Lookup Tokens

AES-256-GCM uses a random nonce per encryption. The same plaintext encrypted twice produces
**different ciphertext**. A DB `UNIQUE` constraint on ciphertext is therefore meaningless — the same
email stored twice would pass the constraint because its ciphertexts differ.

**Rule: every `EncryptedField` that must be unique gets a companion `*_token` column.** The token is
a deterministic HMAC-SHA256 of the normalised plaintext. The `UNIQUE` constraint goes on the token
column, never on the ciphertext column.

### Token column naming

| Encrypted field             | Token column                      |
| --------------------------- | --------------------------------- |
| `email`                     | `email_token`                     |
| `phone`                     | `phone_token`                     |
| `username`                  | `username_token`                  |
| `national_insurance_number` | `national_insurance_number_token` |
| `bank_account_number`       | `bank_account_number_token`       |

For **batch** groups, use a shared token column only when the combined values form a single unique
key. Otherwise add one token column per unique field:

```python
# Individual unique fields within a batch
class PatientRecord(models.Model):
    nhs_number       = EncryptedField()          # unique
    nhs_number_token = models.CharField(max_length=64, unique=True, db_index=True)

    full_name        = EncryptedField()          # not unique — no token needed
    date_of_birth    = EncryptedField()          # not unique — no token needed
    postcode         = EncryptedField()          # not unique — no token needed
```

### Model definition

```python
class MyModel(models.Model):
    # Encrypted — no unique, no db_index
    email = EncryptedField(blank=False, null=False)

    # Token — carries the UNIQUE constraint
    email_token = models.CharField(
        max_length=64,
        unique=True,
        db_index=True,
        verbose_name="email lookup token",
        help_text="HMAC-SHA256 of the normalised email address.",
    )

    # Nullable encrypted field with nullable token
    phone = EncryptedField(blank=True, null=True)
    phone_token = models.CharField(
        max_length=64,
        unique=True,
        null=True,
        blank=True,
        db_index=True,
        verbose_name="phone lookup token",
    )
```

### Token generation

Tokens are generated from the module's `services/lookup_tokens.py` (each module that needs them must
define its own, following the `users` app pattern). The key comes from the module's
`SYNTEK_<MODULE>['FIELD_HMAC_KEY']` setting.

```python
# code/src/backend/apps/<module>/services/lookup_tokens.py
import hashlib
import hmac as _hmac

from django.conf import settings
from django.core.exceptions import ImproperlyConfigured


def _hmac_key() -> bytes:
    cfg = getattr(settings, "SYNTEK_<MODULE>", {})
    key = cfg.get("FIELD_HMAC_KEY")
    if not key:
        raise ImproperlyConfigured("SYNTEK_<MODULE>['FIELD_HMAC_KEY'] must be set.")
    return key.encode("utf-8") if isinstance(key, str) else bytes(key)


def make_email_token(email: str) -> str:
    """Lowercase + strip before hashing for case-insensitive lookups."""
    return _hmac.new(_hmac_key(), email.strip().lower().encode(), hashlib.sha256).hexdigest()


def make_phone_token(phone: str) -> str:
    return _hmac.new(_hmac_key(), phone.strip().encode(), hashlib.sha256).hexdigest()
```

### DB lookups — always use the token column

Never query against an encrypted column directly. Always use the token:

```python
# WRONG — ciphertext lookup, will never match
User.objects.filter(email__iexact=identifier)
User.objects.filter(email=identifier)

# CORRECT — token lookup
from code.src.backend.apps.users.services.lookup_tokens import make_email_token
User.objects.filter(email_token=make_email_token(identifier))
```

### Write path with token

The model manager (or service layer) must compute the token and set both fields before `save()`:

```python
def create_record(email: str, ...) -> MyModel:
    from myapp.services.lookup_tokens import make_email_token

    # _field_key loaded from SYNTEK_<MODULE>["FIELD_KEY"] at module level
    obj = MyModel(
        email=encrypt_field(email, _field_key, "MyModel", "email"),
        email_token=make_email_token(email),
        ...
    )
    obj.save()
    return obj
```

### Token normalisation rules

| Field type               | Normalisation before hashing                                       |
| ------------------------ | ------------------------------------------------------------------ |
| Email                    | `strip().lower()`                                                  |
| Phone                    | `strip()` only (no reformatting)                                   |
| Username                 | `strip().lower()` unless `CASE_SENSITIVE = True`                   |
| National Insurance / SSN | `strip().upper().replace(" ", "")`                                 |
| Other identifiers        | `strip()` — add lowercasing if case-insensitive lookups are needed |

---

## Field Key Naming Convention

All field-level encryption keys follow a strict naming pattern. The full reference is in
[`how-to/src/CONTRIBUTING/FIELD-KEY-NAMING-CONVENTION.md`](../../how-to/src/CONTRIBUTING/FIELD-KEY-NAMING-CONVENTION.md).
The key patterns are summarised here:

| Pattern                  | Format                                   | Example                             | Use Case                                           |
| ------------------------ | ---------------------------------------- | ----------------------------------- | -------------------------------------------------- |
| **Legacy (deprecated)**  | `SYNTEK_<MODULE>_FIELD_KEY`              | `SYNTEK_AUTH_FIELD_KEY`             | Old deployments — upgrade via `migrate_field_keys` |
| **Per-field (standard)** | `SYNTEK_<MODULE>_FIELD_KEY_{FIELD}`      | `SYNTEK_AUTH_FIELD_KEY_EMAIL`       | All new modules                                    |
| **Per-field versioned**  | `SYNTEK_<MODULE>_FIELD_KEY_V{N}_{FIELD}` | `SYNTEK_AUTH_FIELD_KEY_V2_EMAIL`    | 90-day key rotation                                |
| **Batch group**          | `SYNTEK_<MODULE>_FIELD_KEY_{GROUP}`      | `SYNTEK_SHIPPING_FIELD_KEY_ADDRESS` | 3+ related fields                                  |
| **HMAC lookup**          | `SYNTEK_{MODULE}_FIELD_HMAC_KEY`         | `SYNTEK_AUTH_FIELD_HMAC_KEY`        | Unique field lookups                               |

---

## Versioned Key Approach

Keys are versioned via environment variables. The service layer loads all available key versions at
startup and resolves them to plain `bytes` values. The highest version present is used for new
encryptions; all loaded versions remain available for decrypting existing ciphertexts.

```bash
# Initial deployment (V1 only — new encryptions use V1):
SYNTEK_FIELD_KEY_V1_USER_EMAIL=<base64-key-1>

# After rotation (V1 + V2 — new encryptions use V2; V1 can still decrypt old rows):
SYNTEK_FIELD_KEY_V1_USER_EMAIL=<base64-key-1>
SYNTEK_FIELD_KEY_V2_USER_EMAIL=<base64-key-2>
```

The key loader scans `{ENV_PREFIX}_{FIELD}_V1`, `_V2`, … stopping at the first gap, then returns
an ordered mapping of `version → bytes`:

```python
import base64
import os

from django.core.exceptions import ImproperlyConfigured


def load_versioned_keys(field: str, *, env_prefix: str = "SYNTEK_FIELD_KEY") -> dict[int, bytes]:
    """Return a ``{version: key_bytes}`` mapping for *field*.

    Scans ``{env_prefix}_{FIELD}_V1``, ``_V2``, … stopping at the first gap.
    Raises ``ImproperlyConfigured`` if no keys are found.

    Parameters
    ----------
    field:
        Upper-case field identifier, e.g. ``'USER_EMAIL'``, ``'USER_PHONE'``.
    env_prefix:
        Environment variable prefix — defaults to ``SYNTEK_FIELD_KEY``.
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
singleton. Service methods pass `active_key(...)` to `encrypt_field` and attempt decryption with
each version on failure until one succeeds or all are exhausted.

See [`how-to/src/CONTRIBUTING/KEY-ROTATION.md`](../../how-to/src/CONTRIBUTING/KEY-ROTATION.md) for
the full manual rotation procedure.

---

## Settings Required

Every module that uses encrypted fields must define two keys in its `SYNTEK_<MODULE>` settings dict,
both read from environment variables. The `cryptography` package (`cryptography>=42.0`) must be
listed in the app's Python dependencies.

```python
SYNTEK_PAYMENTS = {
    # 32-byte key for field encryption (AES-256-GCM via cryptography.hazmat)
    "FIELD_KEY": env("SYNTEK_PAYMENTS_FIELD_KEY"),

    # 32-byte key for HMAC lookup tokens (only needed when unique fields exist)
    "FIELD_HMAC_KEY": env("SYNTEK_PAYMENTS_FIELD_HMAC_KEY"),
}
```

`FIELD_KEY` and `FIELD_HMAC_KEY` **must be different keys**. Using the same key for both encryption
and HMAC is a cryptographic mistake.

Minimum lengths validated at startup (`AppConfig.ready()`):

| Setting          | Minimum  | Why                            |
| ---------------- | -------- | ------------------------------ |
| `FIELD_KEY`      | 32 bytes | AES-256 requires a 256-bit key |
| `FIELD_HMAC_KEY` | 32 bytes | HMAC-SHA256 security margin    |

---

## Migrations

When adding encrypted fields to a new or existing model:

1. **Add** `EncryptedField` columns — no `unique=True`, no `db_index=True`.
2. **Add** `*_token` columns as `null=True` initially (no `unique` yet).
3. **RunPython** to backfill tokens for existing rows using `FIELD_HMAC_KEY`.
4. **AlterField** token columns to `null=False, unique=True` (or keep `null=True` for optional
   fields — PostgreSQL allows multiple `NULL` values under a `UNIQUE` constraint).
5. **AlterField** the encrypted columns to remove any `unique` / `db_index` that may have been set
   before the token pattern was applied.

See `code/src/backend/apps/users/migrations/0003_user_encrypted_unique_tokens.py` for the canonical
example.

---

## What Needs Encryption

Encrypt any field that, if read directly from the database, would cause a security or privacy
breach:

- **PII** — name, email, phone, address, national insurance number, date of birth, any government ID
- **Long-lived cryptographic secrets** — TOTP secrets, API keys, OAuth client secrets, webhook
  signing keys. These are random (not PII) but a DB read leaks them permanently, enabling ongoing
  attacks (e.g. a stolen TOTP secret allows MFA bypass indefinitely).
- **Session-adjacent secrets** — anything whose exposure allows account takeover

The test: _"If an attacker reads this value from a DB dump, what can they do?"_ If the answer is
"access accounts", "impersonate users", or "contact/identify someone", encrypt it.

## What Does NOT Need Encryption

Do not encrypt fields that are:

- **Non-sensitive flags and metadata** — `is_active`, `is_staff`, `created_at`, `updated_at`
- **Already hashed** — password hashes, backup code hashes (`code_hash`) — hashing is
  non-reversible; there is no plaintext to protect. Do not double-encrypt hashed values.
- **Short-lived single-use tokens** — JWT JTIs (used only for revocation lookups), email
  verification tokens (expire within minutes/hours and are single-use). These are high-entropy and
  become worthless shortly after creation, so the risk window of a DB read is minimal. They do still
  get HMAC token companions for lookup purposes.
- **Foreign keys** — encrypt the referenced row's PII, not the FK integer
- **Enum / choice fields** — `code_type`, `status` — low cardinality, no sensitive information

**Key distinction — random is not the same as safe:** A value being cryptographically random does
not make it safe to store as plaintext. A TOTP secret is random, but it is also long-lived and its
exposure enables indefinite MFA bypass. Randomness speaks to unpredictability; encryption at rest
speaks to what happens if the database is compromised. Ask the consequence question, not the
derivation question.

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
- [ ] Tests set `FIELD_HMAC_KEY` in the conftest `SYNTEK_<MODULE>` dict
