---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Git workflow, branch strategy, commit conventions, PR process, git worktree naming
**MCP Servers:** None (process/workflow documentation)

---

## Parallel Development — Git Worktrees

When two or more stories can be worked on simultaneously, use git worktrees to run each
branch in its own directory with an isolated Docker stack. Full guide and naming convention:
`how-to/docs/GIT-WORKTREES.md` · Workflow: `how-to/workflows/02-worktree-setup/`

**Naming rules (summary):**

| Slot                | Pattern                                     | Example                                     |
| ------------------- | ------------------------------------------- | ------------------------------------------- |
| Worktree path       | `../<%PROJECT_SLUG%>-us###`                 | `../<%PROJECT_SLUG%>-us003`                 |
| Dev Docker project  | `<%PROJECT_SLUG%>-dev-us###`                | `<%PROJECT_SLUG%>-dev-us003`                |
| Test Docker project | `<%PROJECT_SLUG%>-test-us###`               | `<%PROJECT_SLUG%>-test-us003`               |
| Dev URL             | `dev-us###.<%PROJECT_SLUG%>.localhost:3080` | `dev-us003.<%PROJECT_SLUG%>.localhost:3080` |
| Test URL            | `test-us###.<%PROJECT_SLUG%>.localhost`     | `test-us003.<%PROJECT_SLUG%>.localhost`     |
| Nginx loopback IP   | `127.0.0.X` (X = story number)              | `127.0.0.3`                                 |

---

## Branch Strategy

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Branch          | Purpose                                                                   |
| --------------- | ------------------------------------------------------------------------- |
| `us###/feature` | Feature work scoped to a single user story (e.g. `us001/homepage-layout`) |
| `testing`       | Dev team QA — CI + manual testing before merging to dev                   |
| `dev`           | Integration branch — all in-progress features merged here                 |
| `staging`       | Pre-production — acceptance tests run here                                |
| `main`          | Production-ready code — client-accepted releases only                     |

Branch names follow one of two prefixes:

| Prefix               | When to use                                                  | Example                 |
| -------------------- | ------------------------------------------------------------ | ----------------------- |
| `us###/<short-desc>` | Feature or fix work scoped to a user story                   | `us015/homepage-layout` |
| `pm/<short-desc>`    | Project management work (stories, sprints, wireframes, docs) | `pm/wireframes-figma`   |

---

## Before Every Commit

Run these commands before every commit — no exceptions.

### Step 1 — Backend lint

```bash
bash code/src/scripts/syntax/lint.sh --fix --file-type python
bash code/src/scripts/syntax/lint.sh --file-type python
```

### Step 2 — Frontend lint and type-check

```bash
bash code/src/scripts/syntax/lint.sh --file-type typescript
bash code/src/scripts/syntax/check.sh --file-type typescript
```

### Step 3 — Commit

Only commit once all linters exit cleanly.

---

## Before Every Push

Run the full test suite before pushing any branch:

```bash
# Full suite — services, endpoints, templates, and HTMX partials
bash code/src/scripts/tests/backend.sh

# Add the Bruno API integration tests
bash code/src/scripts/tests/all.sh --api
```

Only push when all tests pass.

---

## Commit Message Format

```text
<type>(<scope>): <Description> - <Summarise>

<Body>

Files Changed:
- path/to/file

Still to do:
- task

Version: <old> → <new>
```

### The co-author trailer

Every commit an agent writes ends with a co-author trailer naming the model that wrote it:

```text
Co-Authored-By: Claude <model> <noreply@anthropic.com>
```

`<model>` is the family and its current major — the name in `.claude/CLAUDE.md` Section 4, read at
the time of the commit. **It is never pinned in a rule**, here or in a skill: a hardcoded
version string goes stale on the next model release and then every commit misattributes itself
to a model that did not write it. The same applies to a PR body's generation footer.

### Type values

