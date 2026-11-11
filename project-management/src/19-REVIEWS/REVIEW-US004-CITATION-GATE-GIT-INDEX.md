# Code Review — US004 The citation gate stops depending on the git index, and the PM tree becomes checkable

**Last Updated**: 09/11/2026 · **Story**: US004 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US004 — the citation gate stops depending on the git index, and the PM tree becomes checkable                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Branch**   | `us004/citation-gate-git-index` (cut from `testing` at `173abff`; P1–P4 `e3d5187` red, `022f61a` green; round 2 `9abb477`, `a56ce40`; P5 `48a2501`; round 4 `53a8713`; phase 9 fixes `5c24c12`; decisions `94e7671`, `2b24ae8`, `74b9892`, `46d5c0f`)                                                                                                                                                                                                                                                                                                                                                                                        |
| **PR**       | #24, raised at `23-pr-and-review` Step 3 · target `testing`; merged 09/11/2026 with a merge commit, `7ad0cb8`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Reviewer** | Claude — phase 9 `code-reviewer` and `qa-tester` dispatches at `53a8713`, each finding then put to an adversarial verifier; the fix round's red, green and verify dispatches; at `23-pr-and-review`, a `code-reviewer` and a `qa-tester` pass over the branch, then a second pair over the fix diff a third over the F-021 round and the generation script, and on 09/11/2026 a fourth over the F-051 fix (Section 2.5); after the merge, an independent `qa-tester` sign-off of the manual walk at `7ad0cb8`, 09/11/2026 (Section 5). None wrote the work it reviewed                                                                       |
| **Date**     | 05/11/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **Verdict**  | Phase 9: no blocker; one major and seven minor or nit confirmed by the review, ten by QA; three rejected. Every confirmed finding fixed (16 in `5c24c12`, QA-US004-02 at `74b9892`), and QA-US004-05 too on 06/11/2026 (F-022). **The walk failed 12 rows**, 7 after Sam's rulings of 05/11/2026 and 06/11/2026 (Section 4). Workflow 23's two passes: 27 findings, every one fixed or, for DR-004, handled at the PR; the third pair: 15 more, all but three fixed; F-051 then fixed on Sam's ruling, 09/11/2026, and its round 4 pair: 16 items, 14 confirmed and fixed or documented, two refuted (Section 2.5). Final verdict: Section 5 |

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

