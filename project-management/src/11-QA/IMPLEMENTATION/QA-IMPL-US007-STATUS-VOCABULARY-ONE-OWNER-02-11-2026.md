# QA Implementation Review — US007 The story status vocabulary gets one owner

| Field        | Value                                                                                                                  |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US007 — the story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits |
| **Date**     | 02/11/2026                                                                                                             |
| **Sprint**   | SPRINT-01                                                                                                              |
| **Reviewer** | Claude (a `22-implementation-documentation` subagent that made none of the edits), on Sam's behalf                     |
| **Branch**   | `us007/status-vocabulary-one-owner`, base `777595f`, uncommitted at review                                             |
| **Plan doc** | `../PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`                                                             |
| **Outcome**  | Pass with deviations                                                                                                   |

---

## 1. Scope

**What shipped:** Markdown only, the five residue edits of the re-cut
(`../../02-STORIES/US007.md` → _Re-cut criteria — 02/11/2026_, RC-1 to RC-5), checked against
RC-6's no-regression bar:

- **RC-1:** status boxes in the `23-pr-and-review` and `24-release` checklists.
- **RC-2:** the sprint-plan template's Definition of Done line.
- **RC-3:** a pointer and a dated end note in `MAP-REGISTER-INDEXES.md`.
- **RC-4:** `In Progress` casing in the manual-guide template.
- **RC-5:** clickup-only marking in two workflow `STEPS.md` files and the story-plan template.

There is no backend, API or frontend.

**The plan predates the re-cut, and Sam's Q5 left it as written.** The re-cut superseded the
story's original Acceptance Criteria and Tasks, so this review judges against RC-1 to RC-6. Each
plan scenario is either walked as re-cut or marked superseded, with the mapping in Section 4.

## 2. Acceptance-criteria gaps closed

The plan closed all seven gaps against the story on 08/09/2026, before code. The re-cut changed
what three of them protect.

| Gap                                                              | Status   | Evidence                                                                                                                                                                          |
| ---------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 — the detector moved; a baseline diff needs its hash    | Resolved | Resolved in the plan. The hash capture was dropped by re-cut Q4. Recapturing it was unnecessary at close: the baseline re-ran byte-identical at `777595f` (manual row CAPTURE-01) |
| AC-GAP-2 — "by identity" names no method                         | Resolved | `(file, kind, token)`, line dropped, multiplicity kept; walked as DOCREF-01 and DOCREF-05                                                                                         |
| AC-GAP-3 — `doctrine-drift.sh` reads fenced code only            | Resolved | Reported as a regression guard only (GATES-02)                                                                                                                                    |
| AC-GAP-4 — two citations into the sprint-plan template falsified | Resolved | Resolved in the plan. The re-cut edits that template in one line only (TEMPLATE-02)                                                                                               |
| AC-GAP-5 — the capture names two gates, the criteria four        | Resolved | Five gates captured before the first edit, under `/tmp/us007-baseline/` (manual guide → _Recorded during the build_)                                                              |
| AC-GAP-6 — the closing grep walks the filesystem                 | Resolved | Moot: the casing grep (CASING-01) was retired by the re-cut, and RC-4 is a one-line read (CASING-03)                                                                              |
| AC-GAP-7 — the one movable field moves twice                     | Resolved | The story's status moves are recorded by `completion` in `../../02-STORIES/US007.md` → _Status history_; not a re-cut criterion                                                   |

## 3. Scenario verification

All evidence is manual: the story has no suite (`../../18-TESTS/AUTOMATED/US007-TEST-STATUS.md`).
Each row ID refers to `../../18-TESTS/MANUAL/US007-MANUAL-TESTING.md`, walked 02/11/2026.
`Deviation` means the scenario was walked in its re-cut form (Section 4). `N/A` means the re-cut
superseded it and its guide row is retired.

### Happy Path

