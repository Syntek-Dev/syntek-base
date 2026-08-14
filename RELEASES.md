# Releases — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 3.1.1 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v3.1.1 — 14/08/2026

**Status:** Patch — when an explanation misses because you did not have the background, the
answer now offers to teach you the background. One skill changed. Nothing you write changes.

### What this is

`/wait-what` is what you type when an answer did not land. It re-pitches the explanation in
plain language rather than repeating it louder.

Sometimes that is the whole fix. The answer was right but crammed, or it put the reasoning
before the conclusion. Re-pitching it is enough and the matter is closed.

Sometimes it is not. The answer missed because it assumed something you had never been told, or
leaned on a word this project has never defined for you. A re-pitch gets you through that one
reply. The next reply on the same subject will miss in the same place.

So on those two, and only those two, the re-pitch now ends with an offer: would you like to go
and learn this properly?

### What the offer looks like

Three things, in two lines at the end of the re-pitch:

- The topic, named as the folder it would live in under `learning/`.
- Whether you have started on it before — so it offers to pick it up rather than begin again.
- The first lesson, which is the exact idea that just failed to land.

That last one is the point. Working out which idea you were missing is most of the work, and the
re-pitch has already done it. Handing it straight over saves the teaching session doing it again
from scratch.

You are asked once per topic in a session. Say no and it drops the subject.

### It does not lose your place

Learning is a detour, so it is treated as one. Accept, and the session first writes its handover
note — where the real work had got to, what was half-finished, what came next — and marks it as
a teaching detour. You then open a fresh session, load that note, and learn.

Your work is still in that note afterwards. The lesson comes first; the work carries on from the
same file when you come back to it.

### If you have a project on 3.1.0

`copier update` brings the change. There is no migration, nothing to decide, and no command to
run. Your own code is untouched.

---

## v3.1.0 — 14/08/2026

**Status:** Minor — the tooling and the library versions underneath it are brought up to date,
all of it at once, and a new safety net catches a kind of change that used to arrive
unannounced. Nothing you write changes.

### What this is

The tools that run your checks — the ones that fetch your code, cache your packages, install
Python and Node, and scan for leaked passwords — had fallen behind. Some by a version or two,
one by six. This release moves every one of them to its current release in a single sweep, and
does the same for the package managers and the small set of tools that format and lint the
files.

Eleven tools in the pipeline, across thirty-one pipeline files. Plus pnpm, uv, and six
formatting and linting tools.

It also moves the libraries the project itself is built on — the web framework, the cache, the
background-job runner and the test tools — and the compiler used for the optional Rust parts.
And it adds a safety net for the next time any of that moves.

### Why all at once, rather than one at a time

A pipeline with a mixed toolchain is the awkward kind of broken. Half the jobs run on a current
foundation and half do not, everything looks green, and the first thing to fail does so in
whichever half nobody had looked at recently. Upgrading them together means the pipeline is
either right or wrong as a whole, and you find out immediately.

### Two of them had no version at all

Two steps were pointing at a moving target — one at whatever the author had most recently
published, one at a channel called "beta". Both are other people's code, running with the
permissions of your pipeline, and both could change without a single line changing here. Two
identical pushes a week apart could behave differently, and if something went wrong there was
no version number to report.

Both now name an exact release. If they change in future, it will be because someone here
chose to change them.

### What was checked before it shipped

The three checks that can run on this repository were run on the new tools rather than assumed:
formatting is clean across the whole tree, the documentation linter reports no issues in 735
files, and the code linter passes. The new formatter reflowed exactly one line in one file,
which is included here so it does not turn up unexplained in someone's next piece of work.

One thing is honestly untested: the API test runner crossed a major version, and its test suite
needs a full local stack that this template deliberately cannot build. Its settings were checked
against the tool's current documentation, which is not the same as running it. If you use the
API tests in a generated project, run them once after updating.

### The libraries underneath moved too

Six of the versions this project asks for were raised: the web framework, the cache client, the
background-job runner, and the three testing tools. These are minimums rather than choices —
raising one says "nothing older than this", it does not install anything by itself. What you
actually end up with is worked out when the project resolves its dependencies, so that was run
in full rather than assumed: 119 packages, all agreeing with one another.

### One version stops short of the newest, on purpose

The cache client is held at 6, not the 8 that is published. That is not an oversight. The
background-job runner refuses anything from 6.5 upwards, so 6.4 is genuinely the newest this
project can use — and asking for 8 produces no error at all. It quietly pulls the job runner
back to a much older release to make the two numbers fit, and everything carries on looking
fine. The reason is now written beside the version, so nobody has to rediscover it by breaking
something.

### The Rust compiler moved, and the minimum deliberately did not

For projects using the optional Rust parts, the compiler everyone builds with goes from 1.92 to
1.97. The oldest compiler the code will accept stays at 1.85 — and that gap is the point. They
answer different questions, and this project had been treating them as one. Raising the minimum
every time the compiler moves shuts out anyone on an older setup and gains nothing, because the
compiler is pinned anyway. Checked with the linter, the tests and the licence scan, all clean.

### A safety net for the next update

There is a way a template update can go wrong that produces no error whatsoever. It changes the
versions your project asks for, the update reports success, and the next time anything is
installed you get a different set of libraries than the one your tests last passed against. If
that breaks something, it breaks later, somewhere else, and it looks like your own bug.

The update preview now tells you first. It compares what the incoming template asks for against
what your project actually has, and separates two cases:

- **Blocking** — what you have cannot satisfy the new minimum, or a version moves far enough to
  break a build on its own. The update refuses to apply until you say so explicitly.
- **For information** — the numbers moved, but what you already have is fine. Nothing to do.

That separation is the whole reason it is worth having. Minimums move in almost every release,
so a warning that fired on all of them would be ignored inside a month. This one fires only
when the update can genuinely change what you build.

One thing to know: a guard only protects the updates that come after it. This one arrives in
3.1.0, so an update from 3.0.0 or earlier is the last one you take without it.

### One command for dependencies, instead of three

Python, JavaScript and Rust each have their own tool for moving a dependency, and each means
something slightly different by it. There is now one script covering all three. On its own it
reports what is out of date and changes nothing; asked to, it updates everything, one language,
or a single package:

```bash
bash code/src/scripts/dependencies/update.sh                            # what is out of date
bash code/src/scripts/dependencies/update.sh --apply --package django   # just the one
bash code/src/scripts/dependencies/update.sh --apply                    # everything
```

The dependency-update guide now points here rather than at the three separate tools.

### If you have a project on 3.0.0

`copier update` brings the new pipeline files, the new tool versions and the new minimums. There
is no migration and no decision to make, and your own code is untouched.

There is one extra step this time, because the versions moved. After updating, re-resolve and
run the tests before you commit:

```bash
bash code/src/scripts/dependencies/update.sh --apply
bash code/src/scripts/tests/all.sh
```

A version that moved on its own is a claim nothing has checked yet.

---

## v3.0.0 — 14/08/2026

**Status:** Major release — breaking. The agent folder is gone. Everything it did is still
here, under a different name and reached a different way.

### Read this first if you have a project on 2.x

`.claude/agents/` no longer exists. If you never wrote an agent of your own, there is nothing
for you to do — `copier update` removes the files it put there and the update is clean.

If you **did** write one, the update will tell you. It prints a list of the definitions it
found, and where each one would go if you want to keep it:

```text
▸ v3.0.0 migration — agent definitions the template does not own

  1 agent definition(s) remain in .claude/agents.
  The template no longer reads this directory — nothing routes to these files.

    .claude/agents/invoice-chaser.md    -> .claude/skills/invoice-chaser/SKILL.md
```

**It only tells you.** Nothing is moved, rewritten or deleted, and it cannot make your update
fail. That is on purpose: turning an agent into a skill is a rewrite rather than a rename, so
a tool that moved the file for you would hand you something that does not pass the project's
own checks and call the job done. The step-by-step is in `14-UPDATING.md`.

### Why the folder went

There were two ways to describe the same job, and they had drifted apart. An agent was
something you had to name before it would run. A skill starts itself when the work matches
what it says it does. Keeping both meant writing every remit twice, and the second copy was
reachable only by asking for it — so nobody read it, and nobody noticed when it went stale.
Two of them had been telling a Django project to use React hooks.

So the second copy is gone, and the descriptions did the work instead. That is the whole
change: you stop choosing a specialist and start describing the job.

### Nothing was thrown away without checking

