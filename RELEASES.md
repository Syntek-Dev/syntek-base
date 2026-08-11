# Releases — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 2.7.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v2.7.0 — 11/08/2026

**Status:** Minor — the first release to add running Django code rather than documentation and
gates. A new `apps/core` ships in every generated project.

### Programming the negative space

Most of what a codebase gets wrong is not a missing feature. It is a state that should have been
impossible and was merely unlikely. This release makes constraining that space a named discipline
with an owning guide, a per-project register, the code the doctrine needs, and gates for the half a
machine can decide.

### One invariant, exactly one enforcement point

`code/docs/NEGATIVE-SPACE.md` carries the rule; `how-to/src/INVARIANTS.md` carries **your**
answers. Every invariant this project holds is listed with the single named place that enforces it,
with database-enforced and service-enforced kept apart.

The single-place rule is the whole point. An invariant enforced in two places is enforced in
neither, because the two copies disagree the first time one of them changes and nothing tells you
which is now the truth.

### The error taxonomy, and the one decision it turns on

Three classes, and the split that matters: **a breached invariant is a programmer error.** It
surfaces as a 500 and an event in the tracker. It is never a friendly 4xx.

That is enforced structurally rather than by convention: `InvariantViolation` lives **outside** the
`ServiceError` tree, so no handler that catches service failures can accidentally swallow one and
render it as a validation message.

### `raise`, never `assert` — now enforced

Ruff's `S101` was globally ignored. It no longer is: it is exempted for `*/tests/*` and
`conftest.py` and nowhere else, and a `# noqa: S101` is a finding.

Three reasons, none of them stylistic. An `assert` cannot carry the register key that says which
invariant broke. In the error tracker it is indistinguishable from a failing test. And `python -O`
removes it entirely — so the guard you were relying on is the one thing production does not run.

### Unknown fields no longer pass silently

Django Ninja's default is to **ignore** request-body fields it does not recognise. `extra="forbid"`
fixes that, and because Pydantic inherits it through subclassing, it propagates from a single base
class. The only way around it is to import `Schema` from `ninja` directly — which ruff `TID251` now
bans, with `apps/core/schemas.py` as the one module allowed to.

### An honest gap, recorded rather than papered over

`string_if_invalid` catches missing template variables — but it ships in **dev and test only**,
because Django's own behaviour makes it structurally incapable of policing production: a non-empty
value stops filters applying to invalid variables, and `{% if %}`, `{% for %}` and `{% regroup %}`
read an invalid variable as `None` and never consult it.

So the production template surface has no loud failure by construction. That is written down as a
gap. The alternative was a setting that looked like protection and was not.

### Also in this release

`RequestIDMiddleware` reads the edge's `X-Request-ID` and mints one only when it is absent or
malformed, treating anything inbound as untrusted — bounded alphabet, 200-character cap. It lives
in a `ContextVar` rather than on the request, so code below the view can reach it without being
handed a request object.

HTMX error handling is now split by taxonomy class. HTMX swaps on 2xx only, so a 500 previously
replaced nothing at all — the user saw the page simply not respond. User errors keep the 200
re-render; 500 and 503 go to one global `htmx:beforeSwap` listener rather than a handler per
element.

On the Rust side, `todo`, `unimplemented` and `unreachable` are denied by name in both crates.
`panic = "deny"` covers the `panic!` macro only, and all three of these live in clippy's
`restriction` group, which `all` deliberately excludes. `unreachable!()` is included on purpose: a
window that vanishes is no better for being unreachable in theory.

## v2.6.0 — 11/08/2026

**Status:** Minor — adds the two documents that decide how a generated project looks and sounds,
and five gates that hold the decidable half of them.

### The gap this closes

The template could scaffold a project, gate its security, size its database and route its agents.
It had nothing at all to say about whether the result looked and read like something a person made.

That absence has a predictable output. Machine-authored interfaces converge: the same three-card
row, the same violet-to-indigo gradient, the same emoji in the chrome, the same 300ms ease on
everything that moves. Machine-authored copy converges too, on its own set of tells. Neither is a
bug anyone reports, and both are the first thing a reader notices.

### Two prerequisite documents, settled before the first feature

**`how-to/src/BRAND-VOICE.md`** — tone, the four registers, casing, punctuation, and the tells that
are banned outright. Six agents and the templates skill load it for every user-facing string.

**`code/docs/VISUAL-DESIGN.md`** — the same doctrine in composition rather than copy, with
per-surface sub-documents for web, mobile and desktop.

Both ship as templates: a portable core you adopt unchanged, and per-project sections you fill in.
Both now sit in the first-time-setup run, which has four prerequisite steps rather than two —
**brief → voice → visual direction → sizing** — in that order, because each depends on the one
before and the later documents are themselves written in the voice the earlier one settles.

### A named direction, because "not AI-looking" is not a specification

`VISUAL-DESIGN.md` § 3 makes you pin a **direction** on six axes. This is the load-bearing part:
without a direction, § 4.2's ban list cannot be decided at all, because a deviation is only a
deviation from something. § 4.1 is the separate, unconditional list — the universal tells, banned
on every direction and every surface.

§ 5 is a numeric motion standard rather than a taste statement: frequency first (the rule that
actually changes decisions), duration ceilings, easing as a hierarchy, and reduced-motion meaning
fewer and gentler rather than none.

### Five gates, and an honest boundary

`copy-slop.sh` reads prose. `css-slop.sh` reads stylesheets. `template-slop.sh` reads Django
markup. `render-slop.sh` needs a viewport, because the repeated-device clauses cannot be decided by
any static scan. `style-check.sh` holds the Slint surface, which picks a style whether or not you
name one — so `build.rs` now names it.

Each runs two tiers in one pass, following `cloc.sh`'s warn-at-750 / fail-at-800 precedent:
`[gate: fail]` for an unambiguous match, `[gate: warn]` for a threshold, a ratio, or a word that is
sometimes just correct English. § 6 of the guide is the explicit list of what a script can decide
and what it cannot, so the gates are never mistaken for the standard.

### Credit, written alongside rather than afterwards

Almost none of this doctrine is original, and `README.md` now carries an **Influences and
attribution** section naming every source with its licence. `THIRD-PARTY-NOTICES.md` is the
narrower, harder obligation: the files that contain substantial portions of someone else's licensed
work. It ships into every generated project, because the adapted files do.

Two new non-negotiables keep both current. Doctrine derived from an outside source is credited in
the **same change** as the rule it credits. And: use, adapt and redistribute are three different
permissions — a share-alike source can be read as a checklist of concerns, but never derived into
anything this template redistributes, because every generated project would inherit the obligation.
The licence column gets consulted before deriving, not after.

## v2.5.0 — 11/08/2026

**Status:** Minor — changes how the agents interview you. Nothing about the stack, the scaffold or
the generated project moves.

### Ten decisions used to cost ten exchanges

Grilling is this template's clarification mechanism: before an agent writes a plan, a schema, an
API contract or a story, it interrogates you until the design is sharp enough to implement without
further questions. That much is unchanged and is still the opening move for all substantial work.

What changed is the pacing. The rule was **one question at a time**, and it was expensive in a way
that is obvious in hindsight — a ten-decision design took ten round trips, each one paying the full
cost of re-orientation for a single answer.

### Frontier rounds

