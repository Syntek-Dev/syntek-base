# STORY-PLAN-US011 — The four indexes that shipped blank get a row per instance, and each register stops claiming it is empty

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 03/10/2026                         |
| Branch | `us011/register-index-backfill`    |
| Sprint | SPRINT-07 · Wave 2 · build order 2 |
| Author | <%ORG_NAME%>                       |
| Status | `Blocked`                          |

<!-- BORN WITH ITS PREFIX, 03/10/2026. The number "12-" was reserved for this story on 21/09/2026,
     when US012's admission moved it from "11-", and was recorded in ../02-STORIES/US011.md ->
     Dependencies (the sprint-membership bullet, "at its reserved `12-`", which now records it taken
     up), in ../03-SPRINTS/SPRINT-07.md -> Dependencies, and, from 03/10/2026 until this change
     replaced it with this file, as a no-file row in ../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md ->
     Story Plans — the code master. The prefix is the
     story's position in the settled build order across the WHOLE backlog — US007, US001, US002,
     US003, US004, US005, US006, US008, US009, US010, US012, US011 — not its sprint and not a
     per-sprint counter, so US011 is twelfth, closing SPRINT-07 behind its Must. It is RENUMBERED
     whenever build order changes, which is the OPPOSITE of the sibling rule for the sprint plans: a
     sprint plan carries two numbers and a mismatch between them is information, while a story plan
     carries one, so its prefix must track build order or it says nothing. ./CLAUDE.md owns the
     rule.

     Re-derived 03/10/2026 at HEAD 19e89aa and confirmed still current at save. The sprint plans in
     their own exec-order sequence are 01- to 07-; ../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md builds
     US010 alone, US009's carry held in reserve and not landed; ../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md
     -> Build order builds US012 then US011. The tracked run is contiguous 00- to 11- at 19e89aa —
     US010's "10-" in 805efbd and US012's "11-" in 19e89aa — so this plan is the twelfth file. If
     US009's carry ever lands in SPRINT-06, US010 and US009 swap "09-" and "10-" and this prefix does
     not move (06-SPRINT-PLAN-06 -> Build order). The descriptor REGISTER-INDEX-BACKFILL matches the
     story's QA plan, as every existing pair does. Wave 2 is the story's place in its map's cutting
     order — slice S-05 of ../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md, after S-01 and S-02, cut
     together as US010, in that map's order sentence ("S-01 -> S-02 -> S-05 -> S-03") — and does not
     move with the sprint; build order 2 is second of {US012, US011}, the stretch tier behind the
     Must. -->

<!-- STEP 1 DREW ITS ROUND FROM THE RECORDED ANSWERS (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). The story's own rounds settled its scope between 20/09/2026 and
     27/09/2026 — the instance test, the ordering and its tie-break, the Updated source, the read rule
     it applies, its Should and its 8 SP — and gate 11 resolved thirteen AC-GAPs into it on
     27/09/2026. Four answers of 03/10/2026 bind this plan: the 17-story-plans grilling round 1 of
     that day, asked for US010 and US012 together, settled Q2 (one generated-tree grep over all seven
     index files, built by US010; US011 adds none and its task is recorded "N/A — superseded") and Q3
     (who reads a Summary as a stranger: a fresh Claude session given only the index file, its walk
     reviewed by <%DEVELOPER_NAME%>), and both bind US011; 16-sprint-plans grilling round 9 Q22 has the
     guide written straight after this plan and committed with it. Round 2 Q7 of the 17-story-plans
     series, the same day, was asked for US010's CONTEXT.md task and is worded for every shipped
     CONTEXT.md, so the story's identical task carries it (Key Decision 9). <%DEVELOPER_NAME%>
     confirmed on 03/10/2026 that nothing else was left to ask for US011, and the sprint values below
     are taken from ../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md as written, bar the wave, which the map's
     cutting order gives (the comment above), and the index shapes from
     ../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md as committed in 805efbd. One row
     of the manual testing guide could not be decided from the records once Step 7.2 read them
     together, and it was not guessed: it went to <%DEVELOPER_NAME%> as the guide's open question 1
     and was answered the same day, the recommended option of three (settled 03/10/2026,
     17-story-plans grilling round 4 Q8) — a fifth answer of 03/10/2026 binding this plan, recorded
     as Key Decision 11 below, and the row is written from it. -->

**Implements no ADR, and the absence is the story's own reading.** `../02-STORIES/US011.md` ->
_Decisions_ records none: its one candidate was subsumed on 21/09/2026 by
`../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (every row's Status, and
DECISION-INDEX's two tail values, read by one rule: the carrier value with bold markers, backticks,
any trailing HTML comment and everything from the first space-middle-dot-space removed, then
trimmed), which this story **applies** and does not own. Its citation criterion is read under
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (while
`doc-references.sh` is red, the criterion is a baseline captured before the first edit and read as
a diff, the baseline kept in the manual testing guide). Both read `Accepted`, measured 03/10/2026.
`../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` reads `Proposed`; this
story reads it under the rule and **does not edit it**.

> **`Blocked` is literal, and this is the second plan in this repository to carry it.**
> `./CLAUDE.md` makes any status other than `Blocked` an assertion that the blockers are cleared,
> and the parallel-worktree DAG reads it. US011 edits four files — STORY-INDEX, SPRINT-INDEX,
> DECISION-INDEX and STORY-PLAN-INDEX — that exist in no branch and no commit until US010 is
> **built** and lands; US010 reads `Open` and is unbuilt, measured 03/10/2026. There is no partial
> start and no draftable half: every row this story writes goes into a file US010 creates, under a
> tail and an ordering sentence US010 writes. That is the shape of
> `./06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` (committed `Blocked` in `c6df520`), not
> the build-order `Open` of US001's and US003's plans. **The story itself stays `Open`**:
> `../02-STORIES/US011.md:327` already says a story and its plan may carry different values, each
> mirrored in its own index and neither reconciled, and this plan adds a second such pair beside
> US005's. The sprint plan's row for this file reads "Not started", the value that column's own
> comment defines (`../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md`'s US005 row is the precedent for a
> `Blocked` plan), and does not mirror `Blocked`.

> **Source authority.** Where this plan and `../02-STORIES/US011.md` differ on **what must be
> true**, the story wins. Where they differ on the **shape of the four files** — their tails, their
> ordering sentences, their _How to read a row_ — US010's committed plan and, once built, the files
> themselves win, because US011 fills what US010 designs. Where this plan and the sprint plan differ
> on sprint facts, `../03-SPRINTS/SPRINT-07.md` wins over both. On how any gate's result is
> reported, `code/docs/GATE-REPORTING.md` wins over everything here. The QA plan reads
> `Signed off`, corrected in place 30/09/2026 and 03/10/2026, the second correction made in this
> change (Key Decisions 1 and 11).

Three template sections are dropped: the **Table of Contents** (none of the eleven sibling plans
carries one, re-measured 03/10/2026), the **As-Built Summary** (this plan is forward-looking) and
**Pre-existing bug fixes** (none is fixed en route; a defect the build finds beyond the story goes
to `../21-BUGS/`). The four per-layer sections are dropped under _Approach_, each with its reason.

---

## Problem Statement

**Why this story exists.** `../02-STORIES/US011.md` is SPRINT-07's stretch `Should`, cut on
20/09/2026 as slice `S-05` of `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` when `S-02` split at the
register seam. US010 ships seven register indexes; four of them — stories, sprints, decisions and
story plans — ship with no row, each carrying a visible `Backfill owed — US011` line, because the
backfill priced the unsplit slice at 13 SP or more. This story pays that debt: one row per instance
in each of the four, every row's Status mirrored from its own carrier under the one read rule, a
Summary a stranger can read, and the debt lines gone. Until it ships, a reader opening any of the
four registers finds an index that says, truthfully, that it is incomplete.

**Current state, measured 03/10/2026 at HEAD `19e89aa`.** Every figure here is re-counted at
implementation, and **none is a target** (`../02-STORIES/US011.md:309`).

- **No index file exists in any register.** US010 is unbuilt; the four files this story edits do
  not exist yet, which is why the plan reads `Blocked`.
- **Population, under each register's positive filename pattern** (settled 27/09/2026, grilling
  round 3 Q22), excluding `*TEMPLATE*` and the index by exact filename: 02-STORIES 12 · 03-SPRINTS
  7 · 15-DECISIONS 25 · 17-STORY-PLANS 11 — **55 tracked** at `19e89aa`, and 56 once this plan is
  committed, its own file being the twelfth plan. CUT-PLAN.md matches no pattern and is no
  instance. 20-FINDINGS and 21-BUGS hold zero.
- **Status values under the read rule:** every story `Open`; every sprint `Planned`; ADRs
  `Accepted` 17, `Superseded` 6, `Proposed` 2; plans `Open` 10 and `Blocked` 1 (06-), with this plan
  the second `Blocked`.
- **Six supersession chains, all symmetric** — each `Superseded by` answered by its replacement's
  `Supersedes`: US001 FULL-PATHS to UNVERIFIED; US002 REGISTER-SPLITS to SPLIT-TARGET, the one
  ending on a `Proposed` record; US008 FIRST-MINOR-MIGRATION-KEY to MIGRATION-KEY-DUAL-GATED; and,
  since 30/09/2026, the three AFTER-TESTS-SPLIT successors of US003's BASELINE-DIFF and US004's
  INSTANCE-ARTEFACT-CITER-TEST and REGISTER-ROWS-MAY-BIND-A-CLASS. The story's provenance counted
  three of twenty on 20/09/2026, and is corrected with a dated update in this change.
- **Nine groups of ADRs share both `US###` and Date**, two of them holding a same-date chain (US001
  and US002 on 02/09/2026) — the groups the decision index's tie-break orders.
