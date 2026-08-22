@./CONTEXT.md

# CLAUDE.md — workflows/07-dependency-updates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for adding, upgrading, or removing a dependency in any ecosystem, and for
resolving the advisories the nightly sweep reports.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Execution
  → `cicd` (Opus); a load-bearing choice is grilled and recorded as an ADR via
  `project-management/workflows/15-decisions/` (Fable).
- **Model:** Opus for the change and verification; Fable for the ADR.
- **Concrete steps:** justify → edit manifest and refresh lockfile → reinstall and rebuild
  → run the full gate → commit manifest and lockfile together.
- **Definition of done:** image builds, full gate green, pins moved as a matched set,
  lockfile committed with its manifest.

## Guardrails

- **Adding a dependency is a decision.** Check the "deliberately NOT declared" register and
  its trigger first; confirm licence compatibility per `how-to/src/CONTRIBUTING.md`.
- **Never commit a manifest without its refreshed lockfile.** Every Dockerfile builds with
  `uv sync --frozen`, so the two are one artefact.
- **Pin advisories via `overrides`; never loosen a range** to make an audit pass.
- **Toolchain pins are a matched set** — `.nvmrc`, `.python-version`, `package.json`, and
  workflow `env:` blocks move together, or CI fails alone.
- **In this template `uv.lock` is committed** (16/08/2026) and is refreshed here like any
  other lockfile. It pins `syntek-base`, so `copier.yml` excludes it and a generated project
  locks its own at generation.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Produced by following it:** manifest and lockfile changes, committed together in a
  commit of their own; optionally an ADR under `project-management/src/15-DECISIONS/`.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`.
