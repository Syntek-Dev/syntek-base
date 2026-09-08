# STORY-PLAN-US006 — The destructive dev scripts read the deployment posture, and refuse to run above development

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 08/09/2026                         |
| Branch | `us006/posture-guard`              |
| Sprint | SPRINT-04 · Wave 1 · build order 2 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

<!-- BORN WITH ITS PREFIX, 08/09/2026. The number `07-` was reserved for this story that morning,
     when the six plans in this folder were renamed by `git mv` to
     `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`; the reservation is recorded in
     `../02-STORIES/US006.md` (its STORY-PLAN NUMBER RESERVED comment) and as a no-file row in
     `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` -> _Story Plans — the code master_. The prefix is
     the story's position in the settled build order across the WHOLE backlog — US007, US001,
     US002, US003, US004, US005, US006 — not its sprint and not a per-sprint counter, so US006 is
     seventh and last, closing SPRINT-04 behind US005. It is RENUMBERED whenever build order
     changes, which is the OPPOSITE of the sibling rule for the sprint plans: a sprint plan
     carries two numbers and a mismatch between them is information, while a story plan carries
     one, so its prefix must track build order or it says nothing. `./CLAUDE.md` owns the rule.
     The descriptor `POSTURE-GUARD` matches the story's QA plan, as every existing pair does.
     Wave 1 is the story's position in its map's cutting order — slice `S-01` of
     `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`, the first cut — and does not move with the
     sprint; build order 2 is second of {US005, US006}, the order
     `../03-SPRINTS/SPRINT-04.md` settled on 07/09/2026. -->

Implements `../15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` (the guard
reads `DEPLOYMENT_POSTURE` from `.copier-answers.yml` once per invocation and fails **closed** on
every state but two — a rendered carrier naming `development`, or a template checkout proven by
`copier.yml` at the root, tested only after the carrier holds no legal posture) and
`../15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md` (the override is
`--force-posture <posture>`, space-separated, naming the posture the project is at now, buying
nothing else, and a refusal exits `4`), under
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (a red `doc-references.sh`
is read as a diff against a recorded baseline until US004 retires the regime).

> **`Open` is literal, and it is not the `Blocked` next door.** `../17-STORY-PLANS/CLAUDE.md`
> makes any value other than `Blocked` an assertion that the blockers are cleared, and this story
> has none to clear: its map records `Frontier open: 0 · Blocking open: 0`, it shares no file with
> any story in the backlog, and its one cross-sprint contingency — which reading of the citation
> gate applies — names both branches and blocks on neither. What stands between this plan and the
> first edit is a process gate every story here shares, not a story: the `us###/` branch is cut
> from `main` once `pm/story-creation` lands (`../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` ->
> _Branch Naming Reference_). `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`
> reads `Blocked` because its target directory exists in no branch; that is a different fact and
> the two values are not drift from each other. The sprint plan says the same: "US006's plan, when
> written, has no upstream and will not carry `Blocked` unless something changes."

> **Source authority.** Where this plan and `../02-STORIES/US006.md` differ on **what must be
> true**, the story wins — its bound-set table and its enumerated proof-case list are stated once
> there and every count here is derived from them. Where the story and
> `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` Section 7 differ,
> the story is the corrected record (7.5, 7.6 and 7.7 amended and 7.12 added at `11-qa-checks`,
> 05/09/2026) and the assessment is the one to update. Where this plan and the sprint plan differ
> on sprint facts, `../03-SPRINTS/SPRINT-04.md` wins over both. On how a gate's result is reported,
> `code/docs/GATE-REPORTING.md` wins over everything here. **The two security artefacts read
> `Reviewed`, not `Signed off`** — quoted as found, and not upgraded; the record treats the gate as
> closed on 05/09/2026 with 0 CRITICAL and 0 HIGH.

**No Table of Contents, and the omission is house practice rather than a divergence.** The template
marks the section optional — keep for large multi-phase plans, drop for small single-layer ones —
and this plan is five phases long; but none of the five sibling plans in this folder, `02-` to
`06-`, carries one (measured 08/09/2026), so this plan follows the folder rather than inventing a
difference the next reader would have to explain. Recorded at the Step 9 review, 08/09/2026.

---

## Problem Statement

**`.claude/CLAUDE.md` Section 0 is the strictest rule set in this repository, and the script layer
enforces none of it.** Every sharpened bullet beyond `development` — no destructive migration and a
deploy in one change, nothing dropped without a named recovery path, never a fixture load against a
live environment — rests on the model reading the section and complying.
`how-to/src/DEPLOYMENT-POSTURE.md` says so in as many words about `code/src/scripts/database/reset.sh`:
a rule the model is bound to, "not yet a guard the script itself enforces", citing a `GAPS.md` entry
that was removed when the map was charted and is already dead.

**The scripts that do the damage are hard-wired to local stacks and read nothing about where the
project is deployed.** `database/reset.sh` drops the database, `database/restore.sh` overwrites it,
`database/seed-dev.sh` loads fixtures over it — and advertises itself, in its own header, as being
for "dev and staging environments" — and `development/server.sh` and `tests/server.sh` each destroy
volumes on `down --volumes`. One committed caller ships into every generated project:
`.github/workflows/test-e2e.yml` tears the stack down with `|| true`, which would hide a refusal
completely.

**There is exactly one machine-parseable carrier of the posture, and reading it naively disarms
the guard in exactly the project it exists for.** `copier.yml` asks `DEPLOYMENT_POSTURE` with the
stated rationale that a later gate can read it, and `.copier-answers.yml` ships tracked. But in
this template the answers file holds seven comment lines and one unrendered expression, so a grep
for the key exits 1 — byte-for-byte the observable of a generated project whose key a `copier update`
merge has lost. A guard that defaults the unreadable case to `development` is weakest where the
blast radius is largest. That is the problem the carrier ADR settles, and this plan builds to it.

