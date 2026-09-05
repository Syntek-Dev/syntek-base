# STORY-PLAN-US005 — Exactly one layer decides to retry, and every budget says how long it may take

| Field  | Value                               |
| ------ | ----------------------------------- |
| Date   | 05/09/2026                          |
| Branch | `us005/retry-ownership-and-budgets` |
| Sprint | SPRINT-03 · Wave 1 · build order 1  |
| Author | <%ORG_NAME%>                        |
| Status | `Blocked`                           |

Implements `../15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` (one layer decides
to repeat an operation, every layer beneath makes a single attempt, and SDK transport retries are
clamped off by default) under
`../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` (prose doctrine is verified
by a human read-across, never by `doctrine-drift.sh`).

> **`Blocked` is literal, and it is the first plan in this repository to carry it.**
> `../17-STORY-PLANS/CLAUDE.md` makes any status other than `Blocked` an assertion that the
> blockers are cleared, and the parallel-worktree DAG reads it. US005's four rules are stated
> **inside** `code/docs/reliability/`, which exists in no branch and no commit. There is no
> partial start and no draftable half: the family is the target. US001's and US003's plans read
> `Open` with live blockers because theirs are build-order facts about stories that change no file
> they touch — that is a different thing and this status should not be read as drift from them.

> **Source authority.** Where this plan and `../02-STORIES/US005.md` differ on **what must be
> true**, the story wins. Where they differ on **the state of the citation gate**, this plan wins
> — see _The citation gate, corrected_ below. On what a documentation file may weigh and how a
> gate's result is reported, `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/GATE-REPORTING.md`
> win over both. On the family's file names, **US001 wins over everything here** — see _Approach_.

---

## Problem Statement

**Nothing in the tree says which layer decides that a failed operation should be attempted again,
and left unsaid the answer is "all of them".** The layers compose multiplicatively: a task
configured with three attempts, calling through an SDK whose transport retries three times, behind
a client that retries three times, issues twenty-seven requests against a provider that is already
failing. Every layer looks locally reasonable; the aggregate is an amplification attack the
project runs against its own supplier, and then against itself when that supplier's rate limiter
starts refusing everything.

**The defaults make this the path of least resistance, not an unlucky accident.** `botocore` ships
`max_attempts` at 3 in standard mode, `urllib3` retries, Celery's `autoretry_for` path retries, and
FastMCP ships a `RetryMiddleware`. A developer who configures nothing gets stacked retries, and
the stack is invisible at every individual call site.

**The written budgets already disagree four ways**, which is what a world with no named owner
produces — `code/docs/api-design/WEBHOOKS.md:86`,
`code/docs/performance/API-AND-MONITORING.md:57`, `project-management/docs/gdpr/COMPLIANCE.md:27`
and `code/docs/TASK-AUTHORING.md:204`. Two of those write `max_retries=3` and look identical while
landing roughly **three minutes** and **roughly nine minutes** apart, because one sets
`default_retry_delay=60` and the other inherits Celery's three-minute default.

**And one guide states the inverse of the rule.** `code/docs/mcp-server/TOOL-DESIGN.md:139-141`
tells its reader that transient failures are retried **server-side** by FastMCP's
`RetryMiddleware`. Node `N-003`'s research confirmed the middleware exists and does what the claim
says — so this is not a stale sentence, it is a live contradiction at a surface boundary.

This is slice `S-02` of `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`, nodes `N-008` to
`N-011`, and **three further slices write against the rules it states with no other source for
them** — `S-04` the example-repair sweep, `S-05` the `retry-discipline.sh` gate whose claims row
pins this doctrine's wording, and `S-06` the live-code fixes.

**The rule is being written before its first caller, which is the cheapest moment it will ever
have.** Measured 27/08, 01/09 and 05/09/2026: `code/src/django/` holds no `self.retry`, no
`autoretry_for`, no `max_retries`, no `retry_backoff`, no `boto3` or `botocore` import and no
`sentry_sdk`. Nothing in this repository retries anything today.

## Reference Documents (code/docs gate map)

| Concern                           | Document                                                                              | What it binds here                                                                          |
| --------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| The family this story writes into | `code/docs/reliability/` — **US001's deliverable, absent today**                      | Every rule lands here; **its file names are US001's, cited by role only**                   |
| Task authoring and the bound      | `code/docs/TASK-AUTHORING.md`                                                         | `:204` requires a bound by attempt count **and** total age; its 4xx-is-permanent class      |
| Webhook delivery                  | `code/docs/api-design/WEBHOOKS.md`                                                    | `:86`'s 5-over-24-hours budget; `:88`'s disable-after-N as the breaker's partial mechanism  |
| API performance budgets           | `code/docs/performance/API-AND-MONITORING.md`                                         | `:57` — plus `:46`, `:69` and `:142`, which the inventory must not miss                     |
| The MCP tool surface              | `code/docs/mcp-server/TOOL-DESIGN.md`                                                 | `:139-141` states the inverse of the owner rule and is repaired or assigned                 |
| Service and middleware shape      | `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`                                    | `:265`'s breaker mandate becomes a pointer; `:252-257`'s Retry column is `S-04`'s           |
| What the code must never allow    | `code/docs/NEGATIVE-SPACE.md`                                                         | `:226` repointed or verified; `:211` gains a prose pointer, **never a sixth column**        |
| Length limit and the ratchet      | `code/docs/DOCUMENTATION-LENGTH.md`                                                   | Nothing born at or above 270; nothing edited crosses it without a dated allowance           |
| Reporting a gate's result         | `code/docs/GATE-REPORTING.md`                                                         | `doctrine-drift.sh` is never reported as having read this story's prose                     |
| Forward-looking claims            | `code/docs/FORWARD-VOICE.md`                                                          | The `OUTBOUND-TIMEOUTS.md` reference is a forward one; a dangling path is fixed, not marked |
| GDPR compliance examples          | `project-management/docs/gdpr/COMPLIANCE.md`                                          | `:22-49` — the whole fence, `:27`'s budget and `:46-48`'s shape together                    |
| Story                             | `../02-STORIES/US005.md`                                                              | Nine scenarios, the acceptance this plan implements                                         |
| Threat model                      | `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` | Twelve findings, five trust boundaries, the promotion-trigger table                         |
| Security assessment               | `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md`    | **Section 7's twelve constraints — carried in below, not re-derived**                       |
| QA                                | `../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`                      | Fifteen resolved AC-gaps, the scenario tables, the measured gate baselines                  |
| Sprint plan                       | `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`                                             | Build order, the `Must` tier, the gate-honesty constraint                                   |
| Feature map                       | `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`                                     | Slice `S-02`, nodes `N-008`–`N-011`; the `S-04` and `S-09` rows this story edits            |

