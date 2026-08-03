# code/src/improvement-architecture — Architecture Review Reports

Self-contained HTML architecture-review reports written by the `improve-codebase-architecture`
skill (`/improve-codebase-architecture`). Each run writes a fresh timestamped file here, so the
folder accumulates a local **history of past architecture states** — which deepening opportunities
were surfaced, and when.

> **Reports are gitignored, never committed.** Only this `CONTEXT.md`, `CLAUDE.md`, `.gitignore`,
> and `.gitkeep` are tracked. The history lives on each developer's machine, not in the repo.

## What goes here

| File                                   | Written by                            | Contains                                                               |
| -------------------------------------- | ------------------------------------- | ---------------------------------------------------------------------- |
| `architecture-review-<timestamp>.html` | `improve-codebase-architecture` skill | One deepening-opportunities report (self-contained Tailwind + Mermaid) |

All `*.html` here are gitignored. Each report is self-contained (Tailwind + Mermaid via CDN) — open
it in a browser directly.

## What does NOT go here

- The skill definition + report format → `.claude/skills/improve-codebase-architecture/`
- A resolved decision from a review → a decision record in the project's decision register
- Refactor notes → `project-management/src/21-REFACTORING/`
- Runtime application logs → `code/src/logs/`

## Opening a report

```bash
# newest report, opened in the default browser
xdg-open "$(ls -t code/src/improvement-architecture/*.html | head -1)"   # Linux
# open <path> (macOS) · start <path> (Windows)
```

## Cross-references

- `.claude/skills/improve-codebase-architecture/SKILL.md` — the skill that writes these reports
- `.claude/skills/codebase-design/SKILL.md` — the vocabulary the reports use
- the project's decision register — where a decision surfaced by a review is recorded
