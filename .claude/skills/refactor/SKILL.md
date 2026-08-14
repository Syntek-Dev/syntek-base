---
name: refactor
description: >-
  Restructure working code in <%PROJECT_NAME%> without changing what it does — split a file
  past the 750-line limit, lift business logic out of an endpoint into a service, remove
  duplication, deepen a shallow module, rename for clarity. Load when the code is correct but
  its shape is wrong. Never to add a capability (`feature`), fix a fault (`bugfix`), or write
  the tests that make the restructure safe (`test-writer`) — and not the scan that ranks
  candidates before one is chosen (`improve-codebase-architecture`).
model: opus
metadata:
  skills: codebase-design domain-modelling global-workflow grilling stack-django stack-htmx-templates
---

# Refactor (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the scope and the behaviour-preserving boundary are settled in
the conversation, and the scoped edits below are dispatched).

> **The golden rule: observable behaviour must not change.** Same inputs, same outputs, same
> side effects, an identical public API unless <%DEVELOPER_NAME%> has explicitly authorised a
> break. **Never refactor and change behaviour in the same commit** — a refactor that also
> changes behaviour has no fixed point left to be reviewed against.

---

## Open with a grilling pass

Settle the **exact scope**, the **behaviour-preserving boundary** (what must not change), the
**seams** code will move across, and the **coverage** that will prove behaviour held. The
`grilling` skill owns the round shape (`.claude/CLAUDE.md` Section 10).

`/improve-codebase-architecture` is the optional opener where the target is not yet chosen — it
ranks deepening candidates as a report before the grilling pass picks one.

## Pre-flight — the baseline

```bash
bash code/src/scripts/tests/backend.sh
```

**Red tests stop this skill.** Do not refactor against a broken baseline. Where the target has
**no** coverage, flag the risk and have `test-writer` add characterisation tests first — without
them "behaviour is unchanged" is an assertion, not a claim anyone can check.

Then scope the move structurally: the code-review-graph **refactor playbook**
(`.claude/skills/refactor-safely.md`; guide `code/docs/CODE-REVIEW-GRAPH.md`) runs
`refactor_tool` suggest/dead_code/rename, then `get_impact_radius` and `get_affected_flows`
before anything moves — it finds the callers faster and more cheaply than Grep.

## What to look for

- **Oversized files (>750 lines)** — split into focused modules; the limit is a hard one.
- **Long functions and methods** — break up with guard clauses and early returns.
- **God objects** — split by responsibility.
- **Deep nesting and long parameter lists** — flatten with early returns; pass a dataclass.
- **Duplication** — repeated blocks, copy-paste logic, magic numbers and strings: extract and
  name them.
- **Cryptic or inconsistent names** — rename to be self-documenting. Renaming beats explaining.
- **Feature envy and tight coupling** — move logic to where its data lives, and introduce a seam.

**Reason about depth, not just tidiness.** The `codebase-design` skill supplies the vocabulary —
module, interface, seam, depth, leverage, locality, the deletion test — and a refactor that only
moves shallow code around has spent effort without buying any.

## Where extracted code belongs

Backend: business logic out of Ninja endpoints into service classes (thin endpoints), shared
model behaviour into mixins, abstract bases and custom managers, repeated query patterns into
queryset methods, and any method with ≥2 writes still wrapped in `transaction.atomic()` —
`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` owns the shapes, including the Policy class
for a named access rule and the Strategy class for a variant algorithm.

Frontend: repeated markup into django-components, promoted to the shared library only once it is
broadly reusable; repeated style literals into the token layer, consumed as `var(--token)` —
`code/docs/architecture/FRONTEND-PATTERNS.md` and `code/docs/DESIGN-TOKENS.md` own the shapes.

**Two things a move must never quietly drop:** the explicit permission check on a state-changing
endpoint, and the ownership verification behind it. A refactor that relocates an endpoint and
loses its Policy has introduced a vulnerability while claiming to change nothing.

## The sequence

Phases 3 and 5 are separate Agent tool calls to `general-purpose`, naming the skill to load.
**They dispatch separately so that no phase checks its own output.**

1. **Refactor**, in small independently reversible increments — one kind of refactoring at a
   time. A restructure that needs deep stack knowledge dispatches the edit to the `backend` or
   `frontend` skill.
2. **Verify green** — `bash code/src/scripts/tests/backend.sh`. Red after the refactor means
   behaviour changed: fix or revert **before** review.
3. **Review** — the `code-reviewer` skill, **not a dispatch that edited in phase 1**. It
   confirms the structure improved and the behaviour did not.
4. **Documentation** — a hard gate before the commit. Every `CONTEXT.md` affected by a moved,
   renamed or restructured file; a `CONTEXT.md` + `CLAUDE.md` pair in every new directory; a
   record under `project-management/src/21-REFACTORING/` where the change is material; `GAPS.md`
   for debt surfaced and not addressed. A renamed or deepened module is recorded via the
   `domain-modelling` skill, in the nearest `CONTEXT.md`.
5. **Commit** — the `git` skill, message `refactor(<scope>): <short description>`.

**Docstrings and comments on touched code** follow
`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 4 — the why-only rule, the no-outside-
references rule, and the ban on `TODO`/`FIXME`. It is the owner; this skill does not restate it.

## Definition of done

Tests unchanged and green; coverage not dropped; behaviour identical; every touched file within
750 lines (800 grace); no permission check or ownership verification lost in a move; the
documentation gate satisfied; the commit is `refactor(...)` and carries no behaviour change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/11-refactor/` — **the procedure of record for this skill**
- `code/workflows/02-tdd-cycle/` — the green baseline required before any refactor step
- `code/workflows/10-debug/` — where a bug surfaced mid-refactor is fixed, first and separately
- `project-management/workflows/21-implementation-documentation/` — how a refactor is
  commissioned: findings routed to `project-management/src/21-REFACTORING/`

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — the length limits, naming, and the principles applied here
- `code/docs/coding-principles/PRACTICAL-RULES.md` — decision structuring, DRY, KISS, YAGNI
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` · `code/docs/architecture/FRONTEND-PATTERNS.md`
- `code/docs/testing/COVERAGE.md` — the floors a refactor must not drop below
- `code/docs/PERFORMANCE.md` — read when the refactor touches a query or render hot path
