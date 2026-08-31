# GAPS.md — syntek-base's own open items

**Last Updated**: 31/08/2026 | **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

Active gaps, blockers and standing limitations belonging to **`syntek-base` itself** — the
template repository, not any project generated from it.

> **Why the template's own items live here.** Until 22/08/2026 this file was a shipped empty
> stub and the template's items lived in a separate register under the template guide, because
> whatever this file contained was rendered into every generated project. Keeping it empty was
> a discipline rather than a mechanism, and it had already failed inside a published tag:
> `git show v6.0.0:GAPS.md` is 47 lines carrying the `main` entry below. `copier.yml` now <!-- doc-references: template-only -->
> **excludes** this file and seeds a blank one from `.copier/GAPS.md` instead — the same
> arrangement `.claude/MEMORY.md` has always had — so syntek-base can write to its own register
> freely. `.github/scripts/shipped-registers.sh` holds the seed empty. <!-- doc-references: template-only -->

**Read at the discovery gate.** `project-management/workflows/01-feature-map/` reads this file
and `DEFERRED.md` before charting a feature — to **suggest** candidate features from what has
accumulated, and to triage every open entry against the feature being charted (closes / blocks /
unrelated). An entry a feature will close is **claimed** on its `MAP-<FEATURE>.md`; the
`✅ CLOSED` mark itself is only applied by `workflows/22-implementation-documentation/`, against
shipped code. **Standing limitations are exempt from that triage** — they are accepted
properties, not open entries, and can take none of the three verdicts.

---

## The active items were charted off this file

**Charted 13/08/2026.** The twenty-two actionable entries this file used to carry became
twenty-three decision nodes in five batches on a feature map, and were removed from here so
there was one working copy rather than two that drift. **That map has since been deleted** —
what survives of it is the standing limitations below, the release record in `CHANGELOG.md`,
and git history. The full prose of every entry it replaced is recoverable with:

```bash
git show e16b499:how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md
```

> **A feature map is committed but never ships.** Since 17/08/2026 the feature maps are tracked,
> so they sync across devices; none of them reaches a generated project, because `copier.yml` <!-- doc-references: template-only -->
> `_exclude` empties every artefact tree at generation, gated by
> `.github/scripts/shipped-artefacts.sh`. The name is load-bearing: a map called <!-- doc-references: template-only -->
> `MAP-TEMPLATE-*.md` matches the allowlist's `!*TEMPLATE*` negation, becomes tracked, and ships
> into every generated project — which is the defect this file exists to prevent.

The five batches were named as reusable **defect classes**, so a later map inherits the taxonomy
rather than inventing a grouping: **A** token blast radius · **B** false green · **C**
inheritance leak · **D** split doctrine · **E** declared, not built.

---

## Standing limitations

**Read these; do not try to finish them.** Each is an accepted property of developing a template
rather than a task, so neither belongs on a map. A new one is added here only when a gap is
closed as _accepted_ rather than _fixed_.

### SL-1 — A green suite here proves the template's own code, not your project's

**This entry replaces two, both deleted on 16/08/2026 as factually false.** They said the
suites never execute here and that no tool needing `uv` runs here. Both were true when
written and neither is true now, so keeping them would have made this file the thing it
exists to prevent: a register that is trusted and wrong.

What removed them, in order:

| Change                          | What it unblocked                                                         |
| ------------------------------- | ------------------------------------------------------------------------- |
| `24a5fb7`                       | Ruff, via `uvx --from` — the launcher never needed the manifest           |
| `7cd385d`                       | Everything else: `[project] name` became the house constant `syntek-base` |
| `uv.lock` committed, 16/08/2026 | The Django image builds here, so every suite and container gate can run   |

Verified on 16/08/2026, in this repository, not in a generated project: the dev stack comes
up with all four containers healthy; `backend-coverage.sh` reports **100% over 162
statements**; `basedpyright` reports **0 errors**; `pip-audit` reports **no known
vulnerabilities**. `basedpyright` and `pip-audit` are therefore legitimate evidence here, and
the instruction never to cite CI for them is withdrawn.

