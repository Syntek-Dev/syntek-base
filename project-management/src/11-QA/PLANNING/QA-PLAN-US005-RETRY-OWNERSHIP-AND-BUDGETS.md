# QA Plan — US005 Exactly one layer decides to retry

| Field         | Value                                                                                  |
| ------------- | -------------------------------------------------------------------------------------- |
| **Story**     | US005 — Exactly one layer decides to retry, and every budget says how long it may take |
| **Date**      | 05/09/2026                                                                             |
| **Sprint**    | SPRINT-03 — retry doctrine gets its single owner                                       |
| **Wireframe** | N/A — this story ships Markdown, not a screen                                          |
| **Status**    | Signed off                                                                             |

<!-- Signed off 05/09/2026 once AC-GAP-1 closed. It was [OPEN] for part of this session
     because closing it needed a decision about an already-Accepted ADR that is not this gate's
     to take; the route was settled the same day — corrected in place, not superseded — and the
     gap moved to [RESOLVED]. No [OPEN] gap remains, so 16-sprint-plans is unblocked. -->

---

## 1. Acceptance criteria gaps

**Fifteen gaps found. All fifteen were resolved into
`project-management/src/02-STORIES/US005.md` on 05/09/2026. Nothing blocks `16-sprint-plans`.**

- **AC-GAP-1** `[RESOLVED]` — **the story's one worked code literal was wrong, and it was the
  rule's only concrete form.** Scenario 1 required the guide to name `boto3`'s
  `retries={"max_attempts": 1}` as the worked clamp. Verified against the vendor documentation
  05/09/2026: in a `Config` object `max_attempts` **excludes** the initial request, so
  `max_attempts: 1` is one initial request plus one retry — **two attempts, not one** — and the
  rule that "every layer beneath makes a single attempt" was breached by its own example. The
  single-attempt forms are `retries={"total_max_attempts": 1}` or `max_attempts: 0`. The same page
  records a second trap the doctrine now states: set through `AWS_MAX_ATTEMPTS` or the AWS config
  file, `max_attempts` **includes** the initial request, so the identical name means different
  things by configuration source — and an unconfigured client can be reconfigured by an
  environment variable the application never set. That is what makes "every client constructor
  passes an explicit `retries` dict" a control rather than a style preference: only the explicit
  dict takes precedence over that route. **Resolved by correction in place, not supersession.**
  The literal also sat in
  `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` (twice)
  and in `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` node `N-008`, and
  that ADR reads `Status: Accepted`, which
  `project-management/src/15-DECISIONS/CLAUDE.md` makes immutable. The immutability rule protects a
  decision a reader may have relied on; this one had not reached a commit, so nobody could have.
  Settled 05/09/2026: corrected across all three in one pass, each carrying a dated correction
  note, and the ADR gains a _The clamp's correct form_ section stating the vendor semantics. Added
  to `project-management/src/02-STORIES/US005.md` on 05/09/2026.
- **AC-GAP-2** `[RESOLVED]` — **the story shares a target file with its own blocker and does not
  say so.** `code/docs/NEGATIVE-SPACE.md:226` is repointed by US001 (its Scenario 5) _and_ by this
  story (its seventh scenario). One of the two will find the line already moved. Resolved: the
  scenario now states the repoint as conditional on US001's landing state and requires the story
  to verify the line's content rather than assume it. Added to
  `project-management/src/02-STORIES/US005.md` on 05/09/2026.
- **AC-GAP-3** `[RESOLVED]` — **an orphan task whose evidence expires.** "Record the four
  competing budgets and their worst cases **before** any of them is edited" is the first
  documentation task and no acceptance criterion demanded it, breaching the story's own "all tasks
  map directly to an acceptance criterion". Worse, the "before" state is destroyed by US001, which
  reduces the section holding two of the four — so capturing it after US001 lands captures the
  wrong thing. Resolved: a criterion now requires the inventory, and requires it captured against
  the tree **as US005 opens**, with US001's landing state recorded beside it. Added on 05/09/2026.
