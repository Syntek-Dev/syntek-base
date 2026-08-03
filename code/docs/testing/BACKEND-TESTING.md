---
type: guide
agent: test-writer
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Testing — Backend Testing (Python/Django)

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Backend test setup, pytest-django, type-checking, coverage workflow

---

## Compilation & Type-Checking

Code must compile and pass static type checks before any test result is meaningful. Run
`./code/src/scripts/syntax/check.sh` before the test suite.

### Python — basedpyright

basedpyright validates type annotations statically. Project config at
`code/src/django/pyrightconfig.json`:

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

### When to run

| Event                 | Action                                                        |
| --------------------- | ------------------------------------------------------------- |
| Before the test suite | `./code/src/scripts/syntax/check.sh` (type-check + lint)      |
| Before every commit   | Pre-commit hook runs lint + type-check automatically          |
| In CI on every PR     | Type-check step runs before the test step — blocks on failure |

---

## Python / Django

**Tools:** pytest-django, factory_boy, pytest-cov, hypothesis

Tests live in `code/src/django/apps/<app>/tests/`. The Django settings used during testing are
in `code/src/django/config/settings/test.py`.

### pytest configuration

```toml
# code/src/django/pyproject.toml
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
`docker-compose.test.yml` (a dedicated project test database — never dev or production). No
testcontainers or external setup required.

`@pytest.mark.django_db` wraps each test in a transaction that is rolled back on exit. For tests
that need to verify committed state, use `@pytest.mark.django_db(transaction=True)`.

### factory_boy example

```python
# code/src/django/apps/users/tests/factories.py
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

## Database Isolation

- **Python integration tests:** use `@pytest.mark.django_db`. Each test runs in a transaction
  that is rolled back after the test.
- **Testcontainers:** spin up an ephemeral PostgreSQL 18 container per session for integration
  tests. Never point tests at the dev or production database.

---

## Test Data and Factories

- **Python:** use `factory_boy` (`DjangoModelFactory`) for all model fixtures. Never build model
  instances inline across multiple tests.
- **Avoid hardcoded IDs:** use `factory.Sequence` in Python.

---

## Acceptance criteria

A story's Gherkin acceptance criteria (`project-management/src/02-STORIES/`) are discharged by
integration tests through the Django test client, not by a separate BDD suite. Each `Scenario:`
maps to one test; the `Given` is the factory setup, the `When` is the client call, the `Then` is
the assertion. Only a scenario that genuinely needs a browser goes to
`code/src/django/tests/e2e/`.

```gherkin
Feature: User login

  Scenario: Member logs in successfully with valid credentials
    Given Sarah is a registered member with email "sarah.jones@example.com"
    When she signs in with her correct password
    Then she should land on her dashboard
```

```python
@pytest.mark.django_db
def test_member_logs_in_successfully_with_valid_credentials(client):
    UserFactory(email="sarah.jones@example.com")

    response = client.post(
        "/login/",
        {"email": "sarah.jones@example.com", "password": "secret-password-123"},
        follow=True,
    )

    assertRedirects(response, "/dashboard/")
```

**Readability rules carry over:** one observable outcome per test, realistic data, and a test name
that reads as the scenario title. Page-level rendering assertions belong in
[`FRONTEND-TESTING.md`](FRONTEND-TESTING.md).

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
