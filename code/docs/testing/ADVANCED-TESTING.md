---
type: guide
skills: [test-writer, stack-django, stack-htmx-templates]
model: opus
---

# Testing — Advanced Testing Techniques

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Property-based, mutation, and advanced test techniques

---

## Property-Based Testing with Hypothesis

Use `hypothesis` for any function that must hold across a wide range of inputs — especially
validators, data transformation functions, and serialisation logic.

`hypothesis` is declared as a test dependency in the root `pyproject.toml`.

```python
from hypothesis import given, settings
from hypothesis import strategies as st
from apps.core.validators import validate_slug


@given(
    slug=st.text(
        alphabet=st.characters(whitelist_categories=("Ll", "Nd"), whitelist_characters="-"),
        min_size=1,
        max_size=60,
    )
)
@settings(max_examples=500)
def test_valid_slugs_are_accepted(slug: str) -> None:
    """validate_slug must not raise for any input that matches the allowed character set."""
    validate_slug(slug)


@given(value=st.text(min_size=1, max_size=200))
@settings(max_examples=300)
def test_email_validator_never_raises_unexpectedly(value: str) -> None:
    from django.core.exceptions import ValidationError
    from django.core.validators import validate_email

    try:
        validate_email(value)
    except ValidationError:
        pass  # expected for invalid input
```

**Where to use Hypothesis:**

- Input validators — must never raise an unhandled exception
- Data transformation and serialisation — idempotency, round-trip correctness
- Slug/URL normalisation — consistent output for any valid input
- Ninja `Schema` (Pydantic) field coercion edge cases

**Where NOT to use Hypothesis:**

- Tests that require database state (use `factory_boy` + pytest fixtures)
- E2E or integration tests (too slow for property-based iteration)

---

## Security Testing

### Input sanitisation (every API endpoint)

Every Django app that accepts user input must have negative tests for:

- SQL injection via ORM parametrisation
- Malformed request bodies — rejected by the Ninja request `Schema` (Pydantic) with `422` before the handler runs
- Command/path injection in user-supplied identifiers

```python
@pytest.mark.parametrize(
    "slug",
    [
        "'; DROP TABLE users --",
        "<script>alert(1)</script>",
        "../../../etc/passwd",
        "a" * 300,  # exceeds max field length
    ],
)
def test_invalid_slug_is_rejected(slug: str) -> None:
    from django.core.exceptions import ValidationError
    from apps.core.models import Page

    with pytest.raises((ValidationError, ValueError)):
        Page(slug=slug).full_clean()
```

### Authentication & authorisation (every state-changing Ninja endpoint)

Every state-changing endpoint must have:

1. A test confirming unauthenticated requests are rejected (`401`)
2. A test confirming the correct permission is required
3. A test confirming object-level permission (user A cannot act on user B's resources → `403`, no IDOR)

```python
@pytest.mark.django_db
def test_update_profile_requires_authentication() -> None:
    from ninja.testing import TestClient
    from apps.users.api import router

    client = TestClient(router)
    response = client.post("/profile", json={"display_name": "Eve"})
    assert response.status_code == 401
```

### Dependency scanning (CI)

Runs on a schedule in `.github/workflows/audit-deps.yml` — `pip-audit` for Python and
`pnpm audit` for JavaScript. There is no local wrapper script; trigger the workflow from the
Actions tab to sweep on demand.

---

## Performance & Load Testing

### Query count assertions (pytest-django)

```python
@pytest.mark.django_db
def test_list_articles_no_n_plus_one(article_factory) -> None:
    article_factory.create_batch(10)
    with CaptureQueriesContext(connection) as ctx:
        list(Article.objects.select_related("author").prefetch_related("tags").all())
    assert len(ctx) <= 3, f"Expected ≤3 queries, got {len(ctx)}"
```

### k6 load tests (milestone releases only)

No load-test scripts ship in this repository — `code/src/scripts/tests/` holds no `load/`
directory and no `load.sh` runner, and k6 is not installed. When load testing is introduced the
scripts belong in a `load/` directory beside the other test runners, behind a `load.sh` entry
point, and are run against a staging environment only.

---

## Contract Testing

Nothing in this repository consumes the JSON API — pages talk to Django views over HTMX
(`code/docs/api-design/CLIENT-PATTERNS.md`), so there is no in-repo consumer to write a contract
against, and no contract-test runner is installed.

The API's consumers are external: integrations, webhooks, and any future mobile client. The
lightweight guard that fits that shape is a **schema diff on the OpenAPI document** Ninja publishes
at `/api/docs` — commit the spec, diff it in CI, and treat a removed field or a narrowed type as a
breaking change requiring a version bump.

Introduce consumer-driven contract testing (Pact or equivalent) only when a specific external
consumer exists to define the contract. A contract with no counterparty tests nothing.

---

## Mutation Testing

Run mutation testing when coverage appears high but the tests feel weak.

### Python — mutmut

```bash
bash code/src/scripts/tests/mutmut.sh run
bash code/src/scripts/tests/mutmut.sh results
```

Inspect a surviving mutant with `mutmut.sh show MUTANT_ID`.

There is no JavaScript mutation runner — there is no JavaScript test suite for one to mutate.

A mutation score below **80%** indicates tests that pass but do not assert on output.

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
