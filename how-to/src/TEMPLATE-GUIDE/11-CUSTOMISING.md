# Customising — What Is Yours to Change

**Last Updated**: 23/08/2026

It is your project. You can change anything. This is about which changes are cheap, which are
load-bearing, and which will hurt on the next `copier update`.

---

## Three categories

| Category         | Meaning                                                                  |
| ---------------- | ------------------------------------------------------------------------ |
| **Yours**        | Expected to change. The template ships a starting point, not an answer.  |
| **Load-bearing** | Something else depends on it. Changeable, but change the dependants too. |
| **House rules**  | Deliberate constraints. Changing them is fine — just do it knowingly.    |

**Two files are in none of those categories, because they are not yours to edit at all.**
`how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md` describe **the template**, not
your project — editing one changes nothing about how your project works and guarantees a conflict
on the next `copier update`, because upstream owns the same lines. `.claude/hooks/template-docs-readonly.sh`
blocks writes to them, and it stands down inside `syntek-base` itself, where they are the product
being maintained. Everything else in the tree is yours.

---

## Yours — change freely

- **Everything under `code/src/django/apps/`.** The app skeleton is a starting point.
- **`project-management/src/`** — your stories, sprints, ADRs, threat models, QA plans.
- **Design tokens.** Values are DB-canonical in the design-token app — which no workflow
  creates, so `how-to/src/PROJECT-PATHS.md` deliberately refuses it a row; the standard is
  `code/docs/DESIGN-TOKENS.md`. Once it exists, edit through the
  `/admin/design-tokens` editor or a migration.
- **Brand assets** in `project-management/src/00-ASSETS/` and the generated brand-guide PDF.
- **`.claude/MEMORY.md`** — project memory is meant to accumulate. It arrives with its headings
  and its writing rules and **no entries**: the template's own memory is excluded from generation
  rather than shipped, because a project reading someone else's notes second in every session is
  worse than reading none.
- **`GAPS.md`, `DEFERRED.md`** — working documents.
- **`handoffs/`, `research/`, `questionnaires/`, `learning/`** — the four scratch directories.
- **`VERSION` and the three version logs** — yours from `0.1.0`; the template's history never
  ships. Move them with the `version` skill rather than by hand.
- **Dependencies**, within the licence constraints in `how-to/src/CLAUDE.md` → _Guardrails_ and
  the _Licensing_ section of `how-to/src/CONTRIBUTING.md`.

## Load-bearing — change with their dependants

### Directory structure

Adding a directory means adding **both** a `CONTEXT.md` and a `CLAUDE.md`, and updating the tree
in the parent `CONTEXT.md`. Moving a directory means updating every `REFERENCES.md` that indexes
it. The documentation gate checks this before commit.

### Django app names

You chose them at generation. Renaming afterwards means the app directory, `INSTALLED_APPS`,
migrations, imports, and every documentation reference. Use
`code/src/scripts/development/new-django-app.sh` for new apps — never `manage.py startapp`, which
skips the per-model-file structure and the `CONTEXT.md`/`CLAUDE.md` pair.

### URL structure

Marketing at `/`, admin at `/admin/`, portal at `/portal/`, API at `/api/`. Django's built-in
admin is at `/control/`, deliberately not `/admin/`. Rules in `code/docs/URL-STRATEGY.md`; new
public pages go through `code/src/scripts/development/new-django-view.sh`.

### The scripts

Every guide, skill and workflow references `code/src/scripts/**`. Renaming one means sweeping the
documentation. Adding scripts is cheap; renaming is not.

### CI workflows

A web-only project ships 32 workflows, 22 of them path-filtered (24 carry a filter in the
template; two of those are among the three excluded). If you move source out of the
paths they watch, they silently stop running — and a job that never runs is indistinguishable
from one that passes. Check `.github/workflows/*.yml` `paths:` after any structural move.

