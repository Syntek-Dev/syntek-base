# Threat Model Review — US005 Exactly one layer decides to retry

| Field           | Value                                                                                                      |
| --------------- | ---------------------------------------------------------------------------------------------------------- |
| **Story**       | US005 — Exactly one layer decides to retry, and every budget says how long it may take                     |
| **Date**        | 12/11/2026                                                                                                 |
| **Verified by** | Claude Code — `security` skill, Opus, `22-implementation-documentation` Step 3                             |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` (TM-06 corrected in place 12/11/2026)         |
| **Outcome**     | PASS with deferred items — every planned threat mitigated **in doctrine**; nothing enforces it in code yet |

---

## 1. Scope

**What shipped is prose doctrine, exactly as the plan's Section 1 said it would be.** No Python,
template, model, endpoint or log line changed: `git diff --stat -- code/src/django` on 12/11/2026
shows one file, `code/src/django/apps/core/services/CLAUDE.md`, a two-line repoint of the
circuit-breaker owner. Each `Mitigated` below therefore means **the rule is stated in the shipped
text**, not that a control runs. That is the only kind of mitigation a docs-only story can ship,
and every row says so rather than leaving it implied.

**One surface changed from the plan.** The plan placed the budget table in "the retry guide".
On 12/11/2026 Sam split the budget half into `code/docs/reliability/BUDGETS.md` (story plan,
_Key Decisions_, row "Where the budget material lives"). The threats are unchanged; their evidence
now sits across two files.

| File                                               | Purpose                                                                                                                                           |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/reliability/RETRIES.md`                 | Owner rule, SDK clamp, delegation, served surfaces, idempotency precondition, `Retry-After`, logs                                                 |
| `code/docs/reliability/BUDGETS.md`                 | New 12/11/2026. Attempt definition, budget table, worst case, redelivery limit, persisted schedule                                                |
| `code/docs/RELIABILITY.md`                         | Family hub; the circuit-breaker deferral with both triggers                                                                                       |
| `code/docs/reliability/IDEMPOTENCY.md`             | Cross-references only (adds `BUDGETS.md`); the proof ladder TM-04 routes to was already here                                                      |
| `code/docs/TASK-AUTHORING.md`                      | `visibility_timeout` redelivery, the `Exhausted, parked` class, adapter classification                                                            |
| `code/docs/api-design/WEBHOOKS.md`                 | Delivery repointed to the override row; re-signing; attempt log; inbound replay window unchanged                                                  |
| `code/docs/mcp-server/TOOL-DESIGN.md`              | TM-08's inverse statement repaired                                                                                                                |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` | Breaker mandate became a deferral pointer; a route to the retry guide above the _Retry_ column                                                    |
| `code/docs/NEGATIVE-SPACE.md`                      | Environment-error row reports one attempt; breaker owner repointed                                                                                |
| `code/docs/logging/OBSERVABILITY.md`               | `include_local_variables=False` in the Sentry sample                                                                                              |
| `project-management/docs/gdpr/COMPLIANCE.md`       | Retention example: no automatic retry, identifiers-only failure raised `from None`                                                                |
| `code/docs/performance/API-AND-MONITORING.md`      | **Not edited by this branch.** Its `max_retries=3` sample went in US001 (`DEFERRED.md` row F-010); re-read 12/11/2026, lines 46-48 now route only |

**The present-state measurement was re-taken on 12/11/2026**, and is unchanged from 05/09/2026:
`code/src/django/` contains no `self.retry`, `autoretry_for`, `max_retries`, `retry_backoff`,
`boto3`, `botocore`, `sentry_sdk`, `RetryMiddleware`, `include_local_variables`,
`visibility_timeout` or `task_publish_retry`. `code/src/django/config/__init__.py` states Celery is
declared but unwired, and no `shared_task` exists. **Nothing outbound retries in this tree today.**
Every `INFO` below is a fact about that tree, and expires with it.

## 2. Trust boundaries — confirmed