The **frontier** is every question whose prerequisites are already settled — the ones that can be
answered right now without guessing.

The agent asks the whole frontier in one numbered message, then stops and waits. Your answers
settle those decisions, which unblocks questions that could not sensibly have been asked yet. The
agent recomputes the frontier and asks the next round. It stops when the frontier is empty.

Both failure modes are now named. **Trickling** is the old behaviour: one question per message when
five were answerable. **Front-loading** is the overcorrection: asking everything at once, including
the questions whose answers depend on this round and would therefore be guesses.

### Every question carries a recommendation

The format is fixed: numbered, titled, brief options, and an explicit `➡️ Claude recommends 2` with
the reason in one line. Always recommend, always justify — and never soften the recommendation
because you leaned the other way. Sycophancy is listed in the skill as a failure mode rather than a
courtesy.

Questions are asked as **prose in the chat**, and the `AskUserQuestion` tool is now denied outright.
A multiple-choice widget accepts a choice; it does not accept "2, but only for the admin surface",
which is what most real answers look like. The deny entry removes the widget and nothing else — the
"take no action until confirmed" gate comes from the grilling rule itself.

### The part that mattered more than the rule

Dozens of files described the one-question-at-a-time mechanic in their own words rather than
routing to the skill that owns it. Changing the skill alone would have left every one of them
contradicting it.

So the standing rule is now the shape, not the sentence: an agent, workflow or skill opening a
grilling pass names **what** must be settled and routes to `.claude/skills/grilling/SKILL.md` for
**how** — never the format, the round shape, or the recommendation rule. That is the only way a
change to the interview reaches the whole system at once.

## v2.4.0 — 11/08/2026

**Status:** Minor — a documentation standard that was already being followed by habit becomes a
standard with a name, a guide, and two gates. Around two hundred files change; none of them
changes what the template does.

### The problem with a rule everybody knows

Every directory here carries two files: a `CONTEXT.md` and a `CLAUDE.md`. Everyone working in the
repository knew roughly what went in which. Nothing said it precisely, and nothing checked.

So it drifted in one direction, reliably: an operating rule gets written into an orientation file
because it was useful the moment someone arrived, and the paired `CLAUDE.md` keeps its own copy in
slightly different words. Two wordings of one rule is one rule nobody can change safely — you fix
it in the place you happened to open, and the other copy quietly becomes the wrong answer for
whoever opens that one instead.

### The line, and where it now lives

**`CONTEXT.md` says what is here and why it is here. `CLAUDE.md` says how to work here.**

`code/docs/DOCUMENTATION-PAIRING.md` owns that sentence, the decision test for anything that could
plausibly go in either, the headings that never belong in an orientation file, and the
route-don't-restate rule. `.claude/CLAUDE.md` § 8 states the rule in one bullet and routes here for
the procedure, rather than carrying a second copy of it — which is the standard applied to itself.

### Three gates, because a rule nothing checks is a rule that rots

- **`docs-pairing.sh`** — pairing in both directions, the four required `CLAUDE.md` headings, the
  `@./CONTEXT.md` import, the `Read order:` line, and the banned orientation headings.
- **`docs-length.sh`** — the 300-line instructional cap. This previously pointed at `cloc.sh`,
  which excludes Markdown by design and therefore measured nothing at all.
- **`sync-trees.sh`** — reconciles the Directory Tree block of any `CONTEXT.md` whose directory has
  a staged change. It only ever **adds** a row, and an added row arrives as
  `← TODO: what this is and why it is here` and fails the commit. You write the description while
  you still know the answer, which is the only moment anyone does.

The first two run in CI and at pre-commit; the third runs at pre-commit and re-stages what it fixed.

### What actually changed in the files

Mostly deletions. `Prerequisites`, `Quality gates` and `Naming` sections came out of orientation
files — each was an operating rule in the wrong half, and each already existed in the paired
`CLAUDE.md` or the workflow `CHECKLIST.md`. _Hard gates_ and _Soft references_ became **Governing
documents** and **Related reading**, because the old names described when to read a file rather
than what it is.

Most orientation files also gained an opening line saying why the thing they describe exists. A
directory tree tells you what is there. It does not tell you why you would go.

### If you are updating an existing project

This release rewrites files Copier owns, and Copier will three-way-merge them against your edits.
Where you have added your own sections to a `CONTEXT.md`, expect to resolve a conflict and decide
which half each of your additions belongs in — which is the release working as intended, once.

## v2.3.1 — 03/08/2026

**Status:** Patch — cleans up after 2.3.0 on projects that update. Take this with 2.3.0 rather
than instead of it.

### What 2.3.0 left behind

2.3.0 started shipping the root version files from a `.copier/` staging directory, moved into
place by a post-generation task. Those tasks run on `copier copy` and never on `copier update` —
which is exactly what makes the seeds seed-once, and is the entire point of the arrangement.

The consequence nobody looked for: a project that **updates** receives the staged files and keeps
them. You end up with

```text
.copier/
├── CHANGELOG.md
├── RELEASES.md
├── VERSION
└── VERSION-HISTORY.md
```

sitting in your project. Harmless to the build, and actively confusing to read — four files that
look like your version state, next to the four that actually are.

### The fix

A `_migrations` entry that removes `.copier/` after any update. It is deliberately **not**
version-scoped: the rule needs to hold for every future release that stages a file this way, not
just the one that introduced the problem. Removing a directory that is normally absent is a no-op,
so running it on every update costs nothing.

### How this was found

By updating a real project and reading the result, not by reviewing the diff. That is twice now —
2.1.1 was the same shape of mistake, a mechanism that behaved differently on `copy` than on
`update` and was only exercised on one path.

The lesson, which is now the practice: **anything split across `copy` and `update` gets tested on
both before it ships.** `template-update.sh` exists precisely to make the second path cheap to
check.

---

## v2.3.0 — 03/08/2026

**Status:** Minor release — a generated project's version history is its own now. Existing
projects need a one-time manual correction; see below.

### What was wrong

`VERSION`, `CHANGELOG.md`, `RELEASES.md` and `VERSION-HISTORY.md` shipped from the repository root
unmodified. So every project generated from this template opened life declaring itself **version
2.1.1**, with a changelog documenting twenty releases of syntek-base's own development and not one
line about itself.

This is not hypothetical. The four projects generated before this release each carried twenty
`CHANGELOG.md` entries, twenty `RELEASES.md` sections and twenty `VERSION-HISTORY.md` rows,
none of them theirs.

### What changed

Those four files now ship from the `.copier/` staging directory and are moved into place by a
post-generation task — the arrangement `README.md` has always used. A new project starts at:

```text
VERSION              0.1.0
CHANGELOG.md         one entry: [0.1.0] — generated from the base template
RELEASES.md          one section: v0.1.0 — initial scaffold, nothing built yet
VERSION-HISTORY.md   one row
```

**And they are seeded once, never updated.** Post-generation tasks run on `copier copy` and never
on `copier update`, so a template update cannot overwrite your release history with ours. The
trade is deliberate and worth stating: template improvements to those four files will never reach
you either. They are yours from the moment the project exists.

### If you already have a generated project

Your root version files are wrong and this release cannot fix them — updates deliberately do not
touch them, which is the whole point. A one-time correction, once:

```bash
printf '0.1.0\n' > VERSION
```

