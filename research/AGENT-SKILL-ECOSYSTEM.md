# AGENT-SKILL-ECOSYSTEM

**Written**: 04/08/2026 · **Skill**: `research`
**Feeds**: a second wayfinder map, proposed and not yet charted

---

## Question

Which free, actively-maintained agent skills exist for the disciplines this template governs —
backend, database, security, architecture, background jobs, Rust, mobile, API, GDPR and data
protection, logging, auditing, error handling, observability, analytics, performance, and the
sync/async boundary — and which of them offer something `syntek-base` does not already encode?

---

## Verdict

**The template is not short of doctrine. Across seventeen disciplines it is short in three
places**, each with the same signature: the capability is in the shipped stack, and the doctrine
that governs it is scattered across other guides instead of being owned by one.

| Hole                            | Evidence                                                                                | Does the ecosystem fill it? |
| ------------------------------- | --------------------------------------------------------------------------------------- | --------------------------- |
| **Authoring a background task** | Operated but not specified — `CELERY-FIRST-RUN.md` exists; no task-authoring standard   | Mostly — one MIT skill      |
| **The sync/async boundary**     | Django + Starlette ASGI + Celery + Ninja; async appears only incidentally in eight docs | **No** — nobody covers it   |
| **Running an incident**         | Can draft an incident _policy_; no postmortem format, no on-call handoff                | Yes — three MIT skills      |

**The shape of all three is one thing: a layer seam.** This repository documents the _operate_
side in `how-to/` and the _build_ side in `code/docs/`, and it already has a convention for
disciplines that span both — `PERFORMANCE.md`, `logging/HEALTH-CONTRACT.md` and `SECURITY.md` each
cross-reference `how-to/src/SERVER-ARCHITECTURE/` with an explicit split, `SECURITY.md` stating it
outright: _"this doc keeps owning the why, SERVER-ARCHITECTURE owns what the server provides."_
Three disciplines fall through that seam — documented on the operate side, silent on the build
side, with no cross-reference bridging them:

| Discipline                | Operate side (`how-to/`)                                       | Build side (`code/docs/`)                                       |
| ------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------- |
| Background jobs           | `CELERY-FIRST-RUN.md` — rollout, beat verification, backlog    | **absent** — nothing on writing or testing a task               |
| Process model, WSGI/ASGI  | `SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`, `LOAD-PROFILES.md` | **absent** — incidental only, in `mcp-server/` and `rust/`      |
| Object storage, SeaweedFS | `SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`, `TOPOLOGY.md`     | **absent** — one passing mention in `security/INPUT-AND-API.md` |

A backend developer reading `code/docs/` alone would not learn that Celery beat runs, that the
worker class must be Uvicorn, or that an object store exists. The fix is the convention the
repository already uses three times, not new invention.

Everything else — GDPR, logging, observability, error handling, analytics, performance, auditing —
is covered, several of them far beyond anything published. Two narrower gaps and one trap sit
alongside:

- **Semgrep-class static analysis** — `audits/security.sh` is CVE-only (`pip-audit` + `pnpm audit`).
  Nothing in the repository scans for insecure _code patterns_.
- **OpenTelemetry** — **zero mentions when this note was surveyed.** Named since, but still not
  adopted: OTLP now appears eight times across seven files — `copier.yml` (×2),
  `how-to/src/TEMPLATE-TOKENS.md`, `how-to/src/PLATFORM-PROVIDERS.md`,
  `how-to/src/TEMPLATE-GUIDE/05-ANSWERS.md`, `code/docs/architecture/PROVIDER-NEUTRALITY.md`,
  `.claude/agents/backend.md` and `.claude/agents/code-reviewer.md` — every one of them naming the
  interface, none of them instrumenting a call site. Under the vendor-neutrality requirement below
  this is not a deferrable tracing feature; OTLP is the instrumentation seam, and the seam has to
  be chosen before call sites are instrumented even if the tracing backend is deferred to a scaling
  phase-gate.
- **Rust security review** — Trail of Bits ships `rust-review` and `constant-time-analysis`, which
  map directly onto `code/docs/rust/MEMORY-HYGIENE.md` and the constant-time claim in `stack-rust`.
