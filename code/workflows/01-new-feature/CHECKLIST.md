# Add a New Full-Stack Feature — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] Branch is up to date with `dev`
- [ ] No uncommitted changes from a previous workflow
- [ ] User story exists and is clear
- [ ] `/GAPS.md` checked — no blocking gaps

---

## Execution Checklist

- [ ] Architectural plan saved to `project-management/src/PLANS/`
- [ ] Failing tests written before implementation
- [ ] Models and migration created and applied
- [ ] Service layer implemented with `transaction.atomic()` on multi-write methods
- [ ] GraphQL types and resolvers added; every mutation checks permissions
- [ ] Schema exported and frontend types regenerated (`npm run codegen`)
- [ ] Frontend component/page implemented
- [ ] All tests are green (backend + frontend)
- [ ] Code review and QA passed
- [ ] No new linting errors

---

## Definition of Done

- [ ] Primary objective of the user story achieved
- [ ] All artefacts committed and pushed
- [ ] `/syntek-dev-suite:git` run with accurate commit message
- [ ] Any new gaps logged in `/GAPS.md`
- [ ] User story updated with completion status
