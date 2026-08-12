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
found earlier in `code-reviewer.md`. The standing fix: an agent, workflow or
skill opening a grilling pass names **what** must be settled and routes to
`.claude/skills/grilling/SKILL.md` for **how** — never the format, the round shape, or the
recommendation rule.

### This project does not use ADRs — 11/08/2026

**Project- and template-wide, not one epic's exception.** Decisions are recorded where the work
already lives — the feature map in `project-management/src/01-FEATURE/`, the story plan, the
`CONTEXT.md` glossary, or a `research/` note — never as an `ADR-###`. The trigger was an epic that
charted the tooling surface itself: `14-DECISIONS/` is **not** copier-excluded, so an ADR about the
template's own tooling would ship into every generated project as a decision that project never
made. Sam then
widened it to every project, so the ADR machinery is retired rather than merely unused here.

**The contradiction is live until the removal ships.** `14-DECISIONS/`, `ADR-000-TEMPLATE.md`, PM
workflow `14-decisions/`, and the ADR rows in the `wayfinder` and `grill-with-docs` graduation
tables all still instruct otherwise. This file is read second in the §2.1 order, so it wins —
**do not offer or author an ADR**, whatever those files say. Tracked in
`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` (11/08/2026).

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
`project-management/src/14-DECISIONS/`. (`TEMPLATE-GAPS.md` cited this entry long before the entry
itself was written.)

---

### syntek-base ignores its own handoffs and feature maps; a generated project does not — 11/08/2026

**Two nested `.gitignore` files carry this, and both are `_exclude`d in `copier.yml`.**
`handoffs/.gitignore` ignores `HANDOFF-*.md` and `project-management/src/01-FEATURE/.gitignore`
ignores `MAP-*.md` bar the template — because in **this** repository both are throwaway working
state about the template itself, and neither belongs in its history. In a **generated** project
both are real: handoffs are that project's session continuity and maps are the artefacts of
`01-feature`, so the shipped doctrine in `handoffs/CONTEXT.md` ("committed, synced") stays true
there and must not be rewritten to match this repo's behaviour.

**The mechanism is the point.** Git honours a `.gitignore` in any directory, so a repo-local rule
can live in a file that copier drops at generation — which leaves the root `.gitignore` shipped
and therefore still updatable by `copier update`. Excluding the root `.gitignore` and seeding it
from `.copier/` would have made it seed-once, and no future ignore rule could ever reach an
existing project.

---

### A third-party source's claim is a lead, not a finding — 11/08/2026

Generalised from a licence sweep (GitHub's SPDX detector returned `NOASSERTION` for two plainly
MIT repositories) and a second case that hit the same shape in content rather than metadata:
a cleared MIT skill repo asserted that three techniques in our own `SEO-CHECKLIST.md` were myths.
**It was right, and checking took one fetch of Google's own documentation.** The rule that
survives both: an outside source — a detector, a skill repo, a blog, another model — earns a
**look at the primary source**, never a direct edit. Where the primary source confirms it, the
substance is the primary source's and **no attribution is owed to the lead**; that is why N-003
adopted a correction and still gave N-010 no row.

**Third instance, N-005 (11/08/2026), and the first where the outside sources were _unanimous_
and wrong.** Every ASO source — all four cleared MIT repos, plus the search engine's own summary
of Apple's page — states Apple's keyword limit as "100 characters". Apple's App Store Connect
Help says **"up to 100 bytes"**. The two coincide in ASCII, which is exactly why the error
propagates unchallenged, and diverge by 2–3× the moment a listing is localised. **Consensus among
secondary sources is not corroboration** — they copy each other, so agreement is one source
counted many times. The fix is cheap and the same every time: fetch the vendor's page.

Corollary worth its own sentence: **prompt-only knowledge goes stale unread.** Both defects N-002
and N-003 corrected had been sitting in `.claude/agents/seo.md`, unreachable except by routing to
that agent. A guide nobody can find is a guide nobody can correct.

---

