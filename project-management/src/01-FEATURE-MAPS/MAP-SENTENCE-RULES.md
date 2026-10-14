# MAP-SENTENCE-RULES — Text a reader acts on gets eight sentence rules, one owner, and a gate on changed lines

**Charted**: 14/10/2026 at `24b932a` · **Charted by**: Sam Bailey · **Workflow**: `01-feature-map`
**Status**: Charting — destination awaiting confirmation; S-01 cuttable, S-02 and S-03 wait on
the frontier
**Frontier open**: 4 · **Blocking open**: 4

> A **low-resolution index**, not a storage vault — every resolved node links to the artefact it
> became. Evidence: `research/ASD-STE100-ADOPTION.md`.
>
> **A departure, named.** A chart settles nothing but research nodes (`CHECKLIST.md:66`; the
> wayfinder anti-pattern _Resolving during a chart session_). N-002 to N-007 were settled
> **before** this map existed, in a `/grill-me` sitting (Q1 to Q14, 14/10/2026). Sam then asked
> for the settled design to be written here (`/wayfinder`, 14/10/2026), so they are recorded as
> resolved. `/grill-me` records nothing, so this map is their only record until each graduates.
> N-008 to N-011 were raised by the verification pass the same day and are left for RESOLVE.

---

## Destination

The eight sentence rules exist once, in the project's own words, in `VERSIONING-AND-DOCS.md`, and
every surface they bind routes there. Text written or edited from now on follows them, a warn-tier
audit checks the lines a change touches, and ASD-STE100 is read and credited, never derived from
and never the rules' name.

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                                                                                                                                |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Writing doctrine (`.claude/skills/global-workflow/`, `how-to/docs/OPERATOR-DOC-CRAFT.md`, `how-to/src/BRAND-VOICE.md`), the Section 6 licence rule, and one docs audit under `code/src/scripts/audits/`                                                                                                                                                              |
| Skills to load           | `doc-writer`, `runbook`, `global-workflow`, `support-articles`, `cicd`                                                                                                                                                                                                                                                                                               |
| Standing preferences     | Route, don't restate (`code/docs/DOCUMENTATION-PAIRING.md`) · a gate is derived from a stated rule and tiers every clause (`code/src/scripts/audits/CLAUDE.md:28-30`) · could-not-look is never clean (`code/docs/GATE-REPORTING.md`) · credit in the same change (`.claude/CLAUDE.md` Section 6) · **fix on edit, never a sweep** (the 14/10/2026 advice, accepted) |
| Umbrella ADRs            | None yet — N-002's licence line takes the three-test ADR gate at S-01's story                                                                                                                                                                                                                                                                                        |
| Register entries triaged | 0 closes · 0 blocks · 7 unrelated — the four dated `GAPS.md` entries and the three items under _Still open, found on the way_, the same seven `MAP-NAVIGATION` re-triaged on 01/09/2026. `DEFERRED.md` holds zero rows. SL-1 to SL-3 take no verdict. The 16/08/2026 sitting table's Q10 and Q15 markers are decision states, not entries                            |
| Index row                | The map index awaits `MAP-INDEX.md`, created by `MAP-REGISTER-INDEXES` S-01; this map joins the backfill population its S-02 sweeps — the shipped `CONTEXT.md` table is not edited (N-001 on `MAP-REGISTER-INDEXES`, 31/08/2026)                                                                                                                                     |
| Cross-map                | **N-006 on `MAP-SCRIPT-GUARDS`** — the `server.sh down --volumes` confirmation and the e2e teardown, grilled in the same sitting (Q3, Q8, Q12) and folded into that map's S-01, because it edits `development/server.sh`, which S-01 already guards                                                                                                                  |

---

## Charting calls — confirm with the destination

Claude's calls, made while writing the grilled design down. **Not Sam's answers**; each is
confirmed or overturned with the destination.

