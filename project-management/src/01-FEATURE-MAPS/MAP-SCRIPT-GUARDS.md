# MAP-SCRIPT-GUARDS — Declared doctrine gains its script-layer enforcement

**Charted**: 31/08/2026 · **Charted by**: Sam Bailey · **Workflow**: `01-feature-map`
**Status**: Resolving
**Frontier open**: 3 · **Blocking open**: 1

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

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Type     | Settled    | Became   |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | -------- |
| N-001 | **The destructive population is five scripts, and two are already guarded by other means.** Unguarded: `database/reset.sh` (DROP at `:107-110`, `--yes` bypasses the prompt), `database/restore.sh` (`:109-122`), `development/server.sh down --volumes` (`:176`), `tests/server.sh down --volumes` (`:137`). Guarded elsewhere: `template-update.sh` already refuses `--apply` without `--force-*` flags (`:253-257`); the three test-teardown `down --volumes` traps destroy test volumes **by design** on every run. `migrate.sh` is non-destructive (run/make/show/check/fake) but is named by the claimed entry — whether posture binds it is N-003's question | research | 31/08/2026 | this row |
| N-002 | **The answers file is the only machine-parseable posture carrier, and reading it was anticipated.** `DEPLOYMENT_POSTURE` is asked at `copier.yml:408-419` with the stated rationale that the answer exists in `.copier-answers.yml` "from day one and a later gate can read it"; the file ships tracked in a generated project (not in `_exclude`) as plain YAML; `template-update.sh:108` already reads `_commit:` from it. In **this** repo the file is the unrendered template (a Jinja expression), so a guard must handle the no-answer case explicitly                                                                                                        | research | 31/08/2026 | this row |

---

## Slices

| Slice | Story | Title                  | Nodes              | Acceptance                                                                                                                                                                                                                                                          | Flags                                                                                                    |
| ----- | ----- | ---------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| S-01  | —     | The posture guard      | N-003 ⛔ · N-004 ○ | Every script N-003 binds refuses to run above `development` posture without the explicit override N-003 shapes; the guard reads the posture once, dies loudly when the carrier is unreadable, and the template repo itself (unrendered answers file) runs unimpeded | QA: guard self-test + template-repo case · Docs: `DEPLOYMENT-POSTURE.md`, `_lib/` pair, `CLI-TOOLING.md` |
| S-02  | —     | The seed presence gate | N-005 ○            | Check 4 loops `SEEDED` asserting each seeded file landed; `--self-test` gains a probe that deletes a seeded file and asserts the finding; the header's too-tight claim becomes true for seeded files                                                                | QA: `shipped-artefacts.sh --self-test` · Docs: the script's own header contract                          |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. S-02 is cuttable once N-004's
sibling question never touches it — N-005 has no open decision above it. S-01 waits on N-003.

---

## Frontier

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Type     | Blocked by | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-003 | **The guard's contract**: is reading `.copier-answers.yml` from a generated project's scripts the sanctioned pattern (per N-002 it was anticipated, and one precedent exists) or does posture need its own carrier; the override's shape (a flag, or `docs-length.sh`'s dated-annotation idiom); and exactly which scripts are bound — the four unguarded destructive ones certainly, `migrate.sh` arguably (the claimed entry names it; Section 0 binds its _procedure_ above `development`) | grilling | none       | yes               |
| N-004 | The `_lib/` posture guard, wired into the scripts N-003 binds                                                                                                                                                                                                                                                                                                                                                                                                                                 | build    | N-003      | no                |
| N-005 | `SEEDED` presence loop beside the `NAMED_SHIPPED` one (`shipped-artefacts.sh:215-218`) plus the self-test probe copied from the check-4 shape (`:277-280`)                                                                                                                                                                                                                                                                                                                                    | build    | none       | no                |

---

## Fog of war

- Whether a generated project's scripts reading the answers file becomes a **general** sanctioned
  pattern beyond the posture (other answers a gate might want) — N-003 settles the posture case
  only; a general rule would want its own charting.

---

## Out of scope

| Ruled out                                                            | Why                                                                                                                            |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| The PE gate deferrals (`GAPS.md` 31/08/2026)                         | Wait-states blocked on real templates/CSS; retirement owned by `MAP-PROGRESSIVE-ENHANCEMENT` S-02 and the first real-CSS story |
| Guarding `template-update.sh` and the test-teardown `down --volumes` | Already refuse without `--force-*` flags / destructive by design on every run (N-001)                                          |
| Posture enforcement beyond the script layer (Django settings, CI)    | Section 0 binds the model; the claimed entry names the script layer only. Widening it is a new entry, not scope creep here     |
| Folding S-02 into the register-index work                            | The claimed entry forbids it: `MAP-REGISTER-INDEXES` N-003 cites the seed gate as an **input** and must not be its owner       |

---

## Session log

| Date       | Node settled  | Outcome                                                                 | Frontier redrawn |
| ---------- | ------------- | ----------------------------------------------------------------------- | ---------------- |
| 31/08/2026 | N-001 · N-002 | Charted; both research legs dispatched and resolved into the rows above | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **N-003 (blocking) resolved**
- [x] Every resolved node links to the artefact it became
- [x] Every slice has a flag manifest — `N/A` omitted
- [ ] Index row — awaits `MAP-INDEX.md` (see Notes); joins the `MAP-REGISTER-INDEXES` S-02 backfill

**S-02 may be cut by `workflows/02-story-creation/` now; S-01 waits on N-003.**
