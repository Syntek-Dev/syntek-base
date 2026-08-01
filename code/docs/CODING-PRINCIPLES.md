---
type: guide
agent: code-reviewer
skills: [global-workflow]
model: opus
---

# Coding Principles

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}} **Language**:
British English (en_GB) **Timezone**: {{TIMEZONE}}
**Claude Model:** opus — Universal coding principles, SOLID, naming, error handling, before writing code

These principles apply to **all code** in this project. Derived from Rob Pike, Linus Torvalds, and
extended with practical rules for web application development. For stack-specific rules, read the
relevant companion file alongside this one:

| Stack                                  | File                                                             |
| -------------------------------------- | ---------------------------------------------------------------- |
| Django / Python / Celery               | [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md)   |
| Django templates + HTMX + Alpine + CSS | [`FRONTEND-CODING-PRINCIPLES.md`](FRONTEND-CODING-PRINCIPLES.md) |

## Sub-documents

| Document                                                                           | Covers                                                                                                                                                        |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`coding-principles/DESIGN-PRINCIPLES.md`](coding-principles/DESIGN-PRINCIPLES.md) | Rob Pike's rules, Linus Torvalds' rules, SOLID, CUPID, GRASP, Kent Beck's four rules, DDD fundamentals, package principles, Law of Demeter, Twelve-Factor App |
| [`coding-principles/PRACTICAL-RULES.md`](coding-principles/PRACTICAL-RULES.md)     | DRY/Rule of Three, KISS, YAGNI, class vs function, decision structuring (Boolean/Policy/Strategy), error handling, naming conventions, import rules           |
| [`coding-principles/STYLE-AND-PROCESS.md`](coding-principles/STYLE-AND-PROCESS.md) | Testing requirements, comments and documentation, security, dependencies, git and version control, logging, code review checklist                             |

_Part of the `code/docs/` documentation family._