| ID    | Scenario (from plan)                                                  | Result    | Evidence                                                                                                                                             |
| ----- | --------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | Pre-edit SHA recorded; gate finding sets captured by identity; hashes | Deviation | CAPTURE-01, CAPTURE-02, DOCREF-01 — Pass. Identity diff empty. The hashes and three of the four identity sets were dropped by Q4                     |
| HP-02 | `skill-conformance.sh` baseline empty at capture                      | Pass      | CONFORM-01 — exit 0 before and after                                                                                                                 |
| HP-03 | `docs-length.sh --limit 1` read the three files before the first edit | Deviation | GATES-07 — Pass on the tree-wide run. The per-file readings were dropped by Q4, and the re-cut edits none of the three files                         |
| HP-04 | `docs-pairing.sh` 0 findings at capture                               | Pass      | GATES-01                                                                                                                                             |
| HP-05 | `doctrine-drift.sh` 3 claims, one home each                           | Pass      | GATES-02                                                                                                                                             |
| HP-06 | The story's routes are written                                        | N/A       | Superseded: the routes were measured as already true at `777595f` (ROUTE-01 to ROUTE-09 retired)                                                     |
| HP-07 | The rewritten `completion/SKILL.md`                                   | N/A       | Superseded: the skill is not edited, because of Q2 (no writer table)                                                                                 |
| HP-08 | `copier.yml` `INCLUDE_CLICKUP: false` exclusion list, re-resolved     | Pass      | TRACE-01, plus RECUT-01 and TEMPLATE-04 for RC-5                                                                                                     |
| HP-09 | Seventeen source `**Status:**` fields re-counted                      | N/A       | Superseded (SOURCE-01 to SOURCE-03 retired)                                                                                                          |
| HP-10 | Three `In progress` sites corrected                                   | Deviation | CASING-03 — Pass. Narrowed by RC-4 to the template's line. The skill site was already fixed at 7.7.0, and the map's text is left in place under RC-3 |
| HP-11 | Named-site inventory with a role column                               | N/A       | Superseded (INVENTORY-01 retired)                                                                                                                    |
| HP-12 | Build-start steps and checklist amended                               | N/A       | Superseded: measured as already true at `777595f` (START-01 retired)                                                                                 |

### Error States

| ID    | Scenario (from plan)                          | Result | Evidence                                                                    |
| ----- | --------------------------------------------- | ------ | --------------------------------------------------------------------------- |
| ES-01 | An edit made with no baseline captured        | Pass   | CAPTURE-01: the baseline exists and reproduces at `777595f`                 |
| ES-02 | A `>` line in a file the story edits          | Pass   | DOCREF-02: none occurred                                                    |
| ES-03 | A `>` line in a file the story does not edit  | Pass   | DOCREF-03: none occurred                                                    |
| ES-04 | Detector blob differs at close                | N/A    | Superseded: no hashes, because of Q4 (DETECTOR-01 and -02 retired)          |
| ES-05 | `skill-conformance.sh` red on another skill   | N/A    | Superseded: Q4 dropped attribution (CONFORM-02 retired). Exit 0 in any case |
| ES-06 | `[house 14]` on `completion/SKILL.md`         | N/A    | Superseded: the skill is not edited (CONFORM-03 and -04 retired)            |
| ES-07 | `STORIES.md` or `SPRINTS.md` crosses 270      | N/A    | Superseded: neither file is edited (GATES-04 retired)                       |
| ES-08 | `doctrine-drift.sh` two homes at close        | N/A    | Superseded: Q4 (GATES-03 retired). One home each in any case (GATES-02)     |
| ES-09 | A repointed route's target heading mistyped   | N/A    | Superseded: no route is repointed                                           |
| ES-10 | The closing `git grep` non-zero               | N/A    | Superseded (CASING-01 and -02 retired)                                      |
| ES-11 | A `[plan prefix]` finding from an edited file | Pass   | DOCREF-07: none                                                             |

### Edge Cases

| ID    | Scenario (from plan)                                                | Result | Evidence                                                                            |
| ----- | ------------------------------------------------------------------- | ------ | ----------------------------------------------------------------------------------- |
| EC-01 | The pre-edit tree is dirty with another session's files             | Pass   | CAPTURE-02: the tree was clean (porcelain 0), so the stash branch was not needed    |
| EC-02 | Another story lands between capture and close                       | Pass   | DOCREF-04: HEAD is unchanged at `777595f`                                           |
| EC-03 | A `(file, kind, token)` changes multiplicity                        | Pass   | DOCREF-05: the counts are identical                                                 |
| EC-04 | An edit above a pre-existing finding shifts its line                | Pass   | DOCREF-06                                                                           |
| EC-05 | The conformance baseline is empty and the close is red on the skill | N/A    | Superseded: the skill is not edited                                                 |
| EC-06 | Step 3 of `23` writes `In Review` into the story header             | N/A    | Superseded. RC-1's checklist box now records it through `completion` (CHECKLIST-01) |
| EC-07 | An artefact is created between today and the first edit             | N/A    | Superseded (SOURCE rows retired)                                                    |
| EC-08 | `STORIES.md` and `SPRINTS.md` read different counts                 | N/A    | Superseded: neither file is edited                                                  |
| EC-09 | `docs-length.sh --limit 1` always non-zero                          | N/A    | Superseded: Q4 dropped the per-file readings                                        |
| EC-10 | Pre-existing findings inside `../../02-STORIES/US007.md`            | Pass   | DOCREF-08: four stand unchanged                                                     |
| EC-11 | The `template-only` marker used to clear a `>` line                 | Pass   | DOCREF-09: no marker added                                                          |

