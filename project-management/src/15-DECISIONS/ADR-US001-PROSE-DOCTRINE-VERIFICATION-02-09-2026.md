# ADR-US001: Prose doctrine is verified by a human read-across, not by `doctrine-drift.sh`

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US001

---

## Context

US001 moves cross-surface retry and idempotency doctrine out of two existing guides into a new
owning family, and its acceptance criteria require that no rule ends up stated in two homes. The
story's QA flag named `code/src/scripts/audits/doctrine-drift.sh` as the check that proves it.

That gate cannot do it. It registers three claims, all API-envelope JSON shapes, and it reads
**fenced code only** — its own documentation states that prose may discuss, quote and narrate a
rule freely, and that an example is what counts as stating it. Retry and idempotency doctrine is
prose. Run against this story's change, the gate answers green having examined nothing relevant,
which is exactly the failure `code/docs/GATE-REPORTING.md` names: a skip reaching the same
verdict as a pass.

The gate's own header already warns of the shallower version of this — a claim anchored on `^`
"silently matches nothing and the run still reports it as a claim with exactly one home". The
problem here is one level up: not a misanchored claim, but a class of rule the corpus cannot
contain.

This is not local to US001. Every remaining doctrine-migration slice in the backlog — the absence
family, the CAP-posture register's rule half, the nine rule-ownership slices — moves prose
between guides and meets the same fork. Deciding it once here is the point of recording it.

## Options considered

### Option A — Extend the gate: register the migrated rules as claims

- **Summary:** Add rows to `CLAIMS` so the migrated retry and idempotency rules are machine-checked.
- **Pros:** Enforced in CI, permanent, catches a future regression nobody is looking for.
- **Cons:** A claim must be a regex over fenced code that a statement has and a mention does not —
  a JSON key, a decorator, a setting assignment. Most of this doctrine has no such token, so the
  claims would either match nothing (the gate's own documented silent-pass defect) or match
  prose-adjacent noise. It also edits a script owned by an unresolved slice, making a second,
  unreviewed editor of the same file.

### Option B — Drop `doctrine-drift.sh` from the story's QA set

- **Summary:** Remove the check; rely on the story's per-rule scenarios and the reviewer.
- **Pros:** Honest — no gate claims coverage it does not have.
- **Cons:** Loses the regression guard over the three existing API-envelope claims during a change
  that edits `code/docs/` broadly. A green run there is genuinely worth having.

### Option C — Keep the gate, re-scoped, and add an explicit human read-across

- **Summary:** Run it as a regression guard, restate the check as "no **new** drift introduced",
  and make the duplicate detection an explicit human step recorded in the manual-testing record.
- **Pros:** The gate keeps guarding what it can see. The duplicate check is performed by something
  that can actually see prose. The scope limit is written down at the point of use, so no later
  reader mistakes green for coverage.
- **Cons:** The human check does not scale, is not enforced in CI, and depends on the reviewer
  performing it rather than ticking it.

### Option D — Do nothing

- **Summary:** Leave the QA line as originally written.
- **Pros:** None.
- **Cons:** Ships a check whose green result is a false claim about the very risk the story carries.

## Decision

**We will take Option C.** The deciding factor is that A and B each give up something real that C
keeps: A gives up honesty (a claim that matches nothing still reports one home), B gives up the
regression guard. C is the only option under which the gate's output means exactly what it says
and the duplicate risk is still checked by something capable of seeing it.

The scope limit is stated **at the point of use** — in the story's QA criteria and its QA plan —
rather than only here, because a reader running the gate is not reading this record.

## Consequences

- **Positive:** Green from `doctrine-drift.sh` now carries a stated, accurate meaning on this
  story and every doctrine migration after it. The duplicate check exists and is recorded.
- **Negative / trade-off:** The project accepts a manual check on the one risk this story is most
  exposed to. It will be skipped eventually; the manual-testing record is the only thing making
  that visible.
- **Follow-on:** No script change. The re-scoped wording is enforced in
  `project-management/src/02-STORIES/US001.md` and
  `project-management/src/11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` (AC-GAP-1).
  A later ADR should revisit this if `doctrine-drift.sh` ever gains a prose corpus — at which
  point the human step becomes redundant rather than merely unenforced.