- **AC-GAP-4** `[RESOLVED]` — **two scenarios cannot both hold on the Celery surface.** Scenario 2
  requires the owner to wait `max(backoff, Retry-After)`. Scenario 3 bans manual `self.retry` for
  environment errors because it loses backoff and jitter. But the declarative `autoretry_for` path
  cannot read a response header to extend its own wait — honouring `Retry-After` on Celery needs
  exactly the manual call Scenario 3 bans. Resolved: the ban is narrowed to _"manual `self.retry`
  as the routine environment-error path"_, and the `Retry-After` rule states the one sanctioned
  manual form, with `retry_backoff_max` still capping it. Added on 05/09/2026.
- **AC-GAP-5** `[RESOLVED]` — **429 is a 4xx, and the doctrine will call it permanent and
  retryable at once.** `code/docs/TASK-AUTHORING.md` classifies a 4xx as permanent — "retrying a
  permanent failure repeats the work" — and US001 migrates that bullet into the family this story
  writes into. Scenario 2 then requires honouring a `Retry-After`, which arrives on a **429**.
  Resolved: a criterion now requires the classification to carve 429 and 503 out of the permanent
  class explicitly, so the two rules do not contradict inside one guide. Added on 05/09/2026.
- **AC-GAP-6** `[RESOLVED]` — **"attempts" is undefined at the point the story counts them.**
  Scenario 3 requires "3 attempts"; Scenario 4 reconciles two sites that write `max_retries=3`.
  Celery's `max_retries` counts **retries**, so `max_retries=3` is four attempts — the derived
  worst-case formula lands on a different number depending on which reading is meant, and the
  hand-recomputation check cannot pass without knowing. Resolved: the budget table must define
  _attempt_ once, state which parameter carries which count, and the formula must use the defined
  term. Added on 05/09/2026.
- **AC-GAP-7** `[RESOLVED]` — **the story requires the guide to name a register that will not
  exist.** Scenario 1 requires the delegation escape hatch to point at "a row in the outbound
  timeout register" — `how-to/src/OUTBOUND-TIMEOUTS.md`, which is slice `S-09`'s and runs _beside_
  this story, not before it. Scenario 7 simultaneously requires "no new dangling citation against
  the recorded baseline". Those two are satisfiable together only if the reference is written on
  the terms `code/docs/FORWARD-VOICE.md` sets. Resolved: the criterion now names the register by
  role, states the forward reference explicitly as one, and the expected finding is budgeted in
  Section 7 below rather than discovered at the gate. Added on 05/09/2026.
- **AC-GAP-8** `[RESOLVED]` — **a guide will state the inverse of the doctrine and nothing
  repairs it.** From the security gate (TM-08): `code/docs/mcp-server/TOOL-DESIGN.md:139-141` tells
  its reader that transient failures are retried **server-side** by FastMCP's `RetryMiddleware`,
  while the doctrine will state that middleware is deliberately unwired and that served surfaces
  never retry inbound work. No task in this story and no slice on the map repairs the line.
  Resolved: a criterion now requires `:139-141` either repaired in this story or explicitly
  assigned to a named slice with the assignment recorded on the map — a story that ships doctrine
  while leaving a guide stating its inverse has not repaired the fence. Added on 05/09/2026.
- **AC-GAP-9** `[RESOLVED]` — **the repaired GDPR fence is satisfiable by the defect in
  declarative clothing.** The criterion requires the fence to demonstrate `autoretry_for` with a
  sanctioned budget and no bare `except Exception` with a manual `self.retry`. Both are met by
  `autoretry_for=(Exception,)` — retry-everything, exactly the shape `S-04` exists to remove,
  which lost its "no retry-everything handler remains" clause when this story absorbed the fence.
  Resolved: the criterion now names the exception tuple as required to be specific and to exclude
  permanent failures. Added on 05/09/2026.
