---
workflow: 05-testing-and-coverage
phase: verify
skills: [qa-tester, global-workflow]
model: opus
---

# Testing & Coverage — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                             |
| ---- | ------------------------------------------------------------------- |
| 1    | **Reference guides** → DEVELOPMENT.md (stack health before any run) |
| 2–3  | **Reference guides** → CLI-TOOLING.md (runner flags)                |
| 4    | **Cross-layer references** → `code/docs/testing/COVERAGE.md`        |
| 5    | **External — Debugging** → pytest, pytest-django                    |

---

## Step 1 — Get the stack into a testable state

> **Model:** opus

```bash
bash code/src/scripts/development/server.sh status
bash code/src/scripts/database/migrate.sh check
```

A suite run against a stale database produces failures that describe the environment, not
the code — and those are the ones that waste an afternoon. Fix the environment first
(workflow `08-debugging`) rather than reading its symptoms as test failures.

---

## Step 2 — Run the suite you actually need

> **Model:** opus

```bash
bash code/src/scripts/tests/backend.sh                # fastest signal, no coverage
bash code/src/scripts/tests/all.sh                    # the core suite
bash code/src/scripts/tests/all.sh --coverage         # + coverage thresholds
bash code/src/scripts/tests/all.sh --all --coverage   # + every optional suite
```

Work up, not down: the plain backend run is the tightest loop, and coverage only matters
once the suite is green. Narrow further with pytest's own selection when iterating on one
area — through the script, never a bare `pytest`.

---

## Step 3 — Add an optional suite when there is a reason

> **Model:** opus

```bash
bash code/src/scripts/tests/api.sh          # Bruno HTTP-layer integration
bash code/src/scripts/tests/e2e-py.sh       # Playwright + axe (marked e2e, opt-in)
bash code/src/scripts/tests/mutmut.sh run   # mutation testing — slow, deliberate
bash code/src/scripts/tests/mutmut.sh results
```

Reasons that justify each: **api** — you changed an endpoint contract; **e2e** — you
changed a page, a template, or anything a11y-relevant; **mutmut** — you suspect a suite is
green while asserting nothing, which is the failure coverage cannot see.

---

## Step 4 — Read the coverage honestly

> **↳ New dispatch:** `general-purpose` · **Skill:** `qa-tester` · **Model:** opus

```bash
bash code/src/scripts/tests/backend-coverage.sh
bash code/src/scripts/tests/open-coverage.sh
```

Against the floors in `code/docs/testing/COVERAGE.md`: **75% line and branch**, **90% on
auth-related code**. Both sides of every branch must be exercised — a 75% line score with
40% branch coverage means the error paths are untested, which is where the bugs live.

Two things the number cannot tell you, and which you must check by reading the diff:
whether the assertions come from an independent source of truth rather than recomputing
what the code computes, and whether they go through the public interface. A tautological
test raises coverage and catches nothing.

---

## Step 5 — Act on a failure

> **Model:** opus

| Failure looks like                            | Go to                                |
| --------------------------------------------- | ------------------------------------ |
| Container down, DB unreachable, import error  | `how-to/workflows/08-debugging/`     |
| Wrong output, wrong state, a real logic fault | `code/workflows/10-debug/`           |
| Below a coverage floor                        | `code/workflows/02-tdd-cycle/`       |
| Green suite, but you do not trust it          | `mutmut.sh run`, then `02-tdd-cycle` |

Never adjust a floor to make a run pass. The floors are minimums set once, in
`code/docs/testing/COVERAGE.md`; moving one is a documented decision, not a fix.

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
