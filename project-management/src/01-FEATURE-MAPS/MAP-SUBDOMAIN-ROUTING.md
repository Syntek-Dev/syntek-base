# MAP-SUBDOMAIN-ROUTING — which surface answers on which host

**Seeded**: 16/08/2026 · **Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Frontier resolved** — every decision node settled; slices ready for `02-story-creation` (01/09/2026)
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 26

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately: this charts
> **syntek-base's own** doctrine, and a generated project inherits the decided rule rather than
> the argument that produced it. The name matters — a map called `MAP-TEMPLATE-*.md` would match
> the `!*TEMPLATE*` negation and ship.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026: the index relocates rather than gains an
> exception, and slice S-06 there carries it.
>
> **Seeded 16/08/2026, charted 28/08/2026.** The seeding was a deliberate deferral on Sam's call —
> _"chart this as a stub we can properly fill out after the other maps are fully done"_. Charting
> re-measured every recorded claim first, and the section that survived is smaller and different
> from the one seeded; see _What the re-measurement overturned_.

---

## Destination

Every surface a generated project serves has a **decided host** — apex path, dedicated subdomain,
or a service this repo does not serve at all — with the **cookie scope, canonical, robots and
edge obligations that follow from it** stated once, in one named artefact.

**The Destination deliberately does not name a mechanism.** Whether the host is read inside
Django or only at the edge is **N-014**, this map's own largest question, and a destination that
pre-answered it would be asserting the thing charting exists to surface. The seeded wording
required a mechanism _"that survives a misconfigured edge"_, which contradicts a shipped guide —
`code/docs/URL-STRATEGY.md:74-76`, _"No business-logic changes are required — only edge/Nginx host
routing and the URL-construction helpers change."_ That contradiction is now a node, not a premise.
Settled 01/09/2026: **edge-only, with a named revisit trigger** — `:74-76` upheld (_The mechanism_, below).

**Done looks like** one artefact naming every host, what serves it, and what follows from it —
whether or not any application code is touched.

---

## Notes

| Field                    | Value                                                                                                                                                        |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Domain                   | URL and host architecture — the seam between `code/docs/URL-STRATEGY.md` and `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`                           |
| Skills to load           | `backend` · `stack-django` · `security` · `cicd` · `doc-writer` · `seo` · `scale-planning` (the edge contract is one of its two snapshots)                   |
| Standing preferences     | This repo **specifies**, the deploy repo **implements** · a rule ships with a gate (**tested by N-020**) · no new copier token — **enforced, not preferred** |
| Umbrella ADRs            | **None, and none may be authored here** — a dated house rule (`../15-DECISIONS/CLAUDE.md:34-41`, 16/08/2026), **not** a mechanical impossibility. See below  |
| Register entries triaged | **0 closes · 0 blocks · 1 unrelated** — exhaustive; `DEFERRED.md` holds no rows                                                                              |
| Scope confirmed by Sam   | 28/08/2026 — `Q1→3` mechanism not pre-committed · `Q2→1` all shipped hosts are inventory rows · `Q3→3` `SITE_URL` in scope, `API_DOCS_ENABLED` out           |

**The ADR row is corrected, and the correction is somebody else's node.** This map previously read
_"None, and none is possible"_. That is false: `15-DECISIONS/` ships `ADR-000-TEMPLATE.md`, its
folder pair and PM workflow `15-decisions`, and **no gate blocks an ADR file** — `doc-references.sh`
governs _citations_, never existence. What is true is a house rule declining one, dated 16/08/2026.
**`MAP-PROGRESSIVE-ENHANCEMENT` N-026 owns whether that decline stands**; five files in this folder
carry the strong wording and this map does not settle it for them.

---

## Register claimed

**Nothing claimed.** Triaged against the live registers on 28/08/2026, not inherited from seeding.

| Register      | Entry                                              | Verdict       | Retired by                                             |
| ------------- | -------------------------------------------------- | ------------- | ------------------------------------------------------ |
| `GAPS.md`     | SL-1, SL-2, SL-3 — _Standing limitations_          | **exempt**    | Never — accepted properties, not entries               |
| `GAPS.md`     | 22/08/2026 — `main` has never received this branch | **unrelated** | Its own PR merging; the entry says _"Do not chart it"_ |
| `DEFERRED.md` | _(no rows — 17 lines of preamble)_                 | —             | —                                                      |

**This is a claim, not a close.** Nothing here edits either register.

**SL-2's reopen trigger does not fire on this map.** It reopens when a workflow **publishes** an
image to a registry; nothing here publishes anything.

---

## What the re-measurement overturned

Measured 28/08/2026 against the working tree. **The seeded evidence section is voided and
re-derived rather than patched**, because two of its figures were unreproducible and three
citations pointed at the wrong lines — a baseline that cannot be reproduced cannot measure drift,
which is the only thing it was recorded for.

