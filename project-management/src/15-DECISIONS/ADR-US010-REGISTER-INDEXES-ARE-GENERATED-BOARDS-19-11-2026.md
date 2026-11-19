# ADR-US010: Register indexes are generated boards, and a status line is a plain value plus a status note

**Status:** Accepted
**Status note:** Accepted 19/11/2026 by <%DEVELOPER_NAME%> at US010's re-cut grilling (round 2 Q4), in the same pass that settled the design it records
**Date:** 19/11/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`, `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`
**Superseded by:** None
**Related:** US010 · US011 (absorbed) · `project-management/src/02-STORIES/US010.md` (_Re-cut — 19/11/2026_) · `project-management/src/17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` · `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` N-001, N-002, N-003

---

## Context

**US010 was cut on 20/09/2026 to give seven registers a hand-written index file each**, and two
records of 21/09/2026 decided how those files would read status. The first,
`project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`, made a
map's `**Status**` header `<enum> · <prose>` — a five-value enum, the value plain, any prose after
the first middle dot — so an index could mirror a value that string-equals. The second,
`project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`, gave every
index one read rule for every register's carrier: strip bold, backticks and a trailing comment, cut
at the first space-middle-dot-space, trim.

**7.7.0 (31/10/2026) built the index for five registers another way.** `pm-board.sh` writes a
generated, committed `*-BOARD.md` for `01-FEATURE-MAPS`, `02-STORIES`, `03-SPRINTS`,
`16-SPRINT-PLANS` and `17-STORY-PLANS`, one row per instance — ID, the title from the H1, the status
verbatim, a link — from each item's status line. A generated project receives each board from a
`.copier/` seed moved by the copy-gated `_tasks` entry, `.github/scripts/shipped-boards.sh` proves
every seed is exactly what the generator renders for the seed-only tree, and `pm-board.sh --check`
fails a stale board. The same release normalised every map's status line: a plain `**Status:**`
value from a vocabulary `.claude/skills/completion/SKILL.md` owns, and a free-text
`**Status note:**` line beside it. The map enum's five values, its middle-dot format and its
count-derived tests were overtaken; the story recorded that on 31/10/2026 and 02/11/2026 and left
the re-cut to the first step of its build.

**Three registers are left: `15-DECISIONS`, `20-FINDINGS` and `21-BUGS`.** Measured 19/11/2026,
each holds instances — ADRs 31, findings 9, bugs 12 (the cross-cutting
`BUG-<DESCRIPTOR>-DD-MM-YYYY.md` fallback included) — and each carries status a different way: an
ADR a bold prose line, a finding the last middle-dot-separated field of a metadata line, a bug a
table row with a bold key cell. The question at the re-cut was whether those three get the
hand-written files the story planned, or the boards 7.7.0 built for the other five.

## Options considered

### Option A — the hand-written index files as planned

- **Summary:** `DECISION-INDEX.md`, `FINDING-INDEX.md` and `BUG-INDEX.md`, each with the
  `Status · Instance · Summary · Updated` spine, read under the 21/09/2026 read rule; seeds checked
  by a third `shipped-registers.sh` family.
- **Pros:** a Summary column a reader can scan; the design was fully settled.
- **Cons:** two index mechanisms in one tree, one generated and one hand-kept, with two seed gates
  and two read rules. Every row is a hand edit that drifts — which is exactly the failure that
  started the map (`01-FEATURE-MAPS/CONTEXT.md` reading "None charted yet" beside fifteen maps).
  The read rule exists only to make heterogeneous carriers mirrorable by hand.

### Option B — generated boards, and status lines normalised to the 7.7.0 shape

- **Summary:** three new `pm-board.sh` kinds, `DECISIONS`, `FINDINGS` and `BUGS`, writing
  `DECISIONS-BOARD.md`, `FINDINGS-BOARD.md` and `BUGS-BOARD.md` through 7.7.0's seed chain,
  `SEEDED`, `shipped-boards.sh` and `--check`. Each register's status carrier becomes a plain
  `**Status:**` value plus a free-text `**Status note:**` line, the vocabulary owned by the
  `completion` skill: ADR `Proposed | Accepted | Superseded | Deprecated`; finding
  `Open | Triaged`; bug `Open | Fixed | Verified`.
- **Pros:** one mechanism for all eight registers; no row is ever written by hand, so none drifts;
  the generator's own status reader replaces the bespoke read rule; the seed gate already exists
  and proves byte-identity with the generator.
- **Cons:** the board has no Summary column, so a reader scans titles (the H1), not a one-line
  précis; every existing ADR, finding and bug status line is rewritten once; the decisions board
  needs two tail columns the other kinds lack.

### Option C — boards, reading each register's existing carrier as it stands

- **Summary:** as B, but `pm-board.sh` learns three carrier shapes instead of the files changing.
- **Pros:** no instance file edited.
- **Cons:** the generator grows a second and third parser for what 7.7.0 settled as one line
  shape; the free prose already sitting in some status lines stays unreadable as a value.

## Decision

**We will take Option B.** The three remaining register indexes are generated boards, and every
register's status line is a plain value plus a status note. Settled 19/11/2026 at US010's re-cut
grilling, rounds 1 to 4:

1. **The three indexes are boards** — `pm-board.sh` / `pm-lib.sh` kinds `DECISIONS`, `FINDINGS`
   and `BUGS`, reusing 7.7.0's seed chain, `SEEDED`, `shipped-boards.sh` and `--check`. No
   hand-written `DECISION-INDEX.md`, `FINDING-INDEX.md`, `BUG-INDEX.md` or `MAP-INDEX.md` exists
   (round 1 Q1).
2. **Every `BUG-*.md` but `BUG-US000-TEMPLATE.md` is an instance**, the cross-cutting fallback
   included (round 1 Q2).
3. **Status lines are normalised as 7.7.0 normalised maps** — a plain `**Status:**` value from the
   `completion` skill's vocabulary, and any prose on a `**Status note:**` line (round 1 Q3).
4. **Each ADR carries both `**Supersedes:**` and `**Superseded by:**`**, a full filename or
   `None`, and the decisions board shows both as tail columns (round 2 Q2, round 3 Q2).
5. **Board columns are ID · Title (H1) · Status · File**, plus the decisions board's two tail
   columns; no Summary and no Updated column (round 3 Q3).
6. **The three kinds archive** through `pm-archive.sh <ID>`: an ADR once `Superseded` or
   `Deprecated`, a finding once `Triaged`, a bug once `Verified`; `archive/` is frozen (round 2 Q3,
   round 3 Q1).

**It beat A because a hand-kept index is the failure this work began from**, and two mechanisms
side by side would leave every reader asking which one a register uses. It beat C because the
line shape is already settled for five registers; the cost of rewriting three registers' status
lines once is lower than a generator that parses four shapes for ever.

**This supersedes both records of 21/09/2026.** The enum record's writer format is replaced by the
plain value and its note, and its map vocabulary was already replaced by 7.7.0. The read rule is
replaced by the generator's own status reader: a value that is plain needs no rule to strip it.

## Consequences

- **Positive:** eight registers, one index mechanism, one seed gate, one status shape. A board
  cannot be stale without `pm-board.sh --check` failing, and a seed cannot carry a row without
  `shipped-boards.sh` failing.
- **Negative / trade-off:** no Summary column — a register is scanned by its titles, so a title has
  to be legible on its own (the re-cut keeps that read as a manual criterion). Every ADR, finding
  and bug status line is rewritten in one pass, and an accepted ADR's status line changing shape is
  a format normalisation, not a change to its decision.
- **Follow-on:** the three kinds, their seeds and `_tasks` lines, `SEEDED`, `shipped-boards.sh` at
  eight boards with its check 2 tightened to the copy-gated task, an update probe in
  `.github/scripts/shipped-ai.py` proving byte-identity, the vocabularies in
  `.claude/skills/completion/SKILL.md` and archive support in `pm-archive.sh` — all US010's, as
  re-cut. The 72-case generation matrix moves to its own story. `MAP-REGISTER-INDEXES.md`'s `S-03`
  gate, which was to assert presence, symmetry and status over hand-written files, has nothing left
  to assert that `--check` and `shipped-boards.sh` do not already; its disposal is that map's own
  owner's, not this record's.
