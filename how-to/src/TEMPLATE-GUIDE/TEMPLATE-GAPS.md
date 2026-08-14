# Template Gaps — syntek-base's own open items

**Last Updated**: 13/08/2026 | **Maintained By**: Syntek Studio

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

### SL-1 — The backend, API and browser suites never execute in this repository

`uv.lock` is absent **by design**: it would pin the root project under the literal project-slug
token, so Copier generates it at generation time. Every Dockerfile builds with
`COPY pyproject.toml uv.lock ./`, so the Django image cannot build here at all. `test.yml`,
`test-api.yml`, `test-e2e.yml` and `claude.yml`'s `[7/8] Tests` guard at **step** level and
report success with an explanatory log line.

`[7/8] Tests` was the exception until 14/08/2026, and the reason is worth keeping: it also
declared GitHub **service containers**, which initialise _before_ the first step. A step-level
guard cannot gate one, so the job died at `Initialize containers` on every run from 03/08/2026
while its guard sat unreachable below. It now drives `docker-compose.test.yml` like its
siblings. **The rule that leaves: a job carrying a `services:` block is not covered by the
lockfile guard, whatever its steps say.**

**The rule this leaves:** treat a green `pytest + coverage` in this repository as **"not
applicable"**, never as "passing". The suites are exercised for the first time in a generated
project. The realistic verification is the generation smoke test in `audit-template.yml`, plus
running the suites once in a freshly generated project after any change to `code/src/django/`,
the Dockerfiles, or the compose files.

This is permanent. `MAP-BASE-HEALTH.md` `N-001` does **not** touch it — that node fixes the
manifest's package _name_, which is a different root cause from the missing lockfile.

### SL-2 — Python rules here are proved by the host `ruff` binary and by nothing else

**Temporary — retire this when `MAP-BASE-HEALTH.md` `N-002` lands.**

Every Python CI job runs `uv sync --only-dev` first, and `uv` refuses to parse `pyproject.toml`
at all, because line 2 is `name = "<%PROJECT_SLUG%>"` and that is not a valid PEP 508 package
name. All three ruff/basedpyright jobs therefore fail at the sync step. The same root cause takes
out the three Python lefthook hooks and the `pip-audit` half of `security.sh`.

**The rule this leaves, until `N-001`/`N-002` land:** treat every `.py` change here as verified
by the directly-installed host `ruff` binary — which parses no manifest and works fine — and
**never cite CI as evidence for a Python rule in syntek-base**. Any template-level tooling that
shells out to `uv run` fails in the base repo and works in a generated project; prefer
`uv run --no-project --with <dep>` where the work does not need the project's own environment.

The rules themselves are sound and **do** run in a generated project, where the token renders to
a real name.

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
