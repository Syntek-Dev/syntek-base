# QA Plan — US004 The citation gate stops depending on the git index

| Field         | Value                                                                          |
| ------------- | ------------------------------------------------------------------------------ |
| **Story**     | US004 — The citation gate stops depending on the git index                     |
| **Date**      | 02/09/2026                                                                     |
| **Sprint**    | SPRINT-02 — the citation gate, and the absence guide behind it                 |
| **Wireframe** | N/A — this story edits one bash script, its fixtures, a register and four docs |
| **Status**    | Signed off                                                                     |

---

## 1. Acceptance criteria gaps

**Nine gaps found, and the first two overturn premises the story was written on.** Every
candidate was tested by executing the script rather than by reading it — the standing lesson from
`project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` Batch D, whose own proposed glob
was measured and rejected. Two candidates were refuted and are not listed. **All nine were
resolved into `project-management/src/02-STORIES/US004.md` on 02/09/2026**, in the same pass,
before the sprint plan locks scope. Sign-off is <%DEVELOPER_NAME%>'s.

- **AC-GAP-1** `[RESOLVED]` — **Check 1 already has a naming-row guard, so the story's proposed
  one was a restatement.** `code/src/scripts/audits/doc-references.sh:791` reads
  `[ "$is_naming_row" = true ] && continue`, last in the chain after exists → seeded →
  registered. The story's Scenario 4 asserted the opposite — _"Check 1 consults neither
  is_naming_row nor is_marked"_ — and required a second, token-level guard beside it. That is the
  duplication `MAP-RULE-OWNERSHIP` was chartered to remove, in a story cut from that map. The
  false claim came from grepping lines 700–760, a window ending 31 lines short of the guard.
  **The guard is dropped and the scenario is rewritten.**
- **AC-GAP-2** `[RESOLVED]` — **the register mechanism the story leans on cannot match a patterned
  row.** `is_registered()` (`code/src/scripts/audits/doc-references.sh:376-378`) is
  `grep -qxF` — fixed-string, whole-line — and all three existing rows in
  `how-to/src/PROJECT-PATHS.md` are literal paths. A row reading
  `project-management/src/18-TESTS/US###-MANUAL-TESTING.md` matches no concrete citation, so
  covering the population would need one row per story, forever. **`is_registered()` becomes
  pattern-aware, translating `###` to `[0-9][0-9][0-9]` before matching**, and
  `code/docs/FORWARD-VOICE.md` Section 3 plus the register's own header state that a row may be
  patterned. The `###` spelling was chosen over a shell glob because it is the spelling the
  naming rules, `US000-TEMPLATE.md` and `is_naming_row` itself already use.
- **AC-GAP-3** `[RESOLVED]` — **"the run exits 0" cannot be satisfied by a correct
  implementation.** Six findings survive US004 whatever it does: three citations of
  `code/docs/ABSENCE.md` belonging to US003, and three of
  `code/src/scripts/audits/SLOP-FAMILY.md` belonging to the parallel session's US002 ADRs. This
  is `project-management/src/11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` AC-GAP-2
  recurring one story later. **The criterion is restated as a class delta** — no finding of the
  classes this story owns remains, and every survivor is named with the story that owns it, per
  `code/docs/GATE-REPORTING.md`.
- **AC-GAP-4** `[RESOLVED]` — **the Check 2 exemption was keyed on a predicate that evaporates
  downstream.** It read `is_template_only()`, and `build_template_only()`
  (`code/src/scripts/audits/doc-references.sh:412-415`) returns early when `copier.yml` is
  unreadable — which is every generated project, because `copier.yml:36` excludes itself. `N-009`
  Q31 rejected that same delegation in the same script, in the same sitting this story is cut
  from: _"correct-by-construction here and vacuous downstream, because nothing reports its
  absence."_ **The exemption is re-keyed onto a property of the citing file**, settled at
  AC-GAP-5.