| File                                                                      | Change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`                               | 1119 → 2023 lines at the walk, 2881 after workflow 23's fix rounds, 2943 after round 3, 3424 after F-051 and round 4 (shell is exempt from the 750-line limit; F-017). One population for scan and excluded set; the scoped exemption arms, then re-includes derived from `copier.yml`; the derived citer rule; the PM arm; class registration; literal template presence; the round 2, round 4, phase 9 and workflow 23 repairs; Markdown link targets; the surface-gated pass (F-051); self-test 15 → 130 → 174 → 182 → 208 probes              |
| `code/src/scripts/audits/fixtures/doc-references/` `broken/` and `clean/` | 10 → 63 tracked fixtures at the walk; 88 with the workflow 23 rounds' 25 new files; 90 with round 3's two `nn-letters.md`; 92 with F-051's `broken/gated-surface.md` and `broken/gated-twice.md`. Round 3 also adds `code/src/scripts/development/template-render.sh`, edits `sync-trees.sh`, `copier.yml`, the CI template job, the development and syntax `CLAUDE.md`/`CONTEXT.md`, `how-to/docs/CLI-TOOLING.md` and `CONTRIBUTING.md`                                                                                                          |
| `code/src/scripts/audits/CONTEXT.md`                                      | The `doc-references.sh` row replaced within itself at each round; the Dependencies row no longer lists `realpath`                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `code/src/scripts/audits/doc-references-shipping.txt`                     | New, generated by `--write-shipping`: the seeds and re-includes a generated project reads in place of `copier.yml` (F-027); F-051 adds 39 `gated FLAG path` rows and five `absent FLAG declined\|taken` rows                                                                                                                                                                                                                                                                                                                                      |
| Workflow 23 fix rounds — Markdown                                         | `code/docs/FORWARD-VOICE.md` Section 7; `project-management/docs/git/BRANCHES-AND-WORKTREES.md:28`; workflow 22's `CHECKLIST.md`; workflow 23's `STEPS.md` Step 6 and `CHECKLIST.md`; the audits `CONTEXT.md` tree (226 → 228 counted lines)                                                                                                                                                                                                                                                                                                      |
| `how-to/src/PROJECT-PATHS.md` · `code/docs/FORWARD-VOICE.md`              | Two patterned `18-TESTS` rows and the header note; Section 3's pattern form and duty                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| P5 sweep — shipped files                                                  | `project-management/src/02-STORIES/CONTEXT.md`, `project-management/src/03-SPRINTS/CONTEXT.md`, `how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md`, `project-management/docs/planning/SPRINTS.md`, `project-management/src/15-DECISIONS/CONTEXT.md`, `project-management/workflows/15-decisions/STEPS.md`, `project-management/src/00-ASSETS/scripts/pm-board.sh`, `THIRD-PARTY-NOTICES.md`, `research/CLAUDE.md`                                                                                                                                    |
| P5 sweep — PM records                                                     | Dead PM paths repaired in place, each with a dated `UPDATED` comment; `US014.md:813` respelt in full (QA-US004-02)                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Decision trail                                                            | `../15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md` accepted and the 30/09/2026 citer record superseded; the plan's _Key Decisions_; N-009's overturned claim on `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`; the self-test-downstream `GAPS.md` entry; at workflow 23, `../15-DECISIONS/ADR-US004-INSTANCE-CITER-ADMITS-STORYLESS-DATED-RECORDS-06-11-2026.md` (Accepted 06/11/2026, superseding the 05/11/2026 record); the `template-render.sh` ruling and the plan row recording Sam's instruction to fix every finding |

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
| R-014 | Low      | `doc-references.sh:1224-1236`, `~1505-1520`  | QA-US004-05: `--self-test` fails in a generated project; two of the four failing probes are new                     | **Deferred** by Sam (phase 9 round Q3), then **fixed** 06/11/2026 on his instruction to fix everything (F-022): contract-bound probes named as not run, exit 2 downstream                                       |
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

| ID    | Severity | Where                                                            | Issue                                                                                                                           | Resolution/Status                                                                                                                                                        |
| ----- | -------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| R-022 | High     | Manual guide _Recorded during the build_, five before-edit slots | The before-edit captures were never taken; ten rows fail on them, and the story's "before any edit" criterion cannot now be met | Deviation accepted by Sam 05/11/2026 (Q1, option 2) for BASELINE-02 to 05, rows stay Fail; BASELINE-01 amended and Pass on his ruling of 06/11/2026 (F-020)              |
| R-023 | Low      | Manual row MEASURE-01                                            | The arm-only copy adds one `-DD-MM-YYYY.md` date-placeholder finding, which the row forbids; the shipped detector clears it     | Resolved — amended 05/11/2026 on Sam's ruling (Q2), re-walked Pass (F-002)                                                                                               |
| R-024 | Low      | `doc-references.sh:828`, `:1308`, `:1322`                        | ShellCheck not clean: SC2221/SC2222 (pre-existing), SC2016 ×2 (pre-existing), SC2329 ×2 new in the P9-F8 `realpath` stubs       | **Fixed** — Sam ruled 05/11/2026 (Q3) it is fixed in this story; GATES-05 re-walked Pass, ShellCheck 0.11.0 exit 0, and again 06/11/2026 on the 2881-line script (F-003) |

### 2.5 Workflow 23 — two review passes and two fix rounds, 06/11/2026

**First pass**, over the branch at `3de67ff`: a `code-reviewer` pass (DR-001 to DR-005), a
`qa-tester` pass with a mutation harness and a generated project (QA-F01 to QA-F08), each finding
put to a verifier; plus two items the passes surfaced, GAPS-REL and WF-DISAGREE. **Sam's ruling:
every one is fixed in US004, the ones that proposed a `GAPS.md` note included.** The first fix
round worked red-first under `code/workflows/02-tdd-cycle` and took the self-test to 156 probes.

**Second pass**, over the fix diff: a `code-reviewer` pass (REV-01 to REV-04) and a hostile
`qa-tester` pass (H-01 to H-10). All 14 reproduced and were fixed in a second round, each repair
proven by reverting it alone (33 reverts, every one red); the self-test reached 174 probes.

| ID          | Severity     | Issue                                                                          | Resolution                                                                            |
| ----------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| QA-F01      | Medium       | Four phase 9 behaviours survived mutation                                      | Fixed — four fixtures, four mutants killed; F-023                                     |
| QA-F02      | Medium       | Story-less dated records were not instance citers                              | Fixed, scoped by H-04; ADR Accepted 06/11/2026; F-024                                 |
| QA-F03      | Low          | Most anchor forms were not peeled                                              | Fixed; F-025                                                                          |
| QA-F04      | Low          | A tracked symlink bypassed the seeded-citer exemption                          | Fixed; F-026                                                                          |
| QA-F05      | Low          | Exemption arms and seeded list hand-copied, absent downstream                  | Fixed with DR-001 — single source; F-027                                              |
| QA-F06      | Low          | A worked example rendered to a dangling path downstream                        | Fixed; F-028                                                                          |
| QA-F07      | Low          | A date placeholder hid a concrete instance (regression)                        | Fixed; F-029                                                                          |
| QA-F08      | Info         | Direction B's verdict depended on presence                                     | Fixed; F-030                                                                          |
| DR-001      | Medium → Low | The exemption arms could drift from `copier.yml`                               | Fixed with QA-F05; F-027                                                              |
| DR-002      | Medium → Low | The test record and this review still showed pre-ruling ShellCheck and tallies | Fixed in the records pass; F-031                                                      |
| DR-003      | Low → Info   | No remedy text for `[dangling path]`                                           | Fixed; F-032                                                                          |
| DR-004      | Info         | An out-of-scope commit, `3de67ff`, on the branch                               | Handled at the PR — named; merged with a merge commit, `7ad0cb8`, not squashed; F-033 |
| DR-005      | Info         | The fixture tree in a parenthesis                                              | Fixed; F-034, with GATES-01 amended (F-049)                                           |
| GAPS-REL    | —            | File-relative Markdown links unchecked                                         | Fixed — `[dangling link]` class; F-035                                                |
| WF-DISAGREE | —            | Workflow 23 Step 6 disagreed with 22 Step 1 on GDPR and Security               | Fixed; F-036, refined by H-09                                                         |
| REV-01      | Medium       | Linked targets bypassed Direction B                                            | Fixed with H-01; F-037                                                                |
| REV-02      | Low          | Nine new lines deletable with the self-test green                              | Fixed; F-038                                                                          |
| REV-03      | Low          | One citation reported twice, once per population                               | Fixed; F-039                                                                          |
| REV-04      | Info         | `--self-test` still failed downstream (F-012)                                  | Fixed on Sam's instruction; F-022                                                     |
| H-01        | Medium       | Links bypassed Check 3 and Check 2                                             | Fixed with REV-01; F-037                                                              |
| H-02        | Low          | The link extractor misread spans, fences, comments, escapes, parentheses       | Fixed; F-040                                                                          |
| H-03        | Low          | Path-form date-hidden instances silent                                         | Fixed; F-041                                                                          |
| H-04        | Low          | The date-citer arm was unscoped                                                | Fixed; F-042                                                                          |
| H-05        | Low          | Root-form Direction B depended on presence                                     | Fixed; F-043                                                                          |
| H-06        | Low          | Single-quoted `_exclude` entries dropped; template signal too weak             | Fixed; F-044                                                                          |
| H-07        | Low          | `grep` read a `--token` citation as an option                                  | Fixed; F-045                                                                          |
| H-08        | Info         | `:L12`, trailing comma and `?query` not peeled                                 | Fixed; F-046                                                                          |
| H-09        | Info         | The WF-DISAGREE fix restated 22 Step 1; 22's checklist contradicted it         | Fixed; F-047                                                                          |
| H-10        | Info         | Remedy text printed regardless of class                                        | Fixed; F-048                                                                          |

**Found while fixing:** the `NN` placeholder arm hid path tokens from the gate (F-021). Recorded
then as a dated `GAPS.md` entry; Sam ruled 06/11/2026 that it is fixed in US004 (round 3 below).

**State after both rounds**, re-measured 06/11/2026 in a `--no-hardlinks` clone holding the working
tree: `--self-test` 174, exit 0; ShellCheck exit 0; the whole tree exits 1 on the same 28
`[dangling path]` survivors, 0 of every other class, nothing on stderr. In a generated project the
self-test exits 2 with 153 probes run and passed, and the whole tree reports only docs for the
optional surfaces the project declined (98 `[dangling path]`, 21 `[dangling link]`).

**Round 3 — F-021 and the generation script, 06/11/2026.** On Sam's rulings of 06/11/2026 the
`NN` arm was narrowed red-first (F-021), exposing one false positive in Check 2's seeded
exemption, fixed in the detector (F-054); and `code/src/scripts/development/template-render.sh`
was written so a scratch project is never generated with a raw `copier copy` (F-050, F-055). A
third review pair — a `code-reviewer` pass (A-1 to A-3, B-1 to B-4) and a `qa-tester` pass (QA-A1
to QA-A3, QA-B1 to QA-B5) — raised 15 items, B-1 and QA-B1 one defect between them. The fix round
reproduced all 15: 12 fixed red-first, one trade-off pinned, two recorded. It ran without an Agent
tool, so its own checks are not independent QA (F-068). The self-test reached 182 probes,
`template-render.sh` gained a 7-probe `--self-test`, and every regex mutant now fails.

| ID          | Severity     | Issue                                                              | Resolution                                                  |
| ----------- | ------------ | ------------------------------------------------------------------ | ----------------------------------------------------------- |
| A-1         | Medium       | The F-021 fixtures pinned neither capital-letter guard alone       | Fixed; F-056                                                |
| A-2         | Medium       | The regex's anchors and two-`N` minimum unpinned                   | Fixed; F-057                                                |
| A-3         | Medium       | A default-answer project fails its own citation gate, 119 findings | Recorded; **disposition Sam's**; F-051                      |
| B-1 · QA-B1 | Low · Medium | A relative `--target` resolved against the repository root         | Fixed; F-058                                                |
| B-2         | Low          | Script defaults said to mirror CI's, but did not                   | Fixed: one answer set, CI renders through the script; F-059 |
| B-3         | Low          | The formatting-preview rule written outside `syntax/`              | Fixed; F-060                                                |
| B-4         | Info         | A template-only tree row escaped `sync-trees.sh` by its wording    | Fixed; F-061                                                |
| QA-B2       | Low          | A `--target` symlinked into the repository wrote into it           | Fixed; F-062                                                |
| QA-B3       | Low          | SIGTERM orphaned copier, which recreated the removed target        | Fixed; F-063                                                |
| QA-B4       | Low          | `git status` rewrote the live `.git/index`                         | Fixed; F-064                                                |
| QA-A1       | Low          | `[:upper:]` is locale-dependent for non-ASCII capitals             | Fixed: a literal capital list; F-065                        |
| QA-A2       | Info         | A path whose only placeholder is one `NN` segment is never tested  | Recorded, scoped out by the reviewer; F-052                 |
| QA-A3       | Info         | `USNNN` is no longer a placeholder                                 | Pinned as the accepted trade-off; F-066                     |
| QA-B5       | Info         | A misleading hint, a wrong shortcut row, renders left on disk      | Fixed; F-067                                                |

**Found on the way, recorded:** a default render also fails `sync-trees.sh` with 13 tree findings
(F-053), none caused by these rounds.

**State after round 3**, re-walked 06/11/2026 in fresh `--no-hardlinks` clones holding the working
tree, this records pass included (/tmp/us004-w3.jbal/): `--self-test` 182, exit 0, also under `LC_ALL=C`; ShellCheck exit 0 on all three changed scripts; the whole tree exits 1 on the same 28 `[dangling path]` survivors, 0 of every other class, nothing on stderr. Rendered through `template-render.sh`: the default-answer project's self-test exits 2 with 161 probes run and passed, and its whole tree reports 119 findings (F-051); the all-surfaces project is clean. Manual guide unchanged at **28 Pass, 7 Fail**.

**Round 4 — F-051 and its independent review, 09/11/2026.** Sam ruled F-051 fixed in US004. The
gate now parses each templated `_exclude` entry into the shipping facts and, in a generated
project, reads `.copier-answers.yml`: a citation into a declined surface's absent file is passed
and counted per flag, and a missing or unreadable answers file exempts nothing. One deviation
from the brief: `INCLUDE_CLICKUP` defaults to true, so its missing key counts as taken. This
answers F-068 for the F-051 change: a `code-reviewer` pass (C-01 to C-11) and a `qa-tester` pass
(Q-01 to Q-05), by contexts that wrote none of it, each item put to a separate verifier; a fourth
context fixed the code findings red-first with a revert proof each, and this records pass closed
the drift. 14 confirmed, two refuted (Section 6).

| ID                 | Severity     | Issue                                                                                             | Resolution                                             |
| ------------------ | ------------ | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| C-01 · Q-01        | Medium       | `Clean — every citation resolves.` printed over 121 unjudged citations                            | Fixed: a qualified verdict, terminal and report; F-069 |
| C-04               | Low          | One target cited as link and token on a line counted twice (136 for 121)                          | Fixed: de-duplicated per scan; F-070                   |
| Q-02               | Low          | An indented or duplicated answer key failed open                                                  | Fixed: fails closed; F-071                             |
| C-05 · Q-04        | Low          | A probe counted double-quoted contract entries only                                               | Fixed: counted from the gate's own parse; F-072        |
| Q-05               | Low          | Three mutants survived the self-test                                                              | Fixed: each now fails it; F-073                        |
| C-02               | Low          | A misspelt path under a declined gate passes downstream                                           | Inherent; documented in three places; F-074            |
| C-06 · C-07 · Q-03 | Medium       | `FORWARD-VOICE.md` Section 5 and the audits row still described the old gate, three of five flags | Fixed in this records pass; F-075                      |
| C-08 · C-09 · C-11 | Medium · Low | F-051 still open in the records and `GAPS.md`; 182 probes quoted                                  | Fixed in this records pass; F-075                      |
| C-03 · C-10        | —            | The declined pass above the template presence check; the layered header row                       | Refuted (Section 6)                                    |

**State after round 4**, 09/11/2026: `--self-test` 208, exit 0 (re-run by this records pass);
ShellCheck exit 0; the whole tree exits 1 on the same 28 `[dangling path]` survivors. Rendered
through `template-render.sh`: the default-answer project exits 0, `passed 121 citation(s) into
declined-surface paths, unjudged (INCLUDE_DESKTOP=18 INCLUDE_MOBILE=60 INCLUDE_RUST=23
INCLUDE_WAGTAIL=20)`, then the qualified verdict; with its answers file removed it exits 1 on
exactly the original 119; the all-surfaces project exits 0, `passed 0`; the generated project's
self-test exits 2, 186 run and passed, 13 sets needing the contract. Evidence
/home/sam-desktop/.claude/tmp/us004-f051/ and its `round2/`. Manual guide unchanged.

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
- [x] `--self-test` 208/208, exit 0 (130 at the walk, 174 after round 2, 182 after round 3); every new probe red against the detector it
      was written for, and each workflow 23 round 2 repair red when reverted alone (33 reverts).
- [ ] Every manual QA acceptance criterion walked and passing — **28 Pass, 7 Fail** after Sam's
      rulings of 05/11/2026 and 06/11/2026 and the re-walks of 06/11/2026, the second against round 3 (Section 2.4); all seven
      Fails stand on the accepted capture deviation (F-001).

### 3.4 Quality, DRY & file length

- [x] No second naming guard written (AC-GAP-1); QA-US004-06 changed the one guard there is.
- [x] `code/src/scripts/audits/CONTEXT.md` grown by no line at the walk, 226 counted lines; 228 after
      the two tree rows Sam's workflow 23 rulings added, GATES-01 amended for them (F-049).
- [x] `docs-pairing.sh` and `doctrine-drift.sh` exit 0 (GATES-02, GATES-03).
- [x] Markdown lint clean on the Markdown the story changes (GATES-04). At the walk the whole-tree
      exit 1 was the gitignored `graphify-out/GRAPH_REPORT.md`, the filed
      `../21-BUGS/BUG-LINT-READS-GITIGNORED-GRAPHIFY-OUT-02-11-2026.md`; re-walked 06/11/2026 in a clean
      clone, which has no `graphify-out/`: 1117 files, 0 issues, exit 0.
- [x] ShellCheck clean — 0.11.0, exit 0 (R-024 fixed; re-run 06/11/2026 on the 2943-line script, and on `template-render.sh` and `sync-trees.sh`; 09/11/2026 on the 3424-line script).
- Observation: the script nearly doubled, roughly half of it self-test. Shell is exempt from the
  750-line limit but should stay focused (`code/src/scripts/CLAUDE.md`); F-017.

### 3.5 Performance

- The whole-tree run took 330.27 s at the walk (AFTER-01), against BASELINE-01's 438 s on the
  stock detector at the branch point and the reviewer's 7:59 against 5:52, run concurrently. The
  wider population did not slow the run (plan _Risks_).

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI. The `file:line [class] token` output shape is unchanged.

---

## 4. Required actions before merge

1. **R-022 / F-001** — ruled 05/11/2026: the missed captures for BASELINE-02 to 05 are an accepted,
   documented deviation. **BASELINE-01 — ruled 06/11/2026:** its original capture
   (`/home/sam-desktop/.claude/tmp/tmp.X6zOVdkES2/base.txt`, 12:06:43 UTC, before the first branch commit) stands; Sam's
   attestation of `HEAD` `151a4e3`, the index state taken as clean, satisfies the row, amended
   (F-020). BASELINE-01, AFTER-01 and CLASSIFY-01 Pass; the walk is 28 Pass, 7 Fail.
2. **R-023 / F-002** — done 05/11/2026: MEASURE-01 amended with its trail and re-walked Pass.
3. **R-024 / F-003** — ruled 05/11/2026: fixed in the build; GATES-05 re-walked Pass, ShellCheck exit 0.
4. **F-019** — done: `../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`
   accepted 05/11/2026 at `d13b168`.
5. Sam's countersignature of the walk. The guide's cross-check against the automated record is
   ticked (05/11/2026, re-checked 06/11/2026).
6. **F-024** — done 06/11/2026: Sam accepted
   `../15-DECISIONS/ADR-US004-INSTANCE-CITER-ADMITS-STORYLESS-DATED-RECORDS-06-11-2026.md`; the
   05/11/2026 derived-rule record is Superseded.
7. **F-033 / DR-004** — done: `3de67ff` named in the PR body. Corrected 09/11/2026: PR #24 was merged
   with a merge commit, `7ad0cb8`, not squashed, so `3de67ff` (a US002 handoff prune, out of scope,
   no secret-like literal) is in `testing`'s history. Harmless.
8. **F-051** — done 09/11/2026 on Sam's ruling: fixed in US004; the default-answer project's
   gate exits 0 (F-069 to F-075).
9. **F-068** — answered 09/11/2026 for the F-051 change by round 4's independent pair; round 3's
   own diff rests on its re-walk and Sam's countersignature.
10. **F-059** — the CI generation job, now rendering through `template-render.sh`, has not yet run
    in CI; confirm it on the PR.

---

## 5. Verdict & status transition

- **Verdict:** the phase 9 review and its fix round leave no open code finding but one deferred
  gap; the walk does not pass. **Changes-requested at drafting.** Sam's rulings of 05/11/2026 settle
  three of the four decisions and part of the fourth (Section 4); the final verdict is
  `23-pr-and-review`'s, per this folder's rule, now that BASELINE-01 and GATES-05 are settled.
- **Reasoning:** every owned class is at zero over the whole tree, and the 130-probe self-test
  separates every fixture pair. But a story whose subject is a before-and-after measurement
  never took the before, and the gate it repairs still exits 1 on 28 named survivors, so the
  baseline-diff regime does not retire with it (F-004).
- **Final verdict, 09/11/2026 — merged; QA sign-off with notes.** PR #24 merged into `testing` as
  the merge commit `7ad0cb8` on 09/11/2026, with the known `Citations resolve` red (Section 6: the
  28 survivors owned by US005, US006, US010 and US014). An independent `qa-tester`, which wrote none
  of the work, then signed the manual walk off **with notes** at `7ad0cb8` in disposable clones: all
  35 rows reproduce their recorded results, 28 Pass and 7 Fail, the seven F-001's accepted
  deviations; each missing before-value re-measured at `173abff` (self-test 15 probes;
  `research/CONTEXT.md` read 0, exempt 1; `docs-length.sh` 226 for the audits `CONTEXT.md`; US998
  A/B untracked 12 `[template-only citation]` exit 1, intent-to-add 0 exit 0); BASELINE-01's
  original capture matches its record; no acceptance criterion unproven beyond the accepted
  "recorded before edit" wording. Generated projects through `template-render.sh`: default answers
  exit 0 (121 declined-surface citations passed unjudged, counted per flag); all surfaces exit 0;
  answers file removed, the default render fails closed on 119 and all surfaces exit 0. Notes:
  QA-SO-01 (Low, F-076) and QA-SO-03 (Info, F-077), each a dated `GAPS.md` entry; QA-SO-02 is
  F-014, re-confirmed. Each note was confirmed by a separate verifier agent. Evidence:
  /home/sam-desktop/.claude/tmp/us004-qa-signoff/.
- **Status transition:** none recorded here. `In Progress` → `In Review` and onward are the
  `completion` skill's, at `23-pr-and-review`.

---

## 6. Notes

### Rejected, not recorded as defects

- **F7 and QA-US004-04** — the seed bodies are unchecked, but that predates US004 and is not this
  change's defect. It is a real coverage gap nonetheless, recorded as F-013 with a `GAPS.md` entry.
- **QA-US004-10** — refuted on the ADR's definition of "bounded"; the same defect was confirmed
  as F4 and fixed, so the probe set covers it either way.
- **C-03** (round 4) — the declined-surface pass sits above the shipped-template presence check,
  but a template under a declined gate is not shipped in that project, the ADR's list of what may
  not quieten presence does not include surface gating, and a taken surface still reaches it.
- **C-10** (round 4) — the header's TEMPLATED row carries a dated note on the old row, the file's
  convention, and its "covered" closing text never prints on a run that skipped a contract probe.

### Gate evidence

| Gate                                                       | At the walk (`46d5c0f`)                                              | Reading                                                                                                                                                                                                       |
| ---------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`                | exit 1; 28 `[dangling path]`; 0 instance, template-only, plan-prefix | Survivors owned by US005, US006, US010 and US014. Not a pass, and no before-edit run to diff against (F-001); unchanged at 28 on 09/11/2026. A default-answer render exits 0 since F-051, 121 passed unjudged |
| `doc-references.sh --self-test`                            | exit 0, 130 probes                                                   | 174 probes after workflow 23's rounds 1 and 2, 182 after round 3 (06/11/2026), 208 after round 4 (09/11/2026), exit 0; exit 2 in a generated project, 186 run and pass                                        |
| `docs-length.sh` · `doctrine-drift.sh` · `docs-pairing.sh` | exit 0 · exit 0 · exit 0                                             | GATES-01 fails only on F-001                                                                                                                                                                                  |
| ShellCheck 0.11.0, by hand                                 | exit 1                                                               | exit 0 since the F-003 fix; again 06/11/2026 (R-024 fixed)                                                                                                                                                    |

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
