# ADR-US005: Exactly one layer decides to retry, and SDK transport retries are clamped off by default

**Status:** Accepted
**Date:** 04/09/2026
**Corrected:** 05/09/2026 — the worked clamp read `retries={"max_attempts": 1}`, which permits two
attempts and so breached the rule it illustrates. Corrected in place rather than superseded,
because the record had not yet reached a commit and no reader could have relied on it. Detail in
_The clamp's correct form_ below.
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US005

---

## Context

US005 states cross-surface retry doctrine in the `code/docs/reliability/` family. The first rule
it has to state is the one nothing in the tree states today: **which layer decides that a failed
operation should be attempted again.**

Left unsaid, the answer is "all of them", and the layers compose multiplicatively. A task
configured with three attempts, calling a service through an SDK whose own transport retries three
times, behind a client that retries three times, issues twenty-seven requests against a provider
that is already failing. Every layer looks locally reasonable. The aggregate is an amplification
attack the project runs against its own supplier, and then against itself when the supplier's
rate limiter starts refusing everything.

The defaults make this the path of least resistance rather than an unlucky accident. `botocore`
ships `max_attempts` at 3 in its standard mode; `urllib3` retries; Celery's `autoretry_for` path
retries; FastMCP ships a `RetryMiddleware`. A developer who configures nothing gets stacked
retries, and the stack is invisible at every individual call site.

Three facts bound the decision, all measured on 27/08 and 01/09/2026 and recorded on
`MAP-RETRY-AND-IDEMPOTENCY.md`:

- **Nothing in the repository retries anything today.** Celery is declared and unwired, there is no
  `sentry_sdk.init()`, `boto3` is declared but never imported, and there is no `self.retry` in live
  code. This rule is being written before its first caller, which is the cheapest moment it will
  ever have.
- **The one verified-correct retry claim in the tree runs the other way.**
  `code/docs/mcp-server/TOOL-DESIGN.md:139-141` says transient failures are retried **server-side**
  by FastMCP's `RetryMiddleware`. Node N-003's research confirmed the middleware exists and does
  what the claim says.
- **The written budgets already disagree four ways**, which is what a world without a named owner
  produces: `WEBHOOKS.md:86`, `performance/API-AND-MONITORING.md:57`,
  `project-management/docs/gdpr/COMPLIANCE.md:27` and `TASK-AUTHORING.md:204`.

The trade-off is real, which is why this is recorded rather than simply written into a guide.
Clamping an SDK's retries off means deliberately discarding resilience the vendor wrote, tested and
ships on by default — and a transport-level retry genuinely is better placed than an
application-level one for a dropped TCP segment or a stale connection from a pool.

## Options considered

### Option A — Each layer retries, tuned so the product is acceptable

- **Summary:** Leave SDK defaults on; set application attempt counts low enough that the composed
  worst case stays bounded.
- **Pros:** Keeps the vendor's transport-level recovery, which handles connection-pool staleness
  better than an application retry can. No SDK configuration to write or maintain.
- **Cons:** The bound is a product of numbers set in different files by different people, so nobody
  can state it without reading all of them; adding a layer silently multiplies it again. It cannot
  be gated — there is no single site a script could read. And the total-age ceiling
  `TASK-AUTHORING.md:204` demands becomes uncomputable, because the inner layers' waits are not
  visible to the outer one.

### Option B — One layer decides; every layer beneath makes a single attempt

- **Summary:** Name the deciding layer per operation. Clamp SDK-internal retries off by default
  (`retries={"total_max_attempts": 1}` and kin). A client that keeps transport retries does so
  through a row in the outbound timeout register naming the delegation and its reason.
- **Pros:** The budget is stated in one place per operation and is therefore both readable and
  gateable — `S-05`'s `retry-discipline.sh` has a single site to check. The total-age ceiling
  becomes computable. The exception path exists and is visible, on the `DICT-OK:` escape-hatch
  pattern the project already uses for a rule with legitimate exceptions.
