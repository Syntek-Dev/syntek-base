---
name: version
description: >-
  Move <%PROJECT_NAME%>'s version state as one consistent set — pick the increment a diff
  actually earns, update `VERSION` and any sub-package, write the three logs, refresh the
  markdown metadata headers, and stage it all. Load when a version needs bumping or the version
  files have drifted apart. Not committing or tagging the result (`git`), not deciding a release
  should happen (`release`), not marking a story complete (`completion`), and not writing the
  narrative documentation around it (`doc-writer`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow stack-django stack-htmx-templates
---

# Move the Version (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable task whose output is an edited, staged version
set).

> **Read `project-management/docs/VERSIONING-GUIDE.md` first, every time.** It is canonical for
> the increment rules, the public-API declaration those rules rest on, the full file list, and
> the two-tier strategy. This skill executes it and **decides**; it does not restate it.

**You stage. You never commit and never tag** — that is `git`'s.

---

## The brief arrives settled — except the increment, which is this skill's call

A fork cannot ask, so the brief must carry **what changed** — the diff, the commit range, or
the tag to compare against — and **whether a release is being cut** or the version files have
merely drifted. The **increment itself is decided here**, not handed down.

## Deciding the increment

Read the change, not the commit type. The mapping is:

| The change                                                                       | Increment |
| -------------------------------------------------------------------------------- | --------- |
| Anything that removes or alters part of the declared **public API**              | **MAJOR** |
| New capability, backwards-compatible                                             | **MINOR** |
| Fix, copy change, documentation, internal refactor with no interface consequence | **PATCH** |

**MAJOR is only decidable against the public-API declaration** — the guide names what this
repository's public API is, and it is not the same thing as "the code". Read that section
before classifying anything as breaking; a bump made without it is a guess wearing a number.

**A commit carrying a breaking change is MAJOR whatever its type** — a `fix!:` that removes a
field is a MAJOR, and `feat` alone never implies MINOR. The signalling convention is
`project-management/docs/GIT-GUIDE.md`'s.

**Then ask whether a sub-package moved.** Each deployable carries its own independent semver and
is bumped **only when its own code changed**. Never move a sub-package as a side-effect of a
root bump.

### When to refuse the bump and hand back

Return without bumping when any of these holds:

- **The diff is empty of anything releasable** — a version moved for its own sake records a
  release that did nothing.
- **The change looks breaking and the public API is undeclared or stale.** Say which, and stop:
  guessing MAJOR is as wrong as guessing MINOR.
- **`CHANGELOG.md`'s `[Unreleased]` section does not describe the work being released.** The
  changelog is the input to the bump, not an output of it.
- **The docs hard gate is unmet.** A bump stages files; if the implementation records are
  missing, the commit that follows cannot be made anyway.

## The order, and why it is fixed

**The changelog is written before anything is staged.** Writing it last turns it into a
summary of a decision already taken, and it is meant to be the evidence for that decision.

1. **`VERSION`** — and every affected sub-package version file — set to the new number.
2. **`VERSION-HISTORY.md`** — prepend the row: `DD/MM/YYYY | X.Y.Z | <one-line technical
summary>` in Conventional-Commit style. The developer-facing log.
3. **`CHANGELOG.md`** — move the `[Unreleased]` entries into a new `## [X.Y.Z] - DD/MM/YYYY`
   section under the Keep a Changelog headings, then **reset `[Unreleased]`**. Never leave it
   populated after a release.
4. **`RELEASES.md`** — a `## vX.Y.Z — DD/MM/YYYY` block in plain user-facing language: what it
   means for someone using this, not what changed internally.
5. **Headers** — refresh `**Version**` and `**Last Updated**` on the `.md` files the change
   touched. Never expand a file past the 300-line limit while editing its header.
6. **Stage** — then hand to `git`.

**Mobile carries its version in two files** — `package.json` (`version`) and `app.json`
(`expo.version`) — which must hold the identical string and move in the same edit. **Bumping
only one fails silently:** tests pass, the bundle builds, and the store release ships under the
old number. Mobile-only; a web-only project has neither.

## The metadata header

```markdown
# Document Title

**Last Updated**: DD/MM/YYYY **Version**: X.Y.Z **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
```

Immediately after the H1. Dates DD/MM/YYYY; `RELEASES.md` titles read `vX.Y.Z — DD/MM/YYYY`.

## Guardrails

- **British English throughout**, and **no technical jargon in `RELEASES.md`** — it is read by
  someone who does not have the diff.
- Root and every affected sub-package must agree with their logs. **Leave nothing half-bumped.**
- Never a raw `git commit` or `git tag`, and never a package manager's own version command.
  Stage with `.claude/plugins/git-tool.py add`, then hand off.

## Definition of done

The increment justified against the public-API declaration and stated; every file in the set
moved together; `[Unreleased]` reset; headers refreshed; everything staged and nothing
committed.

## Handoff

Report **previous → new** for the root and every sub-package, which logs were written, how many
headers were refreshed, and **the reasoning for the increment** — that last one is what a
reviewer checks. Then: `git` to commit and tag, `doc-writer` where narrative documentation is
still owed, and `review` where the version set should be independently checked.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/23-release/` — the release procedure that calls this

## Cross-references

- `project-management/docs/VERSIONING-GUIDE.md` — **canonical**: the rules, the public-API
  declaration, the file list, the two-tier strategy, pre-release and precedence
- `project-management/docs/GIT-GUIDE.md` — how a breaking change is signalled in the commit
- `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` — the documentation standards alongside
- `.claude/plugins/git-tool.py` · `.claude/plugins/project-tool.py` — read-only state
