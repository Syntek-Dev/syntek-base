# QA Plan — US010 The seven register indexes are born seeded

| Field         | Value                                                                                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**     | US010 — The seven register indexes are born seeded, and the map index leaves the file that ships                                                        |
| **Date**      | 21/09/2026                                                                                                                                              |
| **Sprint**    | SPRINT-06 — its sole member, 8 of 11 SP, holding a 5 SP reservation for US009's carry (13 / 11 SP at grace if it lands)                                 |
| **Wireframe** | N/A — this story ships Markdown, one YAML `_tasks` chain, one bash array, one bash check family and one Python probe; no screen, no component, no route |
| **Status**    | Signed off · **corrected in place 30/09/2026** — see below                                                                                              |

<!-- STEP 1's GRILLING PASS RAN on 21/09/2026: two rounds with the developer over US010 and US011
     together, frontier empty. Its decisions are cited below as "settled 21/09/2026, grilling round
     N QX" (R1Q1 to R2Q13 in the tables) and none is re-opened. Where a measurement bears on one
     without breaking it, the gap says so.

     STEP 2 HAS NO WIREFRAME TO REVIEW. The scenarios are derived from the story's Gherkin, the
     settled decisions, the two gate-10 artefacts written earlier today and the shell and CI surface
     itself, on the precedent of project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md.

     STEP 3's qa-tester pass IS this document: a general-purpose subagent with the qa-tester skill
     loaded, in a context that wrote neither the story nor its threat model, assessment or ADRs.

     METHOD. Written at HEAD 71a32d7 on pm/story-creation over a dirty working tree: seventeen
     porcelain entries at 17:39, every one a concurrent session's or this workflow's other gate
     files. US010.md carries that session's uncommitted edits (47 insertions, 20 deletions against
     HEAD), so every US010 line cited below is the working copy's as read at 17:39 on 21/09/2026,
     and every feedback edit is anchored on quoted text rather than on a line number. Every citation
     was re-opened today; the scripts were run where a project script exists to run them
     (Section 7), and read where none does.

     THIS PLAN DOES NOT EDIT THE STORY. Settled 21/09/2026, grilling round 2 Q9: new gate files are
     written now, and every edit to a shared file waits until the concurrent session commits. Each
     gap's resolution is returned as a feedback edit against US010.md or SPRINT-06.md; STEP 5
     applies them afterwards and re-tags each gap [RESOLVED] with its date. Until then
     project-management/src/11-QA/PLANNING/CLAUDE.md binds: no sprint plan for US010 while an [OPEN]
     gap stands. LIFTED 27/09/2026 by CUT-PLAN.md P9; the last two paragraphs of this comment
     record the write-back that followed and the final pass of the same day.

     ONE PREMISE OF THIS PASS'S BRIEF WAS STALE, and the stale half is recorded rather than acted on.
     The brief said SPRINT-06 still carries three leftovers of the deletion probe US010 handed to
     US012. Re-measured at 17:39: the concurrent session has already removed all three and recorded
     the repair in SPRINT-06's own FLAGS comment (SPRINT-06.md:45-52). No edit is owed for them
     (Section 8).

     REVISED 21/09/2026 against an independent verifier's findings, every cited line re-read first.
     The shipped-site inventory grows by nine sites, all in the 17-story-plans workflow and the
     story-plan template, so the proposed ST05 widening is six project-management/workflows/
     files, not three (AC-GAP-1). The measured count of changing map headers is now a flagged
     contradiction of the settled figure's wording, not a refuted candidate (Section 8). HP-03 gains
     a proposed host. Four literals and one citation are corrected. Gate 10's three ST07 obligations
     are now marked as awaiting sign-off in every held edit that carries them (AC-GAP-10). The
     working tree had moved to twenty porcelain entries by then, and none of the three new entries
     touches an index site.

     GRILLING ROUND 3 WAS ANSWERED ON 27/09/2026, AND ITS DECISIONS ARE RECORDED HERE, NOT WRITTEN
     BACK. Each is cited as "settled 27/09/2026, grilling round 3 Qn". The four gaps that needed the
     developer's word are settled: AC-GAP-1 (Q14), AC-GAP-3 (Q17), AC-GAP-10 (Q16) and AC-GAP-23
     (Q14 and Q15), each re-tagged [RESOLVED] 27/09/2026. That tag records the settled call only.
     Each of the four still carries a story edit, and those edits wait for the write-back with the
     other nineteen gaps' edits. The nineteen stay [OPEN] until STEP 5 applies them. Q18 and Q24 are
     recorded at AC-GAP-5, AC-GAP-2 and the map-status scenarios; Q21 at AC-GAP-13 and TM-10, on
     CUT-PLAN.md P8's footing; Q23 in Section 2's generated-tree wording and at AC-GAP-11. None of
     them settles a wording repair, so none of those gaps flips.

     WRITTEN BACK 27/09/2026, AND ROUND 2 Q9'S HOLD IS LIFTED. CUT-PLAN.md P9 (27/09/2026) lifted
     the two sessions' holds on each other, so STEP 5 ran: US010.md now carries this plan's edits,
     gate 10's and gate 15's, applied together over the concurrent session's uncommitted edits
     (project-management/src/02-STORIES/US010.md:176-188), and the story's round-6 amendment followed (:190-200). Twenty-two gaps
     were [RESOLVED] 27/09/2026 at that write-back, each citing the story line its fix sat at.
     AC-GAP-2 stayed [OPEN] then: the seed-row agreement clause it proposed for the family was
     Q34, asked 27/09/2026 and cited here as round 6 Q34, and unanswered at that point.
     Round 6 Q31 (27/09/2026) resolves the overlap in the map-status criteria, Blockers clear
     winning, and AC-GAP-5, HP-11, HP-21, EC-04 and TM-12 read the final criteria. Calls announced
     to the developer on 27/09/2026 and not objected to are cited as "call recorded 27/09/2026 with
     round 6". Citations "as read 21/09/2026" elsewhere are records of that reading and are not
     rewritten. AMENDED 27/09/2026 at the final pass: this paragraph read "Twenty-two gaps are
     [RESOLVED] 27/09/2026 ... every such citation measured on 27/09/2026 after that amendment
     landed. AC-GAP-2 stays [OPEN] ... so that clause is written nowhere", and cited the round-6
     amendment as :187-198.

     AMENDED 27/09/2026 AT THE FINAL PASS, and all twenty-three gaps are resolved. Q34 is answered
     (settled 27/09/2026, grilling round 7 Q34, option 1): the third shipped-registers.sh family
     gains ONE clause — the map-index seed's one row, read under the read rule, string-equals the
     scale-planning seed's own Status header (.copier/MAP-SCALE-PLANNING.md:4) — with its own
     --self-test probe, a mutated seed pair yielding exactly one finding, as every check in that
     family ships one. It is a clause in the settled family, not a second family, so round 2 Q12's
     trigger is not reached. The story carries it (its final-pass amendment, project-management/src/02-STORIES/US010.md:202-215),
     AC-GAP-2 is [RESOLVED] 27/09/2026, and HP-03's Status half is automated by the clause, not a
     manual read. Two calls of the same day land with it: the Q24 x Q31 reconciliation, under which
     wayfinder's chart step fills Charted and writes the value the map's counts give and never
     asserts Charting (AC-GAP-5, EC-22); and round 4 Q27's qualifier on the two ADRs' acceptance,
     after an independent review and before the US010 commit (AC-GAP-14). US010.md does not change
     again after the Stories phase, so every "now at US010.md" citation below was RE-MEASURED
     27/09/2026 against the final pre-commit text, by searching for the cited words and never by a
     guessed offset; for those citations it supersedes the METHOD paragraph's 17:39 reading and
     the measure the paragraph above records. A US010.md or
     SPRINT-06.md line in a gap's description locates the text as it was on 21/09/2026 and is
     marked "(as read 21/09/2026)" rather than re-pointed (Section 1). SPRINT-06 is still being
     edited in this pass, so its two 27/09/2026 citations are made by text, not by line.

     SIGNED OFF 30/09/2026 by <%DEVELOPER_NAME%> (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9), against the tree at a18db0b with that gate's corrections applied. The Status
     row read "Reviewed — all twenty-three gaps resolved into the story, 27/09/2026" until then. "US010.md does not change
     again after the Stories phase" stopped holding when the 16-sprint-plans gate corrected the
     story on 28/09/2026 and again on 30/09/2026, above lines this plan cites, and commit 0c5e635's
     text is no longer where the citations land. Every live line citation into US010.md and
     US011.md is re-measured against the stories as corrected that day; the numbers it replaces
     are kept in the dated comments beside Section 1's list and the tables that carry them. What
     else was corrected, and why, is the note below this comment. No gap, scenario or severity
     moves. -->

> **Corrected in place, 30/09/2026, at the `16-sprint-plans` gate, and signed off by
> <%DEVELOPER_NAME%>**: gate 11 closes when a QA plan reads `Signed off`, as gate 10 does (settled
> 30/09/2026, 16-sprint-plans grilling round 3 Q9). Three things had moved under the plan since its
> final pass of 27/09/2026. Correcting them in the same pass rather than under a signature is a
> call made 30/09/2026 while applying round 3, not one of its answers, on the pattern round 2 Q5
> set for the gate-10 plans. <%DEVELOPER_NAME%> reviewed every change made under this sign-off,
> this call among them, and accepted them all (settled 30/09/2026, 16-sprint-plans grilling
> round 5 Q16):
>
> - **Story citations follow the stories.** Every "Written back" citation in Section 1, HP-03,
>   and the TM-10 and TM-13 rows of Section 5 is re-measured against US010.md and US011.md as the
>   16-sprint-plans gate corrected them on 28/09/2026 and 30/09/2026 — the text is unchanged,
>   only its lines moved, bar one: the `GAPS.md` routing bullet AC-GAP-23 cites now names a fourth
>   routed item and spans `project-management/src/02-STORIES/US010.md:426-442`. Citations marked
>   "as read 21/09/2026" keep locating the text as it stood then.
> - **Both US010 ADRs read `Accepted`**, not `Proposed` pending review: each file's `:3`, committed
>   so at `0c5e635` after round 4 Q27's independent review. Corrected in the Cross-references; the
>   "(Proposed)" in AC-GAP-4 and AC-GAP-5 records their state when settled on 21/09/2026.
> - **Tree citations were re-measured on 30/09/2026**, against the tree committed together with the
>   18-TESTS split. Commit `ceb2d70` (28/09/2026) moved four of AC-GAP-1's twenty-four sites in
>   `project-management/workflows/17-story-plans/`, and the 18-TESTS split moves eight, those four
>   among them, and the dated template comment the list cites as an example, each recorded beside
>   the list that cites them. The split moves five other citations, each re-pointed with its old
>   number kept in a dated comment beside it: the `copier.yml` one-way door and the
>   `project-management/src/23-INCIDENTS/CONTEXT.md` precedent in Section 1, HP-04's seed task and
>   HP-17's plans-index section, and EC-17's conditional `_exclude` entries. Every other citation
>   into `copier.yml`, `.github/scripts/`, `.github/workflows/`, `code/src/scripts/`,
>   `pyproject.toml`, the templates, the ADRs and the maps holds. The split rewrites lines in
>   `copier.yml`, `.github/scripts/shipped-artefacts.sh`, `pyproject.toml` and the templates without
>   moving any other line cited here, and every other file this plan cites by line among them is
>   unchanged since `71a32d7`, where this plan was measured, bar the two ADRs, committed at
>   `0c5e635` with the paragraphs cited where they were read, and `MAP-REGISTER-INDEXES.md`, which
>   the RESOLVE sitting of 27/09/2026 corrected at the N-003 and Acceptance-cell lines AC-GAP-2,
>   AC-GAP-8 and AC-GAP-17 cite as read 21/09/2026, as AC-GAP-17 records. Section 7's readings and
>   the dated record of 21/09/2026 beneath Section 1's list stay readings of `71a32d7`. The story
>   citations on lines changed at this gate carry their full repo-relative path since 30/09/2026.
>
> Corrected rather than superseded because no gap, finding, scenario or severity moved. Signing off
> ticks no box in the story; the implementation review closes each scenario with evidence.

---

## 1. Acceptance criteria gaps

**Twenty-three gaps — three blocking, fourteen material, six minor — and all twenty-three are
`[RESOLVED] 27/09/2026`**, each with its resolution below. Every resolution was held on 21/09/2026
(settled 21/09/2026, grilling round 2 Q9) and returned as a feedback edit against
`project-management/src/02-STORIES/US010.md` or `project-management/src/03-SPRINTS/SPRINT-06.md`.
CUT-PLAN.md P9 lifted that hold on 27/09/2026, the write-back of the same day applied the edits,
and each resolved gap cites the story line its fix now sits at. AC-GAP-2, the last, was resolved
at the final pass of the same day (settled 27/09/2026, grilling round 7 Q34, option 1). AMENDED
27/09/2026 at the final pass: this read "Twenty-two are `[RESOLVED] 27/09/2026` and one, AC-GAP-2,
is `[OPEN]`", AC-GAP-2 standing "on round 6 Q34 alone".

**Two kinds of story citation, never mixed.** A gap's description locates US010.md and
SPRINT-06.md as the working copies read on 21/09/2026. The first line a description cites from
each file is marked "(as read 21/09/2026)", every bare line number after it in that description
reads the same way, and none is re-pointed. Each gap's "Written back" sentence carries the current
line instead, re-measured 30/09/2026 against US010.md as the 16-sprint-plans gate corrected it on
28/09/2026 and 30/09/2026, each moved line checked against its text and never taken on an offset
alone. AMENDED 30/09/2026 at the sign-off: this read "re-measured 27/09/2026 against the final
pre-commit US010.md by searching for the cited text, never by a shifted offset; US010.md does not
change again after the Stories phase", which the gate's two corrections made false.

**The three blocking gaps are criteria that cannot be delivered correctly as written**, the grading
of `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`. Two of them are also
one-way doors: a seed is seed-once, so a wrong seed row or a wrong ordering sentence ships into every
project generated afterwards and no update can take it back (`copier.yml:988-993`). The third is a
pair of criteria that contradict each other.

