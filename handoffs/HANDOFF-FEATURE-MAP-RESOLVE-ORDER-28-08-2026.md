# HANDOFF — Feature-map resolve order

**Written**: 28/08/2026 · **Session**: read-only analysis · **Branch**: `main` at `7a82095`

## Goal

Establish the order in which the ten maps in `project-management/src/01-FEATURE-MAPS/` should be
taken through `/wayfinder resolve`. The session loaded eight live maps, confirmed every one is
charted, and produced a recommended sequence keyed on cross-map fan-out and evidence decay.

## Done

**Nothing was written to the repository this session** — the work was reading and analysis only.
No map, `CONTEXT.md`, `GAPS.md` or `DEFERRED.md` was edited.

- Loaded and confirmed charted: `MAP-RETRY-AND-IDEMPOTENCY.md`, `MAP-ABSENCE.md`,
  `MAP-CLAUDE-DESIGN-HANDOFF.md`, `MAP-PROGRESSIVE-ENHANCEMENT.md`, `MAP-NAVIGATION.md`,
  `MAP-REGISTER-INDEXES.md`, `MAP-SUBDOMAIN-ROUTING.md`, `MAP-UPSTREAM-TRACKING.md` — all under
  `project-management/src/01-FEATURE-MAPS/`.
- Confirmed the two remaining maps are **closed** and need no resolve sitting:
  `MAP-RULE-OWNERSHIP.md` (24/24 resolved, _"Blockers clear — stories may start"_) and
  `MAP-GATE-PARITY.md` (31 resolved, frontier closed, fog of war open).
- Derived the cross-map dependency edges by grep across all ten maps.
- Produced the recommended resolve order (below) — **in conversation only, not recorded in any
  artefact.**

## In-flight

The resolve order itself is the only live thread. It exists nowhere on disk.

**Recommended order — fan-out, then freshness, then staleness:**

1. `MAP-PROGRESSIVE-ENHANCEMENT.md` **N-026** alone — the no-ADR decline; corrects five files
   across four maps.
2. `MAP-REGISTER-INDEXES.md` **Batch A** (N-001 + N-005) — the index-row home; retires a decline
   all ten maps carry, and `MAP-RULE-OWNERSHIP.md` slice S-06 waits to carry the row.
3. `MAP-NAVIGATION.md` **N-003** — one research node that may close a 10-node map as a written
   refusal.
4. `MAP-RETRY-AND-IDEMPOTENCY.md` **N-006 + N-007**.
5. `MAP-UPSTREAM-TRACKING.md` **N-005 + N-009**.
6. `MAP-SUBDOMAIN-ROUTING.md` — N-004/005/007 → N-014 + N-016 → N-019.
7. `MAP-REGISTER-INDEXES.md` **B** then **C**.
8. `MAP-ABSENCE.md` **N-008 + N-009** — re-measure first.
9. `MAP-PROGRESSIVE-ENHANCEMENT.md` — re-run workflow `01-feature-map` **Step 2** (its register
   triage is marked STALE), then **N-024**.
10. `MAP-CLAUDE-DESIGN-HANDOFF.md` — last; its **N-018** is cheap and can be pulled forward.

**The principle:** evidence decay sets the cost, not node count. Three maps record the same lesson
independently, and both freshly-charted maps had to void and re-derive their seeded evidence rather
than patch it. So the four fresh maps get dearer every week, while the three stale ones already owe
a re-measurement tax whenever taken — their position costs nothing at the margin.

**Findings surfaced in passing, none actioned:**

- `MAP-UPSTREAM-TRACKING.md` — the session log says _5 blocking_; the header, frontier table and
  gate all say **4** (N-005, N-009, N-010, N-012). The 4 is correct.
- `MAP-ABSENCE.md` and `MAP-NAVIGATION.md` still carry the strong _"no ADR is possible"_ wording.
  `MAP-SUBDOMAIN-ROUTING.md` and `MAP-UPSTREAM-TRACKING.md` have already corrected it to _"a dated
  house rule, not a mechanical impossibility"_ and defer to `MAP-PROGRESSIVE-ENHANCEMENT.md`
  N-026. Whether N-026's reach is one map or five is that node's to settle.
- `MAP-UPSTREAM-TRACKING.md` was rewritten mid-session — 11.6 KB (seeded stub) at 16:12,
  35.8 KB (charted) at 19:34.

## Next

Open `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` and run a
`/wayfinder resolve` sitting on **N-026 alone** — decide whether the no-ADR decline survives on
the house-pattern grounds now its mechanical premise is falsified, and whether that reaches the
four other maps citing the same reason.

## Next skills

`wayfinder` → `grill-with-docs` for the sitting itself; `doc-writer` for the map edits that follow.
Per `01-FEATURE-MAPS/CLAUDE.md`, charting and settling run on **Fable**; Opus only for moving a
resolved row or fixing a link.

## Artefacts

- `project-management/src/01-FEATURE-MAPS/` — all ten maps and the folder's `CONTEXT.md` /
  `CLAUDE.md` pair.
- `project-management/workflows/01-feature-map/` — the workflow; **Step 2** is the stale register
  triage that `MAP-PROGRESSIVE-ENHANCEMENT.md` must re-run.
- `.claude/skills/wayfinder/SKILL.md` — SUGGEST, CHART and RESOLVE, and the claiming-versus-closing
  line.
- `GAPS.md` · `DEFERRED.md` — read by every map, closed by none of them; closing belongs to
  `project-management/workflows/22-implementation-documentation/`.

## Open questions

- **Whether `/wayfinder resolve` should follow this order at all** — it is a recommendation from
  one reading, not a decision Sam has confirmed.
- **Whether "add both of these to the contexts" meant adding index rows to
  `01-FEATURE-MAPS/CONTEXT.md`.** It was read as _load the two maps into context_ and answered that
  way. Writing the rows is blocked on `MAP-REGISTER-INDEXES.md` N-001 and declined on the record by
  all ten maps; if the other reading was intended, it needs a deliberate exception.
