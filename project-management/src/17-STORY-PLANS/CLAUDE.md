@./CONTEXT.md

# CLAUDE.md — src/17-STORY-PLANS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(naming, tier position + Docker/Nginx conventions, imported above) → this file.

## Purpose (one line)

Per-story implementation plans — one `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
per user story (plus cross-cutting `PLAN-<DESCRIPTOR>.md` programme plans) — written **before**
implementation to fix the technical approach, key decisions, dependencies, risks, and per-story
worktree isolation files. Tier 15: the **master a developer codes from**.

## How to work here

- **Routing:** planning work → `planner` (Fable) for the architectural plan. It rests on
  the sprint plan (`../16-SPRINT-PLANS/`) and the decisions (`../15-DECISIONS/`); once
  written it feeds the implementation phase — the code workflows and the PM code/PR
  workflows (`19-backend-code` → `24-release`). Copy `00-STORY-PLAN-US000-TEMPLATE.md` — the
  canonical superset — for every new plan; never start from scratch.
- **Model:** Fable for the substance (approach, decisions table, dependency DAG, risks);
  Opus for status flips, re-prefixing execution order, or mechanical link fixes.
- **Concrete steps:** copy the template → read the settled build order off `../03-SPRINTS/`
  and `../16-SPRINT-PLANS/`, and take the story's position in it as the `<exec-order>`
  prefix → name the file `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the
  prefix 2-digit zero-padded → complete every section (problem, technical approach, key
  decisions, dependencies, deferred, risks, Docker & Nginx) → point the story's row in its
  sprint plan's _Story Plans — the code master_ table (`../16-SPRINT-PLANS/`) at the file,
  replacing any reserved-number placeholder, its Status cell filled as that plan's own section
  defines the column → keep the `blocked-by`/`blocks` callout honest so the DAG stays accurate.
- **Definition of done:** file named `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`,
  the prefix 2-digit zero-padded and matching the story's position in the current build order;
  indexed against its sprint in that sprint plan's _Story Plans — the code master_ table, linked
  to its `US###`, its sprint plan (16), and the decisions (15) it rests on; the four worktree isolation files named per the story number; British English
  throughout, dates DD/MM/YYYY.

## Guardrails

- **The `<exec-order>` prefix tracks build order, and is RENUMBERED whenever build order
  changes.** It is the story's position across the **whole backlog** — not its sprint, and not a
  per-sprint counter — so a re-plan that reorders stories renames the files. Renumber the whole
  affected run in one pass and repoint every citation in the same change.
- **This is the OPPOSITE of the sibling rule in `../16-SPRINT-PLANS/CLAUDE.md`, and the
  difference is not an inconsistency.** A sprint plan is named
  `<exec-order>-SPRINT-PLAN-<sprint-number>.md` and carries **two** numbers: a mismatch between
  them is deliberate information — build sequence against sprint identity — and must never be
  "corrected". A story plan carries **one**. With nothing to disagree with, a prefix that has
  drifted from build order says nothing at all, so here a mismatch is a defect. Do not read the
  sprint-plan guardrail across into this folder.
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
  keep the story's row in its sprint plan's _Story Plans — the code master_ table current on
  every add and every renumber.
- **No index row goes into `CONTEXT.md` here.** It ships, and its _The plans index_ section
  records that it holds no index by decision. A reserved number is recorded in the owning story
  under `../02-STORIES/` and, where a sprint plan already carries the story, as a no-file row in
  that plan's table. The folder-level index is deferred to the register-index work charted in
  `../01-FEATURE-MAPS/`, which names its own file when it lands.

## Output & naming

- **Hand-written:** every `<exec-order>-STORY-PLAN-US###-*.md` and `PLAN-<DESCRIPTOR>.md`, plus
  the story's row in its sprint plan's _Story Plans — the code master_ table next door.
  `CONTEXT.md` here carries no index.
- **Template:** `00-STORY-PLAN-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
  `00-` is reserved for it, mirroring `../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`, and a
  real plan never takes that prefix.
- Per-story plans `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, both the prefix
  2-digit zero-padded and the story number 3-digit zero-padded; cross-cutting programme plans
  `PLAN-<DESCRIPTOR>.md`, unprefixed — they span several stories and so hold no position in a
  build order; stories referenced as `US###`; dates DD/MM/YYYY.

<!-- RENAMED 08/09/2026. The six plans in this folder were renamed by `git mv` that day from
     `STORY-PLAN-US###-<DESC>.md` to `<exec-order>-STORY-PLAN-US###-<DESC>.md`, and the three
     sections above — _Concrete steps_, _Definition of done_ and _Output & naming_ — were
     rewritten to the new convention, with the build-order guardrail and its contrast against
     `../16-SPRINT-PLANS/CLAUDE.md` added. This file is authoritative for this tree's naming
     (`.claude/CLAUDE.md` Section 5). Two consequences a reader should know: the Plans Index
     instruction moved off line 26, where a live story cites it as measured on 07/09/2026 — that
     citation is date-stamped and stays true of that date; and the instruction itself is left
     standing whatever column it names, because the register-index work charted in
     `../01-FEATURE-MAPS/` claims the creation of the index file all such sites should point at.
     This file ships, so it names no per-project artefact: the stories, maps and plans behind
     each statement above are cited from `../17-STORY-PLANS/`'s own plans, which do not. -->

<!-- 08/09/2026, later the same day: every "Plans Index" instruction in this file was rewritten
     to describe what exists, which reverses the "left standing" position the comment above
     records — that comment is kept as the record of the rename and of the position held at
     that hour. Superseded text, preserved rather than deleted — Concrete steps read "→ add the
     row to the Plans Index with its status →"; Definition of done read "indexed with a status";
     the length guardrail read "but keep the index table current on every add"; Output & naming
     read "plus the folder index in `CONTEXT.md`". All four pre-date today. Why: no Plans Index
     exists — `./CONTEXT.md` → _The plans index_ records its absence as a decision, because that
     file ships and an index row would put a per-project citation in it — so each site sent a
     reader to a table that is not there. The job each did is re-pointed at where a plan is
     indexed today, its sprint plan's _Story Plans — the code master_ table in
     `../16-SPRINT-PLANS/`, and at the owning story under `../02-STORIES/` for a reserved
     number. The folder-level index is deferred to the register-index work charted in
     `../01-FEATURE-MAPS/`; no file is named for it because none exists yet. -->
