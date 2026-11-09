# Fixture — a placeholder on a line does not hide a separate citation (US004 phase 9, QA-US004-06)

Fixture for the doc-references self-test. Never read as documentation.

The class `project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md` beside a separate dead path: `project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-A.md`

A ### written in the prose of the line, and a separate dead path: `project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-B.md`

Named `ADR-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, and separately a dead guide: `code/docs/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-C.md`

The worked examples below must stay silent: a naming row shows the pattern and an instance of it.

| Artefact | Pattern                         | Worked example                     |
| -------- | ------------------------------- | ---------------------------------- |
| Story    | `US###.md`                      | `US042.md`                         |
| Plan     | `NN-STORY-PLAN-US###-<DESC>.md` | `STORY-PLAN-US042-FIXTURE-ONLY.md` |

An explicit example marker stays a line-level suppression, e.g. `project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-EXAMPLE.md`
