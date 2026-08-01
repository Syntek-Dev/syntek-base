---
type: guide
agent: test-writer
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Testing — Frontend Testing (Django templates + HTMX)

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: {{TIMEZONE}}
**Claude Model:** opus — Template, component, and HTMX-partial tests through the Django test client

The frontend is HTML produced by Django. There is no client-side bundle and no JavaScript test
runner — a "frontend test" here is a pytest test that renders a view or a component and asserts on
the markup it returns.

That is the whole point of the stack choice: the rendering path and the data path are the same
path, so one suite covers both. **This is where the overwhelming majority of frontend tests
belong.**

The exception is anything needing a real browser — computed layout, resolved CSS, or executed
JavaScript. That goes to the small playwright-python suite at `code/src/django/tests/e2e/`
(`bash code/src/scripts/tests/e2e-py.sh`). Its cost is a running stack and a Chromium download, so
reach for it only when the Django test client genuinely cannot see the defect.

---

## Running them

Frontend tests are backend tests — they run in the same two-phase pytest suite:

```bash
# Whole suite
bash code/src/scripts/tests/backend.sh

# Just the marketing app's template tests
bash code/src/scripts/tests/backend.sh code/src/django/apps/marketing/tests/

# With coverage
bash code/src/scripts/tests/backend-coverage.sh
```

Tests live beside the app they cover, in `code/src/django/apps/<app>/tests/`. A view test touches
the database, so it lands in phase 2 (`-m integration`); a pure component-render test with no
model access can be marked `@pytest.mark.unit` to keep it in the fast phase.

---

## Rendering a page

Use the pytest-django `client` fixture. Assert on status, template, and the content that matters —
never on the full HTML string, which turns every markup tweak into a test failure.

```python
import pytest


@pytest.mark.django_db
def test_home_page_renders(client):
    response = client.get("/")

    assert response.status_code == 200
    assert "marketing/home.html" in [t.name for t in response.templates]
    assert b"<h1" in response.content
```

Prefer `django.test.utils.assertContains` for content assertions — it checks the status code at
the same time and gives a readable failure:

```python
from django.test import Client
from pytest_django.asserts import assertContains, assertTemplateUsed


@pytest.mark.django_db
def test_home_page_shows_the_headline(client: Client):
    response = client.get("/")

    assertTemplateUsed(response, "marketing/home.html")
    assertContains(response, "Build it once", status_code=200)
```

### Context over markup

Where a view computes something, assert on `response.context` rather than the rendered string.
It is the stable contract; the template is presentation.

```python
@pytest.mark.django_db
def test_home_page_lists_three_featured_items(client):
    response = client.get("/")

    assert len(response.context["featured"]) == 3
```

---

## Testing a django-component

Components render standalone, so they can be tested without a request — fast, and in phase 1.

```python
import pytest
from django_components import registry


@pytest.mark.unit
def test_button_renders_its_label():
    Button = registry.get("button")

    html = Button.render(kwargs={"label": "Save", "variant": "primary"})

    assert "Save" in html
    assert 'class="button button--primary"' in html


@pytest.mark.unit
def test_button_marks_itself_disabled():
    Button = registry.get("button")

    html = Button.render(kwargs={"label": "Save", "disabled": True})

    assert "disabled" in html
    assert 'aria-disabled="true"' in html
```

Assert on the **accessible** surface — roles, labels, `aria-*`, `disabled` — not on incidental
class names, unless the class is the thing under test (a variant, a state modifier).

---

## Testing HTMX partials

An HTMX endpoint has two jobs: return the right fragment, and return the right response headers.
Test both. Send `HTTP_HX_REQUEST="true"` so the view takes its HTMX branch.

