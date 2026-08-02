# Template Gaps — syntek-base's own open items

**Last Updated**: 02/08/2026 | **Maintained By**: Syntek Studio

Open items belonging to **`syntek-base` itself** — the template repository, not any project
generated from it.

> **Why this file exists, and why it is here.** The root `GAPS.md` is a **shipped template
> file**: `copier.yml` does not exclude it, so whatever it contains is rendered into every
> generated project. Recording the template's own gaps there leaked syntek-base's internal
> state into unrelated projects, where the entries were meaningless and misleading. `GAPS.md`
> is therefore kept as an empty stub, and the template's own items live here — in
> `TEMPLATE-GUIDE/`, which **is** excluded, so it is durable in git yet never ships.
>
> The same reasoning that put ADR-era design rationale in `02-STACK.md` and `10-CUSTOMISING.md`
> rather than in `13-DECISIONS/`. See `.claude/MEMORY.md` → _Template-development reasoning
> lives in `TEMPLATE-GUIDE/`_.

**Format** matches the root `GAPS.md` so entries can move either way:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

## 02/08/2026 — The five new how-to workflows have never been executed

**Type:** Active gap — **verification debt**
**Summary:** `04-database-operations`, `05-testing-and-coverage`, `06-quality-gates`,
`07-dependency-updates` and `09-write-operator-guide` were written against the real scripts and
their real flags, and every command in them was confirmed to exist. But they have not been **run
start to finish on a clean environment**, which is precisely the rule the `runbook` skill and
workflow `09` impose on every operator guide. They are currently verified by review only, and
review does not find a missing prerequisite.

The same root cause as the entry below applies to two of them: without `uv.lock` the Django image
cannot build here, so `04` and `05` cannot execute in this repository at all.
**Blocked by / Action:** Execute all five in a freshly generated project — `04` and `05` require
it — and correct each from what actually happens rather than from what was intended. Until then,
treat their step-by-step commands as reviewed, not proven.

---

## 02/08/2026 — The backend test suites never execute in this repository

**Type:** Active gap — **known limitation, accepted**
**Summary:** `uv.lock` is absent by design in the base template: it would pin the root project
under the literal project-slug token, so Copier generates it at generation time. Every
Dockerfile builds with `COPY pyproject.toml uv.lock ./`, so the Django image cannot build here
at all. `test.yml`, `test-api.yml` and `test-e2e.yml` now guard at **step** level on `uv.lock`
and report success with an explanatory log line instead of failing.

That is honest — there is genuinely nothing to run — but the consequence must be stated: **the
template never verifies its own backend, API or browser suites.** They are exercised for the
first time in a generated project. Before the guard they failed on every pull request, which was
worse: a permanently red check nobody could act on, and one that could never be made required.
**Blocked by / Action:** None to fix here. The realistic verification is the generation smoke
test in `audit-template.yml`, plus running the suites once in a freshly generated project after
any change to `code/src/django/`, the Dockerfiles, or the compose files. Treat a green
`pytest + coverage` in this repository as "not applicable", never as "passing".

## 02/08/2026 — `pytest + coverage` is not yet a required status check

**Type:** Infrastructure gap
**Summary:** Ruleset `20221742` requires eight lint/audit/template checks plus the four mobile
jobs (`jest-expo + coverage`, `Bundle export`, `ESLint (mobile surface)`,
`TypeScript (mobile surface)`). `pytest + coverage` was deliberately left out: at the time it
could never report success here, so requiring it would have blocked every pull request.
**Blocked by / Action:** The lockfile guard above now lets it report success. Add it to the
required set once it has been green on `main` for a few runs — remembering, per the entry above,
that green means "skipped, nothing to run" in this repository.

## 02/08/2026 — Expo SDK tracking has no owner and no trigger

**Type:** Active gap
**Summary:** The mobile surface pins Expo SDK 57 exactly, and the template's own commitment to
track SDK releases has no named owner and no trigger condition. The first evidence of how fast
the set moves: the epic's research was done against SDK 55 and every "obvious" version choice
turned out wrong — Expo pins TypeScript ~6 (not 7), jest-expo 57 is on the **Jest 29** line (not
30), expo-router 57 needs React Native Testing Library **13** (not 14), and `eslint-config-expo`
is not ESLint 10 compatible. Each was found only by running the toolchain.
**Blocked by / Action:** Decide a cadence and an owner. An SDK bump is a versioned template
release that flows downstream through `copier update`, not a routine dependency bump.

## 02/08/2026 — Delimiter-safety guard is one-sixth implemented

**Type:** Active gap
**Summary:** `.github/scripts/check-template-tokens.sh` scans for the unclosed
variable-opening sequence only — one of the six delimiter forms. `copier.yml` claims its
delimiter set was chosen by scanning every tracked file for zero occurrences, but that analysis
predates both the mobile epic and the TypeScript in the tree. A literal scan already missed one
site, because markdown tables write the pipe as an escaped character.
**Blocked by / Action:** Extend the script to all six sequences **including markdown-escaped
forms**, or it will keep reporting a false all-clear.

## 02/08/2026 — `pnpm audit` is red for pre-existing reasons

**Type:** Active gap
**Summary:** The scheduled `audit-deps.yml` sweep runs `pnpm audit --audit-level low` and
reports roughly 20 advisories, almost all `axios` reached through `@usebruno/cli` — dev-only
API-test tooling. Separately, `pip-audit` cannot parse the root `pyproject.toml` here, because
the project name is an unrendered token rather than a valid package name, so the Python half of
`security.sh` never reports usefully while working on the template.
**Blocked by / Action:** Either bump or replace `@usebruno/cli`, or add the advisories to
`auditConfig.ignoreGhsas` with a written rationale. Consider making `security.sh` skip the Python
half with a clear message when the manifest is an unrendered template, mirroring the CI guards.
