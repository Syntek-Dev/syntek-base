---
type: guide
skills: [backend, stack-django, database]
model: opus
---

# Idempotency

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — the run-twice contract, the proof ladder, and the run-twice test

Part of the reliability family — [`../RELIABILITY.md`](../RELIABILITY.md) is its index, and
states why this rule and the retry rule are decided together.

## The contract

**Every operation that can run twice is written so that running it twice has the same effect as
running it once.** This is the contract, not defensive style. A retry after a timeout, a message
redelivered by its broker, a webhook replayed by its sender, a task re-queued after its worker
died, a command re-run by an operator, a tool call re-sent by an agent — each produces a second
run of an operation that may already have done its work.

## Proving it — the ladder

An operation **proves** idempotency by answering "has this already been done?" from durable
state. In descending order of preference:

1. **A database constraint.** Attempt the write against a natural key with a `UNIQUE`
   constraint and treat the violation as "already done". Never check-then-write: that is a
   race, and the constraint is what makes the invariant true ([`../DATABASE.md`](../DATABASE.md)).
2. **A conditional state transition.** An update that both matches the expected state and
   sets the new one, judged by the number of rows it changed, is idempotent. Reading the
   state and then writing it is not.
3. **An idempotency key for an external effect.** Where the effect leaves the database (an
   email, a webhook, a payment), record the effect and its key in the same transaction, and
   send the key to the remote so its own de-duplication can do the rest.

## The acceptance test

**The acceptance test for an idempotent operation is the operation run twice**, against the same
input, asserting the same end state and exactly one external effect. An operation without that
test is not known to be idempotent, it is only hoped to be.

## Per-surface expression

A surface guide adds what its transport changes about the contract and routes here for the rest.

| Surface          | What the surface adds, and where it is stated                                                                                                                                                                                    |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Background tasks | The delivery guarantee as a configured choice, the broker outside the cache's eviction, arguments re-read at run time, signature change as a two-release change — [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md) → _Idempotency_ |

A surface with no row applies this guide unmodified.

## Cross-references

- [`RETRIES.md`](RETRIES.md): when a failed operation is run again
- [`BUDGETS.md`](BUDGETS.md): how often, and for how long
- [`../DATABASE.md`](../DATABASE.md): constraints, and why an invariant lives in the database
- [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md): the task surface's expression of this contract

_Part of the `code/docs/` documentation family._
