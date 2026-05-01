# project-management/src

Source artefacts for project management, planning, and compliance. Each subdirectory holds a
specific category of project document.

## Directory Tree

```text
project-management/src/
├── 00-ASSETS/               ← logos, images, and static media (SVG source + raster exports)
├── 00-DECISIONS/            ← Architecture Decision Records (ADR-###-<TITLE>.md)
├── 00-PLANS/                ← architecture and implementation plans (PLAN-<FEATURE>.md)
├── 01-STORIES/              ← user stories (US###.md)
├── 02-SPRINTS/              ← sprint plans (SPRINT-##.md)
├── 03-DATABASE/             ← database schema design documents and decisions
├── 04-USER-FLOW/            ← user journey maps (USER-FLOW-<AREA>.md)
├── 05-BRAND-GUIDE/          ← brand guidelines (colours, typography, tone of voice)
├── 06-COMPONENTS/           ← UI component specs and API contracts
├── 07-WIREFRAMES/           ← UI wireframes and design decision notes
├── 08-GDPR/                 ← GDPR compliance artefacts (DPIAs, registers, notices)
├── 09-SECURITY/             ← security audits and threat model documents
├── 10-QA/                   ← quality assurance docs and manual test guides
├── 11-SEO/                  ← SEO audit reports and Lighthouse exports (LIGHTHOUSE-US###-ROUTE-DD-MM-YYYY.json)
├── 12-SPRINT-PLANS/         ← sprint plan documents (SPRINT-PLAN-##.md)
├── 13-TESTS/                ← test status tracking (US###-TEST-STATUS.md, US###-MANUAL-TESTING.md)
├── 14-REVIEWS/              ← code review records and PR feedback
├── 15-BUGS/                 ← bug reports (BUG-<DESCRIPTOR>-DD-MM-YYYY.md)
└── 16-REFACTORING/          ← refactoring plans and technical debt records
```

## Naming Conventions

| Pattern                          | Directory         | Example                   |
| -------------------------------- | ----------------- | ------------------------- |
| `US###.md`                       | `01-STORIES/`     | `US015.md`                |
| `US###-TEST-STATUS.md`           | `13-TESTS/`       | `US015-TEST-STATUS.md`    |
| `US###-MANUAL-TESTING.md`        | `13-TESTS/`       | `US015-MANUAL-TESTING.md` |
| `SPRINT-##.md`                   | `02-SPRINTS/`     | `SPRINT-06.md`            |
| `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `15-BUGS/`        | `BUG-AUTH-19-04-2026.md`  |
| `ADR-###-<TITLE>.md`             | `00-DECISIONS/`   | `ADR-001-SESSIONS-JWT.md` |
| `BRAND-<TOPIC>.md`               | `05-BRAND-GUIDE/` | `BRAND-COLOURS.md`        |
| `COMPONENT-<NAME>.md`            | `06-COMPONENTS/`  | `COMPONENT-BUTTON.md`     |

## Cross-references

- `project-management/CONTEXT.md` — full project-management layer overview
- `project-management/docs/GIT-GUIDE.md` — branch naming and PR conventions
- `project-management/docs/VERSIONING-GUIDE.md` — semantic versioning rules
