---
workflow: 15-story-plans
phase: design
agent: planner
skills: [global-workflow]
model: fable
---

# Story Plans — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Live Artefacts** (src/15-STORY-PLANS/, src/14-SPRINT-PLANS/, src/13-DECISIONS/) for supporting references.

Use this checklist to verify the story plan is complete before implementation begins.

## Prerequisites

- [ ] Story is slotted into a sprint (`src/14-SPRINT-PLANS/`)
- [ ] Every 01–12 spec relevant to this story is signed off
- [ ] Any ADR this story rests on is `Accepted` in `src/13-DECISIONS/`

## Template & Naming

- [ ] Plan copied from `STORY-PLAN-US000-TEMPLATE.md` — never started from scratch
- [ ] Filename follows `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
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

- [ ] Story is broken into phased implementation tasks mapped to `16-backend-code` →
      `17-api-code` → `18-frontend-code`
- [ ] Phase dependencies are stated explicitly — which phase must land before the next
- [ ] Dependencies table complete: 4-column story matrix plus `Blocked by` / `Blocks` /
      `Can be done now`
- [ ] Dependency callout is accurate against the parallel-worktree DAG

## GDPR, Security & QA

- [ ] GDPR obligations carried in from `src/08-GDPR/` (or section removed with reason: no
      personal data touched)
- [ ] Every state-changing endpoint the plan introduces has an explicit permission check
      and ownership verification noted (OWASP A01, no IDOR)
- [ ] Security constraints carried in from `src/09-SECURITY/`
- [ ] QA scenarios and edge cases carried in from `src/10-QA/`

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

- [ ] Plan saved to `src/15-STORY-PLANS/STORY-PLAN-US###-<descriptor>.md`
- [ ] Row added to `src/15-STORY-PLANS/CONTEXT.md` → Plans Index, with Status
- [ ] Driving user story (`src/01-STORIES/US###.md`) updated with a reference to this plan
- [ ] Ready to proceed to `project-management/workflows/16-backend-code/`
