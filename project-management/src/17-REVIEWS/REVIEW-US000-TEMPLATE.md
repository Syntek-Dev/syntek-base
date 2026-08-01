# Code Review — US000 {STORY TITLE}

_Template — copy to `REVIEW-US###-<DESCRIPTOR>.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. This record captures the code review of one user story's branch/PR — findings, dimension checks, and the merge verdict — closing the loop on the story plan it was coded from._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {In Review → Accepted}

| Field        | Value                                           |
| ------------ | ----------------------------------------------- |
| **Story**    | US### — {short title}                           |
| **Branch**   | `us###/{short-kebab-description}`               |
| **PR**       | #{NN} · target `{target-branch}`                |
| **Reviewer** | {name / agent}                                  |
| **Date**     | {DD/MM/YYYY}                                    |
| **Verdict**  | Approve / Approve-with-nits / Changes-requested |

**Codes from:** `../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` — the implementation
master this review closes the loop on.
**Story:** `../01-STORIES/US###.md` — the acceptance criteria the code must satisfy.

---

## 1. Scope & files reviewed

One or two lines: what this PR actually built (backend / API / frontend), and anything
explicitly out of scope or deferred to a follow-on story.

| File                                                  | Change                                      |
| ----------------------------------------------------- | ------------------------------------------- |
| _[EXAMPLE] `apps/{app}/services/{svc}.py`_            | _Created — {service}, {method}, guards_     |
| _[EXAMPLE] `apps/{app}/api.py`_                       | _Added `{endpoint}` operation + Schema_     |
| _[EXAMPLE] `apps/{app}/migrations/0002_add_field.py`_ | _Created — {model}, constraint, RLS policy_ |

_One row per changed file; delete the `[EXAMPLE]` rows._

---

## 2. Findings