**Not applicable, and why:** `../04-DATABASE/`, `../05-USER-FLOW/`, `../06-BRAND-GUIDE/`,
`../07-COMPONENTS/`, `../08-WIREFRAMES/`, `../09-GDPR/`, `../12-SEO/`, `../13-API-DESIGN/`,
`../14-LOGGING/` — the story's corresponding flags all read `N/A`. It ships Markdown: no model,
endpoint, screen, personal-data path, log line or public page. `../10-SECURITY/` is **not** in
that list and is the first story plan in this repository for which it is not.

## Architecture Decision

**One layer decides per operation; every layer beneath it makes a single attempt.** That is
`ADR-US005-ONE-LAYER-DECIDES-TO-RETRY`, and the deciding factor recorded there is that it is the
only option making the budget a **stated** property rather than an emergent one. A tuned product
of numbers set in different files by different people cannot be read without opening all of them,
cannot be gated because there is no single site to check, and cannot satisfy the total-age bound
`TASK-AUTHORING.md:204` already requires — because the inner layers' waits are invisible to the
outer one.

**Fixing the owner structurally — always the outermost layer — was rejected and the reason is
load-bearing here.** Two settled surfaces contradict it: a served surface must **not** retry
inbound work, which is why `MANAGEMENT-COMMANDS.md:103-104` gives the CLI's repeat to its caller
and exit 75 is its expression. Making the outermost layer the owner inverts both.

**The cost is accepted, not hidden.** Clamping an SDK's retries off discards resilience the vendor
wrote, tested and ships on by default, and a transport-level retry genuinely is better placed than
an application-level one for a dropped TCP segment or a stale pooled connection. Three things pay
for it: the escape hatch is a register row rather than a rewrite, there is no wired SDK client in
the tree to take anything away from, and the amplification it prevents arrives exactly when the
system is least able to absorb it.

### The clamp's correct form is the rule's only concrete literal, and the first one was wrong

| Route                                | What `max_attempts` counts | `max_attempts = 1` means | Single attempt is       |
| ------------------------------------ | -------------------------- | ------------------------ | ----------------------- |
| `Config(retries={...})`              | **Retries only**           | Two attempts             | `total_max_attempts: 1` |
| `AWS_MAX_ATTEMPTS` / AWS config file | **Including the initial**  | One attempt              | `max_attempts = 1`      |

**The same identifier means the other thing by another route**, and the doctrine has to say so.
The consequence is not stylistic: an unconfigured client can be reconfigured by an environment
variable the application never set, and only an explicit `retries` dict at the constructor takes
precedence over that route. **That is what makes "every client constructor sets its attempt count
explicitly" a control rather than a preference** — and it is the sentence a later
`retry-discipline.sh` will be written against.

Found by the QA gate as `AC-GAP-1` and corrected in place on 05/09/2026 across the ADR,
`../02-STORIES/US005.md` and the map's `N-008`. **Corrected, not superseded** — the ADR reads
`Status: Accepted` and `../15-DECISIONS/CLAUDE.md` makes that immutable, but the immutability rule
protects a decision a reader may have relied on and this one had not reached a commit.

### Where the rules go, and why this plan will not name a file

`code/docs/reliability/` does not exist, and **its file names are decided inside US001, with the
reasoning in the family's own `CONTEXT.md`** — `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`
declines to name them too, so there is nothing to inherit provisionally and a guessed map would
be a set of dead links. Every placement below is stated by **role**, and the directory name is the
one path token this story may commit to.

The story already distinguishes two roles, and the distinction is kept:

| Rule                                                   | Lands in                   |
| ------------------------------------------------------ | -------------------------- |
| The single-owner rule, the SDK clamp, the escape hatch | **the retry guide**        |
| The `Retry-After` rule and its clamp                   | the retry guide            |
| The budget table and its derived worst-case column     | the retry guide            |
| The circuit-breaker deferral                           | **the reliability family** |

**P1 opens by reading the family's `CONTEXT.md` to resolve those two roles onto real files.** That
read is the first task of implementation, not a planning assumption.

## Approach

### Not applicable — Database, Service Layer, API, Frontend

This story adds no Python, no template and no component. The four layer sections the template
carries are dropped because the story touches none of them, not to dodge a gate.

