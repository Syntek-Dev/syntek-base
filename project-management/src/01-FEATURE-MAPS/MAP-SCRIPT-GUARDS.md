# MAP-SCRIPT-GUARDS — Declared doctrine gains its script-layer enforcement

**Charted**: 31/08/2026 · **Charted by**: Sam Bailey · **Workflow**: `01-feature-map`
**Extended at**: `24b932a` (14/10/2026) — N-006 arrived resolved from the `MAP-SENTENCE-RULES`
grilling (Q3, Q8, Q12); its verification pass opened N-007 and N-008. N-001 to N-005 re-measured
and unchanged
**Status**: Resolving — S-02 cuttable; S-01 waits on N-007 and N-008, and on the extended destination
**Frontier open**: 2 · **Blocking open**: 2

> A **low-resolution index**, not a storage vault — every resolved node links to the artefact it
> became. Charted off `GAPS.md` per its own rule that new items are recorded there first, then
> charted onto a map at the next pass; the two claimed entries were removed from the register in
> the same change, so there is one working copy rather than two that drift (the 13/08/2026
> precedent).

---

## Destination

The two doctrine-without-enforcement gaps in the script layer close: destructive dev scripts read
the deployment posture and refuse above `development` without an explicit override, and the
shipped-artefacts gate proves every seeded file **lands**, not merely that no seed leaked.
**Extended 14/10/2026 (N-006), wording awaiting Sam:** at `development` too, the dev-stack
volume wipe asks before it runs, and the e2e suite owns its own CI stack.

---

## Notes

| Field                    | Value                                                                                                                                                                                                                            |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Shell-script guards: `code/src/scripts/_lib/` + `.github/scripts/`                                                                                                                                                               |
| Skills to load           | `cicd`, `security`, `global-workflow`                                                                                                                                                                                            |
| Standing preferences     | The refuse-loudly idiom — read config once, die at exit 2 rather than degrade (`audits/doc-references.sh:340-352`, `:266-268`); the house `--self-test` + `probe()` pattern all six `.github/scripts/` gates carry               |
| Umbrella ADRs            | None yet — N-003's outcome takes the three-test ADR gate at its story                                                                                                                                                            |
| Register entries triaged | 31/08/2026: 2 closes · 0 blocks · 1 unrelated. **Re-triaged 14/10/2026 for N-006: 0 new closes · 0 blocks · 7 unrelated** — the four dated entries and the three _Still open_ items. `DEFERRED.md` holds zero rows               |
| Index row                | The map index awaits `MAP-INDEX.md`, created by `MAP-REGISTER-INDEXES` S-01; this map joins the backfill population its S-02 sweeps — the shipped `CONTEXT.md` table is not edited (N-001 on `MAP-REGISTER-INDEXES`, 31/08/2026) |

---

## Register claimed

**This is a claim, not a close.** Closing belongs to `workflows/22-implementation-documentation/`,
against shipped code. The two claimed entries were removed from `GAPS.md` on charting (13/08/2026
precedent — one working copy); their full prose is in git history and their substance in the
nodes below.

