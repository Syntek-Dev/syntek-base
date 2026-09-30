# Security Posture Assessment (Plan) — US008 Host-only cookies under `__Host-` names

| Field          | Value                                                                                                          |
| -------------- | -------------------------------------------------------------------------------------------------------------- |
| **Story**      | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule |
| **Date**       | 17/09/2026                                                                                                     |
| **Author**     | Claude Code — `security` skill, Opus · reviewed by <%DEVELOPER_NAME%>                                          |
| **Sprint**     | SPRINT-05 — this story is its `Must`, 8 SP of 13 / 11 (grace taken)                                            |
| **Status**     | Signed off · **corrected in place 28/09/2026** — see below                                                     |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                                       |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

<!-- STEP 1's GRILLING PASS DID NOT RUN. <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10
     and 11 be written for both SPRINT-05 members first and the decisions taken afterwards. This
     baseline therefore reports what was measured in the tree on 17/09/2026 and names, in Section
     8, the five questions it could not settle. Status is Draft. code/docs/GATE-REPORTING.md. -->

<!-- AMENDED 28/09/2026, at the gate-10 sign-off. Until then the Author row read "Claude Code —
     `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**", the Sprint row read
     "SPRINT-05 — this story is its `Must`, 8 of 11 SP", and the Status row read "Draft". The
     sprint reached 13 / 11 SP on 17/09/2026, on US009's re-estimate from 3 to 5 SP
     (`project-management/src/03-SPRINTS/SPRINT-05.md:38-41`). The comment above said Section 8
     names "the five questions it could not settle" and "Status is Draft". Both were true until
     then. The five were settled at `15-decisions` on 17/09/2026, and <%DEVELOPER_NAME%> signed
     this baseline off on 28/09/2026. The grilling pass itself still did not run at this gate, and
     the comment above stays as that day's record. -->

> **Corrected in place and signed off, 28/09/2026, at the `16-sprint-plans` gate.**
> <%DEVELOPER_NAME%> signed this baseline off on 28/09/2026 (settled 28/09/2026, 16-sprint-plans
> grilling round 1 Q1). Text that the three Accepted records of 17/09/2026 had already overtaken
> was corrected in the same pass rather than left under a signature (settled 28/09/2026,
> 16-sprint-plans grilling round 2 Q5):
>
> - **Section 8's five questions are each marked settled**, with the record or criterion that
>   settled each one. A signed-off baseline no longer reads "genuinely open".
> - **TM-05's mechanism is corrected in Sections 1, 4, 6 and 7.5**, as in the threat model.
>   Django emits `Secure` from the setting, and the header drives `SECURE_SSL_REDIRECT` through
>   `request.is_secure()`. The redirect is skipped only for a request that bypasses the edge
>   **and** carries a client-supplied `X-Forwarded-Proto: https`. 7.5 gains the edge-contract
>   clause the decision brought into scope, and that clause is US008's to write. Neither the edge
>   contract nor the owner guide carries it yet.
> - **7.11, 7.13 and the principal finding follow the decisions.** The preview is repaired inside
>   US008, and the story's scope changed to take it. 7.13 names both advisory entries, and the
>   cutover key is derived against `git tag` at release. TM-03, TM-04, TM-14 and TM-15 in Sections
>   4 and 6 follow the same three records.
> - **Counts and references were wrong.** "Five promote to `HIGH`" is nine across six rows.
>   "Eleven constraints" is thirteen. `code/src/scripts/audits/CONTEXT.md:170` is `:174`. The
>   Sprint row now reads 13 / 11 SP. The Decisions row lists the three Accepted records and marks
>   the superseded one.
>
> This is a correction rather than a supersession because no finding, ID or severity moved: 0
> CRITICAL, 0 HIGH, 9 MEDIUM, 4 LOW and 2 INFO before and after, and the thirteen constraints keep
> their numbers. Each superseded wording is kept in a dated comment beside the text that replaced
> it. Every `path:line` citation into this repository was re-measured on 30/09/2026 against the
> tree committed together with the 18-TESTS split, one commit (settled 30/09/2026, 16-sprint-plans
> grilling round 4 Q13 and Q14), with this gate's corrections applied. Section 8's three citations
> into `project-management/src/02-STORIES/US008.md` follow the story as this gate corrects it, on
> 28/09/2026 and 30/09/2026. One citation had moved: the split adds two lines to `copier.yml`'s
> `_exclude` list, so the `v6.0.0` migration note that Section 1 and 7.13 cite at
> `copier.yml:929-932` now sits at `:931-934`, the text unchanged. Both are re-pointed, the number
> they replace kept in a dated comment. Every other citation still locates its text; Section 1's
> two settings citations, and the register citation in Section 6 and 7.10, now carry full paths.
> Section 6's constraint references lose the section sign the same day, a writing-convention fix
> that moves no finding.

---

## 1. Summary

**The doctrine is right and the delivery is where the risk sits.** US008 closes a real,
source-verified exposure — a host under the apex can plant a session cookie the apex will accept,
and only the `__Host-` prefix stops the write — and it closes it the way RFC 6265bis's storage
model actually works rather than by omitting `Domain` and hoping. Fifteen findings were raised
across all six STRIDE categories: **0 CRITICAL, 0 HIGH, 9 MEDIUM, 4 LOW, 2 INFO**. Nothing gates
sprint planning and no vulnerability record is written.

That zero needs its reason, because it is a fact about the tree rather than about the design:
**this is a template repository at posture `development` that serves nothing to a browser, and no
generated project is known to be live.** Section 3a of the threat model names the event that
promotes each finding, and **all nine `MEDIUM`s promote to `HIGH`**, across six trigger rows. Per
`code/docs/GATE-REPORTING.md` this is not reported as "the security gate passed".

<!-- AMENDED 28/09/2026: read "five promote to HIGH" until then. The threat model's Section 3a
     promotes nine threats, which is every MEDIUM, across six rows. -->

**Risk concentrates in delivery, not in the doctrine.** The three settings assignments are correct
and the gate that guards them is well-shaped. What is weak is everything between this template and
a project that already deployed under the opposite rule: a `copier update` merge that produces a
cookie no browser will store (TM-03), whose only warning is printed into a log the preview does not
show (TM-04). Those two are one control with a suppressed output — and the story, as first
written, accepted the suppression as a `GAPS.md` row. **That pairing is this assessment's
principal finding**, and Section 7.11 is where it is closed. On 17/09/2026 the story took the
repair into its own scope (Section 8, question 1).

<!-- AMENDED 28/09/2026: read "and the story knowingly accepts the suppression as a GAPS.md row"
     until then. Reversed at `15-decisions` on 17/09/2026 by
     ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026. -->

**And the delivery has a second defect that only appeared after the story was written.** The
advisory was keyed `v7.6.0` — but `VERSION` was bumped to 7.6.0 on 14/09/2026 by unrelated work,
there is no `v7.6.0` tag, and copier's `from_template.version < current` predicate would therefore
skip the entry for exactly the projects carrying the old `Domain` mandate (TM-15, threat model
Section 3b). `copier.yml:931-934` already records this template mis-keying a migration once before
and stranding every project that updated in between. **This is the one finding that changes what
the story ships rather than what it says**, and it was `15-decisions`' first piece of input
because the artefact that had to move was an ADR. **Settled there on 17/09/2026:** the ADR moved by
supersession. The advisory now ships as two entries: the always-wrong state rides an unversioned,
state-gated entry, and the cutover key is derived at release, with the tag landing in the same act
(Section 8, question 5).

<!-- AMENDED 28/09/2026: read "The advisory is keyed v7.6.0", "predicate therefore skips the entry"
     and "it is 15-decisions' first piece of input because the artefact that has to move is an ADR"
     until then. Superseded by ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026. -->

<!-- AMENDED 30/09/2026: the paragraph above cited `copier.yml:929-932` until then, which located
     the v6.0.0 entry's note at a18db0b. The 18-TESTS split, committed with this correction, adds
     two lines to `_exclude` above it and moves the note to :931-934; the text is unchanged. -->

**Two further weaknesses are inherited rather than introduced, and are named rather than assumed
away.** `SECURE_PROXY_SSL_HEADER` (`code/src/django/config/settings/staging.py:19`,
`code/src/django/config/settings/production.py:19`) lets a header that an unshielded request path
could supply decide `request.is_secure()`, and so whether
`SECURE_SSL_REDIRECT` fires. A response served over plain HTTP then sets a prefixed cookie that
the browser discards (TM-05). And the gate reads a directory while the rule is global (TM-08).
Neither is US008's defect. Both become US008's dependency the moment the doctrine leans on them.

<!-- AMENDED 28/09/2026: read "makes Secure — and so the prefix — depend on a header an unshielded
     request path could supply" until then. Django emits Secure from the setting, and the header's
     reach is the redirect. Corrected per
     ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026. -->

<!-- AMENDED 30/09/2026: the paragraph above cited `staging.py:19` and `production.py:19` until
     then, bare filenames the citation audit cannot check, now given their full paths; the lines
     they locate are unchanged. -->

## 2. Scope

| Dimension  | Coverage                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US008 — host-only cookies, `__Host-` names, CSRF `HttpOnly`, one owning guide, three gate clauses                                                                                                                                                                                                                                                                                                                                                        |
| User flow  | **None** — the story adds no screen, route or journey; `05-USER-FLOW/` has nothing to reference                                                                                                                                                                                                                                                                                                                                                          |
| Wireframe  | **None**, and none is possible — the surface is configuration, a shell audit and Markdown                                                                                                                                                                                                                                                                                                                                                                |
| Schema     | **None** — no model, no migration, no PII. The DB and GDPR flags both read `N/A`                                                                                                                                                                                                                                                                                                                                                                         |
| Decisions  | `ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026` · `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026` · `ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026` · `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` · `ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026` (binding; supersedes `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026`, 30/09/2026) · `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` (Superseded 17/09/2026) |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                                                                                                                                                                                                                                                                                              |

<!-- AMENDED 28/09/2026: the Decisions row read "`ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` ·
     `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` ·
     `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026` (binding, unamended)" until then. The three
     Accepted records of 17/09/2026 were written after this baseline, and one of them superseded
     the first record. All six are under `project-management/src/15-DECISIONS/`, and none is
     edited by this correction. -->

<!-- AMENDED 30/09/2026: the Decisions row named
     `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026` "(binding, unamended)" until then. That
     record was superseded that day for the 18-TESTS split, not by US008, and its successor
     restates the regime unchanged but for the manual testing guide's path (settled 30/09/2026,
     16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round 7
     Q18). The row now names the successor as binding, with the record it supersedes beside it. -->

**Deviation, stated rather than silently absent.** `10-security-checks` Step 1 reviews user flows
and wireframes. This story has neither and can have neither. The trust boundaries in the threat
model were derived from the browser's cookie storage model, the three settings modules and the
delivery mechanism instead. **A second deviation** is the missing grilling pass — see the header.

## 3. Threat models referenced

- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md`
  — 15 findings, 7 trust boundaries (TB1 browser↔apex · TB2 sibling host↔cookie jar · TB3 page
  JavaScript · TB4 edge↔Django · TB5 settings module↔app · TB6 template↔generated project ·
  TB7 a future edit↔the gate)

