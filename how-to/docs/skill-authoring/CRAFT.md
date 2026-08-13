---
type: guide
skills: [doc-writer, global-workflow, runbook]
model: opus
---

# The Craft — invocation, hierarchy, steering, pruning

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the four axes that decide whether a conforming skill is any good

---

Four axes, in the order they bite: **invocation** (how it is reached), **information hierarchy**
(how its content is arranged), **steering** (how runtime behaviour is shaped), and **pruning**
(how it is kept lean). `.claude/skills/grilling/` is the worked example throughout.

## 1. Invocation — how the skill is reached

Two ways in that the description controls, trading two different costs — and a third, at the end
of this section, that it cannot reach. The runtime's opt-out key is declined here
(`FRONTMATTER.md`), so for the first two the **description wording is the whole lever**.

- **Model-auto-loaded.** A description opening with a leading word and a rich "**Load when…**"
  trigger list lets the agent fire the skill on its own, and lets other skills reach it. The
  price is **context load**: the description sits in the window every turn, spending tokens and
  attention. Use this when the agent must reach the skill unaided. The stack skills and
  `grilling` are model-auto-loaded — `grilling`'s description names every design surface and the
  `/grill-*` triggers, so it fires reliably.
- **User-typed `/name`.** A description phrased around explicit invocation ("Invoke by typing
  `/grill-me`…") keeps the skill primarily human-reached: the human is the index that must
  remember it exists. That is **cognitive load** — not a cost to minimise but the price of human
  agency; spend it where human judgement should gate the skill. `grill-me` and `grill-with-docs`
  are the worked example: two thin entry points, each typed by hand.

**Context load vs cognitive load** is the trade. Pick model-auto-loading only when the agent (or
another skill) must reach the skill itself; otherwise phrase for `/name` invocation and pay no
standing context cost.

**Writing the description.** It does two jobs — state what the skill is, and list the branches
that trigger it — and every word is standing context load, so it earns harder pruning than the
body. Front-load the skill's leading word; write **one trigger per branch** (synonyms that rename
one branch are duplication — collapse them); cut identity already stated in the body. The spec's
1024-character ceiling is a validation limit, not a target `[gate: fail]`.

**A description is a claim that it discriminates — and the claim is checkable.** Wording that
reads well alone is not the test; the test is whether the runtime can tell this entry from the
ones beside it. Selection measured on 11/08/2026 — 42 blind-authored requests put to a simulated
roster of roughly 65 entries, each request labelled with its true owner before the run — came out
at **83.3% strict against 97.6% loose**: the right entry is nearly always _present and second_.
The information was there and the wording was blunt, so the gap is a **description defect, not a
structural one**, and no amount of merging or splitting fixes it. Re-run the same shape against
the roster you have; the numbers above are this project's at that date, not a constant.

So a new or edited description **names the near-neighbours it must be distinguishable from, and
says how a reader tells them apart**, in the change that lands it. Live clusters to sharpen
against: backend/database · review/code-reviewer/qa-tester · planner/domain-modelling/doc-writer ·
syntax/review/pr · grill-me/grill-with-docs — the last is a **wording** defect that exists
**today**, with `grill-me` losing to `grill-with-docs` at every roster size measured. Their
_shape_ is not the defect (`FORK-DECISION.md` § _Before the split_ settles that); their two
descriptions simply do not say which one a reader wants. Sharpen against the neighbour, never
against the blank page.

**When to add a router.** When user-typed skills multiply past what one person can hold in their
head, add a router: one user-typed skill that names the others and when to reach for each. The
`grilling` trio is the neighbouring pattern — a shared model-loaded **engine** (`grilling`) with
two user-typed entry points (`grill-me`, `grill-with-docs`) that load it. That keeps the process
in one place while giving each entry point its own `/name`; the condition that makes it one remit
rather than three is in `FORK-DECISION.md`.

