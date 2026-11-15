# Code Review — US006 The destructive dev scripts read the deployment posture, and refuse to run above development

**Last Updated**: 15/11/2026 · **Story**: US006 · **Status**: In Review

| Field        | Value                                                                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US006 — the destructive dev scripts read the deployment posture, and refuse to run above development                                     |
| **Branch**   | `us006/posture-guard` (`testing` merged in at `d463d6b`)                                                                                 |
| **PR**       | Raised by Sam · target `testing`                                                                                                         |
| **Reviewer** | Claude — separate `code-reviewer`, `security` and `qa-tester` dispatches at `23` Steps 1–2, each adversarially verified by a second agent |
| **Date**     | 15/11/2026                                                                                                                               |
| **Verdict**  | Approve — every finding fixed on the branch at Sam's direction                                                                           |

**Codes from:** `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the implementation
master, with its dated errata (the workflow 23 erratum covers every change below).
**Story:** `../02-STORIES/US006.md` — the acceptance criteria this review traced to code.

---

## 1. Scope & files reviewed

Shell only — no Python, template, endpoint, migration or UI. The posture guard, its six callers,
the self-test harness, the CI teardown, and the US006 records; plus, at Sam's direction during the
review, the AI-host configs that keep the live env files unreadable (F-027).

| File                                                                                    | Change                                                                                                     |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/_lib/posture-guard.sh`                                                | The guard; review: `ENV_FILE` input, carrier fail-closed forms, line-break unification, project repair     |
| `code/src/scripts/database/_migrate-self-test.sh`                                       | The harness; review: +64 cases, the behavioural tier (`st_behavioural`)                                    |
| `code/src/scripts/database/{reset,restore,seed-dev,migrate}.sh`                         | Guard wiring; review: `"$ENV_FILE"` passed; `restore.sh` R-004 fix                                         |
| `code/src/scripts/development/server.sh` · `code/src/scripts/tests/server.sh`           | Guard wiring; review: `"$ENV_FILE"` passed                                                                 |
| `.github/workflows/test-e2e.yml`                                                        | CI teardown names `--force-posture development`                                                            |
| `.claude/settings.json` · `.codex/config.toml` · `.zed/settings.json`                   | F-027 — the live env files unreadable to every AI host; env-using scripts not runnable by Claude           |
| `code/src/scripts/audits/env-read-deny.sh` · `.github/workflows/audit-env-read-deny.yml` | F-027 — the gate holding the three host configs in step                                                    |
| `.claude/CLAUDE.md` · `.ai/INSTRUCTIONS.md` · `code/src/scripts/**/{CONTEXT,CLAUDE}.md` | The rule and the contract written where the next reader looks                                              |
| US006 records under `project-management/src/` and the new `21-BUGS/` report             | F-020 to F-027, counts, the independent review recorded, plan erratum                                      |

---

## 2. Findings

Review IDs map one to one onto the findings record; the `F-0NN` there carries the full evidence.