Its trust boundaries and severities are adopted here unchanged.

## 4. OWASP Top 10 — baseline coverage

| ID       | Category                              | Status      | Notes (open findings, controls relied on)                                                                                                                                    |
| -------- | ------------------------------------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | **Partial** | The dominant category. TM-01 is the threat the story closes; TM-02, TM-07 and TM-08 are the places the closure does not reach. All addressed by Section 7                    |
| A02:2025 | Security Misconfiguration             | Partial     | TM-03, TM-08, TM-09 — a merge that mis-configures silently, a gate narrower than its rule, and a register that will say twelve when the answer is fifteen                    |
| A03:2025 | Software Supply Chain Failures        | **Partial** | **TM-15 — a design-time version key can name a release that ships without the doctrine, and then never fires for the projects which need it.** TM-14 and TM-06 also sit here |
| A04:2025 | Cryptographic Failures                | N/A         | No secret, key or credential is read, written or compared. `SECRET_KEY` and the encryption pipeline are untouched                                                            |
| A05:2025 | Injection                             | N/A         | No query, template expression or user-supplied value is introduced. The two cookie names are literals                                                                        |
| A06:2025 | Insecure Design                       | Addressed   | The doctrine was argued to a decision on the map's cookie spine (N-004 to N-008) with `CSRF_USE_SESSIONS` weighed and rejected for a stated reason. No finding               |
| A07:2025 | Authentication Failures               | Partial     | TM-05 — the prefix needs a TLS response, and `SECURE_SSL_REDIRECT` trusts a forwarded header to give one. Not introduced here; now depended upon                             |
| A08:2025 | Software and Data Integrity Failures  | N/A         | Nothing is imported, unsigned or unvalidated by this change                                                                                                                  |
| A09:2025 | Security Logging & Alerting Failures  | **Open**    | TM-13 — a browser discards a malformed prefixed cookie in silence. Accepted residual: the audit trail covers the application, not the browser's storage decision             |
| A10:2025 | Mishandling of Exceptional Conditions | Partial     | TM-04, TM-10, TM-11, TM-12 — the failure paths this change creates are all quiet ones: a suppressed advisory, a logout with no notice, a name-match that rots                |

