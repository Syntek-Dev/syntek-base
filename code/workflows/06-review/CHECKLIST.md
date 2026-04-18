# Code Review — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] Tests green
- [ ] Linters clean (ruff, ESLint, markdownlint)

---

## Execution Checklist

- [ ] Coding principles followed — functions single-purpose, files under 750 lines
- [ ] All mutations verify authentication and permissions explicitly
- [ ] No user-supplied IDs used without ownership verification (no IDOR)
- [ ] Backend coverage ≥ 75% (≥ 90% for auth modules)
- [ ] Frontend coverage ≥ 70%
- [ ] No hardcoded secrets or credentials
- [ ] No bare `except:` — exceptions caught as `except (A, B):`
- [ ] No inline imports without documented reason
- [ ] Security agent findings addressed
- [ ] QA agent confirmed no regressions

---

## Definition of Done

- [ ] All review findings resolved or explicitly accepted with rationale
- [ ] Review notes saved to `project-management/src/REVIEWS/` if significant findings were made
- [ ] Committed and pushed
