@./CONTEXT.md

# CLAUDE.md — workflows/06-quality-gates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for running the eight pre-PR gates and the standalone audits locally, so a
clean local run predicts a clean CI run.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Lint,
  format and type failures → `syntax` (Opus); test failures → workflow
  `05-testing-and-coverage`; content judgement → `code/workflows/07-review/`, which
  precedes this.
- **Model:** Opus throughout.
- **Concrete steps:** format → lint → type-check → audits → tests with coverage → the full
  `pre-pr-check.sh` → raise the PR.
- **Definition of done:** all eight gates green, audits clean, coverage floors met —
  including the higher promotion floor when the PR targets a promotion branch
  (`code/docs/testing/COVERAGE.md`).

## Guardrails

- **Never suppress a gate to make it pass.** A `noqa`, a widened type, or a lowered floor
  is a change to the codebase's guarantees and must be argued, not slipped through.
- **Local and CI must agree.** When they disagree the mirroring is the bug — fix the script
  or the workflow rather than pushing repeatedly to discover what CI wants.
- **The coverage floor is stricter on the promotion branches.** Never restate the number
  here — `code/docs/testing/COVERAGE.md` owns it, and a second copy is a second home.
- **This gate checks form, not judgement.** Green gates do not mean the change is right;
  `code/workflows/07-review/` is where content is reviewed, and it comes first.
- **In this template several gates skip by design** (no `uv.lock`). Expected here; not a
  broken gate, and not something to "fix" by unguarding them.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Generated (never committed):** audit and coverage output under
  `code/src/scripts/reports/` and `code/src/scripts/tests/reports/`.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`.
