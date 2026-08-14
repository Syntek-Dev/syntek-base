# API Verification — US000 {STORY TITLE}

_Template — copy to `API-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's own design, and delete this note
once populated. This is the **post-implementation** API verification; it confirms, with
evidence, the contract in `../PLANNING/API-PLAN-US000-TEMPLATE.md`. The API is the
project's single `NinjaAPI` — defined once in `config/api.py` and served under `/api/`._

| Field          | Value                                                |
| -------------- | ---------------------------------------------------- |
| **Story**      | US### — {short title}                                |
| **Date**       | {DD/MM/YYYY}                                         |
| **Sprint**     | {SPRINT}                                             |
| **Branch**     | `us###/{short-description}`                          |
| **Reviewer**   | {name / agent}                                       |
| **Design doc** | `../PLANNING/API-PLAN-US###-<DESCRIPTOR>.md`         |
| **Outcome**    | Matches contract / Matches with deviations / Blocked |

---

## 1. API surface shipped

Every endpoint the design contract named (design Section 1), marked against what the API actually
exposes. `Present` = shipped as designed; `Changed` = shipped with a different shape
(justify in Section 6); `Missing` = not shipped (deferral or blocker in Section 6).

| Endpoint                      | Type  | Result  | Evidence (route · handler)                    |
| ----------------------------- | ----- | ------- | --------------------------------------------- |
| [EXAMPLE] `GET /api/widgets`  | Read  | Present | `list_widgets` · `code/…/routers/widgets.py`  |
| [EXAMPLE] `POST /api/widgets` | Write | Changed | `create_widget` · `code/…/routers/widgets.py` |

_One row per endpoint in the design's API-surface table. Every contract endpoint must
appear here as Present, Changed, or Missing — no silent drops._

## 2. Contract conformance

Each Ninja Schema and endpoint from the design (design Sections 2–4), marked
`Present / Missing / Changed` against the shipped code, with a Python symbol and handler
file as evidence. One illustrative spec-vs-shipped block follows the tables.

### Schemas (response · request · enums · paged wrapper)

| Schema                          | Result  | Evidence (Python symbol · file)   |
| ------------------------------- | ------- | --------------------------------- |
| [EXAMPLE] `WidgetOut`           | Present | `code/…/schemas.py:WidgetOut`     |
| [EXAMPLE] `WidgetStatus` (enum) | Changed | one value renamed — see Section 6 |

_One row per Schema in the contract. Confirm field names, optionality, and enum values
match; note any field absent from — or added to — the shipped Schema._

### Read endpoints (GET)

| Endpoint                   | Params / pagination match | Result  | Evidence                                 |
| -------------------------- | ------------------------- | ------- | ---------------------------------------- |
| [EXAMPLE] `GET /…/widgets` | `limit`, `offset` — Yes   | Present | `code/…/routers/widgets.py:list_widgets` |

_Confirm query params, defaults/limits, ordering, and the null-vs-empty contract from
design Section 3._

### Write endpoints (POST/PATCH/DELETE)

| Endpoint                    | Request / response match         | Result  | Evidence                                  |
| --------------------------- | -------------------------------- | ------- | ----------------------------------------- |
| [EXAMPLE] `POST /…/widgets` | `WidgetCreate` → `201 WidgetOut` | Present | `code/…/routers/widgets.py:create_widget` |

_Confirm request Schema and response Schema/status from design Section 4; permission is verified
in Section 3._

### Illustrative comparison — spec vs shipped

Keep **one** small block showing the design contract beside the shipped Schema/handler, as
the conformance evidence pattern. Delete the rest; do not paste the whole API.

```python
# Design contract (../PLANNING/API-PLAN-US###-*.md Section 2)
class WidgetOut(Schema):
    id: UUID
    name: str
    status: WidgetStatus
```

```python
# Shipped (code/…/schemas.py)
class WidgetOut(Schema):
    id: UUID
    name: str
    status: WidgetStatus
```

_Assessment: {matches / diverges on `{field}` — justify in Section 6}._

## 3. Permission enforcement (OWASP A01)

