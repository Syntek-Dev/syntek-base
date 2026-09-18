# Threat Model Plan — US008 Host-only cookies under `__Host-` names

| Field               | Value                                                                                                                                    |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**           | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                           |
| **Date**            | 17/09/2026                                                                                                                               |
| **Author**          | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                                                        |
| **Status**          | Draft                                                                                                                                    |
| **Feature surface** | No runtime endpoint. Five settings assignments across three modules, three `negative-space.sh` clauses, five guides, one copier advisory |

<!-- STEP 1's GRILLING PASS DID NOT RUN, and that is a deviation rather than an omission.
     project-management/workflows/10-security-checks/STEPS.md Step 1 opens with grill-with-docs.
     <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10 and 11 be written for both SPRINT-05
     members first and the decisions taken afterwards, so this model was derived from the story,
     the map's cookie spine and the tree rather than from an interview. Every fact below carries
     the file and line it was measured at on 17/09/2026 for exactly that reason: nothing here
     rests on a confirmation that has not happened. Status is Draft, not Reviewed, and Section 4a
     lists what the interview would have to settle.

     code/docs/GATE-REPORTING.md: a pass that could not run is never reported as a pass that ran. -->

---

## 1. Scope

This model covers **a browser-security doctrine and its enforcement**, not a feature. US008 adds
no endpoint, no screen, no model and no log line; ten of its thirteen flags read `N/A`. Three
things are modelled: the cookie surface as the doctrine leaves it, the failure modes of the gate
that enforces it, and the delivery mechanism that carries it into a project that already deployed
under the opposite rule.

**The blast radius is wider than any story modelled here so far, and that is the fact to hold on
to.** US006 guarded this repository's own scripts. US008 ships **configuration that generated
projects deploy** — so every finding below is a finding about a class of projects, not about this
tree. This repository's own posture is `development` (`.claude/CLAUDE.md` Section 0) and nothing
here is served to a browser, which is why the severities in Section 3 read low and why Section 3a
exists to say what promotes them.

### Surface under review

- **The settings** — `code/src/django/config/settings/base.py` (`CSRF_COOKIE_HTTPONLY`),
  `staging.py` and `production.py` (`SESSION_COOKIE_NAME`, `CSRF_COOKIE_NAME` under `__Host-`)
- **The absence that is the rule** — no `SESSION_COOKIE_DOMAIN`, `CSRF_COOKIE_DOMAIN`,
  `SESSION_COOKIE_PATH` or `CSRF_COOKIE_PATH` in any module
- **The enforcement point** — three `[gate: fail]` clauses in
  `code/src/scripts/audits/negative-space.sh` (624 lines; `SETTINGS_FILE` at `:92`,
  `point_scopes_at` at `:473` with its single-file scope at `:481`, `EXPECTED` at `:506-508`)
- **The doctrine's owner** — `code/docs/security/CRYPTO-AND-DATA.md:122-123`, and the four
  guides that defer to it
- **The delivery** — `.copier/migrations/v7.6.0-host-only-cookies.sh` and its `copier.yml`
  `_migrations:` entry

### Measured state of the surface, 17/09/2026

| Fact                                                                                                | Reading                                                                |
| --------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `__Host`, `*_COOKIE_NAME`, `*_COOKIE_DOMAIN`, `*_COOKIE_PATH`, `CSRF_COOKIE_HTTPONLY` in `code/src` | **Zero hits.** Nothing is half-built                                   |
| `document.cookie` / `getCookie` / `csrftoken` under `code/src/django`                               | **Zero hits.** No committed script reads a cookie                      |
| `base.py:159-162`                                                                                   | `SESSION_COOKIE_HTTPONLY`, `SESSION_COOKIE_SAMESITE`, the absence note |
| `staging.py:9-22` vs `production.py:9-22`                                                           | **Byte-identical**, confirmed by `diff`. 14 lines each                 |
| `negative-space.sh` `EXPECTED`                                                                      | Eleven clause names at `:506-508`                                      |
| Fixtures                                                                                            | `broken/` 9 files, `clean/` 13 — flat, `settings.py` fixed by name     |

