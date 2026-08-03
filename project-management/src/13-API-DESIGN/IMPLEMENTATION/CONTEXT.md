# project-management/src/13-API-DESIGN/IMPLEMENTATION

Post-implementation API verification records — **one per user story**. Each record
confirms, with evidence, that a story's shipped Django Ninja API matches the design
contract in `../PLANNING/`, and closes any open items from that contract before the story
is merged.

## Directory Tree

```text
project-management/src/13-API-DESIGN/IMPLEMENTATION/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── API-IMPL-US000-TEMPLATE.md        ← copy this to record a story's API verification
└── API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one record per story shipping Ninja API surface
```

## File naming

```text
API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `API-IMPL-US000-ADMIN-AUTH-01-01-2026.md`. Prefix `API-IMPL-`, three-digit
zero-padded story number, `SCREAMING-KEBAB-CASE` descriptor, then the date DD-MM-YYYY.

## When to create a file here

Write a record during `project-management/workflows/21-implementation-documentation/`, after a story's
Ninja API code ships and before the story closes. Copy `API-IMPL-US000-TEMPLATE.md`, open
the story's design contract in `../PLANNING/API-PLAN-US###-*.md`, and verify the shipped
API against it.

## What belongs in each record

- Header table: story (US###), date, sprint, branch, reviewer, a link to the design
  contract, and an outcome (Matches contract / Matches with deviations / Blocked)
- API surface shipped — each contract endpoint marked Present / Changed / Missing
- Contract conformance — each Schema and endpoint from the design marked
  Present / Missing / Changed, with a Python symbol and handler file as evidence
- Permission enforcement — every write endpoint confirmed to carry an explicit permission
  rule and an ownership/IDOR check in the shipped code (OWASP A01)
- Error types and pagination verified against the contract; a breaking-change assessment
- Each deviation from the design justified, with follow-ups tracked to a target story
- A sign-off checklist that blocks the merge until complete

## Relationship to the design contract

The design contract now lives in `../PLANNING/` (`API-PLAN-US###-*.md`), not at the
`13-API-DESIGN/` folder root. This record **answers** that contract; it verifies the
plan, never backfills it. A story that ships no Ninja API surface records that fact in the
header outcome and needs nothing further.

## Cross-references

- `API-IMPL-US000-TEMPLATE.md` — the per-story verification template
- `../PLANNING/` — the pre-implementation design contracts these records verify
- `../CONTEXT.md` — the API-design folder overview and the PLANNING/IMPLEMENTATION split
- `../../17-TESTS/` · `../../18-REVIEWS/` — downstream test status and code-review notes
- `code/docs/API-DESIGN.md` · `code/docs/SECURITY.md` — the Django Ninja conventions and the
  permission/IDOR enforcement these records must stay consistent with
- `project-management/workflows/21-implementation-documentation/` — where these records are written

**Last Updated**: <%DATE%>