### Phase plan — five phases

| Phase | Deliverable                                                                         | Blocked by    |
| ----- | ----------------------------------------------------------------------------------- | ------------- |
| P0    | The retry-statement inventory, captured **before any edit**                         | US001 landing |
| P1    | The four rules, into the family US001 created                                       | P0            |
| P2    | The four budget contradictions repaired against the table                           | P1            |
| P3    | The three pointer repairs — breaker mandate, environment-error row, the MCP inverse | P1            |
| P4    | The map edits, and the deferral this story hands to `22`                            | P2 · P3       |

**P0 — the inventory, and it expires.** Every retry statement in every file this story touches is
inventoried before any of them is edited, each marked **resolved-here**, **resolved-by-US001** or
**`S-04`'s**, with none unaccounted for. Two traps the QA gate found:

- **The count is four, not three.** `WEBHOOKS.md:86`, `performance/API-AND-MONITORING.md:57`,
  `gdpr/COMPLIANCE.md:27` and `TASK-AUTHORING.md:204`. The map counts statements; the defect is a
  count of worst cases, and the two `max_retries=3` sites land ~3 min and ~9 min apart.
- **The file list is longer than the four.** `performance/API-AND-MONITORING.md` carries three
  further statements at `:46`, `:69` and `:142` — **`:142` sits outside the section US001 reduces**
  and so survives as a retry rule stated away from the family. And
  `architecture/SERVICE-AND-MIDDLEWARE.md:252-257` is a task-type table with a **Retry** column, in
  a file this story edits at `:265`, whose reduction the map assigns to `S-04`.

**The "before" is destroyed by the blocker, not by this story.** US001 reduces the section holding
two of the four, so **US001's landing state is recorded beside the inventory** — a reader cannot
otherwise reconstruct which state was measured, and the disposition of two budgets changes with
it.

**P1 — the four rules.** Placement by role, per the table above.

- **The owner rule.** Exactly one layer decides; every layer beneath makes a single attempt. SDK
  transport retries clamped off by default, naming `retries={"total_max_attempts": 1}` as the
  worked form and stating the configuration-source divergence. A client keeping transport retries
  does so through a row in the outbound timeout register naming the delegation and its reason, on
  the `DICT-OK:` escape-hatch pattern the project already uses. Served surfaces never retry
  inbound work, naming FastMCP's `RetryMiddleware` as deliberately unwired and exit 75 as the CLI
  expression — **and the caller's own obligation to bound the repeat it now owns**, with inbound
  rate limiting named as a dependency this tree does not have rather than assumed. **A layer may
  only repeat an operation it can show is idempotent**, by the family's own rule once `S-03` ships
  and by `TASK-AUTHORING.md`'s proof ladder until then. The guide cites the ADR by full path.
- **The `Retry-After` rule.** Wait `max(backoff, Retry-After)`, never past the row's total-age
  ceiling; **a header beyond the remaining budget means exhausted — park the work, never sleep
  past the bound.** The clamp and the exhausted case are stated **in the same breath as the
  honouring**, never as a later caveat. `Retry-After` is untrusted input controlling how long a
  worker sleeps, so the clamp is a control. The classification carves **429 and 503 out of the
  permanent class explicitly**, because `TASK-AUTHORING.md` calls a 4xx permanent and a
  `Retry-After` arrives on a 429 — without the carve-out a reader can satisfy both rules and still
  be wrong. And the one sanctioned manual form is named: the declarative `autoretry_for` path
  cannot read a response header to extend its own wait, so honouring `Retry-After` on Celery needs
  the manual call, with `retry_backoff_max` still capping the interval.
- **The budget table.** Defaults are **Celery's own, taken declaratively** — the `autoretry_for`
  path, 3 attempts, exponential from 1 s, a 600 s interval cap, jitter on. _Attempt_ is defined
  **once**, stating which parameter carries which count: Celery's `max_retries` counts retries, so
  `max_retries=3` is four attempts and three attempts is `max_retries=2`. A derived worst-case
  total-age column is stated **as a formula, never a number copied once**, and the formula states
  its own assumption that inner-layer attempts equal one. Manual `self.retry` is banned **as the
  routine environment-error path** — narrowed from an outright ban so it does not contradict the
  sanctioned `Retry-After` form. The webhook 5-over-24-hours budget is a recorded **per-row
  override** stating **every parameter it changes**, so its worst case is recomputable without
  reading another document, with what makes an override legitimate stated beside it. A delegating
  row records the delegated attempt count and interval **as numbers**, never "the vendor default".
  The attempt log records **attempt number, elapsed budget and error class** — never the exception
  message, the request URL or the provider body, because a presigned URL in a log line is a
  credential and N attempts write it N times. And the one staleness escape hatch — a timestamp
  argument or a per-message `expires` — is stated with the condition that makes it **mandatory**
  rather than merely available.
- **The breaker deferral**, in the house deferral-with-trigger form, with **both** triggers: the
  first incident where bounded retries against a live provider degrade service, or the story
  integrating a second rate-limited external API. It names `WEBHOOKS.md:88`'s existing
  disable-after-N-failures rule as the partial mechanism already in the tree, so the deferral does
  not read as a contradiction.

**P2 — the four contradictions.** All four resolve against the single table, by agreeing with it
or by citing it instead of restating it. The two `max_retries=3` sites must stop landing on
different worst cases. No guide is left stating a budget the table does not sanction, and the
total-age requirement is stated in a form Celery can actually satisfy — `retry_backoff_max` caps
the **interval between attempts**, not the length of the chain.

