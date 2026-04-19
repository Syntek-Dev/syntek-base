# code/src — Source Root

All deployable source code lives here, split into three sub-layers.

## Directory Tree

```text
code/src/
├── CONTEXT.md               ← this file (contributing, testing, code quality rules)
├── backend/                 ← Django 6.0.4 + Strawberry GraphQL API
│   └── CONTEXT.md           ← stack details, app layout, entry points
├── docker/                  ← Dockerfiles and Compose files for all environments
│   └── CONTEXT.md           ← images, environments, Nginx proxy config
├── frontend/                ← Next.js 16.2.4 App Router site
│   └── CONTEXT.md           ← stack details, page layout, codegen instructions
├── mobile/                  ← Expo React Native app
│   └── CONTEXT.md           ← stack details, screen layout, codegen instructions
├── shared/                  ← Cross-platform UI components, hooks, and utilities
│   └── CONTEXT.md           ← what belongs here, platform portability rules
├── logs/                    ← runtime log files (dev/test only; all gitignored)
│   ├── CONTEXT.md
│   ├── .gitignore
│   └── .gitkeep
└── scripts/                 ← quality scripts (lint, check, format)
    ├── check.sh
    ├── CONTEXT.md
    ├── format.sh
    ├── lint.sh
    └── reports/             ← generated reports (all gitignored)
        ├── CONTEXT.md
        ├── .gitignore
        └── .gitkeep
```

## Sub-layers

| Directory   | Contents                                           | Read first            |
| ----------- | -------------------------------------------------- | --------------------- |
| `backend/`  | Django 6.0.4 + Strawberry GraphQL API              | `backend/CONTEXT.md`  |
| `frontend/` | Next.js 16.2.4 App Router site                     | `frontend/CONTEXT.md` |
| `mobile/`   | Expo React Native app                              | `mobile/CONTEXT.md`   |
| `shared/`   | Cross-platform UI components, hooks, and utilities | `shared/CONTEXT.md`   |
| `docker/`   | Dockerfiles and Compose files for all environments | `docker/CONTEXT.md`   |
| `logs/`     | Runtime log files (dev/test only; all gitignored)  | `logs/CONTEXT.md`     |

Always read the relevant sub-layer CONTEXT.md before touching any code in that directory.

## Cross-references

- `code/CONTEXT.md` — coding standards, testing, security, and API design guides
- `how-to/src/CONTEXT.md` — contributing guide, linting/formatting/typechecking, test commands
