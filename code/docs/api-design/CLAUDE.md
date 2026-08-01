@./CONTEXT.md

# CLAUDE.md — code/docs/api-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the API-design standard — Django Ninja and REST/HTTP conventions,
auth/errors/rate-limiting, auth-scheme selection, webhooks, event tracking, API docs,
and client patterns — behind the `code/docs/API-DESIGN.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; the guides feed the
  `stack-django` skill and the `04-api-design` code workflow when a Django Ninja router
  or endpoint is designed.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`NINJA-CONVENTIONS.md`,
  `AUTH-AND-ERRORS.md`, `AUTH-STRATEGY.md`, `WEBHOOKS.md`, …) → keep
  `API-DESIGN.md` a thin index and update the `CONTEXT.md` file table on any change →
  verify length with `code/src/scripts/audits/cloc.sh`.
- **Definition of done:** conventions match the shipped API and `SECURITY.md`;
  each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **Every documented state-changing endpoint carries an explicit permission check** and every
  user-supplied ID is verified against caller ownership (no IDOR) — this folder is
  where those API rules are stated; never soften them.
- Don't contradict `code/docs/SECURITY.md` on auth, JWT hardening, or API-key
  lifecycle — cross-reference it instead of duplicating.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/API-DESIGN.md`.
