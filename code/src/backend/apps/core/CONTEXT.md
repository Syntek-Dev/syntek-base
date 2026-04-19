# code/src/backend/apps/core

The `core` Django application. Owns the root Strawberry GraphQL schema and shared infrastructure —
field-level PII encryption and utilities consumed by all other apps.

## Directory Tree

```text
apps/core/
├── __init__.py
├── apps.py                  ← CoreConfig (BigAutoField default)
├── encryption.py            ← Fernet-based EncryptedCharField, EncryptedEmailField
├── migrations/              ← auto-generated Django migrations (empty — no models)
│   └── __init__.py
├── models/                  ← placeholder (no models in core yet)
│   └── __init__.py
└── schema.py                ← root Strawberry GraphQL schema (Query root)
```

## Key Files

| File            | Purpose                                                              |
| --------------- | -------------------------------------------------------------------- |
| `schema.py`     | Root `strawberry.Schema` — imported by `config/urls.py`              |
| `encryption.py` | `EncryptedCharField` and `EncryptedEmailField` for Fernet PII fields |
| `apps.py`       | Django app config (`name = "apps.core"`)                             |

## Encryption

`encryption.py` provides two custom model fields backed by symmetric Fernet encryption:

- `EncryptedCharField` — transparently encrypts/decrypts a `TextField` at rest.
- `EncryptedEmailField` — extends `EncryptedCharField` with email format validation.

The encryption key is read from `settings.ENCRYPTION_KEY`, set via the `ENCRYPTION_KEY`
environment variable. Ciphertext is URL-safe base64 — longer than plaintext, so `max_length`
is not enforced at the database level.

## GraphQL Schema

`schema.py` exports `schema`, the root `strawberry.Schema` mounted at `/graphql/` in
`config/urls.py`. Each app contributes types and resolvers composed here as the project grows.

## Cross-references

- `code/src/backend/apps/CONTEXT.md` — app registry and conventions
- `code/src/backend/config/settings/CONTEXT.md` — `ENCRYPTION_KEY` configuration
- `code/docs/API-DESIGN.md` — Strawberry GraphQL conventions
- `code/docs/SECURITY.md` — PII encryption and data protection requirements
