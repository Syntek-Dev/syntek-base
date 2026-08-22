# project-management/src/14-LOGGING

Per-story logging specifications — what a story must emit, at which level, carrying which
fields, and what must never reach a log line. Two stages: `PLANNING/` sets the log surface
before the code exists; `IMPLEMENTATION/` records what was actually emitted and proves the
leak checks.

## Directory Tree

```text
project-management/src/14-LOGGING/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules for this folder
├── PLANNING/                 ← pre-implementation: the planned log surface, per story
│   ├── CONTEXT.md
│   ├── CLAUDE.md
│   └── LOGGING-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/           ← post-implementation: what shipped, and the leak evidence
    ├── CONTEXT.md
    ├── CLAUDE.md
    └── LOGGING-IMPL-US000-TEMPLATE.md
```

**Naming:** `LOGGING-PLAN-US###-<DESCRIPTOR>.md` · `LOGGING-IMPL-US###-<DESCRIPTOR>.md` —
descriptors in `SCREAMING-KEBAB-CASE`, dates DD/MM/YYYY.

## Why this exists

Logging designed after the fact is logging designed by whoever hit the incident first — a
scatter of `INFO` lines that answer last week's question and none of next week's. Worse, it is
where personal data leaks: a debugging line added under pressure prints the object, and the
object holds an encrypted field's decrypted value.

Planning the log surface with the endpoint list and the schema's `[enc]` marks already in hand
makes both problems design problems rather than incident problems.

## What a plan holds

| Section         | Holds                                                                 |
| --------------- | --------------------------------------------------------------------- |
| **Loggers**     | The named logger per module — `logging.getLogger("apps.<app>")`       |
| **Events**      | One row per logged event: level, trigger, and the fields it carries   |
| **Safe fields** | The IDs and enums permitted in each line — never values               |
| **Exclusions**  | Every `[enc]` field and PII attribute that must not appear, and where |
| **Retention**   | How long each channel holds a line, and who can read it               |

## When each stage is written

| Stage             | Written by                        | When                                       |
| ----------------- | --------------------------------- | ------------------------------------------ |
| `PLANNING/`       | `14-logging-checks`               | In the specify loop, after `13-api-design` |
| `IMPLEMENTATION/` | `22-implementation-documentation` | During PR review, against shipped code     |

## Cross-references

- `code/docs/LOGGING.md` — the governing standard: channels, levels, structured fields
- `code/docs/security/AUDIT-TRAIL.md` — the audit record, which is **not** a log line
- `../09-GDPR/` — the PII classification these exclusions are drawn from
- `../04-DATABASE/` — the schema's `[enc]` marks
- `project-management/workflows/14-logging-checks/` — the workflow that produces these

**Last Updated**: <%DATE%>