Every endpoint from the design's permission matrix (design Section 6), confirmed against the
shipped handler. **Each write endpoint must carry an explicit named permission rule and an
ownership/IDOR check** on any user-supplied ID; each read endpoint gate confirmed likewise.

| Endpoint                    | Allowed callers | Permission rule enforced         | Ownership / IDOR check          | Evidence                       |
| --------------------------- | --------------- | -------------------------------- | ------------------------------- | ------------------------------ |
| [EXAMPLE] `POST /…/widgets` | `{role}`        | `require_perm("widgets.manage")` | caller owns `{parent_id}` — yes | `code/…/permissions.py:{rule}` |
| [EXAMPLE] `GET /…/widgets`  | `{role}`        | `require_perm("widgets.view")`   | N/A — no user-supplied ID       | session-authed handler         |

_Every endpoint in the contract appears here. A write endpoint with no explicit permission
rule, or a user-supplied ID resolved without an ownership check, is a **blocker** — record
it in Section 6 and set Outcome = Blocked. Keep consistent with `code/docs/SECURITY.md`._

## 4. Error types & pagination verified

Each error type from the design's error strategy (design Section 7) and the pagination contract
(design Sections 2–3), confirmed against the shipped behaviour. Errors route through the exception
handlers registered on the `NinjaAPI` instance.

| Error / behaviour    | Contract (design)                 | Shipped | Evidence                                    |
| -------------------- | --------------------------------- | ------- | ------------------------------------------- |
| [EXAMPLE] `NotFound` | HTTP 404 for a missing record     | Yes     | `code/…/routers/widgets.py` · `test_{name}` |
| [EXAMPLE] Rate limit | HTTP 429 + `Retry-After` on abuse | Yes     | middleware · `test_{name}`                  |
| [EXAMPLE] Pagination | `{ items, count }` envelope       | Present | `@paginate` · `code/…/routers/widgets.py`   |

_Confirm the null-vs-empty (empty envelope vs 404) and the `items`/`count` contract holds
against the running build, not the worktree._

## 5. Breaking changes

Assess the shipped API against existing consumers (design Section 8). "None — all endpoints new,
no consumers." is a valid entry.

- {Deprecation / additive-only note, or "None." — and any consumer impact. There is
  no codegen step; consumers read the JSON directly, so a removed field breaks at
  runtime.}

## 6. Deviations from the design & follow-ups

Any departure from `../PLANNING/API-PLAN-US###-*.md`, with justification. "None." is a
valid entry. A `Changed` or `Missing` in Sections 1–4 must be explained here.

| ID              | Contract (design)        | Shipped          | Justification                     |
| --------------- | ------------------------ | ---------------- | --------------------------------- |
| [EXAMPLE] D-001 | `{field}` typed as `{X}` | shipped as `{Y}` | {why — target story to reconcile} |

| Follow-up item                  | Priority | Target                 |
| ------------------------------- | -------- | ---------------------- |
| [EXAMPLE] {reconcile `{field}`} | Medium   | {US### / named sprint} |

_Every `[OPEN]` item resolves to Closed, a justified deviation, or a Deferred entry with a
`GAPS.md` link and a target story._

---

## Sign-off checklist

- [ ] Every contract endpoint and Schema marked Present / Changed / Missing (Sections 1–2)
- [ ] Every write endpoint carries an explicit permission rule **and** an ownership/IDOR check (Section 3, OWASP A01)
- [ ] Error types and pagination verified against the contract (Section 4)
- [ ] Breaking-change assessment complete (Section 5)
- [ ] Deviations justified; follow-ups tracked with a target story (Section 6)
- [ ] `US###`, design-doc link, sprint, and date present; British English; DD/MM/YYYY
- [ ] Reviewer approval — **blocks merge until complete**

---

## Cross-references

- `../PLANNING/API-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation contract verified here
- `../../02-STORIES/US###.md` — the story under review
- `code/docs/API-DESIGN.md` — Django Ninja conventions this contract follows
- `code/docs/SECURITY.md` — the permission/IDOR enforcement these checks must stay consistent with
- `../../17-TESTS/US###-TEST-STATUS.md` · `../../18-REVIEWS/` — downstream test and review records
- `project-management/workflows/21-implementation-documentation/` — where this verification is written
