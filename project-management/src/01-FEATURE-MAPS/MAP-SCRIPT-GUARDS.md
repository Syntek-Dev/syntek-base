# MAP-SCRIPT-GUARDS — Declared doctrine gains its script-layer enforcement

**Charted**: 31/08/2026 · **Charted by**: Sam Bailey · **Workflow**: `01-feature-map`
**Status**: Fully charted — frontier and fog empty; S-01 and S-02 await `02-story-creation`
**Frontier open**: 0 · **Blocking open**: 0

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

---

## Notes

| Field                    | Value                                                                                                                                                                                                                            |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Shell-script guards: `code/src/scripts/_lib/` + `.github/scripts/`                                                                                                                                                               |
| Skills to load           | `cicd`, `security`, `global-workflow`                                                                                                                                                                                            |
| Standing preferences     | The refuse-loudly idiom — read config once, die at exit 2 rather than degrade (`audits/doc-references.sh:340-352`, `:266-268`); the house `--self-test` + `probe()` pattern all six `.github/scripts/` gates carry               |
| Umbrella ADRs            | None yet — N-003's outcome takes the three-test ADR gate at its story                                                                                                                                                            |
| Register entries triaged | 2 closes · 0 blocks · 1 unrelated (`DEFERRED.md` holds zero rows)                                                                                                                                                                |
| Index row                | The map index awaits `MAP-INDEX.md`, created by `MAP-REGISTER-INDEXES` S-01; this map joins the backfill population its S-02 sweeps — the shipped `CONTEXT.md` table is not edited (N-001 on `MAP-REGISTER-INDEXES`, 31/08/2026) |

---

## Register claimed

**This is a claim, not a close.** Closing belongs to `workflows/22-implementation-documentation/`,
against shipped code. The two claimed entries were removed from `GAPS.md` on charting (13/08/2026
precedent — one working copy); their full prose is in git history and their substance in the
nodes below.

| Register | Entry                                                                            | Verdict   | Retired by                                                                                                                                                                                                     |
| -------- | -------------------------------------------------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GAPS.md  | 31/08/2026 — the deployment posture binds Claude, but no script reads it         | closes    | Slice **S-01**                                                                                                                                                                                                 |
| GAPS.md  | 31/08/2026 — a seed that never arrives is silent; only the negated files checked | closes    | Slice **S-02**                                                                                                                                                                                                 |
| GAPS.md  | 31/08/2026 — the PE gate's markup half cannot see structure / prefix set         | unrelated | Not this feature's to claim: both halves are wait-states blocked on real templates/CSS existing, and their retirement is owned by `MAP-PROGRESSIVE-ENHANCEMENT` S-02 and the first story writing component CSS |

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Type     | Settled    | Became                                                                                                             |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ------------------------------------------------------------------------------------------------------------------ |
| N-001 | **Four destructive scripts are unguarded; two further candidates are already guarded by other means.** Unguarded: `database/reset.sh` (DROP at `:107-110`, `--yes` bypasses the prompt), `database/restore.sh` (`:109-122`), `development/server.sh down --volumes` (`:176`), `tests/server.sh down --volumes` (`:137`). Guarded elsewhere: `development/template-update.sh` already refuses `--apply` without `--force-*` flags (`:253-262`); the three test-teardown `down --volumes` traps destroy test volumes **by design** on every run. `migrate.sh` is non-destructive (run/make/show/check/fake) but is named by the claimed entry — whether posture binds it is N-003's question                                                                                                                                                         | research | 31/08/2026 | this row                                                                                                           |
| N-002 | **The answers file is the only machine-parseable posture carrier, and reading it was anticipated.** `DEPLOYMENT_POSTURE` is asked at `copier.yml:408-419` with the stated rationale that the answer exists in `.copier-answers.yml` "from day one and a later gate can read it"; the file ships tracked in a generated project (not in `_exclude`) as plain YAML; `development/template-update.sh:108` already reads `_commit:` from it. In **this** repo the file is the unrendered template (a Jinja expression), so a guard must handle the no-answer case explicitly                                                                                                                                                                                                                                                                           | research | 31/08/2026 | this row                                                                                                           |
| N-003 | **The answers file is the carrier; the override is per-run and posture-named; four scripts hard-refuse, `migrate.sh` warns.** The guard reads `DEPLOYMENT_POSTURE` from `.copier-answers.yml` directly — the anticipated read (N-002), no second carrier. The override is `--force-posture=<posture>` and must name the **current** posture, so an override pasted from history dies when the posture has since risen (the house `--force-*` idiom of `development/template-update.sh:253-262`; the dated-annotation idiom rejected — a destructive run is a one-shot act, not a standing allowance). Bound: the four N-001 unguarded scripts hard-refuse above `development`; `migrate.sh` prints the posture and the expand-then-contract obligation, then proceeds — no override needed. Sanctions the posture read **only** (see Out of scope) | grilling | 01/09/2026 | Slice **S-01** — acceptance; the carrier + override contract takes the three-test ADR gate at S-01's story (Notes) |
| N-004 | **The `_lib/` posture guard, specified into S-01** — deliverable (a `_lib/` helper wired into the four bound scripts plus the `migrate.sh` warn) and acceptance written into the slice row; the story builds it, never this map                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | build    | 01/09/2026 | Slice **S-01**                                                                                                     |
| N-005 | **The `SEEDED` presence loop and its probe, specified into S-02** — deliverable and acceptance were complete in the slice row at charting (`shipped-artefacts.sh:215-224` check-4 shape, probe shape `:277-280`); no open decision stood above it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | build    | 01/09/2026 | Slice **S-02**                                                                                                     |