### Severity scale

| Level      | Definition                                                                |
| ---------- | ------------------------------------------------------------------------- |
| `CRITICAL` | Exploitable without authentication, or full compromise / credential theft |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    |
| `LOW`      | Minor impact; defence-in-depth measure                                    |
| `INFO`     | Observation with no immediate exploitability                              |

Only **CRITICAL** and **HIGH** block sprint planning
(`project-management/docs/SECURITY-GUIDE.md`). **This model produced none of either** — read
Section 4 with Section 3a, never alone.

**The scale is attacker-shaped and seven of these fifteen rows have no attacker.** They are the
doctrine mis-delivered, the gate mis-scoped, or a deploy consequence nobody is told about. Said
plainly here so a `MEDIUM` is not read as "an adversary would find this hard".

## 2. Trust boundaries

| ID  | From                             | To                            | Data crossing                                                       |
| --- | -------------------------------- | ----------------------------- | ------------------------------------------------------------------- |
| TB1 | Browser cookie jar               | The apex host                 | `sessionid` / `csrftoken` on every request, by name                 |
| TB2 | A sibling or sub host            | The same browser cookie jar   | A `Set-Cookie` the apex will later receive                          |
| TB3 | Page JavaScript (incl. injected) | The cookie jar and the DOM    | `document.cookie`; the token rendered into markup                   |
| TB4 | Edge proxy                       | Django                        | `X-Forwarded-Proto`, on which `Secure` and therefore `__Host-` rest |
| TB5 | A settings module                | The running application       | Which module supplies `*_COOKIE_NAME`, and whether it is deployed   |
| TB6 | This template                    | A generated project           | `copier update`'s three-way merge, and the `_migrations:` advisory  |
| TB7 | A future edit                    | `negative-space.sh`'s verdict | Whether the doctrine's one enforcement point still sees the edit    |

## 3. STRIDE threat table

**Status is `Proposed` at planning time.** Re-assessed against shipped code in the
`../IMPLEMENTATION/` counterpart.