- **AC-GAP-10** `[RESOLVED]` — **the override cannot be recomputed by hand.** The QA check
  requires the derived worst-case column to be recomputed from the table's own parameters. The
  webhook override's "5 attempts over 24 hours" is not derivable from a table whose defaults are
  exponential from 1 s with a 600 s cap — 5 attempts under those parameters is minutes, not a day.
  Resolved: the criterion now requires a per-row override to state **every parameter it changes**,
  so the row remains computable, and the recomputation check to cover override rows explicitly.
  Added on 05/09/2026.
- **AC-GAP-11** `[RESOLVED]` — **no repeat is required to be safe to repeat.** From the security
  gate (TM-04). `code/docs/TASK-AUTHORING.md` states that retries and idempotency are one rule seen
  twice and that a task which is not idempotent cannot safely be retried at all. This story writes
  the retry half for every surface, including HTTP clients and the CLI, with no idempotency
  precondition anywhere — a retried `POST` whose first attempt succeeded server-side and timed out
  client-side executes twice. Slice `S-03` holds the other half and is not yet a story; it appears
  in `project-management/src/02-STORIES/US005.md` only inside a quoted map sentence. Resolved: the
  owner rule gains an idempotency precondition naming where the proof lives until `S-03` ships, and
  Dependencies gains an `S-03` runs-beside row. Added on 05/09/2026.
- **AC-GAP-12** `[RESOLVED]` — **a marker is silencing the citation gate on a citation that is
  simply wrong.** `project-management/src/02-STORIES/US005.md` carries
  `<!-- doc-references: template-only -->` on a citation of
  `project-management/src/17-STORY-PLANS/STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`, which
  does not exist — that plan is written at `17-story-plans`, after the sprint fills. The marker
  sets the gate's naming-row flag and the dangling-path record is skipped, so the story's "three
  forward findings" are three measured plus one masked. `code/docs/FORWARD-VOICE.md` reserves the
  marker for a citation that is right and merely unprovable downstream, and says a dangling
  citation is fixed rather than marked. Resolved: the marker is removed from that line and the
  citation carried as an honest forward reference, counted in Section 7. Added on 05/09/2026.
- **AC-GAP-13** `[RESOLVED]` — **two clauses in Scenario 1 test nothing.** Its `Given` reads "no
  guide in the tree states which layer owns a repeated operation" — two do, for their own surfaces:
  `code/docs/MANAGEMENT-COMMANDS.md:103-104` gives the CLI's repeat to the caller, and
  `code/docs/mcp-server/TOOL-DESIGN.md:139-141` gives the MCP repeat to the server. Its final `And`
  requires the rule to be recorded in an ADR that already exists on disk with the rejected option
  in it, so the clause is true before the story starts. Resolved: the `Given` now states the real
  precondition — no guide states the _cross-surface_ rule, two state their own owner and one
  contradicts this story — and the ADR clause becomes a requirement that the guide cite the ADR.
  Added on 05/09/2026.
- **AC-GAP-14** `[RESOLVED]` — **the inventory and the read-across both undercount.**
  `code/docs/performance/API-AND-MONITORING.md` carries three further retry statements beyond the
  `:57` the story names — `:46`, `:69` and the closing-checklist line at `:142`, the last of which
  sits outside the section US001 reduces and therefore survives as a retry rule stated away from
  the family. `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:252-257` is a task-type table with
  a **Retry** column, in a file this story edits at `:265`, in neither the inventory nor the
  read-across; the map assigns that table's reduction to `S-04`. Resolved: the inventory criterion
  now covers every retry statement in every file the story touches, each marked resolved-here,
  resolved-by-US001 or `S-04`'s, and the read-across list gains the two files. Added on 05/09/2026.
