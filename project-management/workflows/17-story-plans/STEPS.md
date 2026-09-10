---
workflow: 17-story-plans
phase: design
skills: [planner, global-workflow]
model: opus
---

# Story Plans — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

<!-- 08/09/2026: every "Plans Index" instruction in this file was rewritten to describe what
     exists. Superseded text, preserved rather than deleted — the Naming row read
     "src/17-STORY-PLANS/CONTEXT.md — the Plans Index, which is where build order is read";
     Step 2 item 4 ended "the Plans Index carries the row, and the file is added later at that
     number"; the renumbering sentence listed "the plans, the Plans Index rows, and every
     citation of them"; Step 10 item 2 read "Add the row to `src/17-STORY-PLANS/CONTEXT.md` →
     Plans Index (file link, story, Status), keeping the index in `<exec-order>` sequence".
     Step 10's row instruction pre-dates today; the other three sites arrived earlier today with
     the `<exec-order>` prefix. Why: no Plans Index exists, and
     `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ records its absence as a decision —
     that file ships, so an index row would put a per-project citation in a shipped file. The
     job each site did — recording that a plan exists, and where its number is read from — is
     re-pointed at what holds the information today: the sprint plans in
     `src/16-SPRINT-PLANS/`, whose `<exec-order>` sequence is the build order and whose
     _Story Plans — the code master_ tables index each plan against its sprint, and the owning
     story under `src/02-STORIES/`, which records a reserved number. A folder-level index is
     deferred to the register-index work charted in `src/01-FEATURE-MAPS/`; no file is named for
     it here because none exists yet. -->

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step             | Section                                                                                        |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| All steps        | **Internal — Live Artefacts** → src/17-STORY-PLANS/                                            |
| All steps        | src/17-STORY-PLANS/CLAUDE.md — copy-the-template rules, dependency DAG honesty                 |
| Template         | src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md — the canonical superset scaffold           |
| Naming           | src/17-STORY-PLANS/CONTEXT.md → _The plans index_ — no folder index; where a reservation lives |
| Build order      | src/16-SPRINT-PLANS/ — the sprint plans in `<exec-order>` sequence; their _Story Plans_ tables |
| Gathering inputs | **Internal — Live Artefacts** → src/16-SPRINT-PLANS/, src/15-DECISIONS/                        |

---

## Prerequisites

- [ ] Story slotted into a sprint (`src/16-SPRINT-PLANS/##-SPRINT-PLAN-##.md`)
- [ ] Every 02–14 spec relevant to this story exists and is signed off (GDPR, security,
      QA, SEO, API design as applicable)
- [ ] Any ADR this story rests on is `Accepted` in `src/15-DECISIONS/`

---

## Steps

### Step 1 — Grill, then Gather Inputs

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — scope, which layers are in scope (database /
service / API / frontend / infra / GDPR), phasing, and any open architectural question.

Gather:

- The sprint plan (`src/16-SPRINT-PLANS/`) — goal, priority, and phase assignment for this
  story
- Every ADR (`src/15-DECISIONS/`) the story rests on
- Every relevant 02–14 spec: story, schema, user flow, wireframes, GDPR, security, QA, SEO, logging,
  API design
- The GDPR, security, and QA constraints each spec carries — these are **carried into** the
  plan, not re-derived

### Step 2 — Copy the Template

<!-- 08/09/2026: the naming convention gained an `<exec-order>-` prefix. Superseded text,
     preserved rather than deleted: "Copy "src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md" to
     `src/17-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`." -->

Copy `src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` to
`src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`. Never start
from scratch. Keep the ★-marked core sections always; keep ◇-marked sections only where the
story touches that concern, and say in one line why a dropped section does not apply.

**Computing `<exec-order>`** — 2-digit zero-padded, and it is the story's **position in the
settled build order across the whole backlog**, not its sprint and not a per-sprint counter:

1. Take the sprint plans in `src/16-SPRINT-PLANS/` in their own `<exec-order>` order — that
   prefix is the sequence the sprints are built in, which is not always their sprint number.
2. Within each sprint plan, take its stories in the order that plan sequences them.
3. Concatenate those lists into one backlog-wide build order and number it from `01`. `00-`
   is the template, mirroring `00-SPRINT-PLAN-00-TEMPLATE.md`, so a real plan never takes it.
