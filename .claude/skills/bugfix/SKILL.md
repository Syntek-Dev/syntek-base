---
name: bugfix
description: >-
  Fix a bug in <%PROJECT_NAME%> end to end — reproduce it behind a red command, pin the actual
  root cause, write the failing regression test, apply the minimal fix, QA it, document it and
  commit. Load when something is broken, a regression appeared, or a runtime error, wrong
  output or stale-cache fault needs root-causing from a trace or from existing logs. Diagnosis
  alone is the `## Root cause` phase below, entered on its own. Not restructuring code that
  already works (`refactor`), not auditing a vulnerability in code behaving as written
  (`security`), and not adding the log instrumentation a future diagnosis will read (`logging`).
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-htmx-templates
---

# Fix a Bug (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the symptom, the reproduction and the intended scope of the
fix all arrive in the conversation, and the phases below dispatch rather than run here).

**Two entry points.** The whole sequence, or the `## Root cause` phase alone. A diagnosis step
that names this skill names that phase — it authorises an investigation and a written finding,
never a fix or a commit.

---

## Open with a grilling pass

Settle the exact expected-versus-actual behaviour, the precise reproduction steps, and the
intended **scope of the fix** before dispatching anything. An obvious one-line fix skips it.
The `grilling` skill owns the round shape (`.claude/CLAUDE.md` Section 10); the confirmed answers
become the brief for the root-cause phase.

## Root cause

**Scoped entry point.** Find the actual cause, not a symptom: isolate and document, ship
nothing. `code/workflows/10-debug/STEPS.md` owns the method — the tight-feedback-loop hard
gate, the 3–5 ranked falsifiable hypotheses, one variable at a time, and the `[DEBUG-####]`
probe tagging — and it is not restated here.

- **Confirm the environment is healthy first** via `how-to/workflows/08-debugging/`. A fault
  that is really a broken container costs a day if diagnosed as a logic bug.
- **Trace structurally before searching manually.** Run the code-review-graph **debug playbook**
  (`.claude/skills/debug-issue.md`; guide `code/docs/CODE-REVIEW-GRAPH.md`) —
  `semantic_search_nodes` → `query_graph` callers/callees → `get_flow` → `detect_changes` →
  `get_impact_radius`. Fall back to Grep and Glob only where the graph does not reach.
- **Locate the evidence** with the read-only helpers: `.claude/plugins/log-tool.py` for log
  files, `.claude/plugins/env-tool.py` for environment config, `.claude/plugins/git-tool.py`
  for recent changes. Staging and production faults go through
  `code/workflows/09-debugging-with-logs/`.
- **For a rendered-UI fault**, inspect console, network and rendered HTML with the
  `claude-in-chrome` MCP (load its schema via ToolSearch) at
  `http://dev.<%PROJECT_SLUG%>.localhost`.
- **The root cause must explain every symptom.** If one is left over, the hypothesis is wrong —
  form another rather than stopping at the first plausible issue.
- **An `InvariantViolation` in a trace is the guard working, not the fault.** It carries its
  register key, so `how-to/src/INVARIANTS.md` names which rule broke and the one function that
  enforces it — and the cause is always **upstream of the raise**. "Fixing" the guard buries a
  real defect and removes the only thing that reported it.
- **The error class narrows the search before any hypothesis does**
  (`code/docs/NEGATIVE-SPACE.md`). `DependencyUnavailable` points at the outbound adapter and the
  provider rather than at our logic; a `ServiceError` subclass is a user-facing path behaving as
  written. A 500 that turns out to be an ordinary user mistake, or a friendly 4xx that turns out
  to be a broken invariant, is a **mis-classification** — correcting the class is part of the
  fix, not a tidy-up afterwards. Where the report came from a user, `X-Request-ID` is the join
  between what they quote and the tracker event.
- **Watch the locale-shaped faults:** <%LOCALE%> dates (DD/MM/YYYY) and <%TIMEZONE%> handling,
  alongside the usual null access, async timing, shared-reference mutation, off-by-one,
  encoding, stale cache and dev-versus-prod drift.
- **A root cause that is a security defect is documented and handed to `security`**, not
  patched here.

**Output of this phase:** the confirmed root cause cited to `file:line`, the hypotheses ruled
out, the recommended fix and who should implement it, plus the bug report at
`project-management/src/20-BUGS/` from `BUG-US000-TEMPLATE.md` for anything non-trivial.
**When stuck**, state what has been ruled out and name the logging or repro detail still needed
— never guess a fix to appear productive.

## The full sequence

Each phase below is a separate Agent tool call to `general-purpose`, naming the skill to load in
the prompt and briefing it fully — a fresh dispatch has no memory of the previous one. **Phases
dispatch separately so that no phase checks its own output**; that is a convention this skill
holds, not something the runtime enforces.

1. **Root cause** — the phase above.
2. **Regression test** — the `test-writer` skill. The red command from phase 1 is the seed; the
   test must be RED before any fix. **A different dispatch from phase 3.**
3. **Minimal fix** — the `backend` or `frontend` skill, by fault location. Minimal: no
   refactoring of surrounding code in the same commit.
4. **Verify green** — no dispatch. Run `bash code/src/scripts/tests/backend.sh`; the phase-2
   test must now pass.
5. **QA** — the `qa-tester` skill, checking for regressions in surrounding features. **A
   different dispatch from phase 3**, and a hard gate before phase 6.
6. **Documentation** — no dispatch, and a hard gate before the commit. Update every `CONTEXT.md`
   the fix affects, write or complete the bug report, and record anything broader in `GAPS.md`
   or `DEFERRED.md`.
7. **Commit** — the `git` skill, message `fix(<scope>): <short description>`.

## Definition of done

The root cause is documented and explains every symptom; a regression test written before the
fix now passes; the fix is minimal; QA found no regression; the bug report exists and the
affected `CONTEXT.md` files are current; the commit is conventional and scoped.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/08-debugging/` — **first** — confirm the environment is healthy
- `code/workflows/10-debug/` — **the method of record** — isolate the fault, pin it with a
  regression test, apply the minimal fix
- `code/workflows/09-debugging-with-logs/` — staging and production faults, via the log stack
- `code/workflows/02-tdd-cycle/` — the regression-test cycle
- `project-management/workflows/21-implementation-documentation/` — owns the finding and routes
  it to `project-management/src/20-BUGS/`

## Cross-references

- `code/docs/LOGGING.md` — where logs land, and what is in them
- `code/docs/NEGATIVE-SPACE.md` · `how-to/src/INVARIANTS.md` — the three error classes, and the
  register a raised key resolves against
- `code/docs/TESTING.md` — the harness a reproduction is built on
- `code/docs/CODE-REVIEW-GRAPH.md` — the debug playbook and its tool sequence
- `code/docs/BACKEND-CODING-PRINCIPLES.md` · `code/docs/FRONTEND-CODING-PRINCIPLES.md`
- `project-management/src/20-BUGS/BUG-US000-TEMPLATE.md` — the bug report's shape