<!-- AMENDED 28/09/2026, at the gate-10 sign-off. Two notes were overtaken, and read as follows
     until then. A03: "**TM-15 — the advisory is keyed to a release that has already shipped
     without the doctrine, so it never fires for the projects that need it.** TM-14 and TM-06 also
     sit here". 7.6.0 has not shipped: there is no v7.6.0 tag and main reads 7.5.0 (re-checked
     28/09/2026). ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026 writes no v7.6.0 key and records
     the damage as prospective. A07: "TM-05 — the prefix rests on `Secure`, `Secure` rests on a
     forwarded header. Not introduced here; now depended upon". Django emits `Secure` from the
     setting, and the header reaches the cookie only through `SECURE_SSL_REDIRECT`. Corrected per
     ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026. -->

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                                  |
| --- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | **Strong, and improved by this story.** Five documents state cookie scope today and two of them mandate the opposite of the settled rule; after this, one owns it     |
| ID  | Identify | Strong. Seven boundaries named, the doctrine's two published limits carried into the guide, and a third (TM-06) added rather than left to be discovered               |
| PR  | Protect  | The story's subject, and **Partial** until Section 7 lands. TM-01 is closed outright; TM-02, TM-05 and TM-08 are the edges the closure does not reach                 |
| DE  | Detect   | **Weak.** The gate detects a settings regression and nothing detects a browser rejection (TM-13) or a runtime assignment the clause cannot anchor on (TM-08)          |
| RS  | Respond  | **Weakest function.** There is no response path: a rejected cookie produces an anonymous request, not an error, so the first signal is a user saying "I can't log in" |
| RC  | Recover  | **Open until TM-10 lands.** Rollback restores the plain names and invalidates every session again — the reverse of the deploy costs the same, and nothing says so     |

