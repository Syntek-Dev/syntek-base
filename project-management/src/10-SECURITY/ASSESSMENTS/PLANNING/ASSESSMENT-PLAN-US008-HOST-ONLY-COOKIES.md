# Security Posture Assessment (Plan) — US008 Host-only cookies under `__Host-` names

| Field          | Value                                                                                                          |
| -------------- | -------------------------------------------------------------------------------------------------------------- |
| **Story**      | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule |
| **Date**       | 17/09/2026                                                                                                     |
| **Author**     | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                              |
| **Sprint**     | SPRINT-05 — this story is its `Must`, 8 of 11 SP                                                               |
| **Status**     | Draft                                                                                                          |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                                       |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

<!-- STEP 1's GRILLING PASS DID NOT RUN. <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10
     and 11 be written for both SPRINT-05 members first and the decisions taken afterwards. This
     baseline therefore reports what was measured in the tree on 17/09/2026 and names, in Section
     8, the five questions it could not settle. Status is Draft. code/docs/GATE-REPORTING.md. -->

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
promotes each finding and **five promote to `HIGH`**. Per `code/docs/GATE-REPORTING.md` this is
not reported as "the security gate passed".

**Risk concentrates in delivery, not in the doctrine.** The three settings assignments are correct
and the gate that guards them is well-shaped. What is weak is everything between this template and
a project that already deployed under the opposite rule: a `copier update` merge that produces a
cookie no browser will store (TM-03), whose only warning is printed into a log the preview does not
show (TM-04). Those two are one control with a suppressed output — and the story knowingly accepts
the suppression as a `GAPS.md` row. **That pairing is this assessment's principal finding**, and
Section 7.11 is where it is closed.

**And the delivery has a second defect that only appeared after the story was written.** The
advisory is keyed `v7.6.0` — but `VERSION` was bumped to 7.6.0 on 14/09/2026 by unrelated work,
there is no `v7.6.0` tag, and copier's `from_template.version < current` predicate therefore skips
the entry for exactly the projects carrying the old `Domain` mandate (TM-15, threat model Section
3b). `copier.yml:929-932` already records this template mis-keying a migration once before and
stranding every project that updated in between. **This is the one finding that changes what the
story ships rather than what it says**, and it is `15-decisions`' first piece of input because the
artefact that has to move is an ADR.

**Two further weaknesses are inherited rather than introduced, and are named rather than assumed
away.** `SECURE_PROXY_SSL_HEADER` (`staging.py:19`, `production.py:19`) makes `Secure` — and so
the prefix — depend on a header an unshielded request path could supply (TM-05); and the gate
reads a directory while the rule is global (TM-08). Neither is US008's defect. Both become
US008's dependency the moment the doctrine leans on them.

## 2. Scope

| Dimension  | Coverage                                                                                                                                                                     |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US008 — host-only cookies, `__Host-` names, CSRF `HttpOnly`, one owning guide, three gate clauses                                                                            |
| User flow  | **None** — the story adds no screen, route or journey; `05-USER-FLOW/` has nothing to reference                                                                              |
| Wireframe  | **None**, and none is possible — the surface is configuration, a shell audit and Markdown                                                                                    |
| Schema     | **None** — no model, no migration, no PII. The DB and GDPR flags both read `N/A`                                                                                             |
| Decisions  | `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026` · `ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026` · `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026` (binding, unamended) |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                  |

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
| A03:2025 | Software Supply Chain Failures        | **Partial** | **TM-15 — the advisory is keyed to a release that has already shipped without the doctrine, so it never fires for the projects that need it.** TM-14 and TM-06 also sit here |
| A04:2025 | Cryptographic Failures                | N/A         | No secret, key or credential is read, written or compared. `SECRET_KEY` and the encryption pipeline are untouched                                                            |
| A05:2025 | Injection                             | N/A         | No query, template expression or user-supplied value is introduced. The two cookie names are literals                                                                        |
| A06:2025 | Insecure Design                       | Addressed   | The doctrine was argued to a decision on the map's cookie spine (N-004 to N-008) with `CSRF_USE_SESSIONS` weighed and rejected for a stated reason. No finding               |
| A07:2025 | Authentication Failures               | Partial     | TM-05 — the prefix rests on `Secure`, `Secure` rests on a forwarded header. Not introduced here; now depended upon                                                           |
| A08:2025 | Software and Data Integrity Failures  | N/A         | Nothing is imported, unsigned or unvalidated by this change                                                                                                                  |
| A09:2025 | Security Logging & Alerting Failures  | **Open**    | TM-13 — a browser discards a malformed prefixed cookie in silence. Accepted residual: the audit trail covers the application, not the browser's storage decision             |
| A10:2025 | Mishandling of Exceptional Conditions | Partial     | TM-04, TM-10, TM-11, TM-12 — the failure paths this change creates are all quiet ones: a suppressed advisory, a logout with no notice, a name-match that rots                |

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

