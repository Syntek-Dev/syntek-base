# QA Plan — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Field         | Value                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**     | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                                                                                                                              |
| **Date**      | 01/11/2026                                                                                                                                                                                                                                                                                                                                                                                        |
| **Sprint**    | SPRINT-08 — admitted 01/11/2026 at `03-sprint-planning`, 8 SP standing the record at 11 / 11, the fill trigger (`US014.md` Dependencies, the sprint-membership bullet)                                                                                                                                                                                                                            |
| **Wireframe** | N/A — this story ships one standard-library module, a one-attribute change to `middleware.py`, five settings modules, one Compose mount, three entrypoint lines and Markdown: no model, no endpoint, no screen, no page (`US014.md` FLAGS and Tasks)                                                                                                                                              |
| **Status**    | Signed off 01/11/2026 by <%DEVELOPER_NAME%> — independent review, grilling rounds 2 and 3, the `qa-tester` run (Step 3) and the consistency pass folded in; eighteen gaps, **all eighteen `[RESOLVED]`** (AC-GAP-10, -11 and -17 by round 3, 01/11/2026); the scoped `qa-tester` re-check folded 01/11/2026 and the round-3 feed-back landed in `US014.md` the same day; gate 11 closed for US014 |

<!-- Written 01/11/2026 on pm/story-creation at HEAD 66eb725. Every line number below was
     re-measured against that tree the same day; none is inherited from the scoping pass without
     being re-opened. US013 has not merged, so every cite into 09 STEPS.md, 09 CONTEXT.md and the
     code/src/logs/ pair is re-measured after it does (US014.md:124-128).

     STEP 1's GRILLING PASS is the combined specify-gates round, <%DEVELOPER_NAME%>, 01/11/2026,
     Q1 to Q11, cited below as "gates grilling 01/11/2026, Qn". Two of its questions were this
     gate's own — Q8 (Django's surviving `django` logger) and Q9 (the manual staging-settings row);
     Q1 (the access log) was 09's and this gate consumes it, and Q5, Q6, Q7, Q10 and Q11 move rows
     here although 10 and 14 own them. Claude's calls put in the same round and not objected to are
     settled with it, and are cited "gates grilling 01/11/2026, Claude's call": the filter overwrites
     `request_id` unconditionally and fixed keys are written after extras in wide mode; frames are
     (filename, lineno, function) only; the formatter never raises; the settings test
     importlib-imports each module and never calls dictConfig; the returned-4xx case runs under
     Client and AsyncClient; level is the uppercase levelname and the timestamp format is pinned
     here; the logging SKILL.md:83 timestamp line is fixed to UTC. The story's own cutting interview,
     grilling 31/10/2026 Q1 to Q11, is a different round and is not re-opened.

     STEP 2 HAS NO WIREFRAME TO REVIEW. The scenarios in Section 2 are derived from the story's
     seven Gherkin scenarios, its QA criteria, and the installed Django 6.1.2, uvicorn 0.52.3 and
     gunicorn 26.0.0 sources, as QA-PLAN-US008 derived its own from the settings and shell tree.

     STEP 3 — THE qa-tester DISPATCH IS OWED AND GATES SIGN-OFF. 11-qa-checks CHECKLIST.md requires
     "`qa-tester` skill run for each story"; QA-PLAN-US013 ran it and a scoped re-check before its
     sign-off. No qa-tester output is folded into this plan at writing. The adversarial reading it
     carries is the scoping pass's source reading and Section 8's refuted candidates; that reading
     does not discharge the dispatch. Its findings are folded in by a dated amendment, never
     silently.
     [SUPERSEDED 01/11/2026, round 3 + consistency pass: the dispatch ran the same day and is
     folded in by the QA-TESTER RUN comment below; a scoped re-check after the round-3 rulings
     is what is now owed.]

     SIGN-OFF is <%DEVELOPER_NAME%>'s. A plan reading `Signed off` closes gate 11 (settled
     30/09/2026, 16-sprint-plans grilling round 3 Q9). Two things gate it besides the dispatch:
     AC-GAP-3 and AC-GAP-9, both [OPEN], and 16-sprint-plans is blocked on US014 until each is
     resolved into the story (PLANNING/CLAUDE.md, Guardrails).
     [SUPERSEDED 01/11/2026, round 3 + consistency pass: AC-GAP-3 and AC-GAP-9 were resolved in
     round 2 and AC-GAP-10, -11 and -17 in round 3; no gap is [OPEN]. Sign-off remains gated on
     the scoped qa-tester re-check and the round-3 feed-back into US014.md.]
     [SUPERSEDED 01/11/2026, after the scoped re-check: both are done — the RE-CHECKED comment
     below — and sign-off is <%DEVELOPER_NAME%>'s alone.] -->

<!-- INDEPENDENT REVIEW, 01/11/2026 — a general-purpose reviewer read this plan against HEAD
     66eb725 and returned two major and ten minor findings. All twelve were re-verified against the
     tree and folded in the same day; none was rejected. Folded:
     (1) HP-13 / HP-14 now request an unmatched path: no module under apps/ or config/ calls a
         logger, dev's django logger is INFO, and django.request logs only status >= 400, so a 200
         from /health/ writes nothing that proves request_id.
     (2) The story feedback for US014.md:231 no longer says the django logger is staging/production
         only; dev.py:65 declares it and the story keeps it.
     (3) EC-10 uses a distinctive group message, and member types are pinned as listed.
     (4) The exc_info JSON shape is pinned in AC-GAP-4; HP-05, EC-08 to EC-10 cite it.
     (5) ensure_ascii=True is pinned in AC-GAP-5, and EC-13's surrogate case adds a U-capsys
         reading that stderr stays empty.
     (6) EC-15 added: a request extra with no stored id gives null and never raises.
     (7) AC-GAP-3 option A now also amends the middleware.py:19-22 comment.
     (8) EC-14 is restated as the dict claim U-dict can prove.
     (9) Section 6 and Section 8 no longer call test's survivors inert: django.* INFO reaches test's
         root console by propagation (test.py:41-42, the handler has no level).
     (10) HP-11 also asserts staging.LOGGING == production.LOGGING (US014.md:346-348, Q6).
     (11) Section 5's logging-plan filename and "none exists" wording are corrected.
     (12) Status moves from Reviewed to Draft until the two gaps are ruled.
     The FLAGS QA-row feedback now carries the literal value. The review's four needs_user items are
     recorded below as OPEN with <%DEVELOPER_NAME%>: AC-GAP-3, AC-GAP-9, the EC-12 fallback
     shape, and sign-off itself. This review does not discharge the Step 3 qa-tester dispatch. -->

<!-- GRILLING ROUND 2, 01/11/2026 — <%DEVELOPER_NAME%> ruled R2-Q1 to R2-Q8, cited below as
     "gates grilling round 2, 01/11/2026, Qn". Folded the same day:
     (1) AC-GAP-3 [RESOLVED], option A (R2-Q4): middleware.py stores the id on the request, the
         filter falls back to the `request` extra's stored id; middleware.py, its apps/core test
         and the apps/core/CONTEXT.md middleware row join US014's edit set. EC-16 added.
     (2) AC-GAP-9 [RESOLVED] (R2-Q1): the claim narrows to "every line Django's LOGGING emits";
         the process-server stream (gunicorn.error + uvicorn.error, plain text, stderr, rarely an
         escaped ASGI traceback with its message) is documented with a LogQL selector that keeps
         it; nothing is routed through LOGGING, so option B is not taken. ES-09 added.
     (3) AC-GAP-2 extended (R2-Q2): test.py also declares the django logger at WARNING with no
         handlers; HP-11 and ES-04 assert staging, production and test. Section 6's test-noise
         note and Section 8's "Q8 must reach test" candidate are overturned.
     (4) AC-GAP-5's fallback shape [RESOLVED] (R2-Q5): the fixed field set with unserialisable
         values str()-coerced, one JSON object. EC-12 restated.
     (5) AC-GAP-4's exc_info shape accepted as pinned at the independent review (R2-Q6).
     (6) Dev keeps uvicorn's plain-text access log on its console (R2-Q8); every "dev is JSON"
         claim narrows to Django's lines. Section 5 and Section 6 restated.
     R2-Q3 (4xx WARNING volume) and R2-Q7 (Art. 11(2)) are the logging and GDPR plans' and move
     no row here. The base.py:49 "third in the pipeline" comment (it is second) is an implementer
     doc task, noted in Section 6. No OPEN item remains with <%DEVELOPER_NAME%> but sign-off.
     [SUPERSEDED 01/11/2026, round 3 + consistency pass: the qa-tester run below raised
     AC-GAP-10, -11 and -17, OPEN until round 3 ruled them; and the comment sits at base.py:50,
     not :49 (base.py:48 opens MIDDLEWARE, :49 is SecurityMiddleware).] -->

<!-- QA-TESTER RUN, 01/11/2026 — the Step 3 dispatch. A qa-tester pass read this plan, the story,
     the four sibling gate plans and the installed Django 6.1.2, uvicorn 0.52.3, gunicorn 26.0.0
     and Python 3.14 sources, and returned thirteen findings (seven MEDIUM, six LOW) and three
     needs_user items. All thirteen were folded in the same day; none was rejected. Folded:
     (1) Line size — AC-GAP-10 [OPEN]: a line over PIPE_BUF (4096 bytes) from four gunicorn
         workers is not atomic, and the Docker log copier splits lines over 16 KiB, so EC-13's
         64 KiB unit pass proves nothing about transit. EC-23 added, pending the ruling.
     (2) Never-raises reach — EC-17 added: a bad %-args record, an extra whose __str__ raises, and
         logger.exception() outside an except block, each under staging's handler with capsys,
         `.err` empty (Handler.handleError never reached). The fallback `message` for a
         getMessage failure joins AC-GAP-11 [OPEN].
     (3) EC-12 restated: run under dev's wide formatter and under minimal with the bad value under
         an allowlisted key, and prove the fallback branch ran. The fallback's two readings (extras
         kept, or the fixed keys only) are AC-GAP-11 [OPEN].
     (4) AC-GAP-12 [RESOLVED]: every formatter, filter and handler entry is instantiated through
         `logging.config.DictConfigurator` without calling dictConfig. HP-11b added; Section 6.
     (5) EC-06 restated: isolation is proven on two threads behind a barrier, because AsyncClient
         serialises sync middleware on one executor. HP-07b (an async def view) added; Section 6.
     (6) AC-GAP-13 [RESOLVED]: the process-server selector keeps every non-JSON line. ES-09
         restated.
     (7) AC-GAP-14 [RESOLVED]: the gate-09 Gherkin's two unobservable clauses reworded as
         checkable statements. ES-10 added; the runtime half recorded unmeasured.
     (8) AC-GAP-15 [RESOLVED]: one wording per sentence across the four gates' story feedback.
     (9) AC-GAP-16 [RESOLVED]: a __context__ cycle, a 2000-link chain and exc_info=(None, None,
         None). EC-18 to EC-20 added.
     (10) AC-GAP-17 [OPEN]: streaming bodies and app-spawned threads are uncorrelated. EC-21 added,
          pending the ruling.
     (11) HP-06 gains a wide-mode key-set assertion (no `taskName`); the reserved set derives from
          `logging.makeLogRecord({}).__dict__`.
     (12) EC-16's test carries a function-level story marker; test_middleware.py gains no
          module-level pytestmark. Section 6.
     (13) AC-GAP-18 [RESOLVED]: lines are ASCII-escaped and Django escapes path arguments; one
          documentation sentence. EC-22 added.
     OPEN with <%DEVELOPER_NAME%>, not applied: AC-GAP-10 (line size), AC-GAP-11 (fallback shape
     and getMessage fallback message), AC-GAP-17 (uncorrelated streaming and threads). Carried, not
     this gate's: LOG-GAP-12 (staging's process-server `--log-level info`, `entrypoint.staging.sh`:29,
     against production's `warning`, `entrypoint.prod.sh`:30), which 14-logging-checks owns and
     HP-11's `staging.LOGGING == production.LOGGING` does not reach. This run discharges the
     Step 3 dispatch; a scoped re-check after the three rulings is owed, as QA-PLAN-US013 ran.
     [SUPERSEDED 01/11/2026, round 3 + consistency pass: AC-GAP-10, -11 and -17 and LOG-GAP-12
     were ruled in round 3 (R3-Q1 to R3-Q4); the next comment records how.] -->