| ID  | Boundary                                                  | Change since plan                                                                                                                                                                                                                                      |
| --- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| TB1 | Retry owner to third-party provider                       | Unchanged                                                                                                                                                                                                                                              |
| TB2 | Provider or inbound caller to retry owner (`Retry-After`) | Unchanged                                                                                                                                                                                                                                              |
| TB3 | The written rule to the code expected to obey it          | **Altered.** The plan named the ADR as half of the rule. Under the 12/11/2026 shipped-reference rule, `RETRIES.md` no longer cites the ADR; the rejected options are summarised in place (`RETRIES.md:28-30`). The shipped guide alone is now the rule |
| TB4 | Retry owner to log and error-tracking sinks               | **Widened.** The build found two more crossings: the final `ERROR` line on exhaustion and the tracker's captured frame locals (TM-N1, TM-N2)                                                                                                           |
| TB5 | Served surface to its caller                              | Unchanged                                                                                                                                                                                                                                              |
| TB6 | **New.** Retry owner to the broker that holds its wait    | The Redis/Valkey transport redelivers an unacknowledged message once `visibility_timeout` lapses, so a long countdown is handed to a layer that can repeat it (TM-N3, TM-N4)                                                                           |

## 3. STRIDE threat re-assessment

`Severity` is present state, as in the plan. Every `Mitigated` cites the shipped doctrine and means
**stated, not enforced** — Section 5 carries the enforcement gap.

