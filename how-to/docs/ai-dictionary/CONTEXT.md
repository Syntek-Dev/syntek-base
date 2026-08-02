# how-to/docs/ai-dictionary — AI Coding Dictionary sub-documents

**Last Updated**: <%DATE%>

The themed sub-documents behind [`../AI-DICTIONARY.md`](../AI-DICTIONARY.md) — the
plain-English glossary of AI-coding terms. The entry-point guide is the index; each file
here holds one theme's terms (a definition plus a "why it matters" line), every file
≤ 300 code lines.

## Directory Tree

```text
how-to/docs/ai-dictionary/
├── CONTEXT.md                      ← this file
├── CLAUDE.md                       ← operating rules
├── THE-MODEL.md                    ← parameters, training, inference, tokens, providers (16 terms)
├── SESSIONS-CONTEXT-AND-TURNS.md   ← stateless/stateful, context window, sessions, turns (8)
├── TOOLS-AND-ENVIRONMENT.md        ← environment, tools, MCP, permissions, sandbox (10)
├── FAILURE-MODES.md                ← hallucination, sycophancy, attention, cutoff (9)
├── HANDOFFS.md                     ← handoffs, specs, tickets, compaction, clearing (9)
├── MEMORY-AND-STEERING.md          ← memory, AGENTS.md, progressive disclosure, skills (6)
└── PATTERNS-OF-WORK.md             ← HITL, AFK, review, vibe coding, grilling, DX/AX (11)
```

## When to read this

- Looking up a specific AI-coding term — start at the index for the theme, then this folder
- Onboarding to the agent tooling — the shared vocabulary the rest of `.claude/` assumes

## Source

Adapted from Matt Pocock's AI Coding Dictionary (aicodingdictionary.com), condensed to
en_GB and the <%PROJECT_SLUG%> doc-guide shape. Extend via the entry-point guide `../AI-DICTIONARY.md`.
