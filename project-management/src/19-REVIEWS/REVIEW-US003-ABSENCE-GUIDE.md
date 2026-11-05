# Code Review — US003 Absence gets an owning guide, born under 270 with every clause's tier stated

**Last Updated**: 05/11/2026 · **Story**: US003 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                                                                                          |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US003 — absence gets an owning guide, born under 270 with every clause's tier stated                                                                                                                                                                                                           |
| **Branch**   | `us003/absence-guide` (cut from `testing` at `b7c7c2c`; build `5baaac2`, `5041eb9`, `99187e7`, `e1afd7b`; review fixes `8a9e245`, `ed76236`, `01dd924`; walk `e935666`; walk-fail fix `0471087`)                                                                                               |
| **PR**       | Raised at `23-pr-and-review` Step 3 · target `testing`                                                                                                                                                                                                                                         |
| **Reviewer** | Claude — separate `code-reviewer` and `qa-tester` dispatches, then two targeted re-reviews in five per-surface lenses (Python, HTMX, Alpine, Rust and mobile TypeScript, the rest); none wrote the work it reviewed                                                                            |
| **Date**     | 05/11/2026                                                                                                                                                                                                                                                                                     |
| **Verdict**  | Round 1 (at `e1afd7b`): one High (raised by both passes), nine Medium · round 2 (at `8a9e245`): one High, eleven Medium · round 3 (at `ed76236`): three Medium · workflow 23 (at `426986d`): one High, in the records — every fix landed on the branch; the residue is findings, none blocking |

**Codes from:** `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` → _Key Decisions_ — the
pre-build grilling Q1 to Q4 (04/11/2026) and the review-fix grilling D1 and D2 (05/11/2026), which
settled two of round 2's findings.
**Story:** `../02-STORIES/US003.md` — the acceptance criteria this review judges against.

---

## 1. Scope & files reviewed

Markdown, plus one regex row and three fixture files in the drift audit. No Python, template,
endpoint, migration or UI. Items found by these passes outside the story's scope are in Section 6
and the findings record.