**The limitation that genuinely remains, and it is permanent.** The template ships two apps —
`apps.core` and `apps.health` — and no domain code. A green run here exercises the **harness
and those two apps**: the compose stack, the two-phase runner, the coverage accumulation, the
markers, and the endpoints `apps.health` owns. It says nothing about a generated project's
features, because there are none here to say anything about.

**The rule this leaves:** a green suite in syntek-base is evidence about **syntek-base**.
Read it as "the harness works and the shipped apps pass", never as "this template's projects
pass". A change to `code/src/django/`, the Dockerfiles or the compose files still wants the
generation smoke test in `audit-template.yml` behind it, because that is the only thing here
that exercises a project rather than a template.

**A second, narrower rule survives from the deleted SL-1 and is worth keeping:** a CI job
carrying a `services:` block is not covered by a step-level guard, whatever its steps say —
service containers initialise _before_ the first step, so the job dies at
`Initialize containers` with its guard sitting unreachable below. That cost `[7/8] Tests`
every run from 03/08/2026 to 14/08/2026.

**One preference also survives.** Where template-level tooling needs a dependency but not the
project's own environment, prefer `uvx --from` or `uv run --no-project --with <dep>` over
`uv run`. That is now an efficiency argument rather than a workaround — it skips building the
project environment for a tool that does not need it.

### SL-2 — The template ships no deployment scripts, because it ships no deployment

**Added 21/08/2026, closing a charted node as _accepted_ rather than _fixed_.**
`code/src/scripts/deployment/` holds its documentation pair and a `reports/` folder and no
scripts. `deploy.sh`, `rollback.sh` and `health-check.sh` are named as planned in six sites
across five files, and all six agree — that consistency is the only thing asserted.

**Why it is accepted and not scheduled.** All three wait on the same absent thing, and the
charting rule is that _a task is an unwritten artefact with a **named owner**_:

| Script            | What it waits on                                                                                                     |
| ----------------- | -------------------------------------------------------------------------------------------------------------------- |
| `deploy.sh`       | No workflow **publishes** an image, while `docker-compose.prod.yml:17` pulls one from GHCR with no `build:` fallback |
| `rollback.sh`     | No contract row anywhere in `SERVER-ARCHITECTURE/`; waits on `/scale-planning`                                       |
| `health-check.sh` | Nothing to check the health **of** — it is the caller of a deploy that does not run                                  |

A three-way split was proposed on 16/08/2026 on the premise that `health-check.sh` _"now needs
only an owner"_. **That was settled by finding that nothing in this repository creates these
three scripts** — the blocker was confirmed, not cleared — so the split's premise is
spent and it is refused here. `how-to/src/PROJECT-PATHS.md` correctly carries no entry for any
of them: `code/docs/FORWARD-VOICE.md` Section 3 admits a path to that register only with the
thing that creates it, and an entry that cannot name its creator is a wish.

**Reopens when** any workflow **publishes** an image to a registry. That is the single trigger
for all three: it gives `deploy.sh` its subject and `health-check.sh` its caller.

**Say _publishes_, not _builds_ — measured 21/08/2026 across all 35 workflow files.** One
already builds: `test-api.yml:75` runs `docker compose … build django-test`. What none does is
push — no `docker push`, no `docker/login-action`, no `build-push-action`, and no `ghcr.io`
reference anywhere in `.github/workflows/`. A trigger worded _builds an image_ would read as
already met and reopen this entry against a test image that never leaves the runner. The same
slip was recorded in the other direction on 16/08/2026, when a `grep 'docker build'` could not
match `docker compose … build`; one grep dialect is not a population.

### SL-3 — Three of the four security runbooks have no subject a template can rehearse against

**Added 23/08/2026, closing a charted node as _accepted_ rather than _fixed_.**
`code/docs/security/MONITORING-AND-INCIDENT.md` names four security-specific recoveries as
unwritten: account compromise via `admin_db`, audit-log tampering, emergency key rotation, and
Valkey cache compromise. The node's own gate was that **each is performed once against
non-production before it is written down**, and three of them have nothing to perform against.

**Measured 23/08/2026, in this repository:**

