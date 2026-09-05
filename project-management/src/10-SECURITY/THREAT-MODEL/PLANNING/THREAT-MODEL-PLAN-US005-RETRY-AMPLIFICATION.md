# Threat Model Plan — US005 Exactly one layer decides to retry

| Field               | Value                                                                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Story**           | US005 — Exactly one layer decides to retry, and every budget says how long it may take                                              |
| **Date**            | 05/09/2026                                                                                                                          |
| **Author**          | Claude Code — `security` skill, Fable tier · reviewed by <%DEVELOPER_NAME%>                                                         |
| **Status**          | Signed off                                                                                                                          |
| **Feature surface** | None. This story ships prose doctrine into `code/docs/reliability/` and repairs four budget statements across three existing guides |

---

## 1. Scope

This model covers **the rules US005 writes**, not a runtime surface — the story adds no model,
no endpoint, no screen, no personal-data path and no log line, and eleven of its thirteen flags
read `N/A`. What is being threat-modelled is the retry behaviour the doctrine will licence once
code is configured against it, plus the doctrine's own failure modes as an artefact.

### Inputs actually read

The workflow's named inputs are user flows and wireframes
(`project-management/workflows/10-security-checks/STEPS.md` Step 1). **US005 has neither** — its
`User Flow` and `Wireframes` flags both read `N/A`. Per `code/docs/GATE-REPORTING.md`, that is
recorded here rather than left as empty cells that would read as "reviewed, nothing found":

- **User flow(s):** none — flag `N/A`. Not a skipped read; the artefact does not exist and is not owed.
- **Wireframe(s):** none — flag `N/A`. Same.
- **Read instead:** `project-management/src/02-STORIES/US005.md` (its nine Gherkin scenarios),
  `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`,
  `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` nodes `N-008`–`N-011`,
  and the guides the boundaries below were derived from — `code/docs/TASK-AUTHORING.md`,
  `code/docs/api-design/WEBHOOKS.md`, `code/docs/performance/API-AND-MONITORING.md`,
  `code/docs/mcp-server/TOOL-DESIGN.md`, `code/docs/MANAGEMENT-COMMANDS.md`,
  `code/docs/security/MONITORING-AND-INCIDENT.md` and `project-management/docs/gdpr/COMPLIANCE.md`.
- **Surface under review:** the retry decision itself, wherever the doctrine places it.
- **Data touched:** none directly. The doctrine governs paths that later carry request payloads
  and provider error bodies; **no PII classification applies to this story's own output**.

### Two baselines that do not reach this story

`project-management/docs/SECURITY-GUIDE.md` holds an audit to **NIST SP 800-53** control depth
and **UK Cyber Essentials / CE Plus**. Neither is engaged here and the reason is stated rather
than the rows left blank: SP 800-53 depth applies to an implemented control, and this story
implements none; CE and CE+ cover firewalls, secure configuration, update management, user access
control and malware protection on running infrastructure, and this story changes no running
configuration. **Both re-engage at the first story that wires a client** — recorded as the
promotion trigger in Section 3a rather than dropped.

### Severity scale

| Level      | Definition                                                                |
| ---------- | ------------------------------------------------------------------------- |
| `CRITICAL` | Exploitable without authentication, or full compromise / credential theft |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    |
| `LOW`      | Minor impact; defence-in-depth measure                                    |
| `INFO`     | Observation with no immediate exploitability                              |

Only **CRITICAL** and **HIGH** findings block sprint planning
(`project-management/docs/SECURITY-GUIDE.md`).

**This model states two severities per row, and the distinction is load-bearing** — see
Section 3a. The `Severity` column carries the **present state**, which is what the blocking rule
in `project-management/docs/SECURITY-GUIDE.md` is written against. The design-state severity and
its promotion trigger are a separate table, because inventing a second severity column would fork
`THREAT-MODEL-PLAN-US000-TEMPLATE.md` for one story.

## 2. Trust boundaries

| ID  | From                                                                                                                                   | To                                                                                                       | Data crossing                                                                                             |
| --- | -------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| TB1 | The retry owner inside this application                                                                                                | A third-party provider — S3 via `boto3`, a webhook consumer, ClickUp, the Sentry transport, any HTTP API | The outbound request, and every repeat of it                                                              |
| TB2 | A third-party provider, or an inbound caller                                                                                           | The retry owner inside this application                                                                  | The error response and its `Retry-After` header — a value this application does not control but sleeps on |
| TB3 | The written rule — reliability-family prose + `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` | The code expected to obey it                                                                             | The retry configuration a developer writes, or omits                                                      |
| TB4 | The retry owner                                                                                                                        | The log and error-tracking sinks                                                                         | Exception text, request URLs, provider error bodies — once per attempt                                    |
| TB5 | A served surface — Django Ninja `/api/`, FastMCP `/mcp/`, the CLI                                                                      | Its caller                                                                                               | The repeat decision, handed back outward rather than absorbed                                             |