Then empty `CHANGELOG.md`, `RELEASES.md` and `VERSION-HISTORY.md` of syntek-base's history and
start your own. Copy the shape from a freshly generated project if you want the exact format. Do
this before your first real release, or your first release notes will sit beneath twenty entries
about a template.

### The rule behind it

`CONTRIBUTING.md` § 1b, which never ships downstream: in syntek-base a version bump edits exactly
six root files and **never a versioning document anywhere else in the tree**. The documents under
`code/src/django/` and `code/src/mobile/` are seed content for generated projects and stay pinned
at `0.1.0` — bumping them here would hand every new project a sub-package history describing the
template's development rather than its own.

Two CI assertions now enforce it, because a rule nothing checks is a rule that rots: one proves a
generated project starts at `0.1.0` with single-entry history files and no leftover staging
directory, the other proves the sub-package seeds stay single-entry.

---

## v2.2.0 — 03/08/2026

**Status:** Minor release — makes template updates safe to run on a project that has real work in
it. If you are on 1.x, read this before updating.

### The failure this fixes

Conflicts are the loud failure, and they were never the problem: markers in a file, you resolve
them, you move on. The dangerous one is silent, and v2.0.0 shipped it.

Copier only knows about files it generated. When a release renumbers a directory, it moves its own
scaffolding to the new path and deletes the old — and every story, ADR and sprint record **you**
wrote stays exactly where it was. No conflict. No error. The update reports success.

What you are left with:

```text
project-management/src/
├── 01-STORIES/          ← your US001.md, US002.md, and nothing else.
│                          No CONTEXT.md. Nothing references this folder any more.
└── 02-STORIES/          ← CONTEXT.md, CLAUDE.md, US000-TEMPLATE.md.
                           Every workflow and agent now looks here. It is empty.
```

This was reproduced, not theorised: a v1.2.0 project with two stories, an ADR, a sprint record, a
Django app and a local `.claude/CLAUDE.md` edit, updated to v2.1.1. The app and the local edit
merged fine. The four PM artefacts were stranded, with zero conflicts reported.

### Four layers, in order

**1. The numbers stopped moving.** `project-management/src/` folder numbers are now frozen, append
only. The distinction that was missing: a `workflows/` folder is a **procedure** the template owns
end to end, so renumbering it is a reference sweep. A `src/` folder is a **data store** holding
work the template has never seen, so renumbering it is a schema migration — and Copier cannot
perform one. A new artefact folder now takes the next free number at the end, even where that
breaks the workflow↔`src` mirroring. The mirroring is a convenience; your work is not.

**2. An audit that finds them.**

```bash
bash code/src/scripts/audits/template-orphans.sh
```

Every template-owned directory ships a `CONTEXT.md`, so the signature is exact — content present,
`CONTEXT.md` absent. Nothing else produces that. It runs in CI as `Audit — Template Orphans`.

**3. A preview that predicts them.**

```bash
bash code/src/scripts/development/template-update.sh
```

Clones your project to a scratch directory, runs the update against the copy, and reports what
changes, what is deleted, what conflicts, and what would be orphaned — with your project
untouched. `--apply` when you are satisfied; it refuses while orphans are predicted.

`14-UPDATING.md` has advised diffing in a scratch directory since it was written. Prose nobody
executes prevents nothing, so it is now one command.

**4. A migration that rescues them.** `copier.yml` gained `_migrations` — a mechanism Copier has
had since 9.0.0, which this template required and never used. The v2.0.0 entry moves your
artefacts out of the twenty renumbered folders into their replacements: sub-paths preserved, never
overwriting on a name collision, idempotent if re-run.

### Updating from 1.x

The 2.0.0 notes told you `copier update` would not apply cleanly and to plan it as a piece of
work. That is now much less true — the migration does the folder move for you. Still:

```bash
bash code/src/scripts/development/template-update.sh --ref v2.2.0 \
  -- --data PROJECT_DESCRIPTION="..." --data SPRINT_CAPACITY_SP=11 --data SPRINT_GRACE_SP=13
```

Preview first, read what it says, then `--apply`. Afterwards run the orphan audit and confirm it
is clean before you commit.

### The general rule, now written down

**Any release that moves a directory holding developer artefacts ships a migration in the same
commit, or it silently eats work.** That is in `copier.yml` beside `_migrations` and in
`12-EXTENDING.md`, because the next person to renumber something will not have this context.

---

## v2.1.1 — 03/08/2026

**Status:** Patch — repairs the template's own CI, which 2.1.0 broke. Generated projects are
unaffected.

### What went wrong

`PROJECT_DESCRIPTION`, added in 2.1.0, deliberately has no default — the whole point is that
someone writes it. But the `Audit — Template Integrity` job generates its probe project with
`copier copy --defaults` plus a fixed list of `--data` answers, and that list was never extended.
The job failed at the first step with `Question "PROJECT_DESCRIPTION" is required`, before any of
its six assertions ran.

The same gap sat in `.github/PULL_REQUEST_TEMPLATE.md`, whose "I generated a project from this
branch" snippet would have failed identically for every contributor who followed it.

Both now pass the question. Verified by running the workflow's generation step locally across
both render paths: zero surviving tokens, no template-only files leaked, the mobile surface
obeying its opt-in, and the shared tree byte-identical between the two.

### Nothing to do

`.github/workflows/audit-template.yml` and `.github/PULL_REQUEST_TEMPLATE.md` are both in
`copier.yml` → `_exclude`, so neither has ever existed in a generated project. `copier update`
from 2.1.0 to 2.1.1 changes version metadata and nothing else.

Worth stating plainly, since 2.1.0's release notes did not: a question with no default is a
question every automated caller must be taught about. This release is the cost of that.

---

## v2.1.0 — 03/08/2026

**Status:** Minor release — one new Copier question, two passes that run before the first feature,
and a comment standard that finally says one thing.

### The project describes itself now

A new Copier question, `PROJECT_DESCRIPTION`, asks what the project does, who it is for, and what
it replaces. The answer opens the root `CONTEXT.md`, which `.claude/CLAUDE.md` imports — so it is
the first thing every agent reads in every session, before the stack, before the rules, before
the task. It also fills the `description` field in `pyproject.toml` and `package.json`, neither of
which had one.

Copier enforces a 40-character floor and rejects double quotes. It cannot enforce that you meant
it, which is why the first session asks you to expand it.

### Describe it, then size it, then build it

`how-to/workflows/01-first-time-setup/` gains two steps that run **once per project**, after the
stack is up and before anything is charted:

1. **Sharpen the brief** — what it does, who for, what it replaces, and what it deliberately is
   not. Every scope argument you will have resolves against this paragraph; leave it as a
   generation-time one-liner and those arguments resolve against nothing.
2. **`/scale-planning`** — not for the server tier, which can wait. For the questions it forces
   while everything is still cheap to change: how many users, what the read/write mix is, which
   scaling phase-gate the design must not foreclose.

The second produces something the repo did not have an explicit home for: the **not required**
list. A project sized for hundreds of users does not need what one sized for hundreds of
thousands needs, and naming which you are building is what licenses leaving things out. Answer
these after ten features and you are not planning — you are auditing decisions already made.

Neither is a hard gate on `01-feature`. Charting without them works; it just surfaces every
sizing question as a decision node, one feature at a time, which is the expensive way round.

### The register is a loop, not a dead end

