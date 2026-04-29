# Workflow: Sprint Plans

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
project-management/workflows/11-sprint-plans/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow after GDPR, security, and QA checks are complete and before development begins.
It produces a sprint plan document that:

- Selects and prioritises the stories entering the sprint
- Assigns each story to a development phase (backend → API → frontend)
- Records acceptance criteria, QA scenarios, and definition of done per story
- Captures any outstanding design or security constraints developers must respect

## Prerequisites

- [ ] GDPR compliance review complete (`workflows/08-gdpr-compliance`)
- [ ] Security checks complete (`workflows/09-security-checks`)
- [ ] QA checks complete (`workflows/10-qa-checks`)
- [ ] All in-scope user stories have complete acceptance criteria

## Key concepts

- Sprint plan documents live in `project-management/src/11-SPRINT-PLANS/`
- Naming: `SPRINT-PLAN-##.md` (2-digit zero-padded sprint number)
- Each plan records: goal, stories (MoSCoW), phase breakdown, and definition of done
- Development phases within a sprint: backend → API → frontend → PR & review
- The sprint plan is the single source of truth for what is in scope and how it is sequenced

## Cross-references

- `project-management/src/11-SPRINT-PLANS/` — sprint plan documents
- `project-management/src/01-STORIES/` — story backlog
- `project-management/src/08-GDPR/` — GDPR review output
- `project-management/src/09-SECURITY/` — security review output
- `project-management/src/10-QA/` — QA scenario documents
- `project-management/docs/VERSIONING-GUIDE.md` — version bump on release
