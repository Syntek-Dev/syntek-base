# MAP-SUBDOMAIN-ROUTING — which surface answers on which host

**Seeded**: 16/08/2026 · **Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Charting** — frontier drawn, three research nodes discharged by measurement
**Frontier open**: 23 · **Blocking open**: 6 · **Resolved**: 3

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

**Three research nodes, discharged by measurement on 28/08/2026 and adversarially verified.** Each
became a table in this map and nothing outside it — the exception the folder's _every resolved node
graduates_ rule allows for a census taken to inform a decision not yet made. **If this map dies,
they die with it**, which is named here so it is chosen rather than discovered.

| Node  | Decision                                                               | Type     | Settled    | Became                                    |
| ----- | ---------------------------------------------------------------------- | -------- | ---------- | ----------------------------------------- |
| N-001 | The host inventory — what already answers, and on what                 | research | 28/08/2026 | _The measured host inventory_ table below |
| N-002 | Whether the Cloudflare Access premise is supported anywhere in-repo    | research | 28/08/2026 | The finding below; **kills a fog item**   |
| N-003 | Whether host separation exists in dev or test, and survives a worktree | research | 28/08/2026 | The measurement below; **spawned N-017**  |

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

---

## Slices

**None, and none can be cut.** Every blocking node is open, and slices come from a resolved
frontier. What the deliverable even is remains open — **N-019** decides the artefact's shape and
whether the template ships it filled, empty, or at all.

| Slice | Story | Title                             | Nodes | Acceptance | Flags |
| ----- | ----- | --------------------------------- | ----- | ---------- | ----- |
| —     | —     | _(blocked — see N-019 and N-014)_ | TBD   | TBD        | —     |

**The `Nodes` and `Acceptance` columns were added 31/08/2026** with the `task` -> `build`
type change. Cells reading `TBD` are **not empty, they are unbackfilled** — this map's next
RESOLVE sitting fills them, and until it does the checklist item _every open node belongs to a
slice_ is unverified here.

**This is the one map in this folder where a flag might genuinely fire**, and that is unchanged by
charting. If a surface is routed to its own host, `Security` (cookie scope, host validation, the
`__Host-` prefix) and `SEO` (canonical and robots are per-host resources) both have real entries to
make. Written as a possibility, not a manifest.

---

## Frontier

Open decisions in dependency order. **Blocking** here means _"no artefact text may be written
against it"_ — this map's analogue of blocking a story, on the `MAP-PROGRESSIVE-ENHANCEMENT`
precedent, because the deliverable is doctrine.

**Takeable now — six nodes, nothing in flight:** N-004, N-005, N-007, N-014, N-016, N-019.

### A — Cookie scope, the spine

| Node  | Decision                                                                                                                                                                                                                             | Type     | Blocked by   | Blocking? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------------ | --------- |
| N-004 | **The cookie-scope rule.** Adopt _never set `SESSION_COOKIE_DOMAIN` / `CSRF_COOKIE_DOMAIN`_ and rewrite `URL-STRATEGY.md:149-150`, or keep the shared-domain mandate and drop `__Host-`                                              | grilling | none         | **yes**   |
| N-005 | **What a client-delegated subdomain may be.** Django's own docs: a subdomain can set cookies for the parent **regardless** of what this app configures. Not setting the domain stops it _reading_; only `__Host-` stops it _writing_ | research | none         | no        |
| N-006 | Do `__Host-` prefixed cookie names ship, and does the name live in `base.py` or per-environment                                                                                                                                      | grilling | N-004, N-005 | no        |
| N-007 | **`CSRF_USE_SESSIONS = True`** — a third option nobody has named. It removes the CSRF cookie entirely, so there is no second cookie to scope, name or prefix                                                                         | grilling | none         | no        |
| N-008 | **Reconcile the three-way doctrine and name one owner** — `URL-STRATEGY.md:149-150` mandates the shared domain, `CRYPTO-AND-DATA.md:122-123` says set an explicit `Path` **and `Domain`**, the 16/08 recommendation says set neither | grilling | N-004        | no        |