| ID    | STRIDE | OWASP | NIST  | TB  | Threat Description                                                  | Severity | Planned Mitigation                                         |
| ----- | ------ | ----- | ----- | --- | ------------------------------------------------------------------- | -------- | ---------------------------------------------------------- |
| TM-01 | S      | A01   | PR.AA | TB2 | A subdomain plants a session cookie the apex accepts                | MEDIUM   | The `__Host-` prefix — the story's own deliverable (§7.1)  |
| TM-02 | E      | A01   | PR.AA | TB5 | A deployed module the prefix and the gate never reach               | MEDIUM   | Rule stated per-module; gate names what it read (§7.2)     |
| TM-03 | T      | A02   | RC.RP | TB6 | A merge leaves `Domain` beside `__Host-`; every login fails         | MEDIUM   | The advisory — conditional on §7.11                        |
| TM-04 | D      | A10   | DE.CM | TB6 | The advisory is invisible in the preview that informs the decision  | MEDIUM   | A second channel the operator sees (§7.11)                 |
| TM-05 | S      | A07   | PR.AA | TB4 | `Secure` is inferred from a client-suppliable header                | MEDIUM   | Stated as a precondition of the doctrine (§7.5)            |
| TM-08 | T      | A02   | DE.CM | TB7 | The gate reads a directory; the rule is global                      | MEDIUM   | The guide states the gate's reach (§7.7)                   |
| TM-10 | D      | A10   | RC.RP | TB1 | Rollback invalidates every session a second time                    | MEDIUM   | The advisory names both directions (§7.9)                  |
| TM-11 | D      | A10   | PR.PS | TB1 | A rolling deploy serves both cookie names at once                   | MEDIUM   | The advisory names the cutover shape (§7.9)                |
| TM-15 | T      | A03   | PR.PS | TB6 | The migration key names a release that shipped without the doctrine | MEDIUM   | Key the release the doctrine ships in, and tag it (§7.13)  |
| TM-06 | I      | A03   | PR.DS | TB3 | `HttpOnly` does not defend the token against XSS                    | LOW      | Named as a limit in the owner guide (§7.6)                 |
| TM-07 | T      | A01   | PR.DS | TB2 | `messages` and language cookies stay unprefixed                     | LOW      | Residual, scoped and named (§7.6)                          |
| TM-09 | T      | A02   | DE.CM | TB7 | `audits/CONTEXT.md:170` will say twelve when the answer is fifteen  | LOW      | Named cost of Q3; recorded, not silently carried (§7.10)   |
| TM-12 | D      | A10   | PR.PS | TB5 | Dev and production differ by cookie name; literal matches rot       | LOW      | Warning owed to this tree too, not only to updaters (§7.8) |
| TM-13 | R      | A09   | DE.AE | TB1 | A browser discards a malformed prefixed cookie in silence           | INFO     | Accepted residual, named rather than assumed               |
| TM-14 | E      | A03   | PR.PS | TB6 | An eighth entry on a `--trust` execution surface                    | INFO     | Pre-existing boundary, counted rather than assumed static  |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — see Section 1 for its reason and the
threat model's Section 3a for what promotes it.

## 7. Security tasks & open gaps

Eleven constraints, each checkable by reading the shipped settings, the gate and the advisory.
Each becomes a US008 acceptance criterion; the implementation assessment closes it with evidence.

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
      doctrine**: the prefix requires `Secure`, `Secure` is inferred from `X-Forwarded-Proto`, and
      a request path that does not traverse the edge breaks the chain (A07, TM-05)
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
- [ ] **7.10** The three clauses carry **no silencing annotation** (`audits/CONTEXT.md:170`), and
      the register's under-count is recorded as the named cost of Q3 rather than left to be found
      (A02, TM-09)
- [ ] **7.11** **The advisory reaches its operator.** TM-03's only mitigation is an advisory the
      story's own Q11 row records as invisible in `template-update.sh`'s successful preview. Either
      the blindness is repaired, or the doctrine gets a second channel a `--preview` operator sees.
      **Shipping TM-03's mitigation into a suppressed channel is a false green**
      (`code/docs/GATE-REPORTING.md`) and this is the constraint that stops it (A10, TM-03/TM-04)
- [ ] **7.12** The advisory prints file paths, line numbers and setting names — **never a value**
      from the project it inspects (A01, on the US006 7.11 shape)

- [ ] **7.13** **The `_migrations:` key names the release the doctrine actually ships in, and that
      release is tagged.** Re-derive it at implementation rather than carrying `v7.6.0` from
      09/09/2026: `VERSION` reached 7.6.0 on 14/09/2026 without this doctrine, no `v7.6.0` tag
      exists, and copier's `from_template.version < current <= self.version` predicate then skips
      the entry for every project generated at or updated to 7.6.0 — the projects still carrying
      the old `SESSION_COOKIE_DOMAIN` mandate. `copier.yml:929-932` states this rule and records
      the template breaking it once already (A03, TM-15)

**None of the thirteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. They are
design-stage constraints that must land with the code, and the implementation assessment is where
each is closed with evidence. **7.11 and 7.13 are the two to read first**: 7.11 may require the story's
scope to change rather than its text, and 7.13 invalidates an ADR the story already rests on.

## 8. What this assessment could not settle

The grilling pass did not run. Five questions are genuinely open and each changes a criterion:

1. **Does 7.11 widen the story?** Repairing the preview blindness is a `GAPS.md` row the story
   deliberately declined (Q11). If the repair is in scope, the story grows; if it is not, the
   second channel has to be something else, and what it is has not been decided.
2. **Is `SECURE_PROXY_SSL_HEADER` a stated precondition or an assumed one?** (7.5)
3. **What does a green `negative-space.sh` claim?** (7.7)
4. **What cutover shape does the rename require, and who owns the decision?** (7.9)
5. **Which release carries the doctrine, and does `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`
   get amended or superseded?** (7.13) The ADR's own evidence — "72 tags including the minors
   `v7.1.0` to `v7.5.0`" — no longer supports its conclusion, and this gate cannot rewrite an ADR.

Recorded here rather than resolved, because a gate that invents an answer to a question it never
asked is worse than one that says it did not ask.

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