| Call | What                                                                                                                                                                                | Lands in |
| ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| C1   | The eight-rule list and its bind list are the 14/10/2026 advice, accepted without amendment; no Q settled them                                                                      | N-003    |
| C2   | The plainness option applies to English locales only, because copy follows the application locale (`BRAND-VOICE.md:203-204`)                                                        | N-005    |
| C3   | Thresholds: 20 words a step sentence, 25 elsewhere; a backticked token counts as one word                                                                                           | N-006    |
| C4   | The audit reuses `docs-length.sh`'s `--since` convention: lefthook passes `HEAD`, CI the merge-base                                                                                 | N-006    |
| C5   | Inside a fenced block the lead-in is `# Data loss: <what is lost>`, because commands like `CLI-TOOLING.md:46` sit mid-block                                                         | N-007    |
| C6   | "Derive" means **wording**, the line `README.md:223-226` already draws: share-alike and unlicensed sources "are taken as facts and never as wording"                                | N-002    |
| C7   | `OPERATOR-DOC-CRAFT.md:66` becomes the one-line route, since keeping its rule would restate rule 5                                                                                  | N-004    |
| C8   | The owner tags each rule with its tier (`[gate: warn]` or `[judgement]`), as `audits/CLAUDE.md:29-30` requires of a gated guide                                                     | S-02     |
| C9   | Every skill that writes a bound surface routes to the owner: `to-questionnaire`, `gdpr-mechanics`, `qa-tester` and `bugfix` beside the four first named                             | S-02     |
| C10  | `support-articles/SKILL.md:78` is corrected to a register BRAND-VOICE defines                                                                                                       | S-02     |
| C11  | `THIRD-PARTY-NOTICES.md` records the read-not-reproduced position and the five-gram overlap result, because `research/CLAUDE.md` says it records the position for every source read | S-02     |

---

## Register claimed

**Nothing is claimed.** Every open entry was read, and this feature neither retires nor is blocked
by any of them.

| Register | Entry                                                                                                                | Verdict   | Retired by                                                                                                                               |
| -------- | -------------------------------------------------------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| GAPS.md  | 31/08/2026 — the PE gate's markup half cannot see structure / prefix set                                             | unrelated | Half 1 waits on real templates (`MAP-PROGRESSIVE-ENHANCEMENT` S-04); half 2 on that map's S-02 and the first story writing component CSS |
| GAPS.md  | 31/08/2026 — htmx is pinned at major 2, and the v4 migration waits on two named triggers                             | unrelated | Its own charted feature, once both triggers fire                                                                                         |
| GAPS.md  | 01/09/2026 — a RUSTSEC advisory against an unchanged `Cargo.lock` is invisible                                       | unrelated | A cargo-deny leg in `audit-deps.yml`                                                                                                     |
| GAPS.md  | 01/09/2026 — staging and production have no mail backend, so mail is silently discarded                              | unrelated | The story that picks the relay                                                                                                           |
| GAPS.md  | 16/08/2026 sitting, _Still open_ — `COVERAGE.md` flags · the shared `10.0.1.0/24` subnet · `pnpm-update.sh`'s header | unrelated | None claimed here; the header item is a stale claim, not a sentence-rule breach                                                          |

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Type     | Settled    | Became                                                      |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | ----------------------------------------------------------- |
| N-001 | **ASD-STE100 Issue 9 is read and cited, never derived from.** It is all-rights-reserved and free to obtain. Its reproduction right covers eight named classes and does not extend to this template as a redistributor. No document conformance scheme is described, so the house rules may not be called "STE" or claim compliance. The evidence favours readers of difficult procedures, especially non-native ones, not LLM readers or neural MT                                                                                                                                                                             | research | 14/10/2026 | `research/ASD-STE100-ADOPTION.md`; S-02's credit acceptance |
| N-002 | **Section 6 draws one line between wording and facts** (Q10→2, with C6). Permissive sources (MIT, Apache-2.0, CC BY, OGL, CC0) may have their wording adapted, with notice and credit. Share-alike, all-rights-reserved and unlicensed sources give facts and ideas only, credited, never wording. This fixes `.claude/CLAUDE.md:247`, which lists "unlicensed" as permissive. It ships as its own change, ahead of S-02                                                                                                                                                                                                       | grilling | 14/10/2026 | Slice **S-01**                                              |
| N-003 | **The eight rules and what they bind** (C1). The rules: one action per step · condition first · instruction first, reason next · about 20 words a step sentence and 25 elsewhere, as a warning · a warning line before the command it guards · one name for one thing · keep articles and plain verbs in text read cold · one check per box, one result per Then. They bind procedures, rollback, warnings, reproduction and manual-test steps, GDPR procedures, the Client Summary, questionnaires, error text and support articles. They do not bind rationale guides, ADRs, maps, comments, skill descriptions or marketing | grilling | 14/10/2026 | Slice **S-02**                                              |
| N-004 | **One owner, with its own credit** (Q1→1, Q9→3, with C7). A subsection of `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2 owns the rules, and the credit line sits inside it, so it reaches existing projects on `copier update`. The root `README.md` and `.copier/README.md` carry the Influences row, because `copier.yml:43` excludes the root README                                                                                                                                                                                                                                                    | grilling | 14/10/2026 | Slice **S-02**                                              |
| N-005 | **User copy splits** (Q4→3, with C2). Structure is portable, and BRAND-VOICE Section 6 routes to the owner for it. Sentence plainness is a per-project option: the Reader cell (`BRAND-VOICE.md:70`) asks whether readers read cold or in a second language, and first-time setup Step 8 settles it. Which rules count as plainness is N-010                                                                                                                                                                                                                                                                                   | grilling | 14/10/2026 | Slice **S-02**                                              |
| N-006 | **One warn-tier audit on changed lines** (Q2→3, Q5→2, Q6→2, Q14→2, with C3 and C4). Sentence checks cover `STEPS.md` and ordered lists under `## Steps` or `## Rollback` in `how-to/**`; which `STEPS.md` is N-008. The destructive check covers every fenced `bash` block in `how-to/**` (which holds `TEMPLATE-GUIDE/`) and `**/workflows/**`. Compound steps stay `[judgement]`, because finding them needs meaning                                                                                                                                                                                                         | grilling | 14/10/2026 | Slice **S-03**                                              |
| N-007 | **The warning has a fixed, visible lead-in** (Q13→1, with C5): `**Data loss:** <what is lost>` on the line above. There is no capitalised signal word, so the form also suits Claude-facing text                                                                                                                                                                                                                                                                                                                                                                                                                               | grilling | 14/10/2026 | Slices **S-02** and **S-03**                                |

