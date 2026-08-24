# HANDOFF — Generated-project CI failures after the v7.4.1 update

**Written**: 24/08/2026 | **Repository**: `syntek-base` | **Branch**: `main` @ `daef1a5`

---

## Goal

Close the class of syntek-base defects that pass every gate **here** and fail the identical gate in
a **generated project** — surfaced when four live projects updated `v2.3.1 → v7.4.1` and each came
back with 8 identical CI failures out of ~32 jobs. The template ships CI that a project generated
from it cannot pass on day one.

---

## Done

All landed and pushed; nothing in this section needs revisiting.

- **syntek-base 7.4.1 released** — `111637a`, tag `v7.4.1`, GitHub release published, 13/13 CI
  green. Fixed: all three acting migrations exiting 1 on a collision and aborting the rest of the
  update (`.copier/migrations/v2.0.0-renumber-src.sh`, `v7.0.0-renumber-src.sh`,
  `v6.0.0-rename-feature-surfaces.sh`); the manifest-branding `_task` gated to `copy` so `uv lock`
  resolved under the template's name (`copier.yml`); `_min_copier_version` `9.0.0 → 9.6.0`; the
  "`_tasks` never run on update" claim corrected in seven places.
- **All four projects updated and pushed to their own `main`** — `_commit: v7.4.1`,
  `INCLUDE_CLICKUP: true`, own slug in `pyproject.toml` and `uv.lock`, `.copier/` removed, all 7
  migrations run, `template-orphans.sh` clean.

  | Project                 | Commit    | Surfaces                |
  | ----------------------- | --------- | ----------------------- |
  | `syntek-accountability` | `b2cc493` | rust · desktop · mobile |
  | `syntek-ai-engine`      | `c48907a` | rust · desktop · mobile |
  | `syntek-platform`       | `4c01573` | rust · desktop          |
  | `syntek-modules`        | `7ab1915` | rust · mobile           |

- **Six conflicts per project resolved to the template's side** (119 hunks each on the first three,
  25 on modules) — all template-vs-stale-template with zero developer edits in history. The three
  `*-clickup.sh` scripts and `.github/workflows/clickup-sync.yml` verified byte-identical to
  syntek-base v7.4.1; `code/src/rust/Cargo.lock` taken from the template then proven by
  `syntax/check.sh --file-type rust`, never hand-merged.
- **`project-management/src/17-TESTS/` removed in all four** — two unmodified template stubs
  superseded by `18-TESTS/`, verified against the pre-update HEAD before deleting.

---

## In-flight

Nothing is half-edited in the working tree. What follows is **diagnosed and unfixed** — five
independent defects, each root-caused to a line, ordered by blast radius.

### 1. Copier does not preserve symlinks, so the vendored-skill exemption evaporates

**The largest and the least obvious.** In syntek-base the three Cloudinary skills are symlinks:

```text
.claude/skills/cloudinary-docs -> ../../.agents/skills/cloudinary-docs
```

Copier materialises them as **real directories** in a generated project. Two audits key their
exemption off that symlink and both therefore misfire downstream:

- `code/src/scripts/audits/skill-conformance.sh:363` — `is_vendored() { [[ -L "${1%/}" ]]; }`.
  The header at `:214` already reasons carefully about lexical-vs-realpath resolution for exactly
  this test; what it does not anticipate is the symlink not existing at all. **12 violations**,
  all three Cloudinary skills held to house clauses 7, 10 and 12 they are exempt from here.
- `code/src/scripts/audits/docs-length.sh:368` — `case "$p" in .agents/*|code/docs/cloudinary/*)`.
  The materialised copies live under `.claude/skills/`, which that pattern does not match.
  **6 files over 300 lines**, worst `cloudinary-transformations/references/advanced-features.md`
  at 551.

Deciding this needs a call on **where the vendored set should live in a generated project** — the
exemption cannot be a symlink test on both sides of generation.

