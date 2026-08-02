@./CONTEXT.md

# CLAUDE.md — workflows/05-testing-and-coverage/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for **running** the test suites and reading what they report — runner
selection, flags, coverage floors, and where each kind of failure routes.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Execution
  and coverage judgement → `qa-tester` (Opus). Writing the tests is **not** this workflow —
  `code/workflows/02-tdd-cycle/` owns that.
- **Model:** Opus throughout.
- **Concrete steps:** confirm stack health → run the tightest useful suite → add optional
  suites with a reason → read coverage against the floors → route the failure.
- **Definition of done:** suites green; floors met (75% line and branch, 90% auth); every
  failure routed rather than worked around.

## Guardrails

- **Never run `pytest`, `playwright`, or `mutmut` directly** — always the scripts under
  `code/src/scripts/tests/`.
- **Never lower a coverage floor to make a run pass.** The floors live once in
  `code/docs/testing/COVERAGE.md`; changing one is a documented decision.
- **Rule out the environment before reading a failure as a code fault.** A stale database
  or a downed container produces failures that describe neither.
- **Coverage is not correctness.** A tautological assertion raises the number and catches
  nothing; assert from an independent source of truth, through the public interface.
- **CI is stricter than the runner** — an 80% floor applies on `staging` and `main`. This
  workflow does not predict CI; `06-quality-gates` does.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Generated (never committed):** coverage and JUnit output under
  `code/src/scripts/tests/reports/`.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`.
