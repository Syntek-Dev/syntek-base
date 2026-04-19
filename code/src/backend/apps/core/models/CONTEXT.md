# code/src/backend/apps/core — models

Model definitions for the `core` app. Currently empty — `core` provides shared infrastructure
(GraphQL schema, encryption utilities) but owns no database models.

## Directory Tree

```text
apps/core/models/
└── __init__.py              ← package marker (no models yet)
```

## Rules

- Models that are genuinely cross-cutting (e.g. a shared audit log) can live here.
- New models must be exported from `__init__.py` so they are reachable as `apps.core.models.X`.
- Every model must have `db_table_comment` on its `Meta` class documenting its purpose and any
  encryption or RLS decisions.

## Cross-references

- `code/src/backend/apps/core/CONTEXT.md` — core app overview
- `code/src/backend/apps/users/models/CONTEXT.md` — example of a Fernet-encrypted model
- `code/docs/DATA-STRUCTURES.md` — model design conventions
