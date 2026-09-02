# ADR-US002: The split target is a sub-folder, because a bare sibling file is bound by no length gate

**Status:** Proposed
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES-02-09-2026.md` <!-- doc-references: template-only -->
**Superseded by:** —
**Related:** US002

---

## Context

The superseded record decided that a register under length pressure **splits rather than
relocating**, and named the target `SLOP-FAMILY.md` (a bare sibling in the audits directory). **The split decision
stands. The target was wrong**, and the record asserted a property the tree does not have.

Both that ADR and the story plan state the new file is _"bound by the 300-line limit like any
instructional file"_. Measured at `code/src/scripts/audits/docs-length.sh:362-385`,
`is_instructional()` returns 0 only when:

- the basename is `CONTEXT.md` or `CLAUDE.md`; or
- the path carries a `/docs/` or `/workflows/` segment, or begins `.claude/`.

`SLOP-FAMILY.md` (a bare sibling in the audits directory) satisfies none, and falls through to `return 1`. **No
length gate would ever measure it.** Confirmed by running
`docs-length.sh --path code/src/scripts/audits --limit 1`: it reports _"checked 7 instructional
file(s)"_, and all seven are `CONTEXT.md`/`CLAUDE.md` pairs. Nothing under `code/src/scripts/**`
that is not half of a pair is measured by anything — `cloc.sh` passes `--exclude-lang=Markdown`
and cannot see it either.

So the superseded record discharged `code/docs/DOCUMENTATION-LENGTH.md` Section 6's obligation —
_"the receiving file is given its own ceiling in the same change"_ — against a gate that cannot
see the file. That is the `code/docs/GATE-REPORTING.md` defect, inside a story whose subject is
gate honesty.

**The remedy was already named and was not read.** `code/docs/DOCUMENTATION-LENGTH.md:24-25` states
the shape: _"split the detail into a `kebab-case/` sub-folder and leave the entry point a thin
index."_ A `SCREAMING-KEBAB` sibling file is a different shape, and the superseded record never
said it had departed from the documented one.

## Options considered

### Option A — Keep `SLOP-FAMILY.md`, and state that no gate measures it

- **Pros:** No extra file; the honest statement satisfies `GATE-REPORTING.md`'s letter.
- **Cons:** The ceiling becomes a review convention with nothing behind it, in the one story whose
  purpose is stopping a register outgrowing its gate. It solves this file's problem by creating an
  unmeasured file next to it.

### Option B — A **slop-family** sub-folder under `code/src/scripts/audits/`

- **Summary:** The rationale becomes `slop-family/CONTEXT.md`, with the `CLAUDE.md` its directory
  owes beside it. `audits/CONTEXT.md` keeps a short route.
- **Pros:** `CONTEXT.md` **is** instructional by basename, so the gate binds it at 300 with the
  270 ratchet — the ceiling is enforced, not promised. It is the shape
  `DOCUMENTATION-LENGTH.md:24-25` already prescribes. The rationale lands in an **orientation**
  file, which is what `DOCUMENTATION-PAIRING.md` asks of a why.
- **Cons:** Two files rather than one, and `docs-pairing.sh` will require both. The `CLAUDE.md` is
  thin, which is a smell in itself — a directory whose operating rules amount to little.

### Option C — Reopen the split and relocate into `audits/CLAUDE.md` after all

- **Cons:** Refused by the superseded record on grounds measurement did not disturb: it buys lines
  without reducing anything and puts a why in the operating half.

## Decision

**We will take Option B.** The deciding factor is that Option A asks this story to ship the exact
failure it exists to prevent — a register with no enforced ceiling — and to do so while its own
plan carries a section on why two other gates cannot be trusted here.

**The thin `CLAUDE.md` is accepted as a real cost, not waved away.** It will say how to edit the
rationale and what must not drift from `audits/CONTEXT.md`. If that proves to be one sentence, the
sub-folder was the wrong shape and a later record should say so.

**What the supersession does and does not change.** The split-not-relocate rule is unchanged and
is the reason both records exist. Only the target moves, from a bare sibling to a bound path.

## Consequences

- **Positive:** The receiving file has a ceiling a script enforces, so Section 6's obligation is
  discharged for real.
- **Negative / trade-off:** The Directory Tree gains ~4 lines for the sub-folder rather than 1 for
  a file, so the ledger lands near **231** before Step E's optional extra routing, against a target
  of 230. The gate is 270, so this is inside tolerance; the plan states where the further lines
  come from.
- **Negative / trade-off:** A thin `CLAUDE.md` exists mainly because the pairing rule requires it.
- **Follow-on:** `project-management/src/02-STORIES/US002.md` <!-- doc-references: template-only --> Scenario 3 must name
  **three** files rather than "one of the two" — amended in the same change, because the criterion
  as written cannot be satisfied by any split at all.
- **Follow-on:** The superseded record's Consequences claiming the file is bound by
  `DOCUMENTATION-LENGTH.md` are false and are retired with it; nothing should cite them.
