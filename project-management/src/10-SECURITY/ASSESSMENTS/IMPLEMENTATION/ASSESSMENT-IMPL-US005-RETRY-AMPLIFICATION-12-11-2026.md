# Security Posture Assessment (Implementation) — US005 Exactly one layer decides to retry

| Field           | Value                                                                                                                                                                                      |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**       | US005 — Exactly one layer decides to retry, and every budget says how long it may take                                                                                                     |
| **Date**        | 12/11/2026                                                                                                                                                                                 |
| **Verified by** | Claude Code — `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                                             |
| **Sprint**      | SPRINT-04 (planned as SPRINT-03; moved 07/09/2026)                                                                                                                                         |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` (Section 7 item 6 corrected 12/11/2026)                                                                                         |
| **Outcome**     | PASS with deferred items — eleven constraints closed in shipped text; constraint 12 closed 12/11/2026 by the `DEFERRED.md` _US005_ row (findings F-017); TM-02 stays Residual until `S-05` |

---

## 1. Scope

**The shipped surface is doctrine, as the baseline said it would be.** No running control was
added: the only change under `code/src/django/` is a two-line repoint in
`apps/core/services/CLAUDE.md`. Every `PASS` below therefore means **the rule is stated, at the
cited line, in a form a later gate or reviewer can hold code to** — never that a control runs.
The enforcement gap is carried as constraint 12 and in Section 6.

The baseline's one deviation to re-validate on landing — `code/docs/reliability/` did not exist —
**is cleared**: US001 shipped it in 7.9.0, and this story wrote into it.