Before the folder was deleted, every path, tool and identifier mentioned anywhere inside it —
697 of them — was checked to see whether it was written down anywhere else. Five things were
not, and each was given a proper home first: the per-route rate limits, the rules for who may
see personal data, the security standards an audit is marked against, and the list of
libraries the export feature uses, which now has its own guide.

### What else is in this release

- **A `skills:` name that pointed nowhere used to fail in total silence.** The skill simply
  never arrived and nothing said so. There is now a check for it, and it covers the case where
  a name is valid here but would be missing in a project built without the mobile, Rust or
  desktop surface.
- **The template could not generate at all**, and had not been able to since v2.4.0 — one
  stray character in a script broke it, and the check meant to catch that class of fault was
  looking for the wrong shape and reporting everything fine. Fixed, and the check now proves
  it can spot the fault before it says the tree is clean. Several other checks were given the
  same treatment.
- **A security scan that had never actually scanned anything.** It was passing an option that
  does not exist, and the tool responded by doing nothing and reporting success. With that
  removed it found 36 real advisories, 32 of which are now fixed.
- **The test pipeline is green again** after a fortnight of red that had nothing to do with
  the tests — the database was fine throughout, and only the thing checking on it was broken.
- **Your project's memory starts empty.** New projects had been inheriting eleven notes from
  this template's own development, in a file every session reads as authoritative before doing
  any work. It now arrives blank, and once you have written in it an update can never overwrite
  what you put there.

---

## v2.21.0 — 12/08/2026

**Status:** Minor — versioning doctrine gains the declaration everything else rested on. No
application behaviour changes.

### The rule that made every other versioning rule undecidable

Semantic Versioning's first rule is not about numbers at all:

> Software using Semantic Versioning MUST declare a public API.

This repository had never declared one. `VERSIONING-GUIDE.md` said MAJOR was for "breaking
changes to the public API" — a sentence with no referent, which is worse than saying nothing,
because it reads as settled. Two people could bump the same diff differently and neither could
be shown wrong.

The gap was not theoretical. A decision was already pending on it: the epic that deletes
`.claude/agents/` is ruled a major bump, and nothing in the tree could say why that qualified
when a hundred other changes had not.

### Two declarations, because there are two products

The correction is not one paragraph in one file, because this repository is a template and the
thing it generates is not the same thing.

- **A generated project** declares its `/api/` contract, the schema as reached through it,
  indexed public URLs, and the `/mcp/` tools. Templates, design tokens, internal service
  signatures and operator tooling sit outside — changing them cannot break a consumer. That
  table ships in `VERSIONING-GUIDE.md`, with a `TBD` marker so it is settled per project rather
  than inherited unread.
- **syntek-base itself** declares the template contract: the Copier questions and tokens, the
  generated tree's shape, and the `.claude/` routing contract `copier update` re-applies. That
  lives in `CONTRIBUTING.md`, which Copier excludes — a statement about `copier.yml` shipped
  into every generated project would be meaningless there.

Putting both in the shipped guide would have been the obvious move and the wrong one.

### What else was missing

Five rules the guide had no answer for, each applied to real surfaces rather than restated:
`0.y.z` and when `1.0.0` is earned (the trigger is being **depended on**, not shipping to
production); the pre-release and build-metadata grammar, including the trap that build metadata
is ignored entirely and therefore cannot distinguish two releases; precedence; deprecation —
deprecate in a MINOR, leave it at least one full minor, remove in the next MAJOR, because the
removal is the breaking change but the **surprise** is the avoidable part; and recovery from a
release that turns out to be incompatible, which is a new compatible MINOR and never a moved tag.

`GIT-GUIDE.md` gains the other half: how a commit _says_ it breaks something. The repository has
used Conventional Commits on every release without either the `!` shorthand or the
`BREAKING CHANGE:` footer appearing anywhere in the tree.

### Two smaller corrections

The increment table existed twice and had already drifted — the guide qualified MAJOR with "or
data schema", the `global-workflow` skill did not. The copy is deleted rather than corrected; a
summary restating an authoritative table is a drift site, not a convenience.

And the README version badge had been showing 2.19.0 since the 2.20.0 release. The guide names
the badge and the footer as two separate updates; one moved and the other did not, and nothing
failed. It is fixed here, which is the sort of thing a declared contract makes noticeable.

---

## v2.20.0 — 11/08/2026

**Status:** Minor — one guide split into an index and four sub-documents, and the gate beside
it widened to match what the tooling actually accepts. No application behaviour changes.

### A gate that stated a house choice as somebody else's rule

`SKILL-AUTHORING.md` said that keys outside the six specification fields fail validation, and
`skill-conformance.sh` enforced it. The sentence was false. Claude Code accepts documented
extensions of its own, and three of this repository's shipped skills already used fields
outside the two the guide claimed were authored here.

The distinction matters more than the correction. Three claims were being carried as one: the
specification defines six fields; the tooling accepts more than six; and this project declines
most of the extras **by choice**. Only the third is ours to argue with, and stating it as an
external rule meant nobody could. The gate now admits the two specification fields plus four
runtime keys that place a run — `context`, `agent`, `background` and `model` — and declines the
rest openly, with the reasoning in a file a reader can disagree with.

### The evasion underneath it

The key check matched unquoted keys only. A skill carrying `"allowed-tools":` — one pair of
quote characters — reported fully clean. Found by writing probe skills to force each clause
rather than reading the code and believing it, which is also how the rest of this release was
verified.

### What the split bought

The incoming doctrine — the fork rubric, the fork-target policy, the reopening test, the
reference/task distinction — did not fit the 58 lines the guide had spare under the 300-line
cap. It now sits in four sub-documents with the guide as a thin index: the same shape
`tooling-guide/` and `ai-dictionary/` already use.

Three rules came out of measuring rather than deciding. **One remit, one skill** — a declared
skill/agent pair is two entries competing for one job. **A description is a claim that it
discriminates** from its near neighbours, and the claim is checkable. And a **`skills:` list is
load-bearing**: a reference skill shadowed by its task counterpart placed second in every
measured case, so it is reached only by being named — and a task skill that omits it stops
receiving the conventions with nothing failing loudly.

### Attribution, measured rather than asserted

Both upstream sources are credited in the same change as the rules they inform. The Agent
Skills specification is Apache-2.0 and derivable with attribution; Claude Code's documentation
carries no `LICENSE` file, so its facts are usable and its wording is not.

The check is a five-gram overlap measurement, and it is recorded as a step rather than a claim
because the first draft failed it: a nine-word clause had travelled from a research note, where
it was correctly marked as a quotation, into a shipped guide with the marking gone. Re-authored,
and now at zero shared five-grams against both sources.

## v2.19.0 — 11/08/2026

**Status:** Minor — one new audit script and its CI job, plus the index and orientation
corrections it exists to keep true. No application behaviour changes.

### A rule nothing checks decays between releases

Three ADR numbers were cited as real across six files for a week before anyone noticed there was
no ADR register behind them. A manual sweep found nine phantom citations; thirty more survived it.
The rule itself was never in doubt — a file that ships is read in a project that is not this one,
so it may cite only what that project is guaranteed to have — but a rule held by attention alone
is re-broken by the next release that adds a guide and an index row in the same change.

This is the class made mechanical. A shipped file may cite **layering-system artefacts** —
`CONTEXT.md`, `CLAUDE.md`, `docs/`, `workflows/`, scripts, guides — and never a **per-project
instance**, because a generated project has different ones at those numbers or none at all.

### `doc-references.sh`

Two fail clauses, run over tracked **and** untracked-but-not-ignored `.md` and `.sh` files, the
same scope `check-template-tokens.sh` settled on for the same reason: the file you have just
written is the one most needing the check, and it is not tracked yet.

- **Dangling path** — a backticked repository path that does not exist.
- **Instance citation** — an `ADR-###`, `US###`, `SPRINT-##`, `MAP-*`, `PLAN-*`, `BUG-*` or
  `QA-*` artefact named as though it were a real document.

`.github/workflows/audit-doc-references.yml` runs it on every push and pull request, with the
report uploaded as an artefact. It carries no path filter: any file can carry a citation, and
scoping the gate to a subset would recreate the blind spot it exists to close.

### What it deliberately does not look at

