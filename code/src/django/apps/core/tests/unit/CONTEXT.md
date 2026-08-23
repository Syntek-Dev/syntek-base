# apps/core/tests/unit — Phase 1

The primitives that need no database: the exception trees, the schema bases, the middleware and the template tag.

**This directory's name is functional, not descriptive.** `code/src/django/conftest.py`
marks every test under a `tests/unit/` path as `unit`, and `backend.sh` runs phase 1 with
`-m unit` before any database is touched. Moving a file in or out of here changes which
phase it runs in.

## Directory tree

```text
apps/core/tests/unit/
├── __init__.py   ← package marker
├── CLAUDE.md     ← operating rules
├── CONTEXT.md    ← this file
├── test_errors.py ← that the three exception trees stay unrelated, which is the whole point
├── test_middleware.py ← an inbound identifier is untrusted, and the ContextVar is always reset
├── test_schemas.py ← the `extra` policy that differs across the three bases on purpose
└── test_templatetags.py ← that the tag works with the empty Context the 500 page uses
```

## Cross-references

- `../CONTEXT.md` — the suite this is one half of
- `code/src/django/conftest.py` — the path-to-marker rule
