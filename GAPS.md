# GAPS.md — syntek-base's own open items

**Last Updated**: 01/11/2026 | **Maintained By**: Syntek Studio
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
unrelated). **An entry a map claims, or a story is cut carrying, leaves this file in that change**
(rule: `.claude/CLAUDE.md` Section 9). **Standing limitations are exempt from that triage** — they
are accepted properties, not open entries, and can take none of the three verdicts.

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
- **Added 15/10/2026, found by the mutation-testing research.** `code/docs/testing/TAXONOMY.md:189`
  also advertises `backend.sh -n auto`. The Testcontainers lines (`BACKEND-TESTING.md:114-115`,
  `TAXONOMY.md:22`) contradict `BACKEND-TESTING.md:84-85`, which puts integration tests on the
  Compose-managed `postgres:18-alpine` test database.

---

## Format

New items are recorded here first, in the format below, then charted onto a feature map at the
next pass — and removed from here in the change that charts them. The blank seed at
`.copier/GAPS.md` carries the same format, so an entry reads
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
are deliberately omitted here: US008 edits both fences and both settings modules below, and an
anchor into a file the same story edits goes stale on landing. The ninth is dead: the Django 6.1 that `uv.lock` pins and `.venv` holds declares twelve
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

## 17/09/2026 — `MAP-UPSTREAM-TRACKING.md` asserts things about itself that its own table refutes

<!-- Retitled 01/11/2026. Filed 17/09/2026 as "three feature maps assert things about themselves
     that their own tables refute"; items 1-2 (MAP-RULE-OWNERSHIP) were repaired at US013's cut on
     31/10/2026 and left this entry, so only the MAP-UPSTREAM-TRACKING item remains. -->

**Type:** Active gap
**Summary:** Map prose was not re-measured when the slice tables beneath it changed, and the prose
then stated something falsifiable by the same file:
`MAP-UPSTREAM-TRACKING.md:534` reads "**This is a template-development map, so there are no
stories to cut.**" It carries four slice rows, `US002.md:112` names its `S-01` among the slices it
unblocks, and four other template-development maps have already produced `US001`, `US004`, `US006`
and `US008`. Its `:537` also says "the remaining open nodes refine them without gating them" while
`:5` records zero open nodes. Surfaced 17/09/2026 during `02-story-creation`'s Step 0 sweep across
all thirteen maps.
**Blocked by / Action:** Nothing blocks it, and none of it is a node — this is prose maintenance,
not a decision. `MAP-UPSTREAM-TRACKING.md`'s next RESOLVE sitting should re-read its own Slices
preamble against its table and either delete the claim or make it true. Retires when a re-measure
pass has cleared it.

---

## 17/09/2026 — the backlog register is a set of hand-maintained copies with no gate behind it

<!-- HEADING DE-NUMBERED 20/09/2026. It read "is **five** hand-maintained copies" from
     17/09/2026 until that day, when SPRINT-06 and SPRINT-07 took the register to seven and the
     count in the heading went stale — the exact defect the same change stripped out of seven sprint
     records and `project-management/src/03-SPRINTS/CLAUDE.md`. De-numbered rather than re-numbered,
     so the eighth record does not buy it a third time. The count lives in the register table.
     `project-management/src/01-FEATURE-MAPS/MAP-INSTRUCTION-DELIVERY.md` quotes this title and is
     left to the session that owns `01-FEATURE-MAPS/`. -->

**Type:** Active gap
**Summary:** Every `SPRINT-##.md` under `project-management/src/03-SPRINTS/` now carries the same
backlog register — one row per live record, its members in build order, its capacity and its
admission posture — and every copy is meant to be identical. <!-- 20/09/2026: read "and the five
     copies" until the register reached seven. --> **Nothing checks that they are.** `code/src/scripts/audits/doctrine-drift.sh` is the audit built for exactly this defect
