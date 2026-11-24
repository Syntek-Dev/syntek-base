# Findings — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

**Last Updated**: 24/11/2026 · **Story**: US014
**Status:** Open
**Status note:** F-003 and F-004 ruled 24/11/2026 and F-006 and F-007 fixed in US014; F-001 fixed in US014 under `../21-BUGS/BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md` (same root cause, an existing record), with a second generator defect filed as `../21-BUGS/BUG-US014-TEST-RECORD-ESCAPED-PIPE-SPLITS-CELL-24-11-2026.md`, and the manual guide is not yet walked — any row amended at the walk joins this record as a finding

| Field                | Value                                                                                                                                                                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**            | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                      |
| **Completed**        | Not yet — build, review and gates done 23/11/2026 on `us014/structured-json-logging` (base `b1705408`, uncommitted); the walk, the graph refresh and the PR are outstanding                                                               |
| **Recorded by**      | Claude Code (Opus), `22-implementation-documentation` Step 5 — the recorder wrote none of the story's code                                                                                                                                |
| **Assessed against** | `code/docs/LOGGING.md` + `logging/DJANGO-LOGGING.md`, `code/docs/TESTING.md`, `code/docs/FORWARD-VOICE.md`, `code/docs/GATE-REPORTING.md`, ADR-US014. `code/docs/DATABASE.md` does not apply — the story has no model, field or migration |
| **Outcome**          | 7 findings · 0 expensive-to-retrofit · 0 manual rows amended (guide not yet walked)                                                                                                                                                       |