**The third route in — being named.** A reference skill and the task work it governs answer to
the same request, and the task entry wins it. In the same 11/08/2026 sweeps, every reference
skill that was shadowed placed **second** — all four of them: `codebase-design` behind refactor
work, `global-workflow` behind PR and release work, `stack-django` and `stack-htmx-templates`
behind the surfaces they govern. Second is never loaded. That is the reference/task split working
exactly as designed — the two own different remits, and only one of them is being asked for — and
it carries a consequence no wording fix reaches: **a reference skill is not reached by
description match at all.** It arrives only because something named it in a `skills:`
list — the routing frontmatter on the governing `docs/` or `workflows/` file
(`.claude/CLAUDE.md` § 2.5), or the task entry that loads it.

**So `skills:` is wiring, not documentation — and an omission fails silently.** Leave the
reference skill out of the list on the task side and the run still completes: no gate fires, no
error surfaces, and nothing in the transcript says the conventions were missing. The work is
simply done to the model's defaults instead of this project's, and the first evidence is a review
finding weeks later. A blunt description degrades a pick and can be measured; this leaves no
trace at all. A task skill therefore names every reference skill it depends on, the moment it
depends on one.

## 2. Information hierarchy — how content is arranged

A skill is built from two content types that mix freely: **steps** (ordered actions the agent
performs, in order) and **reference** (definitions, rules, and facts consulted on demand). A
skill can be all steps, all reference, or both. `grilling` is both: five numbered steps under
"How to grill", then flat reference under "What to grill".

Rank every piece on the ladder by how immediately the agent needs it:

1. **In-skill step** — an ordered action in `SKILL.md`, the primary tier.
2. **In-skill reference** — a rule or fact in `SKILL.md`, consulted on demand. Often a
   legitimately flat peer-set (every rule of a review on one rung) — a fine arrangement, not a
   smell.
3. **Sub-document reference** — reference pushed out of `SKILL.md` into a
   `SCREAMING-SNAKE-CASE.md` file beside it, reached by a **context pointer** and loaded only when
   the pointer fires.

**Progressive disclosure** is the move down that ladder, and here the **300-line cap forces
it**: when a `SKILL.md` would breach 300 code lines, disclose its reference into sub-documents and
leave the `SKILL.md` a thin index that points at them. `global-workflow` (index +
`GIT-AND-PR.md` + `VERSIONING-AND-DOCS.md`) and `msp-scp-documents` (index + six sub-documents)
are the worked examples. `grilling` sits comfortably under the cap, so it discloses nothing — a
single `SKILL.md` is correct when it fits.

**Sub-documents sit flat beside `SKILL.md`, not in `references/`.** The specification suggests
three optional directories — `scripts/`, `references/`, `assets/` — and otherwise leaves a skill
folder's shape to its author; the three names are filing conventions for common kinds of content,
never conformance clauses. Every skill here discloses **prose only**, and a `references/` folder holding one
kind of thing is a directory that earns nothing while lengthening every pointer. **The trigger for
adopting the spec directories is content, not count:** the first skill that ships an executable
puts it in `scripts/`, the first that ships a template or fixture puts it in `assets/`, and at
that point its prose moves to `references/` in the same change, so one skill never mixes both
conventions.

**In-file vs sub-doc** is decided by **branch**: inline what every run needs; push behind a
pointer only what some runs reach. The pointer's _wording_, not its target, decides when and how
reliably the agent follows it — a must-have behind a weak pointer is a variance bug, so sharpen
the wording before you consider pulling material back inline. Every reference resolves in **a
single hop** from `SKILL.md`; the spec warns against chaining one pointer into another, and an
agent that must follow two of them to reach a rule usually follows neither.

## 3. Steering — shaping runtime behaviour

