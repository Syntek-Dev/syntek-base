# Workflow: Sprint Plans

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/15-sprint-plans/
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

- [ ] GDPR compliance review complete (`workflows/09-gdpr-compliance`)
- [ ] Security checks complete (`workflows/10-security-checks`)
- [ ] QA checks complete (`workflows/11-qa-checks`)
- [ ] All in-scope user stories have complete acceptance criteria

## Key concepts

- Sprint plan documents live in `project-management/src/15-SPRINT-PLANS/`
- Naming: `SPRINT-PLAN-##.md` (2-digit zero-padded sprint number)
- Each plan records: goal, stories (MoSCoW), phase breakdown, and definition of done
- Development phases within a sprint: backend → API → frontend → PR & review
- The sprint plan is the single source of truth for what is in scope and how it is sequenced

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/PLANNING-GUIDE.md` — MoSCoW format and phase breakdown must be correct before writing any sprint plan

### Soft references — consult during execution

- `project-management/src/15-SPRINT-PLANS/` — sprint plan documents
- `project-management/src/02-STORIES/` — story backlog
- `project-management/src/09-GDPR/` — GDPR review output
- `project-management/src/10-SECURITY/` — security review output
- `project-management/src/11-QA/` — QA scenario documents
- `project-management/src/12-SEO/` — SEO docs required per CHECKLIST before sprint planning
- `project-management/src/13-API-DESIGN/` — API design docs required per CHECKLIST
- `project-management/docs/GIT-GUIDE.md` — branch strategy and PR gates that govern the sprint's development phase
- `project-management/docs/VERSIONING-GUIDE.md` — version bump on release
