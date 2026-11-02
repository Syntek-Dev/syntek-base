# ADR-US008: The `__Host-` doctrine has an edge precondition, and it is written into the deployment contract rather than assumed

**Status:** Accepted
**Date:** 17/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US008 · `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` AC-GAP-3 · `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` TM-05 · `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6

---

## Context

**US008 enumerated the line that its whole doctrine depends on and did not notice it was a
dependency.** The first scenario's Given lists `code/src/django/config/settings/staging.py:9-22` and
`production.py:9-22` line by line, and `SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO",
"https")` is at `:19` of both, directly above the `SECURE_SSL_REDIRECT`, `SESSION_COOKIE_SECURE` and
`CSRF_COOKIE_SECURE` assignments it makes safe. The story reads it as context. It is a precondition.

**The mechanism has to be stated correctly, because the gate that raised it stated it wrongly.**
`QA-PLAN-US008` AC-GAP-3 says Django _"decides `Secure` from `request.is_secure()`, which that header
drives."_ **It does not.** Read in this tree's own dependency set on 17/09/2026, Django 6.1.0:

| Source                                     | What it does                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------------ |
| `django/contrib/sessions/middleware.py:74` | `secure=settings.SESSION_COOKIE_SECURE or None`                                |
| `django/middleware/csrf.py:264`            | `secure=settings.CSRF_COOKIE_SECURE`                                           |
| `django/middleware/security.py:15`, `:25`  | `self.redirect = settings.SECURE_SSL_REDIRECT` … `and not request.is_secure()` |

Both cookie flags come from the **setting**, statically, whatever the request scheme was. So the
story's criterion — assert `SESSION_COOKIE_SECURE = True` is present in the module — does prove the
`Secure` attribute is emitted, and AC-GAP-3's stated chain is wrong.

**The dependency is real, and it runs through the redirect instead.** `SecurityMiddleware` reads
`request.is_secure()` at `security.py:25` to decide whether to redirect, and `is_secure()` is what
`SECURE_PROXY_SSL_HEADER` drives. The chain that actually breaks:

1. A request reaches Django over plain HTTP by a path that does not pass the edge — a misrouted
   container port, a health-check origin, an internal load balancer, a future surface nobody has
   drawn yet — carrying a client-supplied `X-Forwarded-Proto: https`.
2. `request.is_secure()` returns `True`. `SECURE_SSL_REDIRECT` does **not** fire. The response is
   served over plain HTTP.
3. Django emits `Set-Cookie: __Host-sessionid=…; Secure; Path=/` over that non-secure connection.
4. **The browser discards it.** The `__Host-` prefix requires the cookie to have been set over a
   secure connection, by its own definition — the same rule N-005 confirmed at spec level for the
   `Domain` case. No error, no header, no log. The request arrives anonymous.

That is the identical observable failure as the merge hazard TM-03 describes — a silently discarded
cookie and a login that never completes — reached by a different route. **The difference that
matters is who can cause it.** The merge hazard needs a project to have obeyed the old mandate; this
one needs a request path and a header a client can set.

**Before this story the exposure was ordinary; the story is what makes it load-bearing.** With plain
cookie names a response served over accidental HTTP sets a `Secure` cookie the browser may still
handle inconsistently, and `SECURE_SSL_REDIRECT` failing open is a defect on its own terms. With
`__Host-` names the browser's refusal is unconditional and specified. The doctrine converts a
degraded path into a hard one, and it does so without stating what has to be true for it to hold.

**Nothing in this repository says it.** Measured 17/09/2026: `X-Forwarded-Proto` and
`SECURE_PROXY_SSL_HEADER` appear in exactly two places in the whole tree, `staging.py:19` and
`production.py:19`. `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — the contract the deploy
repository consumes — is silent on it across all 353 lines. Its Section 6, _TLS + trusted-proxy
chain_, is exactly the right shape and covers only the sibling headers: it requires Nginx to set
accurate `X-Forwarded-For` / `X-Real-IP`, and requires `TRUSTED_PROXIES` to name the hop the backend
sees, because _"an empty or wrong value silently degrades per-IP rate-limit keying and audit IP
hashing."_ The same paragraph makes no claim about the scheme header at all.

**And no gate in this repository can see it.** Whether an edge strips a client-supplied header is a
property of the edge, not of this tree. A `negative-space.sh` clause can prove `SECURE_PROXY_SSL_HEADER`
is assigned; it cannot prove the assignment is safe.

## Options considered

### Option A — declare it out of scope and say why the prefix is safe without it

- **Summary:** name the boundary, as US008 already does for `SameSite` and the duplicated settings
  block, and move on.
- **Pros:** honest about scope; consistent with how the story handles its other boundaries; costs
  nothing.
- **Cons:** **there is no defensible completion of the sentence.** The other boundaries are things
  the doctrine does not depend on. This one it does, and a boundary note that cannot say why the
  thing outside it is harmless is a note recording that nobody checked.

### Option B — state it in the owner guide only

- **Summary:** the guide that owns the cookie rule carries the precondition; the deployment contract
  is untouched.
- **Pros:** one file, inside the story's existing surface; the reader of the doctrine learns what it
  rests on.
