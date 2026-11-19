# QA Implementation Review — US006 The deployment-posture guard

| Field        | Value                                                                                                                                                                                                                                                           |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US006 — The destructive dev scripts read the deployment posture, and refuse to run above development                                                                                                                                                            |
| **Date**     | 15/11/2026                                                                                                                                                                                                                                                      |
| **Sprint**   | SPRINT-04                                                                                                                                                                                                                                                       |
| **Reviewer** | Claude Code — `qa-tester` skill, Opus, `22-implementation-documentation` Step 3                                                                                                                                                                                 |
| **Branch**   | `us006/posture-guard` at `fbd9dbc`, re-evaluated 15/11/2026 against the F-001 fix to `development/server.sh` and the F-018 fix to `_lib/posture-guard.sh`, both committed in `0a6db24`; then against the workflow 23 review fixes (F-020 to F-026), uncommitted |
| **Plan doc** | `../PLANNING/QA-PLAN-US006-POSTURE-GUARD.md`                                                                                                                                                                                                                    |
| **Outcome**  | Pass — every scenario Pass; ES-07 re-marked Pass after the F-001 fix. Manual walk complete, PERM-07 included (70 Pass, 0 Fail), countersigned by Sam Bailey 15/11/2026. Workflow 23 review: seven LOW/INFO findings, all resolved 15/11/2026                    |

---

## 1. Scope

One sourced helper (`code/src/scripts/_lib/posture-guard.sh`), six wired callers, a stack-down
self-test (`code/src/scripts/database/_migrate-self-test.sh`, entered through
`bash code/src/scripts/database/migrate.sh --self-test`) and the CI teardown at
`.github/workflows/test-e2e.yml:142`. No backend, API or frontend. Matches the plan's scope plus
the gate-10 additions it already carried (`seed-dev.sh`, `up --seed`).

**Evidence used, in order of preference:**

1. **Self-test case labels**, from a run on 15/11/2026 — exit 0, every case `PASS`,
   `docker never invoked`, stdin not a tty. `(r)` and `(w)` below mean the case's `refuse` and
   `warn` runs; `S` cases are line-order assertions over caller text.
2. **Observed behaviour** in a disposable `git archive HEAD` copy under `mktemp -d`, with a
   recording `docker` first on `PATH`, synthetic `DOCKER_CONFIG`, fixture-only `.env.dev` and a
   scratch carrier, per the manual guide's _Preconditions_. No real stack, volume, answers file or
   `copier.yml` was touched; the copy was removed.
3. **Manual row IDs** from `../../18-TESTS/MANUAL/US006-MANUAL-TESTING.md`, walked 15/11/2026: the
   fixture rows at `fbd9dbc`, then the stack-dependent rows on a disposable us006 stack, with
   REFUSE-05 and TARGET-01 to TARGET-04 re-walked after the F-001 fix, and PERM-07 (amended for
   F-018) walked by Sam Bailey at `b173cba` — 70 Pass, 0 Fail. A row cited below is `Pass` unless
   it says otherwise.

**Re-evaluated 15/11/2026** after the F-001 fix (committed in `0a6db24`): `development/server.sh up --seed`
now runs its guard and Docker bind before `compose up -d` and the password sync, and `up` without
`--seed` stays unguarded. The self-test re-ran at exit 0, 175 of 175, with the new structural cases
`21-seed-guard-first-in-block`, `F001-seed-bound-before-up` and `F001-up-d-on-compose-array`.

**Re-evaluated again 15/11/2026** after the F-018 fix (committed in `0a6db24`): the guard compares
`COMPOSE_PROJECT_NAME` with the declared compose `name:` as Compose normalises it, so a permitted
`down --volumes` can no longer act on a different project than the one named. Self-test: exit 0,
**186 of 186**, adding eleven `F018-*` helper cases. No scenario's result changes; ES-04 gains the
evidence.