| ID    | STRIDE | OWASP      | NIST CSF | TB  | Threat description                                                                                                                                                                                                                                                         | Severity | Status   | Mitigation (proposed control)                                                                                                                                                                |
| ----- | ------ | ---------- | -------- | --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | S      | `A01:2025` | `PR.AA`  | TB2 | **Session fixation by subdomain write.** A host under the apex sets `sessionid` with `Domain=.apex`; the browser sends it to the apex alongside the apex's own, and the server reads whichever the jar orders first. Omitting `Domain` stops the _read_, never the _write_ | MEDIUM   | Proposed | The `__Host-` prefix — the only mechanism that refuses a `Domain`-bearing `Set-Cookie` for that name. This is the threat the story exists to close, and it closes it                         |
| TM-02 | E      | `A01:2025` | `PR.AA`  | TB5 | **The prefix lands in two modules and the gate checks those two.** A project that deploys `dev.py`, `test.py` or a fourth module of its own — the shape `DJANGO_SETTINGS_MODULE` makes trivial — gets plain names, no prefix, and a green gate                             | MEDIUM   | Proposed | The doctrine is stated as "every module that serves TLS", the gate's presence clause names the modules it read in its skip note, and the owner guide states the rule for a fourth module     |
| TM-03 | T      | `A02:2025` | `RC.RP`  | TB6 | **A `copier update` merge produces a cookie no browser will store.** The project keeps its `SESSION_COOKIE_DOMAIN` line, the template adds the `__Host-` name, neither side conflicts — and the prefix's own definition makes every login fail                             | MEDIUM   | Proposed | The `v7.6.0` advisory names every `*_COOKIE_DOMAIN` still assigned, with file and line. **Its reach is the open question of this model — see TM-04**                                         |
| TM-04 | D      | `A10:2025` | `DE.CM`  | TB6 | **The advisory is invisible at the moment it is meant to inform.** `template-update.sh` redirects the update wholesale and tails the log only on failure, so a _successful_ preview prints "your project is unchanged" over an advisory that fired                         | MEDIUM   | Proposed | The story accepts this as a `GAPS.md` row (Q11) rather than fixing it. **Accepting it makes TM-03's only mitigation conditional on a channel that does not reach the operator** — Section 4a |
| TM-05 | S      | `A07:2025` | `PR.AA`  | TB4 | **`Secure` is inferred from a header, and `__Host-` is inferred from `Secure`.** `staging.py:19` / `production.py:19` set `SECURE_PROXY_SSL_HEADER`, so any request path reaching Django without the edge stripping `X-Forwarded-Proto` can assert https                   | MEDIUM   | Proposed | Pre-existing and not introduced here, but the doctrine now _depends_ on it. Recorded as a precondition the owner guide must state, and routed — not silently inherited                       |
| TM-06 | I      | `A03:2025` | `PR.DS`  | TB3 | **`CSRF_COOKIE_HTTPONLY` does not protect the token from XSS.** `{% csrf_token %}` renders it into the DOM and `hx-headers` into a body attribute; injected script reads both. Claiming it as anti-theft would be overclaiming                                             | LOW      | Proposed | Stated as a named limit in the owner guide beside the rule, in the same shape as N-005's two limits — defence in depth against _cookie_ reads only                                           |
| TM-07 | T      | `A01:2025` | `PR.DS`  | TB2 | **The prefix protects per cookie name, and two other cookies exist.** `django.contrib.messages` is installed (`base.py:33`) with `MessageMiddleware` (`:59`), whose default storage falls back to a cookie; a language cookie is equally unprefixed                        | LOW      | Proposed | Recorded as the scope of the doctrine rather than closed here: session and CSRF are named, everything else is residual and named as residual                                                 |
| TM-08 | T      | `A02:2025` | `DE.CM`  | TB7 | **The gate reads a directory; the rule is global.** `django.conf.settings` is writable at runtime, an `AppConfig.ready()` can assign a `_DOMAIN`, and an environment-driven override never appears as an assignment the clause can anchor on                               | MEDIUM   | Proposed | The clause's scope is stated in the owner guide as what it _can_ see, so a reader does not take a green gate as proof of the global rule                                                     |
| TM-09 | T      | `A02:2025` | `DE.CM`  | TB7 | **The gate's own register is knowingly left wrong.** `code/src/scripts/audits/CONTEXT.md:170` says "Twelve `[gate: fail]`"; after this story there are fifteen, and Q3 declines to correct it on that file's docs-length headroom                                          | LOW      | Proposed | The story names this as a cost. Recorded here because the register is what a reader consults to learn what the gate checks, and a wrong one is a quiet false negative                        |
| TM-10 | D      | `A10:2025` | `RC.RP`  | TB1 | **The rename is a hard invalidation with no rollback that is cheaper than the deploy.** Every live session and every in-flight CSRF token dies at the deploy that renames — and dies again on a rollback, which restores the plain names                                   | MEDIUM   | Proposed | The advisory says _when_ is the operator's decision. It must also say the reverse is true, so a rollback is not planned as free                                                              |
| TM-11 | D      | `A10:2025` | `PR.PS`  | TB1 | **A rolling deploy serves both names at once.** Old pods set `sessionid`, new pods `__Host-sessionid`; a user load-balanced between them is logged out repeatedly and sees CSRF 403s rather than a login redirect                                                          | MEDIUM   | Proposed | The advisory names the cutover shape the rename requires — not a rolling one — rather than leaving the operator to discover it                                                               |
| TM-12 | D      | `A10:2025` | `PR.PS`  | TB5 | **Dev and production now differ by cookie name.** Any fixture, Playwright selector, monitoring rule or edge config matching `sessionid` literally passes in dev and fails in production. The advisory names this for _updating_ projects only                              | LOW      | Proposed | The same warning is owed to this template's own future code, not only to a project taking the update — stated in the owner guide, which every project reads                                  |
| TM-13 | R      | `A09:2025` | `DE.AE`  | TB1 | **A browser silently discards a malformed `__Host-` cookie.** No error, no header, no log — the user simply is not logged in, and the server sees an anonymous request. There is no detection anywhere for the failure this story can cause                                | INFO     | Proposed | Accepted residual: `code/docs/security/AUDIT-TRAIL.md` covers application events, not a browser's storage decision. Named rather than left to be discovered at 3am                           |
| TM-14 | E      | `A03:2025` | `PR.PS`  | TB6 | **An eighth entry joins a trusted-execution surface.** Copier migrations run shell in the updating project's tree under `--trust`, which `.github/workflows/audit-template.yml:154` passes. Advisory-only content does not change the mechanism                            | INFO     | Proposed | Pre-existing boundary, widened by one entry. The script is advisory and `exit 0` always; recorded so the trust surface is counted rather than assumed constant                               |
| TM-15 | T      | `A03:2025` | `PR.PS`  | TB6 | **The advisory is keyed to a release that has already shipped without the doctrine, so it can never fire for the projects that need it.** Measured 17/09/2026 — see Section 3b                                                                                             | MEDIUM   | Proposed | The key names the release the doctrine **actually ships in**, and the release is tagged. `copier.yml:929-932` already states this rule and records the template mis-keying once before       |