**The GDPR fence is repaired whole, not half.** `gdpr/COMPLIANCE.md:22-49` is one fence claimed by
two slices — this story's budget at `:27` and `S-04`'s bare-`except` shape at `:46-48`. This story
takes all of it, and `S-04`'s scope drops from four bad examples to three. The repaired fence
demonstrates the declarative `autoretry_for` shape with a sanctioned budget, **and its exception
tuple names specific transient types and excludes permanent failures** — `autoretry_for=(Exception,)`
is retry-everything in declarative clothing and does not satisfy this, which is the hole
`AC-GAP-9` found after this story absorbed the fence.

**P3 — three pointer repairs.**

- `architecture/SERVICE-AND-MIDDLEWARE.md:265` — the breaker mandate becomes a **pointer**, and a
  reader who opens it cold reaches the deferral in one hop.
- `NEGATIVE-SPACE.md:226` — points at the reliability family. **US001 also repoints this line**, so
  one of the two stories finds the work done: this story **reads the line's content and verifies
  it**, never assumes it, and makes no second repoint. The `:211` environment-error row gains its
  retry-owner pointer **in prose, never as a sixth column**.
- `mcp-server/TOOL-DESIGN.md:139-141` — either states the rule this story states, **or** the map
  records a named slice that owns its repair, with the assignment written into
  `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`. **A story that ships doctrine while leaving a
  guide stating its inverse has not repaired the fence.** This is the security gate's TM-08 and
  the QA gate's `AC-GAP-8`, and it is the one finding raised to the story on coherence rather than
  on severity.

**P4 — the map, and the one thing this story does not write.** The `S-04` row records that its
example count has dropped to three. `S-02` records this story's number and describes only the
doctrine half; the new `S-09` row carries `N-012` and the `OUTBOUND-TIMEOUTS.md` register with its
own flag manifest, so no deliverable is left without a slice.

**`DEFERRED.md`'s unenforced-window entry is required by this story and written by `22`.** The
rule ships and `retry-discipline.sh` does not; the entry names slice `S-05` as owner and the first
client-wiring story as its deadline. `REFERENCES.md`'s ownership table gives `DEFERRED.md` writes
to `22-implementation-documentation` — so this plan states the obligation and the closing gate
performs it. Recorded here because a story that assumes it may write its own register entry
produces two owners for one file.

### The citation gate, corrected

**Two baselines are in circulation and the story is not the source of the larger one.**
`../02-STORIES/US005.md` reads its checks against **53** (measured 04/09/2026, at `:367` and
`:437`); the **56** belongs to `../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`
Section 7 and to `../03-SPRINTS/SPRINT-03.md`, and the difference is US005's own three artefacts.
Both are honest; neither site says which one the closing check uses, and **this plan settles it:
diff against a figure measured in the same git-index state as the run, and record that state
beside it** — the numbers below, not either inherited one. **By the time this story is worked, most of that is
obsolete, and the reason is build order.**

| Class                             | Count | Cleared by   | Landed before US005?             |
| --------------------------------- | ----- | ------------ | -------------------------------- |
| `code/docs/reliability/`          | 7     | US001        | **Yes** — SPRINT-01, exec `01`   |
| `[template-only citation]` sweep  | many  | US004        | **Yes** — SPRINT-02, exec `02`   |
| `code/docs/ABSENCE.md`            | 2     | US003        | Same sprint, `Should` — may slip |
| `how-to/src/OUTBOUND-TIMEOUTS.md` | 4     | slice `S-09` | **No** — not yet a story         |

US001 is this story's own blocker, so the family exists before a line is written and the seven
forward references resolve on arrival. US004 sits in SPRINT-02 at execution order `02`, which satisfies the **first half** of
`ADR-US003-CITATION-GATE-BASELINE-DIFF`'s retirement condition. **Read that condition as written,
because it is conjunctive and the second half will not hold here:** the record retires when `S-06`
lands _and the gate goes green_, and the gate will not be green — correct forward references
survive, named below. The ADR also says a **new record should supersede it rather than it being
edited**, so the retirement is not automatic and nobody has written that record yet. Treat the
baseline discipline as still in force and the diff as still required. So:

- **The surviving class is the `how-to/src/OUTBOUND-TIMEOUTS.md` forward reference**, four of them,
  owned by slice `S-09` — which runs _beside_ this story and shares no file with it. Each is named
  with its owner; none is deferred.
- **A plain pass is still unavailable**, and for a smaller reason than the story states: four
  correct forward references remain, and `code/docs/GATE-REPORTING.md` forbids reporting that as
  clean.
- **If US003 has not landed**, two `code/docs/ABSENCE.md` references survive as well. Count them
  and name them; do not treat the number as wrong.
- **If this story is somehow worked ahead of US001 or US004**, it cannot be — US001 is a hard
  content blocker. Should US004 slip behind it, the story's original baseline procedure applies
  unchanged, and the index state is recorded beside every figure because the QA plan measured a
  **24-finding swing** between the same bytes untracked and tracked.

**Measured at planning time, so the implementer inherits a figure rather than an estimate.** Run
05/09/2026 with this plan and `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` present and **untracked**:
**151 tree-wide** — 67 `[dangling path]`, 60 `[template-only citation]`, 24 `[instance citation]`.
This plan's own contribution is **32**, the sprint plan's **37**.

