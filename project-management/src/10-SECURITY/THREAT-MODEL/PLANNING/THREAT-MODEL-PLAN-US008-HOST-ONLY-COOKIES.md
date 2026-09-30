# Threat Model Plan — US008 Host-only cookies under `__Host-` names

| Field               | Value                                                                                                                                    |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**           | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                           |
| **Date**            | 17/09/2026                                                                                                                               |
| **Author**          | Claude Code — `security` skill, Opus · reviewed by <%DEVELOPER_NAME%>                                                                    |
| **Status**          | Signed off · **corrected in place 28/09/2026** — see below                                                                               |
| **Feature surface** | No runtime endpoint. Five settings, three gate clauses, five guides, two copier advisories, one preview report block and one edge clause |

<!-- AMENDED 28/09/2026, at the gate-10 sign-off. Until then the Author row read "Claude Code —
     `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**", the Status row read
     "Draft", and the Feature surface row read "No runtime endpoint. Five settings assignments
     across three modules, three `negative-space.sh` clauses, five guides, one copier advisory".
     `15-decisions` widened that surface on 17/09/2026, through the three Accepted ADR-US008
     records of that date: a second copier advisory, the template-update.sh preview report block
     and the EDGE-REQUIREMENTS.md Section 6 clause. See the note below. -->

<!-- STEP 1's GRILLING PASS DID NOT RUN, and that is a deviation rather than an omission.
     project-management/workflows/10-security-checks/STEPS.md Step 1 opens with grill-with-docs.
     <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10 and 11 be written for both SPRINT-05
     members first and the decisions taken afterwards, so this model was derived from the story,
     the map's cookie spine and the tree rather than from an interview. Every fact below carries
     the file and line it was measured at on 17/09/2026 for exactly that reason: nothing here
     rests on a confirmation that has not happened. Status is Draft, not Reviewed, and Section 4a
     lists what the interview would have to settle.

     code/docs/GATE-REPORTING.md: a pass that could not run is never reported as a pass that ran. -->

<!-- AMENDED 28/09/2026: "Status is Draft, not Reviewed, and Section 4a lists what the interview
     would have to settle" was true until then. Section 4a was settled at `15-decisions` on
     17/09/2026, and <%DEVELOPER_NAME%> signed this model off on 28/09/2026. The grilling pass
     itself still did not run at this gate, and the comment above stays as that day's record. -->

> **Corrected in place and signed off, 28/09/2026, at the `16-sprint-plans` gate.**
> <%DEVELOPER_NAME%> signed this model off on 28/09/2026 (settled 28/09/2026, 16-sprint-plans
> grilling round 1 Q1). Text that the three Accepted records of 17/09/2026 had already overtaken
> was corrected in the same pass rather than left under a signature (settled 28/09/2026,
> 16-sprint-plans grilling round 2 Q5):
>
> - **TM-05 and TB4 state the mechanism correctly.** Django emits the cookie's `Secure` attribute
>   from the setting; the header drives `request.is_secure()`, and so whether `SECURE_SSL_REDIRECT`
>   fires. The redirect is skipped only for a request that bypasses the edge **and** carries a
>   client-supplied `X-Forwarded-Proto: https`.
>   `project-management/src/15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md`
>   required this correction in its own Follow-on, and the Django 6.1.0 source it cites was re-read
>   on 28/09/2026. The severity is unchanged.
> - **TM-03, TM-04, TM-14, TM-15 and TM-15's Section 3a trigger follow the decisions.** There are
>   two advisories, and the one guarding the always-wrong state is unversioned and state-gated.
>   The preview is repaired inside US008, and the cutover key is derived at release. The header
>   row and the surface list widen to match, and Section 5's out-of-scope list narrows. Section
>   3b's heading and closing sentence, and constraint 4b.11, follow TM-15 in the same way.
> - **The edge clause and the owner guide's precondition paragraph are US008's to write.** Section
>   4a and Section 5 now say so. Neither `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`
>   nor the owner guide carries them yet (measured 28/09/2026, and again 30/09/2026).
> - **Four counts and references were wrong.** "Five promote to `HIGH`" is nine threats across six
>   rows (Section 4). A tag count of 77 re-counts to 72, locally and on origin. The
>   `code/src/scripts/audits/CONTEXT.md` register row is at `:174`, not `:170`. The `clean/`
>   fixture tree is not flat.
> - **Every settled question is marked settled where it is asked.** That covers Section 4a's five,
>   the Section 3a pair paragraph and the Section 3b closing paragraph.
>
> This is a correction rather than a supersession because no finding, ID or severity moved: 0
> CRITICAL, 0 HIGH, 9 MEDIUM, 4 LOW and 2 INFO before and after. Each superseded wording is kept
> in a dated comment beside the text that replaced it. Every `path:line` citation into this
> repository was re-measured on 30/09/2026 against the tree committed together with the 18-TESTS
> split, one commit (settled 30/09/2026, 16-sprint-plans grilling round 4 Q13 and Q14), with this
> gate's corrections applied. Section 4a's three citations into
> `project-management/src/02-STORIES/US008.md` follow the story as this gate corrects it, on
> 28/09/2026 and 30/09/2026. One citation had moved: the split adds two lines to `copier.yml`'s
> `_exclude` list, so the `v6.0.0` migration note cited by TM-15 and Section 3b at
> `copier.yml:929-932` now sits at `:931-934`, the text unchanged. Both are re-pointed, and
> Section 3b's committed citation keeps the number it replaces in a dated comment. Every other
> citation still locates its text; TM-05's two settings citations and constraint 10's register
> citation now carry full paths. The tag count, `main`'s 7.5.0 and the absent edge clause and
> precondition paragraph were re-checked on 30/09/2026 and still hold; the Django source was not
> re-read.

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
- **The delivery** — two advisories in `.copier/migrations/`: the unversioned, state-gated
  `cookie-domain-conflict.sh` and the keyed `v<RELEASE>-host-only-cookies.sh`, with their two
  `copier.yml` `_migrations:` entries and the key derived at release
- **The channel that carries it** — a success-path report block in
  `code/src/scripts/development/template-update.sh`, beside the one at `:162`, so that a preview
  shows the migration report
- **The edge contract** — a clause in `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`
  Section 6 requiring the edge to strip any client-supplied `X-Forwarded-Proto` and set it itself

<!-- AMENDED 28/09/2026: the delivery bullet read "`.copier/migrations/v7.6.0-host-only-cookies.sh`
     and its `copier.yml` `_migrations:` entry" until then, and the channel and edge-contract
     bullets were absent. Superseded and widened on 17/09/2026 by
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026, ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026
     and ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026. -->

### Measured state of the surface, 17/09/2026

| Fact                                                                                                | Reading                                                                                 |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `__Host`, `*_COOKIE_NAME`, `*_COOKIE_DOMAIN`, `*_COOKIE_PATH`, `CSRF_COOKIE_HTTPONLY` in `code/src` | **Zero hits.** Nothing is half-built                                                    |
| `document.cookie` / `getCookie` / `csrftoken` under `code/src/django`                               | **Zero hits.** No committed script reads a cookie                                       |
| `base.py:159-162`                                                                                   | `SESSION_COOKIE_HTTPONLY`, `SESSION_COOKIE_SAMESITE`, the absence note                  |
| `staging.py:9-22` vs `production.py:9-22`                                                           | **Byte-identical**, confirmed by `diff`. 14 lines each                                  |
| `negative-space.sh` `EXPECTED`                                                                      | Eleven clause names at `:506-508`                                                       |
| Fixtures                                                                                            | `broken/` 9 files, flat · `clean/` 13, one under `tests/` · `settings.py` fixed by name |

<!-- AMENDED 28/09/2026: the Fixtures row read "`broken/` 9 files, `clean/` 13 — flat,
     `settings.py` fixed by name" until then. `clean/` has carried
     `code/src/scripts/audits/fixtures/negative-space/clean/tests/test_guard.py` since 59eba9d
     (11/08/2026), so it was not flat on 17/09/2026 either. The file counts stand, and the layout
     matters because AC-GAP-9's new `settings/` fixture trees are described against it. -->

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

| ID  | From                             | To                            | Data crossing                                                                                          |
| --- | -------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------ |
| TB1 | Browser cookie jar               | The apex host                 | `sessionid` / `csrftoken` on every request, by name                                                    |
| TB2 | A sibling or sub host            | The same browser cookie jar   | A `Set-Cookie` the apex will later receive                                                             |
| TB3 | Page JavaScript (incl. injected) | The cookie jar and the DOM    | `document.cookie`; the token rendered into markup                                                      |
| TB4 | Edge proxy                       | Django                        | `X-Forwarded-Proto`, which decides whether `SECURE_SSL_REDIRECT` fires, and so whether `__Host-` holds |
| TB5 | A settings module                | The running application       | Which module supplies `*_COOKIE_NAME`, and whether it is deployed                                      |
| TB6 | This template                    | A generated project           | `copier update`'s three-way merge, and the `_migrations:` advisory                                     |
| TB7 | A future edit                    | `negative-space.sh`'s verdict | Whether the doctrine's one enforcement point still sees the edit                                       |

<!-- AMENDED 28/09/2026: TB4's data cell read "`X-Forwarded-Proto`, on which `Secure` and
     therefore `__Host-` rest" until then. Django emits `Secure` from the setting, and the header
     drives the redirect instead, as corrected at TM-05 below. -->

## 3. STRIDE threat table

**Status is `Proposed` at planning time.** Re-assessed against shipped code in the
`../IMPLEMENTATION/` counterpart.

| ID    | STRIDE | OWASP      | NIST CSF | TB  | Threat description                                                                                                                                                                                                                                                                                                                                                                                                                 | Severity | Status   | Mitigation (proposed control)                                                                                                                                                                |
| ----- | ------ | ---------- | -------- | --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | S      | `A01:2025` | `PR.AA`  | TB2 | **Session fixation by subdomain write.** A host under the apex sets `sessionid` with `Domain=.apex`; the browser sends it to the apex alongside the apex's own, and the server reads whichever the jar orders first. Omitting `Domain` stops the _read_, never the _write_                                                                                                                                                         | MEDIUM   | Proposed | The `__Host-` prefix — the only mechanism that refuses a `Domain`-bearing `Set-Cookie` for that name. This is the threat the story exists to close, and it closes it                         |
| TM-02 | E      | `A01:2025` | `PR.AA`  | TB5 | **The prefix lands in two modules and the gate checks those two.** A project that deploys `dev.py`, `test.py` or a fourth module of its own — the shape `DJANGO_SETTINGS_MODULE` makes trivial — gets plain names, no prefix, and a green gate                                                                                                                                                                                     | MEDIUM   | Proposed | The doctrine is stated as "every module that serves TLS", the gate's presence clause names the modules it read in its skip note, and the owner guide states the rule for a fourth module     |
| TM-03 | T      | `A02:2025` | `RC.RP`  | TB6 | **A `copier update` merge produces a cookie no browser will store.** The project keeps its `SESSION_COOKIE_DOMAIN` line, the template adds the `__Host-` name, neither side conflicts — and the prefix's own definition makes every login fail                                                                                                                                                                                     | MEDIUM   | Proposed | The unversioned, state-gated `cookie-domain-conflict.sh` names every `*_COOKIE_DOMAIN` still assigned, on every update — file, line and setting name, never a value. Reach: TM-04            |
| TM-04 | D      | `A10:2025` | `DE.CM`  | TB6 | **The advisory is invisible at the moment it is meant to inform.** `template-update.sh` redirects the update wholesale and tails the log only on failure, so a _successful_ preview prints "your project is unchanged" over an advisory that fired                                                                                                                                                                                 | MEDIUM   | Proposed | **Repaired inside US008** (Section 4a, Q1): an additive success-path block in `template-update.sh` surfaces the migration report, and a manual criterion proves the advisory visible         |
| TM-05 | S      | `A07:2025` | `PR.AA`  | TB4 | **`SECURE_SSL_REDIRECT` trusts a header; `__Host-` needs TLS.** `Secure` comes from the setting, but `code/src/django/config/settings/staging.py:19` / `code/src/django/config/settings/production.py:19` let `X-Forwarded-Proto` drive `request.is_secure()`: a request reaching Django by a path that skips the edge while carrying a client-supplied `X-Forwarded-Proto: https` skips the redirect, and the cookie is discarded | MEDIUM   | Proposed | Pre-existing, now depended on (Section 4a, Q2): a precondition the owner guide states, plus an edge-contract clause to strip any client-supplied `X-Forwarded-Proto` and set it              |
| TM-06 | I      | `A03:2025` | `PR.DS`  | TB3 | **`CSRF_COOKIE_HTTPONLY` does not protect the token from XSS.** `{% csrf_token %}` renders it into the DOM and `hx-headers` into a body attribute; injected script reads both. Claiming it as anti-theft would be overclaiming                                                                                                                                                                                                     | LOW      | Proposed | Stated as a named limit in the owner guide beside the rule, in the same shape as N-005's two limits — defence in depth against _cookie_ reads only                                           |
| TM-07 | T      | `A01:2025` | `PR.DS`  | TB2 | **The prefix protects per cookie name, and two other cookies exist.** `django.contrib.messages` is installed (`base.py:33`) with `MessageMiddleware` (`:59`), whose default storage falls back to a cookie; a language cookie is equally unprefixed                                                                                                                                                                                | LOW      | Proposed | Recorded as the scope of the doctrine rather than closed here: session and CSRF are named, everything else is residual and named as residual                                                 |
| TM-08 | T      | `A02:2025` | `DE.CM`  | TB7 | **The gate reads a directory; the rule is global.** `django.conf.settings` is writable at runtime, an `AppConfig.ready()` can assign a `_DOMAIN`, and an environment-driven override never appears as an assignment the clause can anchor on                                                                                                                                                                                       | MEDIUM   | Proposed | The clause's scope is stated in the owner guide as what it _can_ see, so a reader does not take a green gate as proof of the global rule                                                     |
| TM-09 | T      | `A02:2025` | `DE.CM`  | TB7 | **The gate's own register is knowingly left wrong.** `code/src/scripts/audits/CONTEXT.md:174` says "Twelve `[gate: fail]`"; after this story there are fifteen, and Q3 declines to correct it on that file's docs-length headroom                                                                                                                                                                                                  | LOW      | Proposed | The story names this as a cost. Recorded here because the register is what a reader consults to learn what the gate checks, and a wrong one is a quiet false negative                        |
| TM-10 | D      | `A10:2025` | `RC.RP`  | TB1 | **The rename is a hard invalidation with no rollback that is cheaper than the deploy.** Every live session and every in-flight CSRF token dies at the deploy that renames — and dies again on a rollback, which restores the plain names                                                                                                                                                                                           | MEDIUM   | Proposed | The advisory says _when_ is the operator's decision. It must also say the reverse is true, so a rollback is not planned as free                                                              |
| TM-11 | D      | `A10:2025` | `PR.PS`  | TB1 | **A rolling deploy serves both names at once.** Old pods set `sessionid`, new pods `__Host-sessionid`; a user load-balanced between them is logged out repeatedly and sees CSRF 403s rather than a login redirect                                                                                                                                                                                                                  | MEDIUM   | Proposed | The advisory names the cutover shape the rename requires — not a rolling one — rather than leaving the operator to discover it                                                               |
| TM-12 | D      | `A10:2025` | `PR.PS`  | TB5 | **Dev and production now differ by cookie name.** Any fixture, Playwright selector, monitoring rule or edge config matching `sessionid` literally passes in dev and fails in production. The advisory names this for _updating_ projects only                                                                                                                                                                                      | LOW      | Proposed | The same warning is owed to this template's own future code, not only to a project taking the update — stated in the owner guide, which every project reads                                  |
| TM-13 | R      | `A09:2025` | `DE.AE`  | TB1 | **A browser silently discards a malformed `__Host-` cookie.** No error, no header, no log — the user simply is not logged in, and the server sees an anonymous request. There is no detection anywhere for the failure this story can cause                                                                                                                                                                                        | INFO     | Proposed | Accepted residual: `code/docs/security/AUDIT-TRAIL.md` covers application events, not a browser's storage decision. Named rather than left to be discovered at 3am                           |
| TM-14 | E      | `A03:2025` | `PR.PS`  | TB6 | **Two scripts join a trusted-execution surface, one of them on every update.** Copier migrations run shell in the updating project's tree under `--trust`, which `.github/workflows/audit-template.yml:154` passes. Advisory-only content does not change the mechanism                                                                                                                                                            | INFO     | Proposed | Pre-existing boundary, widened by two entries, one unversioned. Both scripts advise and `exit 0` always; recorded so the trust surface is counted rather than assumed constant               |
| TM-15 | T      | `A03:2025` | `PR.PS`  | TB6 | **A version key written at design time can name a release that ships without the doctrine, and then never fires for the projects that need it.** Measured 17/09/2026 — see Section 3b                                                                                                                                                                                                                                              | MEDIUM   | Proposed | Two entries (Section 4a, Q5): the always-wrong state unversioned and state-gated, the cutover key derived at release against `git tag` and tagged in the same act (per `copier.yml:931-934`) |

<!-- AMENDED 28/09/2026. Six rows were overtaken by an Accepted record of 17/09/2026 or by a
     re-measurement, and each read as follows until then.
     TM-03 mitigation: "The `v7.6.0` advisory names every `*_COOKIE_DOMAIN` still assigned, with
     file and line. **Its reach is the open question of this model — see TM-04**". The advisory
     became two entries under ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.
     TM-04 mitigation: "The story accepts this as a `GAPS.md` row (Q11) rather than fixing it.
     **Accepting it makes TM-03's only mitigation conditional on a channel that does not reach the
     operator** — Section 4a". Under ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026 the preview
     is repaired inside US008 instead.
     TM-05 description: "**`Secure` is inferred from a header, and `__Host-` is inferred from
     `Secure`.** `staging.py:19` / `production.py:19` set `SECURE_PROXY_SSL_HEADER`, so any request
     path reaching Django without the edge stripping `X-Forwarded-Proto` can assert https". TM-05
     mitigation: "Pre-existing and not introduced here, but the doctrine now _depends_ on it.
     Recorded as a precondition the owner guide must state, and routed — not silently inherited".
     The mechanism was wrong. Django takes `Secure` from the setting (django/contrib/sessions/
     middleware.py:74 and django/middleware/csrf.py:264, Django 6.1.0, re-read 28/09/2026), and
     the header reaches the cookie only through SECURE_SSL_REDIRECT's call to request.is_secure()
     (django/middleware/security.py:25). Corrected per
     ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026, whose Follow-on required it. The
     severity is unchanged.
     TM-09 description: "`code/src/scripts/audits/CONTEXT.md:170`". The register row was at :170
     at HEAD ff24084 on 09/09/2026, where the story measured it, and at :174 by the commit that
     carried this model (1a9da7c). The plan inherited the story's number.
     TM-14 description: "**An eighth entry joins a trusted-execution surface.**" TM-14 mitigation:
     "Pre-existing boundary, widened by one entry. The script is advisory and `exit 0` always".
     Two scripts join now, and one of them is unversioned.
     TM-15 description: "**The advisory is keyed to a release that has already shipped without the
     doctrine, so it can never fire for the projects that need it.**" TM-15 mitigation: "The key
     names the release the doctrine **actually ships in**, and the release is tagged.
     `copier.yml:929-932` already states this rule and records the template mis-keying once
     before". 7.6.0 has not shipped: there is no v7.6.0 tag and main reads 7.5.0 (re-checked
     28/09/2026). The damage was prospective, as ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026
     records. -->

## 3b. TM-15 in full — a design-time key can name a release that ships without the doctrine

This threat is set out separately because it is the only row whose premise moved **after the
story was written**, and because it is the one finding that changes what US008 ships rather than
what it says.

**Measured 17/09/2026, in this order:**

| Reading                                          | Value                                                                            |
| ------------------------------------------------ | -------------------------------------------------------------------------------- |
| `VERSION`                                        | **7.6.0**                                                                        |
| `CHANGELOG.md` top released heading              | `## [7.6.0] - 14/09/2026` — the shared-AI / Codex release                        |
| `VERSION-HISTORY.md` newest row                  | `14/09/2026 · 7.6.0` — no cookie content in its summary                          |
| `git tag \| wc -l` · newest tag                  | **72**, re-counted 28/09/2026 · **`v7.5.0`**. There is **no `v7.6.0` tag**       |
| The story's own acceptance criterion             | "all at 7.5.0 on 09/09/2026 — move to 7.6.0 … a MINOR bump"                      |
| `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` | Pins the `_migrations:` key at `v7.6.0` — Superseded 17/09/2026 (Section 4a, Q5) |

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
   72 tags (re-counted 28/09/2026, locally and on origin) and **`v7.6.0` is not among them**;
   `Template.version` derives from tags through dunamai, so a `v7.6.0` key is not
   `<= self.version` until that tag exists.