### 2. Two audits read `copier.yml`, which is `_exclude`d and never ships

- `code/src/scripts/audits/doc-references.sh:375` — `awk '/^_exclude:/…' copier.yml`. Downstream
  the file is absent, so the derived set is empty and the run prints
  `matched against 0 path(s) copier excludes unconditionally`.
- `code/src/scripts/audits/routing-skills.sh:294` —
  `grep -oE "if not INCLUDE_[A-Z_]+ :>/$esc[<]" copier.yml`. No `copier.yml` means no flag is ever
  found, so **every** `stack-rust` / `stack-slint` mention in a `skills:` list is reported.
  **22 problems**, e.g. `code/workflows/12-rust-extension/STEPS.md`,
  `code/docs/desktop/LICENSING.md` — false positives in projects that _did_ take those surfaces.

`routing-skills.sh:359` already records that the co-variance verdict reads the real `copier.yml`
and that a fixture would drift; neither script has a downstream branch.

### 3. The seeded `README.md` is frozen at generation and now describes a deleted tree

`copier.yml` `_tasks` seeds `README.md` from `.copier/README.md` gated to `copy`, so no update ever
refreshes it — the corollary `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:43` states in terms. Three
majors later the seeded copy still documents surfaces that no longer exist. From
`syntek-ai-engine` (11 locally, 14 in CI — the count varies by project):

- `README.md:776`, `:777` — `.claude/agents/` and `.claude/agents/CONTEXT.md`, deleted wholesale by
  the v3.0.0 migration. syntek-base's own `.copier/README.md` has **zero** references to that path.
- `README.md:469`, `:508`, `:513`, `:534`, `:558`, `:758` — pre-v7.0.0 PM workflow numbers
  (`01-story-creation`, `02-sprint-planning`, `14-sprint-plans`, `03-database-schema`,
  `07-wireframes`, `20-pr-and-review`).
- `README.md:465` — `US001.md` / `US042.md`, flagged as instance citations.
- `how-to/docs/GIT-WORKTREES.md:54` — dangling `../<slug>-usXXX`.

The v6.0.0 migration did repoint `01-FEATURE → 01-FEATURE-MAPS` in this file, so a migration _can_
reach it; nothing repoints the rest. **The question is whether seed-once should have an escape
hatch for a file that is documentation rather than an accumulator.**

### 4. Rendering breaks Prettier's table alignment across 47 files

The template's markdown tables are pipe-aligned against **token text**; generation substitutes a
real value of a different length and every aligned table in the file goes out of true. Fails
`Markdown — Lint` (MD060), `JS/TS — Lint & Format` (Prettier `--check`) and `Claude Code [3/8]
Format` simultaneously. Confirmed sites include `README.md:712`, `VERSION-HISTORY.md:12`,
`questionnaires/CONTEXT.md:31`, `project-management/src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md:8`,
`project-management/src/23-INCIDENTS/INCIDENT-000-TEMPLATE.md:23` and `INCIDENT-INDEX.md:32`.

This is the widest and probably the cheapest: either the tables stop being aligned-style, or
generation ends with a formatting pass.

### 5. `ruff format` on fenced Python, 2 files

`code/docs/rls/MIDDLEWARE-AND-NINJA.md:198` — a `list(...)` call ruff would join onto one line.
**Already a known open item**: syntek-base's own `CHANGELOG.md` 7.3.0 entry records the
`format.sh` scope gap ("recorded, not closed") — the host `ruff` is below the 0.16 floor at which
Python inside Markdown is formatted, and the container leg does not mount `code/docs/`. Same
defect, now visible downstream too.

### 6. Pre-existing, one project only — not a template defect

`syntek-accountability` also fails `Audit — Conflict Markers` on
`DESIGN-NOTES.md:679` — a stray `</content>` tag after a table, transcript residue in
<%DEVELOPER_NAME%>'s own file. Unchanged by the update, absent from the other three. Left alone
deliberately: deleting a line from those design notes is <%DEVELOPER_NAME%>'s call, and the audit that catches it only
arrived in v7.3.0.