**What this story delivers.** One sourced helper in `code/src/scripts/_lib/` with a two-mode entry
point; six callers wired — five refusing above `development` unless the run names the live posture,
one warning at every posture and proceeding; the override forwarded across the one shell-out; the
CI teardown given an explicit override and its `|| true` dropped; a `--self-test` on the one
non-destructive caller proving twenty-one enumerated cases with the stack down; the `_lib/` pair,
the posture register, the CLI guide, one script header and five call-site documents corrected; and
the map's one surviving divergence re-cut. **Out of scope, and owned elsewhere** (mirrored in
_Deferred Items_): posture enforcement inside Django settings or CI itself; a general sanction for
scripts reading the answers file; the seed presence gate (`S-02` on the same map); CLI-guide
entries for `restore.sh` and `tests/server.sh` (`../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`
slice `S-03`).

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                                                          |
| ----------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`. No model, no migration, no RLS policy                                                                                                               |
| Service layer                 | —         | `Backend: N/A`. No Python is added or edited                                                                                                                   |
| Django Ninja API              | —         | `API: N/A`. No router, endpoint or Schema; no MCP tool                                                                                                         |
| Frontend (templates)          | —         | `Frontend: N/A`. No view, template, component or CSS                                                                                                           |
| Infrastructure / DevOps       | ✓         | **The whole story.** A `_lib/` helper, six shell scripts, one CI workflow line, and the documentation that describes them                                      |
| GDPR / PII                    | —         | `GDPR: N/A`. The guard reads one key from the answers file, prints the posture, and prints nothing else from it (TM-15) — a disclosure control, not a PII path |
| SEO / discoverability         | —         | `SEO: N/A`. No public page and no route in `apps.marketing`; nothing for `build_seo()` to head and nothing for the per-page checklist to gate                  |

<!-- 08/09/2026, Step 9 review (L3): the SEO row was added. _Documentation Write-Ups_ says each of
     GDPR, SEO, API and Logging has "its reason under the matching section above"; GDPR, API and
     Logging did, SEO did not — it was named only in the "Not applicable, and why" list below,
     which gives no per-flag reason. The row is the reason. -->

**This story ships shell, not Django.** The template's per-layer structure is not forced onto it:
the four layer sections are dropped under _Approach_ with their reason, and the plan is organised
around what the story actually builds — the helper's contract, the phases that wire it, and how
each of the twenty-one proof cases is proved.

## Reference Documents (code/docs gate map)

| Concern                           | Document                                                                                           | What it binds here                                                                                                                                                                                                                                                                                                                    |
| --------------------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The rule the guard enforces       | `.claude/CLAUDE.md` Section 0                                                                      | The posture table and the sharpened bullets; the guard is the first thing below the model's own compliance that enforces any of it                                                                                                                                                                                                    |
| The per-surface posture register  | `how-to/src/DEPLOYMENT-POSTURE.md`                                                                 | The sentence this story makes false and rewrites; the `seed-dev.sh` call site it also amends. **Carries no repair procedure**, so no refusal points at it                                                                                                                                                                             |
| The helper library's own rules    | `code/src/scripts/_lib/CLAUDE.md` · `code/src/scripts/_lib/CONTEXT.md`                             | Sourced never executed, no `main`-style entry point, functions not top-level statements; the second enforcer of a rule belongs here; both halves updated                                                                                                                                                                              |
| The conflict-marker scan          | `code/src/scripts/_lib/conflict-markers.sh`                                                        | Sourced for the conflict-marked carrier state (TM-08) — never reproduced. It returns 0 always and signals on stdout, so the guard reads its output                                                                                                                                                                                    |
| Reporting a gate's result         | `code/docs/GATE-REPORTING.md`                                                                      | Every `N/A` below carries its reason; ShellCheck is recorded as run or not run, never as a `lint.sh` pass; the security zero is never "the gate passed"                                                                                                                                                                               |
| Length limit and the ratchet      | `code/docs/DOCUMENTATION-LENGTH.md`                                                                | `code/src/scripts/audits/CONTEXT.md` sits at 298 of 300 code lines and this story may not grow it — the proof lives in `migrate.sh` for that reason                                                                                                                                                                                   |
| Forward-looking claims            | `code/docs/FORWARD-VOICE.md`                                                                       | The helper, the two test records and the four worktree files are forward references — written in quotes here, never marked `template-only`                                                                                                                                                                                            |
| Testing and the one floor         | `code/docs/TESTING.md` · `code/docs/testing/COVERAGE.md`                                           | 75% line and branch, 90% auth — one floor, and it has no Python path to measure here; the proof is the `--self-test`                                                                                                                                                                                                                  |
| The scripts' exit-code convention | The six scripts' own `Exit codes:` header lines · `code/docs/GATE-REPORTING.md` Section 3          | Every header reserves 1 for a command that failed and 2 for a script error, and the syntax scripts take 3 for could-not-run; a correct command refused on policy is none of them, which is why `4` is new. `code/docs/MANAGEMENT-COMMANDS.md` is the Django command surface and reserves only 75 — a sibling convention, not this one |
| What the code must never allow    | `code/docs/NEGATIVE-SPACE.md`                                                                      | The guard clause shape — a refusal is a named enforcement point with one home, never an `assert`                                                                                                                                                                                                                                      |
| Security doctrine                 | `code/docs/SECURITY.md`                                                                            | The A01 framing the threat model uses: the posture **is** the authorisation input                                                                                                                                                                                                                                                     |
| Worktree isolation                | `how-to/docs/GIT-WORKTREES.md` · `code/src/docker/CONTEXT.md` · `code/src/docker/nginx/CONTEXT.md` | The `127.0.0.<story>` loopback rule, the two compose-override examples, and the measured absence of per-story Nginx variants                                                                                                                                                                                                          |
| Story                             | `../02-STORIES/US006.md`                                                                           | Fourteen scenarios, Security 7.1 to 7.12, the bound-set table and the twenty-one-case proof list — the acceptance this plan implements                                                                                                                                                                                                |
| Threat model                      | `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md`                    | Eighteen threats over six trust boundaries; Section 3a's promotion triggers. Status `Reviewed`                                                                                                                                                                                                                                        |
| Security assessment               | `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md`                       | The OWASP and NIST baseline; **Section 7's constraints — carried in below, not re-derived**. Status `Reviewed`                                                                                                                                                                                                                        |
| QA                                | `../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md`                                                 | Twenty-two resolved AC-gaps, the HP/ES/EC scenario tables, Section 7's measured baselines. Status `Signed off`                                                                                                                                                                                                                        |
| Sprint plan                       | `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md`                                                          | Build order, the `Must` tier, the phase assignment, the six gate-honesty rules. Written 08/09/2026; the record wins where they disagree                                                                                                                                                                                               |
| Sprint record                     | `../03-SPRINTS/SPRINT-04.md`                                                                       | 5 + 8 = 13 / 11 SP at grace, taken deliberately 07/09/2026, all-`Must`, and **CLOSED** to further admission — the record's own `**Status:**` reads `Planned`                                                                                                                                                                          |
| Feature map                       | `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`                                                          | Slice `S-01`, nodes `N-003` and `N-004`; the one surviving `S-01` edit and the _Register claimed_ posture row this story discharges                                                                                                                                                                                                   |

<!-- 08/09/2026, Step 9 review (L4): the Sprint record cell read "5 + 8 = 13 / 11 SP at grace,
     taken deliberately 07/09/2026, all-`Must`, **CLOSED**". Unqualified, "CLOSED" reads as a
     claim the sprint is closed; the record qualifies it as "**CLOSED** to further admission"
     and its `**Status:**` is `Planned`. Matched to the record's wording. -->

**Not applicable, and why:** `../04-DATABASE/`, `../05-USER-FLOW/`, `../06-BRAND-GUIDE/`,
`../07-COMPONENTS/`, `../08-WIREFRAMES/`, `../09-GDPR/`, `../12-SEO/`, `../13-API-DESIGN/`,
`../14-LOGGING/` — the story's corresponding flags all read `N/A`, and each is recorded here with
its reason rather than omitted. It ships a bash helper, six shell callers, one workflow line and
Markdown: no model, no screen, no personal-data path, no public page, no Django Ninja surface, no
log line. `../10-SECURITY/` is **live** — the story ships a security control, and the control is
threat-modelled against itself. The cross-layer guides that gate this plan are
`project-management/docs/SECURITY-GUIDE.md`, `project-management/docs/QA-GUIDE.md`,
`project-management/docs/GIT-GUIDE.md` and `project-management/docs/VERSIONING-GUIDE.md`; the SEO
checklist and the GDPR guide have nothing to gate.

## Architecture Decision

**The carrier is `.copier-answers.yml`, read once per invocation, and every state but two fails
closed.** That is the carrier ADR, and its deciding factor is that **an absent answer and a damaged
answers file are the same observable**: any design that infers the template from what is missing
mistakes a broken deployed project for the template. So the template is proven positively — by
`copier.yml` at the repository root, a file no generated project has — and the proof is **ordered
and bounded**: the carrier is read first, a legal posture beats a present `copier.yml`, and the
exemption is reachable only from a carrier holding no legal posture (TM-05). Option A, defaulting
the unreadable case to `development`, is rejected outright as the only option whose failure mode is
permitting. No state defaults to `development`.

**The override names the live posture, and buys nothing else.** That is the override ADR, and its
deciding factor is **expiry**: `--force-posture <posture>` must equal the posture the carrier
currently reports, so an invocation pasted from history, or committed into the CI workflow, dies
the day the posture rises. Three rules follow. It does not buy silence — `--yes` is inert above
`development` and the confirmation prompt still runs. It is the override, not the terminal, that
carries the authorisation. And it is **not honoured where no legal posture can be read**: in the
five damaged states and the unrecognised-value state there is no live posture to name, and a
validated `--force-posture development` would otherwise permit a destructive run on a project at
`production` — the control at its weakest in exactly the state a `copier update` merge produces
(TM-08, AC-GAP-4). The recovery path there is repairing the carrier, and the refusal says so.

**A refusal exits `4`, and the code is new for this tree.** The house reserves `1` for a command
that failed and `2` for a script error — every one of the six scripts' own `Exit codes:` header
lines says so, and the override ADR in as many words — and `code/docs/GATE-REPORTING.md` gives
the syntax scripts `3` for could-not-run. A correct command refused on policy is none of those.
The map charted `2` against a single failure state; the fail-closed set is **eight** — the
override ADR's dated erratum corrects its own "seven", the unrecognised carrier value having been
omitted — and every one of them is a policy refusal.

**What is fixed by prior decisions, and what this plan is free to choose.** Fixed: the carrier and
its read order, the eight refusing states, the override's spelling and semantics, exit `4`, the
helper's home in `_lib/` and its return contract (0 permit, 4 refuse, refusal on stderr, never
`exit`), the bound set (six scripts, five refusing paths), the proof's home in
`database/migrate.sh --self-test` and its dispatch ahead of that script's command validator and
container check, the fixture seam (the repository root as the entry point's first positional
argument, never an environment variable), and every constraint in Security 7.1 to 7.12. Free, and
settled under _Key Decisions_: the shape of the entry point's arguments, where the prompt-path
refusal fires, how the script-level cases are proved with the stack down, and what the committed CI
literal is.

**The helper is a new return contract for `_lib/`, stated rather than inherited.** Only
`env-file.sh` and `wizard.sh` return meaningful codes today; `conflict-markers.sh` and
`frontmatter-skills.sh` each document always returning 0 and signalling on stdout, and
`worktree-detect.sh` defines no function at all. The story says so (AC-GAP-9), and
`code/src/scripts/_lib/CLAUDE.md` gains the contract in the same change so the folder's rules
describe the helper that now lives there.

## Approach

### Not applicable — Database, Service Layer, API, Frontend

This story adds no model, no Python, no template and no component. The four layer sections the
template carries are dropped because the story touches none of them, not to dodge a gate; the
sprint plan records the same three `N/A` phases with their reasons.

### Phase plan — five phases, each red before green

| Phase | Deliverable                                                                                                                                                                                                                           | Blocked by          |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| P0    | The baselines, captured **before any edit** — the citation gate over every file this story edits, with its index state; the length gate's figure for the one file this story must not grow; ShellCheck's presence probed and recorded | The branch existing |
| P1    | The proof harness and the helper — `migrate.sh --self-test` dispatched at entry, the fixture tree under a `trap`, the helper-driven cases red, then the helper written to green them                                                  | P0                  |
| P2    | The six callers wired — five refusing paths and one warn, `--force-posture` parsed and forwarded, `--yes` inert, exit `4` declared twelve times, the presence assertions and the structural cases green                               | P1                  |
| P3    | The CI caller — the teardown step's explicit override, its `\|\| true` dropped, <%DEVELOPER_NAME%> named as the literal's owner and the commit that raises the carrier as its trigger, both written beside it                         | P2                  |
| P4    | The documentation — the posture register, the `_lib/` pair, the CLI guide, the `seed-dev.sh` header, the five call-site documents, the map's one edit and its register row, the assessment's Section 7                                | P2                  |
| —     | The two test records and the register reconciliation — **`22-implementation-documentation`'s**, not this story's to write                                                                                                             | P1 to P4            |

<!-- 08/09/2026, Step 9 review (L1): the P3 cell read "the owner and trigger written beside the
     literal" — the obligation without the identity. Story 7.10, as amended at gate 11, names
     <%DEVELOPER_NAME%> as the owner and the commit that raises the carrier as the trigger; both
     restored here, in the P3 paragraph below and in the 7.10 row under _Security_. -->

P3 and P4 are independent of each other; both wait on P2 and nothing else. Every phase has a named
deliverable and is testable on its own: P1 by the helper-driven cases, P2 by the structural cases
and the manual walk, P3 by reading the workflow and running the template's own teardown, P4 by the
three documentation gates and a cold read.

**P0 — the baselines, and why they come first.** Three figures, each recorded with the state it
was measured in, because a baseline without its state is not a baseline (the QA plan's Section 7
measured a 50-finding swing on this tree between two honest runs an hour apart):

- `code/src/scripts/audits/doc-references.sh` over **every** file this story edits — not
  `../02-STORIES/US006.md` alone — in the index state the closing run will use, with `HEAD` and the tree state
  beside the figure (AC-GAP-15). Whether this is a baseline for a diff or a confirmation of a plain
  pass depends on US004; _The citation gate, as it stands for this story_ names both branches.
- `code/src/scripts/audits/docs-length.sh` — `code/src/scripts/audits/CONTEXT.md` at **298 code
  lines as that gate measures them**, never `wc -l` (357). This story leaves the file unchanged;
  the figure is taken so the close can prove it.
- ShellCheck — whether the host carries it. No project script runs it (`lint.sh`'s legs are ruff,
  markdownlint-cli2, ESLint and clippy per `code/src/scripts/syntax/CONTEXT.md`), so the story's
  own expectation is met by hand or recorded as not run, and P0 is where the answer is found rather
  than at close.

**P1 — the harness first, then the helper, in that order.** `code/workflows/02-tdd-cycle/` is the
inner loop and the subject does not exist yet, so the red state is the harness asserting verdicts
the helper cannot yet give. Two things are load-bearing here and both are correctness properties
rather than style:

- **The `--self-test` arm is dispatched at entry** — ahead of the command validator that `die`s
  at exit 2 on anything outside `run|make|show|check|fake|fake-initial`, and ahead of the
  `container_running` check that follows the flag loop — and it invokes no `docker`. Put anywhere
  else, the proof of a guard built for the stack-down case needs a running stack (AC-GAP-5).
- **The fixture root is the entry point's first positional argument**, defaulting to the
  `BASH_SOURCE`-derived value, so the self-test drives the identical read path over a fixture
  tree under a temporary directory. Never an environment variable: 7.1 bans one, and a test seam
  that reuses the banned channel is the control's own bypass in a test hat (AC-GAP-12).

The helper is then written to the contract in _The helper's contract_ below until every
helper-driven case is green. The fixture set writes nothing outside its temporary directory and
carries a `trap` that removes it on every exit path.

**P2 — the six callers.** Each caller sources the helper, parses `--force-posture <posture>`
space-separated as every value flag under `code/src/scripts/**` already is, branches on the
returned status explicitly and terminates on a refusal, and declares exit `4` in its header
comment and its usage heredoc — twelve lines across six files. Per script:

| Script                                   | Mode   | Guard call sits                                                                                                           | Also                                                                                                                        |
| ---------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/database/reset.sh`     | refuse | Above its container preflight — the posture refusal, not a container-not-running error, is what the operator sees         | `--yes` inert above `development`; the empty-read path of its prompt exits `4` with the guard prefix, never `0`             |
| `code/src/scripts/database/restore.sh`   | refuse | Same                                                                                                                      | Same                                                                                                                        |
| `code/src/scripts/database/seed-dev.sh`  | refuse | Before its first destructive command                                                                                      | Parses `--force-posture` **ahead of** its unknown-option `die`, so a forwarded flag is an override and not a script error   |
| `code/src/scripts/development/server.sh` | refuse | On the `down --volumes` path **above the env-file check**, and inside the `up` case's `--seed` branch — never at its head | Forwards `--force-posture <posture>` verbatim across the shell-out to `seed-dev.sh`; the flag is global and inert elsewhere |
| `code/src/scripts/tests/server.sh`       | refuse | On the `down --volumes` path, above the env-file check                                                                    | Flag global and inert elsewhere                                                                                             |
| `code/src/scripts/database/migrate.sh`   | warn   | **At entry, before argument dispatch** — the one script in which "before the first destructive command" would be vacuous  | Hosts the `--self-test`; prints the posture and the expand-then-contract obligation at every posture; exits 0 on success    |

"Before the first destructive command" is the firing point in the five refusing scripts; the two
`server.sh` scripts have an env-file preflight but no container preflight, and the guard precedes
the env-file `die` too, so an operator with no `.env.dev` still sees the posture refusal
(AC-GAP-10). The `set -e` interaction is an implementation note, not a ban: under
`set -euo pipefail` every construct that observes a non-zero return without aborting first is a
suspending context, so the criterion is that the caller branches and terminates, not that it
avoids the only shapes able to do so (AC-GAP-8). The presence assertions (7.8) and the structural
cases go green in this phase.

**P3 — the CI caller.** The `Tear down` step in `.github/workflows/test-e2e.yml` passes
`--force-posture` explicitly and its `|| true` is dropped, so a literal gone stale against a risen
posture fails the job loudly rather than skipping teardown silently (TM-10). **<%DEVELOPER_NAME%>
owns the `--force-posture` literal, and it is updated in the same commit that raises
`DEPLOYMENT_POSTURE` in `.copier-answers.yml`** — that owner and that trigger are written as a
comment beside the literal so they travel with the thing they govern (AC-GAP-13 — the story had
once asserted it named an owner and had not; 7.10 as amended at gate 11 is where both are named).
The `up --build` step in the same workflow is a second caller of the same guarded script and needs
no override, because `up` is bound on `--seed` only (AC-GAP-14). The literal's form is settled
under _Key Decisions_.

<!-- 08/09/2026, Step 9 review (L1): the second sentence read "The owner and the trigger are
     written as a comment beside the literal so they travel with the thing they govern
     (AC-GAP-13)." — the identity dropped. Restored from `../02-STORIES/US006.md` 7.10. -->

**P4 — the documentation, the map, the assessment.** `how-to/src/DEPLOYMENT-POSTURE.md`'s
sentence about `reset.sh` is rewritten to name the guard and the override, and its dead `GAPS.md`
citation goes with it; its `seed-dev.sh` call site gains the refusal and the override.
`code/src/scripts/_lib/CONTEXT.md` lists the helper in both its tree and its Files table, and
`code/src/scripts/_lib/CLAUDE.md` gains the caller-side contract — the refuse-versus-warn policy is
the helper's and is never restated in a caller. `how-to/docs/CLI-TOOLING.md` documents
`--force-posture` on the scripts it already lists — measured 08/09/2026: `development/server.sh`,
`database/migrate.sh` and `database/reset.sh`; `restore.sh`, `tests/server.sh` and `seed-dev.sh`
have no entry there, the first two belonging to `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md`
slice `S-03` and the third documented instead at the five call sites the story names:
`.claude/skills/database/SKILL.md`, `.claude/skills/stack-django/SKILL.md`,
`how-to/workflows/04-database-operations/STEPS.md`, `code/src/scripts/database/CONTEXT.md` (two
sites) and `how-to/src/DEPLOYMENT-POSTURE.md`. `seed-dev.sh`'s own header and usage heredoc stop
claiming "dev and staging environments" (AC-GAP-2). On the map, `S-01`'s Acceptance cell is re-cut
to the six scripts this story binds and the five that refuse — the one edit of five that had not
already landed in commit `3d149e9` (AC-GAP-19) — and the _Register claimed_ posture row is marked
discharged; the `S-02` seed row stays claimed. And
`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` Section 7 is
updated to the amended twelve, so the security record and the story stop disagreeing —
`../03-SPRINTS/SPRINT-04.md` -> _Security Tasks_ assigns that edit to this story.

**What `22` owns, stated so this story does not write it twice.** `REFERENCES.md`'s ownership
table gives every implementation record and every `GAPS.md` / `DEFERRED.md` write to
`22-implementation-documentation`. So the two test records — "project-management/src/18-TESTS/US006-TEST-STATUS.md"
with the twenty-one observed exit codes and messages and the ShellCheck result, and
"project-management/src/18-TESTS/US006-MANUAL-TESTING.md" with the walk-throughs, the baselines and
the second tester's sign-off — are `22`'s. **`GAPS.md` holds nothing for this story to close**:
the 31/08/2026 posture entry was removed from it at charting under the one-working-copy rule
(measured 08/09/2026 — the register's only posture lines belong to a different map), so the closure
the sprint plan's Definition of Done names is discharged by the map's _Register claimed_ row in P4
and by nothing else.

### The helper's contract

One `posture_`-prefixed entry point, sourced never executed, with no `main`-style body — the shape
`code/src/scripts/_lib/CLAUDE.md` requires. Its inputs, in the order the design needs them:

1. **The repository root** — first positional argument, defaulting to the `BASH_SOURCE`-derived
   value. The carrier is read at `<root>/.copier-answers.yml` and the template proof tested at
   `<root>/copier.yml`, both anchored there and never cwd-relative (7.3, AC-GAP-12).
2. **The mode** — `refuse` or `warn`, declared by the caller. The refuse-versus-warn policy lives
   here; a caller states which it is and restates nothing.
3. **The override** — the value the caller parsed from `--force-posture`, or empty.
4. **The compose name the caller's compose set declares** — for the compose-target allowlist. In
   a worktree the override file's `name:` outranks the base file's, so the caller hands the helper
   the name of the **last** file in its `DC` array, or every worktree stack refuses (see _Risks_).
5. **The caller's own invocation**, so the readable-posture refusal can print a copy-pasteable
   re-run command rather than describe one.

Its verdict is reached in a **fixed order, and the order is the control**:

| Step | What is evaluated                                                                                                                                                                                                                                                    | Outcome                                                                                                                                      |
| ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | The override literal, against the set {`development`, `staging`, `production`} — **before anything is read** (7.5)                                                                                                                                                   | Not in the set: refuse, naming the three legal values. In the set: carried forward, honoured only at step 4                                  |
| 2    | The carrier, read **once**: absent file · present-but-unreadable file · conflict-marked (through `_lib/conflict-markers.sh`) · no `^DEPLOYMENT_POSTURE:` line · commented-only key · duplicated key · unrecognised value · legal value (7.2)                         | Exactly one of eight states, held for steps 3 to 5. The match is anchored, quote-tolerant and inline-comment-rejecting                       |
| 3    | The compose target — `DOCKER_HOST` unset or a local `unix://` socket; `DOCKER_CONTEXT` unset or `default`; `COMPOSE_PROJECT_NAME` unset or equal to the declared name — read from the environment, no daemon contacted (7.12)                                        | Anything else: refuse. Evaluated **at every posture**, and a permit from step 4 or 5 never short-circuits it                                 |
| 4    | A legal posture was read: `development` permits; `staging` or `production` permits **iff** the override equals it (7.4 — the carrier decides before the template proof is consulted)                                                                                 | Refuse otherwise, with the readable-posture message: the live posture and the exact re-run command, and nothing else from the carrier (7.11) |
| 5    | No legal posture was read: `<root>/copier.yml` present proves the template and permits; absent refuses with the damaged-carrier message — the reason the carrier cannot be read and the repair, naming no posture, and the override **not honoured** (7.5, AC-GAP-4) | The repair is concrete: `set DEPLOYMENT_POSTURE in .copier-answers.yml to one of development, staging or production`                         |
| 6    | The mode: in `warn` every refusal above becomes a warning line and a 0 return, and the posture — or "unknown" — is printed with the expand-then-contract obligation at every posture                                                                                 | A warning never moves the exit code                                                                                                          |

It **returns** 0 to permit and 4 to refuse, writes the refusal to stderr with the greppable prefix
`posture-guard: refused —`, and never calls `exit` — the new `_lib/` return contract. It reads the
carrier only: no `${DEPLOYMENT_POSTURE:-…}` construction exists in it, and an exported variable of
that name is ignored (7.1, TM-04). It hands the caller the resolved posture — or its absence —
through a `posture_`-prefixed output that is never named `DEPLOYMENT_POSTURE`, so the two prompting
callers can make `--yes` inert above `development` and route their empty-read path to exit `4`.
Everything it prints from the carrier is the one posture value (TM-15). The exact function
signature and the warn prefix's wording are the implementer's; the order above and the messages'
content are not.

### The proof-case list, and how each case is proved

The story enumerates twenty-one cases once — one entry, one fixture, one verdict — and every count
here cites that list rather than restating a total. Three proof methods cover them, and naming
which applies to each is the plan's job because the fixture seam reaches the helper and nothing
else: the six scripts resolve their own `PROJECT_ROOT` from `BASH_SOURCE`, an environment-variable
seam is banned, and the self-test may invoke no `docker`.

| Method | Meaning                                                                                                                                                                                                                                       |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **H**  | Helper-driven — the self-test invokes the entry point over a fixture root, in the named mode, with the named override and environment, and asserts the verdict: exit code **and** prefix together for a refusal, completion at 0 for a permit |
| **S**  | Structural — the self-test asserts a fact about a caller's text by the line-order technique 7.8 uses: a literal token appears, and appears before another                                                                                     |
| **M**  | Manual — walked by hand and recorded in the manual-testing record, signed off by a tester other than the author                                                                                                                               |

| #   | Case                                                                                     | Verdict                                        | Proved by                                                                                                           |
| --- | ---------------------------------------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| 1   | `development`                                                                            | permits                                        | H · M (all six scripts at `development`, no friction)                                                               |
| 2   | `staging`, no override                                                                   | refuses, exit 4                                | H · M                                                                                                               |
| 3   | `production`, no override                                                                | refuses, exit 4                                | H · M                                                                                                               |
| 4   | an unrecognised value                                                                    | refuses, exit 4                                | H · M                                                                                                               |
| 5   | no `DEPLOYMENT_POSTURE` key                                                              | refuses, exit 4                                | H · M                                                                                                               |
| 6   | a commented key                                                                          | refuses, exit 4                                | H · M                                                                                                               |
| 7   | a duplicated key                                                                         | refuses, exit 4                                | H · M                                                                                                               |
| 8   | a conflict-marked key                                                                    | refuses, exit 4                                | H · M                                                                                                               |
| 9   | a present-but-unreadable file                                                            | refuses, exit 4                                | H · M                                                                                                               |
| 10  | an absent file                                                                           | refuses, exit 4                                | H · M                                                                                                               |
| 11  | `copier.yml` at the root, carrier holding no legal posture — the template proof          | permits                                        | H · M (this repository, all six scripts, answers file confirmed unmodified)                                         |
| 12  | `copier.yml` at the root **and** a legal carrier posture — the carrier wins              | carrier decides                                | H                                                                                                                   |
| 13  | `DEPLOYMENT_POSTURE` exported against a `production` carrier                             | refuses, exit 4                                | H                                                                                                                   |
| 14  | `DOCKER_HOST` / `DOCKER_CONTEXT` / `COMPOSE_PROJECT_NAME` pointed away                   | refuses in the five; **warns** in `migrate.sh` | H, in **both** modes, with no daemon running                                                                        |
| 15  | `--force-posture` naming the live posture                                                | permits                                        | H · M (the suggested re-run command pasted verbatim)                                                                |
| 16  | `--force-posture` naming a stale posture                                                 | refuses, exit 4                                | H — shares no fixture with 15                                                                                       |
| 17  | `--force-posture`, well formed, against a damaged carrier                                | refuses, exit 4                                | H · M (the refusal names a repair and no posture)                                                                   |
| 18  | no tty, above `development`, a prompting script, no override                             | refuses, exit 4                                | H (the guard's verdict) · S (the two prompting scripts' empty-read path terminates at `4`, never `0`)               |
| 19  | no tty, above `development`, a valid override                                            | permits                                        | H — the self-test itself runs with no terminal on stdin, so the state that matters is the state it runs in          |
| 20  | `server.sh up --seed --force-posture <live>`, crossing the shell-out                     | permits                                        | S (the forward is present in `server.sh`; `seed-dev.sh` parses the flag ahead of its `die`) · M (walked end to end) |
| 21  | `server.sh up --build` above `development`, no override — `up` is bound on `--seed` only | proceeds                                       | S (the guard call sits inside the `--seed` branch, below the `up` case's head) · M                                  |

Beyond the twenty-one: the six **presence assertions** (7.8) are S — the literal call token
appears in each bound script at a lower line number than that script's first destructive command,
or its argument dispatch in `migrate.sh`'s case — and the whole self-test asserts on the guard's
own verdict per case. **There is no pre-change comparison**, because there is nothing pre-change to
compare against: the helper does not exist, `--self-test` dies at the unknown-command arm
identically for every case, and the permitting cases — 1, 11, 15, 19, 20 and 21 — proceed
identically before and after the change (AC-GAP-6).

### The citation gate, as it stands for this story

**Which reading applies is contingent on US004, and both branches are named here rather than
discovered at implementation** (AC-GAP-15). US004 is SPRINT-03's sole `Must` since the cascade of
07/09/2026, it retires the baseline-diff regime of
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` by its own terms, and
SPRINT-03 is built before this sprint — so the plain-pass branch is the expected one. **If US004
has landed**, `doc-references.sh` exits 0 on a clean tree and is read as a plain pass. **If it has
not**, it is read as a diff against the baseline P0 captures, and never as a bare pass.

**The story's own baseline, inherited rather than re-measured here:** 103 tree-wide and 9 on
`../02-STORIES/US006.md`, at HEAD `c6df520` on a clean tree, 05/09/2026; 127 tree-wide with the story's five
artefacts staged, every one of the 24 added being an instance citation of a PM artefact — the class
`../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` exempts once US004 lands —
or a forward reference to "code/docs/ABSENCE.md" (US003), "code/docs/reliability/" (US001) or this
story's own helper. None is of a class this story owns. The same tree gave 153 an hour earlier with
a parallel session's two plan files untracked; **a figure without its index state is not a
baseline**, which is why P0 records the state beside the number.

**What this plan adds to the population, and why it is written the way it is.** Every path in
this plan that does not exist yet — the helper, the two test records, the four worktree files, the
two guides other stories create — is written in double quotes, never backticks, because the gate
reads backticked tokens and a forward reference in backticks is a `[dangling path]` finding that
never converges. Every PM artefact is cited by full relative path, never as a bare `US###`,
`MAP-*`, `QA-*` or `SPRINT-##` token in backticks. Until this file is committed it draws spurious
`[template-only citation]` findings, because `build_template_only()` walks `git ls-files` and an
untracked file never enters the template-only set — the defect US004 exists to repair, and not one
to silence with `doc-references: template-only` markers, which `code/docs/FORWARD-VOICE.md`
reserves for a citation that is right and merely unprovable downstream.

## Key Decisions

| Decision                                              | Chosen                                                                                                                                                                                  | Rejected                                                                                          | Why                                                                                                                                                                                                                                                                                                                                         | Reference                                                             |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Where the posture is read from                        | `.copier-answers.yml`, once, at `$PROJECT_ROOT`                                                                                                                                         | A second file; an environment variable; a Jinja-delimiter sniff                                   | One carrier, and the one `N-003` sanctioned; a second channel is the override the design bans in another hat; the helper itself is rendered, so a delimiter in it is substituted, not matched                                                                                                                                               | `ADR-US006-POSTURE-CARRIER-FAILS-CLOSED`                              |
| What an unreadable carrier means                      | Refuse, on every one of eight states                                                                                                                                                    | Default to `development`                                                                          | The unreadable states are likelier on a long-lived deployed project than a fresh one; a control whose failure mode is permitting is not a control                                                                                                                                                                                           | Same ADR, Option A                                                    |
| How the template is told apart from a damaged project | `copier.yml` at the root, tested **after** the carrier holds no legal posture                                                                                                           | Inference from the absent answer; the file test unordered                                         | The two observables are identical; only a positive proof of a different thing separates them, and ordering the carrier first makes the exemption unreachable in any project holding an answer (TM-05)                                                                                                                                       | Same ADR, qualification 1                                             |
| The override's form                                   | `--force-posture <posture>`, space-separated, naming the live posture                                                                                                                   | Boolean `--force`; `=`-form as charted; an environment variable; `--yes` doubling as the override | It expires by construction; every value flag under `code/src/scripts/**` is space-separated; a second channel reopens what `N-003` closed; `--yes` conflates "are you sure" with "do you know where this is pointed"                                                                                                                        | `ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE`                           |
| The override in a damaged carrier                     | Validated first, then **not honoured**; the refusal names the repair                                                                                                                    | Honoured against the literal set alone                                                            | There is no live posture to compare against, so `--force-posture development` would permit a destructive run on a `production` project in exactly the state a `copier update` produces                                                                                                                                                      | AC-GAP-4 · TM-07 · TM-08                                              |
| The refusal's exit code                               | `4`                                                                                                                                                                                     | `2` as charted; `1`                                                                               | The house reserves 1 for a failed command and 2 for a script error; a correct command refused on policy is neither, and the fail-closed set is eight refusals, not one script error                                                                                                                                                         | Same ADR · the six scripts' `Exit codes:` headers                     |
| Where the proof lives                                 | `database/migrate.sh --self-test`, dispatched at entry, no `docker`                                                                                                                     | A new `audits/` gate; an entry point in `_lib/`                                                   | A new audit costs three counted lines in a file at 298 of 300 that US002 owns; `_lib/` bans entry points; the house pattern is the harness in the caller (`audits/conflict-markers.sh` proves `_lib/conflict-markers.sh`); `migrate.sh` is the one caller that destroys nothing                                                             | `../02-STORIES/US006.md` -> _Dependencies_ · AC-GAP-5                 |
| The fixture seam                                      | The repository root as the entry point's first positional argument                                                                                                                      | An environment variable naming the root                                                           | 7.1 bans an environment channel, and a test seam that reuses the banned channel is the control's own bypass                                                                                                                                                                                                                                 | AC-GAP-12                                                             |
| Where the no-tty refusal fires                        | At the **prompt**: the empty-read path in `reset.sh` and `restore.sh`, above `development`, terminates at `4` with the guard prefix; the entry point's verdict never reads the terminal | The entry point refusing whenever stdin is not a tty                                              | 7.6 binds the prompt, not the terminal, and a valid override satisfies the guard with or without one — a scripted caller that pipes its answer is an authorised run the terminal test would refuse, which is the path AC-GAP-1 exists to keep open. The hazard is the exit-0 abort, and that is where it is closed                          | `../02-STORIES/US006.md` 7.6 · AC-GAP-1 · TM-06                       |
| How cases 20 and 21 and the prompt path are proved    | Structurally in the self-test, by the 7.8 line-order technique, **and** by hand                                                                                                         | Dynamically, by running the scripts against a fixture                                             | The scripts resolve their own root from `BASH_SOURCE` and the self-test may invoke no `docker`, so a dynamic script-level case cannot be aimed at a fixture; the walk-through is the dynamic half and is signed off by a second tester                                                                                                      | _The proof-case list_ above                                           |
| The compose-target allowlist's declared name          | The name of the **last** compose file in the caller's set — the worktree override where present                                                                                         | The base file's name only                                                                         | `docker-compose.usXXX.dev.yml.example` sets `name:` per story and `worktree-detect.sh` layers it in; comparing against the base name refuses every worktree stack whose operator has set `COMPOSE_PROJECT_NAME` to the right thing                                                                                                          | 7.12 · `code/src/docker/CONTEXT.md`                                   |
| The committed CI literal's form                       | A hard literal, `development` in this template, hand-maintained, with the owner and trigger in a comment beside it                                                                      | Rendering the posture answer into the workflow through a Copier token at generation               | The template's own CI runs the same workflow unrendered, where a token is not a legal posture and step 1 of the helper would refuse the template's own teardown — the one checkout the `copier.yml` proof exists to keep unimpeded. A hand literal is the expiring form the override ADR chose, and the comment is what keeps it maintained | `ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE` -> _Consequences_ · TM-10 |
| Who writes the records and the register entries       | `22-implementation-documentation`                                                                                                                                                       | This story                                                                                        | `REFERENCES.md`'s ownership table gives them to `22`; a story that writes its own register entry produces two owners for one file                                                                                                                                                                                                           | `REFERENCES.md` -> _Ownership boundaries_                             |
| How this plan names what does not exist yet           | Double quotes                                                                                                                                                                           | Backticks; a `template-only` marker                                                               | The citation gate reads backticked tokens; the marker is for a citation that is right and unprovable downstream, not for a dangling one                                                                                                                                                                                                     | `code/docs/FORWARD-VOICE.md` · AC-GAP-12 of US005's QA plan           |

## Dependencies

| Story | Deliverable it owns                                       | Required for                                                                                                                                                                                   | Current state |
| ----- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| US005 | Retry doctrine into "code/docs/reliability/"              | Nothing here. The other SPRINT-04 member, built first by decision; **shares no file**; blocked by US001 while this story is not                                                                | `Open`        |
| US004 | The citation gate's git-index repair                      | Nothing here **blocks**. It decides which reading of `doc-references.sh` applies at close — both branches named above; SPRINT-03, built before this sprint                                     | `Open`        |
| US003 | "code/docs/ABSENCE.md"                                    | Nothing here — the non-collision is recorded: this story writes into none of it. SPRINT-02's `Should`                                                                                          | `Open`        |
| US002 | `code/src/scripts/audits/CONTEXT.md` headroom, 298 -> 230 | Nothing here — this story leaves that file unchanged, which is **why** the proof lives in `migrate.sh`. SPRINT-02                                                                              | `Open`        |
| US001 | "code/docs/reliability/", the family                      | Nothing here — non-collision recorded; two of this story's inherited dangling citations are US001's to clear. SPRINT-01                                                                        | `Open`        |
| US007 | One owner for the story `**Status:**` vocabulary          | Nothing here blocks. It settles the vocabulary this plan's `Status` cell and the sprint plan's _Story Plans_ column use; `Open` is a value in every set in circulation. SPRINT-01, built first | `Open`        |

**The `Current state` column is the one the parallel-worktree DAG reads**, and every row is
`Open` today — and none of them is a blocker, which is why this plan's own status is `Open` rather
than a judgement call. US007's story and its QA plan are being edited in a parallel session as
this plan is written; nothing here quotes a line of either.

- **Blocked by:** **none.** `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` records
  `Frontier open: 0 · Blocking open: 0`, and this story writes into none of the three files the
  blocking populations at slice selection named. The only thing ahead of the first edit is the
  branch cut from `main` once `pm/story-creation` lands, which is every story's gate.
- **Blocks:** **nothing in the backlog.** `S-02` on the same map, the seed presence gate, shares
  no file with this story and is explicitly **not** unblocked by it; it is not cut, and the record
  is closed to it regardless. What waits on this story is not a story: the `GAPS.md` claim
  discharged on the map's _Register claimed_ table, the posture register's sentence becoming
  true, and the first `staging` surface, at which five of the threat model's findings promote.
- **Runs beside, blocks neither:** US005 — parallel work on a different map, the other member of
  this record, sharing no file. Both sessions stage path-scoped on `pm/story-creation`; the sprint
  record is the one artefact they share.
- **Supersedes on arrival, not blocks:** a later story that binds `up` more widely falsifies the
  override ADR's CI reasoning and supersedes it; a later story adding a fourth posture or a
  per-surface posture supersedes the carrier ADR. Neither is cut.
- **Can be done now:** **everything**, once the branch exists — P0 to P4 in order, with nothing
  inside them waiting on another story. The sprint plan says it plainly: until US005's blocker
  clears, "US006 is the only member that can start, and the order in practice may well be US006
  first". Build order 2 is a decision about which outcome the sprint reaches first, not a
  constraint this story imposes or inherits.

## GDPR

**Not applicable.** The `GDPR` flag reads `N/A`. The story creates a shell helper, wires six
callers and edits Markdown; no field, no store and no code path that could carry personal data is
introduced. Section dropped rather than filled with "none" per row.

**One adjacent thing is not GDPR and should not be filed as it.** The guard reads the file that
holds every generation answer and prints one key from it, never the file — that is a disclosure
control (TM-15, A01:2025), it belongs to the Security section below, and 7.11 is where it is
discharged.

## Security

**Live, and it is the whole subject of the story: the control is threat-modelled against itself.**
Eighteen findings across **all six** STRIDE categories over six trust boundaries — **0 CRITICAL,
0 HIGH, 9 MEDIUM, 7 LOW, 2 INFO** — so nothing gated sprint planning and nothing escalated to
`../10-SECURITY/VULNERABILITIES/PLANNING/`. Twelve of the eighteen have no adversary at all; the
dominant threat class is the control mis-reading its own inputs, or standing down when it should
not, and the single failure direction that matters is failing **open**. Both artefacts read
`Reviewed`, quoted as found.

**No endpoint, no mutation, no protected action in the web sense** — so the template's
permission-check and IDOR rows have no subject and are recorded as such rather than left blank.
The authorisation boundary here is the shell, the subject is _which environment a destructive
command may reach_, and the posture **is** the authorisation input (A01:2025 is the dominant
category in the assessment).

**The twelve developer constraints are carried in from `../02-STORIES/US006.md` Security 7.1 to
7.12 and are not re-derived or restated here.** Eleven are Section 7 of
`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md`; 7.5, 7.6 and 7.7 were
amended and 7.12 added at `11-qa-checks` on 05/09/2026, and where the two disagree the story is the
corrected record — P4 updates the assessment so they stop disagreeing. One row per constraint, in
its order, naming the phase that discharges it and the proof case that shows it:

| #    | Constraint source | Discharged in                                                                                                                                                                                           | Shown by                                                             |
| ---- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| 7.1  | TM-04             | P1 — the helper reads the carrier only; no `${DEPLOYMENT_POSTURE:-…}` construction exists in it                                                                                                         | Case 13                                                              |
| 7.2  | TM-02 · TM-08     | P1 — the anchored, quote-tolerant, comment-rejecting match; duplicate and conflict-marked keys refuse                                                                                                   | Cases 6, 7, 8                                                        |
| 7.3  | TM-11             | P1 — both files tested at the `BASH_SOURCE`-derived root, never cwd-relative                                                                                                                            | Every case, through the root seam; EC-10 by hand                     |
| 7.4  | TM-05             | P1 — the carrier is evaluated before the template proof                                                                                                                                                 | Cases 11, 12                                                         |
| 7.5  | TM-07             | P1 — the override validated before the carrier is read, and not honoured where no posture is readable                                                                                                   | Cases 4, 17                                                          |
| 7.6  | TM-06             | P2 — the two prompting scripts' empty-read path exits `4`, never `0`; the override satisfies the guard regardless of tty                                                                                | Cases 18, 19; the S assertion on the prompt path                     |
| 7.7  | TM-13             | P2 — every caller branches on the status explicitly and terminates on a refusal                                                                                                                         | The S assertions; review                                             |
| 7.8  | TM-03             | P2 — the guard call asserted **present** in each bound script by line-order comparison                                                                                                                  | Six S assertions                                                     |
| 7.9  | TM-09             | P2 — `up --seed` and `seed-dev.sh` bound; the flag forwarded verbatim and parsed ahead of the `die`                                                                                                     | Case 20                                                              |
| 7.10 | TM-10             | P3 — no `\|\| true` on the guarded CI call; <%DEVELOPER_NAME%> owns the `--force-posture` literal, updated in the same commit that raises the carrier, and that owner and trigger are written beside it | A read of the workflow; the template's own teardown at `development` |
| 7.11 | TM-15             | P1 — the refusal prints the live posture where readable and the re-run command, else the reason and the repair, and nothing else from the carrier                                                       | Cases 2, 3, 5 to 10, 17                                              |
| 7.12 | TM-01             | P1 — the compose-target allowlist, decidable from the environment, following the caller's mode                                                                                                          | Case 14, in both modes                                               |

<!-- 08/09/2026, Step 9 review (L1): the 7.10 cell read "P3 — no `\|\| true` on the guarded CI
     call; the owner and trigger written beside the literal". The owner and trigger are restored
     in the wording of `../02-STORIES/US006.md` 7.10. -->

**Every severity above is a present-state reading of a tree with nothing deployed, and the plan
must not be read as though they were stable.** Section 3a of
`../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` names the event
that promotes each. **Six threats in four of its rows carry design-state `HIGH`**: TM-01 and TM-05
at the first surface reaching `staging`; TM-02 and TM-08 at the first `copier update` against a
project at `staging` or above; TM-12 at the first `migrate.sh fake` against a deployed database;
and TM-03 at the first edit to a bound script by anyone who has not read the model. TM-04 and
TM-11 promote to `MEDIUM`. **The promotion is not this story's to perform**; a finding whose
trigger fires during the sprint is re-assessed in `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/`.

**The summaries of that table say five, and the table says six — verified row by row on
08/09/2026.** Section 3a has five rows. Four carry `HIGH`: TM-01 and TM-05 (the first surface
reaching `staging`), TM-02 and TM-08 (the first `copier update` at `staging` or above), TM-12 (the
first `migrate.sh fake` against a deployed database) and TM-03 (the first edit to a bound script)
— **six** threat IDs. The fifth row, TM-04 and TM-11, promotes to `MEDIUM`. **Five carriers write
"five"**, each counting the four with a deployment trigger plus TM-12 and omitting TM-03, whose
trigger is an edit rather than a deployment: the threat model's **own Section 4** ("five of them
promote to `HIGH`"); Section 1 of the assessment ("four at the first `staging` surface, one at the
first `migrate.sh fake`"); the Security comment in `../02-STORIES/US006.md`;
`../03-SPRINTS/SPRINT-04.md` -> _Security Acceptance Criteria_; and
`../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` -> _Sprint-wide Constraints_.

**No edit in this story's scope corrects any of the five.** The one security-artefact edit the
sprint record assigns this story is the assessment's **Section 7** — the amended twelve
constraints, P4 — and it does not reach Section 1; the threat model, the sprint record, the
sprint plan and the story's comment are not this story's files at all. **Residual, with an
owner:** the count is the security gate's own summary of its own table, so `10-security-checks`
(the `security` skill) corrects the two security artefacts in place with a dated erratum — the
shape US005's assessment took for its own four-versus-three, an erratum beside the summary rather
than a supersession — and the three mirrors take the corrected figure from the source on their
owners' next pass (`03-sprint-planning`, `16-sprint-plans`, `02-story-creation`). The latest point
by which it must be reconciled is the threat model's `IMPLEMENTATION/` counterpart, which
re-assesses Section 3a against shipped code at `22`. Nothing in the story's acceptance depends on
the number; this plan carries **six** wherever it counts.

<!-- 08/09/2026, Step 9 review (M1): the paragraph above read "**The summaries of that table say
     five, and the table says six.** The assessment's Section 1, the story's Security comment and
     `../03-SPRINTS/SPRINT-04.md` each write "five promote to HIGH", counting the four with a
     deployment trigger plus TM-12 and omitting TM-03, whose trigger is an edit rather than a
     deployment. Recorded here rather than propagated, on the precedent US005's plan set for its
     own four-versus-three on 08/09/2026, and left for the assessment's own gate to correct when
     P4 updates its Section 7; nothing in the story's acceptance depends on the number." Three
     defects: it listed three carriers where there are five (the sprint plan and the threat
     model's own Section 4 were missing); the route it named, P4's Section 7 update, reaches none
     of them; and it left the correction to a gate without saying no edit here performs it. The
     six was re-verified row by row rather than inherited. -->

**Two baselines deliberately do not reach this story**, and the skip is recorded rather than the
rows left blank: NIST SP 800-53 control depth and UK Cyber Essentials / CE+ both cover running
infrastructure or an implemented runtime control, and this story ships a developer script guard
with no runtime surface. `../10-SECURITY/AUDITS/` does not fire for the same reason — a code audit
reads shipped runtime code — and the sprint plan records the skip. Both re-engage at the first
story that wires a runtime surface.

**Accepted residuals, named rather than assumed:** the override is the authorisation and is
written nowhere but shell history (TM-16 — the audit trail covers the application, not a developer
script); refusal and operator-decline are distinguishable only by exit code (TM-18 — the prefix
makes the refusal greppable and the decline path is out of scope); three unguarded routes wipe the
test volumes on every run (TM-14 — disposable by design, `N-001`); and a generated project whose
carrier is damaged **and** which has acquired a `copier.yml` is exempted (the carrier ADR's own
trade-off, re-assessed at the first `staging` surface).

## Logging & Observability

**Not applicable as a flag** — `Logging: N/A`. The story adds no log line and wires no sink. The
guard's only output is a refusal or a warning on stderr and, in `migrate.sh`, the posture line and
the expand-then-contract obligation. `DE` is the weakest NIST function in the assessment and
honestly so: nothing detects the control's own removal except the presence assertion (7.8), which
is what moves it off Open.

## Performance, Rendering, Responsive & Accessibility

**Not applicable** — no rendered surface, no route, no upload, no user-owned table, so the
scale-readiness row has no subject either. No infrastructure dependency is added: the guard reads
three Docker environment variables the existing compose substrate already defines and contacts no
daemon, so `how-to/src/PLATFORM-PROVIDERS.md` gains no row.

**One readability property is load-bearing rather than tidy:** the refusal message is the guard's
entire user interface. The readable-posture refusal must carry a command an operator can paste
verbatim, and the damaged-carrier refusal must name the file, the key and the three legal values
rather than point at a document — `how-to/src/DEPLOYMENT-POSTURE.md` is the per-surface register
and carries no repair procedure (AC-GAP-22). The manual half reads both as an operator would.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✅ → `10-security-checks` ✅ (`Reviewed`, 05/09/2026) → `11-qa-checks` ✅
(`Signed off`, 05/09/2026) → `15-decisions` ✅ (two ADRs, both `Accepted`) → `03-sprint-planning` ✅
(record opened 05/09/2026, re-planned 07/09/2026) → `16-sprint-plans` ✅ (08/09/2026) →
**`17-story-plans` (this document)** → the lane below → `22-implementation-documentation` →
`23-pr-and-review` → `24-release`.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` all read `N/A`; the
story's `Backend`, `API` and `Frontend` flags say so, and
`../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` -> _Phase Breakdown_ records the three phases as `N/A`
with their reasons. The lane the story runs in is the five-phase plan above.

**`03-sprint-planning` was taken after `10`, `11` and `15`**, not before them — the precedent
SPRINT-03 states and `../03-SPRINTS/SPRINT-04.md` -> _Notes_ records: a record opens when its
member has cleared the specify tier, because gates `10` and `11` supply its Security and QA
sections and gate `11` widened this story's QA flag value.

### Code workflows invoked

| Workflow                                | When                                                                                                                                          |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/workflows/02-tdd-cycle/`          | ✓ always — P1's harness is the red state; the helper greens it; each caller in P2 goes red on its structural assertion first                  |
| `code/workflows/08-security-hardening/` | ✓ — the story ships a security control; the pre-PR pass re-reads 7.1 to 7.12 against the shipped helper and callers                           |
| `code/workflows/07-review/`             | ✓ always — the code-content review before the PR                                                                                              |
| `code/workflows/01-implement-story/`    | The build spine, entered at P1; its models-and-migration and endpoint steps have no subject here and are recorded as skipped with that reason |
| `code/workflows/11-refactor/`           | Only if wiring six callers surfaces duplication worth lifting into the helper — a separate commit, behaviour unchanged                        |
| `code/workflows/10-debug/`              | A reproducible defect found by the walk-through — failing case first                                                                          |

### Standards gates

Every command through `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`, `pytest`,
`pnpm` or `docker` call, and the self-test itself invokes no `docker`. British English,
DD/MM/YYYY, the U+00A7 ban and plain-ASCII punctuation per
`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2. Cross-artefact citations by
full repo-relative path. Shell: `set -euo pipefail` as every one of the six scripts already has;
the helper side-effect-free at load, idempotent when sourced twice, functions not top-level
statements (`code/src/scripts/_lib/CLAUDE.md`). Documentation: nothing born at or above 270 code
lines, nothing edited crosses it without a dated allowance (`code/docs/DOCUMENTATION-LENGTH.md`);
the `_lib/` pair edited on both halves (`code/docs/DOCUMENTATION-PAIRING.md`).

## Execution & Verification via Claude Dynamic Workflows

Every session runs with ultracode on, and the internal procedure comes first
(`.claude/CLAUDE.md` Section 2.7): the dynamic workflow supplies the fan-out and the adversarial
verification, and the steps come from the folders named here.

- **Stage 0 — plan verification.** `17-story-plans` Step 9: two or three independent adversarial
  reviewers over this plan before it is treated as codeable — missing constraints, wrong doc
  references, a proof case mapped to the wrong method, a dependency-order error, an unscoped
  deferral. Findings resolved in this file.
- **Stage 1 — build.** P0 first and alone; then P1 as one TDD loop; then P2 fanned out per caller
  where the callers are independent — the two `database/` refusers, the two `server.sh` scripts,
  `seed-dev.sh` with its forward, `migrate.sh`'s warn — and serialised on the helper's contract,
  which is fixed before the fan-out; P3 and P4 in parallel after P2.
- **Stage 2 — continuous verification.** After every meaningful change:
  `bash code/src/scripts/database/migrate.sh --self-test` with the stack down;
  `bash code/src/scripts/syntax/lint.sh --file-type markdown` over the documents edited;
  `bash code/src/scripts/audits/docs-pairing.sh`; `bash code/src/scripts/audits/docs-length.sh`;
  ShellCheck by hand over the helper and the six callers, recorded as run or not run. The Python
  gates in the template's table — `check.sh`, `stubs.sh` over Python, `tests/all.sh --coverage` —
  have nothing to read and are recorded `N/A`; `audits/cloc.sh` runs and has nothing near a limit.
- **Stage 3 — review.** `code/workflows/07-review/` driven by the `review` and `security` skills;
  each finding adversarially verified before it is acted on. The security pass re-reads 7.1 to
  7.12 against the shipped text — that is the one review question that matters here.
- **Stage 4 — behavioural verification.** The manual half: the ten carrier states against a
  scratch answers file; the template case in this repository across all six scripts, the answers
  file confirmed unmodified; `up --seed --force-posture <live>` end to end; the refusal read as an
  operator would; both `down --volumes` paths at `development`; the damaged-carrier refusal naming
  a repair and no posture. A tester other than the author signs.
- **Stage 5 — PR and release.** `07-review` clean → `22-implementation-documentation` writes the
  records → `23-pr-and-review` → `24-release` if a version is cut.

## Quality Gates, Scripts & Local↔Docker Alignment

**Governing rule.** All developer operations use the wrapper scripts in `code/src/scripts/**/*.sh`.
This story is unusual in that its subject **is** six of those wrappers, and its proof deliberately
runs outside Docker — the guard exists for the stack-down case, and a proof that needed a daemon
would fail in exactly the state the guard is for.

| Need                      | Command                                                            | Runs                                                                 |
| ------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------------------- |
| The proof                 | `bash code/src/scripts/database/migrate.sh --self-test`            | Local, stack down, no `docker`                                       |
| Markdown lint             | `bash code/src/scripts/syntax/lint.sh --file-type markdown`        | Both                                                                 |
| Markdown format           | `bash code/src/scripts/syntax/format.sh --file-type markdown`      | Both                                                                 |
| Citation gate             | `bash code/src/scripts/audits/doc-references.sh`                   | Local                                                                |
| Length gate               | `bash code/src/scripts/audits/docs-length.sh`                      | Local                                                                |
| Pairing gate              | `bash code/src/scripts/audits/docs-pairing.sh`                     | Local                                                                |
| Doctrine regression guard | `bash code/src/scripts/audits/doctrine-drift.sh`                   | Local                                                                |
| Line count                | `bash code/src/scripts/audits/cloc.sh`                             | Local                                                                |
| The walk-throughs         | The six guarded scripts themselves, at the postures the cases name | Docker for the permitting cases at `development`; none for a refusal |
| Worktree `/etc/hosts`     | `bash code/src/scripts/development/hosts-story-add.sh us006`       | Local                                                                |

**Two things are not wrappers and are recorded as such.** ShellCheck has no project script — it is
run by hand, or recorded as not run, never as a `lint.sh` pass (`code/docs/GATE-REPORTING.md`).
`syntax/check.sh` is `N/A`: it type-checks Python, TypeScript and Rust and has no shell, YAML or
Markdown leg. The template's two raw-command exceptions (`pnpm exec`, `uv run`) are not exercised
by this story.

## Testing

**One coverage floor does not apply, with its reason.** `code/docs/TESTING.md` and
`code/docs/testing/COVERAGE.md` fix one floor — **75% line and branch, 90% on auth-related code**,
raised to 80% by the pre-PR gate on `staging`/`main` — and it is enforced by `coverage.py` over
`apps`. This story ships no Python path, so `tests/all.sh --coverage` and `migrate.sh check` are
`N/A` with a reason rather than skipped boxes, and the floor has nothing to measure. The proof is
the `--self-test`; the manual half is load-bearing, not ceremonial, because the fixture seam
reaches the helper and nothing else.

| Layer                        | Method                                                                                                                                                     |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The helper (P1)              | **H** — twenty-one verdicts over a fixture tree, one entry one fixture one verdict; refusals on exit code **and** prefix together, permits at 0            |
| The callers (P2)             | **S** — six presence assertions, the forward, the `--seed`-branch placement, the two prompt paths; each a line-order comparison in the 7.8 style           |
| The CI caller (P3)           | A read of the workflow — the literal, no `\|\| true`, the comment — and the template's own teardown at `development`, which the `copier.yml` proof permits |
| The documentation (P4)       | `lint.sh --file-type markdown`, `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh` per _The citation gate_; a cold read of the rewritten sentence    |
| Unit & integration (backend) | **N/A** — no Python; `tests/backend.sh` has nothing to run                                                                                                 |
| API / contract, permission   | **N/A** — no endpoint, no Bruno flow, no permission check in the web sense                                                                                 |
| Template, component, HTMX    | **N/A** — no template or component                                                                                                                         |
| Browser e2e, accessibility   | **N/A** — no rendered surface; the output is a shell refusal in a terminal                                                                                 |
| Manual                       | **M** — the story's six manual criteria, walked and recorded, signed off by a tester other than the author                                                 |

**Two rules bind every case.** No case shares a fixture with another — the override's two
directions in particular (cases 15 and 16) — and no assertion is on the exit code alone, so a
script that exits `4` for an unrelated reason cannot pass. **There is no pre-change comparison**
(AC-GAP-6), and none is claimed anywhere.

**The self-test is run in the state that matters.** It is dispatched with the stack down, invokes
no `docker`, runs with no terminal on stdin, and writes only under a temporary directory removed by
its `trap`. Its output — every case's observed exit code and message — is what
"project-management/src/18-TESTS/US006-TEST-STATUS.md" records, alongside the ShellCheck result as
run or as not run.

**The manual record carries the baselines too.** P0's three figures with their index state,
`docs-length.sh`'s reading of `code/src/scripts/audits/CONTEXT.md` at close, and the walk-throughs
go into "project-management/src/18-TESTS/US006-MANUAL-TESTING.md", written by `22`.

## Documentation Write-Ups (Implementation Records)

`22-implementation-documentation` owns the records and writes both test records named above. It
also owns this story's register reconciliation, which is a **discharge, not a write**: the
31/08/2026 posture entry was removed from `GAPS.md` at charting, so the closure the sprint plan's
Definition of Done names is the map's _Register claimed_ row marked discharged in P4 and nothing
in `GAPS.md`. `DEFERRED.md` gains no row from this story unless `22` judges one of the deferrals
below a hand-off rather than a map-recorded residual; the candidates are named there so the
judgement is made rather than skipped.

| Record                             | This story                                                                                                                       |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| This plan                          | Always — this file                                                                                                               |
| ADRs                               | Two, both written at `15-decisions` and `Accepted`; the override record carries a dated erratum                                  |
| User story · sprint plan · record  | `../02-STORIES/US006.md` · `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` · `../03-SPRINTS/SPRINT-04.md`                              |
| Security threat model · assessment | Both `PLANNING/` artefacts exist and read `Reviewed`; the `IMPLEMENTATION/` counterparts re-assess against shipped code, by `22` |
| QA plan · QA implementation review | `../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` `Signed off`; the `IMPLEMENTATION/` review at `23-pr-and-review`              |
| Test status · manual testing       | Both, under `../18-TESTS/`, by `22`                                                                                              |
| Code review record                 | `../19-REVIEWS/`, at `23-pr-and-review`                                                                                          |
| GDPR · SEO · API · Logging records | **Not required** — each flag reads `N/A`, with its reason under the matching section above                                       |
| Schema / ERD                       | **Not required** — `DB: N/A`                                                                                                     |
| Bug · refactoring records          | Conditional — only if the walk-through finds a defect, or P2 lifts duplication into the helper                                   |
| Release                            | Conditional — `24-release` if a version is cut; the story itself bumps nothing                                                   |

## CONTEXT.md & Index Updates

| File                                      | Change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/_lib/CONTEXT.md`        | The helper in the tree **and** the Files table — the DoD is satisfiable while leaving one stale, so both are named                                                                                                                                                                                                                                                                                                                                                                                   |
| `code/src/scripts/_lib/CLAUDE.md`         | The caller-side contract: the refuse-versus-warn policy is the helper's; 0 permit, 4 refuse, stderr, never `exit`; the root argument as the test seam                                                                                                                                                                                                                                                                                                                                                |
| `code/src/scripts/database/CONTEXT.md`    | The two `seed-dev.sh` sites gain its refusal and its override                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` | `S-01`'s Acceptance cell re-cut to six scripts and five refusing paths; the _Register claimed_ posture row discharged; the `S-02` row untouched                                                                                                                                                                                                                                                                                                                                                      |
| `../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` | **Paid 08/09/2026 by `17-story-plans` Step 10.** Its _Story Plans — the code master_ row for US006 points at this file, its Status cell filled as that plan's own section defines the column — "Not started", the US005 cell's value, knowingly not this plan's `Open` because that column waits on US007 — and the reservation wording kept there in a dated comment after the table. Its `Git branch` and _Branch Naming Reference_ cells take `us006/posture-guard` from this plan's `Branch` row |
| `../02-STORIES/US006.md`                  | **Paid 08/09/2026 by `17-story-plans` Step 10.** The story cites this plan under its _Decisions_ list in the form `../02-STORIES/US005.md` uses for its own plan; its STORY-PLAN NUMBER RESERVED comment gains a dated note that the reservation was taken up                                                                                                                                                                                                                                        |
| `../17-STORY-PLANS/CONTEXT.md`            | **No row.** It ships, and its _The plans index_ section records that it holds no index by decision; the folder-level index is deferred to the register-index work charted in `../01-FEATURE-MAPS/`                                                                                                                                                                                                                                                                                                   |
| `GAPS.md` · `DEFERRED.md`                 | Nothing to close in the first (the entry left at charting); candidates for the second named under _Deferred Items_ — `22`'s judgement and `22`'s write                                                                                                                                                                                                                                                                                                                                               |

<!-- 08/09/2026, Step 10: two rows above were rewritten when the debts they named were paid. The
     sprint-plan row read "Its _Story Plans — the code master_ row for US006 currently reads
     "_no plan to mirror_" against a no-file reservation; pointing it at this file, with its
     Status cell filled as that plan's section defines, is **that plan's own edit** — named here
     as the one debt this run creates rather than pays. Its `Git branch` and _Branch Naming
     Reference_ cells read "not yet set"; this plan's `Branch` row fixes them". The story row
     read "A reference to this plan, per `17-story-plans` Step 10 — the story's own edit, not
     this run's". Both edits were made by the Step 10 pass, not by the run that wrote this plan. -->

## Status Propagation & ClickUp Sync

On every status transition the same value is set, in this order: `../02-STORIES/US006.md` →
`**Status:**` first, the only file the ClickUp export reads; this plan's `Status` cell; the
sprint plan's _Story Plans — the code master_ `Status` cell, once that plan carries this file;
`../03-SPRINTS/SPRINT-04.md`'s Story Summary; then the export regenerated with
`bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US006`. The vocabulary
this plan uses is the template's, and `Open` is also a value in the `completion` skill's story set
(`.claude/skills/completion/SKILL.md` -> _The status vocabulary_); which set owns the column is
US007's to settle, and this plan does not pre-empt it.

## Deferred Items

- **Posture enforcement outside the script layer** — Django settings and CI itself. Recorded on
  the map's _Out of scope_ table as a new register entry rather than scope creep; no story owns it
  and this story writes no entry for it. Target: future.
- **The seed presence gate** — `S-02` on the same map, sharing no file with this story and not
  unblocked by it. Not cut; the record is closed to it regardless. Target: a later sprint.
- **`migrate.sh fake` and `fake-initial` stay warn-only, knowingly.** They rewrite the schema's
  record of itself, which is the premise `N-003` rested warn-only on (TM-12); the promotion trigger
  is the first `fake` against a deployed database. Held by <%DEVELOPER_NAME%> at gate 10 with the
  disposition known. Target: the story that meets the trigger — a candidate `DEFERRED.md` row for
  `22` to judge.
- **The three unguarded test-volume teardowns** — destructive by design on every run (TM-14,
  `N-001`). Residual, not deferred.
- **The override's audit trail** — written nowhere but shell history (TM-16). Accepted residual:
  the audit trail covers the application, not a developer script.
- **CLI-guide entries for `restore.sh` and `tests/server.sh`** — neither has one today, and both
  belong to `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-03`'s index re-cut. `seed-dev.sh`
  has none either (measured 08/09/2026) and gains none here: the story's task binds the scripts the
  guide already lists, and `seed-dev.sh`'s refusal and override are documented at the five call
  sites instead. Named so the gap is read as known rather than found.
- **A ShellCheck leg in `lint.sh`** — no project script runs it, so the story runs it by hand; no
  story owns adding one. Target: future.
- **Binding `up` more widely** falsifies the override ADR's CI reasoning and supersedes it; **a
  fourth or per-surface posture** supersedes the carrier ADR. Neither is cut, and both are named
  in the ADRs' own follow-ons.
- **The damaged-carrier-plus-`copier.yml` exemption** in a generated project — the carrier ADR's
  accepted trade-off, TM-05's promotion trigger, re-assessed at the first `staging` surface.

## Risks

| Risk                                                                                                                                                      | Likelihood | Impact | Mitigation                                                                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.6 is read as a terminal test and the entry point refuses on no tty, refusing the CI teardown the story exists to keep working (the AC-GAP-1 regression) | Med        | High   | The entry point never reads the terminal; the prompt-path decision is fixed under _Key Decisions_; case 19 runs in the self-test's own no-tty state; HP-04 walked |
| The `--self-test` arm lands after the command validator or the container check and fails with the stack down                                              | Med        | High   | Dispatched at entry as P1's first task; EC-09 is the check; the Definition of Done says "with the stack down"                                                     |
| The compose-target allowlist compares against the base compose name, so a worktree stack whose operator set `COMPOSE_PROJECT_NAME` correctly refuses      | Med        | Med    | The caller hands the helper the last file's declared name; a worktree case (EC-10's shape) in the manual walk                                                     |
| Cases 20, 21 and the prompt path are proved only structurally, and a wiring defect the static assertion cannot see ships                                  | Med        | Med    | The manual half walks each end to end and a second tester signs; the structural assertion is the regression guard, the walk is the proof                          |
| `--force-posture` reaches `seed-dev.sh`'s unknown-option `die` before its parser and dies at exit 2 — a bound path with no open state                     | Med        | High   | Parsed ahead of the `die` (7.9); case 20's structural assertion names the order; the walk-through crosses the shell-out                                           |
| The CI literal is stale on day one for a project generated with a posture above `development`                                                             | Low        | Med    | The failure is loud by design (TM-10); the comment beside the literal names generation as a trigger as well as a raise; the owner is named                        |
| A registration for the proof lands in `code/src/scripts/audits/CONTEXT.md` and breaches the 300-line limit US002 owns                                     | Low        | High   | The proof lives in `migrate.sh`; P0 records the file at 298 and the close proves it unchanged with `docs-length.sh`, never `wc -l`                                |
| The wrong reading of `doc-references.sh` is applied at close — a diff where a plain pass is available, or a bare pass where a diff is owed                | Med        | Low    | P0 captures the baseline with its index state; both branches are named; US004's landing is checked before the run                                                 |
| The present-state severities are read as a clean security result                                                                                          | Med        | Med    | The six design-state `HIGH` threats and their triggers are cited beside every severity claim, per `code/docs/GATE-REPORTING.md`                                   |
| `_lib/conflict-markers.sh`'s "return 0 always, signal on stdout" convention is misread and the conflict-marked state never refuses                        | Low        | Med    | Sourced, never copied; the helper reads its output, not its status; case 8 asserts the verdict                                                                    |
| Exit `4` collides with a code some existing caller of the six scripts already interprets                                                                  | Low        | Low    | P2 greps for callers testing the six scripts' status; the CI `\|\| true` is the one found and is dropped                                                          |
| The `_lib/` pair is edited on one half only                                                                                                               | Low        | Low    | Both halves are named in P4 and in _CONTEXT.md & Index Updates_; `docs-pairing.sh` runs at close                                                                  |
| The seven-line comment block in `.copier-answers.yml` gains a commented `DEPLOYMENT_POSTURE` line in a generated project and a naive match honours it     | Low        | High   | The match is anchored on `^DEPLOYMENT_POSTURE:` and comment-rejecting; case 6 asserts it; EC-01 walked                                                            |

## Docker & Nginx Infrastructure

**N = 6.** `how-to/docs/GIT-WORKTREES.md` fixes the loopback rule — the final octet equals the
story number, `127.0.0.1` being the main stack — so the IP is `127.0.0.6`, and it is unique by
construction: no sibling plan in this folder names a `127.0.0.N` at all (measured 08/09/2026), and
no other story carries the number 6. The subnets follow `code/src/docker/CONTEXT.md`: second octet
the story number, third octet 1 for dev and 0 for test.

| File                                            | Purpose                                                                                                                                                                                     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us006.dev.yml"  | Dev stack override — copied from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us006`; nginx published on `127.0.0.6:3080:80`; subnet `10.6.1.0/24` |
| "code/src/docker/docker-compose.us006.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us006`; `127.0.0.6:3081:80`; subnet `10.6.0.0/24`                        |
| "code/src/docker/nginx/dev-us006.conf"          | Named per `../17-STORY-PLANS/CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                 |
| "code/src/docker/nginx/test-us006.conf"         | Same                                                                                                                                                                                        |

**The two Nginx files are named because the folder's rule names them, and the docker layer says
they do not exist.** `code/src/docker/nginx/CONTEXT.md` states that `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged, and that "there are no per-story
Nginx variants to generate"; `code/src/docker/CONTEXT.md` -> _Worktree stacks_ says the same. The
two compose overrides are the files a worktree actually creates; the two Nginx names are recorded
so the four-file convention is satisfied on paper and the reader is told which half is real. That
disagreement between `../17-STORY-PLANS/CLAUDE.md` and the docker layer's own orientation is not
this story's to settle and is raised in this run's report rather than resolved here.

