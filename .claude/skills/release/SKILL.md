---
name: release
description: >-
  Cut a release of <%PROJECT_NAME%> — sequence the version bump, the full test suite, the
  version commit, and the handover to whoever owns the target environment. Load when a tested
  branch is ready to ship, or when someone asks to deploy. Not choosing and applying the
  increment itself (`version`), not raising the pull request that got the code here (`pr`), and
  not the release's own commit mechanics (`git`).
model: opus
metadata:
  skills: global-workflow
---

# Cut a Release (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — what is in the release, and therefore which increment it
takes, is settled in the conversation; every phase below is dispatched or run directly).

**Prerequisites, checked before phase 1:** `staging` is green, and every sprint story in the
release is marked complete. A release cut over an unfinished story ships a half-feature nobody
agreed to.

---

## Pre-flight

```bash
python3 .claude/plugins/env-tool.py find     # the environment files exist
python3 .claude/plugins/git-tool.py status   # on staging or main, nothing uncommitted
```

## The sequence

Phases 1 and 3 are separate Agent tool calls to `general-purpose`, naming the skill to load.
**They dispatch separately so that neither checks its own output** — a convention this skill
holds, not something the runtime enforces.

1. **Version bump** — the `version` skill, which owns the decision procedure for picking the
   increment from the diff and the ordering constraint that the changelog is written before
   anything is staged. `project-management/docs/VERSIONING-GUIDE.md` owns the rules themselves
   and the list of files a bump touches.
2. **Full test suite** — no dispatch:

   ```bash
   bash code/src/scripts/tests/backend.sh
   bash code/src/scripts/tests/api.sh
   ```

   Both must pass. **If either fails, stop and report — do not deploy.**

3. **Commit the version files** — the `git` skill, message
   `chore(release): bump version to X.Y.Z`.
4. **Deploy — stop here and report.** `code/src/scripts/deployment/` is a scaffold: the
   sanctioned entry point is not written yet, so there is no command to run. Hand the tagged,
   tested release to whoever owns the target environment. **Never improvise a deploy command**
   — an unsanctioned one is a production change nobody can reproduce or roll back.

## Definition of done

The increment matches what actually changed and is justified against the declared public API;
every version file moved together; both suites passed **before** the version commit; the
changelog entry describes the change rather than the commit; the release is handed over with
its tag, not deployed from here.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/23-release/` — **the procedure of record** — bump, changelog, deploy
- `project-management/workflows/22-pr-and-review/` — the promotion chain that must be green first
- `code/workflows/08-security-hardening/` — the built-code audit a release-blocking finding enters

## Cross-references

- `project-management/docs/VERSIONING-GUIDE.md` — the semver rules and the files each bump touches
- `project-management/docs/git/COMMITS.md` — the commit format and the breaking-change signal
- `how-to/docs/FEATURE-DEPLOY.md` — what the target environment has to be told about a change