| Type       | When to use                                         |
| ---------- | --------------------------------------------------- |
| `feat`     | New feature or page                                 |
| `fix`      | Bug fix                                             |
| `refactor` | Code change that is neither a fix nor a new feature |
| `test`     | Adding or updating tests                            |
| `docs`     | Documentation only                                  |
| `chore`    | Tooling, config, dependencies, version bumps        |
| `ci`       | CI/CD workflow changes                              |
| `perf`     | Performance improvement                             |
| `style`    | Formatting only (no logic change)                   |

### Scope values

| Scope      | Meaning                                           |
| ---------- | ------------------------------------------------- |
| `backend`  | Django backend changes                            |
| `frontend` | Django template & component changes (public site) |
| `api`      | Django Ninja API (routers, endpoints, schemas)    |
| `db`       | Django migrations or schema changes               |
| `ci`       | CI workflow files                                 |
| `docs`     | Documentation files                               |
| `infra`    | Docker Compose or environment config              |

### Signalling a breaking change

A breaking change is signalled **in the commit**, not left to be inferred from the diff at release
time. Two forms, and either is sufficient:

| Form                          | Where                                        | Example                                                                        |
| ----------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------ |
| **`!` shorthand**             | Immediately before the `:` in the type/scope | `feat(api)!: drop the v1 booking payload`                                      |
| **`BREAKING CHANGE:` footer** | A footer at the end of the commit body       | `BREAKING CHANGE: the v1 booking payload no longer accepts a bare customer_id` |

Use the footer whenever the consequence needs a sentence — the `!` alone tells a reader that
something broke but not what. Using both is fine and often clearest.

**How type maps to the increment:**

| Commit carries                     | Increment                      |
| ---------------------------------- | ------------------------------ |
| `fix`                              | PATCH                          |
| `feat`                             | MINOR                          |
| `!` or a `BREAKING CHANGE:` footer | **MAJOR — regardless of type** |

A `docs!:` or `chore!:` commit is a MAJOR just as surely as a `feat!:` one. **What counts as
breaking is decided against the declared public API**, not against the size of the diff —
`project-management/docs/VERSIONING-GUIDE.md` owns that declaration and the increment rules; this
guide owns only how a commit says so.

---

## PR Flow

All feature branches must travel the full promotion order. Never skip a stage.

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Merge step                  | Gate                                                       |
| --------------------------- | ---------------------------------------------------------- |
| `us###/feature` → `testing` | Tests pass locally; PR opened to `testing` only            |
| `testing` → `dev`           | CI passes on `testing`; QA sign-off                        |
| `dev` → `staging`           | CI passes on `dev`; lead sign-off; no regressions          |
| `staging` → `main`          | Staging sign-off; version bump and changelog entry present |

### Rules

- Feature branches always target `testing` — never `dev`, `staging`, or `main` directly
- A branch rejection at any stage goes back to the original `us###/feature` branch for fixes

---

## Required status checks and path filters

**A workflow may be path-filtered, or it may be a required status check. Never both.**

GitHub treats a required check as satisfied only when it **reports**. A path-filtered workflow
does not run at all when a pull request touches none of its paths — so it never reports, and the
check sits _Expected — waiting for status_ forever. The pull request cannot merge, and there is
nothing to re-run: the job was never queued. A documentation-only PR blocked by a required CSS
audit is the usual way this is discovered.

So each CI workflow makes one choice, and **says which in a comment at the top of the file**:

| Kind                      | Path filter   | Why                                                                     |
| ------------------------- | ------------- | ----------------------------------------------------------------------- |
| **Required status check** | **None**      | It must report on every pull request, including ones it has no work for |
| **Advisory / audit**      | Path-filtered | It runs only when its own inputs change, and never blocks a merge       |

The audits under `code/src/scripts/audits/` are the second kind: one path-filtered workflow each,
none of them a required check. That is what lets them be cheap and specific. A workflow with no
path filter (`syntax-markdown.yml`, `syntax-js-ts.yml`, `audit-template.yml`) is deliberately
unfiltered because it **is** a required check.

