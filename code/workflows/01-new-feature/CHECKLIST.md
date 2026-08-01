---
workflow: 01-new-feature
phase: build
agent: feature
skills: [stack-django, stack-htmx-templates, global-workflow]
model: opus
---

# Add a New Full-Stack Feature — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** · **External — Testing** · **External — Security & Standards** for supporting references.

## Pre-Conditions

- [ ] Branch is up to date with `dev`
- [ ] No uncommitted changes from a previous workflow
- [ ] User story exists and is clear
- [ ] `/GAPS.md` checked — no blocking gaps

---

## Execution Checklist

- [ ] Architectural plan saved to `project-management/src/15-STORY-PLANS/` · _opus_
- [ ] Failing tests written before implementation · _opus_
- [ ] Models and migration created and applied · _opus_
- [ ] Service layer implemented with `transaction.atomic()` on multi-write methods · _opus_
- [ ] Django Ninja endpoints and Schema models added; every state-changing endpoint checks permissions · _opus_
- [ ] Ninja Schema request/response models defined for any machine-facing endpoint (drive the `/api/docs` OpenAPI schema) · _opus_
- [ ] OpenAPI schema committed if an endpoint changed — diffed for breaking changes · _opus_
- [ ] Frontend template, components, and HTMX partials implemented · _opus_
- [ ] All tests are green (one pytest run covers services, endpoints, templates, partials) · _opus_
- [ ] Accessibility verified (WCAG 2.2 AA) — markup rules asserted in pytest, the rest walked manually · _opus_
- [ ] Code review and QA passed · _opus_
- [ ] No new linting errors · _opus_

---

## Documentation closeout — verified, not written here

Workflow 19 writes these; this checklist only confirms they exist before the PR. The record
formats, templates, and destinations live in
`project-management/workflows/19-implementation-documentation/` — never restate them here.

- [ ] `project-management/workflows/19-implementation-documentation/` run to completion for this story · _opus_
- [ ] Its `CHECKLIST.md` fully satisfied — every applicable IMPLEMENTATION record written from template and linked to `US###` · _opus_
- [ ] No spec left with a `PLANNING/` artefact but no `IMPLEMENTATION/` record · _opus_
- [ ] Findings record written to `project-management/src/18-FINDINGS/` (even if nothing was found) · _opus_
- [ ] `/GAPS.md` and `/DEFERRED.md` updated from those findings · _opus_
- [ ] Touched `CONTEXT.md`/`CLAUDE.md` complete and the code-review-graph refreshed — hard gate before commit (`.claude/CLAUDE.md` §6) · _opus_

### Owned by this layer

- [ ] Bruno API tests written for each new/changed Django Ninja endpoint (`.bru` files → `code/src/tests/api/<domain>/`) if the story adds or changes the Django Ninja API · _opus_

---

## Definition of Done

- [ ] Primary objective of the user story achieved
- [ ] All artefacts committed and pushed
- [ ] `git` run with accurate commit message
- [ ] Open issues from implementation docs logged in `/GAPS.md` (security, architectural, infrastructure gaps)
- [ ] Cross-story deferred items logged in `/DEFERRED.md`
- [ ] User story updated with completion status
