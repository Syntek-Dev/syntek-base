# project-management/src/15-DECISIONS

Architecture Decision Records (ADRs) — significant technical and design decisions with
context, options considered, and rationale. One immutable record per decision.

## Directory Tree

```text
project-management/src/15-DECISIONS/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules for this folder
├── ADR-US000-TEMPLATE.md   ← ADR template — copy to author a new decision
└── ADR-US###-<DECISION>-DD-MM-YYYY.md  ← one file per accepted decision
```

Example: `ADR-US014-OPAQUE-SESSION-TOKENS-31-08-2026.md`.

**Naming:** `ADR-US###-<DECISION>-DD-MM-YYYY.md` — the driving story, the decision it
governs in `SCREAMING-SNAKE-CASE`, and the date it was made. Flat: no per-story
subdirectories. There is no `ADR-###` index; it was retired 31/08/2026.

## What each ADR records

Each ADR captures five sections — **Status** (Proposed / Accepted / Superseded /
Deprecated), **Context**, **Options considered**, **Decision**, and **Consequences** —
under a metadata header (Date, Deciders, Supersedes / Superseded by, Related `US###`).
The full scaffold with authoring guidance lives in `ADR-US000-TEMPLATE.md`.

## When an ADR is written

At the PM step that **surfaces** the trade-off — a schema shape or RLS scope at
`04-database-schema`, a session strategy at `10-security-checks`, a contract shape at
`13-api-design` — not held to the end of the loop. Workflow `15-decisions` is the
**coherence gate**: it checks a story's ADRs hold true and do not clash before
`16-sprint-plans` and `17-story-plans` plan against them.

## Authoring a new ADR

Copy `ADR-US000-TEMPLATE.md` → name it for the driving story, the decision and today's
date → fill the five sections → cross-link the `US###` that drove or consumes it → set
**Status** to `Accepted` on sign-off.

**Last Updated**: <%DATE%>
