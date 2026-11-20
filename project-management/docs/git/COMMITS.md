---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — Commits

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — pre-commit and pre-push gates, commit message conventions

What has to be green before a commit and before a push, and the shape the message itself takes.
Index: [`../GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## Before Every Commit

Run these commands before every commit — no exceptions.

### Step 0 — Stage by explicit path

**Never `git add -A` or `git add .`.** Name every path you are committing. A tree can be written
to by more than one session or agent at once — parallel stories in worktrees, a dispatched
subagent, a second terminal — and a blanket add sweeps someone else's in-flight work into your
commit, where it clears the gates below as though you had written it.

The same applies in reverse when a gate fails in a file you touched: **check its `ls -la` mtime
against your own last write before assuming the fault is yours.**

### Step 1 — Apply what can be applied

```bash
bash code/src/scripts/syntax/lint.sh --fix --file-type python
```

### Step 2 — Verify every surface this project has

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

**Unscoped deliberately.** A bare run covers exactly the surfaces that are present — it
adds `typescript` when `code/src/mobile/` exists and `rust` when `code/src/rust/` does,
and leaves each out otherwise. That is what makes these same two lines correct on a
web-only project and on one carrying all three surfaces.

Scope with `--file-type` when you want faster feedback on one thing:

| Token              | Covers                                                   | Tools                            |
| ------------------ | -------------------------------------------------------- | -------------------------------- |
| `python`           | `code/src/django/`                                       | ruff · basedpyright              |
| `javascript`       | the **web** surface — Alpine and enhancement scripts     | ESLint (root config)             |
| `typescript`       | **mobile-only** — `code/src/mobile/`                     | ESLint (mobile config) · `tsc`   |
| `rust`             | **rust-only** — `code/src/rust/`, desktop crate included | rustfmt · clippy · `cargo check` |
| `markdown` · `css` | repo-wide                                                | markdownlint · Prettier          |

Two things the table does not say twice. `javascript` and `typescript` name **different
surfaces** and never overlap: the root ESLint config ignores `code/src/mobile/`, and
TypeScript exists nowhere else. And naming a surface this project does **not** have is an
**error, not a no-op** — `--file-type typescript` on a web-only project exits `2`,
because a check that could not run must never be reported as a check that came back clean.

### Step 3 — Commit

Only commit once both commands exit `0`.

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

### The planned-red trailer

A commit that deliberately records a failing probe ahead of its fix — test-first, where the probe
sits in a gate's own self-test — names that gate and the probes it expects red in a trailer:

```text
Planned-Red: <self-test script basename>::<probe label>[::<probe label>…]
```

It is the record of an opt-in, never a substitute for one: the commit is made with
`PLANNED_RED=` set to the same value, and the pre-commit leg running that self-test requires it
to exit `1`, to finish, and to fail **exactly** the named probes — each new against `HEAD` — with
everything else green. A planned red may only **add** probes: every probe `HEAD` runs must still
pass, the failure count must match the failures recorded, and the script's diff against `HEAD`
adds lines and changes none (in a detector, only inside its `self_test()` region). The
commit-message leg refuses a `Planned-Red:` trailer without the opt-in, a second one, one that
differs from it, or one the pre-commit leg did not accept for this staged tree, and a merge
commit never carries one; a cherry-pick or rebase copies the trailer without either leg running,
so the trailer proves acceptance only for a commit the hooks judged as it was made. It sits beside
the co-author trailer, in the closing trailer block. A planned-red commit is changed by
`git reset --soft HEAD^` and committed again, never amended. `--no-verify` is never the way to
land a red probe. <!-- Section added 19/11/2026; probe labels and the commit-bound check 19/11/2026; only-adds and the copied-trailer limit 20/11/2026. -->

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
