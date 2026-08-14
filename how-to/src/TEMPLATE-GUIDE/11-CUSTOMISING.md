# Customising — What Is Yours to Change

**Last Updated**: 02/08/2026

It is your project. You can change anything. This is about which changes are cheap, which are
load-bearing, and which will hurt on the next `copier update`.

---

## Three categories

| Category         | Meaning                                                                  |
| ---------------- | ------------------------------------------------------------------------ |
| **Yours**        | Expected to change. The template ships a starting point, not an answer.  |
| **Load-bearing** | Something else depends on it. Changeable, but change the dependants too. |
| **House rules**  | Deliberate constraints. Changing them is fine — just do it knowingly.    |

---

## Yours — change freely

- **Everything under `code/src/django/apps/`.** The app skeleton is a starting point.
- **`project-management/src/`** — your stories, sprints, ADRs, threat models, QA plans.
- **Design tokens.** Values are DB-canonical in `apps/design_tokens`; edit through the
  `/admin/design-tokens` editor or a migration.
- **Brand assets** in `project-management/src/00-ASSETS/` and the generated brand-guide PDF.
- **`.claude/MEMORY.md`** — project memory is meant to accumulate.
- **`GAPS.md`, `DEFERRED.md`** — working documents.
- **Dependencies**, within the licence constraints in `how-to/src/CONTEXT.md`.

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

Nine of the fifteen are path-filtered. If you move source out of the paths they watch, they
silently stop running. Check `.github/workflows/*.yml` `paths:` after any structural move.

### The opt-in mechanism

Optional content — today, the mobile surface — is gated by **one mechanism and one only**: a
templated `_exclude` entry in `copier.yml`.

```yaml
_exclude:
  - "<: if not INCLUDE_MOBILE :>/code/src/mobile<: endif :>"
  - "<: if not INCLUDE_MOBILE :>/code/src/scripts/mobile<: endif :>"
```

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

`copier.yml` sets `_templates_suffix: ""`, which means **every file in the tree passes through
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

## House rules — change knowingly

| Rule                             | Where                           | If you change it                                               |
| -------------------------------- | ------------------------------- | -------------------------------------------------------------- |
| Coverage floors 75 % / 90 % auth | `code/docs/testing/COVERAGE.md` | Update the CI gate too, or it disagrees with the doc           |
| 750-line source limit            | `code/CONTEXT.md`               | `audit-cloc.yml` and `cloc.sh` both hardcode the threshold     |
| 300-line instructional-doc limit | `.claude/CLAUDE.md` §8          | The context-budget rationale goes with it                      |
| British English prose            | `.claude/CLAUDE.md`             | Sweep existing docs or you get a mix                           |
| Grilling before substantial work | `.claude/CLAUDE.md` §10         | Claude stops interviewing and starts building on first reading |
| Token-first CSS                  | `code/docs/DESIGN-TOKENS.md`    | `audits/css-tokens.sh` will fail until you change it too       |
| Docker-only operations           | `.claude/CLAUDE.md` §1          | Every script assumes containers                                |

## The non-negotiables

These are security rules, not preferences (`.claude/CLAUDE.md` §6). Changing them is changing your
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

1. Write an ADR in `project-management/src/14-DECISIONS/` — the reasoning outlives the decision.
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
- **Put project-specific rules in project-specific files.** A new `code/docs/OUR-CONVENTIONS.md`
  never conflicts; edits to `code/docs/CODING-PRINCIPLES.md` do.

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
