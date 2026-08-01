# handoffs — Session Handoff Documents

Committed, synced home for `/handoff` documents. Each file compacts one conversation so a fresh
agent — or {{DEVELOPER_NAME}} on another device — resumes the work without re-deriving it. A handoff is a
transient bridge, not a memory store: durable knowledge lives in `.claude/MEMORY.md`, `GAPS.md`,
and `DEFERRED.md`.

## Directory Tree

```text
handoffs/
├── CONTEXT.md   ← this file
├── CLAUDE.md    ← operating rules
└── HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md   ← one per handoff (created by /handoff)
```

## Why committed

Tracked (not gitignored) so a handoff written on one device is available on another. Prune a
handoff once its work has resumed — the tree stays a live set, not an archive.

## Driven by

`.claude/skills/handoff/SKILL.md` — the `/handoff` skill that writes these documents.
