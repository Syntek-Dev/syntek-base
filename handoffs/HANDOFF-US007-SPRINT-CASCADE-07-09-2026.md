# HANDOFF — US007 cut, sprint cascade applied, cascade repair NOT applied

**Written**: 07/09/2026 · **Branch**: `pm/story-creation` · **HEAD at write**: `0b6543a`
**Workflows in play**: `project-management/workflows/02-story-creation/` (complete) ·
`03-sprint-planning/` + `16-sprint-plans/` Step 3, Review and Balance (**in flight**)

---

## Goal

Cut `US007` — the story `**Status:**` vocabulary reconciliation — and re-plan `SPRINT-01` to
`SPRINT-04` so it ships before `US002`. The story is written and the cascade is applied; a
verified repair list against the cascade is outstanding.

---

## Done

### `US007.md` — written, reviewed three times, **uncommitted**

`project-management/src/02-STORIES/US007.md` — 726 lines, 13 Gherkin scenarios,
**Must Have, 5 SP**, `**Status:** Open`, epic `Story Lifecycle`. Markdown lint clean.
`doc-references.sh` contributes no finding from it (identity diff, present vs moved-aside: empty).

**The twelve grilling decisions are recorded IN the story, not here** — read its Acceptance
Criteria. In brief: the eleven-value set in `project-management/docs/planning/STORIES.md` is
canonical and `.claude/skills/completion/SKILL.md` declares the five it may write; `Status` is
scoped per-register; the sprint set moves to `planning/SPRINTS.md`; the defining sentence goes
board-neutral; the sprint-plan `Status` column is ratified onto the eleven; `MAP-REGISTER-INDEXES.md`
`:215-219` is corrected as a **stated exception**, `:556` and `:213` explicitly are not.

**The story states methods, not figures.** Three review rounds established that pinned gate counts
go stale within the hour on this tree — `skill-conformance.sh` went red to green in 48 minutes,
`copier.yml` shifted three times. Do not reintroduce a quoted gate count.

### The cascade — applied to 14 files, **all uncommitted**

| Sprint      | Members, build order                                          | SP                     |
| ----------- | ------------------------------------------------------------- | ---------------------- |
| `SPRINT-01` | US007 (Must 5) then US001 (Must 5)                            | 10 / 11, CLOSED        |
| `SPRINT-02` | US002 (Must 3) then US003 (Should 5, stretch, carry reserved) | 8 / 11                 |
| `SPRINT-03` | US004 (Must 8), plus US003's carry if it slips                | 8 / 11, or 13 / 11     |
| `SPRINT-04` | US005 (Must 5) then US006 (Must 8)                            | 13 / 11, grace, CLOSED |

Files edited: the four `project-management/src/03-SPRINTS/SPRINT-0[1-4].md`; the three
`project-management/src/16-SPRINT-PLANS/0[1-3]-SPRINT-PLAN-0[1-3].md`; the five
`project-management/src/17-STORY-PLANS/STORY-PLAN-US00[1-5]-*.md`;
`project-management/src/02-STORIES/US003.md` and `US006.md`.

**Verified sound by three independent passes:** every story assigned exactly once, 39 SP scheduled
equals 39 SP across seven stories, all four FLAGS tables are true 13-row unions of their members,
all four goals name only what their final Story Summary carries, history superseded rather than
overwritten, no invented artefact, every story still `**Status:** Open`.

---

## In-flight

**A verified repair list against the cascade. NONE of it is applied** — the repair workflow was
stopped before it wrote. Confirmed on disk at 22:50: no file has changed since 22:33.

### The root cause, one mistake made nine times

Seven agents re-planned in parallel; each wrote that some other artefact was stale while a sibling
was fixing it. Nine passages now describe work this same change already did as outstanding, and
each points a reader away from a correct file. Live examples:

- `project-management/src/03-SPRINTS/SPRINT-01.md:229-235` — says `01-SPRINT-PLAN-01.md` is stale
  in capacity, story set, build order and index. All four were updated.
- `project-management/src/03-SPRINTS/SPRINT-02.md:305` — _"a reader should trust this record over
  it"_, about a plan that is now correct.
- `project-management/src/03-SPRINTS/SPRINT-03.md:137-139` — says `03-SPRINT-PLAN-03.md` is written
  for US005 and US003; it is now titled for US004. Also points at `02-SPRINT-PLAN-02.md` as holding
  US004 alone; it holds US002 and US003.
- `project-management/src/03-SPRINTS/SPRINT-04.md:268-277` — says `US006.md` still describes
  SPRINT-03 at 10 / 11. It was corrected the same day.
