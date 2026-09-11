# GAPS.md — syntek-base's own open items

**Last Updated**: 11/09/2026 | **Maintained By**: Syntek Studio
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

---

## 31/08/2026 — htmx is pinned at major 2, and the v4 migration waits on two named triggers

**Type:** Planned feature
**Summary:** `MAP-ABSENCE.md` N-012 (31/08/2026) pinned the htmx doctrine to major **2**,
**self-vendored** like Alpine (self-hosted, never a CDN, vendored by the first page that uses
it) — django-htmx was dropped the same day (declared, entirely unwired, every guide hand-rolls
its headers; removal is a `MAP-ABSENCE.md` S-03 leg). No page loads htmx yet, so the pin is
doctrine nothing loads. htmx 4.0.0 went GA on 28/08/2026, but npm `latest` is still 2.x.
v4 renames every event to the colon-segmented grammar
(`htmx:before:swap`), swaps 4xx responses by default, and needs `hx-headers:inherited` for the
`<body>` CSRF pattern — roughly eleven shipped surfaces plus `negative-space.sh`'s
`htmx-handler-absent` clause encode the v2 grammar. A silent upgrade would therefore falsify
shipped doctrine and blind the error handler.
**Blocked by / Action:** Migrate only when **both** triggers fire: the repo chooses to vendor
the 4.x GA (npm `latest` has moved and the event-grammar migration is charted), **and** a base
template exists that actually loads htmx. The migration is then its own charted feature (event
grammar, swap policy, CSRF inheritance, the gate regex) — never a side-effect of another
story.

---

## 01/09/2026 — a RUSTSEC advisory against an unchanged `Cargo.lock` is invisible

**Type:** Active gap
**Summary:** `audit-deps.yml` — the only scheduled workflow of 35 — sweeps JS and Python CVEs
daily but has **no cargo step**. `cargo deny check advisories` runs only via `syntax-rust.yml`
→ `rust/audit.sh:51`, and that workflow is path-filtered to `code/src/rust/**` with no
schedule, so an advisory published against an unchanged `Cargo.lock` goes unseen until
somebody edits a Rust file — the exact continuous-drift failure `audit-deps.yml` was written
to close for the other two lockfile ecosystems. Re-verified 01/09/2026. Routed here from
`MAP-UPSTREAM-TRACKING.md` N-021 (Sam, `Q6→2`, 28/08/2026) — corrected on the map, fix
deliberately not adopted there.
**Blocked by / Action:** Nothing blocks it. Add a cargo-deny advisories leg to
`audit-deps.yml` (or an advisories-only scheduled entry for the Rust gate), reporting into the
same aggregated tracking issue the existing legs use.

---

## 01/09/2026 — staging and production have no mail backend, so mail is silently discarded

**Type:** Active gap (blocker — a decision with no story behind it)
**Summary:** `MAILERS` is defined in `code/src/django/config/settings/dev.py:22-29` (console)
and `test.py:24-27` (locmem) only. `base.py`, `staging.py` and `production.py` define neither
`MAILERS` nor any `EMAIL_*` setting, so both deployed environments fall through to Django's
default SMTP backend against `localhost:25` — unconfigured, undocumented, and failing or
discarding every send with no signal. Django 6.1 deprecates the whole `EMAIL_*` family
(`RemovedInDjango70Warning`) and the two forms are mutually exclusive, so the fix is a
`MAILERS` entry, never an `EMAIL_BACKEND` one. Measured 01/09/2026 from
`MAP-CAP-POSTURE.md` N-017; the map states the posture and deliberately does not fix it, because
the posture is `development` (nothing deployed — `how-to/src/DEPLOYMENT-POSTURE.md`) and
choosing a relay is a real decision, not a doc repair.
**Blocked by / Action:** Nothing blocks it. A story picks the staging and production relay
(provider, credentials as environment variables, connection and read timeouts) and adds the
`MAILERS` entry to both settings modules. `code/docs/NOTIFICATIONS.md` is still
declared-not-wired, so this lands with the notification surface rather than ahead of it —
but the silent fall-through is a defect in its own right and should not wait for a
notification feature to be scheduled.

