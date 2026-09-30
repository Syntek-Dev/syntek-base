# SPRINT-05

**Last Updated**: 30/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The cookie doctrine lands and the git hooks arm on purpose — every cookie this
deployable sets is host-only under a `__Host-` name with the CSRF cookie httpOnly, one guide owns
that rule while the four that stated their own defer to it, and `install.sh` installs the
pre-commit hooks as an explicit, reported step instead of leaving them to arm themselves at a
moment nobody chose.

<!-- Derived from the title of US008, the sole member, and from the deliverable column of slice
     S-02 on project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md — the derivation
     SPRINT-03 used on 07/09/2026 when its goal was rewritten for one member. Narrow by decision:
     Q2 of the 09/09/2026 grilling pass settled the goal as the cookie doctrine, matching S-02,
     and not the wider routing theme of the Subdomain Routing epic — the map's other three slices
     are uncut and belong to no record, and a goal naming their deliverables would be the drift
     SPRINT-02 recorded on 05/09/2026 and SPRINT-03 on 07/09/2026. -->

<!-- REWRITTEN 17/09/2026, when US009 was admitted as this record's stretch tier. The goal above
     read, from 09/09/2026 until that day: "The cookie doctrine lands — every cookie this
     deployable sets is host-only under a `__Host-` name, the CSRF cookie is httpOnly, and one
     guide owns the rule while the four that stated their own defer to it — so no generated project
     follows a shipped guide into a cookie the whole domain tree accepts." A goal naming one of two
     members' deliverables is the drift SPRINT-02 recorded on 05/09/2026, so it is rewritten from
     both members' titles in build order — US008 then US009 — on SPRINT-04's convention of
     07/09/2026 for a sprint with two subjects. The two members come from different epics
     (Subdomain Routing and Gate Parity), which is the ordinary shape here: SPRINT-01, SPRINT-02
     and SPRINT-04 each span two. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 SP Must + 5 SP Should = 13 / 11 SP** — at the **grace
ceiling**, two members, a stretch tier, **the full 2 SP of grace taken**, and **CLOSED to further
admission**. See Notes. Recomputed 17/09/2026 on US009's re-estimate from 3 to 5 SP; the record
stood at `11 / 11 SP, no grace taken` from 17/09/2026 until that gate closed the same day.
`.claude/skills/sprint/SKILL.md` notes that a sprint **habitually** running to grace means the
ceiling is wrong — this is the first, and a second is the signal rather than this one.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 09/09/2026 on US008's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US008.md including
     its `.sh` spelling. Two rows carry values and one reads Yes: Security carries the five
     subjects the story set at cutting; QA names a unit type — `negative-space.sh --self-test`
     over a widened fixture pair — and four manual items; Backend reads Yes because the member
     ships settings assignments under code/src/django/config/settings/, which is Python. Ten rows
     stay N/A: no model, no screen, no personal-data path, no public page, no Ninja surface, no
     log line.
     THESE ARE FIRST-PASS VALUES. This is the first record opened at gate 03 rather than after
     gates 10, 11 and 15 — SPRINT-04's Notes record the earlier practice and its reason, that
     those gates supply the record's Security and QA sections — and US008 has entered neither: on
     09/09/2026 no artefact under project-management/src/10-SECURITY/ or
     project-management/src/11-QA/ names it. CADENCE.md's rule is that the flag is a manifest and
     the gate owns the design, so the Security and QA rows here are recomputed when each gate
     closes, on the precedent SPRINT-01 set when QA-PLAN-US001 AC-GAP-6 moved its QA row and
     SPRINT-04 set when gate 11 widened US006's.

     RECOMPUTED 17/09/2026 on US009's admission, per the rule at the head of this comment. The
     union is now over two members, and two rows widened: Security gains US009's supply-chain
     subject — the `--ignore-scripts` control asserted intact across all three
     install-frontend.sh branches, and the hook-arming moment made explicit — and QA gains an
     integration type it did not carry, US008 having named unit and manual only. Backend is
     unchanged at Yes: US009's own row reads N/A (bash and one JSON manifest read, no model and
     no endpoint), and a union of Yes with N/A is Yes. The other eleven rows are N/A in both
     members, so they stay N/A. These are still FIRST-PASS VALUES for both stories: on
     17/09/2026 nothing under project-management/src/10-SECURITY/ or
     project-management/src/11-QA/ names US008 or US009, so both members owe gates 10 and 11,
     and each row is recomputed at those gates' close.

     RECOMPUTED 28/09/2026 at gate 10's sign-off, per the rule at the head of this comment and
     the Definition of Done row that promised it (settled 28/09/2026, 16-sprint-plans grilling
     round 2 Q7). Gate 10 closed for both members that day, when <%DEVELOPER_NAME%> signed off
     all four security plans. Both members' tables were re-read
     from project-management/src/02-STORIES/ that day. CHANGED in two rows, both in US009's
     half. That member's table moved at 15-decisions on 17/09/2026, committed 18/09/2026, and
     this record never took the move. SECURITY now scopes `--ignore-scripts` to three of sixteen
     invocations and records `prepare` as removed. QA now names a worktree probe and a
     `postinstall` notice probe, and states that the pre-commit probe is not in the generation
     job, which only greps. US008's two values are unchanged since 09/09/2026. The other eleven
     rows are unchanged: N/A in both members, and Backend Yes from US008 alone.
     The two rows read, until today — Security: "host-only cookie scope (no `Domain`, ever) ·
     `__Host-` names per TLS environment · CSRF cookie httpOnly · session invalidation at the
     deploy that renames · gate asserts presence and absence · supply-chain — `--ignore-scripts`
     preserved on all three `install-frontend.sh` branches, the hook-arming moment made
     explicit"; QA: "unit — `negative-space.sh --self-test` over a widened fixture pair,
     self-test scope repointed with the real one; integration — the pre-commit probe and its
     no-`.git` negative case, the generation probe on both answer sets; manual —
     `doc-references.sh --path code/docs`, the five-document read-across, the advisory dry run,
     the dev-stack cookie walk, the `.copier/README.md` claim re-read as true".
     WHAT IS NOT VERBATIM, on project-management/src/03-SPRINTS/SPRINT-07.md's precedent of
     21/09/2026, and it is the whole list. Each member's value is prefixed with its ID, because
     US008's own value already uses the separator the union would otherwise need; and the
     union's type list heads the QA row. Everything else in both rows is the member's own,
     backticks included.

     RECOMPUTED 30/09/2026 at gate 11's close, per the rule at the head of this comment. Gate 11
     closes only when a QA plan reads Signed off, exactly as gate 10 does (settled 30/09/2026,
     16-sprint-plans grilling round 3 Q9), and it closed for both members today, when
     <%DEVELOPER_NAME%> signed off
     project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md and
     project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md. Both had read Reviewed
     since 17/09/2026, all nineteen gaps resolved into the stories; that date is history, and
     Reviewed did not close the gate. Both members' tables were re-read from
     project-management/src/02-STORIES/ today. CHANGED in one row, in US008's half: its QA value's
     manual half gains "the preview proof (the advisory visible in a successful
     `template-update.sh` preview)" after "the advisory dry run", which US008 took at gate 11's
     close, recorded in the comment closing its Decisions, to which its FLAGS comment points
     (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9 and Q11). US009's half is
     unchanged, and so are Security and the other eleven rows. What is not verbatim is the list
     above, unchanged. THESE ARE NO LONGER FIRST-PASS VALUES: each half is its member's table
     after both of that member's gates, gate 10 closed on 28/09/2026 and gate 11 on 30/09/2026. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| GDPR       | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Security   | US008: host-only cookie scope (no `Domain`, ever) · `__Host-` names per TLS environment · CSRF cookie httpOnly · session invalidation at the deploy that renames · gate asserts presence and absence · US009: supply-chain — `--ignore-scripts` preserved on `install-frontend.sh`'s three branches (3 of 16 invocations, scope stated); `package.json`'s `prepare` removed so no lifecycle script writes to `.git/`; the hook-arming moment made explicit                                                                                                                                                                        |
| QA         | unit, integration, manual — US008: unit — `negative-space.sh --self-test` over a widened fixture pair, self-test scope repointed with the real one; manual — `doc-references.sh --path code/docs`, the five-document read-across, the advisory dry run, the preview proof (the advisory visible in a successful `template-update.sh` preview), the dev-stack cookie walk · US009: integration, manual — pre-commit probe (not in the generation job, which never runs the generated `install.sh`); worktree probe; `postinstall` notice probe; generation grep on both answer sets; the `.copier/README.md` claim re-read as true |
| SEO        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| API        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Logging    | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Backend    | Yes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

---

## Story Summary

| ID    | Title                                                                                                  | MoSCoW      | SP  |
| ----- | ------------------------------------------------------------------------------------------------------ | ----------- | --- |
| US008 | Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule | Must Have   | 8   |
| US009 | The git hooks arm on purpose at install, and the README claim that they already do becomes true        | Should Have | 5   |

**Total:** 13 SP — **8 committed, 5 stretch.** Rows listed in build order. The all-`Must` shape
this record opened with on 09/09/2026 is repaired rather than inherited; see Notes.

<!-- RECOMPUTED 17/09/2026 at `15-decisions`. US009 moved 3 -> 5 SP: its AC-GAP-1 found the story
     as specified did not deliver its own User Story, and
     project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md
     removes `package.json`'s `prepare` to fix that. US008 HOLDS at 8 despite three decisions
     widening it, stated in that story's own estimate comment as a wide 8 rather than absorbed —
     Fibonacci offers nothing between 8 and 13, and STORIES.md makes 13 an epic that returns to the
     map to be re-cut.

     This record therefore moves from 11 / 11 to 13 / 11, taking the full 2 SP of grace. The
     capacity line below is updated with it. Recomputing the table on a member's re-estimate is the
     rule at the head of the FLAGS block applied to points rather than flags: the capacity is
     computed FROM this table, so a stale row understates the sprint. -->

<!-- US008 is added to this table rather than referenced from it because SPRINTS.md computes the
     flag union and the capacity FROM this table, and a story in no Story Summary is counted
     nowhere — SPRINT-04's reading of 07/09/2026. US008 sits in no other record's table; its own
     `**Status:**` reads `Open`, and this record moves it nowhere. -->

<!-- US009 admitted 17/09/2026 at 03-sprint-planning, cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md slice `S-11`. It is this record's
     first stretch tier and its only `Should`. The row reads Should Have at 3 SP, matching
     project-management/src/02-STORIES/US009.md: its `Should` was settled at cutting on the
     ground that the hazard's trigger is conditional rather than certain, and that grounding is
     unchanged by the placement — the priority argument on the map (`:496`, the only defect that
     stops work once it fires) is an intra-epic slice ordering, not a MoSCoW tier. Its
     `**Status:**` reads `Open` and this record moves it nowhere. US009 sits in no other
     record's table. -->

## Dependencies