- **AC-GAP-15** `[RESOLVED]` — **the Security flag under-counts what the security gate produced.**
  The flag read `retry amplification`; the threat model returned twelve findings across all six
  STRIDE categories and eleven developer constraints, four of which are not amplification —
  duplicate execution, attempt-log leakage, webhook replay, and stale replay. Per
  `project-management/docs/planning/CADENCE.md` the flag is a manifest and the gate may add to it.
  Resolved: the flag now reads `retry amplification · untrusted Retry-After · duplicate execution ·
attempt-log leakage`, the security constraints are carried into the story's Verification Checks,
  and SPRINT-03's flag union was recomputed in the same pass. Added on 05/09/2026.

## 2. Test scenarios

Derived from the story's Gherkin scenarios rather than a wireframe — this story has none. Every
scenario below is executable against the repository after the change lands.

### Happy path (HP-nn)

| ID    | Given                                                                                    | When            | Then                                                                                                                                                   |
| ----- | ---------------------------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| HP-01 | No guide states the cross-surface rule for which layer repeats an operation              | The story ships | The retry guide states it once, with the SDK clamp in its correct vendor form and the delegation escape hatch named                                    |
| HP-02 | `code/docs/TASK-AUTHORING.md` requires a bound by attempt count and by total age         | The story ships | One budget table carries both, defaults taken declaratively from Celery's own, with a derived worst-case column stated as a formula                    |
| HP-03 | Four budget statements disagree across three guides                                      | The story ships | All four resolve against the table — by agreeing or by citing it — and the two `max_retries=3` sites no longer land ~3 min and ~9 min apart            |
| HP-04 | `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:265` mandates circuit breakers         | The story ships | `:265` is a pointer, and the family records the deferral with both triggers and the existing partial mechanism named                                   |
| HP-05 | `code/docs/NEGATIVE-SPACE.md:226` points at two owners, one of which is silent           | The story ships | It points at the reliability family, the `:211` row gains its pointer in prose, and no sixth column appears                                            |
| HP-06 | The tree holds a countable set of retry statements across the files this story touches   | The story ships | The inventory balances — every statement resolved here, by US001, or by `S-04`, with none unaccounted for                                              |
| HP-07 | `project-management/docs/gdpr/COMPLIANCE.md:22-49` holds one fence claimed by two slices | The story ships | The fence demonstrates a declarative shape with a specific exception tuple and a sanctioned budget, and the map's `S-04` row records the drop to three |

### Error states (ES-nn)

For a documentation story the visible failures are gate failures. Each is a check that the gate
still bites, not a defect to expect.

| ID    | Given                                                                       | When                     | Then                                                                                                                     |
| ----- | --------------------------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| ES-01 | A citation is added that does not resolve and is not a budgeted forward one | `doc-references.sh` runs | The finding count rises above the budgeted figure in Section 7                                                           |
| ES-02 | An edited file crosses 270 counted lines with no dated allowance            | `docs-length.sh` runs    | It reports the file in the warn tier                                                                                     |
| ES-03 | A registered fenced-code claim forks into a second home                     | `doctrine-drift.sh` runs | It exits non-zero naming the forked claim                                                                                |
| ES-04 | A `template-only` marker is put on a path that does not exist               | `doc-references.sh` runs | **It stays silent** — the marker suppresses the check, which is why AC-GAP-12 removes it rather than relying on the gate |

### Edge cases (EC-nn)

| ID    | Given                                                                                    | When                         | Then                                                                                                      |
| ----- | ---------------------------------------------------------------------------------------- | ---------------------------- | --------------------------------------------------------------------------------------------------------- |
| EC-01 | US001 has already repointed `code/docs/NEGATIVE-SPACE.md:226`                            | This story reaches that line | The story verifies the line's content and makes no second repoint; the criterion holds either way         |
| EC-02 | A 429 carries a `Retry-After` and the classification calls a 4xx permanent               | Both rules are read together | The guide carves 429 and 503 out of the permanent class; no reader can satisfy both rules and be wrong    |
| EC-03 | An inbound `Retry-After` exceeds the row's remaining total-age budget                    | The rule is applied          | The work is parked as exhausted; the wait is never extended past the bound                                |
| EC-04 | A budget row is an override rather than a default                                        | The worst case is recomputed | The row states every parameter it changes, so the recomputation resolves without reading another document |
| EC-05 | A client legitimately keeps its transport retries                                        | The register row is written  | The row records the delegated attempt count and interval **as numbers**, so the worst case still resolves |
| EC-06 | `code/docs/performance/API-AND-MONITORING.md:142` sits outside the section US001 reduces | The inventory runs           | It is caught as a surviving retry statement in a home other than the family, and dispositioned            |
| EC-07 | The reliability family does not exist when this story is picked up                       | The story opens              | It is blocked, not started — the blocker is US001 and it is stated in the story and in SPRINT-03          |

