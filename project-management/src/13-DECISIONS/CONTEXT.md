# project-management/src/13-DECISIONS

Architecture Decision Records (ADRs) — significant technical and design decisions with
context, options considered, and rationale. One immutable record per decision.

## Directory Tree

```text
project-management/src/13-DECISIONS/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules for this folder
├── ADR-000-TEMPLATE.md     ← ADR template — copy to author a new decision
└── ADR-###-<TITLE>.md      ← one file per accepted decision (e.g. ADR-001-<TITLE>.md)
```

**Naming:** `ADR-###-<TITLE>.md` — 3-digit zero-padded index, `TITLE` in `SCREAMING-SNAKE-CASE`.

## What each ADR records

Each ADR captures five sections — **Status** (Proposed / Accepted / Superseded /
Deprecated), **Context**, **Options considered**, **Decision**, and **Consequences** —
under a metadata header (Date, Deciders, Supersedes / Superseded by, Related `US###` /
`ADR-###`). The full scaffold with authoring guidance lives in `ADR-000-TEMPLATE.md`.

## Rules

- **Immutable once Accepted** — never rewrite a decision in place. To change course,
  raise a new ADR and mark the old one `Superseded`, cross-referencing both records.
- **Indices are unique and monotonic** — never reuse a retired number; gaps are
  acceptable, collisions are not.
- **Documentation only** — an ADR states a security or architecture _decision_; it is
  _enforced_ in `code/`. No source, secrets, or `.env` content here.

## Authoring a new ADR

Copy `ADR-000-TEMPLATE.md` → take the next free `ADR-###` index → fill the five sections
→ cross-link the `US###` that drove or consumes it → set **Status** to `Accepted` on
sign-off.

**Last Updated**: {{DATE}}
