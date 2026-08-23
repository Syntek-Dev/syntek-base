# BUG: US000 — {ONE-LINE DEFECT TITLE}

_Template — copy to `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. One defect found in the code that closes a single user story (US###), captured with its reproduction, root cause, fix, and the regression test that keeps it fixed._

> A genuinely **cross-cutting** defect — not owned by one story (an audit finding, a
> shared-infrastructure fault) — uses the fallback filename `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`
> and leaves the story fields as `N/A — cross-cutting`.

| Field            | Value                                                |
| ---------------- | ---------------------------------------------------- |
| **Story**        | US### — {short story title}                          |
| **Story doc**    | `../02-STORIES/US###.md`                             |
| **Story plan**   | `../17-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` |
| **Severity**     | Critical / High / Medium / Low                       |
| **Date found**   | {DD/MM/YYYY}                                         |
| **Last Updated** | {DD/MM/YYYY}                                         |
| **Status**       | Open / Fixed / Verified                              |
| **Found during** | QA / review / production / debug session             |
| **Reporter**     | {name / agent / audit}                               |

---

## 1. Summary

One line: what breaks, where, and the user-visible or system impact.

_[EXAMPLE] `{function_or_component}` in `code/src/django/apps/{app}/{module}.py` {does the wrong
thing}, so {who} sees {wrong outcome} instead of {right outcome}._

## 2. Environment

Where the defect reproduces — enough to rule out a local-only quirk.

| Aspect      | Value                                                   |
| ----------- | ------------------------------------------------------- |
| **Surface** | Backend / API (Django Ninja) / templates / HTMX partial |
| **Route**   | `{/route/path/ or /api/ endpoint}`                      |
| **Env**     | local / CI / production                                 |
| **Build**   | `{branch or commit / version}`                          |

_[EXAMPLE] Surface: public frontend · Route: `/{page}/` · Env: local · Build: `us###/{short-description}`._

## 3. Reproduction steps

Numbered, deterministic, from a known starting state. Redact any PII or token that appears.

1. {Starting state — e.g. sign in as {role}, open `{/route/}`.}
2. {Action.}
3. {Action.}
4. Observe: {the wrong outcome}.

## 4. Expected vs Actual

|              | Behaviour                           |
| ------------ | ----------------------------------- |
| **Expected** | {what should happen}                |
| **Actual**   | {what happens instead — the defect} |

## 5. Root-cause analysis

Why it happens — the underlying cause, not the symptom. Trace it to the line(s) responsible;
use `code/workflows/09-debugging-with-logs/` when the trail runs through structured logs.

_[EXAMPLE] `{call}` fires before `{precondition}` is set, so `{state}` is read as `{wrong}`; the
guard at `{module}:{line}` only checked `{X}`, never `{Y}`._

| File                                              | Lines   | Issue                          |
| ------------------------------------------------- | ------- | ------------------------------ |
| _[EXAMPLE] `code/src/django/apps/{app}/{mod}.py`_ | _{a–b}_ | _{what is wrong at this site}_ |

## 6. The fix

The approach taken, and every file touched. The patch itself ships in `code/` under the story's
own branch — this record describes intent and points at the change, it does not hold a diff.

**Approach:** {one or two lines — the corrected logic / guard / pattern}.

**Files touched:**

- _[EXAMPLE] `code/src/django/apps/{app}/{module}.py` — {what changed}_
- _[EXAMPLE] `code/src/django/templates/marketing/{page}.html` — {what changed}_

## 7. Regression test (write the failing test FIRST — TDD)

Follow `code/workflows/10-debug/`: **write the test that reproduces the defect and watch it fail
BEFORE applying the fix**, then make it pass. The test is what proves the bug is dead and keeps it
dead. State the name, location, and what it asserts.

| Test                            | Location                                             | Asserts                          |
| ------------------------------- | ---------------------------------------------------- | -------------------------------- |
| _[EXAMPLE] `test_example_case`_ | _`code/src/django/apps/{app}/tests/test_example.py`_ | _{repro path now returns right}_ |

- **Red:** {the assertion that failed against the buggy code}.
- **Green:** {the same assertion passing after the fix}.

## 8. Impact & related stories

Blast radius, and every story or record this touches.

- **Impact:** {who/what was affected, and how widely — one story, one route, or shared}.
- **Related stories:** _[EXAMPLE] US### — {title} (shares the affected component)_.
- **Related records:** _[EXAMPLE] `../19-REVIEWS/REVIEW-US###-<DESCRIPTOR>.md` · `../18-TESTS/US###-TEST-STATUS.md`_.

## 9. Verification

Commands are project scripts under `code/src/scripts/**/*.sh` — never raw pytest / pnpm / docker.

- `bash code/src/scripts/tests/all.sh` — full suite green, including the new regression test.
- _[EXAMPLE] `bash code/src/scripts/tests/backend.sh` — backend-only run while iterating._

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] `bash code/src/scripts/tests/all.sh` green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US###.md` — the story this defect belongs to
- `../17-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` — the code master the fix closes the loop on
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `code/workflows/09-debugging-with-logs/` — tracing a defect through structured logs
- `../19-REVIEWS/` · `../18-TESTS/` — the review and test records from the same PR