### Permission and access (PA-nn)

**None — this story adds no runtime surface, no endpoint and no protected action.** There is no
role boundary to cross and no identifier whose ownership could be verified. The story's `API`,
`Backend` and `Frontend` flags are correctly `N/A`.

**This is not the same as saying the story has no security content.** Its `Security` flag is live
and the gate returned twelve findings — they are threats to what the doctrine _licences later_,
not to a surface it adds now. Recorded here rather than left to be inferred from an empty table,
per `code/docs/GATE-REPORTING.md`;
`project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md`
Section 7 holds the constraints.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is Markdown read in an editor or
on a repository host, neither of which this project controls or ships. Recorded as a skip with its
reason rather than omitted, per `code/docs/GATE-REPORTING.md`.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as section 3.

## 5. GDPR & security constraints

**No PII and no new protected action** — the story creates and edits documentation only, and
introduces no field, no store and no code path that could carry personal data. Its `GDPR` flag is
correctly `N/A`.

**Security constraints do apply**, and they are constraints on the doctrine's wording. The eleven
in
`project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md`
Section 7 are not restated here. Two of them are QA-visible and are the ones a tester checks:

- **The attempt-log rule** (TM-05) — the guide names what an attempt log records and what it never
  records. A tester reads the rule and confirms the exception message, the request URL and the
  provider body are all named as excluded, not merely unmentioned.
- **The idempotency precondition** (TM-04, AC-GAP-11) — a tester confirms no scenario in the guide
  licenses a repeat without one, including on the HTTP-client and CLI surfaces where no Celery
  machinery makes it implicit.

## 6. Developer notes — testability

- **Capture the inventory before US001 lands, not before this story starts.** AC-GAP-3's "before"
  is destroyed by the blocker, not by this story. If US001 has already landed when this story
  opens, record that fact beside the inventory — the disposition of two of the four budgets changes
  with it, and a reader cannot reconstruct which state was measured.
- **`doctrine-drift.sh` is a regression guard here, not a duplicate detector.** It reads fenced
  code only and this story's doctrine is prose, per
  `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`. A green
  run says the three registered API claims are undisturbed and says **nothing** about retry
  doctrine appearing in two places. Never report it as though it had.
- **`doc-references.sh` is read as a diff, and the diff has a budget.** See Section 7. A bare pass
  is unavailable to this story and claiming one is the failure `code/docs/GATE-REPORTING.md` names.
- **The recomputation check is the only thing that tests the formula.** No script recomputes a
  worst case. Do it by hand, on a default row _and_ on the webhook override row, and write both
  arithmetic strings out — a recomputation whose working is not recorded is indistinguishable from
  one nobody did.
- **Three gates, and none of them reads prose.** There is no pytest run, no coverage figure and no
  migration check. `project-management/src/02-STORIES/US005.md`'s Verification Checks mark each
  `N/A` with its reason and the QA record must do the same rather than leave them blank.

## 7. Gate baselines, measured 05/09/2026

