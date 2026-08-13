---
type: guide
skills: [code-reviewer, global-workflow]
model: opus
---

# Coding Principles — Style, Security, Dependencies, and Process

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Code style, testing, comments, dependency vetting, and development process

---

## Testing

Every public function, service, and API endpoint requires tests. See
[`../TESTING.md`](../TESTING.md) for the full testing guide.

Summary of requirements:

- Every public service method or utility function has at least one unit test.
- Every HTTP endpoint has integration tests covering the happy path, error paths, and auth failures.
- Every new database migration has a test verifying the migration runs and rolls back cleanly.
- Tests are independent — no test relies on another having run first.
- Test names describe the scenario: `test_login_fails_with_expired_token` not `test_login_2`.

---

## Comments and Documentation

Comments and docstrings in a code file carry the **why** — never the what, who, how, when, or
where. The code states what it does; names, types, and structure already carry it, and a comment
that repeats them is a duplicate fact that drifts out of date. If the what is not clear from the
code, rename or split the code instead of describing it.

Everything else — the what, the how, the history, the story it came from, the decision behind it —
lives in the developer documentation (`code/docs/*`, `CONTEXT.md`, `CHANGELOG.md`, the PM
artefacts), which is free to carry all of it. A code file never repeats it.

**Scope:** application source that ships in a deployable — `.py`, `.html`, `.css`, `.js`, `.ts`,
`.tsx`, `.rs`, `.slint`. Two exemptions, both because the reference _is_ the content: declarative
configuration (`deny.toml`, `pyproject.toml`, `.gitignore`, CI YAML) — where a policy exception
needs the trail that justifies it; and `code/src/scripts/**/*.sh`, operator tooling that often
names the rule or document it enforces.

- **Write a comment only for a non-obvious reason** — a constraint the code cannot state, an
  invariant holding across a distance, a deliberate trade-off, or a workaround plus the condition
  for removing it. If deleting the comment would not confuse the next reader, delete it.
- **No outside references.** Never cite a story (`US###`), sprint, ADR, plan, bug record, ticket,
  issue, PR, commit, `code/docs/*` path, URL, person, or date. The reason belongs in the comment
  itself — a reader who cannot open the reference still has to understand why.
- **No `TODO` / `FIXME` in committed code.** Deferred work goes to `DEFERRED.md` or `GAPS.md`,
  which are read and triaged.
- **Docstrings** are mandatory on all public APIs and are **one line stating why the thing
  exists** — no `Args:` / `Returns:` / `Raises:` blocks, because the typed signature already
  carries them. Every Django view and django-component opens with one; templates carry a one-line
  `{# #}` comment on the same terms.
- **Exception — published interface text.** A Django Ninja endpoint docstring and `summary` (both
  render on the OpenAPI page) and a FastMCP tool docstring (the prompt a model reads when choosing
  a tool) are interface documentation, not comments: they state the full what. See
  [`../api-design/API-DOCS.md`](../api-design/API-DOCS.md) and
  [`../mcp-server/TOOL-DESIGN.md`](../mcp-server/TOOL-DESIGN.md).
- **No commented-out code** in committed files. Delete it; git history is the recovery mechanism.

---

## Security

- **Never hardcode** secrets, API keys, or credentials in any file committed to this repository.
  All secrets live in environment variables or a secrets manager.
- **Always validate and sanitise** user input at system boundaries. Assume all external input is
  hostile until proven otherwise.
- **Parameterised queries** for all database access. String interpolation into SQL is never
  acceptable — use the ORM or prepared statements.
- **Principle of least privilege**: every service, user, role, and token has only the permissions
  it needs and nothing more.
- **Pin all dependencies** explicitly. Unpinned dependencies are a supply-chain risk.
- See [`../SECURITY.md`](../SECURITY.md) for detailed security patterns and the compliance
  checklist.

---

## Dependencies

Don't add a dependency for something you can write correctly in under 50 lines. Before adding any
dependency, answer all five questions:

1. Can this be implemented simply without it? If yes, write it.
2. Is it actively maintained? (Recent commits, issues acknowledged and resolved)
3. Does it have a clean security track record? (Check CVE databases and `pnpm audit` / `pip-audit`)
4. Is the licence compatible? (MIT, Apache 2.0, ISC are acceptable; GPL requires careful review)
5. Is the version pinned explicitly? Never use unbounded version ranges.

Pin runtime dependencies in `pyproject.toml` and commit `uv.lock`. The `package.json` at the root
carries **repo tooling only** (markdownlint, Prettier, lefthook, Bruno) — nothing there ships to
the browser, and nothing should start to.

---

## Git and Version Control

- **Atomic commits**: each commit does exactly one thing. Mixed concerns belong in separate commits.
- **Conventional Commits format**: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`. Subject line
  under 72 characters. Body explains the reasoning and context, not the diff.
- **Never commit** generated files, secrets, `.env` files, or environment-specific configuration.
- **Branch naming** follows the team convention `<story-id>/<short-description>` (e.g.
  `feat/payment-capture`).
- **Pull requests** require a description explaining what changed and why, with a reference to the
  story or ticket ID.
- Force-push is only permitted on personal feature branches before a PR is opened, never after.

---

## Logging

| Level     | Use for                                                     |
| --------- | ----------------------------------------------------------- |
| `DEBUG`   | Development detail — request payloads, query parameters     |
| `INFO`    | Significant state changes — user created, payment processed |
| `WARNING` | Recoverable issues — retry attempted, fallback used         |
| `ERROR`   | Failures requiring attention — payment failed, write error  |

**Rules:**

- **Never use `print()` (Python) or `console.log()` (browser JS) in committed code.** Always use
  the project logger so output flows through the configured handlers. `print()` and `console.log()`
  bypass every handler — they are invisible to observability tooling.
- Temporary debug statements must be removed before the fix is committed.
- Include enough context to diagnose the issue without re-running: include IDs, paths, and relevant
  values alongside the error.
- Never log sensitive data: passwords, tokens, secret values, or PII.
- In production, use structured logging (JSON) where possible.

---

## Code Review Checklist

Before submitting code for review or marking a task complete, verify:

- [ ] Errors are handled explicitly — no silent failures or unchecked exceptions
- [ ] All public functions and service methods have tests
- [ ] Test names describe the scenario being tested
- [ ] The code follows existing patterns in the codebase
- [ ] A stranger could understand this code in six months without context
- [ ] No secrets, credentials, or API keys are present in the diff
- [ ] No new dependency was added without evaluation
- [ ] Every modified file stays within the 750-line limit
- [ ] Relevant documentation has been updated
- [ ] No commented-out code was left in the diff
- [ ] Every comment and docstring in the diff carries a **why** — none restates a name, a type,
      or the line below it
- [ ] No comment points outside the code file — no `US###`, sprint, ADR, ticket, PR, commit,
      documentation path, URL, person, or date
- [ ] No `TODO` / `FIXME` was introduced — deferred work is recorded in `DEFERRED.md` or `GAPS.md`
- [ ] Docstrings are one line, with no `Args:` / `Returns:` / `Raises:` block (except a published
      Ninja endpoint or FastMCP tool docstring, which states the full what)
- [ ] All imports are at the top of the file — no imports inside functions, methods, or classes
      unless a documented justified exception applies
- [ ] Conditional chains of three or more branches encoding a named business rule are extracted to
      a Policy or Strategy

For backend-specific checklist items (Python `except` syntax, `transaction.atomic()`, caching),
see [`../BACKEND-CODING-PRINCIPLES.md`](../BACKEND-CODING-PRINCIPLES.md).

For frontend-specific items (class components, `console.log`, CSS query ordering), see
[`../FRONTEND-CODING-PRINCIPLES.md`](../FRONTEND-CODING-PRINCIPLES.md).

_Part of the `code/docs/` documentation family. See [`../CODING-PRINCIPLES.md`](../CODING-PRINCIPLES.md) for the full index._