```python
@pytest.mark.django_db
def test_filter_returns_only_the_results_fragment(client):
    response = client.get("/portfolio/?tag=django", HTTP_HX_REQUEST="true")

    assertTemplateUsed(response, "marketing/_portfolio_results.html")
    # A partial must not carry the page chrome
    assert b"<html" not in response.content
    assert b"<nav" not in response.content


@pytest.mark.django_db
def test_full_page_request_returns_the_whole_document(client):
    response = client.get("/portfolio/?tag=django")

    assertTemplateUsed(response, "marketing/portfolio.html")
    assert b"<html" in response.content
```

### Response headers

`HX-Trigger`, `HX-Redirect`, and `HX-Retarget` are part of the contract — assert on them
explicitly, because nothing else will catch a typo in a header name.

```python
@pytest.mark.django_db
def test_subscribe_triggers_the_toast_event(client):
    response = client.post("/subscribe/", {"email": "a@example.com"}, HTTP_HX_REQUEST="true")

    assert response.status_code == 200
    assert response["HX-Trigger"] == "subscribed"
```

### Validation errors re-render the form

An HTMX form that fails validation returns `200` with the re-rendered form, not a `4xx` — the
swap has to put something back on the page. Pin that behaviour down:

```python
@pytest.mark.django_db
def test_invalid_email_re_renders_the_form_with_an_error(client):
    response = client.post("/subscribe/", {"email": "nope"}, HTTP_HX_REQUEST="true")

    assertContains(response, "Enter a valid email address", status_code=200)
    assertTemplateUsed(response, "marketing/_subscribe_form.html")
```

---

## Alpine.js

Alpine behaviour is not tested here — pytest renders markup, it does not execute JavaScript. That
is a constraint on how much logic Alpine is allowed to hold, not a gap to be filled later: **if a
piece of Alpine state needs a test, it belongs on the server.** Keep `x-data` to presentational
toggles (open/closed, active tab, copy-to-clipboard) whose failure is visible and harmless.

What you _can_ assert server-side is that the attributes are present and correctly wired:

```python
@pytest.mark.unit
def test_disclosure_wires_its_alpine_state():
    Disclosure = registry.get("disclosure")

    html = Disclosure.render(kwargs={"summary": "Details"})

    assert 'x-data="{ open: false }"' in html
    assert ':aria-expanded="open"' in html
```

---

## Accessibility

Every rule in [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md) that lives in the markup can be
asserted here — landmarks, heading order, form labelling, `alt` text, accessible names:

```python
@pytest.mark.django_db
def test_home_page_has_one_main_landmark_and_one_h1(client):
    body = client.get("/").content.decode()

    assert body.count("<main") == 1
    assert body.count("<h1") == 1


@pytest.mark.unit
def test_icon_button_has_an_accessible_name():
    IconButton = registry.get("icon-button")

    html = IconButton.render(kwargs={"icon": "close", "label": "Close dialog"})

    assert 'aria-label="Close dialog"' in html
```

Contrast and computed layout need a real browser: the axe scan in
`code/src/django/tests/e2e/test_e2e_a11y.py` covers them, driven from `a11y_config.PAGES`. Focus
order and screen-reader announcement stay on the manual checklist in
[`../accessibility/TESTING-AND-COMPONENTS.md`](../accessibility/TESTING-AND-COMPONENTS.md).

---

## Query counts

A template that loops over a queryset is the usual home of an N+1. Guard the hot pages with
`django_assert_num_queries`:

```python
@pytest.mark.django_db
def test_portfolio_page_does_not_n_plus_one(client, django_assert_num_queries):
    PortfolioItemFactory.create_batch(20)

    with django_assert_num_queries(3):
        client.get("/portfolio/")
```

---

## Test data

Use the same `factory_boy` factories as the rest of the suite — see
[`BACKEND-TESTING.md`](BACKEND-TESTING.md). There is no separate frontend fixture layer.

---

## Coverage

Template and component tests count towards the single backend floor (75% line and branch,
90% for `apps/users`). There is no separate frontend floor — see [`COVERAGE.md`](COVERAGE.md).
The browser suite is excluded: it drives a running stack over HTTP and instruments nothing.

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