---

## Next

**Grill the scope first, then fix.** Items 1–4 are four different answers to one question — what a
gate authored in the template is allowed to assume about the tree it runs in — and settling that
once is cheaper than four patches. Open with `/grill-with-docs` on that question, then take item 4
(the table alignment) as the first fix, because it is the widest blast radius and the least
entangled with the others.

---

## Next skills

- `grill-with-docs` — settle the scope question above before any script is edited.
- `cicd` + `runbook` — the audit scripts under `code/src/scripts/audits/` and the CI workflows.
- `doc-writer` — `code/docs/GATE-REPORTING.md` and `code/docs/FORWARD-VOICE.md` both carry
  doctrine this touches.
- `version` then `git` — the fix lands as its own release; four projects then re-update.

Roster: `.claude/skills/CONTEXT.md`.

---

## Open questions

1. **Where should the vendored Cloudinary skills live in a generated project**, given symlinks do
   not survive generation? The exemption test cannot be `-L` on both sides.
2. **Should a gate that cannot run downstream fail, skip, or self-declare?**
   `code/docs/GATE-REPORTING.md` already rules that "could not look" is never reported as "looked,
   and it was clean" — items 2 needs a decision consistent with it.
3. **Does the seeded `README.md` need a refresh path**, or is a stale README the accepted price of
   seed-once (`14-UPDATING.md:43`)?
4. **Should the four projects re-update after the fix**, or absorb it at their next natural pull?

---

## Artefacts

| Path                                                            | What it is                                                            |
| --------------------------------------------------------------- | --------------------------------------------------------------------- |
| `code/src/scripts/audits/skill-conformance.sh`                  | `is_vendored` at `:363`; the reasoning it needs extending at `:214`   |
| `code/src/scripts/audits/docs-length.sh`                        | exemption `case` at `:368`                                            |
| `code/src/scripts/audits/doc-references.sh`                     | `_exclude` parse at `:375`; Check 3 rationale from `:31`              |
| `code/src/scripts/audits/routing-skills.sh`                     | flag lookup at `:294`; the self-declared coverage gap at `:359`       |
| `copier.yml`                                                    | `_exclude`, `_tasks` (seed-once gates), `_migrations`                 |
| `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`                      | seed-once and its corollary, `:29`–`:45`                              |
| `code/docs/GATE-REPORTING.md`                                   | absent tool vs absent surface — the rule Open Question 2 answers to   |
| `code/docs/FORWARD-VOICE.md`                                    | `template-only` marker doctrine behind item 2                         |
| `CHANGELOG.md` · `RELEASES.md`                                  | the 7.4.1 entries; the 7.3.0 `format.sh` scope-gap note behind item 5 |
| `.github/workflows/audit-*.yml` · `syntax-*.yml` · `claude.yml` | the jobs that go red downstream                                       |
| syntek-base `111637a`, tag `v7.4.1`                             | the release the four projects updated to                              |
| Project commits `b2cc493` · `c48907a` · `4c01573` · `7ab1915`   | the four update commits, each with the full reasoning in its message  |

**Reproduce any of it** without touching a live project: generate into `/tmp` with
`uvx copier copy --trust --defaults --data-file <answers> . /tmp/probe`, then run the audit there.
An answers file can be cut from any project's `.copier-answers.yml` by dropping the `_`-prefixed
keys.

**One operational note worth keeping.** Copier serialises through a single shared bare clone at
`~/.cache/copier/git/<hash>.git`, so concurrent updates race on `refs/heads/main` and fail with
`cannot lock ref`. Run project updates **serially**. Separately,
`template-update.sh -- --defaults` fails: the script already forces `--defaults` in its preview and
copier's plumbum CLI rejects the repeated switch. Its `--apply` path does not force it, so apply
with `uvx copier update --trust --defaults --conflict inline` directly.