<!-- AMENDED 28/09/2026: the tag count read "77" in the table above and in item 3 until then. It
     re-counts to 72, locally (git tag | wc -l) and on origin (git ls-remote --tags origin), with
     v7.5.0 the newest. The 77 cannot be reconstructed, and the 09/09/2026 record also read 72.
     The conclusion is unchanged, because there is no v7.6.0 tag. The same 77 stands in
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026's Context, which is evidence rather than the
     decision and is not amended. It also stood in the story and its QA plan, both corrected to
     72 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11), and in
     project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md, corrected on 28/09/2026, and in
     project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md, corrected
     to 72 on 30/09/2026 with the superseded wording kept in its dated comment (settled
     30/09/2026, 16-sprint-plans grilling round 4 Q15). The table's ADR row gained its
     supersession on 28/09/2026. -->

**The template has already learned this lesson and written it down.** `copier.yml:931-934`, on the
`v6.0.0` entry: _"Keyed v6.0.0 because that is the release the directories MOVED in … not the
release somebody noticed. This repository has mis-keyed a migration by tagging a batch
retroactively, which strands every project that updated in between."_ US008 as it stood on
17/09/2026 reproduced exactly that defect.

<!-- AMENDED 28/09/2026: the Section 3b heading read "TM-15 in full — the migration key names a
     release that has already gone", and the sentence above read "US008 as written reproduces
     exactly that defect", until then. 7.6.0 has not shipped (see TM-15's comment under the Section
     3 table), so no release had gone. The story no longer carries a v7.6.0 key either, because
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026 superseded the record that pinned it. -->