## 6. Findings

Grouped by severity. All fifteen are carried from the threat model unchanged; see it for the
full mitigation text and the promotion triggers.

| ID    | STRIDE | OWASP | NIST  | TB  | Threat Description                                                                  | Severity | Planned Mitigation                                                |
| ----- | ------ | ----- | ----- | --- | ----------------------------------------------------------------------------------- | -------- | ----------------------------------------------------------------- |
| TM-01 | S      | A01   | PR.AA | TB2 | A subdomain plants a session cookie the apex accepts                                | MEDIUM   | The `__Host-` prefix — the story's own deliverable (Section 7.1)  |
| TM-02 | E      | A01   | PR.AA | TB5 | A deployed module the prefix and the gate never reach                               | MEDIUM   | Rule stated per-module; gate names what it read (Section 7.2)     |
| TM-03 | T      | A02   | RC.RP | TB6 | A merge leaves `Domain` beside `__Host-`; every login fails                         | MEDIUM   | The unversioned advisory, via the repaired preview (Section 7.11) |
| TM-04 | D      | A10   | DE.CM | TB6 | The advisory is invisible in the preview that informs the decision                  | MEDIUM   | The preview is repaired inside US008 (Section 7.11)               |
| TM-05 | S      | A07   | PR.AA | TB4 | `SECURE_SSL_REDIRECT` trusts a client-suppliable header                             | MEDIUM   | A stated precondition and an edge strip clause (Section 7.5)      |
| TM-08 | T      | A02   | DE.CM | TB7 | The gate reads a directory; the rule is global                                      | MEDIUM   | The guide states the gate's reach (Section 7.7)                   |
| TM-10 | D      | A10   | RC.RP | TB1 | Rollback invalidates every session a second time                                    | MEDIUM   | The advisory names both directions (Section 7.9)                  |
| TM-11 | D      | A10   | PR.PS | TB1 | A rolling deploy serves both cookie names at once                                   | MEDIUM   | The advisory names the cutover shape (Section 7.9)                |
| TM-15 | T      | A03   | PR.PS | TB6 | A design-time migration key may name a release without the doctrine                 | MEDIUM   | Unversioned state gate; key derived at release (Section 7.13)     |
| TM-06 | I      | A03   | PR.DS | TB3 | `HttpOnly` does not defend the token against XSS                                    | LOW      | Named as a limit in the owner guide (Section 7.6)                 |
| TM-07 | T      | A01   | PR.DS | TB2 | `messages` and language cookies stay unprefixed                                     | LOW      | Residual, scoped and named (Section 7.6)                          |
| TM-09 | T      | A02   | DE.CM | TB7 | `code/src/scripts/audits/CONTEXT.md:174` will say twelve when the answer is fifteen | LOW      | Named cost of Q3; recorded, not silently carried (Section 7.10)   |
| TM-12 | D      | A10   | PR.PS | TB5 | Dev and production differ by cookie name; literal matches rot                       | LOW      | Warning owed to this tree too, not only to updaters (Section 7.8) |
| TM-13 | R      | A09   | DE.AE | TB1 | A browser discards a malformed prefixed cookie in silence                           | INFO     | Accepted residual, named rather than assumed                      |
| TM-14 | E      | A03   | PR.PS | TB6 | Two entries on a `--trust` surface, one run on every update                         | INFO     | Pre-existing boundary, counted rather than assumed static         |

