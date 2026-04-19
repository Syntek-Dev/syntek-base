# code/src/backend/config/settings

Environment-specific Django settings. Every environment file imports from `base.py` and overrides
only what it needs. The active module is selected via `DJANGO_SETTINGS_MODULE` injected by the
Docker environment file.

## Directory Tree

```text
config/settings/
├── __init__.py
├── base.py                  ← shared settings (all environments)
├── dev.py                   ← local development
├── production.py            ← production
├── staging.py               ← staging
└── test.py                  ← pytest-django test runner
```

## Settings Module Map

| File            | `DJANGO_SETTINGS_MODULE`     | Key Overrides                                           |
| --------------- | ---------------------------- | ------------------------------------------------------- |
| `base.py`       | _(never used directly)_      | `INSTALLED_APPS`, DB, auth, email — all shared settings |
| `dev.py`        | `config.settings.dev`        | `DEBUG=True`, `ALLOWED_HOSTS=["*"]`, localhost CORS     |
| `staging.py`    | `config.settings.staging`    | `DEBUG=False`, restricted `ALLOWED_HOSTS`               |
| `production.py` | `config.settings.production` | `DEBUG=False`, strict CORS, Sentry, Prometheus          |
| `test.py`       | `config.settings.test`       | Fast password hasher, in-memory cache, test DB URL      |

## Critical Settings (base.py)

| Setting                | Value                          | Notes                                           |
| ---------------------- | ------------------------------ | ----------------------------------------------- |
| `SECRET_KEY`           | `os.environ["SECRET_KEY"]`     | Required — fails to start if missing            |
| `ENCRYPTION_KEY`       | `os.environ["ENCRYPTION_KEY"]` | Fernet key for PII field encryption             |
| `AUTH_USER_MODEL`      | `"users.User"`                 | Custom user model — set before first migration  |
| `PASSWORD_HASHERS`     | `Argon2PasswordHasher`         | Argon2 is the primary hasher                    |
| `CORS_ALLOWED_ORIGINS` | `[]` in base (set per env)     | Never `["*"]` in staging or production          |
| `DEBUG`                | Absent from base               | Each env file reads it from the `DEBUG` env var |

## Rules

- `DEBUG` is intentionally absent from `base.py` — set it only in environment-specific files.
- `CORS_ALLOWED_ORIGINS` must be an explicit allowlist — never `["*"]` outside local dev.
- All secrets (`SECRET_KEY`, `ENCRYPTION_KEY`, database passwords) come from environment variables.
- New settings that differ per environment go in the environment file; shared settings go in `base.py`.

## Cross-references

- `code/src/docker/CONTEXT.md` — env files and `DJANGO_SETTINGS_MODULE` injection
- `code/docs/SECURITY.md` — security settings requirements
- `code/src/backend/apps/core/encryption.py` — `ENCRYPTION_KEY` usage