<!-- AMENDED 30/09/2026: the paragraph above cited `copier.yml:929-932` until then, which located
     the v6.0.0 entry's note at a18db0b. The 18-TESTS split, committed with this correction, adds
     two lines to `_exclude` above it and moves the note to :931-934; the text is unchanged. -->

**What closes it** is not a bigger number chosen now — the doctrine's release is whichever one
carries it, and that is not yet decided. The constraint is in Section 4b.11, and the ADR is the
artefact that has to move, which makes this gate `15-decisions`' first piece of input.

**Settled 17/09/2026 at `15-decisions`.**
`project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` supersedes
the record that pinned `v7.6.0`. The always-wrong state now rides an unversioned, state-gated
entry that no key can strand. The cutover notice's key is derived at release against `git tag`,
and the tag lands in the same act. Which release that is remains open by design, and the record
calls its `v7.7.0` a prediction. It also measured the damage as prospective, with no `v7.6.0` tag
and `main` at 7.5.0, and both facts still hold on 30/09/2026.

## 3a. Design-state severity and promotion triggers

**Every severity above is a present-state reading of a template repository that serves nothing.**
Read the table with this one, or the `MEDIUM`s will be mistaken for a verdict on the doctrine —
which is sound, and closes the threat it was written for.

| Threat              | Present state | Design state | Promotes when                                                                          |
| ------------------- | ------------- | ------------ | -------------------------------------------------------------------------------------- |
| TM-01               | MEDIUM        | **HIGH**     | Any generated project routes a second host under the apex                              |
| TM-03 + TM-04       | MEDIUM        | **HIGH**     | The first generated project runs `copier update` across the doctrine's release         |
| TM-15               | MEDIUM        | **HIGH**     | The cutover key is written before its own tag, or names a release lacking the doctrine |
| TM-05               | MEDIUM        | **HIGH**     | Any deployment exposes Django on a path that does not traverse the edge                |
| TM-02, TM-08        | MEDIUM        | **HIGH**     | A project deploys a settings module the gate's presence clause does not name           |
| TM-10, TM-11        | MEDIUM        | **HIGH**     | The first deploy of the rename onto a surface with live sessions                       |
| TM-06, TM-07, TM-12 | LOW           | **MEDIUM**   | The first XSS finding, the first second host, or the first name-matching monitor rule  |

