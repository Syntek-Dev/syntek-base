# SPRINT-01

**Last Updated**: 01/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Give the doctrine that wave 1 writes into an owning home, starting with cross-surface
retry and idempotency.

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** 5 / 11 SP

<!-- FLAGS — the union of the member stories' flags. With US001 the only member, the union is
     US001's own table. Recompute this table on every story admitted, never edit it directly.
     Recomputed 01/09/2026 when the QA gate added doctrine-drift.sh to US001's QA value
     (QA-PLAN-US001 AC-GAP-6). -->

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

**Total:** 5 SP

## Dependencies

- US001 has no upstream dependencies — it is wave 0 of the cutting order and waits on nothing.
- This sprint unblocks slices S-02 and S-03 on the retry-and-idempotency feature map, and the
  reliability half of slice S-01 on the CAP-posture map. None of the three is yet cut into a
  story, so none can be admitted to this sprint until it is.

## Notes

**This sprint is open and under capacity — 5 of 11 SP — and that is its intended state.** The
record is a running ledger: it is opened as the first story clears the per-story loop and
accumulates each later story with its points, and it is the accumulated total that tells you the
sprint is full. Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) do not run
until it is.

**Expected to join, in cutting order:** the standalone shrink story for
`code/src/scripts/audits/CONTEXT.md`, and slice S-01 of the absence feature map — the remaining
two members of wave 0. Both are cut and planned before they are admitted here; neither is
promised by this record.

---

## Acceptance Criteria

Cross-surface retry and idempotency doctrine has exactly one owning home, every rule that moved
has left its old one, every pointer reaches the new one, and the four documentation gates run
clean against the result.

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
