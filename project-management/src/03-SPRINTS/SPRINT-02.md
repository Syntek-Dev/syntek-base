# SPRINT-02

**Last Updated**: 02/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The citation gate stops depending on the git index, and the absence guide is born
behind it.

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 SP Must + 5 SP Should = 13 / 11 SP** — at grace, and closed

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 02/09/2026 on US003's admission.
     Recomputed 02/09/2026 on US004's admission and CHANGED in one row. Twelve rows stay N/A
     because both stories ship documentation and one bash script between them: no model, no
     endpoint, no screen, no personal-data path, no log line, no public page. The QA row is the
     union of two different test types — US003's five-gate manual value and US004's unit value,
     which is the sprint's first automated one. Per SPRINTS.md the union is never narrowed, so
     both halves are carried in full and the automated QA sections below are no longer removed.
     Script names are written without the .sh suffix here to match the stories' own flags; the
     full paths are in the Verification Checks. -->

| Flag       | Value                                                                                                                                   |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                     |
| User Flow  | N/A                                                                                                                                     |
| Brand      | N/A                                                                                                                                     |
| Components | N/A                                                                                                                                     |
| Wireframes | N/A                                                                                                                                     |
| GDPR       | N/A                                                                                                                                     |
| Security   | N/A                                                                                                                                     |
| QA         | manual — `docs-length`, `doc-references`, `doctrine-drift`, `routing-skills`, `skill-conformance` · unit — gate self-test, fixture pair |
| SEO        | N/A                                                                                                                                     |
| API        | N/A                                                                                                                                     |
| Logging    | N/A                                                                                                                                     |
| Backend    | N/A                                                                                                                                     |
| Frontend   | N/A                                                                                                                                     |

---

## Story Summary

| ID    | Title                                                                                 | MoSCoW      | SP  |
| ----- | ------------------------------------------------------------------------------------- | ----------- | --- |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated          | Should Have | 5   |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Must Have   | 8   |

**Total:** 13 SP — **8 committed, 5 stretch**

## Dependencies

- **Neither member has an upstream dependency.** US003 is the third and last wave-0 Must of the
  absence map's cutting order; US004 is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`, whose map has an
  empty frontier and whose `Gate to stories` records `02-story-creation` as unblocked.
- **US004 is built first, and the order is not free** (settled at `03-sprint-planning`,
  02/09/2026). US003's acceptance reads `doc-references.sh` as a diff against a recorded
  baseline, and US004 removes the defect that baseline exists for. Building US004 first means
  US003 is worked against a gate that simply passes, and the regime
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  imposes is never exercised. The sprint plan's `{exec-order}` segment records this.
- **US003 needs a revision pass before it is worked, and it is flagged here rather than
  amended** (Q4, 02/09/2026). Three parts of it are written against a defect that will be gone:
  the Gherkin scenario _"The citation gate is read against a recorded baseline, never as a bare
  pass"_, the QA task recording before/after finding counts, and the ADR above. Once US004
  lands, the scenario should read as a plain pass. **The correction belongs to whoever picks
  US003 up**, and is recorded in this sprint rather than in `GAPS.md` because it opens and
  closes inside this sprint — a register entry would need a close pass from
  `22-implementation-documentation` for no benefit. If US003 leaves this sprint unworked, the
  flag goes to `GAPS.md` with it.
- **US003 unblocks five slices** on
  `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — `S-02` (the Python `None` clause),
  `S-03` (the HTMX contract), `S-04` (the optional-surface remainders), `S-05` (tiers and the
  mechanical legs) and `S-06` (consumer wiring). Every one cites the guide US003 creates, and
  `S-06` names the dependency in its own acceptance.
- **US004 unblocks** slice `S-01` on
  `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md`, which changes the same script's
  citation emit and must not land first.
- **Neither depends on a SPRINT-01 member**, and neither blocks one.

## Notes

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
every member has cleared `15-decisions`.** US003 has. US004 has cleared `02-story-creation` and
`03-sprint-planning` only; the rest of its per-story loop is still to run.

---

## Acceptance Criteria

Two independent outcomes, one per member, with US004's landing first.

**US004** — `code/src/scripts/audits/doc-references.sh` gives the same verdict on the same
citation whether or not its file is committed, polices the nine shipped files copier lifts out
of the exempt trees, checks the `project-management/src/` tree without firing on naming
conventions, and exits `0` on a clean tree.

**US003** — `code/docs/ABSENCE.md` exists as the single owner of what an absence means — six
kinds and a five-surface runtime crib — born inside the length ratchet, registered on every
surface it owes, with each clause carrying an honest enforcement tier and every rule another
guide already owns cited rather than restated.

### QA Acceptance Criteria — Automated

<!-- New at US004's admission: this sprint's QA union now names a unit type. US003 contributes
     nothing here and that is recorded rather than inferred, per code/docs/GATE-REPORTING.md. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0, its probe count
      risen by one case per repair US004 makes
- [ ] Every fixture case US004 adds fails against the pre-change script and passes against the
      post-change one — a fixture that passes both proves nothing
- [ ] No existing probe is weakened to accommodate a change; any moved expected count carries
      its justification in the probe's own comment
- [ ] Coverage floors — **N/A**, neither story ships a Python path; US004's proof is the
      script's own `--self-test` and US003 ships Markdown only

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US003-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US004-MANUAL-TESTING.md` each carry a tester sign-off
      block

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
- [ ] US003 — the five documentation gates run, and their output recorded in
      `project-management/src/18-TESTS/US003-MANUAL-TESTING.md`
- [ ] US003 — **if US004 has landed, the baseline-diff scenario is read as a plain pass**; the
      baseline is captured first only if US003 is worked ahead of US004
- [ ] US003 — a human read-across of the new guide against the six
      `code/docs/data-structures/TYPES-*.md` files; no rule stated in two homes
- [ ] US003 — the Codd primary source checked before its attribution row is written, to confirm
      derivation rather than convergence
- [ ] US003 — a developer who opens the guide cold can name which of the six kinds a given
      `return None` means, without opening a second file
- [ ] Each story — a tester other than the author has signed the walk-through off
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
      forward references to `code/docs/ABSENCE.md`, which clear when US003 ships; three cite
      `code/src/scripts/audits/SLOP-FAMILY.md` and belong to **US002 in SPRINT-01**, so a bare
      pass is unavailable to this sprint on its own
- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint
      enters the warn tier without a dated allowance, and `code/src/scripts/audits/CONTEXT.md`
      is not grown while at 298; US002 in SPRINT-01 owns its headroom
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — US003's new `owned` row is green and no
      existing claim forks; regression only for US004, which adds no claims row
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — every name in US003's routing
      frontmatter resolves
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — clause 14 discharged for every skill
      US003's guide names
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
- [ ] The `Should Have` story is either **Completed** or explicitly carried to SPRINT-03 with its
      reason recorded here; it is never dropped silently
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
