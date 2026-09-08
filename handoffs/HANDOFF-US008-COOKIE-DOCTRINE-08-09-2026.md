# HANDOFF — US008 cookie doctrine, grilled and settled, nothing written

**Written**: 08/09/2026 · **Branch**: `pm/story-creation` · **HEAD at write**: `98e3847`
**Workflow in play**: `project-management/workflows/02-story-creation/` — Step 0 complete, Step 1
grilling complete and confirmed, Step 1a onward not started

---

## Goal

Cut **`US008`** from `MAP-SUBDOMAIN-ROUTING` slice **`S-02` — "The cookie doctrine lands"**, via
`02-story-creation`. The grilling pass is **finished**: thirteen decisions are settled across three
frontier rounds. **Nothing has been written to the repository.** The whole settled design lives in
this file and nowhere else — if it is lost, two measurement workflows (21 agents) are lost with it.

---

## Done

**No repository changes were made this session.** Everything below is a settled decision or a
measurement, not an edit.

### The settled design — thirteen decisions

| #   | Decision                                                                                                                     |
| --- | ---------------------------------------------------------------------------------------------------------------------------- |
| Q1  | **Full five-document sweep**, not the two the slice names                                                                    |
| Q2  | `CSRF_COOKIE_HTTPONLY = True` lives in **`base.py`**, not the environment modules                                            |
| Q3  | The gate **folds into an existing audit** — no 25th script, `audits/CONTEXT.md` untouched                                    |
| Q4  | **`SPRINT-05` opens and `US008` starts it**, superseding the 07/09 refusal                                                   |
| Q5  | A **`_migrations:` advisory** ships; the release is a **MINOR** bump (7.5.0 → 7.6.0)                                         |
| Q6  | **`doc-references.sh --path code/docs`** is the verification criterion, not the 254-finding whole-tree baseline              |
| Q7  | The gate host is **`negative-space.sh`** — the only audit reading `config/settings/`; asserts presence _and_ absence         |
| Q8  | **PROVENANCE note _and_ a map re-cut** in the same change, on the `US006` precedent                                          |
| Q9  | `CSRF_COOKIE_HTTPONLY` **pasted into both** near-duplicate blocks; the duplication becomes a `GAPS.md` row                   |
| Q10 | This session **cuts the story only** — `SPRINT-05` is handed to `03-sprint-planning`                                         |
| Q11 | The advisory's preview blindness is **accepted plus a `GAPS.md` row**, not fixed in-story                                    |
| Q12 | **Must-Have**                                                                                                                |
| Q13 | **Both ADRs written, both named `ADR-US008-*`** — `ADR-US003` is **not** amended, appended to, or superseded (Sam, explicit) |

**Estimate: 8 SP.** Q7's `negative-space.sh` widening buys an executable surface with a fixture
pair, which is the `US004`/`US006` rung. The measured ladder: 3 SP = `US002` (two Markdown files);
5 SP = `US001`/`US003`/`US005`/`US007` (multi-file doctrine sweeps, no executable surface);
8 SP = `US004`/`US006`. `US008` is the first story to touch Python, `code/src/django/**`, a copier
migration or a version bump at all.

### What the story ships

**Five document rewrites** — `code/docs/URL-STRATEGY.md:149-153` (Phase 2 mandate defers to the
owner; **`:147` is left alone**, measured true under the new doctrine) · `code/docs/security/CRYPTO-AND-DATA.md:122-123`
(respecified host-only + `__Host-`; becomes sole owner of cookie-**scope** doctrine) ·
`code/docs/api-design/AUTH-STRATEGY.md:67` (the `SESSION_COOKIE_PATH=/` cell — the tree's second
cookie-scope statement — defers) · `code/docs/security/AUTH-AND-AUTHZ.md:133-140` and
`code/docs/security/OWASP-AND-CHECKLIST.md:44-51` (both gain `CSRF_COOKIE_HTTPONLY = True`).