| File                                                                                                                              | Change                                                                                                                                                                                     |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `code/docs/ABSENCE.md`                                                                                                            | Created — born at 144 counted lines (`99187e7`), 148 → 192 → 206 through the three fix rounds, **205** at `0471087`; 30 crib cells; 20 inline markers (19 `[judgement]`, 1 `[gate: fail]`) |
| Root `REFERENCES.md` · `code/REFERENCES.md` · `code/docs/CONTEXT.md`                                                              | Index rows; tree entry in `code/docs/CONTEXT.md`                                                                                                                                           |
| `.claude/skills/backend/SKILL.md` · `frontend/SKILL.md` · `code-reviewer/SKILL.md` · `refactor/SKILL.md`                          | A `code/docs/ABSENCE.md` cross-reference each (+2 counted lines); `frontend`'s HTMX wording corrected at `ed76236`                                                                         |
| `.claude/skills/codebase-design/SKILL.md`                                                                                         | The _boundary_ ban scoped to architectural contexts (96 → 102); four own lines reworded to "seam"                                                                                          |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` · `.claude/skills/improve-codebase-architecture/HTML-REPORT.md` and `SKILL.md` | Seam vocabulary brought into step; the unscoped second copies of the ban route to `codebase-design`                                                                                        |
| `code/src/scripts/audits/doctrine-drift.sh` and its `fixtures/doctrine-drift/` `broken/` and `clean/` files                       | The `owned absence-enum` row (`:94`) and its fixtures                                                                                                                                      |
| `README.md` · `.copier/README.md`                                                                                                 | The Harper _Influences_ row; the `ABSENCE.md` Project Tree entry in the seeded README                                                                                                      |
| US003's story, plan and manual guide; the two boards                                                                              | Re-cut at the build's first step with dated trails (Q1 to Q4), build captures, the D1/D2 rows, the walk and re-walk                                                                        |

---

## 2. Findings

Four passes. Severity is each pass's own grade; a Nit is recorded Low. A finding a later round
re-reported is listed once, at its first round. "Finding F-0NN" points into
`../20-FINDINGS/FINDING-US003-ABSENCE-GUIDE-05-11-2026.md`.

### 2.1 Round 1 — `code-reviewer` and `qa-tester`, at `e1afd7b`; fixed in `8a9e245`

| ID    | Severity | File:line                                                                           | Issue                                                                                                                                                        | Resolution/Status                                                                                                                          |
| ----- | -------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| R-001 | High     | `code/docs/ABSENCE.md:86` (Expected miss × HTMX)                                    | review F1 · QA F-001: "a 404 at its real status" — htmx 2 swaps no 4xx and `observability.js:59-62` returns below 500, so following the cell is a dead click | Fixed `8a9e245` — a 200 not-found partial; made conditional at `ed76236` (D1), its map identifier dropped at `0471087` (finding F-003)     |
| R-002 | Medium   | `ABSENCE.md:127-131`; `code/src/scripts/audits/doctrine-drift.sh:94`                | review F2 · QA F-002: `[gate: fail]` claimed every fenced restatement; the regex sees one Python spelling                                                    | Fixed `8a9e245` — narrowed to what the regex matches, the rest `[judgement]`. Widening the regex is finding F-015                          |
| R-003 | Medium   | `ABSENCE.md:19-23` (marker legend)                                                  | review F3 · QA F-007: legend routed to `audits/CONTEXT.md`, which defines nothing; `[gate: prose]` overloaded against `VISUAL-DESIGN.md` Section 6           | Fixed `8a9e245` — routed to Section 6, the one `[gate: prose]` clause re-tiered `[judgement]`. The departure from `N-015` is finding F-016 |
| R-004 | Medium   | `ABSENCE.md:87` (Not-yet × Python)                                                  | review F4: `StrEnum` on the owning record against `TYPES-PYTHON.md`'s `TextChoices` for a model field                                                        | Fixed `8a9e245`                                                                                                                            |
| R-005 | Medium   | `ABSENCE.md:86`, `:88` (Expected miss and Empty × Alpine)                           | review F5: "cannot arise" contradicted `TYPES-BROWSER.md`'s fetching `searchPanel`                                                                           | Fixed `8a9e245` with expressions; superseded at `ed76236` by D2 (Alpine does not fetch). The owner conflict is finding F-008               |
| R-006 | Low      | `ABSENCE.md:86` vs `code/docs/api-design/NINJA-CONVENTIONS.md:145-146`              | review F6: the `OrderOut \| None` exemplar answers a miss 200/null                                                                                           | Not fixed here — `S-02`'s acceptance (finding F-013)                                                                                       |
| R-007 | Medium   | `ABSENCE.md:93-96`, `:164` (links to `TYPES-RUST.md`)                               | review F7 · QA F-003: dead in a non-Rust project, with no **Rust-only** flag                                                                                 | Fixed `8a9e245` — both flagged. Dangling by design (finding F-022); the gate's blind spot for file-relative links is finding F-017         |
| R-008 | Low      | `ABSENCE.md:91` (Not-applicable × Alpine/HTMX)                                      | review F8: "not rendered" named no mechanism; `x-show` still submits                                                                                         | Fixed `8a9e245` — `x-if` / `{% if %}`; refined at `ed76236` and `01dd924`                                                                  |
| R-009 | Low      | `ABSENCE.md:90` and `:66-68` (Not-supplied × Python)                                | review F9: `T \| None = None` cannot tell omitted from `null`                                                                                                | Fixed `8a9e245` — `model_fields_set` where they differ                                                                                     |
| R-010 | Medium   | `SERVICE-AND-MIDDLEWARE.md:189`; `improve-codebase-architecture/HTML-REPORT.md:122` | review F10 · QA F-004: the authority doc and a second copy of the ban disagree with the scoped skill; the inventory read headings only                       | Fixed `8a9e245` — reworded; the copy routes to `codebase-design`. Inventory method is finding F-023                                        |
| R-011 | Low      | `ABSENCE.md:105-108`                                                                | review F11 · QA F-009(c): Harper credited with McBride's "provenance" wording                                                                                | Fixed `8a9e245` — reworded; the `README.md` row was already accurate                                                                       |
| R-012 | Low      | `ABSENCE.md:34` (not-supplied question)                                             | review F12: "someone's" lets a webhook classify as not-supplied                                                                                              | Fixed `8a9e245` ("a person's"); re-opened as R-033 and R-058                                                                               |
| R-013 | Low      | `ABSENCE.md:36`, `:48-50`                                                           | QA F-005: row 6 not a residual; aggregates land nowhere                                                                                                      | **Refuted** by the verification pass — row 6 opens "None of the above:", the residual by construction                                      |
| R-014 | Low      | `ABSENCE.md:86` vs `:89` (Python miss vs failure)                                   | QA F-006: `ServiceNotFoundError` is a `ServiceError`, so the miss reads as a failure                                                                         | Fixed `8a9e245` — carved out of the Failure cell                                                                                           |
| R-015 | Low      | `.copier/README.md` _Influences_                                                    | QA F-008: the Harper row reached only the template's `README.md`; TigerStyle, SemVer and Conventional Commits also missing                                   | Fixed in part `8a9e245` — Harper row added; the three pre-existing rows are finding F-019                                                  |
| R-016 | Low      | Manual guide header; /tmp evidence                                                  | QA F-009(a)(b): stale _Last Updated_; the citation baseline lives only in /tmp                                                                               | Fixed `8a9e245` — header bumped; the identity multisets' sha256 and derivation recorded in the guide                                       |
| R-017 | Low      | `code/src/scripts/audits/skill-conformance.sh` clause 14 (pre-existing)             | QA F-010: a back-citation inside an HTML comment satisfies the clause                                                                                        | Open — finding F-018, dated `GAPS.md` entry                                                                                                |
| R-018 | Low      | `.github/scripts/shipped-readme.sh` at `e1afd7b`                                    | Found while fixing R-015: red on the missing `ABSENCE.md` Project Tree entry in `.copier/README.md`                                                          | Fixed `8a9e245` (finding F-020)                                                                                                            |

### 2.2 Round 2 — targeted re-review, five lenses, at `8a9e245`; fixed in `ed76236`

| ID    | Severity | File:line                                                     | Issue                                                                                                                   | Resolution/Status                                                                                            |
| ----- | -------- | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| R-019 | Medium   | `ABSENCE.md:116-128` (absence-enum example)                   | PY-2: a `StrEnum` member is a `str`, so `case str():` can catch the absence                                             | Fixed `ed76236` — plain `Enum` with `auto()`; rationale corrected at `01dd924` (R-045)                       |
| R-020 | Medium   | `ABSENCE.md:88` (Failure × Python)                            | PY-3: `DependencyUnavailable` missing                                                                                   | Fixed `ed76236`                                                                                              |
| R-021 | Medium   | `ABSENCE.md:90` (Not-applicable × Python)                     | PY-4: "never a nullable attribute" contradicts `SCHEMA-DESIGN.md`'s constrained nullable column                         | Fixed `ed76236` — nullable under a `CheckConstraint`; the owner's removed `check=` keyword is finding F-010  |
| R-022 | —        | Crib, permission path                                         | PY-1: the never-overload rule leaks existence                                                                           | **Refuted** — the crib mentions no permission path; the anti-enumeration clause was added anyway under R-024 |
| R-023 | Low      | `ABSENCE.md:89` (Not-supplied × Python)                       | PY-5 · PY-6: a form key has no default; `ninja.Schema` is banned (TID251)                                               | Fixed `ed76236` — empty value, never `initial`; `apps.core.schemas.Schema` / `QuerySchema`                   |
| R-024 | High     | `ABSENCE.md:85` (Expected miss × HTMX)                        | HTMX-1: a caller-scoped 200 partial against a 403 for not-owned is an enumeration oracle                                | Fixed `ed76236` — anti-enumeration clause (D1). The owners' own conflict is finding F-006                    |
| R-025 | Medium   | `ABSENCE.md:85`, `:92-95`                                     | HTMX-2: the HTMX/page vs JSON API split unstated                                                                        | Fixed `ed76236` — _The JSON API is not the HTMX column_                                                      |
| R-026 | Medium   | `.claude/skills/frontend/SKILL.md:146-147`                    | HTMX-3: the pointer still said "a 404"                                                                                  | Fixed `ed76236` — "a not-found partial"                                                                      |
| R-027 | Medium   | `ABSENCE.md:85`, `:92-95`                                     | HTMX-4: "never a 4xx" contradicts `N-011`'s end state; `ABSENCE.md` is a seventh 5xx-only artefact                      | Fixed `ed76236` — conditional (D1, settled by Sam). The slice's artefact list is finding F-004               |
| R-028 | Low      | `ABSENCE.md:88` (Failure × HTMX)                              | HTMX-5: a non-form 4xx falls through                                                                                    | Fixed `ed76236` — "shows nothing until" the listener gains its 4xx leg                                       |
| R-029 | Low      | `ABSENCE.md:94`                                               | HTMX-6: nothing loads `observability.js` yet                                                                            | Fixed `01dd924` — htmx 2 named as the pinned major, the handler as shipped doctrine                          |
| R-030 | Medium   | `ABSENCE.md:85` (Expected miss × Alpine)                      | A1: a component-owned `fetch` against RENDERING                                                                         | Fixed `ed76236` — D2, settled by Sam: Alpine does not fetch (finding F-008)                                  |
| R-031 | Medium   | `ABSENCE.md:85`, `:88` (Alpine miss and failure)              | A2: `fetch()` resolves on 4xx/5xx                                                                                       | Fixed `ed76236` — moot under D2                                                                              |
| R-032 | Medium   | `ABSENCE.md:87` (Empty × Alpine)                              | A3: `results: []` alone carries three meanings                                                                          | Fixed `ed76236` (`STATUS.DONE` gate), re-fixed `01dd924` (R-053)                                             |
| R-033 | Medium   | `ABSENCE.md:33` (not-supplied question)                       | RR-01: "a person's" excludes integrations                                                                               | Fixed `ed76236` ("the caller's"); re-opened as R-058                                                         |
| R-034 | Low      | `ABSENCE.md:90` (Not-applicable × Alpine)                     | A4 · A6 · A8: `x-model` state still sent; "never `x-show`" over-broad; server-known applicability belongs to `{% if %}` | Fixed `ed76236` — client-side applicability only, `x-if` or `:disabled`, out of the payload                  |
| R-035 | Low      | `ABSENCE.md:87` (Empty × Alpine)                              | A5: an inserted `x-if` region is not announced (WCAG 2.2 SC 4.1.3)                                                      | Fixed `ed76236` — persistent `role="status"`; re-fixed `01dd924` (R-054)                                     |
| R-036 | Low      | `ABSENCE.md:85-86`                                            | A7: bare string literals where TYPES-BROWSER requires frozen constants                                                  | Fixed `ed76236` — `STATUS.LOADING`; the cell later removed (R-053)                                           |
| R-037 | Medium   | `ABSENCE.md:85` (Expected miss × mobile)                      | RM-1: `classify()` files an API 404 as a user error                                                                     | Fixed `ed76236` — **Mobile-only.** note. The client mapping is finding F-014                                 |
| R-038 | Low      | `ABSENCE.md:89` (Not-supplied × Rust)                         | RM-2: plain `Option<T>` cannot tell omitted from `null`                                                                 | Fixed `ed76236` — `#[serde(default)]`, `Option<Option<T>>`; completed `01dd924` (R-055)                      |
| R-039 | Low      | `ABSENCE.md:88`, `:86` (mobile failure, not-yet)              | RM-3: "a thrown `Error`" does not match the shipped path                                                                | Fixed `ed76236` — `classify()`, `{ kind: "failed"; reason }`                                                 |
| R-040 | Low      | `ABSENCE.md:89`, `:112-114`                                   | RM-4: Python `null` vs mobile absent key unconnected                                                                    | Fixed `ed76236` — the parse function maps `null` to absent                                                   |
| R-041 | Low      | Manual guide build captures                                   | RR-02 · RR-03: marker count off by one; "staged, not committed" against a committed fix                                 | Fixed `ed76236`                                                                                              |
| R-042 | Low      | `.claude/skills/improve-codebase-architecture/SKILL.md:25-27` | RR-04: an unscoped ban beside the scoped route                                                                          | Fixed `ed76236` — routes to `codebase-design` (finding F-023)                                                |
| R-043 | Low      | `ABSENCE.md:130-134`, `:19-22`                                | RR-05 · RR-06: "fenced Python" (the scanner ignores fence language); "outside this guide"; no audit lists `[judgement]` | Fixed `ed76236`                                                                                              |

