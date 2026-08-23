@./CONTEXT.md

# CLAUDE.md — 00-ASSETS/scripts/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script table + when-to-use, imported above) → this file.

## Purpose (one line)

The export helper scripts for the PM layer — PDF/zip artefact exports for client
delivery, plus the ClickUp generate/guard/sync trio (`export-clickup-stories.sh`,
`precommit-clickup.sh`, `sync-clickup.sh`) that keep `export/clickup/` canonical.

## How to work here

- **Routing:** export tooling, not product code. These scripts are driven by lefthook
  (`precommit-clickup.sh`) and the `clickup-sync` GitHub workflow (`sync-clickup.sh`);
  run PDF/zip exports before client-delivery milestones or release cuts. The ClickUp trio is
  **clickup-only** — excluded as one unit when `INCLUDE_CLICKUP` is false, because a lefthook
  hook or a CI job left pointing at a missing script fails on every commit.
- **Model:** Opus for running or minor script edits and reworking the
  export pipeline logic.
- **Concrete steps:** to preview a sync, run `sync-clickup.sh --dry-run`; a real
  upsert needs `CLICKUP_API_TOKEN` + `CLICKUP_LIST_ID` + `CLICKUP_SYNC_APPLY=1`
  in the environment. All output lands in `project-management/export/`.
- **Definition of done:** generated ClickUp Markdown regenerated and re-staged where a
  source story changed; export output written to `project-management/export/`.

## Guardrails

- **ClickUp credentials are environment secrets only** — never hardcode
  `CLICKUP_API_TOKEN` or list IDs; `sync-clickup.sh` stays dry-run until they are set.
- **`export/clickup/` is generated read-only (0444)** — regenerate via
  `export-clickup-stories.sh`, never hand-edit; sync is idempotent via
  `export/clickup-task-map.json`.
- Exports are derived from `src/` artefacts — regenerate rather than editing an
  exported PDF or zip.

## Output & naming

- **Hand-written:** the `*.sh` scripts themselves.
- **Generated (by these scripts, never hand-edited):** everything under
  `project-management/export/` — PDFs, zips, and the read-only `export/clickup/`
  Markdown.
- Scripts `kebab-case.sh`.