| File                                               | What was assessed here                                                        |
| -------------------------------------------------- | ----------------------------------------------------------------------------- |
| `code/docs/reliability/RETRIES.md`                 | Constraints 1, 3, 4, 5, 8, 9, 11 and the failure-record rule                  |
| `code/docs/reliability/BUDGETS.md`                 | **Added 12/11/2026** (Sam's split). Constraints 2 and 6; the redelivery limit |
| `code/docs/RELIABILITY.md`                         | Constraint 10 — the breaker deferral                                          |
| `code/docs/mcp-server/TOOL-DESIGN.md`              | Constraint 7 — the inverse statement                                          |
| `code/docs/api-design/WEBHOOKS.md`                 | Constraints 5 and 6 on the delivery surface; inbound replay window            |
| `code/docs/TASK-AUTHORING.md`                      | The task surface's redelivery bound and terminal class                        |
| `code/docs/logging/OBSERVABILITY.md`               | Frame-locals capture off                                                      |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` | Breaker mandate withdrawn to a deferral pointer                               |
| `code/docs/NEGATIVE-SPACE.md`                      | Environment-error row reports one attempt                                     |
| `project-management/docs/gdpr/COMPLIANCE.md`       | Retention example — no automatic retry, identifiers-only failure              |

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status  | Evidence / Notes                                                                                                                                                                                                                                                                                                   |
| -------- | ------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| A01:2025 | Broken Access Control (incl. SSRF)    | N/A     | Unchanged from baseline: no endpoint, no identifier, nothing owned. `WEBHOOKS.md:84-85` keeps the SSRF check before **each** send, which the persisted schedule now makes several of                                                                                                                               |
| A02:2025 | Security Misconfiguration             | PARTIAL | Rule stated, unenforced. `RETRIES.md:56-59` every outbound client sets its attempt count; `:45-54` the `max_attempts` trap and the `AWS_MAX_ATTEMPTS` route. TM-02 open until slice `S-05`; `DEFERRED.md` entry is constraint 12. The side change in `copier.yml` closed a separate misconfiguration (audit F-001) |
| A03:2025 | Software Supply Chain Failures        | PARTIAL | No dependency moved. The vendor-default override is now named precisely (`RETRIES.md:34-37`: `legacy` 5 attempts, `standard` 3, mode set from outside the code), so a botocore or Celery upgrade that changes retry semantics is a doctrine event. Nothing yet prompts the dependency-update pass to look          |
| A04:2025 | Cryptographic Failures                | N/A     | No key or credential designed. Webhook signing is unchanged in algorithm; only _when_ a signature is computed changed (constraint 6)                                                                                                                                                                               |
| A05:2025 | Injection                             | N/A     | `Retry-After` is parsed as a duration into `RemoteThrottled.retry_after` (`RETRIES.md:162-164`), never interpolated                                                                                                                                                                                                |
| A06:2025 | Insecure Design                       | PARTIAL | TM-08 **closed** (`TOOL-DESIGN.md:139-146`). TM-09, TM-10, TM-11 closed in wording, each naming a dependency that does not yet exist: inbound rate limiting, the `S-09` register, the breaker. `SERVICE-AND-MIDDLEWARE.md:252-258` _Retry_ column still prescriptive, owned by `S-04`                              |
| A07:2025 | Authentication Failures               | N/A     | No credential, session or MFA path touched                                                                                                                                                                                                                                                                         |
| A08:2025 | Software and Data Integrity Failures  | PASS    | In doctrine. TM-04 `RETRIES.md:95-101`; TM-06 `BUDGETS.md:133-138`; TM-12 `RETRIES.md:209-216`. New in the build and closed: redelivery past `visibility_timeout` (`BUDGETS.md:89-94`) and double enqueue on the persisted schedule (`BUDGETS.md:104-121`)                                                         |
| A09:2025 | Security Logging & Alerting Failures  | PARTIAL | Content rules PASS: `RETRIES.md:192-199` attempt log; `:228-241` exhaustion `from None`, frame locals off (`OBSERVABILITY.md:60`). **Alerting unenforced**: `RETRIES.md:205-207` and `COMPLIANCE.md:115-116` both say so. No handler, filter or `sentry_sdk.init()` exists                                         |
| A10:2025 | Mishandling of Exceptional Conditions | PASS    | In doctrine. TM-01 `RETRIES.md:21-26` and `BUDGETS.md:66-70`; TM-03 `RETRIES.md:133-183`; the parked outcome is its own terminal class (`TASK-AUTHORING.md:174`, `:182-188`) so exhaustion cannot be re-caught into another retry                                                                                  |

**A08 and A10 move from Partial to PASS on a stated basis**: the baseline marked them Partial
because the controls were proposed; they are now written. They are PASS **as doctrine** and
revert to open the day a task is wired without them — the design-state HIGHs in Section 5.

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status   | Evidence                                                                                                                                                                                                                            |
| --- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS     | One owner per operation, stated at one site (`RETRIES.md:21-30`), with the rejected options summarised in place rather than cited from the ADR; the budget's home is `BUDGETS.md`. TM-08's inverse is gone                          |
| ID  | Identify | PARTIAL  | Budgets are rows of one table (`BUDGETS.md:52-56`) and every worst case recomputes from its row. `ID.AM-08` waits on the `S-09` register for delegated budgets (`RETRIES.md:68-70`)                                                 |
| PR  | Protect  | PARTIAL  | `PR.IR-04`: single owner, caps, `T`, redelivery limit. `PR.DS-01`: idempotency precondition, conditional-transition claims. **`PR.PS-01` open**: no enforcement point until `S-05`                                                  |
| DE  | Detect   | DEFERRED | `DE.AE-03`: attempt-log fields specified (`RETRIES.md:192-199`) and emission site named (`:201-204`); nothing emits. Blocked by the task surface being unwired (`code/src/django/config/__init__.py`)                               |
| RS  | Respond  | DEFERRED | `RS.MA-01`: breaker deferred with both triggers (`RELIABILITY.md:50-60`); webhook disable-after-N is the partial mechanism (`WEBHOOKS.md:96-97`)                                                                                    |
| RC  | Recover  | PASS     | Every budget terminates: a stated end (`RETRIES.md:218-221`), a park condition (`:141-143`, `BUDGETS.md:104-106`) and a total age `T` on every row that waits. The GDPR purge recovers on its next Beat run (`COMPLIANCE.md:62-68`) |

## 4. Findings

Found while reviewing the shipped text. **No CRITICAL or HIGH finding was identified;
nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.** The five new threats the
build itself raised and closed are TM-N1 to TM-N5 in the threat-model review, not repeated here.

| ID    | STRIDE | OWASP    | NIST CSF | Severity | Finding                                                                                                                                                                                                                                     | Recommendation                                                                               | Status                |
| ----- | ------ | -------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | --------------------- |
| A-001 | T      | A10:2025 | PR.DS-01 | INFO     | `RETRIES.md:137-139` requires `expires = first_attempt_at + T - t` on a counted-down attempt; the worked example (`:166-183`) shows only the task body. Whether `Task.retry` carries the first message's `expires` forward was not verified | Route to `src/20-FINDINGS/`: verify against Celery's source; show the enqueue if it does not | Open — findings phase |
| A-002 | T      | A06:2025 | GV.PO-01 | INFO     | `performance/API-AND-MONITORING.md:119` checklist reads "Background jobs are idempotent with retries and back-off", implying every job retries; the shipped GDPR purge deliberately does not                                                | Route to findings; candidate for `S-04`'s sweep                                              | Open — findings phase |

## 5. Planning-phase findings — status update

Present-state severities re-measured 12/11/2026: `code/src/django/` still has no `self.retry`,
`autoretry_for`, `max_retries`, `retry_backoff`, `boto3`, `botocore` or `sentry_sdk`, and no
`shared_task`. **Under the design state the same rows still carry three HIGHs — TM-01, TM-02 and
TM-04** (threat model Section 3a, restated unchanged in the review's Section 5). Nothing this
story shipped lowers a design-state severity; it states the rules the promoting story will be
held to.

| Plan finding | Status   | Evidence / Notes                                                                       |
| ------------ | -------- | -------------------------------------------------------------------------------------- |
| TM-02 (LOW)  | Residual | Rule at `RETRIES.md:56-59`; no gate. Constraint 12                                     |
| TM-01        | Resolved | `RETRIES.md:21-59`; `BUDGETS.md:66-70`                                                 |
| TM-03        | Resolved | `RETRIES.md:133-183`; counted-down caps below `visibility_timeout`, `BUDGETS.md:89-94` |
| TM-04        | Resolved | `RETRIES.md:95-101` to `IDEMPOTENCY.md` Section _Proving it — the ladder_              |
| TM-05        | Resolved | `RETRIES.md:192-207`; `WEBHOOKS.md:98-100`                                             |
| TM-06        | Resolved | As corrected 12/11/2026: `BUDGETS.md:133-138`; `WEBHOOKS.md:93-95`, `:117-120`         |
| TM-07        | Resolved | `RETRIES.md:192-199`                                                                   |
| TM-08        | Resolved | `TOOL-DESIGN.md:139-146` — repaired in this story, no slice needed                     |
| TM-09        | Resolved | `RETRIES.md:87-93` — the dependency itself remains unbuilt                             |
| TM-10        | Resolved | `RETRIES.md:72-76`; `BUDGETS.md:72-74`                                                 |
| TM-11        | Resolved | `RELIABILITY.md:50-60`                                                                 |
| TM-12        | Resolved | `RETRIES.md:209-216`; `BUDGETS.md:82-87`. Edge in A-001                                |

"Resolved" means the planned wording constraint is met in the shipped text, which is all the
baseline asked of this story (its Section 7: "constraints on **the doctrine's wording**").

## 6. Plan gaps closed & deferred items

The twelve Section 7 constraints, in order.

| #   | Constraint (plan Section 7)                                                                                                                                              | Status | Evidence / Blocked by                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Every client constructor sets its attempt count explicitly; one attempt unless a register row delegates (TM-01, TM-02)                                                   | Closed | `RETRIES.md:56-59`, quoted block, "every" widened to the broker publish, drivers and tracker transport; clamp form `:39-47`                                                                                                                                                                                                                                                                                                                                                                 |
| 2   | Worst-case formula states that inner-layer attempts equal one (TM-01, TM-10)                                                                                             | Closed | `BUDGETS.md:66-70`; delegated-row substitution `:72-74`                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 3   | `Retry-After`: manual owner, `max(backoff, Retry-After)`, interval and remaining-age checks, park never shorten, jitter cannot lower, `retry_backoff_max` no cap (TM-03) | Closed | `RETRIES.md:133-153`, `:155-159`, example `:166-183` (re-check at `:180-181`). Jitter direction tightened by Sam 12/11/2026 (Q5): only lengthens, on every path the project writes (`:124-129`, `:148-153`)                                                                                                                                                                                                                                                                                 |
| 4   | Idempotency precondition on every repeat; where the proof lives until `S-03` (TM-04)                                                                                     | Closed | `RETRIES.md:95-101`. Proof lives in `code/docs/reliability/IDEMPOTENCY.md` Section _Proving it — the ladder_, not `TASK-AUTHORING.md` — Section 7                                                                                                                                                                                                                                                                                                                                           |
| 5   | Attempt log records number, elapsed budget, class; never message, URL, body (TM-05, TM-07)                                                                               | Closed | `RETRIES.md:192-199`; `celery.app.trace` kept out `:201-207`; delivery surface `WEBHOOKS.md:98-100`                                                                                                                                                                                                                                                                                                                                                                                         |
| 6   | Webhook repeat re-signed with a fresh timestamp over the same body, same delivery identifier; consumer de-dup is the replay defence (TM-06, corrected 12/11/2026)        | Closed | `BUDGETS.md:133-138`; `WEBHOOKS.md:93-95`; receiver window unchanged at `WEBHOOKS.md:117-120`, `:145`, `:203`                                                                                                                                                                                                                                                                                                                                                                               |
| 7   | `TOOL-DESIGN.md:139-141` repaired or assigned (TM-08)                                                                                                                    | Closed | Repaired: `TOOL-DESIGN.md:139-146`; map records it with no slice (`MAP-RETRY-AND-IDEMPOTENCY.md` status note, line 6)                                                                                                                                                                                                                                                                                                                                                                       |
| 8   | Caller's bounding obligation; inbound rate limiting named a dependency (TM-09)                                                                                           | Closed | `RETRIES.md:87-93`                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 9   | Delegating register row records attempt count and interval as numbers (TM-10)                                                                                            | Closed | `RETRIES.md:73-76`                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 10  | Breaker deferral, both triggers, disable-after-N named as partial mechanism (TM-11)                                                                                      | Closed | `RELIABILITY.md:50-60`; competing mandates withdrawn at `SERVICE-AND-MIDDLEWARE.md:273-275` and `NEGATIVE-SPACE.md:232-234`                                                                                                                                                                                                                                                                                                                                                                 |
| 11  | Staleness escape hatch with the condition that makes it mandatory (TM-12)                                                                                                | Closed | `RETRIES.md:209-216`                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| 12  | **At ship, `DEFERRED.md` records the unenforced window**, naming `S-05` owner and the first client-wiring story deadline (TM-02)                                         | Closed | Closed 12/11/2026 by `22-implementation-documentation` Step 5, which owns that register's writes (story plan _Key Decisions_): `DEFERRED.md` Section _US005_ records the unenforced window — the rule in `RETRIES.md:56-59`, `retry-discipline.sh` unbuilt, owner slice `S-05`, deadline the first story that wires an outbound client — as finding F-017 of `../../../20-FINDINGS/FINDING-US005-RETRY-OWNERSHIP-AND-BUDGETS-12-11-2026.md`. TM-02 itself stays Residual until `S-05` ships |

## 7. Deviations from plan

- **The budget half moved to its own guide** — `code/docs/reliability/BUDGETS.md`, Sam, 12/11/2026
  (Q4). The plan placed the table "in the retry guide". No constraint changed; evidence for
  constraints 2 and 6 now cites `BUDGETS.md`.
- **Constraint 6 was reversed in substance, by decision.** The signed-off wording kept the
  original signature timestamp on every repeat; the 12/11/2026 correction re-signs each attempt,
  because a repeat signed an hour earlier fails the receiver's 300-second window. Severity stays
  `INFO`: the identifier de-duplication was always the replay defence. Corrected in place in the
  plan with a dated note, per the folder's additive rule.
- **No counted-down wait outlasts redelivery** — Sam, 12/11/2026. A new constraint the baseline
  did not have: every counted-down `C` and manual wait sits below `visibility_timeout`, and a
  longer schedule is persisted and swept (`BUDGETS.md:89-121`). The webhook row moved to that
  form with its 5-attempts-over-24-hours budget kept.
- **The GDPR retention example drops automatic retry** — Sam, 12/11/2026 (Q3). The plan expected
  a declarative fence; the shipped shape makes one attempt and lets the next Beat run be the retry
  (`COMPLIANCE.md:62-68`), which is the single-owner rule applied rather than an exception to it.
- **Jitter only lengthens a wait** — Sam, 12/11/2026 (Q5), withdrawing settled item B. Constraint
  3's "jitter cannot lower the minimum" now holds on every path this project writes as written.
- **The ADR is no longer cited from the guide** (the 12/11/2026 shipped-reference rule).
  `RETRIES.md:28-30` summarises the rejected options and accepted cost in place. The baseline's
  TB3 listed the ADR as half of the rule; the shipped guide is now the whole of it.
- **Constraint 4's proof site.** The plan said `TASK-AUTHORING.md`'s ladder "until `S-03`"; US001
  had moved the ladder to `IDEMPOTENCY.md` (`DEFERRED.md` row F-010), so the shipped rule routes
  there.
- **The sprint.** The plan names SPRINT-03; the story moved to SPRINT-04 on 07/09/2026.

## 8. Sign-off

| Reviewer                             | Role                         | Date       |
| ------------------------------------ | ---------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Security review (author)     | 12/11/2026 |
| <%DEVELOPER_NAME%>                   | Developer — countersignature | _pending_  |

**Independent review outstanding.** No separate peer-audit dispatch reviewed this record; that
gate is reported open, not met by self-review (`.ai/INSTRUCTIONS.md`).

**Overall verdict:** the story meets the baseline's posture targets as doctrine — eleven
constraints closed with cited shipped text, no CRITICAL or HIGH introduced — and constraint 12
closed on 12/11/2026, when this workflow's findings phase wrote the `DEFERRED.md` _US005_ row
recording the unenforced window (finding F-017). TM-02 stays Residual until slice `S-05` ships.
_Corrected 12/11/2026: this paragraph and the Outcome row read "constraint 12 open" after the row
had landed._

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — the baseline answered here
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the re-assessed STRIDE model, with TM-N1 to TM-N5
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the post-build audit this record consumes
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated
- `../../../02-STORIES/US005.md` — the source story
- `../../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — _Key Decisions_ and the 11/11 and 12/11/2026 sections
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
