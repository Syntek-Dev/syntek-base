# Workflow: User Story Creation

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
project-management/workflows/01-story-creation/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when you need to create a new user story before development begins.
Every feature must have a corresponding user story before any code is written.

## Prerequisites

- [ ] Feature requirements are understood
- [ ] You know the user role, goal, and benefit
- [ ] The next available story number has been confirmed by checking `project-management/src/01-STORIES/`

## Key concepts

- Every story is based on `project-management/src/01-STORIES/US000-TEMPLATE.md` — never start from a blank file
- Stories are saved as `US###.md` (3-digit zero-padded, e.g. `US001.md`)
- The template flags table must be completed before any section is written — flags drive which sections are included or removed
- The Frontend flag must specify `Web`, `Mobile`, or `Web + Mobile` — never just `Yes`
- Sections marked `N/A` in the flags table must be removed from the file entirely
- Acceptance criteria and Tasks are split by domain — each subsection maps directly to the flags set
- The Verification Checks and Definition of Done sections must always be present
- Acceptance criteria drive the test cases in `code/workflows/02-tdd-cycle/`

## Template sections and flags

| Flag      | When to set               | Sections it controls                            |
| --------- | ------------------------- | ----------------------------------------------- |
| DB        | Model created or modified | DB Acceptance Criteria · DB Tasks               |
| User Flow | UI journey exists         | User Flow Acceptance Criteria · User Flow Tasks |
| Backend   | Service layer work        | Backend Acceptance Criteria · Backend Tasks     |
| API       | GraphQL schema change     | API Acceptance Criteria · API Tasks             |
| Frontend  | Web / Mobile / both       | Frontend Acceptance Criteria · Frontend Tasks   |
| GDPR      | PII processed             | GDPR Acceptance Criteria · GDPR Tasks           |
| Security  | Security concern          | Security Acceptance Criteria · Security Tasks   |
| Testing   | Tests required            | Testing Acceptance Criteria · Testing Tasks     |

## Cross-references

- `project-management/src/01-STORIES/US000-TEMPLATE.md` — story template (always use this as the base)
- `project-management/src/01-STORIES/` — where completed stories are saved
- `project-management/docs/VERSIONING-GUIDE.md` — story numbering rules
