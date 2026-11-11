# code/docs/reliability

Sub-documents for the reliability family — the cross-surface doctrine for what happens when a call
fails and whether repeating an operation is safe. `code/docs/RELIABILITY.md` is the index.

## Directory Tree

```text
code/docs/reliability/
├── CLAUDE.md       ← operating rules
├── CONTEXT.md      ← this file
├── IDEMPOTENCY.md  ← the run-twice contract, the proof ladder, the run-twice acceptance test
└── RETRIES.md      ← classifying a failure, jittered backoff, bounds, exhaustion, the failure record
```

## Why the family is split this way

**Two sub-guides under one hub, named for the two questions.** Idempotency asks whether a second
run is safe; retrying asks when to make one. They are decided together — the hub states why — but
they grow at different rates and are read by different people: a developer writing a webhook
receiver needs the proof ladder and not the backoff curve, and one writing an HTTP client needs the
reverse. One combined guide would put both on every reader and run out of length first.

**The hub follows the house pattern** (`RLS-GUIDE.md` + `rls/`, `PERFORMANCE.md` +
`performance/`): one stable file every other guide points at, so a sub-guide can be split or
renamed later without repointing a pointer outside this family.

**Named for the doctrine, not the surface.** No file here is named for Celery, HTTP or webhooks,
because the point of the family is that the rule is the same on all of them. A surface's own
expression stays in that surface's guide — the task surface's in `code/docs/TASK-AUTHORING.md`.

## Cross-references

- `code/docs/RELIABILITY.md` — the index these sub-documents belong to
- `code/docs/TASK-AUTHORING.md` — the task surface, whose rules this family was written from