<!-- AMENDED 28/09/2026: TM-15's trigger read "Any project is generated at, or updated to, 7.6.0 —
     the key is then unreachable for it" until then. ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026
     writes no v7.6.0 key, so that event can no longer produce the harm, and the trigger now names
     the event that can. No severity moved. -->

**TM-03 with TM-04 is the pair to watch.** Separately each is a `MEDIUM`; together they are one
control whose only delivery channel is suppressed at the moment of use. That is the shape
`code/docs/GATE-REPORTING.md` calls a false green, and Section 4a made it the first thing the
grilling pass had to settle. **Settled 17/09/2026:** US008 repairs the preview itself, so the
channel reaches an operator who previews (Section 4a, Q1). The pair's trigger above is unchanged.

<!-- AMENDED 28/09/2026: read "Section 4a makes it the first thing the grilling pass must settle"
     until then. -->

## 4. Blocking findings & escalations

**None.** No `CRITICAL` and no `HIGH` finding was raised, so no record is written to
`../../VULNERABILITIES/PLANNING/` and sprint planning is not gated.

That zero is a measured outcome with its reason, not an audit that found nothing: fifteen
threats were raised across all six STRIDE categories and every one resolves to `MEDIUM` or below
**because this repository deploys nothing and no generated project is known to be live**. Section
3a names the event that promotes each, and **all nine `MEDIUM`s promote to `HIGH`**, across six
trigger rows.