`GAPS.md` and `DEFERRED.md` were write-only: every workflow put things in, nothing took them out
except by accident. Two changes close the loop.

`/wayfinder suggest` mines the register for candidate features, clustering by shared cause or
dependency — five deferrals waiting on the same missing table are one feature, not five — and
ranks them by how much debt each retires. Charting then triages every open entry against the
feature in hand: **closes**, **blocks**, or **unrelated**, with the unrelated count recorded so
the triage is provably exhaustive.

**Claiming is not closing.** `01-feature` records on the map that a feature will retire an entry;
`21-implementation-documentation` marks it closed against shipped code, and is now the only place
that can. A claim the story did not actually retire stays open, and the reason becomes a finding.

### Comments say why, and nothing else

The comment standard contradicted itself. `code/docs/coding-principles/STYLE-AND-PROCESS.md` said
"why, not what"; the canonical rule that every agent actually routes to said the opposite — "what
it does (not how)" for docstrings, and inline comments explaining "**what** and **why**".

It now says one thing. Comments and docstrings in a code file carry the **why**; the code states
the what. Docstrings are one line, with no `Args:`/`Returns:`/`Raises:` block, because the typed
signature already carries them.

And a comment never points outside its own file — no story, sprint, ADR, ticket, PR, commit, doc
path, person, or date. The reason has to travel in the comment, because a reader who cannot open
the reference still needs to understand why. `TODO`/`FIXME` go with it: the old rule required a
ticket reference, which is exactly the outward pointer now banned, so deferred work goes to
`DEFERRED.md` or `GAPS.md` instead.

Two exemptions, both because the reference _is_ the content: declarative configuration, where a
policy exception needs its trail, and the dev scripts, which often name the rule they enforce.
One exception for published interface text: a Ninja endpoint docstring renders on the OpenAPI
page and a FastMCP tool docstring is the prompt a model reads, so both state the full what.

### Fixes

- **Sixteen files carried broken token substitutions** — paths concatenated with their filenames,
  placeholder prose where a number belongs, and prose standing in for a path. `wayfinder`'s
  graduation table read "a new ADR — the project's decision register (next free number is the
  project's decision register)". All resolve to real paths now, verified against disk.
- **Origin-project references had leaked in** — a "live worked example" citing US208–US214 in a
  template that ships no stories. `MAP-SCALE-PLANNING.md` was filed under plans in four files; it
  is a map, so it belongs in `src/01-FEATURE/`.
- **Five comments in the shipped skeletons** pointed at `code/docs/*`, in breach of the standard
  above.
- **Copier question counts were wrong in three guides** — twenty-four, twenty-four, and
  twenty-one, against a real figure of twenty-nine. Now thirty: twenty-six always asked, four
  conditional on the optional surfaces.

### Upgrading

`copier update` prompts for `PROJECT_DESCRIPTION` — the one new question. Write it properly; it
is the sentence every agent reads first. Everything else is documentation and applies on the next
session without action.

---

## v2.0.0 — 03/08/2026

**Status:** Major release — breaking. The PM layer is restructured around a per-story planning
cadence, and every workflow and `src/` folder is renumbered.

### Read this first if you have a project on 1.x

`copier update` **will not apply cleanly**. Every `project-management/workflows/` and
`project-management/src/` path has moved by one, two folders were deleted, and two new questions
were added. Plan the update as a piece of work, not a routine pull. `14-UPDATING.md` covers the
conflict flow; the safest route is to update into a scratch directory first and diff.

### What changed, and why

**Planning now runs one story at a time.** Previously the numbered gates read as a batch — write
every story, then every schema, then every flow. That guaranteed the same cross-cutting questions
got answered slightly differently at every gate. A story now runs the whole specify tier
(`02`–`13`) and finishes at `14-decisions` before the next one starts, so story 7 is planned with
six stories' worth of settled decisions already in hand.

**Sprint planning fires on fill, not per story.** Each finished story is slotted into the open
sprint record with its points. When it reaches the ceiling — `SPRINT_CAPACITY_SP`, default 11,
grace 13 — `15-sprint-plans` and `16-story-plans` run for that sprint, then planning resumes. Both
figures are new Copier questions and are meant to be retuned against measured velocity after two
sprints.

**Work starts with a feature, not a story.** The new `01-feature` gate charts the decision
frontier with wayfinder and settles it node by node. Stories are cut from the resolved
`MAP-<FEATURE>.md`, which is what stops each one rediscovering the same questions.

**Design work is consolidated before code.** Planning per story means design arrives per story and
drifts by construction — two stories will model the same entity differently or invent the same
badge twice. The design and schema folders now carry three stages:

```text
USER-STORY-IDEAS/  →  CONSOLIDATED-IDEAS/  →  IMPLEMENTATION/
  per story            workflow 17              what shipped
  frozen once 17 runs  ← this is what gets built
```

`17-consolidate-design-work` reconciles the accumulated work once every story is planned. It
resolves the schema first, because a fragmented schema gets costlier with every story that ships
on top of it. Stage 1 is frozen rather than deleted — it is the record of what each story asked
for, and the evidence when a consolidated decision is later questioned.

### Also in this release

- `12-seo-checks` became a **planning** gate. It sat in the specify tier but required a deployed
  page, which made it impossible to run in its own slot. Auditing the built page and writing the
  `IMPLEMENTATION/` record moved to `21-implementation-documentation`, which already owned every
  other implementation record.
- `SPRINT-PLANNING-GUIDE.md` split into `PLANNING-GUIDE.md` over
  `planning/{CADENCE,STORIES,SPRINTS}.md`. The old name had stopped describing its contents once
  the cadence — which governs `01`–`17` — moved into it.
- A new template guide, `09-PROJECT-MANAGEMENT.md`, on using `project-management/src/` properly.

### Fixes worth knowing about

- Twenty `IMPLEMENTATION/` folders credited the PR workflow for writing their records, which
  workflow `21` had already absorbed.
- Three workflows — brand guides, wireframes, sprint plans — had no grilling pass at all, despite
  `.claude/CLAUDE.md` §10 making it the default for substantial work.
- The wayfinder skill referenced its map through a token substitution that had lost its separator.

### Upgrade notes

- Two new questions on `copier update`: `SPRINT_CAPACITY_SP` (11) and `SPRINT_GRACE_SP` (13).
  Press Enter on both unless you already know your velocity.
- `code/workflows/` and `how-to/workflows/` numbering is **unchanged** — those are catalogues,
  where numbers are stable identifiers and are never reused. Only the PM layer renumbered, because
  there the number _is_ the running order.

---

## v1.2.0 — 02/08/2026

**Status:** Minor release — a fourth surface, off by default, with a licence obligation attached

### Summary

A native **desktop** surface: a Slint application, gated by `INCLUDE_DESKTOP`, which is only asked
when `INCLUDE_RUST` is true. Both default to `false`, so a project that opts into neither is
unaffected.

It is a real native binary — not a webview, not Electron — and it lives as a **member of the
existing Rust workspace** rather than a second one. That means one toolchain pin, one `deny.toml`,
one `clippy.toml`, and lint/test/audit already covered by the Rust script group.

### Read this before enabling it

The app ships under Slint's **Royalty-free** licence. That tier is free for proprietary
applications **and commercial sale** — the paid Commercial licence is triggered by _embedded
systems_, not by charging money.

