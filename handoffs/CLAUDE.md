@./CONTEXT.md

# CLAUDE.md — handoffs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + purpose, imported above) → this file → the `handoff` skill (`.claude/skills/handoff/SKILL.md`).

## Purpose (one line)

The committed home for `/handoff` session-continuity documents.

## How to work here

- **Routing:** all writes here run through the `handoff` skill
  (`.claude/skills/handoff/SKILL.md`). Model: Opus.
- **Concrete steps:** `/handoff` writes `HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` naming the goal, what
  is done, what is in-flight (`path:line`), the next action, the next agent + skills, and artefacts
  by path → prune the file once the work has resumed.
- **Definition of done:** a fresh agent can resume from the handoff alone; no secret value or PII
  appears in it (reference by name and path only).

## Guardrails

- **A handoff carries live continuity only.** Durable knowledge goes to its home instead —
  patterns/state → `.claude/MEMORY.md`; blockers → `GAPS.md`; deferrals → `DEFERRED.md`.
- **Reference, never paste.** Point at plans, ADRs, stories, commits, and diffs by repo path; keep
  secrets and PII out.
- **British English (en_GB)**; filenames use `DD-MM-YYYY`.

## Output & naming

- **Hand-written** via `/handoff`; nothing generated.
- Files `HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` (SCREAMING-KEBAB descriptor).
