# project-management/src/00-DECISIONS

Architecture Decision Records (ADRs) — significant technical and design decisions with context,
options considered, and rationale.

## Directory Tree

```text
project-management/src/00-DECISIONS/
├── CONTEXT.md               ← this file
└── ADR-###-<TITLE>.md       ← e.g. ADR-001-DJANGO-SESSIONS-OVER-JWT.md
```

**Naming:** `ADR-###-<TITLE>.md` — 3-digit zero-padded index, `TITLE` in `SCREAMING-SNAKE-CASE`.

Each ADR documents: **Status** (proposed / accepted / superseded), **Context**, **Options
considered**, **Decision**, and **Consequences**. Once accepted, an ADR is immutable — supersede
it with a new ADR rather than editing in place.