- **Three carrier lines carry a trailing HTML comment the read rule strips**:
  `../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md:11` (Status), and the
  tail lines of the US002 pair (`:7` of REGISTER-SPLITS, `:6` of SPLIT-TARGET), each ending in a
  `doc-references: template-only` marker that must not travel into the index (QA plan EC-05).

**What this story delivers.**

1. **Four filled indexes.** STORY-INDEX, SPRINT-INDEX, DECISION-INDEX and STORY-PLAN-INDEX, each
   with one row per instance counted at implementation: the spine `Status · Instance · Summary ·
Updated`, the tail US010 designed for that register, in the order the file states.
2. **The supersession chain readable from DECISION-INDEX alone**, its `Supersedes` /
   `Superseded by` tail filled for every chain and read by the same strips as Status.
3. **The four `Backfill owed — US011` lines removed**, and the phrase removed from no other file.
4. **The records** — the population beside the cut-time 43, the rows the read rule normalised, the
   one `Proposed` chain head — written at `22-implementation-documentation`, which also writes the
   TM-10 window's `GAPS.md` entry at this story's gate-`22` pass.

**Explicitly out of scope**, each owned elsewhere and mirrored into _Deferred Items_:

- **The generated-tree literal grep.** US010 builds one `[3/4]` step over all seven index files,
  and this story adds none; its first automated criterion is read against that step's output on
  this story's landing run (settled 03/10/2026, 17-story-plans grilling round 1 Q2). This story
  edits no workflow and no script.
- **The index gate** — `S-03`, `N-003` and `N-004` — unscheduled (CUT-PLAN.md P8), and red on the
  four indexes until this story lands, which is why it follows (settled 21/09/2026, grilling round 1
  Q1).
- **The 20-FINDINGS and 21-BUGS indexes** — US010's presence clause, never this story's backfill
  (`../02-STORIES/US011.md:64-67`).
- **The map index, every seed and the three `shipped-*` scripts** — US010's; this story's diff
  leaves `.copier/`, `copier.yml` and `.github/` untouched.
- **Editing `ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`** — its sign-off is named as
  Follow-on in the read-rule record and scheduled nowhere.
- **`S-05`'s "42 at cutting"** on the map — known-stale and its owner's, `01-feature-map`.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                                            |
| ----------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Database / models / migration | —         | `DB: N/A`. No model, field, index or RLS policy                                                                                                  |
| Service layer                 | —         | No service and no Python                                                                                                                         |
| Django Ninja API              | —         | `API: N/A`. No router, endpoint, `Schema` or MCP tool                                                                                            |
| Frontend (templates)          | —         | `Frontend: N/A`. No template, component, partial or CSS                                                                                          |
| Infrastructure / DevOps       | —         | No CI edit since 03/10/2026 (Q2): the `[3/4]` job is read, never edited. The work is Markdown under `project-management/src/`, which never ships |
| GDPR / PII                    | —         | `GDPR: N/A`. The rows name planning artefacts, never people                                                                                      |

---

## Reference Documents (code/docs gate map)

Every row of the template's table was checked; the rows below are the ones that gate this story.

| Guide                                                                          | Why it binds this story                                                                                                                                                                                                                                     |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/GATE-REPORTING.md`                                                  | **The most load-bearing guide here.** The citation gate is read as a diff, `shipped-artefacts.sh` runs only in CI, the generated-tree grep is another story's step read for this one, and the coverage floor binds nothing. Each is a reading, never a pass |
| `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`               | Every Status cell and both DECISION-INDEX tail values — the carrier located by its key, never a line number; the strips applied to the value after the key                                                                                                  |
| `code/docs/FORWARD-VOICE.md`                                                   | Why every path that does not exist yet is written in double quotes below: `audits/doc-references.sh` reads a backticked token as a path that must resolve, comments included                                                                                |
| `code/docs/DOCUMENTATION-LENGTH.md`                                            | The four indexes are register artefacts under `src/` and exempt from the 300-line ceiling; `docs-length.sh` is run so the exemption is proved rather than assumed (the story's automated criterion)                                                         |
| `code/docs/DOCUMENTATION-PAIRING.md`                                           | An index file must never be read as either half of a register's `CONTEXT.md` + `CLAUDE.md` pair; `docs-pairing.sh` is the regression reading                                                                                                                |
| `code/docs/TESTING.md`                                                         | Read for what this story does **not** add: no Python, so no coverage figure to regress                                                                                                                                                                      |
| `how-to/docs/GIT-WORKTREES.md`                                                 | The loopback rule (`:63-65`): the final octet is the story number — see _Docker & Nginx Infrastructure_ for why `127.0.0.11` already appears in the tree                                                                                                    |
| `project-management/docs/QA-GUIDE.md` · `project-management/docs/GIT-GUIDE.md` | The walk-through shape the manual criteria take; the branch above                                                                                                                                                                                           |

**Every other row of the template's gate map is checked and absent, and the absence is the
reading.** URL, architecture, data structures, API design, security, encryption, RLS, rendering,
responsive, accessibility, design tokens, performance, scale, logging and Cloudinary bind nothing:
the story writes Markdown rows into four planning files, and its `DB`, `API`, `Frontend`,
`Backend`, `GDPR`, `Security` and `Logging` flags read `N/A`.

---

## Architecture Decision

**No architectural choice is made here; every structural fact is fixed upstream, and this plan
names which.**

| Fixed by                                                                                                   | What it fixes                                                                                                                                    |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `N-002` and `N-006` on `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` (settled 31/08/2026)                   | The spine `Status · Instance · Summary · Updated`, one file per register, a Summary written for a stranger rather than derived from the filename |
| `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (settled 21/09/2026, grilling round 1 Q5) | One read rule for every register's Status and for DECISION-INDEX's tail values                                                                   |
| Grilling round 1 Q6 (21/09/2026)                                                                           | `Updated` is the instance file's last commit date — the author date, in the commit's recorded offset                                             |
| Grilling round 1 Q7 (21/09/2026); round 3 Q17 (27/09/2026)                                                 | The four orders, and DECISION-INDEX's tie-break: a supersession predecessor before its successor, then filename                                  |
| Grilling round 3 Q22 (27/09/2026)                                                                          | The positive instance pattern per register, the index excluded by exact filename                                                                 |
| QA plan AC-GAP-7 and AC-GAP-13, written back 27/09/2026                                                    | A row cites by Markdown link; the Instance label is the descriptor where the filename carries one, the identifier where it does not              |
| `../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` -> _P2 — The content repairs_ (805efbd) | The four files' shape: spine, tail, ordering sentence and _How to read a row_, **no row and no placeholder row**, and the visible debt line      |
| 17-story-plans grilling round 1 Q2 (03/10/2026)                                                            | The generated-tree grep is US010's, one step over all seven index files; this story adds none                                                    |
| 17-story-plans grilling round 1 Q3 (03/10/2026)                                                            | Who reads a Summary as a stranger                                                                                                                |

**The four tails are US010's to design at its build**, bar DECISION-INDEX's `Supersedes` /
`Superseded by` pair, which is fixed (`../02-STORIES/US010.md` -> Index Tasks; QA-PLAN-US010
Section 2). So this plan does not name the other three registers' tail columns: it fills whatever
columns each file names, from the source that file's _How to read a row_ gives, and P0 records the
tails as US010 landed them.

