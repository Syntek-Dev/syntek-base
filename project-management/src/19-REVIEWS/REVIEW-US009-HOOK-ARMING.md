# Code Review — US009 The git hooks arm on purpose at install, and the README claim that they already do becomes true

**Last Updated**: 17/11/2026 · **Story**: US009 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US009 — `install.sh` Phase 1 Step 9 arms the hooks through `install-hooks.sh`, `prepare` is removed, and `.copier/README.md`'s claim becomes true                                                                       |
| **Branch**   | `us009/hook-arming` (base `testing` at `a0ca304`)                                                                                                                                                                       |
| **PR**       | #37 · target `testing` — raised at workflow 23 Step 3 after this record                                                                                                                                                 |
| **Reviewer** | Independent Claude agents at workflow 23 — `qa-tester` (Step 1) and `review` / `code-reviewer` (Step 2), none of which authored the story — with an adversarial verifier per pass and per fix round; recorded by Claude |
| **Date**     | 17/11/2026                                                                                                                                                                                                              |
| **Verdict**  | Approve-with-nits                                                                                                                                                                                                       |

**Codes from:** `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the implementation
master this review closes the loop on.
**Story:** `../02-STORIES/US009.md` — the acceptance criteria the code must satisfy.

---

## 1. Scope & files reviewed

The branch against `a0ca304`, excluding `c8424f9` (a research note) and `2950392` (a `context7`
change), which are the developer's own and not US009. The story had already passed six TDD rounds
of review, security and QA (findings record F-001 to F-032). Workflow 23 ran one QA pass, one
code review, and three fix rounds, each fix round checked by an agent that did not make it.

| File                                                                       | Change                                                                                                                                                              |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/development/install-hooks.sh`                            | US009 — arming mode and `--notice`. Workflow 23: executes the checked binary directly (R-001), restores a moved symlink on failure (R-004), scoped remedies (R-005) |
| `install.sh`                                                               | US009 — Phase 1 Step 9; Phase 2 renumbered; best-effort `generate_machine_spec` (F-002)                                                                             |
| `package.json` · `pnpm-workspace.yaml`                                     | US009 — `prepare` removed, `--notice` `postinstall`; the `allowBuilds` comment. Workflow 23: the comment no longer cites an excluded ADR (R-002)                    |
| `code/src/scripts/tests/hook-arming.sh`                                    | US009 — the probe runner. Workflow 23: probes for every fix below; HP-06 template-only (R-003)                                                                      |
| `.github/workflows/audit-hook-arming.yml` · `audit-template.yml`           | US009 — probes job, path-filtered `install-failure` job, HP-07 grep. Workflow 23: labels and a misplaced comment (R-006, R-007)                                     |
| `.copier/README.md`, setup docs, `code/src/scripts/development/CONTEXT.md` | US009 — the documentation surface named in the plan's P5                                                                                                            |
| `project-management/src/**` US009 records, two US008 and one US010 header  | Records — workflow 22's set; workflow 23's dated corrections for F-018 to F-025 (R-008)                                                                             |
| `GAPS.md`                                                                  | Workflow 23 — the `doc-references.sh` YAML blind spot behind R-002                                                                                                  |

---

## 2. Findings

Step 1 raised `QA-01`/`QA-02`, Step 2 `CR-01` to `CR-05`; each was put to an adversarial verifier
and none was refuted (`CR-03` was downgraded Low to Info). Later IDs came from the fix-round
verifiers. Most severe first.

