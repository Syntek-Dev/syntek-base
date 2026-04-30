# Testing Guide — project-name

> **Agent hints — Model:** Sonnet · **MCP:** `code-review-graph`, `docfork` + `context7` (pytest, Vitest, Jest, Detox)

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
- [Compilation & Type-Checking](#compilation--type-checking)
- [Python / Django](#python--django)
- [TypeScript / React](#typescript--react)
- [Mobile (Expo / React Native)](#mobile-expo--react-native)
- [GraphQL](#graphql)
- [Bruno API Tests (HTTP Layer)](#bruno-api-tests-http-layer)
- [Database Isolation](#database-isolation)
- [Test Data and Factories](#test-data-and-factories)
- [Property-Based Testing with Hypothesis](#property-based-testing-with-hypothesis)
- [Security Testing](#security-testing)
- [Performance & Load Testing](#performance--load-testing)
- [Test Output & Readability](#test-output--readability)
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

| Layer                 | Unit / Integration                | E2E / Browser    | Framework                                   |
| --------------------- | --------------------------------- | ---------------- | ------------------------------------------- |
| Python / Django       | pytest + factory_boy + hypothesis | —                | pytest-django, compose-managed PostgreSQL   |
| GraphQL (Python)      | pytest                            | —                | pytest-django + Strawberry test client      |
| Web (React/TS)        | Vitest + RTL + MSW                | playwright-bdd   | vitest, @testing-library/react, msw         |
| GraphQL (TS client)   | Vitest + MSW                      | —                | vitest, msw                                 |
| Mobile (React Native) | Jest + RNTL + MSW                 | Detox (BDD)      | jest, @testing-library/react-native, detox  |
| API (HTTP layer)      | Bruno collection                  | —                | Bruno CLI, environments/local.env           |
| PostgreSQL            | pytest transactional fixtures     | —                | compose-managed postgres:18-alpine          |
| Contract              | —                                 | —                | Pact (GraphQL schema changes)               |
| a11y                  | axe-core                          | Playwright + axe | @axe-core/react, playwright-axe             |
| Mutation              | mutmut                            | Stryker          | mutmut (Python), @stryker-mutator/core (TS) |

---

## Running Tests

All tests run inside Docker containers via the scripts in `code/src/scripts/tests/`. Never invoke
`pytest`, `pnpm`, or `next` directly on the host machine.

```bash
# Start the test stack (required for backend, mobile, and E2E scripts)
docker compose -f code/src/docker/docker-compose.test.yml up -d

# Type-check and lint all layers before running tests
./code/src/scripts/syntax/check.sh

# Backend — full suite
./code/src/scripts/tests/backend.sh

# Backend — unit tests only
./code/src/scripts/tests/backend.sh -m unit

# Backend — integration tests only
./code/src/scripts/tests/backend.sh -m integration

# Backend — parallel (faster on large suites)
./code/src/scripts/tests/backend.sh -n auto

# Backend — with coverage report
./code/src/scripts/tests/backend-coverage.sh

# Frontend — full suite (one-shot, no persistent container required)
./code/src/scripts/tests/frontend.sh

# Frontend — with coverage
./code/src/scripts/tests/frontend-coverage.sh

# Frontend — watch mode (interactive)
docker compose -f code/src/docker/docker-compose.test.yml run --rm \
  frontend-test pnpm test:watch

# Mobile — unit suite
./code/src/scripts/tests/mobile.sh

# Mobile — E2E (Detox, explicit only)
./code/src/scripts/tests/mobile-e2e.sh

# API (Bruno HTTP tests) — requires dev stack running
./code/src/scripts/tests/api.sh

# E2E (playwright-bdd) — explicit only, never runs automatically
./code/src/scripts/tests/e2e.sh

# Backend + frontend + API (no E2E or mobile-e2e)
./code/src/scripts/tests/all.sh
```

---

## Compilation & Type-Checking

Code must compile and pass static type checks before any test result is meaningful. A test suite
that passes on untypeable code is giving false confidence. Run `./code/src/scripts/syntax/check.sh`
before the test suite — it runs both checks in one command.

### Python — basedpyright

basedpyright validates type annotations statically without executing any code. It catches wrong
argument types, missing attributes, incompatible return types, and misuses of Strawberry schema
types that pytest would only surface at runtime. basedpyright is stricter than standard pyright
by default — prefer fixing errors over suppressing them.

Project config lives at `code/src/backend/pyrightconfig.json`:

```json
{
  "typeCheckingMode": "all",
  "pythonVersion": "3.14",
  "include": ["apps"],
  "reportMissingTypeStubs": false
}
```

```bash
./code/src/scripts/syntax/check.sh --file-type python
```

### TypeScript — tsc

`tsc --noEmit` validates that the entire type graph is consistent — including the generated GraphQL
types in `src/graphql/generated/` — without emitting any output files. Run it after every
`graphql-codegen` run to confirm generated types still match the consumer code.

```bash
# Web
docker compose exec frontend pnpm tsc --noEmit

# Mobile
docker compose exec mobile pnpm tsc --noEmit
```

### When to run

| Event                   | Action                                                                |
| ----------------------- | --------------------------------------------------------------------- |
| Before the test suite   | `./code/src/scripts/syntax/check.sh` (type-check + lint, both layers) |
| Before every commit     | Pre-commit hook runs lint + type-check automatically                  |
| In CI on every PR       | Type-check step runs before the test step — blocks on failure         |
| After `graphql-codegen` | Re-run `tsc --noEmit` to catch generated type mismatches              |

A type error that is "fixed" by suppressing the checker or removing a test is not fixed.

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
`docker-compose.test.yml` (database `project_name_test`). No testcontainers or external setup
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

## Mobile (Expo / React Native)

**Tools:** Jest, React Native Testing Library (RNTL), MSW, Detox

Tests live alongside source files in `code/src/mobile/src/`. Detox E2E tests live in
`code/src/mobile/e2e/`. Jest configuration is at `code/src/mobile/jest.config.ts`.

Coverage floor: 70% line and branch (same as frontend).

### Unit / component tests (Jest + RNTL)

```typescript
// code/src/mobile/src/screens/auth/LoginScreen.test.tsx
import { render, screen, fireEvent } from "@testing-library/react-native";
import { describe, it, expect, jest } from "@jest/globals";

import { LoginScreen } from "./LoginScreen";

describe("LoginScreen", () => {
  it("calls onSubmit with email and password when the form is submitted", () => {
    const onSubmit = jest.fn();
    render(<LoginScreen onSubmit={onSubmit} />);

    fireEvent.changeText(screen.getByLabelText("Email address"), "alice@example.com");
    fireEvent.changeText(screen.getByLabelText("Password"), "secret123");
    fireEvent.press(screen.getByRole("button", { name: /sign in/i }));

    expect(onSubmit).toHaveBeenCalledWith({
      email: "alice@example.com",
      password: "secret123",
    });
  });
});
```

MSW handler setup for mobile mirrors the web setup — define handlers in
`code/src/mobile/src/test/msw/handlers.ts` and wire them into `jest.setup.ts`.

### Detox E2E (BDD — explicit only)

Detox tests run on a real device or simulator. They are **never triggered automatically** — always
explicit only, mirroring the web playwright-bdd policy.

```typescript
// code/src/mobile/e2e/auth/login.test.ts
import { by, device, element, expect } from "detox";

describe("Login flow", () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  it("logs in successfully with valid credentials", async () => {
    await element(by.label("Email address")).typeText("alice@example.com");
    await element(by.label("Password")).typeText("secret123");
    await element(by.label("Sign in")).tap();
    await expect(element(by.id("dashboard-screen"))).toBeVisible();
  });
});
```

### Running mobile tests

```bash
# Unit suite
./code/src/scripts/tests/mobile.sh

# Unit suite with coverage
./code/src/scripts/tests/mobile-coverage.sh

# Detox E2E — explicit only
./code/src/scripts/tests/mobile-e2e.sh
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

Feature files map 1:1 to `project-management/src/STORIES/US###.md` acceptance criteria. Each
scenario in a feature file must describe something a real user would experience — not a technical
edge case invented for coverage. Scenarios added during implementation (discovered edge cases) must
still describe observable user behaviour, not internal system behaviour.

Follow these rules when writing scenarios:

- Scenario titles read as user-story acceptance criteria: what a user can do or what they see.
- Use realistic data in examples — real-looking names, plausible email addresses, actual error
  messages the UI would display.
- `Given` sets up the world the user is in. `When` is the action the user takes. `Then` is what
  the user observes. Never put assertions in `Given` or actions in `Then`.
- One observable outcome per scenario. Split multi-outcome scenarios.

### Feature file format

```gherkin
# code/src/frontend/e2e/features/auth/login.feature
Feature: User login

  Scenario: Member logs in successfully with valid credentials
    Given Sarah is a registered member with email "sarah.jones@example.com"
    When she signs in with her correct password
    Then she should land on her dashboard
    And the navigation should show her first name "Sarah"

  Scenario: Login is rejected when the password is wrong
    Given Sarah is a registered member with email "sarah.jones@example.com"
    When she signs in with an incorrect password
    Then she should see the error "The email or password you entered is incorrect"
    And she should remain on the login page

  Scenario: Suspended account cannot log in
    Given Sarah's account has been suspended by an administrator
    When she attempts to sign in with her correct credentials
    Then she should see the error "Your account has been suspended. Contact support."
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

## Bruno API Tests (HTTP Layer)

Bruno tests live in `code/src/tests/api/` and test the GraphQL API over real HTTP — exercising
the full Django request/response cycle including middleware, authentication headers, CORS, and
error formatting. This is the authoritative check that the API actually works as a client would
see it.

These are distinct from pytest GraphQL tests, which use the Strawberry `Client` and bypass HTTP
entirely. Both are required.

### When to run

- After any middleware, settings, or authentication change
- After any GraphQL schema change that alters the public API
- Before every release, as part of the smoke test suite

### Running Bruno tests

```bash
# Full collection against the local dev stack (stack must be running)
./code/src/scripts/tests/api.sh

# Single collection
./code/src/scripts/tests/api.sh --collection auth

# CI mode — outputs JUnit XML
./code/src/scripts/tests/api.sh --reporter junit
```

### Collection structure

```text
code/src/tests/api/
├── CONTEXT.md
├── environments/
│   ├── local.env          ← BASE_URL=http://localhost:8000
│   └── staging.env        ← BASE_URL=https://staging.example.com
├── auth/
│   ├── login.bru          ← Login mutation — happy path + wrong password
│   ├── refresh.bru        ← RefreshToken mutation
│   └── me.bru             ← Me query — authenticated + unauthenticated
└── users/
    └── update-profile.bru
```

### What every `.bru` file must assert

- [ ] HTTP status code — `200` for GraphQL; `4xx` for malformed requests that fail before the resolver
- [ ] `Content-Type: application/json` header present
- [ ] `data` shape — required fields present and correctly typed on the happy path
- [ ] `errors` absent on the happy path
- [ ] `errors` present and correctly shaped on all failure paths
- [ ] Authentication failure returns a structured GraphQL error — not a Django 403 HTML page

### Difference from pytest GraphQL tests

| Concern                         | pytest (Strawberry `Client`) | Bruno (HTTP)                   |
| ------------------------------- | ---------------------------- | ------------------------------ |
| Schema logic                    | Yes                          | Yes (indirectly)               |
| Django middleware               | No                           | Yes                            |
| CORS and authentication headers | No                           | Yes                            |
| Real HTTP status codes          | No                           | Yes                            |
| Response content-type headers   | No                           | Yes                            |
| Suitable for smoke tests        | No                           | Yes (runs against any env URL) |

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

## Test Output & Readability

Test results must be human-readable — both in the terminal during development and in CI reports.
Unreadable output delays debugging and masks failures.

### Python — pytest output

Configure for clear terminal output in `pyproject.toml`:

```toml
# code/src/backend/pyproject.toml
[tool.pytest.ini_options]
addopts = "--tb=short --strict-markers -q"
```

| Flag               | Effect                                                          |
| ------------------ | --------------------------------------------------------------- |
| `--tb=short`       | Short tracebacks — the failure line plus immediate context only |
| `--strict-markers` | Unregistered markers are errors, not silent no-ops              |
| `-q`               | Quiet — one summary line per test; full details only on failure |
| `-v`               | Verbose — one line per test name (use when debugging a module)  |
| `-n auto`          | Parallel execution via pytest-xdist — auto-selects worker count |

Coverage and JUnit XML output are generated by the test scripts:

```bash
# Human-readable HTML coverage report
./code/src/scripts/tests/backend-coverage.sh

# CI — runs suite and emits junit-backend.xml to code/src/scripts/reports/
./code/src/scripts/tests/backend-ci.sh
```

### TypeScript — Vitest reporters

```typescript
// code/src/frontend/vitest.config.ts
export default defineConfig({
  test: {
    reporters: ["verbose", ["junit", { outputFile: "reports/junit-frontend.xml" }]],
  },
});
```

Use `verbose` locally for readable test-by-test output. In CI, the `junit` reporter produces a
machine-readable report alongside it. Both reporters run simultaneously — no config change is
needed between local and CI runs.

Coverage and JUnit output are generated by the test scripts:

```bash
# Human-readable HTML coverage report
./code/src/scripts/tests/frontend-coverage.sh

# CI — runs suite and emits junit-frontend.xml to code/src/scripts/reports/
./code/src/scripts/tests/frontend-ci.sh
```

### Coverage report locations

| Layer    | Format | Location                                      | How to open                      |
| -------- | ------ | --------------------------------------------- | -------------------------------- |
| Backend  | HTML   | `code/src/scripts/reports/coverage/backend/`  | Open `index.html` in a browser   |
| Frontend | HTML   | `code/src/scripts/reports/coverage/frontend/` | Open `index.html` in a browser   |
| Frontend | LCOV   | `code/src/scripts/reports/coverage/lcov.info` | Imported by CI coverage trackers |

### Writing readable assertions

A well-written failure reads like a sentence:

```text
FAILED apps/users/tests/test_user_service.py::test_create_user_sets_unusable_password_when_none_given
AssertionError: assert False
  + where False = <User alice@example.com>.has_usable_password()
```

If a failure message does not state what went wrong and where, the assertion is too weak.

```python
# Weak — tells you nothing on failure
assert result == expected

# Strong — tells you exactly what diverged
assert result == expected, f"Got {result!r}, expected {expected!r}"
```

### Rules

- Test names must read as sentences: `test_create_user_sets_unusable_password_when_none_given`,
  not `test_create_user_1`.
- Never use `print()` for debugging in tests — use `caplog` or `capsys`.
- Failure messages must state what the test expected and what it got.
- CI must surface individual test failures in the pipeline UI — configure JUnit output in every
  CI test script.
- Any test suite taking longer than 3 minutes on a single worker must be parallelised
  (`-n auto` for pytest-xdist, `--pool=threads` for Vitest). Slow suites block iteration and
  erode the TDD loop.

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
17. **Code must compile before tests are run.** Run `./code/src/scripts/syntax/check.sh`
    (basedpyright + tsc + lint) before the test suite on every PR. A type error "fixed" by
    suppressing the checker is not fixed.
18. **Every new GraphQL mutation or query must have a Bruno `.bru` file.** The `.bru` file is the
    authoritative proof that the API works over real HTTP — correct status codes, response shape,
    headers, and authentication behaviour. pytest GraphQL tests alone do not cover this.
19. **Test output must be human-readable.** Configure `--tb=short` for pytest and `verbose`
    reporter for Vitest. CI must publish JUnit XML so individual failures are visible per-test in
    the pipeline UI, not buried in log scroll.
20. **Tests must scale.** Any suite taking longer than 3 minutes on a single worker must be
    parallelised (`-n auto` for pytest-xdist, `--pool=threads` for Vitest). Mark tests with
    `unit`, `integration`, and `e2e` markers so developers can run only the relevant tier during
    active development without running the full suite every cycle.
21. **TDD is the starting discipline; tests evolve with the implementation.** Write a failing test
    first to define the contract. During the Green phase, amend existing tests or add new ones
    when real edge cases are discovered through building the feature — this is expected and
    correct. When the edge case is user-observable (account suspended, session expired, form
    rejected with a visible message), add a BDD scenario. When it is internal (transaction
    rollback, retry logic, N+1 protection), add a unit or integration test. Never add a test
    solely to raise a coverage number.
22. **Tests must model real-world scenarios.** Use realistic data — plausible email addresses,
    amounts in valid ranges, error messages users would actually see. Synthetic data
    (`"test@test.com"`, `id=999`, `name="foo"`) gives no confidence the system handles real
    input. Use `factory_boy` with `Faker` for Python; use realistic builders for TypeScript. BDD
    feature file scenarios must read as things a real user would experience, derived from
    acceptance criteria, not invented for coverage.
23. **Write initial tests at the contract level, not the implementation level.** A test asserting
    on a private method, internal attribute, or specific SQL query will break on every refactor. A
    test asserting on the outcome — return value, database state, API response — survives
    refactoring unchanged. Design the initial test suite so the Refactor phase requires zero test
    changes unless the public contract itself changes.
24. **Structure initial tests for growth.** Use factories (never inline model instances), use
    `@pytest.mark.parametrize` for the same behaviour across different inputs, and mark every
    test with the correct tier (`unit`, `integration`, `e2e`). This keeps the suite selectively
    runnable and prevents test sprawl as the feature set scales.
