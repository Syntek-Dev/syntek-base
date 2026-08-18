# HANDOFF — v6.0.0 rename of the four "feature" surfaces

**Written**: 18/08/2026 · **Branch**: `pm/base-health-map` · **Session**: grill + build, interrupted mid-build

---

## Goal

Retire the collision where **"feature" means two different sizes** in this repository — an epic
charted on a map, and a single buildable story — by renaming four surfaces and shipping the
`_migrations` entry the resulting MAJOR owes. `CONTRIBUTING.md:204` makes any move of an inherited
directory MAJOR, and `:208` makes a migration mandatory, so all four ride **one** v6.0.0 bump
rather than four.

---

## The settled design — `/grill-me` recorded nothing, so this section IS the decision record

Thirteen questions were put and answered in session. **None of it exists anywhere else.** Losing
this file loses the design.

| #   | Decision                                                                                                    | Settled |
| --- | ----------------------------------------------------------------------------------------------------------- | ------- |
| Q1  | `src/01-FEATURE` → **`01-FEATURE-MAPS`** (plural artefact noun, matching `02-STORIES`/`14-DECISIONS`)       | Sam     |
| Q2  | `pm/workflows/01-feature` → **`01-feature-map`** (covers SUGGEST+CHART+RESOLVE, not just chart)             | Sam     |
| Q3  | `code/workflows/01-new-feature` → **`01-implement-story`**                                                  | Sam     |
| Q4  | **One** migration script, not two                                                                           | Sam     |
| Q5  | **Act** on path-shaped citations, **advise** on prose                                                       | Sam     |
| Q6  | Migration rescues **all four** trees; `template-orphans.sh` scan roots left unchanged                       | Sam     |
| Q7  | Rewrite anchored with **perl negative lookahead** — `01-FEATURE(?!-MAPS)` — idempotent by construction      | Sam     |
| Q8  | Proven **both** ways: `--self-test` **and** one live `copier copy` → `copier update`                        | Sam     |
| Q9  | **Everything in one commit** — renames + migration + description rewrite + both defects                     | Sam     |
| Q10 | Rewrite touches **all tracked text files**, not just markdown                                               | Sam     |
| Q11 | Rewrite path + `skills:` frontmatter; **report** backticked `` `feature` `` prose                           | Sam     |
| Q12 | Stays on **`pm/base-health-map`** (avoids a second Claude Code session)                                     | Sam     |
| Q13 | Live proof uses a **local throwaway `v6.0.0` tag**, deleted straight after; `23-release` makes the real one | Sam     |

**Two calls made rather than asked:** the advisory report names its destination in `v5.0.0`'s
style; the exit contract follows `v2.0.0` (collisions → 1, advisory findings never fail the run).

**Standing facts that justify the shape** — re-derive nothing:

- The orphan is **guaranteed in 100% of projects**, not hypothetical: `copier.yml:732` seeds
  `MAP-SCALE-PLANNING.md` into that folder via a `_task`, and `_tasks` run on **copy only, never
  update**. On update copier deletes what it owns and leaves that file in a directory with no
  `CONTEXT.md` — `template-orphans.sh`'s exact orphan signature.
- Sam has **no actively-started downstream project**, so the acting half cannot be validated
  against real stranded work. That is why Q8 took both proofs.
- `v5.5.0` **is** tagged (58 tags total), so the live proof's "from" side works.

---

## Done

- **Four `git mv` renames**, all staged, 20 files (`git status --porcelain | grep '^R'`):
  - `.claude/skills/feature/` → `.claude/skills/implement-story/`
  - `code/workflows/01-new-feature/` → `code/workflows/01-implement-story/`
  - `project-management/workflows/01-feature/` → `project-management/workflows/01-feature-map/`
  - `project-management/src/01-FEATURE/` → `project-management/src/01-FEATURE-MAPS/`
- **Path sweep applied across 72 files** with the four perl rules (rule order matters:
  `01-new-feature` first, then `01-feature(?!-map)`, then `01-FEATURE(?!-MAPS)`, then
  `skills/feature\b`). **Zero residual old path tokens.**
- **Deliberately excluded from the sweep** — `CHANGELOG.md`, `VERSION-HISTORY.md`, `RELEASES.md`,
  `.copier/RELEASES.md`: rewriting a v2.0.0 changelog entry would falsify history.
