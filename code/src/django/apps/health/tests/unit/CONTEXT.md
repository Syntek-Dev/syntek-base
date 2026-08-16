# apps/health/tests/unit — Phase 1

The probes and the aggregation rule, in isolation from any running dependency.

**This directory's name is functional, not descriptive.** `code/src/django/conftest.py`
marks every test under a `tests/unit/` path as `unit`, and `backend.sh` runs phase 1 with
`-m unit` before any database is touched. Moving a file in or out of here changes which
phase it runs in.

## Directory tree

```text
apps/health/tests/unit/
├── __init__.py   ← package marker
├── CLAUDE.md     ← operating rules
├── CONTEXT.md    ← this file
└── test_checks.py ← the aggregation rule, and that a failing probe returns rather than raises
```

## Cross-references

- `../CONTEXT.md` — the suite this is one half of
- `code/src/django/conftest.py` — the path-to-marker rule
