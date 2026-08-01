@./CONTEXT.md

# CLAUDE.md — src/12-API-DESIGN/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the 10-step design structure, the N/A path, when to write one — imported above) → this file.

## Purpose (one line)

Pre-implementation API designs — one per user story — fixing the Django Ninja contract
(Schemas, read/write endpoint signatures, permission matrix, error strategy) before any
code is written.

## How to work here

- **Routing:** designs are produced by `project-management/workflows/12-api-design/` using
  the `planner` agent, against a story in `../../01-STORIES/` and its agreed schema in
  `../../03-DATABASE/`, written to `code/docs/API-DESIGN.md` (Django Ninja) conventions. The
  design is fixed **after** the schema is signed off and **before** `../../14-SPRINT-PLANS/`,
  and it feeds `project-management/workflows/17-api-code/`. Read a story's design before
  implementing it.
- **Model:** Fable — the contract defines the shared interface; the Schemas, handler
  contracts, and permission matrix are substantive design judgement. Opus only for a
  status flip, header bump, or a rename.
- **Concrete steps:** copy `API-PLAN-US000-TEMPLATE.md` → `API-PLAN-US###-<DESCRIPTOR>.md`
  → complete the 10 steps (API surface → Ninja Schemas → read endpoints → write endpoints →
  real-time & async → permission matrix → error strategy → breaking changes → peer review →
  cross-references) → give every endpoint a permission-matrix row → cross-link the `US###`
  and the paired `../IMPLEMENTATION/` record → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** every endpoint carries a permission rule and (where it takes a
  user-supplied ID) an ownership check; nullable/optional fields justified; pagination
  stated for each list endpoint; the design is consistent with `code/docs/API-DESIGN.md`;
  British English; DD/MM/YYYY dates.

## Guardrails

- **Every write endpoint carries an explicit permission rule, and every user-supplied ID an
  ownership (IDOR) check (OWASP A01)** — the design _specifies_ what `code/` then _enforces_.
  An endpoint with no permission-matrix row is incomplete; keep it consistent with
  `code/docs/SECURITY.md`. No PII field may be reachable by an unauthenticated caller.
- These are **pre-implementation** contracts — they are _specified_ here and _verified_
  against the shipped endpoints in `../IMPLEMENTATION/`; the verification answers the
  design, never backfills it.
- **Documentation only** — no implementation code (`code/src/django/`), no migration SQL
  or ERDs (`../../03-DATABASE/`), no user stories (`../../01-STORIES/`); no secrets or
  `.env` content.
- One design per story; do not batch multiple stories into one file. There is no
  cross-cutting by-scope report folder — API design is per story. Every new directory needs
  a `CONTEXT.md`; instructional files stay ≤ 300 code lines (this artefact is exempt).

## Output & naming

- **Hand-written:** `API-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none — the client-facing `API-DESIGN.pdf` is regenerated from these
  sources in `project-management/export/`, never hand-edited.
- Filename descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
