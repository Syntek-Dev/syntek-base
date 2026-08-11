---
name: improve-codebase-architecture
description: >-
  Scan the codebase for deepening opportunities — refactors that turn shallow modules into deep
  ones — present them as a visual HTML report, then grill through whichever one is picked. Invoke by
  typing /improve-codebase-architecture, or when <%DEVELOPER_NAME%> asks to review architectural friction, find
  deepening opportunities, or map where the code is shallow. Built on the `codebase-design`
  vocabulary; records decisions via `domain-modelling`; grills via `grill-with-docs`.
---

# Improve Codebase Architecture

> **Adapted from [`mattpocock/skills`](https://github.com/mattpocock/skills)** (MIT, © 2026 Matt
> Pocock) — `skills/engineering/improve-codebase-architecture/SKILL.md`. Required notice:
> `THIRD-PARTY-NOTICES.md`. This is the only skill here adapted rather than independently authored;
> the same-named siblings (`grilling`, `wayfinder`, `codebase-design`, …) are our own.

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow
modules into deep ones. The aim is testability and AI-navigability.

This command is _informed_ by the project's domain model and built on a shared design vocabulary:

- Load **`.claude/skills/codebase-design`** for the architecture vocabulary (**module**,
  **interface**, **depth**, **seam**, **adapter**, **leverage**, **locality**) and its principles
  (the deletion test, "the interface is the test surface", "one adapter is a hypothetical seam, two
  are real"). Use these terms exactly in every suggestion — don't drift into "component," "service"
  (as a loose synonym), "API," or "boundary."
- The domain language in the layered **`CONTEXT.md`** files gives names to good seams
  (**`.claude/skills/domain-modelling`**); the ADRs in **`project-management/src/14-DECISIONS/`**
  record decisions this review must **not** re-litigate.

## Process

### 1. Explore

**Scope before you scan — YAGNI.** Deepening a module pays off by making future changes to it
easier, so put extra weight on the parts of the codebase that have recently changed. Decide _where_
to look before you look:

- If the user named a direction — a module, a subsystem, a pain point — take it, and skip the
  inference below.
- Otherwise, walk back a good stretch of the commit history (`git log --oneline`) to find the
  codebase's hot spots — the files and areas that keep coming up — and let those paths pull your
  attention first. If the changes are scattered with no clear hot spot, widen the net.

Read the area's domain orientation (its `CONTEXT.md`) and any relevant ADR
(`project-management/src/14-DECISIONS/`) first.

Then use the Agent tool with `subagent_type=Explore` to walk the codebase. Don't follow rigid
heuristics — explore organically and note where you experience friction:

- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** — interface nearly as complex as the implementation?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're
  called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts of the codebase are untested, or hard to test through their current interface?

Apply the **deletion test** to anything you suspect is shallow: would deleting it concentrate
complexity, or just move it? A "yes, concentrates" is the signal you want.

### 2. Present candidates as an HTML report

Write a self-contained HTML file into the project's gitignored history folder,
**`code/src/improvement-architecture/`**, so each run is kept as a local record of past architecture
states (the `*.html` reports are gitignored — never committed). Resolve the repo root with
`git rev-parse --show-toplevel`, `mkdir -p` the folder, and write to
`code/src/improvement-architecture/architecture-review-<timestamp>.html` so each run gets a fresh
file. Open it for the user — `xdg-open <path>` on Linux, `open <path>` on macOS, `start <path>` on
Windows — and tell them the absolute path.

The report uses **Tailwind via CDN** for layout and styling, and **Mermaid via CDN** for diagrams
where a graph/flow/sequence reliably communicates the structure. Mix Mermaid with hand-crafted
CSS/SVG visuals — use Mermaid when relationships are graph-shaped (call graphs, dependencies,
sequences), and hand-built divs/SVG when you want something more editorial (mass diagrams,
cross-sections, collapse animations). Each candidate gets a **before/after visualisation**. Be
visual.

For each candidate, render a card with:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — explained in terms of locality and leverage, and how tests would improve
- **Before / After diagram** — side-by-side, custom-drawn, illustrating the shallowness and the deepening
- **Recommendation strength** — one of `Strong`, `Worth exploring`, `Speculative`, rendered as a badge

End the report with a **Top recommendation** section: which candidate you'd tackle first and why.

**Use `CONTEXT.md` vocabulary for the domain, and the `codebase-design` vocabulary for the
architecture.** If a `CONTEXT.md` defines "Conversation," talk about "the Conversation provisioning
module" — not "the ChatProvisioner," and not "the chat service" as a loose synonym.

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is
real enough to warrant revisiting the ADR. Mark it clearly in the card (e.g. a warning callout:
_"contradicts the frontend-stack decision — but worth reopening because…"_). Don't list every theoretical refactor an ADR
forbids.

See [HTML-REPORT.md](HTML-REPORT.md) for the full HTML scaffold, diagram patterns, and styling
guidance.

Do NOT propose interfaces yet. After the file is written, ask the user: "Which of these would you
like to explore?"

### 3. Grilling loop

Once the user picks a candidate, run **`.claude/skills/grill-with-docs`** to walk the decision tree
with them — constraints, dependencies, the shape of the deepened module, what sits behind the seam,
what tests survive. `grill-with-docs` records each resolved decision to the repo as it goes.

Side effects happen inline as decisions crystallise — run **`.claude/skills/domain-modelling`** to
keep the domain model current as you go:

- **Naming a deepened module after a concept not in the area's `CONTEXT.md`?** Add the term to that
  `CONTEXT.md` (creating the `CONTEXT.md` + `CLAUDE.md` pair lazily if the directory has none).
- **Sharpening a fuzzy term during the conversation?** Update the `CONTEXT.md` where it's defined,
  right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR
  (`project-management/src/14-DECISIONS/`), framed as: _"Want me to record this as
  an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would
  actually be needed by a future explorer — skip ephemeral reasons ("not worth it right now") and
  self-evident ones.
- **Want to explore alternative interfaces for the deepened module?** Load
  **`.claude/skills/codebase-design`** and use its design-it-twice parallel sub-agent pattern.

Refresh the code-review-graph after any doc change so the layered docs and the graph stay in lockstep
(`code/docs/CODE-REVIEW-GRAPH.md`).

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/11-refactor/` — where a picked deepening opportunity is executed
- `project-management/workflows/14-decisions/` — where the resulting decision is recorded

## Cross-references

- `.claude/skills/codebase-design/SKILL.md` — the architecture vocabulary + design-it-twice pattern
- `.claude/skills/domain-modelling/SKILL.md` — record the names and decisions this review produces
- `.claude/skills/grill-with-docs/SKILL.md` — the grilling engine step 3 drives
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — the canonical "Deep modules" write-up
- The refactor / review agents and workflows `11-refactor` / `07-review` route to this review
