# apps/core — Project-Wide Primitives

The one app the template ships. It holds what every other app imports and nothing that
belongs to a domain: the Ninja schema bases, the service-layer exception trees, and the
request-correlation middleware. It owns **no models** — `core` is a shared-primitives package
that happens to be a Django app, not a domain module.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/core/
├── __init__.py       ← package marker
├── apps.py           ← CoreConfig — registered as `apps.core`
├── middleware.py     ← RequestIDMiddleware + current_request_id() — the correlation ID
├── schemas.py        ← Schema · OutSchema · QuerySchema — the Ninja bases
├── services/          ← shared service-layer primitives (see its CONTEXT.md)
│   ├── __init__.py
│   ├── errors.py     ← ServiceError tree + InvariantViolation + DependencyUnavailable
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── CONTEXT.md        ← this file
└── CLAUDE.md         ← operating rules
```

No `models/`, no `migrations/`. Both arrive with the first `core` model, and not before —
an empty migrations package on a model-less app is scaffolding that has to be explained.

## What is here, and why each thing is here

| Module               | Holds                                                                          | Decided by                 |
| -------------------- | ------------------------------------------------------------------------------ | -------------------------- |
| `middleware.py`      | The correlation identifier on every response, and the accessor that reads it   | `MAP-NEGATIVE-SPACE` N-009 |
| `schemas.py`         | Three Ninja bases — request bodies forbid unknown fields, the other two do not | `MAP-NEGATIVE-SPACE` N-008 |
| `services/errors.py` | The `ServiceError` tree, plus the two classes deliberately outside it          | `MAP-NEGATIVE-SPACE` N-005 |

`middleware.py` is a **module, not a package**. Request logging, when it lands, is a second
class in this file rather than `middleware/request_log.py` — a package and a module cannot
share the name, and one middleware does not earn a package.

## What is documented here but not shipped

`code/docs/` names a dozen further `apps.core` modules — `utils.get_client_ip`,
`crypto`, `encryption`, `api_auth`, `views/seo`, `mcp_auth`, request logging in
`middleware`, `observability`, `db.get_or_cache`, `conf.get_setting`, `validators`, and
`models`. **None of them exist yet**, and that is deliberate: a module lands here when the
decision that governs it lands, not in anticipation. The register of what is still owed is
`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`.

## Cross-references

- `code/docs/api-design/NINJA-CONVENTIONS.md` — schema naming, the `In`/`Out` convention,
  and the strictness rule `schemas.py` implements
- `code/docs/NEGATIVE-SPACE.md` — the error taxonomy `services/errors.py` implements
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — the `ServiceError` hierarchy and the
  per-app thin base every app defines over it
- `code/src/django/apps/CONTEXT.md` — the app registry this app is listed in
