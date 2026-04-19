# Branch Guide — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Branch naming

Feature and fix branches follow the format:

```text
us###/short-description
```

Where `###` is the zero-padded user story number from `project-management/src/STORIES/`.

```text
us001/user-registration
us042/graphql-portfolio-query
us107/mobile-push-notifications
```

Non-story branches (hotfixes, chores, dependency bumps):

```text
fix/missing-csrf-token
chore/upgrade-strawberry-0.315
ci/add-e2e-workflow
```

Rules:

- All lowercase, words separated by hyphens
- Short but descriptive — 3–5 words maximum
- The `us###` prefix must match a real story ID in `project-management/src/STORIES/`

---

## Promotion flow

All branches travel through the full chain. Never skip a stage.

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Branch | Purpose | Who merges |
| ------ | ------- | ---------- |
| `us###/feature` | Feature work for one story | Developer |
| `testing` | Dev-team QA — CI + manual testing | Developer → QA sign-off |
| `dev` | Integration — all in-progress features | Lead after QA |
| `staging` | Pre-production acceptance | Lead after staging sign-off |
| `main` | Production-ready, client-accepted releases | Lead after full sign-off |

---

## Merge gates

| Step | Gate |
| ---- | ---- |
| `us###/feature` → `testing` | Tests pass locally; PR opened to `testing` only |
| `testing` → `dev` | CI passes on `testing`; QA sign-off obtained |
| `dev` → `staging` | CI passes on `dev`; lead sign-off; no regressions |
| `staging` → `main` | Staging sign-off; version bump and changelog entry present |

---

## Rules

- Feature branches always target `testing` — **never** `dev`, `staging`, or `main` directly.
- A branch rejected at any stage goes back to the original `us###/feature` branch for fixes.
- Delete the feature branch after it is merged into `testing`.
- Do not leave stale branches on the remote for more than one sprint.

---

## Creating a branch

Start from an up-to-date `main`:

```bash
git checkout main
git pull origin main
git checkout -b us042/graphql-portfolio-query
```

Push and open a PR targeting `testing`:

```bash
git push -u origin us042/graphql-portfolio-query
```

Full PR process: [PR Guide](PR-GUIDE.md)

---

## Full reference

Complete branching rules and PR promotion workflow:
`project-management/docs/GIT-GUIDE.md`
