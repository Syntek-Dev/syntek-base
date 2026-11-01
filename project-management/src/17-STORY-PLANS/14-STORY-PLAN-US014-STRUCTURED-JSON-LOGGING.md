# STORY-PLAN-US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field  | Value                                                                                                                                  |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| Date   | 01/11/2026                                                                                                                             |
| Branch | `us014/structured-json-logging`                                                                                                        |
| Sprint | SPRINT-08 · Wave 2 · build order 2                                                                                                     |
| Author | <%ORG_NAME%>                                                                                                                           |
| Board  | No status of its own — `STORY-PLANS-BOARD.md` shows this plan under its `US###`'s `**Status:**`; it moves to `archive/` with the story |

<!-- BORN WITH ITS PREFIX, 01/11/2026. The number "14-" was reserved for this story on 01/11/2026
     at 03-sprint-planning (grilling round 1 Q3), and recorded in ../02-STORIES/US014.md ->
     Dependencies (the sprint-membership bullet, "a reserved `14-`"), in
     ../03-SPRINTS/SPRINT-08.md -> Dependencies, and as a no-file row in
     ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Story Plans — the code master, which this file
     replaces at 17-story-plans Step 10. The prefix is the story's position in the settled build
     order across the WHOLE backlog — US007, US001, US002, US003, US004, US005, US006, US008,
     US009, US010, US012, US011, US013, US014 — not its sprint and not a per-sprint counter, so
     US014 is fourteenth, closing SPRINT-08 behind US013. It is RENUMBERED whenever build order
     changes, which is the OPPOSITE of the sibling rule for the sprint plans: a sprint plan carries
     two numbers and a mismatch between them is information, while a story plan carries one, so
     its prefix must track build order or it says nothing. ./CLAUDE.md owns the rule.

     Re-derived 01/11/2026 at HEAD 5234a27. The sprint plans in their own exec-order sequence are
     01- to 08-; ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Build order builds US013 then US014.
     The tracked run is contiguous 00- to 12- at 5234a27; US013's "13-" is reserved and not yet
     written, and this prefix does not depend on that file existing. The descriptor
     STRUCTURED-JSON-LOGGING matches the story's QA plan and GDPR plan, as every existing pair
     does. Wave 2 is the story's place in its map's cutting order — slice S-07 of
     ../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md, order 2 of the RULE-OWNERSHIP section after S-01
     (US013) — and build order 2 is second of {US013, US014}. -->

