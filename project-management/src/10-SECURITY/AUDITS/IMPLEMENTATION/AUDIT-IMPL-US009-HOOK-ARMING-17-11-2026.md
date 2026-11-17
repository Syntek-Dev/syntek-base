# Security Audit — US009 The git hooks arm on purpose at install

| Field          | Value                                                                                                                                                                                                     |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true                                                                                                   |
| **Date**       | 17/11/2026                                                                                                                                                                                                |
| **Audited by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                     |
| **Plan doc**   | **None.** No `AUDIT-PLAN-US009-*` was written at gate 10. This audit answers the threat-model plan's Section 4b constraints, and the assessment plan's 7.1-7.14 through the assessment record (Section 7) |
| **Verdict**    | **Pass with notes** — no CRITICAL or HIGH; every security finding of the six review rounds is closed with a probe, bar the accepted residuals in Section 6; the new workflow has not run in CI            |

---

## 1. Scope audited

Walked at HEAD `fd11604`, the last US009 commit. `97821a8` above it changes only
`.github/scripts/shipped-ai.py` and is not this story's. The review-round findings are quoted from
the three workflow journals: round 2's review, security and QA passes (`SEC-*`, `QA-*`, `R3-*`);
round 4's confirmation (`R4-*`); and round 5's targeted verification (`R5-*`). The plan's closing
answer sections record the developer's rulings on them. Nothing under the working tree was
executed by this audit. It read the code and the kept probe evidence under
`code/src/scripts/tests/reports/hook-arming/` (gitignored).

