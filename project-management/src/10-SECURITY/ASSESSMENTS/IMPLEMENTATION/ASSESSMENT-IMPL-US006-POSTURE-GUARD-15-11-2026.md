# Security Posture Assessment (Implementation) — US006 The deployment-posture guard

| Field           | Value                                                                                                                                               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US006 — The destructive dev scripts read the deployment posture, and refuse to run above development                                                |
| **Date**        | 15/11/2026                                                                                                                                          |
| **Verified by** | Claude Code — `security` skill, Opus, `22-implementation-documentation` Step 3                                                                      |
| **Sprint**      | SPRINT-04                                                                                                                                           |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` (amended 09/10/2026 and 15/11/2026)                                                            |
| **Outcome**     | PASS with deferred items — 12 of 12 constraints closed; F-001 (TM-N1) fixed and F-002 ruled 15/11/2026; the compose-name gap F-018 fixed under 7.12 |

---

## 1. Scope

Matches the plan, with the two additions the story recorded at gate 10: `seed-dev.sh` and
`server.sh up --seed` bound. Evidence is the shipped shell, the self-test
(`bash code/src/scripts/database/migrate.sh --self-test`, 15/11/2026: exit 0, every case `PASS`,
`docker never invoked`) and a walk of a disposable `git archive HEAD` copy with a recording
`docker` and synthetic `DOCKER_CONFIG` — the method `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US006-POSTURE-GUARD-15-11-2026.md`
Section 1 describes.

**Updated 15/11/2026, after the closeout — two fixes on this branch, uncommitted at the time of
writing:** **F-001** below (guard and bind ahead of `up -d` on the `--seed` path) and **F-018**
from the findings record (the compose-name allowlist compares names as Compose normalises them).
Self-test after both: exit 0, **184 of 184**, `docker never invoked`.

| File                                                    | Purpose                                                        |
| ------------------------------------------------------- | -------------------------------------------------------------- |
| `code/src/scripts/_lib/posture-guard.sh`                | The control: carrier read, target resolution, verdict, binding |
| `code/src/scripts/database/{reset,restore,seed-dev}.sh` | Refusing callers                                               |
| `code/src/scripts/development/server.sh`                | Refusing on `down --volumes` and `up --seed`                   |
| `code/src/scripts/tests/server.sh`                      | Refusing on `down --volumes`                                   |
| `code/src/scripts/database/migrate.sh`                  | Warn-mode caller and `--self-test` entry                       |
| `code/src/scripts/database/_migrate-self-test.sh`       | The proof — H cases both modes, S line-order cases             |
| `.github/workflows/test-e2e.yml`                        | The CI teardown                                                |

**No code audit consumed.** `ASSESSMENTS/IMPLEMENTATION/CLAUDE.md` names the
`../../AUDITS/IMPLEMENTATION/` run as an input; none exists for US006, because the story plan
records that `AUDITS/` does not fire for a story with no runtime surface and no `AUDIT-PLAN` was
written. This record and the threat-model review stand in for it; the tension is routed to the
findings record rather than resolved here.

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status  | Evidence / Notes                                                                                                                                                                                                     |
| -------- | ------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | PASS    | TM-04, TM-05, TM-09, TM-15 closed (cases 13, 12, `20-*`, `posture_quote`). TM-01 closed on all six refusing paths since the F-001 fix (15/11/2026; Section 4); compose-name allowlist hardened by F-018 (H `F018-*`) |
| A02:2025 | Security Misconfiguration             | PASS    | TM-02, TM-08 — `posture_read_carrier` (cases 04-_, 06, 07-_, 08); TM-03 — S `7.8-presence-*` for all six callers                                                                                                     |
| A03:2025 | Software Supply Chain Failures        | N/A     | No dependency added; `jq` deliberately avoided (`posture_saved_context` parses by hand)                                                                                                                              |
| A04:2025 | Cryptographic Failures                | N/A     | No secret read, written or compared by the guard                                                                                                                                                                     |
| A05:2025 | Injection                             | PASS    | TM-10 — `test-e2e.yml:142`, no `\|\| true`, owner at `:133-139`; TM-11 — `$root/copier.yml`, absolute root required. Hostile override and context names pass through `printf %q` before reaching the terminal        |
| A06:2025 | Insecure Design                       | PASS    | TM-06 (`posture_unconfirmed`, cases 18-*), TM-07 (Step 1 before Step 2, case 17), TM-13 (`\|\| exit "$?"`, S `7.7-terminates-*`); TM-14 a tracked residual                                                           |
| A07:2025 | Authentication Failures               | N/A     | No principal; unchanged from the plan                                                                                                                                                                                |
| A08:2025 | Software and Data Integrity Failures  | PARTIAL | TM-12 residual by decision — `migrate.sh fake` warns and proceeds at every posture                                                                                                                                   |
| A09:2025 | Security Logging & Alerting Failures  | PARTIAL | TM-17, TM-18 closed (line-order S cases; exit 4 plus prefix). TM-16 accepted residual — the override is still written nowhere                                                                                        |
| A10:2025 | Mishandling of Exceptional Conditions | PASS    | Damaged, unreadable and malformed inputs all refuse (cases 04–10, 14d-*); outputs cleared at entry and on refusal (`bind-unvalidated`, `posture_clear_binding`); `set-euo-permit`/`set-euo-warn`                     |

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status | Evidence                                                                                                                               |
| --- | -------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS   | `.claude/CLAUDE.md` Section 0 now has an enforcement point in `code/src/scripts/`; the CI literal's owner is written beside it         |
| ID  | Identify | PASS   | Six boundaries confirmed, one added (TB7, parent to child) — threat-model review Section 2                                             |
| PR  | Protect  | PASS   | Constraints 7.1–7.12 closed; `up --seed`'s pre-guard calls fixed 15/11/2026 (F-001)                                                    |
| DE  | Detect   | PASS   | Moved off Open: the presence assertion ships (S `7.8-presence-*`). Its deletion negative is manual `PRESENCE-01`, `Pass`               |
| RS  | Respond  | PASS   | Exit 4 and `posture-guard: refused —` on every refusal (`posture_say`); every refusal case asserts both                                |
| RC  | Recover  | PASS   | Moved off Open: a damaged-carrier refusal names the file, the key and the three legal values (`posture_guard` Step 5; cases 04–10, 17) |

## 4. Findings

| ID    | STRIDE | OWASP      | NIST CSF | Severity | Finding                                                                                                                                                                                                                                                                         | Recommendation                                                                                                                  | Status                                                                                                                                                                                                            |
| ----- | ------ | ---------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F-001 | S, T   | `A01:2025` | `PR.PS`  | LOW      | `development/server.sh` runs `compose up -d` (`:175`) and `_sync_db_password`'s `exec -T db psql` (`:176`) on the ambient Docker selection before the `up --seed` guard at `:183`. Walked: saved remote context → exit 4, both calls recorded first. Contradicts `US006.md:499` | Guard and bind before the `up` arm's first Docker call when `--seed` is set; keep `up --build` unbound (case 21); add an S case | **Resolved 15/11/2026** — fixed on this branch: guard `server.sh:138`, bind `:140`, then `up -d`; S `F001-seed-bound-before-up`, `F001-up-d-on-compose-array`; ES-07, REFUSE-05 and TARGET-01 to TARGET-04 `Pass` |
| F-002 | S      | `A01:2025` | `PR.PS`  | INFO     | Both selectors set and disagreeing refuse as ambiguous (`posture_resolve_target`; case `14d-selectors-split`) rather than following the plan's `DOCKER_CONTEXT`-first precedence. Stricter, but no decision records it                                                          | Developer records the decision (plan amendment or ADR erratum); until then a row asserting the plan's precedence is a Fail      | **Resolved 15/11/2026** — `DOCKER_HOST` wins, the dated erratum in the plan's Approach                                                                                                                            |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Planning-phase findings — status update

| Plan finding | Status              | Evidence / Notes                                                                                                                                      |
| ------------ | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01        | Resolved            | `posture_resolve_target`, `posture_docker_bind`; cases 14a–14e both modes; `up --seed` closed by F-001; compose-name normalisation F-018 (H `F018-*`) |
| TM-02        | Resolved            | `posture_read_carrier`; cases 06, 04-inline-comment                                                                                                   |
| TM-03        | Resolved            | S `7.8-presence-*` × 6; negative `PRESENCE-01` `Pass`                                                                                                 |
| TM-04        | Resolved            | Case 13                                                                                                                                               |
| TM-05        | Resolved            | Step 4 before Step 5; case 12                                                                                                                         |
| TM-06        | Resolved            | `posture_unconfirmed`; case 18-prompt-staging; S `18-empty-read-*`                                                                                    |
| TM-07        | Resolved            | Case 17; repair text in Step 5                                                                                                                        |
| TM-08        | Resolved            | Case 08                                                                                                                                               |
| TM-09        | Resolved            | S `20-*`                                                                                                                                              |
| TM-10        | Resolved            | `test-e2e.yml:133-142`                                                                                                                                |
| TM-11        | Resolved            | Absolute-root check; case `relative-source`                                                                                                           |
| TM-12        | Residual            | Warn-only by decision                                                                                                                                 |
| TM-13        | Resolved            | S `7.7-terminates-*`; `set-euo-*`                                                                                                                     |
| TM-14        | Residual            | N-001                                                                                                                                                 |
| TM-15        | Resolved            | One key extracted; `posture_quote`                                                                                                                    |
| TM-16        | Residual            | Accepted                                                                                                                                              |
| TM-17        | Resolved            | Line-order S cases; guards above env-file checks                                                                                                      |
| TM-18        | Resolved            | Exit 4 plus prefix                                                                                                                                    |
| F-001, F-002 | Resolved 15/11/2026 | Section 4                                                                                                                                             |

## 6. Plan gaps closed & deferred items

| Item                                                                                                                                                           | Status | Evidence / Blocked by                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **7.1** Carrier-only read                                                                                                                                      | Closed | No `${DEPLOYMENT_POSTURE:-…}` in `posture-guard.sh`; case 13 (refuse rc=4), `13-posture` (warn)                                                                                                                                                                                                                                                                                                                                                                  |
| **7.2** Anchored, quote-tolerant, comment-rejecting; duplicate/conflict refuse                                                                                 | Closed | `posture_read_carrier`; cases 01-single-quoted, 01-double-quoted, 04-inline-comment, 06, 07, 07-spaced-key, 07-dquoted-key, 07-squoted-key, 08                                                                                                                                                                                                                                                                                                                   |
| **7.3** `copier.yml` `$PROJECT_ROOT`-anchored                                                                                                                  | Closed | `[[ -f "$root/copier.yml" ]]`; non-absolute root refuses; callers derive root from `BASH_SOURCE`                                                                                                                                                                                                                                                                                                                                                                 |
| **7.4** Carrier before template proof                                                                                                                          | Closed | `posture_guard` Step 4 precedes Step 5; case 12                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **7.5** Override validated first; not honoured in any damaged or unrecognised state                                                                            | Closed | Step 1; cases `override-invalid`, 04, 17; refusal text "--force-posture is not honoured while no posture can be read"                                                                                                                                                                                                                                                                                                                                            |
| **7.6** Empty read above development refuses at 4; override satisfies the guard without a tty                                                                  | Closed | `posture_unconfirmed` via `reset.sh:134`, `restore.sh:135`; cases 18, 18-prompt-staging, 19. With an override and nothing piped the prompt exits 4 — the Key Decision "Where the no-tty refusal fires"; a typed non-`yes` aborts at 0 (TM-18, unchanged)                                                                                                                                                                                                         |
| **7.7** Explicit branch, terminates on refusal                                                                                                                 | Closed | `\|\| exit "$?"` at every call and bind; S `7.7-terminates-*` incl. seed branch and shell-out                                                                                                                                                                                                                                                                                                                                                                    |
| **7.8** Presence asserted by line order                                                                                                                        | Closed | S `7.8-presence-{reset,restore,seed-dev,development-server,tests-server,migrate}`; negative `PRESENCE-01` `Pass`                                                                                                                                                                                                                                                                                                                                                 |
| **7.9** `up --seed` and `seed-dev.sh` bound; flag forwarded verbatim                                                                                           | Closed | `server.sh:138-140` and the seed hand-off; `seed-dev.sh:85,97`; S `20-forwards-override`, `20-seed-dev-parses-first`, `20-pins-child-host`                                                                                                                                                                                                                                                                                                                       |
| **7.10** No `\|\| true`; owner and trigger beside the literal                                                                                                  | Closed | `test-e2e.yml:133-142`                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| **7.11** Posture and re-run where readable; reason and concrete repair where not                                                                               | Closed | Step 4 message with `posture_rerun` (drops any earlier `--force-posture`, both forms); Step 5 message names file, key and the three values                                                                                                                                                                                                                                                                                                                       |
| **7.12** Effective target from local metadata; bind every guarded-path call; five refuse before any daemon operation; migrate warns with no fabricated binding | Closed | `posture_resolve_target`, `posture_saved_context`, `posture_docker_bind`; cases 14a–14e both modes, `14-*` S cases on all six callers. `up --seed` refuses before `up -d` and the password sync since the F-001 fix (15/11/2026). **F-018, fixed 15/11/2026:** `COMPOSE_PROJECT_NAME` is compared with the declared `name:` as Compose normalises it; a name Compose would reject, or a declared name normalising to empty, refuses at 4 — nine H `F018-*` cases |

## 7. Deviations from plan

- **Precedence when both selectors are set (F-002)** — refuses as ambiguous instead of
  `DOCKER_CONTEXT` first. Justified in the code comment by observed Docker 29.9.2 behaviour;
  **Ruled 15/11/2026:** `DOCKER_HOST` wins, recorded as a dated erratum in the plan's Approach — an
  amendment now, not a departure.
- **Self-test location** — the harness is `_migrate-self-test.sh`, sourced only on `migrate.sh`'s
  `--self-test` arm (`:113`), not inline in `migrate.sh`. Entry point, command and dispatch order
  are as planned, so no security property moves; the reason for the split is not recorded in
  this assessment's inputs and is left to the findings record.
- **7.6 with an override and nothing piped** — exits 4 at the empty prompt; covered by the story
  plan's Key Decision "Where the no-tty refusal fires", so an amendment, not a departure.
- **Restore validates its argument first** — `restore.sh:89-90` exits 2 on a missing backup file
  before the guard. Not a security weakening; noted so a reader expecting the refusal is not
  surprised.

## 8. Sign-off

| Reviewer                             | Role                         | Date       |
| ------------------------------------ | ---------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Security review (author)     | 15/11/2026 |
| <%DEVELOPER_NAME%>                   | Developer — countersignature | _pending_  |

Independent review is outstanding; reported open per `.ai/INSTRUCTIONS.md`.

**Overall verdict:** the story meets the baseline's posture targets; the one LOW exception on
`server.sh up --seed` was fixed 15/11/2026 (F-001), and the compose-name gap (F-018) with it. No
CRITICAL or HIGH was introduced. DE and RC, the two functions the plan
left Open, now carry shipped controls.

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` — the baseline answered here
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US006-POSTURE-GUARD-15-11-2026.md` — the threat review consumed here (TM-N1 = F-001, TM-N2 = F-002)
- `../../AUDITS/IMPLEMENTATION/` — no US006 audit; Section 1 says why
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated
- `../../../02-STORIES/US006.md` — the source story
- `../../../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-001, F-002, F-018
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