class, "a rule restated in two guides is not redundancy, it is a fork", and it cannot see these
tables on two independent counts: it reads **fenced code blocks only** by design ("Prose is free;
examples are the contract"), and a markdown table in prose is not fenced; and its `SCAN_DIRS` is
`code/docs`, `.claude/skills`, `code/workflows`, `project-management/workflows` and
`how-to/workflows` — `project-management/src/` is not among them. No other audit reads a sprint
record. So the day two copies disagree, every gate stays green and both are believed. The shape is
the one `doctrine-drift.sh`'s own header describes: "every individual file was internally
consistent and every citation resolved".
**Blocked by / Action:** Nothing blocks it, and the cost was accepted knowingly —
<%DEVELOPER_NAME%> settled the five-copy register at `03-sprint-planning` on 17/09/2026 (Q6 and
Q11) over a single-canonical-table alternative, with the drift risk stated before the call. Two
repairs are available and the second is the cheaper one to reach for first: (1) widen
`doctrine-drift.sh` — add `project-management/src/` to `SCAN_DIRS` and teach it a prose-table
mode, which is a change to the scanner's core assumption and should not be undertaken lightly;
(2) a new single-purpose `code/src/scripts/audits/sprint-register.sh` that extracts the register
from every `SPRINT-##.md` and fails when any two differ — no new doctrine, one comparison, and it
needs nothing from the existing gate. The obligation to hand-update **every** copy is written in
`project-management/src/03-SPRINTS/CLAUDE.md` and the rule in
`project-management/docs/planning/SPRINTS.md`; both are instructions to a reader, not enforcement.

<!-- 20/09/2026: this sentence read "The obligation to hand-update **all five**", which by that
     date attributed to `project-management/src/03-SPRINTS/CLAUDE.md` a five-copy obligation the
     same change had just deleted from it — that file now reads "Every live record carries the same
     backlog register". A gap entry citing a claim its own change removed is the drift this entry
     exists to catch, turned on itself. -->

This entry retires when a gate fails on a divergent register, or when the register collapses to
one canonical copy the other records cite.

**It fired on 20/09/2026, three days after it was filed — and on an axis neither proposed repair
can see.** `SPRINT-06` and `SPRINT-07` were opened at `03-sprint-planning`, which meant editing
the register in every copy, and the `SPRINT-05` row was found stale in **all five**: it read
"US009 (`Should`, 3, stretch)" and "11 / 11 — at capacity, closed" while
`project-management/src/03-SPRINTS/SPRINT-05.md`'s own capacity line read **13 / 11 at the grace
ceiling**. US009's re-estimate from 3 to 5 SP on 17/09/2026 moved that record's header, Story
Summary and Total in the same change that first wrote the five-copy register, and never reached
the register itself.

**The five copies were byte-identical to one another throughout.** The divergence was
register-versus-**record**, not copy-versus-copy — so proposed repair (2) above, "a new
single-purpose `code/src/scripts/audits/sprint-register.sh` that extracts the register from every
`SPRINT-##.md` and fails when any two differ", **would have stayed green through this**. It is
still the cheaper repair and is still worth writing, but it is not sufficient on its own: whatever
gate lands has to compare each row against the capacity line and Story Summary of the record it
names, which is the harder half. Recorded here rather than only in the sprint records, because the
proposal it qualifies lives in this entry.

Repaired in the same change, along with a second finding of the same class in the same file: four
further sites in `project-management/src/03-SPRINTS/SPRINT-05.md` carried the pre-re-estimate
figures, and a fifth denied the existence of
`project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`, which had been written later the
same day. **The register's prose also lost its hardcoded count of five**, which this change would
have made seven; `project-management/docs/planning/SPRINTS.md`'s own rule was already count-free
and the records had added a count it never had. The register now stands at **seven copies**, and
the count lives only in the table.

---

## 16/10/2026 — the nightly sweep publishes advisory detail in a public issue that never closes

**Type:** Active gap
**Summary:** The tracking-issue step at `.github/workflows/audit-deps.yml:190-224` writes each
failing night's audit output into one issue, creating it once and commenting on it after that. In
syntek-base that is issue #14, open since 03/09/2026 with 41 comments, in a public repository
(16/10/2026). No step closes it after a run passes (the file, `:190-230`, has none), so the green
runs on 15/10/2026 and 16/10/2026 left it open. Its comments list vulnerable package names and version
ranges. The template ships the same workflow, so a generated project whose repository is public
publishes the same detail; once a surface is live, part of that detail (the runtime Python
packages, and the prod image once an images leg reports here) describes what is deployed.
`code/docs/security/MONITORING-AND-INCIDENT.md:88-89` says not to discuss a vulnerability in public
channels, GitHub issues included, until it is resolved. The advisories themselves are public; what
the issue adds is which of them this repository has not yet fixed. Found while charting
`project-management/src/01-FEATURE-MAPS/MAP-PIN-DETECT-MOVE.md` (N-008, Sam's Q8), whose S-07 adds <!-- doc-references: template-only -->
an images leg that reports into the same issue.
**Blocked by / Action:** Nothing blocks it. Sam decides what the issue may carry (the full output,
counts and a link to the run, or nothing, with a private advisory channel instead) and whether it
closes when a run passes. A posture-dependent answer is a documented rule tied to
`.claude/CLAUDE.md` Section 0, as N-008 chose for the scan, unless the decision is explicitly to
make the workflow the first CI reader of the posture. The answer binds every leg of the nightly,
not only images. Graduated from N-008 on `MAP-PIN-DETECT-MOVE.md`, which triages it as unrelated
(it constrains S-07's issue section without blocking it) and names it in Out of scope; no map
claims it yet. This entry retires when the workflow does what that decision says.