**Promoting an audit to required means deleting its path filter in the same change.** Adding it
to the branch-protection list while it still carries `paths:` is the failure above, and it will
not be obvious — the first PR to trip it will look like a GitHub outage.

---

## Database Migration PR Gates

These checks are **mandatory** for any PR that adds or modifies a Django migration. They run
during code review at the `us###/feature → testing` step. A PR that fails any of these gates
must not be merged.

### Gate 1 — HMAC Token Completeness Check

Every migration that adds an **encrypted, uniquely-looked-up PII field** must add its HMAC
companion column in the same migration. Cross-check it against the encryption spec in the
story's database-design and QA docs (`src/04-DATABASE/`, `src/11-QA/`).

For each such field, verify **all** of the following before approving:

- [ ] The HMAC companion column exists in the migration (e.g. `email_token VARCHAR(64)`)
- [ ] The data type is `VARCHAR(64)` (not `TEXT` or `CHAR`)
- [ ] The correct index type is created — `UNIQUE` or non-unique, as the field requires
- [ ] A `RunSQL` block or `models.Index` creates the index explicitly (not left to Django auto)
- [ ] The pre-save signal or model `save()` override populates the token before every `INSERT`
- [ ] Both the encrypted field and its HMAC companion are nulled together on GDPR erasure

**Do not approve the PR if any encrypted-unique field is missing its companion column, has the
wrong data type, is missing its index, or the pre-save signal is not wired up.**

---

### Gate 2 — `app_user` Grant Check

Every migration that creates a table must include explicit `GRANT` statements for `app_user`
on that table — the runtime role has no implicit privileges under row-level security:

- [ ] `GRANT SELECT, INSERT, UPDATE, DELETE ON <table> TO app_user;` present for each table
- [ ] `GRANT USAGE, SELECT ON SEQUENCE <table>_id_seq TO app_user;` present for each table
- [ ] For INSERT-only tables (e.g. an audit log): `UPDATE` and `DELETE` are explicitly revoked

Where a CI check verifies grant completeness after each migration, the reviewer must confirm
it passed before approving.

---

## Staging Migration Gates

These checks apply at the `dev → staging` promotion step for any **risky** migration — a data
migration, a schema change with a backfill, a new constraint or trigger, or a grant change.

Run **before** the migration is applied on staging, and again **after**, then record the results
in the PR description before requesting the `staging → main` sign-off.

### Which migrations need staging verification?

Any migration whose failure mode is data loss or a privilege gap. Record each one in the
story's database QA doc with its risk, following this shape:

| Migration          | Story   | Risk                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `<migration name>` | `US###` | `<what could go wrong — e.g. row-count integrity on change>` |

### Staging verification procedure

For each affected migration:

1. **Record the pre-migration count** with the verification query for that migration. Paste
   the result into the PR description.

2. **Apply the migration on staging:**

   ```bash
   bash code/src/scripts/database/migrate.sh run
   ```

3. **Run the post-apply verification queries** and paste the results into the PR
   description.

4. **For data migrations:** confirm the total row count is identical before and after (no
   rows created or deleted beyond what is documented in the migration).

5. **For `app_user` grant migrations:** run the privilege check queries:

   ```sql
   SELECT has_table_privilege('app_user', '<table_name>', 'SELECT');
   SELECT has_table_privilege('app_user', '<table_name>', 'INSERT');
   SELECT has_table_privilege('app_user', '<table_name>', 'UPDATE');
   SELECT has_table_privilege('app_user', '<table_name>', 'DELETE');
   ```

6. **Sign off in the PR description** with the format:

   ```text
   Staging migration verified — <migration name>
   Pre-apply: <count> rows
   Post-apply: <count> rows (expected: <N>)
   Grant check: PASS
   Verified by: <name>, <DD/MM/YYYY>
   ```

**The `staging → main` PR is blocked until staging verification sign-off is present in the PR
description for every affected migration.**