A gate that fails on correct work is discarded, so most of the script is scope rather than
detection. History records what was true then, and is exempt. `how-to/src/TEMPLATE-GUIDE/` is
copier-excluded and has to be able to name a broken citation in order to log one. `handoffs/` and
`.copier/` are staging; vendored documentation is not this repository's to fix. `copier.yml` is
parsed for the paths Copier seeds at generation, so those resolve here even though they are absent
until a project exists — and a new seed needs no edit to this script.

Two resolutions do the rest of the work. Relative citations resolve against the **citing file's**
directory, because a `../` reference means something different in every file that writes it and
resolving them all from the root invents failures. The house shorthand, which names a script by
its group alone, resolves against `code/src/scripts/`; without that, every shorthand reference is
invisible and the check passes silently.

Finally, a naming **pattern** is not a citation. A table showing the format in one column and a
worked example in the next, a line marked `e.g.` or `[EXAMPLE]` — both demonstrate a convention.
For the one case neither rule reaches, a document quoting a path in order to ban it,
`doc-references: ignore` on the line or the one above suppresses it.

One implementation detail is load-bearing: the script assembles the two Jinja delimiter pairs at
runtime. Copier renders it into every generated project, and a literal pair anywhere in the file
would end generation with a `TemplateSyntaxError`.

What it cannot check is whether a path that resolves is the **right** one, or whether a count
stated in words is true. Both stay reviewer judgement, exactly as `shipped-readme.sh` already says
of its own blind spot.

### The indexes it proves

The root `REFERENCES.md` now carries rows for `code/docs/MANAGEMENT-COMMANDS.md`,
`code/docs/MOBILE-CODING-PRINCIPLES.md` and `how-to/src/STORE-LISTING.md` — this cycle's three new
guides, all of which exist on disk before the row claims them — and has lost the ADR citation the
new rule forbids.

The root `CONTEXT.md` had drifted in the way an orientation file drifts: nothing in it was written
carelessly, and the repository moved underneath it. "There is no separate frontend or mobile
application" was true when the stack became Django-only and false the day the mobile surface
shipped. It now states the monolith rule for the web and names the three optional surfaces —
`code/src/mobile/`, `code/src/rust/`, and the Slint desktop app inside it — as separate
deployables consuming the same API. The tree gains `.copier/`,
`code/src/improvement-architecture/`, `LICENSE`, `SECURITY.md` and `CONTRIBUTING.md`, and `.mcp.json`
is described as the three servers it actually configures.

### A gate that never ran, claiming to be the only one that did

`syntax-python.yml` carried a header stating its three jobs "work in the base template and in a
generated project alike. That is also why they are the only Python gate this repository actually
enforces on itself."

The lockfile half is correct: they run `uv sync` without `--frozen`, so no committed lock file is
needed. The conclusion drawn from it was wrong, because the blocker sits one step earlier. In
syntek-base the root `pyproject.toml` still names the package with the unrendered project-slug
token, and uv rejects that as an invalid package name while **parsing the manifest** — before
dependency resolution begins. Every job fails at the sync step and every step after it is skipped.

The header now says that plainly, and says what follows from it: in this repository ruff is
enforced by the directly-installed binary, which parses no manifest, and that is what to cite as
evidence for a Python rule — never CI. A generated project, where the name is rendered, is
unaffected. The contrast that makes the cause legible is recorded too, because it was verified
rather than assumed: pnpm skips name validation on a private package, so the identical token is
harmless in `package.json` and fatal in `pyproject.toml`. One tokenised name is not evidence about
another.

### What the cycle leaves on the table

`TEMPLATE-GAPS.md` now carries seven findings from this cycle and closes two. The closures are
both citation gaps, closed by the rule the audit above enforces. The seven that stay open are
worth knowing about: the routing half deferred because the agent tier is being retired; merge
markers that passed every gate for two releases because Prettier had reformatted them into valid
Markdown; the `/mcp/` surface having no error-taxonomy row; the ruff jobs above, accepted as a
known limitation rather than fixed; the two research notes that cannot be deleted with their epic
because `README.md` cites them as licence evidence; retiring the ADR machinery template-wide,
measured at 74 actionable files; and the mobile tree's sub-directories carrying no
`CONTEXT.md`/`CLAUDE.md` pair, which `docs-pairing.sh` structurally cannot see because it iterates
over the files that exist.

`research/SKILLS-VS-SUBAGENTS.md` picks up a third round and the licence verdict its epic's gate
needs. The findings that matter beyond that epic: an invoked skill body stays in the conversation
for the **session** rather than the turn, and this project disables auto-compaction, so the
documented re-attach budget never fires and invoked bodies accumulate until `/handoff`. On
licences — the Agent Skills specification is Apache-2.0 and derivable with attribution, Claude
Code's documentation carries no LICENSE file, so its facts are freely usable and its wording must
be re-authored, and nothing share-alike is involved, so no obligation propagates into a generated
project.

## v2.18.0 — 11/08/2026

**Status:** Minor — one base class, one lint ban, one new guide. The template ships no
management commands yet, so nothing existing changes behaviour.

### The second surface with nothing to carry the meaning

The three error classes — programmer, user, environment — have been settled since `apps/core`
landed. On an endpoint, HTTP carries them: a 500 and a tracker event, a 4xx the caller can act
on, a 503 a client should retry. The distinction costs nothing to make, because the framework
already has a vocabulary for it.

A management command has none of that. It has an operator reading stderr and, if anything is
watching, an exit code. Left to each command, that mapping gets made once per command, slightly
differently each time — and the drift is invisible, because every version of it runs.

### What the base class decides

`ManagementCommand`, in `code/src/django/apps/core/management/base.py`, makes it once:

| Raised inside the command | Operator sees                      | Exit |
| ------------------------- | ---------------------------------- | ---- |
| `ServiceError` subclass   | one line on stderr                 | 1    |
| `DependencyUnavailable`   | one line on stderr                 | 75   |
| `InvariantViolation`      | the traceback, and a tracker event | 1    |

The classes are distinguished by **type**, not by exit code. Only one code carries meaning:
**75**, `EX_TEMPFAIL` from BSD `sysexits.h`, because it is the only distinction anything
downstream acts on — a scheduler retries on it and must not retry on the other two. That is the
503-versus-500 split, in the vocabulary a shell has. A code per class was rejected: nothing
would read it, so it would go wrong silently.

`InvariantViolation` is the one the base class does **not** touch, and that is the deliberate
part. A traceback is the correct output for a programmer error — it is the one signal saying
"this is a bug in the code, not in what you typed", and it is what carries the register key to
the tracker. Catching it to print something tidier is the friendly-4xx failure in a different
medium.

### The ban is what makes it a rule

Subclassing Django's `BaseCommand` directly still works. The command runs, the tests pass, and
the only difference is that a broken invariant now looks like every other traceback and a
transient outage exits 1 like a typo. Nothing fails until something needed to tell them apart —
which is precisely the class of defect review does not catch and a linter does.

Ruff `TID251` now bans both `django.core.management.base.BaseCommand` and the
`django.core.management.BaseCommand` re-export, since banning one path only would leave a
one-word bypass. `pyproject.toml` exempts exactly one file: the base class itself. Same
mechanism, for the same reason, as the existing `ninja.Schema` ban.

### argparse parses; parsing is not validation

`code/docs/MANAGEMENT-COMMANDS.md` owns what a command line has and a queue does not — an
operator, a shell, and an exit code — and routes everything the two surfaces share back to
`code/docs/TASK-AUTHORING.md` rather than restating it.

Arguments are untrusted input, not because the operator is hostile but because `type=int`
proves a string was numeric and says nothing about whether minus one, zero or forty million is
a number this command may act on. An identifier off the command line is exactly as unverified
as one off a URL; IDOR does not become acceptable because the caller had a shell. And there is
no `request.user`, so identity is an argument and it is data: a command that writes an audit row
takes the actor explicitly and verifies it, rather than inferring it from the Unix user or from
whoever is deploying.

The failure that actually happens, though, is not a hostile value but a plausible one.
**Blast radius is the argument nobody passes** — a missing `--since`, a typo'd `--limit`, a
filter that matched everything. So anything destructive takes `--dry-run` and reports what it
would do; bounds are declared rather than discovered; and the confirmation prompt is not the
safety, because `--noinput`, a pipe and a scheduler all skip it.

### One connection rule, now solved for you

Django closes database connections in `run_from_argv`. `call_command()` never reaches that
cleanup — so a command invoked from a task, a test, or another command inherits whatever
connection state its caller left, and the symptom is an intermittent `InterfaceError` after an
idle period, in production only.

