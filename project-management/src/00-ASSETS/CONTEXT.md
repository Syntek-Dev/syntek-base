# project-management/src/00-ASSETS

Static assets, export tooling and experimental evidence for the PM layer — a brand-logo
slot, the shell scripts that batch-export PM and design artefacts for client delivery, and
the raw record of the cold walk tests that measure whether this repository can orient a
reader who has never seen it.

## Directory Tree

```text
project-management/src/00-ASSETS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── LOGOS/                   ← brand logo slot (empty placeholder — populate per project)
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── scripts/                 ← export helper scripts
│   ├── export-clickup-stories.sh ← per-story client Markdown → export/clickup/ (read-only)
│   ├── export-design-docs.sh  ← exports brand/component design HTML → PDF
│   ├── export-pm-files.sh     ← exports PM artefacts (stories, sprints, plans) → zip
│   ├── export-wireframes.sh   ← exports wireframe HTML → PDF
│   ├── precommit-clickup.sh   ← lefthook guard: regenerates ClickUp exports on commit
│   └── sync-clickup.sh        ← upserts ClickUp exports into ClickUp (clickup-sync CI workflow)
└── WALK-TESTS/              ← cold walk-test evidence: prompt, report, transcript, verified result
    ├── CONTEXT.md
    └── CLAUDE.md
```

`LOGOS/` is a placeholder for a project's brand logos — add the vector source (SVG,
the source of truth) plus any raster exports; never edit a raster directly, re-export
from source.

The `scripts/` are shell helpers for batch-exporting artefacts — do not run them
directly; use the project shell-script conventions in `code/src/scripts/`.

The three `*-clickup.sh` scripts are **clickup-only** — present only in a project generated
with `INCLUDE_CLICKUP`. The four export scripts beside them ship unconditionally.

`WALK-TESTS/` holds the evidence behind a navigability claim — each run is a prompt, the
walker's verbatim answer, the transcript of every tool call it made, and the verified result.
A run's own artefacts are syntek-base's experimental record and do not travel; the folder and
its pair do.

Do not commit large unoptimised binaries.

**Last Updated**: <%DATE%>