| Register | Entry                                                                                      | Verdict   | Retired by                                                                                                                                                            |
| -------- | ------------------------------------------------------------------------------------------ | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GAPS.md  | 31/08/2026 — the deployment posture binds Claude, but no script reads it                   | closes    | Slice **S-01**                                                                                                                                                        |
| GAPS.md  | 31/08/2026 — a seed that never arrives is silent; only the negated files checked           | closes    | Slice **S-02**                                                                                                                                                        |
| GAPS.md  | 31/08/2026 — the PE gate's markup half cannot see structure / prefix set                   | unrelated | Not this feature's to claim: half 1 waits on real templates (`MAP-PROGRESSIVE-ENHANCEMENT` S-04); half 2 on that map's S-02 and the first story writing component CSS |
| GAPS.md  | 31/08/2026 — htmx is pinned at major 2 (re-triage, 14/10/2026)                             | unrelated | Its own charted feature, once both triggers fire                                                                                                                      |
| GAPS.md  | 01/09/2026 — a RUSTSEC advisory against an unchanged `Cargo.lock` is invisible (re-triage) | unrelated | A cargo-deny leg in `audit-deps.yml`                                                                                                                                  |
| GAPS.md  | 01/09/2026 — staging and production have no mail backend (re-triage)                       | unrelated | The story that picks the relay                                                                                                                                        |
| GAPS.md  | 16/08/2026 sitting, _Still open_ — three items (re-triage)                                 | unrelated | None claimed here                                                                                                                                                     |

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Type     | Settled    | Became                                                                                                             |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ------------------------------------------------------------------------------------------------------------------ |
| N-001 | **Four destructive scripts are unguarded; two further candidates are already guarded by other means.** Unguarded: `database/reset.sh` (DROP at `:107-110`, `--yes` bypasses the prompt), `database/restore.sh` (`:109-122`), `development/server.sh down --volumes` (`:176`), `tests/server.sh down --volumes` (`:137`). Guarded elsewhere: `development/template-update.sh` already refuses `--apply` without `--force-*` flags (`:253-262`); the three test-teardown `down --volumes` traps destroy test volumes **by design** on every run. `migrate.sh` is non-destructive (run/make/show/check/fake) but is named by the claimed entry — whether posture binds it is N-003's question                                                                                                                                                         | research | 31/08/2026 | this row                                                                                                           |
| N-002 | **The answers file is the only machine-parseable posture carrier, and reading it was anticipated.** `DEPLOYMENT_POSTURE` is asked at `copier.yml:408-419` with the stated rationale that the answer exists in `.copier-answers.yml` "from day one and a later gate can read it"; the file ships tracked in a generated project (not in `_exclude`) as plain YAML; `development/template-update.sh:108` already reads `_commit:` from it. In **this** repo the file is the unrendered template (a Jinja expression), so a guard must handle the no-answer case explicitly                                                                                                                                                                                                                                                                           | research | 31/08/2026 | this row                                                                                                           |
| N-003 | **The answers file is the carrier; the override is per-run and posture-named; four scripts hard-refuse, `migrate.sh` warns.** The guard reads `DEPLOYMENT_POSTURE` from `.copier-answers.yml` directly — the anticipated read (N-002), no second carrier. The override is `--force-posture=<posture>` and must name the **current** posture, so an override pasted from history dies when the posture has since risen (the house `--force-*` idiom of `development/template-update.sh:253-262`; the dated-annotation idiom rejected — a destructive run is a one-shot act, not a standing allowance). Bound: the four N-001 unguarded scripts hard-refuse above `development`; `migrate.sh` prints the posture and the expand-then-contract obligation, then proceeds — no override needed. Sanctions the posture read **only** (see Out of scope) | grilling | 01/09/2026 | Slice **S-01** — acceptance; the carrier + override contract takes the three-test ADR gate at S-01's story (Notes) |
| N-004 | **The `_lib/` posture guard, specified into S-01** — deliverable (a `_lib/` helper wired into the four bound scripts plus the `migrate.sh` warn) and acceptance written into the slice row; the story builds it, never this map                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | build    | 01/09/2026 | Slice **S-01**                                                                                                     |
| N-005 | **The `SEEDED` presence loop and its probe, specified into S-02** — deliverable and acceptance were complete in the slice row at charting (`shipped-artefacts.sh:215-224` check-4 shape, probe shape `:277-280`); no open decision stood above it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | build    | 01/09/2026 | Slice **S-02**                                                                                                     |
| N-006 | **The dev-stack wipe asks first, and the e2e suite owns its CI stack** (`MAP-SENTENCE-RULES` grilling: Q3→2, Q8→2, Q12→1). `development/server.sh down --volumes` (`:176`) gains a confirmation and a `--yes` bypass, modelled on `database/reset.sh:98-101`; `tests/server.sh` stays unprompted, its volumes rebuilt every run. `--yes` never satisfies the posture guard (a charting call). `e2e-py.sh --own-stack` starts the stack, waits for it, refuses if one is already up, and tears it down in a trap. `test-e2e.yml` replaces its Start (`:89-91`), Wait (`:97-108`) and Tear down (`:131-133`) steps with that one call (a charting call, following from Q12). What the trap may delete is N-007; what an aborted prompt exits with is N-008. Neither edit enforces posture in CI (see Out of scope)                                   | grilling | 14/10/2026 | Slice **S-01**                                                                                                     |

---

## Slices

| Slice | Story | Title                  | Nodes                                                | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Flags                                                                                                                                                                                                                                                                                                                                                                    |
| ----- | ----- | ---------------------- | ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| S-01  | —     | The posture guard      | N-003 ✅ · N-004 ✅ · N-006 ✅ · N-007 ⛔ · N-008 ⛔ | The `_lib/` guard reads `DEPLOYMENT_POSTURE` from `.copier-answers.yml` once; `database/reset.sh`, `database/restore.sh` and both `server.sh down --volumes` paths refuse above `development` unless the run names the live posture with `--force-posture=<posture>`; `migrate.sh` prints the posture and the expand-then-contract obligation and proceeds; an unreadable carrier dies at exit 2; the template repo itself (unrendered answers file) runs unimpeded; `development/server.sh down --volumes` asks for confirmation unless `--yes` is passed, and `--yes` never satisfies the guard; an aborted confirmation exits as N-008 settles; `tests/server.sh` is unprompted; `e2e-py.sh --own-stack` starts, waits for and tears down a stack it owns, refuses a running one, and can delete no volume N-007 does not allow; `test-e2e.yml` uses it in place of its Start, Wait and Tear down steps | QA: guard self-test + template-repo case; prompt abort, no-TTY and `--yes` cases; `--own-stack` against a running stack and against stopped dev volumes · Docs: `DEPLOYMENT-POSTURE.md`, `_lib/` pair, `CLI-TOOLING.md`, `GIT-WORKTREES.md`, `development/` and `tests/` pairs · CI: `test-e2e.yml` · ADR: the carrier + override contract, three-test gate at the story |
| S-02  | —     | The seed presence gate | N-005 ✅                                             | Check 4 loops `SEEDED` asserting each seeded file landed; `--self-test` gains a probe that deletes a seeded file and asserts the finding; the header's too-tight claim becomes true for seeded files                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | QA: `shipped-artefacts.sh --self-test` · Docs: the script's own header contract                                                                                                                                                                                                                                                                                          |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. **S-02 is cuttable.** S-01
waits on N-007 and N-008.