| Class                      | This plan | Cause                                                                                     |
| -------------------------- | --------- | ----------------------------------------------------------------------------------------- |
| `[template-only citation]` | 20        | Citations of tracked, copier-excluded PM artefacts. **Every one clears on commit**        |
| `[dangling path]`          | 12        | The reliability family (US001), the outbound timeout register (`S-09`), and US003's guide |
| `[instance citation]`      | 0         | Every map and story cited by full relative path                                           |

**Count the finding lines, not the grep hits.** The script prints its own explanatory footer, and
that footer contains the literal strings `[template-only citation]` and `[dangling path]` — so a
naive `grep -c` over the whole output over-reads by one or two and the classes stop summing to the
total. The first measurement taken for this plan made exactly that mistake and reported a
breakdown summing to 152 against a stated 151. **The figures above sum: 67 + 60 + 24 = 151**, and
were taken after this plan's own review corrections, not before them.

The `[instance citation]` class is the one to watch when editing either plan: **four bare `MAP-*`
tokens were introduced in the sprint plan's _Won't_ list at first draft and corrected the same
day.** A bare `US###` or `MAP-*` token in backticks trips the check; the full relative path does
not. Bare `ADR-*` tokens do not trip it — measured, and consistent with the sibling plans.

**Do not silence the template-only class with `doc-references: template-only` markers.** The marker
sets the gate's naming-row flag and suppresses the dangling-path record; `code/docs/FORWARD-VOICE.md`
reserves it for a citation that is right and merely unprovable downstream, and a dangling citation
is **fixed rather than marked**. That is the misuse `AC-GAP-12` removed from the story itself.

## Key Decisions

| Decision                                      | Chosen                                                      | Rejected                                             | Why                                                                                                                                                                  | Reference                              |
| --------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| Which layer owns a repeat                     | One named owner per operation                               | Tuned product across layers; or always the outermost | Only a named owner makes the budget stated rather than emergent, and gateable at one site                                                                            | `ADR-US005-ONE-LAYER-DECIDES-TO-RETRY` |
| The worked SDK clamp                          | `retries={"total_max_attempts": 1}`                         | `max_attempts: 1`                                    | In a `Config` object `max_attempts` counts **retries**, so `1` permits two attempts and clamps nothing                                                               | ADR → _The clamp's correct form_       |
| Which of the two correct forms the rule names | `total_max_attempts`                                        | `max_attempts: 0` — correct, but not named           | Both clamp to one attempt. `total_max_attempts` exists only on `Config` and **always counts total requests**, so it reads the same whatever the configuration source | ADR → _The clamp's correct form_       |
| Whether an explicit `retries` dict is a rule  | A control, mandatory at every constructor                   | A style preference                                   | `AWS_MAX_ATTEMPTS` can reconfigure an unconfigured client; only the explicit dict outranks that route                                                                | `AC-GAP-1`                             |
| How the family's files are named here         | By **role** only                                            | A provisional filename map                           | US001 decides them in its own `CONTEXT.md`; a guessed map ships dead links                                                                                           | `../02-STORIES/US001.md`               |
| The budget table's defaults                   | Celery's own, taken declaratively                           | Numbers invented for the table                       | A default a reader can verify against the framework beats one only this guide asserts                                                                                | `../02-STORIES/US005.md` scenario 3    |
| The worst-case column                         | A formula, stating its inner-layer assumption               | A number computed once and copied                    | A copied number cannot be recomputed by hand, and the hand recomputation is the only check on it                                                                     | `AC-GAP-6` · `AC-GAP-10`               |
| The manual `self.retry` ban                   | Narrowed to the routine environment-error path              | An outright ban                                      | An outright ban contradicts the one `Retry-After` form Celery can actually honour                                                                                    | `AC-GAP-4`                             |
| The webhook 5/24 h budget                     | A recorded per-row override stating every parameter         | Reconciled down to the table's default               | 5 attempts under the defaults is minutes, not a day; the override is legitimate and must stay recomputable                                                           | `AC-GAP-10`                            |
| 429 and 503                                   | Carved out of the permanent class explicitly                | Left to the reader to reconcile                      | A 429 is a 4xx and carries `Retry-After`; without the carve-out both rules can be satisfied and still be wrong                                                       | `AC-GAP-5`                             |
| The GDPR fence                                | Repaired whole by this story                                | Split with `S-04` along the line boundary            | A knowingly incoherent worked example is worse than a widened scope; `S-04` drops to three                                                                           | `../02-STORIES/US005.md` scenario 5    |
| `mcp-server/TOOL-DESIGN.md:139-141`           | Repaired here **or** assigned to a named slice on the map   | Left standing                                        | Shipping doctrine beside a guide stating its inverse has not repaired the fence                                                                                      | TM-08 · `AC-GAP-8`                     |
| Where the unenforced window is recorded       | `DEFERRED.md`, written by `22-implementation-documentation` | Written by this story                                | `REFERENCES.md`'s ownership table gives that register's writes to `22`                                                                                               | TM-02                                  |

## Dependencies

| Story | Deliverable it owns                      | Required for                                       | Current state |
| ----- | ---------------------------------------- | -------------------------------------------------- | ------------- |
| US001 | `code/docs/reliability/` — the family    | **Every rule this story writes.** Hard blocker     | `Open`        |
| US004 | The citation gate's git-index repair     | The gate regime this plan's citation section reads | `Open`        |
| US003 | `code/docs/ABSENCE.md`                   | Nothing here — co-member only, no shared file      | `Open`        |
| US002 | `code/src/scripts/audits/` register room | Nothing here                                       | `Open`        |

