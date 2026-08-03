# Workflow: QA Checks

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/11-qa-checks/
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

- [ ] Wireframes signed off in `project-management/src/08-WIREFRAMES/`
- [ ] Security checks complete (`workflows/10-security-checks`)

## Key concepts

- QA is planned at design stage — test scenarios are derived from wireframes, not from completed code
- Each user story gets a `QA-US###-<DESCRIPTION>.md` file in `project-management/src/11-QA/`
- Edge cases and error states identified here feed directly into story acceptance criteria
- QA documents created here are later used as the basis for writing automated and manual tests

## Cross-references

### Hard gates — read before executing Step 1

None — QA planning is pre-code; no safety gates apply.

### Soft references — consult during execution

- `project-management/src/11-QA/` — QA documents output
- `project-management/src/02-STORIES/` — user stories to map QA scenarios against
- `project-management/src/08-WIREFRAMES/` — wireframes under review
- `project-management/src/05-USER-FLOW/` — QA scenarios trace to user flow steps
- `project-management/src/10-SECURITY/` — security findings that QA must exercise
- `project-management/docs/QA-GUIDE.md` — QA scenario format, edge case categories, and acceptance criteria feedback
- `project-management/docs/GIT-GUIDE.md` — commit and PR conventions
- `code/docs/TESTING.md` — test taxonomy and coverage floors that QA scenarios feed into
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA checks that QA must cover for all interactive components
- `project-management/workflows/15-sprint-plans/` — next step after QA
