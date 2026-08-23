# research — Primary-Source Research Notes

Committed, synced home for `/research` notes. Each note answers one question against high-trust
primary sources (official docs, source, specs, RFCs, standards) with a citation on every claim,
and feeds a decision — an ADR or a PLAN links back to it.

## Directory Tree

```text
research/
├── CONTEXT.md   ← this file
├── CLAUDE.md    ← operating rules
├── <TOPIC>.md   ← one per question (created by /research)
└── <SOURCE>.pdf ← a primary source pinned beside the note that cites it, so the
                   exact version its per-claim citations were checked against cannot
                   move under them. Only where the source is a paper or a spec that
                   can be revised in place; a URL alone is the normal case
```

## Boundary with context7

For one library or framework's own API, use the `context7` MCP. A research note is for synthesis
across primary sources — a stack-choice comparison, ADR groundwork, or how a spec behaves.

## Driven by

`.claude/skills/research/SKILL.md` — the `/research` skill that writes these notes.
