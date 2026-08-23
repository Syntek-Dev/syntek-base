# project-management/src/00-ASSETS/scripts

Shell scripts for exporting project artefacts to PDF and zip archives for client delivery.

## Directory Tree

```text
project-management/src/00-ASSETS/scripts/
├── CLAUDE.md                    ← operating rules
├── CONTEXT.md                   ← this file
├── export-clickup-stories.sh    ← stories → the ClickUp import format
├── export-design-docs.sh        ← design artefacts → client-ready PDF
├── export-pm-files.sh           ← the PM tree → a delivery zip
├── export-wireframes.sh         ← wireframe HTML → PDF
├── precommit-clickup.sh         ← regenerates the ClickUp exports on commit; self-gating
└── sync-clickup.sh              ← pushes stories and sprints to the ClickUp workspace
```

These live beside the artefacts they export rather than in `code/src/scripts/`, because their
input is the PM tree and their output is a client deliverable — neither is a dev operation.

The ClickUp trio — `export-clickup-stories.sh`, `precommit-clickup.sh`, `sync-clickup.sh` — is
**clickup-only**, excluded together when `INCLUDE_CLICKUP` is false. They go as one unit: any
one of them shipped alone leaves a lefthook hook or a CI job calling a script that is not there.
The four PDF/zip export scripts ship unconditionally.

## Contents

| Script                      | Purpose                                                                                                                                                                                                                                |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `export-design-docs.sh`     | Exports brand guide and component design artefacts to PDF                                                                                                                                                                              |
| `export-pm-files.sh`        | Exports all PM artefacts (stories, sprints, plans) to a zip archive                                                                                                                                                                    |
| `export-wireframes.sh`      | Exports wireframe HTML files to PDF                                                                                                                                                                                                    |
| `export-clickup-stories.sh` | Generates client-friendly, ClickUp-ready Markdown per story (Status, MoSCoW, SP, Client Summary, User Story) → `export/clickup/`; writes them read-only (0444)                                                                         |
| `precommit-clickup.sh`      | Lefthook pre-commit guard: regenerates and re-stages the ClickUp exports when a source story or generated file is staged (keeps `export/clickup/` canonical)                                                                           |
| `sync-clickup.sh`           | Upserts the generated ClickUp exports into ClickUp (idempotent via `export/clickup-task-map.json`); dry-run unless `CLICKUP_API_TOKEN` + `CLICKUP_LIST_ID` + `CLICKUP_SYNC_APPLY=1` are set. Run by the `clickup-sync` GitHub workflow |

## When to use this

Run the PDF/zip export scripts before client delivery milestones or release cuts.
Output is saved to `project-management/export/`. `sync-clickup.sh` runs in CI (the
`clickup-sync` workflow) on push/PR; run it locally with `--dry-run` to preview.

## Cross-references

- `project-management/src/00-ASSETS/CONTEXT.md` — parent directory
- `project-management/export/` — output destination for all exports

**Last Updated**: <%DATE%>
