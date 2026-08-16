# Template Gaps — syntek-base's own open items

**Last Updated**: 14/08/2026 | **Maintained By**: Syntek Studio

Open items belonging to **`syntek-base` itself** — the template repository, not any project
generated from it.

> **Why this file exists, and why it is here.** The root `GAPS.md` is a **shipped template
> file**: `copier.yml` does not exclude it, so whatever it contains is rendered into every
> generated project. Recording the template's own gaps there leaked syntek-base's internal
> state into unrelated projects, where the entries were meaningless and misleading. `GAPS.md`
> is therefore kept as an empty stub, and the template's own items live here — in
> `TEMPLATE-GUIDE/`, which **is** excluded, so it is durable in git yet never ships.
>
> The same reasoning that put ADR-era design rationale in `02-STACK.md` and `11-CUSTOMISING.md`
> rather than in `14-DECISIONS/`. See `.claude/MEMORY.md` → _Template-development reasoning
> lives in `TEMPLATE-GUIDE/`_.

---

## The active items live on a map, not here

**Charted 13/08/2026.** The twenty-two actionable entries this file used to carry were charted
into `project-management/src/01-FEATURE/MAP-BASE-HEALTH.md` — twenty-three decision nodes in
five batches — and removed from here, so there is one working copy rather than two that drift.

> **That map is deliberately untracked.** `project-management/src/.gitignore` is an allowlist,
> so `MAP-BASE-HEALTH.md` is local to a working clone and never ships. **A fresh clone will not
> have it.** The full prose of every entry it replaced is recoverable with:
>
> ```bash
> git show e16b499:how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md
> ```
>
> The name is load-bearing: a map called `MAP-TEMPLATE-*.md` matches the allowlist's
> `!*TEMPLATE*` negation, becomes tracked, and ships into every generated project — which is the
> defect this file exists to prevent.

The five batches on that map are named as reusable **defect classes**, so a later map inherits
the taxonomy rather than inventing a grouping: **A** token blast radius · **B** false green ·
**C** inheritance leak · **D** split doctrine · **E** declared, not built.

---

## Standing limitations

**Read these; do not try to finish them.** Each is an accepted property of developing a template
rather than a task, so neither belongs on the map. A new one is added here only when a gap is
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

---

## N-035 — settled and built, 16/08/2026

The node that closed both entries above. Fifteen decisions were taken across three grilling
rounds and carried out in one sitting; they are recorded here because a decision that lives
only in a session transcript is not a decision anyone can act on later.

| #   | Decision                                                                                    | Where it landed                                        |
| --- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| Q1  | Commit `uv.lock`, gated on a proven compose healthcheck and a real `/health/` first         | `uv.lock`, root `CONTEXT.md`                           |
| Q2  | Settle the three non-lock blockers here rather than folding them in silently                | this table, Q4/Q8/Q9                                   |
| Q3  | Fix the live false green; chart `claude.yml`'s unevidenced "Verified green" separately      | `test.yml`, `pre-pr-check.sh`                          |
| Q4  | `audits/security.sh` gains `--frozen` so it can never manufacture the lockfile              | `code/src/scripts/audits/security.sh`                  |
| Q5  | New **`apps.health`**, scaffolded via `new-django-app.sh` — not folded into `apps.core`     | `code/src/django/apps/health/`                         |
| Q6  | Liveness + readiness over the dependencies that exist; API and pages arm as they land       | `apps/health/checks.py` — `Component` has two members  |
| Q7  | Cover the template to 75%: the health app plus the four uncovered `core` modules            | 100% over 162 statements                               |
| Q8  | The 90% auth leg is re-pointed and prints its denominator                                   | `backend-coverage.sh` owns it; `test.yml` now calls it |
| Q9  | Explicit `--group test` at test call sites; `test-e2e.yml` gains the `uv sync` it never had | `e2e-py.sh`, `test-e2e.yml` (`uv sync --locked`)       |
| Q10 | Dependency pruning is charted as its own node, not settled here                             | still open — `MAP-BASE-HEALTH.md`                      |
| Q11 | One sitting, all of it, on this branch; the PR to `main` is gated on it being green         | this branch                                            |
| Q12 | Toolchain and all three lockfiles to latest first, then lock                                | uv 0.12.5, pnpm 11.22.0, `Cargo.lock`                  |
| Q13 | `uv.lock` added to copier `_exclude` — never travels, no `copier update` conflict           | `copier.yml` `_exclude` + the `uv lock` post-task      |
| Q14 | Both standing limitations deleted; one true limitation replaces them                        | SL-1 above                                             |
| Q15 | Forced N-036 subset only, then re-chart N-036 against the remeasured file list              | done; N-036 still open                                 |

**`uv run` re-locks silently by default.** `--locked` asserts the lockfile is unchanged and
exits non-zero if it is not; `--frozen` uses it as-is without checking. In CI the first is
almost always what is wanted, because a bare `uv run` turns a stale lock into a green run
against versions nobody committed. Verified against uv's own CLI definitions, 16/08/2026.

### What the sitting found because the guards came off

Each of these was invisible while a guard reported "not applicable", and each was reachable
in a **generated project** — so the template was shipping them:

| Defect                                                                                                                                                                                  | Class |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `pre-pr-check.sh` `_dc`/`_tc` passed no `--env-file`, so every container check failed                                                                                                   | B     |
| `dev_running`/`test_running` grepped `backend`/`backend-test` — services that do not exist here (they are `django`/`django-test`), so the gate would `exit 2` on every run in a project | B     |
| `pre-pr-check.sh` sourced `.env.dev` with bash, which aborts on `POSTGRES_USER=<%PROJECT_SLUG%>`                                                                                        | A     |
| `shipped-readme.sh` globbed the working directory, so a generated gitignored file failed an audit a fresh clone passed                                                                  | B     |
| `test.yml`'s auth gate measured `apps/users/*`, an app that does not exist                                                                                                              | B     |

### Still open, found on the way

- **`server.sh:112`** sources `.env.dev` with bash for its URL banner and hits the same
  token-parse failure as the hook did. The banner is the thing `.claude/CLAUDE.md` Section 7
  tells everyone to trust instead of quoting a URL from memory, and it does not print.
- **`COVERAGE.md`** documents `-n auto` and two other pytest flags that are not in
  `addopts`, and `pytest-xdist` is not a declared dependency.
- **The dev stack and every generated project both claim `10.0.1.0/24`**, so they cannot run
  concurrently on one host. Only the base pair collides; worktrees offset by story number.
- **`pnpm-update.sh`'s header** claims files it no longer updates.

---

## Adding a new gap

New items are recorded here first, in the format below, then charted onto
`MAP-BASE-HEALTH.md` at the next pass. **Format** matches the root `GAPS.md` so entries can move
either way:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

_No uncharted entries._
