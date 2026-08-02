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

Every guide, agent and workflow references `code/src/scripts/**`. Renaming one means sweeping the
documentation. Adding scripts is cheap; renaming is not.

### CI workflows

Nine of the fifteen are path-filtered. If you move source out of the paths they watch, they
silently stop running. Check `.github/workflows/*.yml` `paths:` after any structural move.

## House rules — change knowingly

| Rule                             | Where                           | If you change it                                             |
| -------------------------------- | ------------------------------- | ------------------------------------------------------------ |
| Coverage floors 75 % / 90 % auth | `code/docs/testing/COVERAGE.md` | Update the CI gate too, or it disagrees with the doc         |
| 750-line source limit            | `code/CONTEXT.md`               | `audit-cloc.yml` and `cloc.sh` both hardcode the threshold   |
| 300-line instructional-doc limit | `.claude/CLAUDE.md` §8          | The context-budget rationale goes with it                    |
| British English prose            | `.claude/CLAUDE.md`             | Sweep existing docs or you get a mix                         |
| Grilling before substantial work | `.claude/CLAUDE.md` §10         | Agents stop interviewing and start building on first reading |
| Token-first CSS                  | `code/docs/DESIGN-TOKENS.md`    | `audits/css-tokens.sh` will fail until you change it too     |
| Docker-only operations           | `.claude/CLAUDE.md` §1          | Every script assumes containers                              |

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

1. Write an ADR in `project-management/src/13-DECISIONS/` — the reasoning outlives the decision.
2. Update `how-to/src/TEMPLATE-TOKENS.md` under _What stays fixed_.
3. Sweep the documentation that asserts the old choice. There is more of it than you expect —
   `code/docs/RENDERING.md`, `ARCHITECTURE-PATTERNS.md`, the stack skills, and the agent
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

If you have diverged so far that updates are pure conflict, that is a legitimate end state —
delete `.copier-answers.yml` and treat it as an ordinary repository.

---

## Next

- Add an agent, skill, workflow or app → `11-EXTENDING.md`
- Merge upstream changes → `13-UPDATING.md`