**What this plan is free to choose, and chooses:** the start gate, the commit shape, and the order
of the four files — each a reversible call recorded under _Key Decisions_.

**No infrastructure dependency is introduced and no file approaches a limit.** The four indexes are
Markdown under `project-management/src/`, excluded from every generated project by `copier.yml:157`;
DECISION-INDEX, the largest, holds one row per ADR — 25 on 03/10/2026 — and the 750-line source
limit does not apply to a register artefact.

---

## Approach

### Not applicable — Database, Service Layer, API, Frontend

The template's four layer sections are dropped. This story adds no model, migration, service,
endpoint, `Schema`, template or component, and its `DB`, `API`, `Backend` and `Frontend` flags read
`N/A`. `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Phase Breakdown_ records phases 1 to 3 as
`N/A` with their reasons. The work is planned per phase below.

### Phase plan

| Phase | Deliverable                                                                                                                                                                                                                                                                         | Blocked by                                         |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| P0    | **The start gate and the baselines, before any edit** — US010 confirmed landed with the four files as its plan describes them; the pre-edit tree; the citation baseline by identity with its detector hash; the population, the carriers and the two out-of-scope registers re-read | US010 landed on `main`; the branch cut from `main` |
| P1    | **STORY-INDEX** filled and its debt line removed, one commit                                                                                                                                                                                                                        | P0                                                 |
| P2    | **SPRINT-INDEX** filled and its debt line removed, one commit                                                                                                                                                                                                                       | P0                                                 |
| P3    | **STORY-PLAN-INDEX** filled and its debt line removed, one commit                                                                                                                                                                                                                   | P0                                                 |
| P4    | **DECISION-INDEX** filled, its supersession tail complete, and its debt line removed, one commit                                                                                                                                                                                    | P0                                                 |
| P5    | **Close** — rebase onto `main`, re-count, re-check every row against the tree the landing commit carries, push, read the landing run, the citation diff against P0, the link and cell checks — then `22-implementation-documentation`                                               | P1 to P4                                           |
| —     | The automated test record, the implementation records and the TM-10 `GAPS.md` entry — **`22-implementation-documentation`'s**; the manual guide, authored at `17` before code, is `22`'s to walk                                                                                    | P0 to P5                                           |

**P1 to P4 are independent of one another**: each reads only its own register and writes only its
own index, so their order is a call (Key Decision 7), and a reviewer can read any one commit as a
whole register. **Each debt line leaves in the commit that fills its index** (Key Decision 6): no
commit on the branch carries an index that is filled and still declares its debt, or one that has
dropped its debt line with no rows beneath it.

**No backfill commit touches the story's own three files** (Key Decision 11; settled 03/10/2026,
17-story-plans grilling round 4 Q8). US011.md, this plan and SPRINT-07 change on the branch only in
their status carriers and in the task, checklist and Definition-of-Done ticks the story's Tasks and
gate `23` require. **Each status flip is a commit of its own, touching only that carrier** — a
US011.md flip carrying the `project-management/export/clickup/US011-CLIENT.md` the pre-commit hook
regenerates — and no tick rides in a backfill commit. So once P0's start gate passes and its
captures are pasted into the guide, this plan's `Blocked` to `Open` flip is a commit of its own,
and the story's `In Progress` flip and this plan's are two more (_Status Propagation & ClickUp
Sync_).

**Every phase is testable on its own:** P0 by the recorded captures; each of P1 to P4 by that
index's row-by-row walk, its link and cell counts and the scoped citation run; P5 by the landing
run, the re-count against P0's, and the diff against the baseline.

### P0 — The start gate and the baselines

**The start gate is SPRINT-07's Definition of Done row, read before anything is written: "US010
landed before US011 started — confirmed, not assumed."** On `main`, with the branch cut from it:

- the four files exist at "project-management/src/02-STORIES/STORY-INDEX.md",
  "project-management/src/03-SPRINTS/SPRINT-INDEX.md",
  "project-management/src/15-DECISIONS/DECISION-INDEX.md" and
  "project-management/src/17-STORY-PLANS/STORY-PLAN-INDEX.md";
- each carries the spine, its tail named in the file, its ordering sentence, `## How to read a row`,
  no row, no placeholder row, and one visible `Backfill owed — US011` line (US010's plan, ES-17).

**If any of that is absent, the build does not start** (QA plan ES-09) — US012 can, and the shortfall
is US010's, routed there. The tails, ordering sentences and reading rules are recorded as landed;
the build fills those, never this plan's expectation of them.

Then, still before the first edit, each pasted into the guide's _Recorded during the build_ at
capture and never reconstructed afterwards:

| Baseline                               | How it is taken                                                                                                                                                                                                                                                                                                      |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pre-edit tree                          | `git rev-parse HEAD` and the `git status --porcelain` count — the anchor of the population, carrier and citation baselines. **Not** what the guide's diff rows read: P5's rebase would carry everything `main` gained since P0 into a diff against it, so they read the story's own commits from the base P5 records |
| Citation gate, whole tree, by identity | `bash code/src/scripts/audits/doc-references.sh`, normalised to `(file, kind, token)`, line dropped, multiplicity kept; `git hash-object code/src/scripts/audits/doc-references.sh` and the index state beside it                                                                                                    |
| The population                         | QA plan Section 6's command, per register, with its date and HEAD — beside the cut-time 43, never inherited from it or from this plan's 55                                                                                                                                                                           |
| The two out-of-scope registers         | 20-FINDINGS and 21-BUGS counted under their patterns: zero, or the instance handed back to US010's presence clause and not absorbed (EC-12)                                                                                                                                                                          |
| The carriers                           | Each register's carrier re-read — three bold `**Status:**` prose lines, one backticked `Status` table cell — and every value the read rule changes beyond the plans' backticks and padding listed (EC-10)                                                                                                            |
| US007 and US012 landing state          | Whether either has landed on `main`: US007 may have changed a status vocabulary (EC-13), and US012 edits a script this story must leave unchanged by its own diff                                                                                                                                                    |

### P1 to P4 — The four backfills

**Every row, in every index, is built the same way** — the spine scenario of
`../02-STORIES/US011.md`, under the rules each file states:

| Cell      | Source                                                                                                                                                                                                                                                             |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Status    | The carrier located by its key — the first line beginning `**Status:**`, or the first table row keyed `Status` in a plan — read under the read rule. Mirrored verbatim; never translated into another register's vocabulary; a story and its plan never reconciled |
| Instance  | A Markdown link to the file, resolving from the index's own folder, labelled with the descriptor where the filename carries one and the identifier where it does not — never the filename with its extension                                                       |
| Summary   | One line of plain English for a reader who has not opened the artefact — never the filename restated in prose; no hard line break; any pipe escaped                                                                                                                |
| Updated   | `git log -1 --format=%ad --date=format:%d/%m/%Y -- <file>` — the author date in the commit's recorded offset, never `format-local:` and never a date copied from the file's own header                                                                             |
| Tail      | Each column the file names, filled from the source its _How to read a row_ gives; in DECISION-INDEX, `Supersedes` and `Superseded by` read by the same strips as Status, so no comment or marker travels into a cell                                               |
| Citations | By Markdown link. Any backticked reference in a row is a full relative path: a bare backticked story, sprint or prefixed-plan token is a `doc-references.sh` Check 2 finding in an index file today                                                                |

**The four orders, as the story states them and US010 writes them into each file:**

| Index            | Carrier                                          | Order                                                                                                                                      | Instance label |
| ---------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ | -------------- |
| STORY-INDEX      | First line beginning `**Status:**`               | Ascending by identifier                                                                                                                    | Identifier     |
| SPRINT-INDEX     | First line beginning `**Status:**`               | Ascending by identifier                                                                                                                    | Identifier     |
| STORY-PLAN-INDEX | First table row keyed `Status`, value backticked | Ascending by the build-order prefix; a row renamed in the change that renumbers its plan                                                   | Descriptor     |
| DECISION-INDEX   | First line beginning `**Status:**`               | By `US###` then Date ascending; within a group sharing both, a supersession predecessor before its successor, otherwise filename ascending | Descriptor     |

**Three cases the build meets on today's tree, each already settled:**

- **ADR-US004-CITED-PLAN-PREFIX's Status line** carries a trailing comment; the rule reads it
  `Proposed`, the row string-equals that, and the ADR is not edited (the story's trailing-comment
  scenario; QA plan HP-05).
- **The US002 chain ends on a `Proposed` record**: both rows mirrored verbatim, the chain noted in the
  implementation record as ending on a record not in force, never reconciled and never dangling (QA
  plan EC-04).
- **ADR-US006-OVERRIDE's Date line** continues after a middle dot with a correction note; its
  ordering key is the leading date (QA plan EC-08).

**DECISION-INDEX lands last** (Key Decision 7), so its chain walk and its tie-break are read over the
whole register in one commit, and every other index has been reviewed by then.

### P5 — Close

1. **Rebase onto `main`, record the base, and re-count.** Record `git merge-base main HEAD` after
   the rebase — the base every diff row of the guide reads the story's own commits from — then run
   the population command again at the commit that will land, and compare with P0's. A plan
   renumbered in between is renamed in its row in the same change (QA plan EC-11); an instance
   added in between gets its row; an instance with uncommitted edits at P0 is re-read against the
   tree the landing commit carries (EC-16).
2. **The rows about the story's own work.** US011.md, this plan and SPRINT-07 may change in the
   commit that lands this story (EC-09). Each such row mirrors its file **as committed**, and its
   `Updated` is written with the intended date and **re-checked once the commit exists** — an amend
   or a rebase keeps the author date, so the re-check holds. What those three files may carry in
   the story's diff is settled (Key Decision 11; settled 03/10/2026, 17-story-plans grilling round
   4 Q8): their status carriers and the task, checklist and Definition-of-Done ticks the story's
   Tasks and gate `23` require, nothing else — each status flip a commit of its own touching only
   that carrier, a US011.md flip with the ClickUp export the hook regenerates, and no tick in a
   backfill commit. Before the push, the story's commits are listed with the files each touches —
   the listing REACH-03 reads — and a tick or a flip found in the wrong commit is split out then,
   while the rebase is open, rather than explained at the walk.