Every path in the table is in quotes because none exists until the worktree does; the two example
files they are copied from do exist and are backticked. All four are written in the story's
number, `us006`, and every host-facing port the base file binds is re-scoped — the dev base binds
one, `127.0.0.1:81:80`.

`/etc/hosts` (one-time per story — `bash code/src/scripts/development/hosts-story-add.sh us006`,
reversed by `hosts-story-remove.sh`):

```text
127.0.0.6 dev-us006.<%PROJECT_SLUG%>.localhost test-us006.<%PROJECT_SLUG%>.localhost
```

The worktree-aware scripts auto-detect the `us006/` branch through `_lib/worktree-detect.sh` and
layer the two overrides in. **One consequence for this story in particular:** the override sets a
per-story compose `name:`, so the compose-target allowlist (7.12) must compare against that name
when the override is present — the Key Decision above, and a manual case in the walk-through.
This project keeps no cross-cutting parallel-worktree programme plan; the DAG is the _Dependencies_
sections of the plans in this folder.

## Sprint Verification Checklist

```bash
# The proof — stack down, no docker
bash code/src/scripts/database/migrate.sh --self-test

# The documentation gates
bash code/src/scripts/syntax/format.sh --file-type markdown
bash code/src/scripts/syntax/lint.sh --file-type markdown
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/doctrine-drift.sh
bash code/src/scripts/audits/cloc.sh

# Status propagation — regenerate the ClickUp export from the updated source story
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US006
```

