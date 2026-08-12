---
name: completion
description: >-
  Record that verified work is done in <%PROJECT_NAME%>'s PM artefacts — advance a `US###`
  `**Status:**` line through its lifecycle, tick the sprint's Story Summary, and close a
  `SPRINT-##.md` once every Must-Have story is complete. Load when a status transition has to
  be recorded against work that has already passed review and QA. Not judging whether it passed
  (`qa-tester`), not authoring or numbering the story (`story`), not rebalancing the sprint
  (`sprint`), and not committing the edited artefacts (`git`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow
---

# Record Completion (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable bookkeeping procedure whose output is an edited
artefact). You own the status bookkeeping, never the work and never the judgement behind it.

**Locale:** British English, dates **DD/MM/YYYY**.

---

## The brief arrives settled

A fork cannot ask whether the work really passed, so the brief must already carry: **which
story or sprint** is moving, **which transition**, and **the evidence** — review and QA
sign-off, green tests, documentation updated. **If the evidence is missing, return and say so.**
Recording `Completed` is a claim that all three held; a fork that assumes them launders an
assumption into the record.

## The status vocabulary

**Stories** (`**Status:**`, near the top of each `US###.md`): `Pending` · `Open` · `Blocked` ·
`In Review` · `Completed`. A story reaches `In Review` when it lands on a branch awaiting
review, and `Completed` only once review **and** QA have passed. **Never straight from
`Pending` or `Open` to `Completed`** — a skipped state is an unrecorded review.

**Sprints** (`**Status:**` in the `SPRINT-##.md` header): `Planned` · `In progress` · `Done`.

## Before recording anything

1. **Read the whole story file** — `project-management/src/02-STORIES/US###.md`: the status
   line and the acceptance-criteria checklist, not just the line being edited.
2. **Verify rather than assume** — every acceptance criterion ticked, tests green, review and
   QA signed off. An unmet criterion stops this skill: report the gap. Where the quality itself
   is in question, that is `qa-tester`'s call, not a judgement to make here.
3. **The documentation hard gate applies.** A story whose implementation records or affected
   `CONTEXT.md` files are missing stays `In Review`. Report the gap; do not record it complete.

## Completing a story

1. Set `**Status:**` to `Completed` — or `In Review` for the interim state — and append the
   merge or PR reference in the house style (`Completed — merged in PR 124`).
2. Tick any remaining acceptance-criteria checkboxes the verified work satisfies.
3. Where the story sits in an active sprint, update that sprint's Story Summary tick and
   re-evaluate the sprint below.

## Completing a sprint

A sprint becomes `Done` **only when every Must-Have story is `Completed`**. Should- and
Could-Have stories that slip do not block it, but each must be named as carried over.

1. Set the sprint `**Status:**` to `Done` and mark each completed story in the house style the
   sprint record already uses — the story number followed by a tick.
2. Name the carried-over stories explicitly.
3. Refresh the sprint's `**Last Updated**` date.
4. **Do not rebalance or re-point** — a backlog that needs reshaping is `sprint`'s work.

## Definition of done

Every transition recorded with its evidence; nothing advanced past a state it had not reached;
carried-over work named; dates DD/MM/YYYY; the artefacts edited but **not committed** — `git`
owns that.

## Handoff

Report the transitions made (each story or sprint, previous status → new status, and the file
path), the evidence that justified each `Completed`, anything left `In Review` or `Blocked` and
why, and the carried-over stories. Then name what is still owed: `qa-tester` to verify criteria,
`sprint` to rebalance a changed backlog, `doc-writer` for outstanding documentation, and `git`
to commit the updated artefacts.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/22-pr-and-review/` — a story is not complete until its PR merged
- `project-management/workflows/23-release/` — **the procedure of record** for sprint and
  release completion
- `project-management/workflows/21-implementation-documentation/` — the records the
  documentation gate above checks for

## Cross-references

- `project-management/src/02-STORIES/CLAUDE.md` — the story conventions and the status line
- `project-management/src/03-SPRINTS/CONTEXT.md` — the sprint record and its Story Summary
- `project-management/docs/PLANNING-GUIDE.md` — the MoSCoW mix a Must-Have is judged against
- `.claude/plugins/git-tool.py` · `.claude/plugins/pm-tool.py` — read-only state detection