`ManagementCommand.execute()` closes on entry and exit, which is what makes the two invocation
paths equivalent. `code/docs/PROCESS-MODEL.md` now records that one of its three no-request
surfaces has this handled structurally, and that a task and an MCP tool still carry it
themselves.

### The sibling surface, and the class it does not have

`code/docs/TASK-AUTHORING.md` gains the same taxonomy expressed the way a queue can express it —
permanent versus retryable — and its **user-error row is empty on purpose**. A task has nobody
to tell, so an argument it cannot act on was put there by code: a programmer error, even where
the identical value arriving on an endpoint would be a 422. The user error, if there was one,
happened at enqueue time on the surface that had a user, and was either caught there or never
checked. A task that validates and then returns quietly converts a bug into a silent no-op.

The two guides now name each other, which is the point of shipping them in one change: the same
three classes, spent on retry classification in one place and exit codes in the other.

## v2.17.0 — 11/08/2026

**Status:** Minor — three new files in the Django project, their governance pairs, and one new
entry in the edge contract. Every generated project gains them at baseline; nothing existing
changes behaviour, because nothing loads them until the first page does.

### The error surfaces come first, not last

A project generated from this template has no routes, no base template and no stylesheet. What it
does have, from the moment the first view raises, is failure — and until now every one of those
failures rendered Django's own debug-off default, or in the HTMX case rendered nothing whatsoever.

Three surfaces close that, and they ship together because they are one mechanism rather than three
files that happen to be about errors. The 500 page needs a correlation identifier; the identifier
cannot arrive by the obvious route; and the HTMX handler that shows a failure at all cannot assume
the page it is running on has anywhere to put one.

### The page that is rendered with nothing

`code/src/django/templates/500.html` needs no view and no URL entry — Django resolves it by name,
which is why it works on a project with no routes.

Django's own documentation settles how it is rendered: the default 500 view "passes no variables to
the `500.html` template and is rendered with an empty `Context` to lessen the chance of additional
errors". Two things follow, and both are easy to get wrong because the happy path never exercises
them.

A context processor cannot reach the page, because context processors run only for a
`RequestContext` and there is no request. And `{% extends %}` is a trap rather than a convenience:
a base template that reads `request` for navigation, the user or a CSRF token renders **blanks**
rather than failing — the exact silent failure `code/docs/NEGATIVE-SPACE.md` exists to close, on
the one page a user only reaches when something has already gone wrong. So the page extends
nothing, carries no CSS, and says nothing about what broke.

The identifier therefore arrives through a simple tag. `{% request_id %}`, in the new
`code/src/django/apps/core/templatetags/core.py`, takes its value from the `ContextVar` in
`code/src/django/apps/core/middleware.py` rather than from the context it is rendered with. One
reader, every rendering path: the 500 page, an HTMX error partial, and any ordinary view. Outside a
request it returns an empty string and the template shows nothing, which is the right answer — a
stale identifier from an unrelated request finds the wrong tracker event, and is worse than none.

### A swap that shows nothing, and the two corrections

HTMX swaps on 2xx only. Without a handler, a 500 replaces nothing at all: the indicator stops, the
page is unchanged, and the user re-clicks the button that just failed.
`code/src/django/static/js/observability.js` is the fix — one `htmx:beforeSwap` /
`htmx:sendError` listener pair on `document.body`, global rather than per element, because the view
nobody expected to fail is the one that will.

Two departures from the obvious version, both of which the guide previously got wrong in print:

- **The region is created, never assumed.** `document.getElementById("error-region")` is `null` on
  any page that has not defined one, and a swap into `null` fails silently — reproducing precisely
  the defect the handler exists to close. It is created with `role="alert"`, because the user has
  just acted and nothing else on the page has changed.
- **A 5xx from the edge is not a fragment.** The application returns a rendered partial; Nginx
  returning 502 or 504 returns a complete HTML document, and swapping one into a `div` nests a page
  inside a page. Neither the status code nor the content type separates them. The doctype does.

htmx's own `isError` flag is left alone on purpose. Clearing it would suppress the console error,
and a handler that makes a failure quieter while claiming to make it visible is worse than no
handler.

### Two directories that were empty on purpose, and are not any more

`static/` and `templates/` each held a `.gitkeep` and nothing else, because everything that
normally lives there — the base template, the token stylesheet, the components — depends on design
work a generated project has not done yet.

That reasoning still holds, and these three files are the narrow exception to it: each carries a
correctness rule rather than a design decision, so none of them is waiting on the visual direction
or the brand voice. Both trees now have a `CONTEXT.md` / `CLAUDE.md` pair saying so, along with
what is deliberately absent: no client-side build, no `css/` token layer, no vendored HTMX or
Alpine, and no `400/403/404.html`, because Django's defaults are adequate until there is a base
template to inherit from.

### The 503 is the edge's, and that is decided here

`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` gains entry 14 in the same change as the 500
page, because the boundary is only legible when both sides are written at once.

Django defines a handler and a template name for 400, 403, 404 and 500, and none for 503 — there is
nothing to override. The decisive argument is not that one, though: a 503 is returned exactly when
the application process is **not answering**. A deploy, a crash, a restart, an exhausted worker
pool. A Django template cannot be rendered by a Django process that is down, so this page can only
ever be a static file the edge holds. It is the one point in the error taxonomy where the build side
genuinely cannot express its own class, and the entry records what the deploy repository owes:
served from disk for `error_page 502 503 504`, `Retry-After` where the window is known,
`X-Request-ID` if the edge minted one, never cached, and no asset references — the static tree is
served by the upstream that is failing.

### What is not built yet, written down

`code/docs/FRONTEND-CODING-PRINCIPLES.md` gains a _What is not built yet_ section, the web peer of
the one `code/docs/MOBILE-CODING-PRINCIPLES.md` already carried, and for the same reason: an absence
nobody wrote down is indistinguishable from an oversight, and gets rebuilt slightly differently by
whoever notices it next.

The base template, the `#error-region` div, the HTMX error partial, the `<script>` tag that would
load the handler, and the token stylesheet — each listed with the reason it waits, and
`code/src/scripts/development/new-django-view.sh` already refuses to run without the first of them,
which is what makes it the row that unblocks the rest.

One consequence is worth knowing before you read a green run as evidence. The `htmx-handler-absent`
clause in `code/src/scripts/audits/negative-space.sh` keys on a template using `hx-`, so it is a
no-op in a repository with no templates using it. The handler is shipped and unproven by that gate;
ruff, ESLint and Prettier are what hold it today, and the first HTMX page is what switches the
clause on.

## v2.16.0 — 11/08/2026

**Status:** Minor — two new guides, a new conditional release gate, and an honesty pass over the
discoverability family. Both new files are mobile-only and absent from a web-only project.

### The third destination

`DISCOVERABILITY.md` has always named three places this product is found: search engines, answer
engines, and app-store search. The first two turned out to be one job — Google states that
appearing in AI Overviews and AI Mode needs no optimisation beyond ordinary indexation — and the
third was left with a line admitting it was not covered here yet.

It is a different job because it is a different artefact. Store search matches **listing metadata
inside a length budget**, not a crawled page, and nothing in the `<head>`, the JSON-LD block, the
root files or the page body reaches it. It also belongs to a **different deployable**: the four
existing sub-documents govern outputs of the Django project, and this one governs App Store
Connect and the Play Console entries for `code/src/mobile/`.

`code/docs/discoverability/APP-STORE.md` now owns it — the fields, what each is for, and the
vendor page each limit was read from, each with a `Verified:` date. Google Play's release-notes
limit is deliberately **absent** from that table: the cited pages do not state the figure, and the
guide carries no number it has not read from a primary source. Read it off the Play Console field
and record it beside the project's own listing.

### Apple counts bytes; nearly every source that tells you otherwise is confident

Apple, on the keywords field: _you can provide up to **100 bytes** of content_. Google, on all
three of its fields: character limits apply at any character width.

These are different units, and almost every third-party ASO source states Apple's as "100
characters". For an ASCII listing the two coincide, which is exactly why the error survives
unchallenged. They diverge the moment a listing is localised — in UTF-8 an accented Latin
character costs two bytes and most CJK characters cost three — so a keyword set that measures 100
characters can be rejected at a third of its apparent length. Count with
`len(text.encode("utf-8"))`, never `len(text)`.

