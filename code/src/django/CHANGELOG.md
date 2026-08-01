# Changelog — django

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

All notable changes to the Django project bundle are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this package adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.0] - 01/08/2026

### Added

- Initial scaffold from the base template — Django · Django Ninja · django-components · HTMX · Alpine · vanilla token CSS · Celery · PostgreSQL · Valkey · Nginx · Docker.
- `config/` — ASGI and WSGI entry points, the root URL conf with Django's admin at `/control/`, and the settings split across `base.py`, `dev.py`, `test.py`, `staging.py`, and `production.py`.
- `apps/` — the empty namespace package every Django app is scaffolded into by `code/src/scripts/development/new-django-app.sh`.
- `templates/` and `static/` — the server-rendered presentation roots; there is no client-side build step.
- `tests/e2e/` — the Playwright accessibility (`test_e2e_a11y.py`) and marketing overflow (`test_e2e_marketing_overflow.py`) suites, with shared `conftest.py` and `a11y_config.py`.
- `conftest.py`, `manage.py`, and `pyrightconfig.json` — root pytest configuration, the Django CLI entry point, and type-checker settings.

### Changed

- Established as the repository's only versioned sub-package, tracked independently of the root version by the root `pyproject.toml` and these three version files. Relocated from `code/src/backend/`: with no JavaScript client remaining, Django serves the whole application rather than a backend API alone.
