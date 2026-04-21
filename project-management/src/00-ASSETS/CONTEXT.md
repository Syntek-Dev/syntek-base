# project-management/src/00-ASSETS

Static assets used across the project — logos, images, and other media.

## Directory Tree

```text
project-management/src/00-ASSETS/
├── CONTEXT.md               ← this file
├── ERD-DIAGRAMS/            ← rendered ERD images (ERD-<DOMAIN>.png)
├── LOGOS/                   ← Syntek logo variants by format and resolution
│   ├── 8k/                  ← 8K raster exports (PNG)
│   ├── hd/                  ← HD raster exports (PNG)
│   └── svg/                 ← SVG vector source files (source of truth)
└── USER-FLOW-DIAGRAMS/      ← rendered user flow images (FLOW-<AREA>-<SCREEN>.png)
```

Do not commit large unoptimised binaries. Re-export from source when diagrams or logos change.
