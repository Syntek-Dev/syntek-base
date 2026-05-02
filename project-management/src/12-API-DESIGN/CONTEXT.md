---
folder: src/12-API-DESIGN
purpose: API design artefacts produced during the design phase, before sprint planning
---

# 12-API-DESIGN

Stores the API design documents produced for each user story or feature before development begins.
These artefacts define the GraphQL contract — types, queries, mutations, subscriptions, and
permission rules — so that frontend, mobile, and backend teams share a single agreed interface
before any code is written.

## Directory Tree

```text
project-management/src/12-API-DESIGN/
├── CONTEXT.md                          ← this file
├── PLANNING/                           ← pre-workflow gap analysis reports
│   └── CONTEXT.md
└── API-US###-<descriptor>.md           ← API design documents (created per story/feature)
```

## File naming

| Pattern                         | Example                     | Used for                            |
| ------------------------------- | --------------------------- | ----------------------------------- |
| `API-US###-<descriptor>.md`     | `API-US012-user-auth.md`    | API design tied to a user story     |
| `API-<FEATURE>-<descriptor>.md` | `API-NOTIFICATIONS-push.md` | API design for a standalone feature |

## What belongs here

- GraphQL type definitions (input types, object types, enums, scalars)
- Query and mutation signatures with argument and return types
- Subscription definitions
- Permission matrix (who can call what, under what ownership rules)
- Error / exception types surfaced to the client
- Pagination strategy (relay-style cursors vs offset)
- Any breaking-change notes or deprecation decisions

## What does NOT belong here

- Implementation code → `code/src/backend/`
- Migration SQL or schema ERDs → `src/03-DATABASE/`
- User stories → `src/01-STORIES/`

## Relationship to other artefacts

- Written **after** `src/03-DATABASE/` schema is agreed and **before** `src/13-SPRINT-PLANS/`
- Feeds directly into `workflows/15-api-code/` during implementation
- Reviewed as part of `workflows/18-pr-and-review/` before merge