The guide states this for the same reason `discoverability/CONTENT-STRUCTURE.md` Section 1 disposes of
the answer-engine myths: the wrong figure is not merely missing from this repository, it is
circulating everywhere a developer would go to check.

### The rule, its register and its gate, in one change

Doctrine on its own is a document nobody opens twice. Three files ship together here.

`APP-STORE.md` holds what is true of every project shipping to these stores, including three rules
that are routinely got wrong: `app.json` `expo.name` is the name **under the icon**, not the store
listing name, and a divergence between them is a decision rather than a default; keywords are
never spent on the app or company name, because both are already indexed and naming a competitor
is a rejection risk; and the description is plain text, so markup written into it ships as literal
characters.

`how-to/src/STORE-LISTING.md` is what **this** project actually says — a value and a used-count
per field, beside the budget it has to fit. A blank cell is an unanswered question, not a default.

`project-management/workflows/23-release/` makes it a release gate, and a conditional one. The new
Step 2 fires only when the release moved `code/src/mobile/`; a root-only bump reaches no store, and
a project without the mobile surface never meets the condition. The What's New row is
**overwritten, not appended** — this register records what the store says now, and the history
already has a home on the mobile sub-package's own track.

### Who owns the words

The `mobile` agent, not `seo`. Store search has no web counterpart and `seo` is scoped to the
Django marketing pages, so the listing's text fields sit with the surface that ships them. The
imagery stays with `code/docs/visual-design/MOBILE.md` and the privacy declarations with
`project-management/src/09-GDPR/`.

`how-to/src/BRAND-VOICE.md` places store copy as a **third** thing that is not a fifth register,
listed separately from SEO metadata rather than folded into it. Both are marketing under hard
constraints, but the constraints are not the same shape: a byte budget runs out two to three times
sooner than a character count predicts, and a rule that hides inside another rule's bullet is a
rule someone will apply with the wrong arithmetic.

### How much of this a machine can check

Writing the fifth guide forced the same question at the other four, and the answers turned out to
differ sharply — so each sub-document now ends with the section rather than the family stating it
once. `STRUCTURED-DATA.md` is nearly all test coverage. `WEB-METADATA.md` and `ROOT-SURFACE.md`
can check the shape of the output but not the words. `CONTENT-STRUCTURE.md` and `APP-STORE.md` can
check almost nothing — one field in `app.json`, and not the important one.

Two facts come out of that, and the second is the one that bites. **No audit in
`code/src/scripts/audits/` covers this family, and none is planned:** these rules are properties of
rendered pages, and `code/src/django/apps/` ships empty, so a script written today would report
success having examined nothing — worse than no script, because a green result is believed. And
**a clean pipeline says nothing about whether any of this was honoured**: the gate that does exist,
`12-seo-checks`, runs before any code, so it reviews a plan rather than a page.
`project-management/docs/SEO-CHECKLIST.md` now says so at the top of the checklist.

The honest half is stated too. A `Product` block with valid syntax and invented review counts
passes every structured-data test and is a manipulation. A `Host`-derived canonical renders
correctly, looks correct in a browser, and hands a proxied copy of the site the right to call
itself the original — which is why the checkable half of `WEB-METADATA.md` is the half worth
testing: it is the half that fails silently.

### A step that stopped pretending

The same principle, applied where it was overdue. Release Step 5 printed
`bash code/src/scripts/deployment/deploy.sh` with a footnote conceding the script is planned. The
directory is a scaffold, so the step now stops and says the workflow has no command to give you —
hand the tagged, tested release to whoever owns the target environment and record the deployment
once it is done.

## v2.15.0 — 11/08/2026

**Status:** Minor — a new audit, its CI job, the register column both key on, and the mobile
modules they measure. No breaking change.

### A register kept true by good intentions

2.7.0 made negative space a named discipline: `code/docs/NEGATIVE-SPACE.md` owns what an invariant
is and the one-enforcement-point rule, `how-to/src/INVARIANTS.md` is this project's answer sheet.
The file said what must never be true. Nothing checked that the code agreed.

Half of it had a partial check — a `Meta.constraints` entry with no row, and a row naming a
constraint that does not exist. The other half rested entirely on the same-change rule: write the
guard, write the row, in one commit. That is a discipline, and disciplines are exactly what a
register exists to replace. A guard added without a row is invisible to everyone who reads the
file next, and a row whose key nothing raises is a claim the repository has quietly stopped
honouring.

The obstacle was never the checking. It was that a key living in prose beside a worked example is
not something a gate can read.

### `Key` is a column now

The register gains a sixth column holding the row's identifier and **the exact string the guard
raises** — `InvariantViolation("order.total_matches_lines", …)` on one side, the same characters
on the other. A pure `db-constraint` row carries `—`, because a constraint name is already its own
identifier.

`negative-space.sh` correlates the two by name, in both directions, on both surfaces. Nine
`[gate: fail]` clauses: a constraint with no row and a row with no constraint; a key raised
nowhere, a key raised with no row, and a key raised at two sites; the register deleted while there
is still something to register; a template using `hx-` with no global `htmx:beforeSwap` listener;
`RequestIDMiddleware` gone from `MIDDLEWARE`; and one of the mobile compiler flags loosened. One
`[gate: warn]`: the worked example still sitting beside real rows.

Two things it will never decide, and both are marked `[judgement]` in the rule rather than left to
be discovered. It matches **names**, so a row can point at a function guarding something else
entirely and stay green. And nothing can grep for a rule nobody wrote down — which is the failure
mode the whole guide exists for.

Two rules are deliberately **not** re-enforced here. `assert` outside tests belongs to ruff `S101`
and the `ninja.Schema` import ban to `TID251`; both already have a real analyser, and two enforcers
of one rule drift.

### The green run that has measured almost nothing

Four of the nine clauses are no-ops in a baseline repository. `apps/` carries no models, the
templates and static trees are empty — so an ordinary run passes having looked at nothing, and
keeps passing after the detector breaks.

So `--self-test` runs **first** in CI, and it is the reason the job is worth having. Every clause
runs over `code/src/scripts/audits/fixtures/negative-space/`: `broken/` must trip every fail
clause, `clean/` must trip none. The known positives carry one violation each —
`broken/services.py` raises an unregistered key and raises a registered one twice,
`broken/settings.py` omits the middleware from `MIDDLEWARE` while naming it in the module
docstring, `broken/page.html` posts with `hx-post` and handles nothing.

Two fixtures do more than that. `broken/INVARIANTS.md` closes with a worked-row section whose rows
must never be parsed, so a `constraint-absent` count of exactly one is the proof the register is
read section-aware rather than line by line. And `clean/guard.test.ts` and
`clean/tests/test_guard.py` construct unregistered keys **on purpose**, exactly as a real guard
suite does, so the self-test starts failing the moment test code stops being exempt.

Missing fixtures exit 2. A deleted fixture tree fails loudly rather than quietly disarming the
gate.

### The mobile surface gets something to check

`ts-flags-loosened` and the `client-guard` clauses measure files that did not exist, so they ship
here too.

`code/src/mobile/tsconfig.json` turns on the four flags beyond `strict` —
`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitReturns`,
`noFallthroughCasesInSwitch`. Neither `strict` nor `expo/tsconfig.base` implies any of them, so
the baseline was one flag deep and looked like four. Each bans a state rather than a style, which
is the test for adding a fifth. `noUnusedLocals` and `noUnusedParameters` are declined for the
usual reason: ESLint owns that rule already.

They are the single-config deletion class — `tsc` exits 0 without them, so a flag weakened to clear
a build is invisible in every other gate. That is precisely what the audit leg is for.

`lib/invariant.ts` carries `InvariantViolation`, named to match the backend exactly so one
`On breach` column reads the same on both surfaces, and `unreachable(value, key)`, which fails
typecheck at every unhandled call site and throws a keyed error when the API sends a union member
the app has never seen. `lib/error-classes.ts` classifies failures: `408`, `502`, `503` and `504`
are **environment** errors despite three being 5xx, because each is the edge reporting that the
process is not answering — a rolling deploy's restart window is not a fleet of defects. Anything
else in the 5xx range is the server's programmer error, not the app's, and an unrecognised failure
defaults to programmer error, because defaulting the other way silences the failures nobody has
thought about yet.

Both live in `lib/` and not `app/`, because expo-router would publish a helper under `app/` as a
navigable screen. `jest.config.js` adds the tree to `collectCoverageFrom` in the same change —
without that line the modules are invisible to the coverage floor and the run stays green having
measured nothing, which is the same defect twice in one release.

