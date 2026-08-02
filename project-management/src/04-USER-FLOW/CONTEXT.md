# project-management/src/04-USER-FLOW

User flow diagrams and journey maps — one `USER-FLOW-<AREA>.md` per primary interaction
area, documenting the full sequence of screens, decisions, and transitions a user follows.
`USER-FLOW-TEMPLATE.md` is the template; copy it for every new flow.

## Directory Tree

```text
project-management/src/04-USER-FLOW/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for this folder
├── USER-FLOW-TEMPLATE.md       ← flow-narrative template — copy for each new area
├── USER-FLOW-<AREA>.md         ← per-area flow narrative (SCREAMING-SNAKE-CASE area)
└── DIAGRAMS/                   ← rendered flow images (PNG exports from the Mermaid source)
    ├── CONTEXT.md
    ├── CLAUDE.md
    └── flow-<area>-<screen>.png
```

**Naming:** `USER-FLOW-<AREA>.md` — flow narrative; `flow-<area>-<screen>.png` — rendered image.

A flow narrative documents each screen/journey with a narrative, a rendered diagram, and its
Mermaid source, plus (where they apply) API-design, security, GDPR, and SEO cross-references.
A thin flow that belongs to a larger journey becomes a one-line **stub** pointing at the
canonical section — never a second copy. Full scaffold and stub pattern: `USER-FLOW-TEMPLATE.md`.

## When to read

- Before designing or reviewing wireframes for a feature
- When mapping a user story to its step-by-step journey
- During GDPR compliance review to trace data touchpoints
- When writing acceptance criteria that span multiple screens

## Cross-references

- `project-management/src/07-WIREFRAMES/` — visual wireframe documents per flow
- `project-management/src/01-STORIES/` — user stories the flows are derived from
- `project-management/src/08-GDPR/` — GDPR compliance artefacts for data flows
- `project-management/CONTEXT.md` — full project-management layer overview

**Last Updated**: <%DATE%>