**Codes from:** `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the
implementation master this story was built from.
**Story:** `../02-STORIES/US014.md` — the acceptance criteria the work satisfied.

---

## 1. Scope

US014 delivered the hand-written JSON formatter and `request_id` filter (`apps/core/observability.py`),
the stored id in `RequestIDMiddleware`, each environment's own `LOGGING`, the three entrypoints
without an access log, the dev logs mount, and the documentation set. Assessed against the
logging, testing, forward-voice and gate-reporting standards and the binding ADR. **Not assessed:**
the data layer (none), and the manual walk (a different tester's — any amendment it makes is
added here as a finding).

---

## 2. Findings

| ID    | Area            | Where                                                                                                              | Why it matters                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Smallest fix                                                                                                                                                                                              | Retrofit | Disposition                                                                                                                                                                                                                                                                                                                                 |
| ----- | --------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F-001 | Tooling         | `code/src/django/conftest.py` (the story-map writer) · `code/src/scripts/tests/backend.sh` / `backend-coverage.sh` | **The automated record cannot list a pytest test.** The writer dumps `session.items` to `reports/story-map.json` at the end of **every** pytest session, and the backend runners run two — unit, then integration. US014's 156 marked tests are all unit-tier, so the integration session rewrites the map as `[]` and `test-record.sh US014` writes "0 test rows" (measured 24/11/2026: `story-map.json` reads `[]` after both a full and a `-k` run). US014 is the first story with `.py` markers, so no earlier record could show it | Merge rather than overwrite across sessions of one run (key by `nodeid`), or write one map per phase and have `test-record.sh` read both                                                                  | Cheap    | **Bug — record owed** in `../21-BUGS/` through `code/workflows/10-debug/`, before US014's PR; the automated record carries the hand count meanwhile                                                                                                                                                                                         |
| F-002 | Docs            | `code/docs/logging/HEALTH-CONTRACT.md` — the `scrapeConfigs` example, line 106                                     | The Prometheus job is `<%ORG_SLUG%>-backend` with `service = "web"` — the container-name drift US014 removed from every log selector, surviving in a metrics label. Inert while `/metrics/` is unwired                                                                                                                                                                                                                                                                                                                                  | Name the job and label after the Compose service, `django`, when `/metrics/` is wired                                                                                                                     | Cheap    | **Deferred** — the `/metrics/` wiring story (uncut); recorded in `DEFERRED.md`, US014 section, with its trigger                                                                                                                                                                                                                             |
| F-003 | Line contract   | `apps/core/observability.py` · `_exception_shape`; EC-18                                                           | A `__context__` cycle's back-edge is **omitted** rather than written `null` (review L3). ADR-US014 and AC-GAP-4 read `null` as "no cause", so omission is the faithful reading — but omitting a key on an uncut line is a shape the ADR does not state, and the contract is a published interface                                                                                                                                                                                                                                       | <%DEVELOPER_NAME%> rules omit or `null`. If omit stands, record it against ADR-US014 _Consequences_ (no superseding ADR — no key is renamed or added); if `null`, a one-line change and EC-18's assertion | Cheap    | **Resolved 24/11/2026 — <%DEVELOPER_NAME%> ruling, option 1: omit.** Consistent with the existing "a cut link is omitted" rule; `null` keeps meaning "no cause". As built, no code change; recorded as plan Key Decision 20 and stated in `code/docs/logging/DJANGO-LOGGING.md` (_What a line carries_); QA-IMPL's L3 deviation reads ruled |
| F-004 | Line contract   | `apps/core/observability.py` · `JSONFormatter._format`, wide branch                                                | Dev's wide mode drops `record.stack_info`. The contract is silent on dev, so it is not a breach; keeping it would add a key to dev lines                                                                                                                                                                                                                                                                                                                                                                                                | If wanted, write `stack_info` in wide mode only, with a test                                                                                                                                              | Cheap    | **Resolved 24/11/2026 — <%DEVELOPER_NAME%> ruling, option 1: no change.** Wide mode keeps leaving `stack_info` out — out of US014's scope. Plan Key Decision 21; `DJANGO-LOGGING.md` _dev / test_ now says so                                                                                                                               |
| F-005 | Tooling (plan)  | `../11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` Section 2; story plan _Testing_                       | The plans pinned **one** test module for ~150 cases; the build needed five to stay under 750 lines (review L2). A plan that names a single file forces a deviation it could have foreseen                                                                                                                                                                                                                                                                                                                                               | A QA or story plan names the test **prefix** (`test_<module>*.py`) and the marker, not one filename, once its scenario count is large                                                                     | Cheap    | **Next story** — carry into the next story plan's _Testing_ section                                                                                                                                                                                                                                                                         |
| F-006 | Docs            | `apps/core/observability.py`:3-4 (docstring) · `config/settings/CLAUDE.md`:50                                      | Both cite PM artefacts — the ADR by full path, the story plan in prose — that `copier.yml` `_exclude` drops from a generated project (`/project-management/src/**`), so the cites dangle downstream (`code/docs/FORWARD-VOICE.md`, Direction B). `doc-references.sh` reads only `*.md` (`:1219`), so the `.py` cite is invisible to it                                                                                                                                                                                                  | State the rule in the shipped text and drop the path, or mark the line `doc-references: template-only`; `TODO(verify)` whether a `.py` docstring cite should be in the gate's scope                       | Cheap    | **Fixed 24/11/2026 in US014.** The docstring now cites the shipped `code/docs/logging/DJANGO-LOGGING.md`, and `config/settings/CLAUDE.md` drops the story-plan cite for the same doc — the rule itself already stated in place. The `TODO(verify)` on `.py` gate scope is not decided here and is carried (Section 4)                       |
| F-007 | Docs (template) | `../17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`:596; US014's plan, _Documentation Write-Ups_                   | The template names `23-pr-and-review` as the producer of the QA implementation review, but `22-implementation-documentation` Step 2 and `../11-QA/IMPLEMENTATION/CLAUDE.md` say `22` writes it and `23` only verifies. US014's plan inherited the row, and also listed no audit record, which `22` Step 3 calls "the post-build record". Both were written here at `22` regardless                                                                                                                                                      | Correct the template row to `22-implementation-documentation`                                                                                                                                             | Cheap    | **Fixed 24/11/2026 in US014.** The template row now reads `PM 22-implementation-documentation, verified at 23-pr-and-review`, matching `22` `STEPS.md`:72 and `23` `STEPS.md`:23                                                                                                                                                            |

> Nothing above is inferred without a measurement except where marked `TODO(verify)`.

---

## 3. Expensive to retrofit

None — no expensive-to-retrofit findings. The story has no schema, scope column, constraint or
key; every finding above is a code, test or documentation change.

---

## 4. Carried into the next story

| ID    | Carried as                                                                                           | Target                                                   |
| ----- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| F-001 | File the bug through `10-debug`; fix so `test-record.sh` lists pytest tests across both phases       | `../21-BUGS/` — before US014's PR, then the fixing story |
| F-005 | Name a test prefix and the marker, not one module, in the plan's _Testing_ section                   | The next story plan written                              |
| F-006 | Decide whether `doc-references.sh` should read `.py` docstrings (the two cites themselves are fixed) | The next story plan written                              |

F-002 sits in `DEFERRED.md` with its trigger. F-003 and F-004 were ruled and F-007 fixed on 24/11/2026, so none is carried.

---

## 5. Notes

- **Registers.** US014 claimed two entries at P0b and both left the registers then: the
  `DEFERRED.md` US013 row on the red _Audit — Doc References_ check and the `GAPS.md` entry of
  23/11/2026 on the eighteen PM citations. Both are **retired** — `audits/doc-references.sh` reads
  "Clean — every citation resolves" (exit 0, 23/11/2026). No unclaimed `GAPS.md` or `DEFERRED.md`
  entry was retired by this story, so nothing is closed here. The feature map's _Register
  claimed_ table claims nothing for slice S-07.
- **The 4xx `WARNING` volume** is accepted and recorded in the logging plan and record only — no
  `GAPS.md` row, by ruling (R2-Q3).
- **Standards confirmed applied:** standard library only, no dependency moved; one `DICT-OK:`
  marker at the serialisation boundary (Key Decision 11); `observability.py` 561 lines; the
  story marker on every US014 module; every dev operation through the scripts.
- **The review's MEDIUMs (M1, M2) were defects in the build, fixed test-first in the build** —
  recorded in the assessment record, not here, because they did not ship.
- **Manual guide:** present, authored at `17` (plan dated 01/11/2026), build slots filled. **Not
  walked at this step** — every `Result` cell is blank and is the next tester's. An amended row
  at the walk becomes `F-008` onward here.

---

## Cross-references

- `../02-STORIES/US014.md` — the story these findings came from
- `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the plan this closes the loop on
- `../19-REVIEWS/` — the merge-gating review record, written at `23`
- `../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` — the guide still to be walked
- `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` — where F-001 shows
- `../21-BUGS/` — where F-001's report is owed
- `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` — the contract F-003's ruling (omit) reads alongside; no key changed, so no superseding ADR
- `GAPS.md` · `DEFERRED.md` — F-002's deferral
- `project-management/workflows/22-implementation-documentation/` — where this is written
