@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — project-management/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree, src/ tiers, workflow gates — imported above) → this file → the target
sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The PM layer — user stories, sprints, the design & compliance specs, the decisions and
plans that gate a feature into code, and the post-implementation records, plus the
`docs/` reference guides and the numbered `workflows/` that produce them.

## How to work here

- **Routing:** every PM task starts from the matching `workflows/NN-…/` procedure
  (`STEPS.md` + `CHECKLIST.md`), which points at the governing `docs/` guide. Load the
  matching skills (`story`, `sprint`, `planner`, `gdpr-mechanics`, `seo`, `qa-tester`,
  `security`, `version`, `git`, `completion`) for the heavier steps.
- **Grill first:** any substantial PM task — story, schema, API, GDPR/security/QA spec,
  ADR, or plan — opens with a grilling pass (the owning skill loads
  `.claude/skills/grill-with-docs`) before the artefact is
  produced; only trivial/mechanical work skips it (`.claude/CLAUDE.md` Section 10).
- **Model:** Opus throughout — stories, ADRs, sprint & story plans and GDPR/security/QA
  reports are substantive judgement; status flips, version-header bumps, moving a file and
  doc-index lookups are mechanical touches.
- **Concrete steps:** read the workflow `STEPS.md` → write the artefact under the
  matching numbered `src/NN-…/` folder using its naming pattern → cross-link the story
  (`US###`) → satisfy the workflow `CHECKLIST.md`. Version bumps go through
  `docs/VERSIONING-GUIDE.md`; branches/PRs through `docs/GIT-GUIDE.md`.
- **Definition of done:** artefact in the correct numbered folder and phase, named to
  convention, linked to its `US###`; workflow checklist satisfied; any new directory
  carries a `CONTEXT.md` + `CLAUDE.md`; British English throughout.

## Guardrails

- **Workflow gates bite here:** a feature is not codeable until the specify → decide →
  plan tiers (`src/02–17`) are complete; a PR is not mergeable until
  `workflows/23-pr-and-review/` is signed off; a release follows `workflows/24-release/`.
- **This layer is documentation, not code** — no source, secrets, or `.env` content
  ever lands in `src/`. GDPR, security, and IDOR obligations are _specified_ here and
  _enforced_ in `code/`; keep them consistent with `code/docs/SECURITY.md`.
- **Instructional `.md` files ≤ 300 code lines** (`docs/`, `workflows/**`, every
  `CONTEXT.md`/`CLAUDE.md`); split oversized files, entry point becomes a thin index.
  Root-level artefacts under `src/` are exempt from the 300-line rule.
- **Every new directory in any layer needs a `CONTEXT.md` + `CLAUDE.md`.**
- Single-track semver: bump only via `docs/VERSIONING-GUIDE.md` / the `version` skill.

## Output & naming

- **Hand-written:** all artefacts under `src/`, the `docs/` guides, and workflow
  `STEPS.md`/`CHECKLIST.md`.
- **Generated:** PDFs and zip archives under `export/` (client delivery) — never
  hand-edit; regenerate from source.
- Numbered `src/` folders `NN-SCREAMING-SNAKE-CASE/`; artefacts follow their fixed
  patterns — `US###.md`, `SPRINT-##.md`, `ADR-US###-<DECISION>-DD-MM-YYYY.md`, `##-SPRINT-PLAN-##.md`,
  `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, `<TYPE>-PLAN-US###-*.md` /
  `<TYPE>-IMPL-US###-*.md`, `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; dates DD/MM/YYYY.
- **The two plan prefixes read as one convention and are governed by opposite rules.** A
  sprint plan carries **two** numbers — `<exec-order>-SPRINT-PLAN-<sprint-number>.md` — and a
  mismatch between build sequence and sprint identity is deliberate information, never
  "corrected" (`src/16-SPRINT-PLANS/CLAUDE.md`). A story plan carries **one**: the prefix is the
  story's position in the settled build order across the **whole backlog** — not its sprint, not
  a per-sprint counter — and is **renumbered whenever build order changes**, so a prefix that has
  drifted there is a defect (`src/17-STORY-PLANS/CLAUDE.md`, which owns the rule). `00-` is the
  template in both folders.

<!-- RENAMED 08/09/2026. The _Output & naming_ pattern for a story plan gained its
     `<exec-order>-` prefix, and the guardrail stating the contrast with the sprint-plan rule
     was added beside it. The previous pattern read "STORY-PLAN-US###-*.md", unprefixed. This
     list is the PM layer's authoritative naming table (`.claude/CLAUDE.md` Section 5); the
     per-folder `CLAUDE.md` files under `src/16-SPRINT-PLANS/` and `src/17-STORY-PLANS/` own the
     two rules in full, and this states only enough of each to stop a reader carrying one across
     into the other. -->