### 2.3 Round 3 — targeted re-review, five lenses, at `ed76236`; fixed in `01dd924`

| ID    | Severity | File:line                                                       | Issue                                                                                                                              | Resolution/Status                                                                                                                |
| ----- | -------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| R-044 | Medium   | `ABSENCE.md:90` (Not-supplied × Python, forms)                  | PY-1: required by default, `disabled` takes `initial`, `ModelForm` defaults, multi-value fields clean to `[]`                      | Fixed `01dd924` — the **Django forms** note, one new `[judgement]` (JSON through a `Schema` where omitted and empty must differ) |
| R-045 | Low      | `ABSENCE.md:175-176`                                            | PY-2: the `StrEnum` rationale inaccurate                                                                                           | Fixed `01dd924`                                                                                                                  |
| R-046 | Low      | `ABSENCE.md:91`, `:119-121`                                     | PY-3: the routed owner shows no kind-discriminated constraint                                                                      | Fixed `01dd924` — reworded so the XOR counts; the exemplar is finding F-011                                                      |
| R-047 | Low      | `ABSENCE.md:86` vs `rendering/PITFALLS-AND-EXAMPLES.md:290-299` | PY-4: the exemplar's `get_object_or_404` answers an HTMX miss 404                                                                  | Open — finding F-005                                                                                                             |
| R-048 | Low      | `ABSENCE.md:86`, `:105-107`                                     | PY-5: no owner states `ServiceError` subclass → status                                                                             | Open — finding F-012                                                                                                             |
| R-049 | —        | `ABSENCE.md` HTMX catch                                         | HTMX-R3-1 · HTMX-R3-2: `Http404` unmentioned; no owner maps `ServiceNotFoundError` → 404                                           | **Refuted** — not false and contradicts no owner; the owners map it                                                              |
| R-050 | Low      | `ABSENCE.md:95`                                                 | HTMX-R3-3: "swaps no 4xx" true of htmx 2 only                                                                                      | Fixed `01dd924` — the major named; the htmx-pin `GAPS.md` entry annotated (finding F-007)                                        |
| R-051 | Low      | `ABSENCE.md:105-111`                                            | HTMX-R3-4: `CLIENT-PATTERNS.md` uncited; the owners conflict on anti-enumeration                                                   | Fixed `01dd924` — cited; the owner conflict is finding F-006                                                                     |
| R-052 | Low      | `ABSENCE.md:93`, `:101-102`                                     | HTMX-R3-5 · HTMX-R3-6: full-page branch a soft 404; polling needs `hx-swap="outerHTML"`; the error region                          | Fixed `01dd924` — catch scoped to the `HX-Request` branch; `outerHTML`; an edge error page is written, not swapped               |
| R-053 | Medium   | `ABSENCE.md:87`, `:88` (Alpine not-yet and empty)               | ALP-R1 · ALP-R4: D2 only partly applied — `STATUS.LOADING`, `STATUS.DONE`, a written `results: []`                                 | Fixed `01dd924` — not-yet **cannot arise**; empty a getter over `{% json_script %}` data. D2's own wording is finding F-021      |
| R-054 | Low      | `ABSENCE.md:89`, `:88`, `:116-117`                              | ALP-R2 · ALP-R3: htmx, not Alpine, swaps; edge 5xx is not swapped; the `#status` region has no write path from Alpine              | Fixed `01dd924` — failure **cannot arise**; a component-local `role="status"`. The missing `announce` listener is finding F-009  |
| R-055 | Low      | `ABSENCE.md:91`, `:90` (Rust, mobile)                           | ALP-R5 · RT-1 · RT-3 · RT-4: an unnamed payload path; `#[serde(default)]` required; the mobile PATCH three-state; `reason: string` | Fixed `01dd924` — `:hx-vals`; the attribute required; `name?: T \| null` on an outgoing PATCH body; `reason: string`             |
| R-056 | Low      | `ABSENCE.md:130-131` (Mobile-only note)                         | RT-2: `classify()` files 408 as environment                                                                                        | Fixed `01dd924` — "like every 4xx bar 408"                                                                                       |
| R-057 | Low      | `ABSENCE.md:86`, `:123-126` (Rust)                              | RT-5: no 404 → `Ok(None)` mapping for a future client                                                                              | Fixed `01dd924` — one forward-voiced `[judgement]` in the Rust-only note                                                         |
| R-058 | Medium   | `ABSENCE.md:34`, `:69-71`                                       | RR3-01: "the caller's" excludes the stored-record case the guide's own examples use                                                | Fixed `01dd924` — "whoever writes this request or record — a person, a client or an integration"                                 |
| R-059 | Low      | Manual guide build captures                                     | RR3-02 · RR3-05: stale "staged, not committed"; a lazy continuation line                                                           | Fixed `01dd924`                                                                                                                  |
| R-060 | Low      | `ABSENCE.md:181-185`; `doctrine-drift.sh:183-188`               | RR3-03: `~~~` fences and a bare `class Absence` pass                                                                               | Fixed `01dd924` — "backtick-fenced", both named under the `[judgement]` catch-all. The audit change is finding F-015             |
| R-061 | Low      | `SERVICE-AND-MIDDLEWARE.md:11`, `:18`                           | RR3-04: "boundary" for the service layer                                                                                           | Fixed `01dd924` — "seam" (finding F-023)                                                                                         |