- [ ] `migrate.sh --self-test` exits 0 with the stack down — cases 1 to 21, none omitted, none
      doubled up; every refusal asserted on code **and** prefix; every permit at 0
- [ ] The six presence assertions, the forward, the `--seed`-branch placement and the two prompt
      paths asserted structurally
- [ ] ShellCheck over the helper and six callers recorded as run or as not run — never as a
      `lint.sh` pass
- [ ] `doc-references.sh` read per _The citation gate_ — a plain pass if US004 has landed, a diff
      against P0's baseline in the same index state if not; every survivor named with its owner
- [ ] `docs-length.sh` — `code/src/scripts/audits/CONTEXT.md` unchanged at 298 code lines; nothing
      this story creates or edits enters the warn tier without a dated allowance
- [ ] `docs-pairing.sh` passes — both halves of the `_lib/` pair edited; no new directory, so no
      new pair
- [ ] `doctrine-drift.sh` — regression only; the guard's contract is prose and adds no claims row;
      never reported as having checked prose
- [ ] `syntax/check.sh` · `migrate.sh check` · `tests/all.sh --coverage` · template and component
      tests · `routing-skills.sh` — **N/A**, each with its reason above
- [ ] The manual half walked and signed off by a tester other than the author
- [ ] No secrets, debug flags or hardcoded IDs — the guard prints the posture and nothing else from
      the answers file (TM-15)