| Seeded claim                                                    | Measured 28/08/2026                                                                                                                                                                                                                                     |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| _"52 files reference `control/`; **34** of those mention both"_ | `52` reproduces **exactly** at the seed commit `a9c56a1` and is **53** today. **`34` reproduces under no reading** — six plausible commands give 39, 47, 35, 28 and 33. Today's ratio is ~91%, so the blast-radius argument is **stronger** than stated |
| `DJANGO_ADMIN_PATH` at `base.py:121`                            | Correct when written; the line is now **`:167`**. `:121` is `WSGI_APPLICATION`                                                                                                                                                                          |
| `TEMPLATE-TOKENS.md:90`, `:326`                                 | Both drifted. The token row is **`:91`**; the `status.` derivation is **`:382`**. `:326` is now the Slint licence paragraph                                                                                                                             |
| _"That same section recommends the shared cookie domain"_       | Two H2s separate them. Phase 2 is `:72`; the cookie mandate is under `## CORS and session scope` (`:145`), and it is a **"must use"**, not a recommendation                                                                                             |
| _"probably the first node"_                                     | The map named **two** competing firsts (`:125-128` and `:207-210`) and chose neither. Settled here by dependency order, not by assertion                                                                                                                |
| Fog: _"Cloudflare Access binds to hostname **and** path"_       | **The premise has zero in-repo support** — discharged as **N-002** below                                                                                                                                                                                |
| _"`ALLOWED_HOSTS` does not cover `/mcp/`"_                      | The **inference is sound**; the citation does not carry it. `MOUNTING.md:108-116` enumerates seven middleware losses and host validation is **not among them** — nothing in `code/docs/` states it                                                      |

---

## Resolved decisions

**Three research nodes, discharged by measurement on 28/08/2026 and adversarially verified — joined 01/09/2026 by the cookie spine, settled by grilling.** The three censuses each
became a table in this map and nothing outside it — the exception the folder's _every resolved node
graduates_ rule allows for a census taken to inform a decision not yet made. **If this map dies,
they die with it**, which is named here so it is chosen rather than discovered.

