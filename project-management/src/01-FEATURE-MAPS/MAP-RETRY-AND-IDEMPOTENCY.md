# MAP-RETRY-AND-IDEMPOTENCY — a repeated call is safe, and exactly one layer decides to repeat it

**Charted**: 27/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `7a82095` (`v7.4.1`) · **Research resolved at**: `7a82095` (27/08/2026)
**Status**: Resolving
**Frontier open**: 18 · **Blocking open**: 3 · **Resolved**: 5

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

All five are **research** nodes, fired during charting because they need no human. Each one changes
what a later grilling node can honestly decide, which is why they were taken first.

| Node  | Decision                                                    | Type     | Settled    | Became                                    |
| ----- | ----------------------------------------------------------- | -------- | ---------- | ----------------------------------------- |
| N-001 | Celery's real retry primitives at 5.6                       | research | 27/08/2026 | finding below → input to `N-008`, `N-010` |
| N-002 | botocore's default retry and timeout posture                | research | 27/08/2026 | finding below → input to `N-008`, `N-012` |
| N-003 | Whether FastMCP's `RetryMiddleware` exists and what it does | research | 27/08/2026 | finding below → input to `N-008`          |
| N-004 | Whether a Valkey hang can degrade to a miss                 | research | 27/08/2026 | finding below → input to `N-012`, `N-023` |
| N-005 | What Django does with a deadlock or serialization failure   | research | 27/08/2026 | finding below → input to `N-015`          |

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

---

## Slices

The buildable slices this feature cuts into — **the base the stories are written from**.

| Slice | Story   | Title                                                                | Nodes | Acceptance | Flags                                                                                   |
| ----- | ------- | -------------------------------------------------------------------- | ----- | ---------- | --------------------------------------------------------------------------------------- |
| S-01  | `US###` | The owning guide, and every pointer repaired to reach it             | TBD   | TBD        | QA: manual — docs-length, docs-pairing, doc-references                                  |
| S-02  | `US###` | Retry doctrine: ownership, `Retry-After`, budgets, breaker, timeouts | TBD   | TBD        | Security: outbound timeouts · QA: manual                                                |
| S-03  | `US###` | Idempotency doctrine: keys, stale writes, DB aborts, double-submit   | TBD   | TBD        | API: `Idempotency-Key` contract · Security: replay · QA: manual                         |
| S-04  | `US###` | The example-repair sweep across the five contradicting guides        | TBD   | TBD        | QA: manual                                                                              |
| S-05  | `US###` | The gate, its CI job and its lefthook registration                   | TBD   | TBD        | QA: unit — gate self-test, fixture pair                                                 |
| S-06  | `US###` | The live-code fixes the doctrine already required                    | TBD   | TBD        | Backend: Yes · Security: cache timeouts · QA: unit, integration — health probe, timeout |

**The `Nodes` and `Acceptance` columns were added 31/08/2026** with the `task` -> `build`
type change. Cells reading `TBD` are **not empty, they are unbackfilled** — this map's next
RESOLVE sitting fills them, and until it does the checklist item _every open node belongs to a
slice_ is unverified here.

**The `Story` column is back-filled by `02-story-creation`.** No number is reserved here.

**S-01 gates S-02 and S-03**, because both write into whatever `N-006` names as the owner. S-05
gates on the rules existing; S-06's jitter leg does not gate on anything and could ship first.

---

## Frontier

Open decisions in dependency order. **Four nodes are unblocked**: `N-006`, `N-018`, `N-019`, `N-022`.

| Node  | Decision                                                                                     | Type     | Blocked by           | Blocking a story? |
| ----- | -------------------------------------------------------------------------------------------- | -------- | -------------------- | ----------------- |
| N-006 | Where cross-surface retry + idempotency doctrine lives — new owner, extend, or fix pointers  | grilling | none                 | **yes**           |
| N-007 | The fate of `API-AND-MONITORING.md` → _Background Jobs and Queues_, and the two bad pointers | grilling | `N-006`              | **yes**           |
| N-008 | The retry-ownership rule: which layer retries, and that no other may — incl. SDK defaults    | grilling | `N-006`              | **yes**           |
| N-009 | Honouring an inbound `Retry-After` — the rule for every outbound client                      | grilling | `N-008`              | no                |
| N-010 | One attempt-budget table, and how "total age" is expressed given `N-001`                     | grilling | `N-008`              | no                |
| N-011 | Circuit breaker — specify it, or delete the mandate and defer it with a trigger              | grilling | `N-006`              | no                |
| N-012 | The outbound timeout register — connect and read, per client                                 | grilling | `N-006`              | no                |
| N-013 | The `Idempotency-Key` contract: scope, retention, concurrent duplicates, replay vs `409`     | grilling | `N-006`              | no                |
| N-014 | Stale-write protection, and stating ordering separately from repeat-safety                   | grilling | `N-006`              | no                |
| N-015 | Database transaction aborts — classification, and who replays a rolled-back transaction      | grilling | `N-006`, `N-008`     | no                |
| N-016 | The HTMX POST double-submit rule `CLIENT-PATTERNS.md` has never carried                      | grilling | `N-013`              | no                |
| N-017 | Queue count — `SERVICE-AND-MIDDLEWARE.md:255` "Dedicated queue" against "default to one"     | grilling | `N-007`              | no                |
| N-018 | Valkey DB 0 versus DB 1 — correct `TOPOLOGY.md`, or introduce `CACHE_URL` and move the cache | grilling | none                 | no                |
| N-019 | Which rules are mechanically checkable at all — a spike over the available signals           | tracer   | none                 | no                |
| N-020 | The gate's name, scope, failure mode and where it registers                                  | grilling | `N-019` + rule nodes | no                |
| N-021 | Repair the four bad examples: two `.delay()` sites, two retry-everything handlers            | build    | `N-007`, `N-008`     | no                |
| N-022 | Jitter the two health TTLs — already required by a written rule, nothing to decide           | build    | none                 | no                |
| N-023 | Valkey `SOCKET_TIMEOUT` / `SOCKET_CONNECT_TIMEOUT` and the ClickUp `urlopen` timeout         | build    | `N-012`              | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

