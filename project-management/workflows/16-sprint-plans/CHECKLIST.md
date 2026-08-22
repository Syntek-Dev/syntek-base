---
workflow: 16-sprint-plans
phase: design
skills: [sprint, global-workflow]
model: fable
---

# Sprint Plans — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (PLANNING-GUIDE.md) · **External — Agile & Project Management** (MoSCoW, Definition of Done) · **Internal — Live Artefacts** (src/16-SPRINT-PLANS/) for supporting references.

## Execution Checklist

- [ ] GDPR review complete and documented for every in-scope story whose `GDPR` flag is not `N/A`
- [ ] Security checks complete with no unresolved HIGH/CRITICAL findings
- [ ] QA documents exist for every in-scope story whose `QA` flag is not `N/A`
- [ ] SEO documents exist for every in-scope story whose `SEO` flag is not `N/A`
- [ ] API design documents exist for every in-scope story whose `API` flag is not `N/A`
- [ ] Logging plans exist for every in-scope story whose `Logging` flag is not `N/A`
- [ ] Every skipped gate is skipped because its flag reads `N/A`, not because it was forgotten
- [ ] All in-scope stories have complete acceptance criteria
- [ ] Stories selected and prioritised using MoSCoW
- [ ] Each story mapped to its development phases (backend / API / frontend)
- [ ] Sprint plan document created: `SPRINT-PLAN-##.md` in `project-management/src/16-SPRINT-PLANS/`
- [ ] Sprint goal is clearly stated in one sentence
- [ ] Phase breakdown defines which stories are addressed in each phase
- [ ] Definition of Done recorded in the sprint plan

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] `SPRINT-PLAN-##.md` committed and pushed
- [ ] All developers have reviewed the plan
- [ ] Ready to proceed to `workflows/17-story-plans`
