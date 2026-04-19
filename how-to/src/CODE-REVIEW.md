# Code Review — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Reviewer checklist

Use this checklist when reviewing any PR. Work through it top-to-bottom before approving.

### Correctness

- [ ] The change does what the PR description says it does
- [ ] Edge cases are handled
- [ ] Error paths are handled and logged at `ERROR` or `WARNING`
- [ ] No silent failures — exceptions are never swallowed without logging

### Security (non-negotiable)

- [ ] Every GraphQL mutation has an explicit permission check (OWASP A01)
- [ ] User-supplied IDs are verified against the caller's ownership — no IDOR
- [ ] No hardcoded secrets, tokens, or credentials
- [ ] `DEBUG=False` in all non-local environment settings
- [ ] `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*`
- [ ] User input is validated at the boundary, not deep in service code

### Data integrity

- [ ] Service methods doing ≥ 2 writes use `transaction.atomic()`
- [ ] Migrations are reversible (or the reason they cannot be is documented)
- [ ] No raw SQL without parameterisation

### Code quality

- [ ] File length is under 750 lines (800 with grace)
- [ ] Functions have a single purpose and are short enough to read without scrolling
- [ ] No imports inside functions (unless a documented exception applies)
- [ ] `except (A, B):` syntax — never `except A, B:`
- [ ] Comments explain _why_, not _what_ — no commented-out code

### Tests

- [ ] New behaviour has tests covering the happy path and at least one error path
- [ ] Tests cover real behaviour — no stubs written purely to hit coverage floors
- [ ] Backend coverage remains at or above 75% (90% for auth-related code)
- [ ] Frontend coverage remains at or above 70%

### GraphQL

- [ ] New types and fields are documented with descriptions
- [ ] Codegen has been re-run if the schema changed (`/codegen` or `pnpm codegen`)
- [ ] No N+1 queries introduced in resolvers

### Frontend

- [ ] Interactive components meet WCAG 2.2 AA accessibility standards
- [ ] New pages have SEO metadata (title, description, Open Graph)
- [ ] No raw `fetch` to the GraphQL endpoint — Apollo Client only

### Documentation

- [ ] All fenced code blocks declare their language (no bare ` ``` `)
- [ ] Updated docs are accurate and reflect the current behaviour
- [ ] Story status is updated in `project-management/src/STORIES/`

---

## Giving feedback

- Be specific — cite the file and line number.
- Distinguish blocking issues from suggestions: prefix with **[blocking]** or **[suggestion]**.
- Explain the _why_ behind a requested change, not just what to change.
- Approve once all blocking items are resolved. Suggestions can be addressed in a follow-up.

---

## Author's responsibility

- Respond to every comment — either fix it or explain why you are not.
- Do not force-push a branch under review — add new commits instead.
- Re-request review after addressing all blocking items.

---

## Further reading

- Security guide: `code/docs/SECURITY.md`
- Coding principles: `code/docs/CODING-PRINCIPLES.md`
- Testing guide: `code/docs/TESTING.md`
- Code review workflow: `code/workflows/06-review/`