3. **Push and read the landing run** — the `[3/4] Template Generation` job on every render path,
   its run ID recorded: US010's generated-tree grep step for this story's first automated criterion
   (Q2), the `shipped-artefacts.sh` self-test and full check, and US010's link-check step over the
   in-tree indexes, which now carry this story's rows.
4. **The citation diff.** The whole-tree run normalised the P0 way and diffed against the baseline
   by identity: a new line in a file this story edits is this story's; one outside it is a
   concurrent change's, named with its file. A detector moved since P0 makes the diff
   **detector-confounded**. If US004 has landed and the gate is green, the plain-pass reading
   applies.
5. **The link, cell and debt checks** over the four indexes (QA plan Section 6), each recorded with
   its counts; `docs-length.sh` and `docs-pairing.sh`; Markdown lint and format, scoped.
6. Then `22-implementation-documentation` walks the guide and writes the records.

---

## Key Decisions

| Decision                                               | Chosen                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Rejected / Alternative                                                                      | Reason                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. The generated-tree grep                             | **US011 adds none.** Its task is recorded "N/A — superseded" in the story, its first automated criterion read against US010's one `[3/4]` step over all seven index files on this story's landing run                                                                                                                                                                                                                                                                                                                                                                                 | US010 building the step and US011 extending its pattern in place; two separate steps        | One check, one owner: US010's pattern already covers the four registers. **Settled 03/10/2026, 17-story-plans grilling round 1 Q2.** QA plan HP-11, which expected the workflow to change by this story's step alone, is corrected in place in this change, in that file's corrected-in-place shape; SPRINT-07's record and plan are amended where they said US011 adds the step                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 2. Who reads a Summary as a stranger                   | A **fresh Claude session given only the index file**, one session per index, its walk reviewed by <%DEVELOPER_NAME%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | A person other than the developer; the developer reading each line before opening its file  | The only reader guaranteed not to have opened the artefacts in a one-developer repository; the guide template's sign-off already admits Claude with a human reviewer. **Settled 03/10/2026, 17-story-plans grilling round 1 Q3.** One session per file because a session that has read one index has been given more than "only the index file" — the reading US010's guide takes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| 3. This plan's Status                                  | **`Blocked`**, the story staying `Open`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `Open` with a live blocker, the US001 / US003 shape                                         | The four files do not exist until US010 is built; there is no partial start (`./06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`, committed `Blocked` in `c6df520`). `../02-STORIES/US011.md:327` already has a story and its plan each mirrored, never reconciled. **Confirmed by <%DEVELOPER_NAME%> 03/10/2026, 17-story-plans Step 1** (nothing left to ask for US011), from the Step 1 mapping of 01/10/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 4. Sprint values                                       | SPRINT-07, `Should`, build order 2, prefix `12-` and the drop-branch disposition, from the sprint plan; Wave 2 from the map's cutting order; branch `us011/register-index-backfill`                                                                                                                                                                                                                                                                                                                                                                                                   | Re-deriving any of them here                                                                | SPRINT-07, `Should`, build order 2, prefix `12-` and the drop branch are `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`'s to fix, taken as written — the drop branch from its _Sprint Definition of Done_: a dropped US011 is disposed of in writing on exactly one branch, its placement owed to `03-sprint-planning`, landing ahead of `S-03` wherever it lands. That plan states no wave: Wave 2 is derived from `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`'s order sentence, as the header comment records. The branch is this plan's, under `project-management/docs/GIT-GUIDE.md`'s `us###/<short-desc>` and five words or fewer. **Confirmed by <%DEVELOPER_NAME%> 03/10/2026, 17-story-plans Step 1** (nothing left to ask for US011)                                                                                                                                                                                                                                                                                                                                                                       |
| 5. The four files' shape                               | **As US010's committed plan describes it, and as US010 lands it** — recorded at P0 and filled as found                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Naming the three undecided tails here                                                       | The tails are US010's to design at its build; a plan that named them would write a second, unreviewed design (`../02-STORIES/US010.md` -> Index Tasks). The shapes are taken from `./10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` as committed in `805efbd`. **Confirmed by <%DEVELOPER_NAME%> 03/10/2026, 17-story-plans Step 1** (nothing left to ask for US011)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| 6. Commit shape                                        | **One commit per index, its debt line removed in the same commit as its rows**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | One commit for all four; the debt lines removed in a closing commit                         | A reviewer reads one whole register per commit, and no commit leaves an index both filled and declaring its debt, or neither. **This plan's call, 03/10/2026, reversible**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 7. The order of the four                               | STORY, SPRINT, STORY-PLAN, then DECISION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Any other order                                                                             | Nothing reads across indexes, so the order is free; the decision index carries the tail, the tie-break and the chain walk, and lands last so it is read whole. **This plan's call, 03/10/2026, reversible**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| 8. Figures                                             | **Counted at implementation; no literal is a target**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Carrying 43, 47, 53 or this plan's 55 forward                                               | `../02-STORIES/US011.md:309`; the QA plan's dated literals (HP-01's 47, HP-04's plan counts, ES-04's 12 of 36, AC-GAP-3's chain and group figures, Section 7) are readings of their date, and neither this plan nor its guide copies them as current. Only its undated statements were false of the tree — HP-06's and EC-07's three chains (six since 30/09/2026), EC-01's "Nine" plans, EC-03's list of instances written after cutting and EC-07's "seven today" groups — and each is corrected in place in this change, with Section 1's opening paragraph and the US011.md citations the 30/09/2026 re-measurement left three lines short. **Confirmed by <%DEVELOPER_NAME%> 03/10/2026, 17-story-plans Step 1** (nothing left to ask for US011)                                                                                                                                                                                                                                                                                                                                                            |
| 9. A register `CONTEXT.md` whose index wording changes | `**Last Updated**` keeps the copier date token, the edit dated in a comment — **none expected**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | A literal date in a shipped file                                                            | Q7's answer (settled 03/10/2026, 17-story-plans grilling round 2 Q7, on `../17-STORY-PLANS/CONTEXT.md`'s precedent of 08/09/2026) was given for US010's identical task and is worded for every shipped `CONTEXT.md`, which each register `CONTEXT.md` is: a literal date would ship into every generated project. The story's Documentation Task asked for the date updated, so it is **amended in place in this change** to carry that answer (`../02-STORIES/US011.md:472`, the shape `../02-STORIES/US010.md` took for the same task), and the story and this plan agree. US010 writes each `## The index` section as present, so this story expects to change none                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 10. The estimate                                       | Stays **8 SP**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Re-estimating after Q2 removed the grep task                                                | The 8 was priced on the hand-written Summaries, not on the grep (`../02-STORIES/US011.md:175-179`; settled 27/09/2026, grilling round 4 Q26). Nothing this plan adds is priced. Carried                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 11. What the story's own files may carry in its diff   | **US011.md, this plan and SPRINT-07 carry their status carriers and the task, checklist and Definition-of-Done ticks the story's Tasks and gate `23` require, and nothing else**; each status flip a commit of its own, touching only that carrier, a US011.md flip carrying the `project-management/export/clickup/US011-CLIENT.md` the pre-commit hook regenerates; no tick in a backfill commit; every other instance file of the four registers untouched. QA plan HP-11 and PA-03 and the story's Documentation Task are corrected in place in this change to name the exception | Strict: no instance file in the diff at all; status carriers only, ticks recorded elsewhere | The records disagreed. QA plan HP-11 and the story's Documentation Task said no instance file is touched or edited; the spine scenario (`../02-STORIES/US011.md:317`) and EC-09 anticipate these files changing in the landing commit; the story's Tasks are marked complete before a PR (`:430`) and its Definition of Done checks them off (`:531`); `23-pr-and-review` Step 3 commits the `In Review` flip on the branch; and the lefthook `clickup-export` hook re-stages the export with any staged story, so a story flip carries the export beside its carrier (_Status Propagation_). The strict option is at odds with `:430` and with gate `23`'s branch commit; carriers and export alone, with `:430` and `:531`. A walker could not mark REACH-03 from the records alone, so it was asked, never guessed (`../18-TESTS/MANUAL/CLAUDE.md` -> _Authoring_). **Settled 03/10/2026, 17-story-plans grilling round 4 Q8**, the recommended option of three; the guide's REACH-03 and REACH-02 are written from it, and SPRINT-07's US011 task row that mirrors the Documentation Task is amended with it |
| 12. The citation baseline                              | Captured at P0, in the guide's _Recorded during the build_, with the detector's hash                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | A bare pass while the gate is red                                                           | `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`; the story's automated criterion. **`Accepted` 30/09/2026**, <%DEVELOPER_NAME%> deciding: the record restates unchanged, but for the guide's path, the decision of 02/09/2026 it supersedes (settled 30/09/2026, 16-sprint-plans grilling round 6 Q17 and round 7 Q18), and names no section of the guide, which `../18-TESTS/MANUAL/CLAUDE.md` -> _Recorded during the build_ supplies. The criterion carries the developer's call of 20/09/2026 to wait for US004 rather than add interim markers (`../02-STORIES/US011.md:397-398`). Carried                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

