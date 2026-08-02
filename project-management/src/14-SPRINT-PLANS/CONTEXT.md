# project-management/src/14-SPRINT-PLANS

Sprint plans — one per sprint, written after the design & compliance specs (03–12) and
the decisions (13) are complete. A sprint plan is **sprint-level orchestration**: it fixes
the goal, the story set, the MoSCoW priority, and the build sequence, then feeds each story
to its **story plan** in `../15-STORY-PLANS/` — the master a developer codes from. Per-story
implementation depth is **not** duplicated here; it lives in the story plan.

## Directory Tree

```text
project-management/src/14-SPRINT-PLANS/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
└── 00-SPRINT-PLAN-00-TEMPLATE.md  ← the sprint-plan template — copy for each new plan
```

This is a base-repo scaffold: the folder ships with the template only. Real sprint plans
are added by copying it.

## Naming

`{exec-order}-SPRINT-PLAN-{sprint-number}.md` — both segments 2-digit zero-padded.

- `{exec-order}` — recommended implementation sequence across all sprint plans
- `{sprint-number}` — the sprint it plans, matching `../02-SPRINTS/SPRINT-{##}.md`

The two usually match. They diverge deliberately when a sprint must be built out of sprint-
number order (e.g. an observability or infrastructure sprint pulled early); the prefix is
the build order, the suffix is the sprint identity. Do not "correct" a deliberate mismatch.

## What each plan records

- **Sprint goal** — one sentence: what the sprint delivers and why
- **Sprint reference documents** — the specs in scope (01–13), pointed to, not copied
- **Stories** — selected from `../01-STORIES/`, grouped Must / Should / Could / Won't, each
  linked to its **story plan** (`../15-STORY-PLANS/`) and its QA plan
- **Story-plans index** — each in-scope story → its `STORY-PLAN-US{###}-*.md` (the code master)
- **Phase breakdown** — backend → API → frontend → PR & review, with the stories per phase
- **Sprint-wide constraints** — GDPR / security / QA / SEO summaries drawn from 08–12
- **Sprint verification checklist** and **Definition of Done**

## Where it sits (decide & plan tier)

```text
13-DECISIONS  →  14-SPRINT-PLANS  →  15-STORY-PLANS
   (ADRs)         (this folder)       (code master)
```

Sprint plans (14) feed the story plans (15); the story plan is what implementation follows.
Both are written **before any code**, after the specify tier (01–12).

## When to use

- `../../workflows/14-sprint-plans` — the workflow that produces these documents
- Written after `08-GDPR`, `09-SECURITY`, `10-QA`, `11-SEO`, and `12-API-DESIGN` are complete
- Read throughout the development phases (`../../workflows/16-backend-code` → `20-pr-and-review`)

**Last Updated**: <%DATE%>