---

## Slices

**Order: S-01, then S-02, then S-03** (Q10→2, Q11→2). S-02 relies on the licence line S-01
draws, and S-03 must be derived from rules that already exist.

| Slice | Story | Title                         | Nodes                                                                      | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Flags                                                                                                                                                                                                                                                              |
| ----- | ----- | ----------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| S-01  | —     | One licence line              | N-001 ✅ · N-002 ✅                                                        | Section 6 states the wording-versus-facts line for each class, and no shipped file states a different one. Every Influences row passes it, except `dictionary-of-ai-coding`, which keeps its open question in `THIRD-PARTY-NOTICES.md` (_Open: `dictionary-of-ai-coding` has no licence_)                                                                                                                                                                                                                                                                            | Docs: `.claude/CLAUDE.md` Section 6, `README.md:223-226`, `.copier/README.md:1445`, `research/CLAUDE.md` licence bullets · ADR: the licence line, three-test gate at the story · QA: `doc-references.sh`, `docs-length.sh`                                         |
| S-02  | —     | The eight rules, owned once   | N-001 ✅ · N-003 ✅ · N-004 ✅ · N-005 ✅ · N-007 ✅ · N-009 ⛔ · N-010 ⛔ | The eight rules exist once, in the project's own words, each with its tier. The owner carries the credit: read, not reproduced; not STE-compliant; not affiliated with or endorsed by ASD. Every skill or guide that writes a bound surface routes to the owner in one line and restates nothing. The Reader option exists and first-time setup asks it. Both Influences tables carry the row, and the read-not-reproduced position and a five-gram overlap result are recorded. No file calls the house rules "STE". Every passage the slice edits passes the rules | Docs: `VERSIONING-AND-DOCS.md`, `OPERATOR-DOC-CRAFT.md`, `BRAND-VOICE.md`, `01-first-time-setup/STEPS.md` Step 8, eight skills (C9), both READMEs, `THIRD-PARTY-NOTICES.md` · QA: `docs-length.sh`, `skill-conformance.sh`, `doc-references.sh`, five-gram overlap |
| S-03  | —     | The changed-lines prose audit | N-006 ✅ · N-007 ✅ · N-008 ⛔ · N-009 ⛔ · N-011 ⛔                       | The audit reads changed lines only and only warns. It flags over-long sentences, semicolons (per N-009), and a `--volumes`, `--yes` or `--force` with no `Data loss` lead-in on the line above. When it parsed nothing in scope it reports "not measured", never clean, and it names the `[judgement]` rules it does not check. Fixtures prove every warning can fire. `audits/CONTEXT.md` carries its rows and true script counts without growing past 298 code lines once its `:8` allowance expires (01/12/2026)                                                  | QA: `--self-test` and fixtures · CI: a new `audit-*.yml` · Docs: `audits/CONTEXT.md` inventory and Dependencies rows and script counts, `lefthook.yml`                                                                                                             |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. **S-01 is cuttable now.**
S-02 waits on N-009 and N-010; S-03 on N-008, N-009 and N-011.

---

## Frontier

Raised by the 14/10/2026 verification pass. None blocks another, so all four are takeable in one
batch: they share a subject, the rules' text and the gate derived from it.

