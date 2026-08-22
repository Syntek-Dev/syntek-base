# project-management/src/03-SPRINTS

High-level sprint records — one `SPRINT-##.md` per sprint (goal, timeline, capacity,
story table, dependency notes). The detailed per-sprint execution plans live in
`16-SPRINT-PLANS/`. `SPRINT-00-TEMPLATE.md` is the template; copy it for every new sprint.

## Directory Tree

```text
project-management/src/03-SPRINTS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── SPRINT-00-TEMPLATE.md    ← sprint template — copy for each new sprint
└── SPRINT-##.md             ← sprint records (e.g. SPRINT-01.md, SPRINT-02.md …)
```

**Naming:** `SPRINT-##.md` — 2-digit zero-padded (e.g. `SPRINT-01.md`).

## What each sprint record holds

A high-level record only — goal, timeline, capacity (`used / total SP`), a story table
(ID · Title · MoSCoW · SP), and dependency notes (what blocks it, what it unblocks). The
detailed execution plan lives in `16-SPRINT-PLANS/`. Full scaffold: `SPRINT-00-TEMPLATE.md`.

## Authoring a new sprint

Copy `SPRINT-00-TEMPLATE.md` → `SPRINT-##.md` → fill goal · timeline · capacity · story
table · dependencies → keep capacity within the team's SP ceiling → honour the dependency
chain (sprint numbering is not execution order — never schedule a story ahead of its
blocker). Detailed planning continues in `16-SPRINT-PLANS/`.

**Last Updated**: <%DATE%>
