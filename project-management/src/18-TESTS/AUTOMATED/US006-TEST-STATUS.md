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
# The self-test — helper cases, both modes, the six callers' structural cases, then their behavioural runs
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
in `0a6db24`, **plus the workflow 23 review fixes** (F-020 to F-026 in
`../../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md`), uncommitted at the time of writing,
in `_lib/posture-guard.sh`, `database/_migrate-self-test.sh`, `database/restore.sh` and the six
callers' guard calls. Every run below was repeated after those fixes, last on 15/11/2026:

| Run                          | Result                                                                                                                                                                                                                                                                                                                                                                     |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `migrate.sh --self-test`     | **Exit 0**, `✓ self-test passed`. **250 checks, 250 PASS, 0 FAIL**: 164 helper-driven (H) checks — eleven the F-018 cases, thirty-nine the workflow 23 review's `R001-*`, `R002-*` and `R003-*` — 60 structural (S) checks, 25 behavioural (B) checks, and the closing `docker never invoked`. The banner read `stdin is a tty: no`. Was 186 at `0a6db24` (125 H, 60 S, 1) |
| ShellCheck 0.11.0 (`-x`)     | **Exit 1** — exactly 4 findings, all pre-existing `SC2015 (info)` in four callers; the helper and the harness are clean. Every `# shellcheck source=` directive resolved (no `SC1091`). At `-S warning`: exit 0. Detail in Section 2.2                                                                                                                                     |
| `audits/story-markers.sh`    | Exit 0 (warn-only): "Scanned 9 test module(s) and 7 Bruno request(s). 0 carry a story marker; 72 do not." — 65 pytest cases and 7 `.bru` files. None of the 72 is a US006 test, because the story wrote none                                                                                                                                                               |
| `tests/test-record.sh US006` | Exit 0, `wrote 0 test rows`, reading `code/src/scripts/tests/reports`, re-run after the F-018 fix. The block in Section 1 is its output, unedited; the review fixes changed no suite and no marker, so it was not regenerated                                                                                                                                              |

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

