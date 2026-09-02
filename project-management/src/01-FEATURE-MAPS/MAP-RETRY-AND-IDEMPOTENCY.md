# MAP-RETRY-AND-IDEMPOTENCY — a repeated call is safe, and exactly one layer decides to repeat it

**Charted**: 27/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `7a82095` (`v7.4.1`) · **Research resolved at**: `7a82095` (27/08/2026)
**Status**: Fully charted (01/09/2026) — ready for `02-story-creation`
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 25

> Charted from a documentation audit of retry and idempotency coverage run 27/08/2026 against
> `7a82095`. Every line reference below was taken from the working tree at that commit. The audit
> found seventeen items across fourteen guides: ten contradictions and seven structural gaps.

---

## Destination

**Every surface that talks over a network states who retries it, on which failures, with what
bound — and every write states whether repeating it is safe and by what mechanism.** Done means
the doctrine is internally consistent, a gate holds it there, and the live code that already
breaches a written rule is fixed.

The measured cause is single and structural: **retry and idempotency doctrine grew inside the
guide for one surface (`TASK-AUTHORING.md`, background tasks) while the concerns span six** —
HTTP clients, database transactions, queue consumers, webhooks, MCP tools, and the CLI. Three
documents now claim ownership and contradict each other on backoff, classification and queue
count.

---

## Notes

| Field                    | Value                                                                                     |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| Domain                   | Reliability doctrine — retry policy, idempotency, timeouts, and the gate over them        |
| Skills to load           | `doc-writer` · `backend` · `stack-django` · `cicd` · `grill-with-docs` · `version`, `git` |
| Standing preferences     | See below — four already-settled constraints bound this work                              |
| Umbrella ADRs            | None yet, and none authored here — ADRs are workflow `15`, after stories (`02`)           |
| Register entries triaged | 0 closes · 0 blocks · 5 unrelated (3 standing limitations exempt)                         |
| Cross-map                | None. `MAP-GATE-PARITY` shares the audits surface at `N-020`; referenced, not merged      |

**Standing preferences — settled before this map and not reopened by it:**

- **`DOCUMENTATION-PAIRING.md` — route, don't restate.** A rule lives in exactly one place. Three
  documents carrying task-retry rules is that rule broken, and repairing it is `N-006`/`N-007`,
  not a licence to write a fourth copy.
- **`GATE-REPORTING.md` Section 1** — "could not look" is never reported as "looked, and it was
  clean". The gate node (`N-020`) answers to it: a rule it cannot mechanically check must report
  as unchecked, never as passing.
- **Deferred-with-a-trigger** — `TASK-AUTHORING.md` → _Deferred, with a trigger_ is the house form
  for something deliberately absent. `N-011` (circuit breaker) inherits it as the default shape.
- **Declared, not wired** — a guide may be the design of record for a surface that does not exist
  yet. This map does not build surfaces; it makes their designs consistent.

**Accepted property (27/08/2026).** The template ships almost no application code, so most
findings are **doc-versus-doc**. Four are doc-versus-code and are named in _Register claimed_'s
note below; three of those four are in bounds by the Q3 answer.

**No index row in `CONTEXT.md`, deliberately.** `copier.yml` excludes `/project-management/src/**`
and negates `**/CONTEXT.md`, so the map index **ships**. A row here naming a syntek-base map would
arrive in every generated project pointing at a file that is not there. All nine other maps here
are unindexed for the same reason; the conflict with the wayfinder gate checklist is in fog of war
on `MAP-GATE-PARITY` and is not re-opened here.

---

## Register claimed

Every open entry triaged. **Nothing here edits `GAPS.md` or `DEFERRED.md`.**

| Register      | Entry                                                                                       | Verdict   | Retired by |
| ------------- | ------------------------------------------------------------------------------------------- | --------- | ---------- |
| `GAPS.md`     | 22/08/2026 — `main` has never received this branch                                          | unrelated | its own PR |
| `GAPS.md`     | SL-1, SL-2, SL-3                                                                            | exempt    | —          |
| `GAPS.md`     | Still open — `COVERAGE.md` pytest flags · `10.0.1.0/24` collision · `pnpm-update.sh` header | unrelated | —          |
| `DEFERRED.md` | _(no rows)_                                                                                 | —         | —          |

**This feature closes nothing, and that is the same finding `MAP-GATE-PARITY` recorded.** All
seventeen items came from an audit and were never written to `GAPS.md`, whose own _Format_ section
says new items are recorded there **first** and charted afterwards. Two maps in a row cut from a
report rather than from the register is a pattern, not an accident — worth its own node on a
process map, not this one.

