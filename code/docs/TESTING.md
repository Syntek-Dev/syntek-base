---
type: guide
agent: test-writer
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Testing Guide — {{PROJECT_NAME}}

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: {{TIMEZONE}}
**Claude Model:** opus — Testing strategy, coverage floors, pytest + playwright-python tooling

This guide covers testing strategy, tooling, and standards across the {{PROJECT_NAME}} stack.
All tests run inside Docker containers via the scripts in `code/src/scripts/tests/`. Never invoke
`pytest` directly on the host machine.

## Sub-documents

| Document                                                                     | Covers                                                                                                                                     |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| [`testing/TAXONOMY.md`](testing/TAXONOMY.md)                                 | Testing taxonomy, Backend & API testing checklist, Testing matrix, Running tests                                                           |
| [`testing/BACKEND-TESTING.md`](testing/BACKEND-TESTING.md)                   | Compilation & type-checking, Python/Django (pytest, fixtures, PostgreSQL, factory_boy), acceptance criteria, Database isolation, Test data |
| [`testing/FRONTEND-TESTING.md`](testing/FRONTEND-TESTING.md)                 | Template rendering, django-component tests, HTMX partials and response headers, markup-level accessibility, query counts                   |
| [`code/src/django/tests/e2e/CONTEXT.md`](../src/django/tests/e2e/CONTEXT.md) | The browser suite (playwright-python) — what needs a real browser, viewport projects, the axe gate                                         |
| [`testing/API-TESTING.md`](testing/API-TESTING.md)                           | Django Ninja endpoint tests (pytest), input-validation & per-endpoint authorisation negatives, Bruno JSON API tests, HTTP layer testing    |
| [`testing/COVERAGE.md`](testing/COVERAGE.md)                                 | Coverage thresholds, Test output & readability, Rules and Principles                                                                       |
| [`testing/ADVANCED-TESTING.md`](testing/ADVANCED-TESTING.md)                 | Property-based testing with Hypothesis, Security testing, Performance & load testing, Contract testing, Mutation testing                   |

_Part of the `code/docs/` documentation family._
