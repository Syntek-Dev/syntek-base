---
workflow: 11-refactor
phase: build
agent: refactor
skills: [codebase-design, improve-codebase-architecture, stack-django, stack-htmx-templates]
model: opus
---

# Refactor — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (CODING-PRINCIPLES.md, ARCHITECTURE-PATTERNS.md) · **External — Code Quality** for supporting references.

## Pre-Conditions

- [ ] Tests green before starting
- [ ] No behaviour changes included — bugs fixed separately in `code/workflows/10-debug/`

---

## Execution Checklist

- [ ] All functions have a single, clear purpose · _opus_
- [ ] No file exceeds 750 lines · _opus_
- [ ] Business logic is in service classes, not resolvers; named access rules use Policy classes, variant algorithms use Strategy classes · _opus_
- [ ] No inline imports without a documented reason · _opus_
- [ ] All tests still pass after refactoring · _opus_
- [ ] Coverage not reduced · _opus_
- [ ] No new linter warnings introduced · _opus_

### CSS refactoring (apply when CSS files are in scope)

- [ ] No hardcoded typography, colour, spacing, or shadow values — all use `var(--token-*)` from `shared/src/css/tokens/` · _opus_
- [ ] No declaration block repeated in 4+ distinct files — extracted to a shared utility class in `utility.css` or a section layer file · _opus_
- [ ] Logical properties used throughout — `margin-block-end`, `padding-inline`, `border-block-start` etc.; no `margin-bottom`, `padding-left`, `border-top` · _opus_
- [ ] No per-component `outline: none; box-shadow: var(--shadow-focus)` focus ring — the global rule in `base/reset.css` handles all focus states · _opus_
- [ ] Component CSS files style only their own component — no re-declaration of another component's internals · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Behaviour is identical to before the refactor — verified by passing tests
- [ ] Refactoring notes saved to `project-management/src/21-REFACTORING/` if the change is significant
- [ ] Committed and pushed
