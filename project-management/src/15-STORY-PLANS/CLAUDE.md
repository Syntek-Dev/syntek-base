@./CONTEXT.md

# CLAUDE.md — src/15-STORY-PLANS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(plans index + tier position + Docker/Nginx conventions, imported above) → this file.

## Purpose (one line)

Per-story implementation plans — one `STORY-PLAN-US###-*.md` per user story (plus
cross-cutting `PLAN-<DESCRIPTOR>.md` programme plans) — written **before** implementation
to fix the technical approach, key decisions, dependencies, risks, and per-story worktree
isolation files. Tier 15: the **master a developer codes from**.

## How to work here

- **Routing:** planning work → `planner` (Fable) for the architectural plan. It rests on
  the sprint plan (`../14-SPRINT-PLANS/`) and the decisions (`../13-DECISIONS/`); once
  written it feeds the implementation phase — the code workflows and the PM code/PR
  workflows (`16-backend-code` → `21-release`). Copy `STORY-PLAN-US000-TEMPLATE.md` — the
  canonical superset — for every new plan; never start from scratch.
- **Model:** Fable for the substance (approach, decisions table, dependency DAG, risks);
  Opus for status flips in the index table or mechanical link fixes.
- **Concrete steps:** copy the template → name it `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
  → complete every section (problem, technical approach, key decisions, dependencies,
  deferred, risks, Docker & Nginx) → add the row to the Plans Index with its status →
  keep the `blocked-by`/`blocks` callout honest so the DAG stays accurate.
- **Definition of done:** plan named to convention, indexed with a status, linked to
  its `US###`, its sprint plan (14), and the decisions (13) it rests on; the four
  worktree isolation files named per the story number; British English throughout.

## Guardrails

- **This is a planning document, not code** — no source, secrets, or `.env` content
  lands here. GDPR/security/IDOR obligations are _specified_ in the plan and _enforced_
  in `code/`; keep them consistent with `code/docs/SECURITY.md`.
- **Docker & Nginx isolation files** referenced by a plan follow the fixed
  `docker-compose.us###.{dev,test}.yml` / `nginx/{dev,test}-us###.conf` naming with a
  unique `127.0.0.N` IP and the documented port block — collisions break parallel
  worktrees.
- **Status must be truthful** — a plan marked anything other than `Blocked` asserts its
  blockers are cleared; the cross-cutting parallel-worktree dependency DAG depends on it.
- Root-level plans under `src/` are exempt from the 300-line instructional limit, but
  keep the index table current on every add.

## Output & naming

- **Hand-written:** every `STORY-PLAN-US###-*.md` and `PLAN-<DESCRIPTOR>.md`, plus the
  folder index in `CONTEXT.md`.
- **Template:** `STORY-PLAN-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- Per-story plans `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`; cross-cutting programme
  plans `PLAN-<DESCRIPTOR>.md`; stories referenced as `US###`; dates DD/MM/YYYY.