- **Cons:** Gives up the SDK's transport-level recovery by default, so a failure the vendor would
  have absorbed silently now surfaces to the application layer. Every SDK client needs explicit
  configuration, and a client added without it inherits the vendor default rather than the rule —
  the failure mode is silent until the gate exists.

### Option C — One layer decides, and the deciding layer is always the outermost

- **Summary:** As B, but fix the owner structurally rather than per operation.
- **Pros:** No per-operation judgement; trivially checkable.
- **Cons:** Wrong for the surfaces already settled. A served surface must **not** retry inbound
  work — the caller owns the repeat, which is why FastMCP's `RetryMiddleware` stays unwired and why
  exit 75 is the CLI's expression. Making the outermost layer the owner inverts both.

### Option D — Do nothing; let each story decide when it wires its client

- **Summary:** No cross-surface rule; the first story to wire Celery or `boto3` sets a precedent.
- **Pros:** No doctrine written ahead of a caller.
- **Cons:** This is the state that produced the four contradicting budgets. The rule is cheapest to
  state now, while there is no wired client to migrate; deferring it means writing it later against
  code that already disagrees with it.

## Decision

**We will take Option B.** The deciding factor is that only B makes the budget a _stated_ property
rather than an emergent one. A and D leave the worst case as an arithmetic product distributed
across files, which is unreadable, ungateable, and cannot satisfy the total-age bound
`TASK-AUTHORING.md:204` already requires. C fixes the owner in a way two settled nodes contradict.

The cost — losing vendor transport retries by default — is accepted for three reasons. It is
reversible per client through a register row, so the escape hatch is a row rather than a rewrite.
There is no wired SDK client in the tree today, so nothing is being taken away from working code.
And the amplification it prevents is the failure mode that actually hurts: a retry storm against a
degraded provider is self-inflicted resource exhaustion, and it arrives exactly when the system is
least able to absorb it.

The rule is stated in the reliability family, at the point of use. This record exists for the
rejected option, because a developer who finds `total_max_attempts: 1` on a client and does not
know why will reasonably assume it is a mistake and remove it.

### The clamp's correct form

Verified against the boto3 documentation on 05/09/2026, and it is not what this record first said.
**In a `Config` object `max_attempts` excludes the initial request** — it counts retries — so
`retries={"max_attempts": 1}` is one request plus one retry, **two attempts**, and clamps nothing.
The single-attempt forms are `retries={"total_max_attempts": 1}` or `retries={"max_attempts": 0}`;
`total_max_attempts` exists only on `Config` and always counts total requests, which is why it is
the form this decision names.

**The same identifier means the other thing by another route**, and the doctrine has to say so:
set through `AWS_MAX_ATTEMPTS` or the AWS config file, `max_attempts` **includes** the initial
request. So `max_attempts = 3` is four attempts from a `Config` object and three from the
environment. An unconfigured client can therefore be reconfigured by an environment variable the
application never set — which makes the rule "every client constructor passes an explicit
`retries` dict" a control rather than a style preference, because only the explicit dict takes
precedence over that route.

Found by the QA gate as `AC-GAP-1` (`project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`)
and corrected in the same pass across this record, `project-management/src/02-STORIES/US005.md`
and `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` node `N-008`.

## Consequences

- **Positive:** Every operation's retry budget is readable at one site and computable to a total
  age. `S-05`'s `retry-discipline.sh` has something checkable to check. The four contradicting
  budgets have a single authority to be reconciled against.
- **Negative / trade-off:** Transport-level failures the SDK would have absorbed now reach the
  application layer, and each SDK client needs explicit clamping. Until `S-05`'s gate ships, a new
  client added without that configuration silently inherits the vendor default and breaches this
  rule — the one failure mode this decision creates rather than removes.
- **Follow-on:** The delegation escape hatch needs the register row to write into, which is
  `S-09`'s `how-to/src/OUTBOUND-TIMEOUTS.md` and its retry-owner column — so this ADR's exception
  path is inert until that slice ships. The enforcement is `S-05`'s. Revisit if a wired client
  demonstrates a transport failure class the application layer handles measurably worse.