**The `Current state` column is the one the parallel-worktree DAG reads**, and every row is `Open`
today — which is why this plan's own status is `Blocked` rather than a judgement call.

- **Blocked by:** **US001**, absolutely. Not build order — the target directory does not exist,
  and US001 is itself SPRINT-01's second story, behind US002. US005 sits three stories deep in the
  chain.
- **Blocks:** slices `S-04`, `S-05` and `S-06` on
  `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`. `S-05`'s claims row pins this doctrine's
  exact wording, so a change to the phrasing after `S-05` ships is a gate edit, not a prose edit.
- **Runs beside, blocks neither:** slice `S-09` — the `OUTBOUND-TIMEOUTS.md` register, split out of
  `S-02` at story creation. It is measurable against today's tree and waits on nothing; this story
  waits on the family. **They share no file**, which is what makes the delegation escape hatch a
  forward reference rather than a collision.
- **Runs beside, and holds the other half of the rule:** slice `S-03` — idempotency doctrine, not
  yet cut into a story. `TASK-AUTHORING.md` states that retries and idempotency are one rule seen
  twice and that a task which is not idempotent cannot safely be retried at all. This story writes
  the retry half for **every** surface, including the HTTP clients and the CLI where no Celery
  machinery makes idempotency implicit — so it states the precondition and names where the proof
  lives, and `S-03` states the mechanism.
- **Can be done now:** **nothing.** This is the honest answer and the reason the status reads
  `Blocked`. P0's inventory is the first startable task and even it wants US001's landing state
  recorded beside it, so running it early buys a measurement that must be re-taken.

## GDPR

**Not applicable.** The `GDPR` flag reads `N/A`. The story ships Markdown; no personal data is
read, written, described or logged. Section dropped rather than filled with "none" per row.

**One adjacent thing is not GDPR and should not be filed as it.** The attempt-log rule excludes the
request URL and the provider body from an attempt log — that is a credential-leakage control
(TM-05, `A09:2025`), not a personal-data one, and it belongs to the Security section below.

## Security

**Live, and it is the first story plan in this repository whose Security section is not `N/A`.**
Twelve findings across **five of the six STRIDE categories** — elevation of privilege is recorded
as considered-and-not-applicable, because no principal changes hands in a retry — over five trust
boundaries, **eleven `INFO` and one `LOW`** — nothing CRITICAL or HIGH, so nothing blocked sprint planning and nothing was escalated to
`../10-SECURITY/VULNERABILITIES/PLANNING/`.

**No endpoint, no mutation, no protected action** — so the template's permission-check and IDOR
rows have no subject. That is not the same as saying the story has no security content: **these
are threats to what the doctrine licences later**, not to a surface it adds now.

**The twelve developer constraints are carried in from
`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` Section 7 and
are not re-derived or restated here.** Each is a constraint on **the doctrine's wording**, because
wording is all this story ships **bar the last, which is a task that outlives the document**. Each
of the other eleven is checkable by reading the shipped guide. One row per Section 7 item, in its
order:

| #   | Constraint source    | Discharged in                                                      |
| --- | -------------------- | ------------------------------------------------------------------ |
| 1   | TM-01 · TM-02        | P1 — every client constructor sets its attempt count explicitly    |
| 2   | TM-01 · TM-10        | P1 — the worst-case formula states its inner-layer assumption      |
| 3   | TM-03                | P1 — the `Retry-After` clamp, stated with the honouring            |
| 4   | TM-04                | P1 — the idempotency precondition on the owner rule                |
| 5   | TM-05 · TM-07        | P1 — the attempt-log rule, both what is and is not recorded        |
| 6   | TM-06                | P1 — the webhook override's delivery identifier and signature note |
| 7   | TM-08                | P3 — the MCP inverse, repaired or assigned                         |
| 8   | TM-09                | P1 — the caller's bounding obligation and the named dependency     |
| 9   | TM-10                | P1 — a delegating row records numbers, not "vendor default"        |
| 10  | TM-11                | P1 — the breaker deferral with both triggers                       |
| 11  | TM-12                | P1 — the staleness escape hatch and what makes it mandatory        |
| 12  | TM-02 (the live one) | P4 — `DEFERRED.md`, written by `22`                                |

**Twelve, and the split matters.** `../03-SPRINTS/SPRINT-03.md` counts them as eleven wording
constraints plus the one task that outlives the document, which is the same set described two
ways. An earlier draft of this plan wrote "eleven" and folded rows 1 and 2 together — both are
TM-01's, but they are separate obligations and the assessment gives each its own line.

**Every severity above expires, and the plan must not be read as though they were stable.** Each
`INFO` is a fact about a tree in which nothing outbound retries, measured 05/09/2026. The
promotion-trigger table in
`../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` Section 3a
puts **three rows at design-state `HIGH`** — TM-01, TM-02 and TM-04 — and each names the story
that will meet it. **The promotion is not this story's to perform.**

**The assessment's own summary says four, and it is wrong**: it enumerates "TM-01, TM-02, TM-04
and TM-02's early-wiring case", but that fourth item is TM-02's own row, whose trigger cell
already carries the early/late split. Three rows in Section 3a read `**HIGH**`. Recorded here
rather than propagated, and left for the assessment's own gate to correct.