### 2.4 The walk — at `01dd924`; fixed in `0471087`

| ID    | Severity | File:line                                            | Issue                                                                                                   | Resolution/Status                                                       |
| ----- | -------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| R-062 | Medium   | `ABSENCE.md` → _The absence-enum rule_ · BOUNDARY-06 | The "`case _:` arm is mandatory" clause restated a `TYPES-PYTHON.md` → _Exhaustive match_ rule          | Fixed `0471087` — cited, not restated; re-walked `Pass` (finding F-002) |
| R-063 | Medium   | `ABSENCE.md` → Failure × HTMX, the HTMX note         | Out of row: the shipped guide named the template-only `S-03` and `N-011` (`code/docs/FORWARD-VOICE.md`) | Fixed `0471087` — "when that listener gains a 4xx leg" (finding F-003)  |
| R-064 | Low      | Manual row BAN-02                                    | Four uses where the build measured five                                                                 | Amended at the walk against Q1 and Q2 (finding F-001)                   |

### 2.5 Workflow 23 final passes, 05/11/2026 — at `426986d`; fixed in this change

`23-pr-and-review` Step 1 (final QA pass): no Critical, High or Medium; every QA-plan scenario
holds at HEAD. Step 2 (code review): **Standards — pass with minor changes; Spec — meets spec**,
the one open criterion being Sam's countersignature of the walk. Step 6 (records verify): one High,
S6-01. Two Step 6 items were refuted on adversarial check and left (S6-02, already finding F-021;
S6-03). Every Low and Nit below was fixed in the records pass that returned to
`22-implementation-documentation` for it.

