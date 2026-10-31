---
name: completion
description: >-
  Own <%PROJECT_NAME%>'s PM status vocabulary and record its transitions — advance a `US###`
  `**Status:**` line through its lifecycle with a status-history row, tick the sprint's Story
  Summary, move a `SPRINT-##.md` to Done, and regenerate the boards. Load when a status
  transition has to be recorded against evidence already in hand, or the meaning of a status is
  in question. Not judging whether it passed
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
Recording `Accepted` is a claim that all three held; a fork that assumes them launders an
assumption into the record.

## The status vocabulary — this skill owns it

**This section is the single owner of every PM status word in the repository.** Templates,
folder pairs, workflows and the planning guides link here rather than restating it. The boards
(`*-BOARD.md`) are generated from the status lines alone, so a word not listed here lands in the
board's `Unrecognised` column and raises a warning.

**Status line format.** `**Status:** <Title>`, optionally followed by a spaced `— <note>` tail. Text after
the spaced `—` is a note and the parser ignores it (`**Status:** In Review — PR 124`).

### Stories (`US###.md`)

Board columns run in this order; the slug is the board column id and the JSON value.

| Status              | Slug                | Meaning                                                                |
| ------------------- | ------------------- | ---------------------------------------------------------------------- |
| `Open`              | `open`              | Written, not ready to start (every new story)                          |
| `Pending`           | `pending`           | Ready, waiting to be picked up or scheduled                            |
| `In Progress`       | `in-progress`       | Being built on a branch                                                |
| `In Review`         | `in-review`         | Code review and QA running                                             |
| `Accepted`          | `accepted`          | Passed internal review and QA                                          |
| `Customer Review`   | `customer-review`   | Handed to the customer on a staging deployment                         |
| `Customer Accepted` | `customer-accepted` | The customer signed it off                                             |
| `Rejected`          | `rejected`          | Failed internal review or QA                                           |
| `Customer Rejected` | `customer-rejected` | The customer turned it down                                            |
| `Blocked`           | `blocked`           | Waiting on its dependencies (other stories) to land first              |
| `Completed`         | `completed`         | The post-acceptance window has elapsed; later changes are chargeable   |
| `Closed`            | `closed`            | Archived — set **only** by `pm-archive.sh`, which moves it to archive/ |

**Transition rules:**

- **Never skip review.** Nothing reaches `Customer Review` or `Completed` without `Accepted`
  first — a skipped state is an unrecorded review.
- **Both rejections return the story to `Pending`.** `Rejected` and `Customer Rejected` are
  recorded as transitions (with a history row each), then the story moves on to `Pending` to be
  picked up again.
- **`Blocked` is a dependency wait**, not a difficulty flag. `pm-board.sh --warn` names a
  `Blocked` story whose dependencies are all `Completed` or `Closed`.
- **The customer gate.** The story's FLAGS table may carry a `Customer review` row. **Absent
  means customer review applies** (the default; in syntek-base the developer is the customer).
  `N/A` skips the three customer statuses: `Accepted` → (window) → `Completed`.
- **`Completed` is reached by the clock, not by a judgement.** Let **R** be the date the story
  entered `Customer Review` and **A** the date it entered `Customer Accepted`. It is ready for
  `Completed` at **max(A + `FEEDBACK_WEEKS`, R + `CUSTOMER_REVIEW_WEEKS` + `FEEDBACK_WEEKS`)**;
  for an `N/A` story, at the `Accepted` date + `FEEDBACK_WEEKS`. Both lengths are Copier answers
  read from `.copier-answers.yml`, defaulting to **2** and **4** weeks when absent.
- **`Closed` is the archive step.** Only `pm-archive.sh US###` sets it, from `Completed`, and
  moves the story and its story plan into `archive/`. Never hand-edit a status to `Closed`.

**Status history.** Every story carries a `## Status history` table — `| Date | From | To |
Note |`, dates DD/MM/YYYY — and **every transition appends one row**. The dates in it are what
the clock reads; a story without the table still parses, but no clock is computed and no
readiness warning is raised for it.

### Sprints (`SPRINT-##.md`)

`Planned` · `In Progress` · `Done` · `Closed`. **`Done`** — implementation has happened for
every story in it (each at `Accepted` or later). **`Closed`** — every story in it is `Closed`;
only `pm-archive.sh SPRINT-##` sets it, moving the sprint and its sprint plan into `archive/`.

### Feature maps (`MAP-*.md`)

`**Status:** Charting | Resolving | Blockers Clear | Complete | Closed`, plus a free-text
`**Status note:**` line. **`Complete`** — frontier and fog closed. **`Closed`** — every slice has
been cut into stories; only `pm-archive.sh MAP-<NAME>` sets it. A closed map is frozen: new work
on the area makes a new map. The status itself is advanced by `wayfinder`.