| ID    | Severity | File:line                                                        | Issue                                                                                                                                                                                                             | Resolution/Status                                                                                                                                                          |
| ----- | -------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001 | Medium   | `code/src/scripts/development/install-hooks.sh` (lefthook calls) | `QA-01`. With a stale `node_modules`, `pnpm exec lefthook` ran pnpm 12's verify-deps install — every package, lifecycle scripts included — breaking the write boundary and "the binary checked is the binary run" | Fixed at workflow 23 — the checked `node_modules/.bin/lefthook` is executed directly; measured byte-identical hook and checksum; stale-tree fixture proves no install runs |
| R-002 | Medium   | `pnpm-workspace.yaml` (`allowBuilds` comment)                    | `CR-01`. A shipped file cited an ADR that Copier excludes — a dead citation downstream, invisible to `doc-references.sh`, which reads no YAML                                                                     | Fixed at workflow 23 — the rule stated in place; the gate's blind spot is the `GAPS.md` row of 17/11/2026                                                                  |
| R-003 | Medium   | `code/src/scripts/tests/hook-arming.sh` (HP-06)                  | `CR-02`. Without `.copier/README.md` the probe fell back to a generated project's own `README.md` and pinned its prose, so CI went red when the team edited it                                                    | Fixed at workflow 23 — HP-06 runs only in the template and reports `n/a` elsewhere (`code/docs/GATE-REPORTING.md`)                                                         |
| R-004 | Low      | `install-hooks.sh` (`restore_link`)                              | `QA-02`. A symlinked `pre-commit` moved aside before `lefthook install` was left moved, unreported, if lefthook then failed                                                                                       | Fixed at workflow 23 — restored on failure, or the exact `printf %q` `mv` printed; probes on both failure legs                                                             |
| R-005 | Low      | `install-hooks.sh` (`unset_in_scope`, `remedy()`)                | `CR-04` and its residuals over two rounds. The printed fix for `core.hooksPath` ignored its scope, then its `command` scope, then include files, and used `--unset` where two values exist                        | Fixed at workflow 23 — scope-correct `--unset-all` commands; environment, `GIT_CONFIG` and included values named in words; probes per source                               |
| R-006 | Info     | `audit-hook-arming.yml:1`, `:9-11`, `:130`; `install-hooks.sh`   | `CR-03`. Story numbers, round labels and an excluded file named in shipped files                                                                                                                                  | Fixed at workflow 23 — rules stated in place                                                                                                                               |
| R-007 | Info     | `audit-hook-arming.yml` (`changes` job)                          | `CR-05`. The `install-failure` comment sat above the wrong job                                                                                                                                                    | Fixed at workflow 23                                                                                                                                                       |
| R-008 | Low      | US009 PM records (F-018 to F-025 corrections)                    | The first pass of the corrections rendered six notes as code blocks (MD046), named the wrong commit for F-023 (`bb0ace5`, not `e5b3426`), and overwrote the original dispositions                                 | Fixed at workflow 23 — re-verified by an independent checker; lint clean                                                                                                   |
| R-009 | Low      | `install-hooks.sh` (`/dev/null` detection)                       | A `GIT_CONFIG` file holding `core.hooksPath=/dev/null` is reported as an opt-out, though only `git config` reads `GIT_CONFIG` and `git commit` still runs the hook                                                | Documented limit — fails safe (arms nothing, exit 0); the printed remedy leads to arming                                                                                   |
| R-010 | Low      | `install-hooks.sh` (remedy text)                                 | A value in both a scope's own file and a file it includes takes two runs; a command-line `include.path` is worded as a `GIT_CONFIG` file; `--system` does not say it needs root                                   | Documented limit — each converges on the next run, and the wording is never a no-op command                                                                                |
| R-011 | Low      | `hook-arming.sh` (HP-06, probe coverage)                         | HP-06's `n/a` cannot fail in the template if `.copier/README.md` were deleted; no probes for the system- and worktree-scope remedies (both measured correct by hand)                                              | Documented limit                                                                                                                                                           |
| R-012 | Info     | `audit-hook-arming.yml:118`, `:126`                              | Step names keep probe IDs `R4-QA-01/03` and `R4-SEC-03`; they resolve, because `hook-arming.sh` ships and defines them                                                                                            | No action                                                                                                                                                                  |
| R-013 | Info     | `install-hooks.sh` (interrupts)                                  | Neither the `.old` move nor `restore_link` covers Ctrl-C mid-step; a timestamped `pre-commit.old` is reported at once, not moved back                                                                             | No action                                                                                                                                                                  |

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- [x] **A01 — permission check before logic.** N/A — no endpoint; shell, CI and docs only.
- [x] **IDOR.** N/A — no user-supplied ID is read.
- [x] **Secrets & DEBUG.** No secret in the diff; the CI workflow is `contents: read`, untrusted
      input reaches `run:` only through `env:`. The `review` skill's security pass was not
      triggered — no auth, permission, PII or state-changing endpoint is in scope. R-001 was the
      one write-boundary defect and is fixed.

### 3.2 GDPR / PII

- [x] N/A — no personal data processed.

### 3.3 Test coverage vs floors