| ID    | Severity | File:line                                                         | Issue                                                                                                                         | Resolution/Status                                                                              |
| ----- | -------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| R-001 | Medium   | `_lib/posture-guard.sh` `posture_resolve_target`                  | `COMPOSE_PROJECT_NAME` in the `--env-file` bypassed the F-018 project check; three re-check rounds found further spellings     | Fixed — F-020; `posture_env_project` counts every mention, one canonical line, NUL refused     |
| R-002 | Low      | `_lib/posture-guard.sh` `posture_read_carrier`                    | YAML key spellings and line breaks PyYAML honours hid a second posture                                                        | Fixed — F-021; exotic forms fail closed, breaks unified to LF                                  |
| R-003 | Low      | `_lib/posture-guard.sh` `posture_guard`                           | A project-name refusal printed the Docker-socket repair                                                                       | Fixed — F-022, in refuse and warn mode                                                         |
| R-004 | Low      | `database/restore.sh`                                             | Relative backup path read after `cd` and after `DROP DATABASE` (pre-existing, not US006's)                                    | Fixed — F-023; resolved before the `cd`, opened on fd 3 before the DROP; bug report filed       |
| R-005 | Info     | `database/_migrate-self-test.sh`                                  | The callers were proved only by reading their text                                                                            | Fixed — F-024; behavioural tier runs all six against a fixture on a recording `docker`          |
| R-006 | Low      | `database/_migrate-self-test.sh:230`; `US006-TEST-STATUS.md`      | New ShellCheck `SC2016`; the record called the harness clean                                                                  | Fixed — F-025                                                                                  |
| R-007 | Info     | Both security `IMPLEMENTATION` records                            | Stale counts, line numbers and commit state                                                                                   | Fixed — F-026                                                                                  |
| R-008 | Low      | `.claude/settings.json`, `.codex/config.toml`; the guard's output | Sam's rule: no AI tool reads a live env file; Codex had no control and the guard echoed an env-file value                    | Fixed — F-027                                                                                  |
| R-009 | Info     | `posture_env_project`                                             | A commented-out `# COMPOSE_PROJECT_NAME=` line in a developer's env file now refuses                                          | Won't-fix — deliberate fail-closed; a `#` line can sit inside a quoted value Compose reads      |

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- [x] **A01 — permission check before logic.** N/A as an endpoint rule; the analogue holds — every
      caller branches on the guard (`|| exit "$?"`) before its first daemon call, proved by the
      structural and behavioural tiers.
- [x] **IDOR.** N/A — no user-supplied record IDs.
- [x] **Secrets & DEBUG.** No secret in any changed file; the guard never prints an env-file value
      (F-027). `audits/security.sh` reads a live env file and is Sam's to run.

### 3.2 GDPR / PII

- [x] N/A — no personal data processed.

### 3.3 Test coverage vs floors

- [x] Self-test `bash code/src/scripts/database/migrate.sh --self-test`: **250 of 250**, docker never
      invoked — 164 helper, 60 structural, 25 behavioural. Every review case was shown red first.
- [x] Every acceptance criterion traced to code by the content review; 7.12's compose part closed by F-020.
- [x] Manual walk 70/70 Pass and countersigned; no walked row depends on the changed behaviour.
- [ ] Backend coverage / full suite — N/A to shell; the `tests/` runners read a live env file and are Sam's to run.

### 3.4 Quality, DRY & file length

- [x] One reader per concern — the env-file value goes through `env-file.sh`'s `_env_strip`.
- [x] No new `TODO` / `FIXME` / `HACK`.
- [x] ShellCheck: only the four pre-existing `SC2015 (info)` (F-012).
- [ ] `syntax/lint.sh` / `format.sh` — read a live env file; **Sam to run** before merge.

### 3.5 Performance

- [x] N/A — dev scripts; the guard adds one file read and one `grep` per run.

### 3.6 Accessibility (WCAG 2.2 AA)

- [x] N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

| Action                                                                                       | Finding | Owner | Status |
| -------------------------------------------------------------------------------------------- | ------- | ----- | ------ |
| Run `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/format.sh`      | —       | Sam   | Open   |
| Run the Codex literal read test on fake files (`codex sandbox -P workspace-no-env …`)        | R-008   | Sam   | Open   |
| Confirm no `COMPOSE_PROJECT_NAME` mention in his own `.env.dev` / `.env.test`                | R-009   | Sam   | Open   |

---

## 5. Verdict & status transition

- **Verdict:** Approve.
- **Reasoning:** no Critical or High after adversarial verification; every finding fixed on the
  branch with a red-first case; four independent re-check rounds found no regression.
- **Status transition:** In Progress → In Review at the PR (`completion`); Accepted waits on the
  Section 4 actions and CI.

---

## 6. Notes

- Not OS-level by Sam's choice: a script an AI runs can still read an env file internally, and a
  per-run Codex `-s` / `-c sandbox_mode=…` override drops the profile. The rule binds regardless.
- The env-file control is template-wide (it ships into every generated project), kept on this branch
  at Sam's direction rather than split out.

---

## Cross-references

- `../02-STORIES/US006.md` — the story under review
- `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the plan this code was written from
- `../18-TESTS/AUTOMATED/US006-TEST-STATUS.md` · `../18-TESTS/MANUAL/US006-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US006-POSTURE-GUARD-15-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-001 to F-027
- `../21-BUGS/BUG-RESTORE-RELATIVE-BACKUP-PATH-AFTER-DROP-15-11-2026.md` — the R-004 bug
- `project-management/workflows/23-pr-and-review/` · `code/workflows/07-review/` — the workflows run
