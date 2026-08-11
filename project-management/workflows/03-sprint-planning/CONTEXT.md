# Workflow: Sprint Planning

**Last Updated**: <%DATE%>

The sprint record fixes the goal and the candidate scope before design work starts, so that
design is bounded by a decision rather than the other way round.

## Directory Tree

```text
project-management/workflows/03-sprint-planning/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow early in a sprint cycle to create a high-level sprint record — sprint goal,
candidate stories, and initial scope. Run it after stories exist and before design work begins.

> **Note:** This workflow produces a high-level sprint record (`SPRINT-##.md`).
> The detailed sprint plan (story assignments, phase breakdown, GDPR/security/QA constraints)
> is written later via `workflows/15-sprint-plans/`, after all pre-sprint checks are complete.

## Key concepts

- Sprint records are saved as `SPRINT-##.md` in `project-management/src/03-SPRINTS/`
- Use MoSCoW prioritisation (Must / Should / Could / Won't) to identify candidate stories
- This record captures intent; the definitive plan comes from `workflows/15-sprint-plans/`

## Cross-references

### Governing documents

- `project-management/docs/PLANNING-GUIDE.md` — MoSCoW format must be correct before writing any sprint record

### Related reading

- `project-management/src/02-STORIES/` — story backlog
- `project-management/src/03-SPRINTS/` — sprint records
- `project-management/src/15-SPRINT-PLANS/` — detailed sprint plans (written after checks)
- `project-management/workflows/15-sprint-plans/` — detailed planning workflow
- `project-management/src/09-GDPR/` — check GDPR obligations for candidate stories
- `project-management/src/10-SECURITY/` — check open security findings
- `project-management/src/11-QA/` — confirm QA docs exist
