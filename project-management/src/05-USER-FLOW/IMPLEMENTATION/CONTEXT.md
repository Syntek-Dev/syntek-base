# project-management/src/05-USER-FLOW/IMPLEMENTATION

**Stage 3** — the flow as built. One record per user story, written during
`workflows/21-implementation-documentation/`, confirming that the shipped routes and screens
follow the consolidated journey in `../CONSOLIDATED-IDEAS/`.

## Directory Tree

```text
project-management/src/05-USER-FLOW/IMPLEMENTATION/
├── CONTEXT.md                                        ← this file
├── CLAUDE.md                                         ← operating rules for this folder
├── USER-FLOW-IMPL-US000-TEMPLATE.md                  ← copy this to record a story's flow
└── USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← one record per story
```

**Naming:** `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Reuse the stage-1 descriptor.

## What it holds

Per story: each step of the consolidated journey the story implemented, marked
Present / Changed / Missing with the view or template as evidence; every failure path verified
reachable and handled; data touchpoints confirmed against the GDPR register; and any deviation
from the consolidated journey, justified.

## Failure paths are the ones that slip

Happy paths get built because they are the demo. The consolidated journey exists largely to pin
down what happens when verification bounces or consent is refused — so this record verifies
**those** explicitly, not just that the feature works.

## Cross-references

- `USER-FLOW-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — the journey these records verify the build against
- `../USER-STORY-IDEAS/` — the frozen fragment, for tracing intent
- `../../19-FINDINGS/` — where a divergence worth carrying forward is recorded
- `project-management/workflows/21-implementation-documentation/` — where these are written

**Last Updated**: <%DATE%>