<!-- AMENDED 28/09/2026, at the gate-10 sign-off. Six rows were overtaken by an Accepted record of
     17/09/2026 or by a re-measurement, as in the threat model's Section 3 table, and read as
     follows until then. The originals wrote each constraint reference with the section sign,
     which `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2 bans; it is written
     "Section" below. On 30/09/2026 every constraint reference in the table took that form, the
     unrewritten rows included — a writing-convention fix that moves no finding or mitigation.
     TM-03 mitigation: "The advisory — conditional on Section 7.11". TM-04 mitigation: "A second
     channel the operator sees (Section 7.11)". ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026
     repairs the preview inside US008, and ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026 splits
     the advisory into two entries.
     TM-05 description: "`Secure` is inferred from a client-suppliable header". TM-05 mitigation:
     "Stated as a precondition of the doctrine (Section 7.5)". The mechanism was wrong, and the edge
     clause was added. Corrected per ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.
     TM-09 description: "`audits/CONTEXT.md:170` will say twelve when the answer is fifteen". The
     register row is at :174, as the threat model's TM-09 comment records.
     TM-14 description: "An eighth entry on a `--trust` execution surface". Two scripts join, and
     one of them runs on every update.
     TM-15 description: "The migration key names a release that shipped without the doctrine".
     TM-15 mitigation: "Key the release the doctrine ships in, and tag it (Section 7.13)". 7.6.0
     has not shipped, and the key is now derived at release beside an unversioned state gate, per
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026. -->

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — see Section 1 for its reason and the
threat model's Section 3a for what promotes it.

## 7. Security tasks & open gaps

Thirteen constraints, each checkable by reading the shipped settings, the gate and the advisory.
Each becomes a US008 acceptance criterion; the implementation assessment closes it with evidence.

<!-- AMENDED 28/09/2026: read "Eleven constraints" until then. The list below runs 7.1 to 7.13, and
     the paragraph after it already said "None of the thirteen". -->

- [ ] **7.1** Every module assigning a `__Host-` name satisfies the prefix's three preconditions
      **in that same module** — `SESSION_COOKIE_SECURE = True`, `CSRF_COOKIE_SECURE = True`, `Path`
      left at Django's `/`, no `Domain` — proven by the gate's presence and absence clauses, never
      by a read (A01, TM-01)
- [ ] **7.2** The doctrine is stated as binding **every module that serves TLS**, not only the two
      that exist today; each presence clause **names the modules it read** in its skip note, so a
      third deployed module is visible as unchecked rather than invisible (A01, TM-02)
- [ ] **7.3** No module under `code/src/django/config/settings/` assigns `SESSION_COOKIE_DOMAIN`,
      `CSRF_COOKIE_DOMAIN`, or a `SESSION_COOKIE_PATH` / `CSRF_COOKIE_PATH` other than `/`;
      every gate match is **assignment-anchored at line start**, so a comment is neither a finding
      nor a pass (A02)
- [ ] **7.4** `negative-space.sh:92` and `:481` move **together**, and each clause **skips with a
      note** when its module is absent — an absent surface reported as such, never an absent tool
      reported as clean (A02, `code/docs/GATE-REPORTING.md`)
- [ ] **7.5** `SECURE_PROXY_SSL_HEADER` is stated in the owner guide as a **precondition of the
      doctrine**. The prefix requires the cookie to be set over a secure connection. Django emits
      `Secure` from the setting, but `SECURE_SSL_REDIRECT` reads `request.is_secure()`, which
      `X-Forwarded-Proto` drives. A request that reaches Django by a path skipping the edge, while
      carrying a client-supplied `X-Forwarded-Proto: https`, therefore skips the redirect, and the
      prefixed cookie is served over HTTP and discarded. US008 adds a clause to
      `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 requiring the edge to strip
      any client-supplied `X-Forwarded-Proto` and set it itself (A07, TM-05)