---

## Dependencies

| Story / Artefact                     | Model / Feature                                                                                            | Required for                                                                                                  | Current state                                                                                     |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **US010**                            | Creates the four files, their tails, ordering sentences and debt lines; builds the grep and the link check | **Every row this story writes.** Hard blocker — SPRINT-07's Definition of Done row                            | `Open`, unbuilt; its plan written 03/10/2026 (`./10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md`) |
| US012                                | Edits `.github/scripts/shipped-artefacts.sh`                                                               | Nothing — this story's "unchanged" criterion reads its own diff, and holds whichever lands first              | `Open`, SPRINT-07's `Must`, builds first                                                          |
| US007                                | Settles the story `**Status:**` vocabulary                                                                 | Nothing — every row mirrors whatever vocabulary is found (EC-13)                                              | `Open`, SPRINT-01                                                                                 |
| US004                                | The citation gate's repair                                                                                 | Nothing — the gate is read as a baseline diff until it lands                                                  | `Open`, SPRINT-03                                                                                 |
| The register-index map's `S-03`      | The index gate that will read these files                                                                  | **Blocked by this story** — `N-003`'s presence clause is red on the four debt-carrying indexes until it lands | Unscheduled (CUT-PLAN.md P8)                                                                      |
| `pm/story-creation` merged to `main` | Every planning artefact this story rests on                                                                | Cutting the `us011/` branch from `main`                                                                       | Not merged (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Branch Naming Reference_)               |

**The `Current state` column is the one the parallel-worktree DAG reads**, and its first row is
why this plan reads `Blocked` rather than `Open`.

- **Blocked by:** **US010**, absolutely. Not build order — the four files this story edits do not
  exist in any branch or commit until US010 is built and lands, and US010 is SPRINT-06's sole
  member, one sprint ahead.
- **Blocks:** `S-03` on `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` — the index gate, unscheduled,
  which cannot land green before this story (settled 21/09/2026, grilling round 1 Q1). No story
  waits on it.
- **Runs beside, blocks neither:** US012, in the same sprint and the same `[3/4]` job.
- **Can be done now:** **nothing.** This is the honest answer and the reason the status reads
  `Blocked`. P0's first read is the start gate itself, and every capture after it is taken on a
  branch cut from a `main` that holds US010.

> No cross-cutting programme plan (`17-STORY-PLANS/PLAN-<DESCRIPTOR>.md`) exists in this repository,
> measured 03/10/2026, so there is no serialisation gate to cross-reference beyond US010.

---

## GDPR

**`N/A`, and the flag reads `N/A` in the story.** The indexes list planning artefacts; no field, no
store, no personal-data path, no data subject. `09-gdpr-compliance` did not run, its entry condition
being absent (`code/docs/GATE-REPORTING.md`).

---

## Security

**`N/A` by flag, with the story's reason, and no security artefact is owed** (settled 28/09/2026,
16-sprint-plans grilling round 1 Q2). This story writes real syntek-base rows into four in-tree files
whose `.copier/` seeds must stay blank, and a leak would ship this repository's backlog into every
generated project for good — a genuine one-way door. **The control for it is US010's**: `ST03`,
`ST04` and `ST06`, gated in `.github/scripts/shipped-registers.sh`. This story introduces no control
and changes none; it is exercised by that one. **That is a flag reading, never "the security gate
passed"**: no security check runs for this story. There is no mutation, so no permission or
ownership check is owed (OWASP A01 has no subject).

**US010's two signed-off security plans are the only security artefacts naming this story** —
the threat model and the assessment, whose Sections 7.11 and 7.12 restate TM-10's and TM-09's
mitigations as criteria — and six threat-model rows bear on it (re-read 03/10/2026). They are
carried in so the implementer knows what this story's rows arm and what its own wording owes:

| Row (US010's threat model)                                                             | Severity | What it says of this story                                                                                                                                                                                                                                                                                                                                                             |
| -------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-03 — a seed cut from a populated in-tree index is a one-way door                    | MEDIUM   | **Promotes to HIGH** when a seed is refreshed from its in-tree sibling after this story has written its rows beside it (Section 3a). This story's diff touches no seed, and the guide's REACH rows and the family run prove it                                                                                                                                                         |
| TM-02 — an `_exclude` negation re-including an index path leaks this repository's rows | MEDIUM   | This story's diff adds no `_exclude` line (QA plan PA-02); US010's family goes red on one                                                                                                                                                                                                                                                                                              |
| TM-10 — the four indexes read complete with no gate once this story ships              | LOW      | The window runs from this story shipping until `S-03` is cut, `S-03` unscheduled. **Its `GAPS.md` entry is this story's**, written at its gate-`22` pass, because the window opens when it ships (call recorded 27/09/2026 with round 6)                                                                                                                                               |
| TM-09 — `SEEDED` is an allowlist, already being read as a control                      | LOW      | `shipped-artefacts.sh` admits each seeded path by name and cannot read content, so its green is never evidence that a filled index stayed out of a generated tree — the grep and US010's seed family are (the guide's GEN-02 and SCRIPT-01). Its mitigation binds wording: `SEEDED` is described as an allowlist wherever it is cited, this story's records included (assessment 7.12) |
| TM-11 — two stories gave three answers to "what is a row's Status"                     | LOW      | Its control is the one read rule (`../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`), which every Status and tail cell here applies; a row read any other way re-opens the divergence `S-03`'s string-equality would false-red on                                                                                                                                       |
| TM-17 — nothing records who changed an index row                                       | INFO     | Accepted residual: `Updated` is a last-commit date, and a register file is not the audit trail                                                                                                                                                                                                                                                                                         |

---

## Logging & Observability

**`N/A`, and the flag reads `N/A`.** This story emits no log line.

---

## Performance, Rendering, Responsive & Accessibility

