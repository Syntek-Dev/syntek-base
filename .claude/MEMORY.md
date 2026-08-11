# .claude/MEMORY.md — Project Memory

Read this at the start of every session. Write here instead of the global auto-memory system.

Sections: **Feedback** (<%DEVELOPER_NAME%>'s guidance on approach) · **Project Patterns** (conventions discovered
during work) · **Project State** (business/stack facts not derivable from the codebase)

To add an entry: append a subsection under the correct heading. Keep entries concise — one paragraph
max. Update or remove stale entries rather than appending contradictions.

**Do not write here:** active gaps, blockers, sprint dependencies → those go in `GAPS.md`.

---

## Feedback

### Questions are asked in prose, never via `AskUserQuestion` — 09/08/2026

`AskUserQuestion` is denied in `.claude/settings.json`. The grilling system is the project's
clarification mechanism: questions are asked in the chat as prose, in rounds, each carrying
brief numbered options and an explicit recommendation, with <%DEVELOPER_NAME%> free to answer
by number, counter, or redirect in his own words. **The format lives in
`.claude/skills/grilling/SKILL.md` and is not restated anywhere else** — see the round-shape
update of 09/08/2026 below. The deny entry removes the multiple-choice widget only — the "do not act until
<%DEVELOPER_NAME%> confirms" gate comes from the grilling rule (`.claude/CLAUDE.md` §10), not
from the tool being absent. Trivial or mechanical work still proceeds without asking.

### Grilling asks in frontier rounds, not one question per message — 09/08/2026

Superseded the original one-question-at-a-time rule. A **round** is every question whose
prerequisites are already settled, asked together and numbered; <%DEVELOPER_NAME%> answers the
set, and the answers unblock the next round. Trickling questions out one per message is now an
explicit anti-pattern — it made a ten-decision design take ten exchanges.

**The sweep mattered more than the rule.** 63 files restated the mechanic instead of routing to
the skill, so changing the skill alone would have left 63 contradictions. This is the same drift
`MAP-DOCTRINE-UPGRADE` N-009 found in `code-reviewer.md`. The standing fix: an agent, workflow or
skill opening a grilling pass names **what** must be settled and routes to
`.claude/skills/grilling/SKILL.md` for **how** — never the format, the round shape, or the
recommendation rule.

---

## Project Patterns

### Template-development reasoning lives in `TEMPLATE-GUIDE/` — 09/08/2026

**The template's own open items go in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, never in the
root `GAPS.md`.** `GAPS.md` is a **shipped** file — `copier.yml` does not exclude it — so anything
written there is rendered into every generated project, where syntek-base's internal state is
meaningless and misleading; it is kept as an empty stub, and `TEMPLATE-GUIDE/` **is** excluded, so
it is durable in git yet never ships. The same test applies to any register or reasoning artefact:
**check `_exclude` before writing repo-specific state into a tracked file** — which is why
template-era design rationale sits in `02-STACK.md` and `11-CUSTOMISING.md` rather than in
`project-management/src/14-DECISIONS/`. (`TEMPLATE-GAPS.md` has cited this entry since it was
written; the entry itself was missing until N-030.)

---

### A third-party source's claim is a lead, not a finding — 11/08/2026

Generalised from `MAP-DISCOVERABILITY` N-009 (GitHub's SPDX detector returned `NOASSERTION` for
two plainly MIT repositories) by N-003, which hit the same shape in content rather than metadata:
a cleared MIT skill repo asserted that three techniques in our own `SEO-CHECKLIST.md` were myths.
**It was right, and checking took one fetch of Google's own documentation.** The rule that
survives both: an outside source — a detector, a skill repo, a blog, another model — earns a
**look at the primary source**, never a direct edit. Where the primary source confirms it, the
substance is the primary source's and **no attribution is owed to the lead**; that is why N-003
adopted a correction and still gave N-010 no row.

Corollary worth its own sentence: **prompt-only knowledge goes stale unread.** Both defects N-002
and N-003 corrected had been sitting in `.claude/agents/seo.md`, unreachable except by routing to
that agent. A guide nobody can find is a guide nobody can correct.

---

### Refresh the code-review-graph _after_ staging, never before — 11/08/2026

`build_or_update_graph_tool` runs an incremental update that diffs against a git ref, so a file
that is new and **uncommitted is invisible to it** — the tool reports success having never parsed
it. Two files shipped by `MAP-NEGATIVE-SPACE` were absent from the graph while every audit was
green. `full_rebuild=True` works but re-parses everything and can exceed the tool timeout; `git
add` first is the cheap fix, because staging is what makes the file visible to the diff. The § 6
hard gate says "refresh alongside the docs" — that gate is only satisfied if the new files were
actually in the diff. Filed in `TEMPLATE-GAPS.md` (11/08/2026).

---

## Project State

_No entries yet._
