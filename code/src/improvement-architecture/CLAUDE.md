@./CONTEXT.md

# CLAUDE.md — code/src/improvement-architecture/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is written here, how to open a report — imported above) → this file.

## Purpose (one line)

Timestamped, self-contained HTML architecture-review reports from the
`improve-codebase-architecture` skill — a gitignored local history of past architecture states;
nothing here is source.

## How to work here

- **Routing:** reports are produced by `/improve-codebase-architecture`
  (`.claude/skills/improve-codebase-architecture/SKILL.md`); the format lives in that skill's
  `HTML-REPORT.md`. Open a report in a browser with `xdg-open` (Linux) / `open` (macOS) /
  `start` (Windows).
- **Model:** Opus — this folder is generated output; there is nothing to author here.
- **Concrete steps:** the skill resolves the repo root, writes
  `architecture-review-<timestamp>.html` here, and opens it. To review history, list the folder
  newest-first (`ls -t`); delete old reports freely — they are disposable.
- **Definition of done:** no `*.html` report is committed; only `CONTEXT.md`, `CLAUDE.md`,
  `.gitignore`, and `.gitkeep` are tracked.

## Guardrails

- **Every `*.html` here is gitignored** — never commit a report, and never add application code
  here (this folder is not deployable source despite living under `code/src/`).
- The report is the transient artefact; a decision worth keeping is promoted out — to an ADR
  (the project's decision register) or a refactor note
  (`project-management/src/20-REFACTORING/`).
- Reports are self-contained (Tailwind + Mermaid via CDN) — do not add build steps or assets here.

## Output & naming

- **Generated (gitignored):** `architecture-review-<timestamp>.html` — written by the skill,
  never hand-edited.
- **Tracked only:** `CONTEXT.md`, `CLAUDE.md`, `.gitignore`, `.gitkeep`.
