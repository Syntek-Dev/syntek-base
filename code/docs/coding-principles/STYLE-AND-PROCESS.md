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

**Scope:** every file this repository executes — application source in a deployable (`.py`,
`.html`, `.css`, `.js`, `.ts`, `.tsx`, `.rs`, `.slint`) **and every script file (`*.sh`), wherever
in the repository it sits.** A script is held to the same standard as any other language: its
comments carry the why. What a script may additionally do is **route** — see the enforcement
pointer below, which is a narrow permission and not a second standard.

One exemption, because there the reference _is_ the content: declarative configuration
(`deny.toml`, `pyproject.toml`, `.gitignore`, CI YAML), where a policy exception needs the trail
that justifies it. A `run:` block inside CI YAML is a script and takes the rule.

**A docstring and a comment answer different questions, and that is what sets their length.**
The docstring says why the **unit** exists — the module, class, function, method or component as
a whole. A comment says why **this line** is here, inside the unit that contains it. One is about
a thing; the other is about a position in it.

- **A comment is one line.** Write one only for a non-obvious reason — a constraint the code
  cannot state, an invariant holding across a distance, a deliberate trade-off, or a workaround
  plus the condition for removing it. If deleting it would not confuse the next reader, delete it.
- **A docstring runs as long as its why needs**, and no longer. It is mandatory on all public
  APIs. No `Args:` / `Returns:` / `Raises:` blocks — the typed signature already carries them, and
  restating a signature is the _what_ under another name. Every Django view and django-component
  opens with one; a template's `{# #}` is a **comment** and takes the one-line rule above.
- **Self-contained — no outside references, in either.** Never cite a story (`US###`), sprint,
  ADR, plan, bug record, ticket, issue, PR, commit, **a repository path**, URL, person, or date.
  A file in scope must be understandable without opening anything else: state the reason in full,
  here, or do not state it. A pointer is not a reason, and it rots at a different rate from the
  code it sits in. **This bullet said "anything under `code/src/`" until 23/08/2026**, which was
  narrower than the Scope paragraph above it and left every `*.sh` outside that tree unaddressed
  by the rule that names them.
- **Exception — the enforcement pointer, and the test is who owns the fact.** A file whose **job
  is to enforce a documented rule** may name the document that owns it. That is **routing**, and
  it is the opposite of the duplication this standard exists to prevent: the alternative — "state
  the reason in full, here" — puts a second copy of the rule inside the enforcement, which is the
  drift this repository charts as split doctrine. **Restating the rule's content is still banned**;
  what is permitted is the name of its owner, and enough of the reason to know why the check
  exists at all.
  - **The discriminator:** the file's subject is the rule. An audit under `code/src/scripts/`, a
    pre-PR hook, a template-integrity check — each exists **because** a guide says something, and
    the guide is a fact about the file rather than an outside reference. A service module, a view
    or a component does not enforce a guide, it implements a feature; there a pointer is still a
    substitute for a reason and is still banned.
  - **It does not travel upward.** A comment on a line of application code may not name a guide
    because the enclosing file happens to be a script's neighbour, and an enforcing file may not
    name a story, a sprint, a commit or a person under cover of this exception. The permission is
    to name **the owning document**, nothing else.
- **Exception — the setup instruction.** A note on **placeholder content the project replaces at
  first-time setup** may name the document that governs the replacement. Both halves are
  required: the subject is shipped placeholder copy rather than code, and the path named is what
  the replacement is written against. The test is who loses what when it is deleted — an
  **operator** loses an instruction, never a **reader** a reason. A pointer that explains why
  code does what it does is the banned shape however it is worded.
- **No `TODO` / `FIXME` in committed code.** Deferred work goes to `DEFERRED.md` or `GAPS.md`,
  which are read and triaged.
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
- [ ] Neither a comment nor a docstring points outside the code file — no `US###`, sprint, ADR,
      ticket, PR, commit, repository path, URL, person, or date. The one exception is a setup
      instruction on placeholder copy, naming the document the replacement is written against
- [ ] No `TODO` / `FIXME` was introduced — deferred work is recorded in `DEFERRED.md` or `GAPS.md`
- [ ] Every comment is one line; every docstring states why its unit exists, with no `Args:` /
      `Returns:` / `Raises:` block (except a published Ninja endpoint or FastMCP tool docstring,
      which states the full what)
- [ ] All imports are at the top of the file — no imports inside functions, methods, or classes
      unless a documented justified exception applies
- [ ] Conditional chains of three or more branches encoding a named business rule are extracted to
      a Policy or Strategy

For backend-specific checklist items (Python `except` syntax, `transaction.atomic()`, caching),
see [`../BACKEND-CODING-PRINCIPLES.md`](../BACKEND-CODING-PRINCIPLES.md).

For frontend-specific items (class components, `console.log`, CSS query ordering), see
[`../FRONTEND-CODING-PRINCIPLES.md`](../FRONTEND-CODING-PRINCIPLES.md).

_Part of the `code/docs/` documentation family. See [`../CODING-PRINCIPLES.md`](../CODING-PRINCIPLES.md) for the full index._