- **The Agent Skills specification** is now a published, versioned artefact worth conforming to.
- **The trap:** Trail of Bits' skills are **CC-BY-SA-4.0** — share-alike. Every other source found
  is MIT or Apache-2.0. Share-alike is categorically different for a template redistributed into
  client projects, and is treated separately below.

---

## Claims

### Seven disciplines are already covered on all four legs

Verified by inspection of the repository tree on 04/08/2026: `code/docs/api-design/` carries nine
sub-documents, `code/docs/security/` eight, `code/docs/testing/` seven, `code/docs/architecture/`
five, `code/docs/rust/` three, plus `DATABASE.md` with `data-structures/` and `rls/`. Each pairs
with a skill (`stack-django`, `stack-fastmcp`, `stack-rust`, `stack-react-native`,
`codebase-design`), an agent (`backend`, `database`, `security`, `authentication`, `rust`,
`mobile`, `planner`), and a script group (`scripts/database/`, `scripts/rust/`, `scripts/tests/`,
`audits/security.sh`, `audits/mobile-tokens.sh`).

Testing is denser than the ecosystem norm: seven sub-documents plus **mutation testing** via
`code/src/scripts/tests/mutmut.sh`, which most published skill collections do not address at all.

### Background jobs is operated but not specified

Celery **is** documented on the operate side: `how-to/docs/CELERY-FIRST-RUN.md` (routed to the
`cicd` agent) covers why a first run differs, rollout order, a per-class review of every scheduled
task with dry-run counts for destructive sweeps, verifying every beat entry resolves to a
registered task, the backlog the worker drains on first connect, and a per-environment enablement
checklist.

What is absent is the **build** side. `find code/docs -iname "*task*" -o -iname "*celery*"
-o -iname "*job*" -o -iname "*queue*"` returns nothing; Celery appears only as a passing mention in
fifteen `code/docs/` files (`BACKEND-CODING-PRINCIPLES.md`, `performance/`,
`rls/MIDDLEWARE-AND-NINJA.md`, `security/CRYPTO-AND-DATA.md`, `logging/OBSERVABILITY.md`,
`api-design/WEBHOOKS.md`). No guide states how to **write** a task — idempotency, retry policy,
time limits, routing, transaction interaction — or how to test one against the 75% coverage floor.
No skill loads that knowledge and no agent claims it; `CELERY-FIRST-RUN.md` has no counterpart
cross-reference from `code/docs/`.

### One skill covers most of that hole, and its omissions are informative

