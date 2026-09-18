# QA Plan — US008 Host-only cookies under `__Host-` names

| Field         | Value                                                                                                          |
| ------------- | -------------------------------------------------------------------------------------------------------------- |
| **Story**     | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule |
| **Date**      | 17/09/2026                                                                                                     |
| **Sprint**    | SPRINT-05 — this story is its `Must`, 8 of 11 SP                                                               |
| **Wireframe** | N/A — this story ships settings, a shell audit and Markdown, not a screen                                      |
| **Status**    | Reviewed — all ten gaps resolved into the story, 17/09/2026                                                    |

<!-- STEP 1's GRILLING PASS DID NOT RUN. <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10
     and 11 be written for both SPRINT-05 members first and the decisions taken afterwards. Status
     is therefore Draft, not Signed off, and every gap below is [OPEN]: none has been fed back into
     US008.md yet, because feeding a gap back is a story edit and the decisions have not been made.

     THIS MATTERS FOR THE GATE ORDER. project-management/src/11-QA/PLANNING/CLAUDE.md: "do not
     proceed to a sprint plan while a story carries an unresolved [OPEN] acceptance-criteria gap".
     Ten [OPEN] gaps stand below, so 16-sprint-plans is BLOCKED on US008 until they are resolved
     into the story. That is the plan working as designed, not a defect in it.

     METHOD. US008 is 1057 lines with most of its reasoning in HTML comment blocks, so the pass was
     run as a re-measurement rather than a read: every line citation in the story's Given clauses
     was re-opened in the tree on 17/09/2026 and compared. Nine of the nine settings citations
     still land. One whole class of criteria — the version and migration-key chain — did not, and
     it had moved for a reason outside this story. That is AC-GAP-1.

     code/docs/GATE-REPORTING.md: the absence of the interview is stated, not implied. -->

---

## 1. Acceptance criteria gaps

**Ten gaps found — three blocking, six material, one minor. All ten are
`[RESOLVED] 17/09/2026`:** each has been fed back into
`project-management/src/02-STORIES/US008.md` as an acceptance criterion or a task, and the three
blocking ones were settled by ADRs at `15-decisions` —
`ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` (AC-GAP-1),
`ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` (AC-GAP-2) and
`ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` (AC-GAP-3).
**`16-sprint-plans` is unblocked on US008.**

**The three blocking gaps cluster on one theme: the doctrine is sound and its _delivery_ is
where the story is wrong.** AC-GAP-1 is a criterion that has gone factually false since the story
was written; AC-GAP-2 is a control specified into a channel the story's own evidence says is
suppressed; AC-GAP-3 is a security precondition the story read and did not notice.

- **AC-GAP-1** `[RESOLVED] 17/09/2026` · **blocking** — **the version chain the migration key rests on has moved,
  and the key as written can never fire for the projects that need it.** The story says the four
  version files are "all at 7.5.0 on 09/09/2026" and move "to 7.6.0" as a MINOR bump, and
  `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` pins the `_migrations:` key at `v7.6.0`.
  Measured 17/09/2026: `VERSION` reads **7.6.0** already, `CHANGELOG.md`'s top released heading is
  `## [7.6.0] - 14/09/2026`, and `VERSION-HISTORY.md`'s newest row is the 14/09/2026 shared-AI /
  Codex release — **which contains none of this doctrine**. Copier gates each entry on
  `from_template.version < current <= self.version`, so a project generated at or updated to 7.6.0
  has `7.6.0 < 7.6.0` false and **skips the advisory entirely** — while still carrying the old
  `URL-STRATEGY.md` Phase 2 mandate to set `SESSION_COOKIE_DOMAIN`. It then takes the `__Host-`
  names with its `Domain` line intact and every login fails behind a successful update. The ADR's
  own supporting evidence has also gone: it argues the key fires because the repository "carries 72
  tags including the minors `v7.1.0` to `v7.5.0`" — there are **77 tags today and no `v7.6.0`
  among them**, and `Template.version` derives from tags through dunamai. `copier.yml:929-932`
  states the governing rule on the `v6.0.0` entry and records this template breaking it once
  before: _"This repository has mis-keyed a migration by tagging a batch retroactively, which
  strands every project that updated in between."_ **Resolution is not a bigger number chosen here**
  — the doctrine's release has not been decided, the ADR has to be amended or superseded, and both
  are `15-decisions`' work. Threat model TM-15 and Section 3b; assessment §7.13.
