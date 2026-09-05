# project-management/src/16-SPRINT-PLANS

Sprint plans — one per sprint, written after the design & compliance specs (03–12) and
the decisions (15) are complete. A sprint plan is **sprint-level orchestration**: it fixes
the goal, the story set, the MoSCoW priority, and the build sequence, then feeds each story
to its **story plan** in `../17-STORY-PLANS/` — the master a developer codes from. Per-story
implementation depth is **not** duplicated here; it lives in the story plan.

## Directory Tree

```text
project-management/src/16-SPRINT-PLANS/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
├── 00-SPRINT-PLAN-00-TEMPLATE.md  ← the sprint-plan template — copy for each new plan
└── ##-SPRINT-PLAN-##.md           ← one plan per sprint (e.g. 01-SPRINT-PLAN-01.md)
```

This is a base-repo scaffold: the folder ships with the template only. Real sprint plans
are added by copying it.

## Why a filename carries two numbers

A plan is named `{exec-order}-SPRINT-PLAN-{sprint-number}.md`, both segments 2-digit
zero-padded, because it answers two different questions:

- `{exec-order}` — the recommended implementation sequence across all sprint plans
- `{sprint-number}` — the sprint it plans, matching `../03-SPRINTS/SPRINT-{##}.md`

The two usually match. They diverge deliberately when a sprint has to be built out of
sprint-number order — an observability or infrastructure sprint pulled early, for instance.
The prefix is the build order; the suffix is the sprint's identity. A mismatch is therefore
information, not a typo.

## What each plan records

- **Sprint goal** — one sentence: what the sprint delivers and why
- **Sprint reference documents** — the specs in scope (02–14), pointed to, not copied
- **Stories** — selected from `../02-STORIES/`, grouped Must / Should / Could / Won't, each
  linked to its **story plan** (`../17-STORY-PLANS/`) and its QA plan
- **Story-plans index** — each in-scope story → its `STORY-PLAN-US{###}-*.md` (the code master)
- **Phase breakdown** — backend → API → frontend → PR & review, with the stories per phase
- **Sprint-wide constraints** — GDPR / security / QA / SEO summaries drawn from 08–12
- **Sprint verification checklist** and **Definition of Done**

## Where it sits (decide & plan tier)

```text
15-DECISIONS  →  16-SPRINT-PLANS  →  17-STORY-PLANS
   (ADRs)         (this folder)       (code master)
```

Sprint plans (16) feed the story plans (17); the story plan is what implementation follows.
Both are written **before any code**, after the specify tier (02–14).

## When to use

- `../../workflows/16-sprint-plans` — the workflow that produces these documents
- Written after `09-GDPR`, `10-SECURITY`, `11-QA`, `12-SEO`, and `13-API-DESIGN` are complete
- Read throughout the development phases (`../../workflows/19-backend-code` → `23-pr-and-review`)

**Last Updated**: <%DATE%>