- [ ] **7.6** The owner guide carries **three** limits, not two — the prefix is per cookie name
      (so `messages` and any language cookie stay unprefixed); a pre-prefix browser accepts a
      prefixed cookie unconditionally; and `CSRF_COOKIE_HTTPONLY` does **not** defend the token
      against XSS, because `{% csrf_token %}` and `hx-headers` put it in the DOM (A03, TM-06/TM-07)
- [ ] **7.7** The owner guide states **what the gate can and cannot see** — a directory scan
      cannot observe a runtime `django.conf.settings` assignment or an environment-driven override
      — so a green run is not read as proof of the global rule (A02, TM-08)
- [ ] **7.8** The cookie-name divergence between dev and the TLS environments is stated **in the
      owner guide**, which every project reads, and not only in the advisory, which only an
      updating project runs (A10, TM-12)
- [ ] **7.9** The advisory names the deploy consequences the operator owns: the rename invalidates
      every live session and in-flight CSRF token, **a rollback does the same again**, and the
      cutover cannot be rolling without logging users out repeatedly (A10, TM-10/TM-11)
- [ ] **7.10** The three clauses carry **no silencing annotation**
      (`code/src/scripts/audits/CONTEXT.md:174`), and the register's under-count is recorded as the
      named cost of Q3 rather than left to be found (A02, TM-09)
