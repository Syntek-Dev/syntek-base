@./CONTEXT.md

# CLAUDE.md — 00-ASSETS/LOGOS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(logo-slot convention, imported above) → this file.

## Purpose (one line)

The brand-logo slot — a placeholder for a project's logo assets; empty in the base
template, populated per project with the vector source and its raster exports.

## How to work here

- **Routing:** static-asset folder, not code. Add a project's logos here — keep the
  vector source (SVG) as the source of truth and derive raster exports from it.
- **Model:** Opus — mechanical export work.
- **Concrete steps:** add/edit the SVG source → re-export any raster variants to match →
  verify every format shows the same mark.
- **Definition of done:** every raster matches its vector source; no raster hand-edited;
  any new format sub-folder carries a `CONTEXT.md`.

## Guardrails

- **The vector source is the single source of truth** — never edit a raster export
  directly; always re-export from the SVG.
- **Do not commit large unoptimised binaries** — keep raster exports lean.

## Output & naming

- **Source:** `*.svg` (e.g. under `svg/`). **Generated:** raster exports (e.g. `hd/`,
  `8k/` PNGs).
- Keep variant basenames consistent across formats; format folders lower-case
  (`svg/`, `hd/`, `8k/`).
