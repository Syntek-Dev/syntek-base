# code/src/django/tests/unit — Root `conftest.py` Tests

Unit tests for the project-level pytest configuration in `code/src/django/conftest.py`. They
belong to no Django app because the code they cover belongs to none: the root conftest serves
every suite, so its tests cannot live beside an app without dying with it.

## Directory tree

```text
code/src/django/tests/unit/
├── __init__.py          ← package marker
├── CLAUDE.md            ← operating rules
├── CONTEXT.md           ← this file
└── test_story_map.py    ← the story map survives the runners' two pytest sessions
```

## What is tested here

| Module              | Covers                                                                                                                      |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `test_story_map.py` | `pytest_collection_finish` — the `reports/story-map.json` merge across the unit and integration sessions of one runner call |

The path puts every test here in the `unit` phase (`conftest.py` assigns markers by path), so
no database is attached.

## Cross-references

These tests pin the story-map merge: a later pytest session in the same run must never erase
the entries for tests it did not collect.

- `code/src/django/conftest.py` — the code under test
- `code/src/scripts/tests/test-record.sh` — the generator that reads the map
