# project-management/src/18-TESTS/AUTOMATED

Per-story **automated test records** — what each automated test checks, whether it passed, and
the coverage the suites reached against the floors. A record is written once the suites have run,
after the code, and half of it is generated from the suites' own report artefacts: figures a
person transcribes go stale between runs, and figures a script derives from the run do not.

## Directory Tree

```text
project-management/src/18-TESTS/AUTOMATED/
├── CONTEXT.md             ← this file
├── CLAUDE.md              ← operating rules: the generated block, the generator, the story marker
├── US000-TEST-STATUS.md   ← template: copied to US###-TEST-STATUS.md at the closeout
└── US###-TEST-STATUS.md   ← one record per story
```

## What a record holds

Two halves, divided by the `BEGIN GENERATED: test-record` and `END GENERATED` markers:

| Half             | Sections | Holds                                                                                                                 |
| ---------------- | -------- | --------------------------------------------------------------------------------------------------------------------- |
| **Generated**    | 1        | The suite rollup, coverage against the floors, and one row per test case — what it checks, why, and whether it passed |
| **Hand-written** | 2–4      | How to reproduce the run, the outstanding gaps and flaky tests, and the status line                                   |

The generated half is written by `code/src/scripts/tests/test-record.sh` from the suites' JUnit
XML, Bruno JSON, axe JSON and `coverage.xml`. The hand-written half holds what no report
artefact carries: a reason, a deferral, a judgement.

## How a test reaches a record

The suites run whole-project, and their report artefacts carry no story attribution, so a test
**declares** the story it belongs to with a marker and the generator selects on it. A test with
no marker is absent from every record rather than failing anything. The marker registry is
`code/docs/testing/TAXONOMY.md`; the reasoning behind a marker over a path or a branch diff is the
09/09/2026 comment in `../CLAUDE.md`.

## Cross-references

- `US000-TEST-STATUS.md` — the template every record is copied from
- `../MANUAL/` — the paired manual testing guide, authored before code and walked after it
- `../CLAUDE.md` — the record lifecycle and the three-record boundary
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
- `code/docs/testing/TAXONOMY.md` — the `story` marker registry
- `code/docs/TESTING.md` — coverage floors, test structure and mocking strategy

**Last Updated**: <%DATE%>
