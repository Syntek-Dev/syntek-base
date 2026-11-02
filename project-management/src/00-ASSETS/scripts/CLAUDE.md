@./CONTEXT.md

# CLAUDE.md — 00-ASSETS/scripts/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script table + when-to-use, imported above) → this file.

## Purpose (one line)

The export helper scripts for the PM layer — PDF/zip artefact exports for client
delivery, plus the ClickUp generate/guard/sync trio (`export-clickup-stories.sh`,
`precommit-clickup.sh`, `sync-clickup.sh`) that keep `export/clickup/` canonical, and the PM
board trio (`pm-board.sh`, `pm-archive.sh`, `pm-lib.sh`) that indexes and archives the five
status registers.

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
- **Boards:** `pm-board.sh --write` after a status edit; `--check` must pass before a commit
  (lefthook runs `--write --staged`, CI the `pm-boards` workflow). Stage with
  `git add <paths> $(bash project-management/src/00-ASSETS/scripts/pm-board.sh --boards-for <paths>)` so the boards ride the same `git add`
  and the hook never has to stop the commit. `pm-archive.sh <ID>` is the
  only way an item enters an `archive/` — dry-run first.
- **Definition of done:** generated ClickUp Markdown regenerated and re-staged where a
  source story changed; export output written to `project-management/export/`.

## Guardrails

- **ClickUp credentials are environment secrets only** — never hardcode
  `CLICKUP_API_TOKEN` or list IDs; `sync-clickup.sh` stays dry-run until they are set.
- **`export/clickup/` is generated read-only (0444)** — regenerate via
  `export-clickup-stories.sh`, never hand-edit; sync is idempotent via
  `export/clickup-task-map.json`.
- **Any reader of the five registers resolves an ID across the folder and its `archive/`** —
  through `pm-lib.sh`'s `find()` here, or the same two-folder glob elsewhere. A script that globs
  the live folder alone breaks the day an item is archived.
- **Never let a pm script stage or commit.** `pm-archive.sh` uses `git mv` for the rename and
  stops; `pm-board.sh` writes and names boards and stages none; the author reviews and commits.
  **One named exception:** the ClickUp guard `precommit-clickup.sh` re-stages the generated,
  read-only `export/clickup/` files it regenerates, and nothing else.
- Exports are derived from `src/` artefacts — regenerate rather than editing an
  exported PDF or zip.

## Output & naming

- **Hand-written:** the `*.sh` scripts themselves.
- **Generated (by these scripts, never hand-edited):** everything under
  `project-management/export/` — PDFs, zips, and the read-only `export/clickup/`
  Markdown; and the five `src/*/*-BOARD.md` boards with their gitignored `.json` / `.html`.
- Scripts `kebab-case.sh`.