Captured on the working tree at `7f978a9` plus the untracked US005 artefacts, **before** any edit
this plan causes. `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
obliges a pre-edit capture for the citation gate; the other two are recorded on the same terms
because a regression guard with no recorded starting point cannot show a regression.

| Gate                | Measured 05/09/2026                                                                                     |
| ------------------- | ------------------------------------------------------------------------------------------------------- |
| `doc-references.sh` | **56** citations do not resolve. The recorded baseline is 53; US005's three are the difference          |
| `doctrine-drift.sh` | Exit 0 — 3 registered claims, 3 fail clauses, each resolving to one home. Fenced code only              |
| `docs-length.sh`    | No file over 300; five approaching. `code/docs/TASK-AUTHORING.md` at 266 is the file this story watches |

**The three US005 findings, named individually** so a fourth is visible immediately:
`project-management/src/02-STORIES/US005.md:128` and
`project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md:14`, both
citing `code/docs/reliability/`; and that ADR at `:122`, citing
`how-to/src/OUTBOUND-TIMEOUTS.md`. **A fourth is masked** — see AC-GAP-12 — and removing the marker
makes it visible rather than creating it.

**Budgeted delta from this session's artefacts, measured 05/09/2026 rather than estimated.**
The six files — this plan, the two security artefacts, `SPRINT-03.md`,
`project-management/src/02-STORIES/US005.md` and its ADR — report **14** findings, all
`[dangling path]` forward references, up from the 3 the story and its ADR carried alone. Every
one is correct and none is deferred; each clears when the file it names exists:

| Target                            | Findings | Created by                             |
| --------------------------------- | -------- | -------------------------------------- |
| `code/docs/reliability/`          | 7        | US001, SPRINT-01                       |
| `how-to/src/OUTBOUND-TIMEOUTS.md` | 4        | slice `S-09`, not yet cut into a story |
| `code/docs/ABSENCE.md`            | 2        | US003, now a SPRINT-03 member          |
| plus the ADR's own two            | —        | counted in the seven and four above    |

The two `code/docs/ABSENCE.md` references arrived with US003's admission to SPRINT-03 on
05/09/2026 and sit in `project-management/src/03-SPRINTS/SPRINT-03.md`, not in this plan.

**The measurement exposed a second thing, and it is US004's subject reproduced as a clean A/B —
twice.** Run with these files **untracked**, the whole-tree figure was **100**; run again with the
same bytes entered into the git index and nothing else changed, it was **76**. Every one of the
difference was a `[template-only citation]` — a citation of a tracked, copier-excluded PM artefact
such as `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
or `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md`. Not one survived being
committed. `project-management/src/03-SPRINTS/SPRINT-02.md` cites the same ADR and has never
reported one, because it has been committed since 02/09/2026.

Three consequences for whoever works this story:

- **A baseline is only comparable against a run in the same index state.** The 56 in the table
  above was captured with the US005 artefacts untracked. Recording the number without the state is
  what makes two honest runs disagree — and a **24-finding** swing on this tree is larger than most
  of the deltas a story is asked to account for.
- **These artefacts are expected to report that extra class until they are committed, and none of
  it afterwards.** That is not a defect in them and must not be "fixed" by adding
  `doc-references: template-only` markers — the marker would then be a lie the moment the files
  land, which is the same misuse `AC-GAP-12` removes from the story.
- **It is fresh evidence for US004** (`project-management/src/02-STORIES/US004.md`), whose whole
  subject is that this gate gives a different verdict on the same citation depending on the git
  index. Recorded here rather than opened as a new gap, because the story that owns the repair
  already exists and is already in SPRINT-02.

**The rule for reading it stays the diff, not the count** — every survivor named with the story
that owns it, and the index state stated beside the figure.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US005.md` — the story this plan tests and fed fourteen of fifteen gaps back into
- `project-management/src/03-SPRINTS/SPRINT-03.md` — the sprint whose flag union AC-GAP-15 recomputed
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — the security gate that raised AC-GAP-8, AC-GAP-11 and AC-GAP-15
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the regime Section 7 runs under
- `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` — the rule the `doctrine-drift.sh` note rests on
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections and Section 7 rest on
- `code/docs/FORWARD-VOICE.md` — the rule AC-GAP-12 rests on
