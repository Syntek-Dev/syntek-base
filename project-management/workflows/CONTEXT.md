# project-management/workflows — Step-by-Step PM Guides

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
├── 09-security-checks/         ← threat-model planned features before sprint planning
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 10-qa-checks/               ← define QA scenarios for each story before development
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 11-sprint-plans/            ← write the sprint plan (MoSCoW, phases, definition of done)
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 12-backend-code/            ← implement Django models, services, and business logic
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 13-api-code/                ← implement the Strawberry GraphQL API layer
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 14-frontend-code/           ← implement Next.js pages and React components
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 15-app-code/                ← implement Expo React Native screens and components
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
├── 16-pr-and-review/           ← create, review, and merge a feature PR
│   ├── CHECKLIST.md
│   ├── CONTEXT.md
│   └── STEPS.md
└── 17-release/                 ← cut a release (version bump, changelog, deployment)
    ├── CHECKLIST.md
    ├── CONTEXT.md
    └── STEPS.md
```

| Workflow                | Purpose                                                        |
| ----------------------- | -------------------------------------------------------------- |
| `01-story-creation/`    | Write a well-formed user story with acceptance criteria        |
| `02-sprint-planning/`   | Organise stories into a balanced sprint                        |
| `03-database-schema/`   | Design and sign off a database schema before coding            |
| `04-user-flow-design/`  | Map user journeys and data touchpoints before wireframing      |
| `05-brand-guides/`      | Define and document the visual brand identity and token system |
| `06-component-designs/` | Design reusable UI components before frontend implementation   |
| `07-wireframes/`        | Create and sign off wireframes before frontend work            |
| `08-gdpr-compliance/`   | Review a feature for GDPR compliance                           |
| `09-security-checks/`   | Threat-model planned features before sprint planning           |
| `10-qa-checks/`         | Define QA scenarios for each story before development          |
| `11-sprint-plans/`      | Write the sprint plan (MoSCoW, phases, definition of done)     |
| `12-backend-code/`      | Implement Django models, services, and business logic (TDD)    |
| `13-api-code/`          | Implement the Strawberry GraphQL API layer                     |
| `14-frontend-code/`     | Implement Next.js pages and React components                   |
| `15-app-code/`          | Implement Expo React Native screens and components             |
| `16-pr-and-review/`     | Create, review, and merge a feature PR                         |
| `17-release/`           | Cut a release (version bump, changelog, deployment)            |