<!-- GRILLING ROUND 3 AND THE CONSISTENCY PASS, 01/11/2026 — <%DEVELOPER_NAME%> ruled R3-Q1 to
     R3-Q5, cited below as "gates grilling round 3, 01/11/2026, Qn". Folded the same day, with the
     cross-plan consistency findings that concern this file:
     (1) AC-GAP-10 [RESOLVED] (R3-Q1): the minimal formatter caps each line at 16 KiB, an
         over-long line truncated and marked "truncated": true; the >4 KiB (PIPE_BUF) interleave
         across workers is an accepted residual. EC-23 restated with an exact assertion; EC-13
         notes the cap.
     (2) AC-GAP-11 [RESOLVED] (R3-Q2): the fallback keeps the extras str()-coerced in place, still
         subject to the allowlist; on a getMessage failure `message` is str(record.msg) without
         arguments; all coercion runs through a guarded repr that cannot raise. This is not the
         plan's recommendation (fixed keys plus exc_info only), and the ruling wins. The gap's
         description of the logging plan is corrected: it read R2-Q5's wording, not "the five
         fixed keys plus exc_info". The ruling names no `format_error` marker, so none is in the
         asserted key set. EC-12 and EC-17 restated.
     (3) AC-GAP-17 [RESOLVED] (R3-Q3): records outside the middleware's dynamic extent are
         uncorrelated, request_id null, recorded in Out of Scope and DJANGO-LOGGING.md and pinned
         by a test. EC-21 no longer pending; EC-21b (a thread a view starts) and ES-11 (the two
         sentences read) added.
     (4) LOG-GAP-12 carried (R3-Q4, 14-logging-checks' own gap): entrypoint.staging.sh:29's
         process-server --log-level becomes warning, as entrypoint.prod.sh:30. ES-06 gains the
         static reading.
     (5) R3-Q5 (8 SP kept, a dated Story Points note) is the story's and moves no row here.
     Consistency pass: the Status row; the superseding notes on the Step 3, sign-off and round-2
     comments above; ES-09 and Section 6 no longer say dev's console carries no JSON (Django's
     lines there are JSON, uvicorn's are plain text, round 2 Q8); base.py:49 corrected to :50;
     every US014.md:NNN cite replaced by its section name, because the 01/11/2026 fold moved the
     story's lines (a cite inside a resolved gap's description names the story as written at
     66eb725, and says so); the cross-references updated. Story feed-back owed from round 3 is
     listed under Section 1. A SCOPED qa-tester RE-CHECK of the round-3 rows (AC-GAP-10, -11,
     -17; EC-12, EC-13, EC-17, EC-21, EC-21b, EC-23; ES-06, ES-09, ES-11) follows this
     amendment and gates sign-off, as QA-PLAN-US013 ran one.
     [SUPERSEDED 01/11/2026: the re-check ran and is folded by the next comment.] -->

