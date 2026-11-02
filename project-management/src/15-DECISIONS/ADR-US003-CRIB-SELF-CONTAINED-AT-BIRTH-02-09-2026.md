# ADR-US003: The crib is self-contained at birth, and later slices retro-fit their own back-links

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US003

---

## Context

`code/docs/ABSENCE.md` ships a crib mapping six kinds of absence onto five runtime surfaces —
Python, Rust, Alpine, HTMX and mobile TypeScript. **All five rows land in US003. Only one of
the five has a target to cite today.**

The absence feature map's Destination states that per-surface clauses "land in the guide that
already owns that surface", and its slices divide the work accordingly:

| Surface   | Where its clause lands | Which slice   | Citable today                                  |
| --------- | ---------------------- | ------------- | ---------------------------------------------- |
| Rust      | `TYPES-RUST.md:156`    | already law   | **Yes** — settled at N-008, cited not restated |
| Python    | the Django surface     | `S-02`        | No                                             |
| HTMX      | the rendering guides   | `S-03`        | No                                             |
| Alpine    | the browser surface    | `S-03`/`S-04` | No                                             |
| Mobile TS | the mobile principles  | `S-04`        | No                                             |

So four of the five crib rows describe doctrine whose owning clause does not yet exist. Nothing
in the slice's acceptance said what those cells should contain in the interim, and the omission
was found at `11-qa-checks` as **AC-GAP-5**.

**The naive answer is forbidden by this story's own criteria.** A crib cell citing
`code/docs/rendering/PITFALLS-AND-EXAMPLES.md#absence` before `S-03` writes it is a dangling
path, which `code/src/scripts/audits/doc-references.sh` Check 1 catches — `code/docs/*` is in
its checkable-tree `case`, so unlike the PM-`src/` tree these citations are genuinely verified.
US003 would ship a guide that reddens the gate for as long as four slices take to land.

The competing pull is navigability. A crib is most useful when each cell reaches the rule
behind it in one hop, and a guide that never links out ages into a summary nobody trusts.

## Options considered

### Option A — Self-contained cells, and never linked

- **Summary:** Each cell states the expression directly — `Option`, `None`, `204`, an empty
  partial — and the crib is never wired to the per-surface clauses at all.
- **Pros:** Green gate today and forever; no obligation on any later slice; the crib stands
  alone as a quick-reference table, which is what a crib is for.
- **Cons:** The guide permanently duplicates in summary what four other guides state in full,
  with no mechanical link between them. That is the drift `doctrine-drift.sh` exists to catch,
  arriving by a route the table cannot see — a summary and its source disagreeing silently.

### Option B — Forward citations now

- **Summary:** Cells point at the clause each slice will write, accepted as dangling until it
  lands.
- **Pros:** The final shape is written once; no later slice has to remember anything.
- **Cons:** Contradicts US003's own scenario 10 and reddens a gate that genuinely works on this
  tree, for the duration of four slices. It also spends the one thing the citation gate still
  does reliably — checking `code/docs/*` — to buy convenience.

### Option C — Self-contained at birth, back-links retro-fitted by the slice that creates the target

- **Summary:** Cells are self-contained when the guide is born. `S-02`, `S-03` and `S-04` each
  add the back-link from their surface's crib cell to the clause they write, in the same change
  that creates it.
- **Pros:** Green gate at every point in the sequence. The final state is B's, reached without
  ever passing through a red one. It puts the edit in the change that creates its target, which
  is the same same-change discipline this repository already applies to attribution
  (`.claude/CLAUDE.md` Section 6) and to clause-14 reciprocity.
- **Cons:** The obligation lives in three future slices, and an obligation recorded in a story
  that has not been cut yet is an obligation that can be forgotten. It also means the crib is
  briefly in A's state, so if all three slices were abandoned the guide would silently keep A's
  duplication problem.

## Decision

**We will take Option C.**

The deciding factor is sequencing: C reaches B's end state without the intermediate red gate,
and the cost is an obligation rather than a defect. B trades a working gate for convenience,
and A gives up the link permanently to avoid a bookkeeping cost that C shows is payable.

**The same-change rule is what makes C safe rather than merely optimistic.** The back-link is
not scheduled work that a later slice might deprioritise — it is part of the acceptance of the
change that creates the thing being linked to, exactly as an `_Influences_` row lands with the
rule it credits. A slice that writes its clause without its back-link has not finished.

## Consequences

- **Positive:** `code/docs/ABSENCE.md` is born with a green citation gate and stays green
  through four subsequent slices, on a check that genuinely works for `code/docs/*`.
- **Positive:** Each back-link is written by whoever writes the clause, who knows where it
  should point — rather than by US003's implementer guessing at a path four slices ahead.
- **Negative / trade-off:** Between US003 and `S-04`, the crib summarises doctrine it does not
  link to. A reader in that window has to search rather than click.
- **Negative / trade-off:** Three future slices carry an obligation that nothing enforces
  mechanically. `doctrine-drift.sh` will not notice a missing back-link, and no gate checks that
  a crib cell reaches its clause.
- **Follow-on — and this one is currently unowned.** The absence feature map's slice rows for
  `S-02`, `S-03` and `S-04` do **not** carry the back-link clause in their acceptance. Editing a
  wayfinder artefact's acceptance is outside every workflow that has run for US003 —
  `02-story-creation` may write only the `Story` column, and `11-qa-checks` and `15-decisions`
  touch no map at all. **Until those three rows are amended, this decision is recorded here and
  in `project-management/src/02-STORIES/US003.md`'s Dependencies and nowhere the slices will be
  read from.** The amendment needs an owner before `S-02` is cut, or the obligation is lost at
  exactly the moment it first falls due.