**Four gaps needed the developer's word rather than a wording repair:** the allowlist widening in
AC-GAP-1, the tie-break and the date column in AC-GAP-3, the three `shipped-ai.py` obligations
gate 10 added in AC-GAP-10, and the three questions gate 10 raised and did not settle in
AC-GAP-23. **All four were settled 27/09/2026 in grilling round 3** (Q14 to Q17), and each carries
its settlement beneath its resolution. `[RESOLVED] 27/09/2026` on those four first recorded the
settled call alone. Their story edits landed in the write-back of the same day with every other
gap's.

**Two gaps are shared with `project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md`**
— the ordering prose (its AC-GAP-3, here AC-GAP-3) and the Instance label (its AC-GAP-13, here
AC-GAP-7). That plan routed both to this one for de-duplication. One edit each, applied once.

**One returned edit answers no gap.** SPRINT-06.md:474-475 (as read 21/09/2026) said the member's
QA plan is one "which gate `11` has yet to write". That stopped being true when this file was
written. The returned edit names this file and landed 27/09/2026. It is the row under SPRINT-06's
"QA Acceptance Criteria — Manual" reading "**No `[OPEN]` acceptance-criteria gap remains** in the
member's QA plan", cited by its text because SPRINT-06 is still being edited in this pass. That row
stays unticked while any gap here is `[OPEN]`; since the final pass of 27/09/2026 none is, so
nothing in this plan holds it, and ticking it is the sprint record's own act. AMENDED 27/09/2026 at
the final pass: this cited the row as SPRINT-06.md:622-625 and read "so AC-GAP-2 alone holds it".

