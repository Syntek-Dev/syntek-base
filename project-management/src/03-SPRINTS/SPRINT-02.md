# SPRINT-02

**Last Updated**: 05/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The citation gate stops depending on the git index.

<!-- The goal read "…and the absence guide is born behind it" until 05/09/2026, when US003 moved
     to SPRINT-03. A goal naming a deliverable no member carries is the drift the Story Summary
     exists to prevent. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, and closed

<!-- Was "8 SP Must + 5 SP Should = 13 / 11 SP — at grace" until 05/09/2026, when US003 moved to
     SPRINT-03. This sprint no longer needs grace; the reasoning that admitted it is kept in the
     Notes rather than deleted, because it is the record of a decision that was taken. -->

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 02/09/2026 on US003's admission.
     Recomputed 05/09/2026 on US003's DEPARTURE to SPRINT-03 and CHANGED in one row: the QA
     value narrows, because routing-skills and skill-conformance entered this union with US003
     alone. A union narrows only when a member leaves, which is exactly this case and not the
     Part A / Part B narrowing SPRINTS.md permits — the story did not split, it moved.
     AMENDED 05/09/2026, same day: the surviving three documentation gates were briefly carried
     here on the grounds that US004 "still runs" them, which is an independently-authored value
     the union rule forbids. US004's own flag was widened instead to name the three gates its
     Verification Checks actually run — the manifest-may-be-added-to route CADENCE.md provides —
     so this row is once again the union of its members and nothing more.
     Recomputed 02/09/2026 on US004's admission and CHANGED in one row. Twelve rows stay N/A
     because both stories ship documentation and one bash script between them: no model, no
     endpoint, no screen, no personal-data path, no log line, no public page. The QA row is the
     union of two different test types — US003's five-gate manual value and US004's unit value,
     which is the sprint's first automated one. Per SPRINTS.md the union is never narrowed, so
     both halves are carried in full and the automated QA sections below are no longer removed.
     Script names are written without the .sh suffix here to match the stories' own flags; the
     full paths are in the Verification Checks. -->

| Flag       | Value                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------ |
| DB         | N/A                                                                                              |
| User Flow  | N/A                                                                                              |
| Brand      | N/A                                                                                              |
| Components | N/A                                                                                              |
| Wireframes | N/A                                                                                              |
| GDPR       | N/A                                                                                              |
| Security   | N/A                                                                                              |
| QA         | manual — `docs-length`, `doc-references`, `doctrine-drift` · unit — gate self-test, fixture pair |
| SEO        | N/A                                                                                              |
| API        | N/A                                                                                              |
| Logging    | N/A                                                                                              |
| Backend    | N/A                                                                                              |
| Frontend   | N/A                                                                                              |

---

## Story Summary

| ID    | Title                                                                                 | MoSCoW    | SP  |
| ----- | ------------------------------------------------------------------------------------- | --------- | --- |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Must Have | 8   |

**Total:** 8 SP

<!-- US003 (Should Have, 5 SP) was here until 05/09/2026 and is now in
     project-management/src/03-SPRINTS/SPRINT-03.md. Removed from this table rather than struck
     through, because SPRINTS.md computes this sprint's flag union and capacity FROM this table
     and a story in two Story Summaries is counted twice. The move and its reasoning are in the
     Notes. -->

## Dependencies

