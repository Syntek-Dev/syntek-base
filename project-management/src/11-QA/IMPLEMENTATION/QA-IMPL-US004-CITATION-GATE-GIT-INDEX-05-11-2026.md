# QA Implementation Review — US004 The citation gate stops depending on the git index, and the PM tree becomes checkable

| Field        | Value                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US004 — the citation gate stops depending on the git index, and the PM tree becomes checkable                                                                                                                                                                                                                                                                                                                     |
| **Date**     | 05/11/2026                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Sprint**   | SPRINT-03 (sole member; US003's reserved carry landed in SPRINT-02 first)                                                                                                                                                                                                                                                                                                                                         |
| **Reviewer** | Claude (a `22-implementation-documentation` records subagent that made none of the edits and did not walk the guide), on Sam's behalf                                                                                                                                                                                                                                                                             |
| **Branch**   | `us004/citation-gate-git-index`, cut from `testing` at `173abff`; walked at `46d5c0f`; records staged on `46d5c0f`                                                                                                                                                                                                                                                                                                |
| **Plan doc** | `../PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`                                                                                                                                                                                                                                                                                                                                                            |
| **Outcome**  | **Fail with an accepted deviation; one point pending.** Every scenario's behaviour is met. Sam's rulings of 05/11/2026 accept the missed before-edit captures for BASELINE-02 to 05 (F-001), amend HP-06's row MEASURE-01, now Pass (F-002), and require ShellCheck clean in the build (F-003), met: GATES-05 re-walked Pass at the check stage, exit 0. BASELINE-01's evidence awaits Sam's confirmation (F-001) |

---

## 1. Scope

**What shipped:** `code/src/scripts/audits/doc-references.sh` (1119 → 2023 lines, about half of
the growth its self-test) with 53 new fixtures under
`code/src/scripts/audits/fixtures/doc-references/`; two patterned rows and a header note in
`how-to/src/PROJECT-PATHS.md`; `code/docs/FORWARD-VOICE.md` Section 3; the `doc-references.sh`
row of `code/src/scripts/audits/CONTEXT.md`, replaced within itself; the P5 repair sweep across
shipped files and PM records; and the decision trail — three ADRs of 05/11/2026 and earlier, the
plan's _Key Decisions_ and the US014 respelling. There is no backend, API or frontend.

**Built in five phases plus three fix rounds, each red before green:** P1 to P4 (`e3d5187` red,
`022f61a` green); round 2 (`9abb477`, `a56ce40`); P5 (`48a2501`); round 4 (`53a8713`); phase 9
review and QA, then its fix round (`5c24c12`). The decisions of each round are the plan's
_Key Decisions_ rows dated 05/11/2026, all Sam's.

**No other spec applies.** The story's FLAGS read N/A for every row but `QA`. Listing every
PLANNING folder on 05/11/2026 — `project-management/src/09-GDPR/PLANNING/`, the four
10-SECURITY category PLANNING folders, `project-management/src/12-SEO/PLANNING/`,
`project-management/src/13-API-DESIGN/PLANNING/` and `project-management/src/14-LOGGING/PLANNING/`
— found nothing for US004. This QA plan is the story's only PLANNING artefact, so no other
IMPLEMENTATION record is owed.

## 2. Acceptance-criteria gaps closed

The plan resolved all ten gaps and the fixture decisions into the story before code. Each is
checked here against what shipped. Probe names are those printed by
`bash code/src/scripts/audits/doc-references.sh --self-test` (130/130, exit 0, 05/11/2026); row
IDs are `../../18-TESTS/MANUAL/US004-MANUAL-TESTING.md`'s.

| Gap               | Status   | Evidence                                                                                                                                                                                                                                                             |
| ----------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1          | Resolved | No second guard. Phase 9's QA-US004-06 narrowed `is_naming_row` **itself**: its placeholder arms now apply only to a token without a slash (P9-QA-06 probes). Still one guard                                                                                        |
| AC-GAP-2          | Resolved | `is_registered()` translates `###` to three digit classes ("P4 AC-GAP-2 a class row admits US123"; REGISTER-01, REGISTER-03)                                                                                                                                         |
| AC-GAP-3          | Resolved | Restated as a class delta: AFTER-01 has 0 instance, 0 template-only, 0 plan-prefix and 28 named `[dangling path]` survivors, each with its owner in `../../18-TESTS/AUTOMATED/US004-TEST-STATUS.md`. Not reported as a pass                                          |
| AC-GAP-4 · 5      | Resolved | The citer test reads the citer's basename, by the derived rule of `../../15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md`, bounded on both sides since phase 9 (P3 AC-GAP-5, R2.1, P9-F4 probes). Holds with `copier.yml` unreadable (LOUD-02) |
| AC-GAP-6          | Resolved | Exactly the two `18-TESTS` class rows; no story-plan row (REGISTER-01)                                                                                                                                                                                               |
| AC-GAP-7          | Resolved | Replaced by measurement; the current controlled comparison is MEASURE-01 (Pass as amended 05/11/2026 — F-002), the historical 16 to 38 kept as history only                                                                                                          |
| AC-GAP-8          | Resolved | "P2 AC-GAP-8 an untracked excluded file is template-only after a rebuild"; its guard now asserts from the parent shell, after the trap has run, so it can fail (QA-US004-11)                                                                                         |
| AC-GAP-9          | Resolved | The `doc-references.sh` row was replaced within itself at every round; the phase 9 reviewer measured the file's line count unchanged across the story. GATES-01 reads 226 counted lines, the same as the `173abff` reference (row `Fail` only on F-001)              |
| AC-GAP-10         | Resolved | Literal presence before every suppression ("P4 AC-GAP-10 a class row rejects US000", "P4 EC-01 broken/missing-template-manual.md fires despite the class row"; TARGET-01, TARGET-02). Since phase 9 the marker cannot hide one either                                |
| Fixture decisions | Resolved | All mutations in five `--no-hardlinks` clones; US998 sha256 6257bca0…e209e before and after both A/Bs; US995 to US999 confirmed free; clones discarded (the guide's extra capture slots)                                                                             |

## 3. Scenario verification

The story has no pytest or Bruno suite (`../../18-TESTS/AUTOMATED/US004-TEST-STATUS.md`). Evidence
is the self-test, by probe name, and the walk of `../../18-TESTS/MANUAL/US004-MANUAL-TESTING.md`
on 05/11/2026 at `46d5c0f` by an agent that authored neither the change nor its reviews: **23
Pass, 12 Fail, no row amended**; after Sam's rulings of 05/11/2026, **24 Pass, 11 Fail**, with
MEASURE-01 amended and re-walked; **25 Pass, 10 Fail** once GATES-05 was re-walked Pass at the
check stage (F-003). All ten Fails share one cause, below.

**The before-edit captures were never taken (F-001).** The branch's first source edit was
`e3d5187`, and all five _Recorded during the build_ before-edit slots were empty at the walk. The
folder rule is that a missed capture is recorded as missed, never reconstructed, and no row that
reads it may be marked `Pass`. The walker re-measured the branch point `173abff` in a clean clone
for reference — 500 findings, against the session's live-checkout 502 — and the two-finding gap
is the index sensitivity this story removes, which is why the re-measurement cannot stand in for
the capture. **Where a scenario's behaviour is proved and its row fails only on that capture, the
result below reads "Met; row Fail on F-001".** Sam accepted that deviation on 05/11/2026 (Q1,
option 2) for BASELINE-02 to 05: the slots stay Missed and their rows Fail. His ruling also holds
BASELINE-01 captured before the first edit, but the evidence file cited is byte-identical to the
walk's own re-measurement, so that row is not re-marked until he confirms its source (F-001).

### Happy Path

| ID    | Scenario (from plan)                                                   | Result                      | Evidence                                                                                                                                                                                                                                                                                                                                           |
| ----- | ---------------------------------------------------------------------- | --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | A `CONTEXT.md` inside `research/` is no longer exempt; a note still is | Met; row Fail on F-001      | "P1 HP-01 research/CONTEXT.md is NOT exempt" and seven siblings; "P1 HP-01 a research note stays exempt (GUARD)". EXEMPT-02 Pass; EXEMPT-01 reads the file (1 read, 0 exempt) but has no BASELINE-03 to reverse                                                                                                                                    |
| HP-02 | US998 A/B: post-change template-only zero in both index states         | Met; before-edit A/B missed | AFTER-02 Pass: untracked 0, intent-to-add 0, identical sets, US998 restored untracked with bytes unchanged. BASELINE-04 Fail (F-001); the stock reference gave 12 → 0 by index state                                                                                                                                                               |
| HP-03 | A registered absent US997 automated record passes on the class row     | Pass                        | REGISTER-03, with a control proving the class row, not the wording, suppresses; "P4 HP-03 clean/pm-registered.md silent on registered US997 records (GUARD)" and both "real register admits" probes                                                                                                                                                |
| HP-04 | A dead PM `src/` citation is reported for the first time               | Pass                        | DEADPATH-01: `US999.md:3 [dangling path]` for the absent US997 story; "P4 HP-04 broken/pm-arm.md fires on a dead project-management/src path"                                                                                                                                                                                                      |
| HP-05 | `--self-test` exits 0, its probe count risen by one case per repair    | Met; row Fail on F-001      | Exit 0, 130 probes, nothing left behind (SELFTEST-01). BASELINE-02 missing; the `173abff` reference gives 15                                                                                                                                                                                                                                       |
| HP-06 | Stock versus arm-only on one frozen tree; no naming-pattern additions  | Pass (row amended)          | MEASURE-01, amended 05/11/2026 on Sam's ruling (Q2) to except the classes the plan's "PM-arm false-positive classes, 05/11/2026" row names, then re-walked in a fresh clone: 496 → 537, +41, none removed, the US997 target caught; the only naming-pattern additions fall in those named classes, which the shipped detector clears (R2.4). F-002 |

**The citation gate is not green.** AFTER-01 at `46d5c0f`, porcelain empty: exit 1, **28
`[dangling path]`, nothing else**, 330.27 s. Every one is a forward reference owned by US005,
US006, US010 or US014, named with its owner in the automated record. CLASSIFY-01 classified the
three findings new against the `173abff` reference — all another story's, none genuine to US004 —
and fails only on F-001.

### Error States

| ID    | Scenario (from plan)                                               | Result | Evidence                                                                                                                                                                                                                           |
| ----- | ------------------------------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | The register absent or its heading renamed fails loudly            | Pass   | LOUD-01: 28 → 119 findings, exit 1; restored, `git diff` empty. The heading is matched as a prefix, so a suffixed heading is still read (a walker's note, not a defect)                                                            |
| ES-02 | `copier.yml` unreadable: Check 3 empty, the citer test still holds | Pass   | LOUD-02: "matched against 210" then "matched against 0"; 0 instance findings both runs, the sets identical                                                                                                                         |
| ES-03 | The untracked-file probe fails mid-way; the trap cleans up         | Pass   | Not a standing probe and out of the guide's scope. Phase 9 QA forced a P2 failure and sent SIGTERM at 17 points: the tree stayed clean each time. "P2 ES-03 the probe file is gone once its shell has exited (GUARD)" now can fail |
| ES-04 | A malformed register row neither crashes nor registers everything  | Pass   | LOUD-03: no shell error, the 28-finding set identical to AFTER-01                                                                                                                                                                  |

### Edge Cases

| ID    | Scenario (from plan)                                                   | Result | Evidence                                                                                                                                                                                              |
| ----- | ---------------------------------------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | The manual US000 template, as citer and as target                      | Pass   | CITER-01 (`[instance citation]` from the template); TARGET-01 (missing target fires despite the class row; restored Clean). Probes "P3 EC-01a", "P4 EC-01" ×2                                         |
| EC-02 | A `-TEMPLATE.` file under an exempt tree is admitted and still policed | Pass   | EXEMPT-03, CITER-02; "P1 EC-02 MAP-000-TEMPLATE.md is NOT exempt", "P3 EC-02 broken/…-TEMPLATE.md citer is still reported (GUARD)"                                                                    |
| EC-03 | A class row matches exactly three digits                               | Pass   | REGISTER-04: four-digit and letter forms report; "P4 EC-03" ×3                                                                                                                                        |
| EC-04 | A naming row and a dead path on one line — the known limitation        | Pass   | REGISTER-05: an `e.g.` line still suppresses (and a control without it reports). **Narrowed by phase 9**: a dead path beside a `###` or `<DESCRIPTOR>` token is now reported (P9-QA-06 probes). F-007 |
| EC-05 | US999 cites the absent US997 story: citer exempt, target reported      | Pass   | DEADPATH-02: the dangling path and no instance finding; "P4 EC-05 broken/US999.md: Check 2 exempts the citer, Check 1 still fires"                                                                    |
| EC-06 | The automated US000 template as a missing target                       | Pass   | TARGET-02; "P4 EC-06 broken/missing-template-automated.md fires despite the class row", "P4 EC-06 real register rejects AUTOMATED/US000 (GUARD)"                                                      |

### Permission and Access

N/A. The plan's PA-01 records it: the story ships no endpoint, view or protected action, and the
script runs with the developer's own permissions.

## 4. Deviations from plan

| Deviation                                                                                                                                            | Justification                                                                                                                                                                                                                                       |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The before-edit captures were not taken**, so HP-05, HP-06's comparison point and the A/B "before" exist only as reference re-measurements         | **Justified by Sam's ruling of 05/11/2026** (Q1, option 2) — a process miss, accepted and documented, never reconstructed; the rows stay Fail. Preventive action in `.claude/MEMORY.md`. BASELINE-01's evidence is pending his confirmation (F-001) |
| **The citer test is a derived rule**, not the eight-form list the story names                                                                        | Plan _Key Decisions_ "Citer test shape", 05/11/2026; the list missed seven live classes. The 05/11/2026 ADR supersedes the 30/09/2026 one                                                                                                           |
| **The P1 arm is four arms scoped to copier's re-includes**, not one global fall-through for any `*/CONTEXT.md`, `*/CLAUDE.md`, `*-TEMPLATE.*`        | Phase 9 F5 and QA-US004-01, fixed under "Phase 9 findings, 05/11/2026": the global arm treated non-shipping nested pairs as shipped. `-TEMPLATE.` spelling: build grilling Q3                                                                       |
| **Three PM-arm false-positive classes fixed in the detector** — volume specs, `,:N` anchors, date placeholders — and dead PM paths repaired in place | Plan _Key Decisions_ rows of 05/11/2026 (round 2 Q2, Q3)                                                                                                                                                                                            |
| **A seeded citer is non-shipping for Checks 2 and 3**                                                                                                | "Seeded citers", build grilling round 4 Q1                                                                                                                                                                                                          |
| **`doc-references: ignore` cannot hide a missing shipped template**                                                                                  | Phase 9 round Q2, following the 09/10/2026 ADR; the script and the register row say so                                                                                                                                                              |
| **Template presence is tested from each directory between the citer and the root; a `.../` elision is a pattern**                                    | Phase 9 fix round Q1: the narrower rule added 23 false findings across 21 shipped files of correct prose (F-011)                                                                                                                                    |
| **GNU `realpath` replaced by a pure-bash normaliser**, both calls                                                                                    | Phase 9 F8, fixed under "Phase 9 findings"; the Dependencies row no longer lists it (F-010)                                                                                                                                                         |
| **Volume host halves outside the checked trees, and `../` host halves, stay unchecked**                                                              | Phase 9 fix round Q2: the tree scope predates US004 and no measurement argues for widening it (F-008)                                                                                                                                               |
| **`--self-test` in a generated project left failing**                                                                                                | Phase 9 round Q3: predates US004; a dated `GAPS.md` entry (F-012)                                                                                                                                                                                   |

## 5. New edge cases discovered

| ID               | Scenario                                                                                       | Result | Evidence                                                                 | Fold back?                                            |
| ---------------- | ---------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------ | ----------------------------------------------------- |
| P9-F1            | A relative citation crossing into or out of a checked tree is routed by the citer's directory  | Pass   | Fixed `5c24c12`; five P9-F1 probes                                       | No — fixed on the branch                              |
| P9-F4            | A basename ending in a word plus "US" and three digits read as an instance citer               | Pass   | Fixed `5c24c12`; twelve P9-F4 probes                                     | No — fixed                                            |
| P9-QA-03         | A dead volume host half under a checked tree                                                   | Pass   | Fixed `5c24c12`; two P9-QA-03 probes                                     | No — fixed; the tree-scope residue is F-008           |
| P9-QA-08         | A shipped template spelt relative to an unchecked tree                                         | Pass   | Fixed `5c24c12`; two P9-QA-08 probes                                     | No — fixed; the `.../` residue is F-011               |
| P9-QA-12         | A dated placeholder under a folder that does not exist                                         | Pass   | Fixed `5c24c12`; two P9-QA-12 probes                                     | No — fixed                                            |
| P9-F9            | A self-test killed by SIGKILL leaves its probe file                                            | Pass   | The next run sweeps it (P9-F9)                                           | No — residue F-009                                    |
| QA-US004-05      | `--self-test` without `copier.yml`                                                             | Open   | Four probes fail, two of them US004's                                    | Yes — dated `GAPS.md` entry of 05/11/2026             |
| F7 · QA-US004-04 | The `.copier/` seed bodies a generated project receives are read by no clause                  | Open   | Both verifiers: real, but predates US004 and is not this change's defect | Yes — a new dated `GAPS.md` entry (F-013)             |
| QA-US004-02      | A citation respelt in short form by an owning story never clears                               | Pass   | `US014.md:813` respelt in full at `74b9892`                              | No — the survivor now clears when US014 builds        |
| —                | The plan's round 2, round 4 and phase 9 decisions have probes but no QA scenario or manual row | —      | QA-US004-11                                                              | Yes — the next plan writing a detector change (F-015) |

## 6. Deferred scenarios

None deferred by choice. HP-05's row stands Fail on F-001, an accepted deviation (Sam, 05/11/2026):
the capture cannot be taken retrospectively, so it is never re-walked to a Pass. HP-06 passes on
MEASURE-01 as amended (F-002).

## 7. Accessibility observations

- **axe-core:** N/A. No rendered route.
- **Keyboard & focus:** N/A. No interactive component.
- **Equal-weight actions:** N/A.
- **Other:** the plan's one obligation holds: findings keep the `file:line [class] token` shape, so
  a screen reader and a pager read them as before (AFTER-01's output).

## 8. GDPR & security observations

- **PII at rest:** N/A. The script reads repository documentation and emits paths.
- **PII in responses:** N/A.
- **Rights paths:** N/A.
- **Security gate:** N/A — no endpoint and no permission surface. The plan's one security-adjacent
  property holds: the P2 probe file is created under `research/`, a path the repository owns,
  with `mktemp`, and is removed on every trappable exit; SIGKILL is the residue (F-009).

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified — the missed captures by Sam's ruling of 05/11/2026 (F-001); BASELINE-01's evidence pending his confirmation
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build (N/A, no rendered surface)
- [x] GDPR & security observations confirmed (or N/A recorded)
- [x] Coverage floors met for all modules in scope (no module in scope)
- [ ] Manual testing sign-off (see `../../18-TESTS/MANUAL/US004-MANUAL-TESTING.md`) — walked by an
      independent agent, **25 Pass, 10 Fail** after Sam's rulings; GATES-05 re-walked Pass at the
      check stage 05/11/2026, ShellCheck exit 0 (F-003); open on BASELINE-01 (F-001)
- [ ] Reviewer approval — Sam, at `23-pr-and-review`

---

## Cross-references

- `../PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the pre-development plan verified here
- `../../02-STORIES/US004.md` — the story under review
- `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the plan and its _Key Decisions_ of 05/11/2026
- `../../18-TESTS/AUTOMATED/US004-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US004-MANUAL-TESTING.md` — downstream test records
- `../../19-REVIEWS/REVIEW-US004-CITATION-GATE-GIT-INDEX.md` — the phase 9 review, QA pass, verifiers and fix round
- `../../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md` — the findings this review cites
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