| Node  | Decision                                                                                                                                                                       | Type     | Settled    | Became                                                         |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | -------------------------------------------------------------- |
| N-001 | The host inventory — what already answers, and on what                                                                                                                         | research | 28/08/2026 | _The measured host inventory_ table below                      |
| N-002 | Whether the Cloudflare Access premise is supported anywhere in-repo                                                                                                            | research | 28/08/2026 | The finding below; **kills a fog item**                        |
| N-003 | Whether host separation exists in dev or test, and survives a worktree                                                                                                         | research | 28/08/2026 | The measurement below; **spawned N-017**                       |
| N-004 | Cookie-scope rule: **never set** `SESSION_COOKIE_DOMAIN` / `CSRF_COOKIE_DOMAIN`; adopt `__Host-` names                                                                         | grilling | 01/09/2026 | _The cookie spine_ below; build lands on the slice N-019 gates |
| N-005 | The subdomain cookie-write premise — **confirmed at spec level**, with two named limits                                                                                        | research | 01/09/2026 | _The cookie spine_ below                                       |
| N-006 | `__Host-` names live **per-environment** — `staging.py`/`production.py`, beside the `SECURE=True` lines they depend on; dev keeps plain names                                  | grilling | 01/09/2026 | _The cookie spine_ below; build lands on the slice N-019 gates |
| N-007 | CSRF token stays a **cookie**, hardened with `CSRF_COOKIE_HTTPONLY = True` — `CSRF_USE_SESSIONS` rejected                                                                      | grilling | 01/09/2026 | _The cookie spine_ below; build lands on the slice N-019 gates |
| N-008 | **`CRYPTO-AND-DATA.md`'s Browser Storage Policy owns cookie-scope doctrine** — `:122-123` respecified to host-only + `__Host-`; `URL-STRATEGY.md` defers                       | grilling | 01/09/2026 | _The cookie spine_ below; build lands on the slice N-019 gates |
| N-019 | Artefact: **`how-to/src/HOSTS.md` register + a `code/docs/` rule section**, shipped **filled** with the five measured host families                                            | grilling | 01/09/2026 | _The artefact shape_ below                                     |
| N-014 | Mechanism: **edge-only, with a named revisit trigger** — `URL-STRATEGY.md:74-76` upheld                                                                                        | grilling | 01/09/2026 | _The mechanism_ below                                          |
| N-016 | Dev/test `ALLOWED_HOSTS` become a **leading-dot allowlist**, leaving `["*"]`                                                                                                   | grilling | 01/09/2026 | _The mechanism_ below                                          |
| N-009 | Surface→host: **apex paths now; hosts are trigger rows** — `admin.`/`portal.` are candidate rows, deliberately undecided                                                       | grilling | 01/09/2026 | _The surface→host rule_ below                                  |
| N-021 | `SITE_URL` stays a **single apex value**; multi-host canonical folds into trigger-row obligations                                                                              | grilling | 01/09/2026 | _The surface→host rule_ below                                  |
| N-024 | `dev-us###.conf`: honour or retract — **specified onto slice S-03** with its acceptance                                                                                        | build    | 01/09/2026 | Slice S-03 row                                                 |
| N-025 | `URL-STRATEGY.md` declared-not-wired banner — **specified onto slice S-04**                                                                                                    | build    | 01/09/2026 | Slice S-04 row                                                 |
| N-026 | `SITE_URL` becomes a real setting, single apex value — **specified onto slice S-04**                                                                                           | build    | 01/09/2026 | Slice S-04 row                                                 |
| N-010 | **Two admin surfaces, split** — `admin.` is the custom admin area (CMS, blog editor, CRM); the developer Django admin stays `/control/`, with `control.` its own candidate row | grilling | 01/09/2026 | _The tail_ below; slices S-01/S-04                             |
| N-011 | **No `api.` host, no candidate row**; the candidate section notes a project may add one for API tooling (Postman or self-hosted)                                               | grilling | 01/09/2026 | _The tail_ below; slice S-01                                   |
| N-012 | `/mcp/` is **always a path, never a subdomain** — a decided rule                                                                                                               | grilling | 01/09/2026 | _The tail_ below; slice S-01                                   |
| N-013 | `ALLOWED_HOSTS` lists **Django-terminating hosts only**; `www` leaves the prod example                                                                                         | grilling | 01/09/2026 | _The tail_ below; slice S-04                                   |
| N-015 | **Closed as mooted by N-014** — edge-only leaves no in-Django host key; register key format is S-01's                                                                          | grilling | 01/09/2026 | _The tail_ below                                               |
| N-017 | Tracer **discharged into the trigger obligations** — nothing host-routed exists in dev to misroute                                                                             | tracer   | 01/09/2026 | _The tail_ below; S-01 row text                                |
| N-018 | The dev nginx **catch-all stands, recorded as deliberate**; a second `server{}` arrives with a fired trigger                                                                   | grilling | 01/09/2026 | _The tail_ below; slice S-03                                   |
| N-020 | The rule **ships with a gate** — `audits/hosts-register.sh`, reconciling both directions                                                                                       | grilling | 01/09/2026 | _The tail_ below; slice S-01                                   |
| N-022 | Robots is a **per-row obligation**; `ROOT-SURFACE.md` stays path-scoped                                                                                                        | grilling | 01/09/2026 | _The tail_ below; slice S-01                                   |
| N-023 | **HSTS extends edge entry 1**, mirroring the app backstop values                                                                                                               | grilling | 01/09/2026 | _The tail_ below; slice S-01                                   |

### N-001 — the measured host inventory

**The map was seeded believing in one worked example. There are five host families already shipped
or contracted, and one of them decides the cookie question.**

| Host                            | Status             | What serves it                                                        | Evidence                                                |
| ------------------------------- | ------------------ | --------------------------------------------------------------------- | ------------------------------------------------------- |
| `<%PRIMARY_DOMAIN%>` (apex)     | Shipped            | Django, all traffic, one CF Tunnel                                    | `.env.prod.example:12` · `EDGE-REQUIREMENTS.md:145-166` |
| `www.<%PRIMARY_DOMAIN%>`        | Shipped            | **Nothing** — a Cloudflare 301 Redirect Rule; it never reaches Django | `EDGE-REQUIREMENTS.md:150-151`, `:161-162`              |
| `staging.<%PRIMARY_DOMAIN%>`    | Shipped 02/08/2026 | Django. **An _environment_ host — a class this map had never named**  | `.env.staging.example:12-13`                            |
| `status.<%PRIMARY_DOMAIN%>`     | Contracted         | Gatus. Must stay **out** of `ALLOWED_HOSTS`                           | `HEALTH-CONTRACT.md` · `EDGE-REQUIREMENTS.md:181-188`   |
| The object-store presign host   | Contracted         | SeaweedFS. **Contractually unauthenticated**                          | `EDGE-REQUIREMENTS.md:211-231`                          |
| `s3.<%PROJECT_SLUG%>.localhost` | Design intent, dev | A dedicated nginx `server_name` → `seaweedfs:8333`                    | `EDGE-REQUIREMENTS.md:219-225`                          |

**The finding that reframes the cookie question.** `EDGE-REQUIREMENTS.md:229-230` contracts the
presign host as deliberately unauthenticated — _"Presigned URLs are self-authorising — the vhost
must not add auth, only TLS and routing."_ A wildcard `SESSION_COOKIE_DOMAIN = ".<%PRIMARY_DOMAIN%>"`
would place the session cookie on a host the edge contract **forbids authenticating**. That is not a
preference between two designs; it is a collision between a proposed setting and a shipped contract.