- **US008 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` slice `S-02`, whose map
  header reads `Frontier open: 0 · Blocking open: 0 · Resolved: 26` with every slice "ready for
  `02-story-creation`", and whose `S-02` row's dependency column reads "— (all settled)". Its
  place last in the build order is arithmetic — the other seven stories were placed before it was
  cut — not a blocker, stated so that nobody goes looking for one.
- **The backlog has two blocking edges, and neither touches US008.** US001 -> US005: US005's
  four rules are stated inside the `code/docs/reliability/` family, which is US001's deliverable
  (`project-management/src/03-SPRINTS/SPRINT-04.md` -> Dependencies). US007 -> US002: US002 builds
  `register-indexes.sh` and its status fixtures against whichever vocabulary US007 makes canonical
  (`project-management/src/03-SPRINTS/SPRINT-03.md` -> Notes). Everything else runs beside, not
  behind, and US008 runs beside all seven.
- **US008 does not block on US004, and the reason is the one SPRINT-04 recorded for US006.**
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is a
  reporting regime — "A story cannot be blocked on a gate it is forbidden to repair" — binding
  every story until `doc-references.sh` goes green; it sequences nothing. Its successor of
  30/09/2026,
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  restates it unchanged but for the manual testing guide's path. <!-- UPDATED 30/09/2026: successor added beside the superseded record,
  which the 18-TESTS split superseded for the manual testing guide's path alone (settled
  30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
  `project-management/src/03-SPRINTS/SPRINT-04.md` -> Dependencies states "**US006 does not block
  on US004**" and names both branches of its citation check, and the same applies here. US008 goes
  one step further than US006 did:
  `project-management/src/15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` makes the
  story's own criterion the scoped `--path code/docs` run, with ADR-US003 "stands as decided"
  and binds the story for the whole-tree figure. See Verification Checks.
- **US008 shares no file with any placed story.** It edits five guides under `code/docs/` —
  `code/docs/URL-STRATEGY.md`, `code/docs/security/CRYPTO-AND-DATA.md`,
  `code/docs/api-design/AUTH-STRATEGY.md`, `code/docs/security/AUTH-AND-AUTHZ.md` and
  `code/docs/security/OWASP-AND-CHECKLIST.md`, the five its scoped-baseline ADR names — the
  settings modules and their `CONTEXT.md` under `code/src/django/config/settings/`, and
  `code/src/scripts/audits/negative-space.sh` with its fixtures. Measured 09/09/2026: none of
  the seven placed stories' files under `project-management/src/02-STORIES/` names any of
  those five guides, `negative-space.sh` or `config/settings`. One touch-point is ordered rather
  than blocked: the story's own text names `code/src/scripts/audits/CONTEXT.md` — US002's file,
  at 298 of 300 code lines as `audits/docs-length.sh` measures them, US002 being a SPRINT-02
  member built ahead of this sprint — and what it does there is the story's to state. This
  record's constraint is SPRINT-03's and SPRINT-04's: nothing here grows that file while US002
  owns its headroom; if US002 has landed, the ordinary ratchet applies.
- **US008 unblocks the deferral `S-01` makes.** `S-01` on the same map — the host register and
  its rule — ships a rule section that "defers cookie scope to `CRYPTO-AND-DATA.md`". Until US008
  rewrites that guide, the deferral points at the rule the map settled against, which is why
  `S-02` is cut first. `S-01`, `S-03` and `S-04` are uncut and belong to no record.
- **Sprint numbering and build order agree, and that was checked rather than copied.** The
  settled build order is the prefix on each plan in `project-management/src/17-STORY-PLANS/` —
  `01-` US007, `02-` US001, `03-` US002, `04-` US003, `05-` US004, `06-` US005, `07-` US006, seven
  plans on disk on 09/09/2026 — and US008 builds eighth, behind SPRINT-04's last member, at `08-`.
  That prefix was reserved rather than a plan until `17-story-plans` wrote
  `project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` on 18/09/2026
  (SPRINT-04's rule for US006's `07-`, which has since been written). **US009 builds ninth, at
  `09-`**, behind US008 — settled 17/09/2026 at its admission, and written later on 18/09/2026 as
  `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`. Nothing is
  renumbered: `project-management/docs/planning/STORIES.md` makes the story plan's prefix the
  position in the settled build order across the whole backlog and renumbers it whenever that
  order changes, and appending US009 at the end changes no other story's position.
  It builds behind US008 because the `Must` ships before the stretch; the priority claim
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` makes for `S-11` orders slices
  inside the Gate Parity epic and does not reach the backlog's build order. `16-sprint-plans`
  wrote this sprint's plan on 17/09/2026, and both segments of
  `{exec-order}-SPRINT-PLAN-{sprint-number}.md` read `05`.
- **Nothing carries into this record.** US003's 5 SP `Should` carry is reserved into SPRINT-03 by
  `project-management/src/03-SPRINTS/SPRINT-02.md` -> Definition of Done and reaches this record
  under no branch; SPRINT-04 is closed at grace with nothing reserved out of it. This record's
  capacity line is a settled figure, not an arithmetic risk.
- **US009 has no upstream dependency either, and shares no file with US008.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` slice `S-11`, whose single node
  `N-019` is resolved and whose `N-027` is moot and retired unbuilt. Its own `## Dependencies`
  records the check made on 17/09/2026 across US001 to US008: none of them writes `install.sh`,
  `code/src/scripts/development/install-frontend.sh`, `package.json`, `lefthook.yml` or
  `.copier/README.md`. Measured against this record's other member in particular: US008 edits five
  guides under `code/docs/`, the settings modules under `code/src/django/config/settings/`, and
  `code/src/scripts/audits/negative-space.sh` with its fixtures — no overlap with US009's set in
  either direction. The two can be built in either order; they are listed US008 first because the
  `Must` precedes the stretch.
- **Two things US009 names as adjacent, and this record inherits neither.**
  `project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` puts `install.sh` inside the Bun
  swap's surface, and that map is 29 open / 21 blocking and can produce no story — US009 ships
  against pnpm as the tree stands, and this record schedules no Bun work. And `GAPS.md`'s entry of
  11/09/2026 — `install-frontend.sh --local` handing two stray arguments to `sudo rm -rf` — is
  live in a file US009 reads and asserts against but does **not** fix; the story's assertions are
  written so they neither depend on that defect nor mask it. Named here so neither is read into
  this sprint's scope.
- **`Blocked` is a story status, not a sprint one.** Neither US008 nor US009 waits on anything, so
  no story `**Status:**` moves on account of this sprint.

<!-- AMENDED 28/09/2026, on the build-order bullet above. It read "The next free prefix is `08-`,
     and that number is reserved, not a plan: `17-story-plans` writes it, and nothing here may
     cite it as one", "**US009 builds ninth, at a reserved `09-`**" and "When `16-sprint-plans`
     writes this sprint's plan, both segments ... read `05`" until then. Each was true when
     written and false by 18/09/2026: the sprint plan was written on 17/09/2026 and both story
     plans on 18/09/2026. Found in the records pass of gate 10's sign-off. -->

## Notes