**All four are `N/A`, each for its own reason.** Performance: four Markdown tables, no request path.
Rendering and responsive: no rendered surface — Markdown read in an editor or a repository browser.
Accessibility: no interactive component, but one property is held — each Instance link is labelled
with a descriptor or an identifier rather than a filename, the index's version of link purpose
being clear from the link text (WCAG 2.2 success criterion 2.4.4; QA plan Section 3, HP-02).

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `11-qa-checks` ✅ (`Signed off` 30/09/2026,
corrected in place 03/10/2026) → `15-decisions` ✅ (no ADR of its own; the read rule `Accepted`) →
`16-sprint-plans` ✅ (`../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`, 03/10/2026) → `17-story-plans`
**(this plan and its guide)** → the backfill below → `22-implementation-documentation` →
`23-pr-and-review` → `24-release` when a version is cut.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` all read `N/A`, and since
Q2 this story has no build lane either: it writes Markdown alone, the shape of
`./02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`'s chain. `04` to `10`, `12`, `13` and `14` did
not run, each because its entry-condition flag reads `N/A`.

### Code workflows invoked

**None for code.** `07-review` gates the PR content. No stack skill applies — the diff is Markdown.

### Standards gates

| Gate                        | Applies                                                                                                                                                     |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh`  | **Yes** — the baseline by identity at P0, scoped runs per index after each phase, the whole-tree diff at close; never a bare pass while the baseline stands |
| `audits/docs-length.sh`     | **Yes** — run over the four indexes so the register-artefact exemption is proved, not assumed                                                               |
| `audits/docs-pairing.sh`    | **Yes** — regression only: no directory is created, and an index must not be read as half of a pair                                                         |
| `syntax/lint.sh`            | **Yes, the Markdown leg** over each changed file                                                                                                            |
| `syntax/format.sh`          | **Yes** — Prettier over each changed Markdown file; a Summary containing a pipe must survive it escaped                                                     |
| `syntax/check.sh`           | Regression only — basedpyright reads `code/src/django/`, and this story writes no Python                                                                    |
| `tests/all.sh --coverage`   | Regression only — no application code, so the floor has nothing to bind                                                                                     |
| `audits/doctrine-drift.sh`  | Regression only — a green run says **nothing** about a row's Status; that is the walk's job                                                                 |
| `audits/routing-skills.sh`  | `N/A` — no routing frontmatter is added                                                                                                                     |
| `database/migrate.sh check` | `N/A` — no model                                                                                                                                            |

---

## Execution & Verification via Claude Dynamic Workflows

**The internal procedure comes first** (`.claude/CLAUDE.md` Section 2.7): each stage names the
workflow it executes.

### Stage 0 — Plan verification (before any code)

This plan and its guide are reviewed adversarially at `17-story-plans` Step 9 before either is
treated as codeable. Before building, the implementer re-resolves every line number here **by quoted
text**: every anchor is as at `19e89aa`, and US010 landing moves many of them.

### Stage 1 — Build (one register at a time)

Per index: read the file US010 landed → list the register by the instance pattern → write each row
from its file, never from memory or from another index → order the rows by the file's own sentence
→ remove the debt line → run the scoped checks → commit. A fan-out per index is natural — the four
read disjoint registers — but each index's Summaries come from reading its own artefacts, never from
a summary of them.

### Stage 2 — Continuous verification gates

After each phase: `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <file>`,
`bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`,
`bash code/src/scripts/audits/doc-references.sh --path <file>`, and that index's link and cell
counts. **Every gate is scoped to this story's paths**: US012 may be in flight in a sibling
worktree, and a repo-wide `--fix` cannot be proved not to have touched its files.

### Stage 3 — Review (before raising the PR)

`code-reviewer` for standards and spec, then `qa-tester` for the hostile pass, each dispatched
independently and named in the prompt; **no skill reviews its own work**. A `security` pass is not
dispatched: no auth, permission, PII or endpoint is in scope, the flag reading `N/A`.

### Stage 4 — Behavioural verification

The manual guide, walked at `22`: the row-by-row reads, the legibility readers, the chain walk, the
CI run read by its recorded ID, and the planted mutations in a separate checkout, never this working
tree.

### Stage 5 — PR and release

`23-pr-and-review` → `24-release` if a version is cut. The diff never ships —
`/project-management/src/**` is excluded from every generated project — so whether it earns a bump
is `24-release`'s to judge under `project-management/docs/VERSIONING-GUIDE.md`.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**This story runs no container.** Every gate it needs runs on the host; the generated trees are
CI's.

### Canonical commands

| Purpose                   | Command                                                                           |
| ------------------------- | --------------------------------------------------------------------------------- |
| Markdown lint             | `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <file>`         |
| Format                    | `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <file>` |
| Citation gate, scoped     | `bash code/src/scripts/audits/doc-references.sh --path <file>`                    |
| Length gate               | `bash code/src/scripts/audits/docs-length.sh --path <file>`                       |
| Pairing gate              | `bash code/src/scripts/audits/docs-pairing.sh --path <dir>`                       |
| The seed family           | `bash .github/scripts/shipped-registers.sh` and `--self-test`                     |
| The update probe          | `bash .github/scripts/shipped-ai.sh --self-test`                                  |
| The generated-tree checks | CI's `[3/4] Template Generation` job only — read by run ID                        |

### The exceptions, and why each is allowed

1. **`.github/scripts/*.sh` run directly.** They are the project's own wrappers for the template
   seam; `shipped-registers.sh` and `shipped-ai.sh` run locally as well as in CI, and this story runs
   them only to show its diff needs no edit to either. `shipped-ai.sh` drives real Copier copies and
   updates over throwaway fixtures through `uvx --offline`, never over this tree: a local run needs
   uv's cached Copier environment, or `--python PATH` naming one, and where neither exists it is
   recorded as not run with that reason (`code/docs/GATE-REPORTING.md`), the same script's `[3/4]`
   step read beside it. `shipped-artefacts.sh` reads a generated tree,
   which no project script makes locally, so it is read in CI and never run here — **no raw `copier`
   invocation is improvised to make one** (`.claude/CLAUDE.md` Section 6).
2. **`git log`, `git diff`, `git ls-files`, `grep`, `sed`, `awk` and `test -e` at a terminal** — the
   instance count, the `Updated` reading, the debt-line listing, the link check and the cell count of
   QA plan Section 6. None is a tool Section 6 bans, and no project script makes any of these readings.

---

## Testing

**No pytest, no coverage figure, no migration check** — each recorded `N/A` with its reason. There
is no code in this diff.

### Automated — where each criterion is read

| Criterion (`../02-STORIES/US011.md` -> _QA Acceptance Criteria — Automated_)                                                   | Where it runs                                                                                                                |
| ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| No `US###`, `SPRINT-##`, `ADR-US###` or `STORY-PLAN-US###` literal in any generated index file, the `000` identifiers excepted | `[3/4]`, on every render path — **US010's step**, read on this story's landing run (Q2). This story adds no step             |
| `shipped-artefacts.sh --self-test` passes, unchanged by this story's diff                                                      | `[3/4]` only; "unchanged" read from `git diff --name-only` over the story's own commits, from the base P5 records            |
| `shipped-registers.sh` (with `--self-test`) and `shipped-ai.sh --self-test` pass, none of the four files edited                | Locally and in CI                                                                                                            |
| `doc-references.sh` as a baseline diff, the detector hash beside it                                                            | Locally, at P0 and P5                                                                                                        |
| Every Markdown link in the four indexes resolves, links checked recorded beside rows                                           | Locally by hand (QA plan Section 6), and on the landing run by US010's link-check step, whose in-tree half reads these files |
| `docs-length.sh` and `docs-pairing.sh` pass                                                                                    | Locally                                                                                                                      |

**The criterion and its step have different owners, and that is the point of Q2.** The criterion is
this story's and is read on this story's landing run; the step is US010's and was proved by US010's
own landing run. A green step on US011's landing commit is the evidence that the four filled
in-tree indexes leaked nothing into a seed.

### Manual testing

- `../18-TESTS/MANUAL/US011-MANUAL-TESTING.md` — authored from the specs beside this plan at
  `17-story-plans` Step 7.2, on 03/10/2026, and walked, not written, at `22`. A pointer, never a list
  of its own. Its rows meet the story's five _QA Acceptance Criteria — Manual_ and exercise or name
  every QA-plan scenario; the legibility reader is the one Key Decision 2 names. **No row awaits an
  answer**: REACH-03, which held the guide's open question 1, is written from its answer (Key
  Decision 11; settled 03/10/2026, 17-story-plans grilling round 4 Q8), and the guide has no open
  question.

---

## Documentation Write-Ups (Implementation Records)

Owned by `../../workflows/22-implementation-documentation/`, **not by this story**. Named so the
implementer knows what that workflow will ask for.

