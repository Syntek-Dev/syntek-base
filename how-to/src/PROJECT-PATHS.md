# Project Paths — This Project's Direction A Register

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

Every path a shipped document names that this repository does not hold, the thing that brings it
into existence in a real project, and when that happens.

**The rule that produced this table is not here.** It lives on the build side, in
[`code/docs/FORWARD-VOICE.md`](../../code/docs/FORWARD-VOICE.md) — the one rule, the two directions
a citation can face, and the `template-only` token that covers the other one. That rule is the same
in every project generated from this template. **This file is the answer sheet, and it is yours.**

## How to read a row

| Column         | Meaning                                                                      |
| -------------- | ---------------------------------------------------------------------------- |
| **Path**       | The path a shipped document cites, absent from this repository               |
| **Created by** | The script, workflow or step that brings it into existence in a real project |
| **When**       | The point in a project's life at which that happens                          |

**A row is a promise, and it is now also the only thing that keeps a citation green.** As of
20/08/2026 [`code/src/scripts/audits/doc-references.sh`](../../code/src/scripts/audits/doc-references.sh)
checks `code/src/django/` like any other tree: a backticked path there passes because it exists,
because it holds a row below, or not at all. Nothing else quietens it — not a forward tense, not a
disclaimer at the top of the citing file — because the check reads the path.

**That makes writing a row the wrong first instinct.** A finding means the citation is unbacked,
and the default disposition in
[`code/docs/FORWARD-VOICE.md`](../../code/docs/FORWARD-VOICE.md) Section _The rule_ applies: correct
it or drop it, and point at a document that exists. A row is written only when a creator can be
**named**, which is a separate question from whether a finding is inconvenient.

**A green run still has not judged a single row.** It proves the Path column resolves or is
registered; it proves nothing about whether the **Created by** entry creates that path. That stays
a reviewer's call.

**A row names a creator, or it is not written.** An entry that cannot say what brings the path into
being is a wish, and the rule keeps wishes out of both files. Exactly three paths clear that bar
today; the ones that do not are listed under _What is deliberately not registered_ so nobody has to
re-derive the verdict.

**Register a path, not a site.** One row covers every document citing that path, however many there
are. Two documents disagreeing about what a path is for is a defect to fix in those documents, not
a second row here.

**The `When` column is written the way this repository already writes absence.** The house style is
[`code/docs/FRONTEND-CODING-PRINCIPLES.md`](../../code/docs/FRONTEND-CODING-PRINCIPLES.md) Section
_What is not built yet_, whose second column gives the reason rather than a date, and
`code/src/django/static/CONTEXT.md` Section _What is not here yet_. The executable form of the same
honesty is `code/src/scripts/development/new-django-view.sh`, which refuses to run, names each
missing piece, and prints the command that creates it.

---

## Registered paths