| ID    | STRIDE | OWASP      | NIST CSF   | Trust Boundary | Threat description                                                     | Severity | Status    | Mitigation (as shipped)                                                                                                                                                                                                                                                                                                                     |
| ----- | ------ | ---------- | ---------- | -------------- | ---------------------------------------------------------------------- | -------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | D      | `A10:2025` | `PR.IR-04` | TB1            | Stacked retries multiply against a failing provider                    | INFO     | Mitigated | `RETRIES.md:21-26` one owner, layers beneath one attempt; `:34-47` clamp `total_max_attempts: 1` and the `max_attempts` trap; `:56-59` every outbound client (broker publish, drivers, tracker transport included) sets its attempt count; `BUDGETS.md:66-70` worst-case formula stating the one-attempt assumption                         |
| TM-02 | T      | `A02:2025` | `PR.PS-01` | TB3            | An unconfigured client silently inherits the vendor default; no gate   | LOW      | Residual  | Rule stated in checkable form at `RETRIES.md:56-59`. **No gate:** `retry-discipline.sh` (slice `S-05`) does not exist and `doctrine-drift.sh` reads fenced code only. The `DEFERRED.md` entry is assessment constraint 12, owned by this workflow's findings phase — Section 5                                                              |
| TM-03 | D      | `A10:2025` | `PR.IR-04` | TB2            | Untrusted `Retry-After` parks a worker                                 | INFO     | Mitigated | `RETRIES.md:133-153` — `W = max(backoff, Retry-After)` checked against `C` and `A`, oversized parks, never shortened; jitter only lengthens (`:148-153`); `:157-159` `retry_backoff_max` does not bound `Task.retry(countdown=...)`; worked example `:166-183` re-checks before scheduling. Cap now also below `visibility_timeout` (TM-N3) |
| TM-04 | T      | `A08:2025` | `PR.DS-01` | TB1            | A repeat of a non-idempotent operation executes twice                  | INFO     | Mitigated | `RETRIES.md:95-101` — only an operation with a rung of `IDEMPOTENCY.md` Section _Proving it — the ladder_ repeats; every surface, HTTP `POST` and re-run command included. Deviation: the plan routed the proof to `TASK-AUTHORING.md` "until `S-03`"; US001 had already moved the ladder to `IDEMPOTENCY.md`                               |
| TM-05 | I      | `A09:2025` | `PR.DS-01` | TB4            | Attempt logs repeat exception text with URLs and presigned credentials | INFO     | Mitigated | `RETRIES.md:192-199` records attempt number, elapsed budget, error class; never message, URL or body. `:201-207` keeps `celery.app.trace`'s interpolating line out and says the property is **unenforced, not satisfied** until wiring. `WEBHOOKS.md:98-100` applies it to deliveries                                                       |
| TM-06 | S      | `A08:2025` | `PR.AA-05` | TB1            | A re-signed repeat widens the window a captured delivery replays in    | INFO     | Mitigated | As corrected 12/11/2026. `BUDGETS.md:133-138` and `WEBHOOKS.md:93-95`: each attempt re-signed (fresh `t=`) over the same body, same event `id`; consumer de-duplication on the `id` is the replay defence; receiver's +/-300 s window unchanged (`WEBHOOKS.md:117-120`). Residual: one window per attempt, five at most                     |
| TM-07 | R      | `A09:2025` | `DE.AE-03` | TB4            | A repeat cannot be reconstructed after an outage                       | INFO     | Mitigated | `RETRIES.md:192-199` attempt numbering and elapsed age against `T`; the first attempt's time travels with the work (task argument or header). Emission from a `task_retry` handler, `:201-204`                                                                                                                                              |
| TM-08 | T      | `A06:2025` | `GV.PO-01` | TB3, TB5       | `TOOL-DESIGN.md:139-141` stated the inverse at the MCP boundary        | INFO     | Mitigated | Repaired, not assigned: `TOOL-DESIGN.md:139-146` — one attempt, `RetryMiddleware` deliberately unwired, routed to `RETRIES.md` Section _Served surfaces never retry inbound work_. The map records it repaired with no slice (`MAP-RETRY-AND-IDEMPOTENCY.md` line 6 and the 11/11/2026 log row)                                             |
| TM-09 | D      | `A06:2025` | `PR.IR-04` | TB5            | "Served surfaces never retry" moves the storm onto absent rate limits  | INFO     | Mitigated | `RETRIES.md:80-93` — caller obliged to bound its repeat; inbound rate limiting named a dependency, specified in `security/INPUT-AND-API.md` _Throttling_ and wired nowhere. The dependency itself stays open (Section 5)                                                                                                                    |
| TM-10 | D      | `A06:2025` | `ID.AM-08` | TB1            | A delegated transport budget is unobservable                           | INFO     | Mitigated | `RETRIES.md:72-76` — a delegating row records attempt count and interval as numbers, never "the vendor default"; `BUDGETS.md:72-74` substitutes them into the formula. The register itself is slice `S-09`'s and unwritten (`RETRIES.md:68-70`)                                                                                             |
| TM-11 | D      | `A06:2025` | `RS.MA-01` | TB1            | Per-operation budgets do not bound the fleet; breaker deferred         | INFO     | Mitigated | `RELIABILITY.md:50-60` — deferral with both triggers, naming `WEBHOOKS.md` _Delivery_ disable-after-N as the partial mechanism. `SERVICE-AND-MIDDLEWARE.md:273-275` and `NEGATIVE-SPACE.md:232-234` no longer mandate a breaker                                                                                                             |
| TM-12 | T      | `A08:2025` | `PR.DS-01` | TB1            | Stale intent replayed at the end of a long budget                      | INFO     | Mitigated | `RETRIES.md:209-216` — timestamp check or per-message `expires`; **mandatory** when the payload can be superseded before the row's worst-case age. `BUDGETS.md:82-87` sets `expires = T` per enqueue on the declarative path; `RETRIES.md:137-139` bounds a late counted-down start                                                         |

**Elevation of privilege — still not applicable.** Nothing in the shipped text changes the actor
of a repeat: the persisted schedule's sweep (`BUDGETS.md:96-121`) enqueues the same operation for
the same principal. Re-checked rather than carried over.

## 4. New threats identified during implementation

Each was raised by the build's QA and review passes and closed in doctrine on 12/11/2026 (story
plan, _Settled 12/11/2026 — two QA findings_). All are `INFO` today for the same reason as the
plan's rows: nothing is wired. **None is CRITICAL or HIGH; nothing is escalated to
`../../VULNERABILITIES/IMPLEMENTATION/`.**