**Suggested first batch — `N-006` + `N-007`.** Shared subject: both are one question about where
task-retry doctrine lives and what happens to the copy that contradicts it. Deciding them apart
means deciding `N-007` twice.

**The evidence each node answers to** — every reference measured at `7a82095`:

- `N-006` — three owners claimed: `PROCESS-MODEL.md:166` names `API-AND-MONITORING.md`;
  `CONTEXT.md:91` names `TASK-AUTHORING.md`; `NEGATIVE-SPACE.md:226` names a third pair.
- `N-007` — `API-AND-MONITORING.md:57` (fixed 60 s, no jitter) against `TASK-AUTHORING.md:200`;
  `:62` and `gdpr/COMPLIANCE.md:46` (`except Exception: self.retry`) against `TASK-AUTHORING.md:181`
  and `:197`; `:68` claims idempotency over a non-idempotent example at `:58`.
- `N-008` — no "must not also retry" sentence exists; the only one in the repo is about exit code 75
  (`MANAGEMENT-COMMANDS.md:104`). Stacking is live per `N-002` and `N-003`.
- `N-009` — every `Retry-After` in the tree is outbound. Zero inbound-honouring rules.
- `N-010` — three unreconciled budgets: `WEBHOOKS.md:86` (5 attempts / 24 h),
  `API-AND-MONITORING.md:57` and `gdpr/COMPLIANCE.md:27` (`max_retries=3`), `TASK-AUTHORING.md:204`
  (policy, no numbers).
- `N-011` — mandated at `SERVICE-AND-MIDDLEWARE.md:265`, claimed as owned by `NEGATIVE-SPACE.md:226`;
  `TASK-AUTHORING.md` contains the word "circuit" **zero** times.
- `N-012` — one concrete pair exists (`API-AND-MONITORING.md:33`, 5 s / 30 s). `TASK-AUTHORING.md:230`
  requires timeouts without values. `sync-clickup.sh:115` has none at all.
- `N-013` — `REST-CONVENTIONS.md:29` is the whole contract: "where possible, design `POST` endpoints
  to handle duplicate submissions gracefully".
- `N-014` — zero repo-wide hits for `If-Match`, optimistic locking, fencing, or a version column.
- `N-015` — zero repo-wide hits for serialization failure, deadlock, `40001`, or isolation level.
- `N-016` — `CLIENT-PATTERNS.md` has no repeat-safety rule for the POST views it documents.
- `N-018` — `TOPOLOGY.md:85` says DB 1; `TASK-AUTHORING.md:136` and `COMPUTE-ALLOCATION.md:106` say
  DB 0; `config/settings/base.py:139` and every Compose file say `/0`.
- `N-021` — `SERVICE-AND-MIDDLEWARE.md:44` (bare `.delay()` in an un-atomic multi-write method),
  `WEBHOOKS.md:170` (bare `.delay()`, passes the raw body), plus the two handlers under `N-007`.
- `N-022` — `BACKEND-CODING-PRINCIPLES.md:341` requires a jittered TTL;
  `apps/health/views.py:76` and `apps/health/checks.py:128` are both bare.

---

## Fog of war

In scope, but not yet sharp enough to state as a decision.

- **Whether `code/docs/` gains a `reliability/` sub-family.** If `N-006` names a new owner over 300
  lines it needs the `CONTEXT.md` + `CLAUDE.md` pair and an index row. Sharpens the moment `N-006`
  lands.
- **Middleware or decorator for idempotency keys on the Ninja surface.** Downstream of `N-013`; the
  Ninja throttling precedent at `NINJA-CONVENTIONS.md` cuts both ways.
- **Whether the transactional-outbox trigger moves.** `TASK-AUTHORING.md:308` names one condition;
  `N-013` and `N-014` may add a second, and rewriting a deferral's trigger is a decision of its own.
- **Whether `NEGATIVE-SPACE.md`'s environment-error row gains a "retried by which layer" column.**
  Depends entirely on `N-008`'s shape.
- **The at-least-once passage's fate.** `TASK-AUTHORING.md:119-171` is the best material in the tree
  and must survive whatever `N-006` decides; whether it moves, stays, or is cited from the new owner
  is not decidable until `N-006` is.

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

| Date       | Node settled                         | Outcome                                                           | Frontier redrawn |
| ---------- | ------------------------------------ | ----------------------------------------------------------------- | ---------------- |
| 27/08/2026 | `N-001`–`N-005` (research, charting) | Five facts established; three of them change what `N-008` can say | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — `N-006`, `N-007`, `N-008` open
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted
- [x] Index row in `CONTEXT.md` — **deliberately absent**; see _Notes_

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
