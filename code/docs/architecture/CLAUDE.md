@./CONTEXT.md

# CLAUDE.md — code/docs/architecture/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the architecture-patterns standard — the AdminMember/
ModulePermission auth contract, core decisions and PostgreSQL scaling, frontend
state/routing, and service-layer/middleware design — behind the
`code/docs/ARCHITECTURE-PATTERNS.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) or `planner` (Fable) to author;
  these guides govern any new Django app or public template route and the
  `01-implement-story` workflow.
- **Model:** Fable for substantive guidance; Opus for typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`AUTH-CONTRACT.md`,
  `CORE-AND-SCALING.md`, `FRONTEND-PATTERNS.md`, `SERVICE-AND-MIDDLEWARE.md`) →
  keep `ARCHITECTURE-PATTERNS.md` a thin index and update the `CONTEXT.md` file
  table on any change → verify length with `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** patterns match the shipped app/service layout; each file
  ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **`AUTH-CONTRACT.md` is load-bearing:** it defines how permission checks and
  ownership are enforced across apps — keep it consistent with `code/docs/SECURITY.md` and
  `API-DESIGN.md`; never document a pattern that skips the permission check on a
  state-changing Django Ninja endpoint.
- Business logic belongs in services, not Ninja endpoints or views — the guide must keep saying so.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/ARCHITECTURE-PATTERNS.md`.
