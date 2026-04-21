# project-management/src/06-COMPONENTS

Component specification documents — design decisions, API contracts, and usage notes for shared UI
components.

## Directory Tree

```text
project-management/src/06-COMPONENTS/
├── CONTEXT.md               ← this file
└── COMPONENT-<NAME>.md      ← e.g. COMPONENT-BUTTON.md, COMPONENT-CARD.md
```

**Naming:** `COMPONENT-<NAME>.md` — `NAME` in `SCREAMING-SNAKE-CASE`.

Specs belong here. Implementation lives in `code/src/frontend/src/components/`. A spec should
cover: purpose, props/API, variants, accessibility notes, and any known constraints.
