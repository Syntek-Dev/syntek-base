# QA Plan — US011 The four indexes that shipped blank get a row per instance

| Field         | Value                                                                                                                                          |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**     | US011 — The four indexes that shipped blank get a row per instance, and each register stops claiming it is empty (title as AC-GAP-12 proposes) |
| **Date**      | 21/09/2026                                                                                                                                     |
| **Sprint**    | SPRINT-07 — the stretch `Should`, 8 of 10 SP beside US012's 2 SP `Must`, as the record's uncommitted working tree reads on 21/09/2026          |
| **Wireframe** | N/A — this story writes rows into four Markdown tables; no screen, no component, no endpoint                                                   |
| **Status**    | Signed off · **corrected in place 30/09/2026** — see below                                                                                     |

<!-- STEP 1's GRILLING PASS RAN on 21/09/2026: two rounds with the developer over US010 and US011
     together, frontier empty. Its decisions are cited below as "settled 21/09/2026, grilling round
     N QX" and none is re-opened here. Where a measurement bears on one without breaking it, the
     gap says so; where a measurement falsifies the ground of an EARLIER decision, it is reported as
     a contradiction and the decision is left standing (AC-GAP-5).

     METHOD. Written at HEAD 71a32d7 on pm/story-creation, over a dirty working tree. At the first
     reading it held eleven porcelain entries, every one a concurrent session's: US010.md, SPRINT-01
     to SPRINT-07 and MAP-SCRIPT-GUARDS.md modified, US012.md and its QA plan untracked. At the
     revision (17:02, 21/09/2026) it held seventeen: US011.md had joined the modified set, and this
     plan, US010's two security plans and its two ADRs were untracked beside US012's files.
     SPRINT-07.md grew from 574 lines at HEAD to 980 while this plan was written and revised, so
     every SPRINT-07 line cited below is the working tree's at the moment it was read, and each
     feedback edit against it is anchored on quoted text rather than on a line number.

     US011.md IS NOW A CONCURRENT-SESSION FILE TOO. It was unmodified when this plan was first
     measured; at 16:56 on 21/09/2026 the concurrent session rewrote its Dependencies bullet at
     :170-173 (US012's admission), which is the one edit AC-GAP-12 had listed as that session's.
     The line count is unchanged at 374, so every other US011 line cited below still holds as read
     at 17:02 — but every US011 feedback edit now waits under round 2 Q9 like the rest, and is
     re-anchored against the committed text before STEP 5 applies it.

     Every line cited was re-opened today; the population, the carriers, the chains and the commit
     dates were measured from git ls-files and git log, not inherited from the story or from the
     earlier read-only sweep.

     STEP 3's qa-tester pass IS this document: a general-purpose subagent with the qa-tester skill
     loaded, in a context that wrote neither story. STEP 2 has no wireframe to read — the four
     scenario categories are derived from the Gherkin, the tree and the settled decisions instead,
     on the precedent of project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md.

     THIS PLAN DOES NOT EDIT THE STORY. Settled 21/09/2026, grilling round 2 Q9: new gate files are
     written now, and every edit to a shared file waits until the concurrent session commits. Each
     gap's resolution is returned as a feedback edit; STEP 5 applies them afterwards and re-tags the
     gaps [RESOLVED] with the date. Until then project-management/src/11-QA/PLANNING/CLAUDE.md:31
     binds: no sprint plan for US011 while an [OPEN] gap stands.

     AMENDED 27/09/2026: THE HOLD IS LIFTED, AND THE GAPS ARE RESOLVED. US012's work now runs
     alongside US010's and US011's as one body of work, and neither session waits for the other's
     commit (project-management/src/02-STORIES/CUT-PLAN.md P9, 27/09/2026), so round 2 Q9's hold
     no longer binds — on the US011 edits "US011.md IS NOW A CONCURRENT-SESSION FILE TOO" held, as
     on the rest. STEP 5 applied the held edits at the write-back of 27/09/2026 — to US011.md, and
     to US010.md and SPRINT-07.md where a resolution was theirs — and every gap below is re-tagged
     [RESOLVED] 27/09/2026 with the story line its fix now sits at. The Status row read "Draft — thirteen [OPEN] gaps, every
     resolution held as a feedback edit until the concurrent session commits (settled 21/09/2026,
     round 2 Q9)" until then. CLAUDE.md:31 no longer holds US011's sprint plan on this plan's gaps;
     what the sprint plan still waits on is in Section 1's opening paragraph. US011.md grew from 374
     lines to 524 by 27/09/2026, so a US011 line cited in a gap's account of its defect is as read
     on 21/09/2026. A gap's "now at" citation, and every US011 line cited in Sections 2 to 6, is the
     current one, re-measured 27/09/2026 against the final pre-commit text.

     US010's gate files are being written in the same pass. The two ADRs cited below were not on
     disk when this plan was first measured and are on disk, untracked and Proposed, at the
     revision; the read-rule ADR's Decision and Follow-on were re-read then and agree with every
     use below.

     SIGNED OFF 30/09/2026 by <%DEVELOPER_NAME%> (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9), against the tree at a18db0b with that gate's corrections applied. The Status
     row read "Reviewed — all thirteen gaps resolved into the story, 27/09/2026" until then. The
     16-sprint-plans gate corrected US011.md on 30/09/2026 above lines this plan cites, and
     US010.md on 28/09/2026 and 30/09/2026, so the "now at" citations and the US011 lines in
     Sections 2 to 6, re-measured 27/09/2026 above, are re-measured again against the stories as corrected that day; the
     numbers they replace are kept in the dated comment beneath Section 1's list. Both ADRs of
     US010 read Accepted since 0c5e635. What else was corrected is the note below this comment.
     No gap, scenario or severity moves. -->

> **Corrected in place, 30/09/2026, at the `16-sprint-plans` gate, and signed off by
> <%DEVELOPER_NAME%>**: gate 11 closes when a QA plan reads `Signed off`, as gate 10 does (settled
> 30/09/2026, 16-sprint-plans grilling round 3 Q9). Four things had changed under the plan since
> its final pass of 27/09/2026, and the rest was re-measured. Correcting them in the same pass rather
> than under a signature is a call made 30/09/2026 while applying round 3, not one of its
> answers, on the pattern round 2 Q5 set for the gate-10 plans. <%DEVELOPER_NAME%> reviewed every
> change made under this sign-off, this call among them, and accepted them all (settled
> 30/09/2026, 16-sprint-plans grilling round 5 Q16):
>
> - **Story citations follow the stories.** Every "now at" citation in Section 1 and every US011
>   line in Sections 2 to 6 is re-measured against US011.md as corrected on 30/09/2026 — the
>   sprint-membership bullet AC-GAP-12 cites grew by seven lines and now spans `:233-248`, and
>   everything from the old `:242` moved down seventeen, the text unchanged. HP-08's US010
>   citation follows US010.md the same way. Lines marked as read on 21/09/2026 keep locating the
>   text as it stood then.
> - **The sprint plan's prerequisites are met.** Section 1's opening paragraph said the plans are
>   written once both members' gate documents are complete and committed, and US011's decisions
>   prerequisite met once the read-rule ADR is signed off Accepted. Both hold now: this plan and
>   US012's were signed off on 30/09/2026, closing gate 11 for both members, and the ADR reads
>   `Accepted` at its `:3`, committed so at `0c5e635`. EC-03 said the same ADRs read `Proposed`
>   unless signed off, and is corrected.
> - **Two tree citations had moved.** `ceb2d70` (28/09/2026) moved
>   `project-management/workflows/02-story-creation/STEPS.md` Step 4 down four lines, so
>   AC-GAP-12's `:94-96` is `:98-100`; and the sibling plan QA-PLAN-US009's two blocking gaps are
>   cited by ID now, not by line, because the notes that plan gained above its gap list at this
>   gate moved them.
> - **One statement had been overtaken.** AC-GAP-12 said the generated
>   `project-management/export/clickup/US011-CLIENT.md` still read "43 rows" and would be
>   regenerated in the commit that carries US011.md. It was regenerated in `0c5e635`, US010's
>   commit, and its title carries no literal.
> - **Every other line citation was re-measured on 30/09/2026**, against the tree committed
>   together with the 18-TESTS split. Four had moved, each by that split and the text unchanged,
>   and each is re-pointed with its old number kept in a dated comment beside it: AC-GAP-8's two
>   programme-plan sites in `project-management/src/17-STORY-PLANS/CLAUDE.md` and
>   `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`, AC-GAP-10's line of
>   `project-management/src/02-STORIES/US007.md`, and PA-02's `copier.yml` negation. Every other
>   one holds. The split also rewrites lines in `copier.yml`,
>   `.github/scripts/shipped-artefacts.sh`, the templates, US004 and US005 without moving any other
>   line this plan cites; `doc-references.sh`, the other `.github/scripts/` files,
>   `.github/workflows/audit-template.yml` and the ADRs cited by line are unchanged since
>   `71a32d7`, where this plan was measured; `MAP-REGISTER-INDEXES.md` moved only at the lines the
>   RESOLVE sitting of 27/09/2026 corrected. The story citations on lines changed at this gate
>   carry their full repo-relative path since 30/09/2026.
>
> Corrected rather than superseded because no gap, finding, scenario or severity moved. Each
> superseded wording is kept in a dated comment or an inline AMENDED note beside the text that
> replaced it.

---

## 1. Acceptance criteria gaps

**Thirteen gaps — two blocking, eight material, three minor. All thirteen are
`[RESOLVED] 27/09/2026`:** each was fed back into `project-management/src/02-STORIES/US011.md` as
a Gherkin line, a QA criterion, a task or a corrected comment, and each names the story line its
fix now sits at. Two resolutions also rested on text that is US010's to write (AC-GAP-3,
AC-GAP-13), and one on SPRINT-07's drop branch (AC-GAP-5); both files carry theirs. The
resolutions were held from 21/09/2026 under grilling round 2 Q9 and applied at the write-back of
27/09/2026, once CUT-PLAN.md P9 had lifted that hold. Grilling round 3 (27/09/2026) settled what
four of them had left to the developer or changed under them — AC-GAP-3 (Q17), AC-GAP-5 (Q19),
AC-GAP-8 (Q22) and AC-GAP-11 (Q23) — and round 6 the programme-plan detail AC-GAP-8 had left
open (Q32, Q33); each is recorded beneath its resolution. The one map cell this pass found stale
is routed to the map's owner, not edited from here (AC-GAP-12). **The sprint plan these gaps
gated is owed, and they no longer hold it back.** SPRINT-07 was closed by call at 10 / 11 on
21/09/2026 (CUT-PLAN.md P6), and the close owes `16-sprint-plans` for the record and
`17-story-plans` for US012 at its reserved 11- and for US011 at its reserved 12-. All three are
written once both members' gate documents are complete and committed
(project-management/workflows/16-sprint-plans/STEPS.md Step 1) — for US011, this plan and its
story, which ride in US011's PM commit (grilling round 4 Q28) — and US011's decisions
prerequisite is met when the read-rule ADR is signed off Accepted
(project-management/src/03-SPRINTS/SPRINT-07.md -> _Notes_). AMENDED 27/09/2026: this paragraph
closed "Nothing is waiting on the sprint plan they block today: SPRINT-07 stands at 10 / 11 SP,
which its own capacity line records as short of the fill trigger, so no plan is owed yet", which
the close by call had already made false — what owes the plan is the call, not a fill. **Both
prerequisites are met since 30/09/2026.** Gate 11 closes only when a QA plan reads `Signed off`
(settled 30/09/2026, 16-sprint-plans grilling round 3 Q9), and this plan and US012's were signed
off that day; the read-rule ADR reads `Accepted`, committed so at `0c5e635`; and Security is read
by its flag, `N/A` for both members (settled 28/09/2026, 16-sprint-plans grilling round 1 Q2). The
three plans wait only on the records being corrected first (settled 28/09/2026, 16-sprint-plans
grilling round 1 Q1, Q3 and Q4).