**This record opens holding one all-`Must` member, which is the shape declined on 07/09/2026, and
it is opened knowing that.** What was declined is recorded in
`project-management/src/03-SPRINTS/SPRINT-04.md` -> Notes: the alternative to taking grace there
was "a `SPRINT-05` holding US006 alone at 8 / 11 — a single-member all-`Must` sprint, the shape
SPRINT-03 called 'this sprint's one real weakness' on opening", and <%DEVELOPER_NAME%> "chose the
grace over that", the price paid "for not opening a fifth sprint around one story". Three
statements in the tree refused a fifth record outright — the cascade paragraph of
`project-management/src/03-SPRINTS/SPRINT-03.md` -> Notes ("No SPRINT-05 is opened"), the cascade
paragraph of `project-management/src/03-SPRINTS/SPRINT-04.md` -> Notes ("**No SPRINT-05 is
created.**"), and the _Won't (this sprint)_ bullet of
`project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` ("No fifth record is created, and
none is implied by this plan") — and the change that creates this file dates each of them
where it stands, in a comment, never by deletion. They are not dated for the same reason. The
_Won't (this sprint)_ bullet of `project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md`
asserts as present fact that no fifth record exists, and it goes false the moment this file
exists. The cascade paragraphs of `project-management/src/03-SPRINTS/SPRINT-03.md` and
`project-management/src/03-SPRINTS/SPRINT-04.md` stay true as scoped — each refuses a fifth
record as the alternative to grace in the 07/09/2026 cascade — and are dated because, undated,
they read as standing rules rather than as the settled outcome of one day's arithmetic. Seven
more statements say a fifth sprint was declined _around US006_, and they stay true as written.

**The objection does not transfer, and the arithmetic says why.** On 07/09/2026 the question was
where US006 goes, and every option existed within seven placed stories; US008 did not exist — it
was cut on 09/09/2026, the date both its ADRs carry. Today every record is closed to admission:
SPRINT-01 at 10 / 11 and SPRINT-02 at 8 / 11 by <%DEVELOPER_NAME%>'s call of 07/09/2026; SPRINT-03
at 8 / 11 holding US003's reservation, whose "3 SP under capacity and the 2 SP of grace above it
are together exactly US003's 5"; SPRINT-04 at 13 / 11, the hard ceiling, "CLOSED to further
admission". Measured against each as it stands:

| Record      | Stands at                         | With US008's 8 SP   | Reading                                              |
| ----------- | --------------------------------- | ------------------- | ---------------------------------------------------- |
| `SPRINT-01` | 10 / 11                           | 18 / 11             | Over grace                                           |
| `SPRINT-02` | 8 / 11                            | 16 / 11             | Over grace                                           |
| `SPRINT-03` | 8 / 11, or 13 / 11 with the carry | 16 / 11, or 21 / 11 | Over grace either way, and displaces the reservation |
| `SPRINT-04` | 13 / 11                           | 21 / 11             | Over grace, from the ceiling                         |

An 8 SP `Must` story has no record to enter. The 07/09/2026 refusal was of a fifth record as an
alternative to grace for a story that already had a home; this is a fifth record for a story that
has none, and the only alternative is a `Must` story in no Story Summary, counted nowhere. That is
arithmetic rather than a call, and it is recorded as arithmetic — the way SPRINT-03 recorded
US006's refusal on 05/09/2026.

**The backlog register.** Every live record carries this table and the copies are identical;
**this record is `SPRINT-05`**. It became a live register on 17/09/2026, when US009 was placed into
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

<!-- TWO ROWS ADDED AND ONE REPAIRED, 20/09/2026 at 03-sprint-planning. `SPRINT-06` (US010, `Must`,
     8, holding US009's reserved carry) and `SPRINT-07` (US011, `Should`, 8, open with no `Must`
     tier) were opened that day from the slice split `02-story-creation` made on
     project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md.

     The `SPRINT-05` row was STALE IN EVERY COPY and is repaired in the same change: it read
     "US009 (`Should`, 3, stretch)" and "11 / 11 — at capacity, closed" while that record's own
     capacity line read 13 / 11 at the grace ceiling. US009's re-estimate from 3 to 5 SP on
     17/09/2026 moved the record's header, Story Summary and Total and never reached the register.
     All copies agreed with each other and all of them disagreed with their source — which is
     `GAPS.md`'s entry of 17/09/2026 firing three days after it was filed, on an axis its own
     proposed repair could not see: a script comparing copies to one another would have stayed
     green. Noted in that entry on 20/09/2026.

     The prose above also lost its hardcoded count of five, which this change would have made
     seven. project-management/docs/planning/SPRINTS.md's rule was already count-free — "written
     into every copy in the same change" — and the records had added a count it never had; the
     wording is now the guide's, so the eighth record does not buy the same defect again. Full
     reasoning: project-management/src/03-SPRINTS/SPRINT-06.md -> Notes, the register comment. -->

<!-- This record carried no such table until 17/09/2026: the arithmetic table above is a dated
     09/09/2026 measurement of where an 8 SP `Must` could go, not a backlog view, and it is left
     as written. Added when <%DEVELOPER_NAME%> settled the five tables as one live register at
     03-sprint-planning (Q6). -->

**This record opened on 09/09/2026 with the weakness inherited and unrepaired, and said so rather
than papering over it. It was repaired on 17/09/2026; the reasoning of the day it opened is kept
below, because it is what the repair had to satisfy.**
`project-management/docs/planning/SPRINTS.md` is explicit: "**Avoid a plan where everything is
Must.** If every story is Must, the sprint has no give and the first surprise breaks it." Both
repairs the earlier records used or named are unavailable. The backlog holds exactly one `Should`
— US003, measured 09/09/2026 across all eight stories — and it is SPRINT-02's stretch tier with its
carry reserved into SPRINT-03; borrowing it would be a third move for a story that has moved
twice, and would strip two records' give to build this one's. Cutting a second story to fill the
room is the padding `SPRINTS.md` -> _Capacity_ tells a record to call out instead. Both were
declined on 09/09/2026 (Q1 of the grilling pass). What was true on that day and was not a repair:
at 8 / 11 the sprint had 3 SP inside capacity, and a `Should` that arrived and cleared the specify
tier would be admitted as give. Until one existed, this was a sprint where the one surprise breaks
the plan, recorded the way SPRINT-03 recorded the same shape on 07/09/2026: "the weakness stands,
and this record has no other give it can honestly hold".

**The weakness is repaired, by the story the paragraph above was waiting for (17/09/2026).** US009
— `Should Have`, 5 SP after the re-estimate it took the same day, cut that day from
`MAP-GATE-PARITY.md` `S-11` — is admitted as this record's stretch tier, and the `Must` tier stays
at 8. That is the distinction the arithmetic objection turns on and it is worth stating plainly:
**capacity headroom and MoSCoW give are not the same quantity.** Admitting US009 spends the 3 SP
of headroom and the full 2 SP of grace above it, and takes the `Should` tier from **zero to
5 SP**, so the record gains the droppable work whose absence
`project-management/docs/planning/SPRINTS.md` -> _MoSCoW_ names as the defect — "If every story is
Must, the sprint has no give and the first surprise breaks it." A record at 13 / 11 with 5 SP of
`Should` has give; a record at 8 / 11 with none has headroom and no give. The shape is SPRINT-02's
exactly — a `Must` plus a `Should` stretch — and this record's own reading below already blessed a
larger version of it.

<!-- ARITHMETIC CORRECTED 20/09/2026 at 03-sprint-planning (Q3). The paragraph above was written
     on 17/09/2026 before US009's re-estimate closed later the same day, and it stated 3 SP, "zero
     to 3 SP" and "a record at 11 / 11" throughout — figures this record's own capacity line had
     already moved to 5 and 13 / 11. Its ARGUMENT is untouched and is the reason the paragraph is
     corrected rather than struck: capacity headroom and MoSCoW give are different quantities, and
     admitting a `Should` buys give rather than merely spending room. Previous wording, verbatim:
     "US009 — `Should Have`, 3 SP, cut that day ... Admitting US009 spends the 3 SP of headroom and
     takes the `Should` tier from zero to 3 SP ... A record at 11 / 11 with 3 SP of `Should` has
     give". -->

<!-- The one condition this repair does not meet, stated rather than glossed. The paragraph below
     reserved the give for "a `Should` that arrives and clears the specify tier", and US009 was
     cut on 17/09/2026 and has cleared gates 10, 11 and 15 no more than US008 has — on that day
     nothing under project-management/src/10-SECURITY/ or project-management/src/11-QA/ names
     either story, and neither has a story plan. <%DEVELOPER_NAME%> settled the reading at
     03-sprint-planning on 17/09/2026 (Q2): project-management/docs/planning/CADENCE.md runs gate
     03 SECOND in the per-story loop, immediately after 02 and ahead of 04 to 15, so placement is
     designed to precede the specify tier rather than follow it. The condition as written would
     hold an admitted `Should` to a bar this record does not apply to its own `Must` — US008 was
     admitted on 09/09/2026 having cleared nothing, on the arithmetic recorded above. What the
     specify tier does gate is the sprint PLAN, not the record's membership; that separation is
     the paragraph on the plan below. -->

**Capacity: 13 / 11 — at the grace ceiling, the full 2 SP of grace taken, 8 committed and 5
stretch (17/09/2026; arithmetic corrected 20/09/2026).** The paragraph below is the figure this
record opened on and the sourcing of the two numbers, which is unchanged; only the used side has
moved, from 8 to 13, on US009's admission and its re-estimate the same day. There is nothing left
to call out as under-capacity: `SPRINTS.md` -> _Capacity_ asks that an under-filled record explain
itself rather than pad, and this one is past full.

<!-- CORRECTED 20/09/2026 (Q3). Read "**Capacity: 11 / 11 — at capacity, no grace taken, 8
     committed and 3 stretch (17/09/2026).**" and "only the used side has moved, from 8 to 11" from
     17/09/2026 until that day — against a header capacity line that had been recomputed to 13 / 11
     at grace in the same hour. The header moved and this paragraph did not. -->

**As opened, 09/09/2026 — 8 / 11, inside capacity, no grace taken, and under capacity by 3 SP,
called out rather than padded.** `project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the
trigger_ (as read 09/09/2026) owns both figures as generation-time answers,
`SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`, rendered into its table per project; in this template
repository the table is unrendered, and the 11 and 13 every record here uses are the `copier.yml` <!-- doc-references: template-only -->
defaults for those two answers (`default: 11` and `default: 13`, measured 09/09/2026) —
`.copier-answers.yml` carries neither. Stated on the precedent of
`project-management/src/03-SPRINTS/SPRINT-04.md` -> Notes, "This sprint takes grace, and takes
it deliberately", and its dated comment of 08/09/2026 that de-numbered the citation. The same
section reads: "Capacity is a **trigger**, not a target to
fill exactly. A sprint that lands on 10 SP because the next story is a 5 is a correct sprint, not
an under-filled one." This sprint lands on 8 because the next story does not exist, which is the
same case. `SPRINTS.md` -> _Capacity_ asks that an under-capacity sprint be called out in the
notes rather than padded; called out here.

**CLOSED to further admission, at the grace ceiling and with the stretch tier filled
(17/09/2026).** The first of the three bullets below is the one that fired: US009 entered at 3 SP
inside capacity and was re-estimated to 5 later the same day, which took the record through
capacity and on to the grace ceiling. It now stands at 13 / 11 with **nothing above it**.
`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_ is the reason
nothing further is admitted: grace "exists for one situation — the next story would overshoot, and
splitting it would produce two halves that make no sense alone", and "a sprint that habitually
runs to it means the capacity figure is wrong". This record is the second to take it, after
SPRINT-04; a third is the signal that the ceiling is wrong rather than the exception. Closed by
arithmetic and by decision both, on SPRINT-01's precedent of 07/09/2026 and SPRINT-03's of
05/09/2026 — a ledger is closed by a call, not only by a ceiling.

<!-- CORRECTED 20/09/2026 (Q3). Read, from 17/09/2026: "at capacity and with the stretch tier
     filled ... US009 is 3 SP and went in inside capacity. The record now stands at 11 / 11 with 2
     SP to the grace ceiling, and that 2 SP is reserved for nothing ... Holding 2 SP open invites
     exactly that, on a record that has what it needs." The re-estimate spent that 2 SP later the
     same day, so the paragraph argued for refusing to hold open room the record no longer had. -->

**As opened, 09/09/2026 — open to admission, with nothing to admit, and what would change that.**
Arithmetic: 3 SP inside capacity, 5 SP to the grace ceiling. Availability: US008 was the only
unassigned `Open` story; US001 to US007 were all placed, and nothing carries here. Three things
would change the position, and each is <%DEVELOPER_NAME%>'s call at the time, not this record's to
pre-empt:

- A story of 3 SP or less that has cleared `15-decisions` goes in inside capacity.
- A `Should` of up to 5 SP would stand this record at 13 / 11 with the `Must` tier still at 8 —
  the reading SPRINT-03 recorded for a carry into a single-member sprint, "a stretch tier rather
  than an overcommitment, because the `Must` tier stays at 8 either way" — and would repair the
  weakness above. It is the one case in which 13 here is not an overrun.
- A second `Must` of 8 would be 16 / 11 and is refused on arithmetic before it is argued.

<!-- The first bullet fired on 17/09/2026, and its `15-decisions` qualifier did not hold: US009 is
     3 SP and was admitted inside capacity without having cleared the specify tier. The
     disposition is in the comment under the weakness paragraph above and is not restated here.
     The second bullet was never exercised and is kept because it is the reading that licenses 13
     on this record should a carry ever arrive; the third stands unchanged and is now moot, since
     the record is closed. -->

A candidate that has not cleared the specify tier is not counted (`CADENCE.md` -> _When a sprint
plan is written_: "resolve it or drop it back to the backlog rather than planning a sprint around
it"). The three uncut slices on `MAP-SUBDOMAIN-ROUTING.md` were the obvious candidates on the day
this record opened; none is a story, and this record pre-counts none.

**`05-SPRINT-PLAN-05.md` was written on 17/09/2026 — later the same day this paragraph denied it,
and the denial stood here until 20/09/2026.** The plan exists at
`project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`, written by a `16-sprint-plans` run
"immediately after `15-decisions` closed for both members" in its own words, and both story plans
followed at `08-` and `09-`. **The specify tier's artefacts all exist for both members, and since
30/09/2026 every leg of it is closed** — measured 20/09/2026 and re-measured 28/09/2026 and
30/09/2026, and stated leg by leg so that no leg is read as another:

- **Present and decided.** `15-decisions` has run — US008 carries five ADRs and US009 one under
  `project-management/src/15-DECISIONS/`. GDPR, SEO, API and Logging are skipped by flag for both.
- **Present and signed off, 28/09/2026 — eleven days after the plan they gate.** All four
  `10-SECURITY` artefacts — a threat model and an assessment per member — read
  `**Status:** Signed off`, each reviewed by <%DEVELOPER_NAME%> and corrected in place the same day
  (settled 28/09/2026, 16-sprint-plans grilling round 1 Q1 and round 2 Q5). Between them they
  carry 0 CRITICAL and 0 HIGH: US008 9 MEDIUM, 4 LOW and 2 INFO; US009 7 MEDIUM, 4 LOW and 1 INFO.
  `project-management/docs/planning/CADENCE.md` requires the security threat model and assessment
  **complete**, not merely written, so **gate `10` closed for both members on 28/09/2026**, not on
  17/09/2026, when `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` was written. Per
  `code/docs/GATE-REPORTING.md` that order is recorded rather than smoothed over: an artefact
  existing was not a gate passing, and the plan came first.
- **Present and signed off, 30/09/2026 — thirteen days after the plan they gate.** Both QA plans
  under `project-management/src/11-QA/PLANNING/` have read `Reviewed` since 17/09/2026, with all
  ten and all nine `AC-GAP` entries resolved into their stories, and <%DEVELOPER_NAME%> signed
  both off on 30/09/2026. Gate `11` closes only when a QA plan reads `Signed off`, exactly as gate
  `10` does (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9), so **gate `11` closed for
  both members on 30/09/2026**, not on 17/09/2026: `Reviewed` did not close it. No procedure
  writes that rule down yet, and `project-management/docs/planning/CADENCE.md`'s own QA
  prerequisite is met by a plan that reads only `Reviewed`; the defect is routed to `GAPS.md`
  through US010's gate-`22` pass (`project-management/src/03-SPRINTS/SPRINT-06.md` -> Index and
  Seed Tasks).

<!-- AMENDED 28/09/2026 at gate 10's sign-off. The lead sentence above read "and one leg of it is
     not yet signed off** — measured 20/09/2026, and stated as two facts rather than one", and
     the second bullet read "**Present and NOT yet signed off.** All four `10-SECURITY` artefacts
     ... read `**Status:** Draft`, and both US009 ones say in terms that they are not yet
     reviewed by <%DEVELOPER_NAME%>. ... so **gate `10` is outstanding for both members**. Per
     `code/docs/GATE-REPORTING.md` that is reported here rather than folded into the sentence
     above: an artefact existing is not a gate passing." until then. That was true on 20/09/2026
     bar one word: all four plans, not only US009's two, said in their Author rows that they were
     not yet reviewed. The 20/09/2026 measurement is kept as that day's; the security leg's close
     is dated to the sign-off. -->

<!-- AMENDED 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9). The first bullet above was headed "**Present and reviewed.**" until then, and between
     its two sentences it read "Gate `11` has closed: both QA plans under
     `project-management/src/11-QA/PLANNING/` read `Reviewed`, with all ten and all nine `AC-GAP`
     entries resolved into their stories." That clause moves to the third bullet, which is new,
     and gate 11's close is dated to the sign-off. The lead sentence's closing clause read
     "stated as two facts rather than one so neither is read as the other" until then; there are
     now three legs. -->

**The distinction below still holds, and this record has simply moved to the other side of it: the
record's ledger and the plan's count are two different numbers.** Until 17/09/2026 the argument for
the plan's absence was the fill level — at 8 / 11 the sprint was not full, and capacity is the fill
trigger. US009's admission and re-estimate took the record to 13 / 11, which is **past** the
trigger (`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_: at
capacity, "the sprint is full. Stop planning stories; plan the sprint"), and the plan followed
within the day.

- **The ledger counts every admitted story: 13.** `project-management/docs/planning/SPRINTS.md` ->
  _Two artefacts, two moments_ makes the record "the running ledger — it accumulates stories with
  their points", opened early, and `CADENCE.md`'s per-story loop runs gate `03` second, so a story
  is admitted at cutting and the ledger moves then.
- **The plan counts only stories that have cleared the specify tier: 13, since 30/09/2026.**
  `CADENCE.md` -> _When a sprint plan is written_ names the prerequisites that must hold for
  **every story in the filling sprint** — `15-decisions` cleared, GDPR review, security threat
  model and assessment, a QA plan with no unresolved `AC-GAP`, an SEO plan or `SEO: N/A` with a
  reason, an API contract or no Ninja surface — and closes: "A story that cannot satisfy these is
  **not ready to be counted towards the sprint**." Both members now satisfy them: gate `10`
  closed on 28/09/2026, and gate `11` last, on 30/09/2026, when both QA plans were signed off
  (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9). The security leg binds both, because
  both members' Security flags are live (settled 28/09/2026, 16-sprint-plans grilling round 1
  Q2), and so does the QA leg, both QA flags being live. Neither satisfied them when this record
  opened on 09/09/2026, and the gap between those two dates is the whole reason the two numbers
  are stated separately. `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` was
  written on 17/09/2026 counting 13 while gates `10` and `11` were both still open for both
  members, and that order is recorded here rather than re-dated.

<!-- AMENDED 28/09/2026 at gate 10's sign-off. The plan-count bullet above read "13, since
     17/09/2026" and "Both members now satisfy them; neither did when this record opened on
     09/09/2026" until then. It contradicted this record's own measurement of 20/09/2026, which
     found gate 10 outstanding for both members: CADENCE.md asks for the threat model and
     assessment complete, so the count is honest from the sign-off and not from the day the plan
     was written. The count does not move, only its date (settled 28/09/2026, 16-sprint-plans
     grilling round 2 Q7).
     AMENDED 30/09/2026 at gate 11's close. The count is dated 30/09/2026 and not from gate 10's
     sign-off of 28/09/2026: gate 11 closes only at Signed off, and it closed on 30/09/2026, the
     last prerequisite to hold for either member (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9). The count still does not move. -->

`project-management/src/16-SPRINT-PLANS/CLAUDE.md` forbids a plan without a matching record — "do
not create an orphan plan" — and nothing forbids a record without a plan; that is a record's
ordinary state between opening and filling, and it is the state
`project-management/src/03-SPRINTS/SPRINT-06.md` and
`project-management/src/03-SPRINTS/SPRINT-07.md` are in as of 20/09/2026.

<!-- CORRECTED 20/09/2026 at 03-sprint-planning (Q3), and the correction is the reverse of the
     usual one: a claim that was true when written went false within hours, and nothing brought it
     back. The block read, from 17/09/2026: "**No 05-SPRINT-PLAN-05.md is written, and its absence
     is by rule, not omission**", with a ledger of 11, a plan count of 0, and a closing measurement
     paragraph asserting that "Gates `10` and `11` are owed by both members and `15` has run as a
     pass for neither" and that "The story plans are likewise not written: `08-` and `09-` are
     reserved by build order, and a reserved number is not a plan." Every one of those was falsified
     the same day by the specify tier closing and 16-sprint-plans running on it.

     The plan's own header comment even records the record's earlier denial and says US008's
     Dependencies bullet "was corrected in that change rather than deleted" — the correction reached
     that bullet and not this section. Found on 20/09/2026 while opening SPRINT-06 and SPRINT-07,
     which had to read this record's plan state to decide whether they owed plans of their own.

     The ledger-versus-plan reasoning is KEPT and its counts corrected rather than struck, because
     it is the doctrine that makes the two numbers distinguishable and both new records cite it as
     the reason they owe no plan. What changed is which side of the distinction this record sits
     on. -->

<!-- Settled at 03-sprint-planning on 17/09/2026 (Q4). The two-number reading is what makes the
     doctrine self-consistent rather than being an accommodation invented for this record: gate 03
     sits second in CADENCE.md's per-story loop, ahead of 04 to 15, so a record that could only
     admit stories which had cleared 15 could never admit one at the gate the loop places it at.
     Read the other way — ledger accumulates at 03, plan counts at 15 — both statements hold and
     SPRINTS.md's "filled as stories clear `15`" describes when the FILL is checked, not when
     membership is granted. Reported per code/docs/GATE-REPORTING.md: the trigger fired and was
     answered, not skipped. -->

**This record was opened at gate `03`, not after `10`, `11` and `15`, and the deviation from the
last two records' practice is deliberate.** SPRINT-03 and SPRINT-04 opened after their members had
cleared the specify tier, because gates `10` and `11` supply the Security and QA sections. This one
opens now because the alternative is a `Must` story in no Story Summary, counted nowhere, and
because the plan bullet among the three refusals above goes false the moment a story exists
with nowhere to go. The cost is the one the FLAGS comment names: the Security and QA sections
below opened as first-pass values from the manifest, each owed a rewrite at its gate's close. The
Security section was rewritten on 28/09/2026, at gate `10`'s sign-off, and the QA sections and
tasks on 30/09/2026, at gate `11`'s, from both QA plans as signed off that day (settled 30/09/2026,
16-sprint-plans grilling round 3 Q9 and Q10). Both write-backs are now paid.

<!-- AMENDED 28/09/2026: the last sentence of the paragraph above read "The cost is the one the
     FLAGS comment names: the Security and QA sections below are first-pass values from the
     manifest, each rewritten at its gate's close." until then. Both QA plans had read Reviewed
     since 17/09/2026 and no QA rewrite followed; gate 10's did, today (settled 28/09/2026,
     16-sprint-plans grilling round 2 Q7). Amended again on 30/09/2026, when gate 11 closed at the
     QA plans' sign-off and the QA write-back landed (round 3 Q9 and Q10). -->

**The citation gate is inherited red, and this record adds its own findings to it — expected, not
a regression.** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
superseded 30/09/2026 by
`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
which restates it unchanged but for the manual testing guide's path, <!-- UPDATED 30/09/2026: successor added beside the superseded record,
which the 18-TESTS split superseded for the manual testing guide's path alone (settled 30/09/2026,
16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
governs: the baseline is captured before the first edit, read as a diff, and "never reported as
the gate passing while the baseline stands". Measured 09/09/2026 at HEAD `ff24084`, before this
change: the whole-tree `bash code/src/scripts/audits/doc-references.sh` reported **253**
citations that do not resolve — 135 instance, 106 dangling, 12 template-only, 0 plan-prefix — and
exited `1`; `bash code/src/scripts/audits/doc-references.sh --path code/docs` reported **Clean**
over 174 files and exited `0`. `project-management/src/03-SPRINTS/` is not exempt: the four live
records contributed 73 of the 253 in that run — SPRINT-01 10, SPRINT-02 24, SPRINT-03 20 and
SPRINT-04 19.

**The figure is index-dependent, and the index state is part of the number.** The gate decides
whether a citing file ships in `build_template_only`, which reads `git ls-files`: an untracked
file is not recognised as copier-excluded, `file_ships` stays true, and every citation it makes
of a per-project artefact is reported as template-only. A template-only finding arises only when
a file the gate believes ships cites a path copier excludes, and a staged PM artefact does not
ship, so it raises none. Untracked, this file read **21** on 09/09/2026; staged with
`git add -N`, the state it ships in, it reads **6**, and the 15 template-only findings that
vanished were that artefact of the index, not citations this record ever owed. Every figure here
is measured with the whole change staged, and a re-measurement is only comparable in that state.

**This file, staged, measures 6 — 5 instance, 1 dangling, zero template-only — and every one is
accounted for.** The 5 instance findings are the sprint name inside the quotation from SPRINT-04's
Notes in the first paragraph of these Notes (a fifth record holding US006 alone) and the four
sprint-record cells of the arithmetic table above — the class
`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` is
the doctrine for, which the gate flags by defect until US004 lands in SPRINT-03, and the same
class from the same cause as SPRINT-04's own cascade table. The 1 dangling is the forward
reference in Dependencies to the reliability family US001 creates — the class SPRINT-04 already
carries. A record in house style cites artefacts by full path in backticks, and that form is not
what the gate flags; the instance class is the bare name. None of the 6 is of a class this sprint
owns. The criterion that must stay green is the scoped run, which this file does not touch:
`--path code/docs` reads **Clean**, 174 files, exit `0`, untouched by all of this. With the whole
change staged, the tree measured **259** — 140 instance, 107 dangling, 12 template-only, 0
plan-prefix — a rise of 6 that is this file alone: `project-management/src/02-STORIES/US008.md`
and its two ADRs under `project-management/src/15-DECISIONS/` measure 0 each; `GAPS.md` measures
9, unchanged from HEAD; SPRINT-03 and SPRINT-04 still measure 20 and 19 after the dated comments
this change adds to them. Reported as the number it is, with its delta, and never as a pass.

---

## Acceptance Criteria

Two outcomes, one per member, in build order.

**US008** — every cookie this deployable sets is host-only, with no `Domain` attribute ever,
under a `__Host-` name set per TLS environment; the CSRF cookie is httpOnly, and
`CSRF_COOKIE_HTTPONLY = True` ships in the same change as the `__Host-` names;
`code/docs/security/CRYPTO-AND-DATA.md` owns the rule and `code/docs/URL-STRATEGY.md`,
`code/docs/api-design/AUTH-STRATEGY.md`, `code/docs/security/AUTH-AND-AUTHZ.md` and
`code/docs/security/OWASP-AND-CHECKLIST.md` defer to it; `code/src/scripts/audits/negative-space.sh`
asserts the presence of the settings and the absence of a `Domain`; and the session invalidation
the rename causes at the deploy that ships it is stated rather than discovered.

**US009** — `install.sh` installs the git hooks as an explicit, reported step, the last of Phase 1,
guarded by `git rev-parse --git-dir` so a tree without a repository is skipped and the install
continues, and hard-failing at exit 2 in the house `err` idiom when `lefthook install` genuinely
cannot complete; the `--ignore-scripts` supply-chain control stays on all three
`code/src/scripts/development/install-frontend.sh` branches, and `package.json`'s `prepare` script
is removed, making `install.sh` the sole arming path, with a `postinstall` that announces an
unarmed checkout and arms nothing
(`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`),
so the hook is never armed as a package-manager side effect; and `.copier/README.md:442`'s
existing claim that `install.sh` runs `lefthook install` becomes true **without that sentence
being edited**, while the file's `pnpm prepare` line, dead once `prepare` is removed, is
rewritten to `bash install.sh` and its Development-scripts table gains an "install-hooks.sh" row
(`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, P3).

<!-- AMENDED 28/09/2026 at gate 10's sign-off. The paragraph above read "an explicit, reported
     step after the JavaScript-dependency step, guarded on `.git`" and "`package.json`'s
     `prepare` script is untouched" until then. Both were overtaken at 15-decisions on
     17/09/2026 and this record never took the change: the Accepted
     ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026 removes `prepare` and US009's ST02 was
     inverted to match; the story moved the step to the end of Phase 1 (AC-GAP-5) behind a
     `git rev-parse --git-dir` guard (ST07). ASSESSMENT-PLAN-US009-HOOK-ARMING's 7.1, 7.3 and 7.5,
     signed off 28/09/2026, record all three settled. Bringing a record into line with an
     Accepted ADR is not a new decision, and no ADR is touched.
     CORRECTED 30/09/2026: the paragraph cited "`.copier/README.md:441`'s existing claim" until
     then. `:441` is a blank line; `f045aac` moved the sentence to `:442` on 18/09/2026, the text
     unchanged, as the manual QA rows below record. The story still cites `:441` in its Gherkin
     only (project-management/src/02-STORIES/US009.md:272), by the decision recorded beneath that
     scenario; its Documentation Task cites `:442`.
     CORRECTED 30/09/2026: the paragraph ended "becomes true **without that file being edited**"
     until then. The story plan's P3 rewrites the file's dead `pnpm prepare` line and gives its
     Development-scripts table an "install-hooks.sh" row, and carves both out: "unmodified"
     covers the `lefthook install` sentence at `:442` and nothing else (recorded in
     09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the 16-sprint-plans gate). -->

### Backend Acceptance Criteria

<!-- Kept and substituted rather than filled, on SPRINT-04's precedent for its Security section:
     every template row names a service-layer control — `transaction.atomic()`, IDOR, `post_save`,
     Celery, audit rows — and the member ships settings assignments, five guide edits and one
     widened gate: no service method, no endpoint, no model. The Backend flag reads Yes, so the
     gate applies; per code/docs/GATE-REPORTING.md a section removed reads as a gate that did not
     apply, and this one does. -->

- [ ] The settings assignments ship together in one change — the per-environment `__Host-`
      names and `CSRF_COOKIE_HTTPONLY = True` — and no `Domain` is set on any cookie: in Django's
      terms, neither `SESSION_COOKIE_DOMAIN` nor `CSRF_COOKIE_DOMAIN` is set anywhere under
      `code/src/django/config/settings/`
- [ ] The settings `CONTEXT.md` under `code/src/django/config/settings/` describes the settings
      that moved, and its rows agree with the modules
- [ ] `bash code/src/scripts/audits/negative-space.sh` asserts presence and absence — the
      settings present, the `Domain` settings absent — and its self-test scope is the real scan
      scope, not a narrower one
- [ ] `transaction.atomic()`, IDOR verification, idempotent signals, Celery tasks and audit rows —
      **N/A**, with the reason: the member's DB, API and Logging flags read `N/A` and its
      deliverable is settings, guides and a gate, so the template's five rows have nothing to bind

### Security Acceptance Criteria

<!-- The template's rows name runtime controls — rate limits, audit rows, HTML escaping, ABAC —
     and the member's security gate has not run: on 09/09/2026 no ASSESSMENT-PLAN-US008-* or
     THREAT-MODEL-PLAN-US008-* exists under project-management/src/10-SECURITY/. What stands here
     is the manifest — the five subjects the story set at cutting — as the entry condition gate 10
     designs against; the rows are rewritten at its close, the way SPRINT-04's were widened at
     US005's and US006's gates. Per code/docs/GATE-REPORTING.md this is a gate not yet entered,
     reported as such — not a gate that found nothing.

     AMENDED 28/09/2026 at gate 10's sign-off, when the rows below were rewritten (settled
     28/09/2026, 16-sprint-plans grilling round 2 Q7), on SPRINT-06's precedent of 27/09/2026.
     Gate 10 ran for both members on 17/09/2026 and <%DEVELOPER_NAME%> signed all four plans off
     on 28/09/2026 (round 1 Q1), their stale text corrected in place the same day (round 2 Q5).
     The paragraph above is that of 09/09/2026: it called the rows the manifest and the gate "not
     yet entered", and from 17/09/2026 both were false. The rows are now Section 7 of
     project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md,
     7.1 to 7.13, and of
     project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md,
     7.1 to 7.14, both as corrected on 28/09/2026, and every constraint is carried by exactly one
     row. US009's rows keep the story's ST numbers, ST01 to ST05, ST02b, ST07 and ST08, with ST06
     retired on 17/09/2026 and ST08 added on 30/09/2026 to carry 7.6 (settled 30/09/2026,
     16-sprint-plans grilling round 3 Q11); US008's cite the assessment's numbers, because that
     story's criteria carry none. Nothing is numbered or renumbered here. The manifest's five
     subjects all survive: host-only scope is 7.3, the `__Host-` names 7.1 and 7.2, the httpOnly
     CSRF cookie a Backend criterion above with its limit at 7.6, session invalidation 7.9, and
     presence and absence 7.1, 7.3 and 7.4. Gate 10 raised 0 CRITICAL and 0 HIGH across
     twenty-seven findings, US008 9 MEDIUM, 4 LOW and 2 INFO and US009 7 MEDIUM, 4 LOW and 1 INFO:
     a recorded outcome with its reason, not a gate that found nothing.
     The rows read, until today: "Host-only cookie scope — no `Domain` attribute on any cookie,
     ever"; "`__Host-` names per TLS environment"; "CSRF cookie httpOnly"; "Session invalidation
     at the deploy that renames — stated in the story's deliverable, so the operator is told what
     happens to live sessions rather than finding out"; "The gate asserts presence and absence — a
     tested setting is not an enforced one until something fails when it is missing or when a
     `Domain` appears"; "US009 — `--ignore-scripts` preserved on all three `install-frontend.sh`
     branches, asserted in the diff rather than assumed, with `package.json`'s `prepare`
     byte-identical"; "US009 — the hook-arming moment is explicit: the step runs after dependency
     installation, resolves `lefthook` from the project's own `node_modules` rather than the
     host's, adds no network fetch, no credential read and no write outside `.git/hooks/`, and its
     `.git` guard tests for a repository only — never a general try/ignore that would hide a real
     failure"; and "No CRITICAL or HIGH finding is open — cannot be ticked until gate `10` has run
     for both members; the row is here so that its absence is not read as a pass". The secrets
     row is unchanged. -->

- [ ] **US008 — the prefix's preconditions hold in every module that names it.** Each module
      assigning a `__Host-` name also sets `SESSION_COOKIE_SECURE = True` and
      `CSRF_COOKIE_SECURE = True`, leaves `Path` at Django's `/` and sets no `Domain`, proven by the
      gate's presence and absence clauses and never by a read. The doctrine binds every module
      that serves TLS, not only the two that exist today, and each presence clause names the
      modules it read, so a third deployed module shows as unchecked rather than vanishing
      (assessment 7.1, 7.2)
- [ ] **US008 — host-only scope, asserted where a gate can see it.** No module under
      `code/src/django/config/settings/` assigns `SESSION_COOKIE_DOMAIN`, `CSRF_COOKIE_DOMAIN`, or a
      cookie `Path` other than `/`, and every match is assignment-anchored at line start, so a
      comment is neither a finding nor a pass. `code/src/scripts/audits/negative-space.sh:92` and
      `:481` move together, each clause skips with a note when its module is absent, and none
      carries a silencing annotation — the register's under-count recorded as the named cost of Q3
      (assessment 7.3, 7.4, 7.10)
- [ ] **US008 — the edge precondition is stated.** `SECURE_PROXY_SSL_HEADER` is a precondition of
      the doctrine in the owner guide: Django emits `Secure` from the setting, but
      `SECURE_SSL_REDIRECT` reads `request.is_secure()`, which `X-Forwarded-Proto` drives. A
      request that reaches Django by a path skipping the edge, carrying a client-supplied
      `X-Forwarded-Proto: https`, therefore skips the redirect, and the prefixed cookie is served
      over HTTP and discarded. So `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6
      requires the edge to strip any client-supplied `X-Forwarded-Proto` and set it itself
      (assessment 7.5)
- [ ] **US008 — the owner guide states its limits and its gate's reach.** Three limits: the prefix
      is per cookie name, so `messages` and any language cookie stay unprefixed; a pre-prefix
      browser accepts a prefixed cookie unconditionally; and `CSRF_COOKIE_HTTPONLY` does not
      defend the token against XSS, because `{% csrf_token %}` and `hx-headers` put it in the DOM.
      It also states what a directory scan cannot see, and the dev and TLS cookie names diverging,
      where every project reads it and not only an updating one (assessment 7.6, 7.7, 7.8)
- [ ] **US008 — the advisory reaches its operator and names what the deploy costs.** The preview
      blindness is repaired inside US008 and a successful `template-update.sh` preview is proved
      to show the advisory, because TM-03's only mitigation shipped into a suppressed channel is a
      false green. The advisory names every live session and in-flight CSRF token invalidated by
      the rename, a rollback doing so again, and a rolling cutover as unsafe; it prints file
      paths, line numbers and setting names, never a value (assessment 7.9, 7.11, 7.12)
- [ ] **US008 — the advisory ships as two `_migrations:` entries, and the keyed one names the
      release that ships the doctrine**, per
      `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`. The
      always-wrong state — any `SESSION_COOKIE_DOMAIN` or `CSRF_COOKIE_DOMAIN` still assigned in a
      settings module — rides the unversioned, state-gated `cookie-domain-conflict.sh`, which runs
      on every update, so no key can strand a project still carrying the old mandate. The one-time
      cutover notice rides the keyed `v<RELEASE>-host-only-cookies.sh`, its key derived at release
      against `git tag` and tagged in the same act, never carried from 09/09/2026: `VERSION`
      reached 7.6.0 without the doctrine and no `v7.6.0` tag exists (assessment 7.13)
- [ ] **US009 — `--ignore-scripts` stays on all three
      `code/src/scripts/development/install-frontend.sh` branches**, `:67`, `:84` and `:93`,
      asserted in the diff rather than assumed, and the assertion states its scope: three
      invocations of sixteen, not a repo-wide posture. The other eleven go to a `GAPS.md` row of
      their own, opened on the story's `22-implementation-documentation` pass and dated the day it
      is written — never to a tick here. Each assertion names its own single line, so the
      assertions neither depend on nor mask the live `sudo rm -rf` defect at `:79-81` in the
      `--local` branch (US009/ST01, ST08; assessment 7.2, 7.6)
- [ ] **US009 — no lifecycle script arms the hooks.** `package.json` carries no `prepare` script
      and no lifecycle script in it writes under `.git/`, so `install.sh` is the sole arming path.
      The replacement `postinstall` announces an unarmed checkout and arms nothing: it writes only
      to stdout, and is silent when the hooks are armed, when `CI` is set and when there is no git
      repository (US009/ST02, inverted 17/09/2026, and ST02b; assessment 7.1)
- [ ] **US009 — the binary is the project's own.** `pnpm exec lefthook install`, the house idiom,
      and never a bare `lefthook` from `PATH`; `package.json`'s `"^2.1.10"` is a range, and
      `pnpm-lock.yaml` is what pins `2.1.10` (US009/ST03; assessment 7.4, 7.8)
- [ ] **US009 — the step runs last in Phase 1, after dependency installation.** It can never arm
      a hook naming a toolchain not yet present, and its exit-2 hard fail abandons no Phase 1
      step, because none follows it in Phase 1. It is not free under `install.sh --full`: Phase 2
      follows it there — the Docker dev-stack build and the migrations, `install.sh:540` and
      `:580`, steps 10 and 11 once renumbered — and a hard fail at the step exits before either
      runs, while a plain `bash install.sh` exits after Phase 1 anyway (`install.sh:524-538`). It
      adds no network fetch, no credential read and no write outside `.git/hooks/` (US009/ST04,
      ST05; assessment 7.5, 7.12, 7.13)
- [ ] **US009 — the guard tests for a repository and nothing else.** `git rev-parse --git-dir`,
      not `[ -d .git ]`, which is false in every `git worktree add` checkout; never a general
      try/ignore that would hide a real failure (US009/ST07; assessment 7.3, 7.14)
- [ ] **US009 — the step says what it did.** It reports what it wrote into `.git/hooks/` and what
      it replaced rather than overwriting in silence, and `usage()` names Phase 2 as steps 10 and
      11, so the printed sequence no longer collides with Phase 1 (assessment 7.7, 7.10)
- [ ] **US009 — each proof runs where it can.** The generation job asserts the step present in
      the generated `install.sh` on both answer sets and does nothing more; the probes that run
      the step live in a job of their own, and a generated project's unborn HEAD is covered by a
      probe rather than assumed (assessment 7.9, 7.11)
- [ ] **No CRITICAL or HIGH finding is open** — gate `10` ran for both members on 17/09/2026 and
      raised none, and both were signed off on 28/09/2026; ticked at close unless a promotion
      trigger in either threat model's Section 3a fires during the sprint, where nine US008
      threats across six trigger rows, and five US009 threats, promote to `HIGH`
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### QA Acceptance Criteria — Automated

<!-- First-pass from the manifest; no QA-PLAN-US008-* exists under
     project-management/src/11-QA/PLANNING/ on 09/09/2026. Rewritten at gate 11's close.

     REWRITTEN 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9 and Q10), on this record's gate-10 write-back of 28/09/2026. Gate 11 closed for both
     members today, when <%DEVELOPER_NAME%> signed off
     project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md and
     project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md; both had read Reviewed
     since 17/09/2026, their nineteen gaps resolved into the stories that day. The rows below, the
     manual rows after them and both QA task lists are each member's QA criteria and tasks as
     project-management/src/02-STORIES/US008.md and project-management/src/02-STORIES/US009.md now
     state them, keyed by member. They cite the plans by scenario and gap ID, never by line, and
     where a plan has no scenario for a row they cite the story instead. Nothing is numbered or
     renumbered here. The gate-level checks US008's criteria also carry — lint.sh, check.sh,
     tests/all.sh, docs-length.sh and the scoped doc-references.sh run — stay in Verification
     Checks and are not repeated.
     Two rows joined later the same day, one below and one among the manual rows, each with its
     task in the QA task lists: US009's
     `postinstall` failure case (QA-PLAN-US009 ES-06) and US008's failed-copy walk (QA-PLAN-US008
     ES-08). They were the two QA scenarios with no story line, and <%DEVELOPER_NAME%> had them fed
     back into US009 and US008 as acceptance criteria, so story and plan agree (settled 30/09/2026,
     16-sprint-plans grilling round 5 Q16; project-management/workflows/11-qa-checks Step 5).
     Neither is an AC-GAP, and the nineteen gaps stand as counted.
     The rows read, until today: "`bash code/src/scripts/audits/negative-space.sh --self-test`
     exits 0 over the widened fixture pair, with the self-test's scope repointed to the scan's
     real scope"; "Every fixture case US008 adds fails against the pre-change script and passes
     against the post-change one — a fixture that passes both proves nothing (SPRINT-03's
     criterion for a widened gate)"; and "US009 — a pre-commit probe asserts that after
     `install.sh` completes in a git checkout, `.git/hooks/pre-commit` exists and is lefthook's,
     and its negative case asserts that a tree with no `.git` reports the skip and continues
     rather than exiting non-zero". The second was wrong from 17/09/2026: the old script has no
     clause for a fixture to fail against, so the comparison runs one way only (QA-PLAN-US008
     Section 6). The generation row gains a closing clause naming it a grep, with its citations,
     and the template-integrity and coverage rows stand as they read. -->

- [ ] **US008 — the self-test proves the three new clauses bite.**
      `bash code/src/scripts/audits/negative-space.sh --self-test` exits 0 with `EXPECTED` at
      fourteen names; `broken/settings/` trips all three new clauses and `clean/settings/` trips
      none; a removed fixture still exits 2; and the self-test's scope is repointed with the real
      one (QA-PLAN-US008 ES-01 to ES-05, EC-08; assessment 7.4)
- [ ] **US008 — the new fixtures are inert for every other clause**, asserted rather than assumed.
      `code/src/scripts/audits/negative-space.sh:252` and `:278` scan `*.py` recursively with no
      `*/settings/*` exclusion, so the five new fixtures are input to the constraint and
      key-register clauses as well; the eleven pre-existing clause names behave exactly as before
      (QA-PLAN-US008 AC-GAP-9, EC-07)
- [ ] **US008 — the discriminating comparison runs one way, and both halves are recorded.** The
      new script over the HEAD `ff24084` settings modules reports all three clauses, and over the
      post-change modules none. The reverse comparison does not exist — the old script has no
      clause for a fixture to fail against — and it is never claimed (QA-PLAN-US008 Section 6)
- [ ] **US008 — the unscoped run ran the clauses.** `bash code/src/scripts/audits/negative-space.sh`,
      unscoped because `--path` is refused, exits 0 after the settings land with none of the three
      clauses in its skip notes: they ran, they did not skip (QA-PLAN-US008 HP-01)
- [ ] **US008 — the preview repair is additive.** `code/src/scripts/development/template-update.sh`
      gains a report block on its success path that surfaces the migration report from the update
      log, a sibling of its existing report block; it touches neither the failure tail nor the
      `cleanup` trap, reorders no section and changes no exit code (QA-PLAN-US008 ES-08,
      AC-GAP-2; assessment 7.11)
- [ ] US009 — the `[3/4] Template Generation` job generates a project on **both** answer sets
      (`INCLUDE_MOBILE` false and true) and the generated `install.sh` carries the step in each —
      a grep, the one assertion that job can make (QA-PLAN-US009 HP-07, AC-GAP-6)
- [ ] **US009 — the pre-commit probe.** After `install.sh` completes in a git checkout,
      `.git/hooks/pre-commit` exists and is lefthook's; the probe fails if the file is absent or
      is another tool's hook (QA-PLAN-US009 HP-01, HP-02)
- [ ] **US009 — its negative case.** A tree with no `.git` reports the skip and continues rather
      than exiting non-zero (QA-PLAN-US009 ES-05)
- [ ] **US009 — the worktree probe.** In a checkout made by `git worktree add`, where `.git` is a
      file, the step arms the hooks rather than skipping, run against a checkout with at least one
      commit and never a bare `git init` (US009/ST07; QA-PLAN-US009 EC-01, AC-GAP-2)
- [ ] **US009 — the `postinstall` probe.** The notice prints in a git checkout with no armed hook,
      and is silent when the hook is armed, when `CI` is set and when there is no `.git`. Its
      printing case runs with `CI` unset: the probe job's own `pnpm install` runs under `CI`, so a
      probe that inherits it asserts against the suppressed state and passes for the wrong reason
      (US009/ST02b and the story's third scenario; QA-PLAN-US009 HP-08, EC-09 to EC-11)
- [ ] **US009 — the `postinstall` never fails an install.** In any state it cannot evaluate — no
      git repository, or `git` absent from `PATH` — `pnpm install` still exits 0. A lifecycle
      script that exits non-zero fails the install that ran it, and silence reached by erroring is
      not silence; the case runs through the same `postinstall` probe (QA-PLAN-US009 ES-06)
- [ ] **US009 — the four probes run in a job of their own**, ".github/workflows/audit-hook-arming.yml"
      calling "code/src/scripts/tests/hook-arming.sh", both named by
      `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` under _P4_ and
      neither yet written — and never in `[3/4] Template Generation`, which never executes the
      generated `install.sh` (QA-PLAN-US009 AC-GAP-6; assessment 7.9)
- [ ] US009 — the existing `template-integrity` pre-commit leg still passes
- [ ] Coverage floors — **not marked N/A here, and no floor claim is made.** US008 ships Python —
      settings assignments — and makes no floor claim on the three edited modules, which are
      configuration with no branch to cover: `bash code/src/scripts/tests/all.sh --coverage` is
      read as a regression, as `project-management/src/02-STORIES/US008.md` -> Verification Checks
      has stated since 09/09/2026 and its QA plan, written 17/09/2026, does not revisit. US009
      ships bash, which the floor does not reach, and its QA plan records no coverage figure

<!-- AMENDED 28/09/2026, on the coverage row above. It read "whether the floor binds settings
     modules is gate `11`'s call for that story; US009 ships bash, which the floor does not
     reach. Recorded as open rather than decided by a record that has not seen either QA plan"
     until then. Both QA plans have existed since 17/09/2026, and US008's own Verification Checks
     had already decided the reading on 09/09/2026. -->

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/MANUAL/US009-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **US008 — the whole-tree baseline is captured by identity, before the first edit**: the
      `(file, kind, token)` triple with the line number dropped and multiplicity kept, the
      detector's `git hash-object` recorded beside it and re-asserted at close, and every new line
      at close classified by whether its file is in the story's edit set — a count is never the
      test (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
      superseded 30/09/2026 by
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
      which restates it unchanged)
      <!-- UPDATED 30/09/2026: successor added beside the superseded record, which the 18-TESTS split superseded for the manual testing guide's path alone (settled 30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7 Q18). -->
- [ ] **US008 — the five-document read-across is recorded**: each of the five states the rule or
      defers to the owner, the `CORS_ALLOWED_ORIGINS` sentence is confirmed verbatim, and the seven
      other cookie-mentioning files are re-read and recorded harmless
- [ ] **US008 — the advisory dry run**: against a scratch copy with `SESSION_COOKIE_DOMAIN` planted
      in `staging.py`, it names that file and line, prints its operator notes, prints no value and
      exits 0; against the clean tree it prints nothing and exits 0; with the settings directory
      removed it exits 0 early (QA-PLAN-US008 HP-05, HP-06, EC-11)
- [ ] **US008 — the preview proof.** Against a scratch copy with `SESSION_COOKIE_DOMAIN` planted,
      a **successful** `template-update.sh` preview shows the migration report before its "Preview
      only — your project is unchanged" line, and the same run surfaces the reports of the three
      print-only advisories already shipped, `v3.0.0`, `v5.0.0` and `v6.0.0`'s report-only third.
      The story repairs the preview blindness rather than reproducing it (QA-PLAN-US008 HP-08,
      HP-09 and AC-GAP-2, inverted 17/09/2026;
      `project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`;
      assessment 7.11)
- [ ] **US008 — the failed-copy walk.** Against a scratch update that fails on the copy, with the
      repair in place, the `template-update.sh` preview prints the failure tail
      (`code/src/scripts/development/template-update.sh:148-151`) once and exits 2, as before; the
      success-path block does not run, and `cleanup` (`:122-123`) still removes the log. The repair
      adds a block and reorders nothing (QA-PLAN-US008 ES-08)
- [ ] **US008 — the dev-stack cookie walk**: with the dev stack up, log in at the admin, submit a
      form and fire an HTMX write; all three succeed, the browser shows dev's plain cookie names
      with `HttpOnly` on the CSRF cookie, and no console error (QA-PLAN-US008 HP-04)
- [ ] **US009 — the clean-clone walk**: a clean clone into a scratch directory, `bash install.sh`,
      then a throwaway `git commit`, with the pre-commit legs observed running and their output
      recorded (QA-PLAN-US009 HP-01 to HP-03)
- [ ] **US009 — the idempotence walk**: the same clone re-run through `bash install.sh` duplicates
      nothing and errors nowhere (QA-PLAN-US009 HP-04, EC-06)
- [ ] **US009 — the setup claim re-read**: the `.copier/README.md` sentence that `install.sh` "runs
      `lefthook install`" is read against the changed `install.sh` and confirmed true, the re-read
      recorded, and that sentence confirmed unmodified in the diff (QA-PLAN-US009 HP-06). The
      file's `pnpm prepare` line is rewritten to `bash install.sh` and its Development-scripts
      table gains an "install-hooks.sh" row — the story plan's P3 edit, carved out of
      "unmodified" (recorded in 09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the
      16-sprint-plans gate) — and the walk records the file's diff line by line. The sentence sits
      at `:442`, measured 30/09/2026; `f045aac` moved it there on 18/09/2026 from the `:441` the
      story's Gherkin alone still cites, by the decision recorded beneath that scenario
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in **either member's** QA plan —
      `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md`, ten of ten
      resolved, and `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`, nine of
      nine, both written at gate `11` and `Reviewed` on 17/09/2026, and signed off on 30/09/2026,
      when gate `11` closed; ticked at close against the plans as committed, and unticked if either
      reopens

<!-- AMENDED 28/09/2026: the last row above read "which gate `11` has yet to write for either;
     until they exist this row cannot be ticked, and its absence is not a pass" until then. Both
     plans were written on 17/09/2026 and committed on 18/09/2026.
     REWRITTEN 30/09/2026 at gate 11's close, as the comment heading the automated rows records
     (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9 and Q10). The nine member rows
     between the sign-off row and the last are new, each one of that member's manual criteria,
     US008's failed-copy walk among them (settled 30/09/2026, 16-sprint-plans grilling round 5
     Q16, as the comment heading the automated rows records); the last row gains the sign-off. No
     other row moved. -->

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Backend Tasks

<!-- The five-guide rewrite is listed here because the template has no documentation-tasks
     section and the guides are the doctrine the settings implement — on SPRINT-04's precedent,
     which carried US005's documentation deliverables under its Security Tasks. -->

| Story | Task                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Done |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US008 | Make the settings assignments — the `__Host-` names per TLS environment and `CSRF_COOKIE_HTTPONLY = True` — in one change, with no `Domain` set                                                                                                                                                                                                                                                                                                                                                                                                    | [ ]  |
| US008 | Update the settings `CONTEXT.md` table for the settings that moved                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [ ]  |
| US008 | Widen `code/src/scripts/audits/negative-space.sh` to assert presence and absence, widen its fixture pair, repoint the self-test scope                                                                                                                                                                                                                                                                                                                                                                                                              | [ ]  |
| US008 | Rewrite the five guides so `code/docs/security/CRYPTO-AND-DATA.md` owns the rule and the other four defer to it                                                                                                                                                                                                                                                                                                                                                                                                                                    | [ ]  |
| US008 | On the story's `22-implementation-documentation` pass, open the `GAPS.md` entry `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` promises at `:191`, dated the day it is written and citing the ADR's 17/09/2026 claim as the date it was owed from — never backdated to it: `.copier/migrations/shared-ai-symlinks.sh` shipped with no row in `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`'s register; recorded there, not repaired by this story (settled 28/09/2026, 16-sprint-plans grilling round 2 Q6) | [ ]  |
| US009 | Add the git-hooks step to `install.sh` as the last step of Phase 1, guarded on `git rev-parse --git-dir`, running `pnpm exec lefthook install` and failing at exit 2 otherwise, and renumber `usage()` to match — Phase 1 to nine steps, Phase 2 to steps 10 and 11                                                                                                                                                                                                                                                                                | [ ]  |
| US009 | Leave `install-frontend.sh` unchanged — the three `--ignore-scripts` flags are asserted by tests, not edited — and remove `package.json`'s `prepare`, adding the announcing `postinstall` (`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`)                                                                                                                                                                                                                                                          | [ ]  |
| US009 | Re-read `.copier/README.md:442` against the changed script, confirm it is now true, and record the re-read — **no edit to that sentence**; the file's `pnpm prepare` line is rewritten to `bash install.sh` and its Development-scripts table gains an "install-hooks.sh" row, per the story plan's P3                                                                                                                                                                                                                                             | [ ]  |
| US009 | Update `how-to/docs/DEVELOPMENT.md` and `how-to/docs/CLI-TOOLING.md` where either enumerates `install.sh`'s steps                                                                                                                                                                                                                                                                                                                                                                                                                                  | [ ]  |

<!-- AMENDED 28/09/2026 at gate 10's sign-off. The two US009 rows above read "Add the git-hooks
     step to `install.sh` after the JavaScript-dependency step, guarded on `.git`, failing at exit
     2 otherwise, and renumber the printed Phase 1 sequence and `usage()` to match" and "Leave
     `install-frontend.sh` and `package.json`'s `prepare` unchanged — the three `--ignore-scripts`
     flags are asserted by tests, not edited" until then. Both had contradicted US009's Script
     Tasks since 17/09/2026: the Accepted ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026
     removes `prepare`, the step moved to the end of Phase 1 behind a `git rev-parse --git-dir`
     guard, and the story plan settled Phase 2 as steps 10 and 11 on 18/09/2026 (assessment 7.1,
     7.3, 7.5, 7.10, signed off 28/09/2026). The US008 row naming GAPS.md is new. The ADR's
     promise of a GAPS.md entry dated 17/09/2026 was never kept: GAPS.md holds no such row,
     measured 28/09/2026. The ADR stays untouched, and the row becomes a task on US008's own
     gate-22 pass, which makes the ADR's claim true (settled 28/09/2026, 16-sprint-plans grilling
     round 2 Q6). It mirrors the story's own Documentation Task for that row. It sits here because
     this table carries the sprint's documentation work, as its comment above says. On 30/09/2026
     the row gained the entry's date, mirroring the story's task as corrected that day: the entry
     is dated the day gate 22 writes it and cites the ADR's 17/09/2026 claim as the date it was
     owed from, never backdated to it.
     CORRECTED 30/09/2026: the US009 README row read "Re-read `.copier/README.md:441`" until then.
     `:441` is a blank line; `f045aac` moved the sentence to `:442` on 18/09/2026, the text
     unchanged.
     CORRECTED 30/09/2026: the same row ended "— **no edit to that file**" until then. "No edit"
     covers the `lefthook install` sentence only; the dead `pnpm prepare` line and the
     "install-hooks.sh" row are the story plan's P3 edit to that file (recorded in
     09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the 16-sprint-plans gate). -->

