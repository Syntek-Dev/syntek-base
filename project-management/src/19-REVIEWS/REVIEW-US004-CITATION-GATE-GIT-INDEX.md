# Code Review — US004 The citation gate stops depending on the git index, and the PM tree becomes checkable

**Last Updated**: 05/11/2026 · **Story**: US004 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US004 — the citation gate stops depending on the git index, and the PM tree becomes checkable                                                                                                                                                                                   |
| **Branch**   | `us004/citation-gate-git-index` (cut from `testing` at `173abff`; P1–P4 `e3d5187` red, `022f61a` green; round 2 `9abb477`, `a56ce40`; P5 `48a2501`; round 4 `53a8713`; phase 9 fixes `5c24c12`; decisions `94e7671`, `2b24ae8`, `74b9892`, `46d5c0f`)                           |
| **PR**       | Raised at `23-pr-and-review` Step 3 · target `testing`                                                                                                                                                                                                                          |
| **Reviewer** | Claude — phase 9 `code-reviewer` and `qa-tester` dispatches at `53a8713`, each finding then put to an adversarial verifier; the fix round's red, green and verify dispatches. None wrote the work it reviewed                                                                   |
| **Date**     | 05/11/2026                                                                                                                                                                                                                                                                      |
| **Verdict**  | Phase 9: no blocker; one major and seven minor or nit confirmed by the review, ten by QA; three rejected. Every confirmed finding fixed (16 in `5c24c12`, QA-US004-02 at `74b9892`) bar QA-US004-05, deferred to `GAPS.md` by Sam. **The walk then failed 12 rows** (Section 4) |

**Codes from:** `../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` → _Key Decisions_
— every row dated 05/11/2026 is Sam's: the build grilling (Q1 to Q4), round 2, round 4, the phase 9
round (Q1 to Q3) and the phase 9 fix round (Q1, Q2).
**Story:** `../02-STORIES/US004.md` — the acceptance criteria this review judges against.

> **Who writes this record.** `CLAUDE.md` in this folder places reviews in
> `23-pr-and-review` and `code/workflows/07-review/`. The phase 9 passes recorded here are the
> `07-review` content review run inside the build. This record is drafted at
> `22-implementation-documentation`, from those passes' own outputs, following the US003
> precedent; `23-pr-and-review` completes it with its final passes and verifies it.

---

## 1. Scope & files reviewed

A bash script, its fixtures and Markdown. No Python, template, endpoint, migration or UI.

