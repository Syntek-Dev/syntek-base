# Workflow: QA Checks

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
project-management/workflows/10-qa-checks/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow after security checks and before sprint planning to:

- Review wireframes and user flows for testability
- Identify edge cases, error states, and boundary conditions from the designs
- Produce a QA plan for each user story in the upcoming sprint

## Prerequisites

- [ ] Wireframes signed off in `project-management/src/07-WIREFRAMES/`
- [ ] Security checks complete (`workflows/09-security-checks`)

## Key concepts

- QA is planned at design stage — test scenarios are derived from wireframes, not from completed code
- Each user story gets a `QA-US###-<DESCRIPTION>.md` file in `project-management/src/10-QA/`
- Edge cases and error states identified here feed directly into story acceptance criteria
- QA documents created here are later used as the basis for writing automated and manual tests

## Cross-references

- `project-management/src/10-QA/` — QA documents output
- `project-management/src/01-STORIES/` — user stories to map QA scenarios against
- `project-management/src/07-WIREFRAMES/` — wireframes under review
- `project-management/docs/GIT-GUIDE.md` — commit and PR conventions
