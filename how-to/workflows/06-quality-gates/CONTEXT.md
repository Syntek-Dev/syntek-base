# Workflow: Quality Gates

## Directory Tree

```text
how-to/workflows/06-quality-gates/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow **before raising a pull request**, or whenever CI has gone red and you
want to reproduce the failure locally rather than push-and-pray.

It runs the same eight gates the `.claude/hooks/pre-pr-check.sh` hook and the CI
`claude.yml` workflow run, plus the standalone audits. A clean local run is designed to
predict a clean CI run.

## Prerequisites

- [ ] The dev stack is running — several gates execute inside the container
- [ ] Your work is committed or staged; the gates read the working tree
- [ ] `code/workflows/07-review/` has been run on the change's content

## Key concepts

- **Eight gates, one order.** cloc → lockfiles → format → lint → stubs → typecheck →
  tests → security. They run cheapest-first so the fastest failure surfaces soonest.
- **Local and CI are deliberately mirrored.** `audits/security.sh` states outright that it
  mirrors the CI `[8/8] Security` gate so a clean local run predicts a clean CI run. When
  they disagree, that is a bug in the mirroring — fix it rather than routing around it.
- **CI is stricter in one place:** an **80%** coverage floor applies on `staging` and
  `main`, above the 75% the runner enforces. A change that passes locally can still fail
  the promotion.
- **The audits are separate from the eight gates** and each has its own CI workflow —
  `cloc`, `stubs`, `css-tokens`, `css-gradients`, `copy-emdash`, `mobile-tokens`,
  `security`. They are cheap; run them.
- **In this template, some gates report success with nothing to run.** `uv.lock` is absent
  by design, so the Python half of several CI jobs is guarded and skips. In a generated
  project they all execute.

## Cross-references

### Hard gates — read before executing Step 1

- `how-to/src/CONTRIBUTING.md` — the standard the gates enforce
- `.claude/hooks/CONTEXT.md` — what the pre-PR hook runs and in which order

### Soft references — consult during execution

- `code/src/scripts/audits/CONTEXT.md` — every audit and what it detects
- `code/src/scripts/syntax/CONTEXT.md` — lint, format, and type-check runners
- `how-to/workflows/05-testing-and-coverage/` — the tests gate, in depth
- `code/workflows/07-review/` — content review, which precedes this process gate
- `project-management/workflows/22-pr-and-review/` — the PR itself, once gates are green
