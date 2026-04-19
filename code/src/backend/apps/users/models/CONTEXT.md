# code/src/backend/apps/users — models

Model definitions for the `users` app.

## Directory Tree

```text
apps/users/models/
├── __init__.py              ← exports User
└── user.py                  ← custom User model extending AbstractUser
```

## Models

| Model  | Table        | Description                                       |
| ------ | ------------ | ------------------------------------------------- |
| `User` | `users_user` | Custom auth user with Fernet-encrypted PII fields |

## Conventions

- All new models in this package must be exported from `__init__.py`.
- PII fields (name, email, address, phone) must use `EncryptedCharField` or `EncryptedEmailField`
  from `apps.core.encryption`.
- Each model must have `db_table_comment` on its `Meta` class documenting encryption and any RLS
  decisions.

## Cross-references

- `code/src/backend/apps/users/CONTEXT.md` — users app overview
- `code/src/backend/apps/core/encryption.py` — field encryption implementation
- `code/docs/DATA-STRUCTURES.md` — model design conventions
- `code/docs/SECURITY.md` — PII handling requirements