- [ ] All twelve security constraints signed off; the assessment's Section 7 updated to the amended
      twelve
- [ ] Each design-state promotion trigger in Section 3a of
      `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` names a surface
      or event that can actually fire it — `../03-SPRINTS/SPRINT-04.md` -> _Security Tasks_, the
      fourth of US006's four rows, discharged here and nowhere else in this plan. Read 08/09/2026,
      to be re-read at close against the model as it then stands: the first surface reaching
      `staging` (TM-01, TM-05) is `DEPLOYMENT_POSTURE` rising in `.copier-answers.yml` and
      `how-to/src/DEPLOYMENT-POSTURE.md` gaining its row; the first `copier update` at `staging` or
      above (TM-02, TM-08) is the operation `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` documents; a
      nested `copier.yml` or an exported variable (TM-04, TM-11) is a file or a wrapper an operator
      can add; `migrate.sh fake` against a deployed database (TM-12) is a subcommand
      `code/src/scripts/database/migrate.sh` already dispatches; the first edit to a bound script
      (TM-03) is a diff touching any of the six. Every trigger is a fireable event. One qualifier is
      not observable — TM-03's "by anyone who has not read this model" — which is why 7.8's
      presence assertion is the detector for that row rather than the trigger
- [ ] GDPR, Logging, SEO and accessibility criteria — **N/A**, each flag reads `N/A`
- [ ] Status propagated to story, this plan, the sprint plan's _Story Plans_ row and the sprint
      record; the ClickUp export regenerated