---

## 01/09/2026 — the story `**Status:**` header carries two competing vocabularies

**Type:** Active gap
**Summary:** One field, two canonical sets, and both self-declare. `.claude/skills/completion/SKILL.md:37-41`
defines five states for a `US###.md` header (`Pending · Open · Blocked · In Review · Completed`);
four other surfaces define the **same header** with the eleven-state ClickUp vocabulary —
`project-management/docs/planning/STORIES.md:79-93`, which states outright "This is the canonical
set", the `Status` row of the header table in
`project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`,
`.copier/README.md:568-570`, and `project-management/workflows/23-pr-and-review/STEPS.md:73-74`, <!-- doc-references: template-only -->
which moves a story to `Accepted` / `Accepted Customer` — values the five-state set does not admit,
so the shipped PR workflow instructs a transition the shipped completion skill forbids. Class **D**,
split doctrine. Surfaced 01/09/2026 while resolving `MAP-REGISTER-INDEXES.md`'s fog, which parked it
as "belongs to whoever owns the story lifecycle" and correctly declined to settle another register's
semantics to make its own index fillable.
**Blocked by / Action:** Nothing blocks it. A pass decides which vocabulary wins, or writes the
mapping that reconciles them, and repairs all five surfaces in one change. **Two consumers make the
repair wider than the five sites:** `00-STORY-PLAN-US000-TEMPLATE.md`'s `## Definition of Done`
requires the status to agree across story + plan + sprint/sprint-plan, including the plan's row
in the sprint plan's _Story Plans — the code master_ table, and
`MAP-REGISTER-INDEXES.md` N-003's gate will string-equal the field in "STORY-INDEX.md" and
"STORY-PLAN-INDEX.md", so a reconciliation lands with both indexes and the gate's
`broken/`+`clean/` fixtures. The gate is indifferent to _which_ set wins —
it mirrors verbatim — but not to the cost. Likely charting home is `MAP-RULE-OWNERSHIP.md`, four of
the five sites sitting inside the surfaces its four architecture passes measured; its frontier is
closed, so this is recorded here first per the Format section above.

<!--
08/09/2026 — the story plans gained an `<exec-order>` prefix, so both citations above were
re-pointed and de-numbered to their section names; the template is being edited in the same pass
and a line anchor would go stale on landing. Superseded citations, verbatim:
"project-management/src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md:9" and
"STORY-PLAN-US000-TEMPLATE.md:773". The 01/09/2026 finding itself is unchanged.

08/09/2026, later the same day — the template's `## Definition of Done` stopped naming a Plans
Index (none exists; the template was re-pointed at the sprint plan's _Story Plans — the code
master_ table), so the consumer clause above was corrected in place to the template's current
wording. Superseded clause, verbatim: "requires the status to agree across story + plan + Plans
Index + sprint". The 01/09/2026 finding and the index-gate sentence are unchanged.

08/09/2026, evening — the two index filenames in the index-gate sentence, left alone by the note
above, were de-backticked to "double quotes": neither "STORY-INDEX.md" nor "STORY-PLAN-INDEX.md"
exists anywhere in the repository (the story US007 records both as absent), and the citation
gate reads backticked tokens. Nothing else in the 01/09/2026 finding is touched.
-->

---

## 01/09/2026 — the `CONTEXT.md` index-row instruction survives in three shipped files no slice repairs

