# project-management/src/12-API-DESIGN/PLANNING

Pre-implementation API design — **one design per user story**. Each design fixes the
Django Ninja contract for a single story before any code is written: the API surface,
Schemas, read and write endpoint signatures, real-time/async needs, the permission matrix,
error strategy, and breaking-change notes — a 10-step document written against
`code/docs/API-DESIGN.md` (Django Ninja conventions).

## Directory Tree

```text
project-management/src/12-API-DESIGN/PLANNING/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
├── API-PLAN-US000-TEMPLATE.md     ← copy this to start a story's API design
└── API-PLAN-US###-<DESCRIPTOR>.md ← one design per story that adds or changes Django Ninja surface
```

## How it works

A design is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `API-PLAN-US000-TEMPLATE.md` to
`API-PLAN-US###-<DESCRIPTOR>.md` and complete the 10 steps: the endpoint surface, the
Ninja Schemas (field types, enums, request/response models, the paginated wrapper), each
read (GET) and write (POST/PATCH/DELETE) endpoint signature with its handler contract, the
permission matrix, the error strategy, and the breaking-change assessment. Those decisions
are then verified — against the shipped endpoints — in the matching
`../IMPLEMENTATION/API-IMPL-US###-*.md` record.

The design is written **after** the schema is agreed in `../../03-DATABASE/` and
**before** the story enters `../../14-SPRINT-PLANS/`; it feeds directly into
`project-management/workflows/17-api-code/` during implementation.

## The 10-step structure

Every design follows the same numbered structure: **1** API surface · **2** Ninja Schemas
· **3** read endpoints · **4** write endpoints · **5** real-time & async · **6** permission
matrix · **7** error strategy · **8** breaking changes · **9** peer review · **10**
cross-references — closing with a Prerequisites → Sign-off checklist.

## The N/A path

A story that adds no Django Ninja surface — a pure public-page change served by a Django
template, a migration, a docs-only task — records that fact and needs no design here. API
design is **per story**; there is no cross-cutting by-scope report folder (that role is
served by the per-story designs, as in 08-GDPR).

## When to write one

- When a story introduces or changes any admin API endpoint (GET/POST/PATCH/DELETE)
- When running `project-management/workflows/12-api-design/`
- When fixing a story's Ninja contract before sprint planning and implementation

## Cross-references

- `API-PLAN-US000-TEMPLATE.md` — the per-story API design template
- `../IMPLEMENTATION/` — the post-implementation records that verify these designs
- `../CONTEXT.md` — the 12-API-DESIGN folder overview and the per-story API lifecycle
- `../../01-STORIES/` — the story whose Ninja contract this design fixes
- `../../03-DATABASE/` — the agreed schema a design exposes
- `code/docs/API-DESIGN.md` — Django Ninja conventions the design is written against
- `code/docs/SECURITY.md` — the permission/IDOR rules the design specifies and code enforces

**Last Updated**: {{DATE}}