| Path                              | Created by                                       | When                                                                                                                                           |
| --------------------------------- | ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/django/apps/marketing/` | `code/src/scripts/development/new-django-app.sh` | The first story that needs a public page — Step 2 of `project-management/workflows/20-frontend-code/`, which cannot scaffold a page without it |
| `code/src/django/config/api.py`   | `project-management/workflows/19-api-code/`      | The first story that adds an endpoint — Step 2, in the same change as the router it mounts                                                     |
| `code/src/django/components/`     | `project-management/workflows/20-frontend-code/` | The first story with a reusable server-rendered component — Step 4                                                                             |

### What the marketing row does not cover

**The row covers the app directory and nothing deeper.** Read against the script rather than
against the guides that describe a finished app: `new-django-app.sh` writes `apps.py`,
`__init__.py`, a `migrations/` package, a `models/` package, and a `CONTEXT.md` + `CLAUDE.md` pair
for each of the three directories. That is the whole output. `views/`, `urls.py`, `seo.py` and
everything else the frontend guides name under that app are written by the story, not by the
scaffolder, and none of them has a row.

The script does not register the app either — it prints the `INSTALLED_APPS` edit as the next step
and leaves it to the person running it, so a scaffolded app is inert until
`code/src/django/config/settings/base.py` names it.

`new-django-view.sh` is the proof that the boundary is real. Its pre-flight refuses unless the app
directory, its `views/` package, its `urls.py`, its `seo.py` and the marketing template directory
under `code/src/django/templates/` all exist, and it prints
`bash code/src/scripts/development/new-django-app.sh marketing` as the fix for the first of them.
A document that cites any of the deeper paths as though this row underwrites them is citing
something nothing has promised.

### What the API row does not cover

**The row covers the project-level `NinjaAPI` and nothing else.** `19-api-code` Step 2 creates the
single `NinjaAPI` in `code/src/django/config/api.py` if no story has yet, and mounts the feature's
router onto it.

Whether a per-app `apps/<name>/api.py` is emitted by the app scaffolder or written by the story is
an **open decision**, and it gets no row until it is settled. A row would answer it in passing,
which is the one thing a register must never do — and the project-level singleton is safe to
register precisely because no per-app scaffolder could produce it under either resolution.

### What the components row does not cover

**The row covers the top-level directory, not the choice of which home a component belongs in.**
This project keeps django-components in two places, and
[`code/docs/FRONTEND-CODING-PRINCIPLES.md`](../../code/docs/FRONTEND-CODING-PRINCIPLES.md) owns
that rule outright — go there for it. This register states only that the top-level directory is
brought into existence by the first story that needs a component shared across apps.

The app-owned half needs no row of its own. It arrives inside the app that owns it, so the app's
row already covers it, and a document naming it is naming a location within an app rather than a
path this template promises.

---

## What is deliberately not registered

Each of these was proposed and refused. The verdict is recorded so the proposal does not return.

| Candidate                                                      | Why there is no row                                                                                                                                                                                                              |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A per-app `apps/<name>/api.py`                                 | An open decision, per the API row above. Registering it would settle it silently                                                                                                                                                 |
| The app-owned `apps/<name>/components/` directory              | No creator of its own — it arrives with the app that owns it, and that app's row covers it                                                                                                                                       |
| The design-token app, and the CSS token layer it would seed    | No creator resolves. No workflow creates the app, and what the citations describe is not what the app scaffolder produces. Documents naming it point at [`code/docs/DESIGN-TOKENS.md`](../../code/docs/DESIGN-TOKENS.md) instead |
| The `CONTEXT.md` and `CLAUDE.md` pairs inside a scaffolded app | Subsumed by the app's own row — the scaffolder writes them in the same invocation                                                                                                                                                |

**A refusal is not a permission to keep citing the path.** Direction A has exactly one mechanism,
and a candidate that fails it falls back to the default disposition in
[`code/docs/FORWARD-VOICE.md`](../../code/docs/FORWARD-VOICE.md) Section _The rule_: the citation is
corrected or deleted. Point at a document that exists instead.

---

## What keeps this file true

**Making the promise and writing the row are one change.** A guide that starts telling a developer
where something will go, without a row here saying what puts it there, has written a wish into a
shipped file. This is a definition-of-done item, not a tidy-up task.

**A row retires when the path lands.** In a generated project, the day
`code/src/django/apps/marketing/` exists, its citations resolve like any other and the promise has
been kept — so the row goes, in the same change that creates the directory. Left in place, this
file quietly becomes a list of things that are already true, which is the state in which nobody
reads it. The three rows above never retire in the template itself, because the template builds
nothing.

**The creator column checks itself, at no cost.** Every creator is a backticked path in a shipped
file, so `doc-references.sh`'s ordinary dangling check already reads it. No clause was ever written
for that, and none has to be maintained. The **Path** column is the half that did take one — the
arm reads this section to decide which citations under `code/src/django/` are backed — so the two
columns are checked by different means and only one of them for free.

**Know what a green run is worth, because it is less than it looks.** It proves the creators exist,
and — since the arm landed — that every cited path under `code/src/django/` either exists or is
registered here. It proves nothing about whether a creator creates the path its row claims, which
is the judgement no run has ever made. That limit is stated in [`code/docs/FORWARD-VOICE.md`](../../code/docs/FORWARD-VOICE.md) Section _What the gate
cannot decide, stated plainly_, and they are written here as well rather than assumed, on the rule
in [`code/docs/GATE-REPORTING.md`](../../code/docs/GATE-REPORTING.md): a check that could not look
is never reported as a check that looked and found nothing.

## Cross-references

- [`code/docs/FORWARD-VOICE.md`](../../code/docs/FORWARD-VOICE.md) — the rule this file answers
- [`code/docs/GATE-REPORTING.md`](../../code/docs/GATE-REPORTING.md) — what a check may claim it examined
- [`how-to/src/INVARIANTS.md`](INVARIANTS.md) — the first per-project answer sheet (rule: [`code/docs/NEGATIVE-SPACE.md`](../../code/docs/NEGATIVE-SPACE.md))
- [`how-to/src/PLATFORM-PROVIDERS.md`](PLATFORM-PROVIDERS.md) — the second (rule: [`code/docs/architecture/PROVIDER-NEUTRALITY.md`](../../code/docs/architecture/PROVIDER-NEUTRALITY.md))
