# MAP-CAP-POSTURE — what each dependency gives up, written down before it is needed

**Charted**: 01/09/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `5fc9318` (`v7.4.1`) **plus the uncommitted working tree** — the sibling map
`MAP-RETRY-AND-IDEMPOTENCY.md` resolved nine nodes the same morning, and this map leans on them
**Status**: **Charted, resolved, and fog dispositioned** — the frontier is empty, fog closed 01/09/2026 (1 answered · 1 cleared · 3 stay with triggers); all seven slices are cuttable
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 25

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — this charts **syntek-base's
> own** doctrine; a generated project inherits the decided rule, not the argument. The name
> matters — a `MAP-TEMPLATE-*.md` would match the `!*TEMPLATE*` negation and ship.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026 — the index relocates rather than gains an
> exception, and slice S-06 there carries it.
>
> **Measurement method.** Eight parallel research agents swept one surface each (sessions/auth,
> SSE/presence, external stores, caching, replica/Phase-1, the degraded contract, rate
> limiting, the best-ground statement); every absence claim was then handed to an adversarial
> refuter with different vocabulary and different search targets. 45 absence claims were made,
> 3 refuted, 42 stand. Library behaviour (ninja 1.4.5, django-valkey, django-ratelimit 4.1.0)
> was verified from the installed packages in `.venv/`, never from memory.

---

## Destination

**A project that scales faster than planned finds the trade-offs already written.** Every
dependency and every scaling phase carries its CAP-governed posture — what is given up when the
dependency is unreachable or past its timeout budget, what a replica read may return stale —
stated before it is needed, so moving up a tier is a rehearsed decision, not a scramble. The
ground the code sits on is **maintainable, readable, scaleable — never pre-optimised**:
readiness lives in doctrine and code shape, and no infrastructure arrives ahead of a measured
gate.

**The measured cause is fourfold.** The CAP decisions exist but are (a) **unnamed** — zero
occurrences of CAP, PACELC, eventual consistency, split-brain, network partition or partition
tolerance in any `.md` or `.py` (all 15 "partition" hits classified: `str.partition`, Postgres
table partitioning, rhetoric, set-partition); (b) **scattered** — the only place the posture is
stated _as a rule_ is a health-probe enum (`apps/health/checks.py:7-12`, Postgres `CRITICAL` /
Valkey `DEGRADABLE`) that no guide reads; (c) **contradictory** — the sweep measured six
doctrine-versus-doctrine conflicts, sharpest being fail-closed security doctrine against
fail-open limiter doctrine; (d) **unowned** — no artefact owns "what is given up when X is
unreachable", and the positive "scale-ready shape, day one" half of the ground has no owning
sentence either, while its negative half (anti-forecast, measure-first) has named owners at
every layer.

---

## Notes

| Field                    | Value                                                                                                                                                        |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Domain                   | Partition and staleness doctrine — the seam between `code/docs/architecture/CORE-AND-SCALING.md`, the `how-to/src/` snapshots, and the health contract       |
| Skills to load           | `scale-planning` · `security` · `backend` · `database` · `doc-writer` · `grill-with-docs` · `codebase-design`                                                |
| Standing preferences     | Anti-forecast is absolute (`SCALE-ARCHITECTURE/CLAUDE.md:39-46`) · route-don't-restate · a rule ships with a gate or says why not (`GATE-REPORTING.md`)      |
| Umbrella ADRs            | None yet. **ADRs may be authored here** since 31/08/2026 (`.claude/MEMORY.md`, `MAP-PROGRESSIVE-ENHANCEMENT` N-026) — via a slice's story, never from a map  |
| Register entries triaged | **0 closes · 0 blocks · 2 unrelated** — exhaustive; `DEFERRED.md` holds no rows; SL-1/2/3 exempt as standing limitations                                     |
| Cross-map                | `MAP-RETRY-AND-IDEMPOTENCY` — the write-side owner; see the boundary note below. `MAP-RULE-OWNERSHIP` — the index decline and the split-doctrine class **D** |
| Scope confirmed by Sam   | 01/09/2026 — Q1 CAP named and load-bearing, applied as posture · Q2→2 · Q3 doctrine through Phase 2, provisioning never · Q4→2 · Q5→2 (details below)        |

**The confirmed bounds, in full:**

