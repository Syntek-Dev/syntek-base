---
name: global-workflow
description: "Cross-cutting engineering standards for <%PROJECT_NAME%> — localisation (en_GB), Git branch strategy, commit and pull-request conventions, semantic versioning, Markdown documentation style, and code-comment rules. Load when creating a branch, writing a commit message or PR, bumping the version, or authoring documentation or code comments — i.e. the conventions every skill shares regardless of layer."
---

# Global Workflow & Standards

Project-wide conventions that sit beneath every layer of <%PROJECT_NAME%>. The
per-layer guides (`code/docs/*`, `project-management/docs/*`) own the deep detail;
this skill is the shared baseline that the task skills (`implement-story`,
`bugfix`, `refactor`, `review`, `security`, `pr`, `release`, `story`) all carry.

**Stack:** Django 6 + Django Ninja + PostgreSQL backend · Django templates +
django-components + HTMX + Alpine, server-rendered throughout
frontend · vanilla CSS/design tokens · django-components UI library.
All dev operations run through `code/src/scripts/**/*.sh` — never raw `pnpm`,
`pytest`, `python`, `manage.py`, or `docker`.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>.

---

## Localisation quick reference

| Setting         | Value                                             |
| --------------- | ------------------------------------------------- |
| **Locale**      | British English (en-GB)                           |
| **Spelling**    | 's' not 'z' (_optimise_, _organise_, _behaviour_) |
| **Vocabulary**  | _postcode_, _CV_, _holiday_, _mobile_             |
| **Currency**    | GBP (£) with format `£1,234.56`                   |
| **Date format** | DD/MM/YYYY                                        |
| **Time format** | 24-hour clock (HH:MM)                             |
| **Timezone**    | <%TIMEZONE%>                                      |

**Code-syntax exception:** keep US English for language reserved words and
framework APIs (CSS `color`, Django `Meta`), but use GB
English for your own identifiers (`colourPalette`, `organisationId`) and all
user-facing copy, docstrings, and comments.

---

## Section map

| Document                                         | Covers                                                                                      |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| [GIT-AND-PR.md](GIT-AND-PR.md)                   | SSH repository setup · branch strategy · commit protocol · pull-request management via `gh` |
| [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md) | Semantic versioning · Markdown documentation style · bug-fix docs · code-comment standards  |

## Where things live (project map)

- **Dev scripts:** `code/src/scripts/**/*.sh` (development, database, tests, syntax, audits).
- **Plugin tools (read-only helpers):** `.claude/plugins/*.py` — e.g.
  `project-tool.py info`, `db-tool.py detect`, `env-tool.py find`, `git-tool.py`.
- **Reference guides:** `code/docs/*` (coding), `project-management/docs/*` (PM, Git, versioning, GDPR, security), `how-to/docs/*` (setup, CLI, worktrees, incidents, authoring).
- **Step-by-step procedures:** `code/workflows/NN-*/`, `project-management/workflows/NN-*/`.
- **Sibling skills:** `.claude/skills/stack-django/`, `.claude/skills/stack-htmx-templates/`.

## When to use this skill

- **Creating a branch** — naming and flow → [GIT-AND-PR.md](GIT-AND-PR.md).
- **Writing a commit** — type, scope, imperative mood, changelog-first → [GIT-AND-PR.md](GIT-AND-PR.md).
- **Raising or reviewing a PR** — `gh` commands, title format, body template → [GIT-AND-PR.md](GIT-AND-PR.md).
- **Bumping a version** — MAJOR/MINOR/PATCH rules, pre-commit steps → [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md).
- **Authoring Markdown docs** — headings, tables, lists, code fences → [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md).
- **Documenting a bug fix** — required format and location → [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md).
- **Writing code comments** — why-only rule, no outside references, one-line comments, no-pronouns rule → [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md).

## Authoritative cross-references

These project docs override anything here where they overlap — this skill is the
shared baseline, they are the source of truth:

- `project-management/docs/GIT-GUIDE.md` — branch naming, commits, PR process.
- `project-management/docs/VERSIONING-GUIDE.md` — single-track semver, changelog format.
- `.claude/CLAUDE.md` — global non-negotiables and routing.
- `code/docs/DOCUMENTATION-PAIRING.md` — the `CONTEXT.md`/`CLAUDE.md` split and route-don't-restate.
- `code/docs/CODE-REVIEW-GRAPH.md` — the graph refresh that ships alongside every docs change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/22-pr-and-review/` — branches, commits, PRs
- `project-management/workflows/23-release/` — version bumps and releases
- `how-to/workflows/02-worktree-setup/` — parallel-story worktrees
