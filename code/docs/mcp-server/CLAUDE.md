@./CONTEXT.md

# CLAUDE.md — code/docs/mcp-server/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the MCP standard — ASGI mounting, tool design, auth and the MCP
threat model, testing and operations — behind the `code/docs/MCP-SERVER.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author. The guides feed the `stack-fastmcp` skill, the
  `backend` agent (tools), the `security` agent (`AUTH-AND-THREATS.md`), the `test-writer`
  agent (`TESTING-AND-OPS.md`), and the `05-mcp-server` code workflow.
- **Model:** Opus for substantive guidance and for typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc → keep `MCP-SERVER.md` a thin index and update
  the `CONTEXT.md` file table on any change → verify length with
  `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** guidance matches the shipped mount (or, while unwired, the design of
  record); each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **Identity comes from the verified token, never from a tool argument.** This folder is where
  that rule is stated; never soften it, and never document a tool signature that breaks it.
- **Every state-changing tool carries the same named permission check as its Ninja twin** —
  the `.claude/CLAUDE.md` §6 non-negotiable is about the operation, not the transport.
- **Never imply the `/mcp/` mount inherits Django's middleware.** It does not — no session, no
  `login_required`, no CSRF, no API rate-limit middleware. Any guidance that assumes otherwise
  is wrong.
- Don't contradict `code/docs/SECURITY.md` or `api-design/AUTH-STRATEGY.md` — this surface
  **extends** them (cross-reference rather than restate).
- Keep the status line honest: while nothing is mounted at baseline, say so.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/MCP-SERVER.md`.