| File                                            | Verdict         | Notes                                                                                                                                    |
| ----------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/development/install-hooks.sh` | Pass with notes | Location rule `:280-295`; project binary `:445-453`; classify-then-write `:462-496`. Template-pinned predicate (F-001)                   |
| `install.sh`                                    | Pass            | Step 9 last in Phase 1 (`:536-542`); `generate_machine_spec` made best-effort; 8 pre-existing ShellCheck info findings                   |
| `package.json` · `pnpm-workspace.yaml`          | Pass with notes | Notice `postinstall` (`:11`); `allowBuilds` `lefthook: false` (`:25-28`). pnpm-only control (F-003)                                      |
| `code/src/scripts/tests/hook-arming.sh`         | Pass            | Tripwire on the source's node_modules (`:240`); fail-safe change filter (`:190-201`); strace oracles (`:667-684`)                        |
| `.github/workflows/audit-hook-arming.yml`       | Pass with notes | `contents: read` (`:45-46`); `persist-credentials: false` (`:60`, `:167`, `:193`); own cache key (`:73-74`); timeouts. Never run (F-006) |
| `.github/workflows/audit-template.yml`          | Pass            | HP-07 grep (`:164-174`); passed in CI, run `44134013544`, step "Generate a project both ways"                                            |

ShellCheck 0.11.0, run by hand during the build: `install-hooks.sh` and `hook-arming.sh` clean;
`install.sh` has 8 pre-existing info findings. **actionlint is not installed**, so the workflows
are unmeasured by it.

## 2. Findings

### 2a. Residuals this audit records

| ID    | STRIDE | OWASP    | NIST CSF | Trust boundary         | Finding                                                                                                                                                                                                       | Severity | Mitigation / fix                                              | Status   |
| ----- | ------ | -------- | -------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------- | -------- |
| F-001 | T      | A08:2025 | PR.DS    | TB2 binary             | The armed predicate is lefthook 2.2.2's generated layout (`install-hooks.sh:152-168`). A bump that changes the template reads every hook unarmed, so arming exits 2. Fails closed                             | LOW      | Re-measure the layout on every lefthook bump                  | Residual |
| F-002 | S      | A03:2025 | PR.PS    | TB2 binary             | At commit time, lefthook's own `call_lefthook()` tries `$LEFTHOOK_BIN`, then `lefthook` on `PATH`, before the project's binary. The step proves only which binary armed                                       | MEDIUM   | Outside scope (lefthook's template); TM-04 trigger stays live | Residual |
| F-003 | T      | A03:2025 | PR.PS    | TB3 lifecycle          | npm and yarn unsupported: `allowBuilds` is pnpm's, and lefthook's own postinstall would arm under another manager                                                                                             | LOW      | Recorded                                                      | Residual |
| F-004 | T      | A03:2025 | PR.PS    | TB7 CI fixture tooling | `code-review-graph==2.3.9`'s dependency closure is not hash-pinned in CI; the 1.13.0 fixture fetch is unlocked (SEC-05 residual, INFO at verification)                                                        | INFO     | `UV_EXCLUDE_NEWER` or a hashed requirements file              | Residual |
| F-005 | R      | A09:2025 | DE.AE    | TB3 lifecycle          | `--notice` hides its own errors by design (`:84-90`). The PA-01 notice is swallowed by `.claude/hooks/lib/check-lockfiles.sh:147`, which captures `2>&1`. The `postinstall`'s `\|\| true` needs a POSIX shell | INFO     | Recorded                                                      | Residual |
| F-006 | —      | A10:2025 | DE.CM    | TB5 / CI               | `audit-hook-arming.yml` has never run: it triggers on PRs into `testing`. ES-01 to ES-03 and every runner-side fixture are unmeasured. The GitHub `BASE` expression for the change filter was only reviewed   | —        | Measured at `23-pr-and-review`                                | Deferred |
| F-007 | D      | A10:2025 | RC.RP    | TB4 hooks dir          | Timestamped `pre-commit.old.<stamp>` copies accumulate; nothing prunes them                                                                                                                                   | INFO     | Recorded                                                      | Residual |
| F-008 | —      | A02:2025 | RS.MI    | TB1 shell              | Remedy hints are approximate. An include is detected by origin path, which is approximate for `git config --file`. Git older than 2.26 (no `--show-scope`) gets a generic remedy                              | INFO     | Recorded                                                      | Residual |
| F-009 | —      | —        | ID.AM    | TB1 shell              | The macOS and Windows branches of `generate_machine_spec`, and its `/etc/os-release` read, were not exercised                                                                                                 | INFO     | Recorded                                                      | Residual |

**No new CRITICAL or HIGH.** Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.

### 2b. The review rounds' security findings — found and closed

Each was reproduced in a disposable scratch copy, with HOME and git config isolated. Each is now
pinned by a probe in the named fixture of `code/src/scripts/tests/hook-arming.sh`. The final local
run at `fd11604` was 371 passed, 0 failed, 1 unmeasured (ES-01).

| Round                     | ID                  | Severity (verified) | Finding                                                                                                                              | Closed by                                                                                                                                                                                                                                                                           |
| ------------------------- | ------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 — code review           | S-M1                | Major               | code-review-graph's block appended to lefthook's hook still read as armed, though its `\|\| true` became the exit status             | Tail detection, then the full layout rule (`:160-168`); `graph-reclaim`: a failing leg blocks again after re-arm                                                                                                                                                                    |
|                           | S-M2                | Major               | `pnpm exec` could fall back to a `lefthook` on `PATH`                                                                                | Project binary checked before any lefthook runs (`:445-453`); fixture A probe (corrected 17/11/2026, review QA-01, workflow 23: `pnpm exec` is gone; the checked binary is executed directly, now `:476-484`)                                                                       |
|                           | S-m1                | Minor               | An existing `pre-commit.old` was lost or made the install fail                                                                       | Moved to a timestamped name and reported (`:477-487`); `old-backup`                                                                                                                                                                                                                 |
| 2 — security              | SEC-01              | MEDIUM              | A **global** `core.hooksPath` was force-armed, replacing a machine-wide hook (for example a secret scanner) for every repository     | Refused, exit 2. Generalised in round 5 to the location rule (`:280-295`, `:432-440`); `repo-shapes`                                                                                                                                                                                |
|                           | SEC-02              | MEDIUM              | A symlinked `pre-commit` resolved to its target. The `.old` move then wrote outside the hooks dir and a real `.old` was lost         | Hooks **directory** resolved, never the file (`:257-266`); the link moved as a link (`:489-492`) (corrected 17/11/2026, review QA-02, workflow 23: and moved back if `lefthook install` then fails or does not arm the hook, or the `mv` that restores it is printed); `old-backup` |
|                           | SEC-03              | LOW                 | A broken repository (dangling gitfile, corrupt HEAD) skipped with exit 0, and `--notice` stayed silent                               | `detect_repo` distinguishes broken from absent (`:187-221`); exit 2 with git's message; the notice reminds                                                                                                                                                                          |
|                           | SEC-04              | LOW                 | The `install-failure` change filter omitted inputs `install.sh` reads before Step 9                                                  | Inverted to a docs/PM-only skip that fails open (`hook-arming.sh:190-201`); `change-filter`                                                                                                                                                                                         |
|                           | SEC-05              | INFO                | Persisted token on checkouts; cache key shared with `claude.yml`; unlocked fixture closure                                           | `persist-credentials: false` ×3; own cache prefix. Closure residual F-004                                                                                                                                                                                                           |
|                           | SEC-06              | INFO                | The live tree's `node_modules` pointed into a deleted `/tmp` scratch (see Section 6, incident)                                       | Repaired by `install-frontend.sh --local`; the runner's tripwire (`hook-arming.sh:240`)                                                                                                                                                                                             |
| 4 — confirmation          | R4-SEC-01           | Minor               | `GIT_CONFIG` hid a global `core.hooksPath` from the scope check, so the shared hook was overwritten                                  | Location rule: the resolved hooks dir is judged by real path, whatever config git read (`:280-295`)                                                                                                                                                                                 |
|                           | R4-SEC-02           | Minor (policy)      | A symlinked `.git/hooks`, or a local `include.path`, armed a shared directory. Verification judged this settled policy, not a defect | **Ruled by the developer, round 5**: the location rule refuses both. A tracked `.githooks/` is refused too (R5-AMB)                                                                                                                                                                 |
|                           | R4-SEC-03           | Minor               | Rename detection let a move into a docs path skip `install-failure`                                                                  | `--no-renames`, `core.quotePath=false` (`hook-arming.sh:195`); `change-filter` includes a rename case                                                                                                                                                                               |
|                           | R4-SEC-04           | Nit                 | Remedy hints assumed local scope                                                                                                     | Scoped `remedy()` (`:310-342`); `unset_in_scope` (`:224-231`)                                                                                                                                                                                                                       |
| 5 — targeted verification | R5-QA-01 · R5-QA-02 | LOW · MEDIUM        | A marker in comments, or any appended `\|\| true` tail, read as armed. Arming then overwrote it with no copy                         | Generated-layout rule (round 6, `:152-168`); tailed or LEFTHOOK-mentioning hooks copied aside (`:493-496`)                                                                                                                                                                          |
|                           | R5-QA-03            | LOW                 | `core.bare` / `core.worktree` read across all scopes, so a healthy repository could be refused                                       | Git's effective answers (`--is-bare-repository`, `--show-toplevel`, `:205-212`)                                                                                                                                                                                                     |
|                           | R5-QA-04 to -07     | LOW                 | Remedy, precedence and wording defects (multi-valued, `GIT_CONFIG_PARAMETERS`, hooks dir equal to the common dir, gitfile CR)        | `remedy()`, `hp_source()` (`:345`), the subdirectory message (`:433-434`), gitfile trim (`:194`)                                                                                                                                                                                    |

> **Correction 17/11/2026 (workflow 23, review `REVIEW-US009-HOOK-ARMING.md`):** the
> `install-hooks.sh` line citations in this table are the `fd11604` reading. The review fixes
> (QA-01 direct binary execution, QA-02 symlink restore, CR-04 scoped remedies) moved most of
> them; re-resolve each by its quoted behaviour, not its number. No mitigation named here was
> removed — QA-02 adds that a moved symlink is put back when `lefthook install` fails.

**The location rule** (settled 17/11/2026, Confirmation-round answers) is the control that closed
SEC-01, R4-SEC-01 and R4-SEC-02 together. The hooks directory's real path, and the path
`core.hooksPath` names, must both lie inside `git rev-parse --git-common-dir`. Anything else is
refused before any write, exit 2. The scope reading now only shapes the remedy text. Round 5's
correctness pass reproduced every route it could name in scratch: global, system, `GIT_CONFIG`,
`GIT_CONFIG_COUNT`, `git -c` / `GIT_CONFIG_PARAMETERS`, include, symlinked `.git/hooks`,
worktree-root `.githooks`, `..` through a missing component, and dangling symlinks. Each
refused, and the shared directory stayed byte-identical.

## 3. Checklist results

| #   | Control                                                                        | Result | Evidence (file · symbol)                                                                                                                                         |
| --- | ------------------------------------------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | N/A    | No endpoint                                                                                                                                                      |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | N/A    | No identifier. The analogue — a caller-supplied location — is the location rule (`hooks_outside`, `:280-295`)                                                    |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production      | N/A    | Untouched                                                                                                                                                        |
| C4  | `DEBUG=False` in every non-local environment                                   | N/A    | Untouched                                                                                                                                                        |
| C5  | All secrets read from environment variables — none hardcoded                   | Pass   | No secret in the diff. CI evidence uploads were checked in round 2: strace without `-v`, the snapshot excludes `.env.*`, and `install.sh` prints key names only  |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)          | Pass   | Unknown option exits 2 (`:127-134`); `GIT_*` location variables cleared (`:142`); gitfile value trimmed (`:194`); empty or unresolvable `core.hooksPath` exits 2 |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL   | Pass   | Shell analogue: every path quoted or passed through `printf %s`, no `eval` (round-2 security, confirmed list)                                                    |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass   | Messages print paths and config sources only; `--notice` strace shows no credential-file open (`hook-arming.sh:682`)                                             |
| C9  | Multi-write paths transactional and audit-logged where security-relevant       | Pass   | Each move is checked before lefthook runs (`mv -n` plus a post-condition, `:482`, `:490`); each is reported at once (`:485`); result verified after (`:510-514`) |

## 4. OWASP Top 10 coverage

| #   | Category                              | Result                                            |
| --- | ------------------------------------- | ------------------------------------------------- |
| A01 | Broken Access Control                 | Pass — location rule; TM-06 moot                  |
| A02 | Security Misconfiguration             | Pass — F-008 residual                             |
| A03 | Software Supply Chain Failures        | F-002, F-003, F-004; TM-02 open (assessment A-01) |
| A05 | Injection                             | Pass                                              |
| A08 | Software and Data Integrity Failures  | Pass — F-001 residual                             |
| A09 | Security Logging & Alerting Failures  | F-005; TM-12 accepted residual                    |
| A10 | Mishandling of Exceptional Conditions | Pass locally; F-006 (CI unmeasured)               |

A04, A06 and A07 are N/A or covered without finding
(`../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US009-HOOK-ARMING-17-11-2026.md`, Section 2).

## 5. Plan constraints closed

These are the threat-model plan's Section 4b constraints; no audit plan exists. The assessment
plan's 7.1-7.14 are closed in the assessment record's Section 6.

| Plan constraint                                      | Status          | Evidence                                                                                                                                                                                                 |
| ---------------------------------------------------- | --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 4b.1 Guard tests for a repository                    | Closed          | `detect_repo` (`:187-221`); EC-01 worktree arms                                                                                                                                                          |
| 4b.2 Project binary via `pnpm exec`, never `PATH`    | Closed (arming) | `:445-453`; S-M2 probe; EC-02 execve trace. Commit time: F-002 (corrected 17/11/2026, review QA-01, workflow 23: run directly, not through `pnpm exec`, now `:476-484`; pnpm no longer required)         |
| 4b.3 No network, no credential read, bounded writes  | Closed, widened | The boundary is now the effective hooks dir inside the common dir, plus `.git/info/lefthook.checksum`. `write-boundary`: `*.outside` empty; `--notice` strace clean. Arming mode not straced for network |
| 4b.4 After dependency installation                   | Closed          | `install.sh:536-542` follows Steps 3-4                                                                                                                                                                   |
| 4b.5 `--ignore-scripts` on three lines, scope stated | Closed          | Manifest ST01 (`install-frontend.sh:71`, `:104`, `:113`)                                                                                                                                                 |
| 4b.6 Guard not a general try/ignore                  | Closed          | Broken, bare and worktree-elsewhere exit 2 (`:404-413`)                                                                                                                                                  |
| 4b.7 Report what was written and replaced            | Closed          | `:516-533`; `.old` move `:485`                                                                                                                                                                           |
| 4b.8 Precedence written down                         | Closed          | One mechanism survives (ADR); `allowBuilds` comment names it (`pnpm-workspace.yaml:25-27`)                                                                                                               |

## 6. Deferred / residual items

- **F-001 to F-009** — Section 2a. Each is a known residual or a CI deferral, carried into the
  story's findings record.
- **TM-02's register row is owed.** `GAPS.md` has no row for the unsuppressed `pnpm install`
  invocations (measured 17/11/2026). The build counts 11 unsuppressed of 17; the assessment record
  counts 12 by its own reading (A-04, TODO(verify)).
- **Incident during review, 17/11/2026, 11:22.** A workflow verifier symlinked this checkout's
  live `node_modules` into a scratch copy. Its `pnpm install` then repointed the live
  `node_modules` into a `/tmp` directory, which was later deleted (SEC-06). Repaired with
  `install-frontend.sh --local`. The probe runner now trips, exit 2, if the source checkout's
  `node_modules` changes during a run (`hook-arming.sh:240`). Probe results that relied on the tree's
  `node_modules` between the damage and the repair are not cited here. A process finding, not a code
  vulnerability.
- **Stale text in other gates' artefacts** (recorded, not edited): ST05 / 7.13 "no write outside
  `.git/hooks/`"; ST03 / 7.8 cite lefthook 2.1.10 at `pnpm-lock.yaml:54-56`; the plans' SP headers;
  the story plan's own `:442` README citation (the sentence is now at `.copier/README.md:450`).
  Listed in full in the assessment record (A-02, A-03) and the findings record.

## 7. Deviations from plan

- **No audit plan existed** for US009. This record answers the threat-model plan's Section 4b
  directly, and the assessment plan's Section 7 through the assessment record.
- **The write boundary is the location rule**, not the plan's literal `.git/hooks/`, and not the
  09/10/2026 clarification's "may be external to the clone". Narrowed with the developer at rounds
  4 and 5 (17/11/2026).
- **The step is its own script.** It was extracted from `install.sh` so it can be probed without
  docker, sudo or secrets (story plan Key Decision 1). It follows `install.sh`'s exit-code
  contract (`install-hooks.sh:26-29`).
- **A pre-existing `install.sh` defect was fixed in scope.** `generate_machine_spec` aborted
  `--spec` under `pipefail` when one host probe failed. On this host a stale FUSE mount made `df`
  exit 1. It is now best-effort, and the `machine-spec` fixture pins it.

## 8. Sign-off

| Auditor                                                    | Role                         | Date       |
| ---------------------------------------------------------- | ---------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Post-build security audit    | 17/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — pending | —          |

---

## Cross-references

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` — the constraints answered here in place of an audit plan
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the re-assessed STRIDE model
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the posture assessment this audit feeds
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH would be escalated; none
- `../../../02-STORIES/US009.md` — the story audited
- `../../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the rulings on each review round (closing answer sections)
- `../../../18-TESTS/AUTOMATED/US009-TEST-STATUS.md` — the automated record that owns the probe run
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
