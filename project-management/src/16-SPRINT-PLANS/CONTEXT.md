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

**The story plans next door carry a prefix too, and it obeys the opposite rule.** A plan there is
`{exec-order}-STORY-PLAN-US{###}-{DESC}.md` — **one** number, the story's position in the settled
build order across the whole backlog, **renumbered whenever that order changes**. It has no second
number to disagree with, so a prefix that has drifted from build order says nothing at all and is
a defect, where the same drift here is the point. Do not carry this section's "a mismatch is
information" across the folder boundary: `../17-STORY-PLANS/CLAUDE.md` owns that rule, and
`./CLAUDE.md` owns this one.

## What each plan records

- **Sprint goal** — one sentence: what the sprint delivers and why
- **Sprint reference documents** — the specs in scope (02–14), pointed to, not copied
- **Stories** — selected from `../02-STORIES/`, grouped Must / Should / Could / Won't, each
  linked to its **story plan** (`../17-STORY-PLANS/`) and its QA plan
- **Story-plans index** — each in-scope story → its `{exec-order}-STORY-PLAN-US{###}-*.md` (the
  code master). The prefix is build order across the whole backlog, so an index row's numbers do
  not run 01, 02, 03 down the sprint — they are wherever those stories sit in the global sequence
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

<!-- UPDATED 08/09/2026. Two changes, both consequences of the plans in `../17-STORY-PLANS/`
     being renamed that day to carry an `<exec-order>` prefix. (1) The Story-plans index bullet
     showed the sibling pattern as "STORY-PLAN-US{###}-*.md", unprefixed; it now shows the
     prefix, with the note that an index row's numbers follow the global build order rather than
     counting up within the sprint. (2) _Why a filename carries two numbers_ gained its closing
     paragraph. Without it this file explained that a prefix disagreeing with its suffix is
     deliberate information, one screen above a bullet naming a sibling artefact whose prefix
     must never disagree with anything — the two read as one convention, and this is the only
     file where they sit side by side. `**Last Updated**` above is deliberately untouched: it
     holds the Copier date token rendered at generation, and hard-coding 08/09/2026 there would
     ship this repository's date into every project generated afterwards. The update date is
     this comment. -->