| File                                                                      | Change                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`                               | 1119 → 2023 lines (shell is exempt from the 750-line limit). One population for scan and excluded set; the scoped exemption arms; the derived citer rule; the PM arm; class registration; literal template presence; the round 2, round 4 and phase 9 repairs; self-test 15 → 130 probes                                                                                                                       |
| `code/src/scripts/audits/fixtures/doc-references/` `broken/` and `clean/` | 10 → 63 tracked fixtures                                                                                                                                                                                                                                                                                                                                                                                       |
| `code/src/scripts/audits/CONTEXT.md`                                      | The `doc-references.sh` row replaced within itself at each round; the Dependencies row no longer lists `realpath`                                                                                                                                                                                                                                                                                              |
| `how-to/src/PROJECT-PATHS.md` · `code/docs/FORWARD-VOICE.md`              | Two patterned `18-TESTS` rows and the header note; Section 3's pattern form and duty                                                                                                                                                                                                                                                                                                                           |
| P5 sweep — shipped files                                                  | `project-management/src/02-STORIES/CONTEXT.md`, `project-management/src/03-SPRINTS/CONTEXT.md`, `how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md`, `project-management/docs/planning/SPRINTS.md`, `project-management/src/15-DECISIONS/CONTEXT.md`, `project-management/workflows/15-decisions/STEPS.md`, `project-management/src/00-ASSETS/scripts/pm-board.sh`, `THIRD-PARTY-NOTICES.md`, `research/CLAUDE.md` |
| P5 sweep — PM records                                                     | Dead PM paths repaired in place, each with a dated `UPDATED` comment; `US014.md:813` respelt in full (QA-US004-02)                                                                                                                                                                                                                                                                                             |
| Decision trail                                                            | `../15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md` accepted and the 30/09/2026 citer record superseded; the plan's _Key Decisions_; N-009's overturned claim on `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`; the self-test-downstream `GAPS.md` entry                                                                                                                                   |

---

## 2. Findings

Severity is each pass's own grade (major, minor, nit), recorded here as Medium, Low and Info. A
verifier's re-grade is noted. The phase 9 outputs live outside the tree in
/tmp/us004-phase9-evidence.json; the findings record names what survives as known limitations.
"Finding F-0NN" points into `../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`.

### 2.1 Phase 9 — `code-reviewer`, at `53a8713`; fixed in `5c24c12`

The reviewer measured 81/81 probes, the whole tree at exactly 28 survivors, `--path` exiting 2 on
a missing or outside path, and the CONTEXT row replaced with no line added. **Spec axis: P1 to P5
and every 05/11/2026 Key Decisions row implemented as written.**

| ID    | Severity | File:line (at `53a8713`)                                   | Issue                                                                                                                                                                 | Resolution/Status                                                                                                                                                         |
| ----- | -------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001 | Medium   | `doc-references.sh:946`, `:1015-1025`, `:1043-1047`        | F1: a relative token is sorted into a checked tree before its `..` is normalised — a false negative from `research/` into the PM tree, a false positive the other way | Fixed `5c24c12` — normalised as soon as resolved; a path leaving the repository is dropped. Five P9-F1 probes                                                             |
| R-002 | Low      | `doc-references.sh:701-706`                                | F2: the seeded-citer comment says "Checks 1 and 2 are unaffected" while the code skips Check 2                                                                        | Fixed `5c24c12` — rewritten                                                                                                                                               |
| R-003 | Info     | `doc-references.sh:8`, `:1598`                             | F3: header and printed footer still list the retired `ADR-###` form                                                                                                   | Fixed `5c24c12` — `ADR-US###` (also QA-US004-09)                                                                                                                          |
| R-004 | Low      | `doc-references.sh:632`                                    | F4: the citer rule has no left boundary, so a name such as STATUS200.md is an instance citer                                                                          | Fixed `5c24c12` — `(^\|[^A-Za-z])` before the number forms; twelve P9-F4 probes                                                                                           |
| R-005 | Low      | `doc-references.sh:361-368`                                | F5: the fall-through arm is global; copier's re-includes are scoped                                                                                                   | Fixed `5c24c12` — four arms mirroring copier's re-includes (also QA-US004-01)                                                                                             |
| R-006 | Low      | `doc-references.sh:1036-1039`; audits `CONTEXT.md`         | F6: the ignore marker no longer hides a missing template, and the docs still say it suppresses outright                                                               | Fixed `5c24c12` — behaviour kept (phase 9 round Q2); the script comment and the row say so (also QA-US004-07)                                                             |
| R-007 | —        | `doc-references.sh:704-709`; `.copier/README.md`           | F7: the `.copier/` seed body is checked by nothing                                                                                                                    | **Rejected** by the verifier — the four findings are not defects on reading, and the `.copier/*` exemption predates US004. Recorded as a pre-existing coverage gap, F-013 |
| R-008 | Info     | `doc-references.sh:1045`; audits `CONTEXT.md` Dependencies | F8: a second GNU-only `realpath -m --relative-to`; on macOS the fallback silently keeps the unnormalised path                                                         | Fixed `5c24c12` — a pure-bash normaliser replaces both calls; two P9-F8 probes with `realpath` stubbed out (F-010)                                                        |
| R-009 | Info     | `doc-references.sh:1205-1237`                              | F9: SIGKILL leaves the P2 probe file in the working tree                                                                                                              | Fixed in part `5c24c12` — the next run sweeps it (P9-F9). SIGKILL cannot be trapped (F-009)                                                                               |

### 2.2 Phase 9 — `qa-tester`, at `53a8713`; fixed in `5c24c12`

The breaker measured 81/81, the 28 survivors identical under `--path .`, all five `--path` forms
per `audits/CLAUDE.md`, and the P2 probe file removed under a forced failure and SIGTERM at 17
points.

