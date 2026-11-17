# Threat Model Review — US009 The git hooks arm on purpose at install

| Field           | Value                                                                                                                                                          |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true                                                        |
| **Date**        | 17/11/2026                                                                                                                                                     |
| **Verified by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                          |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` (signed off 28/09/2026; clarification 09/10/2026)                                                         |
| **Outcome**     | **PASS with deferred items** — no CRITICAL or HIGH, planned or new; TM-02 and TM-12 stay accepted residuals; CI for the new workflow is unmeasured (Section 5) |

---

## 1. Scope

Re-assessed at HEAD `fd11604` (the last US009 commit; `97821a8` above it changes only
`.github/scripts/shipped-ai.py` and is not this story's). The surface that shipped is **larger than
the plan's**: the plan named one `install.sh` step; the build extracted that step into its own
script, which now also owns the location rule, the ownership classification and the `--notice`
mode. Every review-round finding cited here is the workflow journals' text (round 2 `SEC-*`,
round 4 `R4-SEC-*`, round 5 `R5-*`), summarised in
`../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US009-HOOK-ARMING-17-11-2026.md`.

| File                                               | Purpose                                                                                     |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `code/src/scripts/development/install-hooks.sh`    | **New.** The arming step and `--notice`; the guard, the location rule, binary provenance    |
| `install.sh`                                       | Phase 1 Step 9 calls it (`:536-542`); usage 1-9 / 10-11 (`:51-63`); `generate_machine_spec` |
| `package.json`                                     | `prepare` removed; `postinstall` is the notice (`:11`); `lefthook` `^2.2.2` (`:22`)         |
| `pnpm-workspace.yaml`                              | `allowBuilds` `lefthook: false` with its reason (`:25-28`)                                  |
| `code/src/scripts/development/install-frontend.sh` | Read only: the three `--ignore-scripts` lines (`:71`, `:104`, `:113`)                       |
| `code/src/scripts/tests/hook-arming.sh`            | **New.** Probe runner; node_modules tripwire (`:240`); change filter (`:190-201`)           |
| `.github/workflows/audit-hook-arming.yml`          | **New.** `probes`, `changes`, `install-failure` jobs                                        |
| `.github/workflows/audit-template.yml`             | HP-07 grep of each generated `install.sh` (`:164-174`)                                      |

## 2. Trust boundaries — confirmed

| ID  | Boundary                                    | Change since plan                                                                                                                                                                                          |
| --- | ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TB1 | Operator shell → `install.sh`               | **Widened.** Git configuration from every scope and the `GIT_*` environment now cross it; the script clears the location variables (`install-hooks.sh:142`) and judges the result by location (`:280-295`) |
| TB2 | `install.sh` → the `lefthook` binary        | Unchanged in shape; enforced: project binary or exit 1 (`:445-453`)                                                                                                                                        |
| TB3 | pnpm lifecycle → hooks directory            | **Closed for arming.** `prepare` gone; `postinstall` reads only; lefthook's own build script blocked by `allowBuilds`                                                                                      |
| TB4 | `install.sh` → effective `pre-commit`       | **Re-pointed** from literal `.git/hooks/pre-commit` to the effective hooks directory, which must lie inside the git common directory (09/10/2026 clarification, narrowed 17/11/2026 rounds 4-5)            |
| TB5 | Template → generated project                | Unchanged; HP-07 grep passed in CI at `fd11604` (run `44134013544`, step "Generate a project both ways")                                                                                                   |
| TB6 | npm dependency graph → host / CI runner     | Unchanged and still open (TM-02). The new workflow adds one more unsuppressed install (`audit-hook-arming.yml:77`)                                                                                         |
| TB7 | **New.** CI fixture tooling → probes runner | `uvx --from code-review-graph==2.3.9` and an unlocked lefthook 1.13.0 fixture fetch, on a runner with `contents: read` and no persisted token (SEC-05)                                                     |

## 3. STRIDE threat re-assessment

| ID    | STRIDE | OWASP    | NIST CSF | TB  | Threat description                                           | Severity | Status                              | Mitigation (as shipped)                                                                                                                                                                                                                                                                                                                                                                                       |
| ----- | ------ | -------- | -------- | --- | ------------------------------------------------------------ | -------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | T      | A03:2025 | PR.PS    | TB3 | The silent-arming channel stays open                         | MEDIUM   | Mitigated                           | `prepare` removed; `postinstall` is `install-hooks.sh --notice \|\| true` (`package.json:11`), which never runs lefthook (`install-hooks.sh:349-391`); lefthook's own postinstall blocked (`pnpm-workspace.yaml:25-28`). Probes: manifest ST02/ST02b, `notice`, `notice-streams`. Residual under npm/yarn (Section 4)                                                                                         |
| TM-02 | E      | A03:2025 | PR.PS    | TB6 | `--ignore-scripts` is three lines, read as a posture         | MEDIUM   | Residual                            | First limb closed: exactly three lines, found by content (manifest ST01; `install-frontend.sh:71`, `:104`, `:113`). Second limb **still owed**: no `GAPS.md` row for the unsuppressed invocations (Section 5)                                                                                                                                                                                                 |
| TM-03 | D      | A10:2025 | PR.PS    | TB1 | The `.git` guard is false in a worktree                      | MEDIUM   | Mitigated                           | Git's own answer, never a directory test (`detect_repo`, `install-hooks.sh:187-221`); a `git worktree add` checkout arms (fixture A, EC-01). Broken, bare and core.worktree-elsewhere exit 2 rather than skip (SEC-03, `:404-413`; fixture `repo-shapes`)                                                                                                                                                     |
| TM-04 | S      | A03:2025 | PR.PS    | TB2 | `lefthook` resolved from `PATH`, unknown version             | MEDIUM   | Mitigated (arm) · Residual (commit) | Arming: `node_modules/.bin/lefthook` must exist, be executable and run before anything else (`:445-453`); a fake on PATH with none in node_modules exits 1 (fixture A, S-M2); strace shows the locked 2.2.2 did the install with 1.13.0 first on PATH (EC-02). Commit time: lefthook's generated `call_lefthook()` tries `$LEFTHOOK_BIN`, then `lefthook` on PATH, first — lefthook's template, outside scope |
| TM-05 | D      | A10:2025 | RC.RP    | TB1 | A hard fail abandons later steps                             | MEDIUM   | Mitigated                           | Last step of Phase 1 (`install.sh:536-542`), `\|\| exit $?` keeps 1/2. ES-01 to ES-03 (Steps 5-8 complete, then exit 2) are **CI-only and not yet run** — unmeasured                                                                                                                                                                                                                                          |
| TM-06 | E      | A01:2025 | PR.PS    | TB1 | Step downstream of a live `sudo rm -rf` with stray arguments | MEDIUM   | **Moot**                            | The defect was fixed upstream in `8dceffb` (14/10/2026), before this story started; the call is now an array (`install-frontend.sh:82-100`). ST08's line-per-assertion form still holds: each line found by content (manifest ST01)                                                                                                                                                                           |
| TM-07 | T      | A08:2025 | PR.DS    | TB4 | `pre-commit` overwritten unconditionally, in silence         | LOW      | Mitigated                           | Eight states classified before any write and each reported (`:462-473`, `:516-533`); a tailed, foreign or LEFTHOOK-mentioning hook copied aside; a symlink moved as a link; an existing `pre-commit.old` moved to a timestamped name (`:477-496`). Fixtures `old-backup`, `graph-reclaim`                                                                                                                     |
| TM-08 | T      | A03:2025 | PR.PS    | TB2 | The "pinned" devDependency is a caret range                  | LOW      | Residual                            | Still `^2.2.2` (`package.json:22`), locked 2.2.2 (`pnpm-lock.yaml:214-216`). Raised in consequence: the armed predicate is tied to 2.2.2's generated layout (`:152-168`), so a bump fails closed, exit 2 (Section 4, N-01)                                                                                                                                                                                    |
| TM-09 | D      | A10:2025 | DE.CM    | TB5 | The proof cannot run where the story put it                  | MEDIUM   | Mitigated · CI unmeasured           | Generation job greps (`audit-template.yml:164-174`, **passed in CI** at `fd11604`); behaviour in `audit-hook-arming.yml`, which **has not run** (it triggers on pull requests into `testing`)                                                                                                                                                                                                                 |
| TM-10 | T      | A02:2025 | PR.PS    | TB1 | Phase 2 numbering collides with Phase 1                      | LOW      | Mitigated                           | Usage Phase 1 1-9, Phase 2 10-11 (`install.sh:51-63`); headers `:536`, `:560`, `:612`. Manifest P2                                                                                                                                                                                                                                                                                                            |
| TM-11 | S      | A03:2025 | PR.PS    | TB5 | A generated project's unborn HEAD                            | LOW      | Mitigated                           | Fixture B arms on `git init` with no commits (EC-04)                                                                                                                                                                                                                                                                                                                                                          |
| TM-12 | R      | A09:2025 | DE.AE    | TB4 | Nothing records whether hooks were armed for a commit        | INFO     | Residual                            | Accepted as planned. Partly narrowed: `--notice` now reports an unarmed or tail-disabled hook on every install. Still no per-commit record                                                                                                                                                                                                                                                                    |

## 4. New threats identified during implementation

Raised by the six review rounds or by this re-assessment; every one at most MEDIUM. Those fixed in
the build are closed in the audit record; those below are what remains.

- **N-01 (LOW, T, A08, TB2)** — the armed predicate recognises lefthook **2.2.2's** generated
  layout exactly (`install-hooks.sh:152-168`). A lefthook bump that changes the template makes every
  hook read unarmed: arming then exits 2, `--notice` reminds. Fails closed. Re-measure on any bump.
- **N-02 (MEDIUM, S, A03, TB2)** — commit-time binary selection is lefthook's template, which
  prefers `$LEFTHOOK_BIN` and a `lefthook` on `PATH` over the project's own. The step proves only
  which binary **armed** the hook. TM-04's promotion trigger therefore still applies at commit time.
- **N-03 (LOW, T, A03, TB3)** — npm and yarn are unsupported. `allowBuilds: lefthook: false` is a
  pnpm control; under another package manager lefthook's own postinstall would arm. Recorded as a
  residual of TM-01, not a regression.
- **N-04 (INFO, T, A03, TB7)** — `code-review-graph`'s dependency closure resolves unlocked in the
  CI `graph-reclaim` fixture, and the 1.13.0 fixture fetch is unlocked (SEC-05, downgraded to INFO
  at verification). Token not persisted, `contents: read`, no `pull_request_target`.
- **N-05 (INFO, R, A09, TB3)** — `--notice` discards its own stderr and always exits 0 by design
  (`:84-90`), so a fault in the notice is invisible. Separately, `check-lockfiles.sh:147` captures
  `2>&1` into a variable, so the PA-01 notice never reaches the operator on that channel.
- **N-06 (INFO, D, A10, TB4)** — timestamped `pre-commit.old.<stamp>` copies accumulate in the
  hooks directory; nothing prunes them.
- **N-07 (LOW, E, A03, TB6)** — the new workflow's own `pnpm install --frozen-lockfile`
  (`audit-hook-arming.yml:77`) runs lifecycle scripts. `CI` is set, so the notice exits at once and
  lefthook's build is blocked; it arms nothing, but it is one more TM-02 invocation.

**No new CRITICAL or HIGH.** Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Residual & deferred items

| Item                                                                                | Threat IDs   | Severity | Tracked in / when                                                                                                            |
| ----------------------------------------------------------------------------------- | ------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Unsuppressed `pnpm install` invocations — the register row                          | TM-02, N-07  | MEDIUM   | **Owed, not written**: `GAPS.md` has no row (measured 17/11/2026). A findings item on this pass; dated the day it is written |
| No per-commit arming record                                                         | TM-12        | INFO     | Accepted residual, as planned                                                                                                |
| Commit-time PATH preference in lefthook's template                                  | TM-04, N-02  | MEDIUM   | Outside scope (lefthook's template); findings record                                                                         |
| Template-pinned armed predicate; caret range                                        | TM-08, N-01  | LOW      | Re-measure on every lefthook bump; findings record                                                                           |
| npm / yarn unsupported                                                              | TM-01, N-03  | LOW      | Findings record                                                                                                              |
| CI execution of `audit-hook-arming.yml` (ES-01 to ES-03, every fixture on a runner) | TM-05, TM-09 | —        | Unmeasured until the PR into `testing` runs it (`23-pr-and-review`)                                                          |

### Design-state promotion triggers — restated against the shipped code

| Threat | Present state | Design state | Promotes when                                                              | After US009                                                                                    |
| ------ | ------------- | ------------ | -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| TM-02  | MEDIUM        | HIGH         | The first compromised package enters the graph                             | **Live.** Unchanged; the surface grew by one (N-07)                                            |
| TM-01  | MEDIUM        | HIGH         | A second contributor joins                                                 | **Narrowed.** Live only if a contributor installs with npm/yarn, or `allowBuilds` flips (N-03) |
| TM-03  | MEDIUM        | HIGH         | The next worktree story                                                    | **Retired.** Worktrees arm (EC-01); a broken gitfile exits 2                                   |
| TM-04  | MEDIUM        | HIGH         | A host-global `lefthook` of a different major on any contributor's machine | **Live at commit time** (N-02); retired for arming                                             |
| TM-06  | MEDIUM        | HIGH         | Anything named `log` or `Removed.` at the project root                     | **Retired.** Fixed upstream in `8dceffb`                                                       |

## 6. Sign-off

| Reviewer                                                   | Role                              | Date       |
| ---------------------------------------------------------- | --------------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Post-implementation STRIDE review | 17/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — pending      | —          |

**Overall verdict:** no CRITICAL or HIGH was planned or introduced; ten of twelve planned threats
are mitigated or moot with probe evidence, TM-02 and TM-12 are the residuals the plan already
accepted, and the new workflow's CI execution is unmeasured, not passed.

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` — the pre-implementation model re-assessed here
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the posture assessment that consumes this review
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the review-round findings and their closures
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH would be escalated; none
- `../../../02-STORIES/US009.md` — the story reviewed
- `../../../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` — the sole-arming-path decision TM-01 rests on
- `../../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the closing answer sections (09/10/2026 to 17/11/2026)
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — where this review is written
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the unrun CI is reported as unmeasured
