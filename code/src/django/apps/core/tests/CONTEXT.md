# apps/core/tests — The Suite for `apps.core`

`core` ships no domain behaviour, so these tests cover the primitives every other app
inherits: the two exception trees and the separation between them, the three Ninja schema
bases and their differing `extra` policies, the correlation middleware, the template tag
that reads it, and the management-command base.

Each test corresponds to a failure with a cost — a broken invariant surfacing as a friendly
400, a silently discarded request field, a 422 on a tracking parameter, a correlation
identifier leaking into the next request on a reused thread — rather than to a line of code.

The split below is not organisational — `conftest.py` assigns a marker **by path**, and the
marker decides which of `backend.sh`'s two phases a test runs in. A file in `unit/` gets
`unit`; everything else here gets `integration` and a database.

## Directory tree

```text
apps/core/tests/
├── __init__.py   ← package marker
├── unit/         ← phase 1: no database, no container dependency
├── CLAUDE.md     ← operating rules
├── CONTEXT.md    ← this file
└── test_management_base.py ← the three error classes as an operator and a scheduler see them
```

## Cross-references

- `code/docs/testing/TAXONOMY.md` — which layer a given test belongs at
- `code/docs/testing/COVERAGE.md` — the floors these suites are measured against
- `code/src/django/conftest.py` — the path-to-marker rule described above
