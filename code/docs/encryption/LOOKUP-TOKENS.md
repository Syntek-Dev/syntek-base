---
type: guide
agent: gdpr
skills: [stack-django]
model: opus
---

# Encryption Guide — Lookup Tokens

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Keyed HMAC blind-index lookup tokens for encrypted fields

---

## Unique Fields — Lookup Tokens

PII fields are Fernet-encrypted (`EncryptedField`). Fernet embeds a timestamp + random IV, so the
same plaintext encrypted twice produces **different ciphertext**. A DB `UNIQUE` constraint on
ciphertext is therefore meaningless — the same email stored twice would pass the constraint
because its ciphertexts differ.

**Rule: every `EncryptedField` that must be unique (or GDPR-queryable) gets a companion `*_token`
column.** The token is a **keyed** HMAC-SHA3-256 of the normalised plaintext — a _blind index_. The
`UNIQUE` constraint goes on the token column, never on the ciphertext column.

### Keyed blind index — not a bare hash

A _bare_ `sha3_256(email)` digest is **precomputable**: an attacker with the database but not the
key can confirm a guessed email by hashing it. Keying the digest with a secret
(`LEGAL['FIELD_HMAC_KEY']`, env-only) makes the token non-precomputable.

Every email lookup token across every app that stores an encrypted email (e.g. `users`,
`marketing`, `legal`) is derived from the **single shared helper**
`apps.core.crypto.make_email_token`, so the construction (key + `strip().lower()` + `sha3_256`)
is byte-identical everywhere. This is the load-bearing invariant that lets cross-app GDPR erasure
and SAR export resolve every row by the identical token. Recomputing an existing column requires a
hand-authored `RunPython` data migration in each affected app that reads the decrypted email
through the field descriptor and routes it through the shared helper.

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
        help_text="Keyed HMAC-SHA3-256 of the normalised email address.",
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

Email tokens are generated from the **single shared helper** `apps.core.crypto.make_email_token`.
Do **not** reimplement the construction per module — import the shared helper so the key,
normalisation and algorithm stay byte-identical across every app. The key comes from
`settings.LEGAL['FIELD_HMAC_KEY']` (env-only). `apps.legal.services.lookup_tokens.make_email_token`
re-exports the shared helper for its historical import path.

```python
# code/src/django/apps/core/crypto.py
import hashlib
import hmac

from django.conf import settings
from django.core.exceptions import ImproperlyConfigured


def _email_hmac_key() -> bytes:
    cfg = getattr(settings, "LEGAL", {})
    key = cfg.get("FIELD_HMAC_KEY")
    if not key:
        raise ImproperlyConfigured("LEGAL['FIELD_HMAC_KEY'] must be set.")
    return key.encode() if isinstance(key, str) else bytes(key)


def make_email_token(email: str) -> str:
    """Keyed HMAC-SHA3-256 of the strip+lower-normalised email — a blind index."""
    return hmac.new(
        _email_hmac_key(), email.strip().lower().encode(), hashlib.sha3_256
    ).hexdigest()
```

For a **new** non-email unique field (e.g. phone), add a sibling helper alongside the email one in
`apps/core/crypto.py` rather than a per-module file, keeping a single source of truth.

### DB lookups — always use the token column

Never query against an encrypted column directly. Always use the token:

```python
# WRONG — ciphertext lookup, will never match
User.objects.filter(email__iexact=identifier)
User.objects.filter(email=identifier)

# CORRECT — token lookup via the shared helper
from apps.core.crypto import make_email_token
User.objects.filter(email_token=make_email_token(identifier))
```

### Write path with token

The model manager (or service layer) must compute the token and set both fields before `save()`:

```python
def create_record(email: str, ...) -> MyModel:
    from apps.core.crypto import make_email_token

    obj = MyModel(
        email=email,  # EncryptedField encrypts on save
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

All field-level encryption keys follow a strict naming pattern; keep the full reference in the
project's operational runbook. The key patterns are summarised here:

| Pattern                  | Format                                           | Example                                     | Use Case                                           |
| ------------------------ | ------------------------------------------------ | ------------------------------------------- | -------------------------------------------------- |
| **Legacy (deprecated)**  | `{{ENV_PREFIX}}_<MODULE>_FIELD_KEY`              | `{{ENV_PREFIX}}_AUTH_FIELD_KEY`             | Old deployments — upgrade via `migrate_field_keys` |
| **Per-field (standard)** | `{{ENV_PREFIX}}_<MODULE>_FIELD_KEY_{FIELD}`      | `{{ENV_PREFIX}}_AUTH_FIELD_KEY_EMAIL`       | All new modules                                    |
| **Per-field versioned**  | `{{ENV_PREFIX}}_<MODULE>_FIELD_KEY_V{N}_{FIELD}` | `{{ENV_PREFIX}}_AUTH_FIELD_KEY_V2_EMAIL`    | 90-day key rotation                                |
| **Batch group**          | `{{ENV_PREFIX}}_<MODULE>_FIELD_KEY_{GROUP}`      | `{{ENV_PREFIX}}_SHIPPING_FIELD_KEY_ADDRESS` | 3+ related fields                                  |
| **HMAC lookup**          | `{{ENV_PREFIX}}_{MODULE}_FIELD_HMAC_KEY`         | `{{ENV_PREFIX}}_AUTH_FIELD_HMAC_KEY`        | Unique field lookups                               |

_Part of the `code/docs/` documentation family. See [`../ENCRYPTION-GUIDE.md`](../ENCRYPTION-GUIDE.md) for the full index._
