# api/auth

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Structure

```text
auth/
├── CONTEXT.md
├── login.bru                   # POST /auth/login — valid credentials
├── login_invalid_password.bru  # POST /auth/login — invalid credentials (expect 401)
└── refresh_token.bru           # POST /auth/refresh — JWT token refresh
```

---

## Purpose

Bruno authentication request templates. Tests the login and token refresh endpoints for the project's Django JWT auth setup.

---

## Notes

- Parent: `../CONTEXT.md`
- `login.bru` (seq 1) stores `auth_token` via `bru.setVar` — all bearer-auth requests in other folders depend on this running first
- Adjust endpoint paths (`/auth/login`, `/auth/refresh`) to match the project's URL configuration
