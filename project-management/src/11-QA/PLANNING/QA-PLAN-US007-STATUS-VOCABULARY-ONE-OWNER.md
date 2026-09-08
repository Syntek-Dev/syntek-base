# QA Plan — US007 The story status vocabulary gets one owner

| Field         | Value                                                                                                                      |
| ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Story**     | US007 — The story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits     |
| **Date**      | 08/09/2026                                                                                                                 |
| **Sprint**    | SPRINT-01 — two rules get one owner each; build order 1, ahead of US001                                                    |
| **Wireframe** | N/A — this story ships Markdown only: no model, no endpoint, no screen, no personal-data path, no log line, no public page |
| **Status**    | Signed off                                                                                                                 |

<!-- Written 08/09/2026 at HEAD 98e3847 on pm/story-creation, over a tree carrying 75 entries in
     `git status --porcelain` — today's cascade repair and story-plan rename, two of them untracked
     fixture files. Read from the working tree, not HEAD, because the story and every artefact it
     cites were edited today and HEAD does not have them.

     METHOD. The grilling pass (Step 1) had already settled the descriptor. This pass read the
     story's thirteen scenarios, its FLAGS comment, Decisions, Tasks, Verification Checks and
     Definition of Done against the tree — every line citation re-resolved by `sed -n` on
     08/09/2026, every count re-taken — and folded in the three findings of the `15-decisions`
     coherence pass run the same day over the ADR set this story rests on. Each candidate gap was
     then re-opened against the cited file with REFUTED as the default; three that did not survive
     are kept in Section 8 because the next reader will otherwise raise them again. Seven survived.

     THIS PLAN DOES NOT EDIT THE STORY. `../../02-STORIES/US007.md` is left as it stands; every
     gap below is routed, with its consequence, and the `[OPEN]` tags are re-tagged there, not
     here, when the story takes them. -->

<!-- Signed off later on 08/09/2026, once all seven gaps closed. The Status row read "Draft —
     seven [OPEN] gaps routed to the story; not signed off" until then. The `story` skill took
     the seven into the story under `11-qa-checks` Step 5 the same day, at HEAD 98e3847 still,
     over a tree of 84 porcelain entries; each gap below is re-tagged [RESOLVED] with where it
     closed. Two statements the day had falsified between this plan's writing and its
     resolution are reconciled in Section 1's closing subsection (R1, R2), and one of Section 7's
     "two facts" is corrected there by measurement. No [OPEN] gap remains, so SPRINT-01's QA
     criterion is satisfied on US007's side and the `16-sprint-plans` pass for US007 is no longer
     blocked on this count. The sprint artefacts are not edited by this pass. -->

---

## 1. Acceptance criteria gaps

**Seven gaps found — two blocking, three material, two minor. All seven were resolved into
`project-management/src/02-STORIES/US007.md` on 08/09/2026**, by the `story` skill under
`11-qa-checks` Step 5, later the same day this plan was written. Nothing blocks
`16-sprint-plans` for US007 on this count, and `17-story-plans` may write the plan whose number
is reserved once `15-decisions` confirms the ADR set.

<!-- Until later on 08/09/2026 this paragraph read: "Seven gaps found — two blocking, three
     material, two minor. All seven are [OPEN]. None was resolved into
     project-management/src/02-STORIES/US007.md by this pass, which records and routes; the story
     skill resolves them there under 02-story-creation, before 17-story-plans writes the plan
     whose number is reserved." -->

**The consequence is stated once, because it applies to every gap below.** `./CLAUDE.md` for this
folder says an `[OPEN]` gap must be resolved in the story _before sprint planning_. US007 is
already in a planned sprint: `project-management/src/03-SPRINTS/SPRINT-01.md` admitted it on
07/09/2026 and closed at 10 / 11 SP, and
`project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` took the mirroring edit the same
day. So the gate this folder guards has already been passed for this story, and the gaps below
bind the next one instead: **SPRINT-01's own QA criterion — "no `[OPEN]` acceptance-criteria gap
remains in either member's QA plan" — is unsatisfied until all seven are resolved in the story**,
and the full `16-sprint-plans` pass for US007, which that plan says waits on the story clearing
`15-decisions`, cannot run until they are. Neither sprint artefact is edited here; each already
records that US007's QA plan "does not yet exist and is written when its `11-qa-checks` gate
runs", and each takes this file's path when it next moves. **Satisfied later on 08/09/2026**, once
all seven were resolved; the paragraph stands as the record of what bound them.

**Two are blocking, and they are the same defect seen from two sides.** AC-GAP-1 is that the
gate the story reads as a baseline diff was edited today, after the story was written, in a way
that changes what it finds — and the story specifies no way to tell a detector move from a
story's own regression. AC-GAP-2 is that "by identity" names no method, and the method has to be
mechanical at the size the baseline has reached. A story that captured its baseline tomorrow under
the story's current wording would satisfy both criteria as written and still be wrong.

