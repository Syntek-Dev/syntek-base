---
story: "{US###}"
title: "{STORY TITLE}"
status: "{Draft | Verified | Signed off}"
version: "{0.1.0}"
created: "{DD/MM/YYYY}"
---

# Logging Record — {US###}: {STORY TITLE}

_Template — copy to `LOGGING-IMPL-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row and
`{PLACEHOLDER}` with this story's measured outcome, and delete this note once populated. This is
the **post-implementation** record; its plan is
`../PLANNING/LOGGING-PLAN-US###-<DESCRIPTOR>.md`._

| Field      | Value                                            |
| ---------- | ------------------------------------------------ |
| **Story**  | US### — {short title}                            |
| **Date**   | {DD/MM/YYYY}                                     |
| **Plan**   | `../PLANNING/LOGGING-PLAN-US###-<DESCRIPTOR>.md` |
| **Commit** | `{sha}`                                          |
| **Status** | Draft / Verified / Signed off                    |

---

## 1. Planned events — verdict per row

Every row from the plan's Section 2, with what shipped. **A divergence is recorded with its
reason, never silently accepted** — that is how the next plan gets better.

| Event                          | Planned level | Shipped level | Fields match? | Verdict / reason                  |
| ------------------------------ | ------------- | ------------- | ------------- | --------------------------------- |
| [EXAMPLE] `{operation}.ok`     | `INFO`        | `INFO`        | yes           | As planned                        |
| [EXAMPLE] `{operation}.denied` | `WARNING`     | `WARNING`     | no            | [EXAMPLE] added `{field}` — {why} |

## 2. Unplanned events

Anything the code logs that the plan did not name.

| Event         | Level         | Fields        | Why it was added | Should the plan have had it? |
| ------------- | ------------- | ------------- | ---------------- | ---------------------------- |
| [PLACEHOLDER] | [PLACEHOLDER] | [PLACEHOLDER] | [PLACEHOLDER]    | [PLACEHOLDER]                |

---

## 3. Exclusion check — the evidence

**Paste the command and its real output.** A summary is not evidence, and an unrun check is
reported as unrun, never as clean (`code/docs/GATE-REPORTING.md`).

Exercise every flow the story adds, then grep the log for each excluded field from the plan's
Section 4.

```text
$ [EXAMPLE] grep -c '{excluded-value}' code/src/logs/django.log
0
```

| Excluded field              | Command run   | Result        | Clean? |
| --------------------------- | ------------- | ------------- | ------ |
| [EXAMPLE] `{email}` `[enc]` | [EXAMPLE] {…} | [EXAMPLE] `0` | yes    |

**Redact before pasting.** If a log line must be quoted, remove the personal value and say what
was removed — this record is committed.

### Committed-code checks

- [ ] No bare `print()` on any server path added by this story
- [ ] No `console.*` in any JavaScript committed by this story
- [ ] Every log call uses the named logger from the plan's Section 1
- [ ] No `[enc]` field value reachable through an exception's `str()` at `ERROR`

---

## 4. Channels as shipped

| Channel       | Configured as planned? | Divergence / reason |
| ------------- | ---------------------- | ------------------- |
| [PLACEHOLDER] | [PLACEHOLDER]          | [PLACEHOLDER]       |

---

## 5. Follow-ups

Anything this record surfaces that the story does not close — routed to `GAPS.md`,
`DEFERRED.md`, or `../../20-FINDINGS/` by `22-implementation-documentation`.

| Item          | Routed to     | Target        |
| ------------- | ------------- | ------------- |
| [PLACEHOLDER] | [PLACEHOLDER] | [PLACEHOLDER] |

---

## Cross-references

- `../PLANNING/LOGGING-PLAN-US###-<DESCRIPTOR>.md` — the plan this closes
- `code/docs/LOGGING.md` — the governing standard
- `code/docs/GATE-REPORTING.md` — why an unrun check is never reported as a clean one
- `../../18-TESTS/US###-TEST-STATUS.md` · `../../19-REVIEWS/` — the sibling records