---

## Slices

| Slice | Story | Title                  | Nodes               | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Flags                                                                                                                                                                         |
| ----- | ----- | ---------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | The posture guard      | N-003 ✅ · N-004 ✅ | The `_lib/` guard reads `DEPLOYMENT_POSTURE` from `.copier-answers.yml` once; `database/reset.sh`, `database/restore.sh` and both `server.sh down --volumes` paths refuse above `development` unless the run names the live posture with `--force-posture=<posture>`; `migrate.sh` prints the posture and the expand-then-contract obligation and proceeds; an unreadable carrier dies at exit 2; the template repo itself (unrendered answers file) runs unimpeded | QA: guard self-test + template-repo case · Docs: `DEPLOYMENT-POSTURE.md`, `_lib/` pair, `CLI-TOOLING.md` · ADR: the carrier + override contract, three-test gate at the story |
| S-02  | —     | The seed presence gate | N-005 ✅            | Check 4 loops `SEEDED` asserting each seeded file landed; `--self-test` gains a probe that deletes a seeded file and asserts the finding; the header's too-tight claim becomes true for seeded files                                                                                                                                                                                                                                                                | QA: `shipped-artefacts.sh --self-test` · Docs: the script's own header contract                                                                                               |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. Both slices are cuttable —
every node above them is resolved.

---

## Frontier

_Empty — every decision resolved (01/09/2026). The route to the destination is fully charted._

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

| Date       | Node settled          | Outcome                                                                                                                                                                                                                                                                                                              | Frontier redrawn |
| ---------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 31/08/2026 | N-001 · N-002         | Charted; both research legs dispatched and resolved into the rows above                                                                                                                                                                                                                                              | [x]              |
| 01/09/2026 | N-003 · N-004 · N-005 | N-003 grilled (Sam: 1, 2, 2) — answers-file carrier, per-run posture-named `--force-posture=<posture>`, four hard-refuse + `migrate.sh` warn-only; N-004/N-005 specified into their slice rows; re-measure confirmed every N-001/N-002 claim (one path drift fixed: `template-update.sh` lives under `development/`) | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **N-003 (blocking) resolved** — 01/09/2026
- [x] Every resolved node links to the artefact it became
- [x] Every slice has a flag manifest — `N/A` omitted
- [ ] Index row — awaits `MAP-INDEX.md` (see Notes); joins the `MAP-REGISTER-INDEXES` S-02 backfill

**Both slices may be cut by `workflows/02-story-creation/` now — the frontier is empty.**