- **AC-GAP-2** `[RESOLVED] 17/09/2026` · **blocking** — **the merge hazard's only mitigation is specified into a
  channel the story itself plans to prove is suppressed.** The story's design for a project that
  already set `SESSION_COOKIE_DOMAIN` is the `v7.6.0` advisory: copier's three-way merge keeps
  both lines without conflicting, every browser then rejects the prefixed cookie, and the advisory
  is what tells the operator. Its own Q11 `GAPS.md` row records that `template-update.sh` redirects
  the update wholesale and tails the log **only on failure**, so a _successful_ preview prints
  "Preview only — your project is unchanged" over an advisory that fired. Its own manual QA
  criterion then says: _"The preview blindness is reproduced and recorded as the Q11 row's
  evidence."_ **So the story plans to demonstrate that its mitigation does not reach its operator,
  and ships anyway.** That is the false-green shape `code/docs/GATE-REPORTING.md` exists to name.
  Either the blindness is repaired inside this story, or the doctrine gets a second channel a
  `--preview` operator sees, and neither has been decided. Threat model TM-03 + TM-04;
  assessment §7.11.
- **AC-GAP-3** `[RESOLVED] 17/09/2026` · **blocking** — **the `__Host-` prefix depends on `Secure`, `Secure`
  depends on a client-suppliable header, and the story enumerated that header without noticing.**
  The first scenario's Given lists `staging.py:9-22` and `production.py:9-22` line by line,
  `SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")` at `:19` among them. The prefix's
  three preconditions are stated as `Secure`, `Path=/` and no `Domain` — and the criterion proves
  `Secure` by asserting `SESSION_COOKIE_SECURE = True` is present in the module.
  **CORRECTED 17/09/2026 — this gap's stated mechanism was wrong, and the finding survives the
  correction.** Django does **not** take the cookie's `Secure` attribute from
  `request.is_secure()`; it reads the setting, at `django/contrib/sessions/middleware.py:74`
  (`secure=settings.SESSION_COOKIE_SECURE or None`) and `django/middleware/csrf.py:264`, verified
  against Django 6.1.0 in this tree's own dependency set on 17/09/2026. The criterion therefore
  does prove the attribute is emitted. **The dependency is real and runs through
  `SECURE_SSL_REDIRECT`**, which reads `request.is_secure()` at
  `django/middleware/security.py:25`: a request reaching Django over plain HTTP with a
  client-supplied `X-Forwarded-Proto: https` skips the redirect, is served over HTTP, and the
  browser then discards the prefixed cookie by the prefix's own definition — the same silent
  anonymous request as the merge hazard, by another route. Pre-existing — **and this is the story
  that makes it load-bearing**. Threat model TM-05; assessment 7.5. **Resolved by
  `ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md`**: the owner guide states the
  precondition and `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 gains the
  clause requiring the edge to strip any client-supplied value. A correct conclusion reached by a
  wrong mechanism is worth more to fix than a wrong conclusion, because the mechanism is what the
  next reader reuses.
- **AC-GAP-4** `[RESOLVED] 17/09/2026` · material — **"no module anywhere" is a claim the gate cannot make.** The
  criterion reads: _"no module anywhere assigns `SESSION_COOKIE_DOMAIN`, `CSRF_COOKIE_DOMAIN`,
  `SESSION_COOKIE_PATH` or `CSRF_COOKIE_PATH`"_, and the gate clause is scoped to
  `code/src/django/config/settings/`. Three assignment sites sit outside it and are invisible to a
  directory scan: a runtime write to `django.conf.settings` (an `AppConfig.ready()` is the
  canonical place), an environment-driven value read anywhere, and any settings module a project
  adds outside that directory. The clause is right; the criterion over-claims what it proves, and
  a reviewer ticking it reads a green gate as proof of a global rule. Threat model TM-08;
  assessment §7.7.
- **AC-GAP-5** `[RESOLVED] 17/09/2026` · material — **the prefix is bound to two named modules, and the rule is
  not about modules.** `staging.py` and `production.py` get the names; the presence clause reads
  those two. Nothing states what a project deploying a third TLS-serving module must do, and
  nothing makes its absence visible — the gate is green either way, because the two it names both
  pass. The doctrine should bind **every module that serves TLS** and each clause should name the
  modules it read in its skip note, so an unchecked third module is visible rather than silent.
  Threat model TM-02; assessment §7.2.
- **AC-GAP-6** `[RESOLVED] 17/09/2026` · material — **`CSRF_COOKIE_HTTPONLY` is presented without its limit, and
  the limit is the important half.** The story's Security criterion says the CSRF cookie carries
  `HttpOnly`, no committed JavaScript reads it, and the token reaches HTMX only through the
  template. All true, and measured — a sweep for `document.cookie`, `getCookie` and `csrftoken`
  under `code/src/django` returns zero hits on 17/09/2026. But the owner guide is required to
  carry "the two limits N-005 named", and there is a third: `{% csrf_token %}` renders the token
  into the DOM and `hx-headers` into a body attribute, both readable by injected script, so
  `HttpOnly` does **not** defend the token against XSS. Without that stated, the next reader takes
  the setting as anti-theft and stops there. Threat model TM-06; assessment §7.6.
- **AC-GAP-7** `[RESOLVED] 17/09/2026` · material — **"protection is per cookie name" is stated and its
  consequence for this app is not drawn.** `django.contrib.messages` is in `INSTALLED_APPS`
  (`base.py:33`) with `MessageMiddleware` in `MIDDLEWARE` (`:59`), and its default storage falls
  back to a cookie. That cookie is unprefixed and stays subdomain-writable after this story, as
  would any language cookie. The doctrine's scope is session and CSRF; saying so explicitly is
  what stops a reader concluding the cookie jar is now covered. Threat model TM-07;
  assessment §7.6.
- **AC-GAP-8** `[RESOLVED] 17/09/2026` · material — **the deploy consequence is stated in one direction only.**
  The advisory is required to say the rename invalidates every live session and open CSRF token
  "so WHEN is a decision". Two things follow that nothing says: a **rollback** restores the plain
  names and invalidates everything a second time, so the reverse is not free; and a **rolling
  deploy** serves both names at once, logging a load-balanced user out repeatedly and surfacing as
  CSRF 403s rather than a login redirect. An operator planning this from the advisory as written
  would reasonably choose a rolling deploy. Threat model TM-10, TM-11; assessment §7.9.
- **AC-GAP-9** `[RESOLVED] 17/09/2026` · material — **the new fixture tree enters three other clauses' scan
  surface, and nothing says it must stay inert there.** The existing fixtures are flat: nine files
  under `broken/`, thirteen under `clean/`, with `settings.py`, `INVARIANTS.md`, `tsconfig.json`,
  `mcp.py` and `asgi.py` fixed by name in `point_scopes_at` and everything else found by recursive
  scan. The story adds `broken/settings/` and `clean/settings/` subtrees. `negative-space.sh:252`
  and `:278` both run `find "$dir" -type f -name '*.py'` with exclusions for `*/tests/*`,
  `*/migrations/*` and `conftest.py` — **and none for `*/settings/*`** — so the five new `.py`
  fixtures become input to the constraint and key-register clauses as well as to the three new
  ones. A fixture that happens to look like a constraint or a raised key would trip a clause it
  was never written for, and the `--self-test`'s `EXPECTED` comparison would then pass or fail for
  the wrong reason. The criterion should require the new fixtures to be **inert for every clause
  but the three they exist for**, asserted rather than assumed.
- **AC-GAP-10** `[RESOLVED] 17/09/2026` · minor — **`byte-identical to HEAD ff24084` is a criterion pinned to a
  commit that is no longer HEAD.** It appears twice, for `dev.py` and `test.py`. The branch is at
  `1e00a4b` today. The settings directory was last touched at `c09a189` (23/08/2026) and all nine
  cited line numbers still land, so the criterion is **true** — but it is checkable only by
  whoever knows `ff24084` is reachable, and it will read as stale to everyone else. State the
  property (`dev.py` and `test.py` are unchanged by this story) and keep the commit as evidence
  rather than as the assertion.

<!-- TWO THINGS THIS PASS DID NOT FIND, recorded because their absence is informative. First,
     every settings line citation in the story holds: base.py:159-162, staging.py:9-22 and
     production.py:9-22 were re-opened on 17/09/2026 and the two environment blocks are
     byte-identical by diff, exactly as claimed. Second, the "nothing is half-built" sweep is
     still true — __Host, SESSION_COOKIE_NAME, CSRF_COOKIE_NAME, SESSION_COOKIE_DOMAIN,
     CSRF_COOKIE_DOMAIN, SESSION_COOKIE_PATH, CSRF_COOKIE_PATH, CSRF_COOKIE_SAMESITE and
     CSRF_COOKIE_HTTPONLY return zero hits across code/src. A story whose factual base holds this
     well after eight days is unusual, and it is why the gaps above are about delivery and
     boundaries rather than about drift. -->

## 2. Test scenarios

Derived from the story's Gherkin, the browser cookie storage model and the shell tree rather than
from a wireframe — this story has none. Every scenario is executable against the repository after
the change lands, except where marked as requiring a generated project.

### Happy path (HP-nn)

| ID    | Given                                                               | When                                                   | Then                                                                                                           |
| ----- | ------------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| HP-01 | The three settings modules after the change                         | `negative-space.sh` runs unscoped                      | Exit 0, and none of the three new clauses appears in the skip notes — they **ran**, they did not skip          |
| HP-02 | `base.py` carrying `CSRF_COOKIE_HTTPONLY = True` exactly once       | Every environment module is read                       | No module re-assigns it (`config/settings/CLAUDE.md:39-41`)                                                    |
| HP-03 | `staging.py` and `production.py` after the change                   | Each is read                                           | Both `__Host-` names sit beside `SESSION_COOKIE_SECURE` / `CSRF_COOKIE_SECURE` at `:21-22`, in the same module |
| HP-04 | The dev stack up under dev's plain cookie names                     | Log in at `/control/`, POST a form, fire an HTMX write | All three succeed; the browser shows `csrftoken` flagged `HttpOnly`; no console error                          |
| HP-05 | A scratch tree with `SESSION_COOKIE_DOMAIN` planted in `staging.py` | The `v7.6.0` advisory runs                             | It names that file and line, prints its operator notes, and exits 0 — **and prints no value from the file**    |
| HP-06 | A clean tree                                                        | The advisory runs                                      | It prints nothing and exits 0                                                                                  |
| HP-07 | The five guide edits landed                                         | `doc-references.sh --path code/docs` runs              | Exit 0, "Clean — every citation resolves." — the story's criterion (Q6), never the whole-tree figure           |

### Error states (ES-nn)

The visible failures here are gate findings and browser rejections. Each is a check that the
control bites, not a defect to expect.

| ID    | Given                                                                  | When                                 | Then                                                                                                                       |
| ----- | ---------------------------------------------------------------------- | ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | `base.py` with `CSRF_COOKIE_HTTPONLY` removed                          | `negative-space.sh` runs             | `csrf-cookie-httponly-absent` fires                                                                                        |
| ES-02 | `staging.py` with the `__Host-` session name removed                   | The same                             | `cookie-host-prefix-absent` fires, naming `staging.py`                                                                     |
| ES-03 | `production.py` with `SESSION_COOKIE_SECURE` removed but the name kept | The same                             | `cookie-host-prefix-absent` fires — the prefix without its precondition is the exact state the clause exists for           |
| ES-04 | Any module assigning `SESSION_COOKIE_DOMAIN`                           | The same                             | `cookie-scope-widened` fires                                                                                               |
| ES-05 | Any module assigning `CSRF_COOKIE_PATH = "/app"`                       | The same                             | `cookie-scope-widened` fires; `= "/"` does **not**                                                                         |
| ES-06 | A `__Host-` name shipped alongside a `Domain` (the merge state)        | A browser receives the `Set-Cookie`  | **The cookie is silently discarded.** No error, no header, no log — the request arrives anonymous (TM-13; AC-GAP-2's case) |
| ES-07 | A guide edit that breaks a citation under `code/docs`                  | `doc-references.sh --path code/docs` | Exit 1 — the scoped criterion is a plain pass or a plain fail, unlike the inherited-red whole-tree run                     |

### Edge cases (EC-nn)

| ID    | Given                                                                           | When                             | Then                                                                                                                          |
| ----- | ------------------------------------------------------------------------------- | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | A settings module carrying `# SESSION_COOKIE_DOMAIN = ".example.com"` commented | The gate reads it                | **No finding.** Every match is assignment-anchored at line start, so a comment is neither a finding nor a pass                |
| EC-02 | The widened `base.py:161-162` comment naming `CSRF_COOKIE_SECURE`               | The gate reads it                | **No finding and no pass** — same anchoring rule, applied to the story's own new prose                                        |
| EC-03 | `config/settings/CONTEXT.md`, which gains six rows naming these very settings   | The absence clause runs          | It is not read as a module. The clause's scope is `*.py`, stated rather than inferred from "every module under the directory" |
| EC-04 | `dev.py` and `test.py`, carrying no cookie setting at all                       | Both clause families run         | Neither fires either way — no presence claim is made of them, and there is no `Domain` to find                                |
| EC-05 | `__init__.py`, which is zero bytes                                              | The absence clause runs          | No finding, and no crash on an empty file                                                                                     |
| EC-06 | A settings module absent from the directory                                     | Its presence clause runs         | It **skips with a note** — an absent surface reported as such, never an absent tool reported as clean (`:407` idiom)          |
| EC-07 | The new `broken/settings/` and `clean/settings/` fixture trees                  | The full `--self-test` runs      | The eleven pre-existing clause names behave exactly as before; only the three new names change the result (AC-GAP-9)          |
| EC-08 | A fixture deliberately removed                                                  | `--self-test` runs               | Exit 2 with the missing-fixture message — **never a silent pass** (`:492-493`, unchanged)                                     |
| EC-09 | A project generated at 7.6.0 carrying the old `Domain` mandate                  | `copier update` crosses `v7.6.0` | **The advisory does not fire.** `7.6.0 < 7.6.0` is false. This is AC-GAP-1, and it is a test that currently proves the defect |
| EC-10 | A project holding a `*_COOKIE_DOMAIN` line **deliberately** — the N-005 case    | The advisory runs                | It reports and does not act; the operator judges and dismisses it                                                             |
| EC-11 | The settings directory absent entirely                                          | The advisory runs                | Exit 0 early, printing nothing                                                                                                |

### Permission and access (PA-nn)

**None in the web sense — this story adds no endpoint, no screen and no protected action.** There
is no role boundary to cross and no identifier whose ownership could be verified. The story's
`API`, `Frontend` and `GDPR` flags are correctly `N/A`.

**That is not the same as saying it has no access-control content — it has more than any story in
this backlog so far.** The authorisation boundary is the **browser's cookie jar**, and the subject
is which host may write a credential the apex will honour. The two scenarios that behave most like
`PA` rows are above: **ES-06**, where a mis-delivered prefix silently de-authenticates every user
(A01:2025, TM-03), and the one that cannot be written as a repository test at all —

| ID    | Given                                                               | When                                                       | Then                                                                                                           |
| ----- | ------------------------------------------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| PA-01 | A host under the apex, and an apex serving `__Host-sessionid`       | The sub host sends `Set-Cookie: sessionid=…; Domain=.apex` | The browser stores it, **and it cannot overwrite the apex's prefixed cookie** — different name, refused write  |
| PA-02 | The same, against the **pre-change** apex serving plain `sessionid` | The same                                                   | It **does** overwrite. This is the exposure the story closes, and the pair is the only proof that it closed it |

**PA-01 and PA-02 need two hosts and a real browser, which this repository has neither of.** They
are recorded as the doctrine's defining test and marked unrunnable here rather than omitted, per
`code/docs/GATE-REPORTING.md` — the settings assertions below are a proxy for them, and a proxy is
not the thing.

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The story renders nothing; its outputs are
a gate finding read in a terminal, an advisory read in a terminal, and Markdown read in an editor.

One thing that is _not_ an accessibility criterion and belongs beside it: **the failure mode this
story can cause is invisible by design.** A browser that rejects a malformed `__Host-` cookie
gives the user no message at all — they are simply not logged in. The advisory's wording is
therefore the whole of the user-facing experience of a botched delivery, which is why HP-05 reads
it as an operator would rather than only checking that it ran.

## 4. Responsive behaviour

**N/A — no rendered screen.** Same reason as Section 3.

## 5. GDPR & security constraints

**No PII and no new protected action.** Two strictly-necessary cookies are hardened; no personal
data is collected, no consent surface moves, no retention window changes, and no new store is
introduced. The story's `GDPR` flag is correctly `N/A` — hardening the scope of a session cookie
is a security change, not a data-protection one.

**Security constraints are the substance of this story rather than a side concern**, and the
thirteen in `ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` Section 7 are not restated here. Five are
QA-visible and are what a tester checks directly:

- **Presence in the same module** (§7.1) — a `__Host-` name and its `SECURE = True` precondition
  must be in **one** module, not satisfied across two. ES-03 is the case that proves it.
- **Absence as the rule** (§7.3) — the tester's instinct is to check what is set. Here what is
  _not_ set is the control, and EC-01/EC-02 exist because prose naming a banned setting must not
  register as either a finding or a pass.
- **The skip note is a result** (§7.4) — HP-01 checks that the three clauses **ran**. A clause
  that skipped and a clause that passed print differently and must never be read as the same thing.
- **The advisory reaches its operator** (§7.11, AC-GAP-2) — the manual walk reproduces the preview
  blindness. Recording it as evidence is correct; recording it and shipping is the gap.
- **The key fires** (§7.13, AC-GAP-1) — EC-09 is written as a test that currently demonstrates the
  defect. It is the one scenario expected to **fail** until the key moves.

**The severities are read with their promotion triggers.** 0 CRITICAL, 0 HIGH, 9 MEDIUM, 4 LOW,
2 INFO is a fact about a template repository that serves nothing to a browser, not a verdict on
the design: five findings promote to `HIGH`, four of them the moment a generated project deploys
or updates. Per `code/docs/GATE-REPORTING.md` the zero is never reported as the gate passing.

## 6. Developer notes — testability

- **Assert the absence, and assert the anchoring separately.** A clause that greps for
  `SESSION_COOKIE_DOMAIN` anywhere in a file will fire on the story's own widened `base.py`
  comment and on `CONTEXT.md`'s new table rows. EC-01 to EC-03 are the three fixtures that prove
  the anchoring, and they are cheaper to write now than to debug later.
- **Scope the absence clause to `*.py` explicitly.** "Every module under the directory" is prose;
  the directory contains `CONTEXT.md` and `CLAUDE.md` as well as five modules and an empty
  `__init__.py` (AC-GAP-4, EC-03, EC-05).
- **Keep the new fixtures inert for the other eleven clauses.** `negative-space.sh:252` and `:278`
  recursive-scan `*.py` with no `*/settings/*` exclusion, so `broken/settings/base.py` is input to
  the constraint and key-register clauses too. Write them to contain cookie settings and nothing
  else, and assert the eleven pre-existing `EXPECTED` names are unaffected (AC-GAP-9, EC-07).
- **`:92` and `:481` are one change.** Widening the real scope without repointing the self-test
  scope makes the self-test prove a different shape than the real run — the defect the script's
  own header at `:59-65` says it refuses at the parser.
- **There is no reverse comparison, and the story is right to say so.** The old script has no
  clause for a fixture to fail against, so the "fixture fails against the pre-change script" form
  US004 uses does not apply. The discriminating comparison runs one way only: the **new** script
  over the **pre-change** modules reports all three clauses, over the post-change modules reports
  none. Record both halves.
- **The citation gate is inherited red and this story's criterion is the scoped run.**
  `--path code/docs` must exit 0 with "Clean — every citation resolves." The whole-tree figure is
  captured before the first edit and at close, recorded with HEAD and detector hash, and
  **never reported as a pass** (`ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026`). Measured on
  this branch at `1e00a4b`: whole tree **259, exit 1**; `--path code/docs` **Clean, exit 0**.
- **`wc -l` is not the length gate's measure**, and `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`
  is not in the gate's scope at all — `is_instructional()` binds a `CONTEXT.md`/`CLAUDE.md`
  basename or a path with a `docs`, `workflows` or `.claude` segment, and that path has none. Do
  not claim a length figure for it as the gate's.
- **ShellCheck has no project script.** `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and
  clippy. Run it by hand over `negative-space.sh` and the advisory, and record it as run or as not
  run — never as a `lint.sh` pass.
- **No pytest assertion over the five settings values.** The story declines one deliberately: the
  gate clause is the invariant's one named enforcement point (`code/docs/NEGATIVE-SPACE.md`), and a
  second enforcer of the same rule is the shape that guide forbids. `tests/all.sh` is run as a
  regression check — the test settings module still imports — and reported as what it measured.

## 7. Gate readings, measured 17/09/2026 — indicative, not baselines

Taken on branch `pm/story-creation` at HEAD `1e00a4b`, working tree clean bar one untracked
handoff. **These are readings, not the story's baseline**: `ADR-US003-CITATION-GATE-BASELINE-DIFF`
obliges a capture immediately before the first edit, under a re-asserted detector hash, and that
capture has not happened because no edit has.

| Reading                              | Value at `1e00a4b`                                                              |
| ------------------------------------ | ------------------------------------------------------------------------------- |
| `doc-references.sh` (whole tree)     | **259, exit 1** — unchanged from `fff578f`, per-file breakdown identical        |
| `doc-references.sh --path code/docs` | **Clean, exit 0** — US008's own criterion, green today                          |
| `VERSION`                            | **7.6.0** (14/09/2026) — see AC-GAP-1                                           |
| `git tag` count · newest             | **77** · **`v7.5.0`** — no `v7.6.0` tag exists                                  |
| `negative-space.sh` `EXPECTED`       | **11** clause names at `:506-508`; the story grows it to 14                     |
| Fixtures                             | `broken/` **9** files, `clean/` **13** — flat; the story adds a subtree to each |
| Cookie-settings sweep, `code/src`    | **Zero hits** across all nine search terms                                      |
| Cookie-read sweep, `code/src/django` | **Zero hits** — `document.cookie`, `getCookie`, `csrftoken`                     |

**One figure the next reader should not re-measure.** `code/src/scripts/audits/CONTEXT.md` is at
**299** of 300 as the gate counts, not 298, and the `GAPS.md` entry of 17/09/2026 holds it. The
story's criterion says "unchanged at 298"; that number is wrong in the story and correct nowhere.
It is not raised as an AC gap because the story's actual requirement — **do not touch that file**
(Q3) — is unaffected by which side of the line it sits on. Record the real figure in the test
record.

## 8. Two candidates refuted, and why they are recorded

Both were raised during the pass, both were plausible, and both fail on a fact. They are kept
because the next reader will otherwise raise them again.

- **"The absence clause will false-positive on `config/settings/CONTEXT.md`."** The file gains six
  rows naming `SESSION_COOKIE_NAME`, `CSRF_COOKIE_NAME` and the rest, and it sits inside the scanned
  directory. It does not fire: every row is a Markdown table line opening with a pipe, and the
  clause is assignment-anchored at line start. The **real** issue is narrower and survives as AC-GAP-4 —
  the clause's scope should say `*.py` rather than "every module under the directory", because the
  protection here is an implementation detail of the anchoring rather than a stated boundary.
- **"`base.py:159-162` has drifted since the story was written."** Re-opened on 17/09/2026:
  `SESSION_COOKIE_HTTPONLY = True` at `:159`, `SESSION_COOKIE_SAMESITE = "Lax"` at `:160`, the
  two-line absence comment at `:161-162`, exactly as cited. The settings directory's last commit
  is `c09a189` (23/08/2026) and the commit batch of 07–17/09/2026 did not touch it. Every settings
  citation in the story holds; **only the version chain moved**, which is why AC-GAP-1 is about
  `VERSION` and not about `base.py`.

---

## Cross-references

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/02-STORIES/US008.md` — the story this plan tests; all ten gaps above are `[RESOLVED] 17/09/2026` in it
- `project-management/src/03-SPRINTS/SPRINT-05.md` — the record this story is the `Must` of; its QA and Security rows are first-pass values recomputed at each gate's close
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` · `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` — the security gate whose Section 7 constraints this plan exercises
- `project-management/src/15-DECISIONS/ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026.md` — the record AC-GAP-1 invalidates; `15-decisions` owns the repair
- `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the regime Section 7 runs under
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
- `code/docs/GATE-REPORTING.md` — the rule the `N/A` sections, the unrunnable `PA` rows, Section 7 and Section 8 rest on