What you owe in return is **disclosure**: the `AboutSlint` widget in the About dialog.
`code/src/scripts/desktop/package.sh` refuses to build a release binary without it. That is a
licence gate, not a lint — if it fires, restore the widget rather than editing the check.

Two exclusions matter architecturally:

- **Embedded systems** — an appliance screen, a POS terminal, a car dashboard — need the paid tier.
- **Redistributing anything that exposes Slint's APIs** is not permitted. This is why desktop UI
  is never moved into a shared package layer, and why desktop panels are rebuilt per application
  rather than shared. That duplication is a priced decision, not an oversight.

This is a reading of the licence text, not legal advice.

### Two advisories are accepted, deliberately

Enabling the desktop surface brings `RUSTSEC-2026-0194` and `-0195` — denial-of-service issues in
`quick-xml`, reached **only** through Slint's accessibility stack. Every version pin from
`accesskit_unix` up to Slint's own `=1.17.1` blocks the patched release, so they are not fixable
downstream.

They are accepted because the parser handles D-Bus introspection XML from the **local** AT-SPI
session bus — an attacker able to publish there already owns the session — and because the
alternative would be dropping the accessibility layer, which is not a mitigation but a regression.
Recorded in `deny.toml` with a re-check date of 02/11/2026.

`unmaintained` is now scoped to `workspace`: you can act on your own direct dependencies, not on
one buried three levels inside a GUI toolkit.

### Upgrading

`copier update`. Answering `false` to `INCLUDE_DESKTOP` — or leaving `INCLUDE_RUST` false, in
which case the question is never asked — changes nothing but the documentation indexes and
version metadata.

---

## v1.1.0 — 02/08/2026

**Status:** Minor release — a new optional surface, off by default

### Summary

`syntek-base` gains a third surface: an opt-in **Rust workspace** at `code/src/rust/`, for PyO3
extension modules, standalone binaries, CLI tools and services. It is gated by one new question,
`INCLUDE_RUST`, which defaults to `false` — so **a project generated without it gains no files and
loses none.**

That is not the same as byte-identical, and the difference is worth knowing before you read a
`copier update` diff: sixteen files change content. The documentation indexes gain **rust-only**
flagged rows, the version metadata moves, and `pyproject.toml` gains one comment. Nothing in the
tree changes.

### The distinction that decides your answer

`INCLUDE_RUST` gates **authoring, not consuming**.

A project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and
needs no toolchain at all — that project answers `false`. Answer `true` only when source in _this_
repository is compiled by `cargo`.

Getting it backwards is expensive in one direction only: on a `true` project every contributor
needs `rustup` before `uv sync` works, and every CI run builds a toolchain. That is the whole
reason the default is `false`.

### What `true` gives you

- A Cargo workspace with `nativecore`, a baseline PyO3 crate — `constant_time_eq` and a
  `SecretBytes` type that wipes itself on drop
- `code/src/scripts/rust/` — build, test, lint and a `cargo-deny` supply-chain gate
- `code/docs/RUST.md` plus three sub-documents: the PyO3 boundary, memory hygiene, supply chain
- `code/workflows/12-rust-extension/`, entered from PM `18-backend-code`
- A `rust` agent and a `stack-rust` skill, excluded together with the tree
- `syntax-rust.yml` — clippy at `-D warnings`, the Rust suite, and the dependency audit

### Why the guidance is opinionated about _whether_ to use it

Every document here opens with the same gate: **does this need to be Rust at all?** Rust earns its
place on two grounds — a guarantee Python cannot make (constant-time comparison; erasing key
material, which immutable garbage-collected `bytes` make impossible), or a **measured** hot path.

A rewrite of working Python fails that gate. The reason is not taste: a PyO3 extension is loaded
into the same process as Django, with the same privileges and no sandbox, so every crate you add
sits between a `build.rs` and your database credentials. That is why `cargo-deny` is a gate rather
than a report.

### Encryption is unchanged

**Fernet remains canonical** for field encryption. Native crypto is a branch for what Fernet
structurally cannot do — never a replacement, and nothing is migrated automatically. Two
implementations of the _same_ concern is a parity burden that drifts; two covering _different_
concerns is a boundary.

### Upgrading

`copier update` and answer `INCLUDE_RUST`. Answering `false` changes nothing.

---

## v1.0.0 — 02/08/2026

**Status:** Stable release — the template leaves `0.x` and commits to its interface

### Summary

**Nothing in the generated project changes.** Generate from `1.0.0` and you get the repository
`0.14.0` produced, byte for byte. This release is a statement about **support**, not a change to
the code — which makes the only question worth answering: what is now promised that was not
promised yesterday?

Under semver, a `0.x` track may break anything in any minor bump, and this one used that latitude
freely. Workflow directories were renumbered twice — the PM layer in `0.8.0`, both workflow layers
in `0.14.0` — and each move silently invalidated every path a downstream project had written down.
Under the `1.x` policy those are major-version events.

Four things are now the template's **public interface**, and a breaking change to any of them
requires `2.0.0`:

- the **Copier answer contract** — twenty-two questions, or twenty-four with the mobile surface
- the **three-layer directory contract** — `code/` · `how-to/` · `project-management/`
- the **`CONTEXT.md` + `CLAUDE.md` pairing rule**, and the routing frontmatter that drives it
- the **numbered workflow identifiers** — stable identifiers, appended to and never renumbered

Everything else — the content of a guide, the wording of an agent definition, an added skill —
stays a minor or patch concern, exactly as before.

### What's new

- **A stability guarantee where there was none.** Pin `1.x` and a `copier update` will not move your workflow paths, rename a layer, or change what the answer file means
- **`.claude/MEMORY.md` ships empty.** It had accumulated five notes written while `syntek-base` itself was being built — the Expo pin matrix, a `glob` override, the route-collision rule, and two design conventions. Useful to whoever built the template; noise to a project generated from it, since it describes decisions already taken in a repository the reader is not working in. The three headings and the write-policy preamble remain, so the first thing you record goes into an empty store rather than on top of someone else's notes
- **The fourteen `0.x` releases are now published as pre-releases**, with `1.0.0` the first marked latest. Their notes, commits and changelog entries are untouched — only the label moved

### Worth knowing

- **There is no upgrade step.** A project generated from `0.14.0` is already on the `1.0.0` surface; nothing needs re-running, and `copier update` will report no changes beyond the version string
- **The durable half of the deleted memory notes was never only there.** `code/src/CONTEXT.md` defines _surface_, and `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md` carries the one-way optional-content gate with its rejected alternatives. Emptying the memory store loses no reasoning that a generated project can act on
- **The pre-`1.0.0` tag numbers are not the ones GitHub carried before.** This repository previously ran to `v1.11.0` under an older Next.js/Expo scaffold, then reset its version track to `0.1.0` at `a1ec114` when it became a template. Those legacy tags and releases have been removed; the commits behind them remain in git history, as `v0.1.0` said they would

---

## v0.14.0 — 02/08/2026

**Status:** Documentation release — the agent-facing surface, specified; CI made green

### Summary

Two unrelated things, both about what a generated project inherits.