### B — Which surfaces get a host

| Node  | Decision                                                                                                                                                                                      | Type     | Blocked by | Blocking? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | --------- |
| N-009 | **The surface→host decision, per surface**, taken against N-001's measured inventory rather than the two-host inventory the map recorded                                                      | grilling | N-004      | **yes**   |
| N-010 | `/control/`'s Phase 2 position — it is **absent from `URL-STRATEGY.md:78-82`'s Phase 2 table entirely**, and the guide does not say whether that is deliberate                                | grilling | N-009      | no        |
| N-011 | Does `api.` serve the API, serve only the docs, or not exist — a docs-only host makes Swagger's "Try it" cross-origin against a session-authed API                                            | grilling | N-009      | no        |
| N-012 | Is `mcp.` a host at all, given `/mcp/` never enters Django's request cycle and the mount is already gated on a settings flag                                                                  | grilling | N-009      | no        |
| N-013 | Does the app's allowlist mirror **every** hostname the edge answers on, or only those terminating at Django — `.env.prod.example:11` already over-claims by one (`www.` never reaches Django) | grilling | N-009      | no        |

### C — The mechanism

| Node  | Decision                                                                                                                                                                                            | Type     | Blocked by   | Blocking? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | --------- |
| N-014 | **In-Django host reading, or edge-only** — and whether `URL-STRATEGY.md:74-76` (_"No business-logic changes are required"_) is overturned. The Destination deliberately does not pre-answer this    | grilling | none         | **yes**   |
| N-015 | Exact-string host key or **leftmost-label pattern** — dev derives from `<%PROJECT_SLUG%>`, prod from `<%PRIMARY_DOMAIN%>`, and the worktree mangles the leftmost label rather than prepending one   | grilling | N-014        | no        |
| N-016 | **Do dev and test stop being `ALLOWED_HOSTS = ["*"]`?** `["*"]` is exactly what makes 253 worktree hostnames work with no configuration, and exactly what makes host enforcement untestable locally | grilling | none         | **yes**   |
| N-017 | How a host-routed request reaches the correct **worktree** stack, given N-003's measured silent misroute to the main stack                                                                          | tracer   | N-014, N-016 | no        |
| N-018 | Does the dev stack gain a second nginx `server{}` block, or does the catch-all stand — four shipped docs restate `server_name _`, and named blocks existed and were deliberately removed            | grilling | N-015        | no        |

### D — The artefact and its gate

| Node  | Decision                                                                                                                                                                                                                                   | Type     | Blocked by | Blocking? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | --------- |
| N-019 | **The artefact shape**: a new `how-to/src/HOSTS.md` answer sheet paired with a rule section, a section inside `URL-STRATEGY.md` alone, or an `EDGE-REQUIREMENTS.md` entry — and whether the template ships it **filled, empty, or at all** | grilling | none       | **yes**   |
| N-020 | Does the host rule **ship with a gate**, or is it the documented exception to that standing preference — `seam-contract.sh` already gates any new numbered `EDGE-REQUIREMENTS.md` section, and nothing else can express it                 | grilling | N-019      | no        |

### E — Canonical, robots and transport

| Node  | Decision                                                                                                                                                                                                                                                                                                                       | Type     | Blocked by | Blocking? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | --------- |
| N-021 | **What `SITE_URL` is when more than one host serves pages.** `WEB-METADATA.md:29-30` makes canonical derive from it and **never** from the request host — so a second host either self-canonicalises to the apex (wrong) or `SITE_URL` becomes host-keyed, which is the banned Host-derived canonical wearing a setting's name | grilling | N-009      | **yes**   |
| N-022 | What `robots.txt` and the sitemaps say on a non-apex host — `ROOT-SURFACE.md:30-31` excludes the private surfaces **by path** and contains no host language at all                                                                                                                                                             | grilling | N-009      | no        |
| N-023 | Does the edge contract gain an **HSTS row**, and at what scope — `production.py:24-25` names the edge as HSTS's owner, and `EDGE-REQUIREMENTS.md` has **no HSTS row anywhere**                                                                                                                                                 | grilling | N-005      | no        |

