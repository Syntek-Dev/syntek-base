---
type: guide
skills: [gdpr-mechanics, stack-django]
model: opus
---

# Encryption Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

**Applies to:** `code/src/django/apps/`
**Claude Model:** opus — Field-level PII encryption, Fernet, key management, lookup tokens

Field-level encryption patterns for Django models. Covers the
zero-plaintext guarantee, EncryptedField usage, encryption/decryption helpers, unique field
lookup tokens, versioned key management, and migration patterns.

**Status: declared, not wired.** Nothing described here ships at baseline — `apps/core/` holds no
encryption or crypto module, and no other app defines one. What exists today is this contract, and
the first story handling PII builds to it.

> **Algorithm this project will use:** PII `EncryptedField`s (an `apps.core.encryption` module a
> story adds) use **Fernet** (authenticated AES-128-CBC + HMAC). **AES-256-GCM** is reserved for
> the MFA service layer. Email lookup tokens are a **keyed HMAC-SHA3-256** blind index from one
> shared `make_email_token` helper in the same app. The generic `encrypt_field(...)` /
> AES-256-GCM examples in `FIELD-ENCRYPTION.md` describe the portable service-layer pattern
> rather than the Fernet field, and the two are not interchangeable.

## Sub-documents

| Document                                                           | Covers                                                                                                                                                                                                        |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`encryption/FIELD-ENCRYPTION.md`](encryption/FIELD-ENCRYPTION.md) | Zero-plaintext guarantee, EncryptedField rules, write/read paths, individual and batch helpers, settings required, versioned key approach, migrations, what to encrypt / what not to encrypt, quick checklist |
| [`encryption/LOOKUP-TOKENS.md`](encryption/LOOKUP-TOKENS.md)       | Unique field problem with Fernet, keyed HMAC-SHA3-256 blind index, one shared crypto helper, `*_token` companion column pattern, token generation, normalisation rules, DB lookup patterns, key naming        |

_Part of the `code/docs/` documentation family._
