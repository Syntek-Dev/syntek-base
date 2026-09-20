# SPRINT-05

**Last Updated**: 20/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
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
     and each row is recomputed at those gates' close. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                                                       |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| GDPR       | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Security   | host-only cookie scope (no `Domain`, ever) · `__Host-` names per TLS environment · CSRF cookie httpOnly · session invalidation at the deploy that renames · gate asserts presence and absence · supply-chain — `--ignore-scripts` preserved on all three `install-frontend.sh` branches, the hook-arming moment made explicit                                                                               |
| QA         | unit — `negative-space.sh --self-test` over a widened fixture pair, self-test scope repointed with the real one; integration — the pre-commit probe and its no-`.git` negative case, the generation probe on both answer sets; manual — `doc-references.sh --path code/docs`, the five-document read-across, the advisory dry run, the dev-stack cookie walk, the `.copier/README.md` claim re-read as true |
| SEO        | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| API        | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Logging    | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |
| Backend    | Yes                                                                                                                                                                                                                                                                                                                                                                                                         |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                                                         |

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
  every story until `doc-references.sh` goes green; it sequences nothing.
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
  plans on disk on 09/09/2026 — and US008 builds eighth, behind SPRINT-04's last member. The next
  free prefix is `08-`, and that number is reserved, not a plan: `17-story-plans` writes it, and
  nothing here may cite it as one (SPRINT-04's rule for US006's `07-`, which has since been
  written). **US009 builds ninth, at a reserved `09-`**, behind US008 — settled 17/09/2026 at its
  admission. Nothing is renumbered: `project-management/docs/planning/STORIES.md` makes the story
  plan's prefix the position in the settled build order across the whole backlog and renumbers it
  whenever that order changes, and appending US009 at the end changes no other story's position.
  It builds behind US008 because the `Must` ships before the stretch; the priority claim
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` makes for `S-11` orders slices
  inside the Gate Parity epic and does not reach the backlog's build order. When `16-sprint-plans`
  writes this sprint's plan, both segments of `{exec-order}-SPRINT-PLAN-{sprint-number}.md` read
  `05`.
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
| `SPRINT-07` | US011 (`Should`, 8)                                             | 8 / 11 — open, `Must` tier absent                           |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

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
followed at `08-` and `09-`. **The specify tier's artefacts all exist for both members, and one
leg of it is not yet signed off** — measured 20/09/2026, and stated as two facts rather than one so
neither is read as the other:

- **Present and reviewed.** `15-decisions` has run — US008 carries five ADRs and US009 one under
  `project-management/src/15-DECISIONS/`. Gate `11` has closed: both QA plans under
  `project-management/src/11-QA/PLANNING/` read `Reviewed`, with all ten and all nine `AC-GAP`
  entries resolved into their stories. GDPR, SEO, API and Logging are skipped by flag for both.
- **Present and NOT yet signed off.** All four `10-SECURITY` artefacts — a threat model and an
  assessment per member — read `**Status:** Draft`, and both US009 ones say in terms that they are
  not yet reviewed by <%DEVELOPER_NAME%>. `project-management/docs/planning/CADENCE.md` requires the
  security threat model and assessment **complete**, not merely written, so **gate `10` is
  outstanding for both members**. Per `code/docs/GATE-REPORTING.md` that is reported here rather
  than folded into the sentence above: an artefact existing is not a gate passing.

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
- **The plan counts only stories that have cleared the specify tier: 13, since 17/09/2026.**
  `CADENCE.md` -> _When a sprint plan is written_ names the prerequisites that must hold for
  **every story in the filling sprint** — `15-decisions` cleared, GDPR review, security threat
  model and assessment, a QA plan with no unresolved `AC-GAP`, an SEO plan or `SEO: N/A` with a
  reason, an API contract or no Ninja surface — and closes: "A story that cannot satisfy these is
  **not ready to be counted towards the sprint**." Both members now satisfy them; neither did when
  this record opened on 09/09/2026, and the gap between those two dates is the whole reason the
  two numbers are stated separately.

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
below are first-pass values from the manifest, each rewritten at its gate's close.

**The citation gate is inherited red, and this record adds its own findings to it — expected, not
a regression.** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
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

**US009** — `install.sh` installs the git hooks as an explicit, reported step after the
JavaScript-dependency step, guarded on `.git` so a tree without a repository is skipped and the
install continues, and hard-failing at exit 2 in the house `err` idiom when `lefthook install`
genuinely cannot complete; the `--ignore-scripts` supply-chain control stays on all three
`code/src/scripts/development/install-frontend.sh` branches and `package.json`'s `prepare` script
is untouched, so the hook is never armed as a package-manager side effect; and
`.copier/README.md:441`'s existing claim that `install.sh` runs `lefthook install` becomes true
**without that file being edited**.

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
     reported as such — not a gate that found nothing. -->

- [ ] **Host-only cookie scope** — no `Domain` attribute on any cookie, ever
- [ ] **`__Host-` names per TLS environment**
- [ ] **CSRF cookie httpOnly**
- [ ] **Session invalidation at the deploy that renames** — stated in the story's deliverable, so
      the operator is told what happens to live sessions rather than finding out
- [ ] **The gate asserts presence and absence** — a tested setting is not an enforced one until
      something fails when it is missing or when a `Domain` appears
- [ ] **US009 — `--ignore-scripts` preserved on all three `install-frontend.sh` branches**,
      asserted in the diff rather than assumed, with `package.json`'s `prepare` byte-identical
- [ ] **US009 — the hook-arming moment is explicit**: the step runs after dependency installation,
      resolves `lefthook` from the project's own `node_modules` rather than the host's, adds no
      network fetch, no credential read and no write outside `.git/hooks/`, and its `.git` guard
      tests for a repository only — never a general try/ignore that would hide a real failure
- [ ] **No CRITICAL or HIGH finding is open** — cannot be ticked until gate `10` has run **for
      both members**; the row is here so that its absence is not read as a pass
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### QA Acceptance Criteria — Automated

<!-- First-pass from the manifest; no QA-PLAN-US008-* exists under
     project-management/src/11-QA/PLANNING/ on 09/09/2026. Rewritten at gate 11's close. -->

- [ ] `bash code/src/scripts/audits/negative-space.sh --self-test` exits 0 over the widened
      fixture pair, with the self-test's scope repointed to the scan's real scope
- [ ] Every fixture case US008 adds fails against the pre-change script and passes against the
      post-change one — a fixture that passes both proves nothing (SPRINT-03's criterion for a
      widened gate)
- [ ] US009 — the `[3/4] Template Generation` job generates a project on **both** answer sets
      (`INCLUDE_MOBILE` false and true) and the generated `install.sh` carries the step in each
- [ ] US009 — a pre-commit probe asserts that after `install.sh` completes in a git checkout,
      `.git/hooks/pre-commit` exists and is lefthook's, and its negative case asserts that a tree
      with no `.git` reports the skip and continues rather than exiting non-zero
- [ ] US009 — the existing `template-integrity` pre-commit leg still passes
- [ ] Coverage floors — **not marked N/A here.** US008 ships Python — settings assignments — and
      whether the floor binds settings modules is gate `11`'s call for that story; US009 ships
      bash, which the floor does not reach. Recorded as open rather than decided by a record that
      has not seen either QA plan

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US008-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US009-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in **either member's** QA plan — which gate
      `11` has yet to write for either; until they exist this row cannot be ticked, and its
      absence is not a pass

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Backend Tasks

<!-- The five-guide rewrite is listed here because the template has no documentation-tasks
     section and the guides are the doctrine the settings implement — on SPRINT-04's precedent,
     which carried US005's documentation deliverables under its Security Tasks. -->

| Story | Task                                                                                                                                                                                          | Done |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US008 | Make the settings assignments — the `__Host-` names per TLS environment and `CSRF_COOKIE_HTTPONLY = True` — in one change, with no `Domain` set                                               | [ ]  |
| US008 | Update the settings `CONTEXT.md` table for the settings that moved                                                                                                                            | [ ]  |
| US008 | Widen `code/src/scripts/audits/negative-space.sh` to assert presence and absence, widen its fixture pair, repoint the self-test scope                                                         | [ ]  |
| US008 | Rewrite the five guides so `code/docs/security/CRYPTO-AND-DATA.md` owns the rule and the other four defer to it                                                                               | [ ]  |
| US009 | Add the git-hooks step to `install.sh` after the JavaScript-dependency step, guarded on `.git`, failing at exit 2 otherwise, and renumber the printed Phase 1 sequence and `usage()` to match | [ ]  |
| US009 | Leave `install-frontend.sh` and `package.json`'s `prepare` unchanged — the three `--ignore-scripts` flags are asserted by tests, not edited                                                   | [ ]  |
| US009 | Re-read `.copier/README.md:441` against the changed script, confirm it is now true, and record the re-read — **no edit to that file**                                                         | [ ]  |
| US009 | Update `how-to/docs/DEVELOPMENT.md` and `how-to/docs/CLI-TOOLING.md` where either enumerates `install.sh`'s steps                                                                             | [ ]  |

### Security Tasks

| Story | Task                                                                                                                           | Done |
| ----- | ------------------------------------------------------------------------------------------------------------------------------ | ---- |
| US008 | Satisfy the developer constraints gate `10` produces, once it has run — the assessment's Section 7, on the pattern of US005's  | [ ]  |
| US008 | Confirm each promotion trigger in the threat model, once written, names a surface or event that can actually fire it           | [ ]  |
| US008 | State the session invalidation the rename causes, keyed where the advisory ships per `ADR-US008-FIRST-MINOR-MIGRATION-KEY`     | [ ]  |
| US009 | Assert `--ignore-scripts` on all three `install-frontend.sh` branches and `package.json`'s `prepare` as byte-identical         | [ ]  |
| US009 | Confirm the step resolves `lefthook` from the project's `node_modules`, not the host, and writes nowhere outside `.git/hooks/` | [ ]  |
| US009 | Satisfy the developer constraints gate `10` produces for this story, once it has run                                           | [ ]  |

### QA Tasks — Automated

- [ ] US008 — the self-test runs and its output is recorded in
      `project-management/src/18-TESTS/US008-TEST-STATUS.md`
- [ ] US008 — each new fixture case is run against both the pre- and post-change script, and
      both results recorded
- [ ] US009 — the pre-commit probe and its no-`.git` negative case are written and wired into the
      generation job so they run on **both** `INCLUDE_MOBILE` poles
- [ ] US009 — the three `--ignore-scripts` assertions and the `package.json` `prepare` assertion
      are added, with their output recorded in
      `project-management/src/18-TESTS/US009-TEST-STATUS.md`

### QA Tasks — Manual

- [ ] US008 — `bash code/src/scripts/audits/doc-references.sh --path code/docs` run before the
      first edit and after the last, both exit codes and both counts recorded in
      `project-management/src/18-TESTS/US008-MANUAL-TESTING.md` — the scoped criterion of
      `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` — with the whole-tree figure recorded beside
      it as a number, never as a pass
- [ ] US008 — the five-document read-across: one guide owns cookie scope, the other four defer to
      it, and none states the opposite
- [ ] US008 — the advisory dry run, exercised as the story specifies it
- [ ] US008 — the dev-stack cookie walk: every cookie observed on the dev stack carries its
      `__Host-` name and no `Domain`, and the CSRF cookie is httpOnly
- [ ] US008 — a tester other than the author has signed the walk-through off
- [ ] US009 — the clean-clone walk-through: install into a scratch directory, make a throwaway
      commit, observe the pre-commit legs run, record the output
- [ ] US009 — the idempotence walk-through: a second `install.sh` run on the same clone duplicates
      nothing and errors nowhere
- [ ] US009 — the failure walk-through: a broken `lefthook install` exits 2 and is reported, not
      swallowed
- [ ] US009 — `.copier/README.md:441` read against the changed `install.sh`, confirmed true, and
      the file confirmed **unmodified** in the diff
- [ ] US009 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, the sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is
      added. The cookie walk above is a cookie-attribute check, not a UI walk-through

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
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; the two members edit
      existing pairs under `code/src/django/config/settings/` and `code/src/scripts/development/`
      and create no directory, so no new pair is owed
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only, unless the story
      registers a claims row for the cookie rule, which is the story's and gate `11`'s to state. A
      green run says the registered claims are undisturbed and says **nothing** about the rule
      living in one home; it is never reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, the member adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — ruff over the settings modules and
      markdownlint-cli2 over the five guides. **ShellCheck over `negative-space.sh` is what a
      widened script asks for and `lint.sh` does not carry it**: its legs are ruff,
      markdownlint-cli2, ESLint and clippy (`code/src/scripts/syntax/CONTEXT.md`), and on
      09/09/2026 — re-checked, on SPRINT-03's and SPRINT-04's finding of the day before — no
      script under `code/src/scripts/`, no CI workflow and no lefthook entry runs ShellCheck. It
      is recorded in `project-management/src/18-TESTS/US008-MANUAL-TESTING.md` as run or as not
      run, never as a `lint.sh` pass, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **applies here**, unlike in SPRINT-03 and
      SPRINT-04: its basedpyright leg reads the settings modules US008 edits. US009 ships bash,
      which that leg does not read; the ShellCheck caveat recorded above for `negative-space.sh`
      applies to US009's changed `install.sh` in exactly the same terms, and for the same reason —
      no script, CI workflow or lefthook entry runs ShellCheck
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, the sprint's DB flag reads
      `N/A`
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — the suite runs as a regression over the
      settings change and passes; whether the coverage floor binds the settings modules is gate
      `11`'s call, recorded as open in the QA Acceptance Criteria
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component
      added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, against gate `10`'s output once
      it exists; the first-pass rows above are the manifest, not the sign-off
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

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
- [ ] No `[OPEN]` acceptance-criteria gap remains in **either member's** QA plan — once gate `11`
      has written them
- [ ] The Security and QA rows of the FLAGS table, and the sections they govern, were recomputed
      when gates `10` and `11` closed for both members, and the union still equals US008's table
      unioned with US009's
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity — once the threat model exists
- [ ] Retrospective notes captured (optional — link or inline)