4. A number is **reserved** as soon as the position is settled, even where the plan is not
   yet written. The reservation is recorded in the story that owns it
   (`src/02-STORIES/US###.md`) and, where a sprint plan already carries that story, as a
   no-file row naming the reserved prefix in that plan's _Story Plans — the code master_
   table; the file is added later at that number. There is no folder-level index to carry it
   — `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ records why.

**Renumber when build order changes.** The prefix is a claim about sequence, so a reordered
backlog is renumbered — the plans, their rows in the sprint plans' _Story Plans — the code
master_ tables, and every citation of them — in the same change that reorders it.

> **This is the opposite of the sprint-plan guardrail, deliberately.**
> `src/16-SPRINT-PLANS/CLAUDE.md` holds that a mismatch between a sprint plan's
> `<exec-order>` prefix and its `<sprint-number>` suffix is **information, not a typo**, and
> must never be "corrected". That rule protects a **pair** of numbers: a sprint plan carries
> both, and the divergence between them is what says the sprint is being built out of
> sprint-number order. A story plan carries **one** number, so it has no pair to disagree
> with — if its prefix does not track build order it says nothing at all. Do not read the
> sprint-plan guardrail across to this folder.

### Step 3 — Fix the Technical Approach

Complete the Problem Statement, the Reference Documents gate map, Architecture Decision
(raise a new ADR in `src/15-DECISIONS/` — via `workflows/15-decisions/` — if the story
makes a cross-cutting choice), and Approach — per layer (database / service / API /
frontend) or per phase for a multi-step story.

### Step 4 — Break the Story into Phased Implementation Tasks

Map the approach onto the code workflow chain, noting explicit phase dependencies:

| Phase    | PM workflow        | Produces                                                                            |
| -------- | ------------------ | ----------------------------------------------------------------------------------- |
| Backend  | `19-backend-code`  | Models, services, migration (TDD via `code/workflows/02-tdd-cycle/`)                |
| API      | `20-api-code`      | Django Ninja routers, endpoints, request/response schemas, permission checks        |
| Frontend | `21-frontend-code` | Templates, django-components, HTMX partials — component-library reuse checked first |

State which phase must land before the next can start, and which slice is startable now
regardless of blockers (mirrors the plan's `Can be done now` line).

### Step 5 — Fill the Key Decisions and Dependencies Tables

- Key decisions: chosen vs rejected, with rationale and a doc reference
- Dependencies: the 4-column story matrix, plus `Blocked by` / `Blocks` / `Can be done
now` — keep this honest, the parallel-worktree DAG depends on it

### Step 6 — Carry In GDPR, Security, and QA Constraints

Copy the obligations from the 02–14 specs into the plan's GDPR, Security, and Testing
sections — do not re-derive them:

- GDPR — personal data touched, lawful basis, retention, rights mechanics, from
  `src/09-GDPR/`
- Security — AuthN/AuthZ, mutation permission checks (A01), IDOR, input validation, from
  `src/10-SECURITY/`
- QA — test scenarios and edge cases, from `src/11-QA/`

Every mutation the plan introduces must carry an explicit permission check and ownership
verification in the plan's Security table — no exceptions.

### Step 7 — Define the Test Strategy

Complete the plan's Testing section per layer: unit & integration (services), template /
component / HTMX-partial rendering, API permission-check tests, markup-level accessibility,
browser e2e (a11y scan + responsive overflow), and manual testing — one coverage floor per
`code/docs/TESTING.md` (75% line and branch, 90% auth). The browser suite is excluded from
coverage; it exercises a running stack over HTTP and instruments nothing.

### Step 8 — Run the Planner Agent

```text
planner [story, sprint plan, ADRs, and every 02–14 spec gathered in Step 1]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `planner` · **Model:** opus · **MCP:** none

### Step 9 — Adversarial Plan Review

> **Model:** opus

Spawn 2–3 independent reviewers to critique the draft before it is treated as codeable:
missing layers, unhandled GDPR/security, wrong doc references, dependency-order errors,
unscoped deferrals. Resolve every finding.

### Step 10 — Save, Index, and Cross-Reference

<!-- 08/09/2026: superseded, preserved rather than deleted — step 1 read
     "Save to `src/17-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`". -->

1. Save to `src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`,
   with `<exec-order>` computed per Step 2 and confirmed still current — the build order may
   have moved while the plan was being written
2. Index the plan where a plan is indexed today: the story's row in its sprint plan's
   _Story Plans — the code master_ table (`src/16-SPRINT-PLANS/##-SPRINT-PLAN-##.md`) — the
   file path replacing any reserved-number placeholder, the Status cell filled as that plan's
   own section defines the column. Add nothing to `src/17-STORY-PLANS/CONTEXT.md`: it ships,
   and its _The plans index_ section records that it holds no index by decision; the
   folder-level index is deferred to the register-index work charted in
   `src/01-FEATURE-MAPS/`, which names its own file when it lands
3. Reference the plan in the driving user story (`src/02-STORIES/US###.md`)
4. Proceed to `workflows/19-backend-code/` to begin implementation

### Step 11 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` + `CLAUDE.md` inside it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
