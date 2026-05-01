# Workflow: Sprint Planning

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
project-management/workflows/02-sprint-planning/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow at the start of each sprint to select, prioritise, and plan user stories.
No sprint should begin without a completed sprint file.

## Prerequisites

- [ ] A backlog of user stories exists in `project-management/src/01-STORIES/`
- [ ] Each candidate story is marked `Status: Ready` and has no incomplete prerequisites
- [ ] The previous sprint is closed (its Definition of Done is complete)
- [ ] The next sprint number has been confirmed by checking `project-management/src/02-SPRINTS/`

## Key concepts

- Every sprint is based on `project-management/src/02-SPRINTS/SPRINT-00-TEMPLATE.md` — never start from a blank file
- Sprints are saved as `SPRINT-##.md` (2-digit zero-padded, e.g. `SPRINT-01.md`)
- The flags table must be completed before any section is written — flags are rolled up from the stories selected for the sprint
- The Frontend flag must specify `Web`, `Mobile`, or `Web + Mobile` — never just `Yes`
- Sections marked `N/A` in the flags table must be removed from the file entirely
- The Story Summary table replaces the User Story section — it lists every story in the sprint with ID, Title, MoSCoW, and SP
- The Acceptance Criteria and Task sections are sprint-level rollups — detailed implementation lives in the individual story files
- The Verification Checks and Definition of Done sections must always be present

## Template sections and flags

| Flag      | When to set                                         | Sections it controls                            |
| --------- | --------------------------------------------------- | ----------------------------------------------- |
| DB        | Any story in the sprint creates or modifies a model | DB Acceptance Criteria · DB Tasks               |
| User Flow | Any story introduces a new user journey             | User Flow Acceptance Criteria · User Flow Tasks |
| Backend   | Any story involves service layer work               | Backend Acceptance Criteria · Backend Tasks     |
| API       | Any story changes the GraphQL schema                | API Acceptance Criteria · API Tasks             |
| Frontend  | Any story has UI work — Web / Mobile / Web + Mobile | Frontend Acceptance Criteria · Frontend Tasks   |
| GDPR      | Any story processes personal data                   | GDPR Acceptance Criteria · GDPR Tasks           |
| Security  | Any story has a security concern                    | Security Acceptance Criteria · Security Tasks   |
| Testing   | Any story requires tests                            | Testing Acceptance Criteria · Testing Tasks     |

## Cross-references

- `project-management/src/02-SPRINTS/SPRINT-00-TEMPLATE.md` — sprint template (always use this as the base)
- `project-management/src/01-STORIES/` — story backlog
- `project-management/src/02-SPRINTS/` — sprint history
- `project-management/docs/SPRINT-PLANNING-GUIDE.md` — capacity and MoSCoW guidance
- `project-management/docs/VERSIONING-GUIDE.md` — sprint numbering rules
