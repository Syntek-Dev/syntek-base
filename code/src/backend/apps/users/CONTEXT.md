# code/src/backend/apps/users

The `users` Django application. Owns the custom `AUTH_USER_MODEL` with Fernet-encrypted PII fields.

## Directory Tree

```text
apps/users/
├── __init__.py
├── apps.py                  ← UsersConfig (BigAutoField default)
├── migrations/              ← auto-generated Django migrations
│   ├── __init__.py
│   └── 0001_initial.py      ← creates the custom User table with encrypted fields
└── models/
    ├── __init__.py
    └── user.py              ← custom User extending AbstractUser
```

## Key Files

| File                         | Purpose                                                    |
| ---------------------------- | ---------------------------------------------------------- |
| `models/user.py`             | `User(AbstractUser)` — PII fields Fernet-encrypted at rest |
| `migrations/0001_initial.py` | Initial migration creating the `users_user` table          |
| `apps.py`                    | Django app config (`name = "apps.users"`)                  |

## User Model

`User` extends `django.contrib.auth.models.AbstractUser`. Key decisions:

- `username` and `password` remain plaintext — required by the auth backend.
- `first_name`, `last_name`, and `email` use `EncryptedCharField` / `EncryptedEmailField`.
- Argon2 is the password hasher (`PASSWORD_HASHERS` in `settings/base.py`).
- `AUTH_USER_MODEL = "users.User"` is set globally in `settings/base.py`.

## Conventions

- Additional user-related models (profiles, roles) go in `models/` and are exported from
  `models/__init__.py`.
- No RLS on the `users_user` table — the auth backend queries it before session context is set.
- Future RBAC/ABAC group assignments are added via a data migration, not the initial migration.

## Cross-references

- `code/src/backend/apps/core/encryption.py` — `EncryptedCharField` implementation
- `code/src/backend/config/settings/CONTEXT.md` — `AUTH_USER_MODEL`, `PASSWORD_HASHERS`
- `code/docs/SECURITY.md` — authentication and IDOR requirements