TB3 is the boundary this story actually crosses. The others are the boundaries its rules govern.

## 3. STRIDE threat table

Status is `Proposed` at planning time throughout. `Severity` is **present state**, measured
05/09/2026 against the working tree: `code/src/django/` contains no `self.retry`, no
`autoretry_for`, no `max_retries`, no `retry_backoff`, no `boto3`/`botocore` import and no
`sentry_sdk` — nothing outbound retries today.

| ID    | STRIDE | OWASP                             | NIST CSF                | Trust Boundary | Threat description                                                                                                                                                                                                                                                                                                                            | Severity | Status   | Mitigation (proposed control)                                                                                                                                                                                                      |
| ----- | ------ | --------------------------------- | ----------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | D      | `A10:2025` (`A06:2025` secondary) | `PR.IR-04`              | TB1            | With no named owner every layer retries and the product is geometric: task layer 3 × SDK transport (botocore legacy mode, ~4 retries at 60 s connect + 60 s read) × client 3 ≈ 27–36 requests per failed operation against a provider already failing. The provider rate-limits, and the failure returns inbound as self-inflicted exhaustion | INFO     | Proposed | The story's own rules: one owner per operation, every layer beneath makes a single attempt, SDK transport retries clamped off at the constructor, the declarative budget table with a derived worst-case formula                   |
| TM-02 | T      | `A02:2025`                        | `PR.PS-01` (`GV.PO-01`) | TB3            | The artefact is prose. `code/src/scripts/audits/doctrine-drift.sh` reads fenced code only, and `retry-discipline.sh` is slice `S-05`'s and does not exist. A client constructed with no retry configuration silently inherits the vendor default — the breach is an omission, not an act, and is invisible until an outage                    | LOW      | Proposed | Record the unenforced window in `DEFERRED.md` at ship, naming `S-05` as owner; sequence `S-05` before the first story that wires a client; until then the outbound timeout register's retry-owner column is the manual review site |
| TM-03 | D      | `A10:2025`                        | `PR.IR-04`              | TB2            | `Retry-After` is attacker-influenced input that controls sleep duration. A hostile or compromised provider returns a very large value and parks the worker for it; a swarm of them exhausts the pool without sending a single byte of payload                                                                                                 | INFO     | Proposed | The story's `max(backoff, Retry-After)` rule **clamped by the row's total-age ceiling**, and "a header beyond the remaining budget means exhausted — park the work, never sleep past the bound"                                    |
| TM-04 | T      | `A08:2025`                        | `PR.DS-01`              | TB1            | A repeat of a non-idempotent operation executes it twice. A `POST` whose first attempt succeeded server-side and timed out client-side is retried into a double webhook, a double email, a double charge. Retry and idempotency are one rule seen twice (`code/docs/TASK-AUTHORING.md`), and this story writes only the retry half            | INFO     | Proposed | The owner rule states that a layer may only repeat an operation it can show is idempotent — by the family's idempotency rule once slice `S-03` ships, by `code/docs/TASK-AUTHORING.md`'s proof ladder until then                   |
| TM-05 | I      | `A09:2025`                        | `PR.DS-01` (`DE.AE-03`) | TB4            | The retry owner logs each attempt. The exception carried through the retry path embeds the request URL and often the provider's error body; a presigned object-storage URL in a log line is a credential per `code/docs/security/MONITORING-AND-INCIDENT.md`, and N attempts write it N times                                                 | INFO     | Proposed | The retry guide states that an attempt log records the attempt number, the elapsed budget and the **error class** — never the exception message, the URL or the provider body                                                      |
| TM-06 | S      | `A08:2025`                        | `PR.AA-05`              | TB1            | A repeated webhook delivery is re-signed per attempt. Each repeat is a fresh, independently valid signed request, so a bounded retry chain widens the window in which a captured delivery replays as authentic                                                                                                                                | INFO     | Proposed | The budget table's webhook override states that a repeat reuses the original delivery identifier so a consumer can deduplicate, and that the signature timestamp is not refreshed merely because the attempt is                    |
| TM-07 | R      | `A09:2025`                        | `DE.AE-03`              | TB4            | Without a per-attempt record, a repeat cannot be reconstructed after the fact — an operator cannot tell one failed call from thirty, and the provider's account of the incident cannot be disputed or confirmed                                                                                                                               | INFO     | Proposed | Attempt numbering and elapsed-budget recording are stated as part of the budget rule, not left to each caller                                                                                                                      |
| TM-08 | T      | `A06:2025`                        | `GV.PO-01`              | TB3 · TB5      | A competing ownership statement survives the story: `code/docs/mcp-server/TOOL-DESIGN.md:139-141` tells its reader that transient failures are retried **server-side** by FastMCP's `RetryMiddleware`, which is the opposite of what the doctrine will state. No task in US005 and no slice on the map repairs that line                      | INFO     | Proposed | Named as a blocking-for-coherence finding — see Section 4. The line is either repaired in this story or explicitly assigned to a slice, and the doctrine cites it as the surface exception it is                                   |
| TM-09 | D      | `A06:2025`                        | `PR.IR-04`              | TB5            | "Served surfaces never retry inbound work" is correct and moves the storm rather than removing it: the caller now repeats, and the rate limits that would absorb that do not exist in this tree yet                                                                                                                                           | INFO     | Proposed | The doctrine states the caller-side obligation alongside the served-surface rule, and the absence of inbound rate limiting is carried as a named dependency rather than assumed                                                    |
| TM-10 | D      | `A06:2025`                        | `ID.AM-08`              | TB1            | A client that keeps transport retries through a register row delegates a budget nobody can observe — the vendor's attempt count and backoff are not surfaced, so the operation's worst case becomes both uncomputable and invisible                                                                                                           | INFO     | Proposed | The register row records the delegated attempt count and interval **as numbers**, not as "vendor default", so the worst-case formula still resolves                                                                                |
| TM-11 | D      | `A06:2025`                        | `RS.MA-01`              | TB1            | Per-operation budgets bound one caller, not the fleet. Fifty workers each correctly bounded still present fifty synchronised chains to one degraded provider, and the breaker that would cut it is deferred — with an incident as its own first trigger                                                                                       | INFO     | Proposed | The deferral is recorded with both triggers stated, naming `code/docs/api-design/WEBHOOKS.md`'s disable-after-N-failures rule as the partial mechanism already in the tree                                                         |
| TM-12 | T      | `A08:2025`                        | `PR.DS-01`              | TB1            | Intent replayed at the end of a long budget may no longer be the intent — a cancellation, a correction or a deletion can land while the chain is still sleeping, and the final attempt writes the stale version                                                                                                                               | INFO     | Proposed | The named staleness escape hatch — a timestamp argument or a per-message `expires` — is stated with the condition that makes it **mandatory** rather than available                                                                |