- **AC-GAP-1** `[RESOLVED]` — **blocking — the detector moved after the story was written, and a
  baseline-diff reading does not survive a detector move.**
  `code/src/scripts/audits/doc-references.sh` carries an uncommitted edit on 08/09/2026 — 128
  insertions and 3 deletions against HEAD `98e3847` — that changes what it finds: Check 2's two
  plan alternatives gained an optional `([0-9]{2}-)?` prefix, and a new **Check 4 — plan prefix**
  fires on a plan cited without one. Under HEAD's detector a bare `NN-SPRINT-PLAN-NN` or
  `NN-STORY-PLAN-US###` basename was **structurally silent** — the anchored alternation never
  matched a prefixed token, and Check 1 drops any token with no `/` — and the same detector's own
  comment says so in terms: "the citation was checked by nothing at all". Measured today: of 136
  `[instance citation]` findings tree-wide, **39 are bare prefixed plan basenames** across 13
  files, **7 of them inside `project-management/src/02-STORIES/US007.md`** (`:202`, `:707`,
  `:708`, `:709` and three at `:796` — the morning's reading; 4 by the evening of 08/09/2026, R2
  having cleared the three at `:796`, EC-10). A story baselined under HEAD's detector and closed under the
  working tree's would be charged with all 39, none of them its own — and the story's criterion
  ("no NEW unresolved citation ... read as a diff against that baseline by identity") would report
  exactly that as a regression. US007 escapes only because its baseline is not yet captured; the
  next story that captured one on 07/09/2026 does not. Scenario 13 and the QA criterion specify
  _what_ the diff is against and never _which detector_ produced either side, and Scenario 13
  enumerates "three named classes" where the detector now reports four. **Resolution:** the
  capture task records, beside each baseline, the detector by content —
  `git hash-object code/src/scripts/audits/doc-references.sh`, which is
  `b9e4e129f2781b37af3879db54af15999daa151d` on today's working tree and differs from HEAD's blob —
  and the pre-edit tree by SHA (`git rev-parse HEAD`, and `git stash create` where the tree is
  dirty), and **re-asserts the hash at close**. If it differs, the close-run diff is
  **detector-confounded and is reported as such — never as the story's**; the recovery is to
  materialise the recorded pre-edit tree in a scratch worktree, run the _current_ detector over it,
  and diff that same-detector baseline against the close run. That is not the after-the-fact
  reconstruction `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  forbids: the pre-edit tree is re-materialised from a recorded SHA, not from memory. Scenario 13's
  class list is widened to "every class the detector reports", so a `[plan prefix]` finding from a
  file this story edits is the story's. The same one-line hash is recorded for the other four gates
  the story names — cheap, and the confound is not specific to this script. Section 6 carries the
  procedure. Raised 08/09/2026. **Resolved 08/09/2026** — Scenario 13 gains a `Given` recording
  the detector's move (128 insertions, 3 deletions against HEAD `98e3847`; Check 2 widened, Check
  4 added), its class list now reads "every class the detector reports — four on 08/09/2026",
  and a `Then` headed "THE DETECTOR IS RECORDED BY CONTENT" requires `git hash-object` of all five
  gates beside the baseline, with the pre-edit tree's SHA, porcelain count and stash SHA,
  re-asserted at close — a differing hash reported as detector-confounded, never as the story's,
  with the scratch-worktree recovery stated. The FLAGS comment, the `doc-references.sh` QA
  criterion and Verification Check, the capture and re-run Tasks rows and the first QA Task carry
  it. Re-measured at resolution: the working-tree blob is still
  `b9e4e129f2781b37af3879db54af15999daa151d`, HEAD `98e3847`, 84 porcelain entries. Added to
  `project-management/src/02-STORIES/US007.md` on 08/09/2026.
- **AC-GAP-2** `[RESOLVED]` — **blocking — "by identity" names no method, and at 254 findings the
  diff must be mechanical.**
  `ADR-US003-CITATION-GATE-BASELINE-DIFF`'s own stated cost of the regime it chose is that "a new
  finding can hide inside a growing baseline if the diff is done carelessly rather than
  mechanically". The baseline was 7 when that record was written, 103 on 05/09/2026, and is
  **254 today** — 136 instance, 106 dangling, 12 template-only, 0 plan-prefix — and the story
  says "by identity" three times without saying what an identity is or how two sets of them are
  compared. Two facts make a careful read-by-eye insufficient rather than merely tedious. First,
  **the story edits twenty files, and pre-existing findings sit in several of them** — today 7 in
  the story itself, 6 in `project-management/src/03-SPRINTS/SPRINT-03.md`, 2 in
  `project-management/src/16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`, 1 each in SPRINT-01, SPRINT-02
  and SPRINT-04 — so an edit above any of them moves its line number, and a diff over
  `file:line` reports every one as a finding removed and a finding added. Second, the gate's
  finding line is `file:line [kind] token`, and the same `(file, kind, token)` can legitimately
  appear more than once — `:796` in the story carries the bare basename of
  `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` twice on one line — so a set
  comparison loses a multiplicity change. **Resolution:** identity is defined as the
  triple `(file, kind, token)` with the line number dropped and multiplicity kept, both sides are
  normalised to that form and sorted, and the comparison is `diff`, never a read. Every `>` line
  at close is then classified by one test — is the file in the story's edit set
  (`git diff --name-only <recorded pre-edit SHA>`)? — and the answer is the attribution: inside
  the set is the story's; outside it is a concurrent change's, named and neither cleared nor
  inherited. The same shape applies to `skill-conformance.sh`, whose lines carry no line number
  and are compared whole; **and "attributable to `.claude/skills/completion/SKILL.md`" is by path
  _and_ cause**: a `[house 14]` clause fires on the skill's own file when a _guide_ names the
  skill in its routing frontmatter and is not cited back, so a finding on the skill's path caused
  by a guide outside the story's edit set is a concurrent change's despite its path. Section 6
  carries the commands. Raised 08/09/2026. **Resolved 08/09/2026** — Scenario 13 gains a `Given`
  quoting `ADR-US003`'s stated cost and the two facts that make a read-by-eye insufficient, and a
  `Then` headed "IDENTITY IS DEFINED": `(file, kind, token)`, line number dropped, multiplicity
  kept through `sort | uniq -c`, the sides compared with `diff`; every `>` line classified by
  whether its file is in `git diff --name-only <recorded pre-edit SHA>`; `skill-conformance.sh`
  compared whole-line; and "attributable" defined as path _and_ cause, with the `[house 14]` case
  stated. The QA criteria for both gates, the Verification Checks and the re-run Tasks row say
  the same; the story routes to this plan's Section 6 for the verbatim commands. The `:796`
  multiplicity example this gap cited was itself rewritten for R2 (full paths, four cells), so
  the case is now historical and the rule stands on EC-03. Added on 08/09/2026.
- **AC-GAP-3** `[RESOLVED]` — **material — `doctrine-drift.sh` is narrower than the story says, and
  a reader should know the definitions themselves go unread.** Its `SCAN_DIRS`
  (`code/src/scripts/audits/doctrine-drift.sh:61-67`) are exactly five trees — `code/docs`,
  `.claude/skills`, `code/workflows`, `project-management/workflows`, `how-to/workflows`. The
  FLAGS comment correctly says the gate "can open the skill and the workflow files this story
  edits", and stays narrowed on
  `project-management/src/15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`'s
  rule. What it does not say is that **the two owning documents this story writes —
  `project-management/docs/planning/STORIES.md` and `SPRINTS.md` — plus everything under
  `project-management/src/` and `.copier/README.md`, are outside `SCAN_DIRS` entirely.** Of the
  twenty files in the Tasks table, the gate can open **six** — the skill, three `STEPS.md` and two
  `CHECKLIST.md` — and reads fenced code only in those, against three API-envelope claims. The
  other fourteen, including both definitions, the ten templates and records, the README seed and
  the map, are never opened. The narrowed claim stays true and the gate stays in the manifest;
  the story's own Verification Check ("it cannot see any of the thirteen scenarios") already
  concedes the content half of this, but a reader of the FLAGS row reads "narrowed" as "reads the
  files, cannot decide the prose", which is US001's case and only partly this story's.
  **Resolution:** one sentence in the FLAGS comment and the QA criterion naming the population —
  six of twenty files opened, fenced code only, neither definition among them — so the green run
  is legible as what it is. Raised 08/09/2026. **Resolved 08/09/2026** — the FLAGS comment's QA
  VALUE paragraph gains "ITS POPULATION IS NARROWER STILL", naming the five `SCAN_DIRS`, the six
  files opened (the skill, three `STEPS.md`, two `CHECKLIST.md`), fenced code only, and the
  fourteen never opened — `STORIES.md`, `SPRINTS.md`, everything under `project-management/src/`,
  `.copier/README.md`; the `doctrine-drift.sh` QA criterion and Verification Check state the same
  population beside the result. The denominator reads twenty-one, not twenty, because R2 added
  the fourth sprint plan to the Tasks table the same day; the six the gate opens are unchanged.
  Added on 08/09/2026.
- **AC-GAP-4** `[RESOLVED]` — **material — two line citations into
  `project-management/src/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md` were falsified today.**
  The story cites that template's `:90` as the `{Draft / Ready / In Progress / Done}` legend
  (Scenarios 4 and 8, and the Tasks row) and its `:170` as the "Sprint closed on the board"
  clause (Scenario 7 and the Tasks row). On 08/09/2026 the file took 33 insertions and 14
  deletions in the story-plan rename pass, and **the legend is at `:98` and the clause at
  `:178`** — measured by `grep -n` today, against HEAD's `:90` and `:170`. The story's Decisions
  block names `copier.yml` and the seven live sprint files as the volatile families and says
  every other line number "was re-read on 07/09/2026"; the templates were assumed stable and one
  of them was not, edited by the same pass that de-numbered the seven. The story-plan template's
  citations, by contrast, hold — `:9`, `:24-30`, `:248`, `:633`, `:646` and `:773` all re-resolve
  today, the file having grown from 774 to 790 lines entirely below `:773`, as the story
  predicted. **Resolution:** the two sprint-plan-template citations move to the form the seven
  live files already use — the _Story Plans_ table's Status column header, and the _Sprint
  Definition of Done_'s board clause, each found by quoted text — and the Decisions block's
  volatility rule is extended to any file the 08/09/2026 rename pass touched, which
  `git status --porcelain` lists. Raised 08/09/2026. **Resolved 08/09/2026** — re-resolved by
  quoted text at resolution, trusting neither number: `grep -n` finds the
  `{Draft / Ready / In Progress / Done}` legend at `:98`, the table header under _Story Plans —
  the code master_ (H2 at `:84`), and "Sprint closed on the board" at `:178` under _Sprint
  Definition of Done_ (H2 at `:171`) — the morning's figures held. Scenario 4, Scenario 7's
  `Given` and `Then`, Scenario 8's `Given` and `Then` and the Tasks row now cite that template
  by section and quoted text, with the day's numbers given as dated evidence only. The Decisions
  block gains a bold paragraph extending the volatility rule to every file
  `git status --porcelain` listed on 08/09/2026 — 84 entries at the time, the sibling-register
  templates, both planning guides and the map among them — and noting the story-plan template's line
  numbers hold while the CONTENT at `:646` and `:773` moved (R1). Superseded clauses are kept in
  the story's third dated comment beneath the Gherkin block. Added on 08/09/2026.
- **AC-GAP-5** `[RESOLVED]` — **material — the capture task names two gates; the criteria read four
  as diffs.** The QA criterion for `docs-pairing.sh` says "read as an identity diff against a
  baseline captured immediately before the first edit"; the one for `doctrine-drift.sh` says "no
  **new** drift"; the Verification Check for the latter says "no **new** finding". Both need a
  _before_. The first Tasks row captures "the `doc-references.sh` and `skill-conformance.sh`
  finding sets by identity" and nothing else, and the closing row re-runs "the five gates" with
  no before to compare. Today both gates are clean — 0 findings over 222 `CONTEXT.md` and 212
  `CLAUDE.md`; 3 claims with one home each — so the practical cost is one line each, but a
  criterion that says "diff" with no captured before is a criterion ticked on trust, which is the
  shape `ADR-US003` was written against. **Resolution:** the capture task lists all four
  diff-read gates, an empty set recorded as empty, alongside the detector hashes AC-GAP-1 adds.
  `docs-length.sh` is the one gate correctly read as a measurement rather than a diff, and stays
  as it is. Raised 08/09/2026. **Resolved 08/09/2026** — the capture Tasks row now lists the
  pre-edit tree (SHA, porcelain count, stash SHA), the five detector hashes, and the finding sets
  of the **four diff-read gates** — `doc-references.sh`, `skill-conformance.sh`,
  `docs-pairing.sh`, `doctrine-drift.sh` — an empty set recorded as empty, with `docs-length.sh`
  named as measured, not captured; the first QA Task, the `docs-pairing.sh` and
  `doctrine-drift.sh` QA criteria ("against its finding lines captured before the first edit, an
  empty set recorded as empty") and their Verification Checks match, the latter no longer
  reading as a bare "passes". Added on 08/09/2026.
- **AC-GAP-6** `[RESOLVED]` — **minor — Scenario 9's closing grep walks the filesystem, not the
  tracked tree.** `grep -rnw "In progress"` over `.md`, `.sh` and `.yml` with `handoffs/` and two
  files excluded is a walk of the working directory, which holds a `node_modules/` at the root
  and, on a developer machine running a parallel story, a `.claude/worktrees/` checkout — a
  second copy of every file, gitignored. Measured today: `node_modules/` contributes 0 hits and
  no worktree exists, so the population is closed by luck rather than by construction, and a
  worktree of this very branch would double every hit. **Resolution:** the command is stated as
  `git grep -nw "In progress" -- '*.md' '*.sh' '*.yml'` with the three exclusions as `:!` pathspecs
  — tracked files only, which returns the same three sites today (the skill's `:42`, the map's
  `:217`, `US000-MANUAL-TESTING.md:5`) and cannot see an ignored tree. The record also states that
  `.yaml` was checked and holds no occurrence, so the `.yml`-only population is a measured one.
  Raised 08/09/2026. **Resolved 08/09/2026** — Scenario 9's closing clause is now
  `git grep -nw "In progress" -- '*.md' '*.sh' '*.yml'` over the tracked tree with every
  exclusion a `:!` pathspec, and states why (a `node_modules/` at the root, a gitignored
  worktree on a parallel-story machine). Run at resolution it returns exactly the three sites;
  `.yaml` (two tracked files) holds none, and the scenario records both. **A third
  casing-subject exclusion was added: this plan.** It quotes the lowercase form at five sites —
  this gap, this note, HP-10 and Section 8 — and is untracked on 08/09/2026, so `git grep` does
  not yet see it; committing it would turn zero into five, which the day's measurement could not
  show. Added
  on 08/09/2026.
- **AC-GAP-7** `[RESOLVED]` — **minor — the one field allowed to move is said to move once, and
  the workflow this story ratifies writes it twice.** Scenario 12 says "this story's own moves
  only at its DoD", the Definition of Done says it moves "to **Completed**", and both sprint
  artefacts repeat "the one field of its measured population that moves, to **Completed**". But
  `project-management/workflows/23-pr-and-review/STEPS.md:57` orders `In Review` at Step 3, the
  story's Scenario 4 leaves that order standing as legal, and the `completion` skill records the
  interim state — so `project-management/src/02-STORIES/US007.md:4` will read `In Review` from
  the moment the PR is raised until it merges, which is before the DoD. A tester taking the
  after-list at PR time, as the record's sign-off row implies, sees a value the criterion did not
  predict; a string-comparing gate of the kind US002 unblocks would flag it. **Resolution:** the
  expected trajectory is stated as `Open` → `In Review` → `Completed`, with `In Review` a legal
  intermediate written by Step 3, and the before/after list is taken at close with that column
  read accordingly. Raised 08/09/2026. **Resolved 08/09/2026** — verified against
  `project-management/workflows/23-pr-and-review/STEPS.md` at resolution: Step 3 (_Open PR to
  `testing`_) orders `In Review` at `:57`, Step 5 (_Promote Through Chain_) orders `Completed` at
  `:73-74`, and `.claude/skills/completion/SKILL.md` records `In Review` as the interim state.
  Scenario 12's `Then` now states the trajectory `Open` -> `In Review` -> `Completed` with
  `In Review` the legal intermediate Step 3 writes, and reads the before/after column against it;
  the Definition of Done's `Completed` bullet names the two writes on one moving field; the QA
  criterion's before/after bullet reads the same. **Not reconciled here:** the SPRINT-01 record
  and its sprint plan still say the field moves once, "to Completed" — neither is this pass's
  file, and each takes the trajectory when it next moves. Added on 08/09/2026.

_All seven were re-tagged `[RESOLVED]` on 08/09/2026, the date each was added to the story —
there and then here. Until that hour this line read: "No gap was resolved in the story by this
pass. Each is re-tagged [RESOLVED] with the date it was added to the story, there and then here."_

### Two reconciliations beyond the seven, and one correction — 08/09/2026

The day moved on between this plan's writing and the gaps' resolution, and two statements the
story made — both re-resolved by this plan in the morning and true then — were falsified by
passes run later the same day. Both are reconciled into the story with the seven, on the
developer's ruling that the later passes stand.

- **R1 — Scenario 11's Plans Index sites are gone, all four.** The story asserted the shipped
  `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` holds four "Plans Index"
  sites (`:16`, `:625`, `:646`, `:773`) and that it would consume two — `:646` removed, `:773`
  rewritten — leaving the other two and the six instruction sites outside the template to slice
  `S-01`. Verified at resolution: a separate pass later on 08/09/2026 rewrote all four in place,
  one line for one line, and re-pointed the six instruction sites the same day, each file
  carrying its own dated comment; the template is 810 lines, `grep -n -i 'plans index'` on it
  finds only `:625`'s "holds no index, by decision" and the two dated comments at its end, row 3
  reads "Sprint plan — story-plan row", and `:773` reads "across story + plan +
  sprint/sprint-plan" — while still naming "the final ClickUp value", unmarked. So the story now
  consumes **zero** sites and removes and renumbers no row. Scenario 11's `Given` and `Then` are
  re-scoped to what stands — the H2 and comment rename, the two clickup-only markers and `:773`'s
  board-neutral value survive; the Dependencies row that read "less the two shipped-template
  sites this story consumes" and the Definition of Done's `DEFERRED.md` bullet are reconciled —
  the row-3 hand-off is recorded as **N/A** with its reason (the index's deferral is already on
  the record at `project-management/src/17-STORY-PLANS/CONTEXT.md` -> _The plans index_ and on
  the map under `S-01`), leaving the sprint `In Progress` row as the one `DEFERRED.md` row the
  story opens. The superseded clauses are preserved in the story's dated comment. Nothing about
  the story's scope moved: one deliverable it owed became moot, and the story says so.
- **R2 — Scenario 8's population grew from three cells to four.** `project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` was
  written on 08/09/2026 after this plan's morning re-count and carries a `Not started` cell for
  US005, flagging the addition in its own dated comment. Counted at resolution from the **live
  _Story Plans — the code master_ tables only** — a raw `grep -n 'Not started'` returns 5, 7, 1
  and 3 lines across the four plans, the extras being history comments and prose — the cells are:
  US001 in the first plan, US002 and US003 in the second, US005 in the fourth; the third holds
  none. The fourth mirrors **`Blocked`**, not
  `Open`, because US005's plan carries `Blocked` in its `| Status |` header row and the column
  mirrors. Scenario 8 (`Given` and `Then`), Scenario 12, Scenario 7, the Decisions block (four
  live plans, eight files cited by section), the Tasks row (full paths, the four values), the QA
  criteria and QA Tasks now say four; the Story Points comment records that the Tasks table
  names twenty-one files and the estimate does not move; HP-09 below is corrected to match.
  Section 6's "six of your twenty files" reads twenty-one for the same reason.
- **Correction to Section 7, by measurement.** The first of its "two facts" — that a full-path
  citation into a PM artefact "produces no finding in either direction" — holds for a **tracked**
  citing file only. Check 3 asks whether the citing file ships and builds its excluded set from
  `git ls-files`, so an **untracked** file under `project-management/src/` is read as shipping and
  its full-path citations of excluded artefacts are reported as `[template-only citation]` until
  it is staged. Re-measured on the evening of 08/09/2026 under the same detector blob
  `b9e4e12…`, HEAD `98e3847`, 85 porcelain entries: **468** findings tree-wide — 227
  template-only, 135 instance, 106 dangling, 0 plan prefix — against the morning's 254. Every
  figure in this paragraph is a count of findings, and the total is **illustrative, not a
  baseline**: it moves with the index state and with every sibling edit — four runs within the
  hour read 461, 463, 468 and 467, the whole movement inside US006's story plan and the fourth
  sprint plan under concurrent passes (the last step one template-only citation fewer in the
  sprint plan). Template-only went 12 to 227: the 12 in tracked files are the morning's 12, and all 215
  others sit in untracked files — US006's plan 52, the fourth sprint plan 34, the US003 plan 28,
  the US004 plan 27, this plan 26, the US005 plan 25, the US002 plan 9, the new ADR 8, the US001
  plan 6, the renamed template 0. Instance went 138 to 135, the three cleared being the story's
  own (R2's full-path rewrite of its `:796` clause — EC-10). They clear when the files are
  staged — EC-01's index-move class, not a story's. The practical consequence for the
  implementer: **stage the untracked artefacts before capturing the baseline**, or the close-run
  diff reports their clearance as `<` lines it must then explain. The second fact stands.
  Section 7's readings are left as the morning's dated evidence.

<!-- The Correction's measurement sentence read, from the afternoon of 08/09/2026 until that
     evening: "Measured at resolution under the same detector blob b9e4e12…: **420** findings
     tree-wide — 176 template-only, 138 instance, 106 dangling, 0 plan prefix — against the
     morning's 254; template-only went 12 to 176, and every one of the 164 sits in an untracked
     file (this plan 26, the fourth sprint plan 34, the new ADR 8, the five renamed story plans
     140 between them)." Superseded because 420 did not reproduce when the gate was re-run, and
     the per-file figures neither summed to 164 nor shared a unit with it. -->

## 2. Test scenarios

Derived from the story's thirteen Gherkin scenarios and the audit scripts rather than a wireframe
— this story has none. For a documentation story the four categories read as: the gates run and
the identity diff is empty (happy path); a gate goes red, or a baseline was never captured (error
states); the boundary and race conditions on the capture (edge cases); and permission and access,
which is N/A with its reason. Every scenario is executable against the repository once the story's
edits land, and every scenario ID is the one the manual-testing record uses.

### Happy path (HP-nn)

| ID    | Given                                                                                                                                                                                                                                                 | When                                                                                                | Then                                                                                                                                                                                                                                                                                                              |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | A pre-edit tree whose SHA is recorded, and the four diff-read gates' finding sets captured by identity on it, empty recorded as empty, with detector hashes                                                                                           | Every edit in the Tasks table lands and the gates re-run                                            | The `doc-references.sh` diff has no `>` line in any file the story edits; the pre-existing set stands and is reported as standing — **never as a pass** while it is non-empty                                                                                                                                     |
| HP-02 | The `skill-conformance.sh` baseline was empty at capture — 65 skills conform today                                                                                                                                                                    | The gate runs at close                                                                              | Exit 0 with no finding on `.claude/skills/completion/SKILL.md` — the **one gate of five that may be reported as a plain pass**, and it is, with the empty baseline cited                                                                                                                                          |
| HP-03 | `docs-length.sh --path … --limit 1` read `STORIES.md`, `SPRINTS.md` and the skill before the first edit                                                                                                                                               | The same three invocations run after                                                                | All three under 270 counted lines by the gate's own figure; the tree-wide run exits 0 with no new file in the warn band                                                                                                                                                                                           |
| HP-04 | `docs-pairing.sh` reported 0 findings at capture                                                                                                                                                                                                      | It runs at close                                                                                    | 0 findings again — an identity diff of two empty sets — and the record says the gate decided nothing here because the story creates, splits and moves no pair                                                                                                                                                     |
| HP-05 | `doctrine-drift.sh` reported 3 claims with one home each at capture                                                                                                                                                                                   | It runs at close                                                                                    | The same 3 claims, one home each; reported as a regression guard over six of the story's twenty-one files, fenced code only, and never as having read a definition                                                                                                                                                |
| HP-06 | The story's routes are written — the skill's two, the three repointed `STEPS.md`, the five ownership comments, the README seed's, the plan template's three, the sprint-plan template's, the `STORIES.md` pointer                                     | A human opens each route's target in place                                                          | Every route lands on a section that states the set it names, or, for the pointer, on the writer declaration itself; recorded route by route, because the gate never reads past the arrow                                                                                                                          |
| HP-07 | The rewritten `.claude/skills/completion/SKILL.md`                                                                                                                                                                                                    | A cold reader opens it and nothing else                                                             | They can name the five story values it writes, the one sprint value, and who writes the other six — and can say from the file's own words that the writer table is a declaration of authority, not a set                                                                                                          |
| HP-08 | `copier.yml`'s `INCLUDE_CLICKUP: false` exclusion list, re-resolved by quoted text first                                                                                                                                                              | A cold reader traces `STORIES.md` and the generated `README.md` as they would exist without ClickUp | The eleven values, the per-register rule and the writer pointer are all reached; no value is attributed to a board and no instruction on the path names a removed script                                                                                                                                          |
| HP-09 | The seventeen source `**Status:**` fields re-counted at capture — seven stories `Open`, four sprints `Planned`, six plans `Open` ×5 `Blocked` ×1 by the evening of 08/09/2026 (sixteen and five plans that morning; US006's plan was written between) | The before/after list is taken at close                                                             | Every field but the story's own holds its captured value, the story's own read against `Open` -> `In Review` -> `Completed`; the four sprint-plan mirror cells read the value their plan carries — `Open` ×3, `Blocked` for US005 (R2); the search, its population and its exclusions are stated with the figures |
| HP-10 | The three `In progress` sites — the skill's `:42`, the map's `:217`, `US000-MANUAL-TESTING.md:5` — corrected as Scenarios 3, 9 and 10 provide                                                                                                         | The closing `git grep -nw "In progress"` runs with its stated exclusions                            | Zero lines, and the command with its pathspecs is recorded verbatim                                                                                                                                                                                                                                               |
| HP-11 | The named-site inventory built with a role column for every site that states a status value                                                                                                                                                           | A reviewer reads the definition rows                                                                | Exactly one definition row per set — `STORIES.md` for the eleven, `SPRINTS.md`'s new section for the three — with every other site carrying legend, writer, example, order, route, mapping or excluded                                                                                                            |

<!-- HP-09's Then read, until later on 08/09/2026: "Every field but the story's own holds its
     captured value; the three sprint-plan mirror cells read Open; the search, its population and
     its exclusions are stated with the figures". Corrected for R2 and AC-GAP-7. Its Given read
     "The sixteen source **Status:** fields re-counted at capture — seven stories Open, four
     sprints Planned, five plans Open x4 Blocked x1 today" until the evening of 08/09/2026, when
     the sixth story plan (US006's, Open) had been written; HP-05's "twenty files" read
     twenty-one from the same pass, for R2's reason. -->

### Error states (ES-nn)

The visible failures here are red gates and missing baselines. Each is a check that the regime
bites, not a defect to expect.

| ID    | Given                                                                                                                   | When                                    | Then                                                                                                                                                                                                                    |
| ----- | ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | An edit from the Tasks table has been made and no baseline was captured                                                 | The implementer reaches for the capture | The story **stops**: a baseline measured after an edit cannot separate a pre-existing finding from an introduced one. Recovery is to return the tree to its pre-edit state by SHA and capture there; the record says so |
| ES-02 | The close-run `doc-references.sh` diff shows a `>` line in a file the story edits                                       | The tester classifies it                | It is the story's. It is fixed or, where the citation is right and merely unprovable downstream, marked — never suppressed to clear the diff. The gate is not reported as passing either way                            |
| ES-03 | The close-run diff shows a `>` line in a file the story does not edit                                                   | The tester classifies it                | It is a concurrent change's — named in the record with its file, neither cleared nor inherited nor reported as the story's, and the story's own verdict is unaffected                                                   |
| ES-04 | `git hash-object code/src/scripts/audits/doc-references.sh` at close differs from the recorded blob                     | The diff is read                        | **The diff is detector-confounded and is reported as such — never as the story's.** The current detector is re-run over the recorded pre-edit tree in a scratch worktree, and that same-detector set is what is diffed  |
| ES-05 | `skill-conformance.sh` exits 1 at close with a finding on a skill other than `completion`                               | The tester reads it                     | Not this story's, and not a pass either: reported as an attributed diff whose story-side is empty, with the other skill named as a concurrent change's                                                                  |
| ES-06 | `skill-conformance.sh` fires `[house 14]` on `.claude/skills/completion/SKILL.md` naming a guide the story did not edit | The tester attributes it                | By path it is the skill's; by cause it is the guide's. Recorded as a concurrent change's, with the guide named — attribution is path _and_ cause (AC-GAP-2)                                                             |
| ES-07 | `STORIES.md` or `SPRINTS.md` crosses 270 counted lines after its gain — 104 and 93 today, per the gate                  | `docs-length.sh` runs                   | The gate warns, the figure is the gate's and not `wc -l`'s, and the story either trims or takes a dated allowance under `code/docs/DOCUMENTATION-LENGTH.md` before close                                                |
| ES-08 | `doctrine-drift.sh` reports a claim with two homes at close                                                             | The tester reads which fenced block     | It is the story's only if the block sits in one of the six files it edits and the story wrote it; otherwise a concurrent change's. Either way the gate examined fenced code only, and the record says so                |
| ES-09 | A repointed route names `STORIES.md -> Story statuses` and the target heading was mistyped or moved                     | The read-across opens it                | The route fails the read-across and is repaired; `doc-references.sh` passed it, because the gate tests the path before the arrow and never the section after it                                                         |
| ES-10 | The closing `git grep` returns a non-zero line count                                                                    | The tester reads each line              | Each hit is a site the story missed or a concurrent addition; recorded with its file and disposition, and the criterion is not ticked until the count is zero                                                           |
| ES-11 | A `[plan prefix]` finding appears from a file the story edits — a live plan cited by its unprefixed name                | The diff is read                        | A new finding of a class the detector now reports, and the story's (AC-GAP-1): repointed to the on-disk prefixed name, or, where it is a superseded name being quoted, moved from backticks to double quotes            |

### Edge cases (EC-nn)

| ID    | Given                                                                                                                                                                                                                                                                                            | When                                                | Then                                                                                                                                                                                                                                              |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | The pre-edit tree is dirty with another session's files — 75 entries at the morning's capture (Section 7), 85 at the evening re-measurement of 08/09/2026                                                                                                                                        | The baseline is captured                            | The index state is recorded beside it — HEAD, the porcelain count, and a `git stash create` SHA — so the tree is re-materialisable; a finding whose file entered or left the index between capture and close is the index move's, not the story's |
| EC-02 | Another story lands on the branch between capture and close                                                                                                                                                                                                                                      | The diff is read                                    | Its findings appear as `>` lines outside the story's edit set and are classified as ES-03; the story's verdict does not move                                                                                                                      |
| EC-03 | The same `(file, kind, token)` appears twice in the baseline and three times at close                                                                                                                                                                                                            | The normalised sets are diffed                      | The count column changes and the line shows as removed-and-added — caught. A set comparison would have shown nothing, which is why multiplicity is kept                                                                                           |
| EC-04 | A story edit above a pre-existing finding shifts that finding's line number                                                                                                                                                                                                                      | The diff is read                                    | Nothing shows: identity dropped the line number. A `file:line` diff would have reported a false removal and a false addition for every such finding                                                                                               |
| EC-05 | The `skill-conformance.sh` baseline was empty and the close run is red on `.claude/skills/completion/SKILL.md` for a clause the story's edit caused                                                                                                                                              | The tester reads it                                 | The story's, full stop — the empty-baseline-plus-exit-0 path is the only pass this gate has for US007, and this is not it                                                                                                                         |
| EC-06 | The PR is raised and Step 3 of `23-pr-and-review` writes `In Review` into the story's own header                                                                                                                                                                                                 | The after-list is taken                             | The story's own field reads `In Review`, a legal intermediate on the `Open` → `In Review` → `Completed` trajectory (AC-GAP-7); every other field still holds its captured value                                                                   |
| EC-07 | A story, sprint record or story plan is created between today and the first edit                                                                                                                                                                                                                 | The Scenario 12 population is re-counted at capture | It joins the population; the count is re-taken and not inherited from the seventeen measured on the evening of 08/09/2026 — sixteen that morning, US006's plan written between, which is this row's own case                                      |
| EC-08 | `STORIES.md` reads 104 and `SPRINTS.md` 93 by the gate today, against the 97 and 88 the story quotes from 07/09/2026                                                                                                                                                                             | The implementer reads the criterion                 | The criterion is the gate's reading before and after, not the story's figure — both files already moved by 7 and 5 today in the rename pass, which is the case for a method over a number                                                         |
| EC-09 | `docs-length.sh --path … --limit 1` always exits non-zero — everything is over a one-line limit                                                                                                                                                                                                  | It is run to read a figure                          | The invocation is a measurement, never a pass/fail leg; the tree-wide run at 300 is the leg. The record labels the two uses apart                                                                                                                 |
| EC-10 | The four pre-existing findings inside `project-management/src/02-STORIES/US007.md` itself — seven at the morning's reading, three cleared when R2 rewrote its `:796` clause to full paths — bare prefixed plan basenames, one in its Decisions block and three in its superseded-clauses comment | The story's DoD edit sets its header to `Completed` | They sit in the baseline and are not the story's to clear; if the implementer repoints them to full paths anyway, they appear as `<` lines, which is fine and is recorded as a clearance, not a requirement                                       |
| EC-11 | The `template-only` marker is reached for to clear a `>` line                                                                                                                                                                                                                                    | The tester reads the citation                       | It is admitted only where the path resolves here and copier excludes it — `code/docs/FORWARD-VOICE.md` Section 4 — never on a dangling path or an instance citation, which are corrected or dropped                                               |

<!-- EC-10's Given read "The seven pre-existing findings inside ... itself — bare prefixed plan
     basenames in its own comments and Tasks row" until the evening of 08/09/2026. Re-measured
     then with the gate scoped by `--path` to the story, detector blob `b9e4e12…`: FOUR — the bare
     basename 03-SPRINT-PLAN-03.md in the Decisions block ("on the form ... already use"), and
     01-SPRINT-PLAN-01.md:109-110, 02-SPRINT-PLAN-02.md:178 and 01-SPRINT-PLAN-01.md:224 in the
     superseded-clauses comment beneath the Gherkin block, at the story's :225, :824, :825 and
     :826 that evening. The three that cleared were the :796 clause's — the Tasks-row and
     Dependencies-row basenames R2 rewrote to full paths. Line numbers are that evening's and are
     not identities. -->

### Permission and access (PA-nn)

**N/A — this story adds no endpoint, no screen, no protected action and no identifier whose
ownership could be verified.** Twelve of its thirteen flags read `N/A`, and the `API`, `Backend`,
`Frontend`, `Security` and `GDPR` rows are among them; there is no role boundary to cross. Recorded
here rather than left to be inferred from an empty table, per `code/docs/GATE-REPORTING.md`.

The one boundary that _behaves_ like access control is the travel rule — what ships into a
generated project and what stays behind — and it is a property of `copier.yml`'s exclusion list,
not of a caller. HP-08 exercises it from the reader's side; nothing here can be reached by a
caller who should not reach it.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The story ships Markdown guides, a skill,
workflow steps, templates and record edits, all read in an editor this project neither controls
nor ships. There is no page for `axe-core` to run against, no focus order and no announcement.
The story's own Verification Checks record the same `N/A` with the same reason; this plan does
not restate a check it has nothing to give.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3. The template's three breakpoints have
nothing to be verified against.

## 5. GDPR & security constraints

**None — no PII, no new protected action.** The story introduces no field, no store and no code
path that could carry personal data, and edits no `code/` file at all. Its `GDPR` and `Security`
flags read `N/A`, `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` records the same
for the whole sprint, and unlike the SPRINT-04 posture story this one carries no security
substance beneath an `N/A` flag either: a status vocabulary is not a control.

The one constraint of this family that does apply is the standing one — no secrets, debug flags
or hardcoded IDs introduced — and the Verification Checks carry it.

## 6. Developer notes — testability, and the capture-and-diff procedure

- **The baseline is a procedure, not a figure, and it runs before the first keystroke.** Nothing
  in this plan quotes a count as the baseline. Section 7's readings are dated, labelled
  indicative, and were taken on a tree with 75 uncommitted entries; the story's own review history
  found that a pinned count on this tree goes stale within the hour, and today's readings already
  disagree with the figures the story quoted yesterday.
- **Capture on a tree you can get back to.** Ideally clean; where it is not, `git stash create`
  gives a SHA that re-materialises the exact working tree without touching it, and that SHA goes
  in the record. A baseline whose tree cannot be reconstructed cannot be re-run under a moved
  detector (AC-GAP-1).
- **Identity is `(file, kind, token)`, line number dropped, multiplicity kept** (AC-GAP-2). The
  reason is measured, not stylistic: the story edits twenty-one files (twenty until R2 added the
  fourth sprint plan on 08/09/2026), several of which carry pre-existing findings, and every
  edit above one shifts its line.
- **The procedure, as it should be executed and pasted into
  `project-management/src/18-TESTS/US007-MANUAL-TESTING.md`** — which does not exist today and is
  created by `22-implementation-documentation` from `project-management/src/18-TESTS/US000-MANUAL-TESTING.md`.
  Each captured set goes into the record as a fenced block, an empty set as an empty block with
  the gate's own zero-count line above it. Artefacts under `project-management/src/` are exempt
  from the 300-line rule, so a 254-line block is admissible there.

  ```bash
  # 1 — the pre-edit tree, by SHA, and its index state
  git rev-parse HEAD
  git status --porcelain | wc -l
  git stash create                       # empty output on a clean tree; otherwise a SHA — record it

  # 2 — every gate the story names, by content, so a detector move is visible at close
  for g in doc-references docs-pairing doctrine-drift skill-conformance docs-length; do
    printf '%s  %s\n' "$g" "$(git hash-object "code/src/scripts/audits/$g.sh")"
  done

  # 3 — doc-references.sh, normalised to (file, kind, token) with multiplicity
  bash code/src/scripts/audits/doc-references.sh \
    | grep -E '^  [^ ]+:[0-9]+  \[' \
    | sed -E 's/^  ([^:]+):[0-9]+  (\[[^]]+\])  (.*)$/\1  \2  \3/' \
    | sort | uniq -c > /tmp/us007-docref-before.txt

  # 4 — skill-conformance.sh, whole lines (they carry no line number)
  bash code/src/scripts/audits/skill-conformance.sh \
    | grep -E '/SKILL\.md: \[' | sort > /tmp/us007-skill-before.txt

  # 5 — the two clean-today gates, finding lines only, so "no new" has a before
  bash code/src/scripts/audits/docs-pairing.sh   | grep -vE '▸|checked|walked|✓' | sort > /tmp/us007-pairing-before.txt
  bash code/src/scripts/audits/doctrine-drift.sh | grep -vE '▸|scope:|✓'         | sort > /tmp/us007-drift-before.txt

  # 6 — the measurements (not diffs): the three files the story grows
  bash code/src/scripts/audits/docs-length.sh --path project-management/docs/planning --limit 1
  bash code/src/scripts/audits/docs-length.sh --path .claude/skills/completion --limit 1
  ```

  At close, steps 2 to 6 are repeated into `*-after.txt`, then:

  ```bash
  # the detector must be the one that produced the baseline — otherwise ES-04
  git hash-object code/src/scripts/audits/doc-references.sh

  diff /tmp/us007-docref-before.txt /tmp/us007-docref-after.txt
  diff /tmp/us007-skill-before.txt  /tmp/us007-skill-after.txt
  diff /tmp/us007-pairing-before.txt /tmp/us007-pairing-after.txt
  diff /tmp/us007-drift-before.txt   /tmp/us007-drift-after.txt

  # every `>` line is classified by one question: is its file in the story's edit set?
  git diff --name-only <recorded pre-edit SHA> | sort
  ```

  A `>` line whose file is in that list is the story's. One whose file is not is a concurrent
  change's, named as such. For `skill-conformance.sh`, the attributed subset is
  `grep -F 'skills/completion/SKILL.md:'` over the `>` lines — and a `[house 14]` line there names
  a guide, which is checked against the same edit set before it is charged to the story.

- **If the detector hash differs at close, do not diff.** Materialise the recorded pre-edit tree
  in a scratch worktree (`git worktree add <dir> <SHA>`), copy the _current_
  `doc-references.sh` in, run step 3 there, and diff that against the close run. Report the
  confound in the record either way; the reader is owed the fact that the ruler moved.
- **`doctrine-drift.sh` reads six of your twenty-one files, fenced code only** (AC-GAP-3; the
  count read "twenty" until R2 added a file on 08/09/2026). A green run
  says three API-envelope claims still have one home in `.claude/skills/**` and the three workflow
  trees. It has not opened `STORIES.md` or `SPRINTS.md`, and cannot.
- **`docs-pairing.sh` decides nothing for this story.** It creates, splits and moves no pair.
  Capture it anyway (AC-GAP-5) so "no new" has a before; today the before is zero.
- **`docs-length.sh --limit 1` is a ruler, not a gate.** It exits non-zero by construction. Read
  the figure, record it, and let the tree-wide run be the pass/fail leg (EC-09). `STORIES.md` has
  166 counted lines of headroom to the warn tier today and `SPRINTS.md` 177; the gains Scenarios 1
  to 4 add are a scoping declaration, a pointer, a board-neutral sentence and a short section.
- **Cite a plan by the name it is on disk under, and quote a superseded name in double
  quotes.** Check 4 fires on a live plan cited without its prefix; Check 2 now fires on a bare
  prefixed basename. A full repo-relative path is silent to both — and, per
  `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`,
  silent because untested, not because verified: the read-across is the only check on a PM `src/`
  citation, in either form.
- **Four findings already sit inside the story file itself** — seven at the morning's reading,
  three cleared when R2 rewrote the `:796` clause to full paths — bare prefixed plan basenames
  in its Decisions block and its superseded-clauses comment (EC-10 names them). They are in the
  baseline and are not this story's to clear. Clearing them is a `<` line, welcome and optional.
- **No pytest, no coverage figure, no migration check, no `check.sh` leg.** The story marks each
  `N/A` with its reason; the test record does the same rather than leaving a box blank, and
  `syntax/lint.sh` is the one syntax leg that reads Markdown.
- **The story plan does not exist and its name is reserved, not invented.**
  `project-management/src/17-STORY-PLANS/` holds `01-` for it — the file will be
  "01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md" — and `17-story-plans` writes it once the
  seven gaps are resolved and `15-decisions` has confirmed the ADR set. Nothing here cites it as
  existing.

## 7. Gate readings, measured 08/09/2026 — indicative, not baselines

**These are not the story's baselines and must not be used as them.** They were taken at HEAD
`98e3847` on a tree carrying 75 entries in `git status --porcelain`, two of them untracked, during
today's cascade repair; US007's baseline-capture task is unticked and its implementation has not
started. They are recorded so a reader can see the gates' condition on the day this plan was
written, and so the figures the story quotes from 07/09/2026 can be seen to have moved already.

| Gate                                                                      | Exit | Reading, 08/09/2026, HEAD `98e3847`, 75 uncommitted entries                                                                                                                               |
| ------------------------------------------------------------------------- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/doc-references.sh`                                                | 1    | **254** do not resolve — 136 instance, 106 dangling path, 12 template-only, 0 plan prefix. Read 1030 files, 92 exempt; 35,756 tokens, 6,574 tested as paths. Working-tree blob `b9e4e12…` |
| `audits/skill-conformance.sh`                                             | 0    | 65 skills — 62 first-party, 3 vendored — every one conforms. **An empty baseline, today**                                                                                                 |
| `audits/doctrine-drift.sh`                                                | 0    | 5 trees, fenced code only, 3 claims, one home each                                                                                                                                        |
| `audits/docs-pairing.sh`                                                  | 0    | 0 findings — 222 `CONTEXT.md` and 212 `CLAUDE.md` checked, 48 `code/src` directories walked                                                                                               |
| `audits/docs-length.sh`                                                   | 0    | 777 instructional files within 300; 5 in the warn band, none this story edits (`code/src/scripts/audits/CONTEXT.md` at 298 is the closest)                                                |
| `audits/docs-length.sh --path project-management/docs/planning --limit 1` | —    | `STORIES.md` **104** · `SPRINTS.md` **93** · `CADENCE.md` 121 · `CONTEXT.md` 38 · `CLAUDE.md` 37 — a measuring call, not a leg                                                            |
| `audits/docs-length.sh --path .claude/skills/completion --limit 1`        | —    | `SKILL.md` **77**                                                                                                                                                                         |

**The detector-move population, named so it is visible at capture.** Of today's 136
`[instance citation]` findings, **39** are bare prefixed plan basenames — the class HEAD's
detector was silent on — in 13 files: 8 in `project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`,
7 in the story (4 by the evening — EC-10), 6 in `project-management/src/03-SPRINTS/SPRINT-03.md`,
3 each in the US002, US003 and US004 story plans, 2 each in the US005 plan and
`project-management/src/16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`, and 1 each in the US001 plan, the
US006 QA plan, SPRINT-01, SPRINT-02 and SPRINT-04. **0** are the unprefixed stale form.
Whichever detector US007's baseline is captured under, these 39 are in it or not as a block, and
the hash AC-GAP-1 records is what tells a reader which. Re-measured on the evening of 08/09/2026
under the same blob: **38** in the same 13 files — the story 4 (R2 cleared three), the US005 plan
4 (its dated comment of that afternoon added two bare sibling basenames), every other figure as
in the morning.

**Two of the story's quoted measurements have already moved.** `STORIES.md` was 97 counted lines
on 07/09/2026 and is 104 today; `SPRINTS.md` was 88 and is 93 — both edited in the rename pass
(3 planning files, 59 insertions, 10 deletions uncommitted). The story says "re-measured at
implementation", so this is not a gap; it is the evidence for reading every figure in the story as
a method.

**What did not move, re-resolved today.** `STORIES.md` `:73`, `:75-77`, `:93`; `SPRINTS.md` `:21`;
`planning/CONTEXT.md:22`; `planning/CLAUDE.md:23`; `.claude/skills/completion/SKILL.md` `:35`,
`:37`, `:42`; `.copier/README.md` `:566`, `:568-570`; the map's `:213`, `:215-219`, `:556`; the
story-plan template's six cited lines; ten sibling-register template lines; the three workflow
routes and the four ordering lines; `copier.yml` `:152`, `:155-156`, `:159`, `:291-298`, `:673`.
The sixteen source fields and the three `Not started` cells re-count as the story states — the
morning's figures; seventeen and four by the evening (HP-09, R2). The only citations found
falsified are the two in AC-GAP-4.

**Two facts a reader of the close run needs.** `project-management/src/**` sits outside Check 1's
checkable-tree allowlist and `project-` matches nothing in Check 2's anchored alternation, so every
full-path citation this plan and the story make into PM artefacts produces **no finding in either
direction** — silent, not verified. **Corrected later on 08/09/2026: true of Checks 1 and 2, and
of Check 3 only while the citing file is tracked** — an untracked file is read as shipping, and
its citations of excluded artefacts fire `[template-only citation]` until it is staged; the
measurement is in Section 1's closing subsection. And `project-management/src/18-TESTS/US007-MANUAL-TESTING.md`,
cited by the story, this plan and both sprint artefacts, **does not exist today**; it is a forward
reference to the file the implementation creates, correct as intent and dead as of this date, and
the gate cannot see it either way.

## 8. Three candidates refuted, and why they are recorded

Each was raised on a fact that is true and fails on a fact that is also true. Kept so the next
reader does not raise them again.

- **"The story-plan template's six line citations are stale — the file grew from 774 to 790
  lines today."** The growth is real and the citations hold: `:9`, `:24-30`, `:248`, `:633`,
  `:646` and `:773` each resolve to the text the story quotes, because the rename pass appended
  its note at the end of the file, below `:773`, exactly as the story's own rename comment
  predicted. The sprint-plan template, edited by the same pass in its body rather than at its
  tail, is the file that moved — AC-GAP-4 — and the contrast is why the two are not one gap.
- **"`STORIES.md`'s `:79-91` and `:93` are stale — the file grew by 7 counted lines today."** It
  grew below the status section: `:73` is still the heading, `:75-77` the defining sentence and
  `:93` the "canonical set" line, and the 7 lines are the build-order-prefix paragraph the rename
  pass added further down. The count moved; the anchors did not.
- **"Scenario 9's grep can never return zero, because Scenario 10 leaves the map's rows standing
  and `:217` carries `In progress`."** Scenario 10 leaves `:213`, `:456-469` and `:556` standing
  and takes exactly one edit — `:215-219` — and `:217` sits inside it. The third site is cleared as
  a consequence of the one map edit the story does take, which is what Scenario 9 says. The
  population gap that _does_ survive is the untracked-tree one, AC-GAP-6, and it is minor.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US007.md` — the story this plan tests, which took the seven gaps on 08/09/2026
- `project-management/src/03-SPRINTS/SPRINT-01.md` — the sprint record that admitted US007 on 07/09/2026, whose QA criterion the open gaps now bind
- `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` — the sprint plan whose QA row reads "not yet written" and takes this file's path
- `project-management/src/18-TESTS/US007-MANUAL-TESTING.md` — **does not exist**; the record the baseline, the hashes and every read-across land in, created at implementation
- "01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md" — **does not exist**; the reserved name in `project-management/src/17-STORY-PLANS/`, written by `17-story-plans` after the gaps resolve
- `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` · `ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` · `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` · `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the four records the story rests on; the last is the regime Section 6 executes and AC-GAP-1 and AC-GAP-2 sharpen
- `GAPS.md` — the entry of 01/09/2026 this story closes at its Definition of Done
- `code/src/scripts/audits/doc-references.sh` · `doctrine-drift.sh` · `skill-conformance.sh` — the three gates whose behaviour Section 1 turns on; the first edited today, uncommitted
- `project-management/src/11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — the sibling plan whose Section 7 first recorded a citation-gate figure with its HEAD and index state
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, Section 7 and every "reported as" above rest on
- `code/docs/FORWARD-VOICE.md` — when the `template-only` marker is admissible (EC-11)