**`EDGE-REQUIREMENTS.md:164-166` already names two required second hostnames**, not one — the status
page and the object store. The per-host obligation has two worked examples, and the map recorded one.

### N-002 — the Cloudflare Access premise, and its absence

**Searched and absent.** `cloudflare access`, `zero trust`, `cf-access` and `cf_authorization`,
case-insensitive across every `.md`, `.py`, `.sh`, `.yml` and `.conf` in the tree, return **exactly
one hit: this map's own fog item** (plus an unrelated bullet in an MSP policy template). The edge
contract's 14 numbered sections promise **nothing** about Access, at hostname or path level.

**What the edge does promise about gating is one line, and it is header-based, not identity-based:**
_"the CF edge rate rule aligned to `GLOBAL_RATE_LIMIT_MAX`, with admin traffic exempted via the
trusted secret header"_ (`EDGE-REQUIREMENTS.md:160-166`). The only other admin gate named anywhere is
env-var IP allowlisting, explicitly framed as a second control and _"never a replacement"_
(`INPUT-AND-API.md:157-158`).

**Consequence.** The fog item _"whether host separation buys anything the edge cannot already give
path-scoped"_ was resting on a capability this repository has never specified. It is **struck from
fog** and, if anyone wants it, it must first become a contract row — which is `EDGE-REQUIREMENTS.md`'s
job, not this map's.

**A second premise fell with it.** The `control.` recommendation read _"swap obscurity for Access"_,
which assumes the repo currently claims path obscurity as a control. It does not: all ~10
restatements give the same narrow rationale — _"a guessable admin path attracts credential-stuffing
traffic"_ — paired with real controls. **Nothing in this repository argues that the path is, or is
not, a security boundary.** Neither side is available to cite.

### N-003 — host separation in dev and test, measured

- **It exists nowhere.** Both shipped nginx configs are catch-alls (`dev.conf:9`, `test.conf:9`,
  `server_name _;`); there is no `django-hosts`, no `request.urlconf` switch, no host-keyed
  middleware, and **nothing under `code/src/django/apps/` reads `get_host` or `ALLOWED_HOSTS`**.
- **It is not merely absent, it is actively unenforced.** `dev.py:12` sets `ALLOWED_HOSTS = ["*"]`
  and `test.py` the same. Measured live: a request carrying the Host `totally-made-up.example.test`
  returns **HTTP 200**.
- **The worktree hazard is sharper than the map recorded, and different in kind.** Measured:
  `getent ahostsv4 admin.dev-us003.<slug>.localhost` returns **`127.0.0.1`, not `127.0.0.3`** —
  `/etc/hosts` has no wildcard and `hosts-story-add.sh:34` writes exactly two literal names per
  story. Combined with the catch-all and `["*"]`, a host-routed request **silently lands on the main
  dev stack with a 200** rather than failing. Silent misrouting, not a broken worktree.
- **The map's framing was also too narrow.** An exact-string map keyed on production hostnames
  matches nothing in the **main** dev stack either, which answers on `dev.<slug>.localhost:81`. It
  breaks all local development, not only worktrees.
- **`CSRF_TRUSTED_ORIGINS` is already incomplete.** `dev.py:16-20` lists three literals and omits
  every worktree host. Harmless today only because `["*"]` plus same-origin `get_host()` covers it.

### N-004 – N-008 — the cookie spine, settled 01/09/2026

**The rule (N-004, `Q2→1`).** Cookies are host-only: `SESSION_COOKIE_DOMAIN` and
`CSRF_COOKIE_DOMAIN` are never set, and both cookies take `__Host-` prefixed names.
`URL-STRATEGY.md:149-153`'s shared-domain mandate is overturned; its rewrite is build work for the
slice N-019 gates, never this sitting's.

**The CSRF cookie exists (N-007, `Q1→3` — 1 and 3 are security-equivalent; 3 adds doctrine fit).**
`CSRF_USE_SESSIONS` rejected: source-verified, any anonymous page rendering `{% csrf_token %}`
forces a persisted session plus `Vary: Cookie` — wrong for a cached marketing surface. The cookie
ships with `CSRF_COOKIE_HTTPONLY = True`, matching `CRYPTO-AND-DATA.md:108`'s httpOnly
classification; nothing client-side reads it (measured: zero cookie reads anywhere; the doctrine
pattern is template-injected `hx-headers`).

**The evidence (N-005).** RFC 6265bis §4.1.2.3/§8.6 and Django's own sessions and CSRF docs confirm
a subdomain can plant a `Domain=parent` cookie the apex accepts; omitting `Domain` stops it
_reading_, and only a `__Host-` name stops it _writing_ (storage model, §5.7 step 21). Two limits
named: protection is per-cookie-name, and browsers without prefix support accept prefixed cookies
unconditionally. The presign host's "must not add auth" contract (`EDGE-REQUIREMENTS.md:229-230`)
stands as the collision a wildcard domain would have created.

