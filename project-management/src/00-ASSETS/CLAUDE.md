@./CONTEXT.md

# CLAUDE.md — src/00-ASSETS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(asset tree + export-script notes, imported above) → this file → the target
sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

Pre-workflow static assets and export tooling for the PM layer — a brand-logo slot
(`LOGOS/`) and the `scripts/` shell helpers that batch-export PM and design artefacts
for client delivery.

## How to work here

- **Routing:** static-asset and export-tooling folder, not code. Logo assets live in
  `LOGOS/` (vector source of truth → re-export rasters). Export runs are operational —
  trigger through the project shell-script conventions in `code/src/scripts/`, never by
  invoking the `scripts/*.sh` here directly.
- **Model:** Opus for the mechanical work here (re-exporting, running a script, moving a
  file) and for reworking the export pipeline itself.
- **Concrete steps:** for a logo change, edit the SVG source and re-export its rasters;
  for an artefact export, run the relevant `scripts/*.sh` and confirm output lands in
  `project-management/export/`.
- **Definition of done:** logo rasters agree with their vector source; no raster
  hand-edited; export output regenerated from `src/` artefacts; any new sub-folder
  carries a `CONTEXT.md`.

## Guardrails

- **Vector source is the single source of truth** for logos — never edit a raster
  directly; always re-export from the SVG.
- **Do not run the `scripts/*.sh` helpers directly** — they are driven by lefthook
  (`precommit-clickup.sh`) and the `clickup-sync` CI workflow (`sync-clickup.sh`); local
  previews use `--dry-run`. ClickUp sync needs `CLICKUP_API_TOKEN` etc. as **environment
  secrets**, never committed. The ClickUp trio is **clickup-only** (`INCLUDE_CLICKUP`); on any
  other board the sync is written from scratch through the `pm-tool-sync` skill.
- **Do not commit large unoptimised binaries** — keep raster exports lean.
- `export/clickup/` is generated and written read-only (0444) — regenerate, never
  hand-edit.

## Output & naming

- **Hand-written / source:** logo vector sources in `LOGOS/` and the `scripts/*.sh`.
- **Generated:** logo raster exports, and everything under `project-management/export/`
  (PDFs, zips, ClickUp Markdown) — never hand-edit.
- Sub-directories `kebab-case/` or format-named (`svg/`, `hd/`, `8k/`); scripts
  `kebab-case.sh`; documentation `SCREAMING-SNAKE-CASE.md`.
