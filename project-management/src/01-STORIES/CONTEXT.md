# project-management/src/01-STORIES

User stories — one `US###.md` per story (role, goal, benefit, acceptance criteria).
`US000-TEMPLATE.md` is the template; copy it for every new story.

## Directory Tree

```text
project-management/src/01-STORIES/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── US000-TEMPLATE.md        ← story template — copy for each new story
└── US###.md                 ← user stories (e.g. US001.md, US002.md …)
```

**Naming:** `US###.md` — 3-digit zero-padded (e.g. `US001.md`). Numeric gaps are
acceptable — only files that exist are listed; never renumber to close a gap.

## What each story records

Every story carries an authoritative `**Epic:**` metadata line and contains role, goal,
benefit, and acceptance criteria (Gherkin and/or sectioned checklists). The full
scaffold — flags, client summary, MoSCoW, story points, dependencies, and the
per-discipline acceptance criteria and tasks — lives in `US000-TEMPLATE.md`.

Related artefacts: `../16-TESTS/US###-TEST-STATUS.md` · `../10-QA/PLANNING/QA-PLAN-US###-*.md`.

## Authoring a new story

Copy `US000-TEMPLATE.md` → next free `US###` number (gaps are intentional, never
backfilled) → write role / goal / benefit / acceptance criteria → set the authoritative
`**Epic:**` line → satisfy the workflow `CHECKLIST.md`.

**Last Updated**: <%DATE%>