**Charting drift corrected.** The 16/08 recommendation named only `SESSION_COOKIE_DOMAIN`; the
"/ `CSRF_COOKIE_DOMAIN`" expansion entered at charting (`b03b6ab`). The settled rule covers both —
decided here, not inherited.

**The consequences (N-006, `Q3→1` · N-008, `Q4→1`).** The `__Host-` names live **per-environment**
— `staging.py`/`production.py`, beside the `SECURE=True` lines they depend on; dev keeps plain
names, because dev serves `http` with `SESSION_COOKIE_SECURE=False` and the storage model rejects
an insecure `__Host-` cookie. **`CRYPTO-AND-DATA.md`'s Browser Storage Policy is the one owner** of
cookie-scope doctrine: its `:122-123` "explicit `Path` and `Domain`" line is respecified to
host-only + `__Host-`, and `URL-STRATEGY.md` defers to it.

**Deliverables held for slices** (named, never done here): the `URL-STRATEGY.md:149-153` rewrite and
its deferral to the owner; the `CRYPTO-AND-DATA.md:122-123` respecification; the per-environment
`__Host-` names and `CSRF_COOKIE_HTTPONLY = True` settings.

### N-019 — the artefact shape, settled 01/09/2026 (`Q5→1`)

**A `how-to/src/HOSTS.md` register paired with a rule section in `code/docs/`**, on the pattern
three shipped pairs already use (`NEGATIVE-SPACE.md` ↔ `INVARIANTS.md`, `FORWARD-VOICE.md` ↔
`PROJECT-PATHS.md`, the posture rule ↔ `DEPLOYMENT-POSTURE.md`). The template ships the register
**filled with the five measured host families** — apex, `www`, `staging.`, `status.`, the presign
host — because those are shipped contracts, not per-project choices; per-project rows arrive as
surfaces do. Every later node's output now has a home: rule text in the `code/docs/` section,
per-host rows in `HOSTS.md`. **N-020 stays genuinely open** — a `how-to/src/` register has no
`seam-contract.sh` coverage, so the gate question is not answered for free. The fog item _whether
the template should ship a host map at all_ is settled by this shape and struck below.

### N-014 · N-016 — the mechanism, settled 01/09/2026 (`Q6→3` · `Q7→2`)

**Edge-only, with a named revisit trigger (N-014).** Django stays host-agnostic; the edge maps
hosts to path prefixes, and `ALLOWED_HOSTS` is the app's only host awareness.
`URL-STRATEGY.md:74-76` is **upheld**, and the seeded "survives a misconfigured edge" requirement
stays dead. The trigger — **the first surface actually served on a second host revisits in-Django
reading** — ships as a `HOSTS.md` register row, on the deferred-infrastructure pattern
`DATABASE.md` already uses.

**Dev and test leave `["*"]` (N-016).** `ALLOWED_HOSTS` becomes a leading-dot allowlist —
`[".<%PROJECT_SLUG%>.localhost", "localhost", "127.0.0.1"]` — one wildcard entry covering every
worktree host, so a foreign Host fails loudly. **Named limit:** this does not fix N-003's silent
worktree misroute — a wrong-stack worktree host still matches the wildcard; that is **N-017**'s
tracer, now unblocked alongside **N-015**.

### N-009 — the surface→host rule, settled 01/09/2026 (`Q8→1`)

**Apex paths now; hosts are trigger rows.** No surface gets a dedicated host until it actually
ships one. `HOSTS.md` records `admin.` and `portal.` as **candidate rows with named triggers** —
deliberately undecided, not contracted-future — and `URL-STRATEGY.md`'s Phase 2 table becomes the
register's candidate section rather than a plan. The same shape as the mechanism decision: decide
what is shipped, name the trigger for what is not. N-010–N-013, N-021 and N-022 now resolve
against _apex + trigger_ rather than against a committed subdomain plan.

**N-021 (`Q9→1`) follows the same shape.** `SITE_URL` stays a single apex value; any candidate
host that would serve _indexable_ pages names canonical strategy among its trigger obligations
(`admin.`/`portal.` are `noindex` anyway). N-026 becomes a clean build node with a single value.

### The tail — nine decision nodes, settled 01/09/2026 (`Q11–Q20`)

**The candidate section (N-010–N-013, N-022).** Two admin surfaces, split on Sam's amendment to
Q11: **`admin.` is the custom admin area** — CMS, blog editor, CRM — and **the developer Django
admin is a separate surface**, at `/control/` today with `control.` as its own candidate row. No
`api.` host and no candidate row, but the candidate section **notes** a project may add
`api.<domain>` for API tooling (Postman or a self-hosted alternative). **`/mcp/` is always a
path, never a subdomain** — a decided rule, not an open candidate. `ALLOWED_HOSTS` lists only
hosts that terminate at Django — `www` leaves `.env.prod.example` (and its CSRF origin), and the
comment is respecified to say _terminates at Django_, so a misconfigured edge fails loudly.
Robots is a per-row obligation on the same shape as canonical; `ROOT-SURFACE.md` stays
path-scoped and true.

