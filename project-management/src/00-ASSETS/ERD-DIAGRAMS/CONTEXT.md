# project-management/src/00-ASSETS/ERD-DIAGRAMS

Rendered entity-relationship diagram images (PNG exports from Mermaid or a DB tool).

## Directory Tree

```text
project-management/src/00-ASSETS/ERD-DIAGRAMS/
├── CONTEXT.md               ← this file
└── erd-<domain>.png         ← e.g. erd-users-auth.png, erd-blog.png
```

**Naming:** `erd-<domain>.png` — kebab-case.

Source schema documents live in `project-management/src/03-DATABASE/`. Re-export here when a schema
changes — do not edit PNGs directly.