**Elevation of privilege — considered, not applicable.** No principal changes hands in a retry:
the repeat runs as the same actor, with the same scope, against the same target. Recorded rather
than omitted, so a later reader can tell a considered `N/A` from an unexamined letter.

## 3a. Design-state severity and promotion triggers

Every row above is `INFO` or `LOW` **today** for one reason: nothing in this repository retries
anything. That is a fact about the tree, not about the design, and it expires. This table states
what each finding becomes and the event that promotes it — the house deferred-with-a-trigger form,
so that a later reader is not left inferring severity from a story that is no longer true.

| ID    | Present | Design state | Promotion trigger                                                                                                                        |
| ----- | ------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | INFO    | **HIGH**     | The first Celery task or request-path service that constructs an SDK or HTTP client without an explicit retry clamp                      |
| TM-02 | LOW     | **HIGH**     | Any client wired **before** `retry-discipline.sh` is registered in CI and lefthook (slice `S-05`); MEDIUM if after                       |
| TM-03 | INFO    | MEDIUM       | The first retry owner that reads an inbound `Retry-After`                                                                                |
| TM-04 | INFO    | **HIGH**     | The first retried operation with an external side effect that is not provably idempotent                                                 |
| TM-05 | INFO    | MEDIUM       | The first attempt-level log line, or `sentry_sdk.init()` — whichever lands first                                                         |
| TM-06 | INFO    | LOW          | The first outbound webhook delivery with a real consumer                                                                                 |
| TM-07 | INFO    | MEDIUM       | The first wired retry owner                                                                                                              |
| TM-08 | INFO    | MEDIUM       | Immediate on this story's ship if `code/docs/mcp-server/TOOL-DESIGN.md:139-141` is left standing — see Section 4                         |
| TM-09 | INFO    | MEDIUM       | The first served surface with an external caller and no inbound rate limit                                                               |
| TM-10 | INFO    | MEDIUM       | The first register row that delegates transport retries                                                                                  |
| TM-11 | INFO    | MEDIUM       | The first incident in which bounded retries against a live provider degrade service — which is the breaker deferral's own stated trigger |
| TM-12 | INFO    | MEDIUM       | The first retried operation whose payload can be superseded while the chain sleeps                                                       |