- **Q1** — the doc names CAP explicitly (a fast-scaling user must find the theorem "already
  there"), applied as per-dependency posture rather than theory-for-theory.
- **Q2 → 2** — this map claims the **unowned partition surface** across all surfaces, and
  **cites `MAP-RETRY-AND-IDEMPOTENCY` for the write-side** — idempotency keys (its N-013),
  concurrency stance and the outbox deferral (N-014), isolation baseline (N-015), timeout
  values (N-012) are settled there and never re-decided here.
- **Q3** — doctrine through **Phase 2**, provisioning through **none**. "Faster than planned"
  is precisely the case where Phase-2 doctrine must pre-exist; `CORE-AND-SCALING.md` already
  writes sharding rules it never provisions, and this map keeps to that line.
- **Q4 → 2** — doctrine plus **only the live fixes a settled rule makes non-optional** (the
  `MAP-RETRY-AND-IDEMPOTENCY` S-06 precedent). No application surface is built (SL-1).
- **Q5 → 2** — a dependency past its timeout budget **is treated as absent**; the budget
  _values_ stay in the timeout register (`MAP-RETRY-AND-IDEMPOTENCY` N-012). Today Valkey's
  `SOCKET_TIMEOUT` defaults to `None`, so the hang is the partition that actually occurs.

**Accepted property (01/09/2026).** The template ships almost no application code (`apps.core`

- `apps.health` only), so most findings are doc-versus-doc; the throttle, SSE, object-store and
  mail surfaces are all declared-not-wired. This map makes their **designs** consistent — the
  posture is decidable before the code exists, which is the point of deciding it now.

---

## Register claimed

**Nothing claimed.** Triaged against the live registers on 01/09/2026:

| Register    | Entry                                                   | Verdict   | Note                                                        |
| ----------- | ------------------------------------------------------- | --------- | ----------------------------------------------------------- |
| GAPS.md     | 31/08/2026 — PE gate's markup half / prefix set         | unrelated | Progressive-enhancement tooling                             |
| GAPS.md     | 31/08/2026 — htmx pinned at major 2, v4 migration waits | unrelated | Frontend dependency doctrine                                |
| GAPS.md     | 01/09/2026 — RUSTSEC advisory vs an unchanged lockfile  | unrelated | Supply-chain gate coverage — added to the triage 01/09/2026 |
| GAPS.md     | 01/09/2026 — the story `**Status:**` vocabularies       | unrelated | Story lifecycle                                             |
| GAPS.md     | 01/09/2026 — the index-row instruction, three files     | unrelated | `MAP-REGISTER-INDEXES` `S-01`                               |
| GAPS.md     | SL-1 · SL-2 · SL-3                                      | exempt    | Standing limitations take no triage verdict                 |
| DEFERRED.md | _no rows_                                               | —         | —                                                           |

**One entry written 01/09/2026 (graduation, not a claim).** N-017 surfaced a live blocker with
no owner — `MAILERS` is defined in `dev.py` and `test.py` only, so staging and production fall
through to Django's default SMTP against `localhost:25`. Written to `GAPS.md` per the wayfinder
graduation table (an active blocker → a `GAPS.md` entry). **This map closes nothing**; the
`✅ CLOSED` mark stays `workflows/22-implementation-documentation/`'s, against shipped code.

---

## The boundary with MAP-RETRY-AND-IDEMPOTENCY — read before resolving anything

That map owns **whether a repeated operation is safe and who repeats it**; this map owns **what
is given up while a dependency is gone and what a read may return stale**. Concretely:

| Question                                              | Owner                                                                                                        |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Retry ownership, budgets, `Retry-After`, breakers     | that map (N-008–N-011, settled)                                                                              |
| Timeout **values**, per-socket                        | that map's timeout register (N-012)                                                                          |
| Idempotency keys, stale-write stance, outbox deferral | that map (N-013–N-015, settled)                                                                              |
| Valkey DB 0 / DB 1 split, `CACHE_URL`                 | that map (N-018, **settled 01/09/2026** — voice repair, DB 1 stays the convention; N-005's facet discharged) |
| Jittered TTLs, Valkey socket timeouts as live fixes   | that map (N-022, N-023 / S-06)                                                                               |
| Which limiter families exist and their **fail mode**  | **this map** (N-010, N-011)                                                                                  |
| What "degraded" suspends, per surface                 | **this map** (N-012)                                                                                         |
| Replica staleness, read-your-writes, lag alerting     | **this map** (N-014)                                                                                         |
| Slow-is-absent as a rule (values delegated)           | **this map** (N-009's guide states it)                                                                       |

---

## Resolved decisions

N-001–N-008 are **research** nodes, fired during charting because they need no human — each
finding is what a later grilling node opens with. N-009–N-021 and N-023 were settled by grilling,
N-022 by its tracer spike, and the two build nodes N-024/N-025 by being specified onto S-07 —
never performed — across the 01/09/2026 resolve sessions.

| Node  | Decision                                                        | Type     | Settled    | Became                   |
| ----- | --------------------------------------------------------------- | -------- | ---------- | ------------------------ |
| N-001 | What sessions and auth counters actually do under cache loss    | research | 01/09/2026 | finding → N-011, N-013   |
| N-002 | The SSE/presence design's real delivery semantics               | research | 01/09/2026 | finding → N-016          |
| N-003 | The external stores' stated outage postures                     | research | 01/09/2026 | finding → N-017          |
| N-004 | Cache-coherence doctrine and any promised staleness bound       | research | 01/09/2026 | finding → N-019          |
| N-005 | Every limiter family's store and verified fail mode             | research | 01/09/2026 | finding → N-010, N-011   |
| N-006 | Every replica-doctrine site, exact wording, and the phantom ADR | research | 01/09/2026 | finding → N-014, N-015   |
| N-007 | The degraded contract's consumers and its promise's real scope  | research | 01/09/2026 | finding → N-012          |
| N-008 | The best-ground halves and their (missing) owners               | research | 01/09/2026 | finding → N-018          |
| N-009 | The owning artefact and how CAP is introduced                   | grilling | 01/09/2026 | decision → S-01, S-04    |
| N-010 | One fail mode per limiter family                                | grilling | 01/09/2026 | decision → S-02          |
| N-011 | The security-counter durability class                           | grilling | 01/09/2026 | decision → S-02          |
| N-012 | The degraded contract                                           | grilling | 01/09/2026 | decision → S-03          |
| N-014 | Replica doctrine unification                                    | grilling | 01/09/2026 | decision → S-03, S-04    |
| N-015 | Trigger concreteness                                            | grilling | 01/09/2026 | decision → S-04          |
| N-013 | The posture register's shape                                    | grilling | 01/09/2026 | decision → S-01          |
| N-016 | The SSE delivery contract                                       | grilling | 01/09/2026 | decision → S-05          |
| N-017 | External-surface postures                                       | grilling | 01/09/2026 | decision → S-05, GAPS.md |
| N-018 | The best-ground statement                                       | grilling | 01/09/2026 | decision → S-06          |
| N-020 | The phantom-ADR citation policy                                 | grilling | 01/09/2026 | decision → S-07          |
| N-023 | The gate's name, scope, failure mode and registration           | grilling | 01/09/2026 | decision → S-07          |
| N-024 | The unconditional repair sweep                                  | build    | 01/09/2026 | specified → S-07         |
| N-025 | The mandated live fixes                                         | build    | 01/09/2026 | specified → S-07         |
| N-019 | The page-cache staleness bound                                  | grilling | 01/09/2026 | decision → S-06          |
| N-021 | Phase-2 doctrine sufficiency                                    | grilling | 01/09/2026 | decision → S-01          |
| N-022 | Which posture rules are mechanically checkable                  | tracer   | 01/09/2026 | finding → N-023          |

**N-001 — sessions and auth counters.** `SESSION_ENGINE` is set nowhere
(`config/settings/base.py:159-162` holds only cookie flags), so the working tree runs Django's
default **pure-DB sessions** — while `TOPOLOGY.md:74` asserts `cached_db` as deployed fact.
Today's real posture is therefore _stronger_ than doctrine claims: sessions fully survive
Valkey loss with zero staleness, at a per-request Postgres read the sizing doc doesn't model.
Admin bearer tokens are doctrinally Valkey-resident (`AUTH-STRATEGY.md:67-68,113-115`:
`admin_access:<token>`, revocation = delete the key) — so a flush is a mass admin logout and an
outage fails Bearer auth **closed**, neither consequence stated anywhere. Session-invalidation
propagation under a stale cache tier: one acceptance criterion exists
(`02-STORIES/US000-TEMPLATE.md:245`), no doctrine. The test suite runs `LocMemCache`
(`test.py:17-20`), so no test exercises any of this.

**N-002 — SSE and presence.** The design (`TOPOLOGY.md:63-71`, `LOAD-PROFILES.md:79-89`) is
sound and CAP-shaped without saying so: pub/sub frames are **id-only wake-ups**, Postgres is
the durable record, publish happens **post-commit**, and missed messages are recovered by
on-connect **backlog replay** — at-most-once transport under an eventually-delivered
application contract. But no delivery-guarantee vocabulary is ever attached to it (all
at-least/at-most-once language is task-layer), nothing states what open streams do when pub/sub
dies, `Last-Event-ID`/`EventSource` appear nowhere, presence-under-outage is unstated, and no
probe component exists for pub/sub (`checks.py` covers `DATABASE` and `CACHE` only). All of it
is declared-not-wired — zero SSE code ships (`RENDERING.md:42-45` gates real-time behind an
ADR).

**N-003 — external stores.** `OBJECT-STORAGE.md` states **no unreachable posture** — including
the trap that presign generation is local signing that succeeds while the store is dead. No
Cloudinary outage doctrine exists (media is server-built `<img>` URLs; a CDN outage is broken
media elements, nowhere stated); the vendored SDK docs carry zero failure-mode content. No S3
consistency claim anywhere. Mail: "enqueue, never 500" (`NOTIFICATIONS.md:26-28`) rests on a
queue that at baseline can drop silently twice over — acks-early (`TASK-AUTHORING.md:125-133`)
and broker-shares-evictable-DB-0 (`:134-140`) — which `TASK-AUTHORING.md` states honestly;
the conflict is between the posture and the shipped substrate, and it is that map's/deploy
repo's to close, this map's to **state**. One live contradiction:
`logging/CLOUDINARY.md:16-19` claims Cloudinary is the default storage in present tense;
`OBJECT-STORAGE.md:22-26` and `base.py:194-197` say `FileSystemStorage`.

**N-004 — caching.** Doctrine is invalidate-on-write plus mandatory TTL backstop, never
write-through, never authoritative cache — a coherent AP-with-bounded-staleness posture that is
never named as one. **No staleness bound is promised anywhere**; the only reasoned numeric
bound in the tree is the health verdict's 15 s memo. Four internal conflicts: the jitter rule
(`BACKEND-CODING-PRINCIPLES.md:341-342`) versus the shipped bare `TIMEOUT: 300` (`base.py:144`)
and the canonical example (`DATABASE-PERFORMANCE.md:182`); the coalescing checklist mandating a
helper (`get_or_set_coalesced()`) that exists nowhere, against its own incremental-rollout
rule; the page-cache version bump praised as one-write invalidation and named "the classic
stampede window" (`READINESS.md:113-121`); and the stampede ladder plus "caching decision
record" attributed to ADRs that do not exist.

**N-005 — limiters, verified from installed source.** Three limiter families, two opposite
fail modes, none documented together: (a) the two mandated HTTP middlewares — **fail-open by
explicit doctrine**, the repo's only limiter fail-mode statement
(`NINJA-CONVENTIONS.md:289-301`, "neither exists at baseline"); (b) Ninja `throttle=` classes —
**fail open silently**: ninja 1.4.5 uses the default Django cache
(`.venv/.../ninja/throttling.py:5,65,150,167`), and `IGNORE_EXCEPTIONS` makes `get` return the
empty-history default and swallows the `set` — no log fires (`LOG_IGNORE_EXCEPTIONS` unset);
(c) django-ratelimit 4.1.0 (declared for forms) — **fails closed by library default**
(`.venv/.../django_ratelimit/core.py:249-257`; `RATELIMIT_FAIL_OPEN` set nowhere, mentioned
nowhere). During a Valkey outage the API would wave everything through while rate-limited
forms deny. Against all three stands `OWASP-AND-CHECKLIST.md:32,158`: "fail closed (deny by
default)", with a test requirement to prove it. The lockout/MFA counters' store is named
nowhere. The store's DB is contradicted (`TOPOLOGY.md:31-32` says DB 0; the throttle docs and
verified library behaviour say the default cache, DB 1) — that facet feeds
`MAP-RETRY-AND-IDEMPOTENCY` N-018. The Cloudflare edge rule is structurally above Valkey but
conditional ("when enabled", "TBD — set per deployment") — not assumable as a backstop.

**N-006 — replica doctrine.** The routing rule lives at three sites in three wordings
(`CORE-AND-SCALING.md:84-88` the keystone; `DATABASE-PERFORMANCE.md:333-342`;
`API-AND-MONITORING.md:147`). The Phase-1 trigger is **three-way inconsistent**: abstract
per-project at the owner (`CORE-AND-SCALING.md:71,74-75`), `TBD` in the snapshots
(`SIZING-ENVELOPE.md:124`, `OVERVIEW.md:55-57,81-82`), and a concrete **p95 > 50 ms** stated as
fact at four sites (`DATABASE-PERFORMANCE.md:330`, `COMPUTE-ALLOCATION.md:55`,
`SCALE-ARCHITECTURE/CONTEXT.md:72-74`, `scale-planning SKILL.md:79`) — the same figure as the
DB query p95 _budget_ (`API-AND-MONITORING.md:88`), which the glossary itself distinguishes
from a gate. Same systemic pattern on Phase 2 (70 % concrete at six sites versus "threshold
TBD" at `READINESS.md:77-78`). "The project's Postgres horizontal-scaling ADR" is cited at
~30 sites and exists nowhere; `READINESS.md:137` escalates the citation into a false promise —
"router code is **pre-written** in the scaling ADR" — and `PrimaryReplicaRouter` appears at
exactly that one site repo-wide. `TEMPLATE-TOKENS.md:489-494` sanctions named-pattern ADR
citations as regenerable placeholders, but `FORWARD-VOICE.md`'s machinery reads backticked
paths only, so the pattern has no keeper and no gate. **No read-your-writes mechanism, no lag
SLO, and no lag alert threshold exist anywhere** — only the routing convention, one checklist
line, and a future "audit read-after-write paths".

**N-007 — the degraded contract.** The published semantics are firm and tested: `degraded`
returns **200**, `503` only for `down` (`HEALTH-CONTRACT.md:46-48`, `views.py:34-41`,
`test_endpoints.py:85-108`). But (a) **nothing consumes `/health/ready/` to shed traffic** —
every container HEALTHCHECK probes liveness, Nginx has no health-gated upstream, deploy
scripts don't exist (SL-2), and the Gatus probe colours a status page; the endpoint's own docs
nonetheless claim it "takes traffic away" (`views.py:50-53`, `CONTEXT.md:41-43`) — an
orchestrator this stack does not have; (b) the promise "the site is still serving correctly"
(`HEALTH-PROBES.md:45`) is true **only of today's baseline** (DB sessions, no limiters, no
SSE, no broker wired) and no document scopes it — once the designed surfaces land, degraded
means limiters open, streams stalled, and possibly queued work at risk; (c) a DB fault can be
masked for up to one 15 s TTL (measured: 16 s of `operational` during a real Postgres outage,
`HEALTH-PROBES.md:139-179`) while a cache fault surfaces immediately — a deliberate,
documented asymmetry, and the closest thing the repo has to honest partition writing.

**N-008 — the best ground.** The **negative** half (never pre-optimise, never pre-provision)
has named owners at every layer: `PERFORMANCE.md:27-29`, `CORE-AND-SCALING.md:50-58,64-78`,
`OVERVIEW.md`'s anti-forecast principle, `DATABASE.md:21-24` ("a trigger, not a shrug"), down
to the skills. The **positive** half — what scale-ready shape looks like day one — exists as
rich content with **no owning sentence**: `READINESS.md`'s six audited dimensions, the
settle-before-first-migration table, pagination-by-default at three sites, N+1-raises-in-dev,
stateless-by-design. No sentence anywhere ranks maintainable/readable/scaleable against
optimised as one claim. And three routing surfaces (`implement-story CONTEXT.md:59`,
`planner SKILL.md:38-42`, `code-reviewer SKILL.md:97-101`) key the readiness-invariants list
to `CORE-AND-SCALING.md` — which contains none of those terms ("never restated" currently
means "stated nowhere at the named owner"). The flagship day-one rule (pagination) is proven
by no gate, admitted in-text at `READINESS.md:52-56`.

**N-009 — settled 01/09/2026 (grilling, Sam; restatement confirmed).** Partition-posture
doctrine takes **two homes, split by which side of the CAP trade-off each defends** — not by
topic. The **`code/docs/reliability/` family** (decided by `MAP-RETRY-AND-IDEMPOTENCY` N-006;
unbuilt, its S-01) argues why availability and partition tolerance win over consistency for
**degradable** dependencies, and owns the **single per-dependency posture register** — role,
give-up, bound; one lookup per dependency; mirrored by the health `Criticality` enum. A **new
`code/docs/architecture/` guide** argues why consistency wins where the **source of truth** is
at stake — thesis: _consistency is the default and every deviation is bounded and named_, so a
Phase-1 replica read is a named, bounded deviation, not a contradiction; it cites register
rows, never restates them. **Amended by N-013 (01/09/2026):** the family owns the register's
**rule half** — the columns and what a give-up and a bound mean — while this project's **rows**
live in `how-to/src/`, per the rule-versus-answers split this decision had missed
(`FORWARD-VOICE.md:51-56`). **CAP is introduced with no single theorem section**: each guide
names the theorem explicitly, states its own clause from its side, and cites the other as the
other half — a conscious departure from the charting bound's one-findable-section reading;
findability rests on both guides naming CAP plus the one register. The boundary test for any
future rule is _which choice it defends_, never its topic keyword. Guide naming is story work.
Replica doctrine (N-014) lands in the architecture guide.

**N-010 — settled 01/09/2026 (grilling, Sam).** Fail mode splits by **what the limiter
protects**. Availability throttles **fail open** — the public HTTP middleware, the
authenticated HTTP middleware, and the MCP per-key throttle are congestion control, not access
control; a Valkey outage waves their traffic through, and the outage is visible as `degraded`
(the per-surface suspension table is N-012's). Access-decision limiters **fail closed** — the
form limiter on auth forms and every counter feeding an access decision.
`OWASP-AND-CHECKLIST.md:32`'s fail-closed rule is thereby _scoped to access control_,
dissolving the sharpest doctrine conflict: the installed defaults (ninja open, django-ratelimit
closed — re-verified from `.venv` source 01/09/2026, and still closed under this repo's
`IGNORE_EXCEPTIONS` cache) already land each family on its correct side. `RATELIMIT_FAIL_OPEN`
is the decided value **`False`, mandated by the owning guide and set explicitly at first
wiring** — never in `base.py` while the library is unwired (a dead setting is pre-provisioning).

**N-011 — settled 01/09/2026 (grilling, Sam).** Lockout and MFA counters are
**Postgres-resident**: an access-control input takes the durable store, so a cache outage opens
no brute-force window and no login outage is traded for it (DB-down is site-down — no window
exists there either); the cost is one write per _failed_ login. Admin bearer tokens **stay
Valkey-resident as `AUTH-STRATEGY.md:68` states**; the consequences are accepted and become
posture rows — an outage fails the admin surface closed (the correct posture), and a flush is a
mass admin logout bounded by the 15-min/7-day TTLs. No redesign.

**N-012 — settled 01/09/2026 (grilling, Sam).** `degraded` returns **200 permanently** — the
wire contract is published, tested and consumed downstream (Gatus keys on `[BODY].status`);
what changes as surfaces land is the suspension list, never the status code. **The register's
give-up column is the suspension statement** — "what degraded suspends" is the union of the
degradable rows' give-ups; `HEALTH-CONTRACT.md` and `HEALTH-PROBES.md` cite it, the
"serving correctly" promise (`HEALTH-PROBES.md:45`) is rescoped to it, and the
traffic-shedding overclaims (`views.py:50-52`, health `CONTEXT.md:43`) are repaired in the
build sweep. **Session doctrine is pure-DB** — the strongest posture and what actually ships;
the per-request DB read gets modelled in sizing; `cached_db` becomes a named, phase-gated
optimisation; `TOPOLOGY.md:74` and `US000-TEMPLATE.md:245` are repaired to match (N-024). The
15 s DB-masking asymmetry stays as deliberate, stated posture.

**N-014 — settled 01/09/2026 (grilling, Sam).** Read-your-writes is **time-boxed
pin-after-write** — a session-stamped last-write time routes that session's reads to the
primary within the window; declared, never wired. **One coupled value: the pin window is the
lag alert threshold** (lag beyond the window is the guarantee broken — that is what the alert
means), shipped default **5 s sustained**, retunable, recorded as a register bound. One owner —
the architecture guide N-009 named; `DATABASE-PERFORMANCE.md:335-342` and
`API-AND-MONITORING.md:147` repaired to cite it; the false "router code is pre-written"
promise (`READINESS.md:137`) repaired.

**N-015 — settled 01/09/2026 (grilling, Sam).** The **Phase-1 gate stays budget-derived** —
the owner already words it "sustained above budget, write headroom remaining"
(`CORE-AND-SCALING.md:71`); the 50 ms lives **once**, as the DB-query budget's default
(`API-AND-MONITORING.md:88`), and the gate cites the budget. The **Phase-2 70 % becomes a
labelled shipped default** at the owner ("default — retune per project via `/scale-planning`").
The seven leaking sites (re-measured 01/09/2026: `DATABASE-PERFORMANCE.md:330-331`,
`SCALE-ARCHITECTURE/CONTEXT.md:72-74`, `COMPUTE-ALLOCATION.md:55-56`,
`SERVER-ARCHITECTURE/CONTEXT.md:73`, `SERVER-ARCHITECTURE/CLAUDE.md:63`,
`scale-planning SKILL.md:79-80`) are repaired to cite; the snapshots' bare TBDs become
"default until retuned".

**N-022 — tracer fired 01/09/2026.** Ten signals classified. **Checkable now:**
SESSION_ENGINE doctrine⇄settings parity (red today until N-012's repair lands),
`RATELIMIT_FAIL_OPEN` (absent-while-unwired / explicitly `False` once imported),
`IGNORE_EXCEPTIONS` doctrine⇄settings parity. **Once-wired:** register⇄`TOPOLOGY.md`-inventory
parity, `Criticality`/`Component` enum⇄register parity (also catches a new surface arriving
without its row), register bound-cell lint, counter-model Postgres residency. **Unlikely:**
free-prose fail-mode contradiction (narrow to ownership via the `doctrine-drift.sh` idiom —
the register as sole owner of fail-mode statements); broker-eviction separation (deploy
repo's knob). Gate idioms captured: exit 0/1/2 contract, printed denominator,
`GATE-REPORTING.md`'s absent-surface-vs-absent-tool rules; `TOPOLOGY.md` is a skeleton until
the first `/scale-planning` run, capping how hard parity gates may fail before regeneration.
Feeds N-023.

**N-013 — settled 01/09/2026 (grilling, Sam).** The register **splits on the repo's existing
rule-versus-answers pattern**, correcting N-009: `code/docs/reliability/` owns the **rule** —
column definitions, what a give-up and a bound mean, the slow-is-absent rule — and
**`how-to/src/DEPENDENCY-POSTURE.md`** holds **this project's rows**, both halves sharing the
same columns exactly as `NEGATIVE-SPACE.md:61-77` prescribes for
`NEGATIVE-SPACE` → `INVARIANTS`. Measured cause: `FORWARD-VOICE.md:51-56` states the split
("the rule … lives here; the answers are this project's and live in `how-to/src/`"), it is
instantiated three times, and all five existing answer sheets are in `how-to/src/` — a
`code/docs/` register would be the only one breaking it. **One row per dependency** in
`TOPOLOGY.md`'s inventory (11 today, not the 2 probed components) — a posture decided before
the code exists is the map's whole Destination — with a **Probed** column carrying
`checks.py`'s existing "each arrives with its surface" answer. Columns:
**`Dependency | Criticality | Probed | What is given up | Bound | Stated in`** —
`Criticality` is the enum value, so the enum⇄register mirror is a greppable column rather than
a convention; `Bound` carries the numbers (replica pin/lag 5 s, page-cache TTL); `Stated in`
routes like `INVARIANTS.md`. **Amended by N-016 (01/09/2026): a dependency splits into
per-plane rows where its planes have different give-ups** — Valkey becomes three (cache DB 1,
broker DB 0, pub/sub DB 0), because one `DEGRADABLE` verdict is measurably false of the broker
plane, whose queue `TOPOLOGY.md:57` states is not reconstructible. **No `Recovery` column** — recovery is the deploy repo's
(`BUILD-OPERATE-SEAM.md`), and a column this repo cannot fill honestly is worse than none. No
owner column, matching all five precedents.

**N-019 — settled 01/09/2026 (grilling, Sam).** Cache doctrine becomes **conjunctive, and the
TTL is the stated staleness bound**: every cached value carries a TTL **and**, where a write
can invalidate it, an invalidation trigger. The charted "invalidate-on-write plus mandatory TTL
backstop" was the map's synthesis, not the tree's rule — `DATABASE-PERFORMANCE.md:232` actually
says "**either** a TTL **or** an explicit invalidation trigger", which leaves an unbounded
staleness window whenever a trigger misfires; that line is repaired. "Never write-through,
never an authoritative cache" is written for the **first time** (measured absent repo-wide).
The TTL fills the register's `Bound` cell for Valkey-as-cache. The **stampede ladder moves into
the reliability family** as declared-not-wired escalation doctrine — the five citations of the
phantom "cache-stampede-mitigation ADR" and `BACKEND-CODING-PRINCIPLES.md:334`'s "caching
decision record" repoint there, and `get_or_set_coalesced()` is documented as the named step-1
helper that arrives with its measurement, not mandated on code that does not exist. The general
phantom-ADR policy stays N-020's.

**N-021 — settled 01/09/2026 (grilling, Sam).** Phase 2 is **named as the C sacrifice and
reconciled explicitly**, not merely cited. The sharding section states that this is where the
stack knowingly trades consistency enforcement for horizontal capacity, and cites the
architecture guide's clause; **`NEGATIVE-SPACE.md` gains the cross-shard exception with its
named service-layer enforcement point** — "one enforcement point, named" is satisfied by naming
the new point, not by ignoring the move. Sharper than charted: `CORE-AND-SCALING.md:105` makes
the move in eighteen words ("Referential integrity moves to the service layer") citing neither
`NEGATIVE-SPACE.md` nor `DATABASE.md`, while `.claude/CLAUDE.md` §6 and `DATABASE.md:47-52`
make database enforcement law — and **nothing in the tree reconciles them**, leaving the
invariant register silently false the day a shard lands.

**N-016 — settled 01/09/2026 (grilling, Sam).** The SSE guarantee is named **"at-most-once
transport under an eventually-delivered application contract"** — pub/sub may drop a frame,
**Postgres is asserted as the durable record** (charted as design fact, re-measured as merely
inferable from the replay sentence — now stated), and the on-connect backlog replay is what
makes the application contract hold; transport and application guarantees are named as two
different things. **Outage behaviour:** the pub/sub plane dying drops open streams; clients
reconnect on `EventSource`'s native backoff and the backlog replay is the recovery path.
**`Last-Event-ID` is declined with its reason** — the server re-derives unseen state from
Postgres under the recipient's own RLS, so a client-supplied cursor is both redundant and a
trust surface. A pub/sub **probe component is declared**, arriving with the surface per
`checks.py`'s existing "each arrives with its surface" rule — the gap it closes is that
Valkey's `DEGRADABLE` verdict was reached reasoning about the cache plane alone
(`checks.py:9`). **Presence takes a posture, not a design:** presence state lives on the
pub/sub plane and is lost on outage — accepted, because it is soft state reconstructed by the
next heartbeat. The three-way wording conflict (`TOPOLOGY.md:69` per-user sorted sets ·
`LOAD-PROFILES.md:84` scanned per-user keys · `READINESS.md:86` "presence markers") joins
N-024's sweep; **what presence means** — semantics, visibility, staleness window — has no
story, no doc and no code, and goes to fog of war rather than being invented here.

**N-017 — settled 01/09/2026 (grilling, Sam).** Each external surface gets a posture row naming
its **deferred** failure. **Object store:** presigning is a local SigV4 HMAC — re-verified
mechanically, no call reaches the store — so an outage is **invisible at issue time** and
surfaces in the user's browser; the bound is the URL's expiry and the give-up is that no
server-side check proves the store reachable. A reachability probe before signing was rejected:
the trap is a property of the mechanism, not a defect to engineer away, and a round-trip per
signed URL contradicts `OBJECT-STORAGE.md:141`'s sign-per-request rule. **Cloudinary:**
server-built `<img>` URLs mean a CDN outage is **broken media elements — the page degrades
rather than fails**; declared, with no fallback asset built, and `DependencyUnavailable` is
promoted from a test fixture (`test_errors.py:95`, the repo's only Cloudinary outage stance) to
the named error type. **Mail:** the enqueue-never-500 promise
(`NOTIFICATIONS.md:28`) rests on **three** silent-drop paths, not the two charted — acks-early
(`TASK-AUTHORING.md:125-133`), the evictable shared DB 0 (`:134-141`), and the
`on_commit`-callback loss (`:84-88`) whose accepted-loss reasoning **explicitly does not cover
this case**, since `:90-91` ends the acceptance "the moment a second party depends on the
event" and a notification recipient is that party. The relay's own unreachability has no retry,
timeout or dead-letter policy anywhere, and the row states so. The **live settings gap** this
exposed — `MAILERS` defined in dev and test only, so staging and production fall through to
Django's default SMTP against `localhost:25` — graduates to `GAPS.md` as a blocker, not a
mandated live fix: the posture is `development`, nothing is deployed, and choosing staging's
mail backend is a real decision with no story behind it.

**N-018 — settled 01/09/2026 (grilling, Sam).** One sentence lands at
`code/docs/architecture/CORE-AND-SCALING.md`, the layer owner that already holds the negative
half (`:64-78`): _built maintainable, readable and scaleable beats built optimised — the shape
that survives growth is decided day one, the infrastructure that serves it is never bought
ahead of a measured gate._ **`READINESS.md`'s six dimensions are the canonical list** and
`scale-planning/SKILL.md:165-174`'s five-bullet restatement is **deleted, not reworded** — it
has already drifted into a falsehood, asserting "`tenant_id` on every user-owned table" where
`READINESS.md:67` explicitly denies it ("the scoping key may not be uniform"). The broken
pointers are repaired **by making the promise true**, not by redirecting: the sentence plus a
short invariants list land at `CORE-AND-SCALING.md` and the pointers keep aiming there —
repointing them at `READINESS.md` would invert the rule-versus-answers split N-013 settled,
since that is a regenerated per-project snapshot. Re-measured 01/09/2026: the pointers number
**five**, not three (`planner:38-42`, `planner:118`, `code-reviewer:98-101`, `backend:162`,
`stack-django:99`) — the charted `implement-story CONTEXT.md:59` **does not exist**, that skill
having no `CONTEXT.md` and no mention of the guide; and pagination-by-default appears at five
sites, not three.

**N-020 — settled 01/09/2026 (grilling, Sam).** **Accepted with rules, and the rules are
enforceable.** The node is not "tighten a gate" but "one document sanctions what another gate
exists to stop": `TEMPLATE-TOKENS.md:493-494` licenses named-pattern ADR citations (naming two
of the phantoms as its worked examples) while `doc-references.sh:8` forbids citing a
per-project instance — and that audit's own header records this class burning the repo once
already in its numbered form. Four rules settle it: the sanction survives **only in files
carrying the "Template skeleton" banner** (54 of the sites sit in the two
`/scale-planning`-regenerated folders); the pattern names become a **closed registered set**,
collapsing 15 spellings to 8; **content claims are banned outright anywhere** — the class that
turns a placeholder into a false promise, of which `READINESS.md:137`'s "router code is
pre-written in the scaling ADR" is the specimen; and `doc-references.sh` gains a check for
closed-set membership plus banner presence. **The policy binds retrospective citations only.**
Re-measured 01/09/2026: **56 sites across 15 files naming 8 absent ADRs**, not the charted ~30
naming 6. **Correction to this map's batch-4 note: `RENDERING.md:45` is not a defect** — it and
16 others are _prospective_ gates ("argue an ADR before adding real-time"), correct
instructions whose referent should not exist yet; binding them would ban the repo from telling
anyone to write an ADR. Only a citation asserting a record exists is a false assertion.

**N-023 — settled 01/09/2026 (grilling, Sam).** **`audits/posture-parity.sh`** — fail-tier,
**no path filter** (the `audit-doc-references.yml` precedent: any file can carry a posture
claim, so scoping recreates the blind spot), self-guarding on absent surfaces. It asserts the
three signals checkable today — `SESSION_ENGINE` doctrine⇄settings, `IGNORE_EXCEPTIONS`
doctrine⇄settings, `RATELIMIT_FAIL_OPEN` absent-while-unwired — and **skips the once-wired
parity checks with a printed reason** per `GATE-REPORTING.md`, never a silent pass. Registered
in the same change as `.github/workflows/audit-posture-parity.yml` plus the inventory and
dependencies rows in `audits/CONTEXT.md`. **It is red on day one by design** — `TOPOLOGY.md:74`'s
session claim is false against the settings — and N-024's sweep is what greens it. A warn tier
was rejected: `CONTEXT.md` holds that a warn tier is earned, and every clause here is a presence
test. **Known limitation:** adding it to the 20 required contexts on ruleset 20221742 is a step
outside this repo and outside `audits/CLAUDE.md`'s procedure, so it lands non-blocking until
that is done by hand.

**N-024 and N-025 — specified onto S-07, 01/09/2026 (build).** Named, never performed: writing
the repairs is the story's work, and doing it in a resolve sitting would skip
`02-story-creation`, its plan, and every gate the workflow chain applies. Their deliverables
and acceptance are S-07's row.

---

## Slices

Low-resolution until their nodes resolve; each story sharpens its cell, never loosens it.

| Slice | Story | Title                                                               | Nodes                                                | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Flags                    |
| ----- | ----- | ------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| S-01  | —     | The owning homes: CAP argued from both sides, the posture register  | N-009 ✅ · N-013 ✅ · N-021 ✅                       | **The guides name PACELC alongside CAP** (fog, 01/09/2026), stating **slow-is-absent as the PA half** — `S-01`'s own, via Q5 — and **citing** the EL deviations to their owners rather than stating them: the architecture guide's pin-after-write window (N-014, `S-04`) and the cache TTL as the stated staleness bound (N-019, `S-06`). Two homes split by the CAP side each defends: the `reliability/` family argues availability-over-consistency for degradable dependencies and owns the register's **rule half** and the slow-is-absent rule; a new `architecture/` guide argues consistency-as-default with every deviation bounded and named, and names Phase-2 sharding as the C sacrifice with `NEGATIVE-SPACE.md` gaining the cross-shard exception and its service-layer enforcement point; `how-to/src/DEPENDENCY-POSTURE.md` holds one row per `TOPOLOGY.md` dependency across `Dependency \| Criticality \| Probed \| What is given up \| Bound \| Stated in`; each home names CAP explicitly, states its own clause, cites the other; every guide routes to them, none restates. **ADR candidate** (three-test gate at story time) | QA: docs gates           |
| S-02  | —     | Limiter and security-counter fail-mode doctrine                     | N-010 ✅ · N-011 ✅                                  | Availability throttles (public, authenticated, MCP per-key) documented fail-open with the outage visible as `degraded`; access-decision limiters (auth-form, lockout, MFA) fail closed; lockout/MFA counters Postgres-resident; `RATELIMIT_FAIL_OPEN=False` mandated at first wiring; admin-bearer outage and flush consequences stated as posture rows. **ADR candidate** (three-test gate at story time)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Security: yes · QA: unit |
| S-03  | —     | The degraded contract scoped, sessions settled                      | N-012 ✅ · N-014 ✅                                  | `degraded` stays 200 permanently; the register's give-up column is the suspension statement, cited by `HEALTH-CONTRACT.md` and `HEALTH-PROBES.md` with "serving correctly" rescoped; the traffic-shedding overclaim repaired; session doctrine is pure-DB (`cached_db` a phase-gated optimisation) with `TOPOLOGY.md:74` and `US000-TEMPLATE.md:245` repaired to match                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Security: yes            |
| S-04  | —     | Replica doctrine unified; triggers and phantom ADRs disciplined     | N-014 ✅ · N-015 ✅ · N-016 ✅                       | The architecture guide owns staleness/routing (the two other sites cite it); read-your-writes = time-boxed pin-after-write, declared not wired, pin window = lag alert threshold (default 5 s sustained) as a register bound; Phase-1 gate budget-derived (50 ms lives once as the budget default), Phase-2 70 % a labelled default at the owner, seven leaking sites repaired to cite; the "pre-written" promise repaired                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | QA: docs gates           |
| S-05  | —     | Async and external surfaces: SSE contract, store/CDN/mail postures  | N-016 ✅ · N-017 ✅                                  | The SSE design names at-most-once transport under an eventually-delivered application contract, with Postgres asserted as the durable record, disconnect-and-replay outage behaviour, the reasoned `Last-Event-ID` decline and a declared pub/sub probe; presence is posture-only (soft state, lost on outage); object store, Cloudinary and mail each carry a posture row incl. the presign-signs-while-dead trap, the broken-media stance and mail's three drop paths; the Cloudinary storage contradiction is repaired                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | QA: docs gates           |
| S-06  | —     | The best ground and the cache bound                                 | N-018 ✅ · N-019 ✅                                  | `CORE-AND-SCALING.md` gains the owning sentence (maintainable/readable/scaleable beats optimised) plus the short invariants list, so the five pointers keying to it resolve without being redirected; `READINESS.md`'s six dimensions are canonical and `scale-planning/SKILL.md:165-174`'s five-bullet restatement is deleted with its `tenant_id` overreach; cache doctrine is conjunctive (TTL **and** invalidation trigger) with the TTL stated as the staleness bound and "never write-through, never authoritative" written; the stampede ladder lands in the reliability family and its phantom-ADR citations repoint                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | QA: docs gates           |
| S-07  | —     | The repair sweep, the citation policy, the gate, and the live fixes | N-020 ✅ · N-022 ✅ · N-023 ✅ · N-024 ✅ · N-025 ✅ | **Repairs (N-024):** `TOPOLOGY.md:74` and `US000-TEMPLATE.md:245` sessions, `logging/CLOUDINARY.md`'s present-tense storage claim (incl. its config block and four required env vars), the four present-tense `cache_marketing` claims, the three-way presence wording conflict, the readiness-invariants pointers, the `OVERVIEW.md:69` WebSocket parenthetical. **Citation policy (N-020):** the banner-scoped sanction, the closed 8-name set, the ban on content claims, and `doc-references.sh` extended to check membership and banner. **Gate (N-023):** `audits/posture-parity.sh` — fail-tier, no path filter, self-guarding, registered with its workflow and both `CONTEXT.md` rows in the same change; uncheckable rules report unchecked per `GATE-REPORTING.md`; red on day one until the repairs land. **Live fixes (N-025):** only what a settled rule makes non-optional — the `Criticality` docstring citing the register, and scoping `HEALTH-PROBES.md:45`'s "serving correctly" wording.                                                                                                                                         | QA: unit · CI            |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. S-01 gates S-02–S-05
(they write into the homes N-009 named; the reliability half also waits on
`MAP-RETRY-AND-IDEMPOTENCY` S-01 building the family — the architecture half is free). S-06
gates on nothing and could ship first. The
`Story` column is back-filled by `02-story-creation`; no number is reserved here.

---

## Frontier

**The frontier is empty.** Every node charted on 01/09/2026 has been settled, and the two
build nodes are specified onto S-07 rather than performed.

_Empty — every node is settled. The Resolved decisions table above is the record._

**All five batches settled 01/09/2026. Every slice S-01 to S-07 has its nodes resolved, so all
seven are cuttable in `workflows/02-story-creation/`.** Suggested order: **S-06 first** (it
gates on nothing), then **S-01** — whose reliability half waits on `MAP-RETRY-AND-IDEMPOTENCY`
S-01 building the family while its architecture half is free — then S-02 to S-05, and **S-07
last**, because its gate is red until the repairs it also carries have landed.

---

## Fog of war

**Dispositioned 01/09/2026: one answered, one cleared, three stay with named triggers.**

- **Whether the posture register and the timeout register are one artefact — stays.** Both are
  **unbuilt** (re-measured: no `how-to/src/DEPENDENCY-POSTURE.md`, no timeout register, no
  `code/docs/reliability/` family to hold either rule half), and their settled shapes genuinely
  diverge — one row per dependency **plane** with six columns here (N-013) against one row per
  **outbound socket** with five columns there (N-012). A merged sheet is not refutable from the
  tree, and deciding it here would reopen two settled column sets across the Q2 ownership boundary
  on no new evidence. **Correction to the item as charted:** the timeout register is
  `MAP-RETRY-AND-IDEMPOTENCY` **S-02**'s deliverable, not S-01's; and file naming is deferred to
  story work only on **that** side — N-013 and this map's `S-01` acceptance already name
  `how-to/src/DEPENDENCY-POSTURE.md`. **Trigger, fired by whichever sitting comes first** (the
  suggested build order puts `S-01` early, so keying it to the retry map alone would fire against a
  fait accompli): the first of **this map's `S-01`** or **`MAP-RETRY-AND-IDEMPOTENCY` `S-02`** to
  reach `02-story-creation` opens the merge question, with the other map's owner as the second
  party. If `S-01` is cut first, its story must state that `DEPENDENCY-POSTURE.md`'s shape is
  **provisional** against a timeout register still to be named.
- **Multi-node Valkey — stays.** Quorum, replication and split-brain territory. **The deferral
  anchor holds at HEAD and nothing has moved:** `TOPOLOGY.md:57` and `:88` both defer to a
  cache-posture ADR that does not exist — legally, because `TOPOLOGY.md` carries the
  Template-skeleton banner N-020's sanction is scoped to, **provided `cache-posture` enters `S-07`'s
  closed eight-name set**. Provisioning is ruled out by this map's own anti-forecast bound, and
  quorum doctrine for an instance count of one would be a decision made on nothing. **Trigger:** the
  ADR stops being phantom — a story authors `ADR-US###-*CACHE-POSTURE*`, or a `/scale-planning` run
  regenerates `TOPOLOGY.md` with Valkey HA inside the sized envelope.
- ~~**The deploy repo's actual behaviour on `degraded`/`down`.**~~ **Cleared 01/09/2026 — this was
  never fog, it is _out of scope_ misfiled.** `HEALTH-CONTRACT.md:58` states that all of it lives in
  `<%DEPLOY_REPO%>`, and this map's own _Out of scope_ table already rules out the deploy repo's
  edge implementation per `BUILD-OPERATE-SEAM.md` — the fog bullet **duplicated that row**. This
  repo specifies the contract and can never observe the consumption, so **no future event makes it
  this map's decision** and a trigger would be a promise nobody here can keep. It merges into the
  existing _Out of scope_ row rather than reading as pending.
- ~~**PACELC beyond slow-is-absent.**~~ **Answered 01/09/2026: the EL half is already settled in
  substance, and only the teaching remains — which is `S-01` story work.** Q5 settled the PA half
  (past-budget is treated as absent); N-019 settled the else-branch in substance (every cached value
  carries a TTL **stated as its staleness bound** — latency chosen over consistency in normal
  operation, the deviation bounded and named), and N-014 did the same for replica reads
  (pin-after-write, 5 s). **That is PACELC's EL clause in everything but name**, and PACELC appears
  in no guide at HEAD. `S-01`'s acceptance therefore gains one clause — and it **cites rather than
  states**, because N-009 makes the reliability family cite register rows and puts replica doctrine
  in the architecture guide, and `S-01` runs before `S-04` and `S-06` write those bounds. No new
  node: the trade-off was taken at N-019 and N-014.
- **What presence means — stays.** N-016 settled its _posture_ (soft state on the pub/sub plane,
  lost on outage, reconstructed by the next heartbeat) but nothing defines the **feature**.
  Re-measured 01/09/2026: **zero** presence code, no story, and the doc mentions are infrastructure
  sketches in regenerated snapshots — mechanism without meaning. **One constraint the item missed
  and the eventual story inherits:** `code/docs/DESIGN-TOKENS.md:89-98` already pre-commits a
  three-state vocabulary — **online / unavailable / offline** — as colour tokens, which constrains
  the feature without defining it: no visibility rules, no staleness window, no owner. Defining
  semantics here would be a decision made on nothing. **Trigger:** the first story requiring
  presence as a user-facing capability; its `05-user-flow-design` pass defines the state semantics,
  visibility rules and staleness window, and **must reconcile its state names with the token
  vocabulary already shipped**.
- ~~**Whether N-020 belongs to this map or `MAP-RULE-OWNERSHIP`**~~ — settled by resolving it
  here on 01/09/2026. It stays this map's: the defect is a posture-doctrine citation class, and
  S-07 carries it. `MAP-RULE-OWNERSHIP` is unaffected.

---

## Out of scope

| Ruled out                                                                 | Why                                                                                |
| ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Provisioning any infrastructure (replica, second Valkey, broker instance) | Anti-forecast is absolute; this map writes doctrine ahead of need, never hardware  |
| Re-deciding retry, idempotency, outbox, isolation, timeout values         | Settled on `MAP-RETRY-AND-IDEMPOTENCY` 01/09/2026; cited, never reopened (Q2)      |
| Building throttle middleware, SSE, the object-store adapter, mail wiring  | SL-1: the template ships no domain code; postures are decidable as doctrine (Q4→2) |
| The Valkey DB 0/DB 1 split and `CACHE_URL`                                | `MAP-RETRY-AND-IDEMPOTENCY` N-018 owns it; this map's N-005 facet is routed there  |
| The deploy repo's edge implementation (CF rule, Gatus, 503 page)          | This repo specifies, the deploy repo implements (`BUILD-OPERATE-SEAM.md`)          |
| Correcting `GAPS.md`/`DEFERRED.md` or authoring ADRs from this map        | Claiming vs closing; ADRs arrive via slice stories under the three-test gate       |

---

## Session log

| Date       | Node settled                      | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                  | Frontier redrawn |
| ---------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| 01/09/2026 | N-001–N-008                       | Charted; eight research nodes discharged by the measured sweep                                                                                                                                                                                                                                                                                                                                                           | [x]              |
| 01/09/2026 | N-010, N-011                      | Settled by grilling: fail modes split availability-open / access-closed; counters Postgres; admin-token consequences accepted as posture rows                                                                                                                                                                                                                                                                            | [x]              |
| 01/09/2026 | N-009                             | Settled by grilling (restatement confirmed): two homes split by the CAP side each defends; single register in `reliability/`; each home states its own clause                                                                                                                                                                                                                                                            | [x]              |
| 01/09/2026 | N-012, N-014, N-015, N-022        | Batch 2 settled by grilling (degraded stays 200, give-up column = suspension statement, pure-DB sessions; pin-after-write with coupled 5 s bound; budget-derived P1 gate, labelled 70 % P2 default) and the N-022 tracer (ten signals classified)                                                                                                                                                                        | [x]              |
| 01/09/2026 | N-013, N-019, N-021               | Batch 3 settled by grilling: register splits rule (`reliability/`) from rows (`how-to/src/DEPENDENCY-POSTURE.md`) on the `FORWARD-VOICE.md:51-56` pattern — **amending N-009**; one row per dependency, six columns; cache doctrine conjunctive with TTL as the bound and the stampede ladder rehomed; Phase 2 named as the C sacrifice with `NEGATIVE-SPACE.md` gaining the cross-shard exception                       | [x]              |
| 01/09/2026 | N-016, N-017                      | Batch 4 settled by grilling: SSE named at-most-once transport under an eventually-delivered contract, `Last-Event-ID` declined, presence posture-only; store/CDN/mail posture rows incl. the presign and third-drop-path findings; the mail settings gap graduated to `GAPS.md`. Valkey splits into per-plane rows, **amending N-013**                                                                                   | [x]              |
| 01/09/2026 | N-018, N-020, N-023, N-024, N-025 | Batch 5 closes the frontier: the best-ground sentence lands at `CORE-AND-SCALING.md` with the skill's drifted five-bullet list deleted; the citation sanction is accepted-with-rules (banner-scoped, closed 8-name set, content claims banned) and bound to retrospective citations only — **correcting this map's `RENDERING.md:45` claim**; `audits/posture-parity.sh` specified; both build nodes specified onto S-07 | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed (Sam, 01/09/2026 — Q1–Q5)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 0 blocks · 2 unrelated
- [x] Every claimed entry names what will retire it — **nothing claimed, nothing closed**. One
      `GAPS.md` entry was **written** 01/09/2026 (N-017's mail-backend blocker) as a graduation
      per the wayfinder table; `✅ CLOSED` stays `22-implementation-documentation/`'s
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — N-009 and N-010 resolved 01/09/2026
- [x] Every resolved node links to the artefact it became — research findings → the grilling
      nodes they opened; grilling decisions → their slice rows; build nodes → S-07
- [x] Every slice has a flag manifest — `N/A` omitted
- [x] Index row in `CONTEXT.md` current — deliberately absent per `MAP-RULE-OWNERSHIP` N-010

**Stories may be cut in `workflows/02-story-creation/` — the frontier is empty as of
01/09/2026 and all seven slices are cuttable.**