| Runbook                           | Subject here                                                                                            |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Account compromise via `admin_db` | **Absent** — `config/settings/base.py` declares a single `default` alias; there is no second connection |
| Audit-log tampering               | **Absent** — no audit model, no migration, and the string `audit` in no `.py` under `code/src/django/`  |
| Emergency key rotation            | **Absent** — `apps.core.encryption` does not exist and `cryptography` is declared but imported nowhere  |
| Valkey cache compromise           | **Present** — `CACHES` is wired at `base.py:140`, with a `cache` service in the dev and test stacks     |

**Why accepted and not scheduled.** All three absent subjects are things a **generated project
builds**, not things this template withholds. A runbook written here would be written against an
imagined implementation — the concrete shell commands for revoking a token in a connection that
does not exist — which is `Batch E` by its own definition: a shipped document routing to
something that is not there. It would also be unrehearsable, failing the node's own criterion in
the same breath.

**The fourth was not split off, and that is deliberate.** Valkey has a subject and its runbook
could be written. It is held with the other three because `MONITORING-AND-INCIDENT.md` names the
four in one paragraph as one gap: shipping one of four would leave that paragraph three-quarters
true, which reads worse than a paragraph that is honestly none. The practice they sit under —
declare, hand over, stand down, postmortem — **does** ship, at
`how-to/docs/INCIDENT-PRACTICE.md`, and that file says in terms that it is the general practice
and not these four runbooks.

**Reopens when** an application layer gives any of the three a subject: a second database
connection, an audit model, or a field-encryption module. Each reopens only its own row — the
first project to build one writes that runbook against the thing it built, which is the only
order in which it can be rehearsed.

---

## The 16/08/2026 sitting — settled and built

The sitting that closed both entries above. Fifteen decisions were taken across three grilling
rounds and carried out in one sitting; they are recorded here because a decision that lives
only in a session transcript is not a decision anyone can act on later.

| #   | Decision                                                                                    | Where it landed                                                                          |
| --- | ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Q1  | Commit `uv.lock`, gated on a proven compose healthcheck and a real `/health/` first         | `uv.lock`, root `CONTEXT.md`                                                             |
| Q2  | Settle the three non-lock blockers here rather than folding them in silently                | this table, Q4/Q8/Q9                                                                     |
| Q3  | Fix the live false green; chart `claude.yml`'s unevidenced "Verified green" separately      | `test.yml`, `pre-pr-check.sh`                                                            |
| Q4  | `audits/security.sh` gains `--frozen` so it can never manufacture the lockfile              | `code/src/scripts/audits/security.sh`                                                    |
| Q5  | New **`apps.health`**, scaffolded via `new-django-app.sh` — not folded into `apps.core`     | `code/src/django/apps/health/`                                                           |
| Q6  | Liveness + readiness over the dependencies that exist; API and pages arm as they land       | `apps/health/checks.py` — `Component` has two members                                    |
| Q7  | Cover the template to 75%: the health app plus the four uncovered `core` modules            | 100% over 162 statements                                                                 |
| Q8  | The 90% auth leg is re-pointed and prints its denominator                                   | `backend-coverage.sh` owns it; `test.yml` now calls it                                   |
| Q9  | Explicit `--group test` at test call sites; `test-e2e.yml` gains the `uv sync` it never had | `e2e-py.sh`, `test-e2e.yml` (`uv sync --locked`)                                         |
| Q10 | Dependency pruning is charted as its own node, not settled here                             | still open — charted separately                                                          |
| Q11 | One sitting, all of it, on this branch; the PR to `main` is gated on it being green         | this branch                                                                              |
| Q12 | Toolchain and all three lockfiles to latest first, then lock                                | uv 0.12.5, pnpm 11.22.0, `Cargo.lock`                                                    |
| Q13 | `uv.lock` added to copier `_exclude` — never travels, no `copier update` conflict           | `copier.yml` `_exclude` + the `uv lock` post-task <!-- doc-references: template-only --> |
| Q14 | Both standing limitations deleted; one true limitation replaces them                        | SL-1 above                                                                               |
| Q15 | Forced the charted subset only, then re-chart it against the remeasured file list           | done; still open                                                                         |

**`uv run` re-locks silently by default.** `--locked` asserts the lockfile is unchanged and
exits non-zero if it is not; `--frozen` uses it as-is without checking. In CI the first is
almost always what is wanted, because a bare `uv run` turns a stale lock into a green run
against versions nobody committed. Verified against uv's own CLI definitions, 16/08/2026.

