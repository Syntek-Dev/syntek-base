# Workflow: Quality Gates

The same eight gates run here, in the pre-PR hook, and in CI. Running them locally first turns
a red pipeline from a twenty-minute round trip into a local failure you can read immediately.

## Directory Tree

```text
how-to/workflows/06-quality-gates/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow **before raising a pull request**, or whenever CI has gone red and you
want to reproduce the failure locally rather than push-and-pray.

It runs the same eight gates the `.claude/hooks/pre-pr-check.sh` hook and the CI
`claude.yml` workflow run, plus the standalone audits. A clean local run is designed to
predict a clean CI run.

## Key concepts

- **Eight gates, one order.** cloc → lockfiles → format → lint → stubs → typecheck →
  tests → security. They run cheapest-first so the fastest failure surfaces soonest.
- **Local and CI are deliberately mirrored.** `audits/security.sh` states outright that it
  mirrors the CI `[8/8] Security` gate so a clean local run predicts a clean CI run. When
  they disagree, that is a bug in the mirroring — fix it rather than routing around it.
- **CI is stricter in one place:** an **80%** coverage floor applies on `staging` and
  `main`, above the 75% the runner enforces. A change that passes locally can still fail
  the promotion.
- **The audits are separate from the eight gates**, and each has its own path-filtered CI
  workflow: `cloc`, `stubs`, `css-tokens`, `css-gradients`, `copy-emdash`, `mobile-tokens`,
  `security`, `seam-contract`, `docs-pairing`, `docs-length`, `skill-conformance`, and the AI-slop
  family — `css-slop`, `template-slop`,
  `copy-slop`, `render-slop`, plus `style-check` on a desktop project. They are cheap; run them —
  `render-slop` is the one exception to cheap, because it drives a browser, and it self-guards to
  a note when Chromium is absent.
- **An audit is never a required status check, and that is why it may be path-filtered.**
  A required check must report on every pull request; a path-filtered one does not run when a PR
  touches none of its paths, so it never reports and the merge waits forever
  (`project-management/docs/GIT-GUIDE.md` § Required status checks and path filters).
- **`static-analysis` is the one audit with no CI workflow yet.** It needs the Opengrep engine
  installed in the runner, and until that is wired it would report a green job having scanned
  nothing — which is worse than no job. Locally it behaves the same way: **without `opengrep` on
  PATH it skips**, so a clean run of it is not evidence its rules pass.
- **Two tiers, one exit code.** The slop family, `cloc` and `docs-length` report `[gate: fail]` and
  `[gate: warn]` in a single run, and only a fail changes the exit code. That is deliberate: a
  threshold on composition or vocabulary fails correct work, so the script reports and a person
  decides (`code/docs/VISUAL-DESIGN.md` § 6). **Exit 0 with warnings is not a clean run** — it is
  a run with unanswered questions in it.
- **In this template, some gates report success with nothing to run.** `uv.lock` is absent
  by design, so the Python half of several CI jobs is guarded and skips. In a generated
  project they all execute.

## Cross-references

### Governing documents

- `how-to/src/CONTRIBUTING.md` — the standard the gates enforce
- `.claude/hooks/CONTEXT.md` — what the pre-PR hook runs and in which order

### Related reading

- `code/src/scripts/audits/CONTEXT.md` — every audit and what it detects
- `code/src/scripts/syntax/CONTEXT.md` — lint, format, and type-check runners
- `how-to/workflows/05-testing-and-coverage/` — the tests gate, in depth
- `code/workflows/07-review/` — content review, which precedes this process gate
- `project-management/workflows/22-pr-and-review/` — the PR itself, once gates are green