### Security Tasks

| Story | Task                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Done |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US008 | Close `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` Section 7, 7.1 to 7.13, with evidence — signed off 28/09/2026, on the pattern of US005's                                                                                                                                                                                                                                                                                                                                           | [ ]  |
| US008 | Confirm each promotion trigger in `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` Section 3a names a surface or event that can actually fire it                                                                                                                                                                                                                                                                                                                                       | [ ]  |
| US008 | State the session invalidation the rename causes, a rollback's second one and why the cutover cannot be rolling, in the keyed cutover advisory whose key is derived at release per `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` (7.9, 7.13)                                                                                                                                                                                                                                                         | [ ]  |
| US009 | Assert `--ignore-scripts` on all three `install-frontend.sh` branches, scoped in the assertions' own names to three invocations of sixteen, each naming its own single line, and that `package.json` carries no `prepare` script (ST01, ST02, ST08)                                                                                                                                                                                                                                                                                           | [ ]  |
| US009 | Confirm the step resolves `lefthook` from the project's `node_modules` via `pnpm exec`, not the host, and writes nowhere outside `.git/hooks/` (ST03, ST05)                                                                                                                                                                                                                                                                                                                                                                                   | [ ]  |
| US009 | Close `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` Section 7, 7.1 to 7.14, with evidence — signed off 28/09/2026                                                                                                                                                                                                                                                                                                                                                                            | [ ]  |
| US009 | On the story's `22-implementation-documentation` pass, open the `GAPS.md` entry `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` promises at `:173`, dated the day it is written and citing the ADR's 17/09/2026 claim as the date it was owed from — never backdated to it: the eleven `pnpm install` invocations that still run dependency lifecycle scripts, TM-02, left open deliberately; this is assessment 7.2's register entry (settled 28/09/2026, 16-sprint-plans grilling round 2 Q6) | [ ]  |

