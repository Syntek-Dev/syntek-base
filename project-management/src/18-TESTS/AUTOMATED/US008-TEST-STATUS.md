# US008 — Test Status

_The automated-test record for US008: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4. The story ships settings lines, Bash and documentation — no Python behaviour a pytest test could exercise — and, by design, no new pytest: the invariant has **one enforcer**, the three cookie clauses of `negative-space.sh`, and a second test asserting the same settings would be a second enforcer of one rule. Its automated proof is therefore the gate's `--self-test`, which no story marker can attribute; Sections 2 and 3 carry it rather than leaving the record empty (the Guardrails of this folder's `CLAUDE.md`)._

**Last Updated**: 16/11/2026 · **Story**: US008 · **Status**: Green

- **Story:** `../../02-STORIES/US008.md` — cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule
- **Story plan:** `../../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the code master this record closes the loop on
- **Branch:** `us008/host-only-cookies`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US008
```

**Read Section 3 before this block.** No test declares US008, and none was written: the story's
one enforcer is a shell gate. The coverage figures below are the **whole-project** backend
figures from the regression run of 16/11/2026 (`all.sh --coverage`, Section 2), not a measure of
anything this story changed — the story touches no module in the table (the defect behind that
reading is `../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`).
The auth-critical row is left as the generator writes it: `apps/users/` does not exist, so no
module in the authentication, session or permission path is in the table; the session and CSRF
**settings** this story changes are configuration, enforced by the gate rather than covered by a
test.

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

_Not run, or produced no artefact: E2E and accessibility, API (Bruno). An absent suite is not a zero — say why in Section 3._

_No test declares `US008`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US008._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story. Everything below runs on the host
through its project script, from the repository root; only `all.sh` needs Docker, which it drives
itself. Nothing here plants or removes a file in the checkout — the self-test builds its variant
trees under its own `mktemp -d` and removes them on exit.

```bash
# The story's proof — every clause over fixtures/negative-space/{broken,clean}, then the cookie half
bash code/src/scripts/audits/negative-space.sh --self-test

# The gate over the real tree — the three cookie clauses ran, nothing fired
bash code/src/scripts/audits/negative-space.sh

# Regression — types, lint, and the backend suite with coverage
bash code/src/scripts/syntax/check.sh
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/tests/all.sh --coverage

# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/test-record.sh US008
```

ShellCheck has **no project script** — `syntax/lint.sh` carries no shell leg — so it was run by
hand over the six shell files the story added or edited, and is recorded as run, never as a
`lint.sh` pass:

```bash
shellcheck \
  .copier/migrations/cookie-domain-conflict.sh .copier/migrations/host-only-cookies.sh \
  code/src/scripts/audits/_lib/negative-space-cookies.sh code/src/scripts/audits/negative-space.sh \
  code/src/scripts/development/template-update.sh code/src/scripts/tests/cookie-preview-fixture.sh
```

**This pass, 16/11/2026,** on `us008/host-only-cookies` at `43acdf5`, clean working tree (this
record the only untracked file), run by an independent tester who wrote none of the story's code:

| Run                             | Result                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `negative-space.sh --self-test` | **Exit 0**, `✓ Self-test passed — broken/ trips 14 clauses, clean/ trips none.` The cookie half (`cookie_self_test` in `_lib/negative-space-cookies.sh`) ran inside it and reported no failure: each broken module named by its clause, the absent-directory skip, the review-bypass variants, the fail-closed fallback, the surfaces, TLS discovery, and byte-for-byte scanner parity with the copier migration twin. The harness prints no per-case count                                                                                                                                                                                |
| Self-test, awk portability      | **Exit 0 under all three**: GNU Awk 5.4.1 (host default); mawk 1.3.4 20240819 and BusyBox 1.37.0 `awk`, each placed first on `PATH` as `awk` through a shim in a `mktemp -d` directory (binaries from `nix build nixpkgs#mawk nixpkgs#busybox`). Re-run by this tester, confirming the implementer's reading. **BSD awk (one-true-awk) unmeasured** — not available on this host                                                                                                                                                                                                                                                           |
| `negative-space.sh` (unscoped)  | **Exit 0**, `✓ Register and code agree.` — 15 fail-tier and 1 warn-tier clauses, surfaces django + mcp + mobile. Skip notes name only `htmx-handler-absent` and `mcp-*`; none of `csrf-cookie-httponly-absent`, `cookie-host-prefix-absent`, `cookie-scope-widened` skipped                                                                                                                                                                                                                                                                                                                                                                |
| `syntax/check.sh`               | **Exit 0** — basedpyright 0 errors / 0 warnings / 0 notes; mobile `tsc` clean; `cargo check` clean                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `syntax/lint.sh`                | **Exit 0** — ruff clean; markdownlint 1158 files, 0 issues; mobile ESLint clean; rustfmt + clippy clean. No shell leg: says nothing about the story's scripts                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `tests/all.sh --coverage`       | **Exit 0** — unit 50 passed, integration 22 passed, total coverage 100.00% against the 75% floor; auth check skipped (`apps/users/` does not exist); mobile jest 16 passed in 3 suites. Regression only                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ShellCheck 0.11.0               | **Exit 1** — 10 findings, **all pre-existing and none in a story-authored line**: 9 in `negative-space.sh` (8 `SC2016 (info)`, 1 `SC1087 (error)` at the `MCP_MASK_SETTING` regex), `git blame` dating them to 11/08 and 14/08/2026, and the same 1 error + 8 info reproduced on the file as it stood before the story's first commit (`cd0b591^`); 1 `SC1091 (info)` in `template-update.sh` (not following a sourced file without `-x`). `cookie-domain-conflict.sh`, `host-only-cookies.sh`, `_lib/negative-space-cookies.sh` and `cookie-preview-fixture.sh` are clean. At `--severity=warning` only the pre-existing `SC1087` remains |
| `audits/story-markers.sh`       | Exit 0 (warn-only): "Scanned 9 test module(s) and 7 Bruno request(s). 0 carry a story marker; 72 do not." None of the 72 is a US008 test, because the story wrote none                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `tests/test-record.sh US008`    | Exit 0, `wrote 0 test rows`, reading `code/src/scripts/tests/reports` as written by the `all.sh` run above. The block in Section 1 is its output, unedited                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