| ID    | STRIDE | OWASP      | NIST CSF   | TB  | Threat                                                                                                                                | Severity | Status    | Mitigation (as shipped)                                                                                                                                                                                                                                                           |
| ----- | ------ | ---------- | ---------- | --- | ------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-N1 | I      | `A09:2025` | `PR.DS-01` | TB4 | Exhaustion re-raises the client's exception, which `celery.app.trace` logs at `ERROR` and the tracker captures, URL and body included | INFO     | Mitigated | `RETRIES.md:228-232` — the exhausting exception carries identifiers only, raised `from None`. `TASK-AUTHORING.md:182-188`; the GDPR example applies it (`COMPLIANCE.md:52-58`, `:70-77`)                                                                                          |
| TM-N2 | I      | `A09:2025` | `PR.DS-01` | TB4 | Sentry's default `include_local_variables` captures the translating frame's `url`, `body` or `response` locals                        | INFO     | Mitigated | `RETRIES.md:234-241`; `OBSERVABILITY.md:60` sets `include_local_variables=False`, `:64-67` gives the reason. Terminal raise follows the `except` block so no `__context__` carries the client's text                                                                              |
| TM-N3 | T, D   | `A08:2025` | `PR.IR-04` | TB6 | A countdown longer than `visibility_timeout` is redelivered each time it lapses: a hidden second retrying layer, and a duplicate      | INFO     | Mitigated | `BUDGETS.md:89-94` — every counted-down `C` and manual wait below the redelivery bound; `TASK-AUTHORING.md:144-149` states the bound (default 3600 s). Header-aware row `C` = 600 s; the webhook row (28800 s) moved to a persisted schedule (Sam, 12/11/2026)                    |
| TM-N4 | T      | `A08:2025` | `PR.DS-01` | TB6 | The persisted schedule's sweep, or a redelivered attempt message, sends one delivery twice                                            | INFO     | Mitigated | `BUDGETS.md:104-121` — the sweep claims by conditional transition judged by rows changed (or `skip_locked`); the lease is `t + q`; each attempt makes its own conditional transition on `started_attempt`, so a duplicate is a no-op; one attempt per enqueue, no `autoretry_for` |
| TM-N5 | D      | `A10:2025` | `PR.IR-04` | TB2 | A hostile `Retry-After` larger than `C` forces early exhaustion                                                                       | INFO     | Accepted  | By design: `RETRIES.md:141-143` parks rather than waits. A remote able to send that header can refuse the call anyway, so parking costs nothing it could not already take. Recorded so it is not rediscovered as a bug                                                            |

**Checked and not found:** a jitter draw that lowers `W` (`RETRIES.md:179` adds within
`bound - wait`); a cap reachable above `visibility_timeout` on a counted-down row (`BUDGETS.md:55`
`C` = 600 s); the worked example retrying past its attempts (`RETRIES.md:177`, `max_retries=2` is
three attempts per `BUDGETS.md:26-28`); a retry-everything handler surviving in the GDPR example
(`COMPLIANCE.md:41-58` catches `DatabaseError` only and does not retry). The three worst-case cells
were recomputed by hand: `3 s + 3t`; `2 x 600 + 3 x 30 = 1290 s` within 1800 s; `54000 + 240 + 300 + 50 = 54590 s`.

