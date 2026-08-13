---
type: guide
skills: [test-writer, stack-django, stack-htmx-templates]
model: opus
---

# Testing — Taxonomy, Checklist, Matrix, and Running Tests

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Test type taxonomy, checklist, coverage matrix, running test suites

---

## Testing Taxonomy

### Functional & Behavioural

| Type                 | Purpose                                                  | Tools                          | When          |
| -------------------- | -------------------------------------------------------- | ------------------------------ | ------------- |
| **Unit**             | Single function/class in isolation                       | pytest                         | Always        |
| **Integration**      | Multiple real components together (real DB, real queues) | pytest-django + testcontainers | Per module    |
| **E2E**              | Full user journey via browser                            | pytest-playwright              | Explicit only |
| **Regression**       | Existing features don't break after changes              | Full CI suite                  | Every PR      |
| **Smoke**            | Critical paths work after a deploy                       | Subset of E2E                  | Post-deploy   |
| **Acceptance (UAT)** | Validates against user story acceptance criteria         | Manual + Playwright            | Per story     |

### Non-Functional

| Type            | Purpose                                         | Tools      | When               |
| --------------- | ----------------------------------------------- | ---------- | ------------------ |
| **Performance** | Response times and throughput under normal load | k6, Locust | Milestone releases |
| **Load**        | Behaviour under expected peak traffic           | k6         | Pre-production     |

### Security

| Type                       | Purpose                                            | Tools               | When            |
| -------------------------- | -------------------------------------------------- | ------------------- | --------------- |
| **Auth/authorisation**     | Access controls enforced correctly                 | pytest              | Every module    |
| **Input sanitisation**     | SQL injection, input validation, command injection | pytest + hypothesis | Every API layer |
| **Vulnerability scanning** | Known CVEs in dependencies                         | `audit-deps.yml`    | Scheduled (CI)  |
| **Penetration testing**    | Simulated attacks on the system                    | Manual / OWASP ZAP  | Pre-release     |

### UX & Accessibility

| Type                     | Purpose                                  | Tools                                  | When          |
| ------------------------ | ---------------------------------------- | -------------------------------------- | ------------- |
| **Accessibility (a11y)** | WCAG 2.2 AA compliance                   | axe-core, Lighthouse, Playwright + axe | All web pages |
| **Cross-browser**        | Consistent behaviour across environments | Playwright (Chromium, Firefox, WebKit) | Web layer     |

---

## Backend & API Testing Checklist

Use this checklist when writing tests for any Django module or Django Ninja endpoint.

### Data Layer

- [ ] **Model validation** — field constraints, custom `clean()` methods, `unique` constraints
- [ ] **Database integrity** — FK cascades, `null=False` violations, transaction rollback on failure
- [ ] **Migrations** — apply cleanly against an empty schema; no data loss on existing rows
- [ ] **Query correctness** — ORM queries return expected results; no N+1 (`CaptureQueriesContext`)

### API Contract

- [ ] **Schema correctness** — Django Ninja routers, request/response `Schema` models, and endpoints match the spec
- [ ] **Request/response shape** — correct fields returned; no unexpected extras
- [ ] **Input validation** — the Ninja request `Schema` (Pydantic) rejects malformed bodies with `422` before the handler runs

### Authentication & Authorisation

- [ ] **Unauthenticated requests** — properly rejected (`401`) with a consistent JSON error shape
- [ ] **Role/permission enforcement** — users can only access what their role permits
- [ ] **Object-level permissions** — user A cannot access user B's data (`403`, no IDOR)

### Input Handling

- [ ] **Validation errors** — malformed input returns a consistent JSON error (Ninja `422`)
- [ ] **Injection** — SQL and command injection confirmed blocked; ORM parametrisation verified
- [ ] **Boundary values** — max string lengths, number ranges, empty strings

### Business Logic

- [ ] **Service layer / domain logic** — isolated from the HTTP layer and tested independently
- [ ] **Side effects** — emails sent, audit logs written correctly
- [ ] **Idempotency** — repeat requests don't duplicate data
- [ ] **State transitions** — objects move through valid states only

### Error Handling

- [ ] **Expected errors** — `400`/`404`/`403`/`409` returned with a consistent error shape
- [ ] **Unexpected errors** — 500s don't leak stack traces or sensitive data
- [ ] **Partial failure** — verify DB state when an endpoint fails mid-way

### Observability

- [ ] **Logging** — correct events logged at correct levels
- [ ] **Audit trails** — sensitive actions recorded (required for GDPR compliance)

---

## Testing Matrix

| Layer                                | Unit / Integration                | E2E / Browser | Framework                                                |
| ------------------------------------ | --------------------------------- | ------------- | -------------------------------------------------------- |
| Python / Django                      | pytest + factory_boy + hypothesis | —             | pytest-django, compose-managed PostgreSQL                |
| Django Ninja API (Python)            | pytest                            | —             | pytest-django + `ninja.testing.TestClient` / test client |
| Templates, components, HTMX partials | pytest (Django test client)       | —             | pytest-django                                            |
| API (HTTP layer)                     | Bruno collection                  | —             | Bruno CLI, environments/local.env                        |
| PostgreSQL                           | pytest transactional fixtures     | —             | compose-managed postgres:18-alpine                       |
| a11y                                 | pytest assertions on markup       | axe-core      | pytest-django; `axe-core-python` in the browser suite    |
| Responsive overflow                  | —                                 | Playwright    | `pytest-playwright` (measured, never screenshot-diffed)  |
| Mutation                             | mutmut                            | —             | mutmut (Python)                                          |

**One browser driver, in Python.** The E2E column is `pytest-playwright`, not a Node runner —
there is no JavaScript test path in this stack. The browser suite is deliberately small: it covers
only what needs computed layout, resolved CSS, or executed JavaScript. Everything else is cheaper
through the Django test client (`code/docs/testing/FRONTEND-TESTING.md`).
See `code/src/django/tests/e2e/CONTEXT.md`.

---

## Running Tests

All tests run inside Docker containers via the scripts in `code/src/scripts/tests/`. Never invoke
`pytest` directly on the host machine.

```bash
# Start the test stack (required for the backend scripts)
bash code/src/scripts/tests/server.sh up

# Type-check and lint before running tests
./code/src/scripts/syntax/check.sh

# Backend — full suite (includes template, component, and HTMX-partial tests)
./code/src/scripts/tests/backend.sh

# Backend — unit tests only / integration tests only / parallel / with coverage
./code/src/scripts/tests/backend.sh -m unit
./code/src/scripts/tests/backend.sh -m integration
./code/src/scripts/tests/backend.sh -n auto
./code/src/scripts/tests/backend-coverage.sh

# API (Bruno HTTP tests against the Ninja JSON API) — requires dev stack running
./code/src/scripts/tests/api.sh

# Backend + API
./code/src/scripts/tests/all.sh --api

# Browser e2e — needs the dev stack up, never runs as part of the ordinary suite
bash code/src/scripts/development/server.sh up
./code/src/scripts/tests/e2e-py.sh
```

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
