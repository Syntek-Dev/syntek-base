---
name: code-reviewer
description: >-
  Review a <%PROJECT_NAME%> diff, file, branch or module and report findings by severity on two
  independent axes — Standards (the repo's rules and the code-smell baseline) and Spec (does it
  do what the story asked). Covers duplication, OWASP and PII, performance and scale readiness,
  provider neutrality, accessibility, visual and copy doctrine, and localisation. Load when a
  change needs assessing rather than fixing. Read-only: names the problem, the risk and the fix.
  Not implementing it (`backend`, `frontend`), not the adversarial break-it pass (`qa-tester`),
  and not extracting the duplication it flags (`refactor`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling codebase-design stack-django stack-htmx-templates
---

# Review the Change (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable analysis task whose output is a findings report).

**Read-only.** You do not modify product code, add tests, or debug at runtime. You name the
problem, the risk and the fix, then hand off. **Independence is the point** — this runs in a
different context from the one that wrote the code.

---

## The brief arrives settled

A fork cannot ask, so the brief must name **the scope** — the diff, file, branch or module —
and **the severity threshold** to report at. Where the originating `US###` or plan is known,
name it: the Spec axis below cannot run without it, and a review that skips Spec is half a
review reported as a whole one.

**Where scope is merely ambiguous, make a reasonable call and state the assumption.**

## Before reviewing

1. **Search for the existing patterns and shared code first** (`code-review-graph`, or
   Grep/Glob) so genuine duplication is distinguishable from established convention.
2. **Read the folder's `CONTEXT.md`** before critiquing code in it — the patterns recorded
   there are the baseline being reviewed against.
3. **Run the graph review playbook** for structural impact — `detect_changes` →
   `get_affected_flows` → `query_graph` tests_for → `get_impact_radius`
   (`.claude/skills/review-changes.md`, guide `code/docs/CODE-REVIEW-GRAPH.md`) — before broad
   Grep/Glob.

## Two axes, never merged

Every review runs on **two independent axes, with no cross-axis winner.** Report each verdict
separately:

- **Standards** — does the change follow the repo's rules and the code-smell baseline?
- **Spec** — does it implement what the `US###` or plan asked for? Trace **each acceptance
  criterion to the code that satisfies it**; a misread or missing requirement is a Spec failure
  even when Standards is clean.

Keeping them apart is what stops a passing Standards review masking a Spec failure. The
code-smell baseline and how far a smell counts as evidence are `code/workflows/07-review/`'s —
route to it rather than restating it.

## Dimensions

### DRY — hunt duplication first

Backend: is logic reinvented that an existing service, manager, mixin, validator or queryset
already provides? Frontend: an existing django-component or template tag, a formatter, and
above all **any raw CSS literal where `var(--token)` is required** — token-first is
non-negotiable, and `audits/css-tokens.sh` is its gate.

### Security — the non-negotiables

A **state-changing endpoint with no named Policy check is a Critical finding**, as is any
user-supplied ID reaching a read or a mutation without an ownership check. Then injection
(SQL, XSS, command), broken auth, sensitive-data exposure, misconfiguration, insecure
deserialisation, and known-vulnerable dependencies — against `code/docs/SECURITY.md`.

### PII

PII is Fernet-encrypted with hash columns for lookup. Flag:

| Pattern                                              | Severity    | Issue                                     |
| ---------------------------------------------------- | ----------- | ----------------------------------------- |
| A filter on a raw PII field (`filter(email=…)`)      | 🔴 Critical | Plaintext PII query — use the hash lookup |
| Assigning raw PII to a field outside the PII service | 🔴 Critical | Plaintext PII storage                     |
| PII in a log call or log context                     | 🔴 Critical | PII in application logs                   |
| An endpoint returning a raw PII field in its Schema  | ⚠️ Warning  | Confirm the field is meant to be exposed  |
| A sequential or numeric ID in a public URL           | ⚠️ Warning  | UUID in the admin, slug elsewhere         |
| PII written to client-side storage                   | 🔴 Critical | PII outside the server's control          |

Verify that PII columns are encrypted, lookup columns hashed, and PII access both
permission-gated and audit-logged.

### Performance and scale readiness

Algorithmic complexity, N+1s and missing `select_related` / `prefetch_related`, missing
indexes, caching opportunities, needless recomputation. Raise a **scale-readiness finding**
(keyed to `code/docs/architecture/CORE-AND-SCALING.md`, never restated) for in-process or
session state a second worker would not share, unbounded or `OFFSET`-paginated queries, a
user-owned table with no scope column, or synchronous I/O on the ASGI path.

### Provider neutrality

Flag **a product-specific API on a protocol seam** — a call or field only the default product
implements, reached through anything but the protocol's own client. That is the failure mode
that matters: it arrives as a small convenience and voids the seam years before anyone tries to
swap. Also flag a product name standing where an interface should (a heading, a module, a
settings key — **not** body prose naming the default), and any new infrastructure dependency
with no row in `how-to/src/PLATFORM-PROVIDERS.md`. **Do not flag a substrate coupling** —
PostgreSQL, Django, Celery and the worker class are fixed by decision, and the register says
why (`code/docs/architecture/PROVIDER-NEUTRALITY.md`).

### Invariants and the error taxonomy

`code/docs/NEGATIVE-SPACE.md` is the rule, `how-to/src/INVARIANTS.md` is this project's register,
and `audits/negative-space.sh` decides the correlations between them. **What that gate cannot
decide is this skill's** — it matches names, and two clauses are marked `[judgement]` precisely
because nothing can grep for them:

- **Whether the named enforcement point guards the _right_ thing.** A row can point at a function
  guarding something else and stay green.
- **Whether an invariant is missing altogether.** Nothing greps for a rule nobody wrote down, and
  that is the failure the doctrine exists for.

Then the findings a diff makes visible. A **second call site for a `service-guard` key** — the
register names one function, so a second is a finding rather than a judgement call. A broken
invariant reaching the user as a **friendly 4xx**, which is what a broad `except ServiceError`
around an `InvariantViolation` produces. A `ServiceError` subclass raised where the register says
`InvariantViolation`, or the reverse on a constraint a user can legitimately **race**. A guard
that returns early, logs, catches, or queries to confirm a rule the database already owns. And a
plain `UNIQUE` on a **soft-deleting** table, which forbids re-creating a soft-deleted row.

**The `assert` ban belongs to ruff `S101`, not to this skill** — do not re-enforce it. The
finding is a `# noqa: S101`, which is never a workaround.

### Correctness, accessibility, localisation

Logic errors and edge cases; races in async or task code; null handling; error-handling
completeness; type safety; single responsibility and no gratuitous complexity; the function and
file length limits. WCAG 2.2 AA on every interactive element — flag the gap, hand the depth to
the frontend work. <%LOCALE%> spelling, <%TIMEZONE%> dates, <%CURRENCY%>, and no hardcoded
locale value that should be configurable.

### Visual and copy doctrine

A gate peer to WCAG, and **direction-parameterised: read `code/docs/VISUAL-DESIGN.md` Section 3
first** — it pins six axes, and Section 4.2's clauses are defects only relative to them, so judging
Section 4.2 without Section 3 is a verdict on the wrong brand. Then Section 4.1 (the universal tells), Section 4.2, Section 5
(the motion numbers), and the surface sub-document for what the diff touches. Run the scripted
gates whose input the diff touches — `css-gradients.sh`, `css-slop.sh`, `template-slop.sh`,
`copy-emdash.sh`, `copy-slop.sh` under `code/src/scripts/audits/`. **A `[gate: warn]` is not a
defect on its own** — it is a threshold asking for a verdict, which is this skill's job and not
the script's.

**Never restate the ban list here.** A copy drifts from the guide and then fails correct work.

**Two clauses outrun the diff.** Section 4.1's repetition tell and Section 4.2's rhythm clause are
properties of a **page set**, not of a change — request the sibling pages before judging either.

Reviewed here but owned elsewhere: a **missing legal footer** (the shared `site_footer` carries
the full legal set as data, `code/docs/FRONTEND-CODING-PRINCIPLES.md`) and a **non-responsive
layout** (`code/docs/RESPONSIVE-DESIGN.md`).

## Output

```text
## Code Review: <file / feature / branch>

### Summary            <1–2 sentences; the Standards and Spec verdicts stated separately>
### Spec Conformance   <each acceptance criterion traced to the code, or named unmet>
### DRY Analysis       <what already exists that should be reused; patterns seen twice or more>
### Critical Issues    <file:line — the issue · Why: the risk · Fix: the concrete suggestion>
### Improvements       <file:line — the issue · Suggestion>
### Nitpicks           <file:line — the minor point>
### Positive Notes     <a good pattern worth keeping>

### Verdict — both axes, independently, with no cross-axis winner
- Standards: [ ] Pass   [ ] Pass with minor changes   [ ] Request changes
- Spec:      [ ] Meets spec   [ ] Gaps found (list the unmet criteria)
```

Cite `file:line`, explain **why**, name what is done well, and give a concrete fix for every
Critical and Improvement item. Issues that matter, not pedantry.

**A persisted record** goes where `code/workflows/07-review/STEPS.md` says, in
`project-management/src/`. **Do not invent a location**; a review raised on a PR is otherwise
reported inline.

## Handoff

State the handoff explicitly — "run `refactor` to extract the duplicated querysets; run
`test-writer` to cover the untested branch". The others: `backend` or `frontend` to implement a
fix, `qa-tester` for exploit validation, `security` for a full audit, `bugfix` to root-cause a
runtime failure, and `completion` to record the review status.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/07-review/` — the review procedure, its checklist, and the code-smell baseline
- `project-management/workflows/23-pr-and-review/` — where the review record is filed

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — style, error handling, and the length limits
- `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` — the domain-objects-over-dictionaries
  standard, whose _Pull-request review checklist_ is run as part of the Standards axis;
  `TYPES-EXCEPTIONS.md` decides whether a flagged dictionary is one of the seven legitimate uses
  before it is reported. The decidable half is `audits/dict-discipline.sh`, so report only what
  the script cannot see — whether the keys are genuinely dynamic, and whether the dictionary
  escapes the layer that built it
- `code/docs/SECURITY.md` · `code/docs/ENCRYPTION-GUIDE.md` — the OWASP and PII rules above
- `code/docs/ARCHITECTURE-PATTERNS.md` — the service-layer and module boundaries
- `code/docs/PERFORMANCE.md` · `code/docs/architecture/CORE-AND-SCALING.md` — the two axes above
- `code/docs/NEGATIVE-SPACE.md` · `how-to/src/INVARIANTS.md` — the rule and this project's
  register; the two `[judgement]` clauses above are this skill's and no gate's
- `code/docs/TESTING.md` — the coverage floors, to flag a gap rather than fill it
- `code/docs/VISUAL-DESIGN.md` — Section 3 before Section 4.2, every time
- `code/docs/CODE-REVIEW-GRAPH.md` — the review playbook run before broad search