- [x] Backend coverage — N/A, no Python changed in the story's surface.
- [x] Template and HTMX-partial tests — N/A.
- [x] Full suite green — `bash code/src/scripts/tests/hook-arming.sh` on the final working tree:
      **429 passed · 0 failed · 1 unmeasured** (was 371 · 0 · 1 before workflow 23). ES-01 (`install-failure`) is **unmeasured** until CI runs; exit 3 is not a pass. CI run `44174073751` on `160c730`:
      probes 429 / 0 / 0 and `install-failure` 7 / 0 / 0 — nothing unmeasured.
- [x] Every acceptance criterion tested — traced criterion by criterion in Step 2; every workflow
      23 fix has a probe that was red before it and, mutated back in a scratch copy, red again.

### 3.4 Quality, DRY & file length

- [x] No duplication — the remedy wording has one copy, shared by `--notice`, arming and `remedy()`.
- [x] No new `TODO`/`FIXME`/`HACK` in shipped code.
- [x] Source files within 750 lines — `install-hooks.sh` is under the limit; `hook-arming.sh` is a
      test harness, measured by `code/src/scripts/audits/cloc.sh`.
- [x] Lint clean — `shellcheck -x` clean on both scripts; markdown lint clean on every touched
      record; `docs-length.sh`, `docs-pairing.sh`, `mcp-parity.sh`, `template-orphans.sh` pass.

### 3.5 Performance

- [x] N/A — no query or hot path.

### 3.6 Accessibility (WCAG 2.2 AA)

- [x] N/A — no user-facing UI.

---

## 4. Required actions before merge

| Action                                                                                        | Finding      | Owner  | Status                                            |
| --------------------------------------------------------------------------------------------- | ------------ | ------ | ------------------------------------------------- |
| Read both `audit-hook-arming.yml` jobs on the PR — ES-01, the change filter's BASE expression | F-005, F-014 | Claude | Done 17/11/2026 — CI run `44174073751`, all green |
| Fill FAIL-01 to FAIL-03 in the manual guide and Sections 2–4 of the automated record from CI  | F-005        | Claude | Done 17/11/2026 — CI run `44174073751`, all green |
| Developer sign-off on the three security implementation records                               | —            | Sam    | Done 17/11/2026                                   |

Every review finding (R-001 to R-008) is fixed; R-009 to R-013 are documented limits.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** no Critical or High; the three Mediums and both Lows from Steps 1–2 are fixed with
  probes proven to fail without the fix; what remains is Low or Info and fails safe.
- **Status transition:** `In Progress → In Review` at the PR (workflow 23 Step 3); `In Review →
Accepted` is Sam's, after CI and his approval.

---

## 6. Notes

- **Findings F-018 to F-025 were corrected in this PR, by the developer's ruling of 17/11/2026**,
  rather than at each owning gate's next pass: a dated note in each owning artefact, the original
  text kept. `MAP-BUN-TOPOLOGY.md` N-024 / S-01 was found **not** to record `8dceffb`; it is a
  feature map outside US009's records and is noted in F-024, not edited.
- **R-001 changes a stated behaviour:** `install-hooks.sh` no longer needs `pnpm` on `PATH` (a
  missing `node` still exits 1). Every US009 artefact that said `pnpm exec lefthook` carries a
  dated correction.
- **The fix rounds converged:** round 1 fixed all seven; round 2's verifier found the
  `command`-scope remedy; round 3's found include files; the final verifier rated nothing above
  Low.

---

## Cross-references

- `../02-STORIES/US009.md` — the story under review
- `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the plan this code was written from
- `../18-TESTS/AUTOMATED/US009-TEST-STATUS.md` · `../18-TESTS/MANUAL/US009-MANUAL-TESTING.md` — the
  test records this review reads against
- `../11-QA/IMPLEMENTATION/QA-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the paired QA review
- `../20-FINDINGS/archive/FINDING-US009-HOOK-ARMING-17-11-2026.md` — F-001 to F-032
- `../21-BUGS/BUG-US009-MACHINE-SPEC-PROBE-ABORT-17-11-2026.md` — F-002
- `../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` — the decision the code implements
- `project-management/workflows/23-pr-and-review/` — the PM workflow where this review is written
- `code/workflows/07-review/` — the code-review workflow the reviewers ran
