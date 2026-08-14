---
workflow: 17-consolidate-design-work
phase: design
skills: [planner, global-workflow, codebase-design, domain-modelling]
model: fable
---

# Consolidate Design Work — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

| Step        | Reference                                                                     |
| ----------- | ----------------------------------------------------------------------------- |
| All steps   | This folder's `CONTEXT.md` — the two stages and the five folders in scope     |
| Step 2 (03) | `code/docs/DATABASE.md` — constraints, scope columns, lock-safe migrations    |
| Step 2 (05) | `code/docs/DESIGN-TOKENS.md` — token-first; DB-canonical values               |
| Step 4      | `project-management/src/14-DECISIONS/` — where a hard-to-reverse choice lands |
| Step 7      | `project-management/src/16-STORY-PLANS/` — plans this pass may invalidate     |

---

## Prerequisites

- [ ] Every story is through `16-story-plans/`
- [ ] Every in-scope story has `USER-STORY-IDEAS/` artefacts, or an explicit `N/A`
- [ ] `code/docs/DATABASE.md` and `code/docs/DESIGN-TOKENS.md` read

---

## Steps

### Step 1 — Grill, then Scope the Pass

> **Model:** fable

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%>:

- Which of the five folders genuinely accumulated work this cycle?
- What counts as a collision here — identical concept only, or near-neighbours too?
- How aggressively to merge: one canonical component with variants, or several siblings?
- Anything already known to be contentious between two stories?

### Step 2 — Inventory Stage 1

> **Model:** fable

Walk `USER-STORY-IDEAS/` in each in-scope folder and build one inventory table per folder:
artefact, owning `US###`, the concept it introduces, and what it depends on.

Do this **for all five folders before resolving anything** — a collision is only visible
once both sides are on the page.

### Step 3 — Find the Collisions

> **Model:** fable

Against the inventory, mark every:

- **Duplicate** — two stories that built the same thing under different names
- **Divergence** — the same concept modelled two ways (a `status` enum with different
  members; a badge with different states)
- **Orphan** — an artefact nothing downstream references
- **Contradiction** — two artefacts that cannot both be true (two delete behaviours on
  one relationship)

Record each with the stories on both sides. Finding none means the pass was shallow —
say so explicitly rather than reporting a clean sweep.

### Step 4 — Resolve, Escalating What Is Hard to Reverse

> **Model:** fable

Resolve each finding to **one canonical form**, taking `04-DATABASE` first — schema
fragmentation is the expensive kind (`code/docs/DATABASE.md`).

For each: state the chosen form, the rejected alternative, and why. Where the choice is
hard to reverse, or a later decision would need to explicitly supersede it, raise an ADR
via `14-decisions/` and cite it rather than burying the reasoning here.

Where resolving reveals a genuine capability gap, **write a new user story** through
`02-story-creation/`. Do not quietly widen scope in a consolidation pass.

### Step 5 — Write the Consolidated Artefacts

> **Model:** fable

Write `CONSOLIDATED-IDEAS/` in each in-scope folder. Every consolidated artefact:

- names the `US###` stories whose stage-1 work it supersedes
- carries the resolution rationale for anything that was a collision
- links any ADR raised in Step 4

Leave every `USER-STORY-IDEAS/` file untouched — stage 1 is frozen, not rewritten.

**Then run the design-time slop gate over the rebuilt screen set** — this is the one moment the
whole set exists at once, which is what makes its page-set clauses decidable at all
(`DESIGN.md` → _The design-time gate_):

```bash
bash code/src/scripts/audits/css-slop.sh
bash code/src/scripts/audits/template-slop.sh
bash code/src/scripts/audits/render-slop.sh   # opens each screen at 1280 px
```

Fix findings in the screens, never by loosening a threshold. A `[gate: warn]` is a question:
answer it, or annotate it with `slop-allow` **naming the clause and the reason**. If the Section 4.2 leg
reports that it skipped, an axis in `code/docs/VISUAL-DESIGN.md` Section 3 is still `TBD` — that is
first-time setup Step 9 outstanding, not a clean run.

**The third script is the only one that opens a browser, and it is the only one that can see the
repetition tell.** The first two read the screens as text, and text has no viewport: the same grid
is a one-, two- or three-column device depending on width, so a three-up reads clean at every
width below 64rem. `render-slop.sh` reports a device stamped **down a screen** and a signature
recurring **across the set** — the second is the page-set property nothing else in the toolchain
reaches. Both are warnings, because a directory or taxonomy screen repeats one card legitimately.
It needs no stack. If it reports that Chromium is absent it has **measured nothing** — that is not
a clean run either; install it and re-run
(`uv run --no-project --with playwright playwright install chromium`).

### Step 6 — Regenerate the Deliverables

> **Model:** opus

Consolidated tokens and components are only real once the generators agree:

- `src/06-BRAND-GUIDE/guide-build/` — update `INPUTS` in `brand_guide.py`, re-run,
  check `brand_guide.py --check` passes
- `src/07-COMPONENTS/component-build/` — update the palette and `section-*.tex`
  partials, re-run, check `components.py --check` passes

Commit `.py`, `.tex`, and `.pdf` together. Never hand-edit the generated files.

### Step 7 — Reconcile the Story Plans

> **Model:** fable

For every `STORY-PLAN-US###-*.md` whose technical approach assumed a shape this pass
changed, correct the plan and note the consolidation that drove it.

This step is what makes the two-stage model safe: the developer codes from the story
plan, so a plan left asserting a superseded design silently undoes the consolidation.

### Step 8 — Close Out

> **Model:** opus

- Update each touched `CONTEXT.md`/`CLAUDE.md` and refresh the code-review-graph
- Confirm every stage-1 artefact is either carried forward or recorded as superseded
- Satisfy `CHECKLIST.md`

Next: `18-backend-code/`.
