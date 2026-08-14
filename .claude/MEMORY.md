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
> Gate: `.github/scripts/shipped-memory.sh`.

---

## Feedback

_No entries yet._

---

## Project Patterns

### Template-development reasoning lives in `TEMPLATE-GUIDE/` — 09/08/2026

**The template's own open items go in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, never in the
root `GAPS.md`.** `GAPS.md` is a **shipped** file — `copier.yml` does not exclude it — so anything
written there is rendered into every generated project, where syntek-base's internal state is
meaningless and misleading; it is kept as an empty stub, and `TEMPLATE-GUIDE/` **is** excluded, so
it is durable in git yet never ships. The same test applies to any register or reasoning artefact:
**check `_exclude` before writing repo-specific state into a tracked file.** This file is the
other side of that test — excluded as of 13/08/2026, and therefore a safe home for exactly the
state `GAPS.md` cannot hold.

### A `description` is charged every turn; a body only when it fires — 13/08/2026

**Route-don't-restate applies hardest to the standing surface, and the agents→skills epic proved
it by getting this backwards.** Measured at closeout: 85 standing entries fell to 65, yet standing
context **rose 6,900 → 8,304 tokens (+20.4%)**. All 31 entries converted one-to-one grew (mean
+307 chars, none shrank), because one decision mandated merging descriptions to save tokens and a
later one, settled in a different round, mandated **sharpening** them to fix a selection
collision — and nothing measured the two against each other. The editorial discipline went to
5,850 body lines that cost nothing standing while the surface charged on every request grew.
**Before sharpening a `description`, price it: chars ÷ 4, times every turn of the project's
life.** And when two decisions touch the same measured quantity in different sessions, one of
them must re-run the measurement — the second decision silently repriced the first.

### No tag before `v3.0.0` can be generated from — prove an update path, never assume it — 14/08/2026

**`N-013` required a real `copier update` proof and the charted path did not exist.** Generate
at an old tag → update across the boundary assumes the old tag generates. `v2.21.0` carries all
56 agent files but predates the generation fix `e16b499`; tested rather than assumed, it dies
with `TemplateSyntaxError: tag name expected` at `sync-trees.sh:190`. `e16b499` lands **after**
the deletion, so it has the fix and zero agents — and a sweep of every commit in `e16b499..main`
found **not one carrying both**. `v3.0.0` is the first generatable tag in this repository's
history.

**The fix was to reconstruct the base, not to weaken the proof.** A throwaway branch off
`f2b04cf` with the deleted agents directory restored from `v2.21.0` — the real pre-deletion
state on top of the generation fix — generated cleanly, and the update across `v3.0.0` deleted
all 55 template-owned files while leaving a self-authored agent byte-identical. **When a proof's
starting point is unreachable, build the state deliberately and say so, rather than downgrading
to a weaker claim and calling it evidence.**

### A copier migration must not do work whose output has to pass a gate — 14/08/2026

`N-013`'s migration was ruled **advisory: report, never move**. Agent → skill is a rewrite, not
a rename — a skill needs `name`/`description` frontmatter and must satisfy
`skill-conformance.sh`. A migration that relocated the file would hand back a skill that fails
its own gate and report success, which is worse than leaving the file alone. **Migrations always
exit 0 where the work is advisory**, because a non-zero exit fails the whole `copier update`.

---

## Project State

_No entries yet._
