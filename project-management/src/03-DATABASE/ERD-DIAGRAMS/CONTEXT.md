# project-management/src/03-DATABASE/ERD-DIAGRAMS

Rendered entity-relationship diagram images (PNG exports from a schema design's Mermaid
source). Empty in the base template — populated as schema designs are signed off.

## Directory Tree

```text
project-management/src/03-DATABASE/ERD-DIAGRAMS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
└── erd-<domain>.png         ← rendered ERD per schema domain (added per design)
```

**Naming:** `erd-<domain>.png` — kebab-case domain slug (e.g. `erd-users-auth.png`).

Source ERDs live in the `DB-<FEATURE>-DD-MM-YYYY.md` schema-design docs one level up (the
`## ERD (Mermaid)` section). Re-export here when a schema changes — never edit a PNG directly.

**Last Updated**: <%DATE%>