**Type:** Active gap
**Summary:** `MAP-REGISTER-INDEXES.md` N-001 (31/08/2026) relocated the map index out of the shipped
`CONTEXT.md` into a seeded map-index file of its own, and every map in `01-FEATURE-MAPS/` has declined the index
row on the record. But the instruction to add it is still shipped in three places:
`.claude/skills/wayfinder/SKILL.md:97-98` ("Add the map to the index in
`src/01-FEATURE-MAPS/CONTEXT.md`") with `:256` naming that file "the map index, where a new map is
registered", and `project-management/src/01-FEATURE-MAPS/CLAUDE.md:22-23` and `:26`, which repeat it
as a concrete step **and** a definition-of-done. That map's S-01 scopes itself to
`MAP-000-TEMPLATE.md:8`/`:146` plus the seven `CONTEXT.md` H2s — the wayfinder skill and the folder
`CLAUDE.md` are in no slice on any map. Meanwhile `01-FEATURE-MAPS/CONTEXT.md:47` reads
"_None charted yet_" against **12** maps present, under that file's own rule at `:50-52` that a map
with no row is "an index that has drifted". So the shipped instruction, the shipped
definition-of-done and the shipped index are all currently false, and the work to make them true is
unowned. Surfaced 01/09/2026 while resolving `MAP-GATE-PARITY.md`'s fog, whose own entry said the
exception "is not this map's to write" — correct, and now discharged to nobody.
**Blocked by / Action:** Nothing blocks it. Either widen `MAP-REGISTER-INDEXES.md` S-01's Acceptance
to name the three sites, so they are repaired in the same change as the seeded map index ships, or repair
them independently. This entry retires when the three files stop instructing a row into a shipped
file.

---

## 02/09/2026 — `doc-references.sh` applies its shipped-file citation rule to a tree that never ships

**Type:** Active gap
**Summary:** Check 2 of `code/src/scripts/audits/doc-references.sh` (`:673-678`) bans a citation to
a per-project instance artefact — `US###`, `SPRINT-##`, `ADR-###`, `MAP-*`, `*-PLAN-US###` — on the
stated reasoning that the reader of a generated project has no such file. It never tests whether
the **citing** file ships. `copier.yml` <!-- doc-references: template-only --> line 152 excludes `/project-management/src/**` and re-includes
only `**/CONTEXT.md`, `**/CLAUDE.md` and `**/*TEMPLATE*`, so a story, sprint record, QA plan and
ADR are all copier-excluded — the rule's premise does not hold for any of them. It has now fired
twice on correct, resolvable citations: seven findings on the first draft of `project-management/src/02-STORIES/US001.md` (01/09/2026) and
nine on its QA plan (01/09/2026). The exemption arm at `:333` already carries this reasoning for
`project-management/src/01-FEATURE-MAPS/*` and for the `WALK-*` evidence files; the rest of
`src/` has no equivalent.

**Corrected 02/09/2026 — the rule also UNDER-applies, and the original wording here repeated a
false mechanism.** This entry previously read that the check "records a finding only where the
token does not resolve (`[ ! -e "$token" ]`), so a full repo-relative path passes and a bare
filename does not". A full path does not _pass_ that test — it never reaches it. Check 2's regex
at `:675` is `^`-anchored, so a token beginning `project-management/` matches no alternative and
the block containing the existence test is never entered; and Check 1's checkable-tree `case` at
`:762-780` has **no `project-management/src/*` arm**, so the same token falls to `*) continue`
before its own existence test. **No gate checks a PM `src/` instance citation in either form.**
Proof in the tree: `project-management/src/02-STORIES/US001.md` cites
`../18-TESTS/US001-MANUAL-TESTING.md` twice, that file does not exist, and the audit exits 0.
Two further defects found by the same measurement — the alternation still carries `ADR-[0-9]{3}`,
the counter retired 31/08/2026, and `QA-US[0-9]{3}` against the live
`QA-PLAN-US###-<DESCRIPTOR>.md` spelling, so **no ADR or QA-plan filename is checkable in any
form**. The interim convention is unchanged and now argued honestly in
`project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`, which
supersedes `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md`
for claiming the full path was machine-verified.
**Third symptom, measured 02/09/2026 — the rule fires INCONSISTENTLY on identical citation
forms.** On that date `project-management/src/02-STORIES/US001.md` and
`project-management/src/03-SPRINTS/SPRINT-01.md` both cited PM `src/` artefacts by full
repo-relative path and scanned **clean**, while `project-management/src/02-STORIES/US003.md`,
`project-management/src/03-SPRINTS/SPRINT-02.md` and
`project-management/src/11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` cited in the
byte-identical form and produced twelve
`[template-only citation]` findings between them. Extracting US001's two Decisions bullets
verbatim into a probe file made them fire immediately, so the difference was not the citation
form and not the citing directory. `is_exempt()` (`:311`) covers
`project-management/src/01-FEATURE-MAPS/*` but no other `src/` tree; the register at
`how-to/src/PROJECT-PATHS.md` holds three rows, none of them relevant; and the naming-row rule
does not apply. **The mechanism is not established**, and the fix must not be attempted until it
is — a repair aimed at the wrong cause would silence the finding rather than correct it.
**Re-measured 09/09/2026 at `ff24084`, those per-file verdicts no longer hold** — and they were
produced by a different instrument, `96982d3` (08/09/2026) having added Check 4 and widened
Check 2's alternation in between. US001 is still clean (0). SPRINT-01 is not: 10 findings, eight
`[instance citation]` and two `[dangling path]`. US003, SPRINT-02 and the QA plan produce **30**
between them — 13 instance and 17 dangling — and **no** `[template-only citation]` at all. The
02/09/2026 observation stands as a dated record that the rule fired inconsistently; the class
labels and per-file verdicts attached to it are that day's, not today's. The whole-run total,
re-measured **09/09/2026** at `ff24084` on a clean tree, is **253 findings** (exit 1): 135
instance citations and 106 dangling paths, every one of them cited **from** a file under
`project-management/src/`, plus 12 template-only citations, nine of which are this entry's own —
eight above this sentence and the disposition citation that closes this paragraph. That is
against 22 on 02/09/2026 — the figure `c57a8ed`'s commit message records, and one that does not
reproduce at that commit: re-run there on 09/09/2026, the gate returns 26 (15 dangling, 11
template-only). It is **not comparable** for a second reason too: the gate changed once
between the two runs (`96982d3`, above) and the tree gained artefacts — 246 to 274 files under
`project-management/src/` — so part of the rise is the instrument seeing a class it previously
could not, not the tree accumulating citations, and the two shares are not apportioned here. 253
is also the **pre-edit baseline** the disposition below requires, never a claim about the merge
commit; US008's own change adds nothing to it — measured 09/09/2026 per file with `--path`, this
file's count is unchanged at nine, and the story, its two ADRs and its one map edit contribute
none, so the tree US008 lands on still runs at 253. Disposition while the gate stays red:
`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`.

**Blocked by / Action:** `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06` owns the first edit to
`doc-references.sh` and is itself blocked on that map's RESOLVE sitting. The fix is now **four
changes, not one**: a `project-management/src/*` arm on Check 1's checkable-tree `case`; the
`ADR-US###` and `QA-PLAN-US###` spellings in Check 2's alternation; a decision on whether Check 2
should exempt copier-excluded citers outright; and fixtures covering a dead PM citation, which
today's `broken/` set does not. Either widen `S-06`'s acceptance to carry all four, or take it
independently once the sitting has settled who owns the file. This entry retires when a
copier-excluded artefact can cite another by its short name without a finding, a dead
citation to a PM `src/` artefact is caught, **and** the inconsistency above is explained rather
than merely no longer firing.

<!--
09/09/2026 — the whole-run total in the Summary was re-measured at ff24084 on a clean tree and
corrected in place; the 02/09/2026 two-part split (forward references / this class) was replaced
by the classes the gate itself reports. Superseded sentence, verbatim: "The whole-run total on
02/09/2026 was **22 findings**: 10 forward references to a guide US003 creates, and 12 of this
class." The 02/09/2026 finding, its mechanism and the disposition are unchanged.

09/09/2026, later — the same paragraph's 02/09/2026 per-file verdicts were re-measured at
ff24084 and found not to hold (SPRINT-01 10 findings; the US003 group 30, none template-only),
so they are date-qualified in place rather than replaced; the 22 is marked non-comparable
because the gate changed at 96982d3 between the two runs; and the paragraph now states what
US008's own change adds to the baseline (nothing, measured per file). Superseded wording,
verbatim — the paths in those sentences are unchanged and are not repeated here, because the
gate reads a backticked path inside a comment as it reads one in prose: "both cite PM `src/`
artefacts by full repo-relative path and scan **clean**.", "cite in the byte-identical form
and produce twelve" and "so the difference is not the citation form"; the lead-in "On that
date" is new. Nothing else in the entry is touched.
-->

---

## 09/09/2026 — the staging/production security-settings block ships twice and has already drifted

**Type:** Active gap
**Summary:** The fenced Python block under `code/docs/security/AUTH-AND-AUTHZ.md`'s _Django
Security Settings (staging and production)_ heading and the one under
`code/docs/security/OWASP-AND-CHECKLIST.md`'s _Django Stack_ heading, led in by "Security
settings that must be enabled in staging and production", carry the same settings. Measured
09/09/2026: a `diff` of the two settings bodies — OWASP's `# settings/production.py` first line
excluded — returns exactly one hunk,
`8a9 > SECURE_BROWSER_XSS_FILTER = True`, so the eight shared settings are byte-identical and in
identical order — and the copies already differ in two respects, the ninth setting
`SECURE_BROWSER_XSS_FILTER`, last in the OWASP fence, and the `# settings/production.py` comment
on that fence's first line, neither of which the `AUTH-AND-AUTHZ.md` copy carries. Line anchors
are deliberately omitted here: US008 edits both fences and both settings modules below, and the
08/09/2026 note above records why an anchor into a file the same story edits goes stale on
landing. The ninth is dead: the Django 6.1 that `uv.lock` pins and `.venv` holds declares twelve
`SECURE_*` names in its `global_settings.py` and `SECURE_BROWSER_XSS_FILTER` is not among them,
with zero hits across its `conf` and `middleware` packages, so the OWASP copy ships a line
Django no longer reads. Nor does either copy describe what runs:
`code/src/django/config/settings/production.py` assigns six of the shared eight —
`X_FRAME_OPTIONS` and `SECURE_CONTENT_TYPE_NOSNIFF` are not assigned there, though both hold as
Django's defaults — plus `SECURE_PROXY_SSL_HEADER`, which neither guide lists; and
`code/src/django/config/settings/staging.py` is further off again, assigning only three of the
eight (`SECURE_SSL_REDIRECT`, `SESSION_COOKIE_SECURE`, `CSRF_COOKIE_SECURE`) and no HSTS setting
at all, while both fences are headed _staging and production_. Class **D**, split doctrine — one
rule, two homes, neither routing to the other. US008 (the cookie doctrine,
`project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` <!-- doc-references: template-only --> S-02)
adds `CSRF_COOKIE_HTTPONLY = True` beside `CSRF_COOKIE_SECURE` in **both** blocks rather than
collapsing them: a story landing the cookie doctrine is not the change in which two security
guides swap ownership of a block, so the paste keeps the copies in step and this row holds the
collapse.
**Blocked by / Action:** Nothing blocks it. One block becomes canonical and the other routes to
it in a sentence; `SECURE_BROWSER_XSS_FILTER` goes; the survivor is reconciled with **both**
`code/src/django/config/settings/production.py` and `staging.py`, which are what actually run,
and says which of its lines are Django defaults rather than assignments and which hold in only
one of the two environments. Retire when `SECURE_SSL_REDIRECT` appears in exactly one guide
under `code/docs/security/`.

---

## 09/09/2026 — a print-only `_migrations:` advisory is invisible in the `template-update.sh` preview

**Type:** Active gap
**Summary:** `code/src/scripts/development/template-update.sh:143-144` runs the preview
`copier update` against a scratch clone with stdout and stderr redirected wholesale to
`$UPDATE_LOG`; `:148-151` shows the log (`tail -20`) only when copier exits non-zero, and
`cleanup()` (`:122`), registered on `EXIT` at `:123`, unlinks it, so nothing survives to be read
afterwards. Two of the six shipped migrations under `.copier/migrations/` <!-- doc-references: template-only --> are advisories — they
print guidance and always exit 0: `v3.0.0-self-authored-agents.sh`, whose header says it "cannot
fail an update", and `v5.0.0-git-guide-split.sh`, headed "WHY THIS ADVISES RATHER THAN ACTS".
The other four act on the project tree — `v2.0.0-renumber-src.sh` and `v7.0.0-renumber-src.sh`
move stranded artefacts, `v4.0.0-manifest-name.sh` restores the manifest name,
`v6.0.0-rename-feature-surfaces.sh` is headed "WHY IT ACTS ON DIRECTORIES" — and what they do to
the scratch clone surfaces in the preview's modified/deleted/added counts and its orphan audit.
An advisory leaves no such trace: its whole effect is the text the redirect swallows, so the
preview, which is the step a human reads before deciding to `--apply`, shows none of it, and
prints "Preview only — your project is unchanged" (`:275`) over an update whose migration had
something to say. The `--apply` invocation at `:281-282` is not redirected, so the advice reaches
the terminal exactly once, after the decision it was written to inform. Class **B**, false
green. Measured 09/09/2026 while cutting US008, whose planned v7.6.0 entry — `CSRF_COOKIE_HTTPONLY`
and the per-environment `__Host-` cookie names — will be exactly such an advisory; the story
accepts the blindness and does not fix the script.
**Blocked by / Action:** Nothing blocks it. Either the preview echoes copier's output on success
as well, filtered to the migration section before the trap deletes the log, or the log is kept
and its path printed beside the "Preview only" line. Retire when a print-only advisory's text
appears in the output of a successful preview.

---

## 11/09/2026 — `install-frontend.sh --local` hands two stray arguments to `sudo rm -rf`

**Type:** Active gap
**Summary:** `code/src/scripts/development/install-frontend.sh:79-81` ends the path line of its
`sudo rm -rf` with a line continuation, so the next line — `log "Removed."` — is parsed as two
further arguments rather than a log call. `--local`, and its `--clean` alias, therefore runs
`sudo rm -rf "$PROJECT_ROOT/node_modules" log Removed.` from the project root (the script `cd`s
there first) and never prints "Removed.". Measured 11/09/2026: neither `log` nor `Removed.` exists
at the root, so `-f` swallows both silently and nothing is lost **today** — the hazard is latent:
anything later named `log` at the root is deleted as root, with no message. Root `install.sh:421`
reaches this path on every first-time setup. The step's premise is stale as well: it removes
"Docker-owned" `node_modules`, but no image installs Node (`code/src/docker/django/CLAUDE.md`).
Class **B**, false green — the step reports nothing and exits 0 either way. Found by the footprint
sweep that charted `project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md`. <!-- doc-references: template-only -->
**Blocked by / Action:** Nothing blocks it, and it should not wait for that epic. Fix through the
`bugfix` skill: drop the trailing `\`, and decide whether a `sudo` removal still has any reason to
exist once nothing root-owned creates `node_modules`. If it is still open when the map's script
slice rewrites this file for Bun, that slice retires it. Retire when `--local` passes exactly one
path to `rm`.

---

## 11/09/2026 — the Bun map's eight tracers have no Bun to run on

**Type:** Infrastructure gap
**Summary:** `project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` <!-- doc-references: template-only -->
settles supply-chain and runtime parity by **running** Bun (tracers N-006 to N-013), and none of
what they need exists. Measured 11/09/2026 on the development host: `command -v bun` is empty;
Node v24.13.0 and pnpm 11.25.0 are present. The overrides set a floor of Bun 1.4.0. Every tracer
runs in a throwaway worktree or scratch clone, **never this tree**, and between them they need: a
Bun >= 1.4.0 binary; scratch Copier renders on both `INCLUDE_MOBILE` paths at a pinned Copier
version (CI's `uvx copier` is unpinned; the local copy is 9.17.0); a scratch project generated at
`--vcs-ref=v7.5.0` with one added dependency committed, so its `pnpm-lock.yaml` diverges from the
template's (N-010); a Node-free shell — a container, or a PATH scrubbed of `node`, `npx`, `pnpm`
and `corepack` — with the test stack up for the Bruno leg (N-012, N-013); an Expo Go device on the
LAN for the manual `server.sh` check; and a throwaway branch with a Bun job on ubuntu runners for
CI parity, dispatched by hand because `test-api.yml`'s path filter skips a JS-only change unless
N-005 widens it. Provisioning is manual work, so it is recorded here rather than as a map node.
**Blocked by / Action:** Nothing blocks it. Sam decides where Bun is installed; the tracers then
run in the order the map's frontier sets. Retire when the first tracer has run.