### Where the doctrine came from

The idea is TigerBeetle's TigerStyle, by way of ThePrimeagen's name for what Hoare simply called
logic: state what must never be true, enforce each invariant at one named point, fail loudly rather
than degrade. The `README.md` influences table gains the row and `THIRD-PARTY-NOTICES.md` records
the measurement — **0.0% five-gram overlap** against both `code/docs/NEGATIVE-SPACE.md` and
`how-to/src/INVARIANTS.md`, measured rather than assumed.

Its assertion mechanism is deliberately not adopted, and the reason is worth keeping: Python's
`assert` is stripped by `-O` and an `AssertionError` cannot carry the register key, so it reaches
the tracker naming nothing. Guards `raise`.

The rule is that attribution is written alongside the doctrine it credits rather than
retrospectively. This is that rule being kept.

## v2.14.0 — 11/08/2026

**Status:** Minor — two MCP servers wired, one map seeded at generation, two nested ignore files.
Everything else is citation repair across the tree, done by hand.

### A citation is a promise the reader will test

A file that ships is read in a project that is not this one. So it may cite only what that project
is guaranteed to have: the layering system — `CONTEXT.md`, `CLAUDE.md`, the `docs/` guides, the
workflows, the scripts. Those exist everywhere, by construction.

A per-project instance does not. A decision record, a story, a sprint, a feature map, a plan — a
generated project has different ones at those numbers, or nothing at all at that number. Naming the
**pattern** is fine, and stays fine: "take the next free number" describes a format. Naming a
specific one as though the reader can go and open it is a broken promise, and the reader who tries
learns that the documentation is not to be trusted, which is a far more expensive lesson than the
one they came for.

This release makes that rule true everywhere it applies.

### The phantom decision records, closed by deciding

2.13.1 shipped with these logged and untouched, on purpose: three decision-record numbers cited as
real across six files with no register behind them, and a note saying that choosing between writing
the records and dropping the citations was a decision rather than a tidy-up.

The decision went the other way from writing them. **This project does not use ADRs at all**, and
`.claude/MEMORY.md` now records that as project- and template-wide. Decisions are recorded where the
work already lives — the feature map, the story plan, the nearest `CONTEXT.md` glossary, a
`research/` note.

The trigger was narrow and then generalised. `project-management/src/14-DECISIONS/` is not
copier-excluded, so an ADR written here about the template's own tooling would ship into every
generated project as a decision that project never made. That alone rules the folder out for
template work; the wider call retires the machinery rather than leaving it merely unused.

The citations are gone from `DESIGN.md`, `.prettierignore`, `code/workflows/03-database-migration/CONTEXT.md`
and the two CSS audit scripts. Each described something real, so each now names that thing directly
— the shard-key co-location, the Django static token cascade, the co-located component CSS. The
retired machinery is still standing and still instructs otherwise; the memory entry is read second in
the Section 2.1 order and wins until the removal ships.

### Instances used as evidence, and paths that resolved to nothing

The same rule reaches further than decision records.

**Story numbers as worked examples.** The component-consolidation documents explained their own
value with two specific stories designing the same badge. The point is exactly right and the
example ships into a repository with no stories in it. It reads as one story's status badge and
another story's tag chip now, which is true in every project.

**Map names and node numbers as evidence.** Several rules cited the map node that discovered them —
in `.claude/MEMORY.md`, the grilling and wayfinder skills, the `seo` agent, and three `research/`
notes. A map is deleted when its epic ships, so the citation dies and the lesson does not. Each
lesson now carries itself.

**Paths that simply were not there.** The `release` agent bumped a manifest at
`code/src/django/pyproject.toml` (it is the root `pyproject.toml`) and deployed by running a script
in a directory that is a scaffold — that phase now stops and reports rather than improvising a
command. The `completion` agent maintained a story index this template does not ship. The testing
guides pointed at the same non-existent Django manifest for the pytest and coverage blocks. A
dependency-audit script was cited three times and has never existed; the work is done by
`.github/workflows/audit-deps.yml`, on a schedule rather than every PR. The debugging checklist
named `lint.sh` and `check.sh` one directory too high. Three server-contract documents cited the
deploy repository's guides bare, so they resolved **here**, to the wrong thing.

### What the documentation promised and nothing supplied

Two of these were not wrong references but missing things.

`.claude/CLAUDE.md` Section 3 listed five MCP servers. `.mcp.json` configured one. `context7` and
`mcp-mermaid` are now genuinely wired, and the table gains a **How you get it** column so the
remaining gap is stated rather than implied: `claude-in-chrome` needs the extension installed and
paired, which no file here can do for you, and the `figma` row is gone because nothing here provides
it.

`MAP-SCALE-PLANNING.md` is the map `/scale-planning` writes, and six shipped files route a reader to
it. It did not exist until that pass had run, so on day one all six routes went nowhere — for the
one artefact the operating model says must be settled **before** the first feature. It is now seeded
into `project-management/src/01-FEATURE/` at generation, as a stub with every row reading `TBD` and
the frontier named rather than answered. That is the honest state before the pass, and it is
seed-once on the same `_tasks` mechanism as the root version files, so an update can never hand a
project its blank stub back over a filled-in map.

### This repository's own throwaway state, kept out of its history

`handoffs/.gitignore` ignores `HANDOFF-*.md`, and `project-management/src/01-FEATURE/.gitignore`
ignores the feature maps bar the template they are written from. Both are `_exclude`d, so no
generated project receives either.

The asymmetry is the whole point. In **this** repository a handoff is session state about work on the
template, and a map charts the template itself and is deleted once its epic ships; neither belongs in
the template's history. In a **generated** project both are real — handoffs are that project's session
continuity, maps are the artefacts of `01-feature` — and `handoffs/CONTEXT.md` says so, unchanged.

The mechanism matters as much as the rule. Git honours a `.gitignore` in any directory, so a
repo-local rule can live in a file copier drops at generation. Excluding the root `.gitignore` and
seeding it instead would have made it seed-once, and no future ignore rule could ever reach an
existing project again.

### The gate that keeps this true is not in this release, and that is an ordering constraint

A rule applied by hand stays true until the next hand touches it. The obvious follow-up is a
mechanical check, and it lands at the end of this cycle rather than here.

The reason is not caution. The refreshed root index cites three guides that do not exist until later
releases in the cycle — so the index cannot land until they do, and a gate that fails on the index it
is meant to protect cannot land before it. Shipping the check now would mean either a red gate or an
exemption written to hide one, and both are worse than the honest sequence: make the tree true first,
then make it stay true.

## v2.13.1 — 11/08/2026

**Status:** Patch — closes out the 2.4.0–2.13.0 cycle. Every guide added across those ten releases
is now indexed, and the stale references a dedicated sweep found are fixed.

### The releases before this one added guides; this one makes them findable

Ten minor releases landed roughly twenty new guides. Each shipped with its own content correct and
its index row missing, because the reference tables were reformatted wholesale and could not be
split cleanly per release. This is that debt paid: the four `REFERENCES.md` files now list
everything.

### A green that meant "did not look"

`check-template-tokens.sh` is the audit that proves no unrendered token survives generation. It scanned
`git ls-files` — tracked files only.

So the file you had just written was invisible to it, and the run said green. CI never caught the
flaw, because by the time CI runs everything is tracked; the blindness was confined to local runs,
which is precisely where you want the check to work. It now scans tracked and
untracked-but-not-ignored files together.

### The README a generated project actually receives

`.copier/README.md` is not this repository's README — it is the one a new project gets, renamed
into place by a post-generation task. Nothing in this repository's CI ever reads it, so it drifted
without a single failure to mark the occasion.

It was describing a repository three surfaces out of date: a `code/src/` tree missing
`improvement-architecture/`, a `.github/workflows/` list naming 11 of 28, a `code/docs/` tree
missing eight ungated guides, a `src/` tree stopping at `21-REFACTORING`, and a workflow count of
21 when there are 23.

`shipped-readme.sh` now guards it, along with `how-to/src/TEMPLATE-TOKENS.md`. Both are documents
whose only reader is someone who has already generated a project, and who has no way of knowing
what they were told is wrong.

### Also fixed

