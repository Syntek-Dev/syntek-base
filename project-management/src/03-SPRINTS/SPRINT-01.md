# SPRINT-01

**Last Updated**: 07/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Two rules get exactly one owner each before anything downstream writes against them —
the story status vocabulary is defined in one document that every skill, workflow and template
writing the field routes to, and cross-surface retry and idempotency doctrine lives in one owning
guide that every pointer reaches.

<!-- The goal read "Wave 1 gets both the homes and the headroom it writes into — an owning guide for
     cross-surface retry and idempotency, and room in the audit register for the gates that follow."
     until 07/09/2026, when US002 moved to SPRINT-02 and US007 was admitted here. The audit-register
     headroom is now SPRINT-02's deliverable, and a goal naming a deliverable no member carries is
     the drift SPRINT-02.md's own goal comment names. Rewritten rather than trimmed, because the
     sprint's subject changed with its membership: both members now give a rule one owner. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **5 SP Must + 5 SP Must = 10 / 11 SP** — inside capacity, all
`Must`, and **CLOSED** again. See Notes.

<!-- Read "8 / 11 SP" from 02/09/2026 until 07/09/2026 — closed by decision at two members, US001
     and US002. Reopened on 07/09/2026 to admit US007 and release US002 to SPRINT-02, and closed
     again the same day at the figure above. The reasoning that closed it at eight is kept in the
     Notes, superseded, because it records a decision that was taken. -->

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Recomputed 01/09/2026 when the QA gate added doctrine-drift.sh to US001's QA value
     (QA-PLAN-US001 AC-GAP-6).
     Recomputed 02/09/2026 on US002's admission and UNCHANGED: US002's QA value was a SUBSET of
     US001's — three of the same four gates, with doc-references.sh scoped — and its other twelve
     rows N/A, so the union over two members was US001's table.
     (Corrected 05/09/2026: this read "identical to US001's — twelve N/A and the same four-gate
     manual QA value". The union result was and is right; the justification was not, and it is
     the justification a future recompute would trust.) Recorded rather than skipped,
     because a recomputation that changes nothing and a recomputation nobody ran are
     indistinguishable in the result.
     Recomputed 07/09/2026 on US002's DEPARTURE to SPRINT-02 and US007's ADMISSION, and CHANGED
     in one row. The departure narrows NOTHING: US002 was the sole carrier of no value — the
     02/09/2026 entry above records its QA value as a subset of US001's — so removing it leaves
     the union where it stood. The admission WIDENS the QA row by one gate: US007's flag names
     the four gates US001's does plus skill-conformance.sh, which enters this union with US007
     alone. Its other twelve rows are N/A and change nothing. A union narrows only when a member
     leaves and widens only when one arrives; both happened here and only the second moved a row.
     QUALIFIERS, so they are not read as drift: US007's own flag annotates three of its five gates
     with the regime it reads them under — doc-references.sh (baseline diff), doctrine-drift.sh
     (regression guard only), skill-conformance.sh (attributed diff) — and US001's annotates
     none. An annotation is how a story reads a gate, not a different gate, so the union names
     each gate once and the Verification Checks below carry the regime per member. Neither
     story's own flag is rewritten to match the other; SPRINT-03 set the precedent on a spelling
     difference. Twelve rows stay N/A because both members ship Markdown only: no model, no
     endpoint, no screen, no personal-data path, no log line, no public page. -->

| Flag       | Value                                                                                                          |
| ---------- | -------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                            |
| User Flow  | N/A                                                                                                            |
| Brand      | N/A                                                                                                            |
| Components | N/A                                                                                                            |
| Wireframes | N/A                                                                                                            |
| GDPR       | N/A                                                                                                            |
| Security   | N/A                                                                                                            |
| QA         | manual — `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh`, `skill-conformance.sh` |
| SEO        | N/A                                                                                                            |
| API        | N/A                                                                                                            |
| Logging    | N/A                                                                                                            |
| Backend    | N/A                                                                                                            |
| Frontend   | N/A                                                                                                            |

---

## Story Summary

| ID    | Title                                                                                                          | MoSCoW    | SP  |
| ----- | -------------------------------------------------------------------------------------------------------------- | --------- | --- |
| US007 | The story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits | Must Have | 5   |
| US001 | Reliability doctrine gets an owning guide, and every pointer reaches it                                        | Must Have | 5   |

