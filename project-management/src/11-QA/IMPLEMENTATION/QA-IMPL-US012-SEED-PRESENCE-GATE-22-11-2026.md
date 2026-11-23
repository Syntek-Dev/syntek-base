# QA Implementation Review — US012 A seeded file that never lands is reported, and the gate's header claim becomes true

| Field        | Value                                                                                                                                                                                                        |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**    | US012 — a seeded file that never lands is reported, and the gate's header claim becomes true                                                                                                                 |
| **Date**     | 22/11/2026                                                                                                                                                                                                   |
| **Sprint**   | SPRINT-07                                                                                                                                                                                                    |
| **Reviewer** | Claude — a `22-implementation-documentation` subagent that wrote none of the story's code, from the CI logs, the diff and the walked guide; the adversarial pass was the `qa-tester` review (QA-01 to QA-04) |
| **Branch**   | `us012/seed-presence-gate` — cut from `dev` at `8e0da02b`; reviewed at the landing head `4dc043c8`                                                                                                           |
| **Plan doc** | `../PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md`                                                                                                                                                            |
| **Outcome**  | **Pass with deviations** — every scenario closed with evidence or its planned disposition; deviations are the probe count (8 -> 9) and the unmeasured 72-case matrix; QA-01 kept as a known limit by Sam     |

---

## 1. Scope

What shipped: one file, `.github/scripts/shipped-artefacts.sh` — check 4's loop over
`"${SEEDED[@]}"` (`:284-287`) with a finding naming the seed's own repair, the `4b` self-test probe
on the last seed (`:351-360`), a seed paragraph in the closing guidance (`:436-439`), and the header
list, too-tight paragraph, `SELF-TEST`, exit codes, `--help`, the check-4 comment and the `SEEDED`
comment. `SEEDED`'s entries and `.github/workflows/audit-template.yml` are unchanged. The surface is
Gate only: no route, no screen, no model.

**Scope matches the plan**, read through its CORRECTED 22/11/2026 block: `SEEDED` holds ten entries
(US010 landed first; US011 absorbed), so the probe moves `21-BUGS/BUGS-BOARD.md`, and the count is
nine probes where it was eight. Exhaustive 72-case generation is not this story's (Section 6).

## 2. Acceptance-criteria gaps closed

All nine gaps in the plan's Section 1 read `[RESOLVED] 21/09/2026`, written back into the story
then. Each is checked here against what shipped.

| Gap                                                                 | Status   | Evidence                                                                                                                                                  |
| ------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 — the closing guidance still sent a seed to the allowlist  | Resolved | The "named beside" form, `:436-439` (manual FINDING-03). Only partly meets ES-02's intent — QA-01, kept by Sam 22/11/2026 (Section 4; finding F-004)      |
| AC-GAP-2 — `probe()` proves the wording, not the negation's absence | Resolved | Positive half by string test (no match against the named-file message, automated record 2.2); negative half read at review, recorded as read (FINDING-02) |
| AC-GAP-3 — exit 1 does not evidence the red run                     | Resolved | Red run `45058050943`: the probe's own `✗ … produced 0 finding(s): (none);` line, 0 `mv: cannot stat` (RED-02, RED-04)                                    |
| AC-GAP-4 — where the runs happen                                    | Resolved | CI `[3/4]` on the pushed branch only; no local generated tree (automated record 2.1)                                                                      |
| AC-GAP-5 — a first-entry probe cannot see a first-entry loop        | Resolved | The probe moves `${SEEDED[${#SEEDED[@]}-1]}` (LOOP-04); `SEEDED` holds ten, so the `"${SEEDED}"` shape fails it                                           |
| AC-GAP-6 — "no job goes red" too strong                             | Resolved | Story rationale narrowed 21/09/2026; nothing in the build depends on it                                                                                   |
| AC-GAP-7 — "never by deleting the path" is an instruction           | Resolved | The `SEEDED` comment states the retirement rule (HEADER-06); the baseline's refusal unchanged (LOOP-05)                                                   |
| AC-GAP-8 — does the finding name a source path                      | Resolved | No: "its .copier/ source file", generically (FINDING-02)                                                                                                  |
| AC-GAP-9 — two wording repairs                                      | Resolved | Story text, 21/09/2026; ShellCheck recorded as run and clean (automated record 2.2)                                                                       |

## 3. Scenario verification

Run evidence is from the four `[3/4] Template Generation` runs in
`../../18-TESTS/AUTOMATED/US012-TEST-STATUS.md` Section 2.1; row IDs are
`../../18-TESTS/MANUAL/US012-MANUAL-TESTING.md`'s.

### Happy Path

