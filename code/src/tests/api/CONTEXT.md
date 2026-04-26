# tests/api — Bruno API Test Collection

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Structure

```text
api/
├── CONTEXT.md
├── bruno.json              # Bruno collection config: name, version, ignore patterns
├── template-test.bru       # Example/template request file for new collections
├── auth/                   # Authentication requests (login, refresh, invalid password)
├── environments/           # Environment variable files (local, staging, production)
├── orders/                 # Orders CRUD requests
├── performance/            # Load and stress test requests
└── users/                  # Users CRUD requests
```

---

## Purpose

Bruno API testing collection for this project. Run against a live backend to verify endpoint contracts, auth flows, and performance thresholds.

- **Local dev**: select the `local` environment (points to `http://localhost:8000`)
- **CI / staging**: select the `staging` environment
- **Manual production checks**: select the `production` environment

---

## What's Inside

| Entry               | Purpose                                                            |
| ------------------- | ------------------------------------------------------------------ |
| `bruno.json`        | Collection metadata                                                |
| `template-test.bru` | Annotated starter file — copy and rename when adding a new request |
| `auth/`             | Login, token refresh, and invalid-password test requests           |
| `environments/`     | `local.json`, `staging.json`, `production.json`, `variables.json`  |
| `orders/`           | CRUD requests for the orders resource                              |
| `performance/`      | Load test and stress test `.bru` files                             |
| `users/`            | CRUD requests for the users resource                               |

---

## Running Tests

```bash
# All tests against staging (Bruno CLI)
bruno run --env staging

# Single folder
bruno run auth/ --env local

# With JSON reporter (CI)
bruno run --env staging --reporter-json results.json
```

---

## Notes

- Parent: `../CONTEXT.md`
- Bruno collection format: plain `.bru` files, human-readable and version-control-friendly
- Never commit real credentials — use Bruno's secret variable feature or inject via CI environment
- `auth_token` is populated automatically by `auth/login.bru` (seq 1) and used by all subsequent bearer-auth requests