- [ ] **7.11** **The advisory reaches its operator.** TM-03's only mitigation is an advisory the
      story's own Q11 row records as invisible in `template-update.sh`'s successful preview. The
      blindness is repaired inside US008, and a successful preview is proved to show the advisory.
      **Shipping TM-03's mitigation into a suppressed channel is a false green**
      (`code/docs/GATE-REPORTING.md`) and this is the constraint that stops it (A10, TM-03/TM-04)
- [ ] **7.12** The advisory prints file paths, line numbers and setting names — **never a value**
      from the project it inspects (A01, on the US006 7.11 shape)

- [ ] **7.13** **The advisory ships as two `_migrations:` entries, and the keyed one names the
      release the doctrine actually ships in, tagged in the same act.** The always-wrong state —
      any `SESSION_COOKIE_DOMAIN` or `CSRF_COOKIE_DOMAIN` still assigned in a settings module —
      rides the unversioned, state-gated `cookie-domain-conflict.sh`. It runs on every update and
      reports file, line and setting name, never a value (7.12), so no key can strand a project
      still carrying the old `SESSION_COOKIE_DOMAIN` mandate. The one-time cutover notice (7.9)
      rides the keyed `v<RELEASE>-host-only-cookies.sh`, whose key is derived against `git tag` at
      the moment of release rather than carried from design time. `VERSION` reached 7.6.0 on
      14/09/2026 without this doctrine and no `v7.6.0` tag exists, so a key written before its own
      tag can name a release that ships without the doctrine. Copier's
      `from_template.version < current <= self.version` predicate then skips the entry for the
      projects that need it. `copier.yml:931-934` states the rule and records the template breaking
      it once already (A03, TM-15)

<!-- AMENDED 28/09/2026. 7.5 read "the prefix requires `Secure`, `Secure` is inferred from
     `X-Forwarded-Proto`, and a request path that does not traverse the edge breaks the chain" until
     then, and it had no edge-contract clause. 7.10 cited "`audits/CONTEXT.md:170`". 7.11 read
     "Either the blindness is repaired, or the doctrine gets a second channel a `--preview` operator
     sees." These were corrected per ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026 and
     ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026. -->

<!-- AMENDED 28/09/2026. 7.13 read as follows until then: "**The `_migrations:` key names the
     release the doctrine actually ships in, and that release is tagged.** Re-derive it at
     implementation rather than carrying `v7.6.0` from 09/09/2026: `VERSION` reached 7.6.0 on
     14/09/2026 without this doctrine, no `v7.6.0` tag exists, and copier's
     `from_template.version < current <= self.version` predicate then skips the entry for every
     project generated at or updated to 7.6.0 — the projects still carrying the old
     `SESSION_COOKIE_DOMAIN` mandate." Its rule stands under
     ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026. It described the superseded single entry,
     though, which left no constraint naming the unversioned `cookie-domain-conflict.sh`. It also
     said "at implementation" where the record says against `git tag` at the moment of release. -->

<!-- AMENDED 30/09/2026: 7.13 cited `copier.yml:929-932` until then, which located the v6.0.0
     entry's note at a18db0b. The 18-TESTS split, committed with this correction, adds two lines to
     `_exclude` above it and moves the note to :931-934; the text is unchanged. -->