### Permission and Access

N/A. The plan has no `PA` scenario: the story adds no endpoint, screen, protected action or
ownable identifier (plan Section 2). The travel rule is walked from the reader's side as HP-08
(TRACE-01).

## 4. Deviations from plan

| Deviation                                                                                                                          | Justification                                                                                                                                                                                                        |
| ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The scenario set was cut to RC-1 to RC-6; 17 plan scenarios are N/A and 3 were walked as Deviation; the plan itself was not re-cut | The 7.7.0 PM-boards change landed most of the story's subject first. The grilling pass of 02/11/2026 (Q1 to Q5, Sam) re-cut the criteria and named only the story plan and manual guide for amendment. Finding F-011 |
| Gate capture is proportionate (Q4): the detector hashes and three of the four identity sets were dropped                           | Same pass, Q4. ADR-US003's identity diff is kept for `doc-references.sh`. The other four gates are compared by exit and output                                                                                       |
| The baseline lives in `/tmp/us007-baseline/`, not pasted into the guide                                                            | Q4. The baseline is reproducible from `777595f`, as this walk showed byte-for-byte, but it is not durable. Finding F-009                                                                                             |
| Manual row MAP-01 amended at the walk                                                                                              | RC-3, as corrected after review, names two edits to the map (the pointer and the end note). The row said "the one edit". Finding F-001                                                                               |

## 5. New edge cases discovered

| ID                                                                      | Scenario                                                                                                       | Result | Evidence                        | Fold back?                        |
| ----------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------- | --------------------------------- |
| GATES-09                                                                | `lint.sh --file-type markdown` lints a gitignored local file (`graphify-out/`), so its exit is not the story's | Fail   | Manual row GATES-09; F-002      | Yes: the row, or the lint ignores |
| GATES-10                                                                | `format.sh --file-type markdown` dry run                                                                       | Pass   | Manual row GATES-10             | No                                |
| RECUT-02                                                                | `pm-board.sh --check` passes (RC-6)                                                                            | Pass   | Manual row RECUT-02             | No                                |
| CHECKLIST-01 to -03, TEMPLATE-02, TEMPLATE-04, MAP-01, MAP-02, RECUT-01 | The RC-1, RC-2, RC-3 and RC-5 read-acrosses, which have no QA-plan ID                                          | Pass   | The manual rows of the same IDs | No: the re-cut owns them          |

## 6. Deferred scenarios

None. Every superseded scenario is retired rather than deferred, and Section 3 gives the reason
for each.

## 7. Accessibility observations

- **axe-core:** N/A. No rendered route (plan Section 3).
- **Keyboard & focus:** N/A. No interactive component.
- **Equal-weight actions:** N/A.
- **Other:** N/A. The story ships Markdown that is read in an editor.

## 8. GDPR & security observations

- **PII at rest:** N/A. No personal data is processed.
- **PII in responses:** N/A.
- **Rights paths:** N/A.
- **Security gate:** N/A. No endpoint and no permission surface. The only boundary is the
  `INCLUDE_CLICKUP` travel rule, verified under HP-08.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build (N/A, no rendered surface)
- [x] GDPR & security observations confirmed (or N/A recorded)
- [x] Coverage floors met for all modules in scope (no module in scope)
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US007-MANUAL-TESTING.md`). Outcome
      Failed on GATES-09 alone, which does not block the story
- [ ] Reviewer approval — **blocks merge until complete**. Pending Sam, verified at `23-pr-and-review`

---

## Cross-references

- `../PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the pre-development plan verified here
- `../../02-STORIES/US007.md` — the story under review; _Re-cut criteria — 02/11/2026_ is the bar
- `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the plan and its _Re-cut — 02/11/2026_
- `../../18-TESTS/AUTOMATED/US007-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US007-MANUAL-TESTING.md`
  — downstream test records
- `../../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` — the findings this review cites
- `../../19-REVIEWS/` — code-review notes from the same PR, written at `23-pr-and-review`
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
