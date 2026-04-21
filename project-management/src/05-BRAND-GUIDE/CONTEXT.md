# project-management/src/05-BRAND-GUIDE

Brand guidelines for Syntek Studio — colours, typography, tone of voice, and logo usage rules.

## Directory Tree

```text
project-management/src/05-BRAND-GUIDE/
├── CONTEXT.md               ← this file
└── BRAND-<TOPIC>.md         ← e.g. BRAND-COLOURS.md, BRAND-TYPOGRAPHY.md, BRAND-TONE.md
```

**Naming:** `BRAND-<TOPIC>.md` — `TOPIC` in `SCREAMING-SNAKE-CASE`.

Each document covers a single brand dimension. Reference these when implementing UI or writing
copy — do not override brand decisions at the component level without updating this directory first.

## Design Toolchain

Brand work follows a two-phase process:

1. **Generate with Claude Design** — Use [Claude Design by Anthropic Labs](https://www.anthropic.com/news/claude-design-anthropic-labs) to generate initial logo concepts, colour palettes, typography options, and visual direction. Curate the outputs and document every agreed decision as a `BRAND-<TOPIC>.md` file in this directory.

2. **Build in Figma** — Open the [Syntek Studio Figma team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629) and use the brand guide template to port the decisions from step 1 into Figma. Set up Figma variables for all tokens so component designers can consume them directly.

The `BRAND-<TOPIC>.md` files in this directory are the source of truth. The Figma brand guide is the shared design reference for all downstream component and wireframe work.
