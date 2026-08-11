---
name: prototype
description: >-
  Build a throwaway prototype — a spike that answers ONE design question, then is discarded.
  Invoke by typing /prototype, or when the user wants to sanity-check whether a state model or
  algorithm feels right (LOGIC branch) or explore what a screen should look like (UI branch)
  before committing to a real build.
---

# Skill: Prototype (<%PROJECT_SLUG%>)

A prototype is **throwaway code that answers one question**, then is discarded. It is a
**spike** — a tracer bullet fired to see where it lands, not a foundation to build on. The
**one question** decides the shape; the answer, not the code, is the deliverable. Ship-rules
relax inside a spike because nothing ships — that is the licence of a spike, and it is earned
only by the paired boundary that a spike never merges to a release branch.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## Steps

### 1. Frame the one question

Write the single design question the spike answers, in one sentence, at the top of the work.
Discover the surrounding context yourself — `code-review-graph` (structure) → Read/Grep/Glob
→ `.claude/plugins/*.py` — rather than asking. A spike that chases two questions answers
neither.

**Done when:** one sentence names the single question, and it is a design question ("does
this feel right?"), not a build task.

### 2. Pick the branch — LOGIC or UI

The question type chooses the branch:

- **LOGIC** — "does this state model / algorithm feel right?" → an interactive terminal
  harness that pushes the states through the cases hard to reason about on paper.
- **UI** — "what should this screen look like?" → several variants of one screen, rendered on
  a single throwaway route in the real stack.

Ambiguous and <%DEVELOPER_NAME%> unreachable? Default by surrounding code — a backend module leans LOGIC, a
page or component leans UI — and state the assumption at the top of the spike.

**Done when:** the branch is named in the spike header, with the assumption noted if it was
defaulted.

### 3. Isolate the spike

A spike lives apart from real code:

- On a throwaway branch **`prototype/<slug>`**, or in a git worktree — mechanics in
  `how-to/docs/GIT-WORKTREES.md`, checkout under `.claude/worktrees/`.
- Run only through the dev/test scripts (`code/src/scripts/development|tests/*.sh`).
- Nothing under `code/src/` imports spike code — the isolation runs one way.

**Done when:** the spike sits on `prototype/<slug>` (or its own worktree) and no file under
`code/src/` references it.

### 4. Build the spike (by branch)

Skip the polish — no tests, no error handling beyond what makes it runnable, no abstractions.
Surface the full relevant state so the learning is visible.

**A · LOGIC harness.** A small interactive terminal harness that drives the state machine,
run inside the backend container via `bash code/src/scripts/development/shell.sh`. State lives
in memory — persistence is the thing being checked, not a dependency; if the question
genuinely needs a store, hit a scratch one named "PROTOTYPE — wipe me". Print the full state
after every transition.

**B · UI variants.** Scaffold one throwaway route with
`bash code/src/scripts/development/new-django-view.sh <route_path>` and serve it with
`bash code/src/scripts/development/server.sh up`. Render several genuinely different variants
on that single route, switched by a URL search param and a floating variant bar, built in the
real stack — Django templates + django-components + HTMX + Alpine + token CSS (skill
`stack-htmx-templates`; the signature is `code/docs/visual-design/WEB.md`, under the direction
`code/docs/VISUAL-DESIGN.md` § 3 commits to). The token-first
CSS audit, mutation permission checks, coverage floors, and docs gate are all relaxed here —
this is a spike, nothing ships.

**Done when:** the spike runs from one script command and surfaces its state on every action
(LOGIC) or serves every variant switchable on one URL (UI), and the hard cases the question
turns on are exercised.

### 5. Read the answer, then discard

Exercise the spike until the question has a clear verdict, then land the answer where design
decisions live — the code, not the spike, keeps only what was validated:

- Record the verdict and the question it settled in a story plan's `### Open Questions` /
  `### Requirements` (`project-management/src/16-STORY-PLANS/STORY-PLAN-US###-*.md`, template
  `STORY-PLAN-US000-TEMPLATE.md`).
- If the answer settles a hard-to-reverse, surprising, genuine trade-off, lay ADR groundwork —
  the next free `ADR-###-<TITLE>.md` under `project-management/src/14-DECISIONS/`.
- If the answer pins a domain model or its terminology, record it through the grill-with-docs
  process — glossary into the nearest `CONTEXT.md` plus the three-test ADR gate
  (`.claude/skills/grill-with-docs/SKILL.md`); the modelling reference is
  `code/docs/data-structures/DOMAIN-MODELLING.md`.
- Fold any validated decision into real code as separate, ship-quality work.
- Archive or remove the `prototype/<slug>` branch or worktree; it never merges to a release
  branch.

**Done when:** the question has a recorded verdict in the decision artefact, and the
`prototype/<slug>` branch or worktree is archived or removed.

## Reference

### Spike, not a product surface

A prototype is disposable. It is **not** a charted epic
(`project-management/src/01-FEATURE/MAP-<FEATURE>.md` and the story plans it fans into) and
**not** the wireframes workflow (`project-management/workflows/08-wireframes/`) — those build
production component-preview and wireframe tooling that ships. Reach for a spike to answer a
question fast; reach for those to build the product.

### The licence of a spike, and its boundary

Because nothing ships, the ship gates — token-first CSS
(`code/src/scripts/audits/css-tokens.sh`), mutation permission checks, coverage floors, the
docs hard gate — are relaxed inside the spike. The boundary that earns that licence: the spike
stays on `prototype/<slug>` or a worktree, real code never imports it, and it never merges to
a release branch.

### Where the answer is _not_ recorded

The spike's verdict goes in the plan or ADR (step 5). Keep the rest separate: an unresolved
blocker the spike surfaces belongs in `GAPS.md`; work deferred to a named future story belongs
in `DEFERRED.md`; a reusable pattern the spike taught belongs in `.claude/MEMORY.md`.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/05-user-flow-design/` — answering one open flow question
- `project-management/workflows/08-wireframes/` — answering one open screen question
- `code/workflows/01-new-feature/` — before committing to a real build

## Cross-references

- `.claude/skills/grilling/SKILL.md` · `.claude/skills/grill-with-docs/SKILL.md` — the design
  interview, and the process that records a settled domain decision.
- `how-to/docs/GIT-WORKTREES.md` · `.claude/worktrees/` — isolating a spike in a worktree.
- `code/docs/VISUAL-DESIGN.md` (§ 3 the direction, § 4 the ban list) ·
  `code/docs/visual-design/WEB.md` (the signature) · `.claude/skills/stack-htmx-templates/SKILL.md`
  — the real stack and signature a UI spike is built in.
- `code/docs/data-structures/DOMAIN-MODELLING.md` — the modelling reference for a LOGIC verdict.
- `code/src/scripts/development/shell.sh` · `new-django-view.sh` · `server.sh` — the run
  commands; `code/src/scripts/audits/css-tokens.sh` — the relaxed token gate.
- `project-management/src/16-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` ·
  `project-management/src/01-FEATURE/` · `project-management/workflows/08-wireframes/` — plan
  template, and the charted epics and workflow to distinguish a spike from.
- `project-management/src/14-DECISIONS/` · `project-management/src/02-STORIES/US###.md` —
  ADR home (take the next free `ADR-###`) and story home.
- `GAPS.md` · `DEFERRED.md` · `.claude/MEMORY.md` — where non-verdict findings go.