### Measure the migration target before authoring it — 12/08/2026

A plan that says "move these conventions to a new guide" is a claim about **two** things, and
only the first is usually checked: that the conventions exist, and that no file already owns
them. N-014's fold of thirteen document-writer agents specified two new `docs/` folders; the
content they would have held was **already in the two skills the agents were folding into**, one
of which was already an index over six sub-documents. Authoring them would have created a third
home for one rule — the exact defect the epic exists to remove.

**The generalisation:** before writing a migration home, grep for the content, not the filename.
The same pass answered the opposite question correctly elsewhere in the same epic —
`weasyprint` and `openpyxl` returned exactly one file, so `code/docs/EXPORTS.md` was genuinely
needed. Two claims, one method, opposite answers: the method is what mattered, and neither answer
was guessable from the plan.

---

### A key name is not a surface — scope a frontmatter sweep by path, not by key — 12/08/2026

`git grep -l "^agent:" -- '*.md'` returns **256** files, and only **234** of them are routing
frontmatter. The other 22 are the converted skills' own `agent: general-purpose` — the same key
name, on a different surface, meaning something else entirely: a **fork target**, not a routing
hint. A sweep that folds `agent:` into `skills:` on a match would rewrite every forked skill's
fork target into a dependency list and pass every audit, because both keys are legal in both
places.

**The generalisation:** before sweeping a frontmatter key, partition the matches **by path** and
name each partition's meaning. A key's semantics belong to the file class that carries it, and
two file classes can legitimately spell the same key. `.claude/skills/**/SKILL.md` is excluded
from the `agent:` sweep by rule, not by luck — it is a second population, not a stray.

---

### Unreachable prose is unreviewed prose — the evidence is inside the epic — 12/08/2026

**Two agent bodies carried a `## Governing procedures` block reading "this agent produces a
standalone compliance or legal document", pasted from a policy writer** — `data-scientist.md`
and `support-articles.md`, neither of which drafts a document, and both wrong in every clause.
Alongside them: `git.md` hardcoded a model version into the `Co-Authored-By` trailer that §4
forbids, and pointed bug records at `src/BUGS/` when the folder is `src/20-BUGS/`.

**None of it was ever wrong loudly.** The text was reachable only by routing to that agent, so
no reviewer, gate or reader passed through it. This is the same shape as `.claude/agents/seo.md`
carrying two SEO defects for months (see _A third-party source's claim is a lead_ above). The
epic converting these bodies into description-matched skills is the fix; the finding is the
justification, and it is worth stating when someone asks what the conversion actually bought.

---

### Refresh the code-review-graph _after_ staging, never before — 11/08/2026

`build_or_update_graph_tool` runs an incremental update that diffs against a git ref, so a file
that is new and **uncommitted is invisible to it** — the tool reports success having never parsed
it. Two newly written files were absent from the graph while every audit was
green. `full_rebuild=True` works but re-parses everything and can exceed the tool timeout; `git
add` first is the cheap fix, because staging is what makes the file visible to the diff. The § 6
hard gate says "refresh alongside the docs" — that gate is only satisfied if the new files were
actually in the diff. Filed in `TEMPLATE-GAPS.md` (11/08/2026).

---

## Project State

### `main`'s branch protection is bypassable by the owner, by design — 12/08/2026

The `syntek-studio` account can push straight to `main` even though protection is configured and
prints _"Changes must be made through a pull request"_ and _"12 of 12 required status checks are
expected"_. **This is not a misconfiguration** — Sam confirmed the protection exists to gate pull
requests from other contributors, and the bypass is deliberate so routine template work is not
blocked on a self-approved PR.

**The consequence for planning: "we could not push directly" is never a reason to open a PR
here.** Reach for a PR when the change genuinely wants the 12 CI checks and a readable diff before
anything irreversible follows — a large mechanical sweep, or a commit that a later commit deletes
against. Reach for a direct push for ordinary work. Do not record the successful push as evidence
of a broken gate; that reading cost one session's open question already.
