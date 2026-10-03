# SPRINT-06

**Last Updated**: 03/10/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Every register folder gains an index file of its own, born seeded and seed-once so no
`copier update` can overwrite a filled one; the feature-map index is backfilled and leaves the
`CONTEXT.md` that ships; and every shipped site still instructing the old index row stops doing so.

<!-- Derived from the title and Client Summary of US010, the sole member, and from the deliverable
     column of the narrowed slices `S-01` and `S-02` on
     project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md — the derivation
     project-management/src/03-SPRINTS/SPRINT-03.md used on 07/09/2026 for a record with one
     member, and project-management/src/03-SPRINTS/SPRINT-05.md on 09/09/2026.

     Narrow by construction. The Register Indexes epic has five slices and this goal names two:
     `S-03` (the gate that reads these files) and `S-04` are uncut and belong to no record, and
     `S-05` is US011's, in project-management/src/03-SPRINTS/SPRINT-07.md. A goal naming their
     deliverables would be the drift project-management/src/03-SPRINTS/SPRINT-02.md recorded on
     05/09/2026 and SPRINT-03 on 07/09/2026.

     AMENDED 27/09/2026 with US010's write-back of gates 10, 11 and 15. The last clause read "the
     six shipped sites still instructing the old index row stop doing so" until that day. Gate 11
     measured twenty-four live sites in thirteen shipped files where the story had counted six
     (project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md, AC-GAP-1 and
     AC-GAP-20), and US010 corrects every one (settled 27/09/2026, grilling round 3 Q14), so the
     goal holds no count. The seed-count and updating-guide statements the same round added (Q14,
     Q15) are named under Acceptance Criteria rather than here: they sit in neither the title nor
     the Client Summary this goal is derived from. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, all-`Must`, and **closed to
