# 13-API-DESIGN

Django Ninja API design artefacts, per user story. The base repo ships this as a **per-story
scaffold**: a pre-implementation `PLANNING/` API design and a post-implementation
`IMPLEMENTATION/` verification, tied to a story at both ends, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/13-API-DESIGN/
├── CONTEXT.md · CLAUDE.md
├── PLANNING/                     ← pre-implementation API design, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── API-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/               ← post-implementation API verification, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── API-IMPL-US000-TEMPLATE.md
```

Each folder ships one `US000-TEMPLATE.md`; a project copies it per story that adds or
changes Django Ninja API surface. The per-story API design now lives in `PLANNING/` (it
previously sat at this folder's root); there is no cross-cutting by-scope report folder
(that role is served by the per-story designs, as in 09-GDPR).

## What an API design defines

The Django Ninja contract — request/response Schemas, endpoints (GET/POST/PATCH/DELETE
routers), and permission rules — agreed **before** any code is written, so backend and
every consumer shares one interface. The design template follows a 10-step structure:
API surface, Ninja Schemas, read endpoints, write endpoints, real-time & async,
permission matrix, error strategy, breaking changes, peer review, and cross-references.

## PLANNING ↔ IMPLEMENTATION — per story

- `PLANNING/API-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation Django Ninja contract
  for a story: Schemas, endpoint signatures, the permission matrix, and error strategy.
- `IMPLEMENTATION/API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the post-implementation
  verification confirming the shipped API matches the contract and every write endpoint
  enforces its permission and ownership (IDOR) check.

## Relationship to other artefacts

- Written **after** `src/04-DATABASE/` schema is agreed and **before** `src/15-SPRINT-PLANS/`
- Feeds `workflows/19-api-code/` during implementation; verified in `workflows/22-pr-and-review/`

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `project-management/workflows/13-api-design/` — produces the `PLANNING/` design
- `code/docs/API-DESIGN.md` — Django Ninja conventions the design is written against
- `code/docs/SECURITY.md` — the permission/IDOR rules the design specifies and code enforces
- `project-management/src/02-STORIES/` — the story a design is written for

**Last Updated**: <%DATE%>