<!-- REWRITTEN 28/09/2026 from both assessments' Section 7 at gate 10's sign-off (settled
     28/09/2026, 16-sprint-plans grilling round 2 Q7), on SPRINT-06's precedent of 27/09/2026. The
     rows read, until then: "US008 | Satisfy the developer constraints gate `10` produces, once it
     has run — the assessment's Section 7, on the pattern of US005's"; "US008 | Confirm each
     promotion trigger in the threat model, once written, names a surface or event that can
     actually fire it"; "US008 | State the session invalidation the rename causes, keyed where the
     advisory ships per `ADR-US008-FIRST-MINOR-MIGRATION-KEY`"; "US009 | Assert `--ignore-scripts`
     on all three `install-frontend.sh` branches and `package.json`'s `prepare` as
     byte-identical"; "US009 | Confirm the step resolves `lefthook` from the project's
     `node_modules`, not the host, and writes nowhere outside `.git/hooks/`"; and "US009 | Satisfy
     the developer constraints gate `10` produces for this story, once it has run". Gate 10 has
     run and is signed off, and both threat models exist. The FIRST-MINOR record has read
     Superseded since 17/09/2026, and the cutover notice is carried by the keyed advisory under
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026. `prepare` is removed by the Accepted
     ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026, not preserved.
     The last US009 row is new. The ADR promises that GAPS.md "carries it from 17/09/2026", and no
     such row was ever written, measured 28/09/2026. The ADR stays untouched; the row becomes a
     task on US009's own gate-22 pass, which makes the ADR's claim true (settled 28/09/2026,
     16-sprint-plans grilling round 2 Q6). US008's matching row sits under Backend Tasks, with the
     sprint's documentation work. On 30/09/2026 the row gained the entry's date, as US008's did:
     dated the day gate 22 writes it, citing the ADR's 17/09/2026 claim as the date it was owed
     from, never backdated to it. -->