| ID    | Severity | File:line (at `53a8713`)                     | Issue                                                                                                               | Resolution/Status                                                                                                                                                                                               |
| ----- | -------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-010 | Low      | `doc-references.sh:361`                      | QA-US004-01: the exempt-tree arm is wider than copier's re-includes                                                 | Fixed `5c24c12` with R-005                                                                                                                                                                                      |
| R-011 | Low      | `US014.md:813`; the `tests/*` shorthand arm  | QA-US004-02: a survivor written in short form resolves under `code/src/scripts/tests/` and would never clear        | Fixed `74b9892` — the citation respelt in full; the survivor now clears when US014 builds                                                                                                                       |
| R-012 | Info     | `doc-references.sh:~926`                     | QA-US004-03: the `:/` skip hides the host half of a volume spec (verifier re-graded minor to nit)                   | Fixed `5c24c12` — a "./x" or "a/b" host half is tested. The fix verifier's reproduction stays silent, because it cites under unchecked `code/src/`; settled as a known limitation, phase 9 fix round Q2 (F-008) |
| R-013 | —        | `doc-references.sh:362`, `~707`              | QA-US004-04: seed bodies are never read                                                                             | **Rejected** — the same pre-existing gap as R-007 (F-013)                                                                                                                                                       |
| R-014 | Low      | `doc-references.sh:1224-1236`, `~1505-1520`  | QA-US004-05: `--self-test` fails in a generated project; two of the four failing probes are new                     | **Deferred** by Sam (phase 9 round Q3) — dated `GAPS.md` entry of 05/11/2026 (F-012)                                                                                                                            |
| R-015 | Info     | `doc-references.sh:~757`                     | QA-US004-06: EC-04 is larger now the PM tree is checked; no shipped owner states it (re-graded to nit)              | Fixed `5c24c12` — the placeholder arms of `is_naming_row` apply only to a slashless token; no new finding on the tree (F-007)                                                                                   |
| R-016 | Info     | `doc-references.sh:~1034-1038`               | QA-US004-07: the marker contract and its docs disagree                                                              | Fixed with R-006                                                                                                                                                                                                |
| R-017 | Info     | `doc-references.sh:~1018-1025`               | QA-US004-08: a template spelling resolving into no checked tree is never presence-tested                            | Fixed `5c24c12`, **widened** beyond the brief: presence tried from each directory up to the root, `.../` a pattern (phase 9 fix round Q1; F-011)                                                                |
| R-018 | Info     | `doc-references.sh:8`, `:1598`               | QA-US004-09: `ADR-###` in the rule text                                                                             | Fixed with R-003                                                                                                                                                                                                |
| R-019 | —        | `doc-references.sh:~248`                     | QA-US004-10: the citer rule has no left boundary                                                                    | **Rejected** by its verifier: "BOUNDED" means right-bounded, as the ADR defines it. R-004 is the same defect, confirmed by the other verifier, and fixed                                                        |
| R-020 | Info     | QA plan ES-03; `doc-references.sh:1239-1245` | QA-US004-11: the P2 guard is tautological; round 2, round 4 and phase 9 decisions have no QA scenario or manual row | Guard fixed `5c24c12` — it asserts from the parent after the trap has run. The coverage gap is F-015                                                                                                            |
| R-021 | Info     | `doc-references.sh:~214`                     | QA-US004-12: a date placeholder drops the whole token, its folder included                                          | Fixed `5c24c12` — the folder is tested; two P9-QA-12 probes                                                                                                                                                     |

### 2.3 The fix round — red, green and verify

- **Red:** 49 new probes — 26 RED, all failing; 23 GUARD, all passing — with all 81 earlier probes
  green (104/130). An incident: a measurement `sed` meant for a clone hit the live script after a
  cross-device `git clone --local` failed; the two lines were restored exactly and the
  measurement redone in a `--no-hardlinks` clone (finding F-016).