**None of the thirteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. They are
design-stage constraints that must land with the code, and the implementation assessment is where
each is closed with evidence. **7.11 and 7.13 were the two to read first.** 7.11 changed the
story's scope rather than its text: US008 took the preview repair, and has held at a wide 8 SP
since 17/09/2026. 7.13 superseded an ADR the story rested on.

<!-- AMENDED 28/09/2026: read "7.11 and 7.13 are the two to read first: 7.11 may require the story's
     scope to change rather than its text, and 7.13 invalidates an ADR the story already rests on"
     until then. Both happened at `15-decisions` on 17/09/2026. -->

## 8. What this assessment could not settle

<!-- SETTLED 17/09/2026 at `15-decisions`, and marked 28/09/2026 at the gate-10 sign-off. The
     questions are kept as written, each answered where it is asked, on the precedent of the threat
     model's Section 4a. A question deleted once answered leaves the next reader unable to see what
     was weighed. -->

**All five are settled.** `15-decisions` settled them on 17/09/2026, three through Accepted
records and two as US008 acceptance criteria, and each is named against its question below.

The grilling pass did not run at this gate. Five questions were genuinely open, and each changed a
criterion:

1. **Does 7.11 widen the story?** Repairing the preview blindness is a `GAPS.md` row the story
   deliberately declined (Q11). If the repair is in scope, the story grows; if it is not, the
   second channel has to be something else, and what it is has not been decided. **Settled
   17/09/2026: it widens the story.** US008 repairs the preview and holds at a wide 8 SP, by
   `project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`.
2. **Is `SECURE_PROXY_SSL_HEADER` a stated precondition or an assumed one?** (7.5) **Settled
   17/09/2026: a stated one**, by
   `project-management/src/15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md`.
   US008 states it in the owner guide and adds a strip-and-set clause to
   `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6. Neither carries it yet
   (measured 28/09/2026, and again 30/09/2026).
3. **What does a green `negative-space.sh` claim?** (7.7) **Settled 17/09/2026 as acceptance
   criteria.** It claims only the settings directory, and each clause names what it read:
   `project-management/src/02-STORIES/US008.md:924-934` (AC-GAP-4, AC-GAP-5).
4. **What cutover shape does the rename require, and who owns the decision?** (7.9) **Settled
   17/09/2026 as acceptance criteria.** The cutover cannot be a rolling deploy, a rollback
   invalidates a second time, and the timing is the operator's decision. The keyed advisory names
   all three: `project-management/src/02-STORIES/US008.md:758-767` and
   `project-management/src/02-STORIES/US008.md:1003-1008` (AC-GAP-8).
5. **Which release carries the doctrine, and does `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`
   get amended or superseded?** (7.13) The ADR's own evidence — "72 tags including the minors
   `v7.1.0` to `v7.5.0`" — no longer supports its conclusion, and this gate cannot rewrite an ADR.
   **Settled 17/09/2026: superseded, not amended**, by
   `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`. The
   release is whichever minor carries the doctrine, and its key is derived at release against
   `git tag`.

Recorded here rather than resolved, because a gate that invents an answer to a question it never
asked is worse than one that says it did not ask.

<!-- AMENDED 28/09/2026: the opening read "The grilling pass did not run. Five questions are
     genuinely open and each changes a criterion:" until then. -->

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` — the STRIDE model this assessment synthesises
- `project-management/src/10-SECURITY/AUDITS/PLANNING/` · `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — the sibling code audit and the escalated findings; this story writes to neither, and Section 6 states why
- `project-management/src/02-STORIES/US008.md` — the story being assessed
- `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` — the QA plan that exercises these constraints
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10 (2025), and NIST CSF 2.0 standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` · `code/docs/NEGATIVE-SPACE.md` — the code-side enforcement these targets must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the zero in Section 6, the missing grilling pass, and Section 8 are stated rather than left implied
