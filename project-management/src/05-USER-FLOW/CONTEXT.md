# project-management/src/05-USER-FLOW

User journeys, in **three stages**. Each story maps the flows it introduces
(`USER-STORY-IDEAS/`); once every story is planned, `17-consolidate-design-work` stitches those
fragments into whole journeys (`CONSOLIDATED-IDEAS/`); after the code ships, each story records
the flow as built (`IMPLEMENTATION/`). Rendered diagrams live in `DIAGRAMS/`.

## Directory Tree

```text
project-management/src/05-USER-FLOW/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── USER-STORY-IDEAS/        ← stage 1: per-story flow fragments (workflow 05)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── USER-FLOW-IDEA-US000-TEMPLATE.md
│   └── USER-FLOW-IDEA-US###-<DESCRIPTOR>.md
├── CONSOLIDATED-IDEAS/      ← stage 2: whole journeys per area (workflow 17)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── USER-FLOW-CONSOLIDATED-000-TEMPLATE.md
│   └── USER-FLOW-CONSOLIDATED-<AREA>.md
├── IMPLEMENTATION/          ← stage 3: the flow as built, per story (workflow 21)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── USER-FLOW-IMPL-US000-TEMPLATE.md
│   └── USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── DIAGRAMS/                ← rendered flow images — cumulative, spans all stages
    ├── CONTEXT.md · CLAUDE.md
    └── flow-<area>-<screen>.png
```

## Why three stages

A story owns a slice of a journey, not the whole thing. Sign-up might be touched by four
stories — registration, email verification, consent capture, the failure paths — each mapping
its own slice without seeing the others. That is what the per-story loop is for, and it is also
why the fragments do not add up to a coherent journey on their own.

`17-consolidate-design-work` stitches them into one canonical flow per **area**, where every
decision node resolves both outcomes across the whole journey rather than only within one
story's slice. The gaps between fragments — a state one story leaves the user in that no other
story picks up — are exactly what consolidation exists to find.

## The three stages

| Stage                 | Written by  | Scope     | Naming                                            |
| --------------------- | ----------- | --------- | ------------------------------------------------- |
| `USER-STORY-IDEAS/`   | workflow 05 | one story | `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md`            |
| `CONSOLIDATED-IDEAS/` | workflow 17 | one area  | `USER-FLOW-CONSOLIDATED-<AREA>.md`                |
| `IMPLEMENTATION/`     | workflow 21 | one story | `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` |

`<AREA>` and descriptors in `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY.

**Stage 1 is frozen once stage 2 runs** — never rewritten; it records what each story mapped.

## Cross-references

- `USER-STORY-IDEAS/CONTEXT.md` · `CONSOLIDATED-IDEAS/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md`
- `../02-STORIES/` — the stories these flows serve
- `../08-WIREFRAMES/` — the screens that realise the consolidated flows
- `../09-GDPR/` — where flagged data touchpoints are given a lawful basis
- `code/docs/URL-STRATEGY.md` — the route structure flows must follow
- `project-management/workflows/05-user-flow-design/` — produces stage 1
- `project-management/workflows/17-consolidate-design-work/` — produces stage 2

**Last Updated**: <%DATE%>