admission, holding a reservation**: `project-management/src/03-SPRINTS/SPRINT-05.md` reserves
US009's 5 SP `Should` carry to this record, and if it lands this sprint is **13 / 11 SP** and at
grace. The grace is deliberately available for that carry and for nothing else
(<%DEVELOPER_NAME%>'s call at `03-sprint-planning`, 20/09/2026). See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 20/09/2026 on US010's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US010.md. Two rows
     carry values: Security carries the two seed-once subjects the story set at cutting, and QA
     names unit, integration and manual types. Eleven rows stay N/A: no model, no screen, no
     personal-data path, no public page, no Ninja surface, no log line, and — unlike
     project-management/src/03-SPRINTS/SPRINT-05.md — no Python either, the member shipping
     Markdown, YAML and one bash array.
     Recomputed 21/09/2026 on US010's amendment, CHANGED in one row: QA drops `seed-deleted`, the
     seeded-deletion probe having moved to US012, which is not a member of this record. The same
     amendment reached three rows outside this table, each still giving US010 the probe until
     then: the QA Automated self-test criterion, which closed ", and its planted-deletion probe
     still fires — a deleted seeded index is reported, not silently tolerated"; the Index and Seed
     Tasks row growing `SEEDED`, which closed ", and add the deletion probe"; and the first QA
     Tasks — Automated row, which read "US010 — extend `shipped-artefacts.sh --self-test` with the
     seeded-index deletion probe". Each now matches project-management/src/02-STORIES/US010.md.
     Recomputed 27/09/2026 on US010's write-back of gates `10`, `11` and `15`, all written
     21/09/2026, and of grilling rounds 3 to 5, CHANGED in two rows, each copied verbatim from
     project-management/src/02-STORIES/US010.md as it then stood. Security widens with gate `10`:
     the `rmdir .copier` ordering and the chain's one-line form, the update probe in
     .github/scripts/shipped-ai.py that changes every index seed between its two tags, asserts
     byte-identity and goes red with the gate removed (settled 27/09/2026, grilling round 3 Q16),
     the seed-emptiness family in .github/scripts/shipped-registers.sh, and the no-negation clause
     naming the leak `shipped-artefacts.sh` admits by name. QA is rewritten with gate `11`: the
     `shipped-artefacts.sh` self-test is credited with the leak allowlist only, never with a proof
     that the seeds landed; the `shipped-registers.sh` and `shipped-ai.sh` self-tests join it; the
     generation smoke names every render path the template offers rather than the two answer sets
     (settled 27/09/2026, grilling round 3 Q23); counts match their source rather than the header;
     and every repaired instruction site is re-read, not six. The other eleven rows stay N/A.
     CORRECTED 27/09/2026 from gate `11`, written 21/09/2026: the member now edits one Python file,
     the CI probe .github/scripts/shipped-ai.py (settled 21/09/2026, grilling round 1 Q3), so the
     "no Python either" above is true of application code only. No flag changes: Backend governs
     application code, and the probe is a template-only CI script outside code/src/django/.
     Recomputed 27/09/2026 at the final pass, CHANGED in one row and copied verbatim from
     project-management/src/02-STORIES/US010.md as it now stands: QA's `shipped-registers.sh
     --self-test` parenthesis gains "seed row agreeing with the seeded map". The third seed family
     gains one clause, the map-index seed's one row string-equal under the read rule to the
     scale-planning seed's own Status header, with its own probe (settled 27/09/2026, grilling round
     7 Q34, option 1). It is a clause in the settled family, not a second family, so round 2 Q12's
     trigger is not reached. Security does not move: its "emptiness gated by a third family"
     already names the family the clause joins. The other eleven rows stay N/A.

     THE RESERVATION CONTRIBUTES NOTHING TO THIS UNION, and that is the rule rather than an
     oversight. project-management/docs/planning/SPRINTS.md computes the union FROM the Story
     Summary, and a reserved carry is not in it until it lands. If US009 arrives, this table is
     recomputed against project-management/src/02-STORIES/US009.md in the same change that admits
     it — which would widen Security with that story's supply-chain subject and add its subjects
     to QA without changing QA's types, US010 already naming unit, integration and manual. Measured
     20/09/2026: every other row reads N/A in BOTH stories, Backend included — US009 ships bash and
     one JSON manifest read, so its own Backend row is N/A, and the union would stay N/A. That
     differs from project-management/src/03-SPRINTS/SPRINT-05.md, whose Backend reads Yes on
     US008's settings modules alone.

     THESE ARE FIRST-PASS VALUES. On 20/09/2026 no artefact under
     project-management/src/10-SECURITY/ or project-management/src/11-QA/ names US010, and it has
     no story plan. project-management/docs/planning/CADENCE.md's rule is that the flag is a
     manifest and the gate owns the design, so the Security and QA rows here are recomputed when
     gates `10` and `11` close, on the precedent SPRINT-01 set when QA-PLAN-US001 AC-GAP-6 moved
     its QA row. Per code/docs/GATE-REPORTING.md these are gates not yet entered, reported as
     such — not gates that found nothing. Gates `10` and `11` have since run, both writing on
     21/09/2026, and both rows are recomputed from what they wrote, the write-back landing
     27/09/2026 once grilling had settled their open questions (the recompute above). Gate `10`
     is signed off: both security plans read Signed off, corrected in place and reviewed by
     <%DEVELOPER_NAME%> on 28/09/2026 (settled 28/09/2026, 16-sprint-plans grilling round 1 Q1),
     the correction moving no finding, severity or constraint, so neither row moves with it.
     Gate `11` closed on 30/09/2026, when <%DEVELOPER_NAME%> signed QA-PLAN-US010 off: it closes
     only at Signed off, exactly as gate `10` does (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9). The plan had read Reviewed since 27/09/2026, all twenty-three of its gaps
     resolved into the story by then, AC-GAP-2 the last (grilling round 7 Q34). The sign-off moves
     no value: US010's own Security and QA rows, re-read 30/09/2026, are unchanged, so neither row
     here moves with it. US010 still has no story plan. AMENDED 27/09/2026 at the final pass: the
     QA clause read "QA-PLAN-US010 reads Draft with AC-GAP-2 [OPEN] on grilling round 6 Q34" until
     then. AMENDED 28/09/2026 at the security sign-off: the gate clause read "Neither gate is
     signed off: both security plans read Draft, and QA-PLAN-US010 reads Reviewed" until then.
     AMENDED 30/09/2026 at gate 11's close: the QA clause ended "— Reviewed, which is not Signed
     off" until then, and the plan now is.

     AMENDED 27/09/2026 AFTER TWO VERIFIED PASSES OF THAT WRITE-BACK. This comment said gates
     `10`, `11` and `15` had "closed" on 21/09/2026 at three places until that day — "all closed
     21/09/2026", "from gate `11`, closed 21/09/2026" and "have since closed, both on 21/09/2026"
     — and the Notes and the QA comment below said the same. What is true is narrower: the three
     gates wrote their artefacts on 21/09/2026, grilling settled their open questions on
     27/09/2026, and the artefacts are committed with US010; the two ADRs, written Proposed, are accepted in this pass
     after an independent review and before the US010 commit (settled 27/09/2026, grilling round 4
     Q27). No flag value moves with the correction. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| GDPR       | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Security   | seed-once integrity — all seven `_tasks` `mv` lines inside the existing `copy` gate, ahead of `rmdir .copier`, in the chain's one-line form, so no `copier update` can overwrite a project's filled index with a blank stub — proved by an update probe in `.github/scripts/shipped-ai.py` that changes every index seed between its two tags, asserts byte-identity, and goes red with the gate removed; no seed cut from a populated in-tree index, emptiness gated by a third family in `.github/scripts/shipped-registers.sh`; no `_exclude` negation re-includes an index path, the leak `shipped-artefacts.sh` admits by name |
| QA         | unit, integration, manual — `shipped-artefacts.sh --self-test` (the eight seeds not reported as leaks); `shipped-registers.sh --self-test` (seed-blank, seed row agreeing with the seeded map, wired, never re-included); generation smoke on every render path the template offers (today: `INCLUDE_MOBILE` true and false) with all seven present; `shipped-ai.sh --self-test` (all seven land; update-does-not-overwrite, byte-identical over changed seeds); row-per-map and counts-match-source; every repaired instruction site re-read                                                                                       |
| SEO        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| API        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Logging    | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Backend    | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

<!-- THE COPIER DELIMITERS ARE NOT REPRODUCED ANYWHERE IN THIS FILE, and the omission is
     deliberate. `.github/scripts/check-template-tokens.sh` scans every non-exempt tracked file for
     the copier delimiter pair and fails anything between them that is not a bare upper-snake token
     name, which a quoted copier conditional is not. Its exemption list covers `project-management/src/01-FEATURE-MAPS/` but not
     `02-STORIES/` or `03-SPRINTS/`, and widening it would be wrong rather than merely bold: the
     `_exclude` re-includes mean `**/CONTEXT.md`, `**/CLAUDE.md` and `**/*TEMPLATE*` under that tree
     DO render, so a blanket folder exemption would stop gating files that genuinely ship. The gate
     has no way to say "this is a quoted example in a file that cannot render", so the `when:` key
     and its condition are named without the delimiters around them — and THIS COMMENT does not
     reproduce them either, which is why it describes the pair rather than showing it. The same
     technique US011 used for a literal HTML comment terminator on the same day. Measured 20/09/2026, when the
     pre-commit hook blocked on four sites across this file and the sprint record. -->

---

## Story Summary

| ID    | Title                                                                                    | MoSCoW    | SP  |
| ----- | ---------------------------------------------------------------------------------------- | --------- | --- |
| US010 | The seven register indexes are born seeded, and the map index leaves the file that ships | Must Have | 8   |

**Total:** 8 SP — all committed, no stretch tier at opening. **US009's 5 SP `Should` carry is
reserved to this record from `project-management/src/03-SPRINTS/SPRINT-05.md`**; if it arrives the
total is 13 SP, 8 committed and 5 stretch. It is not counted until it does.

<!-- US010 is added to this table rather than referenced from it because
     project-management/docs/planning/SPRINTS.md computes the flag union and the capacity FROM this
     table, and a story in no Story Summary is counted nowhere — SPRINT-04's reading of 07/09/2026.
     US010 sits in no other record's table; its own `**Status:**` reads `Open`, and this record
     moves it nowhere.

     The reservation is deliberately NOT a row. project-management/src/03-SPRINTS/SPRINT-03.md set
     the shape on 07/09/2026 when the same conditional arrived there from SPRINT-02: the carry is
     stated in prose beneath the table and in the Definition of Done, and it enters the table only
     if it lands. A conditional row would be counted by the union and the capacity arithmetic as
     though it were certain. -->

## Dependencies

- **US010 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slices `S-01` and the narrowed
  `S-02`, nodes `N-001`, `N-002`, `N-005` and `N-006`, all settled 31/08/2026 on a map whose
  frontier is empty. That map's `Gate to stories` records a deadlock ruling naming the slice by
  number — "`S-01` may be cut on that basis; the box closes when `S-01` ships" — and the ruling was
  exercised at `02-story-creation` on 20/09/2026. Its place tenth in the build order is arithmetic,
  not a blocker, stated so that nobody goes looking for one.
- **US010 unblocks US011, and `project-management/src/03-SPRINTS/SPRINT-07.md` says so from the
  other side.** US011 backfills four index files this story creates and has nothing to edit until
  they exist. The edge is stated in both records and in both stories so a later reader cannot
  re-merge the two halves of a slice that was split at `02-story-creation`.
- **`MAP-REGISTER-INDEXES.md` `S-03` — the gate that reads these files — ships after US011, not
  after this sprint alone, and no record schedules it.** `N-003` asserts presence, symmetry and
  status over the seven indexes and cannot run until they exist; its presence clause has no
  debt-line clause, so run before US011 it is red on the four debt-carrying indexes this sprint
  ships (settled 21/09/2026, grilling round 1 Q1). `S-03` has no sprint: CUT-PLAN.md P8
  (27/09/2026) gives SPRINT-08, not yet opened, to MAP-RULE-OWNERSHIP — US013 then US014 — and
  leaves `S-03` `Proposed` at map-order row 10 of `project-management/src/02-STORIES/CUT-PLAN.md`.
  The window from US011 shipping to `S-03`'s cut is therefore open-ended; TM-10 stays LOW, and the
  window is tracked in `GAPS.md` through gate `22` (settled 27/09/2026, grilling round 3 Q21). The
  entry is written at US011's gate-`22` pass, when the window opens, not at US010's (call recorded
  27/09/2026 with round 6). Named so the absence of a gate in this sprint is read as sequencing
  rather than omission. This record schedules no part of `S-03`, and `S-04` likewise belongs to no
  record.
- **US010 does not block on US004, and the reason is the one SPRINT-04 recorded for US006 and
  SPRINT-05 for US008.**
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is a
  reporting regime — "A story cannot be blocked on a gate it is forbidden to repair" — binding every
  story until `doc-references.sh` goes green; it sequences nothing. Its successor of 30/09/2026,
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  restates it unchanged but for the manual testing guide's path. See Verification Checks.
  <!-- UPDATED 30/09/2026: successor added beside the superseded record,
  which the 18-TESTS split superseded for the manual testing guide's path alone (settled
  30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
- **US010 waits on no placed story, and the files it now shares with three of them are rebases,
  not waits.** Verified 20/09/2026 at cutting against US001 to US009, all `Status: Open`: none of
  them writes `copier.yml`'s `_tasks` list, `.github/scripts/shipped-artefacts.sh`'s `SEEDED`
  array, `.claude/skills/wayfinder/SKILL.md`, or any `CONTEXT.md` under `project-management/src/`.
  One adjacency is ordered rather than blocked: the story edits seven `CONTEXT.md` files under
  `project-management/src/`, and `code/src/scripts/audits/CONTEXT.md` — US002's headroom — is
  **not** among them. **Re-measured 21/09/2026 and 27/09/2026** against the write set as gate `10`
  and grilling round 3 widened it, per project-management/src/02-STORIES/US010.md -> Dependencies:
  US009 adds a grep inside the same `[3/4]` job of `.github/workflows/audit-template.yml`; US012
  edits `.github/scripts/shipped-artefacts.sh`'s check 4 and the comment above `SEEDED`, which
  US010 rewrites too — build order expects US010 to land first, but the landing order is not fixed,
  and whichever of the two lands second extends the other's wording, the two sessions running
  alongside with neither holding the other (CUT-PLAN.md P9, 27/09/2026, which lifted the holds and
  fixed no order); and US008 adds rows to `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` and edits
  `project-management/workflows/24-release/CHECKLIST.md`, neither on a line US010 repairs. One
  unplaced story is ordered too: US015 (provisional, MAP-RULE-OWNERSHIP `S-02`) edits other lines of
  three guide files US010 corrects, and US010, in this sprint, merges first while US015 rebases
  (settled 27/09/2026, grilling round 3 Q14).
- **A concurrent session is charting
  `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`**, committed on 20/09/2026
  in `50e22ad` and still at 21 open / 9 blocking on 21/09/2026, so it can produce no story and
  enters no record. It is not
  a blocker — US010 indexes whatever maps exist when it is built, and no criterion in that story
  holds a literal count — but `.ai/INSTRUCTIONS.md` requires shared-artefact ownership to be
  coordinated, and `project-management/src/01-FEATURE-MAPS/` is shared between the two sessions.
- **Sprint numbering and build order agree, and that was checked rather than copied.** The settled
  build order is the prefix on each plan in `project-management/src/17-STORY-PLANS/` — `01-` US007,
  `02-` US001, `03-` US002, `04-` US003, `05-` US004, `06-` US005, `07-` US006, `08-` US008, `09-`
  US009, nine plans on disk on 20/09/2026 — and US010 builds tenth, behind SPRINT-05's last member.
  The next free prefix is `10-`, and that number is **reserved, not a plan**: `17-story-plans`
  writes it, and nothing here may cite it as one (SPRINT-04's rule for US006's `07-`, which has
  since been written). Nothing is renumbered:
  `project-management/docs/planning/STORIES.md` makes the prefix the position in the settled build
  order across the whole backlog and renumbers it whenever that order changes, and appending US010
  at the end changes no other story's position. Updated 03/10/2026: `16-sprint-plans` has written
  this sprint's plan, `project-management/src/16-SPRINT-PLANS/06-SPRINT-PLAN-06.md`, and both
  segments of its name read `06`, derived in its _Build order_ section, which also states the carry
  case: US010 would build ninth and US009 tenth, so the two story-plan prefixes swap. The plan
  carries the reservation as a no-file row in its index. `project-management/src/02-STORIES/US010.md`
  does not record it yet, and US010's story-plan commit records it there (settled 03/10/2026,
  16-sprint-plans grilling round 9 Q20).
- **One thing may carry into this record, and it is named rather than assumed.**
  `project-management/src/03-SPRINTS/SPRINT-05.md` -> Definition of Done reserves US009's 5 SP
  `Should` carry here if it is dropped rather than delivered. Nothing else can: SPRINT-01, SPRINT-02
  and SPRINT-04 are closed with nothing reserved out of them, and SPRINT-03 holds US003's
  reservation which runs into SPRINT-03, not out of it.
- **`Blocked` is a story status, not a sprint one.** US010 waits on nothing, so no story
  `**Status:**` moves on account of this record.

<!-- CORRECTED 21/09/2026. The concurrent-session bullet above read "untracked as of 20/09/2026 and
     at 21 open / 9 blocking" until that day. The word WAS TRUE WHEN WRITTEN and is corrected
     rather than struck: this record opened in `9901d9c` at 16:51 on 20/09/2026 and the map was
     committed in `50e22ad` at 16:57 the same day, six minutes later. Its header still reads 21 open
     / 9 blocking, so the bullet's conclusion — no story, no record — is unchanged.
     project-management/src/03-SPRINTS/SPRINT-07.md -> Notes carries the same correction. The
     comment sits below the list rather than inside it because Prettier re-indents a comment's
     continuation lines inside a list item on every pass — SPRINT-05's finding of 20/09/2026. -->

<!-- CORRECTED 27/09/2026, with US010's write-back of gates 10, 11 and 15, and lifted out of the
     list for the same Prettier reason. Two bullets above read otherwise until that day, each true
     when written. The S-03 bullet read "ships after this sprint, not before", which N-003's
     presence clause narrows to after US011 (grilling round 1 Q1); the same day's settlement that
     cut S-03 into a new SPRINT-08 after the gates (round 2 Q13) was never written into this record,
     and CUT-PLAN.md P8 has since superseded it. The shared-file bullet was headed "US010 shares no
     file with any placed story", which stopped being true when the write set widened to reach the
     CI scripts on 21/09/2026 and the guide and workflow sites on 27/09/2026 (Q14); its cut-time
     verification is kept as written and the re-measure appended. Neither change adds a blocker:
     US010 still waits on nothing.
     AMENDED 27/09/2026 AFTER TWO VERIFIED PASSES OF THAT WRITE-BACK, following
     project-management/src/02-STORIES/US010.md -> Dependencies. The shared-file bullet read "which
     US010 rewrites first and US012 extends second", credited to CUT-PLAN.md P9, which lifted the
     two sessions' holds and fixed no landing order; it now carries the in-either-order rule. The
     S-03 bullet gains the writer of the TM-10 window's GAPS.md entry, US011's gate-22 pass (call
     recorded 27/09/2026 with round 6). Neither adds a blocker. -->

<!-- AMENDED 03/10/2026, when 16-sprint-plans wrote this record's plan, and lifted out of the list
     for the Prettier reason SPRINT-05 recorded on 20/09/2026. The build-order bullet closed "When
     16-sprint-plans writes this sprint's plan, both segments of
     {exec-order}-SPRINT-PLAN-{sprint-number}.md read 06." until then, its backticks dropped here
     because the citation gate reads backticked tokens inside a comment. The prediction held, and
     the plan derives it rather than copying it. Two clauses are new. The carry case is the plan's:
     "US009 builds ninth and US010 tenth" in the Definition of Done is the no-carry reading. And the
     reservation of "10-" is recorded in this record and the plan's index but not yet in US010.md,
     whose own commit records it (settled 03/10/2026, 16-sprint-plans grilling round 9 Q20); this
     change edits neither US010.md nor SPRINT-07.md. -->

## Notes

**This record opens holding one all-`Must` member, which is the shape declined on 07/09/2026, and
it is opened knowing that — for the second time, on the same arithmetic that opened
`project-management/src/03-SPRINTS/SPRINT-05.md` on 09/09/2026.** What was declined is recorded in
`project-management/src/03-SPRINTS/SPRINT-04.md` -> Notes: the alternative to taking grace there
was a fifth record holding US006 alone, "a single-member all-`Must` sprint, the shape SPRINT-03
called 'this sprint's one real weakness' on opening", and <%DEVELOPER_NAME%> "chose the grace over
that". **Nothing in the tree refuses a sixth record.** That was measured on 20/09/2026 rather than
assumed: a search across `project-management/` and `.claude/` for a statement refusing a sixth or
seventh record returns none, and the three standing refusals SPRINT-05 had to date on opening were
each scoped to a fifth record in the 07/09/2026 cascade. `05-SPRINT-PLAN-05.md` -> _Won't (this
sprint)_ refuses **a third story into SPRINT-05**, which is a different refusal and stays true.

**The objection does not transfer, and the arithmetic says why.** Every record is closed to
admission, and an 8 SP `Must` clears none of them. Measured 20/09/2026:

| Record      | Stands at                             | With US010's 8 SP   | Reading                      |
| ----------- | ------------------------------------- | ------------------- | ---------------------------- |
| `SPRINT-01` | 10 / 11, CLOSED                       | 18 / 11             | Over grace                   |
| `SPRINT-02` | 8 / 11, CLOSED                        | 16 / 11             | Over grace                   |
| `SPRINT-03` | 8 / 11, or 13 / 11 with US003's carry | 16 / 11, or 21 / 11 | Over grace either way        |
| `SPRINT-04` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |
| `SPRINT-05` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |

An 8 SP `Must` story has no record to enter, and the only alternative is a `Must` story in no Story
Summary, counted nowhere. That is arithmetic rather than a call, and it is recorded as arithmetic —
the way SPRINT-03 recorded US006's refusal on 05/09/2026 and SPRINT-05 recorded US008's on
09/09/2026.

**The backlog register.** Every live record carries this table and the copies are identical; **this
record is `SPRINT-06`**. It became a live register on 17/09/2026, when US009 was placed into
SPRINT-05 — until that day it stood in three records only, four rows long, and was scoped to the
07/09/2026 cascade alone.

| Sprint      | Members, in build order                                         | SP                                                          |
| ----------- | --------------------------------------------------------------- | ----------------------------------------------------------- |
| `SPRINT-01` | US007 (`Must`, 5) then US001 (`Must`, 5)                        | 10 / 11 — closed                                            |
| `SPRINT-02` | US002 (`Must`, 3) then US003 (`Should`, 5, stretch)             | 8 / 11 — closed                                             |
| `SPRINT-03` | US004 (`Must`, 8), plus US003's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-04` | US005 (`Must`, 5) then US006 (`Must`, 8)                        | 13 / 11 — at grace, closed                                  |
| `SPRINT-05` | US008 (`Must`, 8) then US009 (`Should`, 5, stretch)             | 13 / 11 — at grace, closed                                  |
| `SPRINT-06` | US010 (`Must`, 8), plus US009's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-07` | US012 (`Must`, 2) then US011 (`Should`, 8, stretch)             | 10 / 11 — closed                                            |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

<!-- THE SAME ROW CHANGED AGAIN LATER ON 21/09/2026, at 03-sprint-planning. The SPRINT-07 row's
     SP cell read "10 / 11 — open" from US012's admission, recorded below, until
     <%DEVELOPER_NAME%> closed that record to further admission by call at 10 / 11: its 1 SP of
     headroom is not spoken for, and the next map's slices estimate at 3 to 8 SP, so nothing
     coming fits it. It reads "closed" as the SPRINT-01 and SPRINT-02 rows do for a close by call,
     and its members did not move. A new admission opens SPRINT-08, which the first story admitted
     to it creates and which does not exist yet. No other row moved; checked against each record's
     own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. -->

<!-- ONE ROW CHANGED, 21/09/2026 at 03-sprint-planning. The `SPRINT-07` row read
     "US011 (`Should`, 8)" and "8 / 11 — open, `Must` tier absent" from 20/09/2026 until that day.
     US012 (`Must`, 2), cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md slice `S-02`, was admitted as that
     record's `Must` tier and builds ahead of US011, which becomes its stretch; the record stands at
     10 / 11, inside capacity and short of the fill trigger. No other row moved. Checked against
     each record's own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. -->

<!-- THE REGISTER'S PROSE NO LONGER CARRIES A COUNT, settled at 03-sprint-planning on 20/09/2026
     (Q4). Every copy read "all five copies are identical" and "written into all five in the same
     change" from 17/09/2026 until that day, and this change would have made it seven — buying the
     same defect again at SPRINT-08. project-management/docs/planning/SPRINTS.md's own rule was
     already count-free ("written into every copy in the same change") and the records had added a
     count it never had; the wording above is the guide's. The table is where the count lives.
     project-management/src/03-SPRINTS/CLAUDE.md's "All five carry the same backlog register" was
     corrected in the same change, and the dated comment in
     project-management/docs/planning/SPRINTS.md is left alone: it describes the 17/09/2026
     decision as it was taken and is history rather than a live claim.

     THE SPRINT-05 ROW WAS STALE IN ALL FIVE COPIES AND IS REPAIRED HERE BEFORE IT PROPAGATES.
     It read "US009 (`Should`, 3, stretch)" and "11 / 11 — at capacity, closed" while
     project-management/src/03-SPRINTS/SPRINT-05.md's own capacity line read 13 / 11 at the grace
     ceiling: US009's re-estimate from 3 to 5 SP on 17/09/2026 moved that record's header, Story
     Summary and Total and never reached the register. All five copies agreed with each other and
     all five disagreed with their source. That is `GAPS.md`'s 17/09/2026 gap firing three days
     after it was filed, and on an axis its own proposed repair could not see — a script that
     compares copies to one another would have stayed green. Noted in that entry on 20/09/2026. -->

**Capacity: 8 / 11 — inside capacity, all committed, and under capacity by 3 SP, called out rather
than padded.** `project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_
owns both figures as generation-time answers, `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`, rendered
into its table per project; in this template repository the table is unrendered, and the 11 and 13
every record here uses are the `copier.yml` defaults for those two answers. <!-- doc-references: template-only -->
The same section reads: "Capacity is a **trigger**, not a target to fill exactly." This sprint
lands on 8 because the only other cut story is an 8 SP `Should` that cannot fit beside it, which is
the same case. `project-management/docs/planning/SPRINTS.md` -> _Capacity_ asks that an
under-capacity sprint be called out in the notes rather than padded; called out here.

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and inventing one here would put the only unmeasured figure in this file into
the line a reader trusts most. Per `code/docs/GATE-REPORTING.md` a check that could not run is
reported, never passed. It becomes answerable the moment a timeline is set.

**CLOSED to further admission, and the 3 SP of headroom is not free — it is spoken for.**
`project-management/src/03-SPRINTS/SPRINT-05.md` -> Definition of Done reserves US009's 5 SP
`Should` carry to this record. **That reservation is larger than the headroom**, and the arithmetic
is `project-management/src/03-SPRINTS/SPRINT-03.md`'s exactly: 3 SP under capacity plus the 2 SP of
grace above it are together exactly the carry's 5. <%DEVELOPER_NAME%> settled at
`03-sprint-planning` on 20/09/2026 (Q7) that the grace is deliberately available for that carry and
for nothing else — so a record reading "open" while every point in it is claimed would be the drift
the register exists to prevent. Closed by decision, on SPRINT-01's precedent of 07/09/2026 and
SPRINT-03's of 05/09/2026: a ledger is closed by a call, not only by a ceiling.

**The all-`Must` weakness stands, and this record has no give it can honestly hold.**
`project-management/docs/planning/SPRINTS.md` is explicit: "**Avoid a plan where everything is
Must.** If every story is Must, the sprint has no give and the first surprise breaks it." The repair
SPRINT-05 eventually used — admitting a `Should` as a stretch tier — is unavailable here on
arithmetic rather than preference. **The backlog holds three `Should` stories, measured 20/09/2026,
and not one of them can be this record's give.** US003 is SPRINT-02's stretch with its carry
reserved into SPRINT-03 — placed, and moved twice already. US009 is SPRINT-05's stretch, and its
5 SP is **already** reserved forward into this record, so admitting it as give would double-count
the one conditional this record holds. US011 is unplaced only in the sense that its own record is
opened in the same change; at 8 SP it would stand this record at 16 / 11 and is refused on
arithmetic before it is argued. Cutting a third story to fill the room is the padding `SPRINTS.md` -> _Capacity_ tells a
record to call out instead. **What partly answers it is the reservation**: if US009 is dropped from
SPRINT-05 it arrives here as a 5 SP `Should`, and this record would then have the droppable work
whose absence is the defect — at 13 / 11, the shape SPRINT-03 has held since 07/09/2026. Until then
the weakness is real and is recorded the way SPRINT-03 recorded it on 07/09/2026 and SPRINT-05 on
09/09/2026: "the weakness stands, and this record has no other give it can honestly hold".

**This record's plan was written on 03/10/2026, owed by a call and not by a fill.** It is
`project-management/src/16-SPRINT-PLANS/06-SPRINT-PLAN-06.md`, written by a `16-sprint-plans` run
and committed with this amendment; it mirrors this record, and where the two would disagree the
record wins. Two calls owed it. <%DEVELOPER_NAME%> settled on 21/09/2026 that this record's plan
and SPRINT-07's are written once their members' gate documents are committed
(`project-management/src/03-SPRINTS/SPRINT-07.md` -> _Notes_), and US010's were committed on
27/09/2026. On 28/09/2026 <%DEVELOPER_NAME%> signed off US010's threat model and assessment, and
ruled that this record's plan and SPRINT-07's are then written (settled 28/09/2026, 16-sprint-plans
grilling round 1 Q1). The plan's commit touches the plan and this record only (settled 03/10/2026,
16-sprint-plans grilling round 9 Q20). `17-story-plans` runs after both sprint plans, once
SPRINT-07's is committed in a change of its own, for US010, US012 and US011 (settled 28/09/2026,
16-sprint-plans grilling round 1 Q4), and each story's manual testing guide is written straight
after its plan, at that workflow's Step 7.2, and committed with it: US010's and then US012's after
one round of that workflow's grilling, US011's once US010's plan is committed (settled 03/10/2026,
16-sprint-plans grilling round 9 Q22). The record's ledger and the plan's count are two different
numbers, and since 30/09/2026 they agree at 8.

- **The ledger counts every admitted story: 8.**
  `project-management/docs/planning/SPRINTS.md` -> _Two artefacts, two moments_ makes the record
  "the running ledger", opened early, and `CADENCE.md`'s per-story loop runs gate `03` second, so a
  story is admitted at cutting and the ledger moves then. 8 of 11 is not the fill trigger; what
  owed the plan was the call, not a fill, as it is for SPRINT-07.
- **The plan counts only stories that have cleared the specify tier: 8, from 30/09/2026.**
  `CADENCE.md` -> _When a sprint plan is written_ names the prerequisites that must hold for
  **every story in the filling sprint** — `15-decisions` cleared, GDPR review, security threat
  model and assessment, a QA plan with no unresolved `AC-GAP`, an SEO plan or `SEO: N/A` with a
  reason, an API contract or no Ninja surface — and closes: "A story that cannot satisfy these is
  **not ready to be counted towards the sprint**." US010 satisfied none of them on 20/09/2026, not
  all of them on 27/09/2026 or 28/09/2026, and every one from 30/09/2026, when gate `11` closed
  last — see below.

<!-- AMENDED 28/09/2026 at the 16-sprint-plans security sign-off. The bold sentence above read "No
     06-SPRINT-PLAN-06.md is written, and its absence is by rule, not omission", and the sentence
     after it "The record's ledger and the plan's count are two different numbers, and this record
     is at neither trigger", until then. The ledger bullet ended "8 of 11 is not the fill trigger."
     The plan bullet read "The plan counts only stories that have cleared the specify tier: 0" and
     closed "and on 27/09/2026 still does not satisfy them all". "By rule" had already disagreed
     with the call of 21/09/2026 that SPRINT-07's Notes record, and round 1 Q1 of 28/09/2026 made
     the plan owed now. The ledger stays at 8 / 11, and the backlog register does not move. Lifted
     out of the list for the Prettier reason SPRINT-05 recorded on 20/09/2026.
     AMENDED 30/09/2026 at gate 11's close: the count is dated 30/09/2026, when QA-PLAN-US010 was
     signed off, and not from gate 10's sign-off of 28/09/2026, gate 11 closing only at Signed off
     (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9). Q9 moves the day US010 cleared the
     specify tier, not whether it has.
     AMENDED 03/10/2026, when 16-sprint-plans wrote the plan. The bold sentence above read "No
     06-SPRINT-PLAN-06.md is written yet, and it is owed, not omitted.", the second sentence "Two
     calls owe it.", and the sentence before the closing one "`16-sprint-plans` writes it next, in
     a change of its own; this record does not." until then. The plan was written in a change of
     its own, as that sentence said, and this amendment rides in that change rather than making
     one. The Q20 and Q22 sentences are new (settled 03/10/2026, 16-sprint-plans grilling round 9
     Q20 and Q22), and so is the Q4 clause inside the second, placing the story plans after both
     sprint plans, the order SPRINT-07's Notes record for its own two members. The ledger bullet's last clause read "what owes
     the plan is the call, not a fill" until then. The ledger and the plan's count do not move, and
     neither does the backlog register. -->

Measured 20/09/2026. US010 has no ADR and records two ADR candidates in its own `## Decisions` for
`15-decisions` to accept or decline; on that date it was named by no artefact under
`project-management/src/10-SECURITY/` or `project-management/src/11-QA/`, both of which its flags
say it enters, and three name it now — see below; and it has no story plan, `10-` being a
reserved number rather than a file. GDPR, SEO, API, Logging, DB, Backend and Frontend are skipped
by flag.
`project-management/src/16-SPRINT-PLANS/CLAUDE.md` forbids a plan without a matching record — "do
not create an orphan plan" — and nothing forbids a record without a plan; that is a record's
ordinary state between opening and filling.

**`15-decisions` ran for US010 on 21/09/2026.** It records its second candidate and a new read
rule, and declines its first on the record:
`project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` and
`project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`, both written
`Proposed` and accepted in the 27/09/2026 write-back pass, after an independent review and before
the US010 commit (settled 27/09/2026, grilling round 4 Q27 to Q29). Each record's own `**Status:**`
line is the record of that acceptance, not this paragraph: both read `Accepted`, committed with
US010 in `0c5e635` on 27/09/2026, so **the `15-decisions` prerequisite is met**.

<!-- AMENDED 27/09/2026 at the final pass. The paragraph above read "both written `Proposed` and
     accepted in the 27/09/2026 write-back pass" without the qualifier round 4 Q27 set: the
     acceptance follows an independent review and precedes the US010 commit. The qualifier stays
     until each ADR's own Status line flips.
     AMENDED 28/09/2026 at the 16-sprint-plans security sign-off. The last sentence read "both read
     `Proposed` as read on 27/09/2026, and the prerequisite is met when both read `Accepted`" until
     then. 0c5e635, the US010 commit that carried that sentence, committed both records Accepted,
     so it was false as committed; the qualifier above has fired and now stands as the history of
     how the acceptance was made. -->

**Gates `10` and `11` ran for US010 the same day, and three artefacts now name it**, committed with
US010: `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
and `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
under `10-SECURITY/`, and `project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
under `11-QA/`. **All three are written and committed** — with US010 in `0c5e635` on 27/09/2026
— **and the two security plans are signed off.** Each reads `Signed off · corrected in place
28/09/2026`, its Author row closing "reviewed by <%DEVELOPER_NAME%>" (settled 28/09/2026,
16-sprint-plans grilling round 1 Q1 and round 2 Q5); the correction moved no finding, severity or
constraint, the count standing at 0 CRITICAL, 0 HIGH, 4 MEDIUM, 12 LOW and 2 INFO, and no Section 3a
promotion trigger has fired. `project-management/docs/planning/CADENCE.md` requires the security
threat model and assessment complete, not merely written, so **the security prerequisite is met**
from 28/09/2026. Until then it was outstanding — SPRINT-05's reading of its members' `Draft`
security plans on 20/09/2026, an artefact existing not being a gate passing, per
`code/docs/GATE-REPORTING.md`. **The QA prerequisite is met, and gate `11` closed on
30/09/2026.** The QA plan has read `Reviewed` since 27/09/2026, all twenty-three of its gaps
`[RESOLVED]` by then, AC-GAP-2 the last (settled 27/09/2026, grilling round 7 Q34), so
`project-management/src/11-QA/PLANNING/CLAUDE.md`'s bar — no sprint plan while any gap stands
`[OPEN]` — no longer holds it; and it is committed, as
`project-management/workflows/16-sprint-plans/STEPS.md` Step 1 needs. `Reviewed` did not close the
gate: gate `11` closes only when the plan reads `Signed off`, exactly as gate `10` does (settled
30/09/2026, 16-sprint-plans grilling round 3 Q9), and <%DEVELOPER_NAME%> signed it off on
30/09/2026. No procedure writes that rule down yet — `project-management/docs/planning/CADENCE.md`'s
own QA prerequisite is met by a `Reviewed` plan — and US010's gate-`22` pass routes the defect to
`GAPS.md` (Index and Seed Tasks below). **So the plan's count is 8, from 30/09/2026.** The record is
still short of the fill trigger at 8 / 11, and its one member has cleared every prerequisite — the
security plans and the QA plan signed off, both ADRs `Accepted`, and every gate document committed.
The plan was owed by call rather than by a fill, as the plan paragraph above records, and
`16-sprint-plans` wrote it on 03/10/2026.

<!-- CORRECTED 27/09/2026. Two clauses above were true when written on 20/09/2026 and are scoped to
     that date rather than struck: the dated paragraph read "it is named by no artefact under" the
     two gate folders, and the plan bullet closed "US010 satisfies none of them". Gates 10, 11 and
     15 ran on 21/09/2026, and the two paragraphs after the dated one record what moved; their
     artefacts are untracked on 27/09/2026 and are committed with US010, so neither paragraph sits
     beside a claim its own commit makes false. The dated paragraph is otherwise left as written,
     "US010 has no ADR" included — the 15-decisions paragraph answers it.
     AMENDED 27/09/2026 AFTER TWO VERIFIED PASSES OF THAT WRITE-BACK. The gates paragraph said
     "The first two meet the security prerequisite", which both plans' own Status rows contradict,
     and counted "twenty-three gaps, nineteen of them `[OPEN]` as read on 27/09/2026", which the
     write-back overtook the same day. It now states each record's Status as read. The conclusion
     is unchanged: the plan's count stays 0.
     AMENDED 27/09/2026 AT THE FINAL PASS. The QA sentence read "The QA prerequisite is not met
     either: the QA plan reads `Draft`, twenty-two of its twenty-three gaps `[RESOLVED]` 27/09/2026
     and one, AC-GAP-2, `[OPEN]` on grilling round 6 Q34" until then. Round 7 Q34 settled AC-GAP-2
     and the plan reached `Reviewed`. The count still stays 0, now on the security plans, the ADRs
     and the commit rather than on an open gap.
     AMENDED 28/09/2026 AT THE 16-SPRINT-PLANS SECURITY SIGN-OFF. The gates paragraph read "**All
     three are written, none is signed off, and all three are untracked** until the US010 commit —
     measured 27/09/2026. The two security plans each read `Draft` and each says it is not yet
     reviewed by <%DEVELOPER_NAME%>", "so **the security prerequisite is outstanding**", "**The QA
     prerequisite is met in content and not yet as committed**", "but it is untracked until the
     US010 commit", and "**So the plan's count stays 0**, and no sprint plan is written here ... the
     security plans unsigned, the two ADRs not yet `Accepted`, and none of its gate documents yet
     committed" until then. The untracked clauses and the ADR clause were false as committed:
     0c5e635 carried all three artefacts and both ADRs `Accepted` beside this paragraph. The
     security clauses went false at the sign-off (settled 28/09/2026, 16-sprint-plans grilling
     round 1 Q1). The count moves from 0 to 8; the ledger does not move.
     AMENDED 30/09/2026 AT GATE 11'S CLOSE (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9). The QA clause quoted above closes the gate at the plan's sign-off rather than reading a
     plan met in content as met, and the count of 8 is dated from that sign-off, 30/09/2026, not
     from gate 10's of 28/09/2026.
     AMENDED 03/10/2026, when 16-sprint-plans wrote the plan. The paragraph's last sentence read
     "The plan is owed by call rather than by a fill, as the no-plan paragraph above records, and
     `16-sprint-plans` writes it next." until then. Nothing else in the paragraph moves: every
     prerequisite it lists was re-read against its artefact that day and still holds. -->

**This record was opened at gate `03`, not after `10`, `11` and `15`, on SPRINT-05's precedent of
09/09/2026.** SPRINT-03 and SPRINT-04 opened after their members had cleared the specify tier,
because gates `10` and `11` supply the Security and QA sections. This one opens now because the
alternative is a `Must` story in no Story Summary, counted nowhere. The cost is the one the FLAGS
comment names: the Security and QA sections below are first-pass values from the manifest, each
rewritten at its gate's close. That cost is now paid, ahead of either gate's close: gates `10` and
`11` wrote their artefacts on 21/09/2026, grilling settled their open questions on 27/09/2026, and
both sections were rewritten from them that day, the edits having waited while a concurrent session
held this file (grilling round 2 Q9) until the two sessions' holds on each other lifted
(CUT-PLAN.md P9). Their artefacts are committed with US010. Gate `10` is signed off: both
security plans read `Signed off`, reviewed by <%DEVELOPER_NAME%> on 28/09/2026, and the correction
made in place moved no Section 7 constraint, so the Security section below stands as rewritten.
Gate `11` closed on 30/09/2026, when the QA plan was signed off: it had read `Reviewed` with all
twenty-three gaps resolved since 27/09/2026, which did not close it (settled 30/09/2026,
16-sprint-plans grilling round 3 Q9), as the gates paragraph above records. US010's QA criteria
did not move with the sign-off, so the QA sections below stand as rewritten too.

<!-- AMENDED 27/09/2026 AFTER TWO VERIFIED PASSES OF THAT WRITE-BACK. The paragraph above read
     "That cost is now paid: gates `10` and `11` closed on 21/09/2026, and both sections were
     rewritten from them on 27/09/2026" until that day. The gates wrote on 21/09/2026 and are not
     closed; the sections were rewritten from what they wrote.
     AMENDED 27/09/2026 at the final pass: the last sentence read "and the QA plan reads `Draft`
     with AC-GAP-2 `[OPEN]`" until then (grilling round 7 Q34).
     AMENDED 28/09/2026 at the 16-sprint-plans security sign-off. The last sentence read "Neither
     gate is signed off: both security plans read `Draft`, and the QA plan reads `Reviewed` ..."
     until then (settled 28/09/2026, 16-sprint-plans grilling round 1 Q1). "Ahead of either gate's
     close" stays: the sections were rewritten on 27/09/2026, the day before gate 10 closed.
     AMENDED 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9): the gate-11 sentence is new, and dates the close to the QA plan's sign-off, its
     `Reviewed` of 27/09/2026 not closing the gate. "Ahead of either gate's close" still stays:
     gate 11 closed three days after the rewrite. -->

**The citation gate is inherited red, and this record adds its own findings to it — expected, not a
regression.** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
superseded 30/09/2026 by
`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
which restates it unchanged but for the manual testing guide's path, <!-- UPDATED 30/09/2026: successor added beside the superseded record,
which the 18-TESTS split superseded for the manual testing guide's path alone (settled 30/09/2026,
16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
governs: the baseline is captured before the first edit, read as a diff, and "never reported as the
gate passing while the baseline stands". The class is `instance citation` — a record in house style
cites artefacts by full path in backticks, which is not what the gate flags; the bare `US###` and
`SPRINT-##` names are. `copier.yml:157` excludes `/project-management/src/**`, so no record ships <!-- doc-references: template-only -->
and the shipped-file citation rule does not apply to one; that is `GAPS.md`'s entry of 02/09/2026,
whose fix is US004. <%DEVELOPER_NAME%> settled on 20/09/2026 that these findings **wait for US004**
rather than carrying interim `doc-references: template-only` markers. **Nothing is suppressed, and the figures are recorded rather than promised** — this
paragraph pointed at "the measured figures in the Verification Checks below" when none existed,
which an independent review on 20/09/2026 called correctly as worse than silence, and the numbers
below are the repair.

**Measured 20/09/2026, at HEAD `53d9196`, with the whole change staged.**
`bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS` exits
`1` and reports **170 citations that do not resolve** across the folder — **142 instance, 27
dangling, 1 template-only, 0 plan-prefix**. Per file: `CONTEXT.md` 1 · SPRINT-01 17 · SPRINT-02
31 · SPRINT-03 31 · SPRINT-04 26 · SPRINT-05 18 · **SPRINT-06 23** · **SPRINT-07 23**.

**This record's own 23 are instance citations and nothing else — 0 dangling, 0 template-only.**
That matters twice. A `dangling` finding would be this record's own defect, a path it wrote that
does not resolve, and there are none. The `instance` class is the inherited one US004 fixes: a
record in house style cites artefacts by full path in backticks, which the gate does not flag, and
the bare `US###` and `SPRINT-##` names it does flag are unavoidable in a record whose subject is
stories and sprints.

**The figure is index-dependent, and the index state is part of the number.** The gate decides
whether a citing file ships in `build_template_only`, which reads `git ls-files`: an untracked file
is not recognised as copier-excluded, `file_ships` stays true, and every citation it makes of a
per-project artefact is reported as template-only. Every figure above is measured with the whole
change staged, and a re-measurement is only comparable in that state — SPRINT-05's finding of
09/09/2026, which measured 21 untracked and 6 staged.

**This change demonstrated it again, and the numbers are recorded because they are the proof.**
Unstaged on 20/09/2026 this record measured **19** template-only findings and
`project-management/src/03-SPRINTS/SPRINT-07.md` **4**; staged, both read **0**. Those 23 were the
artefact of the index and never citations either record owed. An independent review measured the
unstaged state and reported them, which is the correct reading of what it saw — the index state is
part of the number, and a figure quoted without it is not comparable to one that has it.

---

## Acceptance Criteria

One outcome, one member.

**US010** — the seven registers that accumulate instances each carry an index file named for the
folder's own noun, singularised, sharing one spine of `Status · Instance · Summary · Updated` and
stating its own tail columns and ordering rule; `MAP-INDEX.md` carries one row per map counted from
the tree at implementation time, and every map's `**Status**` header reads one of the five enum
values, written plain and derived from the map's own counts — a charted map with no node resolved
and `Blocking open` 0 reading `Blockers clear — stories may start`, never `Charting` — with any
existing prose after a middle dot rather than an em-dash; the four indexes this story does not backfill ship declaring their own
debt and naming US011, while `FINDING-INDEX.md` and `BUG-INDEX.md` are legitimately empty, unless
their register gains an instance before the build, and name no debt; a generated project receives
all seven blank, bar the map index's one seeded row, seeded once inside the existing `copy` gate so
no `copier update` can overwrite a filled one, with `.github/scripts/shipped-artefacts.sh`
admitting all seven; the map index leaves `project-management/src/01-FEATURE-MAPS/CONTEXT.md` and
every register's `CONTEXT.md` routes to its own index; every shipped site that still instructs the
old index row stops doing so, all three decline rationales disposed of rather than only the one
with an owner; the story-plan register stops permitting a programme plan outside the workflows;
and the template guide counts the seeded files truly, its updating guide saying what an existing
project and a recopy receive.

<!-- AMENDED 27/09/2026 with US010's write-back of gates 10, 11 and 15, against US010's own
     Acceptance Criteria lead as it then stood. The paragraph read "begins with one of the four
     enum values separated from any existing prose by a middle dot" and "the six shipped sites that
     still instruct the old index row stop doing so" until that day. The enum gained a fifth value,
     Not started, written plain (the enum-prefix ADR of 21/09/2026), each value tested against the
     map's own counts (settled 27/09/2026, grilling round 3 Q18); gate 11 measured twenty-four
     sites in thirteen shipped files where the story had six (AC-GAP-1, AC-GAP-20). The seed-count
     and updating-guide clauses are new (Q14, Q15), the seeded map-index row is round 1 Q4's, and
     the finding and bug proviso is the story's own re-count at implementation.

     AMENDED AGAIN 27/09/2026 from grilling round 6, against US010's lead as it then stood. The
     enum clause gains the one overlap two of Q18's tests left, resolved for Blockers clear
     (settled 27/09/2026, grilling round 6 Q31). The programme-plan clause is new: a cross-cutting
     programme plan is no register's instance and is permitted in neither syntek-base nor a
     generated project, every artefact following one of the 24 project-management/workflows/, and
     US010 removes the permission from the three shipped 17-STORY-PLANS files (Q32, Q33). -->

### Security Acceptance Criteria

<!-- The template's rows name runtime controls — rate limits, audit rows, HTML escaping, ABAC — and
     the member ships Markdown, a YAML `_tasks` block, one bash array, two CI scripts and one CI
     workflow step: no endpoint, no model, no session. Gate `10` ran on 21/09/2026: the eight
     criteria below are Sections 7.1 to 7.8 of
     project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md,
     ST01 to ST05 kept by number — ST01's consequence and ST02's rationale corrected, ST05's
     allowlist widened — and ST06 to ST08 added; nothing was renumbered. It raised 0 CRITICAL, 0
     HIGH, 4 MEDIUM, 12 LOW and 2 INFO, three of them left unsettled for the developer (assessment
     Section 8); the absence of a blocking finding is a recorded outcome with its reason
     (code/docs/GATE-REPORTING.md). Until 27/09/2026 this comment called the rows the manifest, the
     `ST` numbers "confirmed or renumbered by `10-security-checks`", and the gate "not yet entered".

     AMENDED 27/09/2026 from grilling round 3, against US010's criteria as they then stood. The
     three unsettled findings are settled: assessment 7.13, the seed-count sites, by ST05's second
     widening (settled 27/09/2026, grilling round 3 Q14); 7.14 and 7.15 by US010's updating-guide
     statement, their complete fixes routed to GAPS.md through gate `22` (Q15). ST07's three
     gate-added obligations are settled (Q16), and where gate `11`'s QA plan held them "awaiting
     sign-off", the security wording here wins. 7.9, 7.10 and 7.12 ride the two ADRs, US010's Index
     and Map Tasks and US012, and 7.11 the S-03 sequencing and its GAPS.md route (CUT-PLAN.md P8;
     Q21); none of the four is an `ST`.

     AMENDED 27/09/2026 at the final pass, following US010's ST03 as it now stands. The ST03 row
     gains the seed-row clause and its probe, the host QA-PLAN-US010 AC-GAP-2 proposed for
     assessment 7.4's one permitted row (settled 27/09/2026, grilling round 7 Q34, option 1). It is
     a clause in the settled third family, not a second family, so round 2 Q12's trigger is not
     reached, and no `ST` is added or renumbered.

     SIGNED OFF 28/09/2026. <%DEVELOPER_NAME%> signed off both gate-10 plans that day, each
     corrected in place (settled 28/09/2026, 16-sprint-plans grilling round 1 Q1 and round 2 Q5).
     No row below moves: the correction moved no finding, severity or constraint, so Sections 7.1
     to 7.8 read as they did, and signing off ticks none of them — each is ticked at close against
     the implementation assessment's evidence. The last-but-one row gains the sign-off; see the
     comment beneath the list. -->

- [ ] **Seed-once integrity** — all seven `_tasks` `mv` lines sit inside the one existing entry
      whose `when:` key tests `_copier_operation == 'copy'`, no second task, asserted in the diff,
      by the new `shipped-registers.sh` family and by the update probe. An ungated line would run in
      all three of Copier's update renders, and the project's own diff would be replayed over the
      overwrite: invisible when the seed is unchanged between versions; when it has changed, the
      register altered in silence or left with conflict markers. Consequence corrected at gate `10`;
      the criterion holds on `update`, and `copier recopy` is assessment 7.15, not this row
      (US010/ST01)
- [ ] **Ordering inside the task** — all seven `mv` lines land **before** `rmdir .copier` in the
      same `&&` chain, and that line stays `rmdir`. A line after it fails generation loudly: `rmdir`
      exits 1 on a non-empty directory, the chain aborts and Copier raises `TaskError`; rationale
      corrected at gate `10` (US010/ST02)
- [ ] **No seed cut from a populated in-tree index** — each seed authored blank, or for the map
      index with exactly one row, reading `Not started`, and the emptiness **proved by a check, not
      trusted**: a third family in `.github/scripts/shipped-registers.sh`, each check with a
      self-test probe. Its seed-row clause asserts that one row's `Status`, read under the read
      rule, string-equals the scale-planning seed's own `**Status**` header
      (`.copier/MAP-SCALE-PLANNING.md:4`), its probe a mutated seed pair yielding exactly one
      finding — a clause in that family, not a second one, so round 2 Q12's trigger is not reached
      (settled 27/09/2026, grilling round 7 Q34) (US010/ST03)
- [ ] **No seed names a syntek-base instance** — map, story, sprint, decision, plan, finding or
      bug, and none carries the `Backfill owed` line. A seed cut from this repository's own rows
      ships that content permanently and no later update can correct it. The map-index seed's one
      row mirrors the seeded map — `Status` `Not started`, its link, a generic or `TBD` Summary,
      `Updated` `TBD` — and the generated-tree grep is the check (US010/ST04)
- [ ] **No new reach** — no network fetch, no credential read, and no write outside
      `project-management/src/`, `.copier/`, `copier.yml`, `.github/scripts/shipped-artefacts.sh`,
      `.github/scripts/shipped-registers.sh`, `.github/scripts/shipped-ai.py`,
      `.github/workflows/audit-template.yml`, `.claude/skills/wayfinder/SKILL.md`,
      `project-management/workflows/`, `how-to/src/TEMPLATE-GUIDE/` and
      `how-to/src/TEMPLATE-TOKENS.md` — widened by the three CI paths at gate `10`, and by the last
      three on 27/09/2026 so that US010 corrects every shipped site gate `11` inventoried and the
      seed-count sites, the `--trust` disclosure among them (settled 27/09/2026, grilling round 3
      Q14); every existing self-test probe passes unchanged (US010/ST05)
- [ ] **No negation re-includes an index path** — matched with `_exclude`'s own glob semantics,
      never by string equality, with probes planting a literal and a glob-form negation; the
      generated-tree check admits a seeded path by name and cannot see this leak (US010/ST06)
- [ ] **An update probe that can fail** — the `shipped-ai.py` fixture creates the six register
      folders, and every edited index survives an update: the probe changes every index seed
      between its tags, asserts byte-identity, and goes red with the seed task's gate removed
      (settled 27/09/2026, grilling round 3 Q16) (US010/ST07)
- [ ] **One-line form** — every line is `mv .copier/<NOUN>-INDEX.md`, its register target, then
      `&&`: no flag, no quoting, no `|| true`, no split across the folded scalar, because the three
      consumers of the line each parse it their own way (US010/ST08)
- [ ] **No CRITICAL or HIGH finding is open** — gate `10` ran on 21/09/2026 and raised none, and
      both its plans were signed off on 28/09/2026 at the same count, with no Section 3a trigger
      fired (settled 28/09/2026, 16-sprint-plans grilling round 1 Q1); ticked at close unless a
      promotion trigger in the threat model's Section 3a fires during the sprint
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

<!-- AMENDED 28/09/2026 at the 16-sprint-plans security sign-off. The CRITICAL-or-HIGH row read
     "gate `10` ran on 21/09/2026 and raised none; ticked at close unless ..." until then, without
     the sign-off. It stays unticked: the sign-off closes the planning gate, and the row still
     binds the sprint, ticked at its close. Lifted out of the list for the Prettier reason SPRINT-05
     recorded on 20/09/2026. -->

### QA Acceptance Criteria — Automated

<!-- Rewritten 27/09/2026 from gate 11, which wrote
     project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md on 21/09/2026,
     and from grilling round 3 of 27/09/2026 (Q16, Q23). Until that day this comment read
     "First-pass from the manifest; no QA-PLAN-US010-* exists", and the rows below were four. That
     plan reads Reviewed on 27/09/2026, all twenty-three of its gaps resolved into the story,
     AC-GAP-2 the last (grilling round 7 Q34). AMENDED 27/09/2026 after two verified passes of
     the write-back: the first line read "from gate 11, which closed 21/09/2026 with".
     AMENDED 27/09/2026 at the final pass. The plan's state read "Draft on 27/09/2026, twenty-two
     of its twenty-three gaps resolved into the story and AC-GAP-2 awaiting grilling round 6 Q34"
     until then. The shipped-registers.sh row gains the seed-row clause's probe, as US010's own
     criterion names it, which automates QA-PLAN-US010 HP-03's Status half (round 7 Q34). -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` passes with the enlarged `SEEDED`
      array — proving the eight entries are not reported as leaks, never that they landed
- [ ] `bash .github/scripts/shipped-registers.sh --self-test` passes — the nine existing probes
      unchanged, and one probe per new check, each seen red before it is seen green (US010/ST03,
      ST06). The seed-row clause's probe is among them: a mutated seed pair, the map-index seed's
      row and `.copier/MAP-SCALE-PLANNING.md:4` disagreeing, yields exactly one finding, so the
      seed row's Status agreement is automated at template time rather than read by hand in a
      generated tree (settled 27/09/2026, grilling round 7 Q34)
- [ ] The `[3/4] Template Generation` job generates a project on **every render path the template
      offers** (today: `INCLUDE_MOBILE` false and true), and its completeness step lists all seven
      landed index paths, present in each generated tree
- [ ] `bash .github/scripts/shipped-ai.sh --self-test` passes with the fixture creating the six
      register folders: every copy lands all seven indexes, and after `run_update` to a tag that
      changed every index seed, every edited index is byte-identical to the project's committed
      edit; a mutation removing the seed task's copy gate turns it red (US010/ST07)
- [ ] A grep over each generated tree finds no `US###`, `SPRINT-##`, `ADR-US###` or `MAP-<FEATURE>`
      literal inside any index file, bar the map index's seeded MAP-SCALE-PLANNING.md row, each
      file's own name and the `000` template identifiers
- [ ] Every Markdown link target in the seven in-tree indexes and the seven generated ones resolves
      from the file's own folder
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes — every register folder still carries
      its `CONTEXT.md` + `CLAUDE.md` pair, and an index file is not mistaken for one
- [ ] `bash code/src/scripts/audits/docs-length.sh` passes — the seven `CONTEXT.md` files each gain
      a section, and none crosses the 300-line ceiling or the 270 ratchet without a dated allowance
- [ ] Coverage floors — **N/A**, and marked rather than deleted. The member ships Markdown, YAML,
      bash and one edit to the CI probe `.github/scripts/shipped-ai.py`; the Backend flag reads
      `N/A`, and the one Python file is a template-only CI script outside `code/src/django/`, so the
      floor has nothing to bind. Unlike `project-management/src/03-SPRINTS/SPRINT-05.md`, whose
      member ships settings modules: that record does not mark the row `N/A`, and makes no floor
      claim on the modules, which are configuration with no branch to cover, the suite being read
      as a regression

<!-- CORRECTED 30/09/2026. The coverage row above ended "Unlike
     `project-management/src/03-SPRINTS/SPRINT-05.md`, which left this open because its member
     shipped settings modules" until then. That was true when written on 27/09/2026 and is not
     now: SPRINT-05's row was amended on 28/09/2026 to make no floor claim, the reading US008's own
     Verification Checks had stated since 09/09/2026, and that amendment is committed in the same
     change as this correction. The contrast stands; only its description of SPRINT-05 moved.
     Lifted out of the list for the Prettier reason SPRINT-05 recorded on 20/09/2026. -->

### QA Acceptance Criteria — Manual

<!-- Manual is load-bearing here: a row's Summary is prose written for a human, and no script can
     judge whether one line of plain English describes a map to someone who has not read it. That
     bar is `N-002`'s, not this record's. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/MANUAL/US010-MANUAL-TESTING.md` carries a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in the member's QA plan,
      `project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`, written at
      gate `11` on 21/09/2026. The row stays unticked while any of that plan's gaps is `[OPEN]`, and
      an unticked row is not a pass

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Index and Seed Tasks

<!-- The template has no documentation-tasks section, and the member's deliverable is documentation
     plus a generation seam — so its index, seed and documentation work is carried here on
     SPRINT-05's precedent, which carried US008's five-guide rewrite under its Backend Tasks. -->

| Story | Task                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Done |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US010 | Design the shared spine once, and each register's tail columns and ordering rule; state the order in every file, with the dates and tie-breaks of grilling round 3 Q17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | [ ]  |
| US010 | Create all seven index files in-tree on the `23-INCIDENTS/INCIDENT-INDEX.md` shape                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | [ ]  |
| US010 | Backfill `MAP-INDEX.md` one row per map, **re-counting the folder at implementation time** under the positive instance pattern (grilling round 3 Q22) — the count moved 14 to 15 at cutting                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [ ]  |
| US010 | Add the `Backfill owed — US011` line to four indexes, and **not** to `FINDING-INDEX.md` or `BUG-INDEX.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | [ ]  |
| US010 | Author seven `.copier/` seeds, the six non-map ones carrying only the placeholder row; give `.copier/MAP-INDEX.md` its one row mirroring the seeded map, `Not started` (grilling round 1 Q4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [ ]  |
| US010 | Add seven `mv` lines to the `_tasks` entry, ahead of `rmdir .copier`, inside the existing `copy` gate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [ ]  |
| US010 | Grow `SEEDED` in `.github/scripts/shipped-artefacts.sh` from one entry to eight, and reword the comment above it as the allowlist check 3 reads; whichever of US010 and US012 lands second extends the other's wording                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | [ ]  |
| US010 | Add the seven landed index paths to the `[3/4]` completeness step                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | [ ]  |
| US010 | Give `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4` the fifth value, the format and each value's test from the map's own counts (grilling round 3 Q18), `Blockers clear` winning the one overlap (grilling round 6 Q31)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | [ ]  |
| US010 | Rewrite every map's `**Status**` header to `<enum>` or `<enum> · <prose>`, one of five values, plain, derived by measurement                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [ ]  |
| US010 | Tick or re-justify every map's `Gate to stories` index-row box, disposing of **all three** decline rationales                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [ ]  |
| US010 | Sweep every map's `Umbrella ADRs` row                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [ ]  |
| US010 | Replace `## Map index` in `01-FEATURE-MAPS/CONTEXT.md`; add or rewrite the `## The index` H2 in the other six; leave `23-INCIDENTS`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [ ]  |
| US010 | Repoint every shipped instruction site in the story's site scenario, the `project-management/workflows/` sites included (ST05 widened a second time, grilling round 3 Q14)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | [ ]  |
| US010 | Add wayfinder's chart-step line: writing a map's first node fills its `**Charted**` date and writes the value its counts give — `Charting` while `Blocking open` is above 0, otherwise `Blockers clear — stories may start` — never asserting `Charting` (grilling round 3 Q24; round 6 Q31; reconciled by the call recorded 27/09/2026)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [ ]  |
| US010 | Correct the seven sites that count the seed task's files as nine, the `--trust` disclosure at `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22` among them, merging ahead of US015 (grilling round 3 Q14)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | [ ]  |
| US010 | Remove the `PLAN-<DESCRIPTOR>.md` programme-plan permission from its seven sites in the three shipped `17-STORY-PLANS/` files — `CLAUDE.md`, `CONTEXT.md` and the story-plan template (grilling round 6 Q32, Q33)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | [ ]  |
| US010 | Document TM-14 and TM-18 in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`, promising no fix the template does not ship (grilling round 3 Q15)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | [ ]  |
| US010 | Re-measure the Plans Index citation population from the tree as it stands, per `US007.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | [ ]  |
| US010 | At this story's `22-implementation-documentation` pass, the sole writer of `GAPS.md`, open one entry for the prerequisites a sprint plan checks, which do not state the gates as they are settled. It names three defects. (1) The flag-blind Security prerequisite. (2) The flag-blind GDPR prerequisite. (3) The unwritten rule that gate 11 closes only when a QA plan reads `Signed off`, as gate 10 now does. The entry is dated the day gate 22 writes it, not the day any of its answers was settled. Routed here, not fixed here — each defect's sites are named in `project-management/src/02-STORIES/US010.md` -> Tasks (settled 28/09/2026, 16-sprint-plans grilling round 1 Q2; the GDPR bullet by the call recorded 28/09/2026 at that gate; settled 30/09/2026, 16-sprint-plans grilling round 3 Q9, the routing of the gate-11 rule here a call made 30/09/2026 while applying it, not one of its answers, accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16) | [ ]  |
| US010 | **Verify, do not re-cut** the `S-01`, `S-02` and `S-05` rows on `MAP-REGISTER-INDEXES.md`, against the wording of the map's 27/09/2026 RESOLVE sitting (grilling round 5 Q30)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [ ]  |

<!-- AMENDED 27/09/2026 with US010's write-back of gates 10, 11 and 15 and grilling rounds 3 to 5,
     against US010's own Tasks as they then stood. Three rows read otherwise until that day: the
     seed row gave the map-index seed "its one `TBD` row", the header row said "Prefix every map's
     `**Status**` header with its enum value", and the site row read "Repoint the six instruction
     sites" and named three files. Six rows are new: the completeness step, the template's fifth
     value and criteria (Q18), the Umbrella ADRs sweep, the wayfinder line (Q24), and the
     seed-count sites and the updating guide (Q14, Q15). Four rows gain a clause: the tie-breaks
     on the spine row (Q17), the instance test on the backfill row (Q22), the comment rewrite on
     the SEEDED row, and the RESOLVE sitting on the verify row (round 5 Q30). The third seed
     family and the `shipped-ai.py` extension are rolled up once, under Security Tasks, as US010
     lists them, and not again here or under QA Tasks.

     AMENDED AGAIN 27/09/2026 from grilling round 6 and the calls of that day, against US010's own
     Tasks as they then stood. The template row gains Q31's resolution of the one overlap its tests
     left, Blockers clear winning. The SEEDED row read "reword the comment above it as the
     allowlist check 3 reads, for US012 to extend", which fixed a landing order CUT-PLAN.md P9 never
     set; it now carries the in-either-order rule. One row is new: the programme-plan permission
     leaves its seven sites — project-management/src/17-STORY-PLANS/CLAUDE.md:11, :72 and :81-82;
     project-management/src/17-STORY-PLANS/CONTEXT.md:18 and :25;
     project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md:254 and :714-715 —
     every file already in the write set, and ST05 already admitting project-management/src/ (Q32,
     Q33). CORRECTED 30/09/2026: the sites read "17-STORY-PLANS/CLAUDE.md:11, :72 and :79-80;
     17-STORY-PLANS/CONTEXT.md:18 and :25; 00-STORY-PLAN-US000-TEMPLATE.md:254 and :713-714" until
     then, measured 27/09/2026. The 18-TESTS split, committed together with this correction, moves
     two of the seven down, the text unchanged; re-measured 30/09/2026 against the tree committed
     together with it.

     AMENDED A THIRD TIME 27/09/2026, at the final pass, against US010's wayfinder task as it now
     stands. The wayfinder row read "writing a map's first node moves it from `Not started` to
     `Charting` (grilling round 3 Q24)" until then. Round 3 Q24 settled who moves a map out of Not
     started, the chart step; round 6 Q31 settled the value by counts. So the step fills Charted
     and writes the value the counts give, Charting while Blocking open is above 0 and otherwise
     Blockers clear — stories may start, never asserting Charting (the Q24 x Q31 reconciliation,
     call recorded 27/09/2026 and announced to the developer). The seed-row clause (round 7 Q34)
     is rolled up under Security Tasks with the rest of its family, not here.

     ONE ROW ADDED 28/09/2026, at the 16-sprint-plans gate: the GAPS.md entry above the verify
     row (settled 28/09/2026, 16-sprint-plans grilling round 1 Q2). Security is read by its flag.
     project-management/workflows/16-sprint-plans/STEPS.md Step 1, the security line of
     project-management/workflows/16-sprint-plans/CHECKLIST.md, and
     project-management/docs/planning/CADENCE.md -> When a sprint plan is written each demand the
     security gate's work — a threat model and assessment, or security checks complete — of every
     story, with no flag condition. That guide's own rule, "A downstream checklist reads the flag",
     requires any such box to be written "for every in-scope story whose <flag> is not `N/A`",
     here the Security flag. The defect is routed to GAPS.md rather than repaired here: round 1
     Q2 routes it through US010's gate-22 pass, gate 22 being the only writer of GAPS.md, so the
     row is keyed US010. It sits in this table because the entry is documentation work, which
     this table carries for the member, on US011's precedent for the TM-10 entry in
     project-management/src/03-SPRINTS/SPRINT-07.md -> Measurement and Backfill Tasks. The row
     mirrors the Documentation Task added the same day to
     project-management/src/02-STORIES/US010.md -> Tasks.

     THE SAME ROW WIDENED 30/09/2026, with the story's task. Its one entry names three defects:
     the Security one above; the GDPR prerequisite that
     project-management/docs/planning/CADENCE.md states with no flag condition, where Step 1 and
     the checklist already read the flag (the call recorded 28/09/2026 at that gate); and the
     unwritten rule that gate 11 closes only when a QA plan reads Signed off (settled 30/09/2026,
     16-sprint-plans grilling round 3 Q9; its routing here a call made 30/09/2026 while applying it, not one of its answers, accepted, settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). Every sentence of the row is the story's own wording,
     bar the pointer back to the story before the citations; the row stops short of the story's
     site-by-site detail, which stays in the story, as this section's rollup rule says. -->

### Security Tasks

| Story | Task                                                                                                                                                                                                                                                                                                                                                                                 | Done |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- |
| US010 | Assert all seven `mv` lines inside the `copy` gate, ahead of `rmdir .copier`, in the one-line form (ST01, ST02, ST08)                                                                                                                                                                                                                                                                | [ ]  |
| US010 | Add the third seed family to `shipped-registers.sh` — seed present, `mv` line in the copy-gated task, blankness, the map-index seed row's `Status` string-equal under the read rule to `.copier/MAP-SCALE-PLANNING.md:4`, and the glob-matched no-negation clause, each check with a probe seen red first, the seed-row probe a mutated seed pair (ST03, ST06; grilling round 7 Q34) | [ ]  |
| US010 | Confirm no seed names a syntek-base map, story, sprint, decision, plan, finding or bug, and none carries a debt line (ST04)                                                                                                                                                                                                                                                          | [ ]  |
| US010 | Confirm the change adds no network fetch, no credential read and no write outside the eleven named paths, the list widened twice (ST05)                                                                                                                                                                                                                                              | [ ]  |
| US010 | Extend `shipped-ai.py` — six register folders, all seven indexes asserted present after every copy, a seed-changing byte-identity update probe, proved red with the gate removed (ST07)                                                                                                                                                                                              | [ ]  |
| US010 | Close assessment 7.1 to 7.8 and 7.13 to 7.15 with evidence; 7.9, 7.10 and 7.12 ride the two ADRs, US010's Index and Map Tasks and US012, and 7.11 the `S-03` sequencing and its `GAPS.md` route                                                                                                                                                                                      | [ ]  |

<!-- AMENDED 27/09/2026 from gate 10's assessment and grilling round 3. Until that day the list
     named "the five named paths" and ended "Satisfy the developer constraints gate `10` produces,
     once it has run"; the gate has run, and its Sections 7.1 to 7.15 are the constraints. ST05
     names eleven paths after two widenings (gate 10; Q14), ST06 to ST08 are new, and 7.13 to 7.15
     are settled (Q14, Q15).
     AMENDED 27/09/2026 at the final pass, following US010's Security Tasks as they now stand. The
     third-family row read "blankness and the glob-matched no-negation clause, each check with a
     probe seen red first (ST03, ST06)" until then; it gains the seed-row clause and its probe, a
     clause in that family and not a second one (settled 27/09/2026, grilling round 7 Q34). -->

### QA Tasks — Automated

- [ ] US010 — run `shipped-artefacts.sh --self-test` with the enlarged `SEEDED` array, output
      recorded in `project-management/src/18-TESTS/AUTOMATED/US010-TEST-STATUS.md`
- [ ] US010 — add the generated-tree grep asserting no syntek-base literal appears in any index, on
      **every render path the template offers** (today: `INCLUDE_MOBILE` true and false)
- [ ] US010 — add the link check over the seven in-tree and the seven generated indexes
- [ ] US010 — run `docs-pairing.sh` and `docs-length.sh` over the changed tree, and read
      `doc-references.sh` as a diff against the pre-edit baseline

<!-- AMENDED 27/09/2026 from gate 11. The update probe row read "US010 — add the `copier update`
     probe asserting no index is reverted to its seed" until that day; it now lives in the
     Security Tasks row that extends `shipped-ai.py`, seeds changed between tags, byte-identity
     asserted and red with the gate removed (ST07; grilling round 3 Q16), with the seed family and
     the completeness step likewise listed once rather than here. The grep names every render path
     rather than two poles (Q23). -->

### QA Tasks — Manual

- [ ] US010 — row-by-row walk-through of MAP-INDEX.md against the maps as they then stand,
      recorded: every Status string-equals its map's header under the read rule, every `Updated`
      equals its map's last commit date, and every tail count equals its source
- [ ] US010 — enum derivation walk-through across every map, with the reasoning for each value
      recorded against its count-derived test (grilling round 3 Q18) — which are `Complete`, which
      are `Blockers clear — stories may start`, a charted map with no node resolved and
      `Blocking open` 0 among them and never `Charting` (grilling round 6 Q31), and why a map with
      open fog is not `Complete`
- [ ] US010 — re-read of every repaired instruction site, with the joined-line search recorded
- [ ] US010 — re-read of the seven seed-count sites and the updating guide's two statements against
      `copier.yml`, recorded (grilling round 3 Q14, Q15)
- [ ] US010 — re-read of the seven programme-plan sites in the three `17-STORY-PLANS/` files,
      recorded (grilling round 6 Q33)
- [ ] US010 — Umbrella ADRs sweep, row by row, recorded
- [ ] US010 — the four incomplete indexes read as incomplete-and-owned rather than
      empty-and-correct, by a reader who has not read the story
- [ ] US010 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is added

<!-- AMENDED 27/09/2026 from grilling round 6, against US010's QA Tasks and manual criteria as they
     then stood. The enum walk-through row gains Q31's resolution — a charted map with no node
     resolved and Blocking open 0 is recorded as Blockers clear, never Charting — and the
     programme-plan re-read row is new (Q33). Lifted out of the list for the Prettier reason
     SPRINT-05 recorded on 20/09/2026. -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The checks with nothing to look at are marked N/A with a reason rather than deleted: per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. Unlike
     project-management/src/03-SPRINTS/SPRINT-05.md this sprint's one Python edit is a CI probe
     outside basedpyright's include (`pyproject.toml:184`), so the type-check leg has nothing to
     read. It read "this sprint ships no Python" until 27/09/2026, before gate 11 counted the
     `shipped-ai.py` probe (settled 21/09/2026, grilling round 1 Q3). -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` exits 0 with the enlarged `SEEDED`
      array
- [ ] `bash .github/scripts/shipped-registers.sh --self-test` and
      `bash .github/scripts/shipped-ai.sh --self-test` exit 0 — the nine existing registers probes
      and the existing ai probes unchanged, and the new ones seen red first, the seed-row probe
      among them: a mutated seed pair yielding exactly one finding (grilling round 7 Q34)
- [ ] **The `[3/4] Template Generation` job is green on every render path the template offers**
      (today: `INCLUDE_MOBILE` true and false) — all seven index files present in each generated
      tree, six of them with no instance rows
- [ ] `bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS`
      — **the scoped run, and the one this record was measured on.** At the gate that opened this
      record (20/09/2026, HEAD `53d9196`, whole change staged) it exits `1` with **170** citations
      that do not resolve across the folder — 142 instance, 27 dangling, 1 template-only, 0
      plan-prefix — of which **this record contributes 23, all of them the inherited instance
      class and none of them dangling**. The Notes carry the per-file split. **The criterion for
      this sprint is that this record's `dangling` count stays at 0**: a dangling finding is a path
      this record wrote that does not resolve, and it is the only class here that would be this
      record's own defect. The scoped run completes in about 45 seconds, so there is no excuse for
      reporting it unmeasured
- [ ] `bash code/src/scripts/audits/doc-references.sh` (whole tree) — **read as a diff against the
      baseline captured before the first edit**, per ADR-US003, and never as a bare pass while that
      baseline stands. If US004 — SPRINT-03's sole `Must`, built before this sprint — has landed and
      the gate has gone green, the plain-pass reading applies; both branches are named, as SPRINT-04
      named them for US005 and SPRINT-05 for US008. The story re-captures its own baseline
      immediately before its first edit, in the index state it will be measured in.
      **NOT RUN at the gate that opened this record**, and that is stated rather than left to be
      inferred from the scoped figure above: the whole-tree pass takes over ten minutes against the
      45 seconds the scoped one takes, and it was not completed on 20/09/2026. Per
      `code/docs/GATE-REPORTING.md` an unmeasured gate is reported, never passed — the folder figure
      above is not a whole-tree figure and must not be quoted as one
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance. **Files to watch: the seven `CONTEXT.md` files under
      `project-management/src/`, each of which gains a section, and the
      `project-management/workflows/` files the site repair edits (grilling round 3 Q14).** The
      guard is the gate's reading at implementation time, not a literal in this file — `GAPS.md`'s
      entry of 17/09/2026 records what a bare line count costs.
      `code/src/scripts/audits/CONTEXT.md` is US002's headroom and is not touched by this sprint
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — **more than regression here.** The member
      adds a third `.md` file to seven directories that each carry a `CONTEXT.md` + `CLAUDE.md`
      pair, and the check must confirm an index file is not mistaken for either half
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. A green run says the
      registered claims are undisturbed and says **nothing** about the seven indexes agreeing with
      the registers they describe; it is never reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, the member adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — markdownlint-cli2 over the seven new index
      files, the seven `CONTEXT.md` files and every map whose header gains an enum prefix.
      **ShellCheck over the changed `shipped-artefacts.sh` and `shipped-registers.sh` is what a
      widened script asks for and `lint.sh` does not carry it**: its legs are ruff,
      markdownlint-cli2, ESLint and clippy, and no script under `code/src/scripts/`, no CI workflow
      and no lefthook entry runs ShellCheck. It is recorded in
      `project-management/src/18-TESTS/MANUAL/US010-MANUAL-TESTING.md` as run or as not run, never as a
      `lint.sh` pass, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **regression only.** Its basedpyright leg
      reads `code/src/django/` only (`pyproject.toml:184`), and this sprint's one Python edit,
      `.github/scripts/shipped-ai.py`, sits outside it; run so that the absence is measured rather
      than assumed, and record the probe's own lint as run or not run
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, the sprint's DB flag reads `N/A`
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — the suite runs as a regression and passes;
      the coverage floor has nothing to bind, the sprint adding no application Python
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, against gate `10`'s assessment,
      Sections 7.1 to 7.8 and 7.13 to 7.15, which the rows above carry since 27/09/2026; until
      then they were the manifest, not the sign-off
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

<!-- AMENDED 27/09/2026 at the final pass. The self-test row ended "and the new ones seen red first"
     until then; it now names the seed-row probe, as US010's own Verification Checks do (settled
     27/09/2026, grilling round 7 Q34). Lifted out of the list for the Prettier reason SPRINT-05
     recorded on 20/09/2026. -->

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its own
      DoD complete) — US010 alone, this record having no stretch tier at opening
- [ ] **The carry-over question is disposed of in writing, either way.** US009's 5 SP `Should` carry
      is reserved to this record by `project-management/src/03-SPRINTS/SPRINT-05.md`'s Definition of
      Done. If US009 carried here, it is **Completed** here or explicitly carried on again with its
      reason recorded in both records and in `project-management/src/02-STORIES/US009.md` — a
      `Should` is never dropped silently, and the backlog register is updated in every copy in the
      same change. If it did not carry, that is stated here rather than left as an unexplained
      8 / 11. **In the carry case this record stands at 13 / 11 and at grace**, which is the reading
      the capacity line above already licenses
- [ ] **The carry has a deadline, and it is this record's close.** If US009 is still undecided when
      this record would otherwise close, the close waits on that decision or the reservation is
      released in writing — a reservation with no expiry silently holds 5 SP of a record's give
      forever. **If US009 is dropped AFTER this record has closed**, its points do not land here:
      the drop is recorded in `project-management/src/03-SPRINTS/SPRINT-05.md` and the story is
      carried into whichever record is open at that moment, or recorded as owed and unplaced if
      none is. Build order makes that ordering unlikely — US009 builds ninth and US010 tenth — but
      unlikely is not impossible, and it is stated rather than left to be decided at the keyboard
- [ ] **A landed carry re-opens the sprint plan, written 03/10/2026.**
      `project-management/docs/planning/SPRINTS.md` -> _Two artefacts, two moments_ makes the plan
      "written once, against a settled story set", so a carry arriving now that
      `project-management/src/16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` exists un-settles that set: the
      plan is revised in the same change that admits the story, never left describing a one-member
      sprint that now has two. The same change swaps US010's and US009's story-plan prefixes, as
      that plan's _Build order_ states
- [ ] **Nothing else carries into this record.** SPRINT-01, SPRINT-02 and SPRINT-04 are closed with
      nothing reserved out of them, and SPRINT-03's reservation runs into SPRINT-03. If a story
      arrives anyway it is recorded in both records with its reason and the capacity line
      recomputed — a second `Must` of 8 would be 16 / 11 and is refused on arithmetic before it is
      argued
- [ ] **This record unblocks US011 in `project-management/src/03-SPRINTS/SPRINT-07.md`**, which
      has nothing to edit until the seven index files exist. Confirmed rather than assumed at close:
      the four indexes US011 backfills exist and carry their `Backfill owed — US011` line

<!-- 21/09/2026: the row above read "unblocks `project-management/src/03-SPRINTS/SPRINT-07.md`**,
     whose sole member has nothing to edit" until US012 was admitted there as its `Must`. US012
     waits on nothing in this record — it and US010 edit one script in either order — so the edge
     runs to US011 alone. Nothing else in this record moved with that admission except the backlog
     register. Lifted out of the list for the Prettier reason SPRINT-05 recorded on 20/09/2026. -->

- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in the member's QA plan,
      `project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`, which gate
      `11` wrote on 21/09/2026 — on 27/09/2026 it reads `Reviewed`, all twenty-three gaps resolved
      into the story, AC-GAP-2 the last (grilling round 7 Q34). The plan was committed with US010
      in `0c5e635` on 27/09/2026 and signed off on 30/09/2026, when gate `11` closed, and the row
      is ticked at close against the plan as committed, not before
- [ ] The Security and QA rows of the FLAGS table, and the sections they govern, were recomputed
      when gates `10` and `11` closed. **Which union they must equal depends on the carry**, and
      both branches are named so that a reviewer ticking this row after a landed carry is not asked
      to tick a false statement: **no carry** — the union equals US010's table, this record having
      one member; **carry landed** — the union equals US010's unioned with US009's, which widens
      Security with that story's supply-chain subject and adds its subjects to QA, exactly as the
      FLAGS comment at the head of this record says it would
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity — each trigger is named in the planning threat model's Section 3a,
      written 21/09/2026, where TM-01, TM-03 and TM-04 promote to HIGH
- [ ] Retrospective notes captured (optional — link or inline)

<!-- AMENDED 27/09/2026 after two verified passes of US010's write-back. The QA-plan row read "— once
     gate `11` has written it" until that day; gate 11 wrote the plan on 21/09/2026, and the row now
     names it and its one open gap as read that day. Lifted out of the list for the Prettier reason
     SPRINT-05 recorded on 20/09/2026.
     AMENDED 27/09/2026 at the final pass. The QA-plan row closed "on 27/09/2026 AC-GAP-2 alone
     stands `[OPEN]`, awaiting grilling round 6 Q34" until then. Round 7 Q34 settled that gap and
     the plan reached `Reviewed`, so the row now states the plan's final pre-commit state and when
     it is ticked, SPRINT-07's wording for US011's plan.
     AMENDED 28/09/2026 at the 16-sprint-plans security sign-off. The QA-plan row read "The plan is
     untracked until the US010 commit" until then; 0c5e635 committed the plan beside that sentence,
     so it was false as committed. On 30/09/2026 the row gained the plan's sign-off, the day gate
     11 closed (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9).
     AMENDED 03/10/2026, when 16-sprint-plans wrote the plan. The carry row's bold lead read "A
     landed carry re-opens the sprint plan, if one has been written." and its condition "a carry
     arriving after 06-SPRINT-PLAN-06.md exists" until then; the plan now exists, and the row
     gains the prefix swap the plan derives under the renumber rule of
     project-management/workflows/17-story-plans/STEPS.md Step 2. -->
