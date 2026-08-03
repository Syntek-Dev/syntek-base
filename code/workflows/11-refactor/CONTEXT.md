# Workflow: Refactor

## Directory Tree

```text
code/workflows/11-refactor/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when code is functionally correct but has accumulated technical
debt: it violates coding principles, a file exceeds 750 lines, business logic has
leaked into resolvers, or functions have grown beyond a single purpose.

**Never refactor and change behaviour in the same commit.** If a bug needs fixing
alongside a refactor, fix the bug first (use `code/workflows/10-debug/`), then
refactor separately.

## Prerequisites

- [ ] All tests are green before starting
- [ ] No open bugs on the scope being refactored
- [ ] The scope of the refactor is clearly defined

## Key concepts

- Tests must stay green throughout — run them after every meaningful change
- Extract business logic from resolvers into service classes; when the extracted logic is a named
  access rule, shape it as a Policy class — when it is a variant algorithm, shape it as a Strategy
  class (see `code/docs/coding-principles/PRACTICAL-RULES.md — Decision Structuring`)
- Split any file exceeding 750 lines into focused modules
- One function — one purpose
- After refactoring, behaviour must be identical to before

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/testing/COVERAGE.md` — coverage must not drop after a refactor; floors block PR

### Soft references — consult during execution

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **refactor playbook**
  (`.claude/skills/refactor-safely.md`): `refactor_tool` suggest/dead_code/rename, then
  `get_impact_radius` + `get_affected_flows` before moving any code
- `code/docs/coding-principles/PRACTICAL-RULES.md` — Decision Structuring (Policy/Strategy), DRY, KISS, YAGNI
- `code/docs/coding-principles/STYLE-AND-PROCESS.md` — error handling, naming, import rules, code review checklist
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — service layer and module structure
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — server/HTMX/Alpine boundary when refactoring frontend
- `code/docs/performance/DATABASE-PERFORMANCE.md` — performance patterns to apply during refactoring
- `code/docs/data-structures/SCHEMA-DESIGN.md` — domain model design when restructuring data access
- `code/docs/data-structures/DOMAIN-MODELLING.md` — domain constraints during structural changes
- `code/workflows/02-tdd-cycle/` — green baseline required before any refactor step
- `project-management/src/21-REFACTORING/` — where refactoring notes are saved
- `project-management/workflows/21-implementation-documentation/` — **how work reaches this
  workflow**: findings recorded there with a structural-debt disposition are routed to
  `src/21-REFACTORING/` and become the input for a refactor. There is no PM-layer refactor
  workflow — 19 is the entry point.