### QA Tasks — Automated

- [ ] US008 — the `broken/settings/` and `clean/settings/` fixture trees and the three `EXPECTED`
      names are added, and the self-test runs, its output recorded in
      `project-management/src/18-TESTS/AUTOMATED/US008-TEST-STATUS.md`
- [ ] US008 — the discriminating comparison is recorded **before** any settings module is edited:
      three findings from the new clauses over the HEAD `ff24084` modules, none after
- [ ] US008 — the unscoped audit runs on the finished tree, and the three clauses are confirmed to
      have run rather than skipped
- [ ] US009 — the pre-commit probe and its no-`.git` negative case, the worktree probe and the
      `postinstall` probe are written and run in a job of their own, not in the generation job,
      which never executes the generated `install.sh`; the generation job keeps only the grep for
      the step, on **both** `INCLUDE_MOBILE` poles
- [ ] US009 — the `postinstall` probe's failure case is added: with no git repository, and again
      with `git` absent from `PATH`, `pnpm install` still exits 0 (QA-PLAN-US009 ES-06)
- [ ] US009 — the three `--ignore-scripts` assertions and the assertion that `package.json`
      carries no `prepare` script are added, with their output recorded in
      `project-management/src/18-TESTS/AUTOMATED/US009-TEST-STATUS.md`