## Definition of Done

- [ ] P0's three baselines captured **before any edit**, each with its index state or its tool
      named beside it
- [ ] "code/src/scripts/_lib/posture-guard.sh" exists, sourced never executed, one `posture_`-prefixed
      entry point carrying both modes, returning 0 or 4, refusal on stderr, never calling `exit`,
      reading the carrier only, at the root its first positional argument names
- [ ] The verdict order of _The helper's contract_ holds: override validated first, carrier read
      once, compose target at every posture, carrier before template proof, the override not
      honoured where no posture is readable, the mode applied last
- [ ] The six callers wired per the P2 table — five refuse, one warns; the guard call precedes the
      first destructive command, or argument dispatch in `migrate.sh`, and precedes the env-file
      check in both `server.sh` scripts
- [ ] `--force-posture <posture>` parsed in all five refusing scripts, global and inert on unbound
      subcommands in both `server.sh` scripts, forwarded verbatim across the `seed-dev.sh`
      shell-out and parsed there ahead of the `die`
- [ ] `--yes` inert above `development` in `reset.sh` and `restore.sh`; their empty-read path exits
      `4` with the guard prefix, never `0`
- [ ] Exit `4` declared in all six scripts — header comment and usage heredoc, twelve lines
- [ ] `.github/workflows/test-e2e.yml`'s teardown passes `--force-posture` explicitly with no
      `|| true`, and the owner and trigger sit in a comment beside the literal; `up --build` in the
      same workflow is untouched and unbound
