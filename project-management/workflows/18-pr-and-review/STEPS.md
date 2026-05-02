# PR and Code Review — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Final QA Pass

```text
/syntek-dev-suite:qa-tester
```

### Step 2 — Code Review

```text
/syntek-dev-suite:review
```

Address all findings before opening the PR.

### Step 3 — Open PR to `testing`

Feature branches always target `testing` first — never `dev`, `staging`, or `main`.

PR description must include:

- Summary of changes
- User story reference (US###)
- Test plan (how to verify)

### Step 4 — Await CI and QA Sign-off

CI must pass and QA sign-off received before merging `testing` → `dev`.

### Step 5 — Promote Through Chain

Follow the gate rules in `project-management/docs/GIT-GUIDE.md`:

```text
testing → dev → staging → main
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