The first is **guidance for serving LLM agents**. A generated project can already serve people
(Django pages) and machines (the Django Ninja JSON API). This release documents the third
caller — an AI agent that must _carry out_ domain operations — and the FastMCP tool surface at
`/mcp/` that serves it. Nothing is built: `fastmcp` is not a declared dependency and nothing is
mounted, exactly as Django Ninja itself sits declared-but-unwired. What ships is the design of
record, so the first project to need one does not have to invent it.

The shape is deliberately conservative. MCP tools and Ninja endpoints are **peers over one
service layer** — neither calls the other, neither holds logic. That is not a stylistic
preference: one adapter over a service layer is a seam you could always collapse back; a second
adapter is what makes it real. The alternative on offer — generating tools automatically from
the API's OpenAPI document — is documented as an explicitly rejected default, with the trigger
for reconsidering it.

The second is **CI**. Six of the eight Claude Code quality gates, the nightly dependency sweep,
the ClickUp sync and all three Python syntax jobs were failing on every run in this repository —
not because anything is broken, but because a template legitimately lacks the things they check.
They now report green here and work unchanged in a generated project.

### What's new

- **A guide for exposing domain operations to an AI agent** — when it is the right call, and, more often, when a plain API endpoint already does the job
- **A security model for a surface Django does not protect.** The `/mcp/` mount sits beside Django, not inside it: no session, no login checks, no CSRF. The guide treats that as the defining constraint rather than a footnote
- **One rule stated more firmly than any other:** the caller's identity comes from its token and never from a tool argument. The caller is a language model, so a `user_id` parameter is not a risk — it is the vulnerability, already shipped
- **A `stack-fastmcp` skill and an eleventh code workflow**, so Claude Code applies MCP conventions when working on tools and Django Ninja conventions when working on endpoints, without confusing the two
- **No new agent** — MCP tools are backend work, and the existing `backend`, `security` and `test-writer` agents gained the routing instead
- **Five new operational workflows** covering things the project could already do but had never written down — database backup and restore, running the test suites, the pre-PR quality gates, and dependency updates. Each one drives scripts that already existed
- **A way to write your own operator documentation.** A generated project inherits a workflow, a specialist agent and a skill for authoring the guides that tell a human how to run _that_ project — the part the template cannot write on your behalf. The rule it enforces is the one people skip: a guide you have not executed start to finish is a guess
- **The eleven coding workflows regrouped into three families** — build, verify, then diagnose & improve — so the list reads in the order work actually happens. Debugging-with-logs and debug now sit side by side: one finds the cause, the other fixes it, and they were previously three apart with unrelated workflows in between

### Worth knowing

- **Nothing is installed.** `fastmcp` sits in the register of dependencies deliberately left undeclared, with the condition that should trigger adding it. A project that never needs an agent surface pays nothing for this release
- **The one file it would change is `config/asgi.py`**, which becomes a small router placing FastMCP at `/mcp/` and Django everywhere else. The guide covers the four details that fail silently when wrong
- **The workflow renumber is a path change.** If you have bookmarks, scripts, or notes pointing at the old `07-debug`, `08-refactor` or `09-database-migration` numbering, eight of the eleven directories moved — the mapping is in the changelog. Nothing inside any workflow changed
- **The CI fixes change no behaviour in a generated project.** Every guard detects an absence specific to the template — a missing lockfile, an empty backlog — and steps aside. Where a check still applies here (Prettier, ESLint, dependency auditing), it keeps running: the guards sit on individual steps rather than whole jobs, so fixing the Python half never disabled the JavaScript half

---

## v0.13.0 — 02/08/2026

**Status:** Feature release — the template can now generate a mobile application

### Summary

The template gains a **second surface**. Answer yes to one question at generation and you get a
bootable React Native application at `code/src/mobile/` alongside the Django project — Expo,
TypeScript, expo-router, its own test suite at the same coverage floors, and its own CI jobs.
Answer no, which is the default, and you get a repository functionally identical to the one
0.12.0 produced.

That second half is the harder promise, and it is the one the release is built around. The opt-in
is gated by **one mechanism** — a single templated exclusion entry — so no shared file carries
conditional contents and every file outside the mobile tree is byte-identical on both paths. CI
now proves it: the template audit generates the project **both ways** on every run and compares
the results file by file.

The mobile app is a **peer of the Django project, not a client for it**. It renders no Django
page, Django never bundles it, and it reaches the server through the same JSON API any
third-party client would. That distinction is why the project's long-standing rule — no
client-side build, no bundler, no client framework — survives this release **unweakened**. The
rule was narrowed in scope to "the web surface", not relaxed. Adding a bundler to the Django
pages remains as forbidden as it was.

### What's new

- **An opt-in mobile application** — Expo SDK 57 with Continuous Native Generation, so the iOS and Android directories are generated rather than committed. One placeholder screen; mobile work starts from a user story exactly as web work does
- **Six mobile scripts** covering install, Metro, lint, typecheck, test and bundle export. Metro runs on your machine rather than in Docker, because a phone cannot reach a container's loopback address
- **Four new CI jobs**, each reporting green on a web-only project rather than showing as skipped
- **A mobile specialist agent and stack skill**, so Claude Code applies React Native conventions to the mobile tree and Django-template conventions to the web tree, without confusing the two
- **The design-token bridge, specified** — how database-canonical design values reach an application that cannot read CSS, including which preference settings survive the crossing and which cannot
- **Mobile accessibility guidance** — the same WCAG 2.2 AA standard, with the React Native techniques that satisfy it

### Worth knowing

- **Design-token changes are live on the web, but not on mobile.** A token edit reaches an installed application only through a rebuild and a store release. The web surface keeps its no-rebuild behaviour unchanged
- **Automated accessibility scanning has no mobile equivalent.** The web surface has an automated WCAG scan; nothing comparable exists for React Native, so mobile accessibility is verified by hand on both VoiceOver and TalkBack. A mobile screen is never "scanned clean"
- **The mobile application versions independently**, like the Django bundle. App-store versions must only ever increase, so tying it to the repository version would force pointless releases
- **Existing projects are unaffected.** Updating from 0.12.0 asks three new questions, all with defaults, and changes nothing unless you opt in

---

## v0.12.0 — 02/08/2026

**Status:** Feature release — the template becomes installable, updatable, and open source

### Summary

Three things change together, and they reinforce each other.

