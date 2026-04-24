# Contributing to project-name

Thank you for taking the time to contribute. This project is MIT-licensed and welcomes issues,
pull requests, and template adaptations from anyone.

---

## Quick links

| Guide                                                          | Purpose                                          |
| -------------------------------------------------------------- | ------------------------------------------------ |
| [Getting Started](how-to/src/GETTING-STARTED.md)               | First steps — clone, configure, run              |
| [Branch Guide](how-to/src/BRANCH-GUIDE.md)                     | Branch naming and promotion flow                 |
| [Commit Guide](how-to/src/COMMIT-GUIDE.md)                     | Conventional Commits format and rules            |
| [PR Guide](how-to/src/PR-GUIDE.md)                             | Opening, reviewing, and merging pull requests    |
| [Issue Reporting](how-to/src/ISSUE-REPORTING.md)               | Reporting bugs and requesting features           |
| [Code Review](how-to/src/CODE-REVIEW.md)                       | Reviewer checklist and feedback standards        |
| [Customising the Template](how-to/src/CUSTOMISING-TEMPLATE.md) | Adapting this as the base for your own project   |
| [Claude Multilayer Guide](how-to/src/CLAUDE-MULTILAYER.md)     | Using Claude Code with the three-layer structure |

---

## Before you start

- All development runs inside Docker. See [Getting Started](how-to/src/GETTING-STARTED.md).
- Every feature branch must correspond to a user story in `project-management/src/STORIES/`.
- Branches target `testing` first — never `dev`, `staging`, or `main` directly.
- Run lint, type-checks, and tests before every push. CI enforces the same gates.

---

## Reporting issues

Please read [Issue Reporting](how-to/src/ISSUE-REPORTING.md) before opening a ticket.

---

## Licence

By contributing, you agree that your contributions will be released under the
[MIT Licence](LICENSE) that covers this project.