| Case                                                                                                           | Mode                       | rc         | Result | What it proves                                                                                                                                                                                                                                                                                                      |
| -------------------------------------------------------------------------------------------------------------- | -------------------------- | ---------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `override-invalid`                                                                                             | refuse / warn              | 4 / 0      | Pass   | `--force-posture prod` refuses naming the three legal values **before** the carrier is read (plan step 1)                                                                                                                                                                                                           |
| `bind-unvalidated`                                                                                             | refuse                     | 4          | Pass   | Binding with no validated target refuses and leaves the Docker array empty, never a stale one                                                                                                                                                                                                                       |
| `above-dev-production` · `above-dev-staging` · `above-dev-development` · `above-dev-template`                  | refuse                     | 0          | Pass   | `posture_above_development` answers yes, yes, no, no                                                                                                                                                                                                                                                                |
| `compose-name-base` · `-override` · `-silent-last` · `-squoted` · `-nested-only` · `-missing`                  | refuse                     | 0          | Pass   | The compose name handed to the guard: last declaring file wins; a nested `name:` or none yields empty                                                                                                                                                                                                               |
| `set-euo-permit` · `set-euo-warn`                                                                              | refuse / warn              | 0 / 0      | Pass   | Sourced into a `set -euo pipefail` script, a permit and a fully degraded warn both run on                                                                                                                                                                                                                           |
| `relative-source`                                                                                              | —                          | 0          | Pass   | Sourced by a bare relative name into a strict shell, the helper still finds its sibling conflict-marker library                                                                                                                                                                                                     |
| `F018-raw-declared-cpn`                                                                                        | refuse / warn              | 4 / 0      | Pass   | F-018: `COMPOSE_PROJECT_NAME` equal to a raw declared name Compose would rewrite is refused as not a valid Compose name (warn: warned, binding refused)                                                                                                                                                             |
| `F018-normalised-cpn`                                                                                          | refuse                     | 0          | Pass   | F-018: the name Compose actually uses — the declared name normalised — is permitted and binds                                                                                                                                                                                                                       |
| `F018-cpn-unset`                                                                                               | refuse                     | 0          | Pass   | F-018: no `COMPOSE_PROJECT_NAME`, a declared name needing normalisation, permits                                                                                                                                                                                                                                    |
| `F018-different-cpn`                                                                                           | refuse                     | 4          | Pass   | F-018: a mismatched name is refused, and the reason names the project Compose would use                                                                                                                                                                                                                             |
| `F018-leading-trimmed`                                                                                         | refuse                     | 0          | Pass   | F-018: leading `_` and `-` are trimmed before comparing, as Compose does                                                                                                                                                                                                                                            |
| `F018-empty-normalised`                                                                                        | refuse / warn              | 4 / 0      | Pass   | F-018: a declared name that normalises to empty fails the target check closed (warn: binding refused)                                                                                                                                                                                                               |
| `F018-empty-norm-cpn`                                                                                          | refuse                     | 4          | Pass   | F-018: the same, with `COMPOSE_PROJECT_NAME` set                                                                                                                                                                                                                                                                    |
| `R001-envfile-other` · `-export`                                                                               | refuse / warn              | 4 / 0      | Pass   | F-020: a `COMPOSE_PROJECT_NAME` in the `--env-file` naming another project is refused (plain and `export` forms); warn mode warns                                                                                                                                                                                   |
| `R001-envfile-match` · `-quoted` · `-no-key` · `R001-shell-first`                                              | refuse                     | 0          | Pass   | F-020: an env-file name matching the declared one (plain or quoted) permits; no key permits; a matching shell value wins over a different env-file value — Compose's precedence                                                                                                                                     |
| `R001-envfile-interp` · `-invalid`                                                                             | refuse                     | 4          | Pass   | F-020: an interpolated env-file value fails closed; an env-file name not in Compose's normal form is refused                                                                                                                                                                                                        |
| `R001-envfile-spaced` · `-colon` · `-twice`                                                                    | refuse                     | 4          | Pass   | F-020, widened after the re-checks: `COMPOSE_PROJECT_NAME = x`, `COMPOSE_PROJECT_NAME: x` (both forms Compose reads) and a second mention all refuse in `posture_env_project`                                                                                                                                       |
| `R001-envfile-crlf`                                                                                            | refuse                     | 0          | Pass   | F-020: a CRLF line still reads its value                                                                                                                                                                                                                                                                            |
| `R001-envfile-commented` · `-bom` · `-nbsp` · `-after-quote` · `-in-quote`                                     | refuse                     | 4          | Pass   | F-020 final form, after the second re-check traced Compose's parser: a commented-out key, a BOM, an NBSP, a key after a closing quote and a key inside a quoted value are all mentions other than one plain `COMPOSE_PROJECT_NAME=value` line, so all refuse (fail closed by design — a commented-out key included) |
| `R001-envfile-nul`                                                                                             | refuse                     | 4          | Pass   | F-020, round 3: an env-file containing a NUL byte refuses — before the fix `grep` read it as binary, matched nothing, and a different project passed                                                                                                                                                                |
| `R001-envfile-tab`                                                                                             | refuse                     | 0          | Pass   | F-020, round 3: `export<TAB>COMPOSE_PROJECT_NAME=` matching the declared name permits (the pattern now uses `[[:blank:]]`)                                                                                                                                                                                          |
| `R002-explicit-key` · `-tagged-key` · `-anchored-key` · `-escaped-key` · `-continuation` · `-continuation-gap` | refuse (tagged: also warn) | 4 (warn 0) | Pass   | F-021: `? KEY`, `!!str`, `&a`, an escaped double-quoted key and a continuation line (directly after the key, or after a blank line) all read `unrecognised` and refuse                                                                                                                                              |
| `R002-copier-shape`                                                                                            | refuse                     | 0          | Pass   | F-021: the shape Copier writes still reads as legal and permits                                                                                                                                                                                                                                                     |
| `R002-lone-cr` · `-nel` · `-line-separator` · `-para-separator` · `-nel-continuation`                          | refuse                     | 4          | Pass   | F-021 final form: CRLF, a lone CR, NEL (U+0085), U+2028 and U+2029 are turned into LF before the line loop (`posture_unify_breaks`), so a key hidden after one refuses as set more than once, and so does a key after a NEL continuation                                                                            |
| `R002-crlf-carrier` · `R002-copier-nel` · `R002-copier-ls`                                                     | refuse                     | 0          | Pass   | F-021: a CRLF carrier reads, and so does a carrier in which Copier's own dumper wrote a NEL or U+2028 raw inside a quoted free-text answer — the false refusal the second re-check found in the first widening                                                                                                      |
| `R003-project-repair` · `R003-envfile-repair` · `R003-socket-repair`                                           | refuse                     | 4          | Pass   | F-022: a compose-project refusal (shell or env-file) prints the project repair; a socket refusal still prints the socket one                                                                                                                                                                                        |
| `docker never invoked`                                                                                         | —                          | —          | Pass   | The recording `docker` on `PATH` recorded no call across the whole run                                                                                                                                                                                                                                              |

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