**The promotion is not automatic and it is not this story's to perform.** Each trigger names the
story that will meet it; that story re-assesses the row in its own
`../IMPLEMENTATION/THREAT-MODEL-IMPL-US###-<DESCRIPTOR>.md` with code evidence. What this table
buys is that the re-assessment starts from a stated expectation rather than from a blank page.

## 4. Blocking findings & escalations

**No finding is CRITICAL or HIGH in the present state, so none blocks sprint planning, and no
record is created under `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`.** That is
a decision with a reason, not an omission: the escalation rule in
`project-management/docs/SECURITY-GUIDE.md` is written against exploitability, and there is no
retry in this tree to exploit. Escalating a design-state HIGH into a vulnerability record would
put a live finding on a threat nothing can currently trigger, and the register would carry it as
open for however many sprints pass before a client is wired.

**`AUDITS/` does not fire either**, and the skip is recorded here rather than reported as a pass:
a code audit reads shipped code, and this story ships none. It fires at the first story that
wires a client — the same trigger as TM-01.

**One finding blocks on coherence rather than on severity, and is raised to the story:**

- [ ] **TM-08 (`INFO` present / `MEDIUM` design)** — `code/docs/mcp-server/TOOL-DESIGN.md:139-141`
      states the opposite of the doctrine at the MCP boundary, and nothing repairs it. This is not
      escalated to a vulnerability record; it becomes an acceptance-criterion question in
      `project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` and is
      resolved into `project-management/src/02-STORIES/US005.md` before sprint planning. A story
      that ships doctrine while leaving a guide stating its inverse has not repaired the fence.

## 4a. Developer constraints carried forward

`project-management/docs/SECURITY-GUIDE.md` requires every non-`INFO` finding to become an
explicit, testable constraint. TM-02 is the only non-`INFO` row, but the design-state promotions
are what a later story will actually be held to, so the constraints below are written now and
carried into the sprint record's Security Acceptance Criteria. They are constraints **on the
doctrine's wording**, because that is all this story ships.

- **From TM-01 and TM-02** — the retry guide states, as a rule a script could later check: _every
  SDK or HTTP client constructor sets its attempt count explicitly; one attempt unless a row in
  the outbound timeout register names the delegation and its reason._ The worst-case formula
  states its assumption that inner-layer attempts equal one.
- **From TM-03** — the `Retry-After` rule states the clamp and the exhausted case in the same
  breath as the honouring, never as a later caveat.
- **From TM-04** — the owner rule states an idempotency precondition on every repeat, and names
  where the proof lives until slice `S-03` ships.
- **From TM-05** — the attempt-log rule names what is recorded (attempt number, elapsed budget,
  error class) and what is not (exception message, URL, provider body).
- **From TM-10** — a register row that delegates records the delegated attempt count and interval
  as numbers.

## 5. Out of scope

- **The idempotency half of the rule** — slice `S-03` on
  `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`, not yet cut into a story.
  TM-04 names the dependency; it does not close it.
- **Per-socket timeout values and the outbound timeout register** — slice `S-09`, which runs
  beside this story and shares no file with it.
- **The `retry-discipline.sh` gate and its CI registration** — slice `S-05`. TM-02 is the finding
  that exists _because_ that slice has not shipped.
- **Live-code fixes the doctrine already requires** — jittered health TTLs, Valkey socket
  timeouts, the ClickUp `urlopen` timeout — slice `S-06`.
- **Inbound rate limiting** — no story yet. TM-09 names it as a dependency of the served-surface
  rule rather than claiming it.
- **Authentication, session and credential surfaces** — untouched by this story; modelled in their
  own per-story models when those stories exist.

---

## Cross-references

- `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the post-implementation review that re-assesses this model
- `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — the posture assessment that consumes this model
- `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — where blocking CRITICAL/HIGH findings would be escalated; nothing from this model qualifies, and Section 4 records why
- `project-management/src/02-STORIES/US005.md` — the story being modelled
- `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` — the single-owner decision this model threatens
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 (2025) / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this model
- `code/docs/GATE-REPORTING.md` — the rule Sections 1 and 4 rest on
- `code/docs/SECURITY.md` — the code-side enforcement these controls will specify