- **AC-GAP-5** `[RESOLVED]` — **and a bare `project-management/src/*` glob fails in the other
  direction.** That tree is not a proxy for "does not ship": `copier.yml:120-146` re-includes the
  `CONTEXT.md`/`CLAUDE.md` pairs, every `*TEMPLATE*`, and a named allowlist —
  `00-ASSETS/scripts/*.sh`, `06-BRAND-GUIDE/guide-build/*`, `07-COMPONENTS/component-build/*`,
  `08-WIREFRAMES/SHARED/wireframe.css`, six `09-GDPR/*.md` registers,
  `18-TESTS/US000-*`, `23-INCIDENTS/INCIDENT-INDEX.md` and the `WALK-TESTS/` pair. A glob would
  exempt roughly twenty shipped files, and two of them carry genuine findings today:
  `project-management/src/02-STORIES/CONTEXT.md:16` cites `US001.md` and
  `project-management/src/03-SPRINTS/CONTEXT.md:17` cites `SPRINT-01.md`. **The exemption instead
  tests whether the citing file is itself an instance artefact** — `US###`, `SPRINT-##`,
  `ADR-US###`, `QA-PLAN-US###`, `STORY-PLAN-US###`, `SPRINT-PLAN-##`, `REVIEW-US###`, `BUG-*` —
  with the `US000` and `*TEMPLATE*` forms excluded, those being the allowlist's only
  instance-shaped entries. It holds identically in both trees and cannot reach a pair file,
  because a pair file is not instance-shaped.
- **AC-GAP-6** `[RESOLVED]` — **the story's second register row covers nothing.** It named
  `17-STORY-PLANS/STORY-PLAN-US###-*.md`. Measured: of the 22 findings the
  `project-management/src/*` arm newly produces, **every one cites
  `project-management/src/18-TESTS/`** — nothing in the repository cites a story plan that does
  not exist. `how-to/src/PROJECT-PATHS.md`'s own rule is that a row must never answer a question
  in passing. **The two rows become `18-TESTS/US###-MANUAL-TESTING.md` and
  `18-TESTS/US###-TEST-STATUS.md`.**
- **AC-GAP-7** `[RESOLVED]` — **the ~70-token figure behind the naming guard was never
  measured.** The story's Scenario 4 cited "roughly seventy naming patterns" as the reason the
  guard was needed. That count came from an ad-hoc grep applying no naming-row test. **Measured
  by executing a patched copy of the script**: the arm alone takes `project-management/src` from
  **16 dangling-path findings to 38**, and all 22 additions are forward references to
  `18-TESTS/US###-*.md`. **Zero are naming patterns.** The figure is replaced by the measurement
  and the method recorded, so the next reader can reproduce it.
- **AC-GAP-8** `[RESOLVED]` — **the untracked-file probe cannot see the file it creates.**
  `build_template_only` and `build_template_only_index` run once at load
  (`code/src/scripts/audits/doc-references.sh:485-486`); `self_test()` is not called until
  `:913`. A file created inside the probe is invisible to a set built 428 lines earlier, so the
  probe as written would assert against a stale set and pass for the wrong reason. **The probe
  must re-run both builders after creating the file**, and carry a `trap` so a failure between
  creation and assertion does not leak an untracked file into the working tree.
- **AC-GAP-9** `[RESOLVED]` — **the `audits/CONTEXT.md` refresh collides with US002.** That file
  sits at **298 of 300 counted lines**, and US002 in SPRINT-01 owns shrinking it to 230 by moving
  rows out. US004's task refreshes the `doc-references.sh` row in the same file. Whichever lands
  second reverts or duplicates the other, and if US004 lands first it grows a file two lines from
  a hard limit. **US004's edit is scoped to replacing text within the existing row, never adding
  a line**, and the story records that US002 owns the file's shape.

---

## 2. Test scenarios

**Every scenario below runs against the script, not against a rendered surface.** The two proof
modes are the script's own: `st_probe` (a fixture file with an expected finding count) and a
direct predicate assertion in the `st_set_probe` style.

### Happy path (HP-nn)

- **HP-01** — With the fall-through arm in place, a `CONTEXT.md` inside `research/` is no longer
  exempt: the direct assertion `is_exempt research/CONTEXT.md` answers **no**, and the three tree
  arms still exempt `research/NOTE.md`.
- **HP-02** — The same story file, byte-identical, produces the same finding count untracked and
  tracked. Run `--path` against an instance artefact, record the count, `git add --intent-to-add`,
  re-run, compare, restore the index.
- **HP-03** — A citation of `project-management/src/18-TESTS/US001-MANUAL-TESTING.md` from a story
  passes on the patterned register row, and `is_registered` answers yes for the concrete form.
- **HP-04** — A dead citation to a `project-management/src/` artefact that no register row covers
  is reported for the first time.
- **HP-05** — `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0 with its probe
  count risen by one case per repair.

### Error states (ES-nn)

- **ES-01** — With `how-to/src/PROJECT-PATHS.md` absent or its `## Registered paths` heading
  renamed, `REGISTERED` is empty and every registered path reports. The gate must fail loudly
  rather than silently pass — the failure mode `code/docs/GATE-REPORTING.md` names.
