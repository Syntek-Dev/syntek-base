---
type: guide
agent: doc-writer
skills: [global-workflow]
model: opus
---

# AI Coding Dictionary

**Version:** 0.1.0 **Maintained by:** {{ORG_NAME}} Developers **Language:** British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — plain-English glossary of AI-coding terms, split by theme over `ai-dictionary/`

The vocabulary of AI coding, in plain English — adapted for {{PROJECT_NAME}} from Matt
Pocock's [AI Coding Dictionary](https://aicodingdictionary.com). Sixty-nine terms across
seven themed sub-documents, each a tight definition plus why it matters in practice. Read
it to understand why context degrades, why the same prompt behaves differently from one
run to the next, and what a session actually costs — the mental model the rest of the
agent tooling assumes. The `grilling` skill cites it for _sycophancy_, _human-in-the-loop_,
and _design concept_.

## Sub-documents

| Document                                                                                     | Covers                                                                                                                         |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| [`ai-dictionary/THE-MODEL.md`](ai-dictionary/THE-MODEL.md)                                   | What a model is — parameters, training, inference, tokens, next-token prediction, providers, requests, token economics (16)    |
| [`ai-dictionary/SESSIONS-CONTEXT-AND-TURNS.md`](ai-dictionary/SESSIONS-CONTEXT-AND-TURNS.md) | Stateless vs stateful, context and the context window, agents, sessions, and turns (8)                                         |
| [`ai-dictionary/TOOLS-AND-ENVIRONMENT.md`](ai-dictionary/TOOLS-AND-ENVIRONMENT.md)           | The environment, filesystem, tools, tool calls and results, MCP, permissions, agent mode, sandboxes (10)                       |
| [`ai-dictionary/FAILURE-MODES.md`](ai-dictionary/FAILURE-MODES.md)                           | Hallucination, sycophancy, parametric/contextual knowledge, knowledge cutoff, attention budget and degradation, smart zone (9) |
| [`ai-dictionary/HANDOFFS.md`](ai-dictionary/HANDOFFS.md)                                     | Handoffs and handoff artifacts, specs, tickets, compaction, autocompact, clearing, primary/secondary sources (9)               |
| [`ai-dictionary/MEMORY-AND-STEERING.md`](ai-dictionary/MEMORY-AND-STEERING.md)               | Memory systems, AGENTS.md, progressive disclosure, context pointers, skills, subagents (6)                                     |
| [`ai-dictionary/PATTERNS-OF-WORK.md`](ai-dictionary/PATTERNS-OF-WORK.md)                     | Human-in-the-loop, AFK, automated and human review, vibe coding, grilling, prototyping, design concept, DX/AX (11)             |

## Where it fits

- **New to the tooling?** Read `THE-MODEL.md` and `FAILURE-MODES.md` first — they answer
  the "what does this cost?" and "why did it drift?" questions.
- **Authoring skills or agents?** Pair `MEMORY-AND-STEERING.md` with
  [`SKILL-AUTHORING.md`](SKILL-AUTHORING.md) — the concepts, then the house rules.
- **Designing a feature?** `PATTERNS-OF-WORK.md` covers grilling and human-in-the-loop —
  the postures the design workflows and the `grilling` skill build on.

_Part of the `how-to/docs/` documentation family._