### Plans (`16-SPRINT-PLANS/`, `17-STORY-PLANS/`)

**No status line of their own.** Their board shows the parent's status — a story plan the
`US###` in its filename, a sprint plan the `SPRINT-##` in its filename — and they move into
`archive/` together with that parent.

### Archive and boards

- **`*/archive/` is frozen.** `pm-board.sh --check` fails on any edit to an archived file other
  than the rename into `archive/` and the reference-path rewrites `pm-archive.sh` makes.
- **Look a file up by ID** across its folder **and** its `archive/` — a move never breaks a
  reader.
- **Regenerate after every edit:**
  `bash project-management/src/00-ASSETS/scripts/pm-board.sh --write`. The `*-BOARD.md` are committed and generated (never hand-edited); their `.json` and
  `.html` siblings are gitignored. `pm-board.sh --warn` prints the readiness signals: a
  `Blocked` story with its dependencies landed, a story past its window (ready for `Completed`),
  a `Completed` story (ready to archive), a sprint whose stories are all `Closed`, and a
  `Complete` map with every slice cut.

## Before recording anything

1. **Read the whole story file** — looked up by ID in `project-management/src/02-STORIES/` or
   its `archive/`: the status line, the FLAGS table, the status history and the
   acceptance-criteria checklist, not just the line being edited.
2. **Verify rather than assume** — every acceptance criterion ticked, tests green, review and
   QA signed off for `Accepted`; the customer's sign-off for `Customer Accepted`; the window
   elapsed for `Completed`. An unmet condition stops this skill: report the gap. Where the
   quality itself is in question, that is `qa-tester`'s call, not a judgement to make here.
3. **The documentation hard gate applies.** A story whose implementation records or affected
   `CONTEXT.md` files are missing stays `In Review`. Report the gap; do not record it accepted.

## Recording a story transition

1. Set `**Status:**` to the new value, with any note after a spaced em-dash in the house style
   (`Accepted — merged in PR 124`).
2. **Append a `## Status history` row**: today's date, the old status, the new status, the note.
   A rejection appends two rows — the rejection, then the move back to `Pending`.
3. Tick any remaining acceptance-criteria checkboxes the verified work satisfies.
4. Where the story sits in an active sprint, update that sprint's Story Summary tick and
   re-evaluate the sprint below.
5. Regenerate the boards: `pm-board.sh --write`.

## Recording a sprint transition

A sprint moves `Planned` → `In Progress` when its first story starts, and to `Done` **only when
every story in it is `Accepted` or later**. Should- and Could-Have stories moved out instead of
reaching `Accepted` must be named as carried over.

1. Set the sprint `**Status:**` and mark each accepted story in the house style the sprint
   record already uses — the story number followed by a tick.
2. Name the carried-over stories explicitly.
3. Refresh the sprint's `**Last Updated**` date, then run `pm-board.sh --write`.
4. **Do not rebalance or re-point** — a backlog that needs reshaping is `sprint`'s work.
5. **Never set `Closed` by hand** — it is `pm-archive.sh SPRINT-##` once every story is `Closed`.

## Definition of done

Every transition recorded with its evidence and a status-history row; nothing advanced past a
state it had not reached; carried-over work named; boards regenerated; dates DD/MM/YYYY; the
artefacts edited but **not committed** — `git` owns that.

## Handoff

Report the transitions made (each story or sprint, previous status → new status, and the file
path), the evidence that justified each `Accepted` or `Completed`, anything left `In Review` or
`Blocked` and why, the carried-over stories, and any `pm-board.sh --warn` readiness signals
(including items now eligible for `pm-archive.sh`). Then name what is still owed: `qa-tester` to verify criteria,
`sprint` to rebalance a changed backlog, `doc-writer` for outstanding documentation, and `git`
to commit the updated artefacts.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/23-pr-and-review/` — a story is not complete until its PR merged
- `project-management/workflows/24-release/` — **the procedure of record** for sprint and
  release completion
- `project-management/workflows/22-implementation-documentation/` — the records the
  documentation gate above checks for

## Cross-references

- `project-management/src/02-STORIES/CLAUDE.md` — the story conventions and the status line
- `project-management/src/00-ASSETS/scripts/pm-board.sh` · `pm-archive.sh` — the boards and
  the archive step
- `project-management/docs/planning/STORIES.md` — the lifecycle in planning terms
- `project-management/src/03-SPRINTS/CONTEXT.md` — the sprint record and its Story Summary
- `project-management/docs/PLANNING-GUIDE.md` — the MoSCoW mix a Must-Have is judged against
- `.claude/plugins/git-tool.py` · `.claude/plugins/pm-tool.py` — read-only state detection