- `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md:229` — says
  `STORY-PLAN-US002`'s `| Sprint |` row _"is owed a repoint"_. It was repointed.
- Same class in `STORY-PLAN-US002:71`, `STORY-PLAN-US003:46`, `STORY-PLAN-US004:30`.

**Rule for the fix: open every artefact before describing it, and write against the delivered
tree.** Assume more instances than the eight above.

### Substantive errors, each verified

- **Four Markdown tables broken** — an HTML comment block sits between the last body row and the
  row after it, severing the trailing row from its table:
  `STORY-PLAN-US003-ABSENCE-GUIDE.md:116`, `STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md:101` and
  `:240`, plus at least one more. **`markdownlint` and `docs-length.sh` both pass on the broken
  form** — inspect structure by eye.
- **The `Status` column contradiction.** `01-SPRINT-PLAN-01.md:224` keeps `Not started` on the
  stated ground that correcting it is `US007` Scenario 8; `02-SPRINT-PLAN-02.md:319-320,328-331`
  corrected its cells to `Open`. **Settled: revert `02` to `Not started`** with a dated comment
  saying the value is knowingly false and the correction is the scheduled story's own — a re-plan
  does not pre-empt a live acceptance criterion.
- **`SPRINT-04.md:366-369`** says four rows are design-state `HIGH` for US005; the threat model
  carries three — TM-01, TM-02, TM-04. `03-SPRINT-PLAN-03.md` recorded this when it held the story
  and noted the assessment's own summary double-counts TM-02.
- **`SPRINT-01.md:116-118`** says US002's nine registrations need two rows each; `SPRINT-02.md:174-176`,
  `02-SPRINT-PLAN-02.md:112-114` and `US002.md:155` all say **three counted lines, 27 total**.
- **`STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md:167`** still names US002 as SPRINT-01 co-member.
- **`STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md:215-222`** — a new _Ordered behind US007_ clause
  sits seven lines above an untouched _"Can be done now: yes, in full"_.
- **`SPRINT-03.md:238-239`** says `US006.md` records SPRINT-04 as the sprint it opens; it is now
  that record's second member.
- **`SPRINT-02.md`** keeps a combined `syntax/lint.sh` + `check.sh` box while `SPRINT-01.md:351-354`
  split it with `check.sh` marked `N/A` per `code/docs/GATE-REPORTING.md`.
- **`SPRINT-04.md:192-193`** attributes "capacity 11 SP, grace 13 SP" to
  `project-management/docs/planning/CADENCE.md`, which carries unrendered Copier tokens. Nothing in
  this repository states 11 or 13. Arithmetic unaffected; the attribution is wrong.
- **`SPRINT-01.md:57-58` and `SPRINT-02.md:51-54`** cite SPRINT-03 for a flag-union spelling
  precedent whose text no longer survives there.
- Dead citations: `SPRINT-02.md:605`, `SPRINT-03.md:482-483`, `US006.md:206-207`.

### `US007.md`'s own citations into the re-planned files

`project-management/src/02-STORIES/US007.md` was written **before** the cascade and carries ~20
line citations into the seven re-planned artefacts. All stale. Worst first:

- **`:135`** — _"`SPRINT-03.md:155-156` currently sends this story to `SPRINT-04`"_. This is the
  last live text routing US007 to SPRINT-04. Those lines are now `## Notes` plus a blank; the
  routing survives only in a dated superseded comment.
- **`:299-300`** — the sprint-vocabulary routing comment cited at `SPRINT-01.md:13-14`,
  `SPRINT-02.md:16-17`, `SPRINT-03.md:14-15`, `SPRINT-04.md:14-15`; now at `:22`, `:24`, `:22`, `:23`.
- **`:418-422`** — the `Completed` / `Sprint **Status:** set to Done` pair across the four records.
- **`:425, :446, :515`** — into `02-SPRINT-PLAN-02.md` and `03-SPRINT-PLAN-03.md`; the passage about
  two plan rows differing deliberately now covers a **different pair**, so the Given needs rewriting,
  not renumbering.

**Prefer citing these seven files by section name over line number** — `US006.md` and
`03-SPRINT-PLAN-03.md` already do, and it is the durable form. Extend the story's own volatility
caveat (currently scoped to `copier.yml`) to cover them.

---

## Next

**Apply the repair list above to the fourteen cascade files, then re-resolve `US007.md`'s citations
against them — in that order, not in parallel.** Running both at once is what produced the nine
stale-debt passages. The stopped workflow's script is re-runnable (see Artefacts).