| ID    | Scenario (from plan)                                           | Result    | Evidence                                                                                                                                                            |
| ----- | -------------------------------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | Full run over `gen-false`, `gen-true`: exit 0, no seed finding | Pass      | Runs `45058371338` and `45060223669`: both trees "every artefact tree arrived empty", "A generated project receives empty artefact trees."; GREEN-04, GREEN-07      |
| HP-02 | `--self-test` passes, success line counts the probes           | Deviation | Passes at **9 probes**, not the plan's 6 — the plan's count was wrong (story amendment of 22/11/2026; F-001). Runs `45058371338`, `45060223669`; GREEN-01 (amended) |
| HP-03 | The probe sees exactly one finding, path then seed wording     | Pass      | `✓ check 4 fires when a seeded file does not land` in the green and head runs; `probe()` passes only on exactly one finding; FINDING-01, LOOP-04                    |
| HP-04 | The seed restored; the check-5 probe sees its own one finding  | Pass      | `✓ check 5 fires when an artefact-tree .gitignore leaks`, next line after the new probe; GREEN-02                                                                   |
| HP-05 | Check 3's map-leak probe still sees one finding                | Pass      | `✓ check 3 fires when a feature map leaks`; GREEN-03                                                                                                                |
| HP-06 | Header, `--help` and comments name the seed check              | Pass      | `--help` run on the host, exit 0; HEADER-01 to HEADER-08 (HEADER-07 amended, F-002)                                                                                 |

### Error States

| ID    | Scenario (from plan)                                                  | Result          | Evidence                                                                                                                                                                  |
| ----- | --------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | A tree lacking a seed: one finding, exit 1                            | Pass — by proxy | No lawful tree lacks a seed (plan _Testing_). The finding is the one the probe produces inside its own copy — exactly one, run `45058371338`; its text read at FINDING-01 |
| ES-02 | Closing guidance does not send the reader to `_exclude` or a `!`      | Pass — read     | Source read, `:431-439`: the seed paragraph names the seed's repair and "never add a '!' negation"; parsed by `bash -n`. Known limit QA-01 (Section 4; F-004). FINDING-03 |
| ES-03 | Real tree lacking a seed: baseline refuses, exit 2                    | Pass — read     | The baseline path is unchanged by the diff (LOOP-05); the loop it now reaches is check 4's, so a seed finding takes the same refusal                                      |
| ES-04 | The red run: probe's line reports 0 findings, the others pass, exit 1 | Pass            | Red run `45058050943`, job `137317593803`: the `✗` line with 0 findings, **eight** others `✓` (the plan's "five", F-001), exit code 1; RED-02 (amended), RED-04           |
| ES-05 | Seed absent at red: `mv` aborts, no probe line — not red evidence     | Pass — avoided  | No `mv: cannot stat` in any of the four logs; the red is the probe's (RED-04)                                                                                             |

### Edge Cases

| ID    | Scenario (from plan)                                        | Result         | Evidence                                                                                                                                                                |
| ----- | ----------------------------------------------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | Middle seed absent: one finding naming it                   | N/A — fixture  | A fixture reading the QA plan recorded (Section 7); no criterion needs it and no lawful tree carries it (plan Key Decision 7). The loop's any-position reach is LOOP-01 |
| EC-02 | A loop over `"${SEEDED}"` fails the last-entry probe        | Pass — read    | The loop is `"${SEEDED[@]}"` (LOOP-01, `:284`); with ten entries the unsubscripted form would leave the last entry unchecked and fail the probe                         |
| EC-03 | `mv` retargeted to the `src/` root                          | N/A — fixture  | As EC-01; the QA plan's fixture reading stands                                                                                                                          |
| EC-04 | Seed lands as a directory                                   | N/A — fixture  | As EC-01. The shipped loop tests `-f`, so the planned reading holds; `-e` would miss it and pass the probe (QA-02, Section 5)                                           |
| EC-05 | No `project-management/src/`: one finding, not one per seed | Pass — read    | The loop sits inside check 3's `else` (`:243-288`); LOOP-02                                                                                                             |
| EC-06 | A path in both arrays                                       | Pass — read    | No path is in both `SEEDED` and `NAMED_SHIPPED`; LOOP-03                                                                                                                |
| EC-07 | Substring against the named-file message: no match          | Pass           | Positive half: string test, no match (automated record 2.2). Negative half: read at review, recorded as read (FINDING-02)                                               |
| EC-08 | `SEEDED` emptied: subscript aborts under `set -u`           | N/A — accepted | Known limitation, not fixed (plan _Deferred Items_): retiring the last seed removes the probe in the same change                                                        |
| EC-09 | `gen-true` never read by the self-test                      | Pass — read    | `audit-template.yml:269` passes `gen-false` alone; `:272` covers both trees in the full run; GREEN-05 (amended)                                                         |

### Permission and Access

**N/A** — the plan's `PA` table reads N/A: no endpoint, view or protected action.

## 4. Deviations from plan