**Scaffolding moves to [Copier](https://copier.readthedocs.io/).** `setup.sh` did literal string
substitution and then severed the connection: a project generated from the template could never
receive a later fix. Copier keeps the link. A generated project carries `.copier-answers.yml`
recording the source, the commit and every answer, and `copier update` three-way-merges upstream
improvements against local edits. That single capability — fix once, propagate everywhere — is the
whole reason for the migration, and it is the one thing that could not have been bolted on later.

The move forced a delimiter change. Copier renders through Jinja2, and its default double-brace
delimiters collide with four things already in this repository: GitHub Actions expressions, Django
template syntax, Bruno variables, and — for the obvious double-square-bracket alternative — bash
test syntax, of which there are over three hundred instances in the project scripts. A bespoke set
of variable, block and comment delimiters replaces them, each verified to appear nowhere in the
tree before being adopted. The set and the full reasoning are in
`how-to/src/TEMPLATE-TOKENS.md`.

**The repository becomes properly open source.** MIT, with a `LICENSE`, a `SECURITY.md`
disclosure policy, a contributor guide, CODEOWNERS, issue and pull-request templates, and branch
protection on `main`. Version 0.10.0 retired the licence on the reasoning that a template should
not choose one for the project generated from it — that reasoning was sound but the conclusion was
wrong. MIT covers the template; `<%LICENCE%>` remains a question, so a generated project still
picks its own, and proprietary is still the default answer.

**The documentation catches up.** `how-to/src/TEMPLATE-GUIDE/` is fourteen numbered guides taking
a reader from "should I use this at all" through generation, orientation, the first story,
customisation, deployment and updating. The root README stops impersonating a shipped product and
describes the template — 1160 lines down to 140.

### What's new since v0.11.0

- **One-command generation** — `uvx copier copy gh:Syntek-Dev/syntek-base my-project`
- **`copier update`** — pull later template fixes into projects already built from it
- **MIT licence, `SECURITY.md`, `CONTRIBUTING.md`, CODEOWNERS, issue and PR templates**
- **Branch protection on `main`** — PR required, conversation resolution required, force-push and deletion blocked, eleven required checks, admin bypass retained
- **Two new CI gates** — token-syntax integrity, and a generation smoke test that builds a real project on every pull request
- **Fourteen template guides** plus a contributing standard split out of `how-to/src/CONTEXT.md`
- **Platform-aware `install.sh`** — Linux, macOS (Docker Desktop or Colima), WSL 2; rejects native Windows shells and warns on WSL 1 and `/mnt/c` checkouts
- **Provider-neutral deployment docs** — any Linux host with Docker works; Hetzner, NixOS and Cloudflare are the documented target, not a requirement
- **Grilling versus wayfinder** explained, with the rule for choosing between them

### Upgrading an existing project

There is no automatic path from a `setup.sh`-generated project. Those projects have no
`.copier-answers.yml` and cannot be updated. Recreate the file by hand from a fresh generation's
format, filling in your values with `_src_path` and `_commit`, and `copier update` will work from
there. `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` covers it.

### Known requirements

The agent suite routes across two model tiers and uses Fable for planning and design work, so it
assumes **Claude Max 20× or above, or the Anthropic API**. On a smaller plan, or another provider,
retarget the `model:` frontmatter — the documentation system and gates are provider-agnostic.

---

## v0.11.0 — 01/08/2026

**Status:** Patch release — the root orientation file returns

### Summary

Retiring the root `CONTEXT.md` in 0.10.0 went a step too far. `.claude/CLAUDE.md` imports it with
`@../CONTEXT.md` on line 6, so every session since has loaded a file that no longer existed — the
project lost its top-level orientation just as the layered structure grew to justify it. The file is
back, rewritten for what the repository now is: a Django-only monolith distributed as a reusable base
template, not the Django + Next.js + React Native monorepo the old version described.

It carries the current directory tree, the layer map, the starting points for each kind of work, the
conventions that govern the `CONTEXT.md`/`CLAUDE.md` pairing, and the repository state. The one
documented exception to that pairing is recorded in place: the root has no `CLAUDE.md` because
`code-review-graph install` generates one there and the repository gitignores it — `.claude/CLAUDE.md`
is the root's operating-rules counterpart.

### What's new since v0.10.0

- **Root `CONTEXT.md` reinstated** — directory tree, layer map, starting points, conventions, repository state
- **Broken session import repaired** — `@../CONTEXT.md` in `.claude/CLAUDE.md` resolves again
- **Template instantiation signposted from the root** — the overview points at `setup.sh` and the token contract, and the note removes itself once the template is instantiated

---

## v0.10.0 — 01/08/2026

**Status:** Feature release — the templatisation completes and CI covers the new audits

### Summary

The final batch closes the conversion. Every hardcoded project identifier at the repository root
becomes a substitution placeholder — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`,
`<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>` — and an `install.sh`/`setup.sh` pair
resolves them when a project is scaffolded. CI gains six audit workflows matching the audit scripts
added in 0.4.0, plus a ClickUp sync pipeline, while the frontend and mobile pipelines are gone. Three
session sandboxes are established — `handoffs/` for the compaction replacement, `learning/` for the
teaching skill, and `research/` for cited primary-source notes. `REFERENCES.md` becomes the root
index, and the root `CONTEXT.md` and `LICENCE` are retired: a template does not pick a licence for
the project generated from it.

### What's new since v0.9.0

- **Placeholders throughout** — every project identifier is a substitution token resolved by `setup.sh` when a project is scaffolded
- **Six audit pipelines** — design tokens, CSS gradients, copy, secrets, and dependencies now fail CI, matching the audit scripts
- **Session sandboxes** — `handoffs/`, `learning/`, and `research/` give the handoff, teach, and research skills a committed home
- **Licence deferred to the consumer** — the template ships `<%LICENCE%>`, not a decision

---

## v0.9.0 — 01/08/2026

**Status:** Documentation release — setup, tooling, and deployment sizing guidance

### Summary

The how-to layer is rewritten for the Django-only stack and extended with the material a developer
needs that is neither code nor project management. Two new sub-folder guides land: an AI dictionary
giving plain-English definitions for the agent-coding vocabulary, and a tooling guide covering the
internal agents, skills, commands, and configuration. A fourth workflow documents git worktree
setup for parallel stories. Two architecture folders — `SCALE-ARCHITECTURE/` and
`SERVER-ARCHITECTURE/` — carry the sizing envelope, load profiles, readiness criteria, and compute
allocation that feed the separate NixOS deployment repository. The narrow contributor guides that
duplicated the PM layer are removed rather than maintained twice.

### What's new since v0.8.0

- **AI dictionary** — the agent-coding vocabulary in plain English, split across seven focused documents
- **Tooling guide** — what each internal agent and skill does, and how the configuration fits together
- **Worktree workflow** — run several stories in parallel with isolated Docker stacks and loopback hosts
- **Deployment sizing** — load profiles, a sizing envelope, and readiness criteria that hand off to the NixOS deployment repository
- **Duplication removed** — narrow contributor guides gave way to the authoritative code and PM guides

---

## v0.8.0 — 01/08/2026

**Status:** Documentation release — the PM layer is restructured into three tiers

### Summary

The project-management layer is restructured around three explicit tiers: specify (`01`–`12`),
decide and plan (`13`–`15`), and record (`16`–`20`). Artefact folders and workflows are renumbered
to match, with new slots for API design, SEO, decisions, sprint plans, and story plans — the story
plan is now the master document a developer codes from. Workflows extend to 21, adding
implementation documentation as a hard gate before the PR, and a release procedure at the end.
Every guide is rewritten for the Django-only stack, `GDPR-GUIDE.md` is split into a sub-folder,
and the domain-specific example artefacts are cleared so the template ships templates, not data.

### What's new since v0.7.0

- **Three tiers, explicitly numbered** — specify (01–12) → decide and plan (13–15) → record (16–20), with the story plan as the code master
- **Workflows to 21** — API design, decisions, sprint and story plans, three implementation phases, implementation documentation, PR and review, and release
- **Documentation is a hard gate** — `21-implementation-documentation` must be complete, with the code-review-graph refreshed, before a commit is allowed
- **No project data** — example artefacts and organisation assets are cleared; what ships is the structure and the templates

---

## v0.7.0 — 01/08/2026

**Status:** Documentation release — the code layer is re-documented and re-indexed

### Summary

Every guide under `code/docs/` is rewritten for the server-rendered Django stack, and the
instructional file-length rule is applied throughout: any guide over 300 code lines becomes a thin
index over a sub-folder of focused documents. Fourteen top-level guides now front sub-folders for
accessibility, API design, architecture, coding principles, data structures, design tokens,
encryption, logging, performance, rendering, responsive design, row-level security, security, and
testing. New guides cover the areas the stack change created — `DATABASE.md`, `DESIGN-TOKENS.md`,
`RENDERING.md`, `VISUAL-DESIGN.md`, the split backend and frontend coding principles, and the
code-review-graph playbooks. All ten code workflows gain `CLAUDE.md` operating rules.

### What's new since v0.6.0

- **Guides split, not truncated** — oversized guides become thin indexes over focused sub-documents, keeping every instructional file inside the 300-code-line limit
- **New stack guides** — database invariants and lock-safe migrations, the token-first design system, and the rendering decision boundary between template, HTMX, and Alpine
- **Code-review-graph playbooks** — explore, debug, review, and refactor procedures wired into the matching agents and workflows
- **Workflow operating rules** — every numbered code workflow carries a `CLAUDE.md` beside its `CONTEXT.md`

---

## v0.6.0 — 01/08/2026

**Status:** Feature release — the agent and skill surface moves from marketplace plugins into the repository

### Summary

The agent and skill surface previously came from two installed marketplace plugins. Those are now
disabled and their content lives in the repository, so a scaffolded project inherits a complete,
version-controlled Claude Code configuration with no external installation step. Fifty agents land
in two tiers — eight orchestrators that act as entry points, and the specialists and document
writers they delegate to. The skill library covers the stack, workflow, design, learning, and
document-standard skills. Hooks are consolidated into a single eight-gate pre-PR check plus a
pre-compact handoff interceptor, and the plugin directory is reduced to read-only inspection
helpers — dev operations belong to the shell scripts, not to plugins.

### What's new since v0.5.0

- **50 agents, two tiers** — orchestrators are the entry points and delegate scoped work to tool-scoped specialists and document writers
- **Skill library in-repo** — stack, workflow, design, learning, and document-standard skills load on demand with no marketplace dependency
- **Eight-gate pre-PR check** — lockfiles, lint, format, typecheck, stubs, tests and coverage, `cloc` limits, and a security audit
- **Handoff instead of compaction** — auto-compaction is disabled and intercepted; sessions write a committed handoff document and stop
- **Read-only plugins** — six inspection helpers gather context; they never run dev operations

---

## v0.5.0 — 01/08/2026

**Status:** Feature release — the API test suite becomes a template, not a fixture set

### Summary

A base template must ship the shape of a test suite without shipping anybody's domain. The Bruno
collections for authentication, orders, users, and performance are removed and replaced with one
annotated request template that new suites are copied from. Bruno environments are re-expressed as
native `.bru` files covering local, host, docker, staging, and production. Two runtime directories
gain their tracked scaffolding: `logs/` and a new `improvement-architecture/` scratch area whose
contents are git-ignored but whose orientation files are not.

### What's new since v0.4.0

- **One request template** — copy `template-test.bru` to start a suite; no invented domain endpoints to delete first
- **Five Bruno environments** — local, host, docker, staging, and production, in Bruno's native format
- **Runtime scaffolding** — `logs/` and `improvement-architecture/` carry tracked orientation files and ignored contents

---

## v0.4.0 — 01/08/2026

**Status:** Feature release — the script surface is the only supported way to run dev operations

### Summary

Every developer operation in this template runs through `code/src/scripts/**/*.sh` — never a raw
`pnpm`, `pytest`, `python`, or `docker` invocation. This release rewrites that surface for the
single-stack monolith. Existing runners are re-pointed from `code/src/backend/` to
`code/src/django/`; the frontend and mobile runners are deleted; and a new audit family, project
scaffolding scripts, and worktree helpers are added. Generated test reports stop being tracked.

### What's new since v0.3.0

- **Audit family** — a design-token audit that fails any component CSS carrying a raw literal, plus gradient, copy, and security audits, each wired to a CI workflow in 0.10.0
- **Page scaffolding** — `new-django-view.sh` creates view, template, and URL entry together so page routes are never hand-assembled
- **Worktree support** — `worktree-detect.sh` and the hosts helpers let several stories run side by side with isolated Docker stacks
- **Reports untracked** — test output is generated, never committed

---

## v0.3.0 — 01/08/2026

**Status:** Breaking change to the stack — the Django project bundle becomes the single application root

### Summary

Second half of the stack replacement. `code/src/backend/` becomes `code/src/django/`: with no
JavaScript client left, the Django project is no longer a _backend_ — it is the whole application,
serving its own templates, components, and HTMX partials. The rename runs through the Docker
images, Compose files, Nginx configuration, and the four environment templates. The django bundle
is registered as the repository's only versioned sub-package, starting at its own `0.1.0` baseline
with the three version files the versioning guide requires alongside every package manifest.

### What's new since v0.2.0

- **`code/src/django/`** — one application root: settings split four ways (dev, test, staging, production), ASGI and WSGI entry points, an `apps/` namespace, and template and static roots
- **django sub-package versioning** — the bundle carries its own `CHANGELOG.md`, `VERSION-HISTORY.md`, and `RELEASES.md` at `0.1.0`, moving independently of the root track
- **Docker re-pointed** — `docker/django/` images for all four environments, PostgreSQL dev tuning, and example Compose overlays for per-story worktrees
- **TypeScript shared package removed** — nothing consumes it once both JavaScript clients are gone

---

## v0.2.0 — 01/08/2026

**Status:** Breaking change to the stack — the JavaScript client layers are removed

### Summary

First half of the stack replacement. The template drops both JavaScript client layers: the
Next.js/React web frontend and the Expo React Native mobile application, together with their
Docker images and CI pipelines. Nothing replaces them in this release — the server-rendered
Django presentation layer arrives with the `django` package in 0.3.0. Removing the client layers
first keeps the change reviewable: this release is purely subtractive.

### What's new since v0.1.0

- **No JavaScript client layers** — the React/Next frontend and React Native mobile app are gone; the template targets a single Django monolith
- **Docker surface reduced** — frontend and mobile images are removed from the Compose stack
- **CI trimmed** — the two front-end test pipelines are deleted; the remaining workflows are re-pointed in 0.10.0

---

## v0.1.0 — 01/08/2026

**Status:** Baseline release — the repository becomes a reusable base template

### Summary

Opens the `<%PROJECT_SLUG%>-base` template track. The repository stops being a single delivered
project and becomes the scaffold other projects are generated from, so the root version track is
reset from `1.11.0` to `0.1.0` and the release documents are truncated to a clean baseline. The
pre-template 1.x history remains available in git history and is deliberately not back-filled here.
`.gitignore` is widened to cover the artefacts a template must never carry — generated test
reports, the resolved Python lockfile, worktree checkouts, and local tooling overrides.

### What's new

- **Template version track** — root semver restarts at `0.1.0`; sub-packages version independently from their own `0.1.0` baseline, per `project-management/docs/VERSIONING-GUIDE.md`
- **Clean release documents** — `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` now describe the template, not the project it grew out of
- **Wider `.gitignore`** — generated test reports, the Python lockfile, worktree checkouts, and local tooling overrides are excluded so a scaffolded project starts from a clean tree