| ID    | Severity | File:line                                                    | Issue                                                                                   | Resolution/Status                                                                                              |
| ----- | -------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| R-065 | High     | Automated record, Section 1                                  | S6-01 · CR-01: the template preamble pasted twice, a second `## 1. Results` and `US###` | Fixed — the repeat removed; one Section 1, the generated block untouched                                       |
| R-066 | Low      | Story, Verification Checks (`lint.sh`); DoD                  | QA-001 · CR-08 · S6-04: the box unticked with no reason                                 | Fixed — ticked with its scope (27 branch `.md` files, exit 0 each); the whole-tree red named; DoD re-evaluated |
| R-067 | Low      | Manual guide, tester sign-off, last item                     | QA-002: a truncated, ticked sentence                                                    | Fixed — completed, with a dated trail comment                                                                  |
| R-068 | Nit      | Automated record · this record, `doc-references.sh` rows     | QA-003: "0 new identities" without the F-025 caveat; "on `code/docs/ABSENCE.md`"        | Fixed — the caveat appended; "a dangling path to" wording across the records                                   |
| R-069 | Low      | Story Tasks: Codd check; QA Tasks: the delta row             | QA-004 · S6-05 · CR-06: two ticked rows asserting outcomes the work did not have        | Fixed — re-cut in place with dated RE-CUT comments; ticks kept                                                 |
| R-070 | Low      | Findings F-023                                               | CR-02: a `TODO(verify)` beside a ticked "no TODO" DoD line                              | Fixed — measured (nine seam uses, ten borderline), carried as a dated `GAPS.md` entry; no line reworded        |
| R-071 | Nit      | `fixtures/doctrine-drift/{clean,broken}/ABSENCE.md`          | CR-03: owner fixtures used the `StrEnum` base the guide argues against                  | Fixed — `(Enum)` with `auto()`; `doctrine-drift.sh` and `--self-test` exit 0                                   |
| R-072 | Nit      | `ABSENCE.md` HTMX and Mobile-only notes; two U+2026 ellipses | QA-005 · CR-04 · CR-05: ragged wrap; non-ASCII ellipsis                                 | Fixed — rewrapped at 100 columns; `load delay:<n>s`, `class <Name>Absence(StrEnum)`; still 205 counted lines   |
| R-073 | Nit      | Findings F-022                                               | CR-07: only the Rust links named as surface-gated                                       | Fixed — widened to the mobile links                                                                            |
| R-074 | Nit      | This record                                                  | S6-06 · S6-07: no 23 round; no graph-refresh evidence                                   | Fixed — this round; the graph line under _Gate evidence_; the cross-reference corrected                        |