- **Green:** 130/130, no expectation edited. The whole-tree run before and after: 28 and 28,
  identical finding sets. One deviation put to Sam (R-017's widening, settled Q1). One rule slip:
  `prettier --check` run directly once, read-only (F-016).
- **Verify:** 15 of 16 reproductions resolved; QA-US004-03's own reproduction stays silent
  because it cites a tree the gate does not check — settled Q2 (F-008). 110 of 114 expectation
  lines byte-identical to `HEAD`; the four that moved are the P2 block, restructured on purpose.
  Full tree: 28 `[dangling path]`, nothing outside the accepted survivors.

### 2.4 The walk — at `46d5c0f`; not fixed

| ID    | Severity | Where                                                            | Issue                                                                                                                           | Resolution/Status                                                                    |
| ----- | -------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| R-022 | High     | Manual guide _Recorded during the build_, five before-edit slots | The before-edit captures were never taken; ten rows fail on them, and the story's "before any edit" criterion cannot now be met | Open — Sam's disposition at `23-pr-and-review` (F-001)                               |
| R-023 | Low      | Manual row MEASURE-01                                            | The arm-only copy adds one `-DD-MM-YYYY.md` date-placeholder finding, which the row forbids; the shipped detector clears it     | Open — a proposed amendment for Sam to confirm (F-002)                               |
| R-024 | Low      | `doc-references.sh:828`, `:1308`, `:1322`                        | ShellCheck not clean: SC2221/SC2222 (pre-existing), SC2016 ×2 (pre-existing), SC2329 ×2 new in the P9-F8 `realpath` stubs       | Open — the build, under "Phase 9 findings, 05/11/2026", or Sam's disposition (F-003) |

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- N/A — no endpoint, permission, secret or setting; the Security flag reads N/A. The P2 probe
  writes under `research/` with `mktemp` and removes its file on every trappable exit.

### 3.2 GDPR / PII

- N/A — no personal data processed.

### 3.3 Test coverage vs floors

- N/A for the code floors — no Python path, and no automated test declares US004
  (`../18-TESTS/AUTOMATED/US004-TEST-STATUS.md`).
- [x] `--self-test` 130/130, exit 0; every new probe red against the detector it was written for.
- [ ] Every manual QA acceptance criterion walked and passing — **23 Pass, 12 Fail** (Section 2.4).

### 3.4 Quality, DRY & file length

- [x] No second naming guard written (AC-GAP-1); QA-US004-06 changed the one guard there is.
- [x] `code/src/scripts/audits/CONTEXT.md` grown by no line; 226 counted lines (GATES-01).
- [x] `docs-pairing.sh` and `doctrine-drift.sh` exit 0 (GATES-02, GATES-03).
- [x] Markdown lint clean on the 89 Markdown files the story changes (GATES-04); the whole-tree
      exit 1 is the gitignored `graphify-out/GRAPH_REPORT.md`, the filed
      `../21-BUGS/BUG-LINT-READS-GITIGNORED-GRAPHIFY-OUT-02-11-2026.md`.
- [ ] ShellCheck clean — not clean (R-024).
- Observation: the script nearly doubled, roughly half of it self-test. Shell is exempt from the
  750-line limit but should stay focused (`code/src/scripts/CLAUDE.md`); F-017.

### 3.5 Performance

- The whole-tree run took 330.27 s at the walk (AFTER-01), against the session's 438 s on the
  stock detector at the branch point and the reviewer's 7:59 against 5:52, run concurrently. The
  wider population did not slow the run (plan _Risks_).

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI. The `file:line [class] token` output shape is unchanged.

---

## 4. Required actions before merge

1. **R-022 / F-001** — Sam rules on the missed before-edit captures, which block ten manual rows
   and the story's "record the baseline and A/B before editing" criterion.
2. **R-023 / F-002** — Sam confirms or rejects MEASURE-01's proposed amendment.
3. **R-024 / F-003** — ShellCheck fixed in the build, or Sam's disposition.
4. **F-019** — Sam accepts or supersedes the still-`Proposed`
   `../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`, which the detector
   already implements.
5. Sam's countersignature of the walk, and the guide's last sign-off box (the cross-check against
   the automated record, which exists from this closeout).

---

## 5. Verdict & status transition

- **Verdict:** the phase 9 review and its fix round leave no open code finding but one deferred
  gap; the walk does not pass. **Changes-requested until the four decisions above are settled.**
- **Reasoning:** every owned class is at zero over the whole tree, and the 130-probe self-test
  separates every fixture pair. But a story whose subject is a before-and-after measurement
  never took the before, and the gate it repairs still exits 1 on 28 named survivors, so the
  baseline-diff regime does not retire with it (F-004).
- **Status transition:** none recorded here. `In Progress` → `In Review` and onward are the
  `completion` skill's, at `23-pr-and-review`.

---

## 6. Notes

### Rejected, not recorded as defects

- **F7 and QA-US004-04** — the seed bodies are unchecked, but that predates US004 and is not this
  change's defect. It is a real coverage gap nonetheless, recorded as F-013 with a `GAPS.md` entry.
- **QA-US004-10** — refuted on the ADR's definition of "bounded"; the same defect was confirmed
  as F4 and fixed, so the probe set covers it either way.

### Gate evidence

| Gate                                                       | At the walk (`46d5c0f`)                                              | Reading                                                                                                      |
| ---------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `code/src/scripts/audits/doc-references.sh`                | exit 1; 28 `[dangling path]`; 0 instance, template-only, plan-prefix | Survivors owned by US005, US006, US010 and US014. Not a pass, and no before-edit run to diff against (F-001) |
| `doc-references.sh --self-test`                            | exit 0, 130 probes                                                   | Re-run at this closeout, same result                                                                         |
| `docs-length.sh` · `doctrine-drift.sh` · `docs-pairing.sh` | exit 0 · exit 0 · exit 0                                             | GATES-01 fails only on F-001                                                                                 |
| ShellCheck 0.11.0, by hand                                 | exit 1                                                               | R-024                                                                                                        |

### Known reds for the PR body

- `Audit — Doc References` / `Citations resolve` — 28 forward references owned by US005, US006,
  US010 and US014, and none of US004's classes.

---

## Cross-references

- `../02-STORIES/US004.md` — the story under review
- `../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the plan and its _Key Decisions_
- `../18-TESTS/AUTOMATED/US004-TEST-STATUS.md` · `../18-TESTS/MANUAL/US004-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md` — the findings
- `project-management/workflows/22-implementation-documentation/` · `project-management/workflows/23-pr-and-review/` — `22` drafted this record; `23` completes and verifies it