**Two are blocking, and each is an acceptance criterion the settled decisions have already
overtaken.** A build that satisfied US011 as written would record a status divergence the
read-rule ADR says does not exist (AC-GAP-1), and sort two of its four indexes into an order the
ordering decision reversed (AC-GAP-3). The gap with the widest reach, AC-GAP-5, is **material**,
not blocking: it corrects the story's account of its successor — a MoSCoW comment, a Dependencies
bullet, a sprint record's drop branch — and a build satisfying the criteria as written produces
no defect from it. That is the grading of
project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md, whose two blocking gaps
(AC-GAP-1 and AC-GAP-2) are criteria that cannot be delivered correctly as written.

<!-- AMENDED 30/09/2026 at the sign-off: the two gaps were cited as ":46, :64" until then, their
     lines from 21/09/2026 until that plan gained dated notes above its gap list at the
     16-sprint-plans gate. They are cited by ID now, since a sibling plan's line moves every time
     its header is corrected. -->

- **AC-GAP-1** `[RESOLVED] 27/09/2026` · **blocking** — **the story gives three status readings where one rule is
  settled.** US011.md:213-218 reads the three prose carriers directly and strips backticks from the
  plan cell; :227-232 writes "the enum value alone" for the one ADR whose Status line carries a
  trailing HTML comment and requires "the divergence from N-003's string-equality clause" to be
  recorded; the Decisions section (:183-187) leaves the question to `15-decisions`. Settled
  21/09/2026, grilling round 1 Q5: **one** read rule, designed in US010's spine and recorded as
  `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` — an index
  row's Status is the register's carrier value with bold markers, backticks, any trailing HTML
  comment and everything from the first space-middle-dot-space onward removed, then trimmed. US011
  applies it; S-03 inherits it, so N-003's string-equality is asserted against the normalised
  value. Under it ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md:11 normalises to `Proposed`
  and **string-equals** its row. There is no divergence left to record, and a scenario that demands
  one has the implementer document a defect the decision record says is gone. Measured 21/09/2026:
  beyond stripping the plans' backticks and padding, the rule changes exactly one of the 47 Status
  carriers — that line. The same three-way split sits in the FLAGS QA row (:91),
  the manual criterion (:276), the measurement task (:298-299) and the plan backfill task
  (:307-308). **Resolution:** the carrier scenario is rewritten to the one rule, citing the ADR;
  the trailing-comment scenario asserts the normalised equality and keeps "the ADR itself is not
  edited"; the flag, the manual criterion and both tasks read "under the read rule". **Written
  back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:320-327 (the carrier scenario), :339-344 (the
  trailing-comment scenario), :119 (the QA flag), :410-412 (the manual criterion), :439-442 (the
  measurement task) and :452-454 (the plan backfill task).
- **AC-GAP-2** `[RESOLVED] 27/09/2026` · material — **`Updated` has no source, and the obvious ones are wrong.**
  US011.md:211 asks only for "a DD/MM/YYYY date", and :276 for every `Updated` to be "correct".
  N-002's gloss, "the only date every register can produce" (MAP-REGISTER-INDEXES.md:185), is false
  of the files' own headers: a story carries no date line, a sprint `**Last Updated**`, an ADR
  `**Date:**`, a plan a Date row. Settled 21/09/2026, grilling round 1 Q6: `Updated` is the
  instance file's **last commit date** (`git log -1`, rendered DD/MM/YYYY); no gate reads it. Two
  traps the story does not name, both measured today. **Header dates are not commit dates, on 12
  of the 36 dated instances at HEAD** (stories carry no date; the other 36 are 7 sprints, 20 ADRs
  and 9 plans). Six ADRs: ADR-US005 reads 04/09/2026 against a last commit of 05/09/2026
  (`b708d4c`); ADR-US008-FIRST-MINOR-MIGRATION-KEY 09/09 against 18/09 (`1a9da7c`); and
  ADR-US008-FORWARDED-PROTO, ADR-US008-MIGRATION-KEY-DUAL-GATED, ADR-US008-MITIGATION-OWNS and
  ADR-US009-INSTALL each 17/09 against 18/09. Six plans: 01- 08/09 against 20/09; 02-, 03-, 04-
  and 05- 02/09 against 08/09; 06- 05/09 against 08/09 (`55d229d`). The sprints agree at HEAD, and
  all seven disagree in today's dirty tree — `**Last Updated**` 21/09/2026 against a last commit
  of 20/09/2026 — until the concurrent session commits (EC-16). **The rendering can move a date by
  a day:** `--date=format:` renders in the commit's recorded offset and `--date=format-local:` in
  the reader's — on `1a9da7c`, committed 18/09/2026 15:32 +0100, the local form reads
  **19/09/2026** under `TZ=Pacific/Kiritimati` while the recorded form reads 18/09/2026 under
  every zone tried. **Which date is also unnamed.** Author and committer date agree on all 47
  instances today (0 differ), but a rebase, an amend or a cherry-pick rewrites the committer date
  and keeps the author date, so one must be named. **Resolution:** the spine scenario names the
  source and the command — the **author** date (`%ad`), in the commit's recorded offset. It is the
  date `git log -1` itself prints, so it is the literal reading of round 1 Q6 rather than a
  refinement of it, and it is the one a rebase leaves alone, so a row written before a branch is
  rebased stays right after it. The manual criterion reads "equal to its file's last commit
  date"; an instance changed in the commit that lands US011 takes that commit's date — written
  with the intended date, then re-checked against `git log` once the commit exists (EC-09).
  **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:316-317 (the spine scenario) and :410-412 (the
  manual criterion).