| Record                                         | Destination                                                      | This story                                                                                                                                                  |
| ---------------------------------------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| This plan                                      | `./`                                                             | Always — this file                                                                                                                                          |
| Manual testing guide                           | `../18-TESTS/MANUAL/US011-MANUAL-TESTING.md`                     | Always — authored at Step 7.2, walked at `22`, verified at `23`                                                                                             |
| Automated test record                          | "project-management/src/18-TESTS/AUTOMATED/US011-TEST-STATUS.md" | Always — written at `22`; the no-test block's reason is that no code path exists                                                                            |
| QA implementation review                       | `../11-QA/IMPLEMENTATION/`                                       | Always — every scenario closed with evidence; the population beside the cut-time 43, the rows the read rule normalised, and the `Proposed` chain head noted |
| Code review record                             | `../19-REVIEWS/`                                                 | Always                                                                                                                                                      |
| Findings                                       | `../20-FINDINGS/`                                                | Conditional — one per guide row amended at the walk                                                                                                         |
| ADR, schema, security, GDPR, SEO, API, logging | —                                                                | Not required — no decision is raised here, and each flag reads `N/A`                                                                                        |
| Release                                        | repo root                                                        | Conditional — at `24-release`                                                                                                                               |

**And one register write, gate `22`'s, dated the day it is written**: the `GAPS.md` entry for TM-10's
window — once this story ships, the four backfilled indexes read complete with no gate until `S-03`
is cut, and `S-03` is unscheduled (CUT-PLAN.md P8). `DEFERRED.md` gains nothing.

---

## CONTEXT.md & Index Updates

| File                                      | Change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` | **Paid 03/10/2026 by `17-story-plans` Step 10.** The US011 row of _Story Plans — the code master_ names this file, its Status cell "Not started" as that plan defines the column; the `Should` table's two cells and the Branch row filled; the passages saying US011 adds a grep step amended (Q2)                                                                                                                                                                                                                                                                         |
| `../02-STORIES/US011.md`                  | **Paid 03/10/2026 by Step 10.** References this plan and its guide at the end of its sprint-membership bullet, the reservation recorded taken up; the grep task "N/A — superseded" and its criterion (Q2); the Q3 reader; the Documentation Task's `**Last Updated**` line carrying Q7 (Key Decision 9), and its "no instance file was edited" clause naming Q8's exception (Key Decision 11); two dated re-measurements — every edit in place, because 71 explicit line citations in seven other records point at its lines up to `:533` (counted 03/10/2026 at `19e89aa`) |
| `./CONTEXT.md`                            | **Nothing.** It ships and, until US010's build, holds no index by recorded decision; US010 rewrites its _The plans index_ section. This plan's own row is part of the population this story backfills                                                                                                                                                                                                                                                                                                                                                                       |
| The four register `CONTEXT.md` files      | Only if an index section's wording changes — none expected (Key Decision 9)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `GAPS.md` / `DEFERRED.md`                 | Gate `22` only — the TM-10 window's entry                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

---

## Status Propagation & ClickUp Sync

**Four transitions are owed. The first three land in this story's diff, each flip a commit of its
own** (Key Decision 11; settled 03/10/2026, 17-story-plans grilling round 4 Q8); **the fourth,
`Completed`, is committed after the merge to `testing`** (`23-pr-and-review` Step 5), outside the
diff, in the same one-carrier shape.

1. **`Blocked` → `Open`, this plan only**, once US010 has landed on `main` and P0's start gate
   confirms the four files and P0's captures are taken. From then the plan's `Blocked` is no
   longer truthful, and `./CLAUDE.md` requires a truthful value.
2. **`Open` → `In Progress`**, the story first and this plan after it, two commits, when the build
   starts.
3. **→ `In Review`**, the story and then this plan, two commits, on the branch at
   `23-pr-and-review` Step 3, which commits the story's flip (this plan's follows it under Key
   Decision 11), with the hook below running. It lands after the gate-22 walk and after P5's
   listing, so REACH-03 reads transitions 1 and 2 only, and no step of `23-pr-and-review` reads the
   branch's commit list: this pair's one-carrier shape is held by Key Decision 11 when it is
   committed and is read by no recorded check (`code/docs/GATE-REPORTING.md`). Both commits follow
   the landing commit P5 records, so from them until `S-03` ships the US011 and plan rows of
   STORY-INDEX and STORY-PLAN-INDEX read `In Progress` against carriers reading `In Review` — the
   drift named below, inside the story's own merged diff.
4. **→ `Completed`**, the story and then this plan, only at `completion`, after review and QA.

Where each lands, against the template's six artefacts:

| #   | Artefact                         | This story                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| --- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **Story (source of truth)**      | `../02-STORIES/US011.md` -> `**Status:**`, moved first — the only file the export reads                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 2   | **This plan**                    | The metadata table's `Status` row — `Blocked` until transition 1, then with the story; each mirrored in its own index, never reconciled                                                                                                                                                                                                                                                                                                                                                                       |
| 3   | **Sprint plan — story-plan row** | "Not started", and **does not mirror** this plan, by `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`'s own definition of the column, pending `../02-STORIES/US007.md` Scenario 8                                                                                                                                                                                                                                                                                                                                    |
| 4   | **Sprint record**                | `../03-SPRINTS/SPRINT-07.md`'s Story Summary carries no status column; its own `**Status:**` is the sprint's, moving only when the sprint does; its US011-keyed task rows are ticked on the deliver branch                                                                                                                                                                                                                                                                                                    |
| 5   | **Sprint plan — DoD**            | The US011 rows of the sprint plan's _Sprint Definition of Done_, ticked on the deliver branch or read **N/A — dropped**                                                                                                                                                                                                                                                                                                                                                                                       |
| 6   | **ClickUp export (generated)**   | `project-management/export/clickup/US011-CLIENT.md`, tracked, its Status cell read from row 1. **Never hand-edited:** the lefthook `clickup-export` pre-commit hook (`project-management/src/00-ASSETS/scripts/precommit-clickup.sh`) regenerates every export and re-stages it in any commit that stages a story on a checkout whose hooks are armed, so such a commit flipping row 1 carries this file too; a commit on an unarmed checkout leaves it stale (`./09-STORY-PLAN-US009-HOOK-ARMING.md`, TM-12) |

**The first three land inside this story's diff, under Key Decision 11** (settled 03/10/2026,
17-story-plans grilling round 4 Q8): **each flip is a commit of its own, touching only its Status
carrier and, for a story flip, the export the hook regenerates — nothing else — and never rides in
a backfill commit**, and no tick rides in one either, so that the `Updated` of the rows for
US011.md and this plan is read against a commit that changed only what those rows mirror (QA plan
EC-09). Any flip after the landing commit drifts those two rows until `S-03` ships — the window
TM-10's `GAPS.md` entry tracks.

**Pushing to the board is CI's**: `.github/workflows/clickup-sync.yml` runs on a push or pull
request into `main`, `staging`, `dev` or `testing` that touches the export, and writes only once the
repository's ClickUp secrets are set — a dry run otherwise. This plan cannot read those secrets, so
whether a board receives the flip is unmeasured here; nothing in this story pushes by hand.

---

## Deferred Items

**Nothing is deferred by this story in the `DEFERRED.md` sense.** Each row below is someone else's,
named so it is not absorbed.

| Item                                           | To                                   | Why                                                                                          |
| ---------------------------------------------- | ------------------------------------ | -------------------------------------------------------------------------------------------- |
| The generated-tree literal grep                | US010 (SPRINT-06)                    | One step over all seven index files (settled 03/10/2026, 17-story-plans grilling round 1 Q2) |
| The index gate, `N-003` and `N-004`            | `S-03`, unscheduled                  | Red on these four indexes before this story lands (settled 21/09/2026, grilling round 1 Q1)  |
| The TM-10 window                               | This story's gate `22`, to `GAPS.md` | It opens when this story ships; tracked, not closed, until `S-03` is cut                     |
| The 20-FINDINGS and 21-BUGS indexes            | US010's presence clause              | Both registers held zero when cut; an instance found at P0 is handed back                    |
| ADR-US004-CITED-PLAN-PREFIX's sign-off         | Scheduled nowhere                    | Named as Follow-on in the read-rule record; not this story's                                 |
| `S-05`'s "42 at cutting" on the map            | `01-feature-map`                     | How the cutting gate left it; verify, never re-cut                                           |
| The squash-at-promotion question for `Updated` | `23-pr-and-review`                   | No merge-strategy rule exists; the post-merge re-check is that gate's (see _Risks_)          |

---

## Risks

| Risk                                                                                                                                 | Likelihood | Impact | Mitigation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------------ | ---------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **US010 slips, or lands with a shape its plan did not describe** — a fifth tail, a placeholder row, a different debt line            | Medium     | High   | P0's start gate reads the files as landed and the build fills those; a missing file stops the build and goes back to US010; a placeholder row leaves in the commit that writes the first real row (EC-14). If US010 has not landed when SPRINT-07 closes, US011 takes the sprint's drop branch: disposed of in writing on exactly one branch, as `../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Sprint Definition of Done_ requires, its placement owed to `03-sprint-planning` and landing ahead of `S-03` wherever it lands (Key Decision 4) |
| **A Summary restates its filename**, or reads well only to someone who has opened the artefact                                       | High       | Medium | The bar is one line for a stranger; the legibility reader has opened nothing (Key Decision 2), one session per index, the developer reviewing the reading; ES-10 is its own guide row                                                                                                                                                                                                                                                                                                                                                         |
| **A row's `Updated` is copied from a header date**                                                                                   | Medium     | Medium | Every row read against `git log -1 --format=%ad --date=format:%d/%m/%Y`, never sampled; header and commit dates differed on 12 of the 36 dated instances when the QA plan measured on 21/09/2026 (ES-04)                                                                                                                                                                                                                                                                                                                                      |
| **A squash at promotion rewrites every instance's last commit date**, and every `Updated` with it                                    | Medium     | Medium | No merge-strategy rule exists in `project-management/docs/git/`. `Updated` is re-checked after the landing commit exists, and again at `23-pr-and-review` against the merged commit; a mismatch is a row edit                                                                                                                                                                                                                                                                                                                                 |
| **A plan is renumbered, or an instance added, between P0 and the landing commit**                                                    | Medium     | Low    | P5 rebases and re-counts immediately before landing, and renames or adds the row in the same change (EC-11, EC-16)                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **A tail marker or comment travels into a DECISION-INDEX cell**, silencing `doc-references.sh` on its row and the next               | Low        | Medium | The tail read by the same strips as Status (EC-05); the scoped citation run over the index after P4                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| **A seed is refreshed from its now-populated in-tree sibling** (TM-03's trigger)                                                     | Low        | High   | This story's diff touches no seed (REACH rows); US010's family and its grep step are the standing controls                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| **A tick or a status flip lands in the wrong commit** — a tick in a backfill commit, or a flip commit carrying more than its carrier | Low        | Low    | Each flip staged alone, the hook adding the export to a story flip and nothing else (Key Decision 11). P5 reads the per-commit listing REACH-03 reads before it pushes, so a misplaced change is split out then; at the walk it is a `Fail` on REACH-03, never a judgement                                                                                                                                                                                                                                                                    |
| **A whole-tree gate run damages a sibling worktree's uncommitted work**                                                              | Medium     | Medium | Every `--fix` scoped with `--path`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

---

## Docker & Nginx Infrastructure

**N = 11.** `how-to/docs/GIT-WORKTREES.md:63-65` fixes the loopback rule — the final octet equals
the story number — so the IP is `127.0.0.11`. **It is not reported free, because the address already
appears in three tracked lines** (measured 03/10/2026 at `19e89aa`): `code/src/docker/nginx/dev.conf:15`
and `code/src/docker/nginx/test.conf:15` (`resolver 127.0.0.11 valid=10s ipv6=off;`) and
`code/src/docker/nginx/CONTEXT.md:46`, which names it as Docker's embedded DNS. **That is not a
collision.** Docker's engine networking documentation (_DNS services_, read through `context7` on
03/10/2026) gives `127.0.0.11` as the embedded DNS server's address for containers on a custom
network, and a loopback address in a container's configuration refers to that container's own
network namespace. The nginx resolver is therefore read inside the nginx container, while the
per-story override binds `127.0.0.11:3080` on the host's loopback — two namespaces, one address
each. The only per-story address in the tracked tree remains free; no sibling plan names it.
Subnets follow `code/src/docker/CONTEXT.md:101-102`: `10.11.1.0/24` for dev and `10.11.0.0/24` for
test, both absent from the tracked tree on the same search.

