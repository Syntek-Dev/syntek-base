# code/workflows — Step-by-Step Coding Guides

Each workflow is a numbered folder with three files:

## Directory Tree

```text
code/workflows/
├── CONTEXT.md               ← this file
├── 01-new-feature/          ← add a new full-stack feature (backend + frontend)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 02-tdd-cycle/            ← TDD: Red → Green → Refactor
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 03-security-hardening/   ← security review and hardening of existing code
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 04-api-design/           ← design and implement a new GraphQL API surface
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 05-gdpr-enforcement/     ← implement GDPR requirements in code (encryption, consent, deletion)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 06-review/               ← code quality review (OWASP, principles, coverage)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 07-debug/                ← code-logic debugging and regression test writing
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 08-refactor/             ← systematic refactoring without behaviour change
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 09-database-migration/   ← create and run a new Django database migration
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
└── 10-debugging-with-logs/ ← debug using local logs, Glitchtip, Loki, and Grafana
    ├── CHECKLIST.md
    ├── CONTEXT.md
    └── STEPS.md
```

- `CONTEXT.md` — When to use this workflow and prerequisites
- `STEPS.md` — Ordered steps to execute
- `CHECKLIST.md` — Verification checklist before marking complete

| Workflow                  | Purpose                                                             |
| ------------------------- | ------------------------------------------------------------------- |
| `01-new-feature/`         | Add a new full-stack feature (backend + frontend)                   |
| `02-tdd-cycle/`           | Test-driven development cycle (Red → Green → Refactor)              |
| `03-security-hardening/`  | Security review and hardening of existing code                      |
| `04-api-design/`          | Design and implement a new GraphQL API surface                      |
| `05-gdpr-enforcement/`    | Implement GDPR requirements in code (encryption, consent, deletion) |
| `06-review/`              | Code quality review (OWASP, coding principles, coverage)            |
| `07-debug/`               | Code-logic debugging and regression test writing                    |
| `08-refactor/`            | Systematic refactoring without behaviour change                     |
| `09-database-migration/`  | Create and run a new Django database migration                      |
| `10-debugging-with-logs/` | Debug using local logs, Glitchtip, Loki, and Grafana                |

Read the workflow's `CONTEXT.md` first. Only enter `STEPS.md` when explicitly triggered.