- **US004 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`, whose map has an
  empty frontier and whose `Gate to stories` records `02-story-creation` as unblocked.
- **US004 must still be built before US003, and US003 now sits in the next sprint** (settled at
  `03-sprint-planning` 02/09/2026, and unchanged by the move on 05/09/2026). US003's acceptance
  reads `doc-references.sh` as a diff against a recorded baseline, and US004 removes the defect
  that baseline exists for. Building US004 first means US003 is worked against a gate that simply
  passes, and the regime
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  imposes is never exercised. **The ordering is therefore now cross-sprint**, and is restated in
  `project-management/src/03-SPRINTS/SPRINT-03.md` Dependencies rather than left only here — a
  constraint recorded only in the sprint a story has left is a constraint nobody reads.
- **US003's revision pass travelled with the story on 05/09/2026.** Three parts of it are written
  against a defect US004 removes: the Gherkin scenario _"The citation gate is read against a
  recorded baseline, never as a bare pass"_, the QA task recording before/after finding counts,
  and the ADR above. This record said that if US003 left unworked the flag would go to `GAPS.md`.
  **It went to SPRINT-03 instead**, into that record's Dependencies and its QA Tasks. The
  condition was "left unworked" and the purpose was that the obligation not be lost; it is stated
  in the record whoever picks US003 up will actually read, which `GAPS.md` — owned by
  `22-implementation-documentation` for writes and closes — would not have been. If US003 leaves
  SPRINT-03 unworked as well, the register entry becomes the right home.
- **US004 unblocks** slice `S-01` on
  `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md`, which changes the same script's
  citation emit and must not land first.
- **US004 depends on no SPRINT-01 member and blocks none.**

## Notes

**US003 moved to `project-management/src/03-SPRINTS/SPRINT-03.md` on 05/09/2026, before this
sprint was worked, and this record is now a single-member sprint at 8 / 11 SP.** The three
paragraphs below argue why grace was taken to admit it; they are kept because they record a
decision that was actually taken, not because they still describe this sprint. **Read them as
history.** What replaces them is simpler: SPRINT-03 opened with US005 alone as a 5 SP all-`Must`
sprint, which `project-management/docs/planning/SPRINTS.md` warns has no give, and it had no
candidate for a `Should` tier that was not blocked on its own member. US003 is that give, it was
never worked here, and moving it puts **both** sprints inside capacity — this one at 8 / 11 and
SPRINT-03 at 10 / 11 — where before one was at grace and the other had no stretch at all. The
ordering constraint and the revision pass travelled with it; see Dependencies.

**This sprint stays CLOSED**, now by decision rather than by ceiling. Its 3 SP of headroom is not
an invitation: US004's own unblocking chain runs into `MAP-NAVIGATION` slice `S-01`, which is not
cut, and admitting an unrelated story to fill 3 SP is the padding
`project-management/docs/planning/CADENCE.md` tells this record to call out instead.

---

**History, from 02/09/2026 — superseded by the move above.**

**This sprint admits 13 SP against a capacity of 11 and commits to 8 of them.**
`project-management/docs/planning/CADENCE.md` reserves grace for one situation — the next story
overshoots and splitting it would produce two halves that make no sense alone. US004 meets that
on the record: `02-story-creation` settled (Q12, 02/09/2026) that splitting it means two stories
editing `code/src/scripts/audits/doc-references.sh` and two runs of the same before/after
measurement. **SPRINT-01 declined grace for the opposite reason** — US003 had no split problem
and that sprint did not have to have it — so this is not the routine allowance CADENCE warns
about.

**What grace covers here changed at `16-sprint-plans`, and the shift is recorded rather than
quietly dropped.** US003 was demoted to `Should Have` because
`project-management/docs/planning/SPRINTS.md` is explicit that an all-Must plan has no give and
"the first surprise breaks it". So **grace now covers the ceiling, not the commitment**: the Must
tier is 8 SP, inside capacity, and the 5 SP above it is stretch that slips to SPRINT-03 without
the sprint failing. The 13 SP is still admitted work and the sprint is still closed at two
members.

**The alternative was leaving SPRINT-02 at 5 and opening SPRINT-03, and it was declined on a
measured fact:** this sprint's 6 SP of headroom is otherwise unfillable. Its natural next
members are the five absence slices above, and every one of them blocks on US003 — this
sprint's own member — shipping first. US004 depends on nothing, which makes it the only story
that can occupy that room.

**The goal names two subjects because the sprint has two**, and it is written in execution
order rather than pretending they share one. US004 is a different epic on a different map; it is
here on capacity and independence, not on theme.

**This sprint is CLOSED at two members.** It stands past capacity, so nothing further is
admitted regardless of what clears `15-decisions` next.

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once
every member has cleared `15-decisions`.** Both are written:
`project-management/src/16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`, now at 8 / 11 with US004 alone, and
`project-management/src/17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.

