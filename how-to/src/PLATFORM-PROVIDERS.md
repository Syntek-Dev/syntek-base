# Platform Providers — This Project's Register

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

Every infrastructure dependency this project carries, what interface it sits behind, and whether
it is something you may swap or something the code is written against.

**The rule that produced this table is not here.** It lives on the build side, in
[`code/docs/architecture/PROVIDER-NEUTRALITY.md`](../../code/docs/architecture/PROVIDER-NEUTRALITY.md)
— the two seam kinds, the evidence each demands, and the substrate test. That rule is the same in
every project generated from this template. **This file is the answer sheet, and it is yours.**

## How to read a row

| Column           | Meaning                                                                    |
| ---------------- | -------------------------------------------------------------------------- |
| **Interface**    | What the code is actually written against — the thing that must not change |
| **Seam kind**    | `protocol` · `adapter` · `substrate` · `hypothetical` (see the rule)       |
| **This project** | The answer given at generation time, or the shipped default                |
| **Alternates**   | Implementations known to satisfy the interface — evidence the seam is real |

**Changing a `protocol` row is an environment variable.** Changing an `adapter` row is a new
adapter. Changing a `substrate` row is a fork, not a configuration change.

---

## Protocol seams

The interface is a wire protocol or exposition format with at least two independent
implementations already shipping. There is one code path, and that is correct — the
implementations vary on the far side of the socket.

| Concern                      | Interface                                                  | This project            | Alternates                                                        |
| ---------------------------- | ---------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------- |
| **Object store**             | The **S3 API**, consumed via `boto3`                       | <%OBJECT_STORE%>        | MinIO · Garage · Ceph RGW · AWS S3 · Cloudflare R2 · Backblaze B2 |
| **Error tracking**           | The **Sentry SDK wire protocol**, via `sentry-sdk[django]` | <%ERROR_TRACKING%>      | Sentry · Bugsink                                                  |
| **Metrics**                  | The **Prometheus exposition format** / OpenMetrics         | <%OBSERVABILITY_STACK%> | Prometheus · VictoriaMetrics · Alloy · vendor scrape agents       |
| **Logs**                     | **Structured JSON on stdout** (12-factor)                  | <%LOG_AGGREGATOR%>      | Vector · Fluent Bit · Alloy · CloudWatch Logs                     |
| **Traces**                   | **OTLP** — the OpenTelemetry Protocol                      | <%TRACING_BACKEND%>     | Grafana Tempo · Jaeger · SigNoz · Honeycomb · Uptrace             |
| **Cache & broker transport** | **RESP** (the Redis serialisation protocol)                | Valkey                  | Redis · DragonflyDB · KeyDB                                       |
| **Hosting**                  | A Linux host running the Compose/OCI images                | <%HOSTING_PROVIDER%>    | Any host or managed platform that runs the built images           |
| **Edge reverse proxy**       | **HTTP reverse proxying and TLS termination**              | Nginx                   | Caddy · Traefik · HAProxy · Envoy                                 |
| **Uptime probe**             | The **health endpoint contract** — plain HTTP `200`/`503`  | Gatus                   | Uptime Kuma · Healthchecks.io · Better Stack · any HTTP prober    |

**Error tracking is the instructive one.** The stack already configures its tracker _through_
`sentry-sdk[django]` with a DSN environment variable — so the interface has been the Sentry wire
protocol all along, and naming the product in a heading was always describing the default rather
than the dependency.

**Traces are the row where the seam is adopted and the backend is not.** Nothing is instrumented
and no `opentelemetry-*` package is declared, yet the interface is settled — because the two
halves have wildly different retrofit costs. Changing the backend later is one environment
variable; changing the seam later is every instrumented call site, in whatever library it was
written for. So the answer above may read `None` for a long time without the row being idle: it
is what stops the first person to reach for tracing picking a vendor SDK. The trigger that
reopens the backend, and what binds when it does, are in
[`code/docs/logging/OBSERVABILITY.md`](../../code/docs/logging/OBSERVABILITY.md) Section _Distributed
tracing_.

**Cache and broker transport needs your review.** Valkey is reached through `REDIS_URL` and
`CELERY_BROKER_URL` — configuration, not code — which by the substrate test makes it a protocol
seam rather than substrate. That is the correct verdict and a slightly surprising one, so it is
flagged here rather than filed silently. It applies to the **transport only**: see Celery under
_Substrate_.

**The edge proxy is the closest call on this table, and the tension is worth stating.** The
**deploy repo** is full of Nginx-specific configuration — `custom.nginx.apps` vhosts, the
loopback-only `/metrics/` block. Read from there, Nginx looks like substrate. But the substrate
test is judged on **application code**, and the application touches none of it: Django serves
HTTP and knows nothing about what terminates TLS in front of it. Swapping to Caddy is deploy-repo
work and zero application work, so **protocol seam** is the honest verdict — and the seam sits at
the app boundary, not at the deploy repo's, which is exactly the three-layer chain
[`BUILD-OPERATE-SEAM.md`](../../code/docs/architecture/BUILD-OPERATE-SEAM.md) describes.

**The uptime probe is a seam this project defines and does not implement.** The app publishes the
endpoint set in [`code/docs/logging/HEALTH-CONTRACT.md`](../../code/docs/logging/HEALTH-CONTRACT.md)
and nothing more; the poller lives entirely on the operate side. No adapter is required, and
demanding one would be the waste the rule warns against — the contract is plain HTTP status
semantics, which every prober already speaks. What would break the seam is the app growing an
endpoint shaped for one prober's response schema.

---

## Adapter seams

No wire protocol exists, so the interface is one this project defines. These need a **real second
implementation** before neutrality may be claimed.