<!-- AMENDED 28/09/2026 at gate 10's sign-off. The two US009 rows above read "written and wired
     into the generation job so they run on **both** `INCLUDE_MOBILE` poles" and "the three
     `--ignore-scripts` assertions and the `package.json` `prepare` assertion" until then. The
     probe's home was settled on 18/09/2026 at 17-story-plans as a job of its own, which
     ASSESSMENT-PLAN-US009-HOOK-ARMING's 7.9 records, signed off 28/09/2026; and the `prepare`
     assertion is of its absence, per the Accepted
     ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.
     REWRITTEN 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9 and Q10), from each member's QA Tasks as its story now states them. The US008 rows read
     "US008 — the self-test runs and its output is recorded in
     `project-management/src/18-TESTS/US008-TEST-STATUS.md`" and "US008 — each new fixture case
     is run against both the pre- and post-change script, and both results recorded" until then.
     The second has no script to run against: the comparison runs one way only (QA-PLAN-US008
     Section 6). The unscoped-audit row is new, and the first US009 row gains the worktree and
     postinstall probes, which US009's QA Tasks have carried since 15-decisions wrote them on
     17/09/2026, committed in 1a9da7c on 18/09/2026. The US009 row after it, the `postinstall`
     probe's failure case, joined later the same day: the task behind US009's criterion of that
     name (settled 30/09/2026, 16-sprint-plans grilling round 5 Q16). The gate runs that US008's
     task list also names stay under Verification Checks. -->

