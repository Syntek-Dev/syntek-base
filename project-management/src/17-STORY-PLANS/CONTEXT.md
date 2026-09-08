# project-management/src/17-STORY-PLANS

Per-story implementation plans — one plan per user story, written **before**
implementation to fix the technical approach, key decisions, dependencies, and risks.
This is the **master a developer codes from** (tier 15): each plan references up to its
sprint plan (`../16-SPRINT-PLANS/`), the decisions (`../15-DECISIONS/`), and every 02–14
spec. `00-STORY-PLAN-US000-TEMPLATE.md` is the canonical superset template — copy it for
every new plan.

## Directory Tree

```text
project-management/src/17-STORY-PLANS/
├── CONTEXT.md                       ← this file
├── CLAUDE.md                        ← operating rules for this folder
├── 00-STORY-PLAN-US000-TEMPLATE.md  ← canonical plan template — copy for each new plan
├── ##-STORY-PLAN-US###-<DESC>.md    ← one plan per user story (e.g. 02-STORY-PLAN-US001-<DESC>.md)
└── PLAN-<DESCRIPTOR>.md             ← cross-cutting programme plans spanning several stories
```

This is a base-repo scaffold: the folder ships with the template only. Real plans are
added by copying it.

**Naming:** `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` per story, the prefix
2-digit zero-padded; `PLAN-<DESCRIPTOR>.md`, unprefixed, for cross-cutting programme plans.
Wayfinder feature maps live upstream in `../01-FEATURE-MAPS/`, not here.

## Why the filename carries a build-order prefix

`<exec-order>` is the story's position in the **settled build order across the whole backlog** —
not the sprint it sits in, and not a counter that restarts each sprint. The folder therefore
reads top to bottom in the order the work is meant to happen, which is the one thing a flat
list of per-story plans otherwise cannot show. `00-` is reserved for the template, mirroring
`../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`.

A number may also be **reserved** — taken by a story whose plan is not yet written — so that the
run stays contiguous while `17-story-plans` catches up.

**It is renumbered when build order changes, and that is the opposite of the sibling rule next
door.** A sprint plan carries two numbers and a mismatch between them is deliberate information;
a story plan carries one, so a prefix that has drifted from build order says nothing. `CLAUDE.md`
owns the rule and states the difference in full — read it before renaming anything here.

## Where it sits (decide & plan tier)

```text
15-DECISIONS  →  16-SPRINT-PLANS  →  17-STORY-PLANS
   (ADRs)         (sprint feeds)      (this folder — code master)
```

Sprint plans (16) feed the story plans (17); the story plan is what implementation
follows. Both are written **before any code**, after the specify tier (02–14).

## What each plan records

A plan is created before implementation begins and documents:

- Problem statement (why this story exists)
- Technical approach (models, services, API, frontend layers)
- Key decisions table (chosen vs rejected, with rationale)
- Dependencies table (blocked-by / blocks, with a "can start now" vs "blocked" callout)
- GDPR, security, logging, testing, and the documentation write-up map
- Deferred items and risks
- Docker & Nginx infrastructure — the per-story worktree isolation files

**Per-story worktree isolation files** — each plan references four files that keep
parallel worktrees from colliding (unique `127.0.0.N` IP + port block per story):

- `code/src/docker/docker-compose.us###.dev.yml` — dev stack override
- `code/src/docker/docker-compose.us###.test.yml` — test stack override
- `code/src/docker/nginx/dev-us###.conf` — dev nginx reverse proxy
- `code/src/docker/nginx/test-us###.conf` — test nginx reverse proxy

## Authoring a new plan

Copy `00-STORY-PLAN-US000-TEMPLATE.md` → take the story's position in the settled build order as
the `<exec-order>` prefix → name it `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
→ complete every section → keep the `blocked-by` / `blocks` callout honest so the
dependency DAG stays accurate.

## The plans index

**There is no Plans Index section in this file, and its absence is a recorded decision rather
than drift.** This `CONTEXT.md` ships into every generated project, so a row naming a real story
plan would put a per-project citation in a shipped file — the defect `code/docs/FORWARD-VOICE.md`
governs. The index belongs in its own excluded-and-seeded index file beside these plans, which
the register-index work charted in `../01-FEATURE-MAPS/` creates, names and gates. Until that
lands, a plan is indexed against its sprint in that sprint plan's _Story Plans — the code master_
table (`../16-SPRINT-PLANS/`), and a reserved number is recorded in the owning story under
`../02-STORIES/`. The instructions that once required a row here point there instead — the
`17-story-plans` workflow files and this folder's `CLAUDE.md` were re-pointed on 08/09/2026, then
the plan template and the plans on disk the same day — so no row is added here (`CLAUDE.md`
carries the rule), and a plan's own status lives in its metadata table and in its story.

**Last Updated**: <%DATE%>

<!-- RENAMED 08/09/2026. The six plans in this folder were renamed by `git mv` that day from
     `STORY-PLAN-US###-<DESC>.md` to `<exec-order>-STORY-PLAN-US###-<DESC>.md`, the prefix the
     story's position in the settled build order across the whole backlog and renumbered whenever
     that order changes. This file's Directory Tree, `**Naming:**` line and copy-the-template step
     were updated to match, and _Why the filename carries a build-order prefix_ added, mirroring
     `../16-SPRINT-PLANS/CONTEXT.md` → _Why a filename carries two numbers_. `./CLAUDE.md` owns
     the rule and the contrast with the sprint-plan one.

     Two things asked for and deliberately NOT done, both for reasons this repository has already
     settled, and both stated here WITHOUT naming the artefacts that settled them, because this
     file ships and may name no per-project story, map or plan. (1) A Plans Index table with
     instance rows — including reserved rows for numbers taken by unwritten plans. Two of the
     plans in this folder decline that row ON THE RECORD, the standing gap register carries it
     claimed, and the register-index work charted in `../01-FEATURE-MAPS/` owns the file it should
     live in; creating it here would ship per-project citations in a copier-included file. The
     section _The plans index_ above records the decline instead, and each reserved number is
     recorded in the story that owns it, under `../02-STORIES/`, which does not ship.
     (2) `**Last Updated**` bumped to 08/09/2026 — the field holds `<%DATE%>`,
     a Copier token rendered at generation, in all 138 shipped `CONTEXT.md` files. Hard-coding a
     date here would ship 08/09/2026 into every project generated afterwards and would leave this
     file the only one of the 138 out of pattern. The update date is this comment. -->

<!-- 08/09/2026, later the same day: two corrections to _The plans index_ above; the comment above
     is kept as the record of the position held at that hour. (1) The section's closing sentence
     read "Until that lands, the instructions elsewhere that require a row here stand unaltered and
     the row is not added; a plan's own status lives in its metadata table and in its story." It
     was true this morning and was falsified during the day: the four
     `../../workflows/17-story-plans/` files and this folder's `CLAUDE.md` were re-pointed at the
     sprint plan's _Story Plans — the code master_ table earlier on 08/09/2026, and the plan
     template and the plans on disk followed in the pass that wrote this note. The sentence now
     describes that. (2) The section named the deferred index file in backticks, as
     "STORY-PLAN-INDEX.md" — a file that exists in no repository, this one or any generated from
     it, cited from a file that ships and read by the citation gate, which takes backticked tokens
     as paths. It is now described rather than named: the register-index work charted in
     `../01-FEATURE-MAPS/` names its own file when it lands. -->