**One finding is consciously routed out rather than claimed.** The Cloudinary-as-default-storage
contradiction (`logging/CLOUDINARY.md:18` versus `config/settings/base.py:203`) is out of scope by
the Q3 answer and needs a `GAPS.md` row of its own. **This map does not write it** — recording it
is a deliberate act by whoever owns the register, and a map that quietly filed it would be editing
a register it is only allowed to read.

---

## Resolved decisions

Each links to the artefact it became. **An answer that lives only here has not been graduated.**

The first five are **research** nodes, fired during charting because they need no human. Each
one changes what a later grilling node can honestly decide, which is why they were taken first.
The rest fell on 01/09/2026, across eight sittings in one day — every grilling node, the
tracer, and the three build nodes, resolved by specification onto their slice rows (which is all
a build node ever resolves to). Frontier and fog of war are both empty.

| Node  | Decision                                                    | Type     | Settled    | Became                                    |
| ----- | ----------------------------------------------------------- | -------- | ---------- | ----------------------------------------- |
| N-001 | Celery's real retry primitives at 5.6                       | research | 27/08/2026 | finding below → input to `N-008`, `N-010` |
| N-002 | botocore's default retry and timeout posture                | research | 27/08/2026 | finding below → input to `N-008`, `N-012` |
| N-003 | Whether FastMCP's `RetryMiddleware` exists and what it does | research | 27/08/2026 | finding below → input to `N-008`          |
| N-004 | Whether a Valkey hang can degrade to a miss                 | research | 27/08/2026 | finding below → input to `N-012`, `N-023` |
| N-005 | What Django does with a deadlock or serialization failure   | research | 27/08/2026 | finding below → input to `N-015`          |
| N-006 | Doctrine's owner — a new `code/docs/reliability/` family    | grilling | 01/09/2026 | S-01 slice row + decision below           |
| N-007 | `API-AND-MONITORING.md` section → monitoring residue only   | grilling | 01/09/2026 | S-01 slice row + decision below           |
| N-008 | One layer retries; SDKs clamped; delegation via register    | grilling | 01/09/2026 | S-02 slice row + decision below           |
| N-009 | Inbound `Retry-After` honoured, clamped by the budget       | grilling | 01/09/2026 | S-02 slice row + decision below           |
| N-010 | Celery-default budget table; total age a derived ceiling    | grilling | 01/09/2026 | S-02 slice row + decision below           |
| N-011 | Breaker mandate deleted; deferred with a trigger            | grilling | 01/09/2026 | S-02 slice row + decision below           |
| N-012 | Timeout register — `how-to/src/`, every outbound socket     | grilling | 01/09/2026 | S-02 slice row + decision below           |
| N-013 | `Idempotency-Key`: replay stored response; Postgres store   | grilling | 01/09/2026 | S-03 slice row + decision below           |
| N-014 | Stale writes: declared stance; ordering stated separately   | grilling | 01/09/2026 | S-03 slice row + decision below           |
| N-015 | DB aborts: environment error; replay machinery deferred     | grilling | 01/09/2026 | S-03 slice row + decision below           |
| N-016 | HTMX double-submit: declarative suppression, mandatory      | grilling | 01/09/2026 | S-03 slice row + decision below           |
| N-024 | Key enforcement: per-endpoint opt-in, `throttle=` shape     | grilling | 01/09/2026 | S-03 slice row + decision below           |
| N-019 | Gate signals: 5 mechanical · 7 heuristic · 7 unchecked      | tracer   | 01/09/2026 | finding below → input to `N-020`          |
| N-020 | Two standalone audits; heuristics fail red, `RETRY-OK:`     | grilling | 01/09/2026 | S-05 slice row + decision below           |
| N-017 | Queue count: `TASK-AUTHORING.md` wins; table reduced        | grilling | 01/09/2026 | S-04 slice row + decision below           |
| N-018 | Valkey DB 0/1: a voice defect — repaired, no code change    | grilling | 01/09/2026 | S-04 slice row + decision below           |
| N-021 | Repair the four bad examples                                | build    | 01/09/2026 | S-04 slice row — spec + evidence below    |
| N-022 | Jitter the two health TTLs                                  | build    | 01/09/2026 | S-06 slice row — spec + evidence below    |
| N-023 | Valkey socket timeouts + the ClickUp `urlopen` timeout      | build    | 01/09/2026 | S-06 slice row — spec + evidence below    |
| N-025 | The method contract's completeness, and the non-Ninja rule  | grilling | 01/09/2026 | S-07 + S-08 slice rows + decision below   |

