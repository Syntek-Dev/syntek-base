# STORY-PLAN-US003 — Absence gets an owning guide, born under 270

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 02/09/2026                         |
| Branch | `us003/absence-guide`              |
| Sprint | SPRINT-03 · Wave 0 · build order 2 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

> **US003 moved from SPRINT-02 to SPRINT-03 on 05/09/2026, before either sprint was worked.**
> Its `Should` tier and its wave-0 position on `../01-FEATURE-MAPS/MAP-ABSENCE.md` are
> unchanged — only the sprint it is scheduled in moved. **The US004-before-US003 build order
> survived the move**, as a **cross-sprint** constraint rather than an intra-sprint one, so
> every clause below that rests on US004 landing first reads exactly as written. `Date` above
> is this plan's authoring date and is deliberately not bumped; `../03-SPRINTS/SPRINT-03.md`
> → _Notes_ records the move, and `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` its arithmetic.

Implements `../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md` (the crib's
cells cite nothing that does not yet exist) under
`../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` (prose doctrine is verified
by a human read-across, never by `doctrine-drift.sh`).

> **Source authority.** Where this plan and `../02-STORIES/US003.md` differ on **what must be
> true**, the story wins. Where they differ on **the state of the citation gate**, this plan
> wins — see the correction below. On what a documentation file may weigh,
> `code/docs/DOCUMENTATION-LENGTH.md` wins over both.

> **This plan is more current than its story, deliberately.** US003's Gherkin carries a scenario
> reading `doc-references.sh` as a diff against a recorded baseline, a QA task recording
> before/after finding counts, and an ADR binding both. **US004 lands first and removes the defect
> all three exist for.** This plan therefore plans against a gate that simply passes, and records
> that those three parts of the story are superseded by US004 shipping rather than by anyone
> editing them. `../03-SPRINTS/SPRINT-03.md` → _Dependencies_ carries the same flag.

---

## Problem Statement

When code returns "nothing", it can mean six different things — the record was never there, it has
not arrived yet, the collection is genuinely empty, something failed, nobody supplied a value, or
the concept does not apply. **Today a developer guesses which, and different parts of the codebase
guess differently.**

The `code/docs/data-structures/TYPES-*.md` family already owns **what shape a value has**. Nothing
owns **what an absence means**, and `N-008` measured that the absence-enum rule — that an absence
with more than one meaning is modelled as an enum rather than a null — is stated by no guide at
all. The six kinds appear implicitly across six surfaces with no single statement and no crib
mapping them onto the languages this stack actually uses.

This is slice `S-01` of `../01-FEATURE-MAPS/MAP-ABSENCE.md`, nodes `N-008`, `N-009` and `N-018`,
and **five further slices cite the guide it creates** — `S-02` the Python `None` clause, `S-03`
the HTMX contract, `S-04` the optional-surface remainders, `S-05` tiers and mechanical legs, and
`S-06` consumer wiring, which names the dependency in its own acceptance.

## Reference Documents (code/docs gate map)

| Concern                        | Document                                                   | What it binds here                                                               |
| ------------------------------ | ---------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Length limit and the ratchet   | `code/docs/DOCUMENTATION-LENGTH.md`                        | Born under 270; no edited file at or above 270 may grow at all                   |
| What shape a value has         | `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`     | The boundary this guide must not cross — shape rules stay where they live        |
| The Rust surface's own rules   | `code/docs/data-structures/TYPES-RUST.md`                  | `:156` is cited by the crib's Rust row, never restated                           |
| What the code must never allow | `code/docs/NEGATIVE-SPACE.md`                              | Named a sibling under _What this is not_; two rows land in `S-04`, not here      |
| Reporting a gate's result      | `code/docs/GATE-REPORTING.md`                              | Named a sibling; and `doctrine-drift.sh` is never reported as reading prose      |
| Forward-looking claims         | `code/docs/FORWARD-VOICE.md`                               | Named a sibling; governs what the crib may promise about clauses not yet written |
| The RLS middleware instance    | `code/docs/rls/MIDDLEWARE-AND-NINJA.md`                    | `:270` is the never-overload rule's one shipped instance                         |
| Attribution                    | `README.md` → _Influences_ · `.claude/CLAUDE.md` Section 6 | Licence checked **before** deriving; the row lands in the same commit            |
| Story                          | `../02-STORIES/US003.md`                                   | Nine scenarios, the acceptance this plan implements                              |
| QA                             | `../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md`         | Seven resolved AC-gaps and the scenario tables                                   |
| Sprint plan                    | `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`                  | Build order, `Should` tier, gate-honesty constraint                              |
| Feature map                    | `../01-FEATURE-MAPS/MAP-ABSENCE.md`                        | Slice `S-01`, nodes `N-008`, `N-009`, `N-018`                                    |

