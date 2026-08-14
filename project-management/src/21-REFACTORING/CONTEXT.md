# project-management/src/21-REFACTORING

Behaviour-preserving refactoring records, one per user story. The base repo ships this as a
**template-only scaffold**: a single per-story record template. Real records are added by
copying it — one per refactor, tied to the story whose code it tidies.

## Directory Tree

```text
project-management/src/21-REFACTORING/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
└── REFACTORING-US000-TEMPLATE.md     ← copy this to record a story's refactor
```

The folder ships template-only as a base-repo scaffold. A project copies the template per
refactor; real `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` records are added over time and
are not part of the base repo.

## Where it sits (record tier)

```text
14-DECISIONS → 15-SPRINT-PLANS → 16-STORY-PLANS → code → 17-21 records
                                                          (this folder — 19)
```

The specify (02–13) and decide & plan (14–16) tiers gate a feature into code; the record tier
(17-TESTS, 18-REVIEWS, 19-FINDINGS, 20-BUGS, 21-REFACTORING) captures what happened after. A refactoring
record is written during or after the code/PR phase, once the change has shipped.

## What the record captures

A behaviour-preserving structural change to a story's code — never a feature:

- Metadata: the story (`US###`) and its plan, the motivation type, date, status, and the
  isolated refactor commit
- Motivation & trigger, and the scope of files/modules touched
- A before → after summary of structure and line counts
- A **behaviour-preservation proof**: the same tests run green before and after, coverage not
  reduced, shipped as a separate commit via code workflow `11-refactor`
- Risk & rollback, and the verification commands run (`syntax/lint.sh`, `syntax/check.sh`,
  `audits/cloc.sh`, `tests/all.sh`)

## When to write it

When a refactor is identified — a code review note, a sprint retro, or a `cloc` limit breach —
and executed under `code/workflows/11-refactor/` (or the `refactor` skill) with no change in
observable behaviour. New behaviour belongs to a story, not here.

## Cross-references

- `../02-STORIES/` — the story a record closes the loop on
- `../16-STORY-PLANS/` — the code master the refactor tidies
- `../18-REVIEWS/` · `../19-FINDINGS/` · `../20-BUGS/` — sibling record-tier folders
- `code/workflows/11-refactor/` — the behaviour-preserving refactor procedure
- `code/CONTEXT.md` — the 750/800-line source-file limit this record answers to

**Last Updated**: <%DATE%>