**N-001 — Celery 5.6.** `max_retries` defaults to **3**; `retry_backoff` (1 s base), `retry_backoff_max`
defaults to **600 s**, `retry_jitter` defaults to **True**, plus `autoretry_for` / `dont_autoretry_for`.
Two consequences the doctrine must absorb: the defaults apply **only on the `autoretry_for` path** —
a manual `self.retry(exc=…)` gets neither backoff nor jitter, which is exactly the shape both
contradicting examples use; and **there is no native total-age bound**, because `retry_backoff_max`
caps the _interval_, not the chain. `TASK-AUTHORING.md:204` requires a bound "by attempt count **and**
by total age" that Celery does not natively provide.

**N-002 — botocore.** Defaults are `connect_timeout` **60 s**, `read_timeout` **60 s**, retry mode
`legacy` with "typically four retries" taken from the service model. An unconfigured `boto3` client
therefore retries four times at up to 120 s each, **underneath** whatever the task layer is doing —
the stacking case `N-008` exists to rule on.

**N-003 — FastMCP.** `RetryMiddleware` is real (`fastmcp.server.middleware.error_handling`), with
`max_retries=3` and `retry_exceptions=(ConnectionError, TimeoutError)`. So `TOOL-DESIGN.md:140` is
**correct** — the one reliability claim in the tree that the audit verified true. But the default
tuple does not include `DependencyUnavailable`, so out of the box it retries none of this project's
environment errors. Wiring is required, and that is `N-008`'s.

**N-004 — django-valkey 0.4.1.** `SOCKET_TIMEOUT` and `SOCKET_CONNECT_TIMEOUT` are supported in
`CACHES["OPTIONS"]` and both default to **`None`** — unbounded. `_main_exceptions` is
`(ValkeyTimeoutError, ResponseError, ValkeyConnectionError, socket.timeout)`, wrapped as
`ConnectionInterrupted` and swallowed by `IGNORE_EXCEPTIONS`. **So a hang would degrade to a miss
exactly as the settings comment promises — but only once a timeout is set.** Today the promise holds
for errors and not for hangs, and `readiness()` calls `cache.get()` before anything else.

**N-005 — Django 6.** There is **no** transaction-retry helper anywhere in `django.db`. A deadlock or
serialization failure surfaces as `django.db.utils.OperationalError` and nothing catches it. The
audit's finding that this surface is undocumented is matched by it being unimplemented, so `N-015`
decides doctrine with nothing to reconcile against.

**N-006 — settled 01/09/2026.** Cross-surface retry + idempotency doctrine gets a **new owner**: a
`code/docs/reliability/` family with its `CONTEXT.md` + `CLAUDE.md` pair and index rows. Extending
`TASK-AUTHORING.md` was measured out — ~266 cloc lines against the 270 ratchet — and what
`N-008`–`N-016` will produce exceeds one capped doc. Two migrations settle with it: the idempotency
**proof ladder** (`TASK-AUTHORING.md:143-155`, constraint → conditional transition → idempotency
key) moves to the family while the Celery specifics (`task_acks_late`, broker eviction, signature
drift) stay; and the _Retries and backoff_ **doctrine bullets** (`:197-212`) move while the class
table stays as the task-surface expression. File naming inside the family is S-01's story work.

**N-007 — settled 01/09/2026.** _Background Jobs and Queues_ is deleted bar a **monitoring-only
residue** — failed-job visibility, this guide's own remit — plus a pointer to the family. Every
other rule in it duplicates `TASK-AUTHORING.md` (`:79` pass-IDs, `:212` visibility, whole
sections for the rest). The three pointer repairs (`PROCESS-MODEL.md:166`, `NEGATIVE-SPACE.md:226`,
`code/docs/CONTEXT.md:91`) follow mechanically — S-01 story work, decided nowhere twice.

**N-008 — settled 01/09/2026.** **Exactly one layer decides to repeat an operation; every layer
beneath it makes one attempt.** SDK-internal retries are clamped off by default (boto3
`retries={"max_attempts": 1}` and kin); a client that keeps transport retries does so via its
register row (`N-012`) naming the delegation and why — the `DICT-OK:` escape-hatch pattern
applied to retries. Served surfaces never retry inbound work: FastMCP's `RetryMiddleware` stays
**deliberately unwired** (the agent caller owns the repeat), and exit 75 remains the CLI
expression. Consequence for the sweep: `NEGATIVE-SPACE.md`'s environment-error row gains a
pointer, never a column — the register owns per-client ownership (fog item retired). The rule is
an **ADR candidate**: S-02's story runs the three-test gate.