- **Cons:** the guide is read by whoever is writing Django settings, and the requirement binds
  whoever is configuring Nginx and Cloudflare — different people, different repository. A
  precondition recorded only where it cannot be acted on is a precondition that will not be met.
  `how-to/src/SERVER-ARCHITECTURE/` exists precisely because that seam is real.

### Option C — state it in the owner guide and carry it into the edge contract (the decision)

- **Summary:** the owner guide states the precondition as part of the doctrine; a clause in
  `EDGE-REQUIREMENTS.md` Section 6 requires the edge to strip any client-supplied
  `X-Forwarded-Proto` and set it itself.
- **Pros:** the requirement lands where it can be implemented and where the deploy repository already
  reads its obligations; it joins the sibling headers in the section that already owns the
  trusted-proxy chain; the post-deploy verification section gives it an acceptance check.
- **Cons:** US008 edits a file outside its declared surface, in a story already carrying a second
  subject, and states a requirement against infrastructure that does not exist yet.

### Option D — add a gate clause asserting the settings are correct

- **Summary:** extend `negative-space.sh` to assert `SECURE_PROXY_SSL_HEADER` is assigned wherever
  `__Host-` names are.
- **Pros:** executable, and in the story's existing gate surface.
- **Cons:** **it proves the wrong thing and would read as proving the right one.** The setting is
  already present in both modules; the risk is entirely on the other side of the seam. A green clause
  here is the false green `code/docs/GATE-REPORTING.md` names — a check that ran, passed, and
  measured nothing that was in doubt.

## Decision

**We will take Option C. The doctrine states its precondition, and the requirement that satisfies it
is written into `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 alongside the
sibling headers it already governs.**

The deciding factor is that **`__Host-` is a promise made to a browser, and this repository can only
keep half of it.** The half it owns — no `Domain`, `Path=/`, the `Secure` attribute emitted — US008
ships and gates. The other half, that the connection the cookie was set over was genuinely secure,
is the edge's, and the only artefact that reaches the edge is the contract. Recording the precondition
in a guide the deploy repository never reads would satisfy the reviewer and not the requirement.

The secondary factor is the precedent already sitting in the section. Section 6 requires
`TRUSTED_PROXIES` to name the exact hop because a wrong value _"silently degrades"_ rate-limit keying
and audit IP hashing. That is the same sentence about a different header with a smaller consequence:
a degraded audit hash against a total authentication failure. The scheme header is the one already
missing from a list it plainly belongs on, and it gets the stronger clause of the two.

**The clause says what to do, not merely what to trust.** The edge must **strip** any
`X-Forwarded-Proto` arriving from a client and set the value itself, and the app must be reachable
only through that edge. Trusting a header that a client can also send is not a configuration choice,
it is the vulnerability, and the contract says so in those terms.

**AC-GAP-3's mechanism is corrected rather than carried.** The QA plan and TM-05 both state that the
cookie's `Secure` attribute comes from `request.is_secure()`. It does not, on Django 6.1.0's own
source as cited above. The finding stands and its severity is unchanged; its chain runs through
`SECURE_SSL_REDIRECT`. **A correct conclusion reached by a wrong mechanism is worth more to fix than
a wrong conclusion**, because the mechanism is what the next reader reuses.

## Consequences

- **Positive:** the doctrine's dependency on the edge is stated once, in the artefact the deploy
  repository consumes, and becomes an acceptance check rather than an assumption.
- **Positive:** the failure mode is now named in the same vocabulary as TM-03 — a silently discarded
  cookie and an anonymous request — so an operator diagnosing a login failure after this doctrine
  lands has two documented causes to check instead of one.
- **Positive:** a mechanism error is caught before it propagates. It was stated in two gate artefacts
  and would have been copied into an acceptance criterion and then into a test.
- **Negative / trade-off:** US008 edits a file outside its declared surface. `how-to/src/SERVER-ARCHITECTURE/`
  is a snapshot regenerated by `scale-planning`, so this clause must survive the next regeneration or
  be re-added — an obligation nothing enforces today.
- **Negative / trade-off:** the requirement is written against infrastructure that does not exist.
  This project's posture is `<%DEPLOYMENT_POSTURE%>` and Section 6's own status reads _"TBD — set per
  deployment."_ The clause is a contract term, not a verified control, and must be reported as such —
  never as "the header is handled".
- **Negative / trade-off:** no gate covers it, and by Option D's reasoning none should. The enforcement
  point is a human reading a contract, which is the weakest kind this project accepts, and it is
  accepted because the alternative is a green check that measures nothing.
- **Follow-on:** US008 carries the `EDGE-REQUIREMENTS.md` Section 6 clause, an entry in that file's
  post-deploy verification section, and the precondition paragraph in the guide that owns the cookie
  rule.
- **Follow-on:** `SECURE_SSL_REDIRECT`'s dependence on the same header is broader than cookies — it
  governs every response the deployable serves. This record scopes itself to the cookie doctrine and
  names that wider exposure rather than closing it; a security-hardening pass over the deployed
  surface owns it, when there is a deployed surface.
- **Follow-on:** `QA-PLAN-US008` AC-GAP-3 and `THREAT-MODEL-PLAN-US008` TM-05 are corrected to the
  mechanism above when the gaps are fed back into the story.
