# Workflow: Refactor

## Directory Tree

```text
code/workflows/08-refactor/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when code is functionally correct but has accumulated technical
debt: it violates coding principles, a file exceeds 750 lines, business logic has
leaked into resolvers, or functions have grown beyond a single purpose.

**Never refactor and change behaviour in the same commit.** If a bug needs fixing
alongside a refactor, fix the bug first (use `code/workflows/07-debug/`), then
refactor separately.

## Prerequisites

- [ ] All tests are green before starting
- [ ] No open bugs on the scope being refactored
- [ ] The scope of the refactor is clearly defined

## Key concepts

- Tests must stay green throughout — run them after every meaningful change
- Extract business logic from resolvers into service classes
- Split any file exceeding 750 lines into focused modules
- One function — one purpose
- After refactoring, behaviour must be identical to before

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — rules the refactor must satisfy
- `code/docs/ARCHITECTURE-PATTERNS.md` — service layer and module structure
- `project-management/src/14-REFACTORING/` — where refactoring notes are saved
