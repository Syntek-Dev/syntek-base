@./CONTEXT.md

# CLAUDE.md — project-management/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the 18-step index, imported above) → this file → the target `NN-…/` workflow's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The ordered PM playbook — twenty-one numbered procedures (`01-story-creation` …
`21-release`) that carry a feature from a written story, through design, GDPR,
security, QA, SEO and API gates, into code, documentation, PR, and release.

## How to work here

- **Routing:** never freehand a PM task — open the matching `NN-…/` folder and run its
  `STEPS.md` against its `CHECKLIST.md`. The numbering is the running order: design
  gates (01–15) precede code (16–18), then documentation (19), PR (20), and release (21). Reach
  for the internal agents (`user-story`, `sprint`, `gdpr`,
  `security`, `qa-tester`, `seo`, `git`, `version`, `completion`) for the heavy
  steps.
- **Grill first:** every substantial workflow — design, code, test, QA, review, refactor —
  opens with a grilling pass; the owning agent loads `.claude/skills/grill-with-docs` and
  interviews {{DEVELOPER_NAME}} one question at a time before producing the artefact (`.claude/CLAUDE.md` §10).
  Only trivial/mechanical steps skip it.
- **Model:** Fable to author a design/spec procedure (01–10, 12–15); Opus for SEO (11),
  the code procedures (16–18), documentation (19), and PR/release (20–21); Opus to fix a checklist typo,
  bump a `Last Updated` date, or renumber a step.
- **Concrete steps:** read the workflow `CONTEXT.md` → follow `STEPS.md` in order →
  write the artefact into the matching `src/NN-…/` folder → satisfy every
  `CHECKLIST.md` item before marking the step done.
- **Definition of done:** the workflow's checklist is fully ticked, the artefact
  landed in the correct numbered `src/` folder, and the next workflow's prerequisites
  are met.
- **Routing frontmatter:** every `STEPS.md`/`CHECKLIST.md` here carries `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first and route accordingly (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **The gates bite in order:** a feature is not codeable until 01–15 are complete; a PR
  is not mergeable until `20-pr-and-review/` is signed off; a release follows
  `21-release/` only. Do not skip forward.
- **These are instructional files** — each `CONTEXT.md`, `STEPS.md`, and `CHECKLIST.md`
  stays **≤ 300 code lines**; split an oversized one and make the entry point a thin
  index.
- Every workflow folder keeps its three-file shape (`CONTEXT.md` + `STEPS.md` +
  `CHECKLIST.md`); a new one needs a `CONTEXT.md`.
- British English throughout; dates DD/MM/YYYY.

## Output & naming

- **Hand-written:** `STEPS.md` and `CHECKLIST.md` in each folder; `CONTEXT.md` is the
  orientation file (holds the tree).
- **Nothing here is generated** — the artefacts these workflows produce live under
  `project-management/src/`, not in this tree.
- Workflow folders `NN-kebab-case/`; documentation files `SCREAMING-SNAKE-CASE.md`.