### What the sitting found because the guards came off

Each of these was invisible while a guard reported "not applicable", and each was reachable
in a **generated project** — so the template was shipping them:

| Defect                                                                                                                                                                                                                                                                                                                                                                                                          | Class |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `pre-pr-check.sh` `_dc`/`_tc` passed no `--env-file`, so every container check failed                                                                                                                                                                                                                                                                                                                           | B     |
| `dev_running`/`test_running` grepped `backend`/`backend-test` — services that do not exist here (they are `django`/`django-test`), so the gate would `exit 2` on every run in a project                                                                                                                                                                                                                         | B     |
| Four scripts read `.env` files with `set -a; source`, which aborts on `POSTGRES_USER=` followed by an unrendered project-slug token: `pre-pr-check.sh` reported the whole container half n/a, `server.sh up` exited 2 with the stack already running (no DB password re-sync, no URL banner), `seed-dev.sh` injected empty credentials, and `e2e-py.sh` gave pytest-django a settings module with no SECRET_KEY | A     |
| `shipped-readme.sh` globbed the working directory, so a generated gitignored file failed an audit a fresh clone passed                                                                                                                                                                                                                                                                                          | B     |
| `test.yml`'s auth gate measured `apps/users/*`, an app that does not exist                                                                                                                                                                                                                                                                                                                                      | B     |

### Still open, found on the way

- **`COVERAGE.md`** documents `-n auto` and two other pytest flags that are not in
  `addopts`, and `pytest-xdist` is not a declared dependency.
- **The dev stack and every generated project both claim `10.0.1.0/24`**, so they cannot run
  concurrently on one host. Only the base pair collides; worktrees offset by story number.
- **`pnpm-update.sh`'s header** claims files it no longer updates.

---

## Format

New items are recorded here first, in the format below, then charted onto a feature map at the
next pass. The blank seed at `.copier/GAPS.md` carries the same format, so an entry reads
identically in a generated project:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

## 31/08/2026 — the PE gate's markup half cannot see structure, and the prefix set cannot be measured

Two deferrals from `MAP-PROGRESSIVE-ENHANCEMENT.md`'s final resolve sitting (batches C and E,
31/08/2026). **Neither is a `DEFERRED.md` row**, though N-021's reads like one: that file's own
rule targets a named future `US###` and is written from an implementation doc, and no story has
been cut from this map yet. A row targeting "the first story that writes real CSS" would be a
target no sprint planner can look up.

**1 — A line-oriented PE gate cannot decide the clauses that matter most.** N-013 settled the PE
markup gate as `awk`/grep only, because no HTML or Django-template AST
exists in this repository and Opengrep's template rules are `generic` + `pattern-regex`. That
decides the presence clauses (`hx-boost`, `x-cloak` without its rule, `historyCacheSize: 0`) and
**cannot** decide the structural ones: a `<form>` with no `action`, an `hx-*` attribute with no
server-side fallback route, an interaction placed on the wrong rung. A tag-accumulating scanner
would be the repo's first, against zero templates.

**Blocked by / Action:** Nothing blocks it; it is deliberately not built. Revisit when
`code/src/django/templates/` holds real pages — the gate's own header must say what it does not
check, so a green run is never read as structural proof (`code/docs/GATE-REPORTING.md`).

**2 — N-021's prefix set cannot be re-measured inside this epic's bounds.** The measurement is
**9 properties and 5 values** (not the "nine" the map said in three places), recorded nowhere but the feature map that
measured it. `autoprefixer` is absent from `node_modules/` and has zero
occurrences in `pnpm-lock.yaml`, and the epic declines it twice as a **tool** — it was only ever a
measuring instrument. The only tracked `.css` file in the repo is a PM wireframe artefact, which
carries the repo's single vendor prefix (`-webkit-text-size-adjust`).

**Blocked by / Action:** Blocked on real CSS existing. `S-02` ships the `@eslint/css` half — which
**is** the support policy — and explicitly omits the prefixes. Retire this half when the first
story writing component CSS re-measures the set and states where it lives.