**Two baselines deliberately do not reach this story**, and the skip is recorded rather than the
rows left blank: NIST SP 800-53 control depth applies to an implemented control and this story
implements none, and UK Cyber Essentials / CE+ cover running infrastructure this story does not
change. Both re-engage at the first story that wires a client — the same trigger as TM-01.

## Logging & Observability

**Not applicable as a flag** — the `Logging` flag reads `N/A` and the story adds no log line and
wires no sink.

**It does specify one, and the distinction matters.** The attempt-log rule states what an attempt
log must record and what it must never record; nothing in this story creates that log. `DE` is
the weakest NIST function in the assessment and honestly so — there is no `sentry_sdk.init()`, no
attempt-level line and no metric — and the story states the shape a future line must take rather
than taking it. Wiring is slice `S-06`'s and the first story with a retry owner.

## Performance, Rendering, Responsive & Accessibility

**Not applicable** — no rendered surface, no route, no upload, no user-owned table, so the
scale-readiness row has no subject either.

**One readability property is load-bearing rather than tidy:** a developer must be able to compute
an operation's worst-case total age from the budget table's own row, without opening a second
document. That is what the formula-not-a-number decision and the every-parameter override rule
both exist for, and it is what the hand recomputation checks.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✅ → `10-security-checks` ✅ → `11-qa-checks` ✅ → `15-decisions` ✅ →
`03-sprint-planning` ✅ → `16-sprint-plans` ✅ → **`17-story-plans` (this document)** → the lane
below → `22-implementation-documentation` → `23-pr-and-review`.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` all read `N/A`; the
story's `Backend`, `API` and `Frontend` flags say so.

**`10-security-checks` ran before `03-sprint-planning`**, which is the cadence's order and worth
naming because it is why the security gate could widen the story's Security flag and recompute
SPRINT-03's union before the sprint plan was written.

### Standards gates

Every command through `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`, `pytest` or
`docker` call. British English, DD/MM/YYYY, the U+00A7 ban and plain-ASCII punctuation per
`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2. Cross-artefact citations by full
repo-relative path per `ADR-US001-INSTANCE-CITATION-UNVERIFIED` — which **supersedes**
`ADR-US001-INSTANCE-CITATION-FULL-PATHS`, keeping its form and deleting its justification, so the
superseded record is not the one to cite.

## Testing

**No automated suite** — the story ships no code path, so `tests/all.sh --coverage` and
`migrate.sh check` are `N/A` with a reason rather than skipped boxes, and no coverage floor
applies. Three gates and three human checks stand in for it.

| Check                                | What it proves                                                                                      |
| ------------------------------------ | --------------------------------------------------------------------------------------------------- |
| `docs-length.sh`                     | Nothing born at or above 270; nothing edited crosses it without a dated allowance                   |
| `doc-references.sh`                  | No new dangling citation; the four `OUTBOUND-TIMEOUTS.md` survivors named with `S-09`               |
| `doctrine-drift.sh`                  | Registered fenced-code claims still resolve to one home each — **regression guard only**            |
| Hand recomputation                   | The derived worst-case column matches the table's own parameters                                    |
| Human read-across                    | No budget stated in two homes; no guide stating the inverse of the owner rule                       |
| Cold-read of the two repointed lines | `SERVICE-AND-MIDDLEWARE.md:265` reaches the deferral in one hop; `NEGATIVE-SPACE.md:226` reads true |

**`doctrine-drift.sh` reads fenced code only**, and this story's doctrine is prose. A green run
says the registered claims are undisturbed and says **nothing** about retry doctrine appearing in
two places. Per `ADR-US001-PROSE-DOCTRINE-VERIFICATION` and `code/docs/GATE-REPORTING.md`, it is
never reported as though it had.

**The recomputation is the only thing that tests the formula, and no script does it.** Do it by
hand on a **default row and on the webhook override row**, and write **both arithmetic strings
out** — a recomputation whose working is not recorded is indistinguishable from one nobody did.

**The read-across covers six guides**, two of which the QA gate added on 05/09/2026:
`TASK-AUTHORING.md`, `performance/API-AND-MONITORING.md`, `api-design/WEBHOOKS.md`,
`gdpr/COMPLIANCE.md`, and — added as `AC-GAP-14` and `AC-GAP-8` — `mcp-server/TOOL-DESIGN.md` and
`architecture/SERVICE-AND-MIDDLEWARE.md`.

**A tester other than the author signs the walk-through off**, and the before/after budget
inventory is recorded in `../18-TESTS/US005-MANUAL-TESTING.md` with all four accounted for.

## Documentation Write-Ups (Implementation Records)

`22-implementation-documentation` owns the records and writes `../18-TESTS/US005-TEST-STATUS.md`
and `../18-TESTS/US005-MANUAL-TESTING.md`. **It also owns this story's one register write** — the
`DEFERRED.md` unenforced-window entry naming slice `S-05` as owner and the first client-wiring
story as its deadline.

## CONTEXT.md & Index Updates