### 2.1 Added after closeout — two dev-stack fixes PR'd with US008 (16/11/2026)

Both bugs surfaced by the US008 walk were fixed test-first on their own `us008/` branches and
merged here. Measured on `us008/host-only-cookies` after the second merge (`8d6a5ac`):

| Check                                                       | Result                                                                                                                                                        |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/dev-static.sh --self-test`                          | **Exit 0**, 23 cases — the dev `/static/` guard (`1c750c5`, hardened over two QA rounds, Copier-safe at `e34b4be`). Red first: 3 findings on the unfixed tree |
| `audits/dev-static.sh`                                      | **Exit 0** on the real tree                                                                                                                                   |
| `config/tests/test_dev_settings.py`                         | **21 Pass**, marked `story("US008")` — the story-stack trusted origins (`40ce928`). Red first: 16 failed                                                      |
| `audits/worktree-overlay.sh`                                | **Exit 0** — the overlay sets `DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA`. Red first: 2 violations                                                                    |
| `tests/all.sh --coverage`                                   | **Exit 0** — backend 71 unit + 22 integration, mobile 16; floors met                                                                                          |
| `check-template-tokens.sh`, `shipped-readme.sh`, docs gates | **Exit 0**; a `template-render.sh` render (1581 files) runs `dev-static.sh` green inside the generated project                                                |

**The 21 marked tests are absent from the generated block above**, and that is a reporting
defect, not missing tests: `conftest.py` rewrites `story-map.json` at every pytest session, and
`backend-coverage.sh` runs the integration session second with the unit tests deselected, so it
writes an empty map over the unit session's (finding F-039).

---

## 3. Outstanding gaps and flaky tests

| Item                                                      | Type                     | Reason / owner                                                                                                                                                                                         |
| --------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| pytest / Bruno attribution                                | Out of scope, by design  | No test declares US008: the gate is the invariant's one enforcer, so the generated table is empty and correctly so                                                                                     |
| API (Bruno), E2E, accessibility suites                    | Out of scope             | No endpoint, route or rendered screen added (QA plan Sections 2 to 4). `all.sh` was run without `--api`                                                                                                |
| Self-test under BSD awk                                   | Unmeasured               | Verified under gawk 5.4.1, mawk 1.3.4 and BusyBox 1.37 awk only; no one-true-awk on this host. A macOS developer running the gate is on the unmeasured awk                                             |
| ShellCheck `SC1087` in `negative-space.sh`                | Pre-existing             | Error-severity finding at the `MCP_MASK_SETTING` regex, dated 14/08/2026, present before the story's first commit; not this story's to fix. ShellCheck is not gated anywhere, so nothing reddens on it |
| What the gate cannot see                                  | Documented limit         | Listed in `code/docs/security/CRYPTO-AND-DATA.md`; a computed `SECURE` value turns its module TLS and is held to `__Host-` names                                                                       |
| Cookie attributes in a real browser (PA-01, PA-02, ES-06) | Out of scope             | Need two hosts and a TLS-serving environment; the manual guide, not this record, owns them — `../MANUAL/US008-MANUAL-TESTING.md`                                                                       |
| The migration's versioned filename                        | Deferred to `24-release` | `host-only-cookies.sh` ships `when: false`, unversioned; the rename and its tag are written at release                                                                                                 |
| Story map overwritten by the second pytest session        | Pre-existing defect      | `conftest.py` writes `story-map.json` per session; the integration run's empty map replaces the unit run's, so `test-record.sh` attributes 0 of the 21 US008 tests. Finding F-039                      |
| `story-markers.sh --path` guard                           | Pre-existing defect      | Owned by `code/src/scripts/audits/CLAUDE.md`; not exercised here (the run was unscoped)                                                                                                                |

**Unmarked tests are invisible here.** The generator selects on the story marker; `story-markers.sh`
was read (Section 2), and none of the 72 unmarked tests belongs to this story.

---

## 4. Status line

**Green** — 0 attributed tests (none by design); the story's proof, `negative-space.sh --self-test`, passes under gawk, mawk and BusyBox awk; unscoped gate, `check.sh`, `lint.sh` and the regression suite (72 backend, 100% coverage, floors met) all exit 0; ShellCheck run, findings pre-existing only · verified 16/11/2026.

**Green, re-measured 16/11/2026 at `8d6a5ac`** — the two merged dev-stack fixes add 21 passing US008 tests (unattributed in the block, F-039) and two green audits; `all.sh --coverage` exits 0.

---

## Cross-references

- `../../02-STORIES/US008.md` — the story under test
- `../../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the implementation plan this record closes
- `../MANUAL/US008-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; a manual `Fail` beside a green suite is a missing test
- `code/src/scripts/audits/_lib/negative-space-cookies.sh` — the cookie clauses and their self-test half
- `code/docs/security/CRYPTO-AND-DATA.md` — the owner guide for cookie scope, and what the gate cannot see
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