**Total:** 10 SP — all committed, no stretch tier; rows listed in build order. **The all-`Must`
shape is this sprint's known weakness**; see Notes.

<!-- US002 (Must Have, 3 SP) was here from 02/09/2026 until 07/09/2026 and is now in
     project-management/src/03-SPRINTS/SPRINT-02.md. Removed from this table rather than struck
     through, on SPRINT-02's own precedent for US003: SPRINTS.md computes this sprint's flag union
     and capacity FROM this table, and a story in two Story Summaries is counted twice. The move
     and its reasoning are in the Notes. -->

## Dependencies

- **Neither member has an upstream dependency, and neither depends on the other.** Both are wave 0
  of the cutting order and wait on nothing. They share no file: US007 writes into the planning
  guides, the `completion` skill, three workflows, the PM templates, the live sprint records and
  plans, the README seed and one map; US001 writes into `code/docs/` and the four index surfaces
  that register the family it creates.
- **The build order is nevertheless fixed — US007 first, then US001 — settled 07/09/2026 and not
  to be re-derived here.** It is a sequencing call, not a dependency: US007 must ship before US002,
  which now opens SPRINT-02, and putting it first means the vocabulary is settled before anything
  in this sprint or the next writes a `**Status:**` value against it.
- **US007 unblocks US002's line of work, and US002 is in SPRINT-02.** US002 unblocks
  `MAP-REGISTER-INDEXES.md` slice `S-03` (`register-indexes.sh`), whose `broken/` + `clean/`
  status fixtures are built against whichever vocabulary is canonical on the day they are written
  (`project-management/src/02-STORIES/US007.md` -> Dependencies). That is the constraint that
  brought US007 here rather than to SPRINT-04, and it makes SPRINT-01 -> SPRINT-02 an execution
  order and not only a numbering — the first pair in this backlog where the two agree.
- **US001 unblocks** slices `S-02` and `S-03` on the retry-and-idempotency feature map, the
  reliability half of slice `S-01` on the CAP-posture map — and **US005, now in SPRINT-04**, whose
  four rules are stated inside the `code/docs/reliability/` family US001 creates. US005 sat in
  SPRINT-03 until 07/09/2026; the blocker is unchanged, the sprint it waits in is not.
- **US002's own unblocking table travelled with it** to SPRINT-02 — the nine audit registrations
  across eight slices and seven maps that each need two rows in a register with two lines of
  headroom. Its full table is in `project-management/src/02-STORIES/US002.md`.
- None of the downstream slices above is yet cut into a story, so none could be admitted here even
  were the record open — and per the Notes below, it is not.

<!-- The third, fifth and sixth bullets replace these two, superseded 07/09/2026:
     "- **US002 unblocks nine audit registrations across eight slices and seven maps** — every story
        that adds a script under `code/src/scripts/audits/` needs two rows in a register with two
        lines of headroom. Its full table is in `project-management/src/02-STORIES/US002.md`.
      - None of those downstream slices is yet cut into a story, so none can be admitted here until
        it is — and per the Notes below, this sprint is closed to further members regardless."
     The first is now a fact about SPRINT-02's member and is restated there; the second's "closed
     regardless" cross-referenced the 8 / 11 closure the Notes have since superseded. -->

## Notes

**This record was re-planned on 07/09/2026, before it or any other sprint was worked.** US007 —
_The story status vocabulary gets one owner, and every instruction that writes it uses a value the
owner admits_, `Must Have`, 5 SP — was cut that day, and it has to ship **before** US002, because
US002 unblocks the gate that will string-compare every `**Status:**` value against whichever
vocabulary is canonical when its fixtures are written. <%DEVELOPER_NAME%> settled the shape as a
**full cascade rather than an execution reorder**: US007 enters here, US002 moves to SPRINT-02,
US003 moves from SPRINT-03 to SPRINT-02 as that sprint's `Should` stretch, US004 moves from
SPRINT-02 to SPRINT-03, and US005 moves from SPRINT-03 to SPRINT-04 beside US006. Every sprint is
`Planned` and unworked, so this is a **re-plan, not a carry-over** — the distinction
`project-management/src/03-SPRINTS/SPRINT-03.md` -> Notes draws for US003's move of 05/09/2026,
which is the precedent this cascade follows. The four records after it:

| Sprint      | Members, in build order                                         | Capacity                                          |
| ----------- | --------------------------------------------------------------- | ------------------------------------------------- |
| `SPRINT-01` | US007 (`Must`, 5) then US001 (`Must`, 5)                        | **10 / 11 SP** — closed                           |
| `SPRINT-02` | US002 (`Must`, 3) then US003 (`Should`, 5, stretch)             | 8 / 11 SP                                         |
| `SPRINT-03` | US004 (`Must`, 8), plus US003's reserved 5 SP carry if it slips | 8 / 11 SP, or 13 / 11 SP with the carry           |
| `SPRINT-04` | US005 (`Must`, 5) then US006 (`Must`, 8)                        | 13 / 11 SP — at grace, taken deliberately, closed |

Each record owns its own row. The table is here so that a reader of this file can see where its
former member went and why its own figure moved — not so that another sprint can be edited from
here.

**This sprint is CLOSED at two members and 10 of 11 SP, by decision rather than by fill**
(07/09/2026). The record is a running ledger — opened as the first story clears the per-story loop
and accumulating each later story with its points — but a ledger is closed by a call, not only by a
ceiling. `project-management/docs/planning/CADENCE.md:117-118` is explicit that capacity is a
**trigger and not a target**: _"A sprint that lands on 10 SP because the next story is a 5 is a
correct sprint, not an under-filled one."_ Ten is now that case to the letter. This record closed
once before, at eight, on the same reading; the paragraph that closed it is kept below as history.

<!-- The paragraph replaced here read: "**This sprint is CLOSED at two members and 8 of 11 SP, by
     decision rather than by fill** (02/09/2026). The record is a running ledger — opened as the
     first story clears the per-story loop and accumulating each later story with its points — but
     a ledger is closed by a call, not only by a ceiling. `project-management/docs/planning/CADENCE.md`
     is explicit that capacity is a trigger and not a target: _"A sprint that lands on 10 SP
     because the next story is a 5 is a correct sprint, not an under-filled one."_ Eight is that
     case." True from 02/09/2026 and superseded on 07/09/2026, when the record was reopened to
     admit US007 and release US002. Kept rather than erased, so the earlier closure reads as a
     decision that was taken and then deliberately revisited, not one that quietly lapsed. -->

**US007 came here and not to SPRINT-04, and the record that said otherwise is being corrected in
step.** `project-management/src/03-SPRINTS/SPRINT-03.md` -> Notes, in an edit of 06/09/2026, routed
US007 "to `SPRINT-04` beside `US006`". That routing predates the grilling pass that cut the story
and found the ordering constraint above; it is superseded by this re-plan, and SPRINT-03's own
record supersedes it on its own convention rather than this one deleting it at a distance. US007's
own Dependencies section (`project-management/src/02-STORIES/US007.md`) still cites that SPRINT-03
paragraph as the one that "currently sends this story to `SPRINT-04`" and says moving it "is a
re-plan those records own" — which is this re-plan. That sentence is now stale, and it is the story
file's own move note to correct.

**US003 was not admitted here on 02/09/2026, and is still not.** An earlier revision of this record
named it as expected to join; that expectation was withdrawn because admitting it would have taken
this sprint to roughly 13 SP — the grace ceiling — and grace exists for a story that would split
badly, not as a routine allowance. Nothing in this re-plan changes that: this sprint stands at ten
with two `Must` members, and US003 sits in SPRINT-02 as its `Should` stretch, having gone SPRINT-02
-> SPRINT-03 on 05/09/2026 and SPRINT-03 -> SPRINT-02 on 07/09/2026, with its 5 SP carry reserved
into SPRINT-03 — the same shape it held one sprint later until today.

<!-- The paragraph replaced here read: "**US003 — slice `S-01` of the absence feature map — opens
     SPRINT-02.** It is the third and last wave-0 Must, and an earlier revision of this record
     named it as expected to join here. **That expectation is withdrawn.** Admitting it would have
     taken this sprint to roughly 13 SP, which is the grace ceiling rather than the capacity — and
     grace exists for one situation, a story that would split badly, not as a routine allowance.
     The absence guide is not a story this sprint had to have." Written 02/09/2026, when US003 was
     a Must and SPRINT-02's first member. Superseded 07/09/2026: US003 has been a `Should Have`
     since 16-sprint-plans on 02/09/2026, it no longer OPENS SPRINT-02 — US002 does — and the
     refusal's reasoning is the part that still stands, so it is restated above. -->