- **AC-GAP-1** `[RESOLVED] 27/09/2026` · **blocking** — **the shipped-site inventory is
  incomplete, and the allowlist forbids repairing what it misses.** The story names six sites across
  three files (US010.md:380-386, as read 21/09/2026), and the grilling pass added three more
  (`project-management/src/15-DECISIONS/CLAUDE.md:47`,
  `project-management/src/17-STORY-PLANS/CLAUDE.md:64-68` and `:74`). A sweep of the shipped tree on
  21/09/2026 found six further live sites that name `CONTEXT.md` as a register's index, or say a
  register's index has not landed: `project-management/src/01-FEATURE-MAPS/CLAUDE.md:6` (read order:
  `CONTEXT.md` holds "the index") and `:51` ("the index in `CONTEXT.md`");
  `project-management/src/01-FEATURE-MAPS/CONTEXT.md:11` (the tree annotation "also the map index");
  `project-management/workflows/01-feature-map/STEPS.md:144` ("Add the map to the index in
  `src/01-FEATURE-MAPS/CONTEXT.md`") and
  `project-management/workflows/01-feature-map/CHECKLIST.md:98` ("`src/01-FEATURE-MAPS/CONTEXT.md`
  index current"); and `project-management/workflows/17-story-plans/CLAUDE.md:87-91` ("the
  folder-level index is deferred to the register-index work … which names its own file when it
  lands"). **Verification found nine more, the same day**, each saying that the story-plan register
  has no index or that its index is deferred. Every one becomes false the day STORY-PLAN-INDEX.md
  lands: `project-management/workflows/17-story-plans/STEPS.md:43` (the references row "no folder
  index"), `:101-102` ("There is no folder-level index to carry it") and `:192-195` ("Add nothing to
  `src/17-STORY-PLANS/CONTEXT.md` … which names its own file when it lands");
  `project-management/workflows/17-story-plans/CHECKLIST.md:114-115` ("the folder-level index is
  deferred"); `project-management/workflows/17-story-plans/CONTEXT.md:57-58`, `:87-88` and `:96-98`;
  and the shipped plan template,
  `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:16` (its how-to-use block)
  and `:625` (a live table cell), each reading "holds no index, by decision". The template ships
  through the `*TEMPLATE*` re-include at `copier.yml:164`. The story's Index Task re-measures "the
  Plans Index citation population" (US010.md:483-484) but names no repair for what it finds. These
  nine are that population as measured today. The dated comments in the same files are records true
  of 08/09/2026, for example `project-management/workflows/17-story-plans/STEPS.md:17-35` and the
  template's `:792-807`. The story's own scenario already exempts dated historical comments
  (US010.md:386), so they are not in the inventory. The two procedures of record — `01-feature-map`
  for charting a map, `17-story-plans` for writing a plan — would each tell the next session to do
  what this story undoes. **The contradiction:** six of the files sit under
  `project-management/workflows/`, outside ST05's allowlist even as widened on 21/09/2026
  (assessment Section 7.5). So the site scenario's grep (US010.md:386) requires them repaired, and
  ST05 forbids the write. **The grep cannot pass as worded either.** It is line-based, and two of
  the six named sites are split across lines
  (`project-management/src/01-FEATURE-MAPS/CLAUDE.md:21-22`,
  `.claude/skills/wayfinder/SKILL.md:97-98`), so a clean grep proves nothing about them. It runs
  "across the repository", where every live map's own Gate-to-stories line reads "Index row in
  `CONTEXT.md` current" or a variant (for example
  `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md:740`), outside any comment, so a correct
  build fails it. And it looks only for the old instruction, so it cannot see a site that says an
  index is absent. **Resolution:** the site scenario enumerates all twenty-four live sites measured
  on 21/09/2026 and says what each must say.
  `project-management/workflows/01-feature-map/CHECKLIST.md:64` is re-read, since it already reads
  true once the index sits in that folder. The grep becomes "a search over the files a generated
  project receives, run over joined lines, returns no instruction naming `CONTEXT.md` as a
  register's index, and no statement that a register has no index or that its index is deferred,
  outside dated historical comments". The maps' own boxes are covered by the Map Task, whose
  returned edit rewrites each ticked box's text to name MAP-INDEX.md. **ST05 widens by six files:**
  `project-management/workflows/01-feature-map/STEPS.md`,
  `project-management/workflows/01-feature-map/CHECKLIST.md`,
  `project-management/workflows/17-story-plans/CLAUDE.md`,
  `project-management/workflows/17-story-plans/STEPS.md`,
  `project-management/workflows/17-story-plans/CHECKLIST.md` and
  `project-management/workflows/17-story-plans/CONTEXT.md`. That was a new widening, not the settled
  one, so it was **the developer's call**. The alternative was to route the ten sites in those six
  files to a `GAPS.md` entry through `22-implementation-documentation`, which would have left two
  procedures of record instructing the defect. The two template sites and the other twelve sit
  inside the allowlist and are repaired either way. **Settled 27/09/2026, grilling round 3 Q14:**
  ST05's allowlist widens a second time, by the whole of `project-management/workflows/` (not the
  six files alone), by `how-to/src/TEMPLATE-GUIDE/` and by `how-to/src/TEMPLATE-TOKENS.md`. US010
  corrects all twenty-four live sites this gap and Section 7 inventory. It also corrects the
  `--trust` disclosure at `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22`, which is TM-13's first
  site rather than one of the twenty-four (AC-GAP-23). Q14 covers that site and the six other
  TM-13 count sites as well as the twenty-four (call recorded 27/09/2026 with round 6). The
  `GAPS.md` alternative is not taken.
  **Merge order against US015** (provisional, RULE-OWNERSHIP S-02, which edits other lines of
  `06-GENERATION.md`, `15-TROUBLESHOOTING.md` and `TEMPLATE-TOKENS.md`): US010, in SPRINT-06, lands
  first, and US015 rebases. Q14 does not itself re-size the story (AC-GAP-20). Written back
  27/09/2026: the site scenario is now at project-management/src/02-STORIES/US010.md:686-696, ST05 at :812-825, and the
  Documentation Tasks repairing the sites at :1036-1047, :1058-1065 and :1076-1084. Threat model
  TM-15; assessment Section 7.5.
- **AC-GAP-2** `[RESOLVED] 27/09/2026` · **blocking** — **the map-index seed row contradicts
  itself, and it is a one-way door.** The generated-project scenario gives MAP-INDEX.md's seed row
  "every column reading TBD" (US010.md:349, as read 21/09/2026), and ST03 (:410) and the seed task
  (:490-491) say the same. The MAP-INDEX scenario says "each row's Instance cell links to the map"
  (:319). A seed shipping `TBD` in its
  Status cell against `.copier/MAP-SCALE-PLANNING.md:4`'s `Not started` also fails N-003's status
  clause in every project generated before S-03 ships, and no update can correct it. Settled
  21/09/2026, grilling round 1 Q4: `Not started` is the fifth map status; the seed row's Status
  mirrors it; its Instance cell links the seeded map; its Summary is a generic one-liner naming
  nothing syntek-base-specific, or `TBD`; its Updated is `TBD`. That value's criterion was settled
  27/09/2026, grilling round 3 Q18: `Not started` means nothing charted, `Charted` reading `TBD`,
  and the seeded map's own header reads exactly that (`.copier/MAP-SCALE-PLANNING.md:3-4`).
  **Resolution:** the scenario reads
  "MAP-INDEX.md carries exactly one row, for the seeded MAP-SCALE-PLANNING.md: Status `Not
started`, string-equal under the read rule to that map's own header; Instance a Markdown link to
  MAP-SCALE-PLANNING.md; Summary a generic line naming nothing syntek-base-specific, or `TBD`;
  Updated `TBD`". ST03 and the seed task take the same wording; SPRINT-06's mirrors
  (SPRINT-06.md:431-433, :495, as read 21/09/2026) follow. **The agreement needs a host at
  template time.** Nothing asserted on 21/09/2026 that the map-index seed's row and
  `.copier/MAP-SCALE-PLANNING.md:4` agree, so a later edit to one seed and not the other would
  have passed every gate and shipped. The host proposed then was one more clause in the third
  `shipped-registers.sh` family (AC-GAP-9). **Settled 27/09/2026, grilling round 7 Q34, option
  1:** the family gains that ONE clause — the map-index seed's one row, read under the read rule,
  string-equals the scale-planning seed's own Status header (`.copier/MAP-SCALE-PLANNING.md:4`) —
  with its own `--self-test` probe, a mutated seed pair yielding exactly one finding, as every
  check in that family ships one. It is a clause in the settled family, not a second family, so
  grilling round 2 Q12's trigger is not reached. HP-03 is therefore automated by this clause, not
  a manual read. Written back 27/09/2026: the seed-row wording is now at project-management/src/02-STORIES/US010.md:637, its
  agreement asserted by the seed-row clause at :638; the clause in the seed family's scenario at
  :666 and its probe at :667; ST03's seed-row clause at :795-803, within ST03 at :787-803; the
  seed task at :1006-1010; the QA criterion naming the probe at :863-868; the Security Task at
  :1193-1204; and the Verification Check at :1246-1251. AMENDED 27/09/2026 at the final pass: this
  gap read `[OPEN]`, called the clause "a proposal, not settled", said the gap "stays `[OPEN]` as a
  wording repair", and recorded HP-03 as a manual read of a generated tree if the clause were
  declined. Assessment Section 7.4; threat model TM-08.
- **AC-GAP-3** `[RESOLVED] 27/09/2026` · **blocking** — **the ordering scenario states an order
  the settlement reversed for two registers, and two parts of the settled order are unnamed.**
  US010.md:310 (as read 21/09/2026) puts STORY-PLAN and DECISION "ascending by identifier". Settled 21/09/2026, grilling
  round 1 Q7: STORY-PLAN-INDEX ascends by the build-order prefix; DECISION-INDEX by US### then Date
  ascending, so a story's supersession chain reads forwards; STORY and SPRINT ascend by identifier;
  MAP, FINDING and BUG descend by date. The ordering prose ships in every seed, so a wrong sentence
  is permanent. **Two things the settlement did not name.** First, **the tie-break**: measured
  21/09/2026 over the `**Date:**` lines of the 20 tracked ADRs, 17 sit in seven groups sharing both
  US### and Date (the US011 plan's AC-GAP-3 reads the same), and US010's own two ADRs make an
  eighth. Second, **which date** MAP, FINDING and BUG descend by. `Updated` cannot be it: this story
  edits nearly every map in its landing commit, so under grilling round 1 Q6 nearly every MAP-INDEX
  row would share one date (EC-03). Each register's own creation date is in its tail — a map's
  `**Charted**` header (`project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:3`), a finding's
  filename date, a bug's `**Date found**` row
  (`project-management/src/21-BUGS/BUG-US000-TEMPLATE.md:15`). **Resolution:** US010.md:310 reads
  "MAP, FINDING and BUG descending by the register's own creation date — a map's Charted date, a
  finding's filename date, a bug's Date found — ties by identifier ascending; STORY and SPRINT
  ascending by identifier; STORY-PLAN ascending by the build-order prefix, rows renamed when a plan
  is renumbered; DECISION by US### then Date ascending, ties broken by the rule the file states".
  The proposed tie-break is the US011 plan's: within a tie a supersession predecessor precedes its
  successor, and otherwise filename ascending. The date column and the tie-break were proposals for
  the developer, because without them "ties broken by the rule the file states" asserts nothing.
  **Settled 27/09/2026, grilling round 3 Q17:** MAP, FINDING and BUG index rows descend by each
  register's own creation date, ties broken by identifier. Within a DECISION tie, meaning the same
  US### and the same Date, a predecessor comes before its successor, then filename. Both halves of
  the proposal stand: the date column as proposed, and the proposed tie-break as the rule
  DECISION-INDEX states. **The one detail Q17 left open is settled:** Q17 named no direction for
  the identifier tie-break, and index ties sort by identifier ascending (call recorded 27/09/2026
  with round 6), so the "ascending" first proposed here stands. Written back 27/09/2026: the
  ordering sentence is now at project-management/src/02-STORIES/US010.md:584, and the Index Task designing each order at :961-964,
  each crediting the direction to that call.
- **AC-GAP-4** `[RESOLVED] 27/09/2026` · material — **the story has no rule for reading a Status, and its carrier
  inventory omits two registers.** US010.md:311 (as read 21/09/2026) says "mirrored verbatim" and :329 "string-equals
  that leading enum value"; neither defines how a value is read out of its carrier. The carrier
  task (:467-471) claims "four different status carriers" but shows three shapes across five
  registers, and omits findings (Status is the last
  middle-dot-separated field of a metadata line, `project-management/src/20-FINDINGS/FINDING-US000-TEMPLATE.md:5`)
  and bugs (a bold-key table row, `project-management/src/21-BUGS/BUG-US000-TEMPLATE.md:17`). The
  bullet's own Markdown is broken (KNOWN DEFECT 3): backslash-escaped backticks inside an inline code
  span do not escape in CommonMark, "as" has no space before it, and the continuation at :471 is
  indented one space rather than six. Settled 21/09/2026, grilling round 1 Q5: one read rule for all
  seven carriers, recorded in
  `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (Proposed).
  **The rule applies to the value after the key, never to the whole line.** For a finding, cutting
  the metadata line at its first middle dot loses the Status entirely (EC-08). **Resolution:** :311
  reads "the Status column holds the artefact's own value under the one read rule — the carrier value
  with bold markers, backticks, any trailing HTML comment and everything from the first
  space-middle-dot-space removed, then trimmed — never translated", citing the ADR. The carrier
  bullet is rewritten to name all five carrier shapes across the seven registers, with a
  double-backtick code span for the plan row and correct indentation. A new Index Task writes the
  rule into each index's "How to read a row". Written back 27/09/2026: the Status clause is now at
  project-management/src/02-STORIES/US010.md:585, the carrier task naming five shapes across seven registers at :961-973, and the
  How to read a row task at :974-981. Assessment Section 7.9; threat model TM-11.
- **AC-GAP-5** `[RESOLVED] 27/09/2026` · material — **the status scenario, the manual check and the map task still
  carry four values and allow bold, and no task edits the definition site.** US010.md:323-329
  (as read 21/09/2026), :447-449 and :518-520.
  Settled 21/09/2026, grilling round 2 Q11 (with round 1 Q4's fifth value) and recorded in
  `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`
  (Proposed): the header is `<enum> · <prose>`, the value plain — no bold, no backticks — over five
  values, `Charting`, `Resolving`, `Blockers clear — stories may start`, `Complete` and `Not
started`. "Begins with one of" (:326) admits a bold value, which ten of the twelve headers being
  rewritten carry today. **No task edits the definition site**:
  `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4` still reads four values and states
  no format, and the story repoints that file's :8 and :159 only. **A flagged contradiction of the
  settled figure's wording, not of the decision.** Grilling round 2 Q11 settled that "12 of the 15
  live maps are rewritten". Measured 21/09/2026, at least thirteen headers change.
  `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md:4` parses as `Charting`,
  but its own :5 records the frontier closed on 31/08/2026 with 0 blocking open. Its value is
  therefore re-derived even though its format is right (EC-04; the ADR's own Context, :44-59). Twelve
  is the count of headers that fail the format. The format is not re-opened, and the story's
  criteria hold no count, so nothing below depends on which figure is right. The figure is reported
  in this pass's return (Section 8). **Resolution:**
  the scenario reads the five values, the plain value, the key's own line, re-derivation of every
  header and string-equality under the read rule; a Documentation Task gives
  `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4` the fifth value and a one-line
  format statement; the map task and the
  manual check move to five values and "every header re-derived, including the three that already
  parse". **Settled 27/09/2026, grilling round 3 Q18, and amended the same day by round 6 Q31:**
  each map's value is derived from the map's own counts. `Not started` is nothing charted
  (`Charted` reads `TBD`). `Charting` is charted with no node resolved and `Blocking open` above 0.
  `Resolving` is at least one node resolved with `Blocking open` above 0.
  `Blockers clear — stories may start` is `Blocking open` 0 and not `Complete`. `Complete` is
  `Frontier open` 0 with the Fog of war empty. Q18's criteria overlapped: a charted map with no
  node resolved and `Blocking open` 0 met both `Charting` and `Blockers clear`. Q31 resolves the
  overlap, and Blockers clear wins, so that map is `Blockers clear — stories may start`; the
  `Blocking open` clause on `Charting` is Q31's. The criteria go into the enum ADR's Decision
  item 3 now. US010 writes them into `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4` when
  it is built, beside the fifth value and the format statement; the template is not edited before
  then. **Settled 27/09/2026, grilling round 3 Q24:** wayfinder's chart step is what moves a map
  out of `Not started`, when it writes the map's first node. **Reconciled with round 6 Q31 by the
  call recorded 27/09/2026:** Q24 settled who moves the map and Q31 the value, by counts, so the
  chart step fills `Charted` and writes the value the counts give — `Charting` while
  `Blocking open` is above 0, otherwise `Blockers clear — stories may start` — and never asserts
  `Charting`. US010 carries that one-line edit to `.claude/skills/wayfinder/SKILL.md`.
  `scale-planning` charts through wayfinder, so it needs no line. AMENDED 27/09/2026 at the final
  pass: this read that the chart step "moves a map out of `Not started`, to `Charting`", which a
  first node that is not blocking would contradict under Q31. Written back 27/09/2026, Q31 and the
  reconciliation included: the status scenario is now at project-management/src/02-STORIES/US010.md:609-616, the manual check at
  :906-913, the definition-site Map Task at :1152-1162, the re-derivation task at :1163-1170, and
  the wayfinder line at :721-725 and :1048-1057. Assessment Section 7.10; threat model TM-12.
- **AC-GAP-6** `[RESOLVED] 27/09/2026` · material — **`Updated` has no source, and the manual check's source does
  not exist.** The spine scenario (US010.md:308, as read 21/09/2026) names the column and nothing more. The manual check
  (:443-446) requires every row's `Updated` to match "its map's own header", and a map header
  carries `Charted`, `Status`, `Frontier open` and `Blocking open` — no updated date
  (`project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:3-5`). Settled 21/09/2026, grilling
  round 1 Q6: `Updated` is the instance file's last commit date, rendered `DD/MM/YYYY`; no gate
  reads it. Two refinements, aligned with the US011 plan's AC-GAP-2 so the two stories read one
  column one way: the **author** date (`%ad`, the one `git log -1` prints and a rebase keeps), in
  the commit's recorded offset rather than the reader's. **Every map this story edits takes the
  landing commit's date** — which, with a header re-derivation and a box per map, is nearly all
  fifteen (EC-03). **Resolution:** the spine scenario gains "And Updated is the instance file's last
  commit date — its author date, rendered DD/MM/YYYY in the commit's recorded offset — or `TBD` in
  a seed"; the manual check reads "every `Updated` equals its map's last commit date, re-checked
  after the landing commit exists". Written back 27/09/2026: the Updated clause is now at
  project-management/src/02-STORIES/US010.md:587, the manual check at :902-903, and the How to read a row task at :977-979.
- **AC-GAP-7** `[RESOLVED] 27/09/2026` · material — **the manual check names a count the map header does not carry,
  and the Instance label has no rule for descriptor-less registers.** "Slice count matches its map's
  own header" (US010.md:445, as read 21/09/2026) — no map header carries a slice count (MAP-000-TEMPLATE.md:3-5);
  slices are rows of each map's Slices table. The tail columns are the implementer's to design
  (:467), so the check must name each column's **source**, not a literal column set. Separately, N-002
  labels each Instance "with its descriptor" (MAP-REGISTER-INDEXES.md:183), and a story or sprint
  file is named by its identifier alone — shared with the US011 plan's AC-GAP-13, which routed it
  here. **Resolution:** the manual check reads "every tail count equals its source — a header-derived
  count its header field, a slice count the rows of that map's Slices table"; the spine scenario
  gains "each Instance cell is a Markdown link labelled with the file's descriptor, or its
  identifier where the filename carries none"; each index's "How to read a row" says which.
  Written back 27/09/2026: the Instance label clause is now at project-management/src/02-STORIES/US010.md:586, the tail-count check
  at :903-905, and the How to read a row task at :974-981.
- **AC-GAP-8** `[RESOLVED] 27/09/2026` · material — **the map instance test counts the index itself.** US010.md:314
  (as read 21/09/2026) defines a map instance as "a tracked MAP-\*.md file that is not MAP-000-TEMPLATE.md". N-003's
  test also excludes "the index itself" (MAP-REGISTER-INDEXES.md:231-233). Once this story lands
  MAP-INDEX.md in `project-management/src/01-FEATURE-MAPS/`, it matches `MAP-*.md` and the scenario
  demands a row for itself — and S-03, inheriting the story's wording, would demand it too. A
  suffix exclusion is not the fix: `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`
  is a real map whose name contains `INDEX` (EC-01; the same trap the US011 plan's AC-GAP-8 found
  in `17-STORY-PLANS`). **Resolution:** :314 reads "Given an instance is a tracked MAP-\*.md file
  that is neither MAP-000-TEMPLATE.md nor MAP-INDEX.md, each excluded by exact filename"; the
  backfill task (:476-479) says the same. Written back 27/09/2026: the MAP-INDEX scenario's Given
  is now at project-management/src/02-STORIES/US010.md:600 and the backfill task at :986-992. The story goes further on grilling
  round 3 Q22: every register's instances are named by a positive filename pattern, every
  `*TEMPLATE*` file and the index excluded by exact filename (:590-597).
- **AC-GAP-9** `[RESOLVED] 27/09/2026` · material — **ST03's proof has no named host, and the story still calls
  the negation check a confirmation.** ST03 requires emptiness "proved by a check" (US010.md:409-412, as read 21/09/2026)
  and no task writes one. Settled 21/09/2026, grilling round 1 Q2: `.github/scripts/shipped-registers.sh`
  gains a third family for the seven index seeds — seed exists; its `mv` line inside the
  copy-gated chain; the `## The register` canvas marker; no instance rows bar the empty-register
  placeholder row and MAP-INDEX's single seeded row; and **no** `_exclude` negation re-including
  any index path — with self-test probes. The task at :498-499 still reads "Confirm no `_exclude`
  negation is needed" — true of the design and unasserted by anything — and says
  `code/src/scripts/audits/doc-references.sh:373` parses the lines "out of `_tasks`", when it greps
  the whole of `copier.yml`. **Four properties the family must hold, or it passes while proving
  nothing** (Section 6): its list of seven is its own constant, so a seed and its `mv` line removed
  together is still reported (ES-08); the chain clause reads only the copy-gated task's command,
  because `.github/scripts/shipped-registers.sh:149-154` greps the whole block and cannot tell a
  gated task from an ungated one; each mutation yields exactly one finding, the probe rule at
  `:213-216`, so a glob negation matching seven paths reports once per negation (ES-04); and its
  checks are numbered 10 onward, the header's "append, never renumber" (`:37-38`). **Resolution:** a
  new Gherkin scenario and a Seed Task for the family and its probes, carrying AC-GAP-2's proposed
  seed-row agreement clause marked as awaiting the developer; :498-499 reads "Assert that no
  `_exclude` negation re-includes an index path — the family's negation check (ST06)". The Story
  Points comment gains grilling round 2 Q12's trigger: "if the `shipped-registers.sh` extension
  needs more than one new family plus its probes, this goes to 13 and back to `01-feature-map`".
  Written back 27/09/2026: the family's scenario is now at project-management/src/02-STORIES/US010.md:660-668, ST03 at :787-803, the
  Security Task at :1193-1204, the negation task at :1026-1030 and the Story Points trigger at
  :304-313. The seed-row agreement clause is carried since the final pass (settled 27/09/2026,
  grilling round 7 Q34, option 1), as one clause of this family with its own probe: in the
  family's scenario at :666-667, in ST03 at :795-803 and in the Security Task at :1197-1204, and
  the Story Points comment records that Q12's trigger still has not fired (:324-326; AC-GAP-2).
  AMENDED 27/09/2026 at the final pass: this read "The seed-row agreement clause is not carried:
  it is AC-GAP-2's, round 6 Q34 is unanswered, and the story names its absence". Assessment
  Sections 7.3 and 7.6; threat model TM-02, TM-03, TM-04.
- **AC-GAP-10** `[RESOLVED] 27/09/2026` · material — **the update probe has no host, and the one
  it must use is red under this story as written.** "A `copier update` probe … asserts that no index
  file is reverted to its seed" (US010.md:429-430, task :532, as read 21/09/2026). `.github/scripts/shipped-ai.py` is
  the only CI path that runs a real update (`audit-template.yml:165-166`), and its fixture creates
  one destination folder (`.github/scripts/shipped-ai.py:103-104`), so the first new `mv` into
  `02-STORIES/` fails, `TaskError` escapes `copy_project` (`:188-193`), and `[3/4]` goes red.
  Settled 21/09/2026, grilling round 1 Q3: the fixture creates the six register folders; the update
  probe asserts every edited index survives; no `mkdir -p` enters `copier.yml`. **The fix belongs in
  `fixture()` itself**: `exercise()` (`:198`), `exercise_legacy()` (`:257`) and `self_test()`
  (`:240`) each build their template through it and each runs a real copy through the seed chain.
  **The probe must also assert all seven land after the copy**: `main()` keeps only the task holding
  the memory `mv` (`:320-328`), so an index line moved into a second task is silently dropped from
  the fixture and an "edited indexes survive" check passes vacuously. **Gate 10 added three
  obligations that grilling round 1 Q3 did not settle** (assessment Section 7.7, threat model
  Section 4c item 5): the template changes every index seed between its two tags, the assertion is
  byte-identity, and a self-test mutation removing the seed task's copy gate turns it red. They are
  new Python work that round 2 Q12's trigger does not count. **Resolution:** a Seed Task and a QA
  criterion carrying the settled half, and ST07 naming the three obligations. On 21/09/2026 ST07
  marked them "for the developer's sign-off", and every other held edit carried the settled half
  alone, with an applier note naming the words to add once he signed off: the flags, the Gherkin,
  the QA and seed tasks, the Verification Checks, the Story Points note and SPRINT-06's mirrors.
  **Settled 27/09/2026, grilling round 3 Q16:** all three obligations go into US010, so each of
  those held edits takes the words its applier note names. The developer signs off knowingly that
  round 2 Q12's trigger does not count this `shipped-ai.py` work. The memory-survival probe has the
  identical blind case (`shipped-ai.py:174-175`): its second tag never changes the memory seed, so
  by the same reading it would pass with the memory seed task ungated. That case is routed to
  `GAPS.md` through gate 22 (`project-management/workflows/22-implementation-documentation`, sole
  owner of `GAPS.md` writes) and is not built here. A Verification Check records that no project
  lint leg reads the file (`code/src/scripts/syntax/lint.sh:262-265` reads Python under
  `code/src/django/` only; `pyproject.toml:184` scopes basedpyright the same way). SPRINT-06's five
  "no Python" statements (SPRINT-06.md:43-44, :462, :549, :599, :602, as read 21/09/2026) become
  false and are corrected. Written back 27/09/2026: ST07 is now at project-management/src/02-STORIES/US010.md:836-848, the
  update-probe scenario at :643-651, the QA criterion at :873-877, the Security Task at
  :1205-1210, the Verification Checks at :1246-1251 and :1262-1264, the Security and QA flags at
  :225-226, and the Story Points note at :309-313. SPRINT-06 records its own correction in its
  FLAGS comment, the paragraph beginning "CORRECTED 27/09/2026 from gate `11`", cited by its text
  because SPRINT-06 is still being edited in this pass (AMENDED 27/09/2026 at the final pass: this
  cited it as SPRINT-06.md:74-77). Assessment Section 7.7; threat model TM-01, TM-04, TM-05.
- **AC-GAP-11** `[RESOLVED] 27/09/2026` · material — **"all seven present" has no host, and the QA flag credits
  the self-test with a proof it does not make.** The integration criterion (US010.md:424-426, as
  read 21/09/2026)
  requires all seven indexes in each generated tree. `.github/scripts/shipped-artefacts.sh` check 4
  loops `NAMED_SHIPPED` and `SHIPPED_GLOBS` only (`:215-224`); the `SEEDED` loop is US012's, and
  neither story blocks the other (US010.md:233-238). The completeness step in `[3/4]`
  (`.github/workflows/audit-template.yml:230-248`) lists root seeds beside other shipped files and
  no nested seed: neither the scale-planning map nor `.claude/MEMORY.md`. The QA flag's
  "`shipped-artefacts.sh --self-test` (seed-lands)" (:130) is wrong about what the self-test shows:
  its baseline proves the `SEEDED` entries are **not reported as leaks**, never that they landed.
  **Resolution:** the seven landed paths join the completeness loop at
  `.github/workflows/audit-template.yml:235-241` (inside the settled widening); the criterion names
  that host and `.github/scripts/shipped-ai.py`'s post-copy assertion (AC-GAP-10); the QA flag
  reads "`shipped-artefacts.sh --self-test` (the eight seeds not reported as leaks);
  `shipped-registers.sh --self-test` (seed-blank, wired, never re-included); generation smoke on
  every render path the template offers (today: `INCLUDE_MOBILE` true and false) with the seven
  present; `shipped-ai.sh --self-test` (update-does-not-overwrite); row-per-map and
  counts-match-source; every repaired instruction site re-read". The render-path wording is
  path-neutral, settled 27/09/2026, grilling round 3 Q23, so only test code changes when
  MAP-NATIVE-MOBILE-SURFACE S-01 deletes the key. It replaces this gap's earlier "both
  `INCLUDE_MOBILE` answer sets". Written back 27/09/2026: the QA flag is now at project-management/src/02-STORIES/US010.md:226, the
  integration criterion naming the completeness step at :869-872, the generated-project
  scenario's completeness clause at :640, and the Seed Task adding the seven landed paths at
  :1031-1032.
- **AC-GAP-12** `[RESOLVED] 27/09/2026` · material — **two security rationales are wrong, and three security
  criteria are missing.** ST01 says an ungated `mv` "overwrites a project's filled index with a blank
  stub on every `copier update`" (US010.md:403-405, as read 21/09/2026); read in Copier's source, the overwrite is
  followed by a replay of the project's own diff, so the outcome is invisible, a silent alteration
  or conflict markers, depending on the seed (threat model Section 3b). **One completion, not a
  re-opening.** The settled round 1 call has an ungated line running in two renders, update's
  real-destination render and the old-copy render, and so does the threat model's Section 3b.
  Copier 9.18.2's own source runs three: the old-copy worker, the current worker and the new-copy
  worker each call their copy (its main module, lines 1423, 1472 and 1496). Its operation decorator
  keeps the outer value (lines 105-121), so all three render as update, and TM-01 already names
  three. ST01's held text says "all three update renders", which completes the settled wording and
  changes neither the call nor the criterion. ST02 says a line after
  `rmdir .copier` "silently no-ops" (:406-408); measured, `rmdir` on a non-empty directory exits 1,
  the chain aborts and generation fails loudly (Section 7). ST05's allowlist (:416-418) omits the
  three CI paths the settlement added. And gate 10 produced ST06 (no negation, by glob semantics),
  ST07 (the update probe's shape) and ST08 (the one-line form), which the story does not carry.
  Settled 21/09/2026 (the round 1 calls): ST02's rationale and ST01's consequence are corrected, not
  rewritten; ST05 widens by `.github/scripts/shipped-registers.sh`, `.github/scripts/shipped-ai.py`
  and `.github/workflows/audit-template.yml`. **Resolution:** ST01 to ST05 take assessment
  Sections 7.1 to 7.5's wording and ST06 to ST08 are appended as Sections 7.6 to 7.8, no number
  reused or renumbered; the Verification Check at :557-558 reads "(ST01, ST02, ST08)" and a new
  one reads "(ST06, ST07)"; the
  Security flag widens as gate 10 returned it. **This is gate 10's edit** — if that gate returned the
  same text, it is applied once. SPRINT-06's mirrors (SPRINT-06.md:423-439, :509-512, as read
  21/09/2026) follow. Written back 27/09/2026: ST01 to ST08 are now at project-management/src/02-STORIES/US010.md:768-856, the
  Security flag at :225, and the Verification Checks at :1246-1251 and :1259-1260.
- **AC-GAP-13** `[RESOLVED] 27/09/2026` · material — **the Dependencies bullet on S-03 describes a sequence that
  was settled the other way.** US010.md:261-263 (as read 21/09/2026) says S-03 "ships after this story, not before", and
  the FLAGS comment's "ONE THING THIS GATE DID NOT SETTLE" (:114-119) leaves open whether to pull
  the gate forward. Settled 21/09/2026, grilling round 1 Q1: S-03 is **not** pulled ahead of US011.
  Run before US011, N-003's presence clause is red on the four debt-carrying indexes, having no
  debt-line clause, and its lefthook entry would block every commit. Grilling round 2 Q13 had S-03
  cut at `02-story-creation` into a new SPRINT-08 straight after these gates were committed. **Since
  27/09/2026 SPRINT-08 is RULE-OWNERSHIP's (US013, US014), and S-03 has no sprint: it is
  unscheduled, at map-order row 10 (CUT-PLAN.md P8).** MAP-REGISTER-INDEXES.md:420-421's permission
  that S-03 "may run once `S-02` has landed" contradicts N-003's presence clause. **Resolution:**
  the bullet reads "S-03 ships after US011, not after this story alone …
  MAP-REGISTER-INDEXES.md:420-421 contradicts N-003's presence clause; recorded here, and the map
  text is left for S-03's own cutting gate". Its 21/09/2026 clause "cut into SPRINT-08 straight
  after gates 10, 11 and 15 are committed" is dropped, because S-03 has no sprint (CUT-PLAN.md P8).
  The FLAGS paragraph gains a dated "SETTLED 21/09/2026" note. **Settled 27/09/2026, grilling round
  3 Q21, on P8's footing:** TM-10 stays LOW. The window in which the four backfilled indexes read
  complete with no gate runs from US011 shipping until S-03 is cut, and S-03 is unscheduled
  (CUT-PLAN.md P8, map-order row 10). The window is tracked in `GAPS.md`, routed through gate 22
  (`project-management/workflows/22-implementation-documentation`), and assessment Section 7.11 is
  rewritten to match. The window's `GAPS.md` entry is written at US011's gate-22 pass, the window
  opening when US011 ships (call recorded 27/09/2026 with round 6). Written back 27/09/2026: the
  Dependencies bullet is now at project-management/src/02-STORIES/US010.md:395-412, the entry's writer at :405-408, and the FLAGS
  comment's settled note at :139-149. US011 carries the entry as a task and a Definition-of-Done
  line of its own (project-management/src/02-STORIES/US011.md:470-477 and :534-538), re-measured 30/09/2026 against
  the story as corrected that day. Threat model TM-10; assessment Section 7.11.
- **AC-GAP-14** `[RESOLVED] 27/09/2026` · material — **the Decisions section reads "None" beside two candidates the
  settlement has disposed of, one on a ground that does not hold.** US010.md:271-285, as read 21/09/2026. Settled
  21/09/2026: candidate B earns **one** ADR (grilling round 2 Q11); the read rule earns its own
  (grilling round 1 Q5), two records so each can be superseded alone; candidate A, the debt line,
  earns **none** (grilling round 2 Q10), because no gate ever reads the line, US011 removes it by an
  edit, and it is reversible — the US007 "no record, and why" precedent. The stated ground, "the
  alternative — building the mechanism twice — was rejected" (:281-282), is **false**: the in-tree
  files and the `.copier/` seeds are separate files, so withholding the four in-tree files was
  viable. The comment's "the four stale figures" (:272-273) contradicts the Provenance's SIX (:56),
  KNOWN DEFECT 5. **Resolution:** the section names both ADRs as Proposed until the developer
  signs them off, records "no record, and why" for the debt line with the corrected ground, and
  names the unscheduled sign-off of
  `project-management/src/15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` as the
  read-rule ADR's Follow-on, not edited here; the comment reads "six stale figures". Written back
  27/09/2026: the Decisions section is now at project-management/src/02-STORIES/US010.md:462-517 — the comment recording the
  Provenance's six at :464-467, the two records at :485-505, the ADR-US004 Follow-on at :503-505,
  and the debt line's "no record, and why", with its corrected ground, at :506-517. Both ADRs are
  accepted in the 27/09/2026 write-back pass only after an independent review, and before the
  US010 commit (settled 27/09/2026, grilling round 4 Q27). Each ADR's own Status line reads
  Proposed until that review is done and is the record of the acceptance, as the story's
  Decisions comment says (:475-480).
- **AC-GAP-15** `[RESOLVED] 27/09/2026` · material — **the citation criteria are flat, and the gate they name cannot
  see the links this story writes.** "`doc-references.sh` passes" at US010.md:433-434 (as read 21/09/2026), the QA task
  at :533 and the Verification Check at :552-553. Measured 21/09/2026 on the tracked working copy:
  **32 findings, exit 1, every one `[instance citation]`** (Section 7); the handoff's 47 was taken
  while the file was untracked. The developer settled on 20/09/2026 to **wait for US004** rather
  than add interim markers (SPRINT-06.md:361-362, working tree, as read 21/09/2026), so
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` governs
  until US004 lands. Separately, "every citation this story writes … resolves" is assigned to a
  script that reads backticked tokens only, and MAP-INDEX.md's Instance cells are Markdown links,
  so none is read (`project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`).
  **Resolution:** all three read as a baseline diff — captured immediately before the first edit,
  with `git hash-object code/src/scripts/audits/doc-references.sh` beside it, compared by the
  `(file, kind, token)` identity of `project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`
  AC-GAP-2, and a new finding in a file this story edits is this story's; a link check joins QA
  Automated — every Markdown link target in the seven in-tree indexes and in the generated tree's
  seven tested for existence from the file's own folder (Section 6). Written back 27/09/2026: the
  baseline-diff criterion is now at project-management/src/02-STORIES/US010.md:886-892, the link check at :881-883, the QA task at
  :1221-1222 and the Verification Check at :1252-1254.
- **AC-GAP-16** `[RESOLVED] 27/09/2026` · material — **the Umbrella ADRs sweep S-02 absorbed has a misplaced
  criterion and no task.** US010.md:321 (as read 21/09/2026) puts "no row asserts the retired no-ADR house rule in an
  Umbrella ADRs cell" in the MAP-INDEX scenario, but MAP-INDEX.md has no such cell; the rows are
  each map's own `Umbrella ADRs` header row, which S-02 took on at
  MAP-REGISTER-INDEXES.md:365-392 (eight rows at 31/08/2026) and whose Acceptance and QA cells
  still name (:350). No Map Task, manual check or QA task performs the sweep, and four maps have
  been charted since that measurement. **Resolution:** the line moves to its own scenario ("Given
  each live map's Umbrella ADRs header row, re-measured at implementation time … Then none asserts
  that this repository writes no ADRs or that none may be authored from a map"); a Map Task sweeps
  them against `project-management/src/15-DECISIONS/CLAUDE.md`'s wording, re-measured rather than
  inherited; the manual walk-through records each row read. Written back 27/09/2026: the scenario
  is now at project-management/src/02-STORIES/US010.md:734-738, the Map Task at :1174-1177, the manual check at :924-925 and the
  recorded sweep at :1233.
- **AC-GAP-17** `[RESOLVED] 27/09/2026` · material — **the "verify, do not re-cut" task checks two Acceptance cells
  that the settlement has made stale.** US010.md:523-527 (as read 21/09/2026) confirms the S-01, S-02 and S-05 rows "still
  read as `02-story-creation` left them". S-01's cell gives MAP-INDEX.md's seed "one `TBD` row"
  (MAP-REGISTER-INDEXES.md:349), S-02's says "four-value enum" (:350), and S-05's still reads "42 at
  cutting" (:353). The enum ADR's Follow-on routes the first two to a wayfinder RESOLVE sitting, the
  owner the map names for its Acceptance cells (:356-357); the US011 plan routes the third to
  `01-feature-map`. **Resolution:** the task reads "Confirm … and record S-01's `TBD` seed-row
  wording, S-02's four-value wording and S-05's 42 as known-stale against the settlements of
  21/09/2026 and routed to the map's next RESOLVE sitting — neither corrected here nor read as a
  failed verification". Written back 27/09/2026, now at project-management/src/02-STORIES/US010.md:1178-1189, one step further than
  proposed: the map's RESOLVE sitting ran in the same pass (settled 27/09/2026, grilling round 5
  Q30) and corrected S-01's seed-row wording and S-02's value count, so the task verifies against
  that wording. S-05's 42 stays known-stale, routed to `01-feature-map`.
- **AC-GAP-18** `[RESOLVED] 27/09/2026` · minor — **four literals contradict the story's own no-literal rule, and
  the Provenance total is stale by one** (KNOWN DEFECT 1). The Acceptance Criteria lead says
  MAP-INDEX.md "lists all fourteen maps" (US010.md:292, as read 21/09/2026), and 15 are tracked. The debt scenario says
  the four registers "hold 9, 5, 20 and 8 instances" (:333), and the tracked tree reads 11 · 7 · 20 ·
  9 = 47. The Provenance's 56 (:27-29) was counted against 14 maps and is 57 on the corrected count;
  the tracked tree reads 62 today. The Client Summary is client prose and will be wrong when read,
  twice: "fourteen maps" (:157), and "the instruction that produced that mistake is repeated in four
  other files" (:157-158), which AC-GAP-1's inventory contradicts. The generated ClickUp export,
  `project-management/export/clickup/US010-CLIENT.md:12-13`, carries both. The "legitimately
  empty" scenario (:339) asserts zero findings and bugs as a Given, which holds today and is not
  re-counted. **Resolution:** the lead reads "every map in the folder, counted at implementation
  time"; :333 reads "their registers hold instances counted at implementation time"; the
  Provenance keeps 56 as the cut-time figure and gains a dated re-measure (57 on the corrected
  count; 62 on 21/09/2026, 15 · 11 · 7 · 20 · 9 · 0 · 0). The Client Summary drops both counts: "while
  every map in the folder sits beside it unlisted, and the instruction that produced that mistake is
  repeated across the shipped files". The export is regenerated from the edited source, never hand-edited
  (`project-management/export/clickup/README.md:9-11`), the route the US011 plan gives its own
  export. :339 reads "hold zero instances when this story is implemented, re-counted then — an
  instance found then gets its row here". Written back 27/09/2026: the lead is now at
  project-management/src/02-STORIES/US010.md:523-531, the Provenance's dated re-measure at :33-40, the Client Summary at :250-255,
  the debt scenario's count at :620 and the legitimately-empty Given at :627. The export follows
  its own regeneration route.
- **AC-GAP-19** `[RESOLVED] 27/09/2026` · minor — **three sentences were left garbled where the copier delimiters
  were scrubbed** (KNOWN DEFECT 2): "if a `mv` lands outside `when:` gate keyed on" (US010.md:104, as read 21/09/2026);
  "gated `when:` gate keyed on" (:401-402); "Confirm the `when:` gate keyed on
  `_copier_operation == 'copy'` gate covers all seven" (:495). SPRINT-06.md:423-424 (as read 21/09/2026) mirrors the
  second. **Resolution:** "outside the task whose `when:` key tests `_copier_operation == 'copy'`";
  "gated by a `when:` key testing `_copier_operation == 'copy'`"; "Confirm the `when:` key testing
  `_copier_operation == 'copy'` covers all seven". None reproduces the delimiters. Written back
  27/09/2026: the three sentences are now at project-management/src/02-STORIES/US010.md:119-120, :768-769 and :1016-1017.
- **AC-GAP-20** `[RESOLVED] 27/09/2026` · minor — **"the six shipped files" are six sites across three files**
  (KNOWN DEFECT 4), and the count is wrong once AC-GAP-1 lands. US010.md:294 (as read 21/09/2026); SPRINT-06.md:10 and
  :410 (as read 21/09/2026) say "six shipped sites"; the manual check (:450-451), the QA task (:539), SPRINT-06.md:501
  and :531 carry the "four instruction sites and two template sites" split; and the Story Points
  comment lists "six instruction sites" in the surface it sizes (US010.md:200). **Resolution:** each
  reads "every shipped site that instructs the old index row, or says a register has no index", the
  inventory being the site scenario's own list. The Story Points comment reads "every shipped
  instruction site". Neither recorded trigger for re-sizing counts sites: the `15-decisions`
  trigger counts `copier.yml` decisions, and round 2 Q12's counts families. The developer held
  US010 at 8 SP with the added sites counted (settled 27/09/2026, grilling round 4 Q26, now at
  project-management/src/02-STORIES/US010.md:315-323). Written back 27/09/2026: the lead is now at project-management/src/02-STORIES/US010.md:527-528, the Story
  Points comment at :297-298, the manual check at :914-916 and the QA task at :1228-1229.
- **AC-GAP-21** `[RESOLVED] 27/09/2026` · minor — **the MoSCoW comment counts five maps, then six** (KNOWN
  DEFECT 6). "FIVE maps have parked their unticked `Gate to stories` index-row box" (US010.md:175, as read 21/09/2026)
  and "This blocks more: six maps" (:184). Measured 21/09/2026: **six** maps carry an unticked
  index-row box — GATE-PARITY :676, NATIVE-MOBILE-SURFACE :246, NAVIGATION :790, REGISTER-INDEXES
  :630, RULE-OWNERSHIP :1501 and SCRIPT-GUARDS :163 — and NATIVE-MOBILE-SURFACE's is "withheld
  pending a decision" rather than parked on this slice. **Resolution:** the comment reads "Six maps
  carry an unticked index-row box, measured 21/09/2026 — five parked on this slice and
  MAP-NATIVE-MOBILE-SURFACE.md withheld pending a decision of its own", and :184 reads "six maps".
  Written back 27/09/2026, now at project-management/src/02-STORIES/US010.md:271-282.
- **AC-GAP-22** `[RESOLVED] 27/09/2026` · minor — **the shape of each file, and four small wording obligations, are
  unstated.** First, which files carry the empty-register placeholder row: the six seeds do (settled
  21/09/2026, grilling round 1 Q2); FINDING-INDEX.md and BUG-INDEX.md in-tree do (US010.md:341, as read 21/09/2026); the four
  debt-carrying in-tree indexes must **not**, or they read as empty registers (:336, ES-17 — the US011
  plan's EC-14 raised the same question from the other side); no seed carries the debt line.
  Second, the comment above `SEEDED` says it is "Seeded into 01-FEATURE-MAPS by a _task"
  (`.github/scripts/shipped-artefacts.sh:103-104`), false for seven of eight entries, and assessment
  Section 7.12 requires every citation of `SEEDED` to call it an allowlist. Third,
  `.github/scripts/shipped-registers.sh`'s header, usage text and closing message describe two
  registers (`:3`, `:19`, `:103-104`, `:327-329`). Fourth, `project-management/src/21-BUGS/CONTEXT.md`'s
  new section must cite its index by full path: the bare filename BUG-INDEX.md backticked in a link label,
  the incident precedent's form (`project-management/src/23-INCIDENTS/CONTEXT.md:60`), is a
  doc-references instance-citation finding with no escape (ES-15). **Resolution:** the debt and
  empty-register scenarios and the seed task state the placeholder per file; Seed Tasks rewrite the
  `SEEDED` comment and the family's header, usage and closing text in the same change; the CONTEXT
  scenario gains the full-path rule for `21-BUGS`. Written back 27/09/2026: the placeholder per
  file is stated at project-management/src/02-STORIES/US010.md:619, :629, :636 and :1003-1005; the `SEEDED` comment at :658 and
  :1018-1025, worded for either landing order against US012; the family's header, usage and closing
  text at :668 and :1202-1203; and the full-path rule for `21-BUGS` at :684 and :1041-1042.
- **AC-GAP-23** `[RESOLVED] 27/09/2026` · minor — **gate 10 raised three questions it did not
  settle, and the story records none of them; its no-blocker check predates the widened write set.**
  TM-13 (seven shipped guide sites count the seed task's files as nine, outside ST05), TM-14 (a
  project generated before US010 receives the routes to the seven indexes but never the files) and
  TM-18 (`copier recopy`, or `copier copy` into an existing project, runs as `copy` and moves every
  blank seed over the project's own file) are assessment Sections 7.13 to 7.15, each "a choice for
  the developer, not this gate". Separately, the no-blocker bullet (US010.md:240-244, as read 21/09/2026) was verified
  on 20/09/2026 against a write set that did not yet include `.github/scripts/shipped-registers.sh`,
  `.github/scripts/shipped-ai.py` or `.github/workflows/audit-template.yml`. Re-measured 21/09/2026:
  US009, still `Open` (US009.md:4), planned in SPRINT-05 with its carry reserved into SPRINT-06
  (project-management/src/03-SPRINTS/SPRINT-06.md:30-34, as read 21/09/2026), adds a grep to the same `[3/4]` job (project-management/src/02-STORIES/US009.md:326-335,
  as read 21/09/2026; :354-363 since the 16-sprint-plans gate's corrections of 30/09/2026 above
  it, `ST08` among them, re-measured that day), and US012 names both
  the completeness step and `shipped-ai.py` (US012.md:30-31) — rebases, not blockers.
  **Resolution:** a Dependencies bullet names the three questions, their assessment numbers and
  their settlements; the no-blocker bullet is re-dated and names US009's and US012's overlaps as
  rebases. **Settled 27/09/2026, grilling round 3 Q14 and Q15.** TM-13: ST05 widens by
  `how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md`, and US010 corrects all seven
  count sites there, the `--trust` disclosure at `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22`
  among them (Q14). That Q14 covers all seven, and not the `--trust` disclosure alone, is settled
  by the call recorded 27/09/2026 with round 6. Q14 also sets US015's overlap as a rebase: US010 lands first, and US015 rebases
  (AC-GAP-1). TM-14 and TM-18 are documented in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` as part
  of US010 (Q15). **The wording of that statement is not settled here.** The complete fixes are a
  seed-if-absent update migration for TM-14 and a guard refusing an existing target for TM-18. Both
  are routed to `GAPS.md` through gate 22
  (`project-management/workflows/22-implementation-documentation`, sole owner of `GAPS.md` writes)
  and are not built by US010. Written back 27/09/2026: the Dependencies bullet naming the three
  questions is now at project-management/src/02-STORIES/US010.md:413-425, the re-dated no-blocker bullet at :357-371, the `GAPS.md`
  routing at :426-442, the template-guide scenario at :706-712, the updating-guide scenario at
  :714-719, and their Documentation Tasks at :1085-1102.

<!-- AMENDED 30/09/2026 at the sign-off: every "Written back" and "now at" citation in the list
     above, and the header comment's three, is re-measured against the stories as the
     16-sprint-plans gate corrected them on 28/09/2026 and 30/09/2026. The numbers they replace
     located the same text in US010.md and US011.md at 0c5e635 and b1ca05a, and each is recovered
     by the offset of its block. US010.md: :1-126 unmoved; :127 became :127-130; :128-422 +3; :423
     and :425-432 were rewritten as :426 and :428-442, the routing bullet gaining its fourth item;
     :424 +3; :433-437 +10; fourteen lines inserted after :437; :438-538 +24; :539 became :563-569;
     :540-664 +30; :665 rewritten at :695; :666-1048 +30; :1049-1051 rewritten at :1079-1081;
     :1052-1073 +30; forty-five lines inserted after :1073; :1074-1204 +75. US011.md: :1-238
     unmoved; :239-241 became :239-258; :242 onward +17. So AC-GAP-9's ST03 read :757-773 and is
     now :787-803, AC-GAP-13's US011 task and Definition-of-Done line read :453-460 and :517-521
     and are now :470-477 and :534-538, and AC-GAP-23's routing bullet read :423-432 and is now
     :426-442. Each moved line was checked against its text, never taken on the offset alone.

     AC-GAP-1's inventory is a sweep of 21/09/2026 and keeps that reading. Two changes have since
     moved eight of its sites, the text unchanged each time. Commit ceb2d70 (28/09/2026) moved
     four: project-management/workflows/17-story-plans/CLAUDE.md :87-91 to :89-93, STEPS.md
     :101-102 and :192-195 to :105-106 and :196-199, and CHECKLIST.md :114-115 to :116-117. The
     18-TESTS split, committed together with this correction (settled 30/09/2026, 16-sprint-plans
     grilling round 4 Q13 and Q14), moves those four again and four more. Re-measured 30/09/2026
     against the tree committed together with it, the sites sit at
     project-management/workflows/17-story-plans/CLAUDE.md:97-101;
     project-management/workflows/17-story-plans/STEPS.md:106-107 and :240-243;
     project-management/workflows/17-story-plans/CHECKLIST.md:132-133;
     project-management/workflows/17-story-plans/CONTEXT.md:63-64, :95-96 and :104-106, read as
     :57-58, :87-88 and :96-98 until then; and
     project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:626, read as :625, the
     same template's dated comment, cited above as :792-807, sitting at :793-808. STEPS.md :43, the
     template's :16, the two 01-feature-map sites and every other site in the inventory did not
     move. The story's own site scenario and site task carry the same numbers
     (project-management/src/02-STORIES/US010.md:695 and :1079-1082), re-measured 30/09/2026 as
     read here.
     Two other tree citations in Section 1 move with the split, the text unchanged, re-measured
     30/09/2026 against the tree committed together with it: the lead cited the one-way door as
     `copier.yml:967-972`, now :988-993, and AC-GAP-22 cited the incident precedent as
     project-management/src/23-INCIDENTS/CONTEXT.md:59, now :60, both measured against the tree at
     a18db0b until then. -->

<!-- WHAT THIS PASS DID NOT FIND, recorded because the absence is informative. Every copier.yml,
     shipped-artefacts.sh, shipped-registers.sh, shipped-ai.py and audit-template.yml citation the
     gate-10 artefacts make was re-opened today and holds. The seed chain is where the story says
     (copier.yml:973-984, gate at :984), no _exclude negation today matches an index path, no index
     file or seed exists yet, and the seeded map's header is outside the four-value enum exactly as
     the settlement recorded (.copier/MAP-SCALE-PLANNING.md:4). The story's premise is right: the
     shipped map index reads "None charted yet" against fifteen maps. -->

## 2. Test scenarios

Derived from the story's Gherkin, the settled decisions, the gate-10 artefacts and the shell and CI
surface, not from a wireframe — this story has none. "The read rule" is the one settled 21/09/2026,
grilling round 1 Q5. "The family" is the third `shipped-registers.sh` family, grilling round 1 Q2.
**Generated-tree scenarios run in CI's `[3/4]` job**; no project script makes a generated tree
locally, and none may be improvised (Section 6). **"Every generated tree" means one tree per render
path the template offers (today: `INCLUDE_MOBILE` true and false).** That path-neutral wording was
settled 27/09/2026, grilling round 3 Q23, so only test code changes when MAP-NATIVE-MOBILE-SURFACE
S-01 deletes the key.

### Happy path (HP-nn)

| ID    | Given                                                                     | When                                                                                                                                          | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ----- | ------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The change committed and pushed                                           | `[3/4]` generates on every render path the template offers (today: `INCLUDE_MOBILE` true and false), settled 27/09/2026, grilling round 3 Q23 | All seven index files sit at `project-management/src/<REGISTER>/<NOUN>-INDEX.md` in every generated tree, and `.copier/` is gone (`audit-template.yml:311-314`). The completeness step names the seven (AC-GAP-11)                                                                                                                                                                                                                                                                                                                                                                       |
| HP-02 | Any generated tree                                                        | The six non-map seeds are read                                                                                                                | Each carries the spine, its tail, its ordering sentence, the read rule, the `## The register` marker and the placeholder row alone — no instance row and no debt line (ST03, ST04)                                                                                                                                                                                                                                                                                                                                                                                                       |
| HP-03 | Any generated tree                                                        | The map index's one row is read                                                                                                               | Status `Not started`, string-equal under the read rule to the seeded map's :4; Instance a working link to MAP-SCALE-PLANNING.md; Summary generic or `TBD`; Updated `TBD` (AC-GAP-2). **Host:** the Status agreement is automated at template time by the family's seed-row clause and its probe (settled 27/09/2026, grilling round 7 Q34; project-management/src/02-STORIES/US010.md:638, :666-667), never a manual read; the rest by the link check and the literal grep. AMENDED 27/09/2026 at the final pass: the clause was a proposal here, with a manual read if it were declined |
| HP-04 | The diff to `copier.yml`                                                  | The one seed task is read                                                                                                                     | Seven new lines of the form `mv .copier/<NOUN>-INDEX.md project-management/src/<REGISTER>/<NOUN>-INDEX.md &&`, inside the task at `:994-1005`, ahead of `rmdir .copier`; the task's `when:` key unchanged; no second task (ST01, ST02, ST08)                                                                                                                                                                                                                                                                                                                                             |
| HP-05 | The template repository                                                   | `bash .github/scripts/shipped-registers.sh`, then `--self-test`                                                                               | Exit 0 with no finding; the self-test's nine existing probes pass with unchanged labels and expectations, plus one probe per new check, each seen red before green — the seed-row clause's among them, a mutated seed pair yielding exactly one finding (grilling round 7 Q34) (ST03, ST05, ST06)                                                                                                                                                                                                                                                                                        |
| HP-06 | The fixture creating the six register folders in `fixture()`              | `bash .github/scripts/shipped-ai.sh --self-test` copies on both sets                                                                          | All seven indexes land in each project, and memory is seeded empty, as today (ST07, AC-GAP-10)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| HP-07 | Each project edits every index and commits; the second tag changes seeds  | `run_update` to the second tag                                                                                                                | Every index is byte-identical to the project's committed edit; project memory survives; `.copier/` is gone (ST07, TM-01, TM-04)                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| HP-08 | The self-test mutation that removes the seed task's `when:` key           | The same copy, edit and update                                                                                                                | The probe fails on the byte-identity assertion's own message, and the self-test reports the detector rejecting the mutation (ST07)                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| HP-09 | Every generated tree                                                      | `shipped-artefacts.sh --self-test` on one, the full run on each                                                                               | Exit 0; `SEEDED` holds eight entries and none is reported as leaked; the self-test's existing probes pass unchanged (TM-09)                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| HP-10 | The maps folder at the landing commit                                     | The instance test runs, excluding two files by exact filename                                                                                 | MAP-INDEX.md has exactly one row per instance, no row for itself, a row for MAP-REGISTER-INDEXES.md; the count and HEAD are recorded beside the cut-time 14 (AC-GAP-8)                                                                                                                                                                                                                                                                                                                                                                                                                   |
| HP-11 | Every map after the change                                                | Its `**Status**` header is read                                                                                                               | `<enum>` or `<enum> · <prose>` on the key's line, the value plain and one of five, and the one the map's own counts give under the criteria settled 27/09/2026, grilling round 3 Q18 and round 6 Q31 — a charted map with nothing resolved and `Blocking open` 0 reads `Blockers clear — stories may start`, never `Charting`; its MAP-INDEX row string-equals the read rule's output (AC-GAP-5)                                                                                                                                                                                         |
| HP-12 | Every MAP-INDEX row                                                       | `Updated` is compared with its map's last commit date                                                                                         | Equal on every row, re-run after the landing commit exists (AC-GAP-6, EC-03)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| HP-13 | Every MAP-INDEX row                                                       | Its tail counts and Summary are read against the map                                                                                          | Each header-derived count equals its header field; a slice count equals the rows of that map's Slices table; a second reader finds the Summary intelligible (AC-GAP-7)                                                                                                                                                                                                                                                                                                                                                                                                                   |
| HP-14 | All seven index files                                                     | Their ordering sentences are read, and MAP-INDEX's rows top to bottom                                                                         | Each states the settled order with its date column and tie-break; MAP-INDEX's rows follow its sentence (AC-GAP-3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| HP-15 | Each register's carrier                                                   | The read rule is applied to the value after the key                                                                                           | A story reads `Open`; plan 06 reads `Blocked`; ADR-US004-CITED-PLAN-PREFIX's :11 reads `Proposed`; a companion-format map reads its enum; the finding and bug templates read their legends, unvalidated (AC-GAP-4)                                                                                                                                                                                                                                                                                                                                                                       |
| HP-16 | The in-tree tree and every generated tree                                 | Every line holding "Backfill owed" is listed by file                                                                                          | Exactly STORY-, SPRINT-, DECISION- and STORY-PLAN-INDEX.md in-tree; none in FINDING- or BUG-INDEX.md; none in any seed or generated index (TM-10)                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| HP-17 | The seven register `CONTEXT.md` files                                     | Each is read                                                                                                                                  | A `## The index` section links its index; the `01-FEATURE-MAPS` table and its :53-56 prose are gone; `project-management/src/17-STORY-PLANS/CONTEXT.md:86-96` describes presence; `23-INCIDENTS/CONTEXT.md` is byte-identical                                                                                                                                                                                                                                                                                                                                                            |
| HP-18 | Every site in the site scenario                                           | Each is read, then the joined-line search runs over a generated tree                                                                          | Each names its seeded index; the search returns nothing (AC-GAP-1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| HP-19 | Every map's Gate-to-stories index-row box                                 | Read after the change                                                                                                                         | Ticked where the row exists, its text naming MAP-INDEX.md; any unticked box names a reason still true; none cites N-001                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| HP-20 | Every map's `Umbrella ADRs` header row, re-measured                       | Read after the change                                                                                                                         | None asserts the retired no-ADR rule (AC-GAP-16)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| HP-21 | `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md` in a project | Its :4 is read                                                                                                                                | Five values, each value's count-derived criterion in its final form (settled 27/09/2026, grilling round 3 Q18, the overlap resolved the same day by round 6 Q31, Blockers clear winning), so that no map meets two, and a one-line format statement; the file ships through the `*TEMPLATE*` re-include at `copier.yml:164` (AC-GAP-5)                                                                                                                                                                                                                                                   |

<!-- AMENDED 30/09/2026 at the sign-off: HP-03 cited US010.md:608 and :636-637 until then, the lines
     re-measured 27/09/2026 against the story at 0c5e635. The 16-sprint-plans gate's corrections of
     28/09/2026 and 30/09/2026 moved them to :638 and :666-667, the text unchanged. HP-04 cited
     the seed task as `:973-984`, and HP-17 the plans-index section as "`17-STORY-PLANS`'s :81-91",
     until then, both measured against the tree at a18db0b. The 18-TESTS split, committed together
     with this correction, moves them to copier.yml:994-1005 and
     project-management/src/17-STORY-PLANS/CONTEXT.md:86-96, the text unchanged, re-measured
     30/09/2026 against the tree committed together with it. -->

### Error states (ES-nn)

| ID    | Given                                                                                                 | When                                           | Then                                                                                                                                                                                                               |
| ----- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ES-01 | One index `mv` placed after `rmdir .copier`                                                           | Generation runs                                | **Loud failure**: `rmdir` exits 1 on the unmoved seed, the chain aborts, Copier raises `TaskError` and deletes a fresh destination; `[3/4]` is red. Never a silent skip (ST02 corrected, TM-07)                    |
| ES-02 | One index `mv` moved into a new task with no `when:` key                                              | The family runs; `shipped-ai.sh` runs          | The family reports exactly one finding naming that seed as outside the copy-gated task. `shipped-ai.py` drops the new task from its fixture (`:320-328`), so HP-06's presence assertion fails (ST01, TM-01, TM-04) |
| ES-03 | `copier.yml` gains a literal negation re-including one index path                                     | The family runs                                | Exactly one finding. `shipped-artefacts.sh` on a generated tree stays silent, because `SEEDED` admits the path by name (`:197`) — the masking TM-02 names, and the reason ST06 exists                              |
| ES-04 | A glob-form negation ending `**/*-INDEX.md`                                                           | The family runs                                | Exactly one finding for the negation line, not one per matched path — the probe rule is one finding per mutation (ST06)                                                                                            |
| ES-05 | A seed gains a row linking a real map, story or ADR                                                   | The family runs                                | Exactly one finding naming the seed and the row (ST03, TM-03)                                                                                                                                                      |
| ES-06 | A seed loses its `## The register` line                                                               | The family runs                                | Exactly one finding (ST03)                                                                                                                                                                                         |
| ES-07 | A seed file deleted, its `mv` line kept                                                               | The family runs; generation runs               | One "missing seed" finding; generation also fails loudly at the `mv` (TM-06)                                                                                                                                       |
| ES-08 | A seed **and** its `mv` line removed together                                                         | The family runs                                | Still one finding, because the family's list of seven is its own constant. Derived from `copier.yml` it would be silent — the case US012's plan calls the one no job reports (AC-GAP-9)                            |
| ES-09 | The fixture as it stands (one destination folder)                                                     | `shipped-ai.sh --self-test`                    | `TaskError` at the first `mv` into `02-STORIES/`; `[3/4]` red. The repair is the fixture, never a `mkdir -p` in `copier.yml` (TM-05; settled 21/09/2026, grilling round 1 Q3)                                      |
| ES-10 | An index `mv` written with a flag, a quoted path, or split across the folded scalar                   | The family and `doc-references.sh:373` read it | The family reports the line absent and the citation audit loses the seed: a false red whose repair is the one-line form, never a looser parser (ST08, TM-06)                                                       |
| ES-11 | An index `mv` given an `\|\| true` suffix                                                             | Review of the diff                             | No parser breaks, so no script fails; the line swallows a missing seed. Caught by review against ST08 only — recorded so nobody expects a script to catch it                                                       |
| ES-12 | A map header written `**Charting**` in bold, or `Charting complete`                                   | The read rule, then the manual enum check      | The rule returns `Charting` and `Charting complete` respectively without complaint — it reads, it does not validate. The manual check fails both, the second as outside the enum (TM-12)                           |
| ES-13 | A MAP-INDEX Status translated — `Done` for `Complete`                                                 | The row is compared with its map               | Inequality under the read rule; the walk-through fails the row                                                                                                                                                     |
| ES-14 | A MAP-INDEX row for a map absent from the folder                                                      | The walk-through runs                          | Fails "no row names a map that is absent"                                                                                                                                                                          |
| ES-15 | `project-management/src/21-BUGS/CONTEXT.md` cites its index as a backticked bare name in a link label | `doc-references.sh --path` over that file      | An `[instance citation]` finding with no escape — the regex matches the name and the fallback only searches `01-FEATURE-MAPS/` (`doc-references.sh:771-773`). The full-path form is clean (AC-GAP-22)              |
| ES-16 | A seed carrying a malformed template delimiter; an in-tree index carrying a copied header token       | Generation; the in-tree file read              | The seed fails generation and `[1/4]`. The in-tree token passes the token gate if registered and displays raw, never rendered (`copier.yml:157`) (TM-16)                                                           |
| ES-17 | A debt-carrying in-tree index given the placeholder row                                               | A reader who has not read the story opens it   | It reads as an empty register; the legibility check fails it (AC-GAP-22)                                                                                                                                           |
| ES-18 | A seed's link written relative to `.copier/`, or a link to a sibling that exists only in syntek-base  | The link check runs over a generated tree      | The link does not resolve from the landed path; the check fails it                                                                                                                                                 |
| ES-19 | The citation criterion read as a bare pass                                                            | The whole-tree `doc-references.sh` run         | It never passes before US004 — inherited red. Reported as a diff against the pre-edit baseline, never as a pass or a fail of this story (AC-GAP-15)                                                                |
| ES-20 | The self-test's ungated mutation fails for another reason — a `TaskError`, or the memory assertion    | `shipped-ai.sh --self-test`                    | The proof fails: the expected-message check (`shipped-ai.py:244`) rejects a wrong-reason red, and a `TaskError` is not an `AssertionError` (`:243`) and escapes as a crash                                         |

### Edge cases (EC-nn)

| ID    | Given                                                                                                           | When                                          | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | MAP-INDEX.md landed beside the maps; MAP-REGISTER-INDEXES.md is a real map                                      | The instance test runs                        | MAP-INDEX.md is excluded by exact filename and MAP-REGISTER-INDEXES.md is kept; a `*INDEX*` suffix or glob exclusion would drop a real map (AC-GAP-8)                                                                                                                                                                                                                                                                                                                                                      |
| EC-02 | The map count moves between measurement and landing — it moved 14 to 15 on the day of cutting                   | The landing commit is prepared                | The folder is re-counted at that commit; nothing in any criterion holds a literal                                                                                                                                                                                                                                                                                                                                                                                                                          |
| EC-03 | This story edits nearly every map in its landing commit                                                         | `Updated` is written                          | Each edited map's row takes the landing commit's date: written with the intended date, re-checked after the commit exists. The author date survives a later rebase                                                                                                                                                                                                                                                                                                                                         |
| EC-04 | MAP-PROGRESSIVE-ENHANCEMENT.md reads `Charting` over a frontier closed on 31/08/2026                            | Its value is derived                          | It changes although its format already parses, to `Blockers clear — stories may start` under the final criteria (grilling round 3 Q18 and round 6 Q31, both 27/09/2026): `Blocking open` 0, and not `Complete` while its Fog of war holds an item; at least thirteen headers change, twelve being the format count (the enum ADR's Context, :44-59)                                                                                                                                                        |
| EC-05 | MAP-CAP-POSTURE.md:6, MAP-SUBDOMAIN-ROUTING.md:4 and MAP-REGISTER-INDEXES.md:8 carry middle dots in their prose | They are rewritten, then read                 | The first middle dot, the one after the enum, ends the value; later ones are prose                                                                                                                                                                                                                                                                                                                                                                                                                         |
| EC-06 | MAP-REGISTER-INDEXES.md:6-8 and MAP-ABSENCE.md:4-5 wrap their status                                            | Rewritten                                     | The value sits on the key's own line; the rule is line-scoped                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| EC-07 | The key sits at :4, :5, :6, :15 or :19, and maps also carry table rows keyed `**Status**`                       | The carrier line is found                     | The first line **beginning** with `**Status**:` — never a fixed line number, never a table row                                                                                                                                                                                                                                                                                                                                                                                                             |
| EC-08 | A finding's metadata line, `**Status**:` its last middle-dot-separated field                                    | The read rule runs                            | It runs on the value after the key. Cutting the whole line at its first middle dot yields the Last Updated field and loses the Status                                                                                                                                                                                                                                                                                                                                                                      |
| EC-09 | A bug's bold-key Status row, still holding the template's legend                                                | The read rule runs                            | It returns `Open / Fixed / Verified` without complaint; the rule reads, it does not validate                                                                                                                                                                                                                                                                                                                                                                                                               |
| EC-10 | ADR Status and supersession fields carrying trailing HTML comments                                              | DECISION-INDEX's tail is designed             | The tail cells are read by the same strips as Status; the design says so, and US011 applies it                                                                                                                                                                                                                                                                                                                                                                                                             |
| EC-11 | Same-US###, same-Date ADR groups — seven today, eight with US010's pair                                         | DECISION-INDEX's ordering sentence is written | It states the tie-break, and a predecessor reads before its successor in both same-date chains (AC-GAP-3)                                                                                                                                                                                                                                                                                                                                                                                                  |
| EC-12 | A plan renumbered after STORY-PLAN-INDEX.md exists                                                              | Its row is read                               | "How to read a row" says the prefix is build order and a renumber renames the row                                                                                                                                                                                                                                                                                                                                                                                                                          |
| EC-13 | A story or sprint, whose filename has no descriptor                                                             | Its Instance label is chosen                  | The identifier; a descriptor where the filename has one (AC-GAP-7)                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| EC-14 | A seed whose prose names its own file, the seeded map, or a register's `000` template                           | The generated-tree literal grep runs          | No false positive: the grep excludes the file's own name, MAP-SCALE-PLANNING in the map index's one row, and the `000` template identifiers; anything else is a finding (ST04)                                                                                                                                                                                                                                                                                                                             |
| EC-15 | Seeds edited but not committed                                                                                  | Generation runs                               | It renders `--vcs-ref=HEAD` (`audit-template.yml:154`) and proves nothing about uncommitted bytes                                                                                                                                                                                                                                                                                                                                                                                                          |
| EC-16 | `20-FINDINGS` or `21-BUGS` gains an instance before this story lands                                            | The story runs                                | That index gets its row here, its register being this story's, and the "legitimately empty" Given is re-read rather than assumed (AC-GAP-18)                                                                                                                                                                                                                                                                                                                                                               |
| EC-17 | A negation written single-quoted, with a trailing comment, or wrapped in the template's block-tag conditional   | The family's negation check parses `_exclude` | Each form is still found. The existing parse strips double quotes only and misses an entry with a trailing comment (`.github/scripts/shipped-registers.sh:134-139`), and `copier.yml:194-216` already carries conditional entries                                                                                                                                                                                                                                                                          |
| EC-18 | US012 lands before or after this story                                                                          | `shipped-artefacts.sh` is rebased             | Either order goes green; if US012 is first, its last-entry probe moves onto an index seed the day this lands                                                                                                                                                                                                                                                                                                                                                                                               |
| EC-19 | US009 lands first, adding a grep inside the same `[3/4]` job                                                    | This story edits the completeness step        | A rebase, not a wait                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| EC-20 | The concurrent session's edits to US010.md, SPRINT-06.md and two maps are still uncommitted                     | STEP 5 applies this plan's feedback edits     | Each edit is re-anchored on its quoted text against the committed file, never applied by line number                                                                                                                                                                                                                                                                                                                                                                                                       |
| EC-21 | A project generated before US010 runs `copier update` across it                                                 | Its tree is read                              | No index arrives, but the re-included `CONTEXT.md` routes to all seven do. **Demonstrates TM-14** (assessment Section 7.14). Settled 27/09/2026, grilling round 3 Q15: US010 documents it in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`, and the seed-if-absent migration goes to `GAPS.md` through gate 22, so this stays a demonstration until that fix lands                                                                                                                                            |
| EC-22 | A map charted after this story lands                                                                            | The repointed instructions are followed       | Its row goes into MAP-INDEX.md in the same change as the map; nothing gates it until S-03. Wayfinder's chart step, writing the map's first node, fills `Charted` and moves it out of `Not started` to the value its counts give — `Charting` while `Blocking open` is above 0, otherwise `Blockers clear — stories may start` — and never asserts `Charting` (grilling round 3 Q24 and round 6 Q31, reconciled by the call recorded 27/09/2026; AMENDED 27/09/2026 at the final pass from "to `Charting`") |

<!-- AMENDED 30/09/2026: EC-17 cited `copier.yml:192-214` until then, measured against the tree at
     a18db0b. The 18-TESTS split, committed together with this correction, adds two lines above the
     conditional entries, which sit at :194-216 in that tree, re-measured 30/09/2026, the text
     unchanged. -->

### Permission and access (PA-nn)

**None in the web sense** — no endpoint, no screen, no protected action, no identifier whose ownership
could be verified; the `API`, `Backend`, `Frontend` and `GDPR` flags are correctly `N/A`. **The
access-control content is the seed boundary and the write boundary**, the subject of the story's
Security flag, and four rows belong here rather than above:

| ID    | Given                                                              | When                                                   | Then                                                                                                                                                                                                                                                                                                                         |
| ----- | ------------------------------------------------------------------ | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PA-01 | A negation re-including an index path, and a generated project     | `copier copy`, then `copier update` to a later version | On copy the gated `mv` overwrites the rendered in-tree file and the tree looks clean; on update the in-tree file is template content and syntek-base's rows reach the project. ES-03 is the control (TM-02, ST06)                                                                                                            |
| PA-02 | The change's file list                                             | Read against ST05's allowlist                          | Nothing outside the widened list, which since 27/09/2026 also admits `project-management/workflows/`, `how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md` (settled 27/09/2026, grilling round 3 Q14; AC-GAP-1, TM-15, ST05)                                                                                     |
| PA-03 | A check and its probe both edited by this diff                     | Review                                                 | Every existing probe's label and expected substring is byte-identical; every new probe was seen red before green, the red run recorded (TM-15)                                                                                                                                                                               |
| PA-04 | A generated project with a filled index, in a scratch fixture only | `copier recopy`, or `copier copy` into it              | Every blank seed lands over the project's own file. **Written as a test that demonstrates TM-18** (assessment Section 7.15). Settled 27/09/2026, grilling round 3 Q15: US010 documents it in `14-UPDATING.md`, and the guard refusing an existing target goes to `GAPS.md` through gate 22. Never run against a real project |

**PA-04 and EC-21 are demonstrations, not pass criteria.** They reproduce two gaps gate 10 raised and
did not settle. The developer settled both on 27/09/2026 (grilling round 3 Q15): US010 documents
them in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`, and their complete fixes go to `GAPS.md`
through gate 22. Each stays a demonstration until its fix lands, and is then the test ready to
turn green — per `code/docs/GATE-REPORTING.md`, a gap nobody can reproduce is a gap nobody fixes.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The seven files are Markdown read in an
editor or a repository browser. One property is accessibility-adjacent and worth holding: each
Instance link is labelled with a descriptor or an identifier rather than a filename, which is the
index's version of link purpose being clear from the link text (WCAG 2.2 success criterion 2.4.4).
HP-13 and EC-13 are the checks.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3.

## 5. GDPR & security constraints

**No PII and no new protected action.** The rows name planning artefacts; no person, no identifier
of a person, no personal-data store. The `GDPR` flag is correctly `N/A`.

**Security is this story's substance**, and the constraints in
`project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
Section 7 are not restated here. **0 CRITICAL, 0 HIGH, 4 MEDIUM, 12 LOW, 2 INFO** is a reading of a
template repository with one developer, no index seed and no generated project holding an index —
three findings promote to `HIGH` on named events (threat model Section 3a). Settled 21/09/2026: the
negation leak is `MEDIUM` at design state, mitigated by grilling round 1 Q2's check; no finding is
`HIGH` or `CRITICAL`, so no vulnerability record is written. Per `code/docs/GATE-REPORTING.md` that
zero is a severity reading with its reason, never a report that the seam is safe.

**Every threat and every ST, traced to the scenario that tests it:**

| Threat | ST / Section 7   | Scenario(s)                  | Note                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------ | ---------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01  | ST01 · 7.1       | HP-04, HP-07, HP-08, ES-02   | Holds by construction on `update`; HP-08 turns the Copier reading into a measurement                                                                                                                                                                                                                                                                                                                                                         |
| TM-02  | ST06 · 7.6       | ES-03, ES-04, EC-17, PA-01   | The leak the generated-tree gate cannot see                                                                                                                                                                                                                                                                                                                                                                                                  |
| TM-03  | ST03 · 7.3       | HP-02, HP-05, ES-05, ES-06   |                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| TM-04  | ST07 · 7.7       | HP-07, HP-08, ES-02, ES-20   | A probe whose seeds never change passes with or without the gate                                                                                                                                                                                                                                                                                                                                                                             |
| TM-05  | ST07, ST08 · 7.7 | ES-09                        |                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| TM-06  | ST08 · 7.8       | ES-07, ES-10, ES-11          | ES-11 is review-only                                                                                                                                                                                                                                                                                                                                                                                                                         |
| TM-07  | ST02 · 7.2       | ES-01                        | The rationale corrected; the criterion kept                                                                                                                                                                                                                                                                                                                                                                                                  |
| TM-08  | ST03, ST04 · 7.4 | HP-02, HP-03, HP-05, EC-14   | The generated-tree grep and review, and since 27/09/2026 ST03's seed-row clause, which asserts the seed row's Status against the seeded map at template time (grilling round 7 Q34; AC-GAP-2)                                                                                                                                                                                                                                                |
| TM-09  | 7.12             | HP-09, ES-03, ES-08          | Presence is US012's loop                                                                                                                                                                                                                                                                                                                                                                                                                     |
| TM-10  | 7.11             | HP-16                        | Stays LOW (settled 27/09/2026, grilling round 3 Q21). The window runs from US011 shipping until S-03 is cut, and S-03 is unscheduled (CUT-PLAN.md P8, map-order row 10). It is tracked in `GAPS.md`, the entry written at US011's gate-22 pass (call recorded 27/09/2026 with round 6) and carried as US011's own task and Definition-of-Done line (project-management/src/02-STORIES/US011.md:470-477, :534-538), not closed by a test here |
| TM-11  | 7.9              | HP-15, EC-08, EC-09, EC-10   |                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| TM-12  | 7.10             | HP-11, ES-12, EC-04 to EC-07 | The derivation is recorded by hand, against the count-derived criteria settled 27/09/2026, grilling round 3 Q18, their overlap resolved the same day by round 6 Q31 (Blockers clear wins); nothing validates it until S-03, and S-03 checks agreement only                                                                                                                                                                                   |
| TM-13  | 7.13             | none — a manual re-read      | Settled: Q14 covers all seven count sites, the `--trust` disclosure among them (grilling round 3 Q14; call recorded 27/09/2026 with round 6). US010 corrects them inside the widened ST05 (project-management/src/02-STORIES/US010.md:706-712, :1085-1095) and re-reads them by hand (:917-920) (AC-GAP-23)                                                                                                                                  |
| TM-14  | 7.14             | EC-21                        | Settled 27/09/2026, grilling round 3 Q15: documented in `14-UPDATING.md`, the migration routed to `GAPS.md`. Still a demonstration                                                                                                                                                                                                                                                                                                           |
| TM-15  | ST05 · 7.5       | PA-02, PA-03, HP-05          |                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| TM-16  | —                | ES-16                        | Caught twice by existing gates                                                                                                                                                                                                                                                                                                                                                                                                               |
| TM-17  | —                | none                         | Accepted residual — nothing records who changed a row; named rather than tested                                                                                                                                                                                                                                                                                                                                                              |
| TM-18  | 7.15             | PA-04                        | Settled 27/09/2026, grilling round 3 Q15: documented in `14-UPDATING.md`, the guard routed to `GAPS.md`. Still a demonstration, scratch fixture only                                                                                                                                                                                                                                                                                         |

<!-- AMENDED 30/09/2026 at the sign-off: TM-10 cited US011.md:453-460 and :517-521, measured
     27/09/2026 against the story at b1ca05a, and TM-13 cited US010.md:676-682, :1055-1065 and
     :887-890, against the story at 0c5e635. The 16-sprint-plans gate's corrections of 28/09/2026
     and 30/09/2026 moved them to project-management/src/02-STORIES/US011.md:470-477 and :534-538, and to project-management/src/02-STORIES/US010.md:706-712,
     :1085-1095 and :917-920, the text unchanged. -->

**One constraint must not be tested the obvious way.** HP-07 and HP-08 can only be run through
`bash .github/scripts/shipped-ai.sh`, which builds its own template and project under a temporary
directory. **Never run a real `copier update`, `copier recopy` or `copier copy` against this
repository or a generated project to test the seam** — `.claude/CLAUDE.md` Section 6 forbids the raw
call, and PA-04 against a real project destroys its uncommitted register edits.

## 6. Developer notes — testability

- **Measure by executing, in the lawful places.** `bash .github/scripts/shipped-registers.sh` and
  `bash .github/scripts/shipped-ai.sh` run locally and in CI; they are the project's own wrappers.
  A generated tree exists only in CI's `[3/4]` job, on push to any branch
  (`.github/workflows/audit-template.yml:32-34`). Commit, push the story branch, and record the run
  ID beside each generated-tree result.
- **The family's list is a constant.** Name the seven seed paths and their seven landed paths in
  the script, as `shipped-registers.sh` names GAPS and DEFERRED at `:67-77`. Derived from
  `copier.yml`, a seed dropped with its `mv` line vanishes from both sides (ES-08).
- **Read only the copy-gated task.** Split `_tasks` into its entries and select the one whose
  `when:` line tests `_copier_operation == 'copy'` and whose command holds the README `mv`; check
  each index line inside that command. A line moved to an ungated task must produce one finding,
  and a line dropped entirely one finding — one check, not two, or the probe sees two
  (`:213-216`).
- **Match negations as `_exclude` does.** For each `_exclude` line, strip either quote style, a
  trailing comment, and a surrounding block-tag conditional, then test each of the seven landed
  paths against the pattern with glob semantics — `path_matches` at
  `code/src/scripts/audits/doc-references.sh:406-418` is the in-repository precedent. Report once
  per negation line. Probe with a literal negation and one ending `**/*-INDEX.md`; the baseline
  run must be clean against today's 24 negations.
- **"No instance row" is judged by shape inside `## The register`.** A body row that is neither
  the italic placeholder nor, in the map-index seed, the one row linking MAP-SCALE-PLANNING.md is an
  instance row. The DEFERRED check's first-cell `US` pattern (`:195`) does not transfer: Status
  leads the spine.
- **The seed-row agreement clause (AC-GAP-2; settled 27/09/2026, grilling round 7 Q34, option
  1).** One clause in the family, not a second family. Read the map-index seed's one row, and the
  first line of `.copier/MAP-SCALE-PLANNING.md` that begins with the bold Status key. Apply the
  read rule to each value after its key and compare the results as strings. Its probe is a mutated
  seed pair whose two Status values disagree — a seed row reading `TBD`, say: exactly one finding.
  A change to both seeds together stays green, which is intended, because the pair still agrees.
  AMENDED 27/09/2026 at the final pass: this note read "if the developer accepts it".
- **`shipped-ai.py`, in four places.** Add the six register folders' `CONTEXT.md` markers inside
  `fixture()` beside `:103-104`, so all three callers get them. Assert the seven are present after
  every copy. Edit each index in each project and commit before tagging the second version; change
  every index seed in the template's second commit; compare bytes after `run_update`. Add an
  `ungated-seed-task` mutation that pops the task's `when:` key and expects the byte-identity
  message — the existing mutations run a copy only (`:242`), so this one needs the update path.
  **The changed seeds, the byte comparison and the mutation are gate 10's obligations, signed off
  into US010 (settled 27/09/2026, grilling round 3 Q16; AC-GAP-10).** The memory
  probe's identical blind case at `:174-175` is not repaired here. It goes to `GAPS.md` through
  gate 22.
- **No project lint leg reads the Python.** `lint.sh` skips any path outside `code/src/django/`
  (`:262-265`) and basedpyright's include is the same tree (`pyproject.toml:184`). Record the
  Python leg as not run with that reason, never as a `lint.sh` pass.
- **ShellCheck is not installed on this host** (21/09/2026) and no project script runs it. Install
  it and record the result over `shipped-artefacts.sh` and `shipped-registers.sh`, or record "not
  run" with the reason.
- **Count maps by exact filename:**
  `git ls-files project-management/src/01-FEATURE-MAPS/ | grep -E '/MAP-[^/]*\.md$' | grep -vxF -e project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md -e project-management/src/01-FEATURE-MAPS/MAP-INDEX.md`.
- **`Updated`, with the date and the zone pinned:**
  `git log -1 --format=%ad --date=format:%d/%m/%Y -- FILE` — the author date, in the commit's
  recorded offset. Never `format-local:`.
- **Read a Status by the ADR's terms**, the carrier line first and the strips second. The US011
  plan's Section 6 carries a sketch for the four registers it backfills; for a finding, take the text
  after `**Status**:` before cutting at the middle dot (EC-08).
- **The literal grep, without its false positives.** Over the seven generated index files,
  `grep -ohE 'US[0-9]{3}|SPRINT-[0-9]{2}|MAP-[A-Z][A-Z0-9-]+' FILES | grep -vxE 'US000|SPRINT-00|MAP-INDEX|MAP-SCALE-PLANNING' | sort -u`
  prints nothing when clean; the ADR and plan identifiers are covered because each contains a story
  identifier. MAP-SCALE-PLANNING is allowed in the map index only.
- **The link check the citation gate cannot do.** For each index in-tree and generated, test every
  Markdown link target with `test -e` from the file's own folder; record the count checked beside
  the row count.
- **The joined-line instruction search.** Over the generated tree's Markdown, read paragraphs
  rather than lines (`awk 'BEGIN{RS=""}'`). Match two things: an instruction naming `CONTEXT.md`
  as an index, and a statement that a register has no index or that its index is deferred — "no
  index", "no folder-level index", "index is deferred", "register-index work". Two of the named
  sites split the phrase across lines. Skip dated historical comments, as the story's scenario
  already does, and record the pattern with the result. A site that only says an index is absent is
  missed by the first pattern alone. That is how the first sweep missed nine.
- **Capture the citation baseline before the first edit**, whole tree, with the detector's blob hash
  beside it; read the close as a diff by `(file, kind, token)`. A detector that moved in between
  makes the diff detector-confounded — report it as such.
- **Anchor every held edit on its quoted text.** US010.md and SPRINT-06.md both carry a concurrent
  session's uncommitted edits; every line number in this plan is the working copy's at 17:39 on
  21/09/2026. AMENDED 27/09/2026 at the final pass: the held edits are applied, so this now holds
  of a gap's description only. Each "Written back" citation was re-measured 27/09/2026 against the
  final pre-commit US010.md, and again 30/09/2026 against the story as the 16-sprint-plans gate
  corrected it, and SPRINT-06's 27/09/2026 rows are cited by their text (Section 1).
- **No pytest, no coverage figure, no migration.** The Verification Checks' Python-suite and
  migration rows do not apply; the test record marks them `N/A` with the reason.

## 7. Gate readings, measured 21/09/2026 — indicative, not baselines

Taken on `pm/story-creation` at HEAD `71a32d7`, over the dirty working tree described in the header
comment, with **no edit of US010's made**. These are readings, not the story's baseline, which is
captured immediately before its first edit.

| Reading                                                    | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `doc-references.sh --path` US010.md                        | **32, exit 1**, every one `[instance citation]`. Detector blob `b9e4e129f2781b37af3879db54af15999daa151d`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `shipped-registers.sh` · `--self-test`                     | Exit 0, no finding · **9 probes**, exit 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `shipped-ai.sh --self-test`, unmodified                    | Exit 0, **six PASS lines** — four from the copy and update exercises, two from the detector mutations                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `shipped-artefacts.sh`                                     | **Not run** — it reads a generated tree, and no project script makes one. CI's `[3/4]` is the host; nothing here says it passes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `rmdir` on a non-empty `.copier/`                          | "Directory not empty", **exit 1** — scratch directory under `/tmp`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| Copier's update renders                                    | **3** copy calls in Copier 9.18.2's main module (lines 1423, 1472, 1496), read from the local uv cache, never run. `[3/4]` resolves Copier unpinned (`audit-template.yml:154`), so CI's release may differ                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Tracked instances                                          | Maps **15** · stories 11 · sprints 7 · ADRs 20 · plans 9 · findings 0 · bugs 0 = **62**. Untracked: US012.md and US010's two ADRs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Map `**Status**` headers                                   | **3** parse (all `Charting`) · **12** fail the format · at least **13** change on value — a flagged contradiction of the settled figure's wording (Section 8)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Unticked Gate-to-stories index-row boxes                   | **6** (AC-GAP-21)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Index files present                                        | **0 of 7**; the only index is `project-management/src/23-INCIDENTS/INCIDENT-INDEX.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| The seed chain                                             | Nine `mv` lines and `rmdir .copier` at `copier.yml:973-984`, gated at `:984`; `SEEDED` holds one entry (`shipped-artefacts.sh:105`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `_exclude` negations                                       | **24**, 18 of them at `copier.yml:160-186`; **none** matches an index path                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Shipped sites naming `CONTEXT.md` as an index, or no index | **26** across 14 files: 24 live sites in 13 files, plus the two `CONTEXT.md` sections the Documentation Tasks rewrite. 6 of the files, holding 10 of the sites, sat outside ST05 until it widened by `project-management/workflows/` (settled 27/09/2026, grilling round 3 Q14; AC-GAP-1)                                                                                                                                                                                                                                                                                                                                                       |
| ShellCheck · Python lint legs                              | Not installed · ruff and basedpyright read `code/src/django/` only                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| SPRINT-06's deletion-probe leftovers                       | **0** — repaired by the concurrent session, recorded at SPRINT-06.md:45-52                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `doc-references.sh --path` this plan                       | **44, exit 1**, every one `[template-only citation]`; 0 instance, 0 dangling, 0 plan-prefix; 442 backticked tokens read, 25 tested as repo paths. Measured after this revision's last edit. All 44 are the git-index class: the file is untracked, so the detector reads it as shipping, and each token is a template-only file or a non-shipping PM artefact this plan cites. Expected to clear on commit, **not verified**, and re-measured once committed. Re-measured 27/09/2026 after the final pass's last edit: **44, exit 1**, every one `[template-only citation]` of the same class, and no instance, dangling or plan-prefix finding |
| Whole-tree `doc-references.sh`                             | **Not run by this pass** — over ten minutes, and nothing here rests on it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

## 8. Three candidates refuted, and one settled figure flagged

Each candidate was raised during the pass, each was plausible, and each fails on a measurement.

- **"US010 must add a write-the-row duty to each register's `CLAUDE.md`, or the indexes drift the
  day US011 fills them."** N-004 settled on 31/08/2026 that the duty attaches to the artefact
  template and ships in the same change as its gate (MAP-REGISTER-INDEXES.md:103), which is S-03.
  US010 repoints the map instructions that already exist; it does not create the duty for the other
  six. The window is TM-10's. It runs from US011 shipping until S-03 is cut, S-03 is unscheduled
  (CUT-PLAN.md P8, map-order row 10), and the window is tracked in `GAPS.md` through gate 22
  (settled 27/09/2026, grilling round 3 Q21), the entry written at US011's gate-22 pass (call
  recorded 27/09/2026 with round 6).
- **"SPRINT-06 still gives US010 the deletion probe in three places."** True when the brief was
  written, false at 17:39: the concurrent session removed all three and recorded it
  (SPRINT-06.md:45-52), and :449, :497 and :517 read clean. No feedback edit is owed for them.
- **"The fixture repair belongs in `exercise()`, where the update runs."** `exercise_legacy()` and
  the self-test build through the same `fixture()` and run the same seed chain on copy
  (`shipped-ai.py:240`, `:257`); repairing one caller leaves two red.

**Flagged, not refuted: the settled count of rewritten maps.** Grilling round 2 Q11 settled that
"12 of the 15 live maps are rewritten". Measured 21/09/2026, at least thirteen headers change
value: MAP-PROGRESSIVE-ENHANCEMENT.md:4 already parses as `Charting` over a frontier its own :5
records closed. Twelve is the number that fail the format, and the enum ADR draws the same line
(ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md:57-59). It is reported with this pass's
return as a contradiction of the settled figure's wording. The decision is untouched: the format,
the five values and the re-derivation of every header stand, and no criterion holds the count.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US010.md` — the story this plan tests; all twenty-three gaps above are `[RESOLVED] 27/09/2026` in it, the citations re-measured 30/09/2026 against the story as the 16-sprint-plans gate corrected it (27/09/2026 against its pre-commit text until then)
- `project-management/src/03-SPRINTS/SPRINT-06.md` — the record whose mirrored criteria follow the story's
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the security gate Section 5 traces, TM-01 to TM-18 and Sections 7.1 to 7.15
- `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` — the writer format and reader rule, both `Accepted` — committed so at `0c5e635`, after the independent review round 4 Q27 required (settled 27/09/2026). AMENDED 30/09/2026: read "both `Proposed`, accepted in the 27/09/2026 write-back pass only after an independent review and before the US010 commit" until then
- `project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md` — the sibling plan sharing AC-GAP-3 and AC-GAP-7
- `project-management/src/11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` — the seed presence loop this story's `SEEDED` growth meets
- `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` — S-01, S-02, S-03 and N-001 to N-006
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the reporting regime AC-GAP-15 applies, superseded 30/09/2026 by `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged but for the manual testing guide's path <!-- UPDATED 30/09/2026: successor added beside the superseded record,
  which the 18-TESTS split superseded for the manual testing guide's path alone (settled
  30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, the demonstration rows, Section 7's unrun readings and Section 8 rest on
