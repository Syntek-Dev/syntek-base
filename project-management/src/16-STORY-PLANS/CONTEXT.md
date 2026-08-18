# project-management/src/16-STORY-PLANS

Per-story implementation plans — one plan per user story, written **before**
implementation to fix the technical approach, key decisions, dependencies, and risks.
This is the **master a developer codes from** (tier 15): each plan references up to its
sprint plan (`../15-SPRINT-PLANS/`), the decisions (`../14-DECISIONS/`), and every 02–13
spec. `STORY-PLAN-US000-TEMPLATE.md` is the canonical superset template — copy it for
every new plan.

## Directory Tree

```text
project-management/src/16-STORY-PLANS/
├── CONTEXT.md                    ← this file
├── CLAUDE.md                     ← operating rules for this folder
├── STORY-PLAN-US000-TEMPLATE.md  ← canonical plan template — copy for each new plan
├── STORY-PLAN-US###-<DESC>.md    ← one plan per user story (e.g. STORY-PLAN-US001-<DESC>.md)
└── PLAN-<DESCRIPTOR>.md          ← cross-cutting programme plans spanning several stories
```

This is a base-repo scaffold: the folder ships with the template only. Real plans are
added by copying it.

**Naming:** `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` per story; `PLAN-<DESCRIPTOR>.md`
for cross-cutting programme plans. Wayfinder feature maps live upstream in
`../01-FEATURE-MAPS/`, not here.

## Where it sits (decide & plan tier)

```text
14-DECISIONS  →  15-SPRINT-PLANS  →  16-STORY-PLANS
   (ADRs)         (sprint feeds)      (this folder — code master)
```

Sprint plans (15) feed the story plans (15); the story plan is what implementation
follows. Both are written **before any code**, after the specify tier (02–13).

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

Copy `STORY-PLAN-US000-TEMPLATE.md` → name it `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
→ complete every section → keep the `blocked-by` / `blocks` callout honest so the
dependency DAG stays accurate.

**Last Updated**: <%DATE%>
