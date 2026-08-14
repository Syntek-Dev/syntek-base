---
workflow: 23-release
phase: ship
skills: [release, global-workflow]
model: opus
---

# Release — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                                                   |
| --------- | --------------------------------------------------------------------------------------------------------- |
| All steps | **Internal — Guides** → project-management/docs/VERSIONING-GUIDE.md, project-management/docs/GIT-GUIDE.md |
| All steps | **External — Version Control & CI** → Semantic Versioning 2.0, Conventional Commits 1.0, GitHub Actions   |

---

## Steps

### Step 1 — Version Bump

```text
version bump [patch | minor | major]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `version` · **Model:** opus · **MCP:** none

This updates: `VERSION`, `VERSION-HISTORY.md`, `RELEASES.md`, `CHANGELOG.md`,
`pyproject.toml`.

### Step 2 — Store Listing Copy — only if this release bumped the mobile package

**Skip this step unless Step 1 moved `code/src/mobile/`.** The trigger is `app.json`
`expo.version` — the number shipped to the stores. A root-only bump reaches no store, and a
project with no mobile surface never reaches this condition at all.

```text
stack-react-native
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `stack-react-native` · **Model:** opus · **MCP:** none

Write this release's **What's New / release notes** copy, then:

1. Enter it in **App Store Connect** and the **Play Console** — those are authoritative.
2. Record the same text in `how-to/src/STORE-LISTING.md`, **overwriting the previous release's**.
   The register holds what the store says now; the history is already on the mobile
   sub-package's own track (`code/src/mobile/CHANGELOG.md`, `RELEASES.md`).
3. Fill the **Used** count. Google Play's release-notes limit is deliberately unpinned — read it
   off the Play Console field, per `code/docs/discoverability/APP-STORE.md` Section 1.

The fields and their limits: `code/docs/discoverability/APP-STORE.md`. The register it is
written in: `how-to/src/BRAND-VOICE.md` Section 5. Doing this after the bump and before the commit is
what lands the listing change in the **same commit** as the version files.

> If any other listing field changed with this release, `STORE-LISTING.md` owns that rule — it
> moves in the same change, whether or not a release is being cut.

### Step 3 — Run Full Test Suite

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 4 — Commit Version Files

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

### Step 5 — Deploy to Production

**Stop here.** `code/src/scripts/deployment/` is a scaffold — the sanctioned deploy entry point is
not written yet, so this workflow has no command to give you. Hand the tagged, tested release to
whoever owns the target environment, and record the deployment once it is done.

Once live, set each released story's `**Status:**` to `Closed` in `src/02-STORIES/US###.md` and
commit — the `clickup-sync` workflow moves the ClickUp tasks. Status values:
`project-management/docs/PLANNING-GUIDE.md` → Story Statuses.

---

### Step 6 — Update Context and Documentation

**Hard gate — complete before closing the release.** If this release introduced new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this release created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