## 3b. TM-15 in full — the migration key names a release that has already gone

This threat is set out separately because it is the only row whose premise moved **after the
story was written**, and because it is the one finding that changes what US008 ships rather than
what it says.

**Measured 17/09/2026, in this order:**

| Reading                                          | Value                                                       |
| ------------------------------------------------ | ----------------------------------------------------------- |
| `VERSION`                                        | **7.6.0**                                                   |
| `CHANGELOG.md` top released heading              | `## [7.6.0] - 14/09/2026` — the shared-AI / Codex release   |
| `VERSION-HISTORY.md` newest row                  | `14/09/2026 · 7.6.0` — no cookie content in its summary     |
| `git tag \| wc -l` · newest tag                  | **77** · **`v7.5.0`**. There is **no `v7.6.0` tag**         |
| The story's own acceptance criterion             | "all at 7.5.0 on 09/09/2026 — move to 7.6.0 … a MINOR bump" |
| `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` | Pins the `_migrations:` key at `v7.6.0`                     |

**Two independent failures follow, and the second is the one that bites.**

1. **The story's Given is stale.** It was written on 09/09/2026 when the four version files read
   7.5.0. They were bumped to 7.6.0 on 14/09/2026 by unrelated work. The criterion "move to 7.6.0"
   is already satisfied by a release that contains none of this doctrine.
2. **A key of `v7.6.0` never fires for the project that most needs it.** Copier gates each entry
   on `from_template.version < current <= self.version`. A project generated at or updated to
   7.6.0 — which ships the **old** `URL-STRATEGY.md` Phase 2 mandate to set `SESSION_COOKIE_DOMAIN`
   — has `from_template.version == 7.6.0`, so `7.6.0 < 7.6.0` is false and the entry is skipped.
   That project takes the `__Host-` names with its `Domain` line intact, every browser rejects the
   cookie by the prefix's own definition, and **no advisory is printed at any point**.
3. **The ADR's supporting evidence does not hold either.** It argues the key "resolves and fires"
   because "this repository carries 72 tags including the minors `v7.1.0` to `v7.5.0`". There are
   77 tags today and **`v7.6.0` is not among them**; `Template.version` derives from tags through
   dunamai, so a `v7.6.0` key is not `<= self.version` until that tag exists.

**The template has already learned this lesson and written it down.** `copier.yml:929-932`, on the
`v6.0.0` entry: _"Keyed v6.0.0 because that is the release the directories MOVED in … not the
release somebody noticed. This repository has mis-keyed a migration by tagging a batch
retroactively, which strands every project that updated in between."_ US008 as written reproduces
exactly that defect.

