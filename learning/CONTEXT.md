# learning — Skill Practice Workspace

A committed, synced sandbox where {{DEVELOPER_NAME}} practises new skills without touching the product.
Every learning session (the `teach` skill) reads the real codebase and docs as reference and
writes only here. Content under each topic folder is throwaway practice, not shipped code.

## Directory Tree

```text
learning/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the sandbox
└── <topic>/              ← one folder per skill being learned (created by /teach)
    ├── MISSION.md        ← why, the goal, the family (process | coding)
    ├── RESOURCES.md      ← curated primary + house-convention pointers
    ├── PROGRESS.md       ← retrieval-practice + spaced-repetition log
    └── LESSONS/          ← worked practice: throwaway drafts, runnable examples
```

## Why this exists

Committed (not gitignored) so lessons sync across {{DEVELOPER_NAME}}'s devices. Driven by the `teach` skill
(`.claude/skills/teach/SKILL.md`): a safe space to learn PM/agile process (stories, sprints,
plans, ADRs) and the stack (HTMX, Alpine, vanilla CSS, Django, django-ninja, django-components,
architecture, security, testing).

## Not for

- Shipped code, real stories, or real plans → those live in `code/src/` and
  `project-management/src/`. Practice copies stay here.
