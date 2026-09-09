---
workflow: 23-pr-and-review
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

| Step         | Section                                                                                                                                                              |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 5            | **Internal — Guides** → project-management/docs/GIT-GUIDE.md (gate rules: testing → dev → staging → main)                                                            |
| 5            | **External — Version Control & CI** → Conventional Commits 1.0, GitHub Actions, GitHub flow                                                                          |
| Impl records | Verified here, authored in `workflows/22-implementation-documentation/` → src/09-GDPR/, src/10-SECURITY/, src/11-QA/, src/12-SEO/, src/13-API-DESIGN/, src/18-TESTS/ |

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

### Step 6 — Verify Implementation and Test Records, Write the Review Record

**Hard gate — complete before marking this story done.**

The design/compliance IMPLEMENTATION records and both test records are **written in `22-implementation-documentation`**, which runs before this workflow. Here you **verify** each applicable one exists and is complete, then **write** the single PR-stage record that is the output of Steps 1–2.

**Verify (authored in `22-implementation-documentation`)** — if any applicable record is missing or incomplete, return to `22-implementation-documentation` before proceeding; do not write it here:

| Discipline                                          | Required                                           | Expected in                                  |
| --------------------------------------------------- | -------------------------------------------------- | -------------------------------------------- |
| GDPR review                                         | Always                                             | `src/09-GDPR/IMPLEMENTATION/`                |
| Security (assessment / audit / threat model / vuln) | Always                                             | `src/10-SECURITY/<CATEGORY>/IMPLEMENTATION/` |
| QA plan                                             | Always                                             | `src/11-QA/IMPLEMENTATION/`                  |
| SEO review                                          | Only if story adds public-facing pages             | `src/12-SEO/IMPLEMENTATION/`                 |
| API design                                          | Only if story adds or changes the Django Ninja API | `src/13-API-DESIGN/IMPLEMENTATION/`          |
| Test records (automated + manual)                   | Always                                             | `src/18-TESTS/`                              |
| Findings                                            | Always                                             | `src/20-FINDINGS/`                           |

**Complete is not the same as present** — the two test records in `src/18-TESTS/` are read, not
counted. Rules and templates: `project-management/src/18-TESTS/CLAUDE.md`.

- **`US###-TEST-STATUS.md`** — the block between `<!-- BEGIN GENERATED: test-record -->` and
  `<!-- END GENERATED -->` regenerated against the **last** suite run, not an earlier green one.
  Check a short per-test table against `bash code/src/scripts/audits/story-markers.sh` before
  reading it as coverage: an unmarked test is silently absent from the record, never reported
  as missing.
- **`US###-MANUAL-TESTING.md`** — every row's `Result` marked `Pass` or `Fail`, none left empty.
  An empty `Result` means the step was not run; it is never a pass.
- **Every `Fail` carries a reason and a destination** — the reason in its own `Notes` cell, and
  a row in the guide's _Failures_ table routed before merge, exactly as `src/20-FINDINGS/`
  routes a finding.
- **A green `TEST-STATUS` beside a failing manual row is a missing test, not a passing story.**
  Return to `22-implementation-documentation`; never merge on the automated half alone.

**Write (PR-stage record)** — the output of the Final QA Pass (Step 1) and Code Review (Step 2):

| Discipline         | Required | File to create                              | Save in           |
| ------------------ | -------- | ------------------------------------------- | ----------------- |
| Code review record | Always   | `REVIEW-US###-<descriptor>[-DD-MM-YYYY].md` | `src/19-REVIEWS/` |

Any newly discovered Critical or High findings during review must be escalated to
`src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/` immediately and fed back to
`22-implementation-documentation`.

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

**Hard gate — complete before closing this story.** The primary `CONTEXT.md`/`CLAUDE.md` updates and the code-review-graph refresh are done in `22-implementation-documentation` — confirm they are complete. Then, if **this** workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