**N-012 — settled 01/09/2026.** A **timeout register** ships as a new `how-to/src/` answer sheet
(the `PLATFORM-PROVIDERS.md` pattern — rule in the family, values per project) covering **every
outbound socket**: HTTP clients, Valkey, Postgres, broker, Sentry transport. Five columns:
client · connect · read · retry owner · where set. The 5 s/30 s pair survives as the shipped
generic-HTTP default; `API-AND-MONITORING.md:33-34` reduces to a pointer. File naming is S-02's
story work.

**N-009 — settled 01/09/2026.** An inbound `Retry-After` is **honoured, clamped by the budget**:
the retry owner waits `max(backoff, Retry-After)` but never past the row's total-age ceiling; a
header beyond remaining budget means exhausted — park it, never sleep past the bound.

**N-010 — settled 01/09/2026.** **One budget table, defaults adopted from Celery's own**, taken
declaratively (`autoretry_for` path: 3 attempts, exponential from 1 s, 600 s interval cap, jitter
on). Manual `self.retry` is **banned for environment errors** — it silently loses backoff and
jitter (`N-001`). The webhook 5 attempts / 24 h budget stays as a recorded per-row override.
Total age is a **derived worst-case column**, with one named staleness escape hatch (timestamp
argument or per-message `expires`) for work that goes stale. The declarative-only rule sets
`N-021`'s repair shape.

**N-011 — settled 01/09/2026.** The breaker mandate is **deleted and deferred with a trigger**
(the house form): `SERVICE-AND-MIDDLEWARE.md:265` becomes a pointer, and the family records the
deferral — reopened by the first incident where bounded retries against a live provider degrade
service, or by the story integrating a second rate-limited external API.

**N-013 — settled 01/09/2026.** The `Idempotency-Key` contract: a completed duplicate **replays
the stored response**; an in-flight duplicate gets `409`; the key is scoped per principal +
endpoint (cross-principal replay is an IDOR); storage is a **Postgres table** under
`UNIQUE(principal, endpoint, key)` with configured retention (default 24 h) purged by the
standard retention-task pattern. Declared, not wired. Its enforcement-point shape graduated from
fog of war to `N-024`.

**N-014 — settled 01/09/2026.** **A concurrency stance is declared per mutable endpoint** —
last-write-wins is a stated decision, never a default; version column + `If-Match` is the named
mechanism where a lost update has real cost, deferred with exactly that trigger. Stated
separately: **idempotency is not ordering** — redelivery reorders, so a consumer needing order
names its mechanism, never assumes queue order. The outbox deferral's trigger gains no second
condition (fog item retired — neither decision required one).

**N-015 — settled 01/09/2026.** The baseline is stated (read committed, explicit `atomic`
blocks, no `ATOMIC_REQUESTS`); a deadlock or serialization failure **classifies as an
environment error** — the owner replays per `N-008`: task surface via classification, request
surface returns the 503 shape and never replays in-request. The transaction-boundary replay
helper is deferred with a trigger: any adoption of `SERIALIZABLE` / `REPEATABLE READ`, or a
measured deadlock rate.

**N-016 — settled 01/09/2026.** The double-submit rule enters `CLIENT-PATTERNS.md`: every
non-idempotent `hx-post` trigger carries `hx-disabled-elt` (`hx-sync` where several triggers hit
one endpoint); full-page forms use PRG plus disable-on-submit. Stated explicitly as **UX
suppression, never the safety mechanism** — the proof ladder and key contract remain the
guarantee.