**Both members are `Must`, and that is recorded rather than papered over.**
`project-management/docs/planning/SPRINTS.md` warns that an all-`Must` plan has no give. This
sprint has had that shape since 02/09/2026 — US001 and US002 were both `Must` — and SPRINT-04 names
the same shape as its own known weakness. The give would have to be a `Should` from a map neither
member owns; every open slice that is cut belongs to a later sprint by the cascade above, and none
is admitted to repair a shape this record had already accepted at eight.

**Nothing further is admitted here.** Where a story cut after today goes is a question for
`03-sprint-planning` against the record with room for it — and SPRINT-04 is not that record, being
at grace and closed to further admission by <%DEVELOPER_NAME%>'s call of 07/09/2026.

<!-- The paragraph replaced here read: "**Nothing further is admitted here.** A fourth wave-0 or
     wave-1 story goes to SPRINT-02 beside US003. Sprint plans (`16-sprint-plans`) and story plans
     (`17-story-plans`) run for this sprint once both members have cleared `15-decisions`; US001
     has, US002 has not." Superseded 07/09/2026: US003 is SPRINT-02's stretch tier rather than its
     anchor, US002 is no longer a member here, and where a new story goes is not this record's to
     say. The plan sentence is restated below against the new membership. -->

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once both
members have cleared `15-decisions`.** US001 has:
`project-management/src/17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` is written,
and its `| Sprint |` row already reads `SPRINT-01 · Wave 0 · build order 2`, which this re-plan
leaves true. US007 has not: on 07/09/2026 it has cleared `02-story-creation` and is admitted here at
`03-sprint-planning`, with its QA plan and the rest of its per-story loop still to run — the same
standing US002 had when this record first admitted it on 02/09/2026. Two consequences, both for
other owners and neither taken here:

- `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` was written on 02/09/2026 against
  US001 and US002 at 8 SP, with US002 first in its build order. Against this record it is now stale
  in its capacity line, its story set, its build order and its story-plan index, and the story
  plan it names for US002 carries a `| Sprint |` row that must itself move to SPRINT-02. Rewriting
  it is a `16-sprint-plans` pass against this record, and `CADENCE.md`'s prerequisite for that pass
  — every member cleared `15` — is not yet met by US007. Until it is, the plan stands as the record
  of the 02/09/2026 membership and reads stale against this one.
- No `STORY-PLAN-US007` exists, and none is written here: `17-story-plans` owns it and runs after
  `16`.

---

## Acceptance Criteria

Two independent outcomes, one per member, and the five documentation gates in the union run against
both — four for US001, five for US007 — each recorded under the regime the Verification Checks
give it.

**US007** — one set of eleven story statuses exists and `project-management/docs/planning/STORIES.md`
is the only document that defines it; every skill, workflow, template and README seed that writes
or lists a `**Status:**` value into this repository's own artefacts routes to that section and uses
a value it admits; the sprint set — `Planned` · `In Progress` · `Done` — takes the same shape one
register over in `SPRINTS.md`; and nothing is renamed and no live source value changes, measured
rather than assumed.

**US001** — cross-surface retry and idempotency doctrine has exactly one owning home, every rule
that moved has left its old one, and every pointer reaches the new one.

<!-- US002's outcome — "`code/src/scripts/audits/CONTEXT.md` ends at or under 230 counted lines with
     every register it owns intact, the lines paid for by deleting restatements of rules owned
     elsewhere rather than by deleting facts" — moved with the story to
     project-management/src/03-SPRINTS/SPRINT-02.md on 07/09/2026. -->

### QA Acceptance Criteria — Manual

<!-- The automated QA sections are removed: this sprint's QA flag names a manual type and no
     automated one, matching both members, which ship documentation and no code path between them.
     Per code/docs/GATE-REPORTING.md the skip is recorded here rather than left to be inferred. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US007-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US001-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in either member's QA plan —
      `project-management/src/11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` (six
      found, six resolved), and US007's, which does not yet exist and is written when its
      `11-qa-checks` gate runs

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### QA Tasks — Manual

