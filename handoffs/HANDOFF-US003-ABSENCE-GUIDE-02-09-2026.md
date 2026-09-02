# HANDOFF — US001 specified; next story is US003, with US002 running in parallel

**Written**: 02/09/2026 · **Branch**: `pm/navigation-map-n014` · **Session**: the per-story
specify tier for US001

---

## Goal

Cut and specify the backlog one story at a time through the per-story loop
(`project-management/docs/planning/CADENCE.md`). US001 is now through the whole specify tier.
**A parallel Claude Code session owns US002** (the audits shrink story), so this line of work
takes **US003 = `MAP-ABSENCE.md` slice `S-01`** — the third and last member of wave 0.

---

## Done

### US001 cleared the specify tier — `02` → `03` → `11` → `15`

Ten of the thirteen gates were correctly skipped on `N/A` flags; the loop ran only the gates
whose flag was live, plus the two that are unflagged.

| Workflow             | Landed                                                                                                                                         |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `03-sprint-planning` | `project-management/src/03-SPRINTS/SPRINT-01.md` — **new**, open, 5/11 SP, US001 only                                                          |
| `11-qa-checks`       | `project-management/src/11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — **new**, `Signed off`, six AC-gaps found and all fed back |
| `15-decisions`       | Two ADRs, both **`Accepted`** — the gate's close condition                                                                                     |

### Decisions settled by grilling (three rounds, all confirmed by Sam)

| Round      | Settled                                                                                                                                                                                           |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `03` Q1–Q4 | SPRINT-01 opens with US001 alone and accumulates · capacity written as `5 / 11 SP` · timeline `TBD` · N/A flag sections deleted, but Verification Checks keep every line with `— **N/A**, reason` |
| `11` Q1–Q4 | `doctrine-drift.sh` kept but re-scoped + a human read-across · a completeness AC added · UI-shaped QA sections kept as `N/A` with reason · all six gaps resolved into the story immediately       |
| `15` Q1–Q3 | ADR for the prose-doctrine decision · ADR **and** a `GAPS.md` entry for the citation defect · no ADR for the reliability family's shape (the map already records it)                              |

### The two accepted ADRs — both bind US003

- `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` —
  `doctrine-drift.sh` reads **fenced code only** and registers three API-envelope claims, so it
  cannot see prose doctrine. It runs as a regression guard; the duplicate check is an explicit
  human read-across. **Applies to every doctrine-migration story, US003 included.**
- `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md` —
  PM artefacts cite one another by **full repo-relative path**. `doc-references.sh` Check 2 flags
  a token only where it does not resolve, so `project-management/src/02-STORIES/US001.md` passes
  and a bare `US001.md` does not. This supersedes the previous session's backtick-stripping
  workaround, which was never necessary.

### Repairs made along the way

- `project-management/src/03-SPRINTS/SPRINT-00-TEMPLATE.md` — gained the `**Status:**` field
  `.claude/skills/completion/SKILL.md` edits but no template defined. Swept in the same change
  through `project-management/docs/planning/SPRINTS.md` and the `03-SPRINTS` pair, so all four
  field lists agree.
- `project-management/src/02-STORIES/US000-TEMPLATE.md` — gained the `## Decisions` section that
  `15-decisions` Step 12 requires in every story and the scaffold never carried.
- `project-management/workflows/11-qa-checks/` — all four files named
  `QA-US###-<DESCRIPTION>.md`, which no folder accepts. Corrected to
  `QA-PLAN-US###-<DESCRIPTOR>.md` (6 occurrences).
- `GAPS.md` — one new entry dated 02/09/2026 on `doc-references.sh` over-applying its
  shipped-file rule to the copier-excluded `project-management/src/**` tree.

### Gates — all pass

`docs-length.sh` · `docs-pairing.sh` · `doc-references.sh` · `doctrine-drift.sh` ·
`syntax/lint.sh --file-type markdown` · `syntax/format.sh --file-type markdown`.

---

## In-flight

- **Nothing is committed.** 24 dirty paths on `pm/navigation-map-n014`, by the standing agreement
  carried from the previous session. Every workflow's final commit step is unrun.
- **`project-management/src/03-SPRINTS/SPRINT-01.md:39-45`** — Story Summary holds US001 only,
  `**Total:** 5 SP` against a capacity of 11. **US002 and US003 both need admitting here as they
  clear `15`**, and the FLAGS table above it (`:22-36`) is a union that must be **recomputed**,
  never edited row-by-row.
