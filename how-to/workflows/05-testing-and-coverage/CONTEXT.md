# Workflow: Testing & Coverage

## Directory Tree

```text
how-to/workflows/05-testing-and-coverage/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow to **run** the test suites and read what they report — before raising a
PR, after a restore or reset, when chasing a coverage floor, or when deciding whether a
suite is worth trusting.

**This is not how you write tests.** Authoring them is `code/workflows/02-tdd-cycle/`
(Red → Green → Refactor). This workflow is the operator's side: which runner, which flags,
what the numbers mean, and what to do when one goes red.

## Prerequisites

- [ ] The dev stack is running (`code/src/scripts/development/server.sh`)
- [ ] Migrations are current (`code/src/scripts/database/migrate.sh check`)
- [ ] For the e2e suite: browsers installed on first run

## Key concepts

- **One core suite, opt-in extras.** `tests/all.sh` always runs the backend pytest suite;
  `--api` adds the Bruno integration collection, `--all` is shorthand for every optional
  suite, `--coverage` swaps in the coverage variant. Nothing else runs unless you ask.
- **The floors are minimums, not targets** — 75% line **and** branch, **90% on
  auth-related code**. One standard, enforced once per runtime: `coverage.py` and Jest
  share no accumulator, so a mobile project reports two numbers against one rule.
- **e2e and mutation testing are deliberately not automatic.** `e2e-py.sh` is marked `e2e`
  and excluded from default runs; `mutmut.sh` is slow by nature. Both are run when you have
  a reason, not on every change.
- **A green suite is not a passing gate.** CI applies an **80%** floor on `staging` and
  `main` over and above the 75% the runner enforces. Workflow `06-quality-gates` is what
  predicts CI, not this one.
- **Coverage measures what ran, not what was checked.** A high number with tautological
  assertions is worse than a low honest one — see `code/docs/testing/COVERAGE.md`.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/testing/COVERAGE.md` — the floors, what they count, and the discipline rules
- `code/src/scripts/tests/CONTEXT.md` — every runner, its flags, and its exit codes

### Soft references — consult during execution

- `code/workflows/02-tdd-cycle/` — writing the tests this workflow runs
- `how-to/workflows/06-quality-gates/` — the full pre-PR gate, of which tests are one
- `how-to/workflows/08-debugging/` — when a failure is environmental, not logical
- `code/workflows/10-debug/` — when a failure is a genuine code fault
