@./CONTEXT.md

# CLAUDE.md — project-management/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the why, the planning cadence, and the 23-step index, imported above) → this file →
the target `NN-…/` workflow's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The ordered PM playbook — twenty-three numbered procedures (`01-feature-map` …
`23-release`) that carry a feature from its decision map and a written story, through
design, GDPR, security, QA, SEO and API gates, into code, documentation, PR, and release.

## How to work here

- **Routing:** never freehand a PM task — open the matching `NN-…/` folder and run its
  `STEPS.md` against its `CHECKLIST.md`. The numbering is the running order. Load the
  matching skills (`story`, `sprint`, `planner`, `gdpr-mechanics`, `security`,
  `qa-tester`, `seo`, `git`, `version`, `completion`) for the heavy steps.
- **The cadence is per story, not per phase** (`CONTEXT.md` → _The planning cadence_):
  one story runs `02`→`14` before the next begins; when the open sprint reaches
  `<%SPRINT_CAPACITY_SP%>` SP (grace `<%SPRINT_GRACE_SP%>`), `15` and `16` run for that
  sprint's stories; once every story is planned, `17` consolidates the per-story design
  and schema work. Do not batch a gate across the whole backlog.
- **Grill first:** every substantial workflow — design, code, test, QA, review, refactor —
  opens with a grilling pass; the owning skill loads `.claude/skills/grill-with-docs` and
  interviews <%DEVELOPER_NAME%> before producing the artefact (`.claude/CLAUDE.md` Section 10).
  Only trivial/mechanical steps skip it.
- **Model:** Fable to author a design/spec procedure (01–10, 12–16); Opus for SEO (11),
  the code procedures (18–20), documentation (21), and PR/release (22–23); Opus to fix a
  checklist typo, bump a `Last Updated` date, or renumber a step.
- **Concrete steps:** read the workflow `CONTEXT.md` → follow `STEPS.md` in order →
  write the artefact into the matching `src/NN-…/` folder and phase sub-folder → satisfy
  every `CHECKLIST.md` item before marking the step done.
- **Definition of done:** the workflow's checklist is fully ticked, the artefact
  landed in the correct numbered `src/` folder, and the next workflow's prerequisites
  are met.
- **Routing frontmatter:** every `STEPS.md`/`CHECKLIST.md` here carries `workflow`/`phase`/`skills`/`model` frontmatter — read it first and route accordingly (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **The gates bite in order:** a story is not planned until `14` is done; a sprint is not
  planned until it fills; **no code starts until `17` has consolidated the design**; a PR
  is not mergeable until `22-pr-and-review/` is signed off; a release follows
  `23-release/` only. Do not skip forward.
- **Do not batch the specify tier.** Running `01` for ten stories, then `03` for ten
  stories, defeats the compounding the loop exists for and guarantees a consolidation
  pass with ten-way collisions instead of two-way ones.
- **Stage-1 design artefacts are frozen once `17` runs** — `USER-STORY-IDEAS/` is the
  audit trail of what each story asked for, never rewritten in place.
- **These are instructional files** — each `CONTEXT.md`, `STEPS.md`, and `CHECKLIST.md`
  stays **≤ 300 code lines**; split an oversized one and make the entry point a thin
  index.
- Every workflow folder keeps its four-file shape (`CONTEXT.md` + `CLAUDE.md` +
  `STEPS.md` + `CHECKLIST.md`).
- **These numbers are a sequence, not a catalogue.** Unlike `code/workflows/` and
  `how-to/workflows/`, inserting one mid-sequence means renumbering everything after it
  and sweeping every reference — including `.claude/skills/`, where a stale number is a
  silent routing failure.
- **Never renumber a `project-management/src/NN-…/` folder to match.** Workflow folders are
  documentation the template owns; `src/` folders hold artefacts a developer wrote. Copier
  cannot move those on update — it relocates its own scaffolding and silently strands the
  developer's files in a folder nothing references. `src/` numbers are **frozen, append only**;
  when the mirroring breaks, the mirroring gives way (`CONTEXT.md` → _…but `src/` numbers are
  frozen_).
- British English throughout; dates DD/MM/YYYY.

## Output & naming

- **Hand-written:** `STEPS.md` and `CHECKLIST.md` in each folder; `CONTEXT.md` is the
  orientation file (holds the tree).
- **Nothing here is generated** — the artefacts these workflows produce live under
  `project-management/src/`, not in this tree.
- Workflow folders `NN-kebab-case/`; documentation files `SCREAMING-SNAKE-CASE.md`.