- **`project-management/src/02-STORIES/US001.md`** — specified, `Status: Open`, not implemented.
  Its Definition of Done boxes are correctly unticked.
- **Seven pre-existing dirty files** not from either session: `GAPS.md` (now also ours) and six
  maps — `MAP-CAP-POSTURE`, `MAP-GATE-PARITY`, `MAP-PROGRESSIVE-ENHANCEMENT`,
  `MAP-REGISTER-INDEXES`, `MAP-RULE-OWNERSHIP`, `MAP-SUBDOMAIN-ROUTING`.

### Parallel session — US002, the audits shrink story

A second Claude Code session is running US002. **Do not touch its surface:**

| Path                                         | Why                                                             |
| -------------------------------------------- | --------------------------------------------------------------- |
| `code/src/scripts/audits/CONTEXT.md`         | US002's whole subject — 298 counted lines against the 300 limit |
| `project-management/src/02-STORIES/US002.md` | Being written there                                             |

**Shared files where both sessions will collide — read before writing:**

| Path                                                  | The risk                                                                                                  |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `project-management/src/03-SPRINTS/SPRINT-01.md`      | Both stories get admitted to it; both recompute the flag union and the SP total                           |
| `GAPS.md`                                             | Appended to by this session today                                                                         |
| `project-management/src/02-STORIES/US000-TEMPLATE.md` | Gained `## Decisions` today — if US002 was cut before that, it lacks the section and needs it back-filled |

**Neither session may edit `code/src/scripts/audits/doc-references.sh`** — it belongs to
`project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`, which is blocked on
that map's RESOLVE sitting. See the `GAPS.md` entry dated 02/09/2026.

---

## Next

**Cut US003 from `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` slice `S-01`** — "The
guide, `ABSENCE.md`, born under 270" — through
`project-management/workflows/02-story-creation/`, then run its per-story loop. The slice's three
nodes (N-008, N-009, N-018) are all resolved, and its `Story` column is still `—`, so Step 4
back-fills `US003` there.

Then run the loop against US003's own FLAGS: `03` (admit to SPRINT-01) → whichever gates are live
→ `15`. **`16`/`17` stay blocked** until SPRINT-01's accepted total reaches 11 SP; with US001 at
5, US002 and US003 together will very likely trigger both.

---

## Next skills

`story` + `grill-with-docs` (cutting US003) · `sprint` (admitting it to SPRINT-01) ·
`planner` (if `15-decisions` surfaces an ADR) · `git` (the commit, whenever Sam calls it).

---

## Open questions

1. **`MAP-ABSENCE.md` says all thirteen of `S-01`'s flags read `N/A` — including `QA`.** Taken
   literally, US003 skips `11-qa-checks` entirely. That gate just found **six** acceptance-criteria
   gaps in US001, whose map manifest _did_ give `QA` a value; and `S-01` ships a new guide with a
   `< 270 cloc at birth` acceptance clause and four registration surfaces, all of which are
   checkable. Settle before cutting: is the map's blanket `N/A` right, or does `QA` earn a manual
   value the way US001's did?
2. **Story numbering assumes US002 is taken.** `project-management/src/02-STORIES/` holds only
   `US001.md` in this worktree. Confirm the parallel session has claimed `US002` before writing
   `US003`, or the two sessions collide on a number.
3. **`18-consolidate-design-work` as a gate for this backlog** — carried unresolved from the
   previous session. It is a hard gate on implementation but consolidates `src/04`–`08`, and only
   two of the 45 ready slices carry a design flag. Cheaper to decide now than once the backlog is
   deep.

---

## Artefacts

- `project-management/src/02-STORIES/US001.md` · `US000-TEMPLATE.md`
- `project-management/src/03-SPRINTS/SPRINT-01.md` · `SPRINT-00-TEMPLATE.md`
- `project-management/src/11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`
- `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`
- `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md`
- `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — US003's source, slice `S-01`
- `project-management/docs/planning/CADENCE.md` — the loop, the flags-are-gates rule, the 11/13 SP ceiling
- `project-management/workflows/02-story-creation/` · `03-sprint-planning/` · `11-qa-checks/` · `15-decisions/`
- `GAPS.md` — the 02/09/2026 entry on the citation gate
- `code/docs/GATE-REPORTING.md` — the rule both ADRs rest on
