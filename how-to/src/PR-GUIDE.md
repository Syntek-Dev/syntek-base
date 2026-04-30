# PR Guide — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Before opening a PR

Run these checks locally. CI enforces the same gates — failures locally mean failures in CI.

```bash
# Lint, format, and type-check
./code/src/scripts/syntax/lint.sh
./code/src/scripts/syntax/check.sh
./code/src/scripts/syntax/format.sh

# Full test suite
./code/src/scripts/tests/all.sh
```

All checks must be clean and all tests must pass before you open a PR.

---

## Where to target your PR

Feature branches always target `testing` — **never** `dev`, `staging`, or `main` directly.

```text
us###/feature  →  testing
```

See [Branch Guide](BRANCH-GUIDE.md) for the full promotion flow.

---

## PR title format

Follow the same Conventional Commits format used for commit messages:

```text
feat(auth): Add JWT refresh token rotation
fix(graphql): Correct IDOR check on portfolio query
docs(ci): Update test workflow to use project scripts
```

Keep it under 72 characters.

---

## PR description

Every PR must include:

```text
## Summary
Brief description of what changed and why.

## Story
Closes US-### (link to the story in project-management/src/STORIES/)

## Changes
- List of significant changes — one line per item
- Backend changes first, then frontend, then infra/docs

## Testing
How to verify this change manually:
1. Start the dev stack: ./code/src/scripts/development/server.sh up
2. Navigate to ...
3. Expect ...

## Checklist
- [ ] Tests written and passing (./code/src/scripts/tests/all.sh)
- [ ] Lint and type-checks clean (./code/src/scripts/syntax/lint.sh && check.sh)
- [ ] No hardcoded secrets
- [ ] GDPR implications reviewed (if PII is involved)
- [ ] Accessibility checked (if frontend changes)
- [ ] GraphQL codegen re-run if schema changed
```

---

## Review expectations

- All PRs require at least one reviewer approval before merging.
- The author resolves all requested changes before re-requesting review.
- Reviewers use the [Code Review](CODE-REVIEW.md) checklist.
- Approving a PR means you have reviewed the diff, not just scanned the title.

---

## Promotion chain

After `testing` → `dev` → `staging` → `main`, each step requires sign-off:

| Step               | Gate                                  |
| ------------------ | ------------------------------------- |
| `testing` → `dev`  | CI passes; QA sign-off                |
| `dev` → `staging`  | Lead sign-off; no regressions         |
| `staging` → `main` | Full sign-off; version bump committed |

Full promotion rules: `project-management/docs/GIT-GUIDE.md` ·
PM workflow: `project-management/workflows/16-pr-and-review/`

---

## After merge

- Delete the feature branch.
- Update the story status in `project-management/src/STORIES/US###.md` to `Done`.
- If the PR introduced a release-worthy change, follow the release workflow:
  `project-management/workflows/07-release/`
