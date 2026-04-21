# project-management/src/04-USER-FLOW

User flow diagrams and journey maps for every primary interaction area of the project-name. Each
file documents the full sequence of screens, decisions, and transitions a user follows through one
area of the product.

## Directory Tree

```text
project-management/src/04-USER-FLOW/
├── CONTEXT.md                   ← this file
├── USER-FLOW-ADMIN-CONTENT.md   ← admin content management journeys
├── USER-FLOW-ADMIN-MEMBERS.md   ← admin member management journeys
├── USER-FLOW-AUTH.md            ← registration, login, logout, password reset
├── USER-FLOW-CLIENT-PORTAL.md   ← client portal access and document workflows
├── USER-FLOW-GDPR.md            ← consent, data export, and deletion flows
├── USER-FLOW-NEWSLETTER.md      ← newsletter subscribe and unsubscribe journeys
└── USER-FLOW-PUBLIC.md          ← public-facing pages and navigation journeys
```

**Naming:** `USER-FLOW-<AREA>.md`

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
