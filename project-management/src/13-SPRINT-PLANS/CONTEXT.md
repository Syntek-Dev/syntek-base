# project-management/src/13-SPRINT-PLANS

Sprint plan documents — one per sprint, written after GDPR, security, and QA checks.

## Directory Tree

```text
project-management/src/13-SPRINT-PLANS/
├── CONTEXT.md               ← this file
└── SPRINT-PLAN-##.md        ← sprint plan per sprint (e.g. SPRINT-PLAN-01.md)
```

**Naming:** `SPRINT-PLAN-##.md` (2-digit zero-padded sprint number)

## Contents

Each sprint plan records:

- **Sprint goal** — one-sentence statement of what the sprint delivers
- **Stories** — selected from `src/01-STORIES/`, prioritised with MoSCoW
- **Phase breakdown** — which stories are addressed in each development phase
  (backend → API → frontend → PR & review)
- **GDPR/security/QA constraints** — any requirements from the pre-sprint checks
- **Definition of Done** — criteria that must be met before the sprint closes

## When to use

- `workflows/13-sprint-plans` — the workflow that produces these documents
- Created after `src/08-GDPR/`, `src/09-SECURITY/`, and `src/10-QA/` reviews are complete
- Referenced throughout development phases (`workflows/14-backend-code` through `workflows/18-pr-and-review`)