`.prettierignore` still pointed at `code/src/frontend/` and `code/src/backend/`, plus a Next.js
build-output block and GraphQL codegen paths — none of which have existed since the stack became a
Django-only monolith. The root `CONTEXT.md` declared version 2.0.0, three releases behind, and gave
three wrong workflow ranges. The `README.md` footer declared v1.0.0, and the stack table promised
Celery and S3 storage as though both were wired rather than declared.

### One thing deliberately left open

Three ADRs — `ADR-016`, `ADR-019`, `ADR-023` — are cited as real across six files, and no ADR
register exists. They are the oldest phantom in the tree and they are still here, logged in
`TEMPLATE-GAPS.md`.

Deciding between writing those ADRs and dropping the citations is a decision, not a tidy-up, and
folding it into a sweep would have meant making it quietly.

## v2.13.0 — 11/08/2026

**Status:** Minor — one new hook and a deny-list. Both are Claude Code configuration; no
application behaviour changes.

### A warning that arrives while it can still be acted on

This template disables auto-compaction and replaces it with `/handoff`: the session writes a
handoff document, stops, and you resume in a fresh window from the file. That has been the rule
since the skill was added, and it was hooked to `PreCompact`.

`PreCompact` is too late. By the time compaction fires, the window is already spent — so the
handoff gets written in the least context the session will ever have, about work nobody can now
re-read. It is the worst handoff of the session, produced at exactly the moment the best one is
needed.

The model also cannot read its own context usage, which is why this could never be a rule on its
own. A `UserPromptSubmit` hook now measures it:

- **50% — advise**, once per session. Finish the step in flight, start no new scoped work, name the
  stopping point, offer `/handoff`.
- **75% — insist**, on every prompt. Write the handoff and stop the turn.

The split is the same one `pre-compact-handoff.sh` already used: a hook cannot invoke a skill or
stop a turn, so the script measures and reminds, and `.claude/CLAUDE.md` Section 2.6 carries the
behaviour. Both halves are needed; neither works alone.

Two details worth knowing. The window size is a constant — nothing in the transcript reports it —
defaulting to this project's observed 1M and overridable with `CLAUDE_CONTEXT_WINDOW` for a 200k
plan, with both thresholds overridable too. And the hook **always exits 0**: a miscounted token
must never block your prompt, because a warning system that can refuse input is worse than none.

### `.env` files are now unreadable to the agent

Every variant — `.env`, `.env.dev`, `.env.test`, `.env.prod`, `.env.staging`, `.env.local`,
`.env.probe`, `.env.backup`, `.env.bak*` and the long-form spellings — denied for both `Read` and
`Bash`.

The `.example` templates stay explicitly allowed, and that is the useful half: an agent needs to
know **which** variables exist to wire a feature. It has never needed their values.

## v2.12.0 — 11/08/2026

**Status:** Minor — one new audit script, five rule files, and a stub scanner that now reads Rust.

### Two gaps a per-file Python linter cannot close

Ruff has been carrying the security load here, with `flake8-bandit` enabled through the `S` ruleset.
It is good at what it does, and there are two things it structurally cannot do.

**It cannot read a template.** Ruff parses Python. A `.html` file is not Python, so
`{% autoescape off %}`, a `|safe` filter on user-controlled data, and a template variable
interpolated straight into an Alpine expression or an inline `<script>` were not merely unflagged —
they were never looked at. On a stack whose entire frontend is Django templates, that is the
largest single blind spot in the audit set.

**It cannot see across files.** Ruff runs per file. It will flag a bare `eval()`, because that call
is visible in the file containing it. It cannot see that the argument came off a request three
modules earlier, which is the shape almost every real injection actually takes.

### `static-analysis.sh`

Opengrep, run against five rule files this project authors and owns:

| Rule                        | Closes                                                            |
| --------------------------- | ----------------------------------------------------------------- |
| `django-autoescape-off.yml` | `{% autoescape off %}` blocks                                     |
| `django-safe-filter.yml`    | The `safe` filter applied to data that is not provably safe       |
| `django-template-xss.yml`   | Template variables inside Alpine expressions and inline scripts   |
| `request-to-sink-taint.yml` | Request data reaching a raw-SQL, shell or eval sink, across files |
| `secrets-in-source.yml`     | Hardcoded credential assignments                                  |

The rules live under `code/src/scripts/audits/rules/` with their own `CONTEXT.md`/`CLAUDE.md` pair,
because they are hand-authored source and deserve the same orientation as anything else here.

### `stubs.sh` reads Rust now — but only the half clippy cannot

The stub scanner covers `// STUB`, `// TODO`, `// FIXME` and `// HACK` in Rust.

It deliberately does **not** grep for `todo!()`, `unimplemented!()` or `unreachable!()`. All three
are denied at lint level in every crate, and clippy parses Rust — so it cannot be fooled by a macro
name inside a string or a doc example, and it offers a per-site `#[allow]` carrying a reason, which
a grep cannot. A `// STUB` comment is exactly what clippy cannot see. That is the division of
labour, and both halves are now written down in `code/docs/rust/PYO3-BOUNDARY.md`.

The Cargo `target/` tree is excluded: thousands of generated files carrying upstream crates'
markers, none of them anyone's to fix here.

## v2.11.0 — 11/08/2026

**Status:** Minor — five new skills, one new PM record folder, one new CI gate. Nothing existing
changes behaviour.

### Five moments that had no procedure

Each of these is a situation the template already put you in and then left you to improvise.

**`/incident`** — something is broken in staging or production. What you need at that moment is not
another pair of hands on the keyboard; it is a scribe. The skill keeps timestamped notes, holds the
clock, produces a seven-field handover the moment you have to stop, and writes the blameless
postmortem at stand-down. It has **no paired agent**, on purpose: running an incident is a session
mechanic rather than a remit.

**`/resolving-merge-conflicts`** — a merge, rebase or `copier update` has left markers. The skill
recovers the intent behind both sides rather than picking one, and it knows the file classes that
must never be hand-merged at all: migrations, lockfiles, version state, and frozen PM artefacts.

**`/wizard`** — some steps only a human can do. Provisioning a service, minting a credential,
pasting a CI secret. The skill authors a guided bash script over the new
`code/src/scripts/_lib/wizard.sh`, and is explicitly not for work the agent could have done itself.

**`/to-questionnaire`** — a grilling pass stalls because the answer lives with someone outside the
session: a client, a data controller, a vendor. This is the honest exit — it writes a questionnaire
for that person into `questionnaires/`. Never self-invoked.

**`/wait-what`** — the last reply did not land. Re-pitched in plain language, with the context it
wrongly assumed you had. Also never self-invoked, because an agent is the last thing qualified to
judge whether its own explanation worked.

### The incident register

`project-management/src/22-INCIDENTS/` is new, and it breaks two conventions on purpose. It is
**not story-anchored** — an incident does not belong to a `US###` — and it is **PII-free**, because
an incident record is the document most likely to be read by someone who should never have seen the
personal data that caused it.

It also has no paired workflow, which is why the doctrine lives in
`how-to/docs/INCIDENT-PRACTICE.md`: declare, run, hand over, stand down, write up.

### Skills are now checked against the specification

`skill-conformance.sh` runs eight fail-tier clauses and reports them in **two groups**, because a
specification breach and a house-rule breach are different problems with different fixes.