**Three settings values** — `base.py` gains `CSRF_COOKIE_HTTPONLY = True` beside
`SESSION_COOKIE_HTTPONLY` at `:159-160`; `staging.py` and `production.py` each gain `__Host-`
prefixed `SESSION_COOKIE_NAME` and `CSRF_COOKIE_NAME` beside their `SECURE = True` lines at
`:21-22`; `code/src/django/config/settings/CONTEXT.md:47`'s table gains the rows, compulsory under
`config/settings/CLAUDE.md:23-24`.

**The gate** — `code/src/scripts/audits/negative-space.sh`: widen `SETTINGS_FILE` (`:92`) past
`base.py`, add a clause asserting the two `_DOMAIN` settings are never set, the `__Host-` names are
present in staging and production, and `CSRF_COOKIE_HTTPONLY` is true. Drags a `broken/`+`clean/`
fixture pair, a `--self-test` expectation, one `how-to/src/INVARIANTS.md` row and one
`code/docs/NEGATIVE-SPACE.md` clause. **`audits/CONTEXT.md` is not edited** — US002's headroom is
preserved.

**Template migration** — a `v7.6.0`-keyed advisory in `copier.yml` `_migrations:` (print-only,
exit 0), its script, and a row in `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`'s per-version
register (`:201-209`). Version 7.5.0 → 7.6.0 via the `version` skill.

**Records** — two `ADR-US008-*-08-09-2026.md` files (the scoped citation baseline, citing
`ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` as an exception; the first sub-MAJOR
`_migrations:` key) · three `GAPS.md` rows (the duplicated security-settings block and its drift;
`template-update.sh` hiding migration output in preview; the stale 131 → **254** figure at
`GAPS.md:387-444`) · a PROVENANCE block on the `US004`/`US006` pattern · the map re-cut.

**Does not do** — open `SPRINT-05`; collapse the duplicated settings blocks; fix
`template-update.sh`; touch `ADR-US003`; pre-empt S-01's rule-section filename.

### Corrections the measurements forced

- **`doc-references.sh` is red at 254, not the 131 in `GAPS.md:387-444`** — re-measured, exit 1,
  35,760 tokens checked. The script itself is uncommitted (+128/−3), so HEAD reproduces neither.
  `--path code/docs` is **clean, exit 0**.
- **`audits/CONTEXT.md` is 298 counted lines, not 299.** The prior handoff's "drift" note was the
  error; `US002.md`'s figure is correct. A live `docs-length-allow` expires 01/12/2026, so growth
  to exactly 300 clears both the limit and the ratchet; 301 hard-fails.
- **`security.sh` is not a viable gate host** — dependency-CVE only, reads no project source, the
  only one of 24 with no `--output`/`--self-test`/`--path`, and currently **exits 1** on 12 pnpm
  advisories in the Expo tree.
- **Copier fires MINOR-keyed migrations** — `_template.py:457`,
  `if not (self.version >= current > from_template.version): continue`. A `v7.6.0` key is legal.
- **The `SPRINT-05` refusal is in six files / eight statements, not three**, and none is a standing
  prohibition — all eight echo one 07/09 decision. The prior handoff's `SPRINT-04.md:186` is stale;
  the text is at `:196`.
- **Next story-plan prefix is `08-`** — `01-` is reserved for `US007`, `07-` for `US006`.
- **The two settings blocks are near-duplicates, not verbatim** — `OWASP-AND-CHECKLIST.md:52`
  carries a ninth setting (`SECURE_BROWSER_XSS_FILTER`) that `AUTH-AND-AUTHZ.md` lacks. They have
  already drifted once.

---

## In-flight

**Nothing is mid-edit.** The session ended on an unanswered scope question, not inside a change.

- `project-management/src/02-STORIES/US008.md` — **does not exist.** `US008` is a free number.
- `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md:323` — `S-02`'s `Story` column
  reads `—`; Step 4 back-fills it to `US008`.

### Working tree, not this session's doing