<!-- RE-CHECKED 01/11/2026 by a scoped qa-tester pass over the round-3 application (read-only;
     nothing edited, staged or committed by it). Not refuted: R3-Q1 to R3-Q4 are applied, and the
     round-3 feed-back had already landed in US014.md the same day — the 16 KiB Backend, Gherkin,
     Logging and Out of Scope text, the R3-Q2 fallback, the uncorrelated Out of Scope bullet and
     EC-21, staging's --log-level warning, and the EC-05, EC-07, EC-11, EC-22, HP-10, HP-03 TZ,
     ES-04/05 and ES-10 rows — bar the items re-check 1, 2, 5, 6 and 7 name. It returned eight
     findings, three medium and five low, numbered re-check 1 to 8 in the order returned; each was
     re-read at the working tree the same day and holds. Nothing in it needed a ruling; each fold
     applies R3-Q1, R3-Q2 or R3-Q3 as ruled, and the choices it makes inside a ruling are Claude's
     calls, put to <%DEVELOPER_NAME%> for acceptance at sign-off. Dispositions:
       - APPLIED here: 1 (AC-GAP-10's cut order extended to every variable-length field — message,
         outermost frames, the deepest cause/context links, ExceptionGroup members, oversized
         allowlisted extra values — the outermost type and innermost frame surviving; a cut link
         is omitted, never written null, and the line carries "truncated": true; EC-19 asserts the
         cap; EC-23 gains a 1000-member group and a 20 KiB `method` extra), 2 (AC-GAP-10 cites
         moby daemon/logger/copier.go — defaultBufSize = 16 * 1024 and the full-buffer partial
         branch `p == 0 && n == len(buf)`, re-read through scrapling at master on 01/11/2026 — as
         the source of the newline-inclusive 16 384-byte boundary), 4 (AC-GAP-11's key set admits
         "truncated": true on a cut fallback line; EC-23 gains a fallback-path over-cap record),
         5 (EC-23 gains 20 000 `é` and 5 000 emoji messages; Section 6's byte-count note says the
         cap is measured on the escaped output, because ensure_ascii expands the input), 7 (EC-17
         gains (d) a value whose __str__, __repr__ and metaclass __name__ all raise and (e) a
         msg object whose __str__ raises on a getMessage failure; (b)'s vacuous clause replaced),
         8 (the Status row, Section 1's head and closing note and the cross-reference say the
         round-3 feed-back has landed).
       - APPLIED to US014.md the same day: 1 (the Backend 16 KiB criterion and the EC-19 bullet
         carry the cap), 2 (the Gherkin line, the Backend criterion and the EC-23 bullet read "the
         line plus its newline is at most 16 384 bytes", an uncut record under the cap carries no
         `truncated` key, the type and innermost frame survive a cut), 5 (the EC-23 bullet's
         non-ASCII messages), 6 (a QA Automated bullet for EC-21b; the thread clause in Out of
         Scope, the Gherkin and the DJANGO-LOGGING.md Logging criterion qualified "on the default
         (non-free-threaded) build"), 7 (the EC-17 bullet gains (d) and (e)).
       - OWED to sibling plans, outside the files this fold edits: 3 (THREAT-MODEL TM-09 and its
         round-2 item 2, and ASSESSMENT 7.5, still leave a format_error marker to the implementer;
         AC-GAP-11 pins no marker and EC-12/EC-17 assert none, so each needs a dated note: a
         marker is a change to the ruled shape and returns to <%DEVELOPER_NAME%>, gates grilling
         round 3, 01/11/2026, Q2), the plan-side half of 5 (THREAT-MODEL TM-20's "makes a
         character count") and the plan-side half of 6 (LOGGING-PLAN Section 2's unconditional
         "a ContextVar is not inherited by a plain threading.Thread" and the GDPR-PLAN request_id
         thread sentence, each to read "on the default (non-free-threaded) build").
     Sign-off is <%DEVELOPER_NAME%>'s alone; the plan stays sign-off pending. -->

---

## 1. Acceptance criteria gaps

**Nine gaps found — one blocking, five material, three minor.** AC-GAP-1 to -7 were raised by the
11 scoping pass of 01/11/2026; AC-GAP-8 by the 10 scoping pass the same day, carried here because
it makes a testable Security criterion false as written; AC-GAP-9 by this pass, a residue of the
Q1 ruling. **All nine are `[RESOLVED] 01/11/2026`** — seven in the gates grilling round, AC-GAP-3
and AC-GAP-9 in round 2 — and were fed back into
`project-management/src/02-STORIES/US014.md` on 01/11/2026 (this plan edits no story file; the
exact changes were returned to the session that ran the feed-back). None moves the priority, the
estimate or the sprint.

**Nine more were raised by the `qa-tester` run of 01/11/2026 (AC-GAP-10 to -18).** Six were
`[RESOLVED] 01/11/2026` at the run, each under a settled answer it cites, and were fed back the
same day. **AC-GAP-10, -11 and -17 are `[RESOLVED] 01/11/2026` by round 3** (gates grilling
round 3, 01/11/2026, Q1 to Q3); their feed-back **landed in `US014.md` on 01/11/2026**, and the
scoped `qa-tester` re-check's story folds (re-check 1, 2, 5, 6 and 7) landed with it the same day
(the RE-CHECKED comment above). _Amended 01/11/2026, after the scoped re-check: this paragraph
first said the feed-back was owed and that `16-sprint-plans` stayed blocked until it landed._
**Round-3 story feed-back, as returned and applied:**

- **AC-GAP-10** — a Backend criterion: "the minimal (staging/production) formatter caps each line
  at 16 KiB, truncating an over-long line and marking it `"truncated": true`, so Docker never
  splits a line; the >4 KiB (`PIPE_BUF`) interleave across workers is an accepted residual"; a QA
  Automated criterion for EC-23; and the Logging criterion's "the formatter round-trip test below
  is the evidence that Django's `LOGGING` emits no line it would drop" bounded to lines within the
  16 KiB cap, EC-23 being that evidence (R3-Q1).
- **AC-GAP-11** — the never-raise Backend criterion and the matching QA Automated bullets: "the
  fallback keeps the extras `str()`-coerced in place, still subject to the allowlist; on a
  `getMessage()` failure `message` is `str(record.msg)` without arguments; all coercion runs
  through a guarded `repr` that cannot raise" (R3-Q2).
- **AC-GAP-17** — an Out of Scope bullet and a `DJANGO-LOGGING.md` Documentation sentence:
  "records logged outside `RequestIDMiddleware`'s dynamic extent — a streaming body generated after
  the view returns, a thread a view starts, an exception raised mid-stream under ASGI — are
  uncorrelated, `request_id` null, the response still carrying `X-Request-ID`"; and a QA Automated
  criterion for EC-21 and EC-21b (R3-Q3).
- **LOG-GAP-12** (the logging plan's) — the Backend task editing `entrypoint.staging.sh` also sets
  `--log-level warning` at `:29`; ES-06 reads it (R3-Q4).
- **Consistency** — the QA Manual static row "claim no JSON for dev's console" reads as ES-09 now
  does; and the story's QA criteria name the plan rows they do not yet mandate (EC-05, EC-07,
  EC-11, EC-22, HP-10, ES-04, ES-05, HP-03's `TZ` independence).

- **AC-GAP-1** `[RESOLVED] 01/11/2026` · **blocking** — **staging and production container
  stdout is not all JSON even after this story.** Each entrypoint runs gunicorn with
  `--access-logfile -` (`code/src/docker/django/entrypoint.staging.sh`:30,
  `entrypoint.prod.sh`:31, `entrypoint.test.sh`:27); `uvicorn/workers.py`:35-43 hands
  `uvicorn.access` gunicorn's handlers with `propagate = False`, and Django's dictConfig
  (`disable_existing_loggers: False`) leaves it alone. Every request therefore writes a plain-text
  access line holding the peer address and the full path with its query string, and no
  `request_id` — against the opening criterion (`US014.md` User Story and first Gherkin scenario,
  as written at `66eb725`) and
  `DATA-INVENTORY.md`:199's "query strings stripped". **Resolution:** `--access-logfile -` is
  dropped from the staging, production and test entrypoints; the edge access log owns access
  records, keyed on the same `request_id` (gates grilling 01/11/2026, Q1). With no access handler,
  `uvicorn.access` has no handler and does not propagate, and its INFO records sit below the
  `lastResort` handler's WARNING, so nothing is written. ES-06 asserts the absence.
- **AC-GAP-2** `[RESOLVED] 01/11/2026` · material — **Django's `DEFAULT_LOGGING` survives on the
  `django` logger.** `configure_logging` applies `DEFAULT_LOGGING` before `LOGGING`
  (`django/utils/log.py`:69-78); it declares `django` at INFO with `console`
  (`require_debug_true`) and `mail_admins` (`:56-59`), neither carrying the filter. Staging and
  production never declare `django`, so INFO records from `django.*` reach root's console despite
  root at WARNING, and the every-handler test proves the dict, not the running loggers.
  **Resolution:** staging and production declare `"django": {"handlers": [], "level": "WARNING"}`,
  propagation on, so dictConfig strips the surviving handlers and `django.*` records reach root's
  JSON console at WARNING and above; the settings test asserts it (gates grilling 01/11/2026, Q8).
  HP-11 and ES-04 carry it. **Extended to test** (gates grilling round 2, 01/11/2026, Q2):
  `test.py` declares the same entry, and the settings test asserts it in staging, production and
  test; dev keeps its own `django` logger at INFO (`dev.py`:65).
- **AC-GAP-3** `[RESOLVED] 01/11/2026` · material — **the filter cannot recover a returned error response's id
  from anything the story lets it read.** `log_response` runs after the middleware chain returns
  (`django/core/handlers/base.py`:144-151 sync, :165-173 async, the second through
  `sync_to_async(..., thread_sensitive=False)`), when `RequestIDMiddleware` has already reset its
  ContextVar (`apps/core/middleware.py`:50-51). `log_message` passes only `request` and
  `status_code` as extras, never the response (`django/utils/log.py`:269-271). The middleware keeps
  the id only in the ContextVar (`middleware.py`:45); `request.META` holds only the inbound header,
  and a minted id, or the replacement for a rejected hostile one (`:41`), is never there. So the
  story's returned-4xx scenario (`US014.md` Gherkin "request_id is always present" and Backend
  criteria, as written at `66eb725`) cannot pass unless
  `middleware.py` also stores the id where the `request` extra reaches it — and `middleware.py`,
  `test_middleware.py` and the `apps/core/CONTEXT.md` middleware row were in none of the story's
  tasks (Backend and Documentation Tasks, as written at `66eb725`). The story leaves the mechanism to the implementer, which is fine;
  what it cannot leave is an edit set that excludes the only file the mechanism can live in.
  **Resolution — option A** (gates grilling round 2, 01/11/2026, Q4): `RequestIDMiddleware`
  stores the id on the request it serves, and the filter falls back to the `request` extra's
  stored id for a returned-error `django.request` record; it never reads raw `request.META`.
  `middleware.py`, its test (`apps/core/tests/unit/test_middleware.py`) and the
  `apps/core/CONTEXT.md` middleware row join US014's edit set, and the `middleware.py`:19-22
  comment is amended as A below states. HP-08, HP-09, EC-05, EC-15 and EC-16 carry it. The
  options as put:
  - **A.** Yes: a Backend task "`RequestIDMiddleware` also stores the id on the request it serves,
    so a record logged after the chain recovers it from the `request` extra; the filter never falls
    back to raw `request.META`", plus a `test_middleware.py` task and the `apps/core/CONTEXT.md`
    middleware row in Documentation Tasks. The same task amends the `middleware.py`:19-22
    comment, which today says the ContextVar is used "rather than an attribute on the request":
    the ContextVar serves in-chain consumers, and the request attribute serves records logged
    after the chain resets it (independent review, 01/11/2026).
  - **B.** Name only the constraint ("the filter never reads raw `request.META`") and leave the
    file list to `17-story-plans`.
  - **Recommendation was A, and A was ruled.** The mechanism stays the implementer's, but the edit set must contain a
    file where it can live, and the `META` ban is a security line, not a style one: a fallback to
    the inbound header would log a client-chosen value the middleware rejected. EC-05 tests it
    whichever is ruled.
- **AC-GAP-4** `[RESOLVED] 01/11/2026` · material — **"type and frames" was undefined.** A frame
  carrying source-line text puts the test's own `raise ValueError("user a@example.com not
found")` line into the output, and chained causes, PEP 678 notes and `ExceptionGroup` members
  each carry a message of their own. **Resolution:** each frame is `(filename, lineno,
function)` — no source text, no `f_locals`; `__cause__` and `__context__` are walked type-only;
  notes are dropped (gates grilling 01/11/2026, Claude's call). **The JSON shape**, pinned here at
  the independent review of 01/11/2026 because JSON has no tuple:
  `"exc_info": {"type": "ValueError", "frames": [{"filename": str, "lineno": int, "function": str}], "cause": <link>|null, "context": <link>|null}`,
  where a `<link>` is `{"type": str, "cause": <link>|null, "context": <link>|null}` (type only,
  no frames), each exception visited once so a cycle terminates; an `ExceptionGroup` adds
  `"members": ["ValueError", …]`, member type names only. `type` is the class's `__name__`.
  HP-05, EC-08 to EC-10 assert against this shape. **Accepted as pinned** (gates grilling round
  2, 01/11/2026, Q6).
- **AC-GAP-5** `[RESOLVED] 01/11/2026` · minor — **the field values were unpinned.** `timestamp`
  could end `Z` or `+00:00` at any precision (the first Gherkin scenario against the QA criteria, as
  written at `66eb725`); `level` must be the
  uppercase levelname because `OBSERVABILITY.md`:139 queries `level="ERROR"`; a fixed key and a
  colliding extra had no order in wide mode. **Resolution** (gates grilling 01/11/2026, Claude's
  call; the format pinned here as that call required):
  - `timestamp` — `datetime.fromtimestamp(record.created, tz=timezone.utc).isoformat(timespec="milliseconds")`,
    so always `YYYY-MM-DDTHH:MM:SS.mmm+00:00` and matching
    `^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+00:00$`. Never `Z`, never a local offset, never
    `asctime`.
  - `level` — `record.levelname`, uppercase. `logger` — `record.name`. `message` —
    `record.getMessage()`, arguments interpolated.
  - `request_id` — the filter overwrites any extra of that name unconditionally; the formatter
    writes `null` when a record reaches it with no `request_id` attribute (a handler built without
    the filter), so the key is never missing (`US014.md` Gherkin "request_id is always present").
  - In wide mode the fixed keys are written **after** the extras, so `extra={"level": "x"}` cannot
    displace the real level. `message` and `asctime` cannot collide at all: `Logger.makeRecord`
    refuses them with `KeyError` at the call site.
  - `json.dumps` runs with `ensure_ascii=True` (its default), so every line is ASCII and a lone
    surrogate is written as `\ud800`; with `ensure_ascii=False`, `format()` would succeed and the
    handler's UTF-8 write would raise, and `Handler.handleError` prints a plain-text traceback to
    stderr (independent review, 01/11/2026). EC-13 reads it.
  - The formatter never raises. Should serialisation fail despite `default=str`, the line it
    returns is still **one JSON object**: the fixed field set, with every unserialisable value
    `str()`-coerced (EC-12; gates grilling round 2, 01/11/2026, Q5). This replaces the plan's
    earlier reading of "fallback to str of payload", which put the whole payload's `str()` under
    `message`.
- **AC-GAP-6** `[RESOLVED] 01/11/2026` · minor — **the returned-4xx case named no handler path.**
  Every deployed environment serves ASGI (`entrypoint.prod.sh`:21-22, `-k
uvicorn.workers.UvicornWorker`), so the live path is `get_response_async`; the sync path is
  `get_response`. `caplog`'s handler runs no handler filters, so it cannot observe the filter.
  **Resolution:** the case runs under both `django.test.Client` and `AsyncClient`, with
  `pytest.mark.urls` pointing at the test module, a view returning `HttpResponseBadRequest`, and a
  `StringIO` handler carrying the filter and the minimal formatter attached to `django.request`
  (gates grilling 01/11/2026, Claude's call). HP-08 and HP-09.
- **AC-GAP-7** `[RESOLVED] 01/11/2026` · material — **the manual "staging-settings run" row had
  no route through the scripts.** No script runs staging settings locally: `server.sh` and
  `shell.sh` drive the dev stack, and `code/src/scripts/deployment/` holds documents only. A raw
  `DJANGO_SETTINGS_MODULE=… manage.py` line in the guide would break `.claude/CLAUDE.md` Section 6.
  **Resolution:** the row is replaced — after a dev-stack request, one real line from the host's
  `code/src/logs/django.log` is parsed and carries `request_id` (manual; the request is to an
  unmatched path, so `django.request` logs its `Not Found` WARNING inside the middleware chain —
  independent review, 01/11/2026); and a `capsys` unit test
  proves staging's console handler, built from staging's own `LOGGING`, writes one parseable JSON
  line to stdout (gates grilling 01/11/2026, Q9). HP-12, HP-14.
- **AC-GAP-8** `[RESOLVED] 01/11/2026` · material — **Django itself writes `str(exc)` into
  `message`, which the Security criterion says never reaches staging or production stdout.**
  `BadRequest` logs `"%s: %s" % (str(exc), request.path)` and every `SuspiciousOperation` logs
  `str(exc)` as its whole message on `django.security.<Class>`
  (`django/core/handlers/exception.py`:106-113, :130-138). `message` is not scrubbed (Q9 of
  31/10/2026), so the story's Security criterion on `exc_info`, as written at `66eb725`, was false; the Q11 ValueError-through-`exc_info`
  scenario still holds. **Resolution:** the claim is narrowed — `exc_info` carries no exception
  message, but Django's `BadRequest` and `SuspiciousOperation` records carry `str(exc)` in the
  unscrubbed `message`; the Security criterion, `DJANGO-LOGGING.md` and the `DATA-INVENTORY.md`
  row are reworded to match (gates grilling 01/11/2026, Q6). EC-11 tests the narrowed claim
  exactly, so the residue is proven rather than assumed away.
- **AC-GAP-9** `[RESOLVED] 01/11/2026` · minor — **after Q1, the container stream still carries plain-text lines,
  and the LogQL `__error__` filter drops them silently.** Q1 removed the access line only. Three
  sources remain, each re-read 01/11/2026: gunicorn's error log, `--error-logfile -`
  (`entrypoint.staging.sh`:31, `entrypoint.prod.sh`:32, `entrypoint.test.sh`:28), which
  `gunicorn/glogging.py`:419-427 builds as a plain `StreamHandler` to **stderr**, and to which
  `uvicorn.error` is attached with `propagate = False` (`uvicorn/workers.py`:35-38) — worker
  boots, `WORKER TIMEOUT`, ASGI failures outside Django; the entrypoint `echo` lines
  (`entrypoint.prod.sh`:6, :9, :20); and `migrate` / `collectstatic` output (`:7`, :10). The
  collector reads the container's stdout and stderr alike, so these reach `{service_name="django"}`,
  and `| json | __error__=""` (09 `STEPS.md`:106) discards them — a worker timeout is invisible to
  every documented query. The story's headline "every log line is one valid JSON object"
  (`US014.md` User Story and first Gherkin scenario, as written at `66eb725`) and the Logging
  criterion that this pipeline "emits no line it would drop" (Logging Acceptance Criteria) both
  overreached. The 11 and combined scoping passes named the echo and boot
  output "boot output, not log records" as part of every Q1 option; Q1's recorded answer does not
  carry it. **Resolution** (gates grilling round 2, 01/11/2026, Q1): the claim narrows to
  "every line Django's `LOGGING` emits". The process-server stream — `gunicorn.error` and
  `uvicorn.error`, plain text, on stderr, and on rare occasions an escaped ASGI traceback
  carrying its exception message — is documented with a LogQL selector that keeps it (no
  `| json | __error__=""`). Nothing is routed through `LOGGING`, so option B is not taken; the
  boot output is named as plain text with it. ES-09 reads the documents. The options as put:
  - **A.** Narrow the wording only: "every record through Django's `LOGGING`"; name gunicorn's error
    log and the boot output as plain text outside the pipeline in `DJANGO-LOGGING.md` and the
    `EDGE-REQUIREMENTS.md` log-collection section; the 09 and `OBSERVABILITY.md` queries say a
    worker-level fault is read without `| json`.
  - **B.** As A, and route `gunicorn.error` and `uvicorn.error` through staging and production's
    JSON console handler (`request_id` null on them), so only the boot output stays plain text.
  - **Recommendation was A; the ruling is A, with the selector made explicit.** It keeps every shipped claim true for one sentence in documents the
    story already edits; B reaches into gunicorn's own handler wiring, a library seam the story does
    not otherwise touch, and leaves the boot output to be named anyway.
- **AC-GAP-10** `[RESOLVED] 01/11/2026` · material — **large lines break in transit while
  every unit test passes.** Production runs four gunicorn workers (`entrypoint.prod.sh`:24,
  `--workers "${GUNICORN_WORKERS:-4}"`) writing to one container stdout pipe. A write longer than
  `PIPE_BUF` (4096 bytes) is not atomic, so two workers' lines can interleave mid-object; at about
  110 bytes a frame, a 40 to 60 frame Django traceback already exceeds 4 KiB. Docker's log copier
  also splits a line over 16 KiB into partial records (a `RecursionError`'s roughly 1000 frames,
  or EC-13's own 64 KiB message). `| json | level=~"ERROR|CRITICAL" | __error__=""`
  (09 `STEPS.md`:101-106) then drops the fragments silently, and they are the ERROR lines an
  incident needs. EC-13 asserts `json.loads` on a 64 KiB line at unit level, so it passes for the
  wrong reason. Whether Alloy's `loki.source.docker` reassembles Docker partial records was not
  verified at this pass. **Options:**
  - **A.** The minimal formatter caps its output — `message` truncated at N KiB with a
    `"truncated": true` marker, and `frames` limited to the innermost N — asserted as
    `len(line) < 4096` for a 1000-frame `RecursionError` (EC-23).
  - **B.** `DJANGO-LOGGING.md` and the `EDGE-REQUIREMENTS.md` log-collection section state the
    4 KiB atomicity and 16 KiB split limits, and the collector requirement gains "reassembles
    Docker partial messages", confirmed against Alloy v1.21 as the relabel was (logging plan 5.2).
  - **Recommendation was A.** It keeps the documented `__error__=""` query true by construction,
    whatever collector the deploy repo runs; B rests on a collector behaviour not yet confirmed and
    leaves the interleave at 4 KiB, which no collector repairs.
  - **Ruling — A, capped at 16 KiB rather than 4 KiB** (gates grilling round 3, 01/11/2026, Q1):
    the minimal (staging/production) formatter caps its output at 16 KiB, truncating an over-long
    line and marking it `"truncated": true`, so Docker never splits a line. A line between 4 KiB
    and 16 KiB can still interleave with another worker's write on the pipe; that is recorded as
    an **accepted residual**, not tested, and a fragment it leaves is kept by AC-GAP-13's
    `__error__!=""` selector. **Pinned here for EC-23:** the line `format()` returns, encoded as
    UTF-8 (ASCII, under `ensure_ascii=True`) and with the handler's `"\n"` terminator, is at most
    16 384 bytes; it parses as one JSON object; the fixed keys are all present; `"truncated": true`
    appears only on a line that was cut, and no uncut line carries a `truncated` key (HP-02's key
    set is unchanged). **The boundary is newline-inclusive** because Docker's copier splits only
    a full buffer with no newline in it: moby `daemon/logger/copier.go` sets
    `defaultBufSize = 16 * 1024` and emits a partial record only when `p == 0 && n == len(buf)`,
    so a 16 383-byte line plus its `"\n"` travels whole and a 16 384-byte line plus its `"\n"` is
    split (read at `master` through `scrapling`, 01/11/2026). **Every variable-length field is
    cuttable, so the cap holds for any record** (scoped re-check 1, 01/11/2026, Claude's call
    within R3-Q1): `message`, then the outermost `frames`, then the deepest `cause`/`context`
    links, then `ExceptionGroup` `members`, then oversized allowlisted extra values — the order
    is the implementer's, provided the outermost exception's `type` and its innermost frame
    survive and every fixed key stays present. A cut link is **omitted**, its parent's `cause` or
    `context` key left out, and the line carries `"truncated": true`; it is never written as a
    bare `null`, which AC-GAP-4's shape reads as "no cause" — a departure from that shape only on
    a line marked cut, put to <%DEVELOPER_NAME%> for acceptance at sign-off. Dev's wide formatter is not
    capped: its lines go to the disposable host file and dev's console, not through the collector.
- **AC-GAP-11** `[RESOLVED] 01/11/2026` · material — **the fallback line's shape was unpinned,
  and "never raises" stopped short of the paths that leak.** R2-Q5 reads "the fixed field set with
  unserialisable values `str()`-coerced", and the logging plan (Section 2.2) carries R2-Q5's own
  wording, one JSON object of the fixed field set with each unserialisable value `str()`-coerced.
  _Corrected at the consistency pass, 01/11/2026: this gap first said the logging plan read "the
  five fixed keys plus `exc_info`", which misstated it._ The open question was whether the
  fallback keeps the extras, which R2-Q5's wording does not settle; EC-12 as first written read
  "the offending value `str()`-coerced in place", which keeps them. Separately, the settled "the
  formatter never raises" (gates grilling 01/11/2026, Claude's call) must reach
  `record.getMessage()` raising (`logger.warning("%s %s", 1)` is a `TypeError` before `json.dumps`
  runs) and an extra whose `__str__` raises (both `default=str` and a `str()`-coerced fallback raise
  again). When either escapes `format()`, `Handler.handleError` writes
  `'Message: %r\nArguments: %s'` — the raw arguments, possibly PII — in plain text to stderr
  (`logging/__init__.py`:1060-1095, `raiseExceptions = True` at :65), off the allowlist, and the
  line is lost. The threat model's TM-09 and the assessment's 7.5 left a `format_error` marker to
  the implementer, which would change the key set EC-12 and EC-17 assert. **Put as:** (a) does the
  fallback keep the extras, coerced in place, or carry only the fixed keys plus `exc_info`; (b) is
  the fallback `message` on a getMessage failure `str(record.msg)` with no arguments; (c) does the
  fallback coerce through a guarded `repr` that cannot itself raise. **Recommendation was** fixed
  keys plus `exc_info` only, `str(record.msg)` without arguments, and a guarded `repr`.
  **Ruling** (gates grilling round 3, 01/11/2026, Q2): (a) **the extras are kept, `str()`-coerced
  in place, and still subject to the allowlist** — the recommendation is not taken; (b) on a
  getMessage failure `message` is `str(record.msg)` without arguments; (c) all coercion runs
  through a guarded `repr` that cannot raise, `str(record.msg)` included. **Pinned here for EC-12
  and EC-17:** the fallback line is one JSON object whose key set is the fixed five, plus
  `exc_info` when the record carries an exception, plus each extra the environment keeps — every
  extra in dev's wide mode, only the allowlisted `duration_ms`, `status_code` and `method` under
  minimal — and nothing else, bar `"truncated": true` on a line the AC-GAP-10 cap cut, since the
  cap applies to every line `format()` returns, the fallback's included (scoped re-check 4,
  01/11/2026); the ruling names no `format_error` marker, so none is asserted and a
  marker the implementer adds is a change to the ruled shape that returns to
  <%DEVELOPER_NAME%>. A coerced value is a JSON string; its exact text for a value whose `__str__`
  and `__repr__` both raise is the implementer's, provided it is fixed text naming at most the
  type. A dropped extra stays dropped on the fallback path: the allowlist runs before coercion.
- **AC-GAP-12** `[RESOLVED] 01/11/2026` · material — **no test resolves a formatter or filter
  path from any environment's dict**, so a misspelt `apps.core.observabilty.JSONFormatter` or a
  kwarg the class does not accept is a `ValueError` in `configure_logging` inside `django.setup()`,
  and every staging and production worker fails to boot while the suite is green. pytest-django
  boots with test's `LOGGING`, which has no formatter (`test.py`:38-43); U-dict never calls
  dictConfig; HP-11 checks only filter names. **Resolution:** for each of dev, staging,
  production and test, every formatter, filter and handler entry is built with
  `logging.config.DictConfigurator(copy.deepcopy(LOGGING))`'s `configure_formatter`,
  `configure_filter` and `configure_handler` (dev's file handler pointed at `tmp_path` or skipped),
  which resolve `()` and `ext://` exactly as dictConfig does without touching global logging; each
  handler's filter id is asserted to map to `apps.core.observability`'s filter class and each
  formatter to its formatter class. This is within the settled "the settings test importlib-imports
  each module and never calls dictConfig" (gates grilling 01/11/2026, Claude's call). HP-11b.
- **AC-GAP-13** `[RESOLVED] 01/11/2026` · material — **the example selector for the
  process-server stream keeps only a traceback's first line.** uvicorn's
  `logger.error("Exception in ASGI application", exc_info=...)` reaches gunicorn's error handler as
  multi-line plain text (`uvicorn/workers.py`:35-38), and Docker stores each physical line as its
  own entry, so `{service_name="django"} |= "Exception in ASGI application"` (logging plan
  `:304-308`) returns the header and drops the lines carrying the exception. **Resolution:** R2-Q1
  requires a selector "that keeps it" (gates grilling round 2, 01/11/2026, Q1); a header-only line
  filter does not. The documented selector is
  `{service_name="django"} | json | __error__!=""`, which keeps every line that is not JSON — and
  any AC-GAP-10 fragment — with a note that a traceback arrives one entry per line unless the
  collector runs a multiline stage. ES-09 asserts that selector text.
- **AC-GAP-14** `[RESOLVED] 01/11/2026` · minor — **two clauses of gate 09's proposed Gherkin
  scenario "The app server writes no access log outside dev" have no route to a test.** "A request
  served by the test stack writes no `uvicorn.access` line" needs a read of the test stack's
  container output, and no script provides one (`development/logs.sh`:13 is bound to the dev
  compose file; `tests/server.sh` has no logs subcommand). "The edge access log owns access
  records, keyed on the same `request_id`" is deploy-repo behaviour nothing here can observe.
  **Resolution**, the wording following Q1 (gates grilling 01/11/2026, Q1) and Q7: (1) "With no
  `--access-logfile`, `uvicorn.access` has no handlers and `propagate = False`, so uvicorn's
  `hasHandlers()` is False and no access line is written (`uvicorn/workers.py`:40-43,
  `h11_impl.py`:57)", proven by ES-06 plus that source reading; (2) "`EDGE-REQUIREMENTS.md`
  entry 13 requires the edge access log to carry `$request_id`", a static row (ES-10). The runtime
  half is recorded unmeasured under `code/docs/GATE-REPORTING.md`; no test-stack log read is added
  while no script provides one.
- **AC-GAP-15** `[RESOLVED] 01/11/2026` · minor — **the four gates' pending story feedback words
  the same sentences differently.** The User Story has "Django's logging pipeline emits" (09)
  against "Django's logging emits" (10, 14); the Security criterion on `exc_info` (as written at `66eb725`) has three
  rewordings (10, 11, 14); the returned-error fallback has two scopes, "for a returned-error
  `django.request` record" (10, 11) and "when `current_request_id()` is empty", any record (14,
  logging plan `:152`); and Out of Scope gains two near-duplicate "not routed through `LOGGING`"
  bullets (09, 10). **Resolution:** the claim is worded "every line Django's `LOGGING` emits"
  throughout, R2-Q1's own words (gates grilling round 2, 01/11/2026, Q1); the fallback scope is
  R2-Q4's as written — "for a returned-error `django.request` record" (round 2, Q4) — and the
  logging plan's Section 2.2 `request_id` row is brought into line with it at that plan's own
  consistency pass (owed there, not edited from here); one Out of Scope bullet, citing R2-Q1 and
  TM-13. The qa-tester's alternative, any record whose `request` extra carries a stored id, is
  broader than R2-Q4 and is not taken without a ruling. EC-15 is consistent with either: its record
  is not a returned-error `django.request` record, and carries no stored id.
- **AC-GAP-16** `[RESOLVED] 01/11/2026` · minor — **exception shapes AC-GAP-4 promises but no row
  tests.** A `__context__` cycle ("each exception visited once"), a very deep cause chain where a
  recursive walk hits `RecursionError` inside `format()`, and `exc_info=(None, None, None)` — a
  truthy tuple on which a naive `exc_info[0].__name__` raises, and which "exc_info only when the
  record has one" (the first Gherkin scenario, as written at `66eb725`) left undefined. **Resolution**, within the accepted AC-GAP-4
  shape (gates grilling round 2, 01/11/2026, Q6) and the settled "the formatter never raises": a
  cycle terminates in one line (EC-18); a 2000-link `raise … from` chain gives one line and no
  `RecursionError`, so the walk is iterative or depth-capped (EC-19); a `(None, None, None)` tuple
  carries no exception, so the line has no `exc_info` key, matching HP-02's key set (EC-20).
- **AC-GAP-17** `[RESOLVED] 01/11/2026` · minor — **records logged outside the middleware's dynamic
  extent carry `request_id: null` though they belong to a request.** The story and this plan treat
  null as "outside any request" (`US014.md` Gherkin "request_id is always present"). Three cases
  fall between: a `StreamingHttpResponse` or `FileResponse` body generated after `get_response`
  returns (the `finally` reset at `middleware.py`:50-51 has run, though the response already
  carries `X-Request-ID`); a `threading.Thread` or `ThreadPoolExecutor` a view starts (a new
  thread has an empty context on the default build); and an exception raised mid-stream under
  ASGI, which escapes to uvicorn's "Exception in ASGI application" on the process-server stream.
  The Gherkin "request_id equals `current_request_id()`" passes vacuously there, but "follow one
  request across its log lines" does not hold. **Put as:** record them as uncorrelated, or widen
  the story to carry the id across them; **recommendation was** to record them. **Ruling**
  (gates grilling round 3, 01/11/2026, Q3): they are recorded as **uncorrelated** — `request_id`
  null, the response still carrying `X-Request-ID` — in the story's Out of Scope and in
  `DJANGO-LOGGING.md`, and pinned by a test. EC-21 pins the streaming body and EC-21b the thread;
  the mid-stream ASGI exception is on the process-server stream, outside `LOGGING`, so no unit
  test reaches it and ES-11 reads that the two documents name it.
- **AC-GAP-18** `[RESOLVED] 01/11/2026` · minor — **text searches on non-ASCII paths miss without
  warning.** With `ensure_ascii=True` pinned (AC-GAP-5; independent review, 01/11/2026) non-ASCII
  is written `\uXXXX` in the raw line, so a LogQL `|=` filter before `| json` misses; and Django's
  `log_message` `unicode_escape`s its path arguments (`django/utils/log.py`:275-278), so
  `/café/` is logged as `Not Found: /caf\xe9/` and even `| json | message=~".*café.*"` misses —
  the documented path query (09 `STEPS.md`:114-118) among them. **Resolution:** a consequence of
  the AC-GAP-5 pin, so one Documentation sentence in `DJANGO-LOGGING.md`'s staging/prod section:
  lines are ASCII-escaped and Django escapes path arguments, so search a non-ASCII path in its
  escaped form. EC-22 pins the logged form; no other test change.

_AC-GAP-3 and AC-GAP-9 were re-tagged `[RESOLVED] 01/11/2026` in round 2 and, with the other
seven and AC-GAP-12 to -16 and -18, fed into `US014.md` on 01/11/2026. AC-GAP-10, -11 and -17 were
ruled in round 3, 01/11/2026, and their feed-back (listed at the head of this section) landed in
`US014.md` the same day, with the scoped re-check's story folds; no `[OPEN]` gap holds
`16-sprint-plans` for SPRINT-08 (`PLANNING/CLAUDE.md`, Guardrails), and the plan stays sign-off
pending <%DEVELOPER_NAME%> (amended 01/11/2026, after the scoped re-check)._

---

## 2. Test scenarios

Derived from the story's Gherkin, its QA criteria and the gates grilling round. **Every automated
row bar EC-16 is a unit test in `code/src/django/apps/core/tests/unit/test_observability.py`,
marked `pytestmark = pytest.mark.story("US014")`, with no database** (unit tier by path,
`code/src/django/conftest.py`:55-56); manual rows are walked through the scripts only. Nothing
below is measured on an edited tree, because no edit exists yet.

**Method key.** **U-dict** — importlib-import the settings module and assert on its `LOGGING`
dict; never `logging.config.dictConfig` (Section 6). **U-fmt** — build the formatter and filter
from that module's own `formatters` / `filters` entries and format a hand-made `LogRecord`.
**U-client** — `Client` and `AsyncClient` against a view in the test module. **U-capsys** — a
handler built by hand from staging's dict, captured with `capsys`. **Static** — the file is read
at review. **Manual** — walked on the dev stack, recorded in
`project-management/src/18-TESTS/MANUAL/US014-MANUAL-TESTING.md`.

### Happy path (HP-nn)

| ID     | Given                                                                                                                                                                                             | When                                                                                                                                                                                                                            | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Method   |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| HP-01  | Staging's and production's minimal formatter                                                                                                                                                      | A record whose message holds `"`, `\` and `\n` is formatted                                                                                                                                                                     | The output is **one** physical line (no raw newline in it) and `json.loads` returns a `dict` whose `message` equals the original string (`US014.md` QA Acceptance Criteria — Automated)                                                                                                                                                                                                                                                                                                                              | U-fmt    |
| HP-02  | The same formatter, a record with no extras and no `exc_info`                                                                                                                                     | Formatted                                                                                                                                                                                                                       | The key set is exactly `{timestamp, level, logger, message, request_id}` (31/10/2026 Q4); `level` is `record.levelname`, `logger` is `record.name`                                                                                                                                                                                                                                                                                                                                                                   | U-fmt    |
| HP-03  | The same, the record's `created` fixed                                                                                                                                                            | Formatted                                                                                                                                                                                                                       | `timestamp` matches `^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+00:00$` and equals the UTC instant of `created` to the millisecond, whatever `TZ` the process runs under (AC-GAP-5)                                                                                                                                                                                                                                                                                                                                | U-fmt    |
| HP-04  | `extra={"duration_ms": 12, "status_code": 200, "method": "GET", "email": "a@example.com"}`                                                                                                        | Formatted under staging's and production's formatter                                                                                                                                                                            | `duration_ms`, `status_code`, `method` present with their values; `email` absent as a key, and `a@example.com` appears nowhere in the line — dropped, not masked, not renamed (31/10/2026 Q9)                                                                                                                                                                                                                                                                                                                        | U-fmt    |
| HP-05  | A record with `exc_info` for `ValueError("user a@example.com not found")`                                                                                                                         | Formatted under the minimal formatter                                                                                                                                                                                           | `exc_info` equals the AC-GAP-4 shape: `type` is `"ValueError"`, `frames` a list of objects each with exactly the keys `filename`, `lineno`, `function`, `cause` and `context` `null`; `a@example.com` and `not found` appear nowhere in the line (31/10/2026 Q11; AC-GAP-4)                                                                                                                                                                                                                                          | U-fmt    |
| HP-06  | Dev's wide formatter, the HP-04 and HP-05 records                                                                                                                                                 | Formatted                                                                                                                                                                                                                       | Every extra serialised, `email` included; `exc_info` carries the full traceback, message included (31/10/2026 Q9, Q11). And a wide record with no extras and no `exc_info` has exactly HP-02's key set — no `taskName` (Python 3.12+), `args`, `msg` or `created` — the reserved set derived from `logging.makeLogRecord({}).__dict__` plus `message` and `asctime`, never a hand-copied list (qa-tester run, 01/11/2026)                                                                                            | U-fmt    |
| HP-07  | A view logging a WARNING while `RequestIDMiddleware` serves it, inbound `X-Request-ID` absent                                                                                                     | Requested through `Client`, then `AsyncClient`                                                                                                                                                                                  | The captured line's `request_id` equals the response's `X-Request-ID` (a minted 32-hex id), on both paths (`US014.md` Gherkin "request_id is always present")                                                                                                                                                                                                                                                                                                                                                        | U-client |
| HP-07b | An `async def` view logging a WARNING while the sync-only `RequestIDMiddleware` serves it                                                                                                         | Requested through `AsyncClient`                                                                                                                                                                                                 | The line's `request_id` equals the response's `X-Request-ID` — the async-view adaptation path, which HP-07's view kind did not name (qa-tester run, 01/11/2026)                                                                                                                                                                                                                                                                                                                                                      | U-client |
| HP-08  | A view **returning** `HttpResponseBadRequest`; `django.request` carries a `StringIO` handler with the filter and minimal formatter                                                                | Requested through `Client`                                                                                                                                                                                                      | One `django.request` line at `WARNING`; its `request_id` equals the response's `X-Request-ID`, not null; `status_code` is 400 (an allowlisted extra `log_message` passes); no `request` key (AC-GAP-3, AC-GAP-6)                                                                                                                                                                                                                                                                                                     | U-client |
| HP-09  | The same view and handler                                                                                                                                                                         | Requested through `AsyncClient` (`@pytest.mark.asyncio`)                                                                                                                                                                        | As HP-08 — this is the path production runs, `get_response_async` through `sync_to_async(thread_sensitive=False)` (AC-GAP-6)                                                                                                                                                                                                                                                                                                                                                                                         | U-client |
| HP-10  | A view **raising** `PermissionDenied`                                                                                                                                                             | Requested through `Client` and `AsyncClient`                                                                                                                                                                                    | The `django.request` 403 line carries the response's `X-Request-ID`: it is logged inside the chain by `response_for_exception`, so the ContextVar covers it — distinct from HP-08's mechanism, and both must hold                                                                                                                                                                                                                                                                                                    | U-client |
| HP-11  | `config.settings.dev`, `test`, `staging`, `production`                                                                                                                                            | Each `LOGGING` dict is walked                                                                                                                                                                                                   | Every handler lists the `request_id` filter; staging, production and test declare `"django": {"handlers": [], "level": "WARNING"}` with `propagate` not `False`, root at WARNING; `staging.LOGGING == production.LOGGING`, so the two hand-maintained copies cannot drift (`US014.md` Backend and QA Automated criteria, 31/10/2026 Q6); dev's root is DEBUG, `django` at INFO and `django.db.backends` at WARNING file-only as today (`dev.py`:65, :68) (gates grilling 01/11/2026, Q8; round 2 Q2; 31/10/2026 Q10) | U-dict   |
| HP-11b | `config.settings.dev`, `test`, `staging`, `production`                                                                                                                                            | Every formatter, filter and handler entry is built with `logging.config.DictConfigurator(copy.deepcopy(LOGGING))`'s `configure_formatter`, `configure_filter` and `configure_handler`; dev's file handler pointed at `tmp_path` | Each builds without error, resolving `()` and `ext://` as dictConfig would; each handler's filter id maps to `apps.core.observability`'s filter class and each formatter to its formatter class; dictConfig is never called (AC-GAP-12)                                                                                                                                                                                                                                                                              | U-dict   |
| HP-12  | Staging's console handler, built from its dict entry (`ext://sys.stdout` resolved inside the test, after `capsys` patches it), with its formatter and filter, on an unregistered `logging.Logger` | A WARNING is emitted                                                                                                                                                                                                            | `capsys.readouterr().out` holds exactly one line, it parses with `json.loads` and carries `request_id: null`; `.err` is empty — proving stdout, not `StreamHandler`'s default stderr (gates grilling 01/11/2026, Q9)                                                                                                                                                                                                                                                                                                 | U-capsys |
| HP-13  | The dev stack up through `code/src/scripts/development/server.sh`                                                                                                                                 | One request is made to the unmatched path `/us014-probe-404/`, and its response's `X-Request-ID` noted                                                                                                                          | A `django.request` `Not Found` WARNING line appears in `code/src/logs/django.log` **on the host**, written by the container's `RotatingFileHandler` at `/workspace/code/src/logs/django.log` (`US014.md` Gherkin "Dev log files reach the host"; QA Acceptance Criteria — Manual). Not `/health/`: no module under `apps/` or `config/` calls a logger, and `django.request` logs only status 400 and above, so a 200 writes nothing (independent review, 01/11/2026)                                                | Manual   |
| HP-14  | The HP-13 file                                                                                                                                                                                    | The probe's line is pasted through a JSON parser on the host                                                                                                                                                                    | It parses, its `logger` is `django.request`, and its `request_id` equals the response's `X-Request-ID` noted in HP-13; and the five host-path commands the docs cite run as written against it (gates grilling 01/11/2026, Q9; `US014.md` QA Acceptance Criteria — Manual)                                                                                                                                                                                                                                           | Manual   |
| HP-15  | The four doc gates                                                                                                                                                                                | Run at the end of the build                                                                                                                                                                                                     | `docs-length.sh`, `docs-pairing.sh`, `doctrine-drift.sh` exit 0; `doc-references.sh` reads no new finding from the edit set against the baseline captured before the first edit (ADR-US003; `US014.md` QA Acceptance Criteria — Manual)                                                                                                                                                                                                                                                                              | Manual   |

### Error states (ES-nn)

| ID    | Given                                                                                                                       | When                                 | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Method |
| ----- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| ES-01 | A record logged outside any request — module level in the test                                                              | Formatted after the filter runs      | `request_id` is present and `null`: not `""`, not missing (31/10/2026 Q5); the filter returned `True`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | U-fmt  |
| ES-02 | `current_request_id()` returning `""`                                                                                       | The filter runs                      | `record.request_id is None`; the filter never drops a record, whatever its level or logger                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | U-fmt  |
| ES-03 | `config/settings/base.py` after the change                                                                                  | Imported                             | It has no `LOGGING` attribute, and its "replaces this wholesale" comment is gone (`US014.md` Gherkin "The filter is on every handler in every environment"; Backend criteria)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | U-dict |
| ES-04 | Staging, production or test's dict with the `django` logger entry removed                                                   | HP-11's assertion runs against it    | The test fails, naming the environment and the missing logger: a fixture proving HP-11 can go red, not only green (Q8; round 2 Q2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | U-dict |
| ES-05 | A handler entry missing the filter in any one environment                                                                   | HP-11 runs against a copy so mutated | The test fails, naming the environment and the handler (`US014.md` Gherkin "The filter is on every handler in every environment")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | U-dict |
| ES-06 | `entrypoint.staging.sh`, `entrypoint.prod.sh`, `entrypoint.test.sh`                                                         | Read                                 | None carries `--access-logfile` (gates grilling 01/11/2026, Q1); and `entrypoint.staging.sh`:29 passes `--log-level warning`, as `entrypoint.prod.sh`:30 does, so staging's process-server stream carries no INFO boot and worker lines production does not (logging plan LOG-GAP-12; gates grilling round 3, 01/11/2026, Q4). HP-11's `staging.LOGGING == production.LOGGING` cannot reach this flag, which lives outside `LOGGING`. Static, because the test image copies only `code/src/django/` and its own entrypoint (`Dockerfile.test`:27-29), so a unit test cannot see the staging or production script                                                                                                                      | Static |
| ES-07 | The dev stack **not** running when the walk starts                                                                          | HP-13 is attempted                   | Recorded unmeasured with the reason (`code/docs/GATE-REPORTING.md`), never as passed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Manual |
| ES-08 | `code/src/logs/` after the mount                                                                                            | `git status` after HP-13             | `django.log` and its rotations are untracked and ignored (`US014.md` Gherkin "Dev log files reach the host")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Manual |
| ES-09 | `DJANGO-LOGGING.md`, the `EDGE-REQUIREMENTS.md` log-collection section, 09 `STEPS.md` and `OBSERVABILITY.md` after the edit | Read                                 | The JSON claim reads "every line Django's `LOGGING` emits"; the process-server stream (`gunicorn.error` + `uvicorn.error`, plain text, stderr, possibly an escaped ASGI traceback with message) is named with the selector `{service_name="django"} \| json \| __error__!=""` in `DJANGO-LOGGING.md` and `OBSERVABILITY.md`, not a header-only line filter such as `\|= "Exception in ASGI application"`, with a note that a traceback arrives one entry per line unless the collector runs a multiline stage; no document claims dev's console is all JSON: Django's lines there are JSON, and uvicorn's access and error lines are plain text (gates grilling round 2, 01/11/2026, Q1, Q8; AC-GAP-13; consistency pass, 01/11/2026) | Static |
| ES-10 | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 13, and the uvicorn source                                      | Read                                 | Entry 13 requires the edge access log to carry `$request_id`; and with no `--access-logfile` (ES-06) `uvicorn.access` has no handlers and `propagate = False`, so `hasHandlers()` is False and no access line is written (`uvicorn/workers.py`:40-43, `h11_impl.py`:57). The runtime half — a test-stack request read back — is **unmeasured**: no script reads the test stack's output (AC-GAP-14; `code/docs/GATE-REPORTING.md`)                                                                                                                                                                                                                                                                                                    | Static |
| ES-11 | `US014.md` Out of Scope and `DJANGO-LOGGING.md`'s staging/prod section after the edit                                       | Read                                 | Each names the uncorrelated cases — a streaming body generated after the view returns, a thread a view starts, and an exception raised mid-stream under ASGI (which reaches the process-server stream) — as `request_id` null with the response still carrying `X-Request-ID`; neither promises correlation for them. EC-21 and EC-21b pin the first two; the third has no unit route (AC-GAP-17; gates grilling round 3, 01/11/2026, Q3)                                                                                                                                                                                                                                                                                             | Static |

### Edge cases (EC-nn)

| ID     | Given                                                                                                                                                                                                                                                                                                                                                                                                                                             | When                                                             | Then                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Method   |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| EC-01  | A record with `extra={"request_id": "forged"}` inside a request                                                                                                                                                                                                                                                                                                                                                                                   | Filtered and formatted                                           | `request_id` is the middleware's value; outside a request, `null` — never `"forged"` (gates grilling 01/11/2026, Claude's call)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | U-fmt    |
| EC-02  | Dev's wide formatter, `extra={"level": "x", "logger": "y", "timestamp": "z"}`                                                                                                                                                                                                                                                                                                                                                                     | Formatted                                                        | The three fixed keys carry the real values; the extras do not displace them (AC-GAP-5)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | U-fmt    |
| EC-03  | Wide formatter, `extra={"obj": object()}` and a `django.request` record's `request` extra                                                                                                                                                                                                                                                                                                                                                         | Formatted                                                        | Each serialises as its `str()`; the request appears as its repr, query string included, as the story states for dev (`US014.md` Gherkin "Staging and production keep only the allowlisted extras")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | U-fmt    |
| EC-04  | A handler built **without** the filter                                                                                                                                                                                                                                                                                                                                                                                                            | A record is formatted                                            | `request_id` is present and `null`: the formatter, not only the filter, keeps the key (AC-GAP-5; `US014.md` Gherkin "request_id is always present")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | U-fmt    |
| EC-05  | A request with inbound `X-Request-ID: bad id!` (fails `[A-Za-z0-9._-]{1,200}`, `middleware.py`:17)                                                                                                                                                                                                                                                                                                                                                | HP-08's returned-4xx view, `Client`                              | The line's `request_id` equals the response's minted `X-Request-ID`, and `bad id!` appears nowhere in the line — the filter never falls back to `request.META` (AC-GAP-3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | U-client |
| EC-06  | Two threads behind a `threading.Barrier(2)`, each calling `RequestIDMiddleware(get_response)` on a `RequestFactory` request whose `get_response` waits on the barrier, then logs                                                                                                                                                                                                                                                                  | Both run, overlapping at the barrier                             | Each line carries its own request's id; neither carries the other's (ContextVar isolation where overlap is real). Not two gathered `AsyncClient` requests: `AsyncClientHandler` enters no `ThreadSensitiveContext`, so sync middleware runs one request after the other on asgiref's single executor, a module global would pass, and a barrier there deadlocks (qa-tester run, 01/11/2026). An async variant, each request inside its own `ThreadSensitiveContext`, is optional                                                                                                                                                                                                                                                                                                                                | U-client |
| EC-07  | A record logged after a request has finished, in the same thread                                                                                                                                                                                                                                                                                                                                                                                  | Filtered                                                         | `request_id` is `null`: the reset in `middleware.py`:50-51 holds, so no id leaks onto the next unit of work                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | U-client |
| EC-08  | `raise KeyError("k") from ValueError("user a@example.com")`, then caught and logged                                                                                                                                                                                                                                                                                                                                                               | Minimal formatter                                                | `exc_info.cause` is `{"type": "ValueError", "cause": null, "context": null}`; `a@example.com` appears nowhere; the implicit `__context__` case likewise, under `context` (AC-GAP-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | U-fmt    |
| EC-09  | An exception with `add_note("token=abc123")`                                                                                                                                                                                                                                                                                                                                                                                                      | Minimal formatter                                                | `abc123` appears nowhere — notes dropped (AC-GAP-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | U-fmt    |
| EC-10  | An `ExceptionGroup("grp-secret-7f3", [ValueError("a@example.com")])`                                                                                                                                                                                                                                                                                                                                                                              | Minimal formatter                                                | `exc_info.members` is `["ValueError"]`; neither `grp-secret-7f3` nor `a@example.com` appears anywhere in the line (AC-GAP-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | U-fmt    |
| EC-11  | A view raising `BadRequest("user a@example.com")`, staging's minimal formatter on `django.request`                                                                                                                                                                                                                                                                                                                                                | `Client`                                                         | `exc_info` holds no message text, **and `message` holds `user a@example.com`** — the narrowed claim tested as stated, so the residue is visible (AC-GAP-8; gates grilling 01/11/2026, Q6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | U-client |
| EC-12  | A payload `json.dumps(..., default=str)` cannot serialise — under dev's wide formatter an extra holding a `dict` with a tuple key, and under the minimal formatter the same value under an allowlisted key (`status_code={(1, 2): 3}`), so the allowlist cannot remove it first                                                                                                                                                                   | Formatted                                                        | `format()` returns, never raises, and the line parses as **one** JSON object; the test proves the fallback branch ran (the coerced value appears as a JSON string under its own key) and asserts the fallback line's exact key set as AC-GAP-11 pins it: the fixed five plus each kept extra — every extra under wide, the allowlisted key under minimal — and no `format_error` or other marker; a non-allowlisted extra on the same record stays absent under minimal; never the whole payload's `str()` under `message` (AC-GAP-5, AC-GAP-11; gates grilling round 2, 01/11/2026, Q5; round 3, Q2)                                                                                                                                                                                                           | U-fmt    |
| EC-13  | A message of 64 KiB, and one with a lone surrogate (`"\ud800"`)                                                                                                                                                                                                                                                                                                                                                                                   | Minimal formatter, then staging's console handler under `capsys` | One line each, `json.loads` succeeds, no exception; the surrogate is written escaped (`ensure_ascii=True`, AC-GAP-5), and through the handler `.out` holds one line and `.err` is empty (U-fmt and U-capsys). Under the minimal formatter the 64 KiB message is truncated by the 16 KiB cap, so its line also carries `"truncated": true`; the surrogate line is uncut and carries no `truncated` key. Transit is EC-23's (AC-GAP-10; gates grilling round 3, 01/11/2026, Q1)                                                                                                                                                                                                                                                                                                                                   | U-fmt    |
| EC-14  | An `apps.x` INFO logger under staging's dict                                                                                                                                                                                                                                                                                                                                                                                                      | HP-11's levels read                                              | Staging's root is WARNING and no `apps.*` logger is declared, so an undeclared INFO logger inherits WARNING; a project's own INFO logger joins only when declared (31/10/2026 Q10; `US014.md` Gherkin "Levels follow the environment" and Out of Scope, named loggers). A dict claim; the runtime half is not asserted                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | U-dict   |
| EC-15  | A record with `extra={"request": HttpRequest()}` carrying no stored id, logged outside the ContextVar — the shape of a `DisallowedHost` that `SecurityMiddleware` raises before `RequestIDMiddleware` runs (`staging.py`:20, `base.py`:48-54)                                                                                                                                                                                                     | Filtered and formatted                                           | `request_id` is `null`, the filter returns `True`, and no exception is raised — the accepted uncorrelated short-circuit `base.py`:50-53 records (independent review, 01/11/2026)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | U-fmt    |
| EC-16  | `RequestIDMiddleware` serving a request with no inbound header, then one with `X-Request-ID: bad id!`                                                                                                                                                                                                                                                                                                                                             | The view reads the stored id off the request                     | In both cases the id stored on the request equals the response's `X-Request-ID` (the minted id, never `bad id!`); a valid inbound id is stored as received. In `apps/core/tests/unit/test_middleware.py`, the one automated row outside `test_observability.py`; the new test carries a function-level `@pytest.mark.story("US014")` and the module gains no `pytestmark`, so the existing middleware tests are not attributed to US014 (AC-GAP-3; gates grilling round 2, 01/11/2026, Q4; qa-tester run, 01/11/2026)                                                                                                                                                                                                                                                                                           | U-client |
| EC-17  | Under staging's console handler with `capsys`: (a) `logger.warning("%s %s", 1)`; (b) an allowlisted extra whose `__str__` raises; (c) `logger.exception("x")` called outside any `except` block; (d) an allowlisted extra whose `__str__` and `__repr__` both raise and whose metaclass defines a raising `__name__` property; (e) `logger.warning(obj, 1)`, where `obj.__str__` raises, so `getMessage()` fails and `str(record.msg)` raises too | Each emitted                                                     | `.out` holds one parseable JSON line for each and `.err` is empty — `Handler.handleError` is never reached, so no `Message: %r` / `Arguments: %s` text reaches stderr. For (a), `message` equals `"%s %s"` exactly — `str(record.msg)`, no arguments; for (b), the extra's key is present with a JSON-string value that is the guard's `repr` fallback or its fixed text; for (c), no `exc_info` key (EC-20); for (d), the extra's value is the guard's fixed JSON string, naming at most the type and still written when naming the type raises; for (e), `message` is the guard's fixed JSON string (scoped re-check 7, 01/11/2026). Each line's key set is AC-GAP-11's: the fixed five plus the kept extras, no marker (gates grilling 01/11/2026, Claude's call; round 3, 01/11/2026, Q2; AC-GAP-11)        | U-capsys |
| EC-18  | `e1.__context__ = e2` and `e2.__context__ = e1`, logged with `exc_info`                                                                                                                                                                                                                                                                                                                                                                           | Minimal formatter                                                | One line, `format()` terminates; each exception appears once in the `context` links (AC-GAP-4, AC-GAP-16)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | U-fmt    |
| EC-19  | A 2000-link `raise … from` cause chain                                                                                                                                                                                                                                                                                                                                                                                                            | Minimal formatter                                                | One line, no `RecursionError`: the walk is iterative or depth-capped (AC-GAP-16). The chain alone serialises to about 100 KB, so the line plus its `"\n"` is at most 16 384 bytes and carries `"truncated": true`; the outermost `type` and innermost frame survive, and a cut link is omitted, never written `null` (AC-GAP-10; scoped re-check 1, 01/11/2026)                                                                                                                                                                                                                                                                                                                                                                                                                                                 | U-fmt    |
| EC-20  | A record with `exc_info=(None, None, None)`                                                                                                                                                                                                                                                                                                                                                                                                       | Minimal and wide formatters                                      | No `exc_info` key: the key set is HP-02's exactly, and nothing raises (AC-GAP-16; `US014.md` first Gherkin scenario)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | U-fmt    |
| EC-21  | A view returning a `StreamingHttpResponse` whose generator logs a WARNING                                                                                                                                                                                                                                                                                                                                                                         | `Client`                                                         | The test consumes `response.streaming_content` after the client returns, as a real server does; the generator's line has `request_id` `null`, the filter returns `True`, and the response still carries `X-Request-ID` — the documented uncorrelated behaviour pinned (AC-GAP-17; gates grilling round 3, 01/11/2026, Q3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | U-client |
| EC-21b | A view that starts a `threading.Thread` whose target logs a WARNING, and joins it before returning                                                                                                                                                                                                                                                                                                                                                | `Client`                                                         | The thread's line has `request_id` `null` while the view's own line carries the response's `X-Request-ID`: a new thread starts with an empty context. Asserted where `sys.flags.thread_inherit_context` is false, the default build (Python 3.14.8 locally reads 0); on a free-threaded build, where a thread inherits its starter's context, the row asserts the response's id instead, and the test reads the flag rather than assuming it (AC-GAP-17; gates grilling round 3, 01/11/2026, Q3)                                                                                                                                                                                                                                                                                                                | U-client |
| EC-22  | An unmatched path `/café/` under staging's minimal formatter on `django.request`                                                                                                                                                                                                                                                                                                                                                                  | `Client`                                                         | The raw line holds `Not Found: /caf\\xe9/`, ASCII only; the row pins the escaped form `DJANGO-LOGGING.md` tells a reader to search for (AC-GAP-18)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | U-client |
| EC-23  | A `RecursionError` of roughly 1000 frames; a 64 KiB message; a message of 20 000 `é` characters and one of 5 000 emoji (about 120 KB and 60 KB once escaped); a 1000-member `ExceptionGroup`; a 20 KiB `method` extra; a fallback-path record — an allowlisted `status_code` holding a tuple-keyed dict of about 64 KiB, with a 64 KiB message; and a record whose line falls just under the cap                                                  | Minimal formatter, then staging's console handler under `capsys` | For every record but the last, the line plus its `"\n"` is at most 16 384 bytes, parses as one JSON object, carries every fixed key and `"truncated": true`, and keeps the outermost exception's `type` and its innermost frame where the record carries one; the non-ASCII messages prove the cap is measured on the escaped output, not the input's characters; the fallback-path record also proves the fallback branch ran and that its key set is otherwise AC-GAP-11's (scoped re-check 1, 4 and 5, 01/11/2026); the uncut record carries no `truncated` key and equals its untruncated rendering. Through the handler, `.out` holds one line per record and `.err` is empty. The >4 KiB pipe interleave is the accepted residual and is not asserted (AC-GAP-10; gates grilling round 3, 01/11/2026, Q1) | U-fmt    |

### Permission and access (PA-nn)

**N/A.** No endpoint, view, protected action or role boundary: the views in HP-07 to HP-10 are
throwaway fixtures inside the test module under `pytest.mark.urls`, mounted nowhere. The one
hostile-input path is the inbound `X-Request-ID`, already constrained by `middleware.py`:17, and
its trust question — the edge sets the header from its own `$request_id` unconditionally — is
`10-security-checks`' (gates grilling 01/11/2026, Q7). EC-05 is the QA-visible half. Recorded
rather than omitted, per `code/docs/GATE-REPORTING.md`.

---

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is log lines read in a terminal
or a log store, and Markdown read in an editor.

## 4. Responsive behaviour

**N/A — no layout, no breakpoint, no rendered page.**

## 5. GDPR & security constraints

**PII is in play, incidentally — no new field is collected** (gates grilling 01/11/2026, Claude's
call). The minimisation claim is the staging/production allowlist and the dropped exception
message, and **`message` is not scrubbed** (31/10/2026 Q9, Q11). The lawful basis (Q2), the
retention reference default (Q3) and the data-subject-rights position (Q4) are the controller's
and are recorded in the GDPR plan, not here; QA tests only what the pipeline guarantees. The
QA-visible constraints:

- **Dropped means absent** — HP-04 and HP-05 assert the value appears nowhere in the line, not
  only that the key is gone; a renamed or masked field fails.
- **The narrowed exception claim is tested as narrowed** — EC-11 proves `str(exc)` reaches
  `message` for `BadRequest`, so no document can claim otherwise unnoticed (Q6).
- **Request paths are logged** — every `django.request` line carries `request.path`; the rule
  "no secret or PII in a URL path segment" goes into `DJANGO-LOGGING.md` (Q5). HP-15's doc gates
  do not test it; Section 6 asks the reviewer to read the sentence.
- **No access line** — ES-06; the IP and query string leave the application stream with it (Q1).
- **Dev is wide by design** — HP-06 and EC-03 prove dev serialises PII-bearing extras and the
  request repr; the dev log is disposable under posture `development` and never leaves the host.
  Dev's console also keeps uvicorn's plain-text access log, peer address and query string
  included, on the same footing (gates grilling round 2, 01/11/2026, Q8).
- **The process-server stream is outside the minimisation claim** — `gunicorn.error` and
  `uvicorn.error` write plain text to stderr in staging and production and can, rarely, carry an
  escaped ASGI traceback with its message; the documents name it rather than claim it away, and
  ES-09 reads them (round 2 Q1).

Cross-references: `../../09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md`,
`../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`,
`../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` and
`../../14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md`, written by their own
gates the same day (untracked in the working tree; none is in commit `66eb725`).

---

## 6. Developer notes — testability

- **Load settings with `importlib`, never `dictConfig`.** `base.py`:24 reads `SECRET_KEY` from the
  environment, which `docker-compose.test.yml`:51 sets; staging and production read the rest with
  `.get` defaults, so all four import in-process. Importing `dev.py` has two side effects: it
  creates `code/src/logs/` (`:40-41`) and sets `TEMPLATES[0]["OPTIONS"]["string_if_invalid"]` on the
  shared dict (`:37`) — the same value test sets (`test.py`:31), so harmless, but say so in the
  test. Calling dictConfig on dev's dict would open the `RotatingFileHandler`; on any dict it would
  rewrite the process's global logging under every other test.
- **Build handlers by hand from the dict entries** (HP-12): resolve `ext://sys.stdout` with
  `logging.config.BaseConfigurator` **inside** the test, after `capsys` has patched `sys.stdout`,
  and attach to `logging.Logger("us014")` constructed directly, so nothing enters the logger
  registry.
- **Instantiate every entry as dictConfig would, without dictConfig** (HP-11b, AC-GAP-12):
  `logging.config.DictConfigurator(copy.deepcopy(LOGGING))` and its `configure_formatter`,
  `configure_filter` and `configure_handler` resolve `()` and `ext://` exactly as `dictConfig`
  does and leave global logging untouched; deep-copy first, because the configurator mutates the
  dict it is given. Dev's `RotatingFileHandler` is pointed at `tmp_path` or skipped.
- **`AsyncClient` serialises sync middleware** (EC-06, HP-07b). `RequestIDMiddleware` is sync-only
  (`middleware.py`:31-51, no `async_capable`), and `AsyncClientHandler` enters no
  `ThreadSensitiveContext` where the real `ASGIHandler` does (`django/core/handlers/asgi.py`:172),
  so every request's sync middleware runs on asgiref's one thread-sensitive executor: two gathered
  requests never overlap, and a barrier between them deadlocks. Isolation is proven on threads.
- **`caplog` cannot see the filter** — its handler runs no handler filters. HP-07 to HP-10 attach a
  `StringIO` handler built from the environment's own formatter and filter entries to the logger
  under test, and remove it in a fixture.
- **Async tests need the marker.** `pytest-asyncio` is installed (`pyproject.toml`:204) with no
  `asyncio_mode` set, so each async test carries `@pytest.mark.asyncio`; `--strict-markers` is on
  (`:222`). These are the first async tests in the suite.
- **The unit tier is by path** — no `unit` marker is written; only the story marker (`US014.md` QA Acceptance Criteria — Automated, first bullet).
  `test_observability.py` carries it module-level; EC-16's test in the existing
  `test_middleware.py` carries it function-level, so the module's other tests stay unattributed.
  The test client against a fixture view touches no session or database, so it is unit-safe.
- **Survivors the `django` entry does not reach, recorded rather than fixed.** With round 2 Q2,
  test declares `"django": {"handlers": [], "level": "WARNING"}` as staging and production do, so
  dictConfig strips `DEFAULT_LOGGING`'s `console` and `mail_admins` there too and `django.*` INFO
  no longer reaches test's root console, which carries no level of its own (`test.py`:41-42). In
  every environment `django.server` keeps its own handler; it serves `runserver` only, and no
  stack runs it (dev runs uvicorn, `entrypoint.dev.sh`:27). HP-11 is a claim about the dict plus
  the `django` logger, not about every logger in the process.
- **Dev's console is mixed, and the claim is Django's lines.** Dev runs uvicorn directly and keeps
  its plain-text access log on the console (gates grilling round 2, 01/11/2026, Q8), while Django's
  lines reach that console and the host-mounted file as wide JSON (the dev Backend task). HP-13 and
  HP-14 read the file; ES-09 reads that every "dev is JSON" sentence is narrowed to Django's lines,
  and that no document calls dev's console all JSON (consistency pass, 01/11/2026).
- **`base.py`:50's comment calls `RequestIDMiddleware` "third in the pipeline"; it is second.**
  (Re-measured at the consistency pass, 01/11/2026: `:48` opens `MIDDLEWARE`, `:49` is
  `SecurityMiddleware`, `:50` the comment.) Noted at round 2 with no question; the implementer checks and corrects it with the
  `middleware.py` edit (AC-GAP-3).
- **The 16 KiB cap is a byte count of the written line** (EC-23, AC-GAP-10): measure
  `len((formatter.format(record) + "\n").encode())`, not `len()` of the string — they agree only
  because `ensure_ascii=True` keeps every line ASCII, and the test should say so. The output is
  ASCII but the input expands into it — `é` becomes 6 bytes, an astral character 12, `"` and
  `\n` double — so a cap computed from the input's characters overflows; cap the serialised
  output (EC-23's non-ASCII rows; scoped re-check 5, 01/11/2026).
- **Streaming and thread fixtures** (EC-21, EC-21b): consume `streaming_content` after the client
  call returns, so the generator runs outside the middleware's `finally`, as a server would; read
  `sys.flags.thread_inherit_context` in the thread test rather than assuming the build.
- **Capture the doc-gate baselines before the first edit**, finding by finding, into the manual
  testing guide, as `QA-PLAN-US013` Section 6 did; the end-of-build reading is then a diff.
- **Read the rule sentences at review** — none is machine-checked: the path sentence in
  `DJANGO-LOGGING.md` (Q5), the narrowed exception claim in three files (Q6), the `X-Request-ID`
  clause in `EDGE-REQUIREMENTS.md` entry 13 (Q7), and the log-collection section's
  environment relabel, collector-neutral contract, `OBSERVABILITY.md`:120 correction and
  json-file rotation line (Q10, Q11), and the process-server selector and narrowed JSON claim
  (round 2 Q1, Q8; ES-09). Also the logging `SKILL.md`:83 timestamp line, which reads
  `<%TIMEZONE%>` today and is fixed to UTC as a US014 documentation task.
- **Coverage** — 75 % line and branch for `apps/core` (`code/docs/testing/COVERAGE.md`), through
  `bash code/src/scripts/tests/all.sh --coverage`.

## 7. Gate readings, measured 01/11/2026 — indicative, not baselines

Taken on `pm/story-creation` at `66eb725`, read-only; nothing was executed.

| Reading                                    | Value                                                                                                                                   |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| `LOGGING` assignments                      | Five — `base.py`:203, `dev.py`:43, `test.py`:38, `staging.py`:33, `production.py`:39; base, staging and production plain text to stderr |
| `--access-logfile -` / `--error-logfile -` | `entrypoint.staging.sh`:30 / :31 · `entrypoint.prod.sh`:31 / :32 · `entrypoint.test.sh`:27 / :28                                        |
| Dependency set (local `.venv`)             | Django 6.1.2 · uvicorn 0.52.3 · gunicorn 26.0.0; the staging and production images were not checked against it                          |
| `.py` story markers                        | None yet; US014's is the first (`US014.md` QA Acceptance Criteria — Automated, first bullet)                                            |
| `apps/core/tests/unit/`                    | `test_errors.py`, `test_middleware.py`, `test_schemas.py`, `test_templatetags.py`; no async test anywhere in the suite                  |
| Doc gates, test suite, dev stack           | **Not measured** — no run at writing (`code/docs/GATE-REPORTING.md`)                                                                    |

---

## 8. Candidates re-opened and refuted

- **"Route the access log through the JSON handler instead of dropping it."** Refuted by Q1: JSON
  in form, but it ships the peer address and query string inside `message`, which is not scrubbed.
- **"Run each environment in a subprocess and parse real stdout."** Refuted (gates grilling
  01/11/2026, Claude's call): HP-12's `capsys` test proves the stream from the environment's own
  dict entry, and the unit tier stays hermetic.
- **"The filter can read the id from `request.META`."** Refuted: `META` holds the inbound header
  only, and a rejected hostile value would be logged as the request's id (AC-GAP-3, EC-05).
- **"The sync `Client` alone proves the returned-4xx case."** Refuted: production runs
  `get_response_async`, which logs through `sync_to_async(thread_sensitive=False)` on another
  thread (AC-GAP-6).
- **"Q8 must reach `config.settings.test` too."** First recorded as not taken; **overturned** by
  gates grilling round 2, 01/11/2026, Q2 — test declares the same `django` entry and HP-11 asserts
  it.
- **"Read the test stack's container output to prove no access line."** Not added (qa-tester run,
  01/11/2026): no script reads it, and a raw `docker` line would break `.claude/CLAUDE.md`
  Section 6; ES-06 and ES-10 carry the static half and the runtime half is recorded unmeasured
  (AC-GAP-14).
- **"Two gathered `AsyncClient` requests prove ContextVar isolation."** Refuted: they never overlap
  (Section 6), so a module global would pass (EC-06).
- **"Route `gunicorn.error` and `uvicorn.error` through the JSON console."** Refuted by round 2
  Q1: the claim is narrowed and the plain-text stream documented with a selector that keeps it
  (AC-GAP-9).

---

## Cross-references

- `project-management/src/02-STORIES/US014.md` — the story this plan tests; AC-GAP-1 to -9, -12 to
  -16 and -18 were fed back on 01/11/2026; AC-GAP-10, -11 and -17, ruled in round 3 the same day,
  were fed back the same day with the scoped re-check's folds (Section 1)
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`
  and `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`
  — owe the no-marker note under AC-GAP-11 (scoped re-check 3, 01/11/2026)
- `project-management/src/03-SPRINTS/SPRINT-08.md` — the record US014 stands in at 11 / 11
- `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — slice `S-07`, node N-020
- `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the merge-first
  sibling and the doc-gate baseline precedent
- `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` — the settings-story
  precedent
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation
  review that verifies this plan
- `code/docs/GATE-REPORTING.md` — the rule behind every `N/A` and unmeasured row
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
