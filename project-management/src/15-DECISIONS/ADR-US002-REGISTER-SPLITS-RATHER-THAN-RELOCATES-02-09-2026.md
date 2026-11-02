# ADR-US002: A register under length pressure splits, rather than relocating into its sibling

**Status:** Superseded
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** `project-management/src/15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` <!-- doc-references: template-only -->
**Related:** US002

---

## Context

> **Superseded 02/09/2026 on a measured false claim.** The split-not-relocate rule below
> stands. Its named target does not: `SLOP-FAMILY.md` (a bare sibling in the audits directory) is bound by **no**
> length gate — `docs-length.sh`'s `is_instructional()` admits only a `CONTEXT.md`/`CLAUDE.md`
> basename or a `/docs/`, `/workflows/`, `.claude/` path. The Consequences below claiming it is
> bound are false. See the superseding record.

`code/src/scripts/audits/CONTEXT.md` stands at **298 counted lines against a 300 limit**, and nine
planned audit scripts need **three rows each** — a Directory Tree row, an inventory row and a
Dependencies row — so **27 lines are due**, plus 4 Dependencies rows already missing for scripts
that exist. US002 exists to make room.

**Measured section by section, the room is not there.** The totals below reconcile exactly to
`docs-length.sh`'s 298:

| Section                                                                       | Counted | Disposition                |
| ----------------------------------------------------------------------------- | ------- | -------------------------- |
| Directory Tree · Scripts · Common Flags · Exit Codes · Reports · Dependencies | 177     | Registers — cannot be cut  |
| _The AI-slop family — why four scripts and not one_                           | 70      | Rationale                  |
| `security.sh` · _Markdown: two limits_ · _Cargo tree_ · TDD bypass            | 46      | The only unprotected prose |
| Preamble                                                                      | 5       | —                          |

Deleting **all 46** unprotected lines and adding the 4 owed Dependencies rows lands at **256**.
Twenty-six further lines must come from the registers or from the rationale.

**Cutting the rationale is refused, on the pairing guide's own words.**
`code/docs/DOCUMENTATION-PAIRING.md:62-64` names `## Why three scripts and not one` as the exemplar
of a `CONTEXT.md`'s highest-value content — _"Rationale is orientation of the highest value"_ — and
the section at issue is literally that exemplar. Its second-axis argument is also load-bearing:
it is why `render-slop.sh` is a separate script carrying a browser dependency no sibling has.

**Relocating it into `CLAUDE.md` is refused too, and this is the decision's real subject.** It
would work arithmetically — 165 + 26 = 191, inside the cap US002 sets — but it puts a _why_ into
the operating-rules half, which the same guide says is the wrong home, and
`code/docs/DOCUMENTATION-LENGTH.md` Section 6 names it exactly: _"an operating rule moving to
`CLAUDE.md` is the pairing rule being obeyed, and a rationale moving there to buy lines is this
rule being evaded."_ The pair would hold the same number of lines and the wall would have moved
one file along.

**The file's own allowance comment records a split being declined.** `CONTEXT.md:8`, dated
22/08/2026, says a split _"was considered and declined on the deletion test, the inventory being
genuinely one table"_. That decline is not overturned lightly, and this record does not claim it
was wrong when made — its premise has since moved, which is the argument below.

## Options considered

### Option A — Relocate ~26 lines of rationale into `CLAUDE.md`

- **Summary:** Move enough of the AI-slop rationale next door to reach 230.
- **Pros:** No new file; reaches the target exactly; both files stay within their caps.
- **Cons:** Puts a rationale in the operating half, against `DOCUMENTATION-PAIRING.md`. The pair
  carries the same total, so the next registering story meets the same wall one file along. It is
  the precise behaviour `DOCUMENTATION-LENGTH.md` Section 6 was written to name.

### Option B — Split the rationale into `SLOP-FAMILY.md` (in `code/src/scripts/audits/`)

- **Summary:** The AI-slop family's rationale becomes its own file in the same directory;
  `CONTEXT.md` keeps a short route to it.
- **Pros:** The rationale stays in an orientation file, whole and in one piece. `CONTEXT.md` lands
  near **228** with room for all 27 forward rows and more. `docs-pairing.sh` is **directory**
  -level, so a third `.md` beside the pair owes no new `CONTEXT.md`/`CLAUDE.md` — verified against
  `code/docs/DOCUMENTATION-PAIRING.md`. The four external citations of _The AI-slop family_ get a
  more stable target than a heading inside a moving file.
- **Cons:** Overturns a decline recorded in the file itself. Adds a file to a directory whose
  register the story is trying to shorten, and one more place a reader must look.

### Option C — Abandon the 230 target and land at ~256

- **Summary:** 270 is the gate and 230 only the target, so ship at 256 with the reason recorded.
- **Pros:** No structural change and no overturned decision. Legal under the story's own criteria.
- **Cons:** 256 leaves **14 lines against a 27-line forward demand**. The next registering story
  shrinks this file again, having inherited a smaller budget and the same protected sections — the
  problem is deferred at interest, not solved.

### Option D — Split the inventory instead, keeping the rationale in place

- **Summary:** Move the script inventory table out, since it is the register that grows.
- **Cons:** It is the register every future story must edit, so moving it moves the growth without
  reducing it, and the 22/08/2026 decline applies with full force here — the inventory is
  genuinely one table, and an index over sub-registers of one table is a worse artefact.

## Decision

**We will take Option B, and the rule generalises: when an orientation file outgrows the cap, a
self-contained rationale splits into its own file in the same directory — it does not migrate into
the operating-rules half.**

The deciding factor is that Option A buys lines without reducing anything, and does it by putting
content in the half the pairing guide says is wrong for it. A split moves a whole, coherent
argument to a file that is still orientation; a relocation dismembers it into the wrong register.
Both cost a reader one hop; only one of them leaves the doctrine where it belongs.

**On overturning the 22/08/2026 decline.** That note declined a split of the **inventory**, and its
stated reason — _"the inventory being genuinely one table"_ — is still true and is why Option D is
refused here. It was not a decline of splitting the _rationale_, and it was written before the
27-row forward demand was measured. This record supersedes nothing: it decides a different
question the earlier note did not reach.

## Consequences

- **Positive:** `CONTEXT.md` lands near 228 with headroom for every planned registration and a
  margin beyond, so no later story in the set has to shrink it again.
- **Positive:** The rationale survives whole rather than as the 26 lines that happened to fit, and
  the four external citations of _The AI-slop family_ gain a file to point at instead of a heading
  inside a file the story is rewriting.
- **Negative / trade-off:** A third file in the directory, and a reader looking for why there are
  four slop scripts now takes one hop. The Directory Tree gains a row, which is one of the lines
  the story is trying to save.
- **Negative / trade-off:** The `CLAUDE.md` cap of 200 that US002 sets becomes belt-and-braces
  rather than load-bearing, since this decision removes the pressure to relocate at all. It stays,
  because it is what stops a later implementer reaching for Option A.
- **Follow-on:** `CONTEXT.md:8`'s `docs-length-allow` comment is retired by this story. Its
  reasoning — that lines are paid for by compressing restatements — is superseded by this record
  for the rationale specifically, and the comment must not be left asserting a remedy the story
  did not use.
- **Follow-on:** The new file is bound by `code/docs/DOCUMENTATION-LENGTH.md` like any other
  instructional file, and is registered in the Directory Tree in the same change that creates it.