**Not applicable, and why:** `../04-DATABASE/`, `../05-USER-FLOW/`, `../06-BRAND-GUIDE/`,
`../07-COMPONENTS/`, `../08-WIREFRAMES/`, `../09-GDPR/`, `../10-SECURITY/`, `../12-SEO/`,
`../13-API-DESIGN/`, `../14-LOGGING/` — the story's corresponding flags all read `N/A`. It ships
Markdown: no model, endpoint, screen, personal-data path, log line or public page.

## Architecture Decision

**The guide states what an absence _means_; the `TYPES-*` family keeps what shape a value _has_.**
That boundary is the whole design, and it decides every borderline clause: a rule about
`Option<T>` versus a sentinel is shape and stays in `TYPES-RUST.md`; a rule about which of six
kinds a `None` represents is meaning and lands here.

Three clauses sit on the line and `N-008` measured each:

| Rule                | Owner before | Disposition                                                  |
| ------------------- | ------------ | ------------------------------------------------------------ |
| Absence-enum rule   | **Nobody**   | **Stated here**, and pinned by a new `doctrine-drift.sh` row |
| Never-overload rule | Nobody       | Stated here, citing `rls/MIDDLEWARE-AND-NINJA.md:270`        |
| Rust `Option`/shape | `TYPES-RUST` | **Cited**, at `:156`, never restated                         |

`ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH` settles the second-order problem the crib creates: its
cells describe surfaces whose clauses `S-02`, `S-03` and `S-04` have not written yet. **The cells
are self-contained at birth** — each names a concrete expression or states why that kind cannot
arise on that surface — and the three later slices retro-fit the back-link in the change that
writes the target. A crib citing forward would ship a guide full of dead links.

## Approach

### Not applicable — Database, Service Layer, API, Frontend

This story adds no Python, no template and no component. The four layer sections the template
carries are dropped because the story touches none of them, not to dodge a gate.

### Phase plan — four phases

| Phase | Deliverable                                            | Blocked by |
| ----- | ------------------------------------------------------ | ---------- |
| P1    | `code/docs/ABSENCE.md` — six kinds, crib, tier markers | —          |
| P2    | Registration on every surface it owes                  | P1         |
| P3    | Reciprocity, and the `codebase-design` scoping         | P2         |
| P4    | The drift row and the attribution rows                 | P1         |

**P1 — the guide.** Six kinds — expected miss, not-yet, empty, failure, not-supplied,
not-applicable — each named and distinguished from the other five, **exhaustive and mutually
exclusive**, with the tie-break stated wherever two could plausibly apply. A crib maps each kind
onto **Python, Rust, Alpine, HTMX and mobile TypeScript** and no other surface. **No cell is
blank, a bare dash, or the word "varies"**: each names a concrete expression or says why that kind
cannot arise there. Every clause carries an inline tier marker — `[gate: fail]`, `[judgement]` or
`[gate: prose]` — where a clause is any sentence or bullet stating a rule a reader must obey; a
heading, a worked example and a crib cell are not clauses, so a document-level marker does not
satisfy this. Every `[gate: fail]` names its gate, saying so where that gate's workflow is
path-filtered. **No clause takes `[gate: warn]`.**

**Born under 270 counted lines.** That is the binding constraint on P1 and it shapes the writing,
not the trimming: six kinds, a five-column crib, the two owned rules and the sibling section is a
lot for 270 lines, and the budget is checked before the guide is called done.

**P2 — registration.** The standard header block including its Claude Model line; routing
frontmatter (`type: guide`, `skills:`, `model:`); index rows in the root `REFERENCES.md`,
`code/REFERENCES.md` and `code/docs/CONTEXT.md`. **No row in `code/CONTEXT.md`** — it carries none
for either guide born since charting, and adding one here would be a convention invented in
passing. `routing-skills.sh` must exit 0 with every frontmatter name resolved, including through
the wrapped-array form Prettier forces at `printWidth: 100`.

**P3 — reciprocity, and one scoping fix.** `skill-conformance.sh` clause 14 obliges every skill
named in a guide's routing frontmatter to cite that guide back. The four named — `backend`,
`frontend`, `code-reviewer`, `refactor` — measure **169, 155, 220 and 148** counted lines, all
clear of the 270 band, which is part of why they were chosen over the surface-complete set. **No
file edited to discharge this may grow while at or above 270.**