**The dev edge (N-015, N-017, N-018).** N-015 closed as mooted by edge-only — the register key
format belongs to S-01. N-017's tracer discharged: nothing host-routed exists in dev to
misroute, so every candidate row's trigger obligations include _extend `hosts-story-add.sh` and
the worktree compose override for the new name_. The nginx catch-all stands **as a recorded
decision** — the undocumented `3c22efe` removal of named blocks gains its rationale, and a
second `server{}` block arrives only with a fired trigger.

**The contract tail (N-020, N-023).** The rule ships with a gate — `audits/hosts-register.sh`,
reconciling `ALLOWED_HOSTS` and the register in both directions, on the precedent of the two
gated sibling registers (`negative-space.sh`, `doc-references.sh`). The HSTS obligation extends
edge entry 1 (security headers), mirroring the shipped app backstop — max-age one year,
includeSubDomains, preload — so contract and backstop can never disagree.

**Fog graduated with it:** _whether admin/portal SSO is wanted_ is struck — N-004's host-only
rule means two logins by construction; any future SSO is its own feature with its own map.

---

## Slices

**Four slices, cut and confirmed 01/09/2026.** Every open node (13) belongs to exactly one
slice; the remaining decision nodes settle inside the stories that carry them.
`02-story-creation` cuts each `US###` from its row. **Build order: S-02 first** — the only
slice with no open nodes, and S-01's rule section defers to the doctrine S-02 lands.

| Slice | Story | Title                                                                           | Nodes                                             | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | Flags          |
| ----- | ----- | ------------------------------------------------------------------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| S-01  | —     | **The host register and its rule** — `HOSTS.md` + the `code/docs/` rule section | N-013, N-020, N-022, N-023 _(all settled)_        | Register ships filled with the five measured families plus `admin.` (custom admin area), `portal.` and `control.` (developer Django admin) candidate rows with named triggers — each trigger carrying the N-017 worktree obligation — and the `api.` tooling note; the rule section defers cookie scope to `CRYPTO-AND-DATA.md`, states `/mcp/` is always a path, and extends edge entry 1 with the HSTS obligation; every row states its cookie, canonical, robots and edge obligations; `audits/hosts-register.sh` reconciles register and `ALLOWED_HOSTS` both ways | Security · SEO |
| S-02  | —     | **The cookie doctrine lands**                                                   | — _(all settled)_                                 | `URL-STRATEGY.md:149-153` rewritten to defer to the owner; `CRYPTO-AND-DATA.md:122-123` respecified host-only + `__Host-`; the per-environment `__Host-` names and `CSRF_COOKIE_HTTPONLY = True` ship together                                                                                                                                                                                                                                                                                                                                                         | Security       |
| S-03  | —     | **Dev/test host hygiene**                                                       | N-015, N-017, N-018, N-024 _(all settled)_        | The leading-dot `ALLOWED_HOSTS` allowlist lands and a foreign Host fails loudly in dev and test; the nginx catch-all is recorded as deliberate (N-018); `dev-us###.conf` is honoured or retracted (N-024); N-015 closed as mooted, N-017 discharged into the trigger obligations                                                                                                                                                                                                                                                                                       | —              |
| S-04  | —     | **`URL-STRATEGY.md` corrections + `SITE_URL`**                                  | N-010, N-011, N-012, N-025, N-026 _(all settled)_ | The declared-not-wired banner is added; the Phase 2 table is re-cast as the candidate section with the two admin surfaces split — `admin.` the custom admin area, the developer Django admin at `/control/` with `control.` its candidate — the `api.` tooling note and `/mcp/` always-a-path; `SITE_URL` is defined once, a single apex value; `www` leaves `.env.prod.example`'s `ALLOWED_HOSTS` and CSRF origins (N-013)                                                                                                                                            | SEO            |

**Backfilled 01/09/2026** at the first RESOLVE sitting: the `TBD` cells the 31/08 column change
left are filled, and the checklist item _every open node belongs to a slice_ is verified — 13
open nodes, each in exactly one `Nodes` cell.

**This is the one map in this folder where a flag might genuinely fire**, and that is unchanged by
charting. If a surface is routed to its own host, `Security` (cookie scope, host validation, the
`__Host-` prefix) and `SEO` (canonical and robots are per-host resources) both have real entries to
make. The manifests above now carry it: Security on S-01/S-02, SEO on S-01/S-04.

---

## Frontier