- [ ] US007 — the five gates named in its own flag run, and their output recorded in
      `project-management/src/18-TESTS/US007-MANUAL-TESTING.md`, with `doc-references.sh` and
      `skill-conformance.sh` recorded against baselines captured by identity immediately before
      the first edit — an empty baseline recorded as empty — rather than against a state quoted
      from the story
- [ ] US007 — each route the story writes is read in place and the target section confirmed to
      state the set it names
- [ ] US007 — the `INCLUDE_CLICKUP: false` reading traced against the exclusion list in
      `copier.yml` <!-- doc-references: template-only -->, line numbers re-resolved first, and no
      removed script named on the path
- [ ] US007 — the named-site inventory with its role column, the source `**Status:**` fields
      before and after, the three sprint-plan mirror cells and the closing casing grep with its
      population and exclusions all recorded with their dates
- [ ] US007 — the US005 plan-versus-story status divergence recorded as pre-existing, unexplained
      by any artefact, and routed to whoever owns US005's plan
- [ ] US007 — a tester other than the author has signed the walk-through off
- [ ] US001 — the four documentation gates run, and their output recorded in
      `project-management/src/18-TESTS/US001-MANUAL-TESTING.md`
- [ ] US001 — a reader who opens `code/docs/TASK-AUTHORING.md` cold reaches the migrated rules in
      one hop
- [ ] US001 — each of the three repointed sites re-read in place, and the sentence still reads true
- [ ] US001 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

<!-- US002's four rows moved with the story to project-management/src/03-SPRINTS/SPRINT-02.md on
     07/09/2026: the four gates recorded in US002-MANUAL-TESTING.md, the read-across of the shrunk
     file against each guide it routes to, the before/after register inventory balancing, and the
     tester sign-off. -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation only, and per code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance. For US007, `STORIES.md`, `SPRINTS.md` and
      `completion/SKILL.md` are re-measured with `--path … --limit 1` before and after the edit,
      never with `wc -l`
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — every new directory carries both halves of
      its pair. **Only US001 gives it anything to decide**: it creates `code/docs/reliability/`.
      US007 creates, splits and moves no pair, and reads the gate as an identity diff against its
      captured baseline because another story landing can move it
- [ ] `bash code/src/scripts/audits/doc-references.sh` — **two regimes, one per member, and neither
      is a bare pass while a non-empty baseline stands.** US007 reads it as an identity diff against
      the baseline captured before its first edit
      (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
      which binds every story in this backlog until US004 — now in SPRINT-03 — retires it). US001's
      flag predates that ADR and is deliberately left as it stands, per
      `project-management/src/16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`: every citation resolves, and
      no pointer is left aiming at a moved rule
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression only, for both members.** It
      reads fenced code and both stories' doctrine is prose
      (`project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`);
      a green run says the registered claims are undisturbed and nothing about a rule stated in two
      homes, and is never reported as though it had
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — no **new** violation attributable to
      `.claude/skills/completion/SKILL.md`, read as an identity diff against the baseline captured
      before US007's first edit; an empty baseline with exit 0 at close is a pass and is reported
      as one. **US007's alone**; US001 edits no skill
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — the leg that reads Markdown, via
      markdownlint-cli2
- [ ] `bash code/src/scripts/syntax/check.sh` — **N/A**, it type-checks Python, TypeScript and Rust
      and has no Markdown leg; this sprint ships Markdown only, so it has nothing to look at
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads `N/A`
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

<!-- Until 07/09/2026 the syntax row read "`lint.sh` and `check.sh` pass" as one box. US007's own
     Verification Checks record check.sh as N/A with the reason above, and per
     code/docs/GATE-REPORTING.md a gate with nothing to look at is not reported as having looked;
     US001 ships the same class of file, so the split applies to both members. -->

---

## Definition of Done

- [ ] All stories in the Story Summary are individually marked **Completed** (their own DoD
      complete) — US007 and US001, both `Must`
- [ ] US007's own `**Status:**` header is the one field of its measured population that moves, to
      **Completed**; every other live source field holds the value it held before its first edit
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in either member's QA plan
- [ ] `GAPS.md`'s entry of 01/09/2026 closed and `DEFERRED.md`'s two US007 rows written, both by
      `22-implementation-documentation`, as US007's own Definition of Done provides
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