| Concern            | Interface                                       | This project           | Alternates                                    |
| ------------------ | ----------------------------------------------- | ---------------------- | --------------------------------------------- |
| **Git write-back** | A provider-agnostic **Contents API** adapter    | GitHub                 | GitLab · Forgejo                              |
| **Product events** | This project's **own ingestion API and schema** | <%ANALYTICS_PROVIDER%> | Any collector behind the schema, or own store |

`services/git_writeback.py` is the worked example of a real adapter seam: one interface, three
named providers, and a no-op when unconfigured so local and CI runs never attempt a write
([`code/docs/design-tokens/CASCADE.md`](../../code/docs/design-tokens/CASCADE.md)).

Product analytics has no wire standard, which is exactly why the seam is placed at **this
project's own event schema** rather than at a vendor SDK — the provider sits behind our contract,
not in front of it ([`code/docs/api-design/EVENT-TRACKING.md`](../../code/docs/api-design/EVENT-TRACKING.md)).

---

## Hypothetical seams — declared, not claimed

An adapter seam with **one** implementation. Recorded honestly, because an untested neutrality
claim is worse than an acknowledged coupling: the coupling gets budgeted for, the claim does not.

| Concern                               | Interface                 | This project | Why it is hypothetical                                                                                            |
| ------------------------------------- | ------------------------- | ------------ | ----------------------------------------------------------------------------------------------------------------- |
| **Media transformation and delivery** | The Cloudinary Python SDK | Cloudinary   | Proprietary API, no wire standard, one implementation. Swapping means writing the adapter that does not exist yet |

This is not a defect to fix today. It is the cost of the capability, written down. Note the split:
**private documents and attachments go to the S3 object store above** — a real protocol seam — so
the coupling here is scoped to transformation and delivery of public media, not to file storage
generally.

---

## Substrate — fixed, and deliberately so

Swapping these changes application code, not configuration. Substrate is not a failure; it is
coupling spent where it buys depth. Each row carries its reason, because a verdict without one
becomes an assertion nobody can re-examine.

| Component                     | Why it is substrate                                                                                                                                                                                                             |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **PostgreSQL**                | The code is written against Postgres-specific semantics throughout — row-level security policies, `JSONB`, `CHECK` constraints, concurrent index builds, and the `ACCESS EXCLUSIVE` lock reasoning that governs every migration |
| **Django**                    | The application _is_ Django apps, ORM, middleware and templates. There is no interface to swap behind                                                                                                                           |
| **Celery**                    | Task decorators, the beat schedule and the worker model are written into application code. The **broker transport** is a seam (above); the task framework is not                                                                |
| **Gunicorn + Uvicorn worker** | The worker class is load-bearing, not a preference: a WSGI worker cannot serve streamable HTTP, and a Rust panic under `panic = "abort"` kills the worker process                                                               |
| **Python**                    | The language                                                                                                                                                                                                                    |

Changing any of these is a fork of the template, not an answer to a generation question. That is
why none of them is a Copier question.

---

## Process dependencies — chosen, but not a code seam

A dependency the **people** operating this project rely on, which no application code touches.
Recorded here because the substrate test has to be applied and answered rather than skipped:
swapping one of these changes where a human types, not what the code does — so it is neither a
protocol seam nor an adapter seam, and calling it either would cheapen both terms.

| Concern              | Interface                                       | This project         | Alternates                                            |
| -------------------- | ----------------------------------------------- | -------------------- | ----------------------------------------------------- |
| **Incident tracker** | A human-readable record with **access control** | <%INCIDENT_TRACKER%> | ClickUp · Linear · Jira · a bespoke admin area · none |

The interface is the access control, and that is the whole point. The
[`23-INCIDENTS/`](../../project-management/src/23-INCIDENTS/CONTEXT.md) register is in git and
ships, so it is **PII-free by rule**; the tracker is where log excerpts, identifiers and any
report touching personal data go. A project that answers `none` keeps that substance outside the
repository entirely — the rule is never relaxed to keep a report in one piece. The practice is
[`how-to/docs/INCIDENT-PRACTICE.md`](../docs/INCIDENT-PRACTICE.md).

> **Syntek Studio's own answer today is ClickUp**, which is also what
> `project-management/export/` syncs stories to. That is a studio fact, not a template default —
> the shipped default is `none`, because a default naming a product we are migrating away from
> would bake it into every project generated between now and the migration.

## Keeping this file true

- **Adding an infrastructure dependency adds a row here** — with its verdict and its reason. This
  is a definition-of-done item, not a tidy-up task. A dependency with no row is unclassified, and
  silence reads as "seam" to whoever wants it to be one.
- **Promoting a hypothetical seam to a real one** requires the second implementation to exist, not
  to be planned.
- **Demoting a protocol seam** happens the moment a product-specific API is called. That is the
  failure mode the rule exists to catch, and it arrives as a small convenience in an unremarkable
  pull request.
- The provider answers here come from the Copier questions described in
  [`TEMPLATE-TOKENS.md`](TEMPLATE-TOKENS.md) → _Platform providers_. Re-running generation with
  different answers re-renders this table; it does not change the interfaces.

## Cross-references

- [`code/docs/architecture/PROVIDER-NEUTRALITY.md`](../../code/docs/architecture/PROVIDER-NEUTRALITY.md) — the rule, the evidence bars, and the substrate test
- [`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`](../../code/docs/architecture/SERVICE-AND-MIDDLEWARE.md) — deep modules and the two-adapter rule
- [`code/docs/DATABASE.md`](../../code/docs/DATABASE.md) — PostgreSQL as fixed substrate
- [`SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`](SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md) — what the server must provide for each of these
- [`SCALE-ARCHITECTURE/TOPOLOGY.md`](SCALE-ARCHITECTURE/TOPOLOGY.md) — where each sits in the scaling envelope
