# Testing Guide — syntek-website

**Last Updated**: 18/04/2026\
**Version**: 1.0.0\
**Language**: British English (en_GB)\
**Timezone**: Europe/London

---

## Table of Contents

- [Testing Taxonomy](#testing-taxonomy)
- [Backend & API Testing Checklist](#backend--api-testing-checklist)
- [Testing Matrix](#testing-matrix)
- [Running Tests](#running-tests)
- [Python / Django](#python--django)
- [TypeScript / React](#typescript--react)
- [GraphQL](#graphql)
- [Database Isolation](#database-isolation)
- [Test Data and Factories](#test-data-and-factories)
- [Property-Based Testing with Hypothesis](#property-based-testing-with-hypothesis)
- [Security Testing](#security-testing)
- [Performance & Load Testing](#performance--load-testing)
- [Accessibility Testing](#accessibility-testing)
- [Contract Testing](#contract-testing)
- [Mutation Testing](#mutation-testing)
- [Coverage Thresholds](#coverage-thresholds)
- [Rules and Principles](#rules-and-principles)

---

## Testing Taxonomy

Testing types used across this project, grouped by category.

### Functional & Behavioural

| Type                 | Purpose                                                  | Tools                          | When          |
| -------------------- | -------------------------------------------------------- | ------------------------------ | ------------- |
| **Unit**             | Single function/class in isolation                       | pytest, Vitest                 | Always        |
| **Integration**      | Multiple real components together (real DB, real queues) | pytest-django + testcontainers | Per module    |
| **E2E**              | Full user journey via browser                            | Playwright                     | Explicit only |
| **Regression**       | Existing features don't break after changes              | Full CI suite                  | Every PR      |
| **Smoke**            | Critical paths work after a deploy                       | Subset of E2E                  | Post-deploy   |
| **Acceptance (UAT)** | Validates against user story acceptance criteria         | Manual + Playwright            | Per story     |

### Non-Functional

| Type            | Purpose                                         | Tools      | When               |
| --------------- | ----------------------------------------------- | ---------- | ------------------ |
| **Performance** | Response times and throughput under normal load | k6, Locust | Milestone releases |
| **Load**        | Behaviour under expected peak traffic           | k6         | Pre-production     |

### Security

| Type                       | Purpose                               | Tools                     | When            |
| -------------------------- | ------------------------------------- | ------------------------- | --------------- |
| **Auth/authorisation**     | Access controls enforced correctly    | pytest, Vitest            | Every module    |
| **Input sanitisation**     | SQL, GraphQL depth, command injection | pytest + hypothesis       | Every API layer |
| **Vulnerability scanning** | Known CVEs in dependencies            | `pip-audit`, `pnpm audit` | Every PR (CI)   |
| **Penetration testing**    | Simulated attacks on the system       | Manual / OWASP ZAP        | Pre-release     |

### UX & Accessibility

| Type                     | Purpose                                  | Tools                                  | When           |
| ------------------------ | ---------------------------------------- | -------------------------------------- | -------------- |
| **Accessibility (a11y)** | WCAG 2.2 AA compliance                   | axe-core, Lighthouse, Playwright + axe | All web pages  |
| **Cross-browser**        | Consistent behaviour across environments | Playwright (Chromium, Firefox, WebKit) | Web layer      |
| **Snapshot**             | Catch unintended UI/output changes       | Vitest snapshots                       | Web components |

---

## Backend & API Testing Checklist

Use this checklist when writing tests for any Django module or GraphQL API. Every item must be
covered before a module is considered production-ready.

### Data Layer

- [ ] **Model validation** — field constraints, custom `clean()` methods, `unique` constraints
- [ ] **Database integrity** — FK cascades, `null=False` violations, transaction rollback on failure
- [ ] **Migrations** — apply cleanly against an empty schema; no data loss on existing rows
- [ ] **Query correctness** — ORM queries return expected results; no N+1 (use
      `CaptureQueriesContext`)
- [ ] **Ordering & pagination** — consistent results across pages; default ordering defined

### API Contract

- [ ] **Schema correctness** — GraphQL types, resolvers, and mutations match the spec
- [ ] **Request/response shape** — correct fields returned; no unexpected extras; no missing
      required fields
- [ ] **Null & optional field handling** — nullable vs non-nullable fields behave correctly
- [ ] **GraphQL depth/complexity** — queries beyond configured depth/complexity are rejected

### Authentication & Authorisation

- [ ] **Unauthenticated requests** — properly rejected with a consistent error shape
- [ ] **Role/permission enforcement** — users can only access what their role permits
- [ ] **Token handling** — expiry, refresh, revocation (where applicable)
- [ ] **Object-level permissions** — user A cannot access user B's data (no IDOR)

### Input Handling

- [ ] **Validation errors** — malformed input returns helpful, consistent error responses
- [ ] **Injection** — SQL, GraphQL query depth/complexity attacks confirmed blocked
- [ ] **Boundary values** — max string lengths, number ranges, empty strings
- [ ] **Type coercion** — unexpected types handled gracefully, not silently cast

### Business Logic

- [ ] **Service layer / domain logic** — isolated from the HTTP layer and tested independently
- [ ] **Side effects** — emails sent, audit logs written correctly
- [ ] **Idempotency** — repeat requests don't duplicate data
- [ ] **State transitions** — objects move through valid states only; invalid transitions rejected

### Error Handling

- [ ] **Expected errors** — 400/404/403/409 returned with a consistent error shape
- [ ] **Unexpected errors** — 500s don't leak stack traces or sensitive data
- [ ] **Partial failure** — verify DB state when a mutation fails mid-way

### Performance & Reliability

- [ ] **Query performance** — `select_related`/`prefetch_related` used where needed; query count
      verified
- [ ] **Concurrency** — race conditions on shared resources handled correctly
- [ ] **Rate limiting** — endpoints reject abuse appropriately
- [ ] **Timeouts** — long-running requests fail gracefully

### Integration Points

- [ ] **Third-party services** — mocked in unit tests; tested against sandboxes in integration
- [ ] **Background tasks** — Celery tasks execute correctly and handle failure/retry
- [ ] **Webhooks** — inbound payloads validated and processed correctly

### Observability

- [ ] **Logging** — correct events logged at correct levels (`DEBUG`, `INFO`, `WARNING`, `ERROR`)
- [ ] **Audit trails** — sensitive actions recorded (required for GDPR compliance)
- [ ] **Health check endpoints** — return accurate status

---

## Testing Matrix

| Layer               | Unit / Integration                | E2E / Browser    | Framework                                   |
| ------------------- | --------------------------------- | ---------------- | ------------------------------------------- |
| Python / Django     | pytest + factory_boy + hypothesis | —                | pytest-django, compose-managed PostgreSQL   |
| GraphQL (Python)    | pytest                            | —                | pytest-django + Strawberry test client      |
| Web (React/TS)      | Vitest + RTL + MSW                | playwright-bdd   | vitest, @testing-library/react, msw         |
| GraphQL (TS client) | Vitest + MSW                      | —                | vitest, msw                                 |
| PostgreSQL          | pytest transactional fixtures     | —                | compose-managed postgres:18-alpine          |
| Contract            | —                                 | —                | Pact (GraphQL schema changes)               |
| a11y                | axe-core                          | Playwright + axe | @axe-core/react, playwright-axe             |
| Mutation            | mutmut                            | Stryker          | mutmut (Python), @stryker-mutator/core (TS) |

---

## Running Tests

All tests run inside Docker containers via the scripts in `code/src/scripts/tests/`. Never invoke
`pytest`, `pnpm`, or `next` directly on the host machine.

```bash
# Start the test stack (required for backend and E2E scripts)
docker compose -f code/src/docker/docker-compose.test.yml up -d

# Backend — full suite
./code/src/scripts/tests/backend.sh

# Backend — unit tests only
./code/src/scripts/tests/backend.sh -m unit

# Backend — integration tests only
./code/src/scripts/tests/backend.sh -m integration

# Backend — with coverage report
./code/src/scripts/tests/backend-coverage.sh

# Frontend — full suite (one-shot, no persistent container required)
./code/src/scripts/tests/frontend.sh

# Frontend — with coverage
./code/src/scripts/tests/frontend-coverage.sh

# Frontend — watch mode (interactive)
docker compose -f code/src/docker/docker-compose.test.yml run --rm \
  frontend-test pnpm test:watch

# E2E (playwright-bdd) — explicit only, never runs automatically
./code/src/scripts/tests/e2e.sh

# Both suites (no E2E)
./code/src/scripts/tests/all.sh
```

---

## Python / Django

**Tools:** pytest-django, factory_boy, pytest-cov, hypothesis

Tests live in `code/src/backend/apps/<app>/tests/`. Each app has a `tests/` directory containing
unit tests, integration tests, and fixtures. The Django settings used during testing are in
`code/src/backend/config/settings/test.py`.

### pytest configuration

```toml
# code/src/backend/pyproject.toml
[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = "config.settings.test"
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
markers = [
    "unit: pure unit tests with no DB access",
    "integration: tests that require a real database",
    "e2e: end-to-end browser tests",
]
```

### pytest-django fixture example

```python
# code/src/backend/apps/users/tests/test_user_service.py
import pytest

from apps.users.services import create_user


@pytest.mark.django_db
def test_create_user_sets_unusable_password_when_none_given() -> None:
    user = create_user(email="alice@example.com", password=None)

    assert user.pk is not None
    assert not user.has_usable_password()
```

### PostgreSQL 18 via Docker Compose

Integration tests use the real `postgres:18-alpine` instance managed by
`docker-compose.test.yml` (database `syntek_website_test`). No testcontainers or external setup
required — start the test stack and the database is ready.

`@pytest.mark.django_db` wraps each test in a transaction that is rolled back on exit, keeping
the database clean between tests. For tests that need to verify committed state (e.g. audit log
inspection), use `@pytest.mark.django_db(transaction=True)`.

### factory_boy example

```python
# code/src/backend/apps/users/tests/factories.py
import factory
from django.contrib.auth import get_user_model


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = get_user_model()

    email = factory.Sequence(lambda n: f"user{n}@example.com")
    password = factory.PostGenerationMethodCall("set_password", "secret-password-123")
    is_active = True
```

---

## TypeScript / React

**Tools:** Vitest, React Testing Library, MSW, Playwright

Tests live alongside source files in `code/src/frontend/src/`. E2E tests are in
`code/src/frontend/e2e/`. The Vitest configuration is at `code/src/frontend/vitest.config.ts`.

```bash
# Unit + integration (watch mode inside container)
docker compose exec frontend pnpm test --watch

# Coverage report
docker compose exec frontend pnpm test -- --coverage

# E2E (explicit only)
docker compose exec frontend pnpm test:e2e
```

### Vitest component test example

```typescript
// code/src/frontend/src/components/auth/LoginForm.test.tsx
import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

import { LoginForm } from "./LoginForm";

describe("LoginForm", () => {
  it("calls onSubmit with email and password when the form is submitted", async () => {
    const onSubmit = vi.fn();
    render(<LoginForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByLabelText("Email address"), {
      target: { value: "alice@example.com" },
    });
    fireEvent.change(screen.getByLabelText("Password"), {
      target: { value: "secret123" },
    });
    fireEvent.click(screen.getByRole("button", { name: /sign in/i }));

    expect(onSubmit).toHaveBeenCalledWith({
      email: "alice@example.com",
      password: "secret123",
    });
  });
});
```

### MSW for GraphQL mocking

Define handlers in `code/src/frontend/src/graphql/msw/handlers.ts`:

```typescript
// code/src/frontend/src/graphql/msw/handlers.ts
import { graphql, HttpResponse } from "msw";

export const handlers = [
  graphql.mutation("Login", () => {
    return HttpResponse.json({
      data: {
        login: { token: "test-token", user: { id: "1", email: "alice@example.com" } },
      },
    });
  }),

  graphql.query("Me", () => {
    return HttpResponse.json({
      data: { me: { id: "1", email: "alice@example.com" } },
    });
  }),
];
```

Set up MSW in the Vitest global setup:

```typescript
// code/src/frontend/src/test/setup.ts
import { server } from "./msw-server";
import "@testing-library/jest-dom/vitest";

beforeAll(() => server.listen({ onUnhandledRequest: "error" }));
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

---

## BDD — playwright-bdd (E2E acceptance tests)

BDD is used only at the E2E acceptance layer. Backend unit/integration tests and frontend
component tests are TDD only — RTL is already behaviour-driven by design.

**Where BDD lives:**

```text
code/src/frontend/
├── playwright.config.ts          ← playwright-bdd config
└── e2e/
    ├── features/                 ← Gherkin .feature files (one per user story / flow)
    │   └── auth/
    │       └── login.feature
    └── steps/                    ← TypeScript step definitions (Playwright API)
        └── auth.steps.ts
```

Feature files map 1:1 to `project-management/src/STORIES/US###.md` acceptance criteria.

### Feature file format

```gherkin
# code/src/frontend/e2e/features/auth/login.feature
Feature: User login

  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter "alice@example.com" and my correct password
    And I click "Sign in"
    Then I should see the dashboard

  Scenario: Login rejected with incorrect password
    Given I am on the login page
    When I enter "alice@example.com" and an incorrect password
    And I click "Sign in"
    Then I should see an error message "Invalid credentials"
```

### Step definition format

```typescript
// code/src/frontend/e2e/steps/auth.steps.ts
import { Given, When, Then } from "playwright-bdd";

Given("I am on the login page", async ({ page }) => {
  await page.goto("/login");
});

When("I enter {string} and my correct password", async ({ page }, email: string) => {
  await page.getByLabel("Email address").fill(email);
  await page.getByLabel("Password").fill(process.env.E2E_TEST_PASSWORD!);
});

When("I click {string}", async ({ page }, label: string) => {
  await page.getByRole("button", { name: label }).click();
});

Then("I should see the dashboard", async ({ page }) => {
  await page.waitForURL("/dashboard");
});

Then("I should see an error message {string}", async ({ page }, message: string) => {
  await expect(page.getByRole("alert")).toContainText(message);
});
```

### Running E2E tests

```bash
# Local — requires full test stack running
./code/src/scripts/tests/e2e.sh

# Filter by scenario name
./code/src/scripts/tests/e2e.sh --grep "User login"

# CI — trigger manually via GitHub Actions → test-e2e → Run workflow
```

E2E tests connect to `http://localhost` (nginx port 80 in the test compose stack). They are
**never triggered automatically** on push or PR — always explicit only.

---

## GraphQL

### Python (Strawberry) — pytest

Use the Strawberry `Client` to test the schema directly without an HTTP layer:

```python
# code/src/backend/apps/users/tests/test_auth_schema.py
import pytest
from strawberry.test import Client

from apps.core.schema import schema


@pytest.mark.django_db
def test_login_mutation_returns_token(user_factory) -> None:
    user_factory(email="alice@example.com")
    client = Client(schema)

    result = client.execute(
        """
        mutation Login($email: String!, $password: String!) {
          login(email: $email, password: $password) {
            token
          }
        }
        """,
        variables={"email": "alice@example.com", "password": "secret-password-123"},
    )

    assert result.errors is None
    assert result.data["login"]["token"] is not None


@pytest.mark.django_db
def test_login_mutation_rejected_for_unknown_email() -> None:
    client = Client(schema)

    result = client.execute(
        """
        mutation Login($email: String!, $password: String!) {
          login(email: $email, password: $password) {
            token
          }
        }
        """,
        variables={"email": "nobody@example.com", "password": "wrong"},
    )

    assert result.errors is not None
```

### TypeScript (Apollo Client) — Vitest + MSW

Component-level GraphQL tests intercept network requests via MSW. Use overrides in individual test
files for edge cases:

```typescript
// code/src/frontend/src/components/auth/LoginForm.test.tsx
import { graphql, HttpResponse } from "msw";
import { server } from "../../test/msw-server";

it("shows an error message when login fails", async () => {
  server.use(
    graphql.mutation("Login", () => {
      return HttpResponse.json({
        errors: [{ message: "Invalid credentials" }],
      });
    }),
  );

  render(<LoginForm onSubmit={vi.fn()} />);
  // … interact and assert error message appears …
});
```

---

## Database Isolation

- **Python integration tests:** use `@pytest.mark.django_db` (default in pytest-django). Each
  test runs in a transaction that is rolled back after the test, leaving the DB in a clean state.
- **Testcontainers:** spin up an ephemeral PostgreSQL 18 container per session for integration
  tests. Never point tests at the dev or production database.
- **TypeScript:** mock the data layer via MSW or `vi.mock()`. No real DB in unit or component
  tests.
- **E2E tests:** use a dedicated test database seeded before each Playwright run. The seed script
  is at `code/src/backend/scripts/seed_test_db.py`.

---

## Test Data and Factories

- **Python:** use `factory_boy` (`DjangoModelFactory`) for all model fixtures. Never build model
  instances inline across multiple tests — define a factory and reuse it.
- **TypeScript:** use plain builder functions in
  `code/src/frontend/src/test/builders/`. Each builder returns a typed object matching the
  GraphQL-generated types from `code/src/frontend/src/graphql/generated/`.
- **Avoid hardcoded IDs:** use `factory.Sequence` in Python and `crypto.randomUUID()` in
  TypeScript builders.

Example TypeScript builder:

```typescript
// code/src/frontend/src/test/builders/user.ts
import type { User } from "../../graphql/generated/types";

let counter = 0;

export function buildUser(overrides: Partial<User> = {}): User {
  counter += 1;
  return {
    id: String(counter),
    email: `user${counter}@example.com`,
    isActive: true,
    ...overrides,
  };
}
```

---

## Property-Based Testing with Hypothesis

Use `hypothesis` for any function that must hold across a wide range of inputs — especially
validators, data transformation functions, and serialisation logic.

`hypothesis` is declared as a test dependency in `code/src/backend/pyproject.toml` and is
available inside the container without any additional installation.

```python
# code/src/backend/apps/core/tests/test_validators.py
from hypothesis import given, settings
from hypothesis import strategies as st

from apps.core.validators import validate_slug


@given(slug=st.text(alphabet=st.characters(whitelist_categories=("Ll", "Nd"), whitelist_characters="-"), min_size=1, max_size=60))
@settings(max_examples=500)
def test_valid_slugs_are_accepted(slug: str) -> None:
    """validate_slug must not raise for any input that matches the allowed character set."""
    # Should return without raising
    validate_slug(slug)


@given(value=st.text(min_size=1, max_size=200))
@settings(max_examples=300)
def test_email_validator_never_raises_unexpectedly(value: str) -> None:
    """The validator must raise ValidationError or return None — never an unhandled exception."""
    from django.core.exceptions import ValidationError
    from django.core.validators import validate_email

    try:
        validate_email(value)
    except ValidationError:
        pass  # expected for invalid input
```

**Where to use Hypothesis:**

- Input validators — must never raise an unhandled exception; must return `None` or raise
  `ValidationError` only
- Data transformation and serialisation functions — idempotency, round-trip correctness
- Slug/URL normalisation — consistent output for any valid input
- GraphQL argument coercion edge cases

**Where NOT to use Hypothesis:**

- Tests that require database state (use `factory_boy` + pytest fixtures instead)
- E2E or integration tests (too slow for property-based iteration)

---

## Security Testing

### Input sanitisation (every API endpoint)

Every Django app that accepts user input must have negative tests for:

- SQL injection via ORM parametrisation (confirmed safely escaped via `str(queryset.query)` or
  query log inspection)
- GraphQL query depth attack — queries beyond `max_depth` are rejected with a clear error
- GraphQL complexity attack — queries exceeding `max_complexity` are rejected

```python
# code/src/backend/apps/core/tests/test_security.py
import pytest


@pytest.mark.parametrize("slug", [
    "'; DROP TABLE users --",
    "<script>alert(1)</script>",
    "../../../etc/passwd",
    "a" * 300,  # exceeds max field length
])
def test_invalid_slug_is_rejected(slug: str) -> None:
    from django.core.exceptions import ValidationError

    from apps.core.models import Page

    with pytest.raises((ValidationError, ValueError)):
        Page(slug=slug).full_clean()
```

### Authentication & authorisation (every GraphQL mutation)

Every mutation must have:

1. A test confirming unauthenticated requests are rejected
2. A test confirming the correct permission is required
3. A test confirming object-level permission (user A cannot act on user B's resources)

```python
# code/src/backend/apps/users/tests/test_auth_schema.py
import pytest
from strawberry.test import Client

from apps.core.schema import schema


@pytest.mark.django_db
def test_update_profile_requires_authentication() -> None:
    client = Client(schema)
    result = client.execute(
        'mutation { updateProfile(displayName: "Eve") { success } }'
    )
    assert result.errors is not None
    assert any("not authenticated" in str(e).lower() for e in result.errors)


@pytest.mark.django_db
def test_update_profile_cannot_modify_another_users_data(user_factory) -> None:
    alice = user_factory(email="alice@example.com")
    bob = user_factory(email="bob@example.com")
    client = Client(schema, context_value={"request": _mock_request(alice)})

    result = client.execute(
        'mutation { updateProfile(userId: "%s", displayName: "Hacked") { success } }' % bob.pk
    )

    assert result.errors is not None
```

### Dependency scanning (CI)

Run on every PR as part of CI:

```bash
# Python
pip-audit

# JavaScript
pnpm audit --audit-level moderate
```

---

## Performance & Load Testing

### Query count assertions (pytest-django)

Use `CaptureQueriesContext` to assert that no N+1 queries occur:

```python
# code/src/backend/apps/content/tests/test_queries.py
import pytest
from django.db import connection
from django.test.utils import CaptureQueriesContext

from apps.content.models import Article


@pytest.mark.django_db
def test_list_articles_no_n_plus_one(article_factory) -> None:
    article_factory.create_batch(10)

    with CaptureQueriesContext(connection) as ctx:
        list(Article.objects.select_related("author").prefetch_related("tags").all())

    assert len(ctx) <= 3, f"Expected ≤3 queries, got {len(ctx)}"
```

### k6 load tests (milestone releases only)

Load test scripts live in `code/docs/PERFORMANCE/`. Run against a staging environment only —
never against production or a local dev instance.

```bash
k6 run code/docs/PERFORMANCE/homepage.js
```

---

## Accessibility Testing

All Next.js pages and interactive components must pass WCAG 2.2 AA. Accessibility tests run
automatically in CI as part of the unit and E2E suites.

### axe-core in Vitest

```typescript
// code/src/frontend/src/components/forms/ContactForm.test.tsx
import { render } from "@testing-library/react";
import { axe, toHaveNoViolations } from "jest-axe";
import { describe, it, expect } from "vitest";

import { ContactForm } from "./ContactForm";

expect.extend(toHaveNoViolations);

describe("ContactForm accessibility", () => {
  it("has no WCAG 2.2 AA violations", async () => {
    const { container } = render(<ContactForm onSubmit={vi.fn()} />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

### Playwright + axe in E2E

```typescript
// code/src/frontend/e2e/accessibility.spec.ts
import { checkA11y } from "axe-playwright";
import { test } from "@playwright/test";

test("home page is accessible", async ({ page }) => {
  await page.goto("/");
  await checkA11y(page);
});

test("contact page is accessible", async ({ page }) => {
  await page.goto("/contact");
  await checkA11y(page);
});
```

---

## Contract Testing

Use [Pact](https://docs.pact.io/) to verify that GraphQL schema changes don't silently break the
TypeScript frontend.

- **Provider:** the Django/Strawberry GraphQL API (`code/src/backend/`)
- **Consumer:** the Apollo Client in the Next.js frontend (`code/src/frontend/src/graphql/`)

Pact tests live in `code/src/frontend/src/graphql/pact/`. Run them before any GraphQL schema
change is merged.

```bash
docker compose exec frontend pnpm test:pact
```

---

## Mutation Testing

Run mutation testing when coverage appears high but the tests feel weak — it confirms that tests
actually catch bugs rather than merely execute code.

### Python — mutmut

```bash
docker compose exec backend uv run mutmut run --paths-to-mutate apps/
docker compose exec backend uv run mutmut results
```

### TypeScript — Stryker

```bash
docker compose exec frontend pnpm stryker run
```

A mutation score below **80%** indicates tests that pass but do not assert on output — investigate
and strengthen before shipping.

---

## Coverage Thresholds

Every module must meet the following minimum coverage thresholds. CI enforces these — a PR that
drops any metric below the floor is blocked.

| Layer    | Metric            | Minimum | Notes                                       |
| -------- | ----------------- | ------- | ------------------------------------------- |
| Backend  | Line coverage     | 75%     | Hard floor — no exceptions                  |
| Backend  | Branch coverage   | 75%     | Both sides of every `if`/`else` exercised   |
| Backend  | Auth-related code | 90%     | `apps/users/` and any auth-adjacent service |
| Frontend | Line coverage     | 70%     | Hard floor — no exceptions                  |
| Frontend | Branch coverage   | 70%     | Both sides of every conditional exercised   |

> The floors are **minimums**, not targets. Aim higher. Auth-related code (`apps/users/`,
> permission checks, token handling) must maintain ≥ 90% line and branch coverage. A new file
> that brings any metric below its floor blocks the PR.

### Python — pytest-cov configuration

```toml
# code/src/backend/pyproject.toml
[tool.coverage.run]
source = ["apps"]
branch = true

[tool.coverage.report]
fail_under = 75
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "\\.\\.\\.",
]
omit = [
    "*/migrations/*",
    "*/tests/*",
    "*/__init__.py",
]
```

Running with the threshold enforced:

```bash
docker compose exec backend pytest --cov=apps --cov-fail-under=75 --cov-branch --cov-report=html
```

### TypeScript — Vitest coverage configuration

```typescript
// code/src/frontend/vitest.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      provider: "v8",
      include: ["src/**/*.{ts,tsx}"],
      exclude: ["src/**/*.test.{ts,tsx}", "src/graphql/generated/**", "src/test/**"],
      thresholds: {
        lines: 70,
        branches: 70,
        functions: 70,
        statements: 70,
      },
      reporter: ["text", "html", "lcov"],
    },
  },
});
```

### What counts towards coverage

All source files under `code/src/backend/apps/` and `code/src/frontend/src/` are included. The
following are excluded from the threshold calculation but still appear in the report:

- `migrations/` directories
- `tests/` directories (test code is not measured)
- `__init__.py` re-export files with no logic
- Auto-generated files (`code/src/frontend/src/graphql/generated/`)
- Lines explicitly marked `# pragma: no cover`

---

## Rules and Principles

1. Every new public function has at least one unit test.
2. Every GraphQL mutation/query has an integration test covering: the happy path, an auth failure,
   and at least one invalid input case.
3. Tests are deterministic — no real time, random values, or live network calls in unit tests.
4. Tests are independent — each test sets up its own state and does not rely on execution order.
5. Follow Arrange–Act–Assert in every test.
6. Test behaviour, not implementation details.
7. Unit tests complete in under 100 ms each.
8. Security-critical paths (auth, RBAC, permission enforcement, object-level ownership) must have
   negative tests that verify rejection of invalid or malicious input.
9. Test code is held to the same standard as production code — it is reviewed, maintained, and
   must be readable.
10. No N+1 queries — assert query count in any test that fetches a list of objects.
11. Every module that writes audit logs must have a test confirming the correct log entry is
    emitted (`caplog.messages`, not a mock call assertion).
12. Partial failure paths must have tests — verify DB state after a mid-mutation exception.
13. **Every file must contribute to meeting the coverage floor.** A new file with no tests, or
    tests that never exercise its branches, will drop the module below the threshold and block the
    PR. Write tests alongside new code, not after.
14. **Red phase = stubs, green phase = real code.** During the red phase, service stubs raise
    `NotImplementedError` and tests are expected to fail. A story is only in the green phase when
    every stub is replaced by a working implementation. Never close a story "green" while any
    implementation still raises `NotImplementedError`.
15. **Never mock module-level constants to make tests pass.** Using `patch` to replace a flag
    makes the test verify the mock, not the implementation. Fix the code so it works correctly;
    then the test will pass for the right reason.
16. **Test real outcomes, not mock call counts.** Log assertions must verify actual log content
    (`caplog.messages`), not that `logger.info` was called. DB assertions must query the database,
    not assert on mock return values. A test that only asserts `mock.assert_called_once()` with no
    outcome verification is a vacuous test.