**One observation, not a threat, routed to findings.** `RETRIES.md:137-139` schedules a counted-down
attempt with `expires = first_attempt_at + T - t`; the worked example (`:166-183`) shows the task
body, not its enqueue, so the `expires` is invisible in it. Whether `Task.retry` carries the first
message's `expires` into the retry message was **not verified** here — context7's Celery 5.6.3
documentation does not say, and the source was not read. If it does not, a late start can run
past `T` (TM-12's edge). `INFO`; for `src/20-FINDINGS/`, not a vulnerability.

## 5. Residual & deferred items

| Item                                                                        | Threat IDs                  | Severity | Tracked in / when                                                                                                                                                                        |
| --------------------------------------------------------------------------- | --------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The rule is unenforced: no `retry-discipline.sh`                            | TM-02 (all rows rest on it) | LOW      | Slice `S-05` on `../../../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`. The `DEFERRED.md` row is written by this workflow's findings phase — **not present at the time of this review** |
| The outbound timeout register the delegation hatch names                    | TM-10                       | INFO     | Slice `S-09`; `RETRIES.md:68-70` states the forward reference. `doc-references.sh` counts it among its 29 named `[dangling path]` survivors (orchestrator, 12/11/2026)                   |
| Inbound rate limiting                                                       | TM-09                       | INFO     | No story yet; named a dependency at `RETRIES.md:91-93`                                                                                                                                   |
| Circuit breaker                                                             | TM-11                       | INFO     | `RELIABILITY.md:50-52`, both triggers                                                                                                                                                    |
| `SERVICE-AND-MIDDLEWARE.md` _Retry_ column still prescribes per-job retries | TM-08 (coherence)           | INFO     | Slice `S-04` (`MAP-RETRY-AND-IDEMPOTENCY.md` S-04 row); acknowledged at `SERVICE-AND-MIDDLEWARE.md:264-265` and `RELIABILITY.md:20-22`                                                   |
| Attempt-log handler and `celery.app.trace` filter                           | TM-05, TM-07, TM-N1         | INFO     | The change that wires the task surface (`RETRIES.md:204-207`)                                                                                                                            |
| `RemoteThrottled` and `RetriesExhausted` are declared, not built            | TM-03, TM-N1                | INFO     | `RETRIES.md:162-164`; `TASK-AUTHORING.md:174`. `apps/core/services/errors.py` holds neither (checked 12/11/2026)                                                                         |

### Design-state promotion — restated, unchanged

The promotion table in the plan's Section 3a stands as written. **Three rows reach `HIGH` in the
design state — TM-01, TM-02 and TM-04** — and nothing in the shipped text lowers that, because
the shipped text is a rule and the trigger is the first code that can break it.

| ID    | Present | Design state | Trigger                                                                               | Did this story meet it? |
| ----- | ------- | ------------ | ------------------------------------------------------------------------------------- | ----------------------- |
| TM-01 | INFO    | **HIGH**     | First client constructed without an explicit retry clamp                              | No — no client wired    |
| TM-02 | LOW     | **HIGH**     | Any client wired before `retry-discipline.sh` is in CI and lefthook (MEDIUM if after) | No                      |
| TM-04 | INFO    | **HIGH**     | First retried operation with an external side effect not provably idempotent          | No                      |
| TM-08 | INFO    | MEDIUM       | Immediate on ship if `TOOL-DESIGN.md:139-141` were left standing                      | **Retired** — repaired  |
| TM-N3 | INFO    | MEDIUM       | First counted-down retry wired with a wait at or above `visibility_timeout`           | No — new 12/11/2026     |
| TM-N4 | INFO    | MEDIUM       | First persisted-schedule sweep wired                                                  | No — new 12/11/2026     |

The other plan rows (TM-03, TM-05, TM-06, TM-07, TM-09 to TM-12) keep their Section 3a design states
and triggers unchanged. TM-N1 and TM-N2 promote on TM-05's trigger: the first attempt-level log
line or `sentry_sdk.init()`.

## 6. Sign-off

| Reviewer                             | Role                         | Date       |
| ------------------------------------ | ---------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Security review (author)     | 12/11/2026 |
| <%DEVELOPER_NAME%>                   | Developer — countersignature | _pending_  |

**Independent review is outstanding.** The `security` skill's sequence wants a separate peer
audit dispatch; this record was written by one agent and that agent did not review itself. Per
`.ai/INSTRUCTIONS.md`, the gate is reported open rather than satisfied by self-review.

**Overall verdict:** all twelve planned threats have a final status — eleven mitigated in shipped
doctrine, TM-02 a tracked residual — and five new ones found and closed in doctrine; no
CRITICAL/HIGH in the present state, three design-state HIGHs carried forward unchanged, and the
whole set unenforced until slice `S-05` ships.

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` — the model re-assessed here
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the posture record consuming this review
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the post-build audit
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated; Section 4 says what was checked
- `../../../02-STORIES/US005.md` — the story reviewed
- `../../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — _Key Decisions_ and the 11/11 and 12/11/2026 sections
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `code/docs/GATE-REPORTING.md` — why "stated" and "enforced" are kept apart throughout
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
