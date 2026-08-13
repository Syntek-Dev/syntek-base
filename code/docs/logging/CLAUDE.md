@./CONTEXT.md

# CLAUDE.md — code/docs/logging/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The logging and observability sub-documents behind `code/docs/LOGGING.md` — Django
config and Ninja request/exception logging, browser logging via the Sentry SDK,
Cloudinary media logging, the observability stack, and the app-to-deploy `HEALTH-CONTRACT.md`.

## How to work here

- **Routing:** documentation, not code — reach for the `doc-writer` or
  `logging` skill. Opus for substantive guidance and mechanical touches (typo fixes,
  header/version bumps).
- **Concrete steps:** edit the specific sub-doc → keep `code/docs/LOGGING.md` a thin
  index that points here → if you split a file, add the new file to the parent index
  and this folder's `CONTEXT.md` table. Every command in an example must invoke a
  `code/src/scripts/**/*.sh` script — never raw `python`, `uv`, or `docker`;
  express dependency additions as prose, not raw install commands.
- **Definition of done:** guidance matches the shipped logging config; `HEALTH-CONTRACT.md`
  stays in sync with `apps/health`; each file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split any file that
  exceeds it and demote the parent to an index.
- **No secrets or PII in log examples** — DSNs, tokens, and personal data are
  placeholders only; logs must never carry live credentials or a raw client IP.
- `HEALTH-CONTRACT.md` is a shared contract with the deploy repo — do not change the
  endpoint shape or status codes here without updating `apps/health` in lock-step.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/LOGGING.md`.