**Re-evaluated a third time 15/11/2026** after workflow 23's review — three separate dispatches
(content, `security`, `qa-tester`), each adversarially verified by a second agent, with no Critical,
High or Medium after verification. The developer directed all seven findings fixed on this branch
(uncommitted at the time of writing; detail in the findings record):

| Finding | Severity | What changed                                                                                                                                                                                                                                                                                                                                                           |
| ------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F-020   | LOW      | The compose-project check also reads `COMPOSE_PROJECT_NAME` from the caller's `--env-file` (shell first); new fifth positional `ENV_FILE` on `posture_guard`; after the re-checks, read by `posture_env_project`, which accepts exactly one mention of the key, on a plain `COMPOSE_PROJECT_NAME=value` line, and refuses anything else — a commented-out key included |
| F-021   | LOW      | Carrier spellings a line reader cannot model (`? KEY`, tag, anchor, escaped quoted key, continuation line; after the re-checks, a key hidden after a lone CR, NEL, U+2028 or U+2029, all now read as line breaks) refuse; a quoted answer Copier dumped with a raw NEL still reads                                                                                     |
| F-022   | LOW      | A compose-project refusal prints its own repair, not the Docker-socket one; warn mode names the compose project too                                                                                                                                                                                                                                                    |
| F-023   | LOW      | `restore.sh` makes a relative backup path absolute before its `cd` and opens it on fd 3 before the DROP — **pre-existing, not US006's**; `../../21-BUGS/BUG-RESTORE-RELATIVE-BACKUP-PATH-AFTER-DROP-15-11-2026.md`                                                                                                                                                     |
| F-024   | INFO     | A behavioural tier runs the six callers against a recording `docker`                                                                                                                                                                                                                                                                                                   |
| F-025   | LOW      | The harness's `SC2016` directive added; ShellCheck citations corrected                                                                                                                                                                                                                                                                                                 |
| F-026   | INFO     | Stale counts and lines in the security records corrected                                                                                                                                                                                                                                                                                                               |