<!-- STEP 1 DREW ITS ROUND FROM THE RECORDED ANSWERS (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). The story's scope was settled by its cutting interview
     ("grilling 31/10/2026, Qn"), the three specify-gate rounds of 01/11/2026 ("gates grilling
     01/11/2026, Qn", "R2-Qn", "R3-Qn"), the 15-decisions round that accepted
     ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026, and 16-sprint-plans grilling round 1 Q1 (the
     merge order against US008). All five gate plans read Signed off 01/11/2026 and no gate holds
     an [OPEN] row. Facts recorded for this plan, each confirmed with <%DEVELOPER_NAME%> on
     01/11/2026 and none reopening a gate ruling: the lane is 19-backend-code only, 20 and 21 N/A;
     ADR-US014 binds and wins where it and this plan differ; US014 merges after both US013 and
     US008, in whichever order those two land, and if US008 has not merged US014 waits (since
     tightened to a start gate, round 2 Q3 below); Step 10 moves the story Open -> Blocked
     because both read Open; the security
     count is the assessment's twenty findings (18 LOW, 2 INFO), the story's FLAGS-comment "19 /
     17" being dated history from before round 3; the Docker & Nginx section carries the US006 /
     US008 treatment of the per-story Nginx and port-block disagreement without resolving it; and
     the host-path command cites are re-measured after US013 merges, as the story already says
     (under round 2 Q3, at P0, on a base commit that already contains US013).

     ONE ROW OF THE MANUAL TESTING GUIDE COULD NOT BE DECIDED FROM THE RECORDS and was not
     guessed: no record names the tool a walker uses to make the probe request and read its
     header, or to parse the host line, and no code/src/scripts/**/*.sh script does either. It
     went to <%DEVELOPER_NAME%> as 17-story-plans grilling round 1 Q2 and was answered 01/11/2026,
     option 1 of four: open /us014-probe-404/ at the base URL server.sh up prints and read
     X-Request-ID in the browser devtools Network panel; parse the matching host
     code/src/logs/django.log line with `jq .`; where jq is absent the row is recorded unmeasured
     per code/docs/GATE-REPORTING.md (marked Fail, "Unmeasured — jq absent", since round 2 Q2). Precedent: the Browser journey inside US008's CLI-surface
     guide (COOKIE-01 to COOKIE-06). Recorded as Key Decision 12, and the guide's DEVLOG rows are
     written from it.

     Measured on pm/story-creation at 5234a27, 01/11/2026. Every line cite into 09 STEPS.md, 09
     CONTEXT.md and the code/src/logs/ pair is that tree's and is re-measured after US013 merges,
     never inherited (../02-STORIES/US014.md -> Dependencies); every cite into base.py, staging.py,
     production.py, config/settings/CONTEXT.md and EDGE-REQUIREMENTS.md is likewise re-measured
     after US008 merges. Since round 2 Q3 both re-measurements happen once, at P0, on the branch's
     base commit (Approach -> P0); P5R re-measures again only for a later upstream merge.

     Step 9 review, 01/11/2026: the Table of Contents is kept (the template's own criterion — large,
     GDPR, multi-phase — is met); US013 was drafted as a merge-order dependency, not a start gate
     (option (a) of the review finding, matching ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md -> Build
     order). THAT READING IS REVERSED by round 2 Q3, below. -->

<!-- 17-STORY-PLANS GRILLING ROUND 2, answered by <%DEVELOPER_NAME%> on 01/11/2026 (cited
     "17-story-plans grilling round 2, Qn"). Q1 (09 STEPS.md:42 does not breach US013's AC) and Q5
     (the hosts-story-add.sh us008 form in US008's plan, fixed by the main session in its own
     commit) bind US013 and US008, not this plan; US014's own files already use the numeric 014.
     Three bind here:
     - Q2 = 1: a manual row that cannot be run is Result = Fail, Notes "Unmeasured — <reason>",
       plus a Failures row routed per code/docs/GATE-REPORTING.md, and the sign-off Outcome is
       Blocked. Never Pass, never blank. Key Decision 16; the guide's "Unmeasured rows".
     - Q3 = 2: US013 and US008 are HARD START GATES. Nothing of US014 starts — P0 onward, the
       before-first-edit baselines included — until both have merged; the branch is cut from main
       after both have landed. Step 10 moves US014 Open -> Blocked (completion's call), and to
       Pending once both have merged. This REVERSES the draft's option (a) (P0 to P4 startable once
       the branch exists), and for US014's START supersedes the merge-order-only reading in
       ../03-SPRINTS/SPRINT-08.md -> Dependencies and ../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md ->
       Build order. Key Decision 13; Dependencies.
     - Q4 = 1: slot E (the four doc gates re-run on a checkout of an upstream merge commit, the
       commit recorded) is kept; ADR-US003's baseline-before-first-edit still binds the first edit.
       Under Q3 it applies only if a further upstream US014 depends on merges to main after the
       branch is cut. Key Decision 17; Approach -> P5R. -->

Implements **`../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md`** (the line
contract, the edge/collector contract, minimisation in place of redaction) — **Accepted
01/11/2026**. Its citation criterion is read under
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (a baseline
captured before the first edit, read as a diff, kept in the manual testing guide) unless US004 has
landed and `doc-references.sh` is green.

> **Source authority.** Where this plan and `../02-STORIES/US014.md` differ on **what must be
> true**, the story wins; where they differ on **the line or collector contract**,
> `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` wins over both until a decision
> supersedes it by full filename. Where this plan and `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`
> differ on sprint facts, `../03-SPRINTS/SPRINT-08.md` wins. GDPR authority:
> `../09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md`. On how any gate's result is
> reported, `code/docs/GATE-REPORTING.md` wins over everything here. This plan records the
> engineering route, not the requirement.

Two template sections are dropped: **Pre-existing bug fixes** (every defect this story corrects —
the plain-text `LOGGING`, the "third in the pipeline" comment, the invalid-JSON `"format"` template,
the wrong selector labels — is in its own scope, not fixed en route) and the **As-Built Summary**
(this plan is forward-looking). The four per-layer sections are dropped under _Approach_, each with
its reason. The **Table of Contents** is kept, trimmed to the sections kept: the plan is large,
multi-phase and carries a mandatory GDPR section — the template's own criterion for keeping it.

---

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [Reference Documents (code/docs gate map)](#reference-documents-codedocs-gate-map)
3. [Architecture Decision](#architecture-decision)
4. [Approach](#approach)
5. [Key Decisions](#key-decisions)
6. [Dependencies](#dependencies)
7. [GDPR](#gdpr)
8. [Security](#security)
9. [Logging & Observability](#logging--observability)
10. [Performance, Rendering, Responsive & Accessibility](#performance-rendering-responsive--accessibility)
11. [Implementation Workflows & Standards](#implementation-workflows--standards)
12. [Execution & Verification via Claude Dynamic Workflows](#execution--verification-via-claude-dynamic-workflows)
13. [Quality Gates, Scripts & Local↔Docker Alignment](#quality-gates-scripts--localdocker-alignment)
14. [Testing](#testing)
15. [Documentation Write-Ups (Implementation Records)](#documentation-write-ups-implementation-records)
16. [CONTEXT.md & Index Updates](#contextmd--index-updates)
17. [Status Propagation & ClickUp Sync](#status-propagation--clickup-sync)
18. [Deferred Items](#deferred-items)
19. [Risks](#risks)
20. [Docker & Nginx Infrastructure](#docker--nginx-infrastructure)
21. [Sprint Verification Checklist](#sprint-verification-checklist)
22. [Definition of Done](#definition-of-done)

---

## Problem Statement

**Why this story exists.** Twelve shipped documents promise that staging and production write one
JSON object per line on stdout, and `code/docs/security/MONITORING-AND-INCIDENT.md`:42-43 requires a
correlation identifier in every entry. Neither is true: the repository fails its own security
guide, and every documented LogQL query returns nothing. Story:
`project-management/src/02-STORIES/US014.md` (Must, 8 SP; map slice `MAP-RULE-OWNERSHIP` S-07,
node N-020).

**Current state / gap** (measured at `5234a27`, the story's own re-measurement confirmed):

- No `apps/core/observability.py`, no `logging.Formatter` or `logging.Filter` subclass, and no
  `import logging` anywhere under `code/src/django/`; no JSON dependency in `uv.lock`.
- `LOGGING` is assigned five times — `base.py`:203, `dev.py`:43, `test.py`:38, `staging.py`:33,
  `production.py`:39 — and the base, staging and production blocks are identical plain text to
  `StreamHandler`'s default stderr.
- `RequestIDMiddleware` keeps the id in a `ContextVar` only (`middleware.py`:19-22) and is reset
  before Django's `log_response` writes a returned-error `django.request` line, so that line could
  not carry its request's id even with a filter.
- `base.py`:50 calls the middleware "Third in the pipeline"; `MIDDLEWARE` (`:48-55`) lists it second.
  `EDGE-REQUIREMENTS.md` entry 13 (`:276-292`) repeats "registered third" at `:281` and does not say
  the edge discards a client-supplied `X-Request-ID`.
- The staging, production and test entrypoints pass `--access-logfile -`
  (`entrypoint.staging.sh`:30, `entrypoint.prod.sh`:31, `entrypoint.test.sh`:27): a plain-text line
  per request holding the peer address and query string, with no `request_id`. Staging runs the
  process server at `--log-level info` (`:29`) where production runs `warning` (`:30`).
- The dev `django` service mounts only `../django` (`docker-compose.dev.yml`:50-51), so the
  `RotatingFileHandler`'s file never reaches the host.
- The selectors name containers that do not exist — `-backend` (09 `STEPS.md`, five sites), `-web`
  and `(web|worker)` (`OBSERVABILITY.md`), `-worker` (already marked absent at `:127-129`).

**What this story delivers.**

- `apps/core/observability.py`: one hand-written `logging.Formatter` subclass (wide in dev, minimal
  in staging and production) and one `logging.Filter` subclass, standard library only.
- `LOGGING` rewritten in dev, test, staging and production, the filter on every handler;
  `base.py`'s block deleted.
- `RequestIDMiddleware` storing the validated or minted id on the request it serves.
- The three entrypoints without `--access-logfile`; staging's process server at `warning`.
- The dev logs bind mount.
- `EDGE-REQUIREMENTS.md` entry 13's unconditional clause and position fix, plus a new
  log-collection section and summary row.
- The documentation set `US014.md` → _Documentation Tasks_ names.
- `apps/core/tests/unit/test_observability.py` and an extended `test_middleware.py`.

**Out of scope** (mirrored in _Deferred Items_): redaction, OTLP and metrics (`syntek-observability`);
named loggers and instrumentation; the security and audit stream; a non-Loki query language; the
Prometheus scrape job's label; the retrieval procedure (`S-08`, Held); routing the process-server
stream through `LOGGING`; a per-subject log search; correlating records outside the middleware's
dynamic extent; atomicity of lines over 4 KiB across workers.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                     |
| ----------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------- |
| Database / models / migration | —         | No model, field or migration (`US014.md` Flags: DB N/A)                                                                   |
| Service layer                 | —         | `observability.py` is logging infrastructure in `apps/core`, not a domain service                                         |
| Django Ninja API              | —         | No router, endpoint, Schema or MCP tool (Flags: API N/A)                                                                  |
| Frontend (templates)          | —         | No view, template, component or CSS (Flags: Frontend N/A)                                                                 |
| Infrastructure / DevOps       | ✓         | Five settings modules, `RequestIDMiddleware`, three entrypoints, one Compose mount, `EDGE-REQUIREMENTS.md`                |
| GDPR / PII                    | ✓         | PII is **incidental**, no new field collected; minimisation, not redaction (`GDPR-PLAN-US014`) — Section _GDPR_ mandatory |

---

## Reference Documents (code/docs gate map)

| Concern (when it gates)                                    | Authoritative doc(s)                                                                                                                                                                                         | Applies? |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| **URL / route / slug / admin path**                        | `code/docs/URL-STRATEGY.md` — no route is added; the test views are fixtures under `pytest.mark.urls`, mounted nowhere                                                                                       | —        |
| **Coding principles**                                      | `code/docs/CODING-PRINCIPLES.md` + `BACKEND-CODING-PRINCIPLES.md` (`:324` is a borderline line this story corrects); `coding-principles/STYLE-AND-PROCESS.md` — `:121`, the _Dependencies_ gate (no library) | ✓        |
| **Architecture**                                           | `code/docs/ARCHITECTURE-PATTERNS.md`; `architecture/SERVICE-AND-MIDDLEWARE.md` (the middleware's stored id); `config/settings/CLAUDE.md`:39-41 (each environment's own `LOGGING` — a dated exception)        | ✓        |
| **Data structures / schema**                               | `data-structures/TYPES-OVER-DICTIONARIES.md` + `TYPES-EXCEPTIONS.md` exception 3 (the serialisation boundary) — see _Key Decisions_ 11                                                                       | ✓        |
| **API design**                                             | No schema or endpoint                                                                                                                                                                                        | —        |
| **Security**                                               | `code/docs/SECURITY.md`; `security/MONITORING-AND-INCIDENT.md` (`:40-45`, the two streams); `security/OWASP-AND-CHECKLIST.md` (A09:2025)                                                                     | ✓        |
| **Encryption**                                             | No PII field                                                                                                                                                                                                 | —        |
| **RLS**                                                    | No row-scoped data                                                                                                                                                                                           | —        |
| **Rendering / Responsive / Accessibility / Design tokens** | No UI                                                                                                                                                                                                        | —        |
| **Performance**                                            | `code/docs/PERFORMANCE.md` — the 16 KiB cap and the accepted 4xx `WARNING` volume (_Performance_ below)                                                                                                      | ✓        |
| **Scale / readiness / server contract**                    | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — entry 13 and the new log-collection section; anti-forecast, a contract statement, not provisioning                                                   | ✓        |
| **Logging / observability**                                | `code/docs/LOGGING.md`; `logging/DJANGO-LOGGING.md` (`:35` already names `apps/core/observability.py`); `logging/OBSERVABILITY.md`; `code/workflows/09-debugging-with-logs/`                                 | ✓        |
| **Testing**                                                | `code/docs/TESTING.md`; `testing/{BACKEND-TESTING,COVERAGE}.md`; `code/docs/NEGATIVE-SPACE.md` (`RequestIDMiddleware` stays listed)                                                                          | ✓        |
| **Gate reporting**                                         | `code/docs/GATE-REPORTING.md` — the unmeasured runtime halves (ES-07, ES-10, jq absent; a guide row `Fail`, `Unmeasured — <reason>`) and the collector half nobody here can test                             | ✓        |
| **Cloudinary**                                             | No media                                                                                                                                                                                                     | —        |

> Cross-layer compliance guides also gate this plan: `project-management/docs/SECURITY-GUIDE.md`
> (STRIDE), `project-management/docs/GDPR-GUIDE.md`, `project-management/docs/QA-GUIDE.md`,
> `project-management/docs/GIT-GUIDE.md`. `SEO-CHECKLIST.md` and `VERSIONING-GUIDE.md` do not gate
> it: no public page, and no release is cut inside the story.

---

## Architecture Decision

The story makes a cross-cutting choice, and it is already recorded:
`../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` takes **Options D, G, I and K**
together.

- **D — the formatter and filter are hand-written** in `apps/core/observability.py`. The
  contract-specific code (the exception shape, the ordered cut to 16 KiB, the never-raise fallback)
  is ours under every option, so a library adds a dependency without removing it
  (`STYLE-AND-PROCESS.md` _Dependencies_ question 1). The formatter, filter and the middleware's
  `ContextVar` sit in one module a reviewer reads and one surface a test drives.
- **G — the collector relabels** `com.docker.compose.service` to `service_name` and
  `com.docker.compose.project` to an environment label; every documented query is
  `{service_name="django"}`.
- **I — the edge sets `X-Request-ID` unconditionally**, discarding a client's value; the app's
  alphabet check (`middleware.py`:17) stays as the backstop.
- **K — minimise, never redact.** The staging/production extras allowlist and the dropped `exc_info`
  message are the whole promise; `message` is named as unscrubbed.

**What is fixed by the ADR** — the line contract field by field (its _Decision_ table): `timestamp`,
`level`, `logger`, `message`, `request_id`, the allowlisted extras, `exc_info`, `truncated`. A field
rename is a breaking change to every generated project's queries and needs a **superseding ADR
and a `copier update` advisory**, not an edit. The only supersession trigger is the decision that
builds `syntek-observability` (a second Syntek product needs the scrub list, or tracing is
un-deferred). Separately, the deployment posture leaving `development` (`.claude/CLAUDE.md`
Section 0) sends the ADR back for **re-review** against a live surface — a review, not a
supersession (ADR-US014 _Consequences_).

**What this story is free to choose** — the internal shape of the module (how the mode is selected
from each environment's `LOGGING`, how the cut is ordered within the ADR's survivors, how the
reserved set is derived from `makeLogRecord`), so long as every pinned test in the ADR's
_Consequences_ holds.

**The collector and edge half is a contract this repository states and cannot test.** It is
realised in the deploy repository (`<%DEPLOY_REPO%>`). **Ordering:** entry 13's clause must be
deployed before any surface goes live or entry 2's CSP nonce is activated (`THREAT-MODEL-PLAN-US014`
Section 3a, TM-01).

---

## Approach

### Not applicable — Database, Service Layer, Django Ninja API, Frontend

- **Database** — no model, field, index or migration; `migrate.sh check` — no pending migration
  (the story touches no model).
- **Service layer** — `observability.py` is logging infrastructure beside `middleware.py` in
  `apps/core`, not business logic; no `services/` module is touched.
- **Django Ninja API** — no router, endpoint, Schema or MCP tool, so `20-api-code` is N/A.
- **Frontend** — no view, template, component or CSS, so `21-frontend-code` is N/A.

The story runs in one PM lane, **`19-backend-code`**, with `code/workflows/01-implement-story/` as
its spine and `02-tdd-cycle/` inside it (`../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` → _Phase
Breakdown_).

### Phase plan

The phases are this plan's sequencing; their content is the story's. Each lands with its tests.

- **P0 — Start gate and baselines** (before the first edit).
  - **Start gate:** **US013 and US008 have both merged to `main`** (and `pm/story-creation`
    before them); the branch is then cut from `main` (_Dependencies_). Both are **hard start
    gates**, not merge-order dependencies — nothing below runs before both have landed
    (17-story-plans grilling round 2, Q3, superseding for US014's start the merge-order-only
    reading in `../03-SPRINTS/SPRINT-08.md` → _Dependencies_ and
    `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` → _Build order_).
  - **Baselines:** the four doc gates' findings by identity, with `HEAD` (the base commit, which
    contains both upstream merges), the detector hash and the index state, into the guide's
    _Recorded during the build_ slot A (`QA-PLAN-US014` Section 6; ADR-US003).
  - **Re-measure, never inherit** — on the base commit, before the first edit. Every cite into 09
    `STEPS.md`, 09 `CONTEXT.md` and the `code/src/logs/` pair as US013 left them: the selector lines
    (slot D), the `:34` test tick, the host-path read commands (slot C; at `5234a27`
    `code/src/logs/CONTEXT.md`:41, :44, :47 and `CLAUDE.md`:21-22), the borderline lines and the
    four tree annotations (slot F). Every cite into `base.py` (at `5234a27` `:50`, `:201-217`,
    `:203`), `staging.py`, `production.py`, `config/settings/CONTEXT.md` and `EDGE-REQUIREMENTS.md`
    (entry 13 at `:276-292`, `:281`) as US008 left them; and confirm `negative-space.sh`, which
    US008 also edits, still lists `RequestIDMiddleware`.
  - **Baseline:** `bash code/src/scripts/syntax/check.sh`.
  - **Exit:** slots A, C, D and F filled and dated, or each recorded as missed.
- **P1 — `observability.py`, test-first.** Red → Green per behaviour, in `test_observability.py`.
  - **Filter:** sets `record.request_id` unconditionally from `current_request_id()`, maps `""` to
    `None`, returns `True`. For a returned-error `django.request` record it falls back to the id
    stored on the `request` extra, never to `request.META`; a `request` extra with no stored id gives
    null.
  - **Formatter, common:** payload from `record.__dict__` minus the reserved set derived from
    `logging.makeLogRecord({}).__dict__` plus `message` and `asctime`;
    `json.dumps(..., default=str, ensure_ascii=True)`; `timestamp` UTC to the millisecond whatever
    `TZ` is; `request_id` null when the attribute is absent.
  - **Wide (dev):** every extra; the five fixed keys written after the extras; the full traceback.
  - **Minimal (staging/production):** only `duration_ms`, `status_code` and `method`; `exc_info` as
    `{"type", "frames", "cause", "context"}` with frames `{filename, lineno, function}`, type-only
    links, group `members` as type names, notes, `stack_info` and `exc_text` dropped; never delegates
    to `logging.Formatter.format` or `formatException`; the iterative chain walk; the 16 KiB cap on
    the escaped line plus its newline, with `"truncated": true`, the outermost type and innermost
    frame surviving, a cut link omitted, a record under the cap uncut and unmarked.
  - **Never raises:** the fallback writes the fixed field set and the kept extras, each
    unserialisable value coerced in place through a guarded `repr`; `message` is `str(record.msg)`
    without its args when `getMessage()` fails; no marker key is added (R3-Q2).
  - **Types:** type hints throughout; the fixed field set a named type, the `json.dumps` payload and
    the dynamic extras under a `DICT-OK:` marker (_Key Decisions_ 11). The module stays under 750
    lines; plan the split before it crosses.
  - **Exit:** every U-fmt scenario in `QA-PLAN-US014` Section 2 green.
- **P2 — The stored id.** `RequestIDMiddleware` stores the validated or minted id (never the raw
  header) on the request; its `:19-22` comment says the `ContextVar` serves in-chain consumers and the
  attribute serves records logged after the chain resets it. `test_middleware.py` gains the EC-16
  test under a function-level `@pytest.mark.story("US014")`. `negative-space.sh` still lists the
  middleware. **Exit:** EC-16 green (the stored id on the request).
- **P1 + P2 joint exit** — checked when the later of the two lands, before P3: the returned-error
  U-client scenarios HP-08, HP-09 and EC-05 green; they need the filter's fallback (P1) and the
  stored id (P2) both.
- **P3 — The five settings modules.**
  - **dev:** wide JSON, console plus the existing `RotatingFileHandler`, root `DEBUG`; `django`
    (`:65`) and `django.db.backends` (`:68`) unchanged.
  - **staging and production:** minimal JSON, console to `ext://sys.stdout`, root `WARNING`,
    `"django": {"handlers": [], "level": "WARNING"}`, identical dicts.
  - **test:** one console handler with no formatter, root `WARNING`, the same `django` entry.
  - **Every handler** carries the filter; no named `django.request` or `api` logger.
  - **base.py:** `:201-217` deleted with its "replaces this wholesale" comment; `:50` reads second.
  - **`config/settings/CLAUDE.md`:39-41** gains the dated exception.
  - **Exit:** every U-dict and U-capsys scenario green, the negative fixtures included.
- **P4 — Entrypoints and the dev mount.**
  - `--access-logfile -` removed from `entrypoint.staging.sh`:30, `entrypoint.prod.sh`:31 and
    `entrypoint.test.sh`:27, `--error-logfile -` kept.
  - `entrypoint.staging.sh`:29 to `--log-level warning`; `entrypoint.test.sh`:26 keeps `info` — not
    in the ruling (`LOGGING-PLAN-US014` Section 2.3).
  - `../logs:/workspace/code/src/logs` bind-mounted on the dev `django` service.
  - **Exit:** the dev stack comes up through `server.sh up` and writes `django.log` on the host.
- **P5R — Rebase onto a later upstream merge (conditional).** US013 and US008 are already in the
  base (P0), so P5R never runs for them. It runs only if a **further** upstream story US014
  depends on merges to `main` after the branch is cut — a later edit to the same settings modules,
  the 09 folder, the `code/src/logs/` pair or `EDGE-REQUIREMENTS.md` — before P5 where it touches
  a file P5 edits, else before P6 (17-story-plans grilling round 2, Q4). Each pass:
  - **Rebase** onto `main` at that story's merge commit.
  - **Re-measure, never inherit** — every cite into a file that merge touched, re-taking the
    affected slots C, D and F; and `negative-space.sh` still lists `RequestIDMiddleware`.
  - **Re-baseline:** the four doc gates run, in slot A's form, on a checkout of that merge commit
    itself (no US014 edit in it), recorded in slot E naming that commit — so GATES-05 attributes
    the upstream story's own findings to it, never to US014. ADR-US003's baseline before the first
    edit (slot A) still binds that edit; slot E only moves the diff base.
  - **Exit:** the rebase clean, the re-measured cites recorded, slot E filled for that commit. If
    no such merge occurs, slot E reads `None — no upstream merge after the branch was cut`, dated
    at P6.
- **P5 — Documentation.** The Documentation, GDPR, Security and Logging tasks of `US014.md`, at the
  lines measured at P0 (or re-measured at P5R): `DJANGO-LOGGING.md`, `OBSERVABILITY.md`, 09 `STEPS.md` and `CONTEXT.md`,
  `LOGGING.md`, the `code/src/logs/` pair, `EDGE-REQUIREMENTS.md` (entry 13 and the new section),
  `MONITORING-AND-INCIDENT.md`, the `apps/core` and `tests/unit` `CONTEXT.md` files,
  `config/settings/CONTEXT.md`, `docker/CONTEXT.md`, `.claude/skills/logging/SKILL.md`:83,
  `DATA-INVENTORY.md`:199 and :201, and the borderline lines. **Exit:** every Static scenario and
  every static row of the manual guide reads true.
- **P6 — Close.** On the branch, whose base already contains US013 and US008, plus any P5R
  rebase: the four doc gates against the latest baseline (slot E's most recent entry, else slot
  A); the verification checks; the implementation records; the code-review-graph staged then
  refreshed; the manual guide walked at `22` by a tester other than the author. US014's PR
  therefore always follows both upstream merges (16-sprint-plans grilling round 1 Q1 holds by
  construction).

**Phase dependencies.** Both upstream merges precede P0, and P0 precedes everything. P1 precedes P3,
because the settings reference the module's classes. P2 is independent of P1 and P3 and may run in
parallel; the P1 + P2 joint exit needs both. P4 is independent of P1 to P3. P5 needs P1 to P4,
because it describes them. A conditional P5R precedes P5 where its merge touches a file P5 edits,
else P6. P6 is last.

---

## Key Decisions

| #   | Decision                               | Chosen                                                                                                                                                         | Rejected / Alternative                                                                      | Reason                                                                                                                                                                                                            |
| --- | -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Where the formatter comes from         | Hand-written in `apps/core/observability.py`, standard library only (Option D)                                                                                 | A do nothing; B `python-json-logger`; C `structlog`; E `syntek-modules`                     | The contract code is ours under every option; locality; E cannot reach this tree. ADR-US014 _Decision_ Axis 1; N-020; `STYLE-AND-PROCESS.md`:121                                                                  |
| 2   | How queries select the service         | Collector relabels `com.docker.compose.service` → `service_name`, `com.docker.compose.project` → environment (Option G)                                        | F container-name selectors                                                                  | Survives a second replica; the environment label stops staging and production merging. ADR-US014 Axis 2; `LOGGING-PLAN-US014` 5.1                                                                                 |
| 3   | Who mints the correlation id           | The edge, unconditionally, discarding a client value; the app's alphabet check stays (Option I)                                                                | H the app mints every id                                                                    | The id is only worth having if the edge log, audit trail and nonce carry the same one; closes TM-01. ADR-US014 Axis 2; gates grilling Q7                                                                          |
| 4   | Personal data in the line              | Minimise — allowlist off dev, no message in `exc_info`, `message` named unscrubbed (Option K)                                                                  | J ship a scrub now                                                                          | No document lists what a scrub would scrub; a guarantee not kept is worse than none. ADR-US014 Axis 3; Q9, Q11, gates Q6                                                                                          |
| 5   | The line contract                      | The ADR's field table: five fixed keys, three extras off dev, the pinned `exc_info` shape, `truncated`; `ensure_ascii=True`; UTC timestamp                     | Any field renamed or added by edit                                                          | A published interface; a rename needs a superseding ADR. ADR-US014 _Decision_ and _Consequences_; grilling 31/10/2026 Q4                                                                                          |
| 6   | Line size                              | Minimal line plus newline ≤ 16 384 bytes, `"truncated": true`, type and innermost frame survive; dev uncapped                                                  | No cap (Docker splits at 16 KiB); a cap on input characters                                 | Docker never splits a capped line; the escaped output is what Docker measures. R3-Q1; QA plan AC-GAP-10, Section 6                                                                                                |
| 7   | Formatter failure                      | Never raises: guarded-`repr` fallback, extras coerced in place and still allowlisted, `str(record.msg)`, no marker key                                         | A `format_error` marker; `Handler.handleError`                                              | R2-Q5, R3-Q2; adding a marker changes the ruled shape and goes back to <%DEVELOPER_NAME%> (`ASSESSMENT-PLAN-US014` 7.5)                                                                                           |
| 8   | The returned-error `django.request` id | `RequestIDMiddleware` stores the validated or minted id on the request; the filter falls back to it                                                            | Read `request.META`; accept null on those lines                                             | `META` holds the raw inbound header, so a rejected hostile value would be logged. R2-Q4; TM-03; QA plan Section 8                                                                                                 |
| 9   | Per-environment shape                  | dev wide + file, root `DEBUG`; staging = production minimal to stdout, root `WARNING`; test console, no formatter; `django` at `WARNING`, no handlers, off dev | One `LOGGING` in `base.py`; named `django.request` / `api` loggers                          | Q6, Q8, Q10; R2-Q2; N-020 (nothing writes to named loggers); `config/settings/CLAUDE.md`:39-41 exception                                                                                                          |
| 10  | The process-server stream              | Stays plain text on stderr, documented with `{service_name="django"} \| json \| __error__!=""`; access log dropped outside dev; staging at `warning`           | Route `gunicorn.error` / `uvicorn.error` through `LOGGING`; reformat the access log as JSON | Q1, R2-Q1, R3-Q4, R2-Q8 (dev keeps uvicorn's access log); QA plan Section 8                                                                                                                                       |
| 11  | Dictionaries in `observability.py`     | The fixed field set a named type; the `json.dumps` payload and dynamic extras under `DICT-OK: <reason> — confined to <boundary>`                               | Bare dicts throughout                                                                       | No US014 record names it; the doctrine settles it — `observability.py` is in `dict-discipline.sh`'s scan, and the payload is exception 3 (`TYPES-EXCEPTIONS.md`, the serialisation boundary)                      |
| 12  | How the manual walk probes and parses  | Browser devtools Network panel at the base URL `server.sh up` prints for `X-Request-ID`; `jq .` on the host line; jq absent → unmeasured (as Key Decision 16)  | `curl -si`; outcome-only rows; a new probe script                                           | **17-story-plans grilling round 1 Q2, 01/11/2026, <%DEVELOPER_NAME%>, option 1.** No raw interpreter; US008's Browser journey precedent; a new script would widen the edit set                                    |
| 13  | Start and merge order                  | US013 and US008 are **hard start gates**: US014's branch is cut from `main` after both have merged, in whichever order they land; P0 onward waits on both      | Option (a), P0 to P4 startable once the branch exists; land US014 first and rebase US008    | **17-story-plans grilling round 2 Q3, 01/11/2026, option 2**, tightening 16-sprint-plans grilling round 1 Q1; supersedes for US014's start `SPRINT-08.md` _Dependencies_ and `08-SPRINT-PLAN-08.md` _Build order_ |
| 14  | Story points                           | 8 SP, kept                                                                                                                                                     | Split, or 13                                                                                | R3-Q5; the module, settings and docs are one claim false until all three land (`US014.md` Story Points)                                                                                                           |
| 15  | Cites into the upstream-edited files   | Measured once at P0 on the base commit containing both merges; re-measured at P5R only for a later upstream merge                                              | Measure at `5234a27` and re-measure on each upstream rebase                                 | Follows from Key Decision 13; `US014.md` Dependencies ("re-measured after US013 merges, never inherited")                                                                                                         |
| 16  | A manual row that cannot be run        | `Result` `Fail`, `Notes` `Unmeasured — <reason>`, a _Failures_ row routed per `code/docs/GATE-REPORTING.md`; sign-off _Outcome_ Blocked                        | `Pass`; a blank `Result`; an "unmeasured" mark outside `Pass`/`Fail`                        | **17-story-plans grilling round 2 Q2, 01/11/2026, option 1** — applies to the US013 and US014 guides alike                                                                                                        |
| 17  | Slot E, the upstream re-baseline       | Kept — the four doc gates on a checkout of a later upstream merge commit, the commit recorded; slot A still binds the first edit                               | Delete slot E and P5R now that both upstreams precede the branch                            | **17-story-plans grilling round 2 Q4, 01/11/2026, option 1**; ADR-US003                                                                                                                                           |

---

## Dependencies

| Story / Artefact                               | Model / Feature                                                                                                                                                     | Required for                                                                                                                                                                                                                                                                                                                                                                      | Current state                      |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| US013                                          | 09 Step 4, 09 `CONTEXT.md` and the `code/src/logs/` pair rewritten; the selectors and host-path reads                                                               | **Hard start gate** — US014's branch is cut from `main` only after US013 has merged (17-story-plans grilling round 2 Q3); every cite into these files is measured at P0 on that base                                                                                                                                                                                              | `Open`                             |
| US008                                          | Cookie settings in `base.py`, `staging.py`, `production.py`; `EDGE-REQUIREMENTS.md`; `config/settings/CONTEXT.md`; `negative-space.sh`; `dev.py` / `test.py` pinned | **Hard start gate** — US014's branch is cut from `main` only after US008 has merged (17-story-plans grilling round 2 Q3, tightening round 1 Q1); every cite into the shared files is measured at P0; the `LOGGING` blocks are disjoint from its cookie settings, but `config/settings/CONTEXT.md` is edited by both and `negative-space.sh` must still list `RequestIDMiddleware` | `Open` (in the closed `SPRINT-05`) |
| US004                                          | The citation gate green                                                                                                                                             | Not a dependency — `doc-references.sh` is read as a diff against the P0 baseline (re-based in slot E only by a later upstream merge, P5R) unless US004 has landed green                                                                                                                                                                                                           | `Open`                             |
| `ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026` | The line and collector contracts                                                                                                                                    | Binding                                                                                                                                                                                                                                                                                                                                                                           | `Accepted` 01/11/2026              |
| `pm/story-creation` merged to `main`           | Every planning artefact                                                                                                                                             | The `us014/` branch is cut from `main` only after it merges (`08-SPRINT-PLAN-08.md` → _Branch Naming Reference_)                                                                                                                                                                                                                                                                  | Not merged                         |

**Blocked by:** US013 and US008, both as **hard start gates** — US014's branch is cut from `main`
only after both have merged, in whichever order those two land, so it can never land before
either (17-story-plans grilling round 2 Q3). Both read `Open`, so at Step 10 `completion` moves
US014 **`Open` → `Blocked`**, and to `Pending` once both have merged. Before either, the
`pm/story-creation` → `main` merge, without which no `us###/` branch exists.

> **Supersession, recorded 01/11/2026.** For US014's **start**, this supersedes the merge-order-only
> reading in `../03-SPRINTS/SPRINT-08.md` → _Dependencies_ and
> `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` → _Build order_, which let US014's work begin before
> either upstream merged. Their merge order (US014 after both) stands and now holds by
> construction. Those two files are not edited by this change; where they and this plan differ on
> when US014 starts, round 2 Q3 governs.

**Blocks:** none recorded. S-08 (the retrieval procedure) is `Held` on the map and is not cut.

**Can be done now:** nothing. No phase — not even P0's before-first-edit baselines — starts until
`pm/story-creation`, US013 and US008 have all merged to `main` and the `us014/` branch is cut from
it. From then, P0 to P6 run in the order of _Phase dependencies_, with no further upstream wait
unless a later upstream merge triggers P5R.

> This project keeps no cross-cutting parallel-worktree programme plan; the DAG is the
> _Dependencies_ sections of the plans in this folder.

---

## GDPR

Carried from `../09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (Signed off
01/11/2026), not re-derived.

- **Personal data touched:** incidental only — no new field is collected. Request paths, remote
  addresses and exception text may reach a line. `DATA-INVENTORY.md`:199 and :201 (row 15a) take
  the plan's Section 9 wording, re-measured first.
- **Minimisation, not redaction:** staging and production serialise only the fixed keys and
  `duration_ms`, `status_code`, `method`; `exc_info` carries no exception message. **`message` is
  not scrubbed** — Django's `BadRequest` and `SuspiciousOperation` records carry `str(exc)` in it
  (gates Q6). `DJANGO-LOGGING.md`:34-35's scrub sentence becomes a forward reference.
- **Bounded to Django's `LOGGING` lines:** the process-server stderr stream, which can rarely carry
  an escaped ASGI traceback with its message, is outside the claim (R2-Q1). Dev keeps uvicorn's
  plain-text access log, client address and query string included, disposable while the posture is
  `development` (R2-Q8); the app-server access log is dropped outside dev (Q1).
- **Lawful basis:**

  | Processing activity                           | Lawful basis (UK GDPR Art. 6)                         | Special category? | Article      |
  | --------------------------------------------- | ----------------------------------------------------- | ----------------- | ------------ |
  | Operational logging of the application stream | Legitimate interests — **LIA owed by the controller** | No                | Art. 6(1)(f) |

- **Retention:** 14 days staging and 90 days production as **reference defaults the controller
  confirms**, enforced by the collector and stated in `EDGE-REQUIREMENTS.md`'s new section; host
  `json-file` rotation by `max-size` / `max-file`; dev bounded by the `RotatingFileHandler`; test
  none. The edge access log's retention is the controller's, recorded by the deploy repository.
- **Rights mechanics:** no per-subject search over the log store is built (Q4). The Art. 11 position
  holds only while call sites keep identifiers out of `message` and URL path segments; under
  Art. 11(2) a supplied `request_id` **may have to be served** (R2-Q7). Carried into
  `GDPR-IMPL-US014` unchanged and flagged for legal sign-off.
- **At rest:** no new field; nothing encrypted.
- **DPIA:** not raised by `GDPR-PLAN-US014`, which does not address one — this plan's own reading,
  not a carried ruling: no new field, PII incidental to an existing stream, minimised off dev.
- **Open, the controller's, never closed by this template:** the LIA, the confirmed retention
  numbers, the Art. 11 legal sign-off, the edge access log's retention.

---

## Security

Carried from `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`
and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` (both
Signed off 01/11/2026). The surface is **OWASP A09:2025**.

**Twenty findings: 0 CRITICAL, 0 HIGH, 0 MEDIUM, 18 LOW, 2 INFO** (assessment, after round 3 added
TM-20). The story's FLAGS-comment count of nineteen with seventeen LOW is dated history from before
round 3. No VULNERABILITIES record. **Nine LOWs promote to MEDIUM across seven trigger rows**
(threat model Section 3a) — a template at posture `development` serving nothing, reported per
`code/docs/GATE-REPORTING.md`, never as "the security gate passed".

| Check                            | Requirement                                                                                                                                                                                                |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AuthN / AuthZ                    | N/A — no authenticated surface added                                                                                                                                                                       |
| Endpoint permission checks (A01) | **N/A — no state-changing endpoint.** The HP-07 to HP-10 views are test fixtures under `pytest.mark.urls`, mounted nowhere (`QA-PLAN-US014` Section 2, _Permission and access_)                            |
| IDOR                             | N/A — no user-supplied ID is resolved to a record                                                                                                                                                          |
| Input validation                 | The inbound `X-Request-ID` keeps `[A-Za-z0-9._-]{1,200}` (`middleware.py`:17); a rejected value never reaches the line (EC-05); the stored id is the validated or minted one, never the raw header (TM-03) |
| Correlation-id trust             | `EDGE-REQUIREMENTS.md` entry 13 requires the edge to set `X-Request-ID` from its own `$request_id` unconditionally, keeping entry 2's nonce from being client-chosen (TM-01)                               |
| Path rule                        | `DJANGO-LOGGING.md` states `django.request` logs the path, so no secret or PII in a URL path segment (Q5, TM-06)                                                                                           |
| Secrets                          | No new environment variable; `DEBUG=False` off-local unchanged                                                                                                                                             |
| Rate limiting                    | N/A — no new public endpoint                                                                                                                                                                               |
| Dependencies                     | None added — nothing in `pyproject.toml` or `uv.lock` moves                                                                                                                                                |

**The fourteen developer constraints** — threat model Section 4b, numbered there, carried here by
number and checked at review: (1) unconditional filter set, `""` → `None`, returns `True`; (2) fixed
keys after extras in wide mode, the three-extra allowlist in minimal; (3) the returned-error line's
id from the stored id under `Client` and `AsyncClient`; (4) the minimal `exc_info` shape and no
delegation to `logging.Formatter`; (5) never raises, the guarded-`repr` fallback; (6) the filter on
every handler, `ext://sys.stdout`, the mode per environment; (7) the `django` logger at `WARNING`
with no handlers in staging, production and test; (8) no `--access-logfile`, staging at `warning`;
(9) `DJANGO-LOGGING.md`'s unscrubbed-`message`, path and `str(exc)` sentences; (10) entry 13's
unconditional clause; (11) the label contract, rotation and retention in the new section; (12) every
"every line" claim scoped to Django's `LOGGING`, the process-server selector documented; (13) the
16 KiB cap and the 4 KiB interleave residual; (14) the out-of-extent records stated uncorrelated and
pinned.

> STRIDE + OWASP mapping per `project-management/docs/SECURITY-GUIDE.md`. The implementation
> records go to `10-SECURITY/{THREAT-MODEL,ASSESSMENTS}/IMPLEMENTATION/` (_Documentation Write-Ups_).
> TM-01 and TM-13 are the two to watch; a promotion sends a project to the `incident` skill or the
> security path, not to a new ADR.

---

## Logging & Observability

Carried from `../14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md` (Signed off
01/11/2026). **The story is the pipeline**; it adds no event and names no logger.

- **Levels** (logging plan 2.3): root `DEBUG` dev, `WARNING` elsewhere; `django` `INFO` in dev,
  `WARNING` with no handlers in test, staging and production; `django.db.backends` `WARNING`, file
  only, in dev.
- **Channels** (Section 5): `code/src/logs/django.log` (dev only, wide JSON, host-mounted); the dev
  console (Django's lines JSON, uvicorn's plain text); staging and production stdout (minimal JSON);
  process-server stderr (plain text, no `request_id`, collected with stdout); `mail_admins`
  (`DEFAULT_LOGGING`) — removed in staging, production and test by the handler-less `django` logger
  (Q8, R2-Q2), and in dev replaced by dev's own `django` handlers (`dev.py`:65); Sentry declared,
  not wired.
- **Collector contract** (5.1), written collector-neutrally into `EDGE-REQUIREMENTS.md`:
  - stdout and stderr read through the daemon with labels;
  - the service and environment relabels;
  - the retention line;
  - `json-file` `max-size` and `max-file`;
  - the keeping selector `{service_name="django"} | json | __error__!=""` with the multiline note.
  - Reference realisation: Alloy `discovery.docker` → `discovery.relabel` → `loki.source.docker`,
    confirmed against v1.21 (5.2). `LOGGING-IMPL-US014` re-reads it at implementation and records
    the version read.
- **Selectors:** every `-backend`, `-web` and `(web|worker)` selector becomes
  `{service_name="django"}`; `-worker` queries are marked forward references gated on Celery; the
  `logger="api"` and `apps.users.*` queries say they apply once a project declares the logger at
  `INFO`.
- **Accepted:** every returned or raised 4xx is a `WARNING` line off dev (R2-Q3) — logging plan 2.3
  records it, no `GAPS.md` row.
- **Uncorrelated by design:** records outside the middleware's dynamic extent — a streaming body
  generated after the view returns, a thread a view starts on the default build, a mid-stream ASGI
  exception — carry `request_id` null (R3-Q3, TM-18).
- **No PII added** to any line; the exclusion check (logging plan Section 4) runs at `22`.

---

## Performance, Rendering, Responsive & Accessibility

- **Performance and volume:** the minimal formatter caps each line at 16 KiB, so a pathological
  traceback costs at most one capped line; the cut works on the escaped output (`QA-PLAN-US014`
  Section 6). The 4xx `WARNING` volume on staging and production stdout is accepted (R2-Q3). A line
  over 4 KiB may interleave across workers on one pipe — an accepted residual (TM-20).
- **Scale readiness:** no route, upload, SSE surface or user-owned table. The edge and collector
  obligations go into `EDGE-REQUIREMENTS.md` as contract text, not provisioning.
- **Rendering / Responsive / Accessibility / SEO:** N/A — no page, template or interactive component
  (`QA-PLAN-US014` Sections 3 and 4).

---

## Implementation Workflows & Standards

### PM workflow chain (in order)

| Phase                           | Workflow                                                            | Applies                                    |
| ------------------------------- | ------------------------------------------------------------------- | ------------------------------------------ |
| Story written + AC agreed       | `project-management/workflows/02-story-creation/`                   | ✓ always                                   |
| Sprint slotted                  | `…/03-sprint-planning/`                                             | ✓ SPRINT-08                                |
| DB schema signed off            | `…/04-database-schema/`                                             | — no model                                 |
| User flow mapped                | `…/05-user-flow-design/`                                            | — no journey                               |
| Brand / components / wireframes | `…/06-brand-guides/`, `…/07-component-designs/`, `…/08-wireframes/` | — no UI                                    |
| GDPR review                     | `…/09-gdpr-compliance/`                                             | ✓ signed off 01/11/2026                    |
| Security review                 | `…/10-security-checks/`                                             | ✓ signed off 01/11/2026                    |
| QA plan                         | `…/11-qa-checks/`                                                   | ✓ signed off 01/11/2026                    |
| SEO check (public pages)        | `…/12-seo-checks/`                                                  | — no public page                           |
| API contract designed           | `…/13-api-design/`                                                  | — no endpoint                              |
| Logging plan                    | `…/14-logging-checks/`                                              | ✓ signed off 01/11/2026                    |
| Decision                        | `…/15-decisions/`                                                   | ✓ ADR-US014 Accepted 01/11/2026            |
| Detailed sprint plan            | `…/16-sprint-plans/`                                                | ✓ `08-SPRINT-PLAN-08.md`                   |
| Backend code                    | `…/19-backend-code/`                                                | ✓ the only build lane                      |
| API code                        | `…/20-api-code/`                                                    | — N/A                                      |
| Frontend code                   | `…/21-frontend-code/`                                               | — N/A                                      |
| Implementation documentation    | `…/22-implementation-documentation/`                                | ✓ records, the guide walked, graph refresh |
| PR & review                     | `…/23-pr-and-review/`                                               | ✓ always — the branch postdates both gates |
| Release                         | `…/24-release/`                                                     | — not cut inside the story                 |

### Code workflows invoked

| Workflow                                 | When                                                                                                                                                                                         |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/workflows/01-implement-story/`     | The spine, entered at `19`; its Step 1 fills the guide's _Recorded during the build_ slots                                                                                                   |
| `code/workflows/02-tdd-cycle/`           | ✓ always — Red → Green → Refactor per behaviour in P1 to P3                                                                                                                                  |
| `code/workflows/06-gdpr-enforcement/`    | GDPR flag Yes; logs are a PII exfiltration path. Over the staging/production extras allowlist, the message-free `exc_info` and the DATA-INVENTORY 15a wording; evidence to `GDPR-IMPL-US014` |
| `code/workflows/08-security-hardening/`  | The pre-PR security pass over the fourteen constraints                                                                                                                                       |
| `code/workflows/07-review/`              | ✓ always — content review before the PR                                                                                                                                                      |
| `code/workflows/11-refactor/`            | Only if the module nears 750 lines or cleanup is wanted — a separate commit                                                                                                                  |
| `code/workflows/09-debugging-with-logs/` | Not invoked to debug; its `STEPS.md` and `CONTEXT.md` are **edited** by P5, after US013's rewrite                                                                                            |

### Standards gates

| Doc / gate                                                                              | When it gates                                                                                                          |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `code/docs/CODING-PRINCIPLES.md` + `BACKEND-CODING-PRINCIPLES.md`                       | All code; type hints throughout                                                                                        |
| `code/docs/TESTING.md`                                                                  | One floor: **75% line and branch** for `apps/core`; the pre-PR gate on `staging`/`main` raises it to **80%**           |
| `code/docs/SECURITY.md`                                                                 | The A09 surface; no A01 surface                                                                                        |
| `code/docs/LOGGING.md`                                                                  | The whole story                                                                                                        |
| `audits/dict-discipline.sh` (`TYPES-OVER-DICTIONARIES.md`)                              | `observability.py` is in its scan — every dict a named type or a reasoned `DICT-OK:`                                   |
| `audits/story-markers.sh` (warn-only)                                                   | The first `.py` story marker — module-level in `test_observability.py`, function-level in `test_middleware.py`         |
| `audits/negative-space.sh`                                                              | `RequestIDMiddleware` stays listed                                                                                     |
| `audits/cloc.sh`                                                                        | No source file over 750 lines                                                                                          |
| `audits/docs-length.sh` · `docs-pairing.sh` · `doc-references.sh` · `doctrine-drift.sh` | The edit set; `doc-references.sh` as a diff against the P0 / P5R baseline; `doctrine-drift.sh` a regression guard only |

---

## Execution & Verification via Claude Dynamic Workflows

**The internal procedure comes first** (`.claude/CLAUDE.md` Section 2.7). Each stage names the
workflow it executes; a dynamic workflow supplies the fan-out and the verification only.

### Stage 0 — Plan verification (before any code)

- `17-story-plans` Step 9: 2–3 independent reviewers critique this plan and its guide — missing
  layers, unhandled GDPR or security, wrong references, dependency-order errors, a guide row no spec
  supports, a QA scenario no row exercises. Findings resolved before the branch is cut.

### Stage 1 — Build (TDD inner loop)

- `code/workflows/01-implement-story/` with `02-tdd-cycle/`, phases P0 to P6, entered only once
  US013 and US008 have both merged and the branch is cut. P1 and P2 may run as parallel subagents,
  their joint exit checked once both land; P3 waits on P1; P5 waits on all of P1 to P4; a
  conditional P5R precedes P5 or P6 only if a later upstream merges.

### Stage 2 — Continuous verification gates

| Gate            | Command (project script)                                         | Pre-PR gate # |
| --------------- | ---------------------------------------------------------------- | ------------- |
| Format          | `bash code/src/scripts/syntax/format.sh --fix`                   | [3/8]         |
| Lint            | `bash code/src/scripts/syntax/lint.sh --fix`                     | [4/8]         |
| Typecheck       | `bash code/src/scripts/syntax/check.sh`                          | [6/8]         |
| Stub audit      | `bash code/src/scripts/audits/stubs.sh`                          | [5/8]         |
| cloc line-count | `bash code/src/scripts/audits/cloc.sh`                           | [1/8]         |
| Dependency/CVE  | `bash code/src/scripts/audits/security.sh` — no dependency moves | [8/8]         |
| Lockfiles fresh | `install-backend.sh --check` · `install-frontend.sh --check`     | [2/8]         |
| Tests           | `bash code/src/scripts/tests/all.sh --coverage`                  | [7/8]         |

Plus, on every change to `observability.py`: `bash code/src/scripts/audits/dict-discipline.sh`.

### Stage 3 — Review (before raising the PR)

- `code/workflows/07-review/` through the `review` skill, which dispatches `code-reviewer` and
  `qa-tester`, with the `security` pass (`08-security-hardening`) over the fourteen constraints.
  Each finding adversarially verified before it is acted on.

### Stage 4 — Behavioural verification

- `bash code/src/scripts/development/server.sh up`, then the DEVLOG journey of the manual guide — the
  probe request in a browser and the host line parsed. No e2e or accessibility suite applies.

### Stage 5 — PR & release

- `07-review` clean, `22-implementation-documentation` complete → PM `23-pr-and-review/`. The PR
  follows both US013 and US008 by construction — the branch was cut after both merged — and any
  later upstream merge is absorbed by P5R first. No release inside the story.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**Governing rule.** Every developer operation uses a wrapper in `code/src/scripts/**/*.sh`. Never a
raw `python`, `manage.py`, `pytest`, `pnpm`, `uv`, `pip`, `npx` or `docker` call.

### Canonical commands

| Need                  | Command                                                                                               | Runs   |
| --------------------- | ----------------------------------------------------------------------------------------------------- | ------ |
| Start / stop / status | `bash code/src/scripts/development/server.sh up` / `down` / `status`                                  | Docker |
| Tail container output | `bash code/src/scripts/development/logs.sh --follow --service django`                                 | Docker |
| Migration check       | `bash code/src/scripts/database/migrate.sh check` — no pending migration (the story touches no model) | Docker |
| Format · lint · types | `syntax/format.sh [--fix]` · `syntax/lint.sh [--fix]` · `syntax/check.sh`                             | Both   |
| Backend tests         | `bash code/src/scripts/tests/backend.sh` · `tests/all.sh --coverage`                                  | Docker |
| Audits                | `audits/{cloc,stubs,security,dict-discipline,story-markers,negative-space}.sh`                        | Local  |
| Doc gates             | `audits/{docs-length,docs-pairing,doc-references,doctrine-drift}.sh`                                  | Local  |
| Lockfiles             | `development/install-backend.sh --check` · `install-frontend.sh --check`                              | Local  |
| Worktree `/etc/hosts` | `bash code/src/scripts/development/hosts-story-add.sh 014` / `hosts-story-remove.sh 014`              | Local  |

**Raw-command exceptions used by this story: none.** The template's two exceptions (raw
`pnpm exec`, raw `uv run`) are not needed. The manual walk uses a browser's devtools, `grep`,
`tail`, `git status` and `jq` on host files — none on Section 6's banned list, none running the
stack (_Key Decisions_ 12).

---

## Testing

**Coverage floor:** **75%** line and branch for `apps/core` — one floor (`code/docs/TESTING.md`,
`testing/COVERAGE.md`); 80% on `staging`/`main` at the pre-PR gate. Assert on outcomes; no stubs in
green code.

### Unit — `bash code/src/scripts/tests/backend.sh`, `tests/all.sh --coverage`

Every automated scenario of `../11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md` Section 2 is
a unit test in `code/src/django/apps/core/tests/unit/test_observability.py` (module-level
`pytestmark = pytest.mark.story("US014")`, no database), bar EC-16 in `test_middleware.py`
(function-level marker, the module gaining no `pytestmark`). Scenario IDs are the QA plan's and are
not restated.

| Method (QA plan key) | Scenarios                                                                                                | How (QA plan Section 6)                                                                                                                           |
| -------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| U-fmt                | HP-01 to HP-06; ES-01, ES-02; EC-01 to EC-04, EC-08 to EC-10, EC-12, EC-13, EC-15, EC-18 to EC-20, EC-23 | Formatter and filter built from the environment's own entries; hand-made `LogRecord`; 16 KiB measured as bytes of line + newline                  |
| U-client             | HP-07 to HP-10 (HP-07b async); EC-05 to EC-07, EC-11, EC-16, EC-21, EC-21b, EC-22                        | `Client` and `AsyncClient` against fixture views under `pytest.mark.urls`; `StringIO` handler, never `caplog`; isolation on a `threading.Barrier` |
| U-dict               | HP-11, HP-11b; ES-03 to ES-05; EC-14                                                                     | `importlib` import, never `dictConfig`; every entry built through `DictConfigurator(copy.deepcopy(...))`; negative fixtures                       |
| U-capsys             | HP-12; EC-17                                                                                             | Staging's console handler built by hand, `ext://sys.stdout` resolved after `capsys` patches it, on an unregistered `Logger`                       |

- Async tests carry `@pytest.mark.asyncio` (no `asyncio_mode`; `--strict-markers` on).
- The thread test reads `sys.flags.thread_inherit_context` rather than assuming the build.
- **The rename tripwire** — HP-02, HP-05, EC-08 to EC-10, EC-12, EC-17, EC-19, EC-23 pin the field
  set (ADR-US014 _Consequences_).

### Static — read at review

ES-06, ES-09, ES-10 (its runtime half unmeasured — no script reads the test stack's output; it is
no row of the guide, so it is reported unmeasured per `code/docs/GATE-REPORTING.md`, never as a
pass), ES-11, and the documentation content criteria. Each static half is also a row of the manual
guide. A guide row that cannot be run is `Fail` with `Unmeasured — <reason>` (Key Decision 16).

### API / contract — N/A

No `/api/*` endpoint; no Bruno flow.

### API permission tests — N/A

No state-changing endpoint (`QA-PLAN-US014` Section 2, PA N/A).

### Browser e2e and accessibility — N/A

No page or interactive component (`QA-PLAN-US014` Sections 3 and 4). The one browser step is the
manual guide's probe, which reads a header, not a UI.

### Manual testing

- `project-management/src/18-TESTS/MANUAL/US014-MANUAL-TESTING.md` — authored from the specs beside
  this plan at `17-story-plans` Step 7.2. A pointer, never a list of its own.

---

## Documentation Write-Ups (Implementation Records)

| Record                                   | Filename pattern                                       | Destination folder                                             | Produced by (workflow)                    | This story                                                                  |
| ---------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------- |
| **This plan**                            | `14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md`       | `project-management/src/17-STORY-PLANS/`                       | `17-story-plans`                          | Always                                                                      |
| ADR                                      | `ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md`      | `…/src/15-DECISIONS/`                                          | `15-decisions`                            | Written — Accepted                                                          |
| User story                               | `US014.md`                                             | `…/src/02-STORIES/`                                            | `02-story-creation`                       | Always                                                                      |
| Sprint plan                              | `08-SPRINT-PLAN-08.md`                                 | `…/src/16-SPRINT-PLANS/`                                       | `16-sprint-plans`                         | Written                                                                     |
| Schema / ERD / migration notes           | —                                                      | `…/src/04-DATABASE/`                                           | —                                         | Not required — no model                                                     |
| GDPR implementation record               | `GDPR-IMPL-US014-*.md`                                 | `…/src/09-GDPR/IMPLEMENTATION/`                                | `22-implementation-documentation`         | Always — carries the Art. 11 position unchanged, flagged for legal sign-off |
| Threat model / assessment implementation | `THREAT-MODEL-IMPL-US014-*`, `ASSESSMENT-IMPL-US014-*` | `…/src/10-SECURITY/{THREAT-MODEL,ASSESSMENTS}/IMPLEMENTATION/` | `22` / code `08-security-hardening`       | Always — the fourteen constraints evidenced                                 |
| Vulnerability record                     | —                                                      | `…/src/10-SECURITY/VULNERABILITIES/`                           | —                                         | Not required — no finding above LOW                                         |
| QA implementation review                 | `QA-IMPL-US014-STRUCTURED-JSON-LOGGING-*.md`           | `…/src/11-QA/IMPLEMENTATION/`                                  | `23-pr-and-review`                        | Always                                                                      |
| SEO / API records                        | —                                                      | `…/src/12-SEO/`, `…/src/13-API-DESIGN/`                        | —                                         | Not required — no page, no endpoint                                         |
| Logging implementation record            | `LOGGING-IMPL-US014-*.md`                              | `…/src/14-LOGGING/IMPLEMENTATION/`                             | `22-implementation-documentation`         | Always — re-reads the Alloy relabel and records the version; 2.3's 4xx row  |
| Manual testing guide                     | `US014-MANUAL-TESTING.md`                              | `…/src/18-TESTS/MANUAL/`                                       | `17-story-plans` Step 7.2; walked at `22` | Always                                                                      |
| Automated test record                    | `US014-TEST-STATUS.md`                                 | `…/src/18-TESTS/AUTOMATED/`                                    | `22-implementation-documentation`         | Always                                                                      |
| Code review record                       | `REVIEW-US014-*.md`                                    | `…/src/19-REVIEWS/`                                            | `23-pr-and-review` / code `07-review`     | Always                                                                      |
| Findings                                 | `FINDING-US014-*-DD-MM-YYYY.md`                        | `…/src/20-FINDINGS/`                                           | `22-implementation-documentation`         | Conditional — any guide row amended at the walk                             |
| Bug / refactoring record                 | `BUG-US014-*` / `REFACTORING-US014-*`                  | `…/src/21-BUGS/`, `…/src/22-REFACTORING/`                      | code `10-debug` / `11-refactor`           | Conditional                                                                 |
| Release                                  | root version files                                     | repo root                                                      | `24-release`                              | Not inside the story                                                        |

---

## CONTEXT.md & Index Updates

| File                                                          | Change required                                                                                                                                                                                                                                                                           |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `project-management/src/16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` | US014's _Story Plans — the code master_ row and _Branch Naming Reference_ row point at this file and branch (Step 10, not this change); `pm-board.sh --write`                                                                                                                             |
| `code/src/django/apps/core/CONTEXT.md`                        | Tree gains `observability.py` and `tests/unit/test_observability.py`; module row; `observability` leaves the not-shipped list; middleware row names the stored id                                                                                                                         |
| `code/src/django/apps/core/tests/unit/CONTEXT.md`             | Tree gains `test_observability.py`                                                                                                                                                                                                                                                        |
| `code/src/django/config/settings/CONTEXT.md` + `CLAUDE.md`    | Each module's logging and `base.py`'s absence of one; the dated exception at `CLAUDE.md`:39-41                                                                                                                                                                                            |
| `code/src/docker/CONTEXT.md`                                  | The logs mount — the section `LOGGING.md`:50 cites                                                                                                                                                                                                                                        |
| `code/src/logs/CONTEXT.md` + `CLAUDE.md`                      | Dev only and host-mounted; JSON bounded to Django's `LOGGING`; uvicorn's dev access log and the process-server stream plain text — at the post-US013 lines                                                                                                                                |
| `code/workflows/09-debugging-with-logs/CONTEXT.md`            | The test tick removed (post-US013 line)                                                                                                                                                                                                                                                   |
| Relevant `CONTEXT.md` **Last Updated** dates                  | Refreshed wherever content changed                                                                                                                                                                                                                                                        |
| `GAPS.md` / `DEFERRED.md` (repo root)                         | No `GAPS.md` row for the 4xx volume (R2-Q3). Every deferral but one has its destination on the map; the exception, the Prometheus scrape-job label drift (`HEALTH-CONTRACT.md`:106), gets a `DEFERRED.md` entry naming its owner or trigger, written by `22-implementation-documentation` |
| code-review-graph                                             | Staged first, then refreshed (`code/docs/CODE-REVIEW-GRAPH.md`) — owned by `22-implementation-documentation`                                                                                                                                                                              |

No new directory is created, so no new `CONTEXT.md` + `CLAUDE.md` pair is owed.

---

## Status Propagation & ClickUp Sync

The story's `**Status:**` line is the only status; this plan and the sprint plan carry none. At
`17-story-plans` Step 10 `completion` moves US014 **`Open` → `Blocked`** — US013 and US008 are hard
start gates and both read `Open` — with its _Status history_ row and the boards regenerated; the
SPRINT-08 Story Summary is ticked only on completion. It moves to **`Pending`** once both have merged,
`completion`'s call, and to `In Progress` when the branch is cut and P0 starts (17-story-plans
grilling round 2 Q3, superseding for US014's start `../16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` →
_Build order_). It never returns to `Blocked` for US013 or US008 once started.

| #   | Artefact                        | Where it lives                                                      | Notes                                                               |
| --- | ------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| 1   | **Story (source of truth)**     | `project-management/src/02-STORIES/US014.md` → `**Status:**` header | Edit here **first** — the only status anywhere                      |
| 2   | **Status history**              | the same story → `## Status history` table                          | One row per transition (date, from, to, note)                       |
| 3   | **Sprint record**               | `…/src/03-SPRINTS/SPRINT-08.md` → Story Summary tick                | A tick, not a status                                                |
| 4   | **Boards (generated)**          | `…/src/{01,02,03,16,17}-*/*-BOARD.md`                               | `bash project-management/src/00-ASSETS/scripts/pm-board.sh --write` |
| 5   | **This plan · the sprint plan** | —                                                                   | No status: the boards show them under the parent's                  |
| 6   | **ClickUp export (generated)**  | `…/export/clickup/US014-CLIENT.md`                                  | **clickup-only** — absent unless the project opted in               |

In a ClickUp-enabled project, regenerate the export after the story edit:

```bash
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US014
```

---

## Deferred Items

- **Redaction, scrub keys, OTLP tracing and metrics** — the deferred half of N-020 — target: the
  `syntek-observability` package in `syntek-modules`, built when a second Syntek product needs the
  scrub list or tracing is un-deferred (`MAP-RULE-OWNERSHIP.md` Batch G1; the ADR's only
  supersession trigger).
- **Named loggers and application instrumentation** — a generated project adds its own (N-020).
- **The `-worker` queries** — forward references, gated on Celery being wired.
- **The retrieval procedure and the block on Claude reaching a server** — `S-08`, `Held`.
- **The collector, edge and retention realisation** — the deploy repository (`<%DEPLOY_REPO%>`);
  stated here, untestable here.
- **The Prometheus scrape job label** (`HEALTH-CONTRACT.md`:106) — a metrics label, the same drift,
  not this pipeline. No destination exists on the map or in either register today, so
  `22-implementation-documentation` writes a `DEFERRED.md` entry naming its owner or trigger
  (_CONTEXT.md & Index Updates_).

### Accepted residuals — not deferrals

| Residual                                                                                                       | Source                    |
| -------------------------------------------------------------------------------------------------------------- | ------------------------- |
| The process-server stderr stream is plain text and can rarely carry an escaped ASGI traceback with its message | TM-13; R2-Q1              |
| Records outside the middleware's dynamic extent are uncorrelated                                               | TM-18; R3-Q3              |
| A line over 4 KiB can interleave across workers                                                                | TM-20; R3-Q1              |
| `message` is not scrubbed                                                                                      | TM-05; gates Q6           |
| Every 4xx is a `WARNING` line off dev                                                                          | R2-Q3                     |
| The collector and edge half cannot be tested from this repository                                              | ADR-US014 _Consequences_  |
| `django.server` keeps its own handler in every environment; no stack runs `runserver`                          | `QA-PLAN-US014` Section 6 |

---

## Risks

| Risk                                                                                                                                                                                                                    | Likelihood | Impact | Mitigation                                                                                                                                                                                           |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US014 lands before US008 and falsifies its `dev.py`/`test.py` byte-identical claim, colliding in `base.py`, `staging.py`, `production.py`, `EDGE-REQUIREMENTS.md`, `config/settings/CONTEXT.md` and `negative-space.sh` | Low        | High   | US008 is a hard start gate: the branch is cut only after it merges (17-story-plans grilling round 2 Q3), a Definition of Done row; P0 confirms `negative-space.sh` still lists `RequestIDMiddleware` |
| US013 or US008 slips, holding US014 `Blocked` with no partial progress and SPRINT-08 short                                                                                                                              | Med        | Med    | Accepted cost of the start gate (round 2 Q3); `Pending` is `completion`'s call once both merge; a re-plan goes through the `sprint` skill, never by starting US014 early                             |
| Cites into 09 and `code/src/logs/` taken from `5234a27` rather than from the tree US013 left                                                                                                                            | Med        | Med    | P0 measures every one on the branch's base commit, which contains US013, and records the host-path, selector and borderline sets in the guide (slots C, D, F)                                        |
| Cites into `base.py`, `staging.py`, `production.py`, `config/settings/CONTEXT.md` and `EDGE-REQUIREMENTS.md` taken from `5234a27` rather than from the tree US008 left                                                  | Med        | Med    | P0 measures every one on the base commit, which contains US008; never inherited                                                                                                                      |
| A further upstream merges after the branch is cut, stales the cites, or has its own findings read as US014's in GATES-05                                                                                                | Low        | Med    | P5R rebases, re-measures the touched cites and re-baselines the four gates on that merge commit in slot E, naming it; GATES-05 diffs against the latest entry (round 2 Q4)                           |
| A field renamed in the module by edit                                                                                                                                                                                   | Low        | High   | The rename tripwire tests; a superseding ADR and a `copier update` advisory are the only route                                                                                                       |
| The 16 KiB cap computed on input characters and overflowing once escaped                                                                                                                                                | Med        | Med    | EC-23's non-ASCII and emoji rows; the cap measured on the escaped line plus newline (QA plan Section 6)                                                                                              |
| A test calls `dictConfig` and rewrites global logging under every other test                                                                                                                                            | Med        | Med    | `importlib` plus `DictConfigurator` on a deep copy; `StringIO` handlers removed in a fixture                                                                                                         |
| Isolation "proved" on gathered `AsyncClient` requests, which never overlap                                                                                                                                              | Med        | Med    | EC-06 on two barrier threads (QA plan Section 8)                                                                                                                                                     |
| The deploy repository realises the collector without the relabel — queries return `unknown_service`, nothing fails                                                                                                      | Med        | High   | The contract stated in `EDGE-REQUIREMENTS.md`; TM-14/TM-15 promotion trigger; the `LOGGING-IMPL` re-read                                                                                             |
| A surface goes live before entry 13's edge clause is deployed (forged join, client-chosen nonce)                                                                                                                        | Low        | High   | ADR ordering clause; TM-01's promotion trigger                                                                                                                                                       |
| `observability.py` grows past 750 lines with the fallback, cap and chain walk                                                                                                                                           | Low        | Med    | P1 plans the split before it crosses; `cloc.sh`                                                                                                                                                      |
| `doc-references.sh` netted against a count and reported as a pass                                                                                                                                                       | Med        | Low    | The baseline by identity, with detector hash and index state; read as a diff (ADR-US003)                                                                                                             |

---

## Docker & Nginx Infrastructure

**N = 14.** `how-to/docs/GIT-WORKTREES.md` fixes the loopback rule — the final octet equals the
story number, `127.0.0.1` being the main stack — so the IP is `127.0.0.14`. **Verified free
01/11/2026**: `git grep '127\.0\.0\.14'` returns no tracked hit outside this plan. Subnets follow
`code/src/docker/CONTEXT.md` → _Network subnet scheme_: second octet the story number, third octet 1
for dev and 0 for test.

| File                                            | Purpose                                                                                                                                                                                       |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us014.dev.yml"  | Dev stack override — copied from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us014`; nginx published on `127.0.0.14:3080:80`; subnet `10.14.1.0/24` |
| "code/src/docker/docker-compose.us014.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us014`; `127.0.0.14:3081:80`; subnet `10.14.0.0/24`                        |
| "code/src/docker/nginx/dev-us014.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                                   |
| "code/src/docker/nginx/test-us014.conf"         | Same                                                                                                                                                                                          |

**The two Nginx files are named because the folder's rule names them, and the docker layer says they
do not exist.** `code/src/docker/nginx/CONTEXT.md` states that `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged, and that "there are no per-story Nginx
variants to generate". The two compose overrides are the files a worktree actually creates; the two
Nginx names are recorded so the four-file convention is satisfied on paper and the reader is told
which half is real. **That disagreement between `./CLAUDE.md` and the docker layer's own orientation
is not this story's to settle** — `./07-STORY-PLAN-US006-POSTURE-GUARD.md` set this treatment on
08/09/2026, and `./01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` and
`./08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` carried it.

**A second contradiction to know rather than resolve:** the plan template names three dev ports
(`3080`/`3082`/`3180`) where `code/src/docker/docker-compose.usXXX.dev.yml.example` binds only
`127.0.0.NNN:3080:80`. **The example is the file that gets copied.**

Every path in the table is in quotes because none exists until the worktree does; the two example
files they are copied from do exist and are backticked.

```text
127.0.0.14 dev-us014.<%PROJECT_SLUG%>.localhost test-us014.<%PROJECT_SLUG%>.localhost
```

`bash code/src/scripts/development/hosts-story-add.sh 014`, reversed by
`bash code/src/scripts/development/hosts-story-remove.sh 014` — both take the **numeric** story
number and refuse `us014` (`hosts-story-add.sh`:23-26), so the `us008` form in
`./08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`:1314 is not copied.
The worktree-aware scripts auto-detect the `us014/` branch through `_lib/worktree-detect.sh` and
layer the two overrides in.

**This story needs a running dev stack**: the manual guide's DEVLOG journey requests an unmatched
path and reads the line the container writes to the host-mounted `code/src/logs/django.log`, which
no unit test can observe. The test stack is not walked — no script reads its output (ES-10's runtime
half, reported unmeasured; no guide row).

---

## Sprint Verification Checklist

```bash
# Quality gates (mirror the 8 pre-PR gates)
bash code/src/scripts/syntax/format.sh --fix
bash code/src/scripts/syntax/lint.sh --fix
bash code/src/scripts/syntax/check.sh
bash code/src/scripts/audits/stubs.sh
bash code/src/scripts/audits/cloc.sh
bash code/src/scripts/audits/security.sh
bash code/src/scripts/development/install-backend.sh --check
bash code/src/scripts/development/install-frontend.sh --check
bash code/src/scripts/tests/all.sh --coverage

# The story's own checks
bash code/src/scripts/database/migrate.sh check
bash code/src/scripts/audits/negative-space.sh
bash code/src/scripts/audits/dict-discipline.sh
bash code/src/scripts/audits/story-markers.sh

# Doc gates — doc-references.sh read as a diff against the latest baseline (slot E, else slot A)
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/doctrine-drift.sh
```

- [ ] All 8 quality gates pass locally **and** in Docker (no mismatch)
- [ ] `apps/core` at or above 75% line and branch (80% if targeting `staging`/`main`)
- [ ] `migrate.sh check` — no pending migration (the story touches no model)
- [ ] `negative-space.sh` passes with `RequestIDMiddleware` listed; `dict-discipline.sh` clean
- [ ] No dependency added — `pyproject.toml` and `uv.lock` unchanged
- [ ] No PII in any new line; secrets via env only; `DEBUG=False` off-local
- [ ] Every GDPR task checked off; the logging plan satisfied and its exclusion check run; the
      security criteria signed off
- [ ] All implementation records written (_Documentation Write-Ups_)
- [ ] `CONTEXT.md` / index updates done; the graph staged then refreshed
- [ ] The manual guide walked, every row marked (an unrunnable row `Fail`, `Unmeasured — <reason>`),
      signed off by a tester other than the author
- [ ] Story status advanced with a Status history row; boards regenerated

---

## Definition of Done

- [ ] Acceptance criteria in `US014.md` met and demonstrated, every Gherkin scenario included
- [ ] Code workflows `02-tdd-cycle` + `07-review` complete; `08-security-hardening` pass over the
      fourteen constraints
- [ ] Behaviour verified on the running dev stack — the DEVLOG journey walked
- [ ] All quality gates green locally and in Docker; coverage floor met
- [ ] Documentation hard gate satisfied — every record and `CONTEXT.md` update complete **before**
      commit, the code-review-graph staged then refreshed
- [ ] **Started after both US013 and US008 merged** — the branch cut from `main` after both landed,
      no phase run before (17-story-plans grilling round 2 Q3); so merged after both
      (16-sprint-plans grilling round 1 Q1)
- [ ] Every cite into the 09 folder, the `code/src/logs/` pair and the US008-shared files measured at
      P0 on the base commit (slots C, D, F); any later upstream merge absorbed by P5R with slot E
      filled, else slot E reads `None`
- [ ] Every unrunnable manual row recorded `Fail`, `Unmeasured — <reason>`, with a _Failures_ row
      (17-story-plans grilling round 2 Q2)
- [ ] The manual testing guide walked by a tester other than the author (`US014.md` QA Acceptance
      Criteria — Manual)
- [ ] PR raised and promoted via PM `23-pr-and-review/`; review record in `19-REVIEWS/`
- [ ] Story status advanced by the `completion` skill (history row appended, boards regenerated —
      the plans carry no status); ClickUp export regenerated where the project opted in
