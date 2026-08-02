# Git & Pull Requests

Repository setup, branch strategy, commit protocol, and pull-request management.
Full project rules live in `project-management/docs/GIT-GUIDE.md`; this is the
shared baseline. All Git operations may use the `gh` CLI and the project's
`git-tool.py` helper (`.claude/plugins/git-tool.py`).

---

## 1. Repository setup (SSH)

**Clone over SSH, never HTTPS** — enables commit-author tracking, key-based auth,
and signed commits.

```bash
# Correct
git clone git@github.com:<%ORG_NAME%>-Dev/<%PROJECT_SLUG%>.git

# Wrong — do not use HTTPS
git clone https://github.com/<%ORG_NAME%>-Dev/<%PROJECT_SLUG%>.git
```

Convert an existing HTTPS checkout:

```bash
git remote set-url origin git@github.com:<%ORG_NAME%>-Dev/<%PROJECT_SLUG%>.git
```

One-time SSH setup: generate a key (`ssh-keygen -t ed25519 -C "you@<%PRIMARY_DOMAIN%>"`),
add it to the agent (`ssh-add ~/.ssh/id_ed25519`), register the public key in
GitHub → Settings → SSH and GPG keys, then verify with `ssh -T git@github.com`.

---

## 2. Branch strategy

### User-story branches

All feature work branches from a user story:

```
us###/short-description
```

- Story number is zero-padded to 3 digits (`us001`, `us042`, `us100`).
- Description is kebab-case, 2–4 words (`us015/payment-integration`).

### Hotfix branches

```
hotfix/<issue-number>-<short-description>
```

Example: `hotfix/123-login-crash`.

### Branch flow

```
us###/feature → testing → dev → staging → main
```

| From            | To        | Condition              | On rejection            |
| --------------- | --------- | ---------------------- | ----------------------- |
| `us###/feature` | `testing` | Developer tests pass   | Fix in feature branch   |
| `testing`       | `dev`     | QA tests pass          | Fix and re-submit       |
| `dev`           | `staging` | Integration tests pass | Fix and re-submit       |
| `staging`       | `main`    | **Client accepts**     | Back to `us###/feature` |

Never commit directly to a protected branch. If a task starts on `main`, branch
first. Full branch protection and merge rules: `project-management/docs/GIT-GUIDE.md`.

---

## 3. Commit protocol

### Message template

```
<type>(<scope>): <Description> — <summary>

<Body — what changed and why>

Files changed:
- <app-name/folder/file>

Version: <old-version> → <new-version>
```

### Commit types

| Type       | Use for                             |
| ---------- | ----------------------------------- |
| `feat`     | New feature                         |
| `fix`      | Bug fix                             |
| `docs`     | Documentation only                  |
| `style`    | Formatting, no logic change         |
| `refactor` | Code restructure, no feature change |
| `test`     | Adding or updating tests            |
| `chore`    | Build, config, dependencies         |

### Rules

1. **Imperative mood** — "Add resolver", not "Added resolver".
2. **Changelog-first** — update `CHANGELOG.md` before committing (see
   [VERSIONING-AND-DOCS.md](VERSIONING-AND-DOCS.md)).
3. **Docs hard gate** — implementation docs and `CONTEXT.md` updates must be
   complete before any commit; this is non-negotiable.
4. **Version bump** — reflect the semver change in the commit.
5. **No `.env`** — never commit secrets or `.env` files; use `.env.*.example` templates.

Commit or push only when the user asks. Match the project's commit-trailer
convention as configured in the environment.

---

## 4. Pull-request management

All PR operations use the `gh` CLI for consistency and automation. The pre-PR
quality gate (`.claude/hooks/pre-pr-check.sh`) must pass before a PR is marked ready.

### Creating

```bash
gh pr create --base testing \
  --title "[US001] feat(auth): Add login" \
  --body-file <path-to-body>
```

### Reviewing

```bash
gh pr list                                    # open PRs
gh pr view <number>                           # details
gh pr diff <number>                           # diff
gh pr review <number> --comment  --body "…"   # comment
gh pr review <number> --approve  --body "Approved: all tests pass"
gh pr review <number> --request-changes --body "Needs fixes: …"
```

### Managing

```bash
gh pr merge  <number> --merge
gh pr close  <number> --comment "Rejected: <reason>"
gh pr status
```

### Title format

```
[<branch-type>] <type>(<scope>): <Description>
```

Examples: `[US001] feat(auth): Add user login`, `[HOTFIX] fix(payment): Resolve
checkout timeout`, `[TESTING→DEV] feat(auth): Authentication module`.

### Body template

```markdown
## Summary

- <What this PR does>
- <Key changes / notable decisions>

## Changes

### Added

- <New feature or file>

### Changed

- <Modified functionality>

### Fixed

- <Bug fix>

## Version

**Previous:** `X.Y.Z` · **New:** `X.Y.Z` · **Increment:** MAJOR | MINOR | PATCH

## Test plan

- [ ] <How to test change 1>
- [ ] Backend suite passes — `bash code/src/scripts/tests/backend.sh`
- [ ] Frontend suite passes — `bash code/src/scripts/tests/*.sh`

## Checklist

- [ ] Follows project style and non-negotiables (permission checks, no IDOR)
- [ ] Tests added/updated
- [ ] Docs and `CONTEXT.md` updated (hard gate)
- [ ] `CHANGELOG.md` and version files updated
- [ ] No secrets or credentials in code

## Related issues

Closes #<issue-number>
```

---

## 5. Client acceptance (staging → main)

**Accept:**

```bash
gh pr review <number> --approve --body "Client accepted: ready for production"
gh pr merge  <number> --merge
```

**Reject:**

```bash
gh pr review <number> --request-changes --body "Client rejected: <detailed reason>"
gh pr close  <number> --comment "Rejected by client — creating fix branch from the US branch."
```

After rejection: branch again from the original `us###/feature`, implement fixes,
and re-run the full flow `testing → dev → staging`.
