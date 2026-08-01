# project-management/src/00-ASSETS/LOGOS

Brand logo slot — a placeholder for a project's logo assets. Empty in the base template;
populate it per project.

## Directory Tree

```text
project-management/src/00-ASSETS/LOGOS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
└── (add brand logo assets)  ← e.g. svg/ (vector source of truth) + raster exports (hd/, 8k/)
```

**Convention:** keep the vector source (SVG) as the source of truth; derive any raster
exports (e.g. `hd/`, `8k/` PNGs) from it, and re-export from source whenever the logo
changes — never hand-edit a raster.

**Last Updated**: {{DATE}}
