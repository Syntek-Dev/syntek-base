# project-management/src/18-TESTS

Per-story test records, in two sub-folders by record type. `MANUAL/` holds the **manual testing
guide** — the journeys a tester or Claude Chrome walks, authored from the story's specifications
before any code exists and walked, row by row, once the code ships. `AUTOMATED/` holds the
**automated test record** — what each automated test checks and whether it passed — written after
the suites run. This folder is a base-repo **template-only scaffold**: it ships the two `US000-…`
copy sources and the documentation pairs, nothing else; real records are added per story.

## Directory Tree

```text
project-management/src/18-TESTS/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules: the record lifecycle and the three-record boundary
├── MANUAL/                        ← per-story manual testing guides — authored at 17, walked at 22
│   ├── CONTEXT.md · CLAUDE.md
│   └── US000-MANUAL-TESTING.md    ← template: the guide a story copies at 17-story-plans
└── AUTOMATED/                     ← per-story automated test records — written at 22
    ├── CONTEXT.md · CLAUDE.md
    └── US000-TEST-STATUS.md       ← template: the record a story copies at the closeout (half generated)
```

Filenames do not change with the folder: every real file is `MANUAL/US###-MANUAL-TESTING.md` or
`AUTOMATED/US###-TEST-STATUS.md`.

## Why two folders

The two records sat side by side while both were written at the same moment, the documentation
closeout. They no longer are. The manual guide is written **before** code, from the specs, so that
it says what the build should do before there is a build for it to agree with — a guide drafted
from the code can only confirm the code. The automated record is still written **after** code,
half of it generated from the suites' own reports. Two records with different authors, different
moments and different rules each got a folder, and each folder carries its own operating rules.

## Record-tier position

This is a **record** folder. A feature flows
`15-DECISIONS → 16-SPRINT-PLANS → 17-STORY-PLANS → code → 18-22 records`: the story plan (17) is
the master a developer codes from, and the 18–22 folders (tests, reviews, findings, bugs,
refactoring) capture what happened after the code shipped. The automated record is a record from
the start. The manual guide straddles the line — it is authored alongside the story plan as the
plan's executable half, is read at the Red phase, and becomes a record when it is walked.

## What sits beside them

Three record folders resemble each other and answer different questions — `../11-QA/`,
`../05-USER-FLOW/IMPLEMENTATION/`, and this one. The split between them, the accessibility evidence
that follows it, and which workflow writes which record when are this folder's `CLAUDE.md`.

## Cross-references

- `MANUAL/CONTEXT.md` · `AUTOMATED/CONTEXT.md` — the two record types
- `../02-STORIES/` — the user stories these records test
- `../17-STORY-PLANS/` — the per-story implementation plan the manual guide is authored beside
- `../11-QA/` — the QA plan (PLANNING) and review (IMPLEMENTATION) these records sit beside
- `../05-USER-FLOW/` — the consolidated journeys the manual guide's `Flow` column cites
- `code/docs/TESTING.md` · `code/docs/ACCESSIBILITY.md` — coverage floors and WCAG rules
- `code/src/scripts/tests/` — the runners, and the `test-record.sh` generator

**Last Updated**: <%DATE%>