Six come from the [Agent Skills specification](https://agentskills.io/specification): frontmatter at
byte 0, `name` and `description` present, `name` matching its directory, the name character rules,
the description length cap, and no key outside the six the spec defines.

Two are house rules. This project authors only `name` and `description` and declines the other four
spec fields, for a reason worth stating: capability and model belong to the **agent** that loads a
skill, never to the skill itself. And every first-party skill carries a `## Governing procedures`
section.

Length is deliberately not checked here. `docs-length.sh` already owns the 300-line cap across
`.claude/**`, and one rule with two enforcers drifts.

Vendored skills — the Cloudinary set, symlinked and refreshed from upstream — are held to the spec
half only. Hand-editing one to satisfy a house rule is undone by the next refresh.

## v2.10.0 — 11/08/2026

**Status:** Minor — documentation only. Four subsystems that were dependencies without designs now
have designs, and every one of them says out loud that it is not wired up.

### Declared, not wired

The template has carried `celery[redis]`, `boto3`, `sentry-sdk[django]` and `django-prometheus` as
declared dependencies for some time. None of them is configured. There is no `config/celery.py`, no
task module, no `CELERY_*` setting, no `worker` or `beat` service in any of the four Compose files,
no storage adapter, no `sentry_sdk.init(...)`, and `django_prometheus` is not in `INSTALLED_APPS`.

That is a defensible state for a template — you should not inherit a Celery cluster you did not ask
for. What was not defensible was the silence. A dependency in `pyproject.toml` with no guide is an
invitation to invent a design at the keyboard, on the day someone finally needs it, under time
pressure.

So each of these now has a **design of record**, and each opens with an explicit status line naming
the dependency, where it is declared, and precisely what does not exist. A guide that reads as
though the subsystem is running is worse than no guide at all: it sends someone looking for a
module nobody ever wrote.

### The four

**`TASK-AUTHORING.md`** — the enqueue boundary, idempotency, retries, limits, queue routing, and
how to test tasks without a broker.

**`PROCESS-MODEL.md`** — worker class, event loop and the ORM's synchronous boundary, treated as
one topic rather than three, because deciding any of them alone decides the other two badly. The
web process family here is verified against the Compose files; the task family is not, and the
guide is explicit about which half is which.

**`OBJECT-STORAGE.md`** — private documents over the S3 API: the adapter contract, presigned URLs,
upload validation, and the split against Cloudinary, which keeps public media.

**`security/AUDIT-TRAIL.md`** — the audit record, and the **record** half of OWASP A09:2025. Table
schema, atomic write path, what goes in and what must never, the PII rule, retention, and tamper
resistance. Its neighbour `MONITORING-AND-INCIDENT.md` keeps alerting and response; the A09 row now
names both, because one control with two owners needs both named or neither gets done.

### Observability, rewritten around interfaces

`logging/OBSERVABILITY.md` now leads each of its four sections — error tracking, log aggregation,
metrics, traces — with the **interface** the code is written against, and names the product as one
implementation behind it. This is v2.9.0's provider-neutrality rule applied to the guides that most
needed it.

It also draws a boundary that was implicit and routinely misread: the **collector side** — log
shipper, metrics store, dashboards — is server infrastructure. It does not run in your local Docker
Compose stack, and it is not something the application is expected to bring with it.

## v2.9.0 — 11/08/2026

**Status:** Minor — adds eight Copier questions, all with defaults. Updating projects are prompted
for choices they already made implicitly; nothing breaks if you accept every default.

### "Provider-agnostic" is a claim, and claims need evidence

Plenty of projects describe themselves as provider-agnostic. Most mean one of three quite different
things, and the difference decides whether swapping the provider is an afternoon or a quarter.

This release names all three:

- **Protocol seam** — the code is written against a published wire format or API. The S3 API. The
  Prometheus exposition format. Swapping the product behind it is a configuration change.
- **Adapter seam** — the code is written against an interface this project defines, with an
  implementation behind it. Swapping means writing a new implementation.
- **Substrate** — the code is written against the product itself. Postgres is substrate here, and
  saying so plainly is more useful than pretending otherwise.

With the standing rule that keeps the vocabulary honest: **one adapter is a hypothetical seam; two
are real.** An interface with a single implementation has never been proven to abstract anything.

### Which of three owners holds a given fact

One infrastructure fact is usually owned in three places at once — the application code, the server
contract in `how-to/src/SERVER-ARCHITECTURE/`, and the deploy repository that provisions the host.

`BUILD-OPERATE-SEAM.md` says which part belongs where, gives the two shapes a bridge between them
can take, and states the same-change rule that stops the three drifting apart.

`seam-contract.sh` enforces the mechanical half. Every numbered section of the server contract must
carry a `**Source:**` field, and every repository path in one must resolve. A requirement with no
source is a requirement nobody can verify, and nobody can update when the thing it came from
changes.

### Eight questions, recording choices rather than dependencies

`HOSTING_PROVIDER` · `OBJECT_STORE` · `ERROR_TRACKING` · `LOG_AGGREGATOR` · `OBSERVABILITY_STACK` ·
`TRACING_BACKEND` · `ANALYTICS_PROVIDER` · `INCIDENT_TRACKER`

The defaults are self-hosted and open source — SeaweedFS, GlitchTip, Loki, Prometheus + Grafana,
Plausible — but the point is not the defaults. It is that the guides name **the interface** and
treat the product as one implementation behind it, so a project that answers differently is still
on-doctrine rather than off-piste.

That is also why several guides changed wording: structured JSON on stdout rather than a named log
shipper, the Prometheus exposition format rather than Prometheus, the Sentry SDK wire protocol
rather than Sentry.

### `how-to/src/PLATFORM-PROVIDERS.md` is yours

The rule is identical in every project generated from this template. The register — every
dependency, what interface it sits behind, its seam kind, and whether you may swap it — is the
answer sheet for **your** project, and it is the file to reach for when someone asks how hard it
would be to move.

## v2.8.0 — 11/08/2026

**Status:** Minor — documentation only. Notable less for what it adds than for what it deletes.

### A third of what this template said about answer engines was false

The work started as a straightforward gap-fill: the page **body** was the one output surface with
no owning guide, so a fourth sub-document was needed. Checking the existing material against
primary sources turned up something the plan had not anticipated.

Google's own documentation — [AI features and your
website](https://developers.google.com/search/docs/appearance/ai-features) — states there are **no
additional requirements and no special optimisations** for AI Overviews and AI Mode, and no new
machine-readable files to publish.

Three items in `SEO-CHECKLIST.md` said otherwise:

- **Content chunking for RAG**
- **Fan-out query coverage**
- **Per-engine optimisation** — which additionally named five specific products as a requirement,
  against the provider-neutrality rule this template holds everywhere else

They are removed, not unticked. A checklist row that cannot be satisfied because the thing it asks
for does not exist is worse than no row: it gets ticked anyway.

### `llms.txt` stays, for the honest reason

`ROOT-SURFACE.md` called `llms.txt` "the one leg of answer-engine discoverability". It is not a
search or citation signal and never was.

It stays in the template, re-justified as **agent-facing**: an index for IDE agents and MCP clients
that read a project rather than crawl it, which is a real use with a real consumer — and which
points at `code/docs/MCP-SERVER.md` rather than at a search engine.

### The structure that came out of it

`code/docs/DISCOVERABILITY.md` is now a thin index over four sub-documents, one per output surface:

| Surface       | Owner                  |
| ------------- | ---------------------- |
| The `<head>`  | `WEB-METADATA.md`      |
| The JSON-LD   | `STRUCTURED-DATA.md`   |
| Root files    | `ROOT-SURFACE.md`      |
| The page body | `CONTENT-STRUCTURE.md` |

And the split with the PM layer is now stated in both files: `SEO-CHECKLIST.md` is **what must be
true per page** before a story closes; `DISCOVERABILITY.md` is **how this stack does it**. Neither
restates the other.

The checklist also gained a `_(not a gate item)_` convention. Around nine rows describe good
practice that cannot actually block a story, and marking them keeps the gate honest about what it
stops.

### The lesson, now recorded in project memory

A third-party source's claim is a **lead, not a finding**. Every one of the three myths arrived
from a plausible secondary source and survived because nobody checked it against the primary one.

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

`VISUAL-DESIGN.md` Section 3 makes you pin a **direction** on six axes. This is the load-bearing part:
without a direction, Section 4.2's ban list cannot be decided at all, because a deviation is only a
deviation from something. Section 4.1 is the separate, unconditional list — the universal tells, banned
on every direction and every surface.

Section 5 is a numeric motion standard rather than a taste statement: frequency first (the rule that
actually changes decisions), duration ceilings, easing as a hierarchy, and reduced-motion meaning
fewer and gentler rather than none.

### Five gates, and an honest boundary

`copy-slop.sh` reads prose. `css-slop.sh` reads stylesheets. `template-slop.sh` reads Django
markup. `render-slop.sh` needs a viewport, because the repeated-device clauses cannot be decided by
any static scan. `style-check.sh` holds the Slint surface, which picks a style whether or not you
name one — so `build.rs` now names it.

Each runs two tiers in one pass, following `cloc.sh`'s warn-at-750 / fail-at-800 precedent:
`[gate: fail]` for an unambiguous match, `[gate: warn]` for a threshold, a ratio, or a word that is
sometimes just correct English. Section 6 of the guide is the explicit list of what a script can decide
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
route-don't-restate rule. `.claude/CLAUDE.md` Section 8 states the rule in one bullet and routes here for
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

`CONTRIBUTING.md` Section 1b, which never ships downstream: in syntek-base a version bump edits exactly
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
  `.claude/CLAUDE.md` Section 10 making it the default for substantial work.
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
