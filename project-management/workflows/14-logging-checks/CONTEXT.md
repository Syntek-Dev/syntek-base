# Workflow 14 — Logging Checks

**Last Updated**: <%DATE%>

Logging designed after the incident is designed by whoever hit it first. This gate decides the
log surface while the endpoint list and the schema's `[enc]` marks are still in hand.

## Directory Tree

```text
project-management/workflows/14-logging-checks/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

Set a story's **log surface before its code is written** — which named loggers it adds, one row
per event with its level and exact field list, and every `[enc]` or PII attribute that must
never appear in a line. The output is `LOGGING-PLAN-US###-<DESCRIPTOR>.md` in
`src/14-LOGGING/PLANNING/`.

## Why it sits at 14, after the API design

The plan needs two upstream facts that only exist by `13`:

- **The endpoint list** (`13-api-design`) — you cannot name the events a request path emits
  before the request paths are decided.
- **The `[enc]` marks** (`04-database-schema`) — the exclusion table is drawn from the schema's
  own PII classification, not guessed.

Placed earlier, this gate would specify log lines for code whose shape is still open.

## This workflow plans — it does not verify

| Concern                                         | Owner                                  |
| ----------------------------------------------- | -------------------------------------- |
| The planned log surface, before the code exists | **here** (`14-logging-checks`)         |
| Emitting it                                     | `19-backend-code` · `21-frontend-code` |
| Proving what shipped, and that nothing leaked   | `22-implementation-documentation`      |

## When to use this

- During a story's pass through the specify tier, when its `Logging` flag is not `N/A`
- After `13-api-design`, before `15-decisions` closes the story's loop

## When NOT to use this

- To audit a running system's logs — that is `22-implementation-documentation`, or an incident
- For a story whose `Logging` flag is `N/A` — record the reason in the flag row and move on
- To design the **audit trail** — that is a database write with its own schema and retention
  (`code/docs/security/AUDIT-TRAIL.md`), not a log line

## Key concepts

- **Identifiers, never values.** A line carries `<entity>_id` and `action`. It never carries a
  name, an email, a token, or the plaintext of an `[enc]` field. Every rule here serves that one.
- **The field list is exhaustive.** A field not named in the plan does not appear in the line.
  "Log the request context" is not a plan.
- **A log line is not an audit record.** Planning one as the other produces an audit trail that
  rotates away in fourteen days.
- **Stack traces leak too.** An exception whose `str()` interpolates a personal value publishes
  it at `ERROR`. Where that is reachable, the plan says which exception and how it is handled.
- **Retention is a business decision.** If nobody has set one, raise it in the story's GDPR plan
  rather than inventing a number.

## Cross-references

### Governing documents

- `code/docs/LOGGING.md` — channels, levels, structured fields; the standard this gate plans to
- `code/docs/security/AUDIT-TRAIL.md` — the audit record, and why it is not this

### Related reading

- `project-management/src/14-LOGGING/PLANNING/` — where the plan lands
- `project-management/src/13-API-DESIGN/PLANNING/` — the endpoint list the events hang off
- `project-management/src/04-DATABASE/USER-STORY-IDEAS/` — the schema's `[enc]` marks
- `project-management/src/09-GDPR/PLANNING/` — the PII classification the exclusions are drawn from
- Story file `### Logging Acceptance Criteria` — kept consistent with this plan
- `project-management/workflows/22-implementation-documentation/` — writes the
  `IMPLEMENTATION/` record and runs the leak check