| Deviation                                                                                        | Justification                                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Probe count 9 where it counted 8, not 6 where it counted 5 (HP-02, ES-04)                        | The plan was written against a five-probe script; it ran eight at `8e0da02b`. Settled at the implement-story grilling Q1, 22/11/2026, and written into the story and plan (`e004d23f`). Intent unchanged — one more probe. F-001                                                                                         |
| The closing guidance names the seed's repair **beside** the allowlist's, printed unconditionally | AC-GAP-1 allowed either form; the build took the one with no logic below the green `exit 0`. QA-01 (low): on a seed-only failure "Fix the allowlist there" still prints first, and a leak-only failure gets the seed paragraph. **Sam ruled 22/11/2026 to keep the shipped form and record it as a known limit** (F-004) |
| The plan's anchors and its `SEEDED` and US011 facts                                              | Stale after US010's re-cut; corrected in the plan's CORRECTED 22/11/2026 block before code (F-002)                                                                                                                                                                                                                       |

## 5. New edge cases discovered

From the `qa-tester` pass (approve with notes). None is a defect in what the story specified.

| ID    | Scenario                                                                                                                 | Result      | Evidence                                                                                                                                                                                                                                                      | Fold back?                       |
| ----- | ------------------------------------------------------------------------------------------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| QA-02 | A loop checking only the last entry, or `-e` for `-f`, passes the self-test                                              | Known limit | The one probe moves the last entry only; review is the guard (LOOP-01 reads the shipped `-f` over every entry). A second probe would be new machinery                                                                                                         | No — recorded (F-005)            |
| QA-03 | A seed landing as a symlink to a file passes checks 3 and 4                                                              | Known limit | `-f` follows the link and `find -type f` skips it. Pre-existing; Copier's `mv` cannot produce one                                                                                                                                                             | No — recorded (F-006)            |
| QA-04 | The `SELF-TEST` header's line-wrap (= CR-US012-02)                                                                       | Fixed       | `4dc043c8`, comment-only; `self_test()` non-comment lines unchanged (TM-15)                                                                                                                                                                                   | No                               |
| —     | Manual rows with QA `—`: RED-01, RED-03, GREEN-06, GREEN-07, LOOP-06, LOOP-07, HEADER-07, MAP-01, REMEDY-01 to REMEDY-04 | Walked      | Each marked in the guide; REMEDY-01, -02, -03 `Fail` at the 22/11 walk (findings F-008, F-009, F-003), the rest `Pass`; 23/11/2026: REMEDY-01 fixed and re-walked `Pass`, REMEDY-02 superseded by dropping the column, REMEDY-03 non-blocking (Sam's rulings) | No — process rows, not scenarios |

## 6. Deferred scenarios

| Scenario                                                    | Reason                                                                                                                                           | When to address                                                                 |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| Exhaustive generation — the 72 valid offered configurations | Moved 19/11/2026 out of US010 to `MAP-GENERATION-COVERAGE` S-01, uncut; US012 records it **unmeasured** and leaves it unticked (story amendment) | When S-01 is cut and lands (`../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md`) |

## 7. Accessibility observations

N/A — no rendered screen (plan Section 3). The one property it names holds: the failing probe line
carries `✗` and "produced 0 finding(s)", so colour is never the only signal (manual RED-03).

- **axe-core** — N/A, no route
- **Keyboard & focus** — N/A
- **Equal-weight actions** — N/A
- **Other** — terminal text only; the new finding and probe use the existing `finding()` and `probe()` idiom

## 8. GDPR & security observations

N/A — no personal data processed. The script reads file names in a generated tree and prints paths.

- **PII at rest** — N/A
- **PII in responses** — N/A
- **Rights paths** — N/A
- **Security gate** — the plan's one security-shaped constraint holds: neither the finding nor the closing guidance advises a `!` negation for a seed, the edit that would open the `copier update` one-way door (FINDING-02, FINDING-03). The file never ships (`audit-template.yml` asserts `.github/scripts` absent from a generated project)

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build
- [x] GDPR & security observations confirmed (or N/A recorded)
- [ ] Coverage floors met for all modules in scope — **N/A**, no Python module in scope; left unticked rather than claimed
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US012-MANUAL-TESTING.md`) — walked 22/11/2026, REMEDY-01 and -02 re-walked 23/11/2026: 32 Pass, 2 Fail, neither blocking (Sam's rulings 23/11/2026); **countersigned by Sam, 23/11/2026**
- [x] Reviewer approval — **blocks merge until complete**; given by Sam, 23/11/2026

---

## Cross-references

- `../PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` — the pre-development plan verified here
- `../../02-STORIES/US012.md` — the story under review
- `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the plan, its CORRECTED 22/11/2026 block first
- `../../18-TESTS/AUTOMATED/US012-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US012-MANUAL-TESTING.md`
  — downstream test records
- `../../20-FINDINGS/archive/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md` — the findings F-001 to F-010
- `../../19-REVIEWS/` — code-review notes from the same PR, written at `23-pr-and-review`
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
