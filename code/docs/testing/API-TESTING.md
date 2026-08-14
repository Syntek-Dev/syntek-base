---
type: guide
skills: [test-writer, stack-django, stack-htmx-templates]
model: opus
---

# Testing — API Testing (Django Ninja + Bruno)

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Django Ninja endpoint tests, input-validation & authorisation negatives, Bruno HTTP

The JSON API is built with Django Ninja: a `NinjaAPI` mounts one or more `Router`s, each endpoint
declares Pydantic `Schema` request/response models and an explicit per-endpoint auth. Ninja
auto-generates an OpenAPI document at `/api/docs`. This guide covers testing those endpoints in
pytest and over HTTP with Bruno. Nothing in this repository consumes these endpoints from the
browser — page interactions go through Django views and are covered in `FRONTEND-TESTING.md`.

---

## Django Ninja endpoint tests — pytest

Use `ninja.testing.TestClient` to exercise a router (its schemas, auth, and handler) directly
without a live HTTP server:

```python
import pytest
from ninja.testing import TestClient
from apps.users.api import router


@pytest.mark.django_db
def test_login_returns_token(user_factory) -> None:
    user_factory(email="alice@example.com")
    client = TestClient(router)

    response = client.post(
        "/login",
        json={"email": "alice@example.com", "password": "secret-password-123"},
    )

    assert response.status_code == 200
    assert response.json()["token"]


@pytest.mark.django_db
def test_login_rejects_unknown_email() -> None:
    client = TestClient(router)
    response = client.post(
        "/login",
        json={"email": "nobody@example.com", "password": "wrong"},
    )
    assert response.status_code == 401
```

For the full HTTP stack (middleware, CORS, real routing under the mounted prefix), use Django's
test client against the mounted API path, or Bruno (below).

---

## Input-validation negatives (Ninja `Schema` → `422`)

The request `Schema` validates the body before the handler runs. Every endpoint that accepts input
needs a test proving malformed bodies are rejected:

```python
@pytest.mark.django_db
def test_login_rejects_malformed_body() -> None:
    client = TestClient(router)
    response = client.post("/login", json={"email": "not-an-email"})  # password missing
    assert response.status_code == 422
    assert response.json()["detail"][0]["loc"][-1] == "password"
```

---

## Per-endpoint authorisation negatives

**Every state-changing Django Ninja endpoint needs an explicit permission check.** Prove it with
negative tests: unauthenticated callers are rejected, and no caller can act on another user's
resources (no IDOR).

```python
@pytest.mark.django_db
def test_update_profile_requires_authentication() -> None:
    client = TestClient(router)
    response = client.post("/profile", json={"display_name": "Eve"})
    assert response.status_code == 401


@pytest.mark.django_db
def test_user_cannot_edit_another_users_profile(user_factory, token_for) -> None:
    alice = user_factory()
    bob = user_factory()
    client = TestClient(router)

    response = client.put(
        f"/users/{bob.id}/profile",
        json={"display_name": "hijacked"},
        headers={"Authorization": f"Bearer {token_for(alice)}"},
    )
    assert response.status_code == 403  # IDOR blocked — object ownership verified
```

---

## Bruno API Tests (HTTP Layer)

Bruno tests live in `code/src/tests/api/` and exercise the Ninja JSON API over real HTTP —
running the full Django request/response cycle including middleware, authentication headers, CORS,
and error formatting. Bruno requests mirror the operations published in the OpenAPI document at
`/api/docs`.

These are distinct from pytest endpoint tests (which bypass the HTTP server). Both are required.

### When to run

- After any middleware, settings, or authentication change
- After any Ninja `Schema` or endpoint change that alters the public API
- Before every release, as part of the smoke test suite

### Running Bruno tests

```bash
./code/src/scripts/tests/api.sh
./code/src/scripts/tests/api.sh --collection auth
./code/src/scripts/tests/api.sh --reporter junit
```

### Collection structure

```text
code/src/tests/api/
├── CONTEXT.md
├── environments/
│   ├── local.env
│   └── staging.env
├── auth/
│   ├── login.bru
│   ├── refresh.bru
│   └── me.bru
└── users/
    └── update-profile.bru
```

### What every `.bru` file must assert

- [ ] HTTP status code — `200`/`201` on success; `422` for an invalid body; `401`/`403` for auth failures
- [ ] `Content-Type: application/json` header present
- [ ] Response body shape — required fields present on the happy path
- [ ] Error body — Ninja returns a JSON `detail` payload on failure, never an HTML error page
- [ ] Authentication failure returns a JSON error (`401`/`403`), not a Django HTML error page

### Difference from pytest endpoint tests

| Concern                         | pytest (`ninja.testing.TestClient`) | Bruno (HTTP)                   |
| ------------------------------- | ----------------------------------- | ------------------------------ |
| Endpoint / handler logic        | Yes                                 | Yes (indirectly)               |
| Django middleware               | No                                  | Yes                            |
| CORS and authentication headers | No                                  | Yes                            |
| Real HTTP status codes          | No                                  | Yes                            |
| Suitable for smoke tests        | No                                  | Yes (runs against any env URL) |

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
