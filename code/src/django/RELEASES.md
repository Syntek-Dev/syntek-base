# Releases — django

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

Release notes for the Django project bundle.

---

## v0.1.0 — 01/08/2026

**Status:** Baseline release — the Django bundle becomes the single application root

### Summary

Establishes `code/src/django/` as the repository's only versioned sub-package, relocated from
`code/src/backend/`. With both JavaScript client layers removed, Django is no longer a backend
sitting behind an API client — it renders the entire application from its own templates,
components, and HTMX partials. The bundle ships the four-environment settings split, the empty
`apps/` namespace, the template and static roots, and the Playwright accessibility and overflow
suites. No domain models, migrations, or API routers exist yet; that is deliberate.

### What's new

- **Four-environment settings** — `base.py` with `dev`, `test`, `staging`, and `production` overlays
- **Application entry points** — the ASGI and WSGI modules plus the root URL conf, with Django's own admin mounted at `/control/` rather than `/admin/`
- **`apps/` namespace** — every app is scaffolded into it by `new-django-app.sh`, never by `startapp`
- **End-to-end suites** — Playwright accessibility and marketing overflow tests with shared fixtures
- **Independent versioning** — this bundle moves on its own track and is never bumped as a side-effect of a root version bump