Three of the template's 35 do not reach your project: `audit-template.yml` is template-integrity
only, and `syntax-rust.yml` and `audit-style-check.yml` travel with the surfaces they test. A
workflow shipped without the script it runs is a permanently-red job, which a generated baseline
must never carry.

**Mobile is the counter-example, and it is deliberate.** `audit-mobile-tokens.yml` is not excluded,
because its job is guarded at **step** level instead — the rule is _a CI job travels with the script
it runs_, and a shared job satisfies that by skipping, not by being deleted (`12-EXTENDING.md` →
_An optional subtree_, point 6).

### The opt-in mechanism

Optional content — the mobile, Rust and desktop surfaces — is gated by **one mechanism and one
only**: a templated `_exclude` entry in `copier.yml`. <!-- doc-references: template-only -->

<: raw :>

```yaml
_exclude:
  - "<: if not INCLUDE_MOBILE :>/code/src/mobile<: endif :>"
  - "<: if not INCLUDE_MOBILE :>/code/src/scripts/mobile<: endif :>"
```

<: endraw :>

Each surface's entries cover everything it owns and nothing else: the tree, its scripts, its
`code/docs/` guides, its `code/workflows/NN-…` folder, its CI job, and its stack skill. The stack
skill matters most — **a skill fires on description match rather than on being named**, so an
unusable one competes for work it cannot do rather than sitting inert.

Three properties make this worth protecting, and all three are lost the moment a second
mechanism appears:

- **No file anywhere has templated contents.** Shared files gain **inert no-ops** instead — an
  ignore entry pointing at a path that may not exist, a glob that may match nothing, a `ts,tsx`
  extension in a lint target. Each costs a web-only project exactly nothing.
- **The excluded tree is never rendered at all.** A Jinja syntax error inside a mobile file
  cannot break a web-only generation, because Copier never opens it.
- **When the condition is false the entry renders to an empty string**, which Copier tolerates.

Two alternatives were tried and rejected. **Conditional directory names** degenerate here because
`_templates_suffix: ""` makes Copier's "suffix outside the condition" rule meaningless. A
**post-generation delete task** renders the tree first and deletes after — so a broken mobile
file still kills a web-only generation.

If you add your own optional subtree, copy this pattern rather than inventing a second one, and
extend the CI matrix that generates **both** boolean values so the negative case stays tested.

### Binaries and `_templates_suffix`

`copier.yml` sets `_templates_suffix: ""`, which means **every file in the tree passes through <!-- doc-references: template-only -->
Jinja** — there is no `.jinja` opt-in marker. The consequence is easy to trip over: **binaries
cannot be rendered**, which is why `*.pdf` is excluded and why the mobile app uses Expo's
Continuous Native Generation rather than committed `ios/` and `android/` directories
(`02-STACK.md`).

If you add a binary asset anywhere in the tree — a font, an image, a JAR — you must add an
exclusion entry for it or generation fails. This is the single most common cause of a template
that worked yesterday and does not today.

### The pnpm workspace glob

`pnpm-workspace.yaml` declares `packages: ["code/src/*"]` rather than naming the mobile app.
pnpm treats a matched directory as a package only when it has a `package.json`, so the glob
resolves to the mobile app when you opted in and to nothing when you did not — leaving the file
**byte-identical on both paths**. That is what lets `_exclude` remain the single mechanism.

Cost: any future directory you add under `code/src/` carrying a `package.json` joins the
workspace silently. Nothing warns you.

### The patch that only applies on one path

`patches/` and the `patchedDependencies` entry pointing at it ship to **every** project, mobile
or not, because `pnpm-workspace.yaml` is byte-identical on both paths and cannot conditionally
name a patch. On a web-only project the patched package is simply not in the graph, and pnpm 11
**errors** on a patch it could not apply (`ERR_PNPM_UNUSED_PATCH`; `ignorePatchFailures` was
removed in 11.0). `allowUnusedPatches: true` is what turns that error into a warning, so it is
load-bearing for the web-only render path rather than a convenience — verified both ways on
01/09/2026 against a scratch project.

