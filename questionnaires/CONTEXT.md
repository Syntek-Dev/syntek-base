# questionnaires — Outbound Discovery Questionnaires

Committed home for `/to-questionnaire` documents: a decision <%DEVELOPER_NAME%> cannot settle
alone, turned into a document filled in by the person who holds the answer — a client, a data
controller, a vendor, a stakeholder.

## Directory Tree

```text
questionnaires/
├── CONTEXT.md   ← this file
├── CLAUDE.md    ← operating rules
└── QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md   ← one per send (created by /to-questionnaire)
```

## Why it is committed

A questionnaire is the evidence behind a decision that was **taken on someone else's word**. Six
months later, "the client said 90 days" is worth nothing; the document they answered is worth a
great deal — particularly for the GDPR registers, where the lawful basis and retention answers
originate outside the team.

It is kept after it returns, with the answers in it. An empty sent questionnaire and a returned one
are the same file at two points in time.

## Boundary with the neighbours

| If you are…                                       | Go to                                        |
| ------------------------------------------------- | -------------------------------------------- |
| Asking a **human outside the team** for knowledge | **here** — `/to-questionnaire`               |
| Asking **<%DEVELOPER_NAME%>** to settle a design  | `/grill-me` · `/grill-with-docs`             |
| Briefing a **fresh agent** with repo access       | `/handoff` → `handoffs/`                     |
| Assessing a **vendor's security posture**         | `.claude/agents/vendor-assessment-writer.md` |
| Recording a **primary-source fact**               | `/research` → `research/`                    |

## Driven by

`.claude/skills/to-questionnaire/SKILL.md` — the skill that writes these.