**What closes it** is not a bigger number chosen now — the doctrine's release is whichever one
carries it, and that is not yet decided. The constraint is in Section 4b.11, and the ADR is the
artefact that has to move, which makes this gate `15-decisions`' first piece of input.

## 3a. Design-state severity and promotion triggers

**Every severity above is a present-state reading of a template repository that serves nothing.**
Read the table with this one, or the `MEDIUM`s will be mistaken for a verdict on the doctrine —
which is sound, and closes the threat it was written for.

| Threat              | Present state | Design state | Promotes when                                                                          |
| ------------------- | ------------- | ------------ | -------------------------------------------------------------------------------------- |
| TM-01               | MEDIUM        | **HIGH**     | Any generated project routes a second host under the apex                              |
| TM-03 + TM-04       | MEDIUM        | **HIGH**     | The first generated project runs `copier update` across the doctrine's release         |
| TM-15               | MEDIUM        | **HIGH**     | Any project is generated at, or updated to, 7.6.0 — the key is then unreachable for it |
| TM-05               | MEDIUM        | **HIGH**     | Any deployment exposes Django on a path that does not traverse the edge                |
| TM-02, TM-08        | MEDIUM        | **HIGH**     | A project deploys a settings module the gate's presence clause does not name           |
| TM-10, TM-11        | MEDIUM        | **HIGH**     | The first deploy of the rename onto a surface with live sessions                       |
| TM-06, TM-07, TM-12 | LOW           | **MEDIUM**   | The first XSS finding, the first second host, or the first name-matching monitor rule  |

**TM-03 with TM-04 is the pair to watch.** Separately each is a `MEDIUM`; together they are one
control whose only delivery channel is suppressed at the moment of use. That is the shape
`code/docs/GATE-REPORTING.md` calls a false green, and Section 4a makes it the first thing the
grilling pass must settle.

## 4. Blocking findings & escalations

**None.** No `CRITICAL` and no `HIGH` finding was raised, so no record is written to
`../../VULNERABILITIES/PLANNING/` and sprint planning is not gated.

That zero is a measured outcome with its reason, not an audit that found nothing: fifteen
threats were raised across all six STRIDE categories and every one resolves to `MEDIUM` or below
**because this repository deploys nothing and no generated project is known to be live**. Section
3a names the event that promotes each, and **five promote to `HIGH`**.

Per `code/docs/GATE-REPORTING.md` this is never reported as "the security gate passed".

## 4a. What the grilling pass must settle

<!-- SETTLED 17/09/2026 at `15-decisions`. The questions are kept as written, each answered below,
     because a question deleted once answered leaves the next reader unable to see what was
     weighed. TM-05's mechanism is CORRECTED where it is stated: Django takes the cookie's `Secure`
     attribute from the setting, not from `request.is_secure()` — the dependency runs through
     `SECURE_SSL_REDIRECT`. See QA-PLAN AC-GAP-3 and the ADR named below. -->

**All five are settled.** Q1 by
`project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` — the
preview is repaired inside this story, so the advisory reaches an operator who previews. Q2 by
`ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` — it is a precondition, stated in the
owner guide and carried into `EDGE-REQUIREMENTS.md` Section 6 as a strip-the-header clause. Q3 as
acceptance criteria — the owner guide states the gate's reach, and the prefix binds every
TLS-serving module with each clause naming what it read. Q4 as acceptance criteria — rollback
invalidates a second time and a rolling deploy is unsafe, both named in the advisory. Q5 by
`ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`, which supersedes the record that pinned
`v7.6.0`: the advisory is dual-gated and the key is derived at release.

Step 1's interview did not run at the time (see the header). Five questions were genuinely open,
and each changes an acceptance criterion rather than a wording:

1. **TM-03/TM-04 — does the advisory reach anyone?** The story accepts the preview blindness as a
   `GAPS.md` row while relying on the advisory as TM-03's only mitigation. Either the blindness is
   fixed, or the doctrine needs a second channel that a `--preview` operator actually sees.
