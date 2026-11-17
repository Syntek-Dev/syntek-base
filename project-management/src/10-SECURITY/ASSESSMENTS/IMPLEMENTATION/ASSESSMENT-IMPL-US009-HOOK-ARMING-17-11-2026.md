# Security Posture Assessment (Implementation) — US009 The git hooks arm on purpose at install

| Field           | Value                                                                                                                                   |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true                                 |
| **Date**        | 17/11/2026                                                                                                                              |
| **Verified by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3   |
| **Sprint**      | SPRINT-05 — re-estimated 5 to 8 SP on 17/11/2026; the sprint runs 16 / 11 SP over grace and is reconciled at its close                  |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` (signed off 28/09/2026; clarification 09/10/2026)                                    |
| **Outcome**     | **PASS with deferred items** — thirteen of fourteen constraints closed with evidence (7.6 moot); 7.2's register row owed; CI unmeasured |

---

## 1. Scope

Assessed at HEAD `fd11604`, the last US009 commit; `97821a8` above it touches only
`.github/scripts/shipped-ai.py`. Consumes
`../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US009-HOOK-ARMING-17-11-2026.md` and
`../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US009-HOOK-ARMING-17-11-2026.md`.

**Addition to the plan's scope:** the step became its own script,
`code/src/scripts/development/install-hooks.sh`, with a read-only `--notice` mode. Two more were
added: the probe runner `code/src/scripts/tests/hook-arming.sh` and the workflow
`.github/workflows/audit-hook-arming.yml`. One pre-existing `install.sh` defect was also fixed:
`generate_machine_spec` aborted `--spec` under `pipefail` when a host probe failed.

| File                                                             | What was assessed here                                                                              |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `code/src/scripts/development/install-hooks.sh`                  | Guard, location rule, binary provenance, ownership classification, `--notice`, exit codes           |
| `install.sh`                                                     | Step 9 position and propagation (`:536-542`); numbering (`:51-63`); `generate_machine_spec` (`:83`) |
| `package.json` · `pnpm-workspace.yaml`                           | `postinstall` (`:11`), range (`:22`); `allowBuilds` `lefthook: false` (`:25-28`)                    |
| `code/src/scripts/development/install-frontend.sh`               | The three `--ignore-scripts` lines (`:71`, `:104`, `:113`); the array fix (`:82-100`)               |
| `code/src/scripts/tests/hook-arming.sh`                          | Probe oracles; tripwire (`:240`); change filter (`:190-201`); strace oracle (`:667-684`)            |
| `.github/workflows/audit-hook-arming.yml` · `audit-template.yml` | Job permissions, credentials, cache key, timeouts; HP-07 grep (`audit-template.yml:164-174`)        |

**Probe evidence.** Final local run at `fd11604`: **371 passed, 0 failed, 1 unmeasured** (ES-01,
CI-only). Evidence under `code/src/scripts/tests/reports/hook-arming/` (gitignored). That run
belongs to the automated record, `../../../18-TESTS/AUTOMATED/US009-TEST-STATUS.md`; this record did
not re-run the suite. It read the kept evidence files named below.

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status  | Evidence / Notes                                                                                                                                                                                                                                                                  |
| -------- | ------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | PASS    | TM-06 moot (`8dceffb`, before the story). Writes are confined to the hooks directory inside the git common directory (`install-hooks.sh:280-295`, `:432-440`); `write-boundary` evidence: only `.git/hooks/pre-commit` and `.git/info/lefthook.checksum` changed, nothing outside |
| A02:2025 | Security Misconfiguration             | PASS    | TM-10: usage and headers renumbered (`install.sh:51-63`). Remedies are scoped to the setting's origin (`remedy`, `install-hooks.sh:310-342`)                                                                                                                                      |
| A03:2025 | Software Supply Chain Failures        | PARTIAL | TM-01 closed and TM-04 closed for arming. Still open: TM-02 (unsuppressed installs, register row owed), TM-08 (caret range), commit-time PATH preference, and an unlocked CI fixture closure (INFO)                                                                               |
| A04:2025 | Cryptographic Failures                | N/A     | No secret, key or credential is handled. The strace oracle shows `--notice` opens no `.env.*`, `.npmrc`, `.git-credentials` or `.netrc` (`hook-arming.sh:682`)                                                                                                                    |
| A05:2025 | Injection                             | PASS    | Every path and config value is quoted or passed through `printf %s`; no `eval` (round-2 security pass, confirmed list)                                                                                                                                                            |
| A06:2025 | Insecure Design                       | PASS    | Sole arming path (ADR); one location rule replaced the scope-by-scope refusals (round 5, 17/11/2026)                                                                                                                                                                              |
| A07:2025 | Authentication Failures               | N/A     | No principal                                                                                                                                                                                                                                                                      |
| A08:2025 | Software and Data Integrity Failures  | PASS    | TM-07: classify-then-report, with copy-aside or move-aside before lefthook writes (`:462-496`). A tailed hook is unarmed (`:160-168`; `graph-reclaim` shows a failing leg blocks again after re-arm). Residual: the predicate is tied to the 2.2.2 template                       |
| A09:2025 | Security Logging & Alerting Failures  | PARTIAL | TM-12 accepted residual. `--notice` discards its own stderr by design; on the PR channel `check-lockfiles.sh:147` swallows the notice                                                                                                                                             |
| A10:2025 | Mishandling of Exceptional Conditions | PASS    | Exits are only 0, 1 or 2; `--notice` is always 0 (round-5 robustness pass: 16 hostile inputs). Broken, bare and worktree-elsewhere repositories exit 2 (`:404-413`). ES-01 to ES-03 unmeasured (CI-only)                                                                          |

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status  | Evidence                                                                                                                                                                                                        |
| --- | -------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS    | `.copier/README.md`'s claim that `install.sh` arms the hooks is now true (unedited; the shipped code makes it so). The ADR is implemented, and the `allowBuilds` comment names it (`pnpm-workspace.yaml:25-27`) |
| ID  | Identify | PASS    | Eight hook states are classified before any change (`install-hooks.sh:462-473`); git config source and scope are read for the remedy (`:237-249`)                                                               |
| PR  | Protect  | PARTIAL | Location rule, project-only binary, no write through a symlink. TM-02 remains open                                                                                                                              |
| DE  | Detect   | PARTIAL | **Improved from Weak.** `--notice` on every pnpm install reports an unarmed, tailed or redirected-outside hook (`:349-391`). No per-commit record (TM-12)                                                       |
| RS  | Respond  | PASS    | Every refusal names its cause and a remedy for its origin; git's own error is reprinted for a broken repository (`:404-407`)                                                                                    |
| RC  | Recover  | PASS    | Step last in Phase 1; re-running `bash install.sh` is the stated recovery in every remedy line. ES-01 to ES-03 are the CI-only proof, unmeasured                                                                |

## 4. Findings

Findings of this review. Review-round findings and their closures are the audit record's.

| ID   | STRIDE | OWASP    | NIST CSF | Severity | Finding                                                                                                                                                                                                                                                                         | Recommendation                                                                                             | Status   |
| ---- | ------ | -------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------- |
| A-01 | E      | A03:2025 | PR.PS    | MEDIUM   | 7.2's second limb: `GAPS.md` has no row for the unsuppressed `pnpm install` invocations (measured 17/11/2026)                                                                                                                                                                   | Open the row on this pass, dated the day it is written, citing the ADR's 17/09/2026 claim                  | Owed     |
| A-02 | —      | —        | GV.PO    | LOW      | Stale constraint text. ST05 and 7.13 still say "no write outside `.git/hooks/`", but the boundary is now the effective hooks directory plus `.git/info/lefthook.checksum`. ST03 and 7.8 cite lefthook 2.1.10 at `pnpm-lock.yaml:54-56`, but the lock is now 2.2.2 at `:214-216` | Correct in place at the owning gates (`02-story-creation`, `10-security-checks`); recorded, not fixed here | Recorded |
| A-03 | —      | —        | GV.PO    | INFO     | The assessment plan's Section 7 opens "Fourteen constraints" correctly, but its header still reads "5 of 13 SP". Its Section 1 history cites "3 of 11 SP". The story is now 8 SP of 16                                                                                          | Header correction at `10-security-checks`                                                                  | Recorded |
| A-04 | E      | A03:2025 | PR.PS    | LOW      | Sweep count disagrees. The build reports 17 `pnpm install` invocations: 6 suppressed and 11 not. This record's own reading of the planning scope, at `fd11604`, counts **12** unsuppressed. The extra one is `audit-hook-arming.yml:77`, which is new in US009                  | Settled 17/11/2026: 18 / 6 / 12, the `GAPS.md` row counts the CI step; the fixture install is excluded     | Closed   |

**No CRITICAL or HIGH finding.** Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Planning-phase findings — status update

| Plan finding | Status            | Evidence / Notes                                                                                                    |
| ------------ | ----------------- | ------------------------------------------------------------------------------------------------------------------- |
| TM-01        | Resolved          | `package.json:11`; `pnpm-workspace.yaml:28`; manifest ST02/ST02b; `notice` fixture. Residual under npm/yarn         |
| TM-02        | Residual          | First limb resolved (manifest ST01); register row owed (A-01)                                                       |
| TM-03        | Resolved          | `detect_repo` (`install-hooks.sh:187-221`); fixture A EC-01 (worktree); `repo-shapes` (broken, bare)                |
| TM-04        | Resolved (arming) | `:445-453`; S-M2 probe; EC-02 strace (`binary-provenance/provenance.record`: 1.13.0 first on PATH, 2.2.2 installed) |
| TM-05        | Resolved          | `install.sh:536-542`; ES-01 to ES-03 unmeasured in CI                                                               |
| TM-06        | Moot              | Fixed upstream in `8dceffb` (14/10/2026), an ancestor of the story's first commit                                   |
| TM-07        | Resolved          | `:462-496`, `:516-533`; `old-backup`, `graph-reclaim`                                                               |
| TM-08        | Residual          | `^2.2.2` stays a range; predicate tied to 2.2.2 fails closed on a bump                                              |
| TM-09        | Resolved          | HP-07 grep **passed in CI** (run `44134013544`, `fd11604`); behavioural workflow not yet run                        |
| TM-10        | Resolved          | `install.sh:51-63`; manifest P2                                                                                     |
| TM-11        | Resolved          | Fixture B, EC-04                                                                                                    |
| TM-12        | Residual          | Accepted, as planned                                                                                                |

## 6. Plan gaps closed & deferred items

| Item                                                              | Status                        | Evidence / Blocked by                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------------------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **7.1** `prepare` settled                                         | Closed                        | `prepare` absent; `postinstall` = `install-hooks.sh --notice \|\| true` (`package.json:11`); `--notice` never runs lefthook (`install-hooks.sh:349-391`); lefthook's own postinstall blocked (`pnpm-workspace.yaml:25-28`)                                                                                                                                                                                                                                                                                                        |
| **7.2** `--ignore-scripts` asserted, scope stated, register entry | Partly closed                 | Exactly three lines, found by content (manifest ST01; `install-frontend.sh:71`, `:104`, `:113`). **Register row owed** (A-01)                                                                                                                                                                                                                                                                                                                                                                                                     |
| **7.3** Guard tests for a repository                              | Closed                        | Git's answer plus a check that git resolved this root's own `.git` (`:189-202`); worktree arms (EC-01)                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **7.4** Project binary, never `PATH`                              | Closed                        | `:445-453`. Fake lefthook on PATH with none in node_modules exits 1 (fixture A, S-M2); EC-02 execve trace. Commit-time selection is lefthook's template (residual)                                                                                                                                                                                                                                                                                                                                                                |
| **7.5** Position against failure mode                             | Closed · CI unmeasured        | Last in Phase 1, `\|\| exit $?` (`install.sh:542`); `--full` still stops before Phase 2, as accepted 30/09/2026. ES-01 to ES-03 not yet run                                                                                                                                                                                                                                                                                                                                                                                       |
| **7.6** Assertions neither depend on nor mask the `sudo rm -rf`   | **Moot**                      | The defect was removed upstream in `8dceffb` before the story began. The array form at `install-frontend.sh:82-100` cannot dangle. ST08's per-line form is still honoured: each flag is found on its own line by content                                                                                                                                                                                                                                                                                                          |
| **7.7** Report what was written and replaced                      | Closed                        | Per-state report `:516-533`; `.old` move reported at once (`:485`), even when lefthook then fails (R3-S-m1 probe)                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **7.8** Range vs pin wording                                      | Closed in code · text stale   | `package.json:22` `^2.2.2`, `pnpm-lock.yaml:214-216` 2.2.2. ST03 text still cites 2.1.10 (A-02)                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **7.9** Generation job greps; execution in its own job            | Closed · CI partly unmeasured | `audit-template.yml:164-174` passed in CI; `audit-hook-arming.yml` `install-failure` job not yet run                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **7.10** Phase 2 renumbered                                       | Closed                        | `install.sh:51-63`, headers `:560`, `:612`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **7.11** Unborn HEAD covered                                      | Closed                        | Fixture B (EC-04)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **7.12** After dependency installation                            | Closed                        | Step 9 follows Steps 3-4; it also refuses a missing or non-running project binary (`:445-453`)                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| **7.13** No network, no credential read, writes bounded           | Closed, **widened boundary**  | The boundary is now the effective hooks directory, which must lie inside the git common directory, plus `.git/info/lefthook.checksum` (red-phase answer, 17/11/2026). `write-boundary`: `default.changed` lists only those two paths, and `redirected.changed` only the redirected hooks dir; `*.outside` are empty; the ignored-file control `ctl.changed` trips. `--notice` strace: no `connect`, no credential opens. Arming mode was not straced for network; lefthook's own network behaviour is not measured (TODO(verify)) |
| **7.14** Guard is not a general try/ignore                        | Closed                        | Only `absent` and `nested` skip; broken, bare and worktree-elsewhere exit 2 with git's message (SEC-03, R4-03, R5-QA-03; `repo-shapes`)                                                                                                                                                                                                                                                                                                                                                                                           |

## 7. Deviations from plan

- **7.13's boundary moved twice.** The 09/10/2026 clarification allowed a hooks directory
  "external to the clone". The red-phase answer added `.git/info/lefthook.checksum`. Rounds 4 and 5
  then narrowed it: the hooks directory's real path must lie **inside the git common directory**.
  A global, system, `GIT_CONFIG`, include or symlinked directory is refused, and so is a
  working-tree one such as `.githooks/`. This is stricter than the clarification, and settled
  with <%DEVELOPER_NAME%> (Confirmation-round answers, 17/11/2026).
- **`core.hooksPath=/dev/null` is an opt-out** (exit 0, nothing armed), not a failure. Red-phase
  answer, 17/11/2026.
- **"Armed" means lefthook 2.2.2's generated layout exactly**, not a marker substring (round 6).
  This is stricter than the 09/10/2026 predicate, and it ties the check to one lefthook release.
- **TM-06 / 7.6 is moot, not closed by this story.** The hazard it guarded against was removed
  upstream before the story began.
- **The step's own exit codes follow `install.sh`'s contract**, not the `development/` folder's
  (`install-hooks.sh:26-29`), so `|| exit $?` propagates them unchanged.

## 8. Sign-off

| Reviewer                                                   | Role                                                     | Date       |
| ---------------------------------------------------------- | -------------------------------------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Post-implementation assessment                           | 17/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — given at `23-pr-and-review`, PR #37 | 17/11/2026 |

**Overall verdict:** the story meets the baseline's posture targets for arming. It introduces no
CRITICAL or HIGH. A03 stays PARTIAL on TM-02, whose register row is owed. The new workflow's CI
execution is unmeasured, not passed.

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the baseline answered here
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US009-HOOK-ARMING-17-11-2026.md` · `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US009-HOOK-ARMING-17-11-2026.md` — the code audit and updated threat model consumed by this review
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH would be escalated; none
- `../../../02-STORIES/US009.md` — the source story
- `../../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the closing answer sections cited in Section 7
- `../../../18-TESTS/AUTOMATED/US009-TEST-STATUS.md` — the automated record that owns the probe run
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
- `code/docs/GATE-REPORTING.md` — why unrun CI is unmeasured, never passed