Every issue raised, most severe first. Give each a stable `R-0NN` ID so actions and
re-review can reference it. `file:line` points at the exact site; `Resolution/Status`
tracks it to closure (Open / Fixed `{commit}` / Deferred `{US###}` / Won't-fix `{reason}`).

| ID                | Severity   | File:line                            | Issue                                                      | Resolution/Status    |
| ----------------- | ---------- | ------------------------------------ | ---------------------------------------------------------- | -------------------- |
| _[EXAMPLE] R-001_ | _Critical_ | _`apps/{app}/api.py:42`_             | _Endpoint runs before permission check_                    | _Fixed — `{commit}`_ |
| _[EXAMPLE] R-002_ | _High_     | _`apps/{app}/services/{svc}.py:88`_  | _User-supplied `id` not ownership-checked (IDOR)_          | _Fixed — `{commit}`_ |
| _[EXAMPLE] R-003_ | _Medium_   | _`apps/{app}/models/{model}.py:31`_  | _`null=True` mismatch between model and migration_         | _Deferred — US###_   |
| _[EXAMPLE] R-004_ | _Low_      | _`apps/{app}/services/{svc}.py:120`_ | _N+1: second query per call, no `select_related`_          | _Open_               |
| _[EXAMPLE] R-005_ | _Info_     | _`apps/{app}/schemas.py:15`_         | _`exclude_unset` partial-update pattern confirmed correct_ | _No action_          |

Severity scale: **Critical** (merge blocker — exploit, data loss, broken auth) ·
**High** (must-fix before merge) · **Medium** (fix now or ticket with a named story) ·
**Low** (nit — fix if cheap) · **Info** (observation, no action).

---

## 3. Dimension checklists

Tick each item, or mark `N/A` with a one-line reason. A failed item becomes a finding in
§2 and, if it blocks merge, a required action in §4. Run the checks through the project
scripts — never raw `pytest` / `pnpm` / `docker` / `python`.

### 3.1 Security (OWASP)

- [ ] **A01 — permission check before logic.** Every state-changing Django Ninja endpoint
      runs a named permission check as its **first** statement, before any `objects` query or write.
- [ ] **IDOR.** Every user-supplied ID is verified against the caller's ownership; no
      sequential/guessable IDs are exposed; `DoesNotExist` returns a clean not-found.
- [ ] **Secrets & DEBUG.** No hardcoded secrets, keys, or tokens; all via env vars.
      `DEBUG=False` assumed for every non-local environment; `CORS_ALLOWED_ORIGINS`
      is an explicit allowlist. Verify with `code/src/scripts/audits/security.sh`.

### 3.2 GDPR / PII

- [ ] **Encrypted at rest.** Any new PII field uses the Fernet-encrypted pipeline; no
      plaintext personal data in the store.
- [ ] **Erase & export coverage.** New personal data is reachable by the Art. 17 erasure
      and the access/export paths (or a tracked follow-up story names the gap).
- [ ] **No PII in logs.** No personal data, tokens, or raw IP written to logs or errors.
- [ ] N/A — no personal data processed. _{delete the boxes above and state this if true}_

### 3.3 Test coverage vs floors

- [ ] Backend coverage meets the module floor — `code/src/scripts/tests/backend-coverage.sh`.
- [ ] Template and HTMX-partial tests included in the coverage run — `code/src/scripts/tests/backend-coverage.sh`.
- [ ] Full suite green — `code/src/scripts/tests/all.sh` ({N} passed · 0 failed).
- [ ] Every acceptance criterion has at least one test; error, edge, and permission
      paths are covered, not only the happy path.

### 3.4 Quality, DRY & file length

- [ ] No copy-paste duplication; shared logic factored into a service/util.
- [ ] No new `TODO` / `FIXME` / `HACK` in shipped production code (deferrals go to
      `DEFERRED.md` / `GAPS.md`).
- [ ] Every source file ≤ **750 lines** (800 with grace) — `code/src/scripts/audits/cloc.sh`.
- [ ] Lint clean — `code/src/scripts/syntax/lint.sh`.

### 3.5 Performance

- [ ] No N+1 query in an endpoint or hot path (`select_related` / `prefetch_related`
      where a relation is walked in a loop).
- [ ] Appropriate caching / indexing for the added read paths; no unbounded query.

### 3.6 Accessibility (WCAG 2.2 AA)

- [ ] Accessibility verified on affected route(s) — pytest markup assertions plus the manual WCAG 2.2 AA checklist.
- [ ] Keyboard operable; logical focus order; visible focus ring; focus trap in any modal.
- [ ] Labels, contrast, and reduced-motion honoured; primary/secondary actions equal
      weight (no dark patterns).
- [ ] N/A — no user-facing UI in this story. _{state if true}_

---

## 4. Required actions before merge

Blockers only — each ties back to a `R-0NN` finding. Clear every row (or downgrade the
verdict) before the PR merges. "None — approved as-is." is a valid entry.

| Action                                           | Finding | Owner   | Status              |
| ------------------------------------------------ | ------- | ------- | ------------------- |
| _[EXAMPLE] Add permission check to `{endpoint}`_ | _R-001_ | _{dev}_ | _Done — `{commit}`_ |
| _[EXAMPLE] Ownership-filter `{id}` lookup_       | _R-002_ | _{dev}_ | _Done — `{commit}`_ |

---

## 5. Verdict & status transition

- **Verdict:** Approve / Approve-with-nits / Changes-requested.
- **Reasoning:** {one or two lines — what carries the verdict}.
- **Status transition:** {In Review → Accepted} (or `In Review → Rejected` /
  `Changes-requested → In Review` on re-review). Use the canonical status vocabulary from
  `project-management/docs/SPRINT-PLANNING-GUIDE.md`.

A `Changes-requested` verdict **blocks the merge** until every §4 action is `Done` and the
PR is re-reviewed.

---

## 6. Notes

Anything worth recording that is not a finding — a design call confirmed, a deferral
rationale, or a forward-compatibility pattern accepted. Keep it factual.

- _[EXAMPLE] {observation about a factory, migration split, or type organisation}._

---

## Cross-references

- `../01-STORIES/US###.md` — the story under review
- `../15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md` — the plan this code was written from
- `../16-TESTS/US###-TEST-STATUS.md` · `US###-MANUAL-TESTING.md` — the test records this review reads against
- `../10-QA/IMPLEMENTATION/QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the paired QA review from the same PR
- `../19-BUGS/` — file a `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` for any defect this review surfaces
- `code/docs/SECURITY.md` — the OWASP / IDOR obligations §3.1 checks against
- `project-management/workflows/20-pr-and-review/` — the PM workflow where this review is written
- `code/workflows/06-review/` — the code-review workflow the reviewer runs

> **Cross-cutting reviews** — an audit not tied to a single story (e.g. a cross-module
> alignment or design-token sweep) is filed as `REVIEW-<DESCRIPTOR>-DD-MM-YYYY.md` instead
> of `REVIEW-US###-*.md`; drop the story-specific header rows and the `US###` links.
