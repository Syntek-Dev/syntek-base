---
workflow: 22-pr-and-review
phase: ship
skills: [pr, global-workflow]
model: opus
---

# PR and Code Review — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step         | Section                                                                                                                                               |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 5            | **Internal — Guides** → project-management/docs/GIT-GUIDE.md (gate rules: testing → dev → staging → main)                                             |
| 5            | **External — Version Control & CI** → Conventional Commits 1.0, GitHub Actions, GitHub flow                                                           |
| Impl records | Verified here, authored in `workflows/21-implementation-documentation/` → src/09-GDPR/, src/10-SECURITY/, src/11-QA/, src/12-SEO/, src/13-API-DESIGN/ |

---

## Steps

### Step 1 — Final QA Pass

```text
qa-tester
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `qa-tester` · **Model:** opus · **MCP:** none

### Step 2 — Code Review

```text
review
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `review` · **Model:** opus · **MCP:** none

Address all findings before opening the PR.

### Step 3 — Open PR to `testing`

Feature branches always target `testing` first — never `dev`, `staging`, or `main`.

PR description must include:

- Summary of changes
- User story reference (US###)
- Test plan (how to verify)

Set the story `**Status:**` to `In Review` in `src/02-STORIES/US###.md` and commit — the lefthook
regenerates the ClickUp export and the `clickup-sync` workflow pushes it to the board. Status set
per `project-management/docs/PLANNING-GUIDE.md` → Story Statuses.

### Step 4 — Await CI and QA Sign-off

CI must pass and QA sign-off received before merging `testing` → `dev`.

### Step 5 — Promote Through Chain

Follow the gate rules in `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md`:

```text
testing → dev → staging → main
```

Once merged to `testing`, set the story `**Status:**` to `Completed` (move to `Accepted` /
`Accepted Customer` on sign-off). Commit the change so the ClickUp board updates.

---

### Step 6 — Verify Implementation Records, Write Review Records

**Hard gate — complete before marking this story done.**

The design/compliance IMPLEMENTATION records are **written in `21-implementation-documentation`**, which runs before this workflow. Here you **verify** each applicable one exists and is complete, then **write** the two PR-stage records that are the outputs of Steps 1–2.

**Verify (authored in `21-implementation-documentation`)** — if any applicable record is missing or incomplete, return to `19` before proceeding; do not write it here:

| Discipline                                          | Required                                           | Expected in                                  |
| --------------------------------------------------- | -------------------------------------------------- | -------------------------------------------- |
| GDPR review                                         | Always                                             | `src/09-GDPR/IMPLEMENTATION/`                |
| Security (assessment / audit / threat model / vuln) | Always                                             | `src/10-SECURITY/<CATEGORY>/IMPLEMENTATION/` |
| QA plan                                             | Always                                             | `src/11-QA/IMPLEMENTATION/`                  |
| SEO review                                          | Only if story adds public-facing pages             | `src/12-SEO/IMPLEMENTATION/`                 |
| API design                                          | Only if story adds or changes the Django Ninja API | `src/13-API-DESIGN/IMPLEMENTATION/`          |
| Findings                                            | Always                                             | `src/19-FINDINGS/`                           |

**Write (PR-stage records)** — the outputs of the Final QA Pass (Step 1) and Code Review (Step 2):

| Discipline         | Required | File to create                                     | Save in           |
| ------------------ | -------- | -------------------------------------------------- | ----------------- |
| Code review record | Always   | `REVIEW-US###-<descriptor>[-DD-MM-YYYY].md`        | `src/18-REVIEWS/` |
| Test record        | Always   | `US###-TEST-STATUS.md` + `US###-MANUAL-TESTING.md` | `src/17-TESTS/`   |

Any newly discovered Critical or High findings during review must be escalated to
`src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/` immediately and fed back to
`21-implementation-documentation`.

### Update GAPS.md and DEFERRED.md

Once all implementation records are written, scan them before opening the PR.

**Open issues → `/GAPS.md` (project root)**

Any finding that cannot be resolved in this PR — a security gap needing a follow-up story, a
missing infrastructure dependency, an architectural risk — gets an entry in `/GAPS.md`. Use the
format documented at the top of that file. Update an existing entry rather than duplicating.

**Cross-story deferrals → `/DEFERRED.md` (project root)**

Any item explicitly deferred to a named story (`DEFERRED (US###)`, `DEFERRED (apps.xxx)`) gets
a row in `/DEFERRED.md` under the source story's heading. Sprint planners check this file before
scheduling any target story. If the source story section does not exist, add one.

Do not open the PR until both files are current.

---

### Step 7 — Verify Documentation Closeout

**Hard gate — complete before closing this story.** The primary `CONTEXT.md`/`CLAUDE.md` updates and the code-review-graph refresh are done in `21-implementation-documentation` — confirm they are complete. Then, if **this** workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
