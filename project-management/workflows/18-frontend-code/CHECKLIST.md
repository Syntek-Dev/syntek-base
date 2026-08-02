---
workflow: 18-frontend-code
phase: build
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Frontend Code — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (coding-principles/STYLE-AND-PROCESS.md, ACCESSIBILITY.md, responsive/BREAKPOINTS.md, responsive/CONTAINER-QUERIES.md, rendering/TEMPLATES-AND-INTERACTIVITY.md, performance/FRONTEND-PERFORMANCE.md, testing/FRONTEND-TESTING.md) · **External — Framework & Language Docs → Frontend** · **External — Testing** for supporting references.

## Execution Checklist

- [ ] `code/CONTEXT.md` read — Django + django-components conventions applied
- [ ] `code/docs/coding-principles/STYLE-AND-PROCESS.md` read — component naming and design rules applied
- [ ] `code/docs/ACCESSIBILITY.md` read — WCAG 2.2 AA requirements noted for all interactive components
- [ ] `code/docs/performance/FRONTEND-PERFORMANCE.md` read — lazy loading and bundle size rules applied
- [ ] `code/workflows/01-new-feature/` followed — full-stack feature checklist completed
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Wireframes and component designs reviewed before implementation begins
- [ ] Existing components in `code/src/django/components/` checked before creating new ones
- [ ] Every state-changing HTMX endpoint has an explicit permission check and IDOR ownership verification, and returns the re-rendered partial on validation failure
- [ ] Pages and routes implemented per the wireframes
- [ ] All components implement every required state (default, hover, focus, disabled, error, success, empty)
- [ ] Design tokens applied via CSS custom properties — no raw hex values or hard-coded sizes
- [ ] New CSS values checked against the design-token layer (`code/src/django/apps/design_tokens/`) before hardcoding — token added via the `/admin/design-tokens` editor or a migration if missing
- [ ] No CSS declaration block repeated in 4+ files — extracted to `sections/utility.css` or a section layer
- [ ] Logical properties used (`margin-block-end`, `padding-inline`, etc.) — no physical properties in new or refactored CSS
- [ ] Component CSS does not re-declare another component's internal declarations
- [ ] No per-component focus ring — global `:focus-visible` rule in `base/reset.css` handles it
- [ ] Template, component, and HTMX-partial tests written in pytest per `code/docs/testing/FRONTEND-TESTING.md`
- [ ] Test coverage ≥ 75% line and branch — the single project floor (frontend tests are pytest tests)
- [ ] Render, loading, error, and interaction paths covered by tests
- [ ] `code/docs/ACCESSIBILITY.md` checklist completed — colour contrast, focus, ARIA, touch targets
- [ ] Golden path verified visually in the browser · _opus · MCP: claude-in-chrome_
- [ ] Edge cases (empty states, error states, loading states) verified in the browser · _opus · MCP: claude-in-chrome_
- [ ] `code/src/scripts/syntax/lint.sh` passes — no lint errors
- [ ] `code/src/scripts/syntax/check.sh` passes — no type errors

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All acceptance criteria from the user story are covered by passing tests
- [ ] WCAG 2.2 AA compliance confirmed on all interactive components
- [ ] Code committed and pushed
- [ ] Ready for `20-pr-and-review/`