---

## Next skills

`sprint` + `global-workflow` for the records and plans (model **fable**, per
`03-sprint-planning/STEPS.md` and `16-sprint-plans/STEPS.md` frontmatter) · `story` for
`US007.md`'s citations · `version` + `git` at commit time.

---

## Open questions

**None on the design** — all twelve decisions are settled and recorded in `US007.md`.

Two scope calls the next session may want to put to <%DEVELOPER_NAME%>:

1. **`04-SPRINT-PLAN-04.md` does not exist.** `SPRINT-04.md` previously forbade a `16-sprint-plans`
   run before the carry-over question was settled; it now is. Authoring the plan is a fresh
   `16-sprint-plans` pass with its own grilling and prerequisite gate — deliberately out of scope
   so far.
2. **`STORY-PLAN-US006` and `STORY-PLAN-US007` do not exist.** Story plans exist for US001–US005
   only. `17-story-plans` owns them.

---

## One thing to check

**A second Claude Code session (`syntek-base-16`) is working in this tree** on a Wagtail CMS
integration, and has now started cutting `US008` — see the untracked
`handoffs/HANDOFF-US008-SLICE-SELECTION-07-09-2026.md`, which this session did not write.

It has modified `copier.yml`, `REFERENCES.md`, `.claude/skills/CONTEXT.md`, four
`code/workflows/*/STEPS.md`, four `project-management/workflows/*/STEPS.md` and three
`how-to/src/TEMPLATE-GUIDE*` files, and added `code/docs/WAGTAIL.md`, `code/docs/wagtail/`,
`.claude/skills/stack-wagtail/` and `research/WAGTAIL-CMS-INTEGRATION.md`.

Two consequences for this work:

- **`copier.yml` line citations in `US007.md` are volatile.** Measured shifts of +8, +35 and +5 in
  one afternoon. The story says so; re-resolve by quoted text, never trust a number.
- **If Wagtail introduces a page workflow state, that is another sibling register** `US007`'s
  scoping declaration should name. The declaration was deliberately written **non-exhaustive** for
  exactly this reason, so this is a check, not a blocker.

`git status` also shows `handoffs/HANDOFF-US007-SLICE-SELECTION-05-09-2026.md` **staged as
deleted** — deliberate, confirmed by <%DEVELOPER_NAME%> on 07/09/2026.

---

## Artefacts

| Path                                                                                                                                                                     | What it is                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| `project-management/src/02-STORIES/US007.md`                                                                                                                             | The story — **untracked**, 726 lines, 5 SP                                             |
| `project-management/src/03-SPRINTS/SPRINT-0[1-4].md`                                                                                                                     | The four re-planned records — **uncommitted**                                          |
| `project-management/src/16-SPRINT-PLANS/0[1-3]-SPRINT-PLAN-0[1-3].md`                                                                                                    | The three re-planned plans — **uncommitted**                                           |
| `project-management/src/17-STORY-PLANS/STORY-PLAN-US00[1-5]-*.md`                                                                                                        | `\| Sprint \|` rows repointed — **uncommitted**                                        |
| `project-management/src/02-STORIES/US003.md` · `US006.md`                                                                                                                | Move notes — **uncommitted**                                                           |
| `project-management/workflows/02-story-creation/`                                                                                                                        | Procedure of record for the story — complete                                           |
| `project-management/workflows/03-sprint-planning/` · `16-sprint-plans/`                                                                                                  | Procedures of record for the cascade — Step 3 outstanding                              |
| `GAPS.md` (01/09/2026 entry, `:337-359`)                                                                                                                                 | The gap `US007` closes. Its `MAP-RULE-OWNERSHIP` charting-home claim is untested       |
| `GAPS.md` (02/09/2026 entry, `:387-445`)                                                                                                                                 | Why `doc-references.sh` is red, and why it is not this story's to fix                  |
| `handoffs/HANDOFF-US007-STATUS-VOCABULARY-06-09-2026.md`                                                                                                                 | The prior handoff — its Round 1 is answered; prune it                                  |
| `/home/sam-dev/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/eedef3df-f4d4-487f-b4dd-c219835e51e8/tasks/wk5wo1g6z.output`                                    | The cascade's three verification passes, in full. **Local only**                       |
| `/home/sam-dev/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/eedef3df-f4d4-487f-b4dd-c219835e51e8/workflows/scripts/us007-cascade-repair-wf_6042a55c-66e.js` | The **stopped** repair script, carrying the full fix list. Re-runnable. **Local only** |