---

## Frontier

Opened 14/10/2026 by the `MAP-SENTENCE-RULES` verification pass. Neither blocks the other; one sitting takes both, since both decide how the new destructive paths fail safe.

| Node  | Decision                                                                                                                                                                                                                                                                                                                                            | Type     | Blocked by | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-007 | **What may the `--own-stack` trap delete?** The dev stack has a fixed project name (`docker-compose.dev.yml:7`) and a persistent volume, `postgres_dev_data` (`:18`). "Refuses if one is already up" checks running containers only, so a stopped stack whose volume remains would be reused and then wiped, through compose, past the N-006 prompt | grilling | none       | yes — S-01        |
| N-008 | **What does an aborted confirmation exit with?** `reset.sh:98-102` exits 0 on a refusal and on empty stdin, so a non-interactive caller reads success. This map's own preference is the refuse-loudly idiom (Notes)                                                                                                                                 | grilling | none       | yes — S-01        |

---

## Fog of war

_Empty — the one item (a general answers-file-read sanction) moved to Out of scope when N-003
settled the posture case without sharpening it into a node here._

---

## Out of scope

| Ruled out                                                            | Why                                                                                                                            |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| The PE gate deferrals (`GAPS.md` 31/08/2026)                         | Wait-states blocked on real templates/CSS; retirement owned by `MAP-PROGRESSIVE-ENHANCEMENT` S-02 and the first real-CSS story |
| Guarding `template-update.sh` and the test-teardown `down --volumes` | Already refuse without `--force-*` flags / destructive by design on every run (N-001)                                          |
| Posture enforcement beyond the script layer (Django settings, CI)    | Section 0 binds the model; the claimed entry names the script layer only. Widening it is a new entry, not scope creep here     |
| Folding S-02 into the register-index work                            | The claimed entry forbids it: `MAP-REGISTER-INDEXES` N-003 cites the seed gate as an **input** and must not be its owner       |
| A **general** sanction for scripts reading `.copier-answers.yml`     | N-003 sanctioned the posture read only (01/09/2026); other answers a gate might want are a new charting, not this feature's    |

---

## Session log

| Date       | Node settled          | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Frontier redrawn |
| ---------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 31/08/2026 | N-001 · N-002         | Charted; both research legs dispatched and resolved into the rows above                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 01/09/2026 | N-003 · N-004 · N-005 | N-003 grilled (Sam: 1, 2, 2) — answers-file carrier, per-run posture-named `--force-posture=<posture>`, four hard-refuse + `migrate.sh` warn-only; N-004/N-005 specified into their slice rows; re-measure confirmed every N-001/N-002 claim (one path drift fixed: `template-update.sh` lives under `development/`)                                                                                                                                                                            | [x]              |
| 14/10/2026 | N-006                 | Added resolved from the `MAP-SENTENCE-RULES` grilling (Sam: Q3→2 fold here, Q8→2 dev only, Q12→1 `--own-stack`) and folded into S-01. The verification pass corrected the CI steps `--own-stack` replaces, dropped a false analogy with N-001's test-stack traps, re-triaged the register, and opened N-007 and N-008. Re-measured `development/server.sh:176`, `tests/server.sh:137`, `reset.sh:98-102`, `test-e2e.yml:89-91,97-108,131-133`, `e2e-py.sh:11` and `docker-compose.dev.yml:7,18` | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed — 31/08/2026; **the 14/10/2026 extension awaits Sam**
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **N-003 (blocking) resolved** — 01/09/2026
- [x] N-006 resolved and folded into S-01 — 14/10/2026
- [ ] **N-007 and N-008 (blocking S-01) resolved**
- [x] Every resolved node links to the artefact it became
- [x] Every slice has a flag manifest — `N/A` omitted
- [ ] Index row — awaits `MAP-INDEX.md` (see Notes); joins the `MAP-REGISTER-INDEXES` S-02 backfill

**S-02 may be cut by `workflows/02-story-creation/` now. S-01 waits on N-007, N-008 and the extended destination.**