In the same phase, `.claude/skills/codebase-design/SKILL.md`'s ban on substituting "boundary" for
"seam" is **scoped to architectural contexts** — it is currently broken four times in its own file
and by 20 headings across 16 files. Each of those four uses is checked against the new scope and
reworded if it still violates: **a rule whose own defining file breaks it has not been fixed.**
This lands in the same commit as the guide, not as a follow-up.

**P4 — the drift row and the attributions.** One `doctrine-drift.sh` `owned` row pinning the
absence-enum rule to `code/docs/ABSENCE.md`, green on the baseline. Two `README.md` _Influences_
rows, each with its licence, each in the same commit as the rule it credits: E. F. Codd's
applicable/inapplicable null marks for the not-supplied and not-applicable kinds, and Robert
Harper's Boolean Blindness for the absence-enum rule. **The Codd row is written only after the
primary source is checked** to confirm derivation rather than convergence — and if the check
returns convergence, **no row is written** and the guide instead states that the split parallels
Codd's marks, claiming no derivation.

### The citation gate, corrected

US003's Gherkin plans a baseline capture. **US004 ships first and removes the need.** The three
`code/docs/ABSENCE.md` forward references currently outstanding are this story's own targets and
resolve the moment P1 lands. So:

- **No baseline is captured**, provided US004 has landed. Confirm it has before starting.
- `doc-references.sh` is read as a plain pass on this story's files.
- **If US003 is somehow worked ahead of US004**, the story's original baseline procedure applies
  unchanged — but the sprint has ruled that order out.

## Key Decisions

| Decision                                  | Chosen                                             | Rejected                                  | Why                                                                   |
| ----------------------------------------- | -------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------- |
| Where the absence-enum rule lives         | Stated in `ABSENCE.md`                             | Cited to a `TYPES-*` guide                | `N-008` measured it owned by nobody                                   |
| Where the Rust shape rule lives           | Cited at `TYPES-RUST.md:156`                       | Restated in the crib                      | Shape belongs to the `TYPES-*` family; meaning belongs here           |
| Whether crib cells cite forward           | Self-contained at birth                            | Cite the clauses `S-02`–`S-04` will write | A guide of dead links (ADR)                                           |
| Which skills take the routing frontmatter | `backend`, `frontend`, `code-reviewer`, `refactor` | The surface-complete set                  | All four are clear of the 270 band, so reciprocity costs no allowance |
| How prose doctrine is verified            | Human read-across                                  | `doctrine-drift.sh`                       | It reads fenced code only (ADR-US001)                                 |
| Whether a row in `code/CONTEXT.md`        | No                                                 | Add one                                   | It carries none for either guide born since charting                  |

## Dependencies

| Story | Relationship                                                                                       |
| ----- | -------------------------------------------------------------------------------------------------- |
| US004 | **Blocking, by sprint decision.** It removes the defect this story's baseline procedure exists for |
| US001 | Independent — its `ADR-US001-PROSE-DOCTRINE-VERIFICATION` binds this story's verification method   |
| US002 | Independent. Different tree, different subject                                                     |

- **Blocked by:** US004, on build order rather than on mechanism. The absence map's frontier and
  fog of war are both empty; nothing on that map blocks this.
- **Blocks:** slices `S-02` to `S-06` on `../01-FEATURE-MAPS/MAP-ABSENCE.md`. Three of them —
  `S-02`, `S-03`, `S-04` — inherit an obligation from this story: each retro-fits its surface's
  crib back-link in the change that writes the clause it points at. **The map's slice rows need
  that clause adding to their acceptance — a map edit this story does not own and does not make.**
- **Can be done now:** P1 and P4 in draft. P2 and P3 need P1's frontmatter settled.

## GDPR

**Not applicable.** The `GDPR` flag reads `N/A`. The story ships Markdown guidance; no personal
data is touched, stored or described. Section dropped rather than filled with "none" per row.

## Security

**Not applicable** as a flag — no endpoint, view, mutation or protected action, so the
permission-check and IDOR rows have no subject. The guide's content touches security only where it
names `NEGATIVE-SPACE.md` as a sibling, and it states no security rule of its own.

## Logging & Observability

**Not applicable.** The `Logging` flag reads `N/A`; the story adds no log line and describes none.

## Performance, Rendering, Responsive & Accessibility

**Not applicable** — no rendered surface. The one readability property that matters is the crib:
a developer must be able to read their surface's expression off a single table **without opening a
second file**, which is what makes the self-contained-at-birth decision load-bearing rather than
tidy.

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✅ → `03-sprint-planning` ✅ → `11-qa-checks` ✅ → `15-decisions` ✅ →
`16-sprint-plans` ✅ → **`17-story-plans` (this document)** → the lane below →
`22-implementation-documentation` → `23-pr-and-review`.