**Leading words.** A leading word is a compact concept already living in the model's pretraining
(_lesson_, _fog of war_, _tracer bullets_) that the agent thinks with while running the skill.
Repeated as a token — not restated as a sentence — it accumulates a distributed definition and
anchors a whole region of behaviour in the fewest tokens. It serves predictability twice: in the
body it anchors execution (the agent reaches for the same behaviour each time the word appears);
in the description it anchors invocation (when the same word lives in your prompts, docs, and
code, the agent links that shared language to the skill and fires it more reliably). `grilling`
leans on _predictability_ and _frontier round_ as its leading words. Prefer an existing
pretrained word; a coined one recruits no priors and you pay in definition tokens what a
pretrained word gives free.

**Completion criteria.** Every step ends on the condition that tells the agent the work is done.
Make it **checkable** (can the agent tell done from not-done?) and, where it matters,
**exhaustive** ("every modified model accounted for", not "produce a change list") — a vague
criterion invites premature completion and thin legwork. `grilling` ends on a sharp,
non-negotiable bar: the design is summarised and <%DEVELOPER_NAME%> gives an explicit "yes" before any
downstream work begins.

**Look up facts; ask about decisions.** Steer the agent to _discover_ anything derivable from the
codebase or environment rather than offload the question to the human. In <%PROJECT_NAME%> the lookup order
is `code-review-graph` (structural context) → Read/Grep/Glob → `.claude/plugins/*.py`
(`project`/`db`/`env`), and every dev operation runs through `code/src/scripts/**/*.sh`. Reserve
questions for genuine decisions with a real trade-off. `grilling` rule 3 is the canonical
statement: "Do not ask 'does a `Customer` model exist?' — check. Do ask 'should a booking belong
to a `Customer` or a `User`?'".

**Post-completion steps.** The steps visible ahead of the current one pull the agent forward into
**premature completion** — ending a step before it is genuinely done. Defend in order: sharpen the
completion criterion first (cheap and local); only if it is irreducibly fuzzy _and_ you observe
the rush do you hide the later steps by splitting the sequence across a real context boundary (a
user-typed hand-off or a forked dispatch — an inline call leaves the later steps in view and
clears nothing).

**Steer positive, not by prohibition.** Naming the banned behaviour drags it into context and
makes it _more_ available — _don't think of an elephant_. State the target behaviour so the
banned one is never spoken ("write one-line comments", not "never write verbose comments"). Keep
a prohibition only as a hard guardrail you cannot phrase positively, and even then pair it with
the positive target.

## 4. Pruning — keeping the skill lean

The 300-line cap is a standing forcing function against every failure below (`SHIPPING.md`).

- **Single source of truth.** Keep each meaning in exactly one authoritative place, so changing
  the behaviour is a one-place edit. The `grilling` engine is the pattern — `grill-me` and
  `grill-with-docs` both load it rather than restate the process.
- **Duplication** — the same meaning in more than one place. It costs maintenance and tokens and
  inflates a meaning's prominence on the ladder past its real rank. Collapse it (and, in a
  description, collapse synonym-triggers to one per branch).
- **Sediment** — stale layers that settle because adding feels safe and removing feels risky. The
  default fate of any skill without a pruning discipline; check every line for **relevance** —
  does it still bear on what the skill does?
- **Sprawl** — a skill simply too long, even when every line is live and unique. The cure is the
  ladder: disclose reference into sub-documents and split by branch or sequence so each path
  carries only what it needs.
- **Measure the migration target before authoring it.** "Move these conventions to a new guide"
  is a claim about **two** things, and only the first is usually checked: that the conventions
  exist, and that no file already owns them. Grep for the **content**, not the filename — a
  destination that turns out to be occupied makes a third home for one rule, which is the defect
  the move was meant to fix. The same check justifies the move when the grep comes back empty.
- **The no-op test.** Hunt no-ops sentence by sentence: does this line change behaviour versus the
  model's default? A line the agent already obeys pays load to say nothing. A weak leading word
  (_be thorough_ when the agent is already thorough-ish) is a no-op — the fix is a stronger word
  (_relentless_), not a new technique. When a sentence fails, delete the whole sentence rather
  than trim words from it. Be aggressive; most prose that fails should go.

_Part of the `how-to/docs/` documentation family._