2. **TM-05 — is `SECURE_PROXY_SSL_HEADER` a precondition of this doctrine?** If it is, the owner
   guide states it and the deployment contract carries it. If it is not, say why the prefix is
   safe without it.
3. **TM-02/TM-08 — what does the gate claim to prove?** A clause over a directory cannot prove a
   global rule. The owner guide should state the gate's reach so a green run is not over-read.
4. **TM-10/TM-11 — what cutover shape does the rename require?** The story says _when_ is the
   operator's decision; it does not say a rolling deploy is unsafe, or that rollback costs the
   same as the deploy.
5. **TM-15 — which release carries the doctrine, and what happens to the ADR that pinned
   `v7.6.0`?** This gate cannot rewrite `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`, whose
   supporting evidence Section 3b measured as no longer holding. `15-decisions` owns it.

## 4b. Developer constraints carried forward

Checkable by reading the shipped settings, the gate and the advisory. These become US008
acceptance criteria; the assessment numbers them.

1. Every module that assigns a `__Host-` name satisfies the prefix's three preconditions **in that
   same module** — `SESSION_COOKIE_SECURE = True`, `CSRF_COOKIE_SECURE = True`, `Path` left at
   Django's `/`, no `Domain`
2. No module under `code/src/django/config/settings/` assigns `*_COOKIE_DOMAIN`, or a
   `*_COOKIE_PATH` other than `/`
3. Every gate match is assignment-anchored at line start, so a setting named in a comment is
   neither a finding nor a pass
4. Each clause **skips with a note** when the module it reads is absent — an absent surface
   reported as such, never an absent tool reported as clean
5. `:92` and `:481` move together, so the self-test proves the shape the real run proves
6. The owner guide carries the two N-005 limits **and** TM-06's — the prefix is per cookie name,
   pre-prefix browsers accept a prefixed cookie unconditionally, and `HttpOnly` does not defend
   the token against XSS
7. The owner guide states what the gate can and cannot see (TM-08), so a green run is not read as
   proof of the global rule
8. The advisory prints file paths, line numbers and setting names — **never a value**
9. The advisory names the invalidation in both directions (TM-10) and the cutover shape (TM-11)
10. The three clauses carry no silencing annotation — `audits/CONTEXT.md:170`'s standing rule
11. **The `_migrations:` key names the release the doctrine actually ships in, and that release
    is tagged** — re-derived at implementation rather than carried from 09/09/2026, because
    `VERSION` moved to 7.6.0 on 14/09/2026 without this doctrine (Section 3b)

## 5. Out of scope

- **`SameSite`** — `code/docs/security/CRYPTO-AND-DATA.md:120-121` owns it in prose, Django's
  default of `Lax` satisfies it, and no script reads it. Named as a boundary, not omitted
- **The `messages` and language cookies** (TM-07) — residual, recorded not closed; the doctrine
  names session and CSRF
- **`SECURE_PROXY_SSL_HEADER`'s own correctness** (TM-05) — pre-existing, and a deployment-contract
  question for `how-to/src/SERVER-ARCHITECTURE/`
- **`template-update.sh`'s preview blindness** — the story's own `GAPS.md` row of 09/09/2026 (Q11)
- **The duplicated `staging.py` / `production.py` block** — the `GAPS.md` row of 09/09/2026 (Q9)
- **Authentication itself** — no credential, session-issuance or MFA path changes here

---

## Cross-references

- `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the post-implementation review that re-assesses this model
- `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` — the posture assessment that consumes this model
- `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — where blocking findings escalate; none from this model
- `project-management/src/02-STORIES/US008.md` — the story being modelled
- `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` — _The cookie spine_, N-004 to N-008, where the doctrine was argued
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 (2025) / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this model
- `code/docs/SECURITY.md` · `code/docs/NEGATIVE-SPACE.md` — the code-side enforcement these controls specify
- `code/docs/GATE-REPORTING.md` — why Section 4's absence, and the header's missing grilling pass, are stated rather than left implied
