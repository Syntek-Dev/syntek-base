# US006 — Test Status

_The automated-test record for US006: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4. The story ships Bash only — a posture guard and its six callers — so no pytest test or Bruno request can declare it. Its automated proof is the `migrate.sh --self-test` harness, which no story marker can attribute; Sections 2 and 3 carry that run case by case rather than leaving the record empty (the Guardrails of this folder's `CLAUDE.md`)._

**Last Updated**: 15/11/2026 · **Story**: US006 · **Status**: Partial

- **Story:** `../../02-STORIES/US006.md` — the destructive dev scripts read the deployment posture, and refuse to run above development
- **Story plan:** `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the code master this record closes the loop on
- **Branch:** `us006/posture-guard`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US006
```

**Read Section 3 before this block.** No test declares US006, and none could: the story changes
no Python and no Bruno path. The coverage figures below come from the **whole-project** report
artefacts already on disk (`code/src/scripts/tests/reports/`; `coverage.xml` last written
15/11/2026 by a run this records pass did not make), not from anything this story ran or touched —
the defect filed as
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`.

The floors are **one floor, not one per layer** — template, django-component and HTMX-partial
tests are pytest tests and count towards the same number as the rest of the backend. On
`staging` and `main` the pre-PR gate raises every floor to **80%**, so a story green locally can
still block the PR if a module in scope sits between its floor and 80%. **Auth-critical** means
any module in the authentication, session or permission path.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact | Tests | Result              | Coverage   |
| ---------- | --------------- | ----- | ------------------- | ---------- |
| **Totals** |                 | **0** | **0 Pass / 0 Fail** | **100.0%** |

_No test declares `US006`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

### 1.2 Coverage vs floors

| Scope                       | Floor | This story                                       | Met? |
| --------------------------- | ----- | ------------------------------------------------ | ---- |
| All modules — line + branch | 75%   | 100.0% line / 100.0% branch                      | Yes  |
| Auth-critical modules       | 90%   | _{state the modules in scope and their figures}_ | _{}_ |

_The line floor above is read from `pyproject.toml`; the 90% auth floor is not machine-readable and is stated by `code/docs/testing/COVERAGE.md`, which owns both. The auth-critical row is not derivable either — which modules sit in the authentication, session and permission path is a judgement. Name them and read their figures from the per-module table below._

| Module                                           | Statements | Missed | Branch | Cover  |
| ------------------------------------------------ | ---------- | ------ | ------ | ------ |
| `code/src/django/apps/core/apps.py`              | 4          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/management/base.py`   | 17         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/middleware.py`        | 23         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/schemas.py`           | 8          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/services/errors.py`   | 20         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/templatetags/core.py` | 7          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/apps.py`            | 3          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/checks.py`          | 51         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/urls.py`            | 5          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/views.py`           | 24         | 0      | 100.0% | 100.0% |

### 1.3 Tests by module

_No attributed tests to list for US006._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story, so there is nothing to run before the
generator. The story's automated proof is the self-test, run through its project script. It needs
**no stack** and invokes no `docker`: every fixture lives under one `mktemp -d` tree removed by its
trap, a recording `docker` heads `PATH` and must never be called, and stdin is `/dev/null` so the
no-tty cases run in the state they name.

```bash
# The self-test — helper cases, both modes, then the six callers' structural cases
bash code/src/scripts/database/migrate.sh --self-test </dev/null

# The story-marker audit — read before trusting the empty table in Section 1
bash code/src/scripts/audits/story-markers.sh

# Then rewrite this file's generated block:
bash code/src/scripts/tests/test-record.sh US006
```

ShellCheck has **no project script** — `syntax/lint.sh` carries no shell leg, and no CI job or
lefthook entry runs it (`../../02-STORIES/US006.md`, _QA Acceptance Criteria — Automated_). It was
run by hand, from the repository root, over the helper, the self-test harness and the six callers:

```bash
shellcheck -x \
  code/src/scripts/_lib/posture-guard.sh \
  code/src/scripts/database/_migrate-self-test.sh \
  code/src/scripts/database/reset.sh code/src/scripts/database/restore.sh \
  code/src/scripts/database/seed-dev.sh code/src/scripts/database/migrate.sh \
  code/src/scripts/development/server.sh code/src/scripts/tests/server.sh
```

**This pass, 15/11/2026,** on `us006/posture-guard` at `fbd9dbc` (P0 to P4 committed) **plus the
F-001 fix** in `development/server.sh` and `database/_migrate-self-test.sh` **and the
F-018 fix** in `_lib/posture-guard.sh` and `database/_migrate-self-test.sh`, both since committed
in `0a6db24`. Every run below was repeated after both fixes, last on 15/11/2026:

| Run                          | Result                                                                                                                                                                                                                                                                                             |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `migrate.sh --self-test`     | **Exit 0**, `✓ self-test passed`. **186 checks, 186 PASS, 0 FAIL**: 125 helper-driven (H) checks, eleven of them the F-018 cases (two added for interpolated and non-ASCII declared names), 60 structural (S) checks, and the closing `docker never invoked`. The banner read `stdin is a tty: no` |
| ShellCheck 0.11.0 (`-x`)     | **Exit 1** — 4 findings, all `SC2015 (info)`, none in the helper or the harness. Every `# shellcheck source=` directive resolved (no `SC1091`). At `-S warning`: exit 0. Detail in Section 2.2                                                                                                     |
| `audits/story-markers.sh`    | Exit 0 (warn-only): "Scanned 9 test module(s) and 7 Bruno request(s). 0 carry a story marker; 72 do not." — 65 pytest cases and 7 `.bru` files. None of the 72 is a US006 test, because the story wrote none                                                                                       |
| `tests/test-record.sh US006` | Exit 0, `wrote 0 test rows`, reading `code/src/scripts/tests/reports`, re-run after the F-018 fix. The block in Section 1 is its output, unedited                                                                                                                                                  |

### 2.1 The self-test, case by case

Case numbers are the proof-case list of `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`
(_The proof-case list, and how each case is proved_). **Mode** is the guard mode the case ran in:
`refuse` is the five destroying callers' mode, `warn` is `migrate.sh`'s. **rc** is the guard's
observed return; a `refuse`-mode permit case returns `0` by design. A refusal passes only on return
`4` **and** the `posture-guard: refused —` prefix **and** cleared binding outputs together; a permit
only on `0` with no refusal line. Every case preloads stale outputs, so each also proves the outputs
are cleared at entry.

#### Top-level cases 1 to 19, helper-driven

| Case | What it proves                                                                                | refuse rc | warn rc | Result | Variant checks, same run (all PASS)                                                                                                                      |
| ---- | --------------------------------------------------------------------------------------------- | --------- | ------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | `development` carrier permits, binds the default socket                                       | 0         | 0       | Pass   | `01-single-quoted`, `01-double-quoted` (refuse, 0); `01-posture` (warn prints `posture: development`)                                                    |
| 2    | `staging`, no override, refuses naming `--force-posture staging`                              | 4         | 0       | Pass   | `02-posture` (warn prints `posture: staging`)                                                                                                            |
| 3    | `production`, no override, refuses naming `--force-posture production`                        | 4         | 0       | Pass   | `03-posture` (warn prints `posture: production`, binds the default socket)                                                                               |
| 4    | Unrecognised value refuses with the repair, echoing no carrier text                           | 4         | 0       | Pass   | `04-inline-comment`, `04-no-space`, `04-quoted-key` (refuse, 4)                                                                                          |
| 5    | No `DEPLOYMENT_POSTURE` line refuses with the repair                                          | 4         | 0       | Pass   | —                                                                                                                                                        |
| 6    | A commented-only key refuses                                                                  | 4         | 0       | Pass   | —                                                                                                                                                        |
| 7    | A duplicated key refuses                                                                      | 4         | 0       | Pass   | `07-spaced-key`, `07-dquoted-key`, `07-squoted-key` (refuse, 4); `07-spaced-key` (warn prints `posture: unknown`, never `development`)                   |
| 8    | A conflict-marked key refuses                                                                 | 4         | 0       | Pass   | —                                                                                                                                                        |
| 9    | A present-but-unreadable carrier refuses                                                      | 4         | 0       | Pass   | Ran in its `mode-000 file` form (this process could not read it)                                                                                         |
| 10   | An absent carrier refuses                                                                     | 4         | 0       | Pass   | `10-posture` (warn prints `posture: unknown` and the repair)                                                                                             |
| 11   | `copier.yml` at the root and no legal posture — the template proof — permits                  | 0         | 0       | Pass   | `11-posture` (warn prints `posture: unknown (template repository`)                                                                                       |
| 12   | `copier.yml` **and** a legal `production` carrier — the carrier wins and refuses              | 4         | 0       | Pass   | —                                                                                                                                                        |
| 13   | `DEPLOYMENT_POSTURE=development` exported against a `production` carrier still refuses        | 4         | 0       | Pass   | `13-posture` (warn prints `production`, never `development`)                                                                                             |
| 15   | `--force-posture` naming the live posture permits                                             | 0         | 0       | Pass   | —                                                                                                                                                        |
| 16   | `--force-posture` naming a stale posture refuses, suggesting only the live one                | 4         | 0       | Pass   | Asserts no stale `--force-posture` value leaks into the suggested command                                                                                |
| 17   | A well-formed override against a damaged carrier refuses — **not honoured**, names no posture | 4         | 0       | Pass   | —                                                                                                                                                        |
| 18   | No tty, above `development`, no override, refuses                                             | 4         | 0       | Pass   | `18-prompt-staging` (4, "no confirmation"); `18-prompt-development` and `18-prompt-template` (0) — an unanswered prompt refuses only above `development` |
| 19   | No tty, above `development`, a valid override, permits                                        | 0         | 0       | Pass   | —                                                                                                                                                        |

Case 14 is subdivided below; cases 20 and 21 are structural. Every warn-mode run of cases 1 to 19
also asserted the `expand-then-contract` obligation and a line carrying the `posture-guard:` prefix.

#### Case 14 — effective Docker target, 14a to 14e, both modes

A `development` carrier unless the subcase says otherwise, so only the target can refuse. Every
subcase ran in **both** modes: denied in `refuse` means warned in `warn`, with no stale binding.

| Subcase               | Fixture                                                                                              | refuse rc | warn rc | Result |
| --------------------- | ---------------------------------------------------------------------------------------------------- | --------- | ------- | ------ |
| `14a-remote-host`     | `DOCKER_HOST=ssh://…`                                                                                | 4         | 0       | Pass   |
| `14a-remote-context`  | `DOCKER_CONTEXT` naming a `tcp://` context                                                           | 4         | 0       | Pass   |
| `14a-tcp-loopback`    | `DOCKER_HOST=tcp://127.0.0.1:2375` — loopback TCP is not a known local socket                        | 4         | 0       | Pass   |
| `14a-compose-name`    | `COMPOSE_PROJECT_NAME` not the declared compose name                                                 | 4         | 0       | Pass   |
| `14a-override-noop`   | A valid `production` override does not lift a remote-target refusal                                  | 4         | 0       | Pass   |
| `14a-template-noop`   | The template proof does not lift a remote-target refusal                                             | 4         | 0       | Pass   |
| `14b-saved-remote`    | Saved `currentContext` remote, both selector variables unset                                         | 4         | 0       | Pass   |
| `14b-saved-case`      | Saved key spelt `CurrentContext` — Docker reads it case-insensitively, so it still selects           | 4         | 0       | Pass   |
| `14c-named-local`     | Named local Unix-socket context via `DOCKER_CONTEXT` — permits and binds that socket                 | 0         | 0       | Pass   |
| `14c-saved-local`     | The same context persisted as `currentContext` — permits and binds                                   | 0         | 0       | Pass   |
| `14d-unknown-ctx`     | `DOCKER_CONTEXT` naming no context                                                                   | 4         | 0       | Pass   |
| `14d-malformed-cfg`   | `config.json` not JSON                                                                               | 4         | 0       | Pass   |
| `14d-case-dup-cfg`    | Two case-variant `currentContext` keys                                                               | 4         | 0       | Pass   |
| `14d-escaped-key`     | A `\u`-escaped key spelling                                                                          | 4         | 0       | Pass   |
| `14d-ambiguous-cfg`   | A second, nested `currentContext`                                                                    | 4         | 0       | Pass   |
| `14d-unreadable-cfg`  | `config.json` unreadable (`mode-000 file` form)                                                      | 4         | 0       | Pass   |
| `14d-no-endpoint`     | Context metadata with no Docker endpoint                                                             | 4         | 0       | Pass   |
| `14d-inspect-fails`   | Context inspection fails                                                                             | 4         | 0       | Pass   |
| `14d-relative-sock`   | A relative socket path                                                                               | 4         | 0       | Pass   |
| `14d-empty-sock`      | An empty socket path                                                                                 | 4         | 0       | Pass   |
| `14d-selectors-split` | `DOCKER_CONTEXT` and `DOCKER_HOST` both set and disagreeing — refused as ambiguous                   | 4         | 0       | Pass   |
| `14e-drift`           | Bind, then change the selectors: the binding already handed out does not re-resolve; re-bind refused | 4         | 0       | Pass   |

`14d-selectors-split` **passes as the code was written and as the plan's 15/11/2026 erratum records it** — Section 3,
first row.

#### Extra helper cases, beyond the twenty-one

| Case                                                                                          | Mode          | rc    | Result | What it proves                                                                                                                                          |
| --------------------------------------------------------------------------------------------- | ------------- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `override-invalid`                                                                            | refuse / warn | 4 / 0 | Pass   | `--force-posture prod` refuses naming the three legal values **before** the carrier is read (plan step 1)                                               |
| `bind-unvalidated`                                                                            | refuse        | 4     | Pass   | Binding with no validated target refuses and leaves the Docker array empty, never a stale one                                                           |
| `above-dev-production` · `above-dev-staging` · `above-dev-development` · `above-dev-template` | refuse        | 0     | Pass   | `posture_above_development` answers yes, yes, no, no                                                                                                    |
| `compose-name-base` · `-override` · `-silent-last` · `-squoted` · `-nested-only` · `-missing` | refuse        | 0     | Pass   | The compose name handed to the guard: last declaring file wins; a nested `name:` or none yields empty                                                   |
| `set-euo-permit` · `set-euo-warn`                                                             | refuse / warn | 0 / 0 | Pass   | Sourced into a `set -euo pipefail` script, a permit and a fully degraded warn both run on                                                               |
| `relative-source`                                                                             | —             | 0     | Pass   | Sourced by a bare relative name into a strict shell, the helper still finds its sibling conflict-marker library                                         |
| `F018-raw-declared-cpn`                                                                       | refuse / warn | 4 / 0 | Pass   | F-018: `COMPOSE_PROJECT_NAME` equal to a raw declared name Compose would rewrite is refused as not a valid Compose name (warn: warned, binding refused) |
| `F018-normalised-cpn`                                                                         | refuse        | 0     | Pass   | F-018: the name Compose actually uses — the declared name normalised — is permitted and binds                                                           |
| `F018-cpn-unset`                                                                              | refuse        | 0     | Pass   | F-018: no `COMPOSE_PROJECT_NAME`, a declared name needing normalisation, permits                                                                        |
| `F018-different-cpn`                                                                          | refuse        | 4     | Pass   | F-018: a mismatched name is refused, and the reason names the project Compose would use                                                                 |
| `F018-leading-trimmed`                                                                        | refuse        | 0     | Pass   | F-018: leading `_` and `-` are trimmed before comparing, as Compose does                                                                                |
| `F018-empty-normalised`                                                                       | refuse / warn | 4 / 0 | Pass   | F-018: a declared name that normalises to empty fails the target check closed (warn: binding refused)                                                   |
| `F018-empty-norm-cpn`                                                                         | refuse        | 4     | Pass   | F-018: the same, with `COMPOSE_PROJECT_NAME` set                                                                                                        |
| `docker never invoked`                                                                        | —             | —     | Pass   | The recording `docker` on `PATH` recorded no call across the whole run                                                                                  |

#### Structural cases — the six callers' wiring

Line-order assertions over each caller's own text (story 7.8); comment lines never count. **60
checks, 60 PASS.**

| Caller                  | Checks | Cases                                                                                                                                                                                                                                                                                                                                                                                                 |
| ----------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `database/reset.sh`     | 9      | `7.8-presence`, `7.7-terminates`, `14-binding`, `14-no-bare-docker`, `7.8-one-guard`, `14-no-repin`, `14-no-reselect`, `yes-inert`, `18-empty-read`                                                                                                                                                                                                                                                   |
| `database/restore.sh`   | 9      | The same nine                                                                                                                                                                                                                                                                                                                                                                                         |
| `database/seed-dev.sh`  | 8      | `7.8-presence`, `7.7-terminates`, `14-binding`, `14-no-bare-docker`, `7.8-one-guard`, `14-no-repin`, `14-no-reselect`, **`20-seed-dev-parses-first`**                                                                                                                                                                                                                                                 |
| `development/server.sh` | 16     | `7.8-presence`, `7.8-down-volumes-only`, `7.7-terminates`, `14-binding`, `14-no-bare-docker`, `14-no-repin`, `global-flag`, **`21-seed-guard-first-in-block`**, **`F001-seed-bound-before-up`**, **`F001-up-d-on-compose-array`**, `7.7-terminates-seed-branch`, **`20-forwards-override`**, **`20-pins-child-host`**, `7.7-terminates-shell-out`, **`21-dev-two-guards-only`**, `14-dev-no-reselect` |
| `tests/server.sh`       | 9      | `7.8-presence`, `7.8-down-volumes-only`, `7.7-terminates`, `14-binding`, `14-no-bare-docker`, `14-no-repin`, `global-flag`, `7.8-tests-one-guard`, `14-tests-no-reselect`                                                                                                                                                                                                                             |
| `database/migrate.sh`   | 9      | `7.8-presence`, `7.7-terminates`, `14-binding`, `14-no-bare-docker`, `7.8-migrate-one-guard`, `14-no-repin`, `14-no-reselect`, `help-before-guard`, `help-clean`                                                                                                                                                                                                                                      |

Cases **20** and **21** and the **F-001** ordering are proved here by S alone — seven checks
between them, in bold. **F-001's three** replaced the pre-fix `21-up-bound-on-seed-only` and
`14-seed-branch-no-compose`, which asserted the old order (unbound `up -d` before the `--seed`
guard) and were made to fail first: run against the unfixed `server.sh`, the new set exited 1 with
4 failures. Now `21-seed-guard-first-in-block` asserts the guard is the first statement under the
`up --seed` block; `F001-seed-bound-before-up` asserts the strict order `--seed` block → guard →
bind → `DOCKER=` → env-file check → `DC=` → `up)` → `up -d` → `_sync_db_password` → seed hand-off,
so every Docker call on that path is pinned and a refusal lands before any daemon operation
(`US006.md:499`); `F001-up-d-on-compose-array` asserts `up -d` runs on the bound `"${DC[@]}"`.
`21-dev-two-guards-only` still requires exactly two guard calls, so `up` without `--seed` stays
unguarded (case 21), and `14-no-repin-development-server` now allows only the `--seed` and `DC=`
assignments after the first `DOCKER=`. **Case 18**'s
S half is `18-empty-read` on the two prompting scripts: the empty-read path terminates at `4`, never
`0`.

### 2.2 ShellCheck, as run

ShellCheck **0.11.0** (`/run/current-system/sw/bin/shellcheck`, the version the P0 baseline
recorded), `-x`, default severity, over the eight files above:

| File                                                            | Finding                                               | Line | Origin                               |
| --------------------------------------------------------------- | ----------------------------------------------------- | ---- | ------------------------------------ |
| `code/src/scripts/_lib/posture-guard.sh`                        | None                                                  | —    | —                                    |
| `code/src/scripts/database/_migrate-self-test.sh`               | None                                                  | —    | —                                    |
| `code/src/scripts/database/reset.sh`                            | `SC2015 (info)` — `A && B \|\| C` is not if-then-else | 177  | `ee5c2bb`, 01/08/2026 — before US006 |
| `code/src/scripts/database/restore.sh`                          | `SC2015 (info)`                                       | 85   | `f0681f2`, 18/04/2026 — before US006 |
| `code/src/scripts/development/server.sh`                        | `SC2015 (info)`                                       | 227  | `f0681f2`, 18/04/2026 — before US006 |
| `code/src/scripts/tests/server.sh`                              | `SC2015 (info)`                                       | 171  | `ee5c2bb`, 01/08/2026 — before US006 |
| `code/src/scripts/database/seed-dev.sh` · `database/migrate.sh` | None                                                  | —    | —                                    |

**Exit 1 is not "ShellCheck clean"** (`code/docs/GATE-REPORTING.md`). The four findings are
info-severity, carried unchanged from the P0 tree (`fc10bcc`: the same four `SC2015` over the six
callers), and none lies on a line this story wrote. The six `# shellcheck source=` directives to
`_lib/posture-guard.sh` all resolved. Run at `-S warning` the same eight files exit 0.

---

## 3. Outstanding gaps and flaky tests

| Item                                        | Type                    | Reason / owner                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Selector precedence — `14d-selectors-split` | Departure, now recorded | The plan resolved "non-empty `DOCKER_CONTEXT`, otherwise non-empty `DOCKER_HOST`" (_09/10/2026 decision_). The helper **refuses** when both are set and disagree, because the Docker CLI it was built against (29.9.2) lets `DOCKER_HOST` win. **Resolved 15/11/2026 (F-002):** the developer ruled `DOCKER_HOST` wins, recorded as a dated erratum in the plan's Approach; the refusal fails closed under either precedence. No longer a Fail against the plan                                            |
| Cases **20** and **21**                     | Proved S + M only       | By design (plan's proof-case table): no H half exists, because the fixture seam reaches the helper and not the callers. The S checks above prove the text — the forward is present, `seed-dev.sh` parses the flag first, `up` is guarded on `--seed` only and bound before `up -d`. That the flag actually crosses the shell-out and `up --build` actually proceeds is proved by `../MANUAL/US006-MANUAL-TESTING.md` rows SEED-01 and SEED-03, both `Pass` on a disposable us006 stack after the F-001 fix |
| Case 14 end-to-end binding                  | Proved H + S + M        | H proves the resolver over synthetic metadata; S proves each caller consumes the validated array. That preflight, Compose calls and seed forwarding go to the bound endpoint — `up --seed`'s `up -d` and password sync included since the F-001 fix — is TARGET-01 to TARGET-05 in the manual guide, all `Pass`                                                                                                                                                                                            |
| ShellCheck "clean"                          | Not met as written      | Exit 1 on 4 pre-existing `SC2015 (info)` (Section 2.2). The helper and harness are clean; the story's criterion says "clean over the helper and its six callers" and the callers are not, at info severity. No project script runs ShellCheck, so this was run by hand and is recorded as run                                                                                                                                                                                                              |
| Every pytest, Bruno, E2E and axe suite      | Out of scope            | No Python, template or API path changed. The CI teardown change (`.github/workflows/test-e2e.yml`, `--force-posture development`, no `\|\| true`) is exercised only when that workflow runs, which this pass did not do; manual rows CI-01 and CI-02 cover it                                                                                                                                                                                                                                              |
| Coverage figures in Section 1.2             | Not attributable        | The 100.0% line and branch figures and "Met? Yes" are the whole Django project's, which the no-test block prints regardless. They say nothing about US006 (the filed bug, Section 1)                                                                                                                                                                                                                                                                                                                       |
| Auth-critical row                           | N/A                     | No module in the authentication, session or permission path is in scope                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Flaky tests                                 | None                    | One run; the self-test is hermetic (fixtures under `mktemp -d`, no daemon, no network)                                                                                                                                                                                                                                                                                                                                                                                                                     |

Known behaviours that are **not** gaps, because the plan records them: the self-test lives in
`_migrate-self-test.sh`, sourced only by `migrate.sh --self-test` (split at P2 for the 750-line
limit); `reset.sh` and `restore.sh` with `--force-posture` and nothing piped exit `4` at the empty
prompt (Key Decision _Where the no-tty refusal fires_, proved by `18-empty-read-*`); a typed non-`yes`
answer still aborts at `0`.

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
15/11/2026: exit 0 as a warning, "0 carry a story marker; 72 do not." — 65 pytest cases and 7
`.bru` files. None is a US006 test; the story's proof is the self-test above, which no marker can
reach.

---

## 4. Status line

**Partial** — 0 attributed tests and no coverage attributable (no Python path); the story's own
proof, `migrate.sh --self-test`, exits 0 with 186 of 186 checks passing (cases 1 to 19, 14a to 14e
in both modes, the extra helper cases including the nine F-018 cases, and 60 structural checks including cases 20 and 21 and the
three F-001 ordering checks); ShellCheck 0.11.0 exits 1 on 4 pre-existing `SC2015 (info)`
findings in four callers, none in new code (the `server.sh` one moved from line 218 to 227 with the
fix, unchanged).
Verified 15/11/2026 at `fbd9dbc` plus the F-001 and F-018 fixes (committed in `0a6db24`); ShellCheck re-run after
the F-018 fix, the same four findings at the same lines.

---

## Cross-references

- `../../02-STORIES/US006.md` — the story under test; its _QA Acceptance Criteria — Automated_ asks for the self-test exit 0 and ShellCheck recorded here
- `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the implementation plan this record closes; its proof-case table numbers every case above
- `../MANUAL/US006-MANUAL-TESTING.md` — the paired manual testing guide; it carries the M half of cases 14, 20 and 21 (TARGET-01 to TARGET-05, SEED-01 to SEED-03) and the CI teardown rows
- `../../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — the scenarios the QA record closes
- `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` — the threat model the guard answers
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` — the assessment whose constraints the resolver implements
- `code/src/scripts/_lib/posture-guard.sh` — the helper and its contract block
- `code/src/scripts/database/_migrate-self-test.sh` — the harness this record transcribes
- `code/docs/GATE-REPORTING.md` — why ShellCheck's exit 1 is not reported as clean
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