| File                                              | Change                                                                                                                                         |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/reliability/CONTEXT.md`                | **Read first**, to resolve the two placement roles onto real files. Edited only if a new file is added                                         |
| `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` | `S-02` records this story and describes the doctrine half only; `S-04`'s example count drops to three; `S-09` carries `N-012` and the register |
| `code/REFERENCES.md` · root `REFERENCES.md`       | **No new row** unless P1 adds a file to the family — US001 owns the family's index rows                                                        |
| `DEFERRED.md`                                     | The unenforced window — **written by `22`, not by this story**                                                                                 |
| `../17-STORY-PLANS/CONTEXT.md`                    | **No Plans Index row** — see below                                                                                                             |

**There is no Plans Index row, and it is a decision.** The index eight artefacts already cite has
never existed. `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice `S-01` **creates
`../17-STORY-PLANS/STORY-PLAN-INDEX.md`** — the file all eight citations should have named — and
repoints them. The claim lives on that map's _Register claimed_ table, **not** on `GAPS.md` — the
entry was re-triaged off that register and the map is now its only home, so a reader sent to
`GAPS.md` for it finds nothing. Adding an index here would pre-empt a claimed slice and create a
ninth citation of a surface about to be named otherwise.

## Deferred Items

- **The enforcement.** `retry-discipline.sh` is slice `S-05`'s. Until it ships, a client added
  without an explicit clamp silently inherits the vendor default — **the one failure mode this
  decision creates rather than removes.** Recorded in `DEFERRED.md` at ship by `22`, naming `S-05`
  as owner and the first client-wiring story as its deadline.
- **The delegation escape hatch is inert until `S-09` ships.** The rule names a register row to
  write into, and `how-to/src/OUTBOUND-TIMEOUTS.md` does not exist yet. The exception path is
  stated and unusable, which is correct and must be said rather than discovered.
- **The idempotency half** — slice `S-03`, not yet a story. This story states the precondition and
  names `TASK-AUTHORING.md`'s proof ladder as where the proof lives until then; it does not close
  it.
- **Inbound rate limiting** — no story owns it. TM-09 names it as a dependency of the
  served-surface rule rather than claiming it.
- **The live-code fixes** — jittered health TTLs, Valkey socket timeouts, the ClickUp `urlopen`
  timeout — slice `S-06`'s.
- **`architecture/SERVICE-AND-MIDDLEWARE.md:252-257`** — the task-type table's Retry column. The
  inventory catches it and dispositions it; `S-04` reduces it.

## Risks

| Risk                                                                        | Mitigation                                                                                                                        |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| US001 lands with a family shape the role-only placement does not fit        | P1 opens by **reading the family's `CONTEXT.md`** and resolving roles onto real files before writing a line                       |
| The inventory is captured after US001 lands and measures the wrong "before" | US001's landing state is recorded **beside** the inventory; the disposition of two budgets changes with it                        |
| The worst case is not hand-recomputable on the override row                 | The override states **every parameter it changes**; the recomputation covers a default row and the override row, both written out |
| The MCP inverse is left standing because it is not this story's file        | The criterion accepts a named slice assignment **written into the map** — but not silence                                         |
| `S-05`'s gate is written against wording this story later rephrases         | The doctrine's phrasing is pinned by `S-05`'s claims row; a later rewording becomes a gate edit and is flagged as one             |
| `TASK-AUTHORING.md` crosses 270 as this story edits it                      | US001 **reduces** it first — the 266 measurement predates that migration. Re-measure rather than inherit the figure               |
| The gate figures in the story are read as current                           | _The citation gate, corrected_ states what build order has already cleared; the story's 56 is a pre-US001, pre-US004 number       |
| The `INFO` severities are read as a clean security result                   | The design-state table and its four `HIGH`s are cited beside every severity claim, per `code/docs/GATE-REPORTING.md`              |

## Definition of Done

- [ ] The inventory is captured **before any edit**, with US001's landing state beside it, and it
      balances — every statement resolved-here, resolved-by-US001 or `S-04`'s
- [ ] The four rules are stated in the family: the owner rule with the SDK clamp and the escape
      hatch, the clamped `Retry-After` rule, the budget table, the breaker deferral
- [ ] The clamp is written `total_max_attempts: 1`, and the configuration-source divergence is stated
- [ ] _Attempt_ is defined once; the worst-case column is a formula stating its own assumption
- [ ] The webhook override states every parameter it changes, and recomputes by hand
- [ ] The idempotency precondition, the attempt-log rule and the caller's bounding obligation are
      all stated, each naming its dependency rather than assuming it
- [ ] 429 and 503 are carved out of the permanent class where the classification states it
- [ ] All four budget contradictions resolve against the table; the two `max_retries=3` sites no
      longer land ~3 min and ~9 min apart
- [ ] The whole `gdpr/COMPLIANCE.md:22-49` fence is repaired, with a specific exception tuple
- [ ] `SERVICE-AND-MIDDLEWARE.md:265` is a pointer; `NEGATIVE-SPACE.md:226` reads true and `:211`
      gained prose, not a column
- [ ] `mcp-server/TOOL-DESIGN.md:139-141` is repaired, or assigned to a named slice on the map
- [ ] The map's `S-02`, `S-04` and `S-09` rows are correct, and no deliverable lacks a slice
- [ ] Three gates run and are recorded; none is reported as having checked prose
- [ ] The read-across across six guides and the two cold-reads are done and recorded
- [ ] A tester other than the author has signed the walk-through off
- [ ] `DEFERRED.md` carries the unenforced-window entry, written by `22`
- [ ] Status propagated to every artefact that carries it — `../02-STORIES/US005.md`, **this plan's
      own header** (off `Blocked`), `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`'s Story Plans row and
      `../03-SPRINTS/SPRINT-03.md`'s Story Summary. **This plan is the first to carry `Blocked`, so
      it is the first whose own header needs clearing** — the template's propagation line also
      names a Plans Index, which does not exist (see _CONTEXT.md & Index Updates_)
- [ ] Reviewed and approved; merged
