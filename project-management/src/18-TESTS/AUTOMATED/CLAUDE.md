@./CONTEXT.md

# CLAUDE.md — src/18-TESTS/AUTOMATED/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CLAUDE.md` (the record lifecycle,
the three-record boundary, the guardrails both records share) → this folder's `CONTEXT.md`
(the two halves of a record, how a test reaches one — imported above) → this file.

## Purpose (one line)

The per-story automated test record — what each test checks and whether it passed, half generated
from the suites' own reports — and the one home of the rules that govern it.

## How to work here

- **Routing:** written by `project-management/workflows/22-implementation-documentation/` Step 4,
  driven by the `doc-writer` skill, and only **verified** by `23-pr-and-review/` Step 6. Suites
  run through `code/src/scripts/tests/**/*.sh` — never `pytest`, `bru` or `playwright` directly.
- **Model:** Opus throughout — running the generator is mechanical; the gaps, deferrals and status
  line are judgement.
- **Concrete steps:** copy `US000-TEST-STATUS.md` → `US###-TEST-STATUS.md` → run the story's
  suites → `bash code/src/scripts/tests/test-record.sh US###` to write the generated block → read
  `bash code/src/scripts/audits/story-markers.sh` → write Sections 2 to 4 → link the story and its
  plan → set the header status and date.
- **Definition of done:** the record present, its generated block regenerated against the **last**
  suite run, Sections 2 to 4 written (every suite not run named with its reason), the status line
  matching the block, story and plan cross-linked, British English, dates DD/MM/YYYY.

### The generator

`test-record.sh` is the only writer of everything between the generated markers, the coverage
figures included. Run it after the suites, **green or red** — a failing run still records. It
refuses to write a record that does not exist yet, so the copy comes first. Its contract — the
markers it requires, and why it never changes a suite's exit code — is
`code/src/scripts/tests/CLAUDE.md`.

### The story marker

A test reaches a record only if it declares its story — the marker and its syntax are registered
in `code/docs/testing/TAXONOMY.md`. Enforcement is warn-only: `audits/story-markers.sh` lists what
carries no marker and exits `0`, so **an unmarked test is silently absent from the record** rather
than failing it.

## Guardrails

- **Every story gets a record — a plan cannot decide it away.** A story with no automated suite
  still has one: the generator writes its no-test block, and Section 3 says why (no code path, say).
  An absent file is indistinguishable from a skipped step; a record stating "no suite" is not.
- **Never hand-edit between `<!-- BEGIN GENERATED: test-record -->` and `<!-- END GENERATED -->`.**
  The next run of `test-record.sh` discards it without warning. Corrections belong in the test, or
  in Section 3.
- **Never read a short per-test table as a small suite** until `audits/story-markers.sh` has been
  read — a missing row is not the same claim as a missing test.
- The re-run and no-secrets rules both records share — `../CLAUDE.md` → _Guardrails_.

## Output & naming

- **Hand-written:** `US###-TEST-STATUS.md` Sections 2 to 4 — reproduction, gaps and flaky tests,
  the status line — plus its header.
- **Generated:** `US###-TEST-STATUS.md` Section 1, written by `code/src/scripts/tests/test-record.sh`
  from the suites' JUnit XML, Bruno JSON, axe JSON and `coverage.xml`. Never hand-edited.
- **Template:** `US000-TEST-STATUS.md` — the copy source; never filled in, never deleted.
- `US###-TEST-STATUS.md` — `US` + the zero-padded three-digit story number, no descriptor and no
  date (`../CLAUDE.md` → _Output & naming_).

<!-- UPDATED 30/09/2026. Created when "../CLAUDE.md" split the folder by record type. The rules
     here — the generated-block ban, the generator's green-or-red contract, the story marker and
     its warn-only audit — moved from "../CLAUDE.md" unchanged in substance; only their home moved,
     because they bind this record alone and the manual guide beside it is now written at a
     different stage, by a different workflow, under rules of its own. Why the folder split:
     "../CLAUDE.md". -->