- **AC-GAP-3** `[RESOLVED] 27/09/2026` · **blocking** — **the ordering scenario asserts an order the settled
  decision reversed for two registers, and the settled order had no tie-break** (one was
  settled 27/09/2026, grilling round 3 Q17). US011.md:237 and
  the backfill tasks (:305-308) put all four indexes "ascending by identifier". Settled 21/09/2026,
  grilling round 1 Q7: STORY-PLAN-INDEX ascending by the build-order prefix; DECISION-INDEX by
  US### then Date ascending, so a story's supersession chain reads forwards; STORY and SPRINT
  ascending by identifier. For plans the readings differ at the first row — prefix order opens on
  the 01- plan, which is US007's, where identifier order would open on US001's 02- plan. For
  decisions they differ at two rows today: ADR-US004-CITED-PLAN-PREFIX (08/09) is first of US004's
  three by filename and third by date, and ADR-US008-SCOPED-CITATION-BASELINE (09/09) is fifth of
  US008's five by filename and **second** by date under the tie-break below — it ties with
  FIRST-MINOR-MIGRATION-KEY on 09/09, no supersession joins the two, and F precedes S by filename
  (settled 27/09/2026, grilling round 3 Q17). **The tie is the larger half.** 17 of the 20 ADRs
  sit in a group sharing both US### and Date — US001 three on 02/09, US002 three on 02/09, US003
  two, US004 two on 02/09, US006 two on 05/09, US008 two on 09/09 and three on 17/09 — and US010's
  two new ADRs will make an eighth. **Two of the three supersession chains are same-date pairs**
  (US001 FULL-PATHS then UNVERIFIED; US002 REGISTER-SPLITS then SPLIT-TARGET, all 02/09), so the
  decision's own purpose holds for them only through a tie-break nothing states. A filename
  tie-break happens to put both predecessors first — F before U, R before S — by alphabet, not by
  rule. The map already concedes "a legitimate same-day tie" (MAP-REGISTER-INDEXES.md:244).
  **The ground under the scenario is also stale on US010's side.** The ordering prose US011 asserts
  against is US010's to write, and US010's own criterion still states the pre-settlement order for
  all four: "ascending by identifier for STORY, SPRINT, STORY-PLAN and DECISION"
  (project-management/src/02-STORIES/US010.md:310, working tree, 21/09/2026). Built to that, HP-08's
  "the stated rule and the actual order agree" passes on the wrong order. **Resolution:** the
  scenario and the task rows read the settled order; a feedback edit against US010 (held under
  round 2 Q9 until CUT-PLAN.md P9 lifted that hold on 27/09/2026, and de-duplicated against
  US010's own `11-qa-checks` plan if that reaches the same line) brings :310 to round 1 Q7 and
  gives DECISION-INDEX.md's ordering prose a tie-break. **The tie-break is settled 27/09/2026,
  grilling round 3 Q17, as this gap proposed it:** within a DECISION tie (same US### and same
  Date), predecessor before successor, then filename. The same answer orders MAP, FINDING and BUG
  rows descending by each register's own creation date, ties broken by identifier ascending (the
  direction by call, recorded 27/09/2026 with round 6) — US010's registers, not US011's. US011
  asserts the file's stated rule plus the chain property directly (EC-07). The tie-break was this
  gap's own open condition, so "ties broken by the rule DECISION-INDEX.md states" now asserts
  something. **Both held edits were written back 27/09/2026:** US011's ordering scenario, now at
  project-management/src/02-STORIES/US011.md:346-353, and its four backfill tasks, now at :446-454; and US010's criterion, which now
  states the settled order and both tie-breaks in the ordering line of its scenario "Every index
  carries the shared spine and states its own tail and order" (as read 27/09/2026).
- **AC-GAP-4** `[RESOLVED] 27/09/2026` · material — **the Decisions section still carries an ADR candidate the
  settled record subsumes.** US011.md:177-187 reads "None" and names one candidate: how a Status
  value with a trailing HTML comment is mirrored. Settled 21/09/2026 (round 2, the consequential
  calls): **US011 carries no ADR.** Its candidate is subsumed by the read-rule ADR, which US011
  cites; ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md is **not edited**, and its sign-off —
  unscheduled anywhere, US004's `15-decisions` having run on 02/09/2026 before the record existed —
  is named as Follow-on in the read-rule ADR. The Provenance paragraph on the trailing comment
  (:59-68) and the Documentation task (:315-317) inherit the same stale framing. **Resolution:**
  Decisions reads "None — no ADR of its own" with the reason and the citation; the Provenance
  paragraph gains a dated note; the task records which rows the rule normalised instead of a
  divergence. **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:260-290 (the Decisions section and its
  comment), :86-91 (the Provenance note) and :461-466 (the Documentation task).