**Sign-off.** Sam signed the story off on 05/11/2026 in session, after Steps 1, 2 and 6 above,
accepting the recorded findings **F-001 to F-025** and the `GAPS.md` carries, **including D1's
conditional HTMX cell**. Section 4's open manual criterion, his countersignature of the walk, is
therefore met.

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- N/A — no endpoint, permission, secret or setting is touched; the story's Security flag reads
  N/A. The guide's anti-enumeration clause routes to `security/AUTH-AND-AUTHZ.md` and states no
  security rule of its own; the owners' conflict is finding F-006.

### 3.2 GDPR / PII

- N/A — no personal data processed.

### 3.3 Test coverage vs floors

- N/A for the code floors — no source changed and no automated test declares US003
  (`../18-TESTS/AUTOMATED/US003-TEST-STATUS.md`).
- [x] Every manual QA acceptance criterion has at least one manual row, walked: **47 Pass, 0
      Fail** after the re-walk at `0471087`; one row amended (BAN-02, F-001).

### 3.4 Quality, DRY & file length

- [x] No rule stated in two homes across the six `TYPES-*` guides — BOUNDARY-06 re-walked `Pass`
      at `0471087` (it failed at `01dd924`, F-002).
- [x] `code/docs/ABSENCE.md` at **205** counted lines, 65 clear of 270; the four reciprocity
      skills each +2 and clear of 270; `docs-length.sh --since testing` exit 0, 807 files, the
      three approaching untouched.
