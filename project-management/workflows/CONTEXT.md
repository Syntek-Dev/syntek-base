# project-management/workflows — Step-by-Step PM Guides

**Last Updated**: {{DATE}}

## Directory Tree

```text
project-management/workflows/
├── CONTEXT.md                  ← this file
├── 01-story-creation/          ← write a well-formed user story with acceptance criteria
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 02-sprint-planning/         ← organise stories into a balanced sprint (MoSCoW)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 03-database-schema/         ← design and sign off a database schema before coding
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 04-user-flow-design/        ← map user journeys before wireframing
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 05-brand-guides/            ← define and document the visual brand identity
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 06-component-designs/       ← design reusable UI components before frontend work
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 07-wireframes/              ← create and sign off wireframes before frontend work
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 08-gdpr-compliance/         ← review a feature for GDPR compliance
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 09-security-checks/         ← threat model and security review of designs
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 10-qa-checks/               ← QA planning from wireframes before development
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 11-seo-checks/              ← verify SEO on all public-facing pages
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 12-api-design/              ← design the Django Ninja API contract before sprint planning
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 13-decisions/               ← author an Architectural Decision Record (ADR)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 14-sprint-plans/            ← write detailed sprint plans after all checks
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 15-story-plans/             ← write the per-story implementation plan (code master)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 16-backend-code/            ← implement Django models, services, and business logic
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 17-api-code/                ← implement the Django Ninja API layer
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 18-frontend-code/           ← implement Django templates + django-components (HTMX/Alpine)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 19-implementation-documentation/ ← update docs + write IMPLEMENTATION records after code
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 20-pr-and-review/           ← create, review, and merge a feature PR
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
└── 21-release/                 ← cut a release (version bump, changelog, deployment)
    ├── CHECKLIST.md
    ├── CONTEXT.md
    └── STEPS.md
```

| Workflow                           | Purpose                                                        |
| ---------------------------------- | -------------------------------------------------------------- |
| `01-story-creation/`               | Write a well-formed user story with acceptance criteria        |
| `02-sprint-planning/`              | Organise stories into a balanced sprint                        |
| `03-database-schema/`              | Design and sign off a database schema before coding            |
| `04-user-flow-design/`             | Map user journeys and data touchpoints before wireframing      |
| `05-brand-guides/`                 | Define and document the visual brand identity and token system |
| `06-component-designs/`            | Design reusable UI components before frontend implementation   |
| `07-wireframes/`                   | Create and sign off wireframes before frontend work            |
| `08-gdpr-compliance/`              | Review a feature for GDPR compliance                           |
| `09-security-checks/`              | Threat model and security review of designs before development |
| `10-qa-checks/`                    | QA planning from wireframes — test scenarios before any code   |
| `11-seo-checks/`                   | Verify SEO on all public-facing pages before story closes      |
| `12-api-design/`                   | Design the Django Ninja API contract before sprint planning    |
| `13-decisions/`                    | Author an Architectural Decision Record (ADR)                  |
| `14-sprint-plans/`                 | Write detailed sprint plans after GDPR, security, and QA       |
| `15-story-plans/`                  | Write the per-story implementation plan — the code master      |
| `16-backend-code/`                 | Implement Django models, services, and business logic (TDD)    |
| `17-api-code/`                     | Implement the Django Ninja API layer                           |
| `18-frontend-code/`                | Implement Django templates + django-components (HTMX/Alpine)   |
| `19-implementation-documentation/` | Update docs + write IMPLEMENTATION records after code          |
| `20-pr-and-review/`                | Create, review, and merge a feature PR                         |
| `21-release/`                      | Cut a release (version bump, changelog, deployment)            |

## Pairing with the code layer

These workflows are the **specify and gate** half of a two-layer chain; `code/workflows/` is the
**build and verify** half. The canonical pairing map — which PM workflow pairs with which code
workflow, which PM phase enters it, and who owns each fact — is in
[`REFERENCES.md` → Cross-layer workflow pairing](../../REFERENCES.md). Do not restate it here.

Two rules follow from it:

- **Design gates never trigger a code workflow directly.** `03-database-schema` and `07-wireframes`
  hand forward to the next gate, not to `code/workflows/`. Implementation is reached only through
  `16-backend-code`, `17-api-code`, and `18-frontend-code`, once `01`–`15` are complete.
- **`19-implementation-documentation` owns the whole closeout** — records, findings,
  `GAPS.md`/`DEFERRED.md`, the `CONTEXT.md`/`CLAUDE.md` update, and the graph refresh. Workflow
  `20` verifies them; the code workflows hand off to `19` and restate nothing.
