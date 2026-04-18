# Workflow: Add a New Full-Stack Feature

## Directory Tree

```text
code/workflows/01-new-feature/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding any new capability to the website that requires both backend
(Django/Strawberry) and frontend (Next.js) work.

## Prerequisites

- [ ] A user story exists in `project-management/src/STORIES/` covering this feature
- [ ] Branch created from `dev`: `us###/feature-name`
- [ ] No blocking items in `/GAPS.md`
- [ ] `.env.dev` is populated and containers are running

## Key concepts

- Business logic lives in Django **services**, not resolvers — keep resolvers thin
- Strawberry types go in `apps/<app>/types.py`, mutations in `apps/<app>/mutations.py`
- Frontend consumes generated TypeScript hooks from `code/src/frontend/src/graphql/generated/`
- Run `pnpm codegen` after any schema change

## Cross-references

- Coding rules: `code/docs/CODING-PRINCIPLES.md`
- Test requirements: `code/docs/TESTING.md`
- Security rules: `code/docs/SECURITY.md`
- API design: `code/docs/API-DESIGN.md`