| File                                            | Purpose                                                                                                                                                                      |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us011.dev.yml"  | Dev stack override — from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us011`; nginx on `127.0.0.11:3080:80`; subnet `10.11.1.0/24` |
| "code/src/docker/docker-compose.us011.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us011`; `127.0.0.11:3081:80`; subnet `10.11.0.0/24`       |
| "code/src/docker/nginx/dev-us011.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                  |
| "code/src/docker/nginx/test-us011.conf"         | Same                                                                                                                                                                         |

**The two Nginx files are named because this folder's rule names them, and the docker layer says
they do not exist**: `code/src/docker/nginx/CONTEXT.md:28-29` states that `dev.conf` and `test.conf`
are `server_name _` catch-alls a worktree stack reuses unchanged. **And the stack is very likely
never started** — this story writes Markdown and runs no container. The overrides are specified
because `./CLAUDE.md` requires them of every plan, and the worktree is still where the branch is
developed.

`/etc/hosts`, if the stack is ever started, through
`bash code/src/scripts/development/hosts-story-add.sh 011` — the story number, never `us011`, which
the script refuses as non-numeric (the form `./11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` ->
_Measured divergences_ records):

```text
127.0.0.11 dev-us011.<%PROJECT_SLUG%>.localhost test-us011.<%PROJECT_SLUG%>.localhost
```

---

## Sprint Verification Checklist

- [ ] The start gate recorded: US010 on `main`, the four files present with their debt lines, tails,
      ordering sentences and _How to read a row_, before the first edit
- [ ] `bash code/src/scripts/syntax/lint.sh --file-type markdown --path <each changed .md>` — clean
- [ ] `bash code/src/scripts/syntax/format.sh --fix --file-type markdown --path <each changed .md>` —
      clean, every escaped pipe surviving
- [ ] `bash code/src/scripts/audits/doc-references.sh --path <each index>` — no new finding
- [ ] `bash code/src/scripts/audits/doc-references.sh` whole tree — diffed against P0 **by identity**,
      never by count, and never reported as a pass while the baseline stands
- [ ] `bash code/src/scripts/audits/docs-length.sh` over the four indexes and
      `bash code/src/scripts/audits/docs-pairing.sh` — exit 0
- [ ] `bash .github/scripts/shipped-registers.sh` and `--self-test`, and
      `bash .github/scripts/shipped-ai.sh --self-test` — exit 0, none of the four files in the diff
- [ ] The `[3/4] Template Generation` job green on every render path on the landing commit, its run
      ID recorded — US010's generated-tree grep printing nothing, `shipped-artefacts.sh` and its
      self-test green, US010's link check green over the in-tree indexes
- [ ] The link check, the row and link counts, the cell count and the debt-line listing over the four
      indexes, each recorded with its output and HEAD
- [ ] `bash code/src/scripts/syntax/check.sh` and `bash code/src/scripts/tests/all.sh` — regression
      only, recorded as such
- [ ] The manual guide walked and signed off by a tester other than the author
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] The code-review-graph refreshed **after staging** (`code/docs/CODE-REVIEW-GRAPH.md`)

---

## Definition of Done

- [ ] Each of the four indexes carries exactly one row per instance counted at the landing commit,
      and no row naming an absent file or a file outside its register's pattern
- [ ] Every Status string-equal to its carrier under the read rule; every `Updated` equal to its
      file's last commit date, the landing commit's rows re-checked once it exists
- [ ] Every Instance a resolving Markdown link with the right label; every Summary one line a
      stranger understood, the developer's review of the readings recorded
- [ ] Each file's stated order honoured; DECISION-INDEX's tail filled for every chain, every chain
      readable from the index alone, none dangling, the `Proposed` head noted
- [ ] The four debt lines removed, and the phrase removed from no other file; no index in the tree
      still carries a `Backfill owed` line
- [ ] `.copier/`, `copier.yml` and `.github/` untouched; no other story's instance file edited; the
      story's own three files changed only in their status carriers and the ticks Key Decision 11
      allows, each flip a commit of its own and a US011.md flip carrying its regenerated export, no
      tick in a backfill commit
- [ ] `S-05` verified on the map, not re-cut
- [ ] The automated record, the QA implementation review and the TM-10 `GAPS.md` entry written by
      gate `22`, never from here
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped silently
