---
type: guide
skills: [cicd, global-workflow]
model: opus
---

# Gate reporting — what a check may claim it looked at

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

Every gate in this repository — the `syntax/` scripts, the `audits/`, the `.claude/hooks/` check
libraries and the CI jobs over them — ends by printing a verdict and setting an exit code. This
guide owns one rule about that verdict, and the three families route here rather than restating
it: `code/src/scripts/syntax/CLAUDE.md`, `code/src/scripts/audits/CLAUDE.md` and
`.claude/hooks/CLAUDE.md`.

## 1. The rule

> **"Could not look" is never reported as "looked, and it was clean."**

A gate that was unable to run a leg has produced **no result** for that leg. Printing a success
line and exiting `0` states a result it does not have, and the reader cannot tell the difference —
which is the whole failure, because the reader is usually a pull-request gate or an agent
following a checklist.

## 2. The distinction the rule turns on

**An absent tool is not an absent surface**, and only the first is a breach.

| Situation                     | Population              | Correct verdict                       |
| ----------------------------- | ----------------------- | ------------------------------------- |
| The **tool** is absent        | Full, and unexamined    | **Never clean.** Report "not run"     |
| The **surface** is absent     | Legitimately empty      | **Clean is correct.** Note the reason |
| The tool ran and found no hit | Non-empty, examined     | Clean                                 |
| The population is zero        | Empty for another cause | See _§5, the boundary_                |

`mobile-tokens.sh` on a web-only project has nothing to check and is right to exit `0` with a
note — that is `audits/CLAUDE.md`'s self-guarding rule, and it is the second row, not a breach of
the first. `check-typecheck.sh` without `basedpyright` on `PATH` has an entire Python tree it did
not examine — that is the first row.

The test that separates them, and it is the same one the feature maps use for a frontier:
**name the search, its population and its exclusions.** If the population is empty because there
is nothing of that kind here, clean is honest. If it is unexamined because the means was missing,
it is not.

## 3. How each family expresses it

One rule, three idioms. None of them is a restatement of another — they are the same rule in the
vocabulary each family already has.

### Scripts under `code/src/scripts/syntax/`

The published contract gains a fourth code:

| Code | Meaning                                                              |
| ---- | -------------------------------------------------------------------- |
| `0`  | Every requested leg ran, and found nothing                           |
| `1`  | A leg ran and found issues                                           |
| `2`  | Script error — bad arguments, or a prerequisite the caller must fix  |
| `3`  | **Every leg that ran was clean, and at least one leg could not run** |

`3` is non-zero **deliberately**: a caller that treats any non-zero as failure fails closed, which
is the safe direction. The summary names which legs did not run and why, so `3` is actionable
rather than merely alarming.

### Check libraries under `.claude/hooks/lib/`

`_dual_result` takes a per-leg **state**, not only an integer, and `CHECK_PASS` gains a third
value, `unmeasured`. The pre-PR gate reports an `unmeasured` check in its own tier and **does not
block on it**, because these checks run on a developer's machine where a missing host tool is
ordinary. Blocking there converts a reporting defect into a workflow defect, and a gate that
blocks the maintainer's own machine is a gate that gets switched off.

An `unmeasured` host leg must never be paired with a container leg into a `MISMATCH` verdict: a
mismatch asserts two results, and there is only one.

### Audits under `code/src/scripts/audits/`

Unchanged, and that is the point — `audits/CLAUDE.md`'s _"a self-guarding audit must exit `0`,
not fail, when its surface is absent"_ is §2's second row and stays exactly as written. What the
rule adds there is the note: an audit that exits `0` over an absent surface **says so in its
output**, so the zero is legible as "nothing of this kind here" rather than "nothing wrong here".

## 4. What this rule is not

- **Not a ban on skipping.** Skipping is often correct. The ban is on skipping _silently_, or on
  a skip reaching the same verdict as a pass.
- **Not a demand that every gate fail closed.** §3 deliberately gives the scripts a non-zero code
  and the hook libraries a non-blocking state, because their readers differ.
- **Not applicable to advisory hooks that produce no verdict.**
  `.claude/hooks/context-threshold-handoff.sh` always exits `0` by design — it fires on every
  prompt submission and must never block typing. It reports nothing, so it claims nothing, and a
  hook that claims nothing cannot claim something false. That reasoning is written where it
  belongs, in `.claude/hooks/CLAUDE.md`.

## 5. The boundary with a zero population

A gate whose population is zero for a reason it never checked is a **different** defect: it looked
in a place that could not contain the thing, and reported success. That is a scoping fault, not a
reporting one, and it is tracked separately.

The two are told apart by a single question: **could this run have found a member?**

- **No, because the tool was missing** → this guide, §1.
- **No, because the search was wrong** → a scoping fault. Fix the search, then this guide applies
  to whatever it then could not do.
- **Yes, and it found none** → clean, and correctly so.

## 6. Enforcement

There is no automated gate over this guide, and stating that plainly is deliberate: a detector for
"reported a result it did not have" would have to know what each leg intended, which is exactly
the knowledge the defect destroys. It is enforced at review, and the review question is one line:

> **For every success line this change can print — name what ran to earn it.**

A success line that cannot be traced to an execution is the defect, whatever the exit code says.