**N-024 — settled 01/09/2026.** Enforcement is **per-endpoint opt-in** — a decorator or
operation parameter in the shape of Ninja's own `throttle=`; only endpoints with external
effects participate (`N-014`'s declared stance), and response storage happens only where the
contract applies. Blanket middleware rejected: it needs the per-endpoint participation signal
anyway. Declared, not wired — the design of record for S-03's guide.

**N-019 — tracer, landed 01/09/2026** (5-agent spike over the settled rules' signals). **Five
mechanical checks** (three live-red today: the Valkey `CACHES` timeouts, the two manual-retry doc
fences, the budget-kwarg tokens outside the owner), **seven heuristic** (incl. the `urlopen`
breach), **seven semantic remainders** the gate must print as UNCHECKED, **four absent surfaces**
with self-arming probes (requests/httpx, boto3, the Celery task surface, the register itself —
whose arming is asymmetric: a call-site appearing before the register exists must go red).
Recommended shape: **two standalone audits on the `dict-discipline.sh` model**
(`outbound-timeouts.sh` — every outbound call bounded and registered; `retry-discipline.sh` —
every retry declarative and budgeted in one place), one claims-row in `doctrine-drift.sh`, R11
already enforced by `doc-references.sh`, opengrep rules deferred as secondary depth — an
opengrep-first gate would open green over five live breaches (`static-analysis.sh` scopes
`code/src/django` only). Dated `RETRY-OK:` marker as the escape hatch. **Path correction:** the
live ClickUp breach is `project-management/src/00-ASSETS/scripts/sync-clickup.sh:115`, not a
`code/src/scripts/` path.

**N-020 — settled 01/09/2026.** The gate is **two standalone audits on the `dict-discipline.sh`
model** — `outbound-timeouts.sh` (every outbound call is bounded and registered) and
`retry-discipline.sh` (every retry is declarative and budgeted in one place) — plus R14's token
leg as a claims-row in `doctrine-drift.sh`; R11 needs nothing (`doc-references.sh` covers it);
opengrep rules deferred as secondary depth. **Heuristic findings fail red**, with a dated
`RETRY-OK:` marker as the escape hatch; every run prints its UNCHECKED lines and surface-absent
reasons per `GATE-REPORTING.md`; absence probes self-arm, the register's asymmetrically.
Registered in CI and lefthook per `audits/CLAUDE.md`.

**N-017 — settled 01/09/2026.** `TASK-AUTHORING.md` wins: **one queue by default**, the
second-queue trigger already recorded. The job-classification table's prescriptive Queue and
Retry columns (`SERVICE-AND-MIDDLEWARE.md:252-257`) reduce to classification plus a pointer —
folded into S-04's sweep, which already edits `:44` and `:265` in the same file.

**N-018 — settled 01/09/2026.** The charted contradiction was **overstated**: both server docs
already record the unwired baseline explicitly (`COMPUTE-ALLOCATION.md:104-106`,
`TOPOLOGY.md:92-94`). The defect is `TOPOLOGY.md:85` speaking in the present tense about the
DB-1 convention — a `FORWARD-VOICE.md` fault. Resolution: **voice repair, no code change**. DB 1
stays the locked convention; `CACHE_URL` stays unintroduced, its trigger stated (task-surface
wiring, or eviction shown to reach broker keys). A per-DB split would not isolate eviction
anyway — `maxmemory` and policy are instance-wide. Moved from S-06 (code) to S-04 (docs).

**Build nodes `N-021`–`N-023` — resolved by specification, 01/09/2026.** Deliverable and
acceptance live on their slice rows (S-04, S-06) and resolve no further. The evidence their
stories answer to:

- `N-021` — `SERVICE-AND-MIDDLEWARE.md:44` (bare `.delay()` in an un-atomic multi-write method),
  `WEBHOOKS.md:170` (bare `.delay()`, passes the raw body), plus the two retry-everything
  handlers, repaired to `N-007`/`N-010`'s doctrine.
- `N-022` — `BACKEND-CODING-PRINCIPLES.md:341` requires a jittered TTL; `apps/health/views.py:76`
  and `apps/health/checks.py:128` are both bare.
- `N-023` — `config/settings/base.py:140-150` `OPTIONS` lack both socket timeouts;
  `project-management/src/00-ASSETS/scripts/sync-clickup.sh:115` calls `urlopen` unbounded.

### N-025 — the method contract's completeness, settled 01/09/2026

**Why it is on this map and not its own.** S-03 already widens
`code/docs/api-design/REST-CONVENTIONS.md`'s method table on the RFC 10008 evidence, so that
guide's method doctrine is this map's ground. Charting a second map over it would create the
double ownership `MAP-RULE-OWNERSHIP` exists to prevent. Measured before opening: the owner spends
**14 lines** on methods (a five-row table plus four bullets) and sits at **169 cloc against the
270 ratchet**, so ~101 lines of headroom — the residue lands in the incumbent, and no new guide is
born. The domain fit is a stretch and is named rather than hidden: method **safety** is
reliability, method **spelling** is not, and both are in one table that one story should edit.

**The eight decisions:**

1. **`PATCH` returns `200` with the updated resource.** The status table currently says both —
   `200` for "GET, PUT, PATCH success with a response body" and `204` for "DELETE success, **or
   updates that return no body**" — and nothing picks. A partial update's result is not
   computable by the client (server defaults, derived fields, `updated_at`), so returning it
   saves a follow-up GET. `204` narrows to DELETE and to an endpoint that **declares** an empty
   response.
2. **`PATCH` is idempotent, and the hedge goes.** _"No (by convention, treat as Yes)"_ is not a
   rule anyone can apply. As this project writes PATCH — field replacement, never a relative
   delta or a list `add` — it **is** idempotent; state that, and ban the operation shapes that
   would break it. A hedge becomes a decidable rule plus a named prohibition.
3. **`405` and `Allow` get a stated rule, and the non-Ninja surface gets its first one.** Ninja
   dispatches and answers `405` itself; **plain Django views are a second, undocumented
   mechanism** — `@require_POST` at `code/docs/api-design/WEBHOOKS.md:163` and `@require_safe` at
   `apps/health/views.py:44,59`, described only operationally in `how-to/docs/HEALTH-PROBES.md`.
   Rule: a plain view declares its method set with `require_http_methods`/`require_safe` and lets
   Django's `HttpResponseNotAllowed` supply `Allow`. The health views are the worked example.
4. **`HEAD` and `OPTIONS` are declared inherited, never hand-written.** Both return zero hits
   across `code/docs/` and `how-to/docs/`. Django serves HEAD for any GET view and answers
   OPTIONS on `View`; the rule is that neither is implemented by hand, and a custom OPTIONS
   response is an ADR. Deferred-with-a-trigger, the house form — not new machinery.
5. **`202 Accepted` joins the status table**, paired with `TASK-AUTHORING.md`'s enqueue boundary:
   an endpoint that enqueues returns `202` and a way to check progress, never `200` with a
   fabricated result. This is the row that ties the method contract to this map's own subject,
   and it is absent from the entire repository today.
6. **`CORS_ALLOW_METHODS` becomes an explicit allowlist**, on the shape the
   `CORS_ALLOWED_ORIGINS` non-negotiable already uses. It appears **nowhere** in the tree, so
   django-cors-headers' permissive default applies silently while its sibling setting is mandated
   in nine places. One rule, applied to the other half of the same header family.
7. **`NINJA-CONVENTIONS.md:136` and `:162` fold into a citation.** Both restate the
   URL-noun/method-verb rule with no cross-reference to the owner — the fork
   `doctrine-drift.sh` exists to catch, in the guide most likely to be read instead of it.
8. **The gate is one `doctrine-drift.sh` claims row**, anchored on a verb plus an `/api/` path.
   Prototyped against the script's own corpus during the pass: it fires on the real restatements
   in `project-management/workflows/13-api-design/STEPS.md` with the owner correctly **inside**,
   needing no fence-rule change and no `SCAN_DIRS` change. Adding the row is the whole cost —
   and it is what stops decision 7 recurring.

**What this node does not touch.** The page-surface status contracts are `MAP-ABSENCE` S-03's
(204 no-op, non-form 4xx, the form-200 re-render and its sentence reconciling
`REST-CONVENTIONS.md:102`); the health and limiter statuses are `MAP-CAP-POSTURE`'s; the
`Idempotency-Key` contract is this map's own S-03. Named so none is re-owned here.

**Three defects found in the same pass were fixed as corrections, not decisions**, and are
recorded here so the node is not re-opened for them: the `per_page` parameter documented at three
sites is a parameter of no Ninja paginator and Ninja ships no cursor paginator at all;
`code/workflows/04-api-design/CONTEXT.md` filed the owner under _Related reading_ while three
other index tables call it the owner; and `doctrine-drift.sh`'s `api-success-data-wrap` claim was
anchored with a bare `^` against a corpus whose lines begin `path:line:`, so it matched nothing
while the run reported three claims guarding — a `GATE-REPORTING.md` breach, masked because a
sibling claim shares its clause name.

---

## Slices

The buildable slices this feature cuts into — **the base the stories are written from**.

| Slice | Story   | Title                                                                | Nodes                       | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Flags                                                                                   |
| ----- | ------- | -------------------------------------------------------------------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| S-01  | `US001` | The owning guide, and every pointer repaired to reach it             | `N-006` · `N-007`           | Family exists with pair + index rows; ladder and retry bullets migrated; residue + pointer in place; three pointers repoint; docs gates pass                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | QA: manual — docs-length, docs-pairing, doc-references                                  |
| S-02  | `US###` | Retry doctrine: ownership, `Retry-After`, budgets, breaker, timeouts | `N-008`–`N-012`             | Retry guide states the single-owner rule (SDKs clamped, delegation via register row), the clamped `Retry-After` rule, the Celery-default budget table with derived-age column and webhook override, and the breaker deferral with its trigger; timeout register exists — every outbound socket, five columns, 5 s/30 s defaults; the three budget contradictions gone                                                                                                                                                                                                                                                                                               | Security: outbound timeouts · QA: manual                                                |
| S-03  | `US###` | Idempotency doctrine: keys, stale writes, DB aborts, double-submit   | `N-013`–`N-016` · `N-024`   | Idempotency guide states the key contract (replay semantics, Postgres store, retention), the declared-stance and ordering rules, DB-abort classification with the deferred replay helper, and the per-endpoint opt-in enforcement shape (`throttle=` precedent); `CLIENT-PATTERNS.md` carries the declarative double-submit rule — `hx-disabled-elt`/`hx-sync`, UX suppression never the guarantee; the guide states that the safe-and-idempotent method set is wider than `REST-CONVENTIONS.md`'s five-row method table — RFC 10008 registers QUERY as both — so the opt-in test reads an operation's effects and never its verb (`research/HTTP-QUERY-METHOD.md`) | API: `Idempotency-Key` contract · Security: replay · QA: manual                         |
| S-04  | `US###` | The example-repair sweep across the five contradicting guides        | `N-017` · `N-018` · `N-021` | The four bad examples repaired in the declarative `autoretry_for` shape; the job-classification table's prescriptive columns reduced to pointer; `TOPOLOGY.md:85` voice repaired with the `CACHE_URL` trigger stated; no retry-everything handler remains                                                                                                                                                                                                                                                                                                                                                                                                           | QA: manual                                                                              |
| S-05  | `US###` | The gate, its CI job and its lefthook registration                   | `N-019` · `N-020`           | Two audits — `outbound-timeouts.sh` and `retry-discipline.sh` (dict-discipline model, heuristics fail red with dated `RETRY-OK:` markers, self-arming absence probes) — plus the `doctrine-drift.sh` claims-row; registered in CI and lefthook; every unchecked rule printed per `GATE-REPORTING.md`                                                                                                                                                                                                                                                                                                                                                                | QA: unit — gate self-test, fixture pair                                                 |
| S-06  | `US###` | The live-code fixes the doctrine already required                    | `N-022` · `N-023`           | Health TTLs jittered; Valkey socket timeouts set so a hang degrades to a miss; the ClickUp `urlopen` timeout set                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Backend: Yes · Security: cache timeouts · QA: unit, integration — health probe, timeout |

| S-07 | `US###` | The method contract completed in its owner | `N-025` (1–5, 7) | `PATCH` returns **200** with the updated resource and `204` narrows to DELETE and to an endpoint declaring an empty response — the `:86`/`:88` collision gone; `PATCH` stated **idempotent** with the hedge removed and the breaking operation shapes (relative deltas, list `add`) named as prohibited; the `405`/`Allow` rule stated for plain Django views (`require_http_methods`/`require_safe`, Django supplying `Allow`) with `apps/health/views.py` as the worked example; `HEAD` and `OPTIONS` declared inherited and never hand-written, a custom OPTIONS response deferred to an ADR; `202 Accepted` added to the status table, paired with `TASK-AUTHORING.md`'s enqueue boundary; `NINJA-CONVENTIONS.md:136` and `:162` reduced to a citation of the owner; the guide still under the 270 ratchet at close | API: the method contract · QA: manual — docs-length, doctrine-drift, doc-references |
| S-08 | `US###` | The method gate, and the CORS half nobody wrote | `N-025` (6, 8) | `CORS_ALLOW_METHODS` set as an explicit allowlist on the `CORS_ALLOWED_ORIGINS` shape, never a wildcard, in the same settings module and with the same non-negotiable wording; one `doctrine-drift.sh` claims row anchored on a verb plus an `/api/` path, landing **green** with the owner inside and the known restatements outside; the row's fixture pair added so `--self-test` proves it, per the per-claim assertion that script now carries | Security: CORS methods · QA: unit — gate self-test, fixture pair |

**Backfilled 01/09/2026.** Every open node now belongs to exactly one slice — two placement
calls made here: `N-017` (a doc contradiction) to the repair sweep S-04, and `N-018` (a possible
`CACHE_URL` code change) to S-06. S-02–S-06 acceptance is low-resolution until their nodes
resolve; each story sharpens its cell, never loosens it.

**S-07 and S-08 cut 01/09/2026 from `N-025`.** They are ordered behind S-03, not beside it:
both S-03 and S-07 edit the same method table in `REST-CONVENTIONS.md`, and two stories editing
one table is the merge this map can avoid by sequencing. **S-08 follows S-07** — its claims row
pins the owner's wording, so the owner has to be right before the gate freezes it. S-08's CORS
leg depends on nothing and could ship first if the settings change is wanted sooner.

**The `Story` column is back-filled by `02-story-creation`.** No number is reserved here.

**S-01 gates S-02 and S-03**, because both write into whatever `N-006` names as the owner. S-05
gates on the rules existing; S-06's jitter leg does not gate on anything and could ship first.

---

## Frontier

_Empty since 01/09/2026 — the route is fully charted._

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

**Next: `02-story-creation` cuts the six slice rows into stories.**

---

## Fog of war

In scope, but not yet sharp enough to state as a decision.

_Empty since 01/09/2026 — every parked item was retired by a resolved node or graduated into one (`N-024`)._

---

## Out of scope

| Ruled out                                                    | Why                                                                                                                                                                                                                         |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Wiring the Celery surface itself                             | Q4. This epic writes doctrine; the first feature that needs a task builds the surface, per `TASK-AUTHORING.md` → _Deferred, with a trigger_                                                                                 |
| Per-provider numeric SLOs                                    | Q4. A concrete timeout for a named provider belongs to the story that integrates it; this map decides that the register exists, not what is in its rows                                                                     |
| The deploy-repo half — broker/cache provisioning, edge retry | Q4. `BUILD-OPERATE-SEAM.md` puts both in `<%DEPLOY_REPO%>`. `N-018` states the app-side requirement and stops there                                                                                                         |
| The mobile and Rust surfaces                                 | Q1. Rust has no network client; mobile has a status classifier and no client. `MOBILE-CODING-PRINCIPLES.md:143` promises a retry affordance with no policy behind it — **it reopens the day a mobile project is generated** |
| Cloudinary as the default storage backend                    | Q3. A storage-routing defect sitting next to this work, not a reliability claim. Needs its own `GAPS.md` row, written by whoever owns the register                                                                          |
| Rewriting `TASK-AUTHORING.md`'s enqueue-boundary section     | It is correct and is the audit's strongest finding. `N-006` may move it; nothing here reopens it                                                                                                                            |

---

## Session log

| Date       | Node settled                         | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Frontier redrawn |
| ---------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 27/08/2026 | `N-001`–`N-005` (research, charting) | Five facts established; three of them change what `N-008` can say                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | [x]              |
| 01/09/2026 | `N-006` + `N-007` (grilling batch)   | New owner `code/docs/reliability/`; section → residue + pointer                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | [x]              |
| 01/09/2026 | `N-008` + `N-012` (grilling batch)   | Single-owner retry rule, SDKs clamped; timeout register, all sockets                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | [x]              |
| 01/09/2026 | `N-009`–`N-011` (grilling batch)     | Clamped `Retry-After`; Celery-default budgets, derived age; breaker deferred                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | [x]              |
| 01/09/2026 | `N-013`–`N-015` (grilling batch)     | Replay-semantics key contract; declared concurrency stance; aborts classified                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | [x]              |
| 01/09/2026 | `N-016` + `N-024` (grilling batch)   | Declarative double-submit suppression; per-endpoint opt-in enforcement                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [x]              |
| 01/09/2026 | `N-019` (tracer, 5-agent workflow)   | Signal inventory: 5 mechanical, 7 heuristic, 7 unchecked, 4 absent; two-script gate shape                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 01/09/2026 | `N-020` (grilling)                   | Two audits, dict-discipline model; heuristics red + `RETRY-OK:`; doctrine-drift row                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 01/09/2026 | `N-017` + `N-018` (grilling batch)   | One queue wins, table reduced; DB 0/1 was a voice defect — no code change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 01/09/2026 | `N-021`–`N-023` (build, by spec)     | Deliverable + acceptance on S-04/S-06 rows; frontier and fog both empty                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | [x]              |
| 01/09/2026 | `N-025` (grilling)                   | **The method contract's completeness.** `PATCH` returns 200 and the idempotency hedge goes; `405`/`Allow` stated for the plain-Django surface that had no rule; `HEAD`/`OPTIONS` declared inherited; `202` added; the `NINJA-CONVENTIONS` restatements folded to a citation; `CORS_ALLOW_METHODS` made an explicit allowlist; one `doctrine-drift.sh` claims row, prototyped green. **S-07 and S-08 cut**, both ordered behind S-03 because they edit one table. Three defects fixed as corrections in the same pass — the `per_page` sites, the owner's demotion in `04-api-design/CONTEXT.md`, and the dead `api-success-data-wrap` regex | [x]              |
| 01/09/2026 | — (no node settled)                  | **S-03 acceptance gains one clause from outside evidence.** `research/HTTP-QUERY-METHOD.md` establishes that RFC 10008 (Proposed Standard, 06/2026) registers QUERY as safe **and** idempotent, so `REST-CONVENTIONS.md`'s five-row method table is narrower than the standard: the guide states the wider set and the opt-in test reads an operation's effects, never its verb. **No node reopened** — the research names no surface this project serves, and browsers carry QUERY only as an unrecognised pass-through method (no caching, always preflighted)                                                                            | [ ]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — last (`N-008`) settled 01/09/2026
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted
- [x] Index row in `CONTEXT.md` — **deliberately absent**; see _Notes_

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