#### Behavioural cases — the six callers, run

Added 15/11/2026 for the workflow 23 review's R-005 (F-024): the structural checks prove the text,
these run it. `st_behavioural` copies the four script groups into a fixture repository with
one-line compose and env files and puts a recording `docker` stub first on `PATH` — it logs its
arguments, exits 0 and never reaches a daemon. Each run starts from a directory outside the
fixture root, with the selectors and `COMPOSE_PROJECT_NAME` unset. **25 checks, 25 PASS** — 22 caller runs and three byte/DROP checks. A refusal
passes on exit 4, the prefix and no recorded call. A permit passes on any exit but 4 (the caller
may stop downstream on the stub's empty answers; several exit 2), no refusal line, at least one
recorded call, and every recorded call carrying `--host unix:///var/run/docker.sock`.

| Cases                                                                                                                                                                                   | What they prove                                                                                                                                                                                                                                                                                                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `B-staging-reset` · `-restore` · `-seed-dev` · `-dev-down-vol` · `-dev-up-seed` · `-test-down-vol`                                                                                      | At `staging`, each of the six bound paths exits 4 with the prefix and `docker` is never called                                                                                                                                                                                                                                                                                        |
| `B-dev-reset` · `-restore` · `-seed-dev` · `-down-vol` · `-up-seed` · `B-test-down-vol` · `B-dev-migrate-show`                                                                          | At `development`, permitted, every recorded call pinned to the validated socket — `migrate.sh show` included (seven)                                                                                                                                                                                                                                                                  |
| `B-override-seed-dev` · `B-override-up-seed`                                                                                                                                            | `--force-posture staging` crosses each parser, and `up --seed` hands it to its `seed-dev.sh` child — the end-to-end half of case 20                                                                                                                                                                                                                                                   |
| `B-override-wrong`                                                                                                                                                                      | A wrong override (`production` at `staging`) is refused at 4                                                                                                                                                                                                                                                                                                                          |
| `B-envfile-name-refused` · `B-envfile-name-matches`                                                                                                                                     | F-020 end to end: an env-file `COMPOSE_PROJECT_NAME` naming another project refuses `development/server.sh down --volumes`; the matching name permits                                                                                                                                                                                                                                 |
| `B-envfile-test-refused`                                                                                                                                                                | F-020 on the test stack: an `.env.test` naming another project refuses `tests/server.sh down --volumes` (added after the first re-check)                                                                                                                                                                                                                                              |
| `B-restore-relative-path` · `B-restore-relative-dropped-once` · `B-restore-reads-the-backup` · `B-restore-plain-format` · `B-restore-plain-reads-the-backup` · `B-restore-missing-path` | F-023: a relative backup path is resolved where it was typed (exit 0, exactly one DROP), in custom and `--format plain`; the stub deletes the backup when it sees the DROP (`ST_RM_ON_DROP`), so the restore succeeds only by reading the descriptor opened before it — with `<&3` reverted to the path, four of these fail; a missing relative path stops before `docker` is touched |

### 2.2 ShellCheck, as run

ShellCheck **0.11.0** (`/run/current-system/sw/bin/shellcheck`, the version the P0 baseline
recorded), `-x`, default severity, over the eight files above:

| File                                                            | Finding                                                                                | Line | Origin                               |
| --------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---- | ------------------------------------ |
| `code/src/scripts/_lib/posture-guard.sh`                        | None                                                                                   | —    | —                                    |
| `code/src/scripts/database/_migrate-self-test.sh`               | None — the `SC2016` the F-018 commit added at `:230` now carries its directive (F-025) | —    | —                                    |
| `code/src/scripts/database/reset.sh`                            | `SC2015 (info)` — `A && B \|\| C` is not if-then-else                                  | 177  | `ee5c2bb`, 01/08/2026 — before US006 |
| `code/src/scripts/database/restore.sh`                          | `SC2015 (info)`                                                                        | 85   | `f0681f2`, 18/04/2026 — before US006 |
| `code/src/scripts/development/server.sh`                        | `SC2015 (info)`                                                                        | 227  | `f0681f2`, 18/04/2026 — before US006 |
| `code/src/scripts/tests/server.sh`                              | `SC2015 (info)`                                                                        | 171  | `ee5c2bb`, 01/08/2026 — before US006 |
| `code/src/scripts/database/seed-dev.sh` · `database/migrate.sh` | None                                                                                   | —    | —                                    |

**Exit 1 is not "ShellCheck clean"** (`code/docs/GATE-REPORTING.md`). The four findings are
info-severity, carried unchanged from the P0 tree (`fc10bcc`: the same four `SC2015` over the six
callers), and none lies on a line this story wrote. The six `# shellcheck source=` directives to
`_lib/posture-guard.sh` all resolved, as does the helper's own to `_lib/env-file.sh`. Run at
`-S warning` the same eight files exit 0.

**Corrected 15/11/2026 (F-025):** this section previously called the harness clean while the F-018
commit had added an `SC2016 (info)` at `_migrate-self-test.sh:230` — the literal `${X}` there is
the fixture, so a directive now says so. Re-run after the workflow 23 review fixes: the four
`SC2015` above and nothing else; the helper and the harness are genuinely clean.

---

## 3. Outstanding gaps and flaky tests

| Item                                        | Type                    | Reason / owner                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------------------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Selector precedence — `14d-selectors-split` | Departure, now recorded | The plan resolved "non-empty `DOCKER_CONTEXT`, otherwise non-empty `DOCKER_HOST`" (_09/10/2026 decision_). The helper **refuses** when both are set and disagree, because the Docker CLI it was built against (29.9.2) lets `DOCKER_HOST` win. **Resolved 15/11/2026 (F-002):** the developer ruled `DOCKER_HOST` wins, recorded as a dated erratum in the plan's Approach; the refusal fails closed under either precedence. No longer a Fail against the plan                                                                                                                                                                                                                                                      |
| Cases **20** and **21**                     | Proved S + B + M        | By design (plan's proof-case table): no H half exists, because the fixture seam reaches the helper and not the callers. Since 15/11/2026 the B tier runs the callers: `B-override-up-seed` carries the override across `up --seed` into `seed-dev.sh`, and `B-dev-up-seed` / `B-staging-dev-up-seed` prove the guard on `--seed`. The S checks above prove the text — the forward is present, `seed-dev.sh` parses the flag first, `up` is guarded on `--seed` only and bound before `up -d`. That the flag actually crosses the shell-out and `up --build` actually proceeds is proved by `../MANUAL/US006-MANUAL-TESTING.md` rows SEED-01 and SEED-03, both `Pass` on a disposable us006 stack after the F-001 fix |
| Case 14 end-to-end binding                  | Proved H + S + M        | H proves the resolver over synthetic metadata; S proves each caller consumes the validated array. That preflight, Compose calls and seed forwarding go to the bound endpoint — `up --seed`'s `up -d` and password sync included since the F-001 fix — is TARGET-01 to TARGET-05 in the manual guide, all `Pass`                                                                                                                                                                                                                                                                                                                                                                                                      |
| ShellCheck "clean"                          | Not met as written      | Exit 1 on 4 pre-existing `SC2015 (info)` (Section 2.2). The helper and harness are clean; the story's criterion says "clean over the helper and its six callers" and the callers are not, at info severity. No project script runs ShellCheck, so this was run by hand and is recorded as run                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Every pytest, Bruno, E2E and axe suite      | Out of scope            | No Python, template or API path changed. The CI teardown change (`.github/workflows/test-e2e.yml`, `--force-posture development`, no `\|\| true`) is exercised only when that workflow runs, which this pass did not do; manual rows CI-01 and CI-02 cover it                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Coverage figures in Section 1.2             | Not attributable        | The 100.0% line and branch figures and "Met? Yes" are the whole Django project's, which the no-test block prints regardless. They say nothing about US006 (the filed bug, Section 1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Auth-critical row                           | N/A                     | No module in the authentication, session or permission path is in scope                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| Flaky tests                                 | None                    | One run; the self-test is hermetic (fixtures under `mktemp -d`, no daemon, no network)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

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
proof, `migrate.sh --self-test`, exits 0 with 250 of 250 checks passing — 164 H (cases 1 to 19,
14a to 14e in both modes, the extra helper cases including the eleven F-018 and thirty-nine review
cases), 60 S (including cases 20 and 21 and the three F-001 ordering checks), 25 B (the six callers
run against a recording `docker`) and `docker never invoked`; 186 of 186 at `0a6db24`. ShellCheck
0.11.0 exits 1 on exactly 4 pre-existing `SC2015 (info)` findings in four callers, none in new code
(the `server.sh` one moved from line 218 to 227 with the F-001 fix, unchanged); helper and harness
clean. Verified 15/11/2026 at `0a6db24` plus the workflow 23 review fixes (F-020 to F-026,
uncommitted at the time of writing).

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
