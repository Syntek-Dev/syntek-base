---
type: guide
skills: [gdpr-mechanics, stack-django]
model: opus
---

# Encryption Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

**Applies to:** `code/src/django/apps/` **Reference implementation:**
`code/src/django/apps/users/`
**Claude Model:** opus — Field-level PII encryption, Fernet, key management, lookup tokens

Field-level encryption patterns for Django models. Covers the
zero-plaintext guarantee, EncryptedField usage, encryption/decryption helpers, unique field
lookup tokens, versioned key management, and migration patterns.

> **Algorithm in this stack:** PII `EncryptedField`s (`apps.core.encryption`) use **Fernet**
> (authenticated AES-128-CBC + HMAC). **AES-256-GCM** is used **only** by the MFA service layer
> (`apps/users/services/mfa_encryption.py`). Email lookup tokens are a **keyed HMAC-SHA3-256**
> blind index from the shared `apps.core.crypto.make_email_token` helper. The generic
> `encrypt_field(...)` / AES-256-GCM examples in `FIELD-ENCRYPTION.md` describe the portable
> service-layer pattern, not the Fernet field implementation actually wired into `apps/core`.

## Sub-documents

| Document                                                           | Covers                                                                                                                                                                                                         |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`encryption/FIELD-ENCRYPTION.md`](encryption/FIELD-ENCRYPTION.md) | Zero-plaintext guarantee, EncryptedField rules, write/read paths, individual and batch helpers, settings required, versioned key approach, migrations, what to encrypt / what not to encrypt, quick checklist  |
| [`encryption/LOOKUP-TOKENS.md`](encryption/LOOKUP-TOKENS.md)       | Unique field problem with Fernet, keyed HMAC-SHA3-256 blind index, shared `apps.core.crypto` helper, `*_token` companion column pattern, token generation, normalisation rules, DB lookup patterns, key naming |

_Part of the `code/docs/` documentation family._
