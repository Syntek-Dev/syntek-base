# apps/core/services — Shared Service-Layer Primitives

The service-layer pieces every app's own `services/` builds on. At baseline that is one
module: the exception bases.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/core/services/
├── __init__.py   ← package marker
├── errors.py     ← ServiceError tree · InvariantViolation · DependencyUnavailable
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

## The two trees in `errors.py`

They are separate deliberately, and the separation is the whole point.

| Class                                                                                         | Tree              | Surfaces as                     |
| --------------------------------------------------------------------------------------------- | ----------------- | ------------------------------- |
| `ServiceError` · `ServicePermissionError` · `ServiceNotFoundError` · `ServiceValidationError` | user error        | 4xx, `INFO`, no tracker event   |
| `InvariantViolation`                                                                          | programmer error  | 500, `ERROR`, one tracker event |
| `DependencyUnavailable`                                                                       | environment error | 503, `WARNING`, aggregated      |

`InvariantViolation` carries the **register key** — the row identifier in
`how-to/src/INVARIANTS.md` — so a tracker event names which invariant broke.

## Cross-references

- `code/docs/NEGATIVE-SPACE.md` → The error taxonomy — the rule this module implements
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` → Service Exception Hierarchy — the
  per-app thin base every app defines over `ServiceError`
- `how-to/src/INVARIANTS.md` — the register whose keys `InvariantViolation` quotes