Self-test: exit 0, **250 of 250** (164 H, 60 S, 25 B, `docker never invoked`). No scenario's result
changes and no manual row needed amending or re-walking. An independent re-check of the fixes
(four rounds, by a separate agent that wrote none of the code) verified R-003, R-005 and R-006
closed, found R-001 and R-002 not fully closed (both reshaped into final forms), found a MEDIUM
NUL-byte gap in the F-020 fix and a tab false refusal, and strengthened the F-023 regression case;
all fixed, no regression (the guide's _Failures_ says why); ES-04
gains the env-file evidence (EC-N6), and EC-N7 and EC-N8 are new below.

## 2. Acceptance-criteria gaps closed

All twenty-two were resolved into the story at planning; this closes each against what shipped.

| Gap       | Status   | Evidence                                                                                                                                                           |
| --------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| AC-GAP-1  | Resolved | Case 19 (r) rc=0 with no tty; `posture_unconfirmed` binds the prompt, not the terminal                                                                             |
| AC-GAP-2  | Resolved | S `7.8-presence-*` over exactly six callers; `21-dev-two-guards-only`                                                                                              |
| AC-GAP-3  | Resolved | S `20-forwards-override`, `20-seed-dev-parses-first`, `20-pins-child-host`                                                                                         |
| AC-GAP-4  | Resolved | Case 17 (r) rc=4; Step 5 refusal names the repair and says the override is not honoured                                                                            |
| AC-GAP-5  | Resolved | `migrate.sh:113` dispatches `--self-test` ahead of the guard (`:128`), the validator and `container_running` (`:166`); `docker never invoked`                      |
| AC-GAP-6  | Resolved | Each H case asserts exit code and prefix for refusals, rc=0 for permits; no pre-change comparison                                                                  |
| AC-GAP-7  | Resolved | Self-test labels track cases 01–21 with 14 split into 14a–14e                                                                                                      |
| AC-GAP-8  | Resolved | `\|\| exit "$?"` at every call; S `7.7-terminates-*`; H `set-euo-permit`, `set-euo-warn`                                                                           |
| AC-GAP-9  | Resolved | Return contract stated at `posture-guard.sh:18-20`: 0 permit, 4 refuse, stderr, never `exit`                                                                       |
| AC-GAP-10 | Resolved | Guards above the env-file check (`development/server.sh:126-133`, `tests/server.sh:116-123`); S line-order presence cases                                          |
| AC-GAP-11 | Resolved | Cases 14a–14e both modes; `up --seed` now guards and binds before its first Docker call (F-001 fix; S `F001-seed-bound-before-up`; manual `TARGET-01`–`TARGET-04`) |
| AC-GAP-12 | Resolved | `posture_guard ROOT …` positional; no environment seam; case `relative-source`                                                                                     |
| AC-GAP-13 | Resolved | Owner and trigger at `test-e2e.yml:133-139`; manual `CI-01`, `CI-02`                                                                                               |
| AC-GAP-14 | Resolved | S `21-seed-guard-first-in-block`, `21-dev-two-guards-only`; manual `SEED-03`                                                                                       |
| AC-GAP-15 | Resolved | Baseline captured in P0 (`fc10bcc`); closing comparison manual `BASE-01`, `GATES-01` (28 → 18, nothing new in the story's files)                                   |
| AC-GAP-16 | Resolved | Planning-only (SPRINT-04 composition); no shipped-code evidence applies                                                                                            |
| AC-GAP-17 | Resolved | Both ADRs exist: `ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026`, `ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026`                                       |
| AC-GAP-18 | Resolved | Manual `BASE-02`, `GATES-03` (243 code lines, unchanged)                                                                                                           |
| AC-GAP-19 | Resolved | `MAP-SCRIPT-GUARDS.md` S-01 row names US006 and the guard (planning-side; not re-verified line by line here)                                                       |
| AC-GAP-20 | Resolved | As AC-GAP-7                                                                                                                                                        |
| AC-GAP-21 | Resolved | Every 14* case: refuse rc=4, warn rc=0; `migrate.sh` passes `warn` and no override                                                                                 |
| AC-GAP-22 | Resolved | Step 5 message names file, key and the three values; case 04 (unrecognised) refuses with it                                                                        |

## 3. Scenario verification

**The plan carries two rows with the ID `HP-07`** — the 09/10/2026 target row and the original
`up --build` row. The plan is frozen, so they are kept and told apart below as HP-07 (target) and
HP-07 (`up --build`); the duplicate is routed to findings.

### Happy Path

| ID                   | Scenario (from plan)                                               | Result | Evidence                                                                                                                                                                                                                                       |
| -------------------- | ------------------------------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-07 (target)       | Named local context passes and binds, both modes                   | Pass   | Cases 14c-named-local, 14c-saved-local (r) rc=0 and (w) rc=0; S `14-binding-*` on all six callers. Manual `TARGET-02`: every call pinned, `up --seed`'s `up -d` and password sync included                                                     |
| HP-01                | `development` permits; `migrate.sh` prints posture and obligation  | Pass   | Case 01 (r)/(w), 01-posture (w); S `help-clean-migrate`. Manual `DEV-01`–`DEV-07`                                                                                                                                                              |
| HP-02                | Template repository: every script proceeds; answers file unchanged | Pass   | Case 11 (r)/(w), 11-posture; the shipped `.copier-answers.yml` carries no `DEPLOYMENT_POSTURE` line, so it takes the template branch. Manual `TMPL-01`–`TMPL-08`, real database and volume effects on the us006 stack; answers file unmodified |
| HP-03                | Live override permits; prompt still runs; `--yes` inert            | Pass   | Case 15 (r) rc=0; S `yes-inert-reset`, `yes-inert-restore`. Manual `OVR-01` (pasted re-run, prompt ran, reset completed), `OVR-02`                                                                                                             |
| HP-04                | No tty, live override, `down --volumes` proceeds                   | Pass   | Case 19 (r) rc=0 in a no-tty run. Manual `NOTTY-03`                                                                                                                                                                                            |
| HP-05                | `up --seed --force-posture staging` crosses the shell-out          | Pass   | S `20-forwards-override`, `20-seed-dev-parses-first`, `20-pins-child-host`. Manual `SEED-01`: stack came up seeded, exit 0, no second refusal                                                                                                  |
| HP-06                | `production`: `migrate.sh run` warns, proceeds, exits 0            | Pass   | Case 03-posture (w) rc=0; `migrate.sh:128` calls the guard in `warn` with no override. Manual `MIG-01`: a real pending migration applied at `production`, exit 0                                                                               |
| HP-07 (`up --build`) | `up --build` proceeds at any posture                               | Pass   | S `21-seed-guard-first-in-block`, `21-dev-two-guards-only`. Manual `SEED-03` at `staging`: 0 guard lines, exit 0                                                                                                                               |

### Error States

| ID    | Scenario (from plan)                                                                            | Result | Evidence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----- | ----------------------------------------------------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | `staging`/`production`, no override: exit 4, prefix, posture, re-run                            | Pass   | Cases 02, 03 (r) rc=4. Observed: `staging` carrier, `reset.sh`, `restore.sh`, both `down --volumes`, `up --seed` each exit 4 with `posture-guard: refused — this project is at 'staging', where this command is destructive. If that is the target you mean, re-run naming the live posture: …`. Manual `REFUSE-01`–`REFUSE-07`; `REFUSE-05` re-walked after the F-001 fix with zero us006 daemon events                                                                                                                                                                                                       |
| ES-02 | Prompting script, no tty: exit 4, never the exit-0 abort                                        | Pass   | Cases 18, 18-prompt-staging (r) rc=4; S `18-empty-read-reset`, `18-empty-read-restore`. Manual `NOTTY-01`, `NOTTY-02`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ES-03 | Stale override refused                                                                          | Pass   | Case 16 (r) rc=4. Manual `OVR-03`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ES-07 | Saved remote context: five refuse at 4 **before daemon operation**; migrate warns               | Pass   | **Re-marked 15/11/2026 — was Fail** (F-001, resolved on this branch). Self-test 14b-saved-remote (r) rc=4 and (w) rc=0; S `F001-seed-bound-before-up` and `F001-up-d-on-compose-array`. Manual `TARGET-01`: all six bound paths, `up --seed` included, exit 4 with only `context ls`/`inspect` recorded — no pre-guard `compose up -d`, no password-sync exec. `REFUSE-05` on the real us006 stack: exit 4, zero us006 daemon events. Meets `US006.md:499`. `migrate.sh show` warns (`TARGET-05`)                                                                                                              |
| ES-08 | Unknown/malformed/missing/inspect-failed metadata: no fallback; refuse vs warn; outputs cleared | Pass   | Cases 14d-unknown-ctx, 14d-malformed-cfg, 14d-ambiguous-cfg, 14d-unreadable-cfg, 14d-no-endpoint, 14d-inspect-fails, 14d-relative-sock, 14d-empty-sock, 14d-escaped-key, 14d-case-dup-cfg (r) rc=4, (w) rc=0; harness checks binding cleared. Manual `TARGET-03`: six variants, all six refusing paths exit 4 with 0 downstream calls, `up --seed` included; `migrate.sh show` warns with no fabricated `--host`                                                                                                                                                                                               |
| ES-09 | Selection changed after validation: bound calls keep `--host`                                   | Pass   | Case 14e-drift (r)/(w); S `14-no-reselect-*`, `14-no-repin-*`, `14-dev-no-reselect`, `14-tests-no-reselect`, `20-pins-child-host`. Manual `TARGET-04`: saved selection drifted to remote after validation; every recorded call, `up --seed`'s `up -d` and password sync included, carried the validated `--host`; the child validated the inherited host                                                                                                                                                                                                                                                       |
| ES-04 | Remote/unknown endpoint at `development`: five exit 4; migrate warns                            | Pass   | Cases 14a-remote-host, 14a-remote-context, 14a-tcp-loopback, 14a-compose-name, 14a-override-noop, 14a-template-noop (r) rc=4, (w) rc=0. Compose-name allowlist compared after Compose's normalisation (F-018, fixed 15/11/2026): `F018-raw-declared-cpn`, `F018-different-cpn`, `F018-empty-normalised`, `F018-empty-norm-cpn` (r) rc=4; `F018-normalised-cpn`, `F018-cpn-unset`, `F018-leading-trimmed` (r) rc=0; the warn-mode pair rc=0 with the binding refused. Observed `migrate.sh show`: `posture-guard: warning — Docker target locality is unverified: …` and continues. Manual `PERM-03`, `PERM-04` |
| ES-05 | Guard call deleted: presence assertion fails                                                    | Pass   | Manual `PRESENCE-01`: deleting `reset.sh`'s guard call failed the self-test (`7.8-presence-reset` among 5 failures); restored, exit 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ES-06 | Unbudgeted citation raises the count                                                            | Pass   | Manual `GATES-01`, `GATES-02`: a scratch citation raised the findings by exactly one                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

### Edge Cases

| ID    | Scenario (from plan)                                  | Result | Evidence                                                                                                                                                    |
| ----- | ----------------------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | Commented key refuses                                 | Pass   | Case 06 (r) rc=4. Manual `DAMAGED-03`                                                                                                                       |
| EC-02 | Duplicate key refuses                                 | Pass   | Cases 07, 07-spaced-key, 07-dquoted-key, 07-squoted-key (r) rc=4. Manual `DAMAGED-04`                                                                       |
| EC-03 | Conflict-marked carrier refuses, its own state        | Pass   | Case 08 (r) rc=4; reason text "carries unresolved merge conflict markers" (`posture_carrier_reason`). Manual `DAMAGED-05`                                   |
| EC-04 | Unreadable carrier refuses as absent                  | Pass   | Case 09 (r) rc=4 [mode-000 file]; a directory in its place takes the same `unreadable` state (`posture_read_carrier`, the `-f` test). Manual `DAMAGED-06`   |
| EC-05 | Damaged carrier plus valid override still refuses     | Pass   | Case 17 (r) rc=4. Manual `DAMAGED-08`                                                                                                                       |
| EC-06 | `copier.yml` plus legal carrier: carrier wins         | Pass   | Case 12 (r) rc=4. Manual `PERM-01`                                                                                                                          |
| EC-07 | Exported `DEPLOYMENT_POSTURE` ignored                 | Pass   | Case 13 (r) rc=4, 13-posture (w). Manual `PERM-02`                                                                                                          |
| EC-08 | No env file: the posture refusal shows, not the `die` | Pass   | Observed: `tests/server.sh down --volumes` in the copy, which had no `.env.test`, exited 4 with the guard prefix, not the env-file exit 2. Manual `DOWN-02` |
| EC-09 | Stack down: `--self-test` exits 0, no `docker`        | Pass   | The 15/11/2026 run: exit 0, `docker never invoked`. Manual `DOWN-03`                                                                                        |
| EC-10 | Worktree root resolves from `BASH_SOURCE`             | Pass   | Each caller: `PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"` from `BASH_SOURCE` (`reset.sh:13-14`); case `relative-source`. Manual `PERM-06`        |

### Permission and Access

**N/A — no endpoint, screen or role boundary**, as the plan recorded. The two scenarios that
behave like access control are covered above: EC-06 (TM-05) and ES-04 (TM-01).

## 4. Deviations from plan

| Deviation                                                                                                                                                                | Justification                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `DOCKER_CONTEXT` and `DOCKER_HOST` both set and disagreeing **refuse as ambiguous** (case `14d-selectors-split`) instead of the plan's `DOCKER_CONTEXT`-first precedence | **Recorded 15/11/2026 (F-002)** — the developer ruled `DOCKER_HOST` wins, a dated erratum in the story plan's Approach; the refusal fails closed under either precedence |
| Self-test harness in `_migrate-self-test.sh`, not `migrate.sh`                                                                                                           | **Recorded 15/11/2026 (F-005)** — a dated erratum in the plan's _Key Decisions_; entry point, command and dispatch order unchanged (`migrate.sh:113`)                    |
| `reset.sh`/`restore.sh` with `--force-posture` and nothing piped exit 4 at the empty prompt                                                                              | Recorded — story plan Key Decision "Where the no-tty refusal fires"; HP-04 concerns the non-prompting `down --volumes` and is unaffected                                 |
| A typed non-`yes` answer still aborts at exit 0                                                                                                                          | Recorded — TM-18 keeps the decline path unchanged and out of scope                                                                                                       |

## 5. New edge cases discovered

| ID    | Scenario                                                                                                     | Result           | Evidence                                                                                                                                                                                                                                                                                                                                                                                       | Fold back?                                                                                                        |
| ----- | ------------------------------------------------------------------------------------------------------------ | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| EC-N1 | `server.sh up --seed` with an unverifiable Docker target, or a `staging` carrier and no override             | Pass (after fix) | **Was Fail** (pre-guard `compose up -d` and password sync). Fixed on this branch 15/11/2026 (F-001): manual `REFUSE-05` (zero daemon events) and `TARGET-01`, `TARGET-03` (no pre-guard calls)                                                                                                                                                                                                 | Done — folded back as S `21-seed-guard-first-in-block`, `F001-seed-bound-before-up`, `F001-up-d-on-compose-array` |
| EC-N2 | Default context on a rootless-Docker host                                                                    | Not walked       | `posture_context_to_endpoint` and the default branch hard-code `unix:///var/run/docker.sock`; with no context selected, a rootless host is bound to a socket it does not serve and the command fails. Fail-closed, functional only                                                                                                                                                             | Findings record decides                                                                                           |
| EC-N3 | `restore.sh` with a missing backup file above `development`                                                  | Pass (as built)  | `restore.sh:89-90` exits 2 before the guard; the operator sees the argument error, not the refusal. No security effect                                                                                                                                                                                                                                                                         | No                                                                                                                |
| EC-N4 | Hostile override or context name containing terminal escapes                                                 | Pass             | `posture_quote` (`printf %q`) on every caller- or config-supplied value in a refusal                                                                                                                                                                                                                                                                                                           | No                                                                                                                |
| EC-N5 | `COMPOSE_PROJECT_NAME` set to a declared name Compose normalises (an unrendered slug token)                  | Pass (after fix) | **Was a false success** (F-018, found walking PERM-07): permitted, then `down --volumes` printed success while Compose acted on a different, empty project. Fixed on this branch 15/11/2026: refused at 4 as not a valid Compose name                                                                                                                                                          | Done — folded back as eleven H `F018-*` cases                                                                     |
| EC-N6 | `COMPOSE_PROJECT_NAME` naming another project set only in the `--env-file`, shell unset                      | Pass (after fix) | **Was a pass-through** (F-020, review R-001): the check read the shell only. Now refused at 4 with the project repair, including the `=`/`:` spellings, BOM, NBSP, quoting forms and NUL byte the re-checks found (a commented mention refuses too — an accepted, documented fail-closed residual); H `R001-*`, B `B-envfile-name-refused`, `B-envfile-name-matches`, `B-envfile-test-refused` | Done — folded back as H `R001-*` and two B cases                                                                  |
| EC-N7 | Carrier key written as `? DEPLOYMENT_POSTURE`, tagged, anchored, escaped, or followed by a continuation line | Pass (after fix) | **Was a misread** (F-021, review R-002): could read `development` where PyYAML reads `production`. Now `unrecognised`, refused at 4 — and, after the re-checks, a key hidden after a lone CR, NEL, U+2028 or U+2029 (refused as a duplicate); H `R002-*`                                                                                                                                       | Done — folded back as H `R002-*`                                                                                  |
| EC-N8 | `restore.sh` with a relative backup path, run from outside the repository root                               | Pass (after fix) | **Was data loss, pre-existing** (F-023, review R-004): the database was dropped, then the read failed. Now resolved before the `cd` and opened before the DROP; B `B-restore-relative-path`, `B-restore-relative-dropped-once`, `B-restore-missing-path`                                                                                                                                       | Done — bug report filed, status fixed                                                                             |

## 6. Deferred scenarios

| Scenario                                                                                          | Reason                                                                                                                                                                                                                         | When to address |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- |
| Manual `PERM-07` (correctly named worktree stack passes) — no scenario's Then depends on it alone | **No longer deferred.** Amended for F-018 (the name Compose normalises) and walked 15/11/2026 by Sam Bailey at `b173cba` on a provisioned worktree stack: `Pass`, not refused, containers, volumes and network removed, exit 0 | Done            |

## 7. Accessibility observations

**N/A — no rendered screen**, as the plan recorded. The refusal text is the guard's interface:
observed refusals lead with the prefix, name the posture or the carrier state, and give a
pasteable re-run (`posture_rerun`) or the concrete repair. Read as an operator would in manual
`REFUSE-01` and `DAMAGED-01`, and pasted verbatim in `OVR-01`.

## 8. GDPR & security observations

- **PII at rest / in responses / rights paths** — N/A — no personal data processed.
- **Security gate** — `../../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US006-POSTURE-GUARD-15-11-2026.md`
  and `../../10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US006-POSTURE-GUARD-15-11-2026.md`.
  The four QA-visible constraints the plan named: carrier-only read (case 13), ordering (case 12),
  damaged-carrier verdict (cases 04–10, 17) and presence (S `7.8-presence-*`; negative walked as
  `PRESENCE-01`). ES-07/EC-N1 is the security record's TM-N1 / F-001 (LOW), resolved on this branch
  15/11/2026; EC-N5 is F-018, fixed under TM-01 the same day. EC-N6 and EC-N7 are the security
  records' TM-N3 (F-020) and TM-N4 (F-021), both LOW, mitigated 15/11/2026; the workflow 23
  security pass is recorded there as the independent review. No CRITICAL or HIGH.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — every one Pass, with the row named
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified — the precedence departure (F-002) and the harness move (F-005) recorded as plan errata 15/11/2026
- [x] New edge cases recorded (EC-N1, EC-N5 to EC-N8 fixed and folded back)
- [x] Accessibility observations confirmed against the build — N/A recorded
- [x] GDPR & security observations confirmed — N/A for GDPR
- [x] Coverage floors met for all modules in scope — N/A: no pytest, no coverage figure (plan Section 6)
- [x] Manual testing sign-off — `../../18-TESTS/MANUAL/US006-MANUAL-TESTING.md` walked 70 of 70, 70 Pass, 0 Fail; countersigned by Sam Bailey 15/11/2026
- [ ] Reviewer approval — **blocks merge until complete**; no unresolved Fail (ES-07 resolved), awaiting the developer

---

## Cross-references

- `../PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — the pre-development plan verified here
- `../../02-STORIES/US006.md` — the story under review
- `../../20-FINDINGS/archive/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-001, F-002, F-005, F-018, and the workflow 23 review's F-020 to F-026
- `../../21-BUGS/BUG-RESTORE-RELATIVE-BACKUP-PATH-AFTER-DROP-15-11-2026.md` — F-023 / EC-N8
- `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the 09/10/2026 target decision and the Key Decisions cited in Section 4
- `../../18-TESTS/AUTOMATED/US006-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US006-MANUAL-TESTING.md` — downstream test records
- `../../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US006-POSTURE-GUARD-15-11-2026.md` — TM-N1 to TM-N4
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `code/docs/GATE-REPORTING.md` — why "pending walk" is never written as Pass
