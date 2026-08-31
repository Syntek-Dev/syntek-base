# project-management/src/00-ASSETS/WALK-TESTS

Evidence from cold walk tests — the experiment that asks whether this repository can orient an
agent that has never seen it. A walk is run by a session with the project's context chain
suppressed, given a rule to trace and a hard budget, and judged on which question broke rather
than on a score. What is kept here is the raw material: the prompt the walker was given, its
verbatim answer, the ground-truth transcript of every tool call it made, and the recorded result
with the walker's claims checked against the tree.

They live here because a walk is only worth the evidence behind it. The finding of the first walk
was that the walker stated one confident falsehood inside its budget, which no budget catches and
only an independent check does — so a walk summarised without its transcript is a claim, not a
result.

## Directory Tree

```text
project-management/src/00-ASSETS/WALK-TESTS/
├── CONTEXT.md                                  ← this file
├── CLAUDE.md                                   ← operating rules for this folder
├── WALK-N010-COLD-31-08-2026.md                ← the first cold walk: result, verification, routing
├── WALK-N010-COLD-31-08-2026-PROMPT.md         ← exactly what that walker was given
├── WALK-N010-COLD-31-08-2026-REPORT.md         ← that walker's verbatim output, unedited
└── WALK-N010-COLD-31-08-2026-TRANSCRIPT.jsonl  ← ground truth: every tool call, and usage totals
```

The four `WALK-N010-*` files are syntek-base's own experimental record and do not travel to a
generated project — they are excluded in `copier.yml`. <!-- doc-references: template-only -->
The folder and this pair do ship, because the walk test is a reusable practice, not a one-off.

## When to read this

Reach for a walk record when arguing about navigability — whether a rule is reachable, what cites
it, what moves when it changes. The record says what a cold reader actually managed, which is a
different question from what the tree makes possible in principle.

**Last Updated**: <%DATE%>