### QA Tasks — Manual

- [ ] US008 — `bash code/src/scripts/audits/doc-references.sh --path code/docs` run before the
      first edit and after the last, both exit codes and both counts recorded in
      `project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md` — the scoped criterion of
      `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` — with the whole-tree figure recorded beside
      it as a number, never as a pass
- [ ] US008 — the whole-tree `doc-references.sh` baseline captured by identity, with the detector
      hash, before the first edit; diffed at close, and every new line classified by the edit set
- [ ] US008 — the five-document read-across: one guide owns cookie scope, the other four defer to
      it, and none states the opposite; the seven other cookie-mentioning files re-read and
      recorded
- [ ] US008 — the advisory dry run, exercised as the story specifies it
- [ ] US008 — **the preview proof**: the advisory proved visible in a **successful**
      `template-update.sh` preview against a scratch copy with `SESSION_COOKIE_DOMAIN` planted,
      before the "Preview only" line, and the same run recorded surfacing the three print-only
      advisories already shipped
- [ ] US008 — the failed-copy walk: a scratch update made to fail on the copy and the preview
      run; the failure tail prints once, the script exits 2, the success-path block does not run,
      and the log is removed (QA-PLAN-US008 ES-08)
- [ ] US008 — the dev-stack cookie walk: every cookie observed on the dev stack carries dev's
      plain name and no `Domain`, and the CSRF cookie is httpOnly — the `__Host-` names are the
      TLS environments', and dev keeps its plain names
- [ ] US008 — a tester other than the author has signed the walk-through off
- [ ] US009 — the clean-clone walk-through: install into a scratch directory, make a throwaway
      commit, observe the pre-commit legs run, record the output
- [ ] US009 — the idempotence walk-through: a second `install.sh` run on the same clone duplicates
      nothing and errors nowhere
- [ ] US009 — the failure walk-through: a broken `lefthook install` exits 2 and is reported, not
      swallowed
- [ ] US009 — the `.copier/README.md` sentence that `install.sh` "runs `lefthook install`", at
      `:442` since `f045aac` (18/09/2026), read against the changed `install.sh`, confirmed true,
      and that sentence confirmed **unmodified** in the diff; the file's `pnpm prepare` line
      confirmed rewritten to `bash install.sh` and its Development-scripts table confirmed to
      carry an "install-hooks.sh" row, both the story plan's P3 edit
- [ ] US009 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, the sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is
      added. The cookie walk above is a cookie-attribute check, not a UI walk-through

<!-- REWRITTEN 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9 and Q10), from each member's QA Tasks — Manual as its story now states them. Three rows
     moved. The read-across row ended "and none states the opposite" until then, and gains the
     seven bystanders. The cookie-walk row read "every cookie observed on the dev stack carries
     its `__Host-` name and no `Domain`, and the CSRF cookie is httpOnly": wrong from the day it
     was written, because dev keeps its plain names and the prefix is set per TLS environment
     (QA-PLAN-US008 HP-04, and US008's own walk). The README row read "`.copier/README.md:441` read
     against the changed `install.sh`", and the sentence moved to :442 in f045aac on 18/09/2026.
     Two rows are new: the baseline captured by identity, and the preview proof, which US008's
     own task stated as reproducing the preview blindness until 30/09/2026 (a call made
     30/09/2026 while applying 16-sprint-plans grilling round 3, not one of its answers, accepted,
     settled 30/09/2026, 16-sprint-plans grilling round 5 Q16) and which this record had never
     carried at all. A third joined later the same
     day: the failed-copy walk, the task behind US008's criterion of that name (settled
     30/09/2026, 16-sprint-plans grilling round 5 Q16).
     CORRECTED 30/09/2026: the README row ended "and the file confirmed **unmodified** in the
     diff" until then. "Unmodified" covers the `lefthook install` sentence only; the dead
     `pnpm prepare` line and the "install-hooks.sh" row are the story plan's P3 edit to that file
     (recorded in 09-STORY-PLAN-US009 P3, 18/09/2026; applied 30/09/2026 at the 16-sprint-plans
     gate). -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The checks with nothing to look at are marked N/A with a reason rather than deleted: per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. Unlike SPRINT-03 and
     SPRINT-04, this sprint ships Python, so the type-check and test rows apply. -->

- [ ] `bash code/src/scripts/audits/negative-space.sh --self-test` exits 0 — over the widened
      fixture pair
- [ ] `bash code/src/scripts/audits/negative-space.sh` — the ordinary run passes over the tree
      with the settings in place, asserting presence and absence
- [ ] `bash code/src/scripts/audits/doc-references.sh --path code/docs` — **exit 0, Clean.** The
      criterion `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` sets: measured Clean over 174 files
      on 09/09/2026, before the story's first edit, so the story ships no new unresolved citation
      into `code/docs/`
- [ ] `bash code/src/scripts/audits/doc-references.sh` (whole tree) — **read as a diff against
      the baseline captured before the story's first edit**, per ADR-US003, and never as a bare
      pass while that baseline stands. If US004 — SPRINT-03's sole `Must`, built before this
      sprint — has landed and the gate has gone green, the plain-pass reading applies; both
      branches are named, as SPRINT-04 named them for US005 and US006. The figure this record
      measured on opening is **253** (09/09/2026, HEAD `ff24084`, index state in the Notes); the
      story re-captures its own immediately before its first edit, in the index state it will be
      measured in
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance. Files to watch: the five guides US008 edits, none
      of which the gate named on 09/09/2026 (777 files checked, no warning against any of them;
      raw `wc -l` 156, 185, 188, 210 and 194 in the order the Acceptance Criteria list them).
      `code/src/scripts/audits/CONTEXT.md` is US002's headroom and is not grown here; see
      Dependencies. **The bare figure that stood here — 298 — is stale**: the gate measured it at
      **299 of 300** on 17/09/2026, and `GAPS.md`'s entry of that date records that 19 artefacts
      under `project-management/src/` assert the old number. The guard is the gate's reading at
      implementation time, not a literal in this file. US009 adds files under neither path
- [ ] **The `[3/4] Template Generation` job is green on both answer sets** — US009's criterion;
      the generated `install.sh` carries the git-hooks step under `INCLUDE_MOBILE` false and true
- [ ] **US009's probe job is green** — the pre-commit probe, its no-`.git` negative case, the
      worktree probe and the `postinstall` probe, in the job of their own the QA criteria above
      name, never in the generation job
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; the two members edit
      existing pairs under `code/src/django/config/settings/` and `code/src/scripts/development/`
      and create no directory, so no new pair is owed
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. It reads fenced code,
      and no claim row in its table covers a settings line, so it cannot see the two blocks US008
      edits, as that story's Verification Checks state; neither the story nor gate `11`, closed
      30/09/2026, registers a claims row for the cookie rule. A green run says the registered
      claims are undisturbed and says **nothing** about the rule living in one home; it is never
      reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, the member adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — ruff over the settings modules and
      markdownlint-cli2 over the five guides. **ShellCheck over `negative-space.sh` is what a
      widened script asks for and `lint.sh` does not carry it**: its legs are ruff,
      markdownlint-cli2, ESLint and clippy (`code/src/scripts/syntax/CONTEXT.md`), and on
      09/09/2026 — re-checked, on SPRINT-03's and SPRINT-04's finding of the day before — no
      script under `code/src/scripts/`, no CI workflow and no lefthook entry runs ShellCheck. It
      is recorded in `project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md` as run or as not
      run, never as a `lint.sh` pass, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **applies here**, unlike in SPRINT-03 and
      SPRINT-04: its basedpyright leg reads the settings modules US008 edits. US009 ships bash,
      which that leg does not read; the ShellCheck caveat recorded above for `negative-space.sh`
      applies to US009's changed `install.sh` in exactly the same terms, and for the same reason —
      no script, CI workflow or lefthook entry runs ShellCheck
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, the sprint's DB flag reads
      `N/A`
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — the suite runs as a regression over the
      settings change and passes; no coverage-floor claim is made on the settings modules, as
      US008's own Verification Checks record
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component
      added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, against both assessments'
      Section 7 as signed off on 28/09/2026, US008's 7.1 to 7.13 and US009's 7.1 to 7.14, which
      the Security Acceptance Criteria above now carry
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

<!-- AMENDED 28/09/2026 at gate 10's sign-off. Two rows above changed. The coverage row read
     "whether the coverage floor binds the settings modules is gate `11`'s call, recorded as open
     in the QA Acceptance Criteria", and the security row "against gate `10`'s output once it
     exists; the first-pass rows above are the manifest, not the sign-off", until then. US008's
     Verification Checks have made no floor claim since 09/09/2026; gate 10's output has existed
     since 17/09/2026 and was signed off on 28/09/2026.
     AMENDED 30/09/2026 at gate 11's close (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9 and Q10). The doctrine-drift row read "regression only, unless the story registers a
     claims row for the cookie rule, which is the story's and gate `11`'s to state" until then.
     Gate 11 has closed, and neither it nor
     project-management/src/02-STORIES/US008.md -> Verification Checks registers one; the story
     states why the audit cannot see the settings blocks, and the row now says so. The probe-job
     row is new the same day: the four probes are US009's QA criteria, and
     project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md -> Sprint Verification Checklist
     has carried the check since it was written on 17/09/2026, while deferring to this list as
     the full one. -->

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US008 alone. US009 is the `Should Have` stretch tier: it is included in
      the plan and is the first thing dropped if US008 overruns
      (`project-management/docs/planning/SPRINTS.md` -> _MoSCoW_), and dropping it does **not**
      fail the sprint
- [ ] **If US009 is dropped rather than delivered**, it is recorded here with its reason and
      carried into `project-management/src/03-SPRINTS/SPRINT-06.md` with its **5 SP** reserved
      there — the six-artefact discipline SPRINT-03 set on 05/09/2026 for US003, and the backlog
      register in the Notes is updated in every copy in the same change. That record's own
      Definition of Done receives the reservation from this side, and its capacity line already
      licenses the 13 / 11 the carry would produce

<!-- 20/09/2026, on the Definition of Done row above: it read "carried into the next record with
     its 3 SP reserved there ... updated in all five records" until SPRINT-06 existed to be named.
     The 3 was stale from US009's 17/09/2026 re-estimate; "the next record" was written when there
     was none. The note is lifted OUT of the list item because Prettier re-indents a comment's
     continuation lines inside one on every pass and never converges — the blocking pre-commit
     format gate then fails on a file nothing else is wrong with. -->

- [ ] **Nothing carries into this record, and nothing is expected to.** US003's carry is reserved
      into SPRINT-03 by SPRINT-02's Definition of Done; SPRINT-04 is closed at grace. If a story
      arrives here anyway, it is recorded in both records with its reason and the capacity line
      recomputed — a `Should` of up to 5 SP is the stretch reading in the Notes, and a second
      `Must` of 8 is 16 / 11, refused on arithmetic before it is argued
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in **either member's** QA plan — both written at
      gate `11` and `Reviewed` on 17/09/2026, all nineteen gaps resolved, and signed off on
      30/09/2026, when gate `11` closed; ticked against the plans as committed
- [ ] The Security and QA rows of the FLAGS table, and the sections they govern, were recomputed
      when gates `10` and `11` closed for both members, and the union still equals US008's table
      unioned with US009's
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity. Each trigger is named in the planning threat models' Section 3a,
      written 17/09/2026 and signed off 28/09/2026: nine US008 threats, across six trigger rows,
      and five US009 threats promote to `HIGH`
- [ ] Retrospective notes captured (optional — link or inline)

<!-- AMENDED 28/09/2026 at gate 10's sign-off. Two rows above changed. The QA plan row read "—
     once gate `11` has written them", and the promotion-trigger row "— once the threat model
     exists", until then. Both QA plans and both threat models have existed since 17/09/2026, and
     the threat models were signed off on 28/09/2026. -->
