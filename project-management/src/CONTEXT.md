# project-management/src

Source artefacts for project management, planning, and compliance. Each subdirectory holds a
specific category of project document.

## Directory Tree

```text
project-management/src/
├── BUGS/                    ← bug reports (BUG-<DESCRIPTOR>-DD-MM-YYYY.md)
├── DATABASE/                ← database schema design documents and decisions
├── GDPR/                    ← GDPR compliance artefacts (DPIAs, registers, notices)
├── PLANS/                   ← architecture and implementation plans
├── QA/                      ← quality assurance docs and manual test guides
├── REFACTORING/             ← refactoring plans and technical debt records
├── REVIEWS/                 ← code review records and PR feedback
├── SECURITY/                ← security audits and threat model documents
├── SPRINTS/                 ← sprint plans (SPRINT-##.md)
├── STORIES/                 ← user stories (US###.md) and test status docs
├── TESTS/                   ← test status tracking (US###-TEST-STATUS.md)
└── WIREFRAMES/              ← UI wireframes and design decision notes
```

## Naming Conventions

| Pattern                          | Directory  | Example                   |
| -------------------------------- | ---------- | ------------------------- |
| `US###.md`                       | `STORIES/` | `US015.md`                |
| `US###-TEST-STATUS.md`           | `TESTS/`   | `US015-TEST-STATUS.md`    |
| `US###-MANUAL-TESTING.md`        | `QA/`      | `US015-MANUAL-TESTING.md` |
| `SPRINT-##.md`                   | `SPRINTS/` | `SPRINT-06.md`            |
| `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `BUGS/`    | `BUG-AUTH-19-04-2026.md`  |

## Cross-references

- `project-management/CONTEXT.md` — full project-management layer overview
- `project-management/docs/GIT-GUIDE.md` — branch naming and PR conventions
- `project-management/docs/VERSIONING-GUIDE.md` — semantic versioning rules
