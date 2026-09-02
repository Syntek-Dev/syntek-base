# SPRINT-01

**Last Updated**: 02/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Wave 1 gets both the homes and the headroom it writes into — an owning guide for
cross-surface retry and idempotency, and room in the audit register for the gates that follow.

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** 8 / 11 SP

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Recomputed 01/09/2026 when the QA gate added doctrine-drift.sh to US001's QA value
     (QA-PLAN-US001 AC-GAP-6).
     Recomputed 02/09/2026 on US002's admission and UNCHANGED: US002's thirteen rows are
     identical to US001's — twelve N/A and the same four-gate manual QA value — so the union
     over two members is the same table as the union over one. Recorded rather than skipped,
     because a recomputation that changes nothing and a recomputation nobody ran are
     indistinguishable in the result. -->

| Flag       | Value                                                                                  |
| ---------- | -------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                    |
| User Flow  | N/A                                                                                    |
| Brand      | N/A                                                                                    |
| Components | N/A                                                                                    |
| Wireframes | N/A                                                                                    |
| GDPR       | N/A                                                                                    |
| Security   | N/A                                                                                    |
| QA         | manual — `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh` |
| SEO        | N/A                                                                                    |
| API        | N/A                                                                                    |
| Logging    | N/A                                                                                    |
| Backend    | N/A                                                                                    |
| Frontend   | N/A                                                                                    |

---

## Story Summary

| ID    | Title                                                                   | MoSCoW    | SP  |
| ----- | ----------------------------------------------------------------------- | --------- | --- |
| US001 | Reliability doctrine gets an owning guide, and every pointer reaches it | Must Have | 5   |
| US002 | The audits register regains the headroom nine new gates need            | Must Have | 3   |

**Total:** 8 SP

## Dependencies

- **Neither member has an upstream dependency, and neither depends on the other.** Both are
  wave 0 of the cutting order and wait on nothing, so they may be worked in either order or in
  parallel.
- **US001 unblocks** slices `S-02` and `S-03` on the retry-and-idempotency feature map, and the
  reliability half of slice `S-01` on the CAP-posture map.
- **US002 unblocks nine audit registrations across eight slices and seven maps** — every story
  that adds a script under `code/src/scripts/audits/` needs two rows in a register with two
  lines of headroom. Its full table is in `project-management/src/02-STORIES/US002.md`.
- None of those downstream slices is yet cut into a story, so none can be admitted here until
  it is — and per the Notes below, this sprint is closed to further members regardless.

## Notes

**This sprint is CLOSED at two members and 8 of 11 SP, by decision rather than by fill**
(02/09/2026). The record is a running ledger — opened as the first story clears the per-story
loop and accumulating each later story with its points — but a ledger is closed by a call, not
only by a ceiling. `project-management/docs/planning/CADENCE.md` is explicit that capacity is a
trigger and not a target: _"A sprint that lands on 10 SP because the next story is a 5 is a
correct sprint, not an under-filled one."_ Eight is that case.

**US003 — slice `S-01` of the absence feature map — opens SPRINT-02.** It is the third and last
wave-0 Must, and an earlier revision of this record named it as expected to join here. **That
expectation is withdrawn.** Admitting it would have taken this sprint to roughly 13 SP, which is
the grace ceiling rather than the capacity — and grace exists for one situation, a story that
would split badly, not as a routine allowance. The absence guide is not a story this sprint had
to have.

**Nothing further is admitted here.** A fourth wave-0 or wave-1 story goes to SPRINT-02 beside
US003. Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint
once both members have cleared `15-decisions`; US001 has, US002 has not.

---

## Acceptance Criteria

Two independent outcomes, one per member, and the four documentation gates run clean against
both.

**US001** — cross-surface retry and idempotency doctrine has exactly one owning home, every rule
that moved has left its old one, and every pointer reaches the new one.

**US002** — `code/src/scripts/audits/CONTEXT.md` ends at or under 230 counted lines with every
register it owns intact, the lines paid for by deleting restatements of rules owned elsewhere
rather than by deleting facts.

### QA Acceptance Criteria — Manual

<!-- The automated QA sections are removed: this sprint's QA flag names a manual type and no
     automated one, matching US001, which ships documentation and no code path. Per
     code/docs/GATE-REPORTING.md the skip is recorded here rather than left to be inferred. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] Every story's `US###-MANUAL-TESTING.md` carries a tester sign-off block

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### QA Tasks — Manual

- [ ] US001 — the four documentation gates run, and their output recorded in
      `project-management/src/18-TESTS/US001-MANUAL-TESTING.md`
- [ ] US001 — a reader who opens `code/docs/TASK-AUTHORING.md` cold reaches the migrated rules in
      one hop
- [ ] US001 — each of the three repointed sites re-read in place, and the sentence still reads true
- [ ] US001 — a tester other than the author has signed the walk-through off
- [ ] US002 — the four documentation gates run, and their output recorded in
      `project-management/src/18-TESTS/US002-MANUAL-TESTING.md`
- [ ] US002 — a human read-across of the shrunk file against each guide it routes to; every route
      lands on a section that actually states the rule
- [ ] US002 — the before/after register inventory balances: every cut line accounted for as
      restatement removed, content relocated, or fact deliberately deleted with a reason
- [ ] US002 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation only, and per code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — every new directory carries both halves of
      its pair
- [ ] `bash code/src/scripts/audits/doc-references.sh` — every citation resolves; no pointer left
      aiming at a moved rule
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — no rule is stated in both its new home and
      its old one
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads `N/A`
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`

---

## Definition of Done

- [ ] All stories in the Story Summary are individually marked **Completed** (their own DoD complete)
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
