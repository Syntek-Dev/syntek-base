# Refactoring Record — US000 {REFACTOR TITLE}

_Template — copy to `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. A behaviour-preserving refactoring record for
one user story (US###): the structural change, its before → after, and the proof that
nothing observable changed._

> Cross-cutting fallback — when a refactor spans several stories and maps to no single one,
> drop the `US###` segment and name the file `REFACTORING-<DESCRIPTOR>-DD-MM-YYYY.md`
> (mirrors `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`). The story-focused form above is preferred.

| Field               | Value                                                                        |
| ------------------- | ---------------------------------------------------------------------------- |
| **Story**           | US### — {short title} · [`../01-STORIES/US###.md`](../01-STORIES/US###.md)   |
| **Story plan**      | [`../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md`](../15-STORY-PLANS/)   |
| **Motivation type** | {oversized file >750 lines · duplication · tech debt · modernise} — pick one |
| **Date**            | {DD/MM/YYYY}                                                                 |
| **Author**          | {name / agent}                                                               |
| **Status**          | {Proposed · In Progress · Complete}                                          |
| **Refactor commit** | `{sha}` — separate from any feature commit (code workflow `11-refactor`)     |

---

## 1. Motivation & trigger

Why this refactor exists, in two or three lines, anchored to the story it closes the loop on
(`../01-STORIES/US###.md`) and the plan that mastered it
(`../15-STORY-PLANS/STORY-PLAN-US###-*.md`). Name the **motivation type** and the concrete
trigger — the review note, retro finding, or gate that surfaced it.

| Trigger                             | Detail                                                         |
| ----------------------------------- | -------------------------------------------------------------- |
| [EXAMPLE] `audits/cloc.sh` gate     | `{path/to/module}` reached {N} lines — over the 750-line limit |
| [EXAMPLE] Rule-of-three duplication | `{helper}` copied identically across {N} files                 |
| [EXAMPLE] Review note               | `../17-REVIEWS/REVIEW-US###-<DESCRIPTOR>.md` flagged {concern} |

**Motivation type** — one of:

- **Oversized file (>750 lines)** — split a module over the source-length limit into deep,
  focused modules (`code/CONTEXT.md`).
- **Duplication** — collapse a rule-of-three violation to a single canonical definition.
- **Tech debt** — remove a workaround, shallow seam, or naming drift a prior story deferred.
- **Modernise** — adopt a newer stack idiom with no change in observable behaviour.

## 2. Scope

The files and modules touched — nothing outside this list changed. Keep it exhaustive so the
diff and this record agree.

| File / module                           | Change                                               |
| --------------------------------------- | ---------------------------------------------------- |
| [EXAMPLE] `{path/to/module}.py`         | Split into `{a}.py` + `{b}.py`; public API unchanged |
| [EXAMPLE] `{path/to/caller}.py`         | Import path updated to the new module                |
| [EXAMPLE] `{path/to/module}/CONTEXT.md` | New — orientation for the extracted package          |

**Out of scope (unchanged):** {list anything a reader might expect to be touched but is not —
public signatures, DB schema, Django Ninja API contract, rendered output}.

## 3. Before → After

Show the structural shift — module layout and line counts. A refactor moves code; it does not
add behaviour, so the totals move but the surface does not.

**Structure:**

```text
Before                                  After
──────                                  ─────
{module}.py            {N} lines   →    {module}/__init__.py     {n} lines
                                        {module}/{part_a}.py     {n} lines
                                        {module}/{part_b}.py     {n} lines
```

**Line counts** (from `bash code/src/scripts/audits/cloc.sh {paths}`):

| Unit                             | Before | After | Note                                 |
| -------------------------------- | ------ | ----- | ------------------------------------ |
| [EXAMPLE] `{module}.py`          | 812    | —     | Removed — split below                |
| [EXAMPLE] `{module}/{part_a}.py` | —      | 410   | New — extracted, under the 750 limit |
| [EXAMPLE] `{module}/{part_b}.py` | —      | 402   | New — extracted, under the 750 limit |

## 4. Behaviour-preservation proof

The defining property of a refactor: observable behaviour is identical before and after. Each
line below must hold and carry evidence — an unresolved item blocks the record.

- **Tests unchanged and green** — the existing suite ran **before** the change and **after**
  it with no assertion edits; the same tests pass on both sides. Evidence:
  `bash code/src/scripts/tests/all.sh` — {N passed} on both HEAD~1 and HEAD.
  [EXAMPLE] _If a test had to change, it is a behaviour change — stop and route it to a story,
  not this record._
- **Coverage not reduced** — module coverage is equal or higher after the refactor; no branch
  lost its test. Evidence: `bash code/src/scripts/tests/backend-coverage.sh {module}` (or
  `backend-coverage.sh`) — {before}% → {after}%.
- **Separate commit** — the refactor ships as its **own commit**, isolated from any feature or
  fix, executed through code workflow [`11-refactor`](../../../code/workflows/11-refactor/)
  (or the `refactor` agent). Evidence: commit `{sha}`, message `refactor: {summary}`.
- **Public surface intact** — signatures, Ninja Schema models, URLs, and rendered output are
  byte-for-byte unchanged (or diff-verified equivalent). Evidence: {OpenAPI snapshot clean /
  schema snapshot / observed output}.

## 5. Risk & rollback

| Risk                                    | Likelihood | Mitigation                                    |
| --------------------------------------- | ---------- | --------------------------------------------- |
| [EXAMPLE] Import cycle after the split  | Low        | `bash code/src/scripts/syntax/check.sh` clean |
| [EXAMPLE] Missed caller of moved symbol | Medium     | Full-tree grep; `tests/all.sh` green          |

**Rollback:** revert the single refactor commit `{sha}` — no data migration, no schema change,
so `git revert {sha}` restores the prior structure with zero side effects. State any exception.

## 6. Verification

Run from the repo root; every command is a project script (never raw pytest / pnpm / docker).

```bash
bash code/src/scripts/syntax/lint.sh     # lint: Python (ruff) + Markdown — 0 issues
bash code/src/scripts/syntax/check.sh    # basedpyright type check — clean
bash code/src/scripts/audits/cloc.sh     # line counts — all touched files ≤ 750 lines
bash code/src/scripts/tests/all.sh       # full suite — same tests, all green
```

Record the observed result beside each below:

| Command                     | Expected        | Result     |
| --------------------------- | --------------- | ---------- |
| [EXAMPLE] `syntax/lint.sh`  | 0 issues        | {0 issues} |
| [EXAMPLE] `syntax/check.sh` | clean           | {clean}    |
| [EXAMPLE] `audits/cloc.sh`  | all ≤ 750 lines | {pass}     |
| [EXAMPLE] `tests/all.sh`    | {N} passed      | {N passed} |

## 7. Conventions established

Any pattern this refactor makes canonical, so a future change follows it rather than
re-introducing the old shape. "None." is a valid entry.

1. [EXAMPLE] Define `{helper}` once in `{canonical module}`; callers import it — never re-copy.
2. [EXAMPLE] Modules over ~600 lines split proactively before they breach the 750-line limit.

---

## Cross-references

- [`../01-STORIES/US###.md`](../01-STORIES/US###.md) — the story this refactor closes the loop on
- [`../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md`](../15-STORY-PLANS/) — the code master
- [`../17-REVIEWS/`](../17-REVIEWS/) — the review that may have flagged the refactor
- [`../../../code/workflows/11-refactor/`](../../../code/workflows/11-refactor/) — the behaviour-preserving refactor procedure
- `code/CONTEXT.md` — the 750/800-line source-file limit this record answers to