<!-- This paragraph read "US004 — now the only member — has cleared 02-story-creation and
     03-sprint-planning only; the rest of its per-story loop is still to run, so neither plan can
     be written yet" until 05/09/2026. Both plans were on disk when it was written, and
     02-SPRINT-PLAN-02.md was edited the same day for US003's departure. Corrected rather than
     deleted, because the claim is the kind a later reader would otherwise trust. -->

---

## Acceptance Criteria

One outcome, one member.

**US004** — `code/src/scripts/audits/doc-references.sh` gives the same verdict on the same
citation whether or not its file is committed, polices the nine shipped files copier lifts out
of the exempt trees, checks the `project-management/src/` tree without firing on naming
conventions, and exits `0` on a clean tree.

<!-- US003's outcome moved with the story to project-management/src/03-SPRINTS/SPRINT-03.md
     on 05/09/2026. -->

### QA Acceptance Criteria — Automated

<!-- New at US004's admission: this sprint's QA union names a unit type. Since US003's move on
     05/09/2026, US004 is the only contributor to every row below. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0, its probe count
      risen by one case per repair US004 makes
- [ ] Every fixture case US004 adds fails against the pre-change script and passes against the
      post-change one — a fixture that passes both proves nothing
- [ ] No existing probe is weakened to accommodate a change; any moved expected count carries
      its justification in the probe's own comment
- [ ] Coverage floors — **N/A**, neither story ships a Python path; US004's proof is the
      script's own `--self-test`

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US004-MANUAL-TESTING.md` carries a tester sign-off block

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### QA Tasks — Automated

- [ ] US004 — the self-test runs and its output is recorded in
      `project-management/src/18-TESTS/US004-TEST-STATUS.md`
- [ ] US004 — each new fixture case is run against both the pre- and post-change script, and
      both results recorded

### QA Tasks — Manual

- [ ] US004 — the whole-tree run is recorded before and after, with both finding counts and
      both exit codes
- [ ] US004 — the tracked-versus-untracked A/B is reproduced before any edit and again after,
      with the git index restored each time
- [ ] US004 — every finding the widened gate exposes is classified in writing as genuine,
      generic-noun false positive, or another story's, with none left unclassified

<!-- US003's five manual checks moved with the story to
     project-management/src/03-SPRINTS/SPRINT-03.md on 05/09/2026. -->

- [ ] US004 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation and one bash script, and per code/docs/GATE-REPORTING.md a skip is never
     reported as a pass. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh` — **no finding remains of the three classes
      US004 owns**, each survivor named with the story that owns it. Corrected 02/09/2026 by
      `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` AC-GAP-3:
      this does **not** become a plain pass on US004's completion. Three survivors are US003's
      forward references to `code/docs/ABSENCE.md`, which now clear in **SPRINT-03**, not here;
      three cite
      `code/src/scripts/audits/SLOP-FAMILY.md` and belong to **US002 in SPRINT-01**, so a bare
      pass is unavailable to this sprint on its own
- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint
      enters the warn tier without a dated allowance, and `code/src/scripts/audits/CONTEXT.md`
      is not grown while at 298; US002 in SPRINT-01 owns its headroom
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression only**; US004 adds no claims
      row, and US003's new `owned` row moved to SPRINT-03 with the story
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A here since 05/09/2026**; it entered
      this record with US003 and ran only against that story's routing frontmatter. Marked with its
      reason rather than deleted, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — **N/A here since 05/09/2026**; same
      reason as the row above
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; this sprint creates no
      directory and so owes no new pair
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass,
      including ShellCheck over the script US004 edits
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a Python
      path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component
      added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads
      `N/A`
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US004 alone
- [ ] **No `Should Have` story remains here.** US003 was this sprint's stretch tier and moved to
      `project-management/src/03-SPRINTS/SPRINT-03.md` on 05/09/2026 before the sprint opened,
      with its reason recorded in the Notes. It was not dropped and it was not silent
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