- **`.claude/skills/implement-story/SKILL.md`** — `name:` now matches the folder (spec 3);
  description rewritten to name the **`US###` unit** and the wayfinder distinction; H1 now
  `# Implement a Story`; `22-pr-and-review` **dropped** from Governing procedures (it contradicted
  the skill's own "not the PR that ships it").
- **19 backticked `` `feature` `` prose sites** rewritten — every one hand-verified as the skill.
- **`skills: [feature, …]` arrays** updated in `code/workflows/01-implement-story/{STEPS,CHECKLIST}.md`.
- **`.claude/skills/CONTEXT.md:17`** tree entry re-aligned to the 24-char arrow column.
- **All four hardcoded sites were caught by the sweep** and verified correct: `copier.yml:732`,
  `.github/scripts/shipped-artefacts.sh:103`/`:105`/`:273-275`,
  `code/src/scripts/audits/doc-references.sh:113`/`:201`.
- Earlier, unrelated but uncommitted on this branch: `MAP-NAVIGATION.md`'s two "gitignored" claims
  corrected to "git-tracked but copier-excluded" (now at
  `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md`, carried across by `git mv` as `RM`).

---

## In-flight

- **`REFERENCES.md:124`** — table label still reads `01 — New feature`; the link beside it is
  already correct. Should read `01 — Implement story`.
- **`REFERENCES.md:166`** — label still reads `01 — Feature`. Should read `01 — Feature map`.
- **`REFERENCES.md:209`** — the pairing row lists `01-implement-story` under `20-frontend-code`
  only. **Defect #2 from Q9**: that workflow's own `CONTEXT.md` opens "A feature crosses the
  backend **and** the frontend", so the table understates it. Correction not yet applied.
- **Roster prose not yet re-worded** — `.claude/skills/CONTEXT.md:127` still describes the skill as
  "A new capability has to be built end to end"; `:17`'s tree comment says the same. Both should
  name the story unit, matching the new description.
- **Other index labels unswept** — `code/workflows/CONTEXT.md` and
  `project-management/workflows/CONTEXT.md` were not checked for prose labels naming the old
  workflow titles.
- **`.copier/migrations/v6.0.0-rename-feature-surfaces.sh` — NOT WRITTEN.** This is the main
  outstanding deliverable.
- **`_migrations:` entry — NOT REGISTERED.** Goes in `copier.yml` after the `v5.0.0` block that
  ends near `:681`, same shape: `- version: v6.0.0` / `command: bash "<% _copier_conf.src_path
%>/.copier/migrations/…"` / `when: "<% _stage == 'after' %>"`.
- **No gate has been run. No formatting has been run.** The sweep broke markdown table alignment
  in several files (`REFERENCES.md`, `.claude/skills/CONTEXT.md`, `project-management/REFERENCES.md`).
- **Version set still reads 5.5.0** — no bump attempted.

---

## Next

**Write `.copier/migrations/v6.0.0-rename-feature-surfaces.sh`**, modelled on
`.copier/migrations/v2.0.0-renumber-src.sh` (the acting precedent — read its move loop at
`:56-90`) and `v5.0.0-git-guide-split.sh` (the advisory precedent), with three behaviours in one
script: act on stranded dirs in all four trees using a per-tree marker guard (`CONTEXT.md` for
`src/` and both workflow trees, `SKILL.md` for skills), act on path + `skills:` citations via the
negative-lookahead rules, and report backticked `` `feature` `` without affecting exit code.

---

## Then, in order

1. Finish the in-flight prose labels above.
2. Register the `_migrations:` entry in `copier.yml`.
3. `bash code/src/scripts/syntax/format.sh --fix --file-type markdown` — repairs table alignment.
4. Gates: `skill-conformance.sh`, `routing-skills.sh`, `doc-references.sh`, `docs-length.sh`,
   `docs-pairing.sh`, `template-orphans.sh`, and `.github/scripts/shipped-{readme,artefacts}.sh`.
5. `--self-test` the migration, then the live proof: `copier copy --vcs-ref v5.5.0` into a scratch
   dir → commit → local `git tag v6.0.0` → `copier update` → assert the rescue → `git tag -d v6.0.0`.
6. Version bump 5.5.0 → 6.0.0 via the `version` skill (MAJOR).

---

## Next skills

`version` (the MAJOR bump and its whole file set) · `cicd` (the migration script and the
`copier.yml` registration) · `doc-writer` (the roster and index prose) · `global-workflow` (the
conventional commit). Roster: `.claude/skills/CONTEXT.md`.

---

## Artefacts by path

- `.copier/migrations/v2.0.0-renumber-src.sh` — the acting precedent to copy
- `.copier/migrations/v5.0.0-git-guide-split.sh` — the advisory precedent
- `copier.yml:656` — the `_migrations:` block · `copier.yml:126` — the `src/**` `_exclude`
- `CONTRIBUTING.md:185-208` — "syntek-base's public API", the MAJOR rule and the migration duty
- `code/src/scripts/audits/template-orphans.sh` — the orphan signature this all turns on
- `project-management/docs/git/BRANCHES-AND-WORKTREES.md:51-56` — branch prefixes
- `project-management/src/01-FEATURE-MAPS/` — the eight live maps, moved intact

---

## Open questions

**None on the design** — all thirteen are settled above. One execution unknown remains: whether
`copier update` in the live proof leaves `MAP-SCALE-PLANNING.md` stranded exactly as predicted.
**That prediction is the premise of the whole change and has never been watched.** If it turns out
copier does _not_ strand it, the acting half of the migration is unnecessary and Q6 should be
revisited before the commit — do not assume the prediction holds because it is written down here.