### F — Corrections found while charting

| Node  | Decision                                                                                                                                                                                                                          | Type  | Blocked by | Blocking? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | ---------- | --------- |
| N-024 | **`dev-us###.conf`: honour or retract.** `17-STORY-PLANS/CONTEXT.md:55` and `STORY-PLAN-US000-TEMPLATE.md:703` both name it as a real path; `nginx/CONTEXT.md:28-29` states _"there are no per-story Nginx variants to generate"_ | build | none       | no        |
| N-025 | Give `URL-STRATEGY.md` the **declared-not-wired banner** its own content requires, on the `MCP-SERVER.md:13-17` precedent — four of its six prefixes do not exist, and 70 files defer to it                                       | build | none       | no        |
| N-026 | Does `SITE_URL` become a real setting in the same change as the host decision, or stay a guide-only name — it is defined in **no settings module**                                                                                | build | N-021      | no        |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

### Suggested first batch

**N-004 + N-005 + N-007 as one grilling pass.** They are one question about one cookie: what its
scope is, what a delegated subdomain can do to it regardless, and whether the second cookie should
exist at all. Deciding them apart means deciding the first one three times.

**N-014 + N-016 run together and in parallel** — both are mechanism questions with shared evidence
(N-003's measurements) and neither depends on the cookie answer.

**N-019 runs alone and early**, because every other node's output needs somewhere to land.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**

- **Whether the template should ship a host map at all.** A template hardcoding `admin.` decides for
  every generated project; shipping the mechanism plus an empty register is the other shape. N-019
  touches this but does not exhaust it.
- **What a client-delegated subdomain actually _is_.** `email.`, `chat.`, `video.` were named as the
  motivating case, but a vendor CNAME, a proxied third-party app and a Django-served surface have
  three different security answers. **The proposal treats them as one class; they are not one.**
  N-005 settles the cookie half only.
- **Whether admin/portal SSO is wanted at all.** Two logins versus a shared cookie is a product
  question about who the admin users are, and no admin surface exists.
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

| Date       | Node settled          | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Frontier redrawn |
| ---------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_      | Seeded out of a read-only recommendation pass on Sam's five-subdomain proposal, on his call that it is charted **after the other maps are fully done**. Frontier deliberately empty                                                                                                                                                                                                                                                                                                                                                                      | [ ]              |
| 28/08/2026 | N-001 · N-002 · N-003 | **Charted: 26 nodes, 23 open, 6 blocking, 3 discharged by measurement.** The seeded evidence section was **voided and re-derived** — `34` reproduces under no reading, three citations had drifted, and one fog item's premise (Cloudflare Access) is absent from the repository entirely. N-001 found **five** shipped or contracted host families where the map recorded one, and the object-store presign host's _"must not add auth"_ contract makes the cookie question sharper rather than softer. Bounds confirmed by Sam: `Q1→3`, `Q2→1`, `Q3→3` | [x]              |

---

## Gate to stories

- [x] **Destination and out-of-scope bounds confirmed** — Sam, 28/08/2026 (`Q1→3 Q2→1 Q3→3`)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 0 blocks · 1 unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired; **six takeable now**
- [ ] **Every node marked blocking is resolved** — 6 open (N-004, N-009, N-014, N-016, N-019, N-021)
- [x] Every resolved node links to the artefact it became — **N-001, N-002 and N-003 became tables
      in this map and nothing outside it.** Deliberate, and named as a cost: if this map dies, the
      three censuses die with it
- [ ] **Every slice has a flag manifest** — no slices; blocked on N-019 and N-014
- [x] **No index row in `CONTEXT.md`** — the interim decline `MAP-RULE-OWNERSHIP` N-010 settled on
      28/08/2026; the row arrives with that map's slice S-06

**This is a template-development map, so there are no stories to cut.** The equivalent gate is that
**N-004, N-014 and N-019 must settle before any artefact text is written** — the rule, the mechanism
and the home.