- [x] Pairing intact — `docs-pairing.sh` exit 0 (no new directory).
- [x] `routing-skills.sh` exit 0 (612 names, 264 files); `skill-conformance.sh` exit 0 (65 skills);
      `doctrine-drift.sh` exit 0 (4 claims) and `--self-test` exit 0; `shipped-readme.sh` exit 0.
- [x] Prettier and markdownlint clean on the story's files, the second `--fix` pass leaving the
      diff unchanged.

### 3.5 Performance

- N/A — no runtime path.

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI in this story. The guide's Alpine empty-state cell names a
  `role="status"` count (R-035, R-054) as content guidance, not a rendered surface.

---

## 4. Required actions before merge

None open on the branch. Every High and Medium is fixed or settled (D1, D2), the walk's one Fail
is fixed and re-walked, and the residue is recorded as findings routed to slices or dated
`GAPS.md` entries. One plan note (F-021) lands with the `23-pr-and-review` records pass. Sam's
countersignature of the walk is the open manual criterion.

---

## 5. Verdict & status transition

- **Verdict:** three review rounds and the walk, every fix landed on the branch; the walk passes
  47/47 after the walk-fail fix.
- **Reasoning:** the guide lands at 205 with six kinds, a 30-cell crib reconciled against the
  owner guides of five surfaces, and both rules it owns; the drift row pins the absence-enum rule
  for the one spelling its regex sees, and the guide says so; the citation gate gains no identity
  the story wrote and loses 18 identities (65 findings).
