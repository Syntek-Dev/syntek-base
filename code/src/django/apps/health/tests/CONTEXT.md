# apps/health/tests — The Suite for `apps.health`

Two files, and the division of labour between them is the point: the aggregation rule is
tested against constructed results, because the interesting cases — a critical dependency
down while a degradable one is healthy, and the reverse — cannot be produced by breaking a
real dependency mid-run. The endpoint tests then assert the wire contract those results are
published through.

The split below is not organisational — `conftest.py` assigns a marker **by path**, and the
marker decides which of `backend.sh`'s two phases a test runs in. A file in `unit/` gets
`unit`; everything else here gets `integration` and a database.

## Directory tree

```text
apps/health/tests/
├── __init__.py   ← package marker
├── unit/         ← phase 1: no database, no container dependency
├── CLAUDE.md     ← operating rules
├── CONTEXT.md    ← this file
└── test_endpoints.py ← the wire contract: paths, codes, body shape, what it withholds
```

## Cross-references

- `code/docs/testing/TAXONOMY.md` — which layer a given test belongs at
- `code/docs/testing/COVERAGE.md` — the floors these suites are measured against
- `code/src/django/conftest.py` — the path-to-marker rule described above