- [ ] `migrate.sh --self-test` dispatched at entry, no `docker`, a `trap`, nothing written outside
      a temporary directory, twenty-one cases plus the structural assertions, all green with the
      stack down
- [ ] `how-to/src/DEPLOYMENT-POSTURE.md` names the guard and the override and cites no dead
      `GAPS.md` entry; its `seed-dev.sh` site amended
- [ ] `code/src/scripts/_lib/CONTEXT.md` lists the helper in tree and table;
      `code/src/scripts/_lib/CLAUDE.md` states the caller contract
- [ ] `how-to/docs/CLI-TOOLING.md` documents `--force-posture` on the scripts it lists;
      `seed-dev.sh`'s header and heredoc no longer claim staging; the five call-site documents
      carry its refusal and override
- [ ] `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` `S-01` names six scripts and five refusing paths,
      and its _Register claimed_ posture row reads discharged; `S-02` untouched
- [ ] `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` Section 7 reads
      the amended twelve
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped
      silently and nothing not-run reported as clean
- [ ] Both test records written by `22`, the manual one signed off by a second tester
- [ ] Code reviewed and approved (minimum 1 reviewer); the security pass re-read 7.1 to 7.12
      against the shipped text
- [ ] No TODO or FIXME introduced; no secret, debug flag or hardcoded ID
- [ ] Status propagated to every artefact that carries it — `../02-STORIES/US006.md`, this plan's
      own header, the sprint plan's _Story Plans — the code master_ row once it names this file,
      and `../03-SPRINTS/SPRINT-04.md`'s Story Summary; the ClickUp export regenerated
- [ ] Reviewed and approved; merged