- **Status transition:** none recorded here. `In Progress` → `In Review` and onward are recorded
  through the `completion` skill at `23-pr-and-review`.

---

## 6. Notes

### Pre-existing or out of diff, found by these passes

| Item                                                                                              | Owner / disposition                             |
| ------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `SCHEMA-DESIGN.md` `CheckConstraint(check=…)` at `:151` and `:262`, removed in Django 6           | Finding F-010 — dated `GAPS.md` entry           |
| `TYPES-BROWSER.md`'s fetching `searchPanel` against `RENDERING.md`                                | Finding F-008 — dated `GAPS.md` entry           |
| `CLIENT-PATTERNS.md` 403 against `AUTH-AND-AUTHZ.md` → _Anti-Enumeration_                         | Finding F-006 — dated `GAPS.md` entry           |
| No `announce` listener ships for the `#status` region                                             | Finding F-009 — dated `GAPS.md` entry           |
| `doc-references.sh` blind to file-relative links; `skill-conformance.sh` clause 14 reads comments | Findings F-017, F-018 — dated `GAPS.md` entries |
| `.copier/README.md` lacks three _Influences_ rows                                                 | Finding F-019 — dated `GAPS.md` entry           |

### Gate evidence

| Gate                                                                                                           | Before (`5baaac2`) | At the walk (`01dd924`) / re-walk (`0471087`) | Reading                                                                                                                                                                                                                                                                |
| -------------------------------------------------------------------------------------------------------------- | ------------------ | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`                                                                    | exit 1, 564 / 269  | exit 1, 499 / 251                             | Findings / identities. **0 new identities; 18 identities (65 findings) gone**, every one a dangling path to `code/docs/ABSENCE.md`. A diff, not a pass. The fix's one shipped file, scoped at `0471087`: exit 0; at HEAD the generated block adds one identity (F-025) |
| `code/src/scripts/audits/docs-length.sh --since testing`                                                       | —                  | exit 0                                        | 807 files within 300; `ABSENCE.md` 205                                                                                                                                                                                                                                 |
| `code/src/scripts/audits/doctrine-drift.sh` · `--self-test`                                                    | —                  | exit 0, 4 claims · exit 0                     | Fenced code only — never read as checking the prose (ADR-US001-PROSE-DOCTRINE-VERIFICATION)                                                                                                                                                                            |
| `routing-skills.sh` · `skill-conformance.sh` · `docs-pairing.sh` · `shipped-readme.sh` · `pm-board.sh --check` | —                  | exit 0                                        | Re-run at this closeout over the staged tree, 05/11/2026                                                                                                                                                                                                               |
| code-review-graph                                                                                              | —                  | current at `426986d`                          | The `22-implementation-documentation` Step 7 refresh, confirmed at `23-pr-and-review` Step 6 (S6-07)                                                                                                                                                                   |

Findings over identities, compared as a multiset with line numbers stripped, per
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`. The walk
figures predate this closeout's records; the automated record's generated block adds one identity
of its own (finding F-025).

### Known reds for the PR body

- `Audit — Doc References` / `Citations resolve` — 499 pre-existing findings owned outside this
  story, plus the line the generated test record adds (F-025).

---

## Cross-references

- `../02-STORIES/US003.md` — the story under review
- `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the plan, its pre-build Key Decisions (Q1 to Q4) and review-fix decisions (D1, D2)
- `../18-TESTS/AUTOMATED/US003-TEST-STATUS.md` · `../18-TESTS/MANUAL/US003-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US003-ABSENCE-GUIDE-05-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US003-ABSENCE-GUIDE-05-11-2026.md` — the findings
- `project-management/workflows/22-implementation-documentation/` · `project-management/workflows/23-pr-and-review/` — `22` drafted this record; `23` completes it with its final passes (Section 2.5) and verifies it