**No code lane.** `19-backend-code`, `20-api-code` and `21-frontend-code` all read `N/A`.

### Standards gates

Every command through `code/src/scripts/**/*.sh`. British English, DD/MM/YYYY, the U+00A7 ban and
plain-ASCII punctuation per `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2.

## Testing

**No automated suite** — the story ships no code path, so `tests/all.sh --coverage` is `N/A` with
a reason rather than a skipped box. Five gates and two human checks stand in for it.

| Check                  | What it proves                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------------- |
| `docs-length.sh`       | Under 270 at birth; no edited file at or above 270 grew at all                              |
| `doc-references.sh`    | Every citation the guide and the edited skills write resolves                               |
| `doctrine-drift.sh`    | The new `owned` row is green and no existing claim forks                                    |
| `routing-skills.sh`    | All four frontmatter names resolve, including through the wrapped-array form                |
| `skill-conformance.sh` | Clause 14 discharged for all four named skills                                              |
| Human read-across      | No rule stated in two homes across the six `TYPES-*` guides — **the script cannot do this** |
| Cold-read walk         | A developer names which of six kinds a given `return None` means, without a second file     |

**`doctrine-drift.sh` reads fenced code only.** It runs here as a regression guard and is **never
reported as having checked this guide's prose** — `ADR-US001-PROSE-DOCTRINE-VERIFICATION` and
`code/docs/GATE-REPORTING.md` both bind that.

## Documentation Write-Ups (Implementation Records)

`22-implementation-documentation` owns the records and writes `../18-TESTS/US003-TEST-STATUS.md`
and `../18-TESTS/US003-MANUAL-TESTING.md`.

## CONTEXT.md & Index Updates

| File                           | Change                                              |
| ------------------------------ | --------------------------------------------------- |
| `REFERENCES.md` (root)         | Index row for `code/docs/ABSENCE.md`                |
| `code/REFERENCES.md`           | Index row                                           |
| `code/docs/CONTEXT.md`         | Index row and directory-tree entry                  |
| `code/CONTEXT.md`              | **No row** — deliberate, recorded in P2             |
| `README.md`                    | Two _Influences_ rows, licence-checked, same commit |
| `../17-STORY-PLANS/CONTEXT.md` | Plans Index row for this plan                       |

## Deferred Items

- **The crib back-links** — `S-02`, `S-03` and `S-04` each retro-fit their surface's link. Not
  deferred work in the `DEFERRED.md` sense: it is scheduled on a map, and the acceptance clause
  that binds those slices is a map edit **this story does not make**.
- **The two `NEGATIVE-SPACE.md` rows** (Rust, desktop) — `S-04`'s.
- **The 20 boundary/seam headings across 16 files** — P3 scopes the rule and fixes its own file's
  four uses; the wider sweep is not this story's.

## Risks

| Risk                                                                   | Mitigation                                                                     |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| The guide overruns 270 lines and needs an allowance at birth           | The budget is a P1 exit criterion, checked before the guide is called done     |
| A crib cell reads "varies" because the surface genuinely differs       | The QA plan forbids it: name the expression or say why the kind cannot arise   |
| The Codd attribution claims derivation where there is only convergence | The primary source is checked **before** the row is written; no row if unclear |
| A reciprocity edit grows a skill file into the warn tier               | All four measured clear of 270 at planning; re-measured before committing      |
| US003 is worked ahead of US004 and the plan's gate advice misleads     | The fallback is stated explicitly above rather than assumed                    |

## Definition of Done

- [ ] `code/docs/ABSENCE.md` exists, under 270 counted lines at birth
- [ ] Six kinds, exhaustive and mutually exclusive, with tie-breaks where two could apply
- [ ] Every crib cell self-contained — no blank, no dash, no "varies"
- [ ] Every clause carries a tier marker; every `[gate: fail]` names its gate; none reads `warn`
- [ ] Registered on all four surfaces it owes, and deliberately not on `code/CONTEXT.md`
- [ ] All five gates pass; the human read-across and the cold-read walk both done and recorded
- [ ] The `codebase-design` ban scoped, and its own four uses checked against the new scope
- [ ] Attribution rows land in the same commit as the rules they credit, licences checked first
- [ ] Plans Index row added; story cross-references this plan
- [ ] Reviewed and approved; merged; `../02-STORIES/US003.md` status set to **Completed**