The same setting covers the other direction: each key pins an **exact** version, so the day the
upstream package moves the patch stops matching, the install warns instead of applying a diff
written against different code, and `pnpm audit` goes loud again if the new version is still
vulnerable. That is the signal you want. Do not loosen a key to a range to keep it quiet.

## House rules — change knowingly

| Rule                             | Where                           | If you change it                                               |
| -------------------------------- | ------------------------------- | -------------------------------------------------------------- |
| Coverage floors 75 % / 90 % auth | `code/docs/testing/COVERAGE.md` | Update the CI gate too, or it disagrees with the doc           |
| 750-line source limit            | `code/CONTEXT.md`               | `audit-cloc.yml` and `cloc.sh` both hardcode the threshold     |
| 300-line instructional-doc limit | `.claude/CLAUDE.md` Section 8   | The context-budget rationale goes with it                      |
| British English prose            | `.claude/CLAUDE.md`             | Sweep existing docs or you get a mix                           |
| Grilling before substantial work | `.claude/CLAUDE.md` Section 10  | Claude stops interviewing and starts building on first reading |
| Token-first CSS                  | `code/docs/DESIGN-TOKENS.md`    | `audits/css-tokens.sh` will fail until you change it too       |
| Docker-only operations           | `.claude/CLAUDE.md` Section 6   | Every script assumes containers                                |

## The non-negotiables

These are security rules, not preferences (`.claude/CLAUDE.md` Section 6). Changing them is changing your
security posture:

- an explicit permission check on every state-changing Ninja endpoint
- user-supplied IDs verified against caller ownership — no IDOR
- invariants enforced in the database, not only in application code
- `DEBUG=False` outside local
- `CORS_ALLOWED_ORIGINS` an explicit allowlist, never `*`
- secrets from the environment, never committed
- Django admin never at `/admin/`

---

## Changing the stack

The template argues against this in several places, and those arguments are in `02-STACK.md`. If you
still want to:

1. Write an ADR in `project-management/src/15-DECISIONS/` — the reasoning outlives the decision.
2. Update `how-to/src/TEMPLATE-TOKENS.md` under _What stays fixed_.
3. Sweep the documentation that asserts the old choice. There is more of it than you expect —
   `code/docs/RENDERING.md`, `ARCHITECTURE-PATTERNS.md`, the stack skills, and the skill
   definitions all describe the stack.
4. Accept that `copier update` will conflict in those files from then on.

Adding a **new tier** to the three-tier frontend rule (template / HTMX / Alpine) is the specific
case the docs treat as an ADR-level change. It is not a dependency decision; it is an architecture
decision.

---

## Keeping updates cheap

The more you edit files the template also maintains, the more `copier update` conflicts.

**Cheap to update:** you added your own files and left the template's alone.
**Expensive:** you rewrote `.claude/CLAUDE.md`, the layer `CONTEXT.md` files, and the workflows.

Two tactics:

- **Append rather than rewrite.** Adding a section to a guide conflicts less than restructuring it.
- **Put project-specific rules in project-specific files.** A new guide of your own under
  `code/docs/` never conflicts; edits to `code/docs/CODING-PRINCIPLES.md` do.

**One thing that is not about conflicts at all: never renumber a
`project-management/src/NN-…/` folder.** Those hold your artefacts, and Copier only tracks files
it generated — so on the next update it moves its own scaffolding to wherever the template says
and leaves your stories and ADRs behind, with no conflict and no warning. Conflicts are noisy and
survivable; this one is silent. `code/src/scripts/audits/template-orphans.sh` detects it, and
`template-update.sh` predicts it before you apply anything (`14-UPDATING.md`).

If you have diverged so far that updates are pure conflict, that is a legitimate end state —
delete `.copier-answers.yml` and treat it as an ordinary repository.

---

## Next

- Add a skill, workflow or app → `12-EXTENDING.md`
- Merge upstream changes → `14-UPDATING.md`
