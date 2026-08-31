# .claude/MEMORY.md — Project Memory

Read this at the start of every session. Write here instead of the global auto-memory system.

Sections: **Feedback** (<%DEVELOPER_NAME%>'s guidance on approach) · **Project Patterns** (conventions discovered
during work) · **Project State** (business/stack facts not derivable from the codebase)

To add an entry: append a subsection under the correct heading, titled
`### <what was learned> — DD/MM/YYYY`. Keep entries concise — one paragraph max. Update or
remove stale entries rather than appending contradictions.

**Do not write here:** active gaps, blockers, sprint dependencies → those go in `GAPS.md`.

> **This file is syntek-base's own, and copier excludes it.** A generated project is seeded a
> blank canvas from `.copier/MEMORY.md` instead, because Section 2.1 has every session read this file
> second and believe it — so the template's memory arriving as a project's own is read as
> authoritative. Write repo-specific state here freely; it never ships. Doctrine that every
> project needs is not memory and belongs in the `docs/` guide that owns it.
> Gate: `.github/scripts/shipped-memory.sh`. <!-- doc-references: template-only -->

---

## Feedback

_No entries yet._

---

## Project Patterns

- **syntek-base authors ADRs of its own** (31/08/2026, `MAP-PROGRESSIVE-ENHANCEMENT` N-026). <!-- doc-references: template-only -->
  This reverses the 16/08/2026 decline, whose stated reason — that `15-DECISIONS/` ships into
  every generated project — was measured false. `copier.yml` excludes <!-- doc-references: template-only -->
  `/project-management/src/**` and re-includes only `**/CONTEXT.md`, `**/CLAUDE.md` and
  `**/*TEMPLATE*`; a probe ADR was proved not to travel. **The exclusion is the permission**: an
  ADR written here is tracked, syncs across devices, and cannot leak downstream.
  Recorded here rather than in `src/15-DECISIONS/CLAUDE.md`, because that file **ships** and a
  generated project must not inherit the template's own policy debate.
- **Ten feature maps still carry the superseded no-ADR wording** in their `Umbrella ADRs` rows.
  The sweep was deliberately deferred from the 31/08 sitting: it edits the same gate checklists as
  the index-row sweep that `MAP-REGISTER-INDEXES` N-001 generates, and the two sessions ran <!-- doc-references: template-only -->
  concurrently. `MAP-CLAUDE-DESIGN-HANDOFF:35` is the only one still asserting impossibility. <!-- doc-references: template-only -->
- **A map's load-bearing external claims are re-measured at the start of each RESOLVE sitting**,
  not only at charting. Its first application (31/08/2026) caught a `copier.yml` line citation <!-- doc-references: template-only -->
  that had drifted from `:131` to `:152` and pointed at a comment while still reading plausibly.
  **Its second application, the same day, caught six** on one map — including a cost figure that
  overstated by 2x _against the conclusion it was cited to support_, five drifted line numbers, a
  `Blocked by` naming a node resolved sixteen days earlier, and a Notes row asserting an empty
  `GAPS.md` that was 346 lines long. **The yield is high enough that the pass is not optional**:
  every one of the six still read plausibly, which is exactly why none had been noticed.
- **A wayfinder node type was wrong for as long as it existed, and the tell was usage, not
  reasoning** (31/08/2026). `task` was defined as _"manual unblocking work: provision infra, run a
  migration script, seed data"_ and used that way in **none of its 42 instances across 8 maps** —
  every one was deliverable work. It is now `build`: _the work a slice's story carries, named on
  the map, never done on it_. The lesson generalises: **when auditing a definition, count its
  instances before re-reading its wording.** Manual unblocking work is now a `GAPS.md` blocker,
  which already owned blockers.
- **A `DEFERRED.md` row needs a `US###` that a map cannot supply.** That file targets a named
  future story and is written from an implementation doc, so a deferral surfaced during a
  wayfinder RESOLVE sitting — before any story is cut — belongs in `GAPS.md` instead. Learned by
  trying it (31/08/2026, N-021's prefix half).

---

## Project State

- **This working tree is shared by concurrent Claude sessions, and they write to it mid-task**
  (observed 31/08/2026: `MAP-NAVIGATION.md` gained 712 lines while another session held the file,
  its mtime moving two hours after this session last touched it). **Never `git add -A`** — stage
  by explicit path. Before reporting a gate failure in a file you edited, check `ls -la` mtimes
  against your own last write: a lint error in a shared file is as likely to be another session's
  in-flight work as your own.
