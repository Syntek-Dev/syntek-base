# ADR-US000: [Decision Title]

<!-- Filename: ADR-US###-<DECISION>-DD-MM-YYYY.md — the driving story, the decision in
     SCREAMING-SNAKE-CASE, and the date it was made (e.g.
     ADR-US014-OPAQUE-SESSION-TOKENS-31-08-2026.md). Flat: no per-story subdirectory.
     There is no ADR-### index; it was retired 31/08/2026. Never reuse a
     retired number. One ADR = one decision. Once Accepted, an ADR is immutable —
     supersede it with a new ADR rather than editing the decision in place. -->

<!-- Status: one plain value — Proposed | Accepted | Superseded | Deprecated (the completion
     skill owns the vocabulary). No bold, backticks or comment on the Status line itself; any
     prose (who accepted it, when) goes on the Status note line, which may be deleted if empty.
     pm-board.sh reads both supersession lines into the decisions board: each is a full ADR
     filename or None, and a supersession is recorded on both records. -->

**Status:** Proposed
**Status note:** [optional — one line, e.g. "Accepted DD/MM/YYYY by <name> at <step>"]
**Date:** DD/MM/YYYY
**Deciders:** [name(s) who own this decision]
**Supersedes:** None <!-- full filename of the ADR this record replaces, or None -->
**Superseded by:** None <!-- full filename of the ADR that later replaced this, or None -->
**Related:** [US###, or —] <!-- the story that drove or consumes the decision -->

---

## Context

<!-- The forces at play: the problem, the constraints, the requirements, and the
     assumptions in effect at the time of the decision. State the situation neutrally
     enough that a reader who disagrees with the outcome still recognises the problem.
     Link the driving US### / plan where one exists. -->

[What is the issue we are deciding on, and why now? What constraints bound the choice?]

## Options considered

<!-- Each realistic option with its trade-offs — including the "do nothing" option
     where relevant. Enough that the Decision below reads as a choice, not a decree. -->

### Option A — [name]

- **Summary:** [what this option is]
- **Pros:** [benefits]
- **Cons:** [costs, risks, trade-offs]

### Option B — [name]

- **Summary:** [what this option is]
- **Pros:** [benefits]
- **Cons:** [costs, risks, trade-offs]

## Decision

<!-- The option chosen, stated plainly, and WHY it beat the alternatives. This is the
     load-bearing section — be specific about the deciding factors. -->

[We will … because …]

## Consequences

<!-- The results of the decision — positive, negative, and neutral — and any follow-on
     work it creates. What becomes easier? What becomes harder? What must be enforced in
     code, and where? Note any new obligation that later ADRs may need to revisit. -->

- **Positive:** [what improves]
- **Negative / trade-off:** [what we accept]
- **Follow-on:** [migrations, enforcement points, stories unblocked or created]
