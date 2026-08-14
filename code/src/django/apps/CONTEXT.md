# code/src/django/apps

Django applications for the project backend. **One app ships with the template** — `core`,
which owns no domain concepts and holds the primitives every other app imports. There are
no domain modules yet.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/
├── __init__.py      ← package marker
├── core/            ← the shipped app: schema bases, exception trees, middleware, command base, tags; no models
│   ├── middleware.py
│   ├── schemas.py
│   ├── management/base.py
│   ├── services/errors.py
│   ├── templatetags/core.py
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── CONTEXT.md       ← this file
└── CLAUDE.md        ← operating rules
```

## App Registry

Each app gets a row here — Django label, purpose, and the models it owns — and a line in
`INSTALLED_APPS` as `apps.<name>`.

| App    | Django label | Purpose                                                                                                                                                                           | Models |
| ------ | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `core` | `apps.core`  | Project-wide primitives: the Ninja schema bases, the service-layer exception trees, the request-correlation middleware and the tag that reads it, and the management-command base | none   |

**`core` is not scaffolded like the others.** It ships with the template, so it does not
come from `new-django-app.sh` — that script builds a _domain_ app. Read
`core/CONTEXT.md` before importing from it, and note what it deliberately does not
contain yet.

## Creating an app

`bash code/src/scripts/development/new-django-app.sh <app_name>` is the scaffolder: it wires
the package, its `apps.py`, and its registration in one step, which is why it exists rather
than `manage.py startapp` — Django's own command knows nothing about this project's layout.

An app is a Python package registered in `INSTALLED_APPS` as `"apps.<name>"`. Inside it,
business logic sits in `services.py` (or a `services/` package) and request/response schema
models in `schemas.py` (or a `schemas/` package), so the views and endpoints above them stay
thin enough for a second adapter to sit beside the first.

**Schemas subclass the bases in `apps.core.schemas`, never `ninja.Schema`** — request bodies
`Schema`, responses `OutSchema` or `ninja.ModelSchema`, `Query(...)` containers
`QuerySchema`. Ruff `TID251` fails the build on a direct `ninja.Schema` import; the reason
is in `code/docs/api-design/NINJA-CONVENTIONS.md` Section _Schema strictness_.

**Management commands subclass `apps.core.management.base.ManagementCommand`, never Django's
`BaseCommand`** — the same `TID251` mechanism, for the same reason: the direct base still
works, and the only difference is that a broken invariant stops being distinguishable from a
transient outage. Commands live in the app whose data they touch, at
`<app>/management/commands/`; see `code/docs/MANAGEMENT-COMMANDS.md`.

## Before the first app

This tree is **pre-migration**. `code/docs/DATABASE.md` lists the invariants that are
cheap to settle now and expensive to retrofit — scope columns and the policies that read
them, database-level constraints, and the custom-user-model decision. Read it before the
first model.

## Cross-references

- `code/src/django/CONTEXT.md` — the Django project baseline
- `code/docs/DATABASE.md` — pre-flight data-layer rules
- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service-layer patterns
