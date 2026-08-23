---
workflow: 14-logging-checks
phase: design
skills: [logging, gdpr-mechanics, global-workflow]
model: fable
---

# Logging Checks — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

| Step   | Reference                                                                     |
| ------ | ----------------------------------------------------------------------------- |
| All    | `code/docs/LOGGING.md` — channels, levels, structured fields (**hard gate**)  |
| Step 1 | The story's FLAGS table → `Logging` row                                       |
| Step 3 | `src/13-API-DESIGN/PLANNING/API-PLAN-US###-*.md` — the endpoint list          |
| Step 4 | `src/04-DATABASE/USER-STORY-IDEAS/DB-IDEA-US###-*.md` — the `[enc]` marks     |
| Step 4 | `src/09-GDPR/PLANNING/GDPR-PLAN-US###-*.md` — the PII classification          |
| Step 4 | `code/docs/security/AUDIT-TRAIL.md` — what belongs in the audit trail instead |

---

## Prerequisites

- [ ] The story's `Logging` flag is **not** `N/A` — if it is, skip this gate entirely
- [ ] `13-api-design` complete for this story
- [ ] `04-database-schema` complete for this story
- [ ] `code/docs/LOGGING.md` read

---

### Step 1 — Confirm the flag and grill the surface

> **Model:** fable

Read the story's `Logging` flag. It carries the event shortlist the map or the story proposed —
treat it as the first draft, not the answer.

**Grill before drafting** (`.claude/CLAUDE.md` Section 10): which failures would a human
actually act on; where the `ERROR`/`WARNING` line sits for this story; whether any proposed
event is really an **audit record** rather than a log line; whether a retention period exists.

_Done when the flag is confirmed, the event set is agreed, and anything belonging in the audit
trail has been routed to `code/docs/security/AUDIT-TRAIL.md` instead._

### Step 2 — Copy the template

> **Model:** opus

Copy `src/14-LOGGING/PLANNING/LOGGING-PLAN-US000-TEMPLATE.md` to
`src/14-LOGGING/PLANNING/LOGGING-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`. Never start from scratch.

### Step 3 — Name the loggers and the events

> **Model:** fable

Fill Section 1 (one row per module that logs, always `logging.getLogger("apps.<app>")`) and
Section 2 (one row per event: level, trigger, and the **exhaustive** field list).

Work from the story's endpoint list and service functions — an event with no call site is an
event nobody will write.

_Done when every event has a level and a named field list, and no row says "context"._

### Step 4 — Build the exclusion table

> **Model:** fable

Fill Section 3 (the safe-field allowlist) and Section 4 (the exclusions). Section 4 is
**derived, not invented**: every field marked `[enc]` in the story's schema design, plus every
PII attribute in its GDPR plan, gets a row naming the field and the surface it is barred from.

Then ask the question the table is easy to miss: **can a stack trace leak one of these?** An
exception whose `str()` interpolates a personal value publishes it at `ERROR`. Where that is
reachable, name the exception and how it is caught.

_Done when every `[enc]` field in the story's schema appears, and the stack-trace question is
answered rather than skipped._

### Step 5 — State channels and retention

> **Model:** fable

Fill Section 5. Retention is a **business and legal decision** — if none is set, mark the row
`TBD` and raise it in the story's GDPR plan. Do not invent a number.

### Step 6 — Raise the gaps, sync the story

> **Model:** opus

Record any unresolved question as `LOG-GAP-n` in Section 6. Update the story's
`### Logging Acceptance Criteria` so it matches this plan — the two drift the moment one is
edited alone.

_Done when the plan and the story say the same thing._

### Step 7 — Close out

> **Model:** opus

- Confirm every `[OPEN]` gap is resolved or fed back into `US###.md`
- Confirm nothing here verifies a running system — that is `22-implementation-documentation`
- Satisfy `CHECKLIST.md`

Next: `15-decisions/`, which closes the story's specify loop.