| Node  | Decision                                                                                                                                                                                                                                                                                                   | Type     | Blocked by | Blocking a story? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-008 | **Do workflow `STEPS.md` files outside `how-to/` count as human-read procedures?** Q5→2 leaves open whether the sentence checks cover all 46 `STEPS.md` or only the nine under `how-to/`. The other 37 are routed to Claude by `model:` frontmatter, and Out of scope bans word caps on Claude-facing text | grilling | none       | yes — S-03        |
| N-009 | **Which rule does the semicolon check enforce?** Q6→2 chose the check, but none of the eight rules names semicolons, and a gate needs a stated rule (`audits/CLAUDE.md:28`)                                                                                                                                | grilling | none       | yes — S-02, S-03  |
| N-010 | **Which of the eight rules are plainness, and so per-project?** N-005 does not say. `support-articles/SKILL.md:71` already requires sentences under about 25 words in every project, so a plainness option could weaken a rule that is portable today                                                      | grilling | none       | yes — S-02        |
| N-011 | **May a skill sub-doc own a gated rule?** `audits/CLAUDE.md:28` derives a gate from "a stated rule in a `docs/` guide", and N-004 puts the owner in `.claude/skills/global-workflow/`. `copy-slop.sh` already derives from `how-to/src/BRAND-VOICE.md`, which is not under `docs/` either                  | grilling | none       | yes — S-03        |

**Types:** see `MAP-000-TEMPLATE.md`. Each takes the `/grill-with-docs` pass that records its
answer.

---

## Fog of war

_Empty._

---

## Out of scope

| Ruled out                                                                                                                                      | Why                                                                                                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Adopting ASD-STE100 itself — the dictionary, all 53 rules, US spelling, the contraction ban                                                    | All-rights-reserved, a vocabulary that does not fit developer text, and no conformance scheme to meet (N-001)                                       |
| Naming the house rules "STE", "Simplified Technical English" or anything confusable                                                            | It implies a compliance nobody can claim and an endorsement ASD forbids (N-001)                                                                     |
| A sweep of existing text                                                                                                                       | Fix on edit (the 14/10/2026 advice, accepted); several instructional files already sit in the 270 ratchet band                                      |
| Word caps or capitalised signal words in Claude-facing orientation and rule files (`CLAUDE.md`, `CONTEXT.md`, `SKILL.md`, MCP tool docstrings) | No evidence they help a model reader, and tool-description studies penalise missing content, not length (N-001). Whether `STEPS.md` counts is N-008 |
| Code comments, internal docstrings, `code/docs/` rationale, ADRs, maps, skill descriptions, marketing                                          | Argument or voice, not procedure; the comment rules already cover what matters there (N-003)                                                        |
| Translation as the justification                                                                                                               | No i18n pipeline exists, and neural MT gains little from controlled-language rules (N-001)                                                          |
| Compound-step detection in the audit                                                                                                           | It needs meaning, so it stays `[judgement]`, the split BRAND-VOICE already uses (N-006)                                                             |
| The `server.sh down --volumes` confirmation and the e2e teardown                                                                               | Charted as N-006 on `MAP-SCRIPT-GUARDS` and folded into its S-01 (Q3→2)                                                                             |
| Resolving `dictionary-of-ai-coding`'s licence                                                                                                  | An open question with its own home in `THIRD-PARTY-NOTICES.md`; S-01 records that it fails the line and does not settle it                          |
| A project whose client contract requires STE                                                                                                   | That project obtains the standard and a checker itself; the template supplies neither (N-001)                                                       |

---

## Session log

| Date       | Node settled   | Outcome                                                                                                                                                                                                                                                                   | Frontier redrawn |
| ---------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 14/10/2026 | N-001 to N-007 | Written from a design settled before charting: five read-only research agents, then `/grill-me` in three rounds (Sam: Q1-4 1, 3, 2, 3 · Q5-11 2, 2, 3 (Q7, reopened as Q12), 2, 3, 2, 2 · Q12-14 1, 1, 2). N-001 graduated to its research note; the rest to S-01 to S-03 | [x]              |
| 14/10/2026 | —              | Verification pass, three read-only agents: corrected twelve literals and claims here and in the research note, labelled C1 to C11 as calls, and raised N-008 to N-011                                                                                                     | [x]              |

---

## Gate to stories

- [ ] Destination and out-of-scope bounds confirmed — **awaiting Sam, with C1 to C11**
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it — none claimed; **neither register file edited**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] Every node marked "blocking a story" is resolved — **N-008 to N-011 open**
- [x] Every resolved node links to the artefact it became
- [x] Every slice has a flag manifest — `N/A` omitted
- [ ] Index row — awaits `MAP-INDEX.md` (see Notes); joins the `MAP-REGISTER-INDEXES` S-02 backfill

**S-01 may be cut by `workflows/02-story-creation/` once the destination is confirmed. S-02 and
S-03 wait on the frontier.**