- **ES-02** — With `copier.yml` unreadable, `TEMPLATE_ONLY` is empty and Check 3 finds nothing.
  The instance-artefact citer test still exempts Check 2 correctly, which is AC-GAP-4's whole
  point; assert both halves.
- **ES-03** — The untracked-file probe fails mid-way; the `trap` removes the file and the working
  tree is unchanged.
- **ES-04** — A malformed register row — no backticks, or a pattern with no digits — neither
  crashes the parser nor silently registers everything.

### Edge cases (EC-nn)

- **EC-01** — `project-management/src/18-TESTS/US000-MANUAL-TESTING.md` is a real shipped file and
  is instance-shaped. Assert it is **not** exempted as a citer, and that the register pattern
  matching `US###` does not make its absence unreportable.
- **EC-02** — A `*TEMPLATE*` file under an exempt tree: the fall-through arm admits it, and the
  instance-artefact citer test does not exempt it.
- **EC-03** — A patterned register row must not over-match: `US###-MANUAL-TESTING.md` translates
  to three digits exactly, so `US1234-MANUAL-TESTING.md` and `USxyz-MANUAL-TESTING.md` still
  report.
- **EC-04** — A naming row and a real dangling path on the same line. `is_naming_row` is
  line-level, so the dangling path is suppressed. This is a **known limitation the story does not
  fix** — recorded here so the next reader does not mistake it for a regression US004 introduced.
- **EC-05** — An instance artefact citing another that genuinely does not exist. Check 2 now
  exempts the citer, so the dead citation must be caught by Check 1's new arm instead. Assert the
  two clauses hand over rather than both standing down.

### Permission and access (PA-nn)

- **PA-01** — **N/A.** This story ships no endpoint, no view and no protected action; the script
  runs with the developer's own permissions and reads only tracked and untracked repository files.
  Recorded rather than omitted, per `code/docs/GATE-REPORTING.md`.

---

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — this story renders no interactive surface.** It ships a shell script, Markdown fixtures
and register rows, read in an editor or a terminal. The one accessibility-adjacent obligation is
the script's own output: findings stay in the `file:line [class] token` shape the existing report
uses, so a screen reader and a terminal pager read them identically to today's.

---

## 4. Responsive behaviour

**N/A — no layout, no breakpoint, no rendered page.**

---

## 5. GDPR & security constraints

- **No personal data is read, written or logged.** The script reads repository documentation and
  emits paths.
- **One security-adjacent property is worth asserting:** the untracked-file probe writes inside
  the repository. It must create its file under a path the repository already owns, never in
  `/tmp` with a predictable name, and must remove it on every exit path.
- **No secret, token or environment value enters the script's output.** The findings are paths
  taken from backticked spans in committed documentation.

---

## 6. Developer notes — testability

- **Measure by executing, never by reading.** Every figure in the story was produced by patching
  a scratch copy of the script and running it; two claims made by reading were wrong, and both
  are AC-GAPs above. Copy to an untracked sibling, patch, run scoped with `--path`, delete.
- **`--path` scoping is the cheap loop.** A whole-tree run takes seconds but mixes in every other
  story's findings; `--path project-management/src` isolates this story's population.
- **The before/after must be captured on the same tree.** The parallel session is writing to
  `project-management/src/` continuously — the whole-tree count moved from 22 to 44 during
  02/09/2026 — so a baseline taken an hour before the change is not a baseline.
- **A fixture that passes both scripts proves nothing.** Every new fixture case is run against
  the pre-change script and must fail there.
- **The set builders run once at load.** Any probe that changes what they would read must re-run
  `build_template_only` and `build_template_only_index` explicitly (AC-GAP-8).
- **`git add --intent-to-add` is the reversible way to test the tracked case.** `git reset -- <path>`
  restores it; confirm with `git status --porcelain` after every A/B.
- **Do not edit `code/src/scripts/audits/CONTEXT.md`'s line count.** US002 owns that file's shape
  and it is at 298 of 300 (AC-GAP-9).

---

## Cross-references

- `project-management/src/02-STORIES/US004.md` — the story these gaps were resolved into
- `project-management/src/03-SPRINTS/SPRINT-02.md` — the sprint, at 8/11 SP with US004 its only member and built first (was 13/11 until US003 moved to SPRINT-03 on 05/09/2026)
- `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — slice `S-06`, nodes `N-009` and `N-010`
- `project-management/src/11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — AC-GAP-2 there is AC-GAP-3 here
- `code/docs/GATE-REPORTING.md` — a skip is never reported as a pass
- `code/docs/FORWARD-VOICE.md` — Section 3 owns the register this story makes pattern-aware
- `how-to/src/PROJECT-PATHS.md` — the register gaining the two rows
