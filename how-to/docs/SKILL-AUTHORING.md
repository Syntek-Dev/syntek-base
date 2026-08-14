---
type: guide
skills: [doc-writer, global-workflow, runbook]
model: opus
---

# Authoring Skills

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the index over how to write and edit skills under `.claude/skills/`

A skill exists to wrangle determinism out of a stochastic system. The root virtue is
**predictability** — the agent taking the same _process_ every run, not producing the same
output. A brainstorming skill should predictably diverge; its tokens vary, its behaviour does
not. Cost and maintainability are symptoms of predictability, not rivals to it. Every lever in
the sub-documents below serves it.

Two things govern a skill here, and they are different in kind. The **format** is the published
[Agent Skills specification](https://agentskills.io/specification) — an external contract, and
the thing a loader validates. The **craft** is what makes a conforming skill any good.
Conforming to the format is necessary and tells you nothing about the second.

Three questions are settled before a word of the body is written: **whether any existing entry
already owns this remit**, **what the skill is** (conventions, or a procedure) and **where it
runs** (this conversation, or a fresh one). Everything else — which keys the frontmatter carries,
how the content is arranged, what the gate will accept — falls out of those three answers, which
is why they lead the reading order below.

## Sub-documents

| Document                                                               | Covers                                                                                                                                                            |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`skill-authoring/FORK-DECISION.md`](skill-authoring/FORK-DECISION.md) | Whether the remit is already owned, reference skill vs task skill, the three-axis fork rubric, which target a fork lands in, and the custom-agent reopening test  |
| [`skill-authoring/FRONTMATTER.md`](skill-authoring/FRONTMATTER.md)     | The six specification fields and their constraints, the four runtime keys admitted here, `metadata.skills` as a checkable register, what is declined and why      |
| [`skill-authoring/CRAFT.md`](skill-authoring/CRAFT.md)                 | The four axes: invocation, information hierarchy, steering, pruning — including what a description must discriminate against and how a reference skill is reached |
| [`skill-authoring/SHIPPING.md`](skill-authoring/SHIPPING.md)           | Folder structure, the length cap, the `## Governing procedures` routing section, registration, the conformance gate, and the pre-ship checklist                   |

## Before you commit

Both must exit 0 on any skill you touch — the rules behind them are in `SHIPPING.md`:

```bash
bash code/src/scripts/audits/skill-conformance.sh
bash code/src/scripts/audits/docs-length.sh --path .claude/skills
```

_Part of the `how-to/docs/` documentation family._
