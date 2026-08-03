---
workflow: 07-review
phase: verify
agent: review
skills: [codebase-design, improve-codebase-architecture, stack-django, stack-htmx-templates]
model: opus
---

# Code Review — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (CODING-PRINCIPLES.md, SECURITY.md, TESTING.md) · **External — Code Quality** · **External — Security & Standards** for supporting references.

## Pre-Conditions

- [ ] Tests green
- [ ] Linters clean (ruff, ESLint, markdownlint)

---

## Execution Checklist

- [ ] Coding principles followed — functions single-purpose, files under 750 lines · _opus_
- [ ] All mutations verify authentication and permissions explicitly via a named Policy class · _opus_
- [ ] No user-supplied IDs used without ownership verification (no IDOR) · _opus_
- [ ] Coverage ≥ 75% line and branch (≥ 90% for auth modules) — one floor, all layers · _opus_
- [ ] No hardcoded secrets or credentials · _opus_
- [ ] No bare `except:` — exceptions caught as `except (A, B):` · _opus_
- [ ] No inline imports without documented reason · _opus_
- [ ] Security agent findings addressed · _opus_
- [ ] QA agent confirmed no regressions · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All review findings resolved or explicitly accepted with rationale
- [ ] Review notes saved to `project-management/src/18-REVIEWS/` if significant findings were made
- [ ] Committed and pushed