**Empty — every decision node settled 01/09/2026.** Sections A–F graduated to _Resolved
decisions_; the takeable edge is now `02-story-creation`, cutting `US###` from the slice rows,
S-02 first.

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**

- **What a client-delegated subdomain actually _is_.** `email.`, `chat.`, `video.` were named as the
  motivating case, but a vendor CNAME, a proxied third-party app and a Django-served surface have
  three different security answers. **The proposal treats them as one class; they are not one.**
  N-005 settles the cookie half only.
- **What the published API surface is made of**, if one is published — a second `NinjaAPI` is
  **banned twice** (`NINJA-CONVENTIONS.md:130`, `AUTH-STRATEGY.md:46-48`), so "publish a filtered
  subset" has no shipped mechanism. Deliberately not a node: `API_DOCS_ENABLED` was ruled **out of
  scope** on 28/08/2026 (`Q3→3`).
- **Whether an environment host is the same class as a surface host.** `staging.` is in the
  inventory now, but nothing has argued whether the two obey one rule or two.
- **Whether host enumeration is a threat this project answers.** `AUTH-AND-AUTHZ.md:93-126` has a
  full anti-enumeration section and it is **entirely about API responses** — nothing about host,
  path or subdomain enumeration.

---

## Out of scope

| Ruled out                                                  | Why                                                                                                                                                                                                       |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Provisioning any tunnel, vhost or DNS record               | This repo specifies and the deploy repo implements — `SERVER-ARCHITECTURE/CLAUDE.md:38`. The output here is a contract row, never a Nix module                                                            |
| `API_DOCS_ENABLED` and whether an API surface is published | **Ruled out 28/08/2026 (`Q3→3`).** It is an API-publication decision, not a host decision, and it only bites if a docs host is chosen. Recorded in fog so it is not silently reopened                     |
| The `status.` host itself                                  | Settled contract since before this map. It enters as a **worked example** of the per-host obligation                                                                                                      |
| Tenant-per-subdomain multi-tenancy                         | A different feature. `SERVICE-AND-MIDDLEWARE.md:214` names tenant resolution from a subdomain; **this map is about surfaces, not tenants**                                                                |
| Building any client-facing host                            | `email.` / `chat.` / `video.` are the motivating case for **not foreclosing** the shape. Building one is its own feature with its own map                                                                 |
| Authoring an ADR for any of it                             | A dated house rule (`../15-DECISIONS/CLAUDE.md:34-41`), **not** an impossibility. Whether the decline stands is `MAP-PROGRESSIVE-ENHANCEMENT` N-026's, not this map's                                     |
| Adopting Cloudflare Access                                 | **N-002 measured it absent from the entire repository.** It is not ruled out on merit — it has never been specified, so it cannot be cited. Making it a control is an `EDGE-REQUIREMENTS.md` change first |

---

## Session log

