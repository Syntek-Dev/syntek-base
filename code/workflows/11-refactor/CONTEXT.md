# Workflow: Refactor

A refactor that also changes behaviour cannot be reviewed, because there is no longer a fixed
point to compare against. Keeping restructuring in its own workflow is what makes "no behaviour
change" a checkable claim.

## Directory Tree

```text
code/workflows/11-refactor/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when code is functionally correct but has accumulated technical
debt: it violates coding principles, a file exceeds 750 lines, business logic has
leaked into resolvers, or functions have grown beyond a single purpose.

**Never refactor and change behaviour in the same commit.** If a bug needs fixing
alongside a refactor, fix the bug first (use `code/workflows/10-debug/`), then
refactor separately.

## Key concepts

- **The test suite is the fixed point.** It is what turns "no behaviour change" from an assertion
  into a checkable claim — so a suite that goes red mid-refactor means this stopped being one
- Extract business logic from resolvers into service classes; when the extracted logic is a named
  access rule, shape it as a Policy class — when it is a variant algorithm, shape it as a Strategy
  class (see `code/docs/coding-principles/PRACTICAL-RULES.md — Decision Structuring`)
- Split any file exceeding 750 lines into focused modules
- One function — one purpose
- After refactoring, behaviour must be identical to before

## Cross-references

### Governing documents

- `code/docs/testing/COVERAGE.md` — coverage must not drop after a refactor; floors block PR

### Related reading

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **refactor playbook**
  (`.claude/skills/refactor-safely.md`): `refactor_tool` suggest/dead_code/rename, then
  `get_impact_radius` + `get_affected_flows` before moving any code
- `code/docs/coding-principles/PRACTICAL-RULES.md` — Design Patterns in Refactoring (the trigger
  rule, the smell-to-pattern map, the decision record), Decision Structuring (Policy/Strategy),
  DRY, KISS, YAGNI
- `code/docs/coding-principles/STYLE-AND-PROCESS.md` — error handling, naming, import rules, code review checklist
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — service layer and module structure
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — server/HTMX/Alpine boundary when refactoring frontend
- `code/docs/performance/DATABASE-PERFORMANCE.md` — performance patterns to apply during refactoring
- `code/docs/data-structures/SCHEMA-DESIGN.md` — domain model design when restructuring data access
- `code/docs/data-structures/DOMAIN-MODELLING.md` — domain constraints during structural changes
- `code/workflows/02-tdd-cycle/` — green baseline required before any refactor step
- `project-management/src/22-REFACTORING/` — where refactoring notes are saved
- `project-management/workflows/22-implementation-documentation/` — **how work reaches this
  workflow**: findings recorded there with a structural-debt disposition are routed to
  `src/22-REFACTORING/` and become the input for a refactor. There is no PM-layer refactor
  workflow — 19 is the entry point.
