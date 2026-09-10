---
workflow: 17-story-plans
phase: design
skills: [planner, global-workflow]
model: opus
---

# Story Plans — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Live Artefacts** (src/17-STORY-PLANS/, src/16-SPRINT-PLANS/, src/15-DECISIONS/) for supporting references.

Use this checklist to verify the story plan is complete before implementation begins.

## Prerequisites

- [ ] Story is slotted into a sprint (`src/16-SPRINT-PLANS/`)
- [ ] Every 02–14 spec relevant to this story is signed off
- [ ] Any ADR this story rests on is `Accepted` in `src/15-DECISIONS/`

## Template & Naming

<!-- 08/09/2026: the naming rows gained the `<exec-order>-` prefix. Superseded text, preserved
     rather than deleted: "Plan copied from "STORY-PLAN-US000-TEMPLATE.md"" and
     "Filename follows `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`". -->

- [ ] Plan copied from `00-STORY-PLAN-US000-TEMPLATE.md` — never started from scratch
- [ ] Filename follows `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the prefix
      2-digit zero-padded
- [ ] `<exec-order>` is the story's position in the settled backlog build order (STEPS.md
      Step 2) — **not** its sprint number and **not** a per-sprint counter
- [ ] No other plan holds that number, and any number reserved for an unwritten plan is
      left alone
- [ ] If build order moved while this plan was written, every affected plan, its row in the
      sprint plans' _Story Plans — the code master_ tables, and every citation was renumbered
      in the same change
- [ ] ★-marked core sections are all present; ◇-marked sections kept only where the
      concern applies, with a one-line reason for any dropped

## Technical Approach

- [ ] Problem Statement, Reference Documents gate map, and Approach are complete for every
      in-scope layer
- [ ] Architecture Decision section links a new or existing ADR where the story makes a
      cross-cutting choice
- [ ] Key Decisions table records chosen vs rejected, each with a rationale and doc
      reference

## Phasing & Dependencies

- [ ] Story is broken into phased implementation tasks mapped to `19-backend-code` →
      `20-api-code` → `21-frontend-code`
- [ ] Phase dependencies are stated explicitly — which phase must land before the next
- [ ] Dependencies table complete: 4-column story matrix plus `Blocked by` / `Blocks` /
      `Can be done now`
- [ ] Dependency callout is accurate against the parallel-worktree DAG

## GDPR, Security & QA

- [ ] GDPR obligations carried in from `src/09-GDPR/` (or section removed with reason: no
      personal data touched)
- [ ] Every state-changing endpoint the plan introduces has an explicit permission check
      and ownership verification noted (OWASP A01, no IDOR)
- [ ] Security constraints carried in from `src/10-SECURITY/`
- [ ] QA scenarios and edge cases carried in from `src/11-QA/`

## Test Strategy

- [ ] Test strategy defined per layer: unit & integration, component, API/contract,
      Django Ninja permission-check tests, accessibility/E2E, manual testing
- [ ] Coverage floors referenced (`code/docs/TESTING.md`: 75% line and branch / auth 90% — one floor)

## Review

- [ ] Plan reviewed by 2–3 independent adversarial passes; findings resolved
- [ ] Deferred items and risks recorded, each with a target future story where applicable

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` + `CLAUDE.md`

---

## Sign-off

<!-- 08/09/2026: superseded, preserved rather than deleted — the row read
     "Plan saved to `src/17-STORY-PLANS/STORY-PLAN-US###-<descriptor>.md`". -->

<!-- 08/09/2026, later the same day: both "Plans Index" rows in this file were rewritten to
     describe what exists. Superseded text, preserved rather than deleted — under Template &
     Naming: "every affected plan, Plans Index row and citation was renumbered in the same
     change" (added earlier today with the `<exec-order>` prefix); here under Sign-off: "Row
     added to `src/17-STORY-PLANS/CONTEXT.md` → Plans Index, with Status, and the index still
     reads in `<exec-order>` sequence" (the row-added clause pre-dates today; the sequence
     clause was added today). Why: no Plans Index exists —
     `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ records its absence as a decision,
     because that file ships and an index row would put a per-project citation in it. The job
     each row did is re-pointed at where a plan is indexed today: its sprint plan's
     _Story Plans — the code master_ table in `src/16-SPRINT-PLANS/`. The folder-level index is
     deferred to the register-index work charted in `src/01-FEATURE-MAPS/`; no file is named
     for it because none exists yet. -->

- [ ] Plan saved to `src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-<descriptor>.md`
- [ ] The story's row in its sprint plan's _Story Plans — the code master_ table
      (`src/16-SPRINT-PLANS/##-SPRINT-PLAN-##.md`) names this file, any reserved-number
      placeholder replaced, its Status cell filled as that plan's own section defines the column
- [ ] Nothing added to `src/17-STORY-PLANS/CONTEXT.md` — it holds no index by recorded decision
      (its _The plans index_ section), and the folder-level index is deferred
- [ ] Driving user story (`src/02-STORIES/US###.md`) updated with a reference to this plan
- [ ] Ready to proceed to `project-management/workflows/19-backend-code/`
