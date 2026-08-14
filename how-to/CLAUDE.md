@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — how-to/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + key docs, imported above) → this file → the target sub-folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The operations layer — how to set up the environment, run the dev stack, use the
<%ORG_NAME%> Dev Suite, specify the app→server contract (`src/SERVER-ARCHITECTURE/`), and
debug failures; the `docs/` guides plus the step-by-step `workflows/` that drive them.

## How to work here

- **Routing:** operational tasks → `global-workflow` skill. Pick the matching
  `workflows/NN-…/` procedure (`STEPS.md` + `CHECKLIST.md`); it points at the
  governing `docs/` guide (`DEVELOPMENT.md`, `GIT-WORKTREES.md`, `TOOLING-GUIDE.md`,
  `CLI-TOOLING.md`). This layer documents operations — it holds no deployable code.
- **Grill first:** any substantial operational task — restructuring a guide or workflow —
  opens with a grilling pass (the running skill loads `.claude/skills/grill-with-docs`, which owns the round shape and question format) before the artefact is produced; only trivial/mechanical touches skip
  it (`.claude/CLAUDE.md` §10).
- **Model:** Opus when authoring or restructuring a guide/workflow and
  mechanical touches (renames, link fixes, version-header bumps).
- **Concrete steps:** edit the relevant `docs/*.md` or `workflows/NN-…/*.md` → keep
  every developer command a `code/src/scripts/**/*.sh` reference (never raw `pnpm`,
  `next`, `pytest`, `python`, or `docker`) → keep instructional `.md` ≤ 300 code
  lines → update this folder's `CONTEXT.md`/`REFERENCES.md` if structure changed.
- **Definition of done:** guidance accurate against the scripts it names; British
  English; cross-references resolve; docs hard-gate satisfied before any commit.

## Guardrails

- **Script-first, always.** Every operational command in these docs must resolve to a
  `code/src/scripts/**/*.sh` script — never a raw `pnpm`/`npm`/`npx`/`pip`/`uv`/
  `docker`/`python manage.py` invocation.
- **Instructional `.md` ≤ 300 code lines** (`cloc`); split an oversized guide and
  leave a thin index (as `TOOLING-GUIDE.md` does over `tooling-guide/`).
- **Not the place for code, stories, or PRs** — code → `code/CONTEXT.md`; stories,
  PRs, releases → `project-management/CONTEXT.md`.
- Every directory carrying a `CONTEXT.md` also carries a `CLAUDE.md`.

## Output & naming

- **Hand-written:** all `docs/*.md`, `workflows/**/{STEPS,CHECKLIST,CONTEXT}.md`, and
  the `src/` operator guides (contributing guide, architecture snapshots, the
  `NIXOS-SETUP.md` pointer stub). Nothing here is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; workflow directories carry an `NN-`
  numeric prefix; user stories referenced as `US###`.
