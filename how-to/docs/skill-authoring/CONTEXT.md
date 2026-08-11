# how-to/docs/skill-authoring

The substance behind the skill-authoring standard, split out so the entry point can stay a thin
index and each part can grow without pushing another over the 300-line instructional limit. An
author needs them in the sequence `FORK-DECISION.md` → `FRONTMATTER.md` → `CRAFT.md` →
`SHIPPING.md`: decide whether the skill should exist and what it is, express that in frontmatter,
write the body well, then ship it. The tree below is alphabetical. Read via
`how-to/docs/SKILL-AUTHORING.md`, which is that index.

## Directory Tree

```text
how-to/docs/skill-authoring/
├── CLAUDE.md          ← operating rules
├── CONTEXT.md         ← this file
├── CRAFT.md           ← the four axes: invocation, hierarchy, steering, pruning
├── FORK-DECISION.md   ← is the remit owned, reference vs task, the fork rubric and target
├── FRONTMATTER.md     ← the six spec fields, the four runtime keys, and what is declined
└── SHIPPING.md        ← structure, routing section, registration, the gate, the checklist
```

## Cross-references

- `how-to/docs/SKILL-AUTHORING.md` — the index these sub-documents belong to
- `.claude/skills/CONTEXT.md` — the skills the standard governs, and the when-to-load table
- `code/src/scripts/audits/skill-conformance.sh` — the gate that enforces the format half
