# Security Posture Assessment (Plan) — US005 Exactly one layer decides to retry

| Field          | Value                                                                                  |
| -------------- | -------------------------------------------------------------------------------------- |
| **Story**      | US005 — Exactly one layer decides to retry, and every budget says how long it may take |
| **Date**       | 05/09/2026                                                                             |
| **Author**     | Claude Code — `security` skill, Fable tier · reviewed by <%DEVELOPER_NAME%>            |
| **Sprint**     | SPRINT-03 — retry doctrine gets its single owner                                       |
| **Status**     | Signed off                                                                             |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)               |

> This assessment establishes the security **baseline** for the story before any code is written.
> It synthesises the story's STRIDE threat model and maps overall posture against OWASP Top 10 and
> NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or HIGH finding.

---

## 1. Summary

**Twelve findings, none CRITICAL or HIGH in the present state: eleven `INFO` and one `LOW`. No
finding blocks sprint planning, and no vulnerability record is opened.** Risk concentrates
entirely at **TB1**, the boundary between this application's retry owner and a third-party
provider, and at **TB3**, the boundary between the written rule and the code expected to obey it.

The present-state figures are not a compliment to the design; they are a fact about the tree.
Measured 05/09/2026: `code/src/django/` contains no `self.retry`, no `autoretry_for`, no
`max_retries`, no `retry_backoff`, no `boto3` or `botocore` import and no `sentry_sdk` — **nothing
outbound retries today, so nothing outbound can amplify today.** Under the design state the same
twelve rows carry four HIGHs (TM-01, TM-02, TM-04 and TM-02's early-wiring case). The promotion
triggers are in
`project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
Section 3a, and each names the story that will meet it.

**This story's security value is preventative, and it is the cheapest it will ever be.** It states
the rule before there is a caller to migrate — which is also why the assessment reads so quietly.
The one finding that is live now, TM-02, is live precisely because the rule ships without its gate.

## 2. Scope

| Dimension    | Coverage                                                                                                                                                                                                                                                                         |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story        | US005 — Exactly one layer decides to retry, and every budget says how long it may take                                                                                                                                                                                           |
| User flow    | **None — flag `N/A`.** Not a skipped read: the story adds no journey, so no flow artefact is owed. Recorded per `code/docs/GATE-REPORTING.md`                                                                                                                                    |
| Schema       | **None — flag `N/A`.** No model, no table, no RLS scope, no PII classification. The story ships Markdown                                                                                                                                                                         |
| Decisions    | `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` |
| Read instead | The story's eight Gherkin scenarios, `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` nodes `N-008`–`N-011`, and the seven guides listed in the threat model's Section 1                                                                                    |
| Frameworks   | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                                                                                                                      |

**Two baselines do not reach this story**, and the reason is stated rather than the row left
blank. `project-management/docs/SECURITY-GUIDE.md` holds an audit additionally to **NIST SP
800-53** control depth and **UK Cyber Essentials / CE Plus**. SP 800-53 depth applies to an
implemented control and this story implements none; CE and CE+ cover running infrastructure and
this story changes no running configuration. Both re-engage at the first story that wires a client.

**One deviation to re-validate on landing:** the story's target directory, `code/docs/reliability/`,
does not exist in any branch or commit today — it is US001's deliverable, and US001 is still
`Open` in SPRINT-01. Every rule assessed here is assessed against a home that has not been built.

## 3. Threat models referenced

- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
  — **12 findings across all six STRIDE categories, 5 trust boundaries.** Elevation of privilege is
  recorded as considered-and-not-applicable rather than omitted. This assessment adopts its
  boundaries and severities unchanged, including the present-state / design-state split.

## 4. OWASP Top 10 — baseline coverage

Design-stage posture. Status ∈ Addressed / Partial / Open / N/A.

| ID         | Category                              | Status      | Notes (open findings, controls relied on)                                                                                                                                                                                                                                                                                                                                                                                   |
| ---------- | ------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `A01:2025` | Broken Access Control (incl. SSRF)    | N/A         | The story adds no endpoint, no protected action and no user-supplied identifier. No role boundary is crossed and no ownership is verified, because nothing is owned                                                                                                                                                                                                                                                         |
| `A02:2025` | Security Misconfiguration             | **Partial** | **TM-02 (`LOW`)** open. The rule is stated but unenforced — `doctrine-drift.sh` reads fenced code only and `retry-discipline.sh` is slice `S-05`'s. A client wired before that gate silently inherits the vendor default                                                                                                                                                                                                    |
| `A03:2025` | Software Supply Chain Failures        | Partial     | No dependency added or moved. But the doctrine deliberately **overrides a vendor default** (SDK transport retries), so a supply-chain change — a botocore upgrade altering retry semantics — becomes a doctrine event. Named here so the next dependency-update pass knows to look                                                                                                                                          |
| `A04:2025` | Cryptographic Failures                | N/A         | No credential, key, token or encrypted field is designed, stored or transmitted by this story                                                                                                                                                                                                                                                                                                                               |
| `A05:2025` | Injection                             | N/A         | No query, no template interpolation, no user-supplied input reaches a parser. `Retry-After` is untrusted input but it is parsed as a duration, not injected — that risk is `A10` (TM-03)                                                                                                                                                                                                                                    |
| `A06:2025` | Insecure Design                       | **Partial** | The category this story exists to address. **TM-08, TM-09, TM-10, TM-11 (all `INFO`)** open: a surviving competing ownership statement, a storm relocated inbound onto absent rate limits, an unobservable delegated budget, and fleet-level amplification the deferred breaker would have cut. The abuse case is modelled — which is the improvement — but four of its edges are stated as dependencies rather than closed |
| `A07:2025` | Authentication Failures               | N/A         | No credential, session or MFA path is touched                                                                                                                                                                                                                                                                                                                                                                               |
| `A08:2025` | Software and Data Integrity Failures  | **Partial** | **TM-04, TM-06, TM-12 (all `INFO`)** open: duplicate execution of a non-idempotent repeat, a re-signed webhook widening its replay window, and stale intent replayed at the end of a long budget. TM-04 is the significant one — the idempotency half of this rule is slice `S-03` and is not yet a story                                                                                                                   |
| `A09:2025` | Security Logging & Alerting Failures  | **Partial** | **TM-05, TM-07 (both `INFO`)** open: per-attempt logging repeats exception text embedding request URLs and possibly presigned credentials, and without attempt numbering a repeat cannot be reconstructed after an incident                                                                                                                                                                                                 |
| `A10:2025` | Mishandling of Exceptional Conditions | **Partial** | The story's own subject. **TM-01, TM-03 (both `INFO`)** open: the retry path is an error path that consumes resources geometrically, and `Retry-After` is attacker-influenced input controlling how long a worker sleeps. The proposed controls close both **in doctrine**; nothing enforces them yet                                                                                                                       |

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                                                                                                                                                                                                             |
| --- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| GV  | Govern   | **The improvement this story delivers.** Retry ownership was undefined policy — `GV.PO-01` — with four guides contradicting each other on budget. After this story exactly one layer decides, the decision is recorded in an ADR with its rejected option, and the policy has a named home. TM-08 weakens it: one guide still states the inverse |
| ID  | Identify | The four contradicting budgets and their worst cases are inventoried before any is edited, so the asset being changed is known. `ID.AM-08` is weakened by TM-10 — a delegated transport budget is an unmeasured asset                                                                                                                            |
| PR  | Protect  | `PR.IR-04` (adequate capacity to maintain availability) is what the single-owner rule and the total-age ceiling protect. `PR.PS-01` is **open**: configuration management for this rule has no enforcement point until slice `S-05`. `PR.DS-01` is weakened by TM-04, TM-05 and TM-12                                                            |
| DE  | Detect   | **The weakest function, and honestly so.** `DE.AE-03` — nothing correlates attempts today; there is no `sentry_sdk.init()`, no attempt-level log line and no metric. TM-05 and TM-07 both live here. The story states what an attempt log must contain; it does not create one                                                                   |
| RS  | Respond  | `RS.MA-01` is deferred by design: the circuit breaker that would cut a degrading provider is recorded as deferred with two triggers, one of which is an incident. `code/docs/api-design/WEBHOOKS.md`'s disable-after-N-failures rule is the partial mechanism already in the tree and is named so the deferral does not read as a contradiction  |
| RC  | Recover  | Bounded retries **are** the recovery path for a transient provider failure, and bounding them is what makes recovery terminate. No rollback surface is added or changed; nothing here is irreversible                                                                                                                                            |

## 6. Findings

All twelve are adopted unchanged from the threat model. Present-state severity; design-state and
trigger in that document's Section 3a.

| ID    | STRIDE | OWASP      | NIST CSF   | Trust Boundary | Threat Description                                                                        | Severity | Planned Mitigation                                                                                                                                     |
| ----- | ------ | ---------- | ---------- | -------------- | ----------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| TM-02 | T      | `A02:2025` | `PR.PS-01` | TB3            | Unconfigured client silently inherits the vendor retry default; no gate detects it        | **LOW**  | `DEFERRED.md` entry at ship naming `S-05` as owner; sequence `S-05` before the first client-wiring story; manual review at the register row until then |
| TM-01 | D      | `A10:2025` | `PR.IR-04` | TB1            | Stacked retries multiply geometrically against a provider already failing                 | INFO     | One owner per operation; layers beneath make a single attempt; explicit SDK clamp; derived worst-case formula                                          |
| TM-03 | D      | `A10:2025` | `PR.IR-04` | TB2            | Untrusted `Retry-After` controls sleep duration and can park a worker indefinitely        | INFO     | `max(backoff, Retry-After)` clamped by the total-age ceiling; beyond-budget means exhausted, park, never sleep past                                    |
| TM-04 | T      | `A08:2025` | `PR.DS-01` | TB1            | Duplicate execution of a repeat that is not provably idempotent                           | INFO     | Idempotency precondition stated on the owner rule; proof ladder named until slice `S-03` ships                                                         |
| TM-05 | I      | `A09:2025` | `PR.DS-01` | TB4            | Attempt logs repeat exception text embedding request URLs and presigned credentials       | INFO     | Attempt log records attempt number, elapsed budget and error class only                                                                                |
| TM-06 | S      | `A08:2025` | `PR.AA-05` | TB1            | A re-signed retry widens the window in which a captured delivery replays as authentic     | INFO     | Webhook override reuses the delivery identifier; signature timestamp not refreshed per attempt                                                         |
| TM-07 | R      | `A09:2025` | `DE.AE-03` | TB4            | A repeat cannot be reconstructed after an outage without a per-attempt record             | INFO     | Attempt numbering and elapsed-budget recording stated as part of the budget rule                                                                       |
| TM-08 | T      | `A06:2025` | `GV.PO-01` | TB3 · TB5      | `code/docs/mcp-server/TOOL-DESIGN.md:139-141` states the inverse of the doctrine          | INFO     | Repaired in this story or explicitly assigned to a slice — raised to the story via the QA gate                                                         |
| TM-09 | D      | `A06:2025` | `PR.IR-04` | TB5            | "Served surfaces never retry" moves the storm inbound, onto rate limits that do not exist | INFO     | Caller-side obligation stated alongside; absent inbound rate limiting carried as a named dependency                                                    |
| TM-10 | D      | `A06:2025` | `ID.AM-08` | TB1            | A delegated transport budget is unobservable, so the worst case stops resolving           | INFO     | Register row records the delegated attempt count and interval as numbers                                                                               |
| TM-11 | D      | `A06:2025` | `RS.MA-01` | TB1            | Per-operation budgets do not bound fleet-level amplification; the breaker is deferred     | INFO     | Deferral recorded with both triggers, naming the existing disable-after-N-failures rule as partial mechanism                                           |
| TM-12 | T      | `A08:2025` | `PR.DS-01` | TB1            | Stale intent replayed at the end of a long budget                                         | INFO     | Staleness escape hatch stated with the condition that makes it mandatory rather than merely available                                                  |

**Nothing is escalated to
`project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`, and that is a decision.** The
escalation rule is written against exploitability; there is no retry in this tree to exploit.
Opening a record on a design-state HIGH would leave a live vulnerability entry against a threat
nothing can trigger, open for however many sprints pass before a client is wired. The
promotion-trigger table is the mechanism that replaces it.

**`AUDITS/` does not fire.** A code audit reads shipped code and this story ships none. Recorded
here rather than reported as a clean pass, per `code/docs/GATE-REPORTING.md`. It fires at the
first story that wires a client — the same trigger as TM-01.

## 7. Security tasks & open gaps

Each becomes a checklist item the implementation assessment closes with evidence. These are
constraints on **the doctrine's wording**, because that is all this story ships.

- [ ] The retry guide states, in a form a script could later check: _every SDK or HTTP client
      constructor sets its attempt count explicitly; one attempt unless a row in the outbound
      timeout register names the delegation and its reason_ (TM-01, TM-02, `A02` / `A10`).
- [ ] The worst-case formula states its own assumption — that inner-layer attempts equal one
      (TM-01, TM-10, `A10`).
- [ ] The `Retry-After` rule states the total-age clamp and the beyond-budget-means-exhausted case
      in the same breath as the honouring, never as a later caveat (TM-03, `A10`).
- [ ] The owner rule states an idempotency precondition on every repeat, and names where the proof
      lives until slice `S-03` ships (TM-04, `A08`).
- [ ] The attempt-log rule names what is recorded — attempt number, elapsed budget, error class —
      and what is never recorded: the exception message, the request URL, the provider body
      (TM-05, TM-07, `A09`).
- [ ] The webhook override states that a repeat reuses the original delivery identifier and does
      not refresh the signature timestamp (TM-06, `A08`).
- [ ] `code/docs/mcp-server/TOOL-DESIGN.md:139-141` is either repaired by this story or explicitly
      assigned to a named slice; the doctrine cites the served-surface rule it belongs to
      (TM-08, `A06`) — **raised to the story through the QA gate.**
- [ ] The served-surface rule states the caller's obligation to bound its own repeats, and names
      inbound rate limiting as a dependency rather than assuming it (TM-09, `A06`).
- [ ] A register row that delegates transport retries records the delegated attempt count and
      interval as numbers, not as "vendor default" (TM-10, `A06`).
- [ ] The breaker deferral records both triggers and names
      `code/docs/api-design/WEBHOOKS.md`'s disable-after-N-failures rule as the partial mechanism
      already in the tree (TM-11, `A06`).
- [ ] The staleness escape hatch states the condition that makes it **mandatory**, not merely
      available (TM-12, `A08`).
- [ ] **At ship, `DEFERRED.md` records the unenforced window** — the rule exists and
      `retry-discipline.sh` does not — naming slice `S-05` as its owner and the first
      client-wiring story as its deadline (TM-02, `A02`). This is the one task that outlives the
      document.

**None of the above is a sprint-planning blocker**, because none is CRITICAL or HIGH today. All
twelve are `MEDIUM`-and-below developer constraints in the sense
`project-management/docs/SECURITY-GUIDE.md` means: documented, explicit, testable, and carried
into `project-management/src/02-STORIES/US005.md` and SPRINT-03's Security Acceptance Criteria
rather than left in this file.

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` — the STRIDE model this assessment synthesises
- `project-management/src/10-SECURITY/AUDITS/PLANNING/` · `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — neither fires for this story; Section 6 records why for both
- `project-management/src/02-STORIES/US005.md` — the story being assessed
- `project-management/src/03-SPRINTS/SPRINT-03.md` — the sprint whose Security Acceptance Criteria these constraints populate
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10 (2025), and NIST CSF 2.0 standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` rows and the non-firing categories rest on
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