<!-- AMENDED 28/09/2026: read "five promote to HIGH" until then. The Section 3a table promotes nine
     threats, TM-01, -02, -03, -04, -05, -08, -10, -11 and -15, which is every MEDIUM, across six
     rows. -->

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
`ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` — it is a precondition, which US008
states in the owner guide and carries into `EDGE-REQUIREMENTS.md` Section 6 as a strip-the-header
clause. Q3 as
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
   **Settled 17/09/2026: the blindness is fixed inside US008**, by
   `project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`.
2. **TM-05 — is `SECURE_PROXY_SSL_HEADER` a precondition of this doctrine?** If it is, the owner
   guide states it and the deployment contract carries it. If it is not, say why the prefix is
   safe without it. **Settled 17/09/2026: it is a precondition**, by
   `project-management/src/15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md`.
   US008 states it in the owner guide and adds a strip-and-set clause to
   `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6. Neither carries it yet
   (measured 28/09/2026, and again 30/09/2026).
3. **TM-02/TM-08 — what does the gate claim to prove?** A clause over a directory cannot prove a
   global rule. The owner guide should state the gate's reach so a green run is not over-read.
   **Settled 17/09/2026 as acceptance criteria** in
   `project-management/src/02-STORIES/US008.md:924-934` (AC-GAP-4, AC-GAP-5).
4. **TM-10/TM-11 — what cutover shape does the rename require?** The story says _when_ is the
   operator's decision; it does not say a rolling deploy is unsafe, or that rollback costs the
   same as the deploy. **Settled 17/09/2026 as acceptance criteria** in
   `project-management/src/02-STORIES/US008.md:758-767` (the keyed advisory's cutover notice) and
   `project-management/src/02-STORIES/US008.md:1003-1008` (AC-GAP-8).
5. **TM-15 — which release carries the doctrine, and what happens to the ADR that pinned
   `v7.6.0`?** This gate cannot rewrite `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`, whose
   supporting evidence Section 3b measured as no longer holding. `15-decisions` owns it.
   **Settled 17/09/2026: superseded, not amended**, by
   `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`, with
   the key derived at release.

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
10. The three clauses carry no silencing annotation —
    `code/src/scripts/audits/CONTEXT.md:174`'s standing rule
11. **The advisory ships as two `_migrations:` entries.** The unversioned, state-gated
    `cookie-domain-conflict.sh` reports any `*_COOKIE_DOMAIN` still assigned, on every update, by
    file, line and setting name, never a value. The keyed `v<RELEASE>-host-only-cookies.sh`
    carries the cutover notice, and **its key names the release the doctrine actually ships in** —
    derived against `git tag` at the moment of release, with the tag landing in the same act,
    rather than carried from design time, because `VERSION` moved to 7.6.0 on 14/09/2026 without
    this doctrine (Section 3b)

<!-- AMENDED 28/09/2026: item 10 cited "`audits/CONTEXT.md:170`" until then. See TM-09's comment
     under the Section 3 table. -->

<!-- AMENDED 28/09/2026: item 11 read "**The `_migrations:` key names the release the doctrine
     actually ships in, and that release is tagged** — re-derived at implementation rather than
     carried from 09/09/2026, because `VERSION` moved to 7.6.0 on 14/09/2026 without this doctrine
     (Section 3b)" until then. Its rule stands under ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.
     It described the superseded single entry, though, and said "at implementation" where the
     record says against `git tag` at the moment of release. -->

## 5. Out of scope

- **`SameSite`** — `code/docs/security/CRYPTO-AND-DATA.md:120-121` owns it in prose, Django's
  default of `Lax` satisfies it, and no script reads it. Named as a boundary, not omitted
- **The `messages` and language cookies** (TM-07) — residual, recorded not closed; the doctrine
  names session and CSRF
- **`SECURE_SSL_REDIRECT`'s dependence on the header beyond cookies** (TM-05). It governs every
  response the deployable serves, and a security-hardening pass over the deployed surface owns it.
  The cookie precondition itself is in scope: US008 states it in the owner guide and adds the
  strip-and-set clause to `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6
- **The duplicated `staging.py` / `production.py` block** — the `GAPS.md` row of 09/09/2026 (Q9)
- **Authentication itself** — no credential, session-issuance or MFA path changes here

<!-- AMENDED 28/09/2026: until then this list also carried "**`SECURE_PROXY_SSL_HEADER`'s own
     correctness** (TM-05) — pre-existing, and a deployment-contract question for
     `how-to/src/SERVER-ARCHITECTURE/`" and "**`template-update.sh`'s preview blindness** — the
     story's own `GAPS.md` row of 09/09/2026 (Q11)". `15-decisions` brought both into US008's
     scope on 17/09/2026: the edge clause by ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026,
     and the preview repair by ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026. Only the
     redirect's wider exposure stays outside, as the first record's own Follow-on names it. -->

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