- **AC-GAP-5** `[RESOLVED] 27/09/2026` · material — **S-03 now follows this story as its hard successor, and
  the story still reads its own absence as harmless.** Graded material, not blocking: none of the
  three sites below is an acceptance criterion, so a build that satisfies US011's criteria as
  written produces no defect from it — the harm is to S-03's ordering whenever S-03 is cut, which
  is why it is still owed before sprint planning. Settled 21/09/2026, grilling round 1 Q1: S-03
  is **not** pulled ahead of US011. S-03 is unscheduled (CUT-PLAN.md P8, 27/09/2026): SPRINT-08
  is RULE-OWNERSHIP's, US013 then US014 at 11 / 11, and S-03 has no sprint, staying `Proposed` at
  map-order row 10 — so round 1 Q1's "cut straight after these gates, into a new SPRINT-08" and
  round 2 Q13's "the next action" no longer describe its schedule.
  The ground is N-003's
  presence clause (MAP-REGISTER-INDEXES.md:240): run before US011, it is red on the four
  debt-carrying indexes, and the gate's lefthook entry (:248-251) would block every commit. So
  **S-03 cannot land green until US011 has**, and two sentences become false. The MoSCoW comment's
  "Nothing is blocked from shipping by its absence" (US011.md:128) is false of S-03; the
  Dependencies bullet (:165-169) is right that S-03 is not US011's dependency and silent that US011
  now gates S-03. The drop branch inherits the same hole. SPRINT-07's Definition of Done says there
  is no SPRINT-08 "to reserve the 8 SP into"; this gap had read that as true only until SPRINT-08
  opened for S-03, and that reading is withdrawn — SPRINT-08 is RULE-OWNERSHIP's at 11 / 11, with
  no room for 8 SP, and S-03 is not in it (CUT-PLAN.md P8). A dropped US011's reservation therefore
  stays owed and unplaced, and the ordering binds on whichever record first schedules S-03: a
  dropped US011 lands **ahead of** S-03 or S-03 is red on arrival. The map's
  own permission for S-03 to run "once S-02 has landed" (MAP-REGISTER-INDEXES.md:420-421)
  contradicts the presence clause; that is recorded in US010's Dependencies and left to S-03's
  cutting gate, so no map edit is proposed for it here. **Resolution:** the Dependencies bullet
  names S-03 as the successor US011 gates, with the settlement; the MoSCoW sentence is corrected to
  the fact — S-03 cannot land green without US011 (N-003's presence clause), and S-03 is
  unscheduled (CUT-PLAN.md P8; map-order row 10); SPRINT-07's drop branch gains the ordering, to
  bind on whichever record first schedules S-03. **The priority is not touched.** `Should` was
  settled at cutting — `02-story-creation`, 20/09/2026, resting
  on that gate's round-3 decision (US011.md:121-126) — and `03-sprint-planning` Q1 the same day
  only declined to relabel it (SPRINT-07's working tree, the comment beside its Story Summary).
  Its written ground,
  "Nothing is blocked from shipping by its absence" (US011.md:128), was false in one respect, and
  this gap reported it as a contradiction for the developer rather than re-deciding it. **Settled
  27/09/2026, grilling round 3 Q19:** US011 stays `Should`, and the sentence is corrected to the
  fact as the Resolution states. The contradiction is closed, and **all three sites were written
  back 27/09/2026**: the MoSCoW comment, now at US011.md:156-167; the Dependencies bullet, now at
  :219-232; and SPRINT-07's drop branch, the Definition of Done row "US011, the stretch tier, is
  disposed of in writing", which now binds the ordering on whichever record first schedules S-03.
  AMENDED 27/09/2026: "S-03 is unscheduled", in the sentence after round 1 Q1's above, was cited
  to round 3 Q19 and is now cited to CUT-PLAN.md P8, which recorded it; Q19 settled the priority
  and the corrected sentence, not the schedule.
- **AC-GAP-6** `[RESOLVED] 27/09/2026` · material — **the citation criterion is flat, and the settled reporting
  regime is a baseline diff.** US011.md:263-264 ("`doc-references.sh` passes"), the QA task at :336
  and the Verification Check at :354-355. The gate is inherited red on US011.md alone, all
  `[instance citation]`, exit 1 (Section 7): **25** on the unmodified tracked file earlier on
  21/09/2026, and **27** at 17:05 after the concurrent session's rewrite of :170-173, which carries
  five findings where the replaced text carried three. The developer settled on 20/09/2026 to
  **wait for US004** rather than add interim `template-only` markers, recorded in both sprint
  records' citation-gate paragraphs.
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` governs
  until US004 lands. The handoff's figure of 27 was taken while the file was untracked, and is a
  different reading that now happens to share the number. The figure moves with every edit, which
  is the argument for the diff: the baseline is whatever the committed text reads immediately
  before US011's first edit, never either number here. **Resolution:** all three read as a
  baseline diff — captured before the first edit, with the detector recorded by `git hash-object` beside it on the
  procedure of `project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`
  AC-GAP-1 — and a new finding in a file in US011's edit set is US011's. **Written back
  27/09/2026**, now at project-management/src/02-STORIES/US011.md:387-395 (the criterion), :494-495 (the QA task) and :514-516 (the
  Verification Check).
- **AC-GAP-7** `[RESOLVED] 27/09/2026` · material — **no gate can prove the links this story writes resolve, and
  the index files are policed for the form a row might cite in.** The criterion "every one of the
  43-odd links this story writes resolves" (:263-264) is assigned to a script that reads backticked
  tokens only (`code/src/scripts/audits/doc-references.sh:599`), and the Instance cell is a
  Markdown link by N-002 (MAP-REGISTER-INDEXES.md:183) — so not one row's link is read, and a
  green run would say nothing about them. In the other direction, the four in-tree index files are
  **not** exempt: only the feature-map folder and `.copier/` are
  (`code/src/scripts/audits/doc-references.sh:334`, `:345`). A bare backticked story, sprint or
  prefixed-plan token in a row is therefore a new Check 2 finding today (`:771`), and stays one
  after US004, whose citer exemption is keyed on an instance-shaped **filename** (US004.md:223-225)
  that none of the four indexes has. (Its `BUG-*` shape would take in
  `project-management/src/21-BUGS/BUG-INDEX.md` as a citer, which is US010's file and outside this
  story.) Bare ADR tokens are silent today only because `:771` still spells the
  retired three-digit ADR form, which US004 corrects (US004.md:230). **Resolution:** a
  link-resolution check joins QA Automated — every Markdown link target in the four files tested
  for existence relative to the index (Section 6) — and the spine scenario gains the citation
  form: a row cites by Markdown link, and any backticked reference in a row is a full relative
  path. **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:396-399 (the link check) and :318 (the
  citation form).
- **AC-GAP-8** `[RESOLVED] 27/09/2026` · material — **"not the index itself" has an obvious implementation that
  silently drops a real row.** US011.md:200 states N-003's instance test.
  `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` ends in
  `-INDEX.md`. Measured 21/09/2026: excluding the index by a `*-INDEX.md` suffix counts **8** plans;
  excluding it by exact filename counts **9**. No other instance in the four registers ends that
  way today. **Resolution:** the instance test reads "not the index itself, matched by its exact
  filename", in the scenario and in the measurement task (:294-295). **Settled 27/09/2026,
  grilling round 3 Q22:** the instance test becomes a **positive** filename pattern per register,
  still excluding `*TEMPLATE*` and the index itself — 02-STORIES `US[0-9]{3}.md`, 03-SPRINTS
  `SPRINT-[0-9]{2}.md`, 15-DECISIONS `ADR-*.md`, 17-STORY-PLANS `[0-9]{2}-STORY-PLAN-US[0-9]{3}-*.md`
  — and US011's count adopts it now. It does not dissolve this gap: the 05- plan matches its
  register's pattern, so a `*-INDEX.md` exclusion layered on the pattern still drops its row, and
  the index is still excluded by exact filename. It does close a second trap: CUT-PLAN.md, a
  copier-excluded cut plan that `project-management/src/02-STORIES/CLAUDE.md` says "is not a story",
  is not an instance, where the any-`.md` test would have counted it once committed. Measured
  27/09/2026: each of the four patterns matches every instance on disk and its register's
  `CLAUDE.md` naming rule. **The one detail Q22 left open is settled 27/09/2026, grilling round 6
  Q32:** `project-management/src/17-STORY-PLANS/CLAUDE.md` also permits unprefixed cross-cutting
  programme plans, `PLAN-<DESCRIPTOR>.md`, which the plans' pattern does not count. Programme plans
  are not instances, and `PLAN-<DESCRIPTOR>.md` is not permitted in syntek-base or in any
  generated project: every artefact follows one of the 24 project-management/workflows/. None
  exists, so STORY-PLAN-INDEX.md has no row to lose, and the plans' pattern stands as written.
  Removing the permission is US010's, as a task and a criterion (round 6 Q33): from
  project-management/src/17-STORY-PLANS/CLAUDE.md (:11, :72, :81-82),
  project-management/src/17-STORY-PLANS/CONTEXT.md (:18, :25) and
  project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md (:254, :714-715), all
  inside project-management/src/, which US010's ST05 already admits. AMENDED 27/09/2026: this
  detail read "none exists today, and whether one would belong in STORY-PLAN-INDEX.md is not
  settled". N-003's own wording in MAP-REGISTER-INDEXES.md is corrected at the wayfinder resolve
  sitting that already owns the map's two Acceptance-cell fixes (round 5 Q30), not from this gate.
  **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:303-305 (the instance scenario) and :431-436 (the
  measurement task); Q32 needs no US011 edit, because the pattern already leaves out a file that
  may not exist.
- **AC-GAP-9** `[RESOLVED] 27/09/2026` · material — **"no chain dangles" is undefined at the two edges the tree
  already holds.** US011.md:220-225 and the manual criterion at :279-280. **First, a Superseded
  record whose replacement is only Proposed:** ADR-US002-REGISTER-SPLITS reads `Superseded` at :3
  and names ADR-US002-SPLIT-TARGET, which reads `Proposed` at :3. Walked to its end the chain
  reaches a record that is not in force; the story does not say whether that dangles. **Second,
  both links of that pair carry a trailing `doc-references: template-only` comment on the tail
  line** (REGISTER-SPLITS :7, SPLIT-TARGET :6). A row that copies the field verbatim carries the
  marker into DECISION-INDEX.md, where it sets `is_naming_row` for its own line **and the next**
  (`code/src/scripts/audits/doc-references.sh:629-639`) — silencing Checks 1 and 2 on two rows this
  story is responsible for. Settled 21/09/2026, grilling round 1 Q5: the read-rule ADR also
  dissolves the trailing comments ADR-US000-TEMPLATE.md puts on Supersedes. Measured today: three
  chains, all symmetric — each `Superseded by` is answered by its replacement's `Supersedes`.
  **Resolution:** a chain dangles only where a named file is absent or the two fields disagree; a
  Proposed head is mirrored verbatim and noted in the implementation record, never reconciled (the
  records are US002's); tail cells are read under the same comment-stripping and carry no marker.
  **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:334-336 (the supersession scenario) and :415-417
  (the manual criterion).
- **AC-GAP-10** `[RESOLVED] 27/09/2026` · minor — **a story and its plan disagree, and the story does not say the
  index keeps them apart.** Plan 06-US005 carries `Blocked` in its Status row at :9; US005.md
  carries `**Status:** Open` at :4. "No register's value is translated into another register's
  vocabulary" (US011.md:218) forbids translation but not reconciliation, and the difference is
  deliberate — "a plan marked anything other than Blocked asserts its blockers are cleared"
  (project-management/src/02-STORIES/US007.md:593). **Resolution:** the carrier scenario gains an `And`: each row mirrors its own
  file, and neither is reconciled to the other. **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:327.
- **AC-GAP-11** `[RESOLVED] 27/09/2026` · material — **the seed-side criteria predate three settlements, and the
  literal grep has a false positive built in.** First, settled 21/09/2026, grilling round 1 Q2:
  `.github/scripts/shipped-registers.sh` gains a third family proving the seven index seeds blank,
  wired, and never re-included by an `_exclude` negation. Second, round 1 Q3:
  `.github/scripts/shipped-ai.py` creates the six register folders in its fixture and asserts every
  edited index survives `copier update`. Both are US010's surfaces; US011's regression criteria
  name `shipped-artefacts.sh` alone (:260-262, :353), and US011's diff must leave all three scripts
  green and **unchanged** — four files, since `.github/scripts/shipped-ai.sh` is a wrapper that
  execs `shipped-ai.py` (`.github/scripts/shipped-ai.sh:28`, `:31`) and CI runs the wrapper
  (`.github/workflows/audit-template.yml:166`) — on the reasoning :260-262 already gives. Third,
  the seeds carry an empty-register placeholder row (round 1 Q2, "no instance rows bar the empty-register placeholder
  row", the `project-management/src/23-INCIDENTS/INCIDENT-INDEX.md:16` shape): ":250 carry no
  instance rows" is right and must not be tested as "carry no rows". Fourth, the grep at :257-259
  hunts story, sprint, ADR and plan literals — and each of the four registers' shipped `CONTEXT.md`
  names its own template on three or four lines (the US000, SPRINT-00, ADR-US000 and 00-plan
  identifiers, measured today), so a seed following that idiom trips a naive digit-triple grep.
  **Resolution:** the generated-tree scenario and the automated criteria add the two scripts and
  their self-tests as "passes, unchanged by US011's diff", name the placeholder row, and state that
  the grep excludes the 000 template identifiers (Section 6). **Settled 27/09/2026, grilling round
  3 Q23:** the criteria naming both `INCLUDE_MOBILE` answer sets — the scenario at :253, and the
  `[3/4]` rows at :262 and :361 that say "both answer sets" of the same key — are reworded
  path-neutral, "on every render path the template offers (today: INCLUDE_MOBILE true and false)",
  so only test code changes when MAP-NATIVE-MOBILE-SURFACE S-01 deletes the key (HP-10, PA-01).
  **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:362-368 (the generated-tree scenario), :373-386
  (the three automated criteria) and :517-518 (the Verification Check).
- **AC-GAP-12** `[RESOLVED] 27/09/2026` · minor — **the population figure is stale in four places, and the title
  still states one.** US011.md's title (:1) says "43 rows"; the Provenance (:26-33) counts 43;
  MAP-REGISTER-INDEXES.md:353 still reads "(42 at cutting: 9 · 5 · 20 · 8)", the figure US011
  corrected to 43 on 20/09/2026 (US011.md:35-44) without the map being told; SPRINT-07's Story
  Summary repeats the title and its working tree says "43-odd" five times at 17:02, one of them
  inside a dated comment that quotes superseded wording and stays as written. **Measured 21/09/2026:
  47 tracked — 11 · 7 · 20 · 9 — and 48 once US012.md, untracked today, is committed.**
  Re-measured 27/09/2026 at the same HEAD under the positive pattern (settled 27/09/2026, grilling
  round 3 Q22; AC-GAP-8): the same 47, and the 48 holds only under that pattern — CUT-PLAN.md,
  untracked in 02-STORIES on 27/09/2026, is not an instance, where the any-`.md` test would read 49
  once both files are committed. Expected
  before US011 builds: US010's two ADRs, Proposed until the developer signs them off; plans 10-
  (US010), 11- (US012) and 12- (US011's own — its reservation moved from 11- on 21/09/2026, in
  SPRINT-07's working-tree Dependencies). Separately, "this story is the sole member of SPRINT-07"
  (:170) was stale against SPRINT-07's working tree when this plan was first written; **the
  concurrent session rewrote it at 16:56 on 21/09/2026** (:170-173 now opens "Sprint membership:
  SPRINT-07's stretch Should, beside US012 (Must, 2 SP) at 10 / 11", quoted here without its
  backticks; now at project-management/src/02-STORIES/US011.md:233-248), so no edit is owed for it here.
  **Resolution:** the title drops the literal, and the generated
  `project-management/export/clickup/US011-CLIENT.md:1`, which carries it, is regenerated from
  source rather than edited (`project-management/export/clickup/README.md:11`); the Provenance
  gains a dated re-measure. **The map cell is not edited from this gate.** Maps are written by
  `01-feature-map` (`project-management/src/01-FEATURE-MAPS/CLAUDE.md:15-17`), `02-story-creation`
  may make only the Slices `Story`-column edit
  (`project-management/workflows/02-story-creation/STEPS.md:98-100`), and round 1 Q1 set the
  precedent of leaving map text to its owning gate. Nor is the cell "drift" under US011's own Map
  Task (:324-330): "42 at cutting" is how the cutting gate left it, a wrong count faithfully
  recorded, and US011's Provenance (:35-44) already carries the correction. It is routed to the
  map's owner, `01-feature-map`, as a named item in this plan's return. Every criterion already
  counts at implementation time, so nothing else moves. **Written back 27/09/2026:** the title
  carries no literal (US011.md:1), and the dated re-measure is now at :46-62, with the per-commit
  figures at :193-209. The generated export was regenerated from source by the ClickUp pre-commit
  hook (project-management/export/clickup/README.md:19-20), never edited, and carries no literal:
  the hook ran in `0c5e635`, US010's commit of 27/09/2026. AMENDED 30/09/2026 at the sign-off: this
  read "The generated export still read "43 rows" on 27/09/2026; it is regenerated from source by
  the ClickUp pre-commit hook in the commit that carries US011.md", and the commit before
  US011.md's was the one that regenerated it. **The 48 above missed the
  commit order.** It counted US012.md alone; the three PM commits land US010, US011, US012
  (grilling round 3 Q25, split by whole file in round 4 Q28), and US010's carries its two ADRs.
  Under the positive pattern the tracked population reads 47 at HEAD, 49 after US010's commit, 49
  after US011's, which adds no instance, and 50 after US012's, which adds US012.md; CUT-PLAN.md
  rides in that last commit and adds nothing. The figures above are left as measured.
- **AC-GAP-13** `[RESOLVED] 27/09/2026` · minor — **"labelled with the file's descriptor" cannot be met by two
  registers.** US011.md:209. A story file and a sprint file are named by their identifier alone and
  carry no descriptor segment; an ADR and a plan do. **Resolution:** the label is the descriptor
  where the filename carries one and the identifier where it does not, and US010's "How to read a
  row" section in each file says which — a US010 obligation, carried by the same held feedback
  edit against US010 as AC-GAP-3's. **Written back 27/09/2026**, now at project-management/src/02-STORIES/US011.md:314; US010's
  half is carried by the label and "How to read a row" lines of its scenario "Every index carries
  the shared spine and states its own tail and order" (as read 27/09/2026).

<!-- AMENDED 30/09/2026 at the sign-off: every "now at" citation in the list above is re-measured
     against US011.md as the 16-sprint-plans gate corrected it that day. The numbers they replace
     located the same text at b1ca05a and are recovered by one offset: :1-238 unmoved; :239-241,
     the tail of the sprint-membership bullet, rewritten as :239-258; :242 onward +17. So
     AC-GAP-1's carrier scenario read :303-310 and is now :320-327, AC-GAP-4's Decisions section
     read :243-273 and is now :260-290, and AC-GAP-12's sprint-membership bullet read :233-241 and
     is now :233-248; the rest follow the same rule, each moved line checked against its text. The
     same rule re-points the US011 lines in HP-11, HP-13, ES-08, ES-10, ES-11 and Section 6's
     second-tester note, and HP-08's US010.md:554 is now project-management/src/02-STORIES/US010.md:584 by US010's own offset of +30 in
     that block.
     AC-GAP-12's `project-management/workflows/02-story-creation/STEPS.md:94-96` read that way on
     21/09/2026; ceb2d70 (28/09/2026) moved Step 4 down four lines, so the permission it cites
     sits at :98-100, the text unchanged.
     AC-GAP-8 cited the programme-plan sites as project-management/src/17-STORY-PLANS/CLAUDE.md
     :79-80 and the story-plan template's :713-714, and AC-GAP-10 cited "US007.md:592", until
     then, all three measured against the tree at a18db0b. The 18-TESTS split, committed together
     with this correction, moves each down, the text unchanged, to
     project-management/src/17-STORY-PLANS/CLAUDE.md:81-82,
     project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:714-715 and
     project-management/src/02-STORIES/US007.md:593, re-measured 30/09/2026 against the tree
     committed together with it. -->

<!-- WHAT THIS PASS DID NOT FIND, recorded because the absence is informative. Every citation in
     US011's Gherkin holds against the tree: the carriers are where it says, ADR-US000-TEMPLATE.md
     defines the supersession pair at :13-14, and the audit-template generation loop is at
     .github/workflows/audit-template.yml:151-163 (the story's :151-161 ends two lines short, the
     same drift the US009 plan's AC-GAP-6 recorded). 20-FINDINGS and 21-BUGS still hold zero
     instances, so the boundary at US011.md:46-49 (now at :64-67) holds without a hand-back. -->

## 2. Test scenarios

Derived from the story's Gherkin, the tree and the settled decisions, not from a wireframe — this
story has none. Every scenario runs against the in-tree files or a generated tree; none needs a
running stack. "The read rule" is the one settled 21/09/2026, grilling round 1 Q5.

### Happy path (HP-nn)

| ID    | Given                                                                                                                                                                     | When                                                                                                                                                                        | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The four registers after US010 has landed, HEAD recorded                                                                                                                  | Each is counted by the positive filename pattern per register (settled 27/09/2026, grilling round 3 Q22), `*TEMPLATE*` and the index excluded by exact filename (Section 6) | Each index has exactly one row per instance, and CUT-PLAN.md, which is not an instance, has none; the count, its date and its HEAD are recorded beside the cut-time 43. The reading on 21/09/2026 was 47 — 11 · 7 · 20 · 9 — and the same on 27/09/2026 under the positive pattern                                                                                                                                                                                                                                                                                                                                                                                                      |
| HP-02 | Any row                                                                                                                                                                   | Its Instance link is followed from the index's own folder                                                                                                                   | The file exists; the label is the descriptor, or the identifier where the filename has none (AC-GAP-13); it is never the filename with its extension                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| HP-03 | A bold-carrier instance — a story, a sprint, an ADR                                                                                                                       | The read rule is applied to the value after the key                                                                                                                         | The row reads the normalised value byte for byte: `Open` for each story, `Planned` for each sprint, `Accepted`, `Superseded` or `Proposed` for each ADR                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| HP-04 | A plan's single Status row, its value backticked and padded                                                                                                               | The read rule strips the backticks and trims                                                                                                                                | The row reads `Open` for eight plans and `Blocked` for one, the 06- plan, as measured 21/09/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| HP-05 | ADR-US004-CITED-PLAN-PREFIX's Status line at :11, `Proposed` followed by an HTML comment                                                                                  | The read rule is applied                                                                                                                                                    | The row reads `Proposed` and string-equals the file's normalised value — no divergence is recorded, and the ADR is byte-identical in the diff (AC-GAP-1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| HP-06 | DECISION-INDEX.md's supersession tail                                                                                                                                     | Walked from each `Superseded` row                                                                                                                                           | US001 FULL-PATHS reaches UNVERIFIED (`Accepted`); US002 REGISTER-SPLITS reaches SPLIT-TARGET (`Proposed`, EC-04); US008 FIRST-MINOR reaches DUAL-GATED (`Accepted`); each replacement's `Supersedes` names its predecessor                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| HP-07 | Every row                                                                                                                                                                 | `Updated` compared with the file's last commit date, rendered as Section 6 states                                                                                           | Equal on every row (AC-GAP-2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-08 | The four files' stated ordering rules                                                                                                                                     | The rows are read top to bottom                                                                                                                                             | STORY and SPRINT ascend by identifier; plans ascend by prefix, opening on 01- (US007's, today); decisions by US### then Date, so US004's CITED-PLAN-PREFIX (08/09) follows its two 02/09 records and US008's SCOPED-CITATION-BASELINE (09/09) sits second of five, after FIRST-MINOR-MIGRATION-KEY by filename within their 09/09 tie (settled 27/09/2026, grilling round 3 Q17). Asserted against the prose US010 writes once it states round 1 Q7's order — against project-management/src/02-STORIES/US010.md:310 as read 21/09/2026, the rule and the order would "agree" on the wrong order (AC-GAP-3); the settled order is now at project-management/src/02-STORIES/US010.md:584 |
| HP-09 | The change applied                                                                                                                                                        | Every removed line containing "Backfill owed" is listed by file (Section 6)                                                                                                 | Exactly the four index files; FINDING-INDEX.md and `project-management/src/21-BUGS/BUG-INDEX.md` untouched                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| HP-10 | Projects generated from the committed change on every render path the template offers (today: `INCLUDE_MOBILE` true and false — settled 27/09/2026, grilling round 3 Q23) | The four index files in each tree are read                                                                                                                                  | Present; the empty-register placeholder row and no other; no instance identifier bar the 000 template identifiers (AC-GAP-11)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-11 | The change applied                                                                                                                                                        | `git diff --name-only` against the recorded pre-edit SHA                                                                                                                    | Nothing under `.copier/`; `copier.yml` untouched; no instance file of the four registers touched; `.github/workflows/audit-template.yml` changed only by the grep step project-management/src/02-STORIES/US011.md:491 adds                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| HP-12 | The change applied                                                                                                                                                        | `shipped-artefacts.sh --self-test`, `shipped-registers.sh` and its `--self-test`, and `shipped-ai.sh --self-test` run                                                       | All green; none of the three scripts — four files, counting the `shipped-ai.py` the wrapper execs — edited by US011's diff (AC-GAP-11)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| HP-13 | Every row's Summary                                                                                                                                                       | Read cold by a reader other than the author, who has not opened the artefact (project-management/src/02-STORIES/US011.md:413-414, :420, :500)                               | Each conveys what the artefact is; the reader is named in the walk-through, and the count of summaries read is recorded beside the count of rows — a summary not read has not been checked                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |

### Error states (ES-nn)

| ID    | Given                                                                                                                                          | When                                                                                                   | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | One instance left without a row — plant it by omitting US005's                                                                                 | The walk compares the count with the rows                                                              | Caught. **No gate catches it until S-03** — the walk is the only presence check this story has, so it is run against the count, never by eye alone                                                                                                                                                                                                                                                                                                                                                                                        |
| ES-02 | A row naming no live file — a plan row under a pre-renumber name, or a placeholder row left in a populated index                               | The link check runs, and rows are counted against instances and links checked against rows (Section 6) | The renamed-plan row is caught by the link check as an orphan. The placeholder carries no link, so the link check never sees it: only the counts catch it — rows exceed instances by one, and links checked fall one short of rows. The symmetry clause's failure mode, reproduced by hand                                                                                                                                                                                                                                                |
| ES-03 | A Status copied raw — backticks, bold markers or the trailing comment kept                                                                     | Compared under the read rule                                                                           | Fails: a backticked `Blocked` is not `Blocked`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ES-04 | `Updated` copied from a header date                                                                                                            | Compared with the last commit date                                                                     | Fails on 12 of the 36 dated instances at HEAD, measured today — six ADRs: US005 (04/09 against 05/09), US008-FIRST-MINOR (09/09 against 18/09), and US008-FORWARDED, US008-MIGRATION-KEY-DUAL-GATED, US008-MITIGATION and US009-INSTALL (each 17/09 against 18/09); six plans: 01- (08/09 against 20/09), 02- to 05- (02/09 against 08/09), 06- (05/09 against 08/09). The sprints agree at HEAD and all seven disagree in today's dirty tree (21/09 against 20/09), provisionally (EC-16). Every row is checked, not a sample (AC-GAP-2) |
| ES-05 | A row or summary citing a peer as a bare backticked story or sprint token                                                                      | `doc-references.sh --path` over the index                                                              | A new `[instance citation]` in a file in US011's edit set — US011's own finding in the baseline diff, not an inherited one (AC-GAP-7)                                                                                                                                                                                                                                                                                                                                                                                                     |
| ES-06 | A `.copier/` seed touched by the diff                                                                                                          | HP-11's listing                                                                                        | Fails. A seed is US010's surface and a one-way door (US010.md ST03 and ST04)                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ES-07 | The debt line left in one index, or a "Backfill owed" line removed from any other file                                                         | HP-09's listing                                                                                        | Fails                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ES-08 | A tree-wide `grep -rl 'Backfill owed'` used as the Definition of Done check (project-management/src/02-STORIES/US011.md:533)                   | Run after the change                                                                                   | It never passes: nine files carried the phrase at 17:02 on 21/09/2026 — six tracked (US010, US011, SPRINT-06, SPRINT-07, the map and the handoff) and three untracked gate artefacts, this plan and US010's two security plans among them — and none is an index. Every gate artefact that discusses the debt adds to the figure. The check is scoped to the index files or it is noise                                                                                                                                                   |
| ES-09 | US010 not landed — the four files absent, or without their debt line                                                                           | US011 is started                                                                                       | It cannot start; SPRINT-07's Definition of Done row requiring US010 to have landed first fails before any row is written                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ES-10 | A Summary that restates the filename in prose — for ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL, "the ADR on the cited plan prefix being optional" | The legibility pass reads it (HP-13)                                                                   | Fails: the story's own fail condition (project-management/src/02-STORIES/US011.md:413-414, :455-456), and the filename-derived label N-002 rejected                                                                                                                                                                                                                                                                                                                                                                                       |
| ES-11 | A Summary running past one line — a hard line break inside the cell                                                                            | The file is read, and rendered                                                                         | Fails "one line" (project-management/src/02-STORIES/US011.md:315). A Markdown table row cannot span lines: the break ends the row, and the remainder renders as a stray line or a malformed row                                                                                                                                                                                                                                                                                                                                           |
| ES-12 | A Summary containing a literal pipe character                                                                                                  | The table is rendered, and the cell-count check runs (Section 6)                                       | The pipe opens an extra cell and shifts `Updated` and the tail out from under their headers. Fails unless escaped; the cell-count check prints more than one value                                                                                                                                                                                                                                                                                                                                                                        |

### Edge cases (EC-nn)

| ID    | Given                                                                                                                                                                                                                                                                | When                                   | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | `project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`, whose name ends in `-INDEX.md`                                                                                                                                               | The plans are counted                  | Nine, not eight. A suffix exclusion drops the row silently (AC-GAP-8)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| EC-02 | US012.md, untracked on 21/09/2026                                                                                                                                                                                                                                    | Committed before US011 builds — or not | Committed: STORY-INDEX.md gains its row. Still untracked: no row, because the instance test reads tracked files                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| EC-03 | Instances written after cutting: US010's two ADRs and plans 10-, 11- and 12-                                                                                                                                                                                         | They exist at implementation           | Each gets a row. The ADRs read `Accepted`, committed so at `0c5e635`; the two tie on US010 and 21/09/2026 (EC-07)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| EC-04 | ADR-US002-REGISTER-SPLITS `Superseded`, its replacement SPLIT-TARGET only `Proposed`                                                                                                                                                                                 | The chain is walked                    | Both mirrored verbatim; recorded as a chain ending on a record not in force; not dangling, not reconciled (AC-GAP-9)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| EC-05 | Tail lines ending in a `doc-references: template-only` comment (REGISTER-SPLITS :7, SPLIT-TARGET :6)                                                                                                                                                                 | The tail cells are filled              | Each cell carries the link and nothing else; no marker in the index, where it would silence Checks 1 and 2 on its own row and the next                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| EC-06 | Plan 06-US005 `Blocked`, US005.md `Open`                                                                                                                                                                                                                             | Both indexes are filled                | STORY-INDEX.md reads `Open`, STORY-PLAN-INDEX.md reads `Blocked`; neither is reconciled (AC-GAP-10)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| EC-07 | Same-US###, same-Date ADR groups — seven today, eight with US010's pair                                                                                                                                                                                              | DECISION-INDEX.md is ordered           | The file's stated tie-break — predecessor before successor, then filename (settled 27/09/2026, grilling round 3 Q17) — is honoured, and every chain reads predecessor first: FULL-PATHS before UNVERIFIED, REGISTER-SPLITS before SPLIT-TARGET, FIRST-MINOR before DUAL-GATED; US010's unchained pair falls to filename, INDEX-STATUS-READ-RULE first (AC-GAP-3)                                                                                                                                                                                                                                                                                                                                                      |
| EC-08 | ADR-US006-OVERRIDE's `**Date:**` line at :4 continues after a middle dot with a correction note                                                                                                                                                                      | Its ordering key is read               | The leading date, 05/09/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| EC-09 | Rows about the story's own work — US011.md, its 12- plan if written, SPRINT-07 — whose Status may move in the commit that lands US011                                                                                                                                | That commit is made                    | Each row mirrors the file as committed, and its `Updated` is that commit's date — written with the intended date, since the commit does not exist yet, and re-checked against `git log` once it does; an amend or a rebase keeps the author date, so the re-check holds. Any later flip drifts until S-03 ships. Round 1 Q1 (21/09/2026) had closed that window by scheduling S-03 next; S-03 is now unscheduled (CUT-PLAN.md P8, map-order row 10), so the window has no close date and is tracked in GAPS.md, routed through gate 22 (settled 27/09/2026, grilling round 3 Q21). The window opens when US011 ships, so its GAPS.md entry is written at US011's gate-22 pass (call recorded 27/09/2026 with round 6) |
| EC-10 | A carrier that moves line — SPRINT-07's `**Status:**` sits at :24 at HEAD and at :41 in the working tree on 21/09/2026                                                                                                                                               | The carrier is located                 | By its key, never by a line number                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| EC-11 | A plan renumbered between measurement and landing — US011's own reservation moved from 11- to 12- on 21/09/2026                                                                                                                                                      | The index lands                        | Rows re-counted and re-ordered at landing; links repointed in the same change (`project-management/src/17-STORY-PLANS/CLAUDE.md:41-44`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| EC-12 | 20-FINDINGS or 21-BUGS has gained an instance                                                                                                                                                                                                                        | US011 runs                             | Handed back to US010's presence clause, not absorbed (US011.md:64-67)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| EC-13 | US007, which builds first, has changed a register's status vocabulary                                                                                                                                                                                                | The carriers are re-read               | Mirrored as found under the read rule; nothing translated                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| EC-14 | **Conditional on US010's final in-tree shape.** US010.md:332-336 (working tree, 21/09/2026) ships the four in-tree indexes with no rows and a debt line, so today there is no placeholder to remove. If US010 lands them carrying the seed's placeholder row instead | The first real row lands               | The placeholder goes in the same change, or it is a row with no instance — caught by the counts, not the link check (ES-02); the seed keeps its placeholder                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| EC-15 | A seed whose prose names its register's template, as each register's shipped `CONTEXT.md` does                                                                                                                                                                       | The generated-tree grep runs           | No false positive: the grep excludes the 000 template identifiers (Section 6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| EC-16 | An instance with uncommitted edits at measurement — as US010.md, US011.md and SPRINT-01 to SPRINT-07 carry on 21/09/2026                                                                                                                                             | `Updated` and Status are read          | Re-read at the commit that lands US011, against the tree that commit carries; a reading from a dirty tree is recorded with its HEAD and treated as provisional                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

<!-- AMENDED 30/09/2026 at the sign-off: EC-03's Then read "The ADRs read `Proposed` unless the
     developer has signed them off" until then. Both were accepted after round 4 Q27's independent
     review and committed `Accepted` at 0c5e635, on 27/09/2026. -->

### Permission and access (PA-nn)

**None in the web sense** — this story adds no endpoint, no screen and no protected action, and
the `API`, `Backend`, `Frontend` and `GDPR` flags are correctly `N/A`. The boundaries it must hold
are the seed boundary and the ownership boundary, and three rows belong here rather than above:

| ID    | Given                                                                                                                                         | When                                                                                                                                                | Then                                                                                                                                                                                                       |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PA-01 | 47 or more syntek-base rows in four in-tree files whose seeds must stay blank                                                                 | A project is generated on every render path the template offers (today: `INCLUDE_MOBILE` true and false — settled 27/09/2026, grilling round 3 Q23) | No row crosses into the generated tree (HP-10). The in-tree files sit under the `/project-management/src/**` exclusion (`copier.yml:157`), so only a seed edit or a negation could carry one across        |
| PA-02 | An `_exclude` negation re-including an index path                                                                                             | Added by any diff                                                                                                                                   | US010's `shipped-registers.sh` family goes red (settled 21/09/2026, round 1 Q2). US011's diff adds none. The pattern sits next door: INCIDENT-INDEX.md ships by exactly such a negation (`copier.yml:188`) |
| PA-03 | Another story's artefact that would make a criterion easier if edited — the ADR-US004 Status line, the ADR-US002 tail pair, US005 or its plan | The change is applied                                                                                                                               | None is edited; HP-11's listing names no instance file                                                                                                                                                     |

<!-- AMENDED 30/09/2026: PA-02 cited `copier.yml:186` until then, measured against the tree at
     a18db0b. The 18-TESTS split, committed together with this correction, adds two lines above the
     INCIDENT-INDEX.md negation, which sits at :188 in that tree, re-measured 30/09/2026, the text
     unchanged. -->

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The four files are Markdown read in an
editor or a repository browser. One property is accessibility-adjacent and worth holding: the
Instance link is labelled with a descriptor rather than a filename, which is the index's version
of link purpose being clear from the link text (WCAG 2.2 success criterion 2.4.4) — HP-02 is the
check.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3.

## 5. GDPR & security constraints

**None — no PII, no new protected action.** The rows name planning artefacts; no person, no
identifier of a person, no store of personal data.

**The Security flag is `N/A`** (US011.md:118, reasoned at :93-108), and this plan finds no
reason to disturb it: the hazard — this repository's backlog reaching a generated project's seed —
is real and permanent, but its control is US010's (`ST03`, `ST04`, the enlarged `SEEDED` array,
and the `shipped-registers.sh` family settled 21/09/2026, round 1 Q2). US011 is **exercised** by that
control and adds none. **Settled 21/09/2026 (one of the calls made in round 1 and accepted without
objection): the negation leak is MEDIUM at design state, mitigated by the round 1 Q2 check; no finding is HIGH or CRITICAL, so
no VULN record is written.** Per `code/docs/GATE-REPORTING.md` that zero is a severity reading
with its reason — mitigated by a check not yet built — never a report that the seam is safe.

Three QA-visible constraints follow from it, and each is already a row above: the seeds unmodified
in the diff (HP-11), the generated-tree grep (HP-10, EC-15), and no negation added (PA-02).

## 6. Developer notes — testability

- **Count by the positive pattern, and exclude the index by its exact filename.** The instance
  test settled 27/09/2026, grilling round 3 Q22 — a positive filename pattern per register,
  `*TEMPLATE*` and the index still excluded — written so EC-01 cannot recur and a non-instance file
  such as CUT-PLAN.md is never counted. Run on 27/09/2026 at HEAD `71a32d7` it printed 11, 7,
  20 and 9 per register:

  ```bash
  for row in '02-STORIES:STORY-INDEX.md:US[0-9]{3}\.md' \
             '03-SPRINTS:SPRINT-INDEX.md:SPRINT-[0-9]{2}\.md' \
             '15-DECISIONS:DECISION-INDEX.md:ADR-.*\.md' \
             '17-STORY-PLANS:STORY-PLAN-INDEX.md:[0-9]{2}-STORY-PLAN-US[0-9]{3}-.*\.md'; do
    IFS=: read -r reg idx pat <<<"$row"
    dir="project-management/src/$reg"
    git ls-files "$dir/" | grep -xE "$dir/$pat" \
      | grep -v TEMPLATE | grep -vxF "$dir/$idx"
  done
  ```

- **Apply the read rule to the value after the key, never to the whole line.** It makes no
  difference for these four registers, and all the difference for a finding, whose Status is the
  last middle-dot-separated field of a metadata line, after the second middle dot
  (FINDING-US000-TEMPLATE.md:5) — cut the whole line at the first one and the Status is lost
  entirely. Strip the comment
  before splitting on the middle dot, so a comment that happened to contain one could not
  truncate the value. A sketch for checking rows, not the gate S-03 will build:

  ```bash
  norm() { sed -E 's/<!-{2}.*-{2}>//; s/ · .*$//; s/\*\*//g; s/`//g; s/^[[:space:]]+|[[:space:]]+$//g'; }
  sed -n 's/^\*\*Status:\*\* *//p' FILE | head -1 | norm             # stories, sprints, ADRs
  grep -m1 '^| Status ' FILE | awk -F'|' '{print $3}' | norm         # plans
  ```

- **`Updated`, with the date and the zone pinned.**
  `git log -1 --format=%ad --date=format:%d/%m/%Y -- FILE`. The **author** date — the one
  `git log -1` prints by default, and the one a rebase, an amend or a cherry-pick keeps — in the
  commit's recorded offset. Never `format-local:`, which renders in the reader's zone and moved
  `1a9da7c` to the next day under a +14 offset (AC-GAP-2). A row for an instance changed in the
  landing commit is written with the intended date and re-run after the commit (EC-09).
- **The link check the citation gate cannot do.** For each index, every Markdown link target
  tested with `test -e` from the index's own folder. Run it at close and record the count checked
  beside the count of rows; a row whose link is not tested has not been checked.
- **The counts that catch what the link check cannot.** Rows against instances, and links checked
  against rows, per index. A row carrying no link — a leftover placeholder — is invisible to the
  link check and visible only here (ES-02).
- **The cell count, for a Summary that breaks its row.** One value printed per index means every
  row of the register table has the header's cell count; two or more means a stray pipe or a
  broken row (ES-11, ES-12):

  ```bash
  sed -n '/^## The register/,/^## /p' FILE | grep '^|' | sed 's/\\|//g' \
    | awk -F'|' '{print NF}' | sort -u
  ```

- **The debt-line listing.** Removed lines only, by file, against the recorded pre-edit SHA:
  `git diff -U0 <SHA> | awk '/^\+\+\+ /{f=$2} /^-[^-].*Backfill owed/{print f}' | sort -u` — four
  lines expected, each one of the four index files. Records that newly _mention_ the phrase are
  added lines and do not appear.
- **The generated-tree grep, without the template false positive.**
  `grep -ohE 'US[0-9]{3}|SPRINT-[0-9]{2}' <the four generated index files> | grep -vxE 'US000|SPRINT-00' | sort -u`
  prints nothing when clean. It covers ADR and plan identifiers too, since both contain a story
  identifier.
- **Generation reads committed bytes.** The CI job renders `--vcs-ref=HEAD`
  (`.github/workflows/audit-template.yml:154`), so a generation run before the index edits are
  committed tests the pre-edit tree and proves nothing about this change.
- **Capture the citation baseline before the first edit**, with
  `git hash-object code/src/scripts/audits/doc-references.sh` beside it, and read the close run as
  a diff by the `(file, kind, token)` identity the US007 plan's AC-GAP-2 defines. A detector moved
  in between makes the diff detector-confounded, reported as such, never as US011's.
- **No gate reads any of this until S-03.** Every presence, symmetry and status check here is
  manual or a one-line command. Record the command, its output and the HEAD it ran at, so the
  walk-through is reproducible by the second tester the story requires (project-management/src/02-STORIES/US011.md:420).
- **No pytest, no coverage figure, no migration.** The Verification Checks' Python rows do not
  apply; the test record says `N/A` with the reason rather than leaving them blank.

## 7. Gate readings, measured 21/09/2026 — indicative, not baselines

Taken on `pm/story-creation` at HEAD `71a32d7`, with the working tree dirty from a concurrent
session and **no edit of US011's made**. These are readings, not the story's baseline, which is
captured immediately before its first edit.

| Reading                                       | Value                                                                                                                                                                                                                                                                                                                                                                                                                           |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Instances, N-003's test, exact index filename | **47 tracked** — 02-STORIES 11 · 03-SPRINTS 7 · 15-DECISIONS 20 · 17-STORY-PLANS 9. US012.md untracked, so 48 once committed. **Re-measured 27/09/2026** at the same HEAD under the positive pattern (settled 27/09/2026, grilling round 3 Q22): 47 tracked, unchanged; 50 on disk, US012.md and US010's two ADRs untracked. The any-`.md` test read 51 on disk, counting the untracked CUT-PLAN.md, which the pattern does not |
| Out of scope, same test                       | 20-FINDINGS **0** · 21-BUGS **0** · 01-FEATURE-MAPS 15 (US010's). The same under their positive patterns on 27/09/2026 (grilling round 3 Q22)                                                                                                                                                                                                                                                                                   |
| Plans, suffix-glob exclusion instead          | **8** — one real instance lost (EC-01). Still 8 with the exclusion layered on the positive pattern, 27/09/2026                                                                                                                                                                                                                                                                                                                  |
| Status values                                 | Stories `Open` ×11 · sprints `Planned` ×7 · ADRs `Accepted` 15, `Superseded` 3, `Proposed` 2 · plans `Open` 8, `Blocked` 1                                                                                                                                                                                                                                                                                                      |
| Carrier position                              | First `**Status:**` in every bold-carrier file is its carrier; every plan has exactly one Status row — both checked on all 47                                                                                                                                                                                                                                                                                                   |
| Trailing comments on carriers                 | **1** Status line (ADR-US004-CITED :11) · **2** tail lines (ADR-US002 REGISTER-SPLITS :7, SPLIT-TARGET :6)                                                                                                                                                                                                                                                                                                                      |
| Supersession chains                           | **3**, all symmetric; 2 of them same-date pairs; 1 ending on a `Proposed` record                                                                                                                                                                                                                                                                                                                                                |
| Same-US###, same-Date ADR groups              | **7** groups holding 17 of 20 ADRs                                                                                                                                                                                                                                                                                                                                                                                              |
| Last commit dates                             | 02/09/2026 to 20/09/2026; author and committer date differ on **0** of 47                                                                                                                                                                                                                                                                                                                                                       |
| Header date against last commit date          | **12 of the 36 dated instances differ at HEAD** — 6 ADRs, 6 plans, 0 sprints (stories carry no date). All 7 sprints differ in the dirty tree at the revision, `**Last Updated**` 21/09 against 20/09                                                                                                                                                                                                                            |
| `doc-references.sh --path` US011.md           | **25, exit 1** on the unmodified tracked file, 157 backticked tokens checked. **27, exit 1** at 17:05 on the working tree after the concurrent session's :170-173 rewrite, 161 tokens. All `[instance citation]`. Detector blob `b9e4e129f2781b37af3879db54af15999daa151d` at both readings                                                                                                                                     |
| `doc-references.sh --path` INCIDENT-INDEX.md  | **0, clean** — the shape the four indexes follow carries no finding of its own                                                                                                                                                                                                                                                                                                                                                  |
| Files mentioning "Backfill owed"              | **6** at the first reading; **9** at 17:02 — the same six tracked files plus three untracked gate artefacts, this plan among them. None an index; no index file exists yet. Gate artefacts that discuss the debt add to the figure (ES-08)                                                                                                                                                                                      |
| `doc-references.sh --path` this plan          | **24, exit 1** at the revision (21 at the first write) — all `[template-only citation]`, 0 instance, 0 dangling, 200 backticked tokens checked. The file is untracked, so the git-index class reads it as shipping (US004.md:205-211); expected to clear on commit, **not verified**, because staging is outside this pass                                                                                                      |
| Whole-tree `doc-references.sh`                | **Not run by this pass** — over ten minutes, and nothing in this plan rests on it                                                                                                                                                                                                                                                                                                                                               |

## 8. Four candidates refuted, and why they are recorded

Each was raised during the pass, each was plausible, and each fails on a measurement.

- **"A file's first `**Status:**` may sit in prose above its carrier."** US010 and US011 both quote
  the key in their own prose. Checked on all 38 bold-carrier instances: the first occurrence is the
  carrier in every one, and every plan carries exactly one Status row. The rule "first line keyed
  `**Status:**`" is safe on today's tree — EC-10 still requires the key rather than the line.
- **"SPRINT-01 to SPRINT-04 carry a trailing comment on their Status line."** A comment follows each
  of them, but on its own line after a blank one; the carrier line is clean in all seven sprints.
- **"US011's in-tree edits could move `shipped-artefacts.sh` or `shipped-registers.sh`."** The first
  reads a generated tree, where the seeds stand in for these files and the in-tree copies are
  excluded (`copier.yml:157`); the second reads `.copier/` and `copier.yml` only, its live paths
  appearing solely as `mv` destinations (`.github/scripts/shipped-registers.sh:76-77`, `:151-154`).
  "Unchanged" is a prediction the design supports, which is why HP-12 tests it rather than assumes it.
- **"Last commit dates are unstable because author and committer dates drift."** 0 of 47 differ
  today. The risk is real after a rebase, an amend or a cherry-pick, each of which rewrites the
  committer date and keeps the author date — which is why AC-GAP-2 names the author date — but it
  is not a present defect.

---

## Cross-references

- `project-management/src/02-STORIES/US011.md` — the story this plan tests; all thirteen gaps above are `[RESOLVED] 27/09/2026` in it
- `project-management/src/02-STORIES/US010.md` — the story that creates the four files, their tails, ordering prose and debt lines
- `project-management/src/03-SPRINTS/SPRINT-07.md` — the record US011 is the stretch `Should` of
- `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` — `N-002`, `N-003` and the `S-05` row
- `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` — the read rule this plan tests every Status against
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the citation reporting regime, superseded 30/09/2026 by `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged but for the manual testing guide's path <!-- UPDATED 30/09/2026: successor added beside the superseded record,
  which the 18-TESTS split superseded for the manual testing guide's path alone (settled
  30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
- `project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the baseline-diff procedure Section 6 routes to
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule Section 5's zero, Section 7's unrun row and ES-01 rest on