| Date       | Node settled                                                | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Frontier redrawn |
| ---------- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_                                            | Seeded out of a read-only recommendation pass on Sam's five-subdomain proposal, on his call that it is charted **after the other maps are fully done**. Frontier deliberately empty                                                                                                                                                                                                                                                                                                                                                                      | [ ]              |
| 28/08/2026 | N-001 · N-002 · N-003                                       | **Charted: 26 nodes, 23 open, 6 blocking, 3 discharged by measurement.** The seeded evidence section was **voided and re-derived** — `34` reproduces under no reading, three citations had drifted, and one fog item's premise (Cloudflare Access) is absent from the repository entirely. N-001 found **five** shipped or contracted host families where the map recorded one, and the object-store presign host's _"must not add auth"_ contract makes the cookie question sharper rather than softer. Bounds confirmed by Sam: `Q1→3`, `Q2→1`, `Q3→3` | [x]              |
| 01/09/2026 | N-004 · N-005 · N-007                                       | **The cookie spine settled — first RESOLVE sitting.** Never set `SESSION_COOKIE_DOMAIN`/`CSRF_COOKIE_DOMAIN`; `__Host-` names adopted; the CSRF token stays a cookie with `CSRF_COOKIE_HTTPONLY = True` (`CSRF_USE_SESSIONS` rejected — it forces sessions onto anonymous form pages). N-005 confirmed at spec level with two named limits. Charting drift corrected: the 16/08 rec named only `SESSION_COOKIE_DOMAIN`. Sam: `Q1→3`, `Q2→1`; slices-become-stories confirmed, superseding the no-stories gate line                                       | [x]              |
| 01/09/2026 | N-006 · N-008                                               | **Round 2, same sitting.** `__Host-` names live per-environment (`staging.py`/`production.py`, beside the `SECURE=True` lines they depend on); dev keeps plain names. `CRYPTO-AND-DATA.md`'s Browser Storage Policy named the sole owner of cookie-scope doctrine — `:122-123` respecified to host-only + `__Host-`, `URL-STRATEGY.md` defers. Sam: `Q3→1`, `Q4→1`                                                                                                                                                                                       | [x]              |
| 01/09/2026 | N-019                                                       | **Round 3, same sitting.** Artefact settled: `how-to/src/HOSTS.md` register + `code/docs/` rule section, on the shipped rule↔register pattern; ships **filled** with the five measured host families, per-project rows arrive with surfaces. N-020 unblocked and genuinely open (no `seam-contract.sh` coverage in `how-to/src/`). Fog item _ship a host map at all_ graduated into the decision. Sam: `Q5→1`                                                                                                                                            | [x]              |
| 01/09/2026 | N-014 · N-016                                               | **Round 4, same sitting.** Mechanism: **edge-only with a named revisit trigger** (first surface served on a second host) — `URL-STRATEGY.md:74-76` upheld, the trigger ships as a `HOSTS.md` row. Dev/test `ALLOWED_HOSTS` become the leading-dot allowlist `[".<%PROJECT_SLUG%>.localhost", "localhost", "127.0.0.1"]`; the worktree misroute stays N-017's tracer. N-015 and N-017 unblocked. Sam: `Q6→3`, `Q7→2`                                                                                                                                      | [x]              |
| 01/09/2026 | N-009                                                       | **Round 5, same sitting.** Surface→host settled: **apex paths now; hosts are trigger rows** — `admin.`/`portal.` become candidate rows with named triggers in `HOSTS.md`, the Phase 2 table becomes the register's candidate section. N-010–N-013, N-021, N-022 unblocked. Sam: `Q8→1`                                                                                                                                                                                                                                                                   | [x]              |
| 01/09/2026 | N-021                                                       | **Round 6, same sitting — the blocking frontier empties.** `SITE_URL` stays a single apex value; a candidate host serving indexable pages names canonical strategy among its trigger obligations. N-026 unblocked as a clean build node. Sam: `Q9→1`                                                                                                                                                                                                                                                                                                     | [x]              |
| 01/09/2026 | —                                                           | **Round 7, same sitting — four slices cut and backfilled.** S-01 host register + rule (N-013, N-020, N-022, N-023) · S-02 cookie doctrine (no open nodes, **builds first**) · S-03 dev/test host hygiene (N-015, N-017, N-018, N-024; N-015 flagged possibly mooted by edge-only) · S-04 `URL-STRATEGY.md` corrections + `SITE_URL` (N-010–N-012, N-025, N-026). Every open node assigned; confirmed by Sam                                                                                                                                              | [x]              |
| 01/09/2026 | N-024 · N-025 · N-026                                       | **Build nodes graduated by slice assignment** — a build node resolves when its deliverable and acceptance sit in a slice row (S-03, S-04, S-04). No further outline here; the stories own it                                                                                                                                                                                                                                                                                                                                                             | [x]              |
| 01/09/2026 | N-010–N-013 · N-015 · N-017 · N-018 · N-020 · N-022 · N-023 | **Round 8 — the frontier empties.** Two admin surfaces split on Sam's Q11 amendment (`admin.` custom area; developer Django admin at `/control/` with `control.` candidate); no `api.` host but a tooling note; `/mcp/` always a path; `ALLOWED_HOSTS` Django-terminating only, `www` dropped; robots per-row; N-015 mooted; N-017 discharged into triggers; catch-all recorded deliberate; `audits/hosts-register.sh` gate; HSTS extends edge entry 1. SSO fog struck per N-004. Sam: `Q11→amended 1`, `Q12→1`+note, `Q13→1`, `Q14–Q20→1`               | [x]              |

---

## Gate to stories

- [x] **Destination and out-of-scope bounds confirmed** — Sam, 28/08/2026 (`Q1→3 Q2→1 Q3→3`)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 0 blocks · 1 unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired; **six takeable now**
- [x] **Every node marked blocking is resolved** — the last (N-021) settled 01/09/2026
- [x] Every resolved node links to the artefact it became — **N-001, N-002 and N-003 became tables
      in this map and nothing outside it.** Deliberate, and named as a cost: if this map dies, the
      three censuses die with it. N-004 – N-008 are recorded in
      _The cookie spine_, graduating with the slice N-019 gates
- [x] **Every slice has a flag manifest** — four slices cut and backfilled 01/09/2026; S-03 carries `—`, stated not omitted
- [x] **No index row in `CONTEXT.md`** — the interim decline `MAP-RULE-OWNERSHIP` N-010 settled on
      28/08/2026; the row arrives with that map's slice S-06

**Slices here become stories** — Sam, 01/09/2026, superseding the earlier no-stories reading;
`02-story-creation` cuts them once the blocking frontier resolves. The three named gates — the
rule (N-004), the mechanism (N-014) and the home (N-019) — **all settled 01/09/2026**; artefact
text is unblocked, and it is build work carried by slices, never a sitting's.