`git status` carries **67 modified, 8 added, 6 renamed and 2 deleted** paths, none written here —
substantially more than the 28 the prior handoff recorded, so Sam has been working in parallel.
`handoffs/HANDOFF-US008-SLICE-SELECTION-07-09-2026.md` is already deleted unstaged; this file
replaces it. Establish what is intended to be committed before adding to it.

---

## Next

**Answer the scope question below, then run `02-story-creation` Step 1a onward** — fill the 13-row
FLAGS table, generate `US008.md`, back-fill the map, write the two ADRs and the three `GAPS.md`
rows. No further grilling is needed; the frontier is empty and Sam confirmed all thirteen.

The FLAGS values are already derived and need no interview: `Security` from the slice manifest ·
`Backend: Yes` (the story touches `config/settings/*.py`) · `QA` = the fixture-backed audit
self-test Q7 bought · the other ten `N/A`, including `GDPR` — strictly-necessary cookies being
hardened, not new data collected.

---

## Next skills

`story` for the cut itself; `security` for the cookie doctrine's substance; `doc-writer` for the
five rewrites; `global-workflow` for the artefact conventions; `version` for the 7.6.0 bump.
Roster: `.claude/skills/CONTEXT.md`.

---

## Open questions

- **Does the map re-cut ride inside the story change, or ship as a separate `01-feature-map`
  correction?** `02-story-creation` Step 4 says the `Story` column back-fill is _"the one edit this
  workflow makes to a wayfinder artefact; it does not touch the frontier or the resolved
  decisions"_ — and Q8's re-cut edits four resolved-decision `Became` cells (`:116`, `:118`,
  `:119`, `:120`) plus `:210-211` and `:447`, repointing the N-004–N-008 deliverables from "the
  slice N-019 gates" to `S-02`. `US006` re-cut its map in the same change, so it is not
  unprecedented, but it exceeds this workflow's stated limit. **Claude recommended a separate,
  explicitly-committed correction; Sam had not answered when the session ended.**

---

## Artefacts

| Path                                                                                                                                                 | What it is                                                                                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`                                                                                    | The map. `:323` the `S-02` row · `:116-120`, `:210-211`, `:447` the six re-cut targets · `:238-240` the deliverables-held list |
| `project-management/workflows/02-story-creation/STEPS.md`                                                                                            | The procedure of record — resume at Step 1a                                                                                    |
| `project-management/src/02-STORIES/US000-TEMPLATE.md`                                                                                                | The 13-row FLAGS table and section skeleton                                                                                    |
| `project-management/src/02-STORIES/US004.md` · `US006.md`                                                                                            | The two PROVENANCE precedents for recording a map disagreement                                                                 |
| `project-management/src/15-DECISIONS/CLAUDE.md`                                                                                                      | ADR naming (`ADR-US###-<DECISION>-DD-MM-YYYY.md`), five sections, no index                                                     |
| `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`                                                            | The ADR the new one cites as an exception — **do not amend, append to, or supersede**                                          |
| `code/src/scripts/audits/negative-space.sh`                                                                                                          | The gate host. `:92` `SETTINGS_FILE` · `:209-211` the `fail`/`skip` helpers · `:405-416` the clause shape                      |
| `code/docs/GATE-REPORTING.md`                                                                                                                        | The idiom for reporting the inherited-red citation gate                                                                        |
| `handoffs/HANDOFF-US007-PLANNING-AND-PLAN-PREFIX-08-09-2026.md`                                                                                      | The parallel `US007` thread                                                                                                    |
| `~/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/72657a87-a129-4ddf-89c6-410588cb2611/subagents/workflows/wf_1862d892-af6/journal.jsonl` | Round 1 measurements — 13 agents, 9 dimensions. **Local only, not committed**                                                  |
| `~/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/72657a87-a129-4ddf-89c6-410588cb2611/subagents/workflows/wf_2fc50d95-56b/journal.jsonl` | Round 2 measurements — 8 agents, 6 dimensions. **Local only, not committed**                                                   |

---

**Last Updated**: 08/09/2026