`wshobson/agents` (38,470 ★, MIT, pushed 22/07/2026) ships
`plugins/python-development/skills/python-background-jobs/SKILL.md`. It treats **Celery as the
primary example** while naming RQ, Dramatiq, AWS SQS and GCP Tasks as equally valid, and teaches: a
job state machine (pending → running → succeeded/failed) with persisted state; **idempotent tasks**
because at-least-once delivery guarantees duplicate execution; idempotency keys on external calls;
check-before-write, upsert and deduplication windows; exponential backoff for transient errors and
**no retry on permanent failures**; hard and soft time limits; `acks_late`; worker prefetch
multiplier tuning; and a dead-letter queue for permanent failures.
[python-background-jobs/SKILL.md](https://raw.githubusercontent.com/wshobson/agents/main/plugins/python-development/skills/python-background-jobs/SKILL.md)

It does **not** cover task routing or priority queues, beat scheduling for periodic work, testing
strategy, or monitoring and alerting. Those four are precisely what a `syntek-base` guide must add
on top, since this project declares Celery (beat included) and holds a 75% coverage floor.

The same plugin ships `django-pro`, `python-observability`, `python-error-handling`,
`python-performance-optimization`, `async-python-patterns` and `python-anti-patterns` skills, plus
`database-design/skills/postgresql`, `database-migrations`, and `backend-api-security` plugins
across 90 plugin directories.
[wshobson/agents tree](https://github.com/wshobson/agents)

### Static code analysis is a second, narrower gap

`code/src/scripts/audits/security.sh` runs `pip-audit` and `pnpm audit` — both **dependency CVE
scanners**. No tool in the repository inspects first-party code for insecure patterns. Trail of
Bits publishes `semgrep-rule-creator` and `semgrep-rule-variant-creator` skills for authoring
Semgrep rules, alongside `insecure-defaults`, `entry-point-analyzer` and `differential-review`.
[trailofbits/skills tree](https://github.com/trailofbits/skills)

### Trail of Bits is the strongest security source and the one licence that bites

`trailofbits/skills` — 6,422 ★, pushed 03/08/2026 — ships `rust-review`, `constant-time-analysis`,
`property-based-testing`, `mutation-testing`, `modern-python`, `c-review`, `insecure-defaults`,
`second-opinion` and `sharp-edges`, among ~40 skills. Two map onto existing claims in this
repository: `constant-time-analysis` against the constant-time comparison duty in `stack-rust`, and
`rust-review` against `code/docs/rust/MEMORY-HYGIENE.md` and the never-panic FFI boundary.

Its licence is **CC-BY-SA-4.0 (Creative Commons Attribution Share Alike 4.0 International)**,
confirmed via the GitHub API.

This changes the calculus established in
[`ANTI-SLOP-RULE-SOURCES.md`](ANTI-SLOP-RULE-SOURCES.md). MIT and Apache-2.0 require attribution to
be _retained_; **share-alike requires the derivative itself to be licensed alike**. Three usages
must be kept distinct:

| Usage                                                                        | Position                                                                               |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **Install and run** their plugin in a developer's own environment            | Fine — use, not redistribution                                                         |
| **Adapt their skill text** into `.claude/skills/`                            | **No** — syntek-base is redistributed by Copier into client projects, many proprietary |
| Use their **skill list as a checklist of concerns** and author independently | Fine — facts and methods are not copyrightable, only the expression is                 |

### GDPR and data protection: the ecosystem has nothing, and this repository has a great deal

Repository searches for GDPR, privacy-compliance and PII-detection skills returned **no results at
all** across three query formulations. Against that, `syntek-base` carries: `GDPR-GUIDE.md` with
`gdpr/COMPLIANCE.md` and `gdpr/DATA-RIGHTS.md`; six register skeletons in `src/09-GDPR/`
(breach notification, consent and lawful basis, data inventory, data subject rights, retention and
deletion, third-party processors) each with per-story `PLANNING/` and `IMPLEMENTATION/`; a `gdpr`
agent; two workflows (`pm/09-gdpr-compliance` specifying, `code/06-gdpr-enforcement` enforcing);
`ENCRYPTION-GUIDE.md` with `FIELD-ENCRYPTION.md`, `LOOKUP-TOKENS.md` and `RUST-CRYPTO.md`; and
seven document-writer agents for the policy artefacts.

This is the widest margin in the sweep. Nothing should be imported here.

### Logging, observability, error handling, analytics and performance are covered

`code/docs/logging/OBSERVABILITY.md` covers GlitchTip error tracking (Django + browser, including
an explicit list of what it does _not_ capture), Loki aggregation with the log pipeline, LogQL
queries and retention, Prometheus via `django-prometheus` with scrape config, Grafana panels, and
health endpoints — alongside `DJANGO-LOGGING.md`, `FRONTEND-LOGGING.md` and `HEALTH-CONTRACT.md`.
Performance carries four sub-documents; error handling sits in `api-design/AUTH-AND-ERRORS.md`
plus both coding-principles guides.

Analytics is stronger than expected: `code/docs/api-design/EVENT-TRACKING.md` separates event
tracking from webhooks, sets a Plausible-versus-own-store decision gate, and specifies the event
schema, ingestion endpoint rules and a **privacy/GDPR section marked critical**. The ecosystem's
nearest offering — `wshobson/agents` `business-analytics` with `data-storytelling` and
`kpi-dashboard-design` — is business intelligence, a different discipline that pairs with this
project's `reporting` and `data-scientist` agents rather than competing with `EVENT-TRACKING.md`.

The one thin spot is **distributed tracing**: no guide owns it. The nearest thing is
`code/docs/security/MONITORING-AND-INCIDENT.md`, and only in passing — it says an incident should
"be traced across services" (line 44) without naming a protocol, and mentions neither
OpenTelemetry nor OTLP. Where OTLP _is_ named (the seven files listed above) it is the
provider-neutrality register and the reviewer guardrails, not a tracing guide. `wshobson/agents`
ships `distributed-tracing`, `prometheus-configuration` and `grafana-dashboards` skills plus an
`slo-implement` command. For one deployable, tracing is correctly deferred — it belongs on a
phase-gate in `code/docs/architecture/CORE-AND-SCALING.md`, not in the baseline.

### Auditing is distributed with no owner

Audit logging is discussed in at least ten files — `security/MONITORING-AND-INCIDENT.md`,
`architecture/SERVICE-AND-MIDDLEWARE.md`, `rls/TESTING-AND-AUDIT.md`, `GDPR-GUIDE.md`,
`gdpr/DATA-RIGHTS.md`, `gdpr/COMPLIANCE.md`, `mcp-server/AUTH-AND-THREATS.md`,
`testing/COVERAGE.md`, `.claude/skills/stack-django/SKILL.md` and `.claude/agents/gdpr.md` — but no
guide owns the audit trail as a subject, and `find code/docs -iname "*audit*"` returns only
`rls/TESTING-AND-AUDIT.md`, which is scoped to row-level security. This is a weaker finding than
the background-jobs hole: the doctrine exists, it simply has no home, so each consumer restates a
fragment. `wshobson/agents` ships a `signed-audit-trails` plugin with a single recipe skill.

### Running an incident has no doctrine, only a policy template

The repository can **draft** an incident response policy — `incident-response-plan-writer` agent,
`msp-scp-documents/INCIDENT-CONTINUITY.md` — and `code/docs/security/MONITORING-AND-INCIDENT.md`
covers detection. Nothing covers **running one**: searches for postmortem, post-mortem, on-call and
oncall across `code/`, `project-management/`, `how-to/` and `.claude/` return one file, and it is
the policy-drafting standard. `wshobson/agents` `incident-response` ships `postmortem-writing`,
`on-call-handoff-patterns` and `incident-runbook-templates` (MIT). The `runbook` skill and
`operator-docs` agent already exist to own this in `how-to/`.

### The sync/async boundary is a hole nobody fills

`grep` for `sync_to_async`, `async_to_sync`, `async def` and `ASGI` across `code/docs/` returns
eight files, and the coverage is incidental in every one: four are `mcp-server/*` (because
Starlette composes the `/mcp/` mount in `config/asgi.py`), the rest are `URL-STRATEGY.md`,
`logging/HEALTH-CONTRACT.md` and `api-design/NINJA-CONVENTIONS.md`. No guide owns the boundary,
despite this stack running Django 6 with async views and ORM, a Starlette ASGI composition, Django
Ninja endpoints that may be either, and Celery, which is synchronous.

The ecosystem does not fill this. `wshobson/agents` `async-python-patterns` teaches the general
law — _"stay fully sync or fully async within a call path; mixing creates hidden blocking and
complexity"_ — plus event-loop blocking (`time.sleep` versus `await asyncio.sleep`), a
when-not-to-use-async matrix (CPU-bound work, simple scripts), `asyncio.gather` with
`return_exceptions=True`, `create_task`, `wait_for` timeouts, and `pytest-asyncio` testing. It
states **no Django or ASGI guidance appears in the document**.
[async-python-patterns/SKILL.md](https://raw.githubusercontent.com/wshobson/agents/main/plugins/python-development/skills/async-python-patterns/SKILL.md)

So the general law is importable, but the part that actually bites this stack — the Django ORM
sync boundary inside async views, and where Celery sits relative to it — has to be authored here.

### The process model and object store are the other two seam casualties

**Gunicorn/Uvicorn is specified, in the wrong layer for a developer.** The stack runs Gunicorn with
Uvicorn workers against `config.asgi:application`, sized in
`how-to/src/SCALE-ARCHITECTURE/LOAD-PROFILES.md` (worker count as the second scaling lever after
cache hit-rate) and contracted in `SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`. The sharpest
statements sit in two surface-specific guides: `code/docs/mcp-server/MOUNTING.md` — _"the worker
class must be the Uvicorn one. A WSGI worker cannot serve streamable HTTP"_, plus the
worker-affinity problem where a client's second request lands on a worker that never heard of its
session — and `code/docs/rust/PYO3-BOUNDARY.md`, where a panic under `panic = "abort"` kills the
whole Gunicorn worker. Both are correct and both are invisible to anyone not working on MCP or
Rust. No `code/docs/` guide owns the process model or the WSGI-versus-ASGI decision as a subject.

This is the same guide as the sync/async boundary above: worker class, event loop, and where
blocking ORM calls may run are one topic, not two.

**Object storage has no build-side presence at all.** SeaweedFS is in the root `README.md` stack
line and specified in `SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md` (S3 gateway behind an
`objectstore-proxy` doing bucket isolation and AV, consumed via boto3 as an engine-neutral seam,
`OBJECT_STORE_ENDPOINT_URL`) and `SCALE-ARCHITECTURE/TOPOLOGY.md` (stateful, private documents and
attachments, short-TTL presigned URLs). Across all of `code/docs/`, a search for boto3, object
store, presigned or S3 returns **one file** — `security/INPUT-AND-API.md`. A developer implementing
a file upload has a server contract but no coding standard.

### The three seam guides must be vendor-neutral, and the repository already knows how

**Constraint, set 04/08/2026:** the object-store, observability and analytics doctrine names an
**interface**, not a product. Not every project will run SeaweedFS, GlitchTip, Loki, Alloy, Grafana
or Plausible, and a template that hard-codes them ships someone else's infrastructure choice as if
it were a standard.

This is not new ground here. The idiom already exists, in the repository's own words:

- _"**Engine-neutral object store.** SeaweedFS S3 is consumed via boto3 — the app…"_
  (`SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`) and _"Engine-neutral boto3 seam"_
  (`SCALE-ARCHITECTURE/TOPOLOGY.md`).
- `code/docs/design-tokens/CASCADE.md` describes `git_writeback.py` as a **"provider-agnostic
  Contents-API adapter (GitHub / GitLab / Forgejo)"** — one interface, three named providers. This
  is the model to copy.
- The counter-case is stated just as plainly: _"**PostgreSQL** — that is the fixed substrate, not a
  swappable choice"_ (`DATABASE.md`). Neutrality is therefore a **per-component decision** with
  precedent for both answers, and each guide must say which it is and why.

The governing rule is already written in `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`:
**"One adapter is a hypothetical seam; two adapters are a real seam."** Neutrality asserted with a
single implementation behind it is a claim, not a seam — so each guide names the interface, a
default, and at least one proven alternate.

Each of the three has a genuine interoperability standard, and adopting the standard _is_ the
neutrality:

| Concern        | The interface (the seam)                           | Default today       | Proven alternates                               |
| -------------- | -------------------------------------------------- | ------------------- | ----------------------------------------------- |
| Object store   | **S3 API** via boto3 — already the stated seam     | SeaweedFS           | MinIO, Garage, Ceph RGW, AWS S3, R2, B2         |
| Error tracking | **Sentry SDK wire protocol** — already in use      | GlitchTip           | Sentry, Bugsink                                 |
| Metrics        | **Prometheus exposition / OpenMetrics**            | `django-prometheus` | Prometheus, VictoriaMetrics, Alloy, Datadog     |
| Logs           | **Structured JSON on stdout** (12-factor)          | Loki                | Vector, Fluent Bit, Alloy, CloudWatch           |
| Traces         | **OTLP / OpenTelemetry**                           | _none — see above_  | any OTLP collector                              |
| Product events | The project's **own ingestion API + event schema** | Plausible or own    | already gated in `api-design/EVENT-TRACKING.md` |

Error tracking is the cheapest to fix and the most instructive: `logging/OBSERVABILITY.md` already
configures GlitchTip **through `sentry-sdk[django]` with `GLITCHTIP_DSN` as the DSN** — so the seam
is the Sentry wire protocol and has been all along. The document names the product in its headings
where it could name the interface. That is a re-framing, not a rebuild.

Scope of the coupling to unpick: twelve references to GlitchTip, Loki, Prometheus, Grafana,
Plausible or Alloy by name across `code/docs/` and `how-to/src/`. Bounded, and mostly in
`logging/OBSERVABILITY.md`, whose section headings are currently product names.

**The cost to weigh, honestly.** Pure neutrality produces guides that say "use an error tracker"
and help nobody; the present value of `OBSERVABILITY.md` is that it is concrete and runnable. The
resolution is the `CASCADE.md` shape — **named interface, named default, named alternates, and the
swap documented as an adapter change** — not the removal of product names.

### Checked and not gaps

Verified as adequately covered, recorded so they are not re-investigated: caching and Valkey (35
mentions, plus `performance/`), money and currency handling (28), rate limiting and throttling (24,
with `api-design/AUTH-STRATEGY.md` and `URL-STRATEGY.md`), backup and restore (`scripts/database/`
plus 88 mentions), deployment (`how-to/docs/FEATURE-DEPLOY.md`, with
`code/src/scripts/deployment/` deliberately empty and marked planned), search (`DATABASE.md`),
container hardening (**implemented** — `Dockerfile.prod` and `Dockerfile.staging` both `adduser`
a non-root `django` user and `USER django`), and timezone handling (`USE_TZ = True` in
`config/settings/base.py`, documented in `config/settings/CONTEXT.md`).

Three are thin but arguably correct: **i18n/l10n** (two mentions — a deliberate consequence of the
en_GB-only locale contract, and a decision rather than a gap), **feature flags** (two mentions —
YAGNI at this scale), and **HTTP idempotency keys** (one mention — which becomes load-bearing the
moment the background-jobs guide above is written, since the two share the concept).

### The remaining collections are process, not platform

`addyosmani/agent-skills` (81,542 ★, MIT, pushed 04/08/2026) ships 24 skills that are almost
entirely process: `spec-driven-development`, `test-driven-development`, `planning-and-task-breakdown`,
`code-review-and-quality`, `documentation-and-adrs`, `git-workflow-and-versioning`,
`security-and-hardening`, `observability-and-instrumentation`, `performance-optimization`,
`api-and-interface-design`. This template already encodes each as a numbered workflow with a
`STEPS.md` and `CHECKLIST.md`. The two with no counterpart here are **`doubt-driven-development`**
and **`context-engineering`**.
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)

`agentskills/agentskills` (23,826 ★, Apache-2.0, pushed 03/08/2026) is the **specification and
documentation for Agent Skills** as a format — worth conforming `how-to/docs/SKILL-AUTHORING.md`
against, since this project authors ~25 of its own.
[agentskills/agentskills](https://github.com/agentskills/agentskills)

`alibaba/open-code-review` (18,644 ★, Apache-2.0, pushed 04/08/2026) is a hybrid-architecture code
review system, adjacent to `code/workflows/07-review/` and the code-review-graph already wired in.
[alibaba/open-code-review](https://github.com/alibaba/open-code-review)

### Nothing exists for Slint, and nothing dedicated exists for background jobs outside the above

Repository searches for Celery, task-queue and background-job skills returned no dedicated
project; the only coverage found was the `wshobson/agents` sub-skill above. This mirrors the
desktop finding in [`ANTI-SLOP-RULE-SOURCES.md`](ANTI-SLOP-RULE-SOURCES.md): the ecosystem is
shaped around web and JavaScript, and thins sharply outside it.

---

## Sources

- Repository inventory — `code/docs/`, `.claude/skills/`, `.claude/agents/`, `code/src/scripts/`, read 04/08/2026
- `wshobson/agents` background-jobs skill — <https://raw.githubusercontent.com/wshobson/agents/main/plugins/python-development/skills/python-background-jobs/SKILL.md>
- `wshobson/agents` — <https://github.com/wshobson/agents>
- `trailofbits/skills` — <https://github.com/trailofbits/skills>
- `addyosmani/agent-skills` — <https://github.com/addyosmani/agent-skills>
- `agentskills/agentskills` — <https://github.com/agentskills/agentskills>
- `alibaba/open-code-review` — <https://github.com/alibaba/open-code-review>
- Star counts, licences, push dates, repository trees — GitHub REST API (`repos/{owner}/{repo}`,
  `git/trees/main?recursive=1`, `search/repositories`), retrieved 04/08/2026
