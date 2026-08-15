# Contributing to syntek-base

Thanks for looking. This is the front door for **changes to the template itself**.

If you are looking for the coding standards that apply _inside_ a project generated from this
template — testing, linting, commit hygiene, code quality — that is
[`how-to/src/CONTRIBUTING.md`](how-to/src/CONTRIBUTING.md). This file is about changing
syntek-base.

`syntek-base` is MIT licensed. You do **not** owe us a contribution for using it: fork it, strip
it, rebrand it, build commercial products with it. Contributions are welcome, not expected.

---

## What this repository is

A [Copier](https://copier.readthedocs.io/) template that generates a Django-monolith project
complete with a three-layer documentation system and a Claude Code skill suite. Almost everything
here is documentation and configuration; there is very little application code.

Generate a project with:

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

Full detail: [`how-to/src/TEMPLATE-GUIDE/`](how-to/src/TEMPLATE-GUIDE/).

---

## What we accept

**Good contributions:**

- Bug fixes — a token that does not render, a broken cross-reference, a script that fails on a
  supported platform, a workflow that is wrong
- Security fixes (read [`SECURITY.md`](SECURITY.md) first — report privately, do not open a PR
  that advertises a live vulnerability)
- Documentation that is inaccurate, out of date, or contradicts the code it describes
- Portability fixes — something that assumes Linux where macOS is supported
- New guides or workflows that fit the existing three-layer structure

**Things to raise as an issue before writing code:**

- Changing the stack (adding a dependency, replacing a component). The stack is deliberate and
  documented in `how-to/src/TEMPLATE-TOKENS.md` under _What stays fixed_. There is a strong
  default answer of "no" — but the reasoning is open to argument.
- Adding a token. Every token is a question a human must answer on every future project, forever.
  The bar is high.
- Restructuring the layer system (`code/`, `how-to/`, `project-management/`, `.claude/`).

**What we will decline:**

- Changes that make the template opinionated toward one project's needs at every other project's
  expense
- Reformatting or "tidying" passes with no behavioural change
- Anything that breaks `copier update` for projects already generated from the template

---

## Before you open a pull request

### 1. Generate a project and check it still works

This is the one test that matters. A change can look fine in the template and be broken in
everything generated from it.

```bash
uvx copier copy --trust --defaults \
  --data PROJECT_NAME="Test Project" --data ORG_NAME="Test Org" \
  --data PROJECT_DESCRIPTION="A test project for checking that the template renders end to end." \
  --data DEVELOPER_NAME="You" --data DEVELOPER_EMAIL="you@example.com" \
  --data DATE="01/01/2027" \
  . /tmp/syntek-check

# no token should survive
grep -rIo '<%[A-Z_]*%>' /tmp/syntek-check --exclude-dir=.git | wc -l   # must be 0

# a new project starts at 0.1.0 with its own empty history, not ours
cat /tmp/syntek-check/VERSION                                          # must be 0.1.0
grep -c '^## \[' /tmp/syntek-check/CHANGELOG.md                        # must be 1
```

### 1b. Never touch a versioning document outside the root

**In this repository, a version bump edits exactly six files, all at the root:** `VERSION`,
`VERSION-HISTORY.md`, `CHANGELOG.md`, `RELEASES.md`, the `README.md` badge, and the `CONTEXT.md`
repo-state line. Nothing else, ever.

The versioning documents under `code/src/django/` and `code/src/mobile/` are **seed content**.
They ship to every generated project as that project's starting point and must stay pinned at
`0.1.0` with their single scaffold entry. Bumping them here would hand a brand-new project a
sub-package history describing the template's development instead of its own.

The same applies in reverse to the four root files: they are excluded from generation and shipped
fresh from `.copier/`, so editing them changes syntek-base's history and nothing downstream. That
is deliberate — see `project-management/docs/VERSIONING-GUIDE.md` → _Your version history is
yours_.

> This is a syntek-base rule, not a rule for projects generated from it. A generated project has
> real sub-packages that legitimately release on their own tracks.

### 2. Respect the delimiter contract

Tokens are written `<%TOKEN%>`, blocks `<: … :>`, comments `<~ … ~>`. **Not `{{ }}`.**

This is not a style preference. The repository contains GitHub Actions expressions (`${{ }}`),
Django template syntax (`{% %}` and `{{ }}`), Bruno variables (`{{api_url}}`) and bash tests
(`[[ ]]`) — Jinja's usual delimiters, and the obvious alternatives, all collide with real content.
The chosen set was verified to appear nowhere in the tree.

If you add content that literally contains `<%`, `%>`, `<:`, `:>`, `<~` or `~>`, wrap it in
`<: raw :>` … `<: endraw :>`, and say so in the PR.

Full reasoning: [`how-to/src/TEMPLATE-TOKENS.md`](how-to/src/TEMPLATE-TOKENS.md).

### 3. Keep the documentation gate

This repository holds documentation to the same standard as code:

- Instructional `.md` files (`**/docs/*.md`, `**/workflows/**/*.md`, `.claude/**/*.md`, every
  `CONTEXT.md`) stay **under 300 lines**. Oversized files split, and the entry point becomes a
  thin index. Files under `**/src/*.md` are exempt — they are operator guides for humans.
- Every directory with a `CONTEXT.md` also has a `CLAUDE.md`. `CONTEXT.md` is orientation
  (the tree, what is here); `CLAUDE.md` is operating rules.
- If you add or move a file, update the directory tree in the nearest `CONTEXT.md` and any
  `REFERENCES.md` that indexes it.
- Prose is **British English (en_GB)**.

### 4. Run the checks

```bash
pnpm lint:md                                        # markdownlint across every .md
bash code/src/scripts/syntax/lint.sh                # ruff + markdownlint
bash code/src/scripts/syntax/format.sh              # prettier + ruff format (dry run; --fix to apply)
bash .github/scripts/check-template-tokens.sh       # token SHAPE — run after any Markdown format
bash .github/scripts/check-template-parsers.sh      # token POSITION — every manifest must still parse
```

> **Why that last check matters.** Token names contain underscores, and Prettier's Markdown
> formatter treats `_` as emphasis. In a paragraph containing both a token and `_emphasis_`,
> Prettier can pair them and rewrite `<%PROJECT_NAME%>` into `<%PROJECT_NAME%>` — which then
> renders as an undefined variable and vanishes from every generated project. Prefer `**bold**`
> over `_emphasis_` near a token.
>
> The script also catches tokens that are not registered questions in `copier.yml` (they render
> to nothing) and unclosed `<%` delimiters (they kill generation outright). CI runs it on every
> pull request.
>
> **The second script is the other half, and it is not a text check.** A token is inert in a
> comment and fatal in any position a parser validates as a name — the delimiters `<`, `%` and
> `>` are not legal in one. Those two cases look identical to a grep, and are not even
> consistent between tools: pnpm accepts `<%PROJECT_SLUG%>` in `package.json`'s `name` while uv
> rejects it in `pyproject.toml`'s. So rather than guess, `check-template-parsers.sh` runs each
> toolchain's own parser — `uv`, `cargo`, `pnpm`, `docker compose` — and requires every manifest
> to load **in the template**. A file that only parses after generation takes its gates down
> with it, and nobody looks there. Rule: `how-to/src/TEMPLATE-TOKENS.md`.

All developer operations go through the scripts in `code/src/scripts/` — never raw `python`,
`pytest`, `pnpm`, `uv` or `docker`.

---

## Branches and commits

Branch from `main`:

| Prefix               | For                                        | Example                 |
| -------------------- | ------------------------------------------ | ----------------------- |
| `us###/<short-desc>` | work scoped to a user story                | `us015/homepage-layout` |
| `pm/<short-desc>`    | documentation, process, template mechanics | `pm/copier-migration`   |

Commits follow [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <description>
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, `style`
**Scopes:** `backend`, `frontend`, `api`, `db`, `ci`, `docs`, `infra`, `template`

Do not bump the version in your PR — versioning is single-track and handled on merge
(`project-management/docs/VERSIONING-GUIDE.md`).

### syntek-base's public API

Semantic Versioning requires a declared public API, or MAJOR has no referent. `VERSIONING-GUIDE.md`
carries the rule and the declaration a **generated project** makes; this repository's own is
different, and is stated here rather than there because that guide ships into every generated
project, where a statement about `copier.yml` would be meaningless.

> **syntek-base's public API is the template contract**: the `copier.yml` questions and tokens, the
> shape of the generated tree, and the `.claude/` routing contract a generated project inherits and
> `copier update` re-applies.

It is **not** the Django Ninja `/api/` surface — that belongs to the generated project and moves on
the `code/src/django/` sub-package track.

What this makes decidable, with no argument left over:

| Change to the template                                                        | Increment |
| ----------------------------------------------------------------------------- | --------- |
| Removing or renaming a Copier question or token; removing a routing contract  | **MAJOR** |
| Moving or deleting a directory a generated project inherits                   | **MAJOR** |
| Adding a question with a default, a new guide, a new skill, a new workflow    | MINOR     |
| Correcting prose, a link, a script, or a gate that changes no inherited shape | PATCH     |

A MAJOR bump to the template also requires a `_migrations:` entry in `copier.yml`, because an
existing project has to be carried across the break rather than left on the old contract.

---

## What CI will run against you

`main` is protected. A pull request is required, and these checks must pass before it can merge:

| Check                       | What it enforces                                                                                                                               |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `[1/8] Line Count`          | no source file over 800 lines                                                                                                                  |
| `[2/8] Lockfile Alignment`  | `uv.lock` and `pnpm-lock.yaml` match their manifests                                                                                           |
| `[3/8] Format`              | ruff format + Prettier                                                                                                                         |
| `[4/8] Lint`                | ruff + ESLint                                                                                                                                  |
| `[5/8] Stub Audit`          | no `NotImplementedError`, `TODO`, `FIXME`, `HACK`                                                                                              |
| `[6/8] Type-check`          | basedpyright                                                                                                                                   |
| `[7/8] Tests`               | pytest                                                                                                                                         |
| `[8/8] Security`            | static security audit                                                                                                                          |
| `TruffleHog — Secrets Scan` | no credentials committed                                                                                                                       |
| `[1/2] Template Tokens`     | no mangled, unregistered or unclosed tokens                                                                                                    |
| `[2/2] Template Generation` | a project actually generates from your branch, with zero surviving tokens, no template-only file leaking, and `${{ }}` / `[[ ]]` syntax intact |

Conversations on the PR must be resolved before merge. Force-pushes and branch deletion on `main`
are blocked.

Other workflows (Markdown lint, CSS token audits, e2e tests) run only when relevant paths change,
so they are advisory rather than blocking — but a failure in one is still a failure. Fix it.

---

## Licensing of contributions

By opening a pull request you agree that your contribution is licensed under the
[MIT Licence](LICENSE), the same terms as the rest of the repository. There is no CLA to sign and
no copyright assignment.

If you are contributing on behalf of an employer, make sure you have the right to do so.

---

## Reporting problems

- **Security vulnerability** → [`SECURITY.md`](SECURITY.md). Never a public issue.
- **Bug** → open an issue with the _Bug report_ template.
- **Template improvement** → open an issue with the _Template improvement_ template.
- **Question** → open a discussion or an issue; there is no wrong door.

We are a small team and this is maintained alongside client work. Expect days, not hours.
