# HANDOFF — N-037 × N-031 grilled and settled; implementation not started

**Written**: 18/08/2026 · **Branch**: `pm/base-health-map` · **HEAD**: `af03014` · **Pushed**: yes
· **Tree**: NOT clean — see _In-flight_, a parallel session is live in it

## Goal

Resolve `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` one sitting at a time. This
session cut **5.5.0**, settled **N-043**, and then **grilled N-037 × N-031 to an empty frontier**
across seventeen questions. **The design is settled and nothing has been implemented.** The next
session builds it.

Frontier now **21 open · 0 blocking · 38 resolved** — recounted from the tables, `21 + 38 = 59 =
N-059`. Per batch: A 0 · B 5 · D 4 · E 8 · unbatched 4.

## Done

Three commits, all pushed, every lefthook leg green on each.

- **`b4f00db`** `chore(version)` — **5.5.0**. MINOR against `CONTRIBUTING.md:185-205`, syntek-base's
  public API being the template contract. **Settles the previous handoff's open question 1 by
  reading, not judgement**: `lint.sh` rejecting `--file-type css` is a script flag, which that
  declaration puts outside the contract, so it does **not** force a MAJOR.
- **`2c33506`** `docs(pm)` — `TEMPLATE-GUIDE/` **ships** (pinned to `f5fef31`, 14/08, v3.2.0),
  swept all fourteen mentions and found **exactly one** live falsehood in the map's own voice
  (N-012's rejected option (c)). **N-037 re-measured: 87 → 117 sites, 42 → 62 files, and a reading
  it never had — 50 unique paths.**
- **`af03014`** `fix(docs)` — **N-043 settled.** Register corrected and **verified by generating**
  (`uvx copier copy`, 27/27 assertions). Found the guide contradicting itself: `:103` called the
  tree excluded while `:217` excluded it from a token sweep that only runs downstream — **0
  surviving tokens with that exclusion, 95 without**. Two uncharted falsehoods swept up.

**Also shipped outside git:** `v5.4.0` and `v5.5.0` tagged and pushed, and both cut as **GitHub
pre-releases**. `v5.4.0` had never been tagged — 57 log entries against 56 tags. Four-way parity
restored and re-measured at **58/58/58/58**, every `comm -3` empty.

**Verification not to repeat**: the `copier copy` generation and its 27 assertions, the 0-vs-95
token measurement, 795 markdown files lint-clean, `format.sh` clean on all four legs,
`doc-references`/`docs-length`/`docs-pairing`/`copy-emdash`/`conflict-markers` all exit 0, backend
suite 50 unit + 22 integration.

## In-flight

**Nothing of mine is mid-edit. Two things in the tree are not mine.**

- **`project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md` — modified, unstaged, NOT this session's
  work.** Mtime **16:54**, after this session's last commit at ~15:36, so **a parallel session is
  live in this working tree on this branch**. The diff corrects _Out of scope_ row 6 and a gate
  checkbox from _"every map here is gitignored"_ to _"git-tracked but copier-excluded"_ — the same
  class of correction `2c33506` made, and **factually right at HEAD**. **Do not stage, commit or
  revert it.** The map records two sessions on one branch in one afternoon as prior art.
- **`handoffs/HANDOFF-BASE-HEALTH-BATCH-B-18-08-2026.md` — untracked, superseded, never committed.**
  Its work has resumed, so `handoffs/CLAUDE.md` says prune it. Left in place deliberately: deleting
  an uncommitted file is unrecoverable and that is <%DEVELOPER_NAME%>'s call.

## Next

**Get the explicit go-ahead, then build commit 1 of four.** The design summary was presented and
not disputed, but `.claude/skills/grilling/SKILL.md` requires an explicit yes before downstream
work and it was not given — <%DEVELOPER_NAME%> asked for this handoff instead. **Confirm first,
then implement.**

### The settled design — seventeen decisions, do not re-grill

**The rule: a shipped document may cite a path absent here only if it declares which way it
speaks.** Two directions, two mechanisms:

| Direction                               | Mechanism                                       |
| --------------------------------------- | ----------------------------------------------- |
| **A** — absent here, present downstream | Register: `how-to/src/PROJECT-PATHS.md`         |
| **B** — present here, absent downstream | Per-line token: `doc-references: template-only` |

Anything else that does not resolve is a false assertion and is **fixed, not marked**.

- **New rule doc** `code/docs/FORWARD-VOICE.md`; **new register** `how-to/src/PROJECT-PATHS.md`.
  House split, twice precedented (`NEGATIVE-SPACE`→`INVARIANTS`, `PROVIDER-NEUTRALITY`→
  `PLATFORM-PROVIDERS`): rule in `code/docs/` is the same everywhere, register in `how-to/src/`
  is the project's own answer sheet and ships.
- **Register entry = path + what creates it.** An entry that cannot name its creator is a wish.
  Because the creator is a backticked path in a shipped file, `doc-references.sh` **already**
  checks it resolves — the anti-dumping-ground test enforces itself at no cost.
- **Mechanism general, content django-only.** Measured: `project-management/src/**` yields
  **3** non-pattern paths and all three are already handled (seeded / instance-check / pattern),
  so it has ~0 real members. Do not build for it.
- **`doc-references.sh` changes:** register lookup · the `template-only` token · a
  `code/src/django/*` arm at the allowlist `case` (**`:252-258`**, re-anchored 18/08, was
  `:243-249`) · `MACHINE-SPEC.md` into the generated-output arm at **`:268`** · `is_exempt()`'s
  `how-to/src/TEMPLATE-GUIDE/*` arm (**`:88`**) narrowed to `TEMPLATE-GAPS.md` alone · a
  **`--self-test` over the new branches only**.
- **Triage is fix-by-default.** A path enters the register only when its creator can be named.

### The four commits, in order

1. **N-042** — `MACHINE-SPEC.md` joins the generated-output arm. Own commit so a Batch B row closes
   on its own evidence.
2. **The mechanism** — both new documents, the gate changes, the `--self-test`.
3. **The sweep** — the gate's own findings only. Direction A: ~50 unique paths judged. Direction B:
   whatever narrowing `is_exempt()` reddens. **Measure before editing, not after.**
4. **The map** — N-037 and N-031 to _Resolved decisions_, recount from the tables, session log,
   residue charted.

**Stop and chart rather than run past the boundary** if commit 3 opens wider than expected: land
1 and 2, chart the remainder.

### Chart, do not do

- **`--self-test` over the gate's two existing checks**, including the fresh-checkout behaviour
  that produced N-042.
- **The `copier.yml` self-citation sweep** — 32 shipped files. The rule covers it; the edits are a
  separate change.
- **`.github/workflows/audit-doc-references.yml:19`** asserts it is _"not a required status
  check"_. **Measured false** — `Citations resolve` is one of ruleset `20221742`'s 20 required
  contexts. Found this session, uncharted, outside both nodes' scope.

## Next skills

`doc-writer` + `scaffold` for the new rule/register pair and its `REFERENCES.md` rows · `cicd` for
the `doc-references.sh` and self-test work · `code-reviewer` for an independent pass on commit 3's
per-path judgements — **no skill reviews its own work**. Roster: `.claude/skills/CONTEXT.md`.

## Standing duties this map imposes

- **Read the seven sibling maps before opening any node.** Discharged three times; found something
  twice, nothing on the third (N-043).
- **Re-verify before acting, including a node's own facts.** N-043's own `_exclude` anchors were
  **wrong** — `:29-250` with **82** entries, not `:29-197` with 58; `866d59d` drifted every
  pre-17/08 anchor by ~53.
- **Recount from the tables, never from prose.** `open + resolved = highest node number`.
- **The completeness critic finds what the finders cannot** — both of N-043's uncharted falsehoods
  came from sweeping the whole register rather than its charted bullets.
- **New this session:** a claim measured once is not measured forever. N-040's four-way parity was
  true when written and false one commit later, and nothing was watching.

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-BASE-HEALTH.md` — N-043 in _Resolved decisions_, N-037's
  growth table, N-031's row with N-043 struck, two 18/08 session-log rows
- `code/docs/GATE-REPORTING.md` — the sibling rule this one sits beside
- `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` — the corrected register
- `code/src/scripts/audits/doc-references.sh` — the gate every remaining commit edits
- `CONTRIBUTING.md` Section _syntek-base's public API_ — the increment rules
- Commits `b4f00db` · `2c33506` · `af03014` · tags `v5.4.0` `v5.5.0`

## Open questions

1. **The explicit go-ahead on the settled design** — asked for and not yet given. First action.
2. **Prune `HANDOFF-BASE-HEALTH-BATCH-B-18-08-2026.md`?** Untracked and superseded; unrecoverable
   if deleted.
