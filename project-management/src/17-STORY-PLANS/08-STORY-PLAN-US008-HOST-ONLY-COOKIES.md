# STORY-PLAN-US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule

| Field  | Value                              |
| ------ | ---------------------------------- |
| Date   | 18/09/2026                         |
| Branch | `us008/host-only-cookies`          |
| Sprint | SPRINT-05 · Wave 1 · build order 1 |
| Author | <%ORG_NAME%>                       |
| Status | `Open`                             |

<!-- BORN WITH ITS PREFIX, 18/09/2026. The number `08-` was reserved for this story on 09/09/2026,
     recorded in `../02-STORIES/US008.md` (its STORY-PLAN NUMBER RESERVED comment) and as a
     no-file row in `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Story Plans — the code master_.
     The prefix is the story's position in the settled build order across the WHOLE backlog —
     US007, US001, US002, US003, US004, US005, US006, US008 — not its sprint and not a per-sprint
     counter, so US008 is eighth, opening SPRINT-05 behind US006. It is RENUMBERED whenever build
     order changes, which is the OPPOSITE of the sibling rule for the sprint plans: a sprint plan
     carries two numbers and a mismatch between them is information, while a story plan carries
     one, so its prefix must track build order or it says nothing. `./CLAUDE.md` owns the rule.
     Re-derived 18/09/2026 against the run on disk, contiguous `00-` to `07-`, and confirmed
     still current: no plan has been renumbered since 08/09/2026 and `09-` stays reserved for
     US009. The descriptor `HOST-ONLY-COOKIES` matches the story's QA plan, its threat model and
     its assessment, as every existing pair does. Wave 1 is the story's position in its map's
     cutting order — slice `S-02` of `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`, which that
     map's own build-order sentence (`:317-318`) puts FIRST because it is the only slice with no
     open nodes and because `S-01` defers to the doctrine `S-02` lands; build order 1 is first of
     {US008, US009}, the order `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Build order_ settled
     on 17/09/2026 on the `Must`-before-`Should` rule in `../../docs/planning/CADENCE.md`. -->

Implements `../15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` (the advisory ships
as **two** `_migrations:` entries gated on different things — an unversioned, state-gated entry for
the always-wrong `_DOMAIN`-beside-`__Host-` combination, and a version-keyed entry for the one-time
cutover notice — with the key derived at release against `git tag` and never carried from a
design-time record), `../15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` (the
`template-update.sh` preview blindness is repaired **inside** this story, and the rule beyond it:
a story that specifies a mitigation owns the channel that delivers it) and
`../15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` (`SECURE_PROXY_SSL_HEADER`
is a stated precondition of the doctrine, and the requirement that satisfies it is written into
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6), under
`../15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` (this story's citation criterion
is the scoped run) and `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (a red
`doc-references.sh` is read as a diff against a recorded baseline until US004 retires the regime).

`../15-DECISIONS/ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026.md` is **superseded** by the first
of those and is cited here because a superseded record stays readable: its rule that a key names
the release the change shipped in whatever the tier survives intact, as does its
`Template.migration_tasks()` proof, and neither is re-derived by its replacement.

> **`Open` is literal, and it asserts something.** `./CLAUDE.md` makes any value other than
> `Blocked` an assertion that the blockers are cleared, and this story has **no story-level blocker** to clear — one sprint-level prerequisite gates P5 alone, and it is named below:
> `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` records `Frontier open: 0 · Blocking open: 0 ·
Resolved: 26`, slice `S-02`'s Nodes cell reads `— (all settled)`, and no story in the backlog
> writes a file this story writes. What stands between this plan and the first edit is a process
> gate every story here shares — the `us008/` branch is cut from `main` once `pm/story-creation`
> lands — plus **one sprint-level prerequisite that is this sprint's alone** and is not a blocker
> of this story in the DAG sense: `v7.6.0` must be tagged at `16aac54` before the key in P5 is
> written. `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _The tag this sprint waits on_ owns it,
> it belongs to the `release` and `version` skills, and no member of this sprint owns it.

> **Source authority.** Where this plan and `../02-STORIES/US008.md` differ on **what must be
> true**, the story wins — its five-statement table under _Acceptance Criteria_ is stated once
> there and every count here derives from it. Where the story and
> `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` Section 7 or
> `../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` differ on a **mechanism**, the three ADRs
> of 17/09/2026 are the corrected record — the `Secure`-from-`request.is_secure()` error is
> corrected in the QA plan in place and in the threat model's Section 4a comment and must not be reintroduced from either. Where this plan and
> the sprint plan differ on sprint facts, `../03-SPRINTS/SPRINT-05.md` wins over both. On how a
> gate's result is reported, `code/docs/GATE-REPORTING.md` wins over everything here. **Both
> security artefacts read `Draft` and both QA plans read `Reviewed`, not `Signed off`** — quoted
> as found and not upgraded; the record treats both gates as closed on 17/09/2026 with 0 CRITICAL
> and 0 HIGH, and each artefact's own header records that its Step 1 grilling pass did not run at
> the time; only `THREAT-MODEL-PLAN-US008` Section 4a records that the interview was taken later
> the same day at `15-decisions`. `QA-PLAN-US008`'s header comment still reads `Draft` and
> `[OPEN]` against a Status cell of `Reviewed` — the cell is quoted as found and the header's
> disagreement is `11-qa-checks`' to reconcile.
>
> **One bullet in the story's own _Not in scope_ list is stale, and is named here rather than
> inherited.** `../02-STORIES/US008.md:277-278` still lists "fixing `template-update.sh`'s preview
> blindness" as out of scope. The same story's acceptance criteria at `:912-916` and `:946-953`
> **require** the repair, and `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` decided it.
> The criteria and the ADR are the corrected record and **P4 stands**; read literally, the
> authority clause above would have put this plan's own P4 out of scope. Correcting the bullet
> belongs to `02-story-creation`. **This does not tick the `17-story-plans`
> Prerequisite, which reads "signed off".** Either `10-security-checks` and `11-qa-checks` advance
> the four artefacts' status words before implementation begins, or <%DEVELOPER_NAME%> waives the
> prerequisite in writing on this plan. Naming the deviation is not the same as clearing it.

**No Table of Contents, and the omission is house practice rather than a divergence.** The
template marks the section optional — keep for large multi-phase plans, drop for small
single-layer ones — and this plan is six phases long; but none of the seven sibling plans in this
folder, `01-` to `07-`, carries one (re-measured 18/09/2026, all seven at zero), so this plan
follows the folder rather than inventing a difference the next reader would have to explain.

---

## Problem Statement

**Why this story exists.** `../02-STORIES/US008.md` is the `Must` of SPRINT-05 and the first cut
of `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`. The tree today **mandates the opposite of the
settled rule, in two shipped guides that travel into every generated project**:
`code/docs/URL-STRATEGY.md:149-153` says Phase 2 cookies "must use" `SESSION_COOKIE_DOMAIN` and
`CSRF_COOKIE_DOMAIN` set to the parent domain, and `code/docs/security/CRYPTO-AND-DATA.md:122-123`
says to set an explicit `Domain` on cookies. A project that follows either sets a cookie the whole
domain tree accepts — the exact write a subdomain can exploit, source-verified at map node N-005.

**Current state / gap.** Measured 17/09/2026 and unchanged at the time of writing: a repo-wide
search for `__Host`, `SESSION_COOKIE_NAME`, `CSRF_COOKIE_NAME`, `SESSION_COOKIE_DOMAIN`,
`CSRF_COOKIE_DOMAIN`, `SESSION_COOKIE_PATH`, `CSRF_COOKIE_PATH`, `CSRF_COOKIE_SAMESITE` and
`CSRF_COOKIE_HTTPONLY` returns **zero hits** across `code/src` — nothing is half-built. A sweep for
`document.cookie`, `getCookie` and `csrftoken` under `code/src/django` returns **zero hits** — no
committed script reads a cookie. `code/src/django/config/settings/` holds eight tracked files, last
touched at `c09a189` (23/08/2026), with `base.py:159-160` carrying `SESSION_COOKIE_HTTPONLY = True`
and `SESSION_COOKIE_SAMESITE = "Lax"`, `:161-162` the two-line comment explaining that
`SESSION_COOKIE_SECURE` is intentionally absent, and `staging.py:9-22` / `production.py:9-22`
byte-identical by `diff` at fourteen lines each. What is missing is the doctrine, its single owner,
its enforcement point, and the channel that carries it to a project already deployed under the
opposite rule.

**What this story delivers.** Five settings assignments across three modules; one widened comment
and six rows in the settings `CONTEXT.md`; three `[gate: fail]` clauses in
`code/src/scripts/audits/negative-space.sh` with the real scope and the self-test scope moved
together and a fixture pair grown on both sides; five guide rewrites making
`code/docs/security/CRYPTO-AND-DATA.md`'s Browser Storage Policy the sole owner of cookie-scope
doctrine; a clause and a verification entry in
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6; an additive report block in
`code/src/scripts/development/template-update.sh` that makes every print-only migration visible in
a successful preview; and two `_migrations:` entries with their scripts and their
`how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` register rows.

**Explicitly out of scope**, each owned elsewhere; the five that are this tree's are mirrored into _Deferred Items_, and the three map slices are held by `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`: the
six-target map re-cut (a separate `01-feature-map` correction on <%DEVELOPER_NAME%>'s 09/09/2026
ruling); collapsing the two near-duplicate guide settings blocks, and the byte-identical
`staging.py` / `production.py` block behind them (the `GAPS.md` row of 09/09/2026, Q9); a gate
clause over `SameSite`, which `code/docs/security/CRYPTO-AND-DATA.md:120-121` owns in prose and no
script reads; `code/src/scripts/audits/CONTEXT.md`'s clause register, deliberately left
under-counting by three (Q3); the `shared-ai-symlinks.sh` register row missing since 14/09/2026
(a `GAPS.md` row of 17/09/2026); `S-01`'s rule-section filename and content; `S-03`'s dev/test host
hygiene; `S-04`'s Phase 2 table; and **amending, appending to or superseding
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, which stays exactly as it
is** (Q13, <%DEVELOPER_NAME%> explicit) — both its supersession fields read `—` today and must
still read `—` at close.

**Layer scope (drives which sections survive).**

| Layer                         | In scope? | Notes                                                                                                                                                                       |
| ----------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Database / models / migration | —         | `DB: N/A`. No model, no field, no index, no RLS policy, no Django migration. The word "migration" in this story means a **copier** `_migrations:` entry, which is unrelated |
| Service layer                 | —         | No service function, no transaction, no error type. The story ships configuration                                                                                           |
| Django Ninja API              | —         | `API: N/A`. No router, no endpoint, no `Schema`, no MCP tool                                                                                                                |
| Frontend (templates)          | —         | `Frontend: N/A`. No template, component, partial or CSS. The CSRF token still reaches HTMX through the template, which this story asserts and does not change               |
| Infrastructure / DevOps       | ✓         | Three Django settings modules, one audit script, one update wrapper, two copier migration scripts and `copier.yml`                                                          |
| GDPR / PII                    | —         | `GDPR: N/A`. Two strictly-necessary cookies are hardened; no personal data is collected, no consent surface moves, no retention window changes                              |

**`Backend: Yes` and `Database: —` are not in tension.** The story's `Backend` flag reads `Yes`
because it edits Python under `code/src/django/`, which is **the first Python this backlog has
touched** and the first story for which `bash code/src/scripts/syntax/check.sh` is not `N/A`. The
Database row is `—` because the data layer is untouched. `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`
-> _Phase Breakdown_ records the same split.

---

## Reference Documents (code/docs gate map)

Every row of the template's table was checked; the rows below are the ones that gate this story.

| Concern (when it gates)                                                                                                          | Authoritative doc(s)                                                                                                                                                 | Applies? |
| -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| **Security** — the whole subject of the story                                                                                    | `code/docs/SECURITY.md`; `code/docs/security/CRYPTO-AND-DATA.md` (**the owner this story creates**), `security/AUTH-AND-AUTHZ.md`, `security/OWASP-AND-CHECKLIST.md` | ✓        |
| **Negative space** — the invariant and its one enforcement point                                                                 | `code/docs/NEGATIVE-SPACE.md` — the `[gate: fail]` marker shape at `:222-224`, and the rule that an invariant has exactly one named enforcer                         | ✓        |
| **Gate reporting** — how every result is stated                                                                                  | `code/docs/GATE-REPORTING.md` — absent tool vs absent surface; a skip is never a pass                                                                                | ✓        |
| **Forward voice** — what this plan may claim about paths                                                                         | `code/docs/FORWARD-VOICE.md` — the `template-only` token, and why a forward reference is not backticked                                                              | ✓        |
| **API auth surface** — one deferral only                                                                                         | `code/docs/api-design/AUTH-STRATEGY.md:67` — the Session cookie row that stops making a scope claim                                                                  | ✓        |
| **URL strategy** — the mandate being withdrawn                                                                                   | `code/docs/URL-STRATEGY.md:149-153`, and the `CORS_ALLOWED_ORIGINS` sentence at `:152-153` that must survive verbatim                                                | ✓        |
| **Testing**                                                                                                                      | `code/docs/TESTING.md` — read for what this story deliberately does **not** add; see _Testing_ below                                                                 | ✓        |
| **Documentation length**                                                                                                         | `code/docs/DOCUMENTATION-LENGTH.md` — the 270 ratchet over the five guides, and the file this story must not grow                                                    | ✓        |
| **Documentation pairing**                                                                                                        | `code/docs/DOCUMENTATION-PAIRING.md` — the `config/settings/` pair, edited on one half and kept whole                                                                | ✓        |
| **Edge contract**                                                                                                                | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 — the trusted-proxy chain the new clause joins                                                       | ✓        |
| **Rendering** — read, not edited                                                                                                 | `code/docs/rendering/PITFALLS-AND-EXAMPLES.md:100` and `rendering/TEMPLATES-AND-INTERACTIVITY.md:88` — the template-injected CSRF pattern                            | ✓        |
| Database / RLS / encryption / API design / accessibility / responsive / design tokens / SEO / Cloudinary / logging / performance | —                                                                                                                                                                    | —        |

> The last row is one line rather than eleven blanks: each of those concerns has **no subject** in
> this story, and the sprint plan records the same `N/A` set with its reasons. Deleting them here
> is the template's `◇` rule applied, not a gate dodged.

Cross-layer compliance guides that also gate this plan: `project-management/docs/SECURITY-GUIDE.md`
(STRIDE), `project-management/docs/QA-GUIDE.md`, `project-management/docs/VERSIONING-GUIDE.md`
(the MINOR bump at `:76`), `project-management/docs/GIT-GUIDE.md` (the branch above).

---

## Architecture Decision

**The doctrine itself is not decided here and is not re-opened.** It was argued on
`../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` -> _The cookie spine_ (`:206-241`), nodes N-004 to
N-008: never set `SESSION_COOKIE_DOMAIN` or `CSRF_COOKIE_DOMAIN`; `__Host-` names in the modules
that serve TLS, beside the `SECURE = True` lines they depend on, with dev keeping plain names
because a browser's storage model rejects an insecure `__Host-` cookie; omitting `Domain` stops a
subdomain **reading** the apex's cookie and only the prefix stops it **writing** one the apex
accepts; and `CSRF_USE_SESSIONS` rejected because an anonymous page rendering `{% csrf_token %}`
would force a persisted session plus `Vary: Cookie` on a cached marketing surface, so the CSRF
cookie stays and is hardened with `CSRF_COOKIE_HTTPONLY = True` in `base.py`.

**What the three ADRs of 17/09/2026 decided is the doctrine's _delivery_, and that is what this
plan sequences.** All three findings cluster on one theme, which the QA plan states plainly: the
doctrine is sound and its delivery is where the story was wrong.

| Decided                                                              | By                                                          | What it fixes                                                                                                   |
| -------------------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| Two `_migrations:` entries, gated on state and on version separately | `ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`          | A single version key can only be correct about one of the advisory's two claims, and was falsified once already |
| The preview repair lands inside this story                           | `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`       | The merge hazard's only mitigation was specified into a channel the story itself planned to prove suppressed    |
| The edge precondition is stated and carried into the contract        | `ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` | `__Host-` is a promise to a browser this repository can only keep half of; the other half is the edge's         |

**This story is free to choose one thing and it is chosen below: the order.** The three clauses,
the five assignments, the five guides, the contract clause, the preview repair and the two
migration entries could land in several sequences. One is forced by a proof obligation and the
rest follow from it — see _Phase plan_.

---

## Approach

### Not applicable — Database, Service Layer, API, Frontend

The template's four layer sections are dropped. This story adds no model, no migration in the
Django sense, no service, no endpoint, no `Schema`, no template and no component; the story's
`DB`, `API` and `Frontend` flags all read `N/A` and
`../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Phase Breakdown_ records phases 2 and 3 as `N/A`
with their reasons. They are dropped because the story touches none of them, not to dodge a gate.

**The Python it does ship is configuration, and it is planned in P2 rather than under a layer
heading**, because five module-level assignments and a table have no service boundary, no error
type and no transaction to describe.

### Phase plan — six phases, and the first ordering constraint is forced

| Phase | Deliverable                                                                                                                                                                                                                        | Blocked by                       |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| P0    | The baselines, captured **before any edit** — the whole-tree citation figure by identity with its detector hash and index state; the scoped criterion's starting reading; the length figures; ShellCheck probed                    | The branch existing              |
| P1    | The gate — the settings-directory scope with `:92` and `:481` moved together, the three `[gate: fail]` clauses, the fixture pair grown on both sides, `EXPECTED` at fourteen, `--self-test` green                                  | P0                               |
| P2    | The settings — five assignments across three modules, the widened comment, six rows in the settings `CONTEXT.md`, the Module Map cell                                                                                              | P1                               |
| P3    | The doctrine's owner and the four deferrals, plus the `EDGE-REQUIREMENTS.md` Section 6 clause and its verification entry                                                                                                           | P2                               |
| P4    | The preview repair — an additive report block in `template-update.sh`, proved against the **three advisories already shipped blind**                                                                                               | P0                               |
| P5    | The two `_migrations:` entries and their scripts, the two `06-GENERATION.md` register rows, the keyed entry's derived-at-release comment, and the proposed line in `24-release/CHECKLIST.md` (scope addition — implementer's call) | P2, P4, **and the `v7.6.0` tag** |
| —     | The two test records and the register reconciliation — **`22-implementation-documentation`'s**, not this story's to write                                                                                                          | P1 to P5                         |

**The gate comes before the settings, and that is not a preference.** The story's discriminating
comparison is the **new** script run over the settings modules as they stand _before_ the change —
reporting all three clauses — and then over the modules after P2, reporting none
(`../02-STORIES/US008.md` -> _QA Acceptance Criteria — Automated_). The clauses must therefore
exist while the modules are still un-edited, so P1 precedes P2 and the capture happens at P1's
close. **There is no comparison the other way round**: the old script has no clause for a fixture
to fail against, so the "fixture fails against the pre-change script" form US004 uses does not
apply here, and saying so is what stops it being claimed.

**P4 is independent of P1 to P3 and is placed where it buys a second proof.** The preview repair
waits only on P0. Running it before the cookie advisory exists means it is proved against the
three print-only advisories that have shipped blind since they landed — `v3.0.0`, `v5.0.0` and
`v6.0.0`'s report-only third — which is exactly the generality
`ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` says the repair is for. Folding it into P5
would couple the two proofs and leave a failure impossible to localise between the channel and the
advisory. **P5 then re-proves the same channel carrying the new advisory**, which is the criterion
the story actually states.

**Every phase is testable on its own:** P0 by the recorded figures and their states; P1 by
`--self-test` plus the pre-change capture; P2 by the post-change capture and the unscoped run; P3
by `doc-references.sh --path code/docs`, `docs-length.sh` and `docs-pairing.sh` — **not
`doctrine-drift.sh`**, which no claim row makes able to see a settings line — plus the
five-document read-across; P4 by the preview proof below; P5 by the advisory dry run in three
states and a second preview.

**P5 has a third blocker that is not a phase.** `v7.6.0` must be tagged at `16aac54` before P5's
key is derived. **Do not enter P5 until `git tag --sort=-v:refname | head -1` returns `v7.6.0`**;
while it returns `v7.5.0`, P5 is not startable and P0 to P4 are the whole of the available work.

**P4's proof needs a generated project, because `template-update.sh:102` refuses to run here.**
That line dies with "No `.copier-answers.yml` — this project was not generated from a template",
and **syntek-base's `.copier-answers.yml` is the Jinja template rendered into projects** — zero
`_commit:` literals, measured 18/09/2026 — so the script cannot execute in this repository at all.
Generate a scratch project from a ref **below `v3.0.0`**, commit it so `:106`'s clean-tree guard
passes, copy the edited `template-update.sh` in, and run the preview. Two consequences the earlier
draft of this plan had wrong:

- **The expected output is four banner lines from three advisories, not three.**
  `v5.0.0-git-guide-split.sh` is declared **twice** in `copier.yml`, at `:889` under `version:
v4.0.0` and at `:903` under `version: v5.0.0`, deliberately and with the reason at `:887-888`.
  A scratch copy old enough to cross both keys prints it twice.
- **P4 cannot be run concurrently with uncommitted P1 to P3 work.** `template-update.sh:106` dies
  on a dirty tree. "P4 waits only on P0" is a dependency claim, not an execution one: take the
  proof at a commit boundary.

**If P2 lands before P1's capture anyway, the story is not lost.** `git stash` the settings edits,
or check the pre-P2 commit out into a second worktree, and run the new script there. Record in the
test record that the capture was taken that way rather than in sequence. `--path` cannot
substitute — `negative-space.sh:182` refuses it outright.

**Between P1's close and P2's close the unscoped gate is red, and that redness is the
deliverable.** Three findings over the un-edited modules _is_ the pre-change capture; it is not a
defect and is not repaired until P2. Stage 2's unscoped run is read as **captured** rather than
**passed** across that window, per `code/docs/GATE-REPORTING.md`. Nothing blocks the commit —
`lefthook.yml` runs no negative-space leg — and `.github/workflows/audit-negative-space.yml`
filters to `[main, staging, dev, testing]`, so it does not fire on a `us008/` branch until the PR,
by which time P2 has landed.

**P0 — the baselines, and why a figure without its state is not a baseline.** Four readings, each
recorded with the state it was measured in:

- `bash code/src/scripts/audits/doc-references.sh` over the whole tree, captured **by identity** —
  the `(file, kind, token)` triple with the line number dropped and multiplicity kept, the form
  US007's Scenario 13 fixed — with the detector's `git hash-object` recorded beside it and
  re-asserted at close. The inherited figures are **253** at HEAD `ff24084` on a clean tree
  (135 instance, 106 dangling, 12 template-only, no plan-prefix finding) and **259** with the
  09/09/2026 change staged, the `+6` all `../03-SPRINTS/SPRINT-05.md`'s. Both are inherited readings, not this
  branch's: `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` obliges a capture **immediately
  before the first edit**, and P0 is where that happens. **`git add -N` first** — because
  `build_template_only()` reads `git ls-files` and an untracked file is treated as shipping — **and
  again at close, which is where it bites.** At P0 the tree is clean and the call is a no-op; at
  close the two migration scripts, both fixture subtrees and the two compose overrides are
  untracked, and without it the detector reads each as shipping and the closing figure is not
  comparable to the baseline.
- `bash code/src/scripts/audits/doc-references.sh --path code/docs` — the story's actual criterion
  (Q6), which read `Clean, exit 0` on 09/09/2026 and again at `1e00a4b`. Recorded at P0 so the
  close proves it did not move.
- `bash code/src/scripts/audits/docs-length.sh` — the five guides — 185, 156, 188, 210 and 194 in the row order of the five-statement table above (
  lines on 09/09/2026 as `wc -l` counts them, and lower as the gate counts) against the 270
  ratchet, and **`code/src/scripts/audits/CONTEXT.md` at 299 of 300 as the gate measures them**.
  That figure is 299 and not the 298 this story's own criteria assert — re-measured 18/09/2026,
  `docs-length.sh` printing `299 code/src/scripts/audits/CONTEXT.md (1 left)` against a `wc -l` of 356. The story's requirement is **do not touch that file** (Q3) and is unaffected by which side
  of the line it sits on; the real figure is recorded here and in the test record so the next
  reader does not re-derive it. **Re-read it at P0 rather than inheriting this figure**: a parallel session committed `f045aac` on 18/09/2026 while this plan was being written, rewriting that file by 43 lines to pay for a new `playwright-pin.sh` register row out of compression. It still measures **299 of 300**, and the `negative-space.sh` row is at `:174`, but the file has moved under a figure this plan quotes and will move again.
- ShellCheck — whether the host carries it. No project script runs it: `lint.sh`'s legs are ruff,
  markdownlint-cli2, ESLint and clippy, and as of 17/09/2026 no script under `code/src/scripts/`,
  no CI job and no lefthook entry invokes it. P0 is where the answer is found rather than at close,
  and the result is recorded **as run or as not run, never as a `lint.sh` pass**.

**P1 — the gate, and the two things that are load-bearing.** `code/src/scripts/audits/negative-space.sh`
is 624 lines. `SETTINGS_FILE` at `:92` names `base.py` alone; `run_middleware_clause` at `:405-416`
is the clause shape to copy, with its skip idiom at `:407` and the fail/skip helpers at `:209-211`;
`--path` is refused outright at `:182` and `--self-test` is the only sanctioned scope change.

- **`:92` and `:481` move together.** `point_scopes_at` at `:481` sets
  `SETTINGS_FILE="$root/settings.py"` — a single file — so widening `:92` without repointing `:481`
  coherently makes the self-test prove a different shape than the real run. That is the defect the
  script's own header at `:59-65` says it refuses at the parser, wearing the self-test's clothes.
  The script gains a settings-**directory** scope beside `SETTINGS_FILE`, which stays as it is
  along with `run_middleware_clause`; the real run points the new scope at
  `code/src/django/config/settings/`, the self-test at a `settings/` directory under `$root`, and
  the module names inside it — `base.py`, `staging.py`, `production.py`, `dev.py`, `test.py` — are
  fixed by `point_scopes_at` exactly as `settings.py` is.
- **The new fixtures must be asserted inert for the other eleven clauses, not assumed to be.**
  `negative-space.sh:252` (`collect_constraints`) and `:278` (`collect_keys`) both run
  `find … -type f -name '*.py'` with **different** exclusions —
  `:252` drops `*/tests/*` and `*/migrations/*`, `:278` drops `*/tests/*` and `conftest.py`, **and
  neither drops `*/settings/*`** — so the five new
  `.py` fixtures become input to the constraint and key-register clauses as well. A fixture that
  happens to look like a constraint or a raised key would trip a clause it was never written for,
  and `EXPECTED` would then pass or fail for the wrong reason. Write them to contain cookie
  settings and nothing else, and assert the eleven pre-existing names are unaffected (AC-GAP-9). **Eleven is `EXPECTED`'s
  count, not the clause count.** `code/src/scripts/audits/CONTEXT.md:174` names **twelve**
  `[gate: fail]` clauses; `EXPECTED` at `:506-508` omits `register-absent`, which is a live clause
  the self-test has never asserted. This story grows `EXPECTED` eleven to **fourteen** and leaves
  that pre-existing omission alone — closing it would make the target fifteen and fail the
  Definition of Done. The inertness assertion therefore covers eleven of twelve, and
  `register-absent` is checked by hand against the five new fixture modules.

`EXPECTED` at `:506-508` grows from eleven names to fourteen; `broken/` gains a `settings/` tree
that trips all three clauses and `clean/` one that trips none; the missing-fixture `exit 2` at
`:492-493` is unchanged. `.github/workflows/audit-negative-space.yml` needs **no edit** — its path
filters (`:34-39` on push, `:43-48` on pull request) already include `code/src/django/**`, the
script and its fixtures, and the job runs `--self-test` first (`:60`) and the audit second (`:63`).

**P1 closes with the pre-change capture**: the new script over the settings modules as they stand,
reporting all three clauses. Recorded, with `HEAD` beside it.

### The three gate clauses, and what each asserts

Named apart the way `key-unraised`, `key-unregistered` and `key-duplicated` are, **because the
three ways to break the doctrine are three different repairs**.

| Clause                        | Asserts                                                                                                                                                           | Over                                                 |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `csrf-cookie-httponly-absent` | `base.py` assigns `CSRF_COOKIE_HTTPONLY = True`                                                                                                                   | **Presence**, `base.py` named                        |
| `cookie-host-prefix-absent`   | A module lacks a `SESSION_COOKIE_NAME` or `CSRF_COOKIE_NAME` beginning `__Host-`, or lacks the `SECURE = True` line the prefix depends on, **in the same module** | **Presence**, `staging.py` and `production.py` named |
| `cookie-scope-widened`        | Any module assigns `SESSION_COOKIE_DOMAIN` or `CSRF_COOKIE_DOMAIN`, or a `SESSION_COOKIE_PATH` / `CSRF_COOKIE_PATH` other than `/`                                | **Absence**, every `*.py` in the directory           |

Four properties bind all three:

1. **Every match is assignment-anchored at the start of a line**, so a setting named in a comment
   — the widened `base.py:161-162` among them — is neither a finding nor a pass, and a commented-out
   assignment is absent. `config/settings/CONTEXT.md` gains six rows naming these very settings and
   sits inside the scanned directory; it does not fire, because every row is a Markdown table line
   opening with a pipe. **The scope is stated as `*.py` rather than "every module under the
   directory"**, so the protection is a stated boundary and not an implementation detail of the
   anchoring (AC-GAP-4).
2. **Each clause skips with a note when the module it reads is absent**, on the `:407` idiom — an
   absent surface reported as such, never an absent tool reported as clean.
3. **Each presence clause names the modules it read in its skip note** (AC-GAP-5). The doctrine
   binds **every module that serves TLS**, not two named files; `staging.py` and `production.py`
   are simply the TLS-serving modules today, so a third such module a project adds is visible as
   unchecked rather than silently passing because the two the clause names both passed.
4. **No silencing annotation**, on `code/src/scripts/audits/CONTEXT.md:174`'s standing rule that a
   comment suppressing a negative-space finding is itself a finding.

`dev.py` and `test.py`, carrying no cookie setting at all, can never fire either way: no presence
claim is made of them, and there is no `Domain` to find. **`SameSite` is not asserted** —
`code/docs/security/CRYPTO-AND-DATA.md:120-121` owns it in prose, Django's default of `Lax`
satisfies it, and widening the clause to it is a later story. The boundary is stated so it is read
rather than assumed.

### What the gate can and cannot see

**A green run proves a directory, not a global rule**, and the owner guide says so (AC-GAP-4,
TM-08, assessment 7.7). Three assignment sites are invisible to a directory scan:

- a runtime write to `django.conf.settings` — an `AppConfig.ready()` is the canonical place;
- an environment-driven value, read anywhere, which never appears as an anchorable assignment;
- any settings module a project adds outside `code/src/django/config/settings/`.

No record produced by this story may read the green run as proof the rule holds everywhere.
`../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Gate honesty_ carries the same constraint at sprint
level.

### The doctrine's owner, and the four statements that defer to it (P3)

**Five statements exist in `code/docs/` and no sixth**, measured 09/09/2026 by a sweep of the
twelve files containing "cookie". The story enumerates them once under _Acceptance Criteria_ and
every count here derives from that table.

| #   | File                                        | Lines      | Becomes                                                                              |
| --- | ------------------------------------------- | ---------- | ------------------------------------------------------------------------------------ |
| 1   | `code/docs/security/CRYPTO-AND-DATA.md`     | `:122-123` | **The owner** — host-only, `__Host-`, three preconditions, three limits, gate marker |
| 2   | `code/docs/URL-STRATEGY.md`                 | `:149-153` | Defers to 1; three sentences survive verbatim                                        |
| 3   | `code/docs/api-design/AUTH-STRATEGY.md`     | `:67`      | Defers to 1; the `(SESSION_COOKIE_PATH=/)` fragment goes                             |
| 4   | `code/docs/security/AUTH-AND-AUTHZ.md`      | `:133-140` | Gains `CSRF_COOKIE_HTTPONLY = True` beside `:138`, plus one routing sentence         |
| 5   | `code/docs/security/OWASP-AND-CHECKLIST.md` | `:44-52`   | Gains the same line beside `:49`, plus one routing sentence                          |

**Three sentences in row 2 survive verbatim and one of them is a non-negotiable.**
`CORS_ALLOWED_ORIGINS` "must be an explicit allowlist — never `*` in production" at `:152-153` is
a `.claude/CLAUDE.md` Section 6 rule and must not be lost to a rewrite aimed at the cookie clause
above it; "Admin and portal sessions remain separate" and "Implement subdomain migration only
after explicit security review" survive with it. `:147-148` — one wrapped bullet that quoting
`:147` alone truncates — is left alone, and `:154-156`, the Edge contract bullet, is untouched.

**The owner carries three limits, not two** (AC-GAP-6, assessment 7.6). N-005 named two — the
prefix protects **per cookie name**, and a browser without prefix support accepts a prefixed cookie
unconditionally, so the prefix is defence in depth over the settings and never a substitute for
them. The third is this story's: **`CSRF_COOKIE_HTTPONLY` does not defend the token against XSS**,
because `{% csrf_token %}` renders it into the DOM and `hx-headers` into a body attribute, both
readable by injected script. It stops a script reading the _cookie_, and that is all. Without it
stated, the next reader takes the setting as anti-theft and stops.

**The owner states the doctrine's scope, and which cookies it does not cover** (AC-GAP-7,
assessment 7.6). `django.contrib.messages` is in `INSTALLED_APPS` (`base.py:33`) with
`MessageMiddleware` in `MIDDLEWARE` (`:59`), and its default storage falls back to a cookie that
stays unprefixed and subdomain-writable after this story, as would any language cookie. Saying so
is what stops a reader concluding the cookie jar is now covered.

**The owner states the dev/TLS name divergence** (assessment 7.8), because that warning is owed to
this template's own future code — a fixture, a Playwright selector, a monitoring rule or an edge
config matching `sessionid` literally passes in dev and fails in production — and not only to an
updating project, which is all the advisory reaches.

**`code/docs/wagtail/ADMIN-AND-PERMISSIONS.md:47-50` is noted, not edited.** "A session obtained at
the CMS login is a session everywhere" names no setting, so it is not a scope statement; it is true
under host-only cookies for as long as every surface shares one host. The note goes in the
manual-testing record beside the sweep.

### The edge precondition (P3)

`__Host-` requires the cookie to have been set over a genuinely secure connection. **Django emits
the `Secure` attribute from the setting** — `django/contrib/sessions/middleware.py:74`
(`secure=settings.SESSION_COOKIE_SECURE or None`) and `django/middleware/csrf.py:264`, verified
against Django 6.1.0 in this tree's own dependency set on 17/09/2026 — so that half is this
repository's and is gated by P1's presence clause. **What is not is `SECURE_SSL_REDIRECT`**, which
reads `request.is_secure()` at `django/middleware/security.py:25` and therefore trusts
`SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")` at `staging.py:19` and
`production.py:19`. A request reaching Django over plain HTTP with a client-supplied
`X-Forwarded-Proto: https` skips the redirect, is served over HTTP, and the browser discards the
prefixed cookie — the same silent anonymous request as the merge hazard, by another route.

> **This mechanism was stated wrongly in two gate artefacts and the correction must not be
> reversed.** `QA-PLAN-US008` AC-GAP-3 and `THREAT-MODEL-PLAN-US008` TM-05 both said Django takes
> the cookie's `Secure` flag from `request.is_secure()`. It does not. `QA-PLAN-US008` AC-GAP-3 **is** corrected in place; `THREAT-MODEL-PLAN-US008` TM-05's own row
> still states the wrong mechanism and is corrected only in its Section 4a header comment — read
> the correction there, not in the row.
> the finding survives the correction and its severity is unchanged. A correct conclusion reached
> by a wrong mechanism is worth more to fix than a wrong conclusion, because the mechanism is what
> the next reader reuses.

`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 gains a clause requiring the edge
to **strip** any client-supplied `X-Forwarded-Proto` and set it itself, plus an entry in that
file's post-deploy verification section. **No gate clause is added**: whether an edge strips a
header is not a property of this tree, and a green clause over the setting would be the false green
`code/docs/GATE-REPORTING.md` names — a check that ran, passed, and measured nothing in doubt.

### The preview repair (P4)

`code/src/scripts/development/template-update.sh` is 295 lines. It runs copier at `:143-144` with
stdout and stderr redirected wholesale to `$UPDATE_LOG`, tails that log at `:151` **only** when the
exit code is non-zero, and its `cleanup` at `:122` deletes the log unconditionally. A print-only
advisory exiting 0 therefore never reaches the preview's report, and at `:275` the preview prints
"Preview only — your project is unchanged" over an advisory that fired.

The repair is an **additive report block** on the success path, a sibling of the
`── What this update does ──` block at `:162` which already prints counts of modified, deleted,
added and conflicted files. It greps the migration banner lines out of `$UPDATE_LOG` and prints
them — roughly eight lines, in a script whose whole structure is additive report blocks. It
touches **neither** the failure tail at `:151`, which is inside `if [[ $UPDATE_RC -ne 0 ]]`, **nor**
the `cleanup` trap at `:122`, which fires at exit while the repair prints before it. It reorders no
section and changes no exit code.

**The repair is general by design, and P4 proves that before the cookie advisory exists.** It
surfaces whatever the migration stage printed, not a cookie-specific string, so the three
advisories already shipped blind become visible in a preview for the first time, and
`how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:144`'s existing claim becomes true of both paths without
that guide being edited.

### The two migration entries (P5)

`copier.yml` opens `_migrations:` at `:823` with nine entries — seven version-keyed and two
unversioned, the `rm -rf` staging-directory entry at `:945` which must stay **last** because
declaration order is run order. Both new entries go **before** it.

| Entry                                                | Gated on    | Why that gate                                                                                                                                                               |
| ---------------------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ".copier/migrations/cookie-domain-conflict.sh"       | **State**   | A `__Host-` name beside a `Domain` attribute is wrong **whenever** it holds, by the prefix's own definition. Not an event — so no key can be wrong, because there is no key |
| ".copier/migrations/v<RELEASE>-host-only-cookies.sh" | **Version** | The rename invalidates every live session and open CSRF token at one crossing. That is an event, and a state gate has nothing to read                                       |

**The unversioned entry is silent when it finds nothing** — a deliberate deviation from the two
shipped advisories that banner unconditionally, because an entry running on every update forever
must cost nothing on the updates where it has nothing to say. It reports each hit with file, line
and setting name, **never a value**; exits 0 always, and early when the settings directory is
absent. A project holding a `_DOMAIN` line deliberately — the N-005 case — gets a report it must
judge and dismiss on every update; the advisory says so rather than deciding.

**The keyed entry carries the cutover notice** (AC-GAP-8), which a state gate cannot: the rename invalidates
everything at the first deploy so **when** is a decision; a **rollback** restores the plain names
and invalidates everything a second time, so the reverse is not free; a **rolling deploy** serves
both names at once and logs a load-balanced user out repeatedly, surfacing as CSRF 403s rather
than a login redirect, so it is unsafe and the advisory says so; and anything matching a cookie by
name — an edge rule, a monitor, a test, a script reading the CSRF cookie that
`CSRF_COOKIE_HTTPONLY = True` now blinds — must be repointed. It ends in the proof step,
the unscoped `bash code/src/scripts/audits/negative-space.sh`.

Both follow the convention `v3.0.0-self-authored-agents.sh` (91 lines) fully specifies:
`set -euo pipefail`; a long `#` header covering what changed, why an update cannot repair it, why
it advises rather than acts, the working directory and the exit codes; an early `exit 0` when the
target is absent; the banner `printf`; a guidance heredoc ending in a
`bash code/src/scripts/audits/...` proof step; and `exit 0` **always**. The unversioned one carries
no version prefix, on `shared-ai-symlinks.sh`'s form, because a filename recording "the release it
was written for" is meaningless for an entry keyed to none.

**Both get a row in `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`'s per-version register** — the
keyed one in declaration order, the unversioned one in the form that table needs for a row with no
version, **establishing that form**, because `shared-ai-symlinks.sh` shipped without a row and the
register has been incomplete since 14/09/2026. Backfilling that earlier row is **not** this story's
work; it is a `GAPS.md` row of 17/09/2026. That file's length is **not** a gate figure —
`docs-length.sh`'s `is_instructional()` binds only a `CONTEXT.md`, `CLAUDE.md` or `AGENTS.md` basename, or a path
carrying a `docs`, `workflows`, `.claude`, `.ai` or `.codex` segment, and `how-to/src/TEMPLATE-GUIDE/` carries none
— so no length figure for it is claimed as the gate's.

### The migration key — the entry in P5, the key at `24-release`

**Settled 18/09/2026 at this plan's grilling pass, and corrected the same day at its Step 9
review** (AC-GAP-1). The story's task table holds both "add both entries to `copier.yml`" and "derive the key
at release against `git tag`", and those pull apart because the story edits `copier.yml` well
before the release.

> **The first resolution this plan carried was wrong and is recorded rather than quietly replaced.**
> It had P5 writing `v7.7.0` at implementation time, on the reading that a placeholder was the
> thing the ADR bans. **It is not.** All three binding records name the opposite act:
> `ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md:149` — "A key written into `copier.yml`
> **before the tag it names exists** is an unverified claim"; `../02-STORIES/US008.md:677` and
> `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:197` — "writing an **untagged number** into
> `copier.yml` is the unverified claim this story exists to stop repeating"; and the story's own
> task at `:997` — "**never write an untagged number into `copier.yml`**". Writing `v7.7.0` at P5
> is writing an untagged number, by this plan's own measurement. The resolution below is the
> sources', and adopting it needs no ADR; the one it replaces would have needed one.

1. **P5 writes both entries and the keyed one's comment, not its key.** The unversioned entry is
   complete at P5. The version-keyed entry lands with the **derived-at-release comment** the
   story's task at `:996` requires — stating that the key names the release the doctrine ships in,
   that it is the first minor-keyed migration this template has carried, and that the value is
   written at release and not at design.
2. **The key itself is written at `24-release`, in the same act as the tag.** The release derives
   it with `git tag --sort=-v:refname | head -1` — **`--sort` is load-bearing: a bare `git tag`
   sorts lexicographically and would return `v7.9.0` as newer than `v7.10.0`** — takes the next
   minor above what it returns, writes it into `copier.yml`, and cuts the tag. The key and the tag
   are never separated by a commit.
3. **US008 builds the channel that obligation travels in.** `project-management/workflows/24-release/`
   is silent on `_migrations:` today — measured 18/09/2026, its `STEPS.md` and `CHECKLIST.md`
   contain zero occurrences of `migration`, `copier` or `key` — so an obligation recorded only in
   this plan's Definition of Done reaches nobody at the moment it binds. **P5 therefore adds one
   line to `project-management/workflows/24-release/CHECKLIST.md`.** This is the story's own rule
   applied to itself: `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` holds that a story
   specifying a mitigation owns the channel that delivers it, and a plan that repaired
   `template-update.sh` for exactly that reason cannot leave its own key unreachable.

   **It is a scope addition beyond the story's Tasks table, and it is NOT yet accepted.** Raised
   18/09/2026 at `17-story-plans` and ruled on the same day by <%DEVELOPER_NAME%>: neither taken
   into the story nor declined, but **left for this story's own implementation to settle**, with
   `24-release/` open in front of whoever takes it. So `../02-STORIES/US008.md`'s Tasks table was
   not grown today, and P5 carries the line as a proposal the implementer rules on. **If it is
   declined, a `GAPS.md` row is filed in its place** — the one outcome ruled out is silence,
   because the derive-at-release obligation then reaches no reader of that workflow at all.

**`v7.7.0` is the expected value and it is a prediction, not a decision.** Measured 18/09/2026:
`VERSION` reads `7.6.0` on `pm/story-creation` and `7.5.0` on `main`; there are **77 tags and the
newest is `v7.5.0`**; `CHANGELOG.md`'s top released heading is `## [7.6.0] - 14/09/2026`,
describing the shared-AI / Codex release and nothing else.

> **`v7.6.0` is NOT yet tagged, and two binding records say otherwise in passing.**
> `../02-STORIES/US008.md:675` and
> `../15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md:145` both read "`v7.6.0` is
> tagged at `16aac54`". Re-measured 18/09/2026: **77 tags, newest `v7.5.0`, and `git tag
--points-at 16aac54` returns nothing.** Both documents contradict themselves elsewhere and are
> right there — the story's own `:638-639` says "there is **NO** `v7.6.0` tag", and the ADR's
> `:188` says "tagged at `16aac54` **when this branch merges**", which is the future form.
> `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md:175` has it right: "**must be** tagged". **This plan
> carries the sprint plan's form throughout.** Correcting the other two is not a story plan's
> licence — an `Accepted` ADR belongs to `15-decisions` and a story to `02-story-creation` — so
> the slip is named here once, with its measurement, so the next reader does not re-derive it and
> does not build on the false premise. Settled 18/09/2026, Q3 of this plan's grilling pass.

### The citation gate, as it stands for this story

**This story is on the baseline-diff branch, full stop, and the regime is not contingent the way
it was for US006.** US004 has not landed (SPRINT-03, `Open`), so the whole-tree run is inherited
red and `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` applies: the baseline is captured
before the first edit, read as a diff, and "never reported as the gate passing while the baseline
stands".

**The criterion is the scoped run** (Q6,
`ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md`): `bash code/src/scripts/audits/doc-references.sh
--path code/docs` exits 0 with "Clean — every citation resolves." after the five guide edits. That
is a plain pass and is read as one. **The whole-tree figure is never the criterion.**

**That record's enumeration of the files this story edits outside that scope has grown from three
to five**, and the growth is a property of the story rather than of the decision — the record is
not superseded. Each takes one `--path <file>` run, exit 0:

| File                                                  | Reading                                             |
| ----------------------------------------------------- | --------------------------------------------------- |
| `code/src/scripts/audits/negative-space.sh`           | Clean on 09/09/2026, 36 tokens, 0 tested as paths   |
| `code/src/django/config/settings/CONTEXT.md`          | Clean on 09/09/2026, 61 tokens, 2 tested as paths   |
| `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`          | Clean on 09/09/2026, 190 tokens, 10 tested as paths |
| `code/src/scripts/development/template-update.sh`     | **New to this sprint** — captured at P0             |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` | **New to this sprint** — captured at P0             |

**What this plan adds to the population, and why it is written the way it is.** Every path in this
plan that does not exist yet — the two migration scripts, the four worktree files, the two test
records, "code/docs/reliability/" — is written in **double quotes, never backticks**, because the
gate reads backticked tokens and a forward reference in backticks is a `[dangling path]` finding
that never converges. Every PM artefact is cited by full relative path, never as a bare `US###`,
`MAP-*`, `QA-*` or `SPRINT-##` token in backticks. Until this file is committed it draws spurious
`[template-only citation]` findings, because `build_template_only()` walks `git ls-files` and an
untracked file never enters the template-only set — the defect US004 exists to repair, and **not**
one to silence with `doc-references: template-only` markers, which `code/docs/FORWARD-VOICE.md`
reserves for a citation that is right and merely unprovable downstream.

---

## Key Decisions

| Decision                                      | Chosen                                                                                                             | Rejected                                                                          | Why                                                                                                                                                                                                                        | Reference                                              |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| Phase order                                   | The gate (P1) **before** the settings (P2)                                                                         | Settings first, gate second                                                       | The discriminating comparison is the new script over the **un-edited** modules; clauses that do not yet exist cannot be run over anything, and there is no reverse comparison because the old script has no clause to fail | `../02-STORIES/US008.md` -> _QA AC — Automated_        |
| Where the preview repair sits                 | Its own phase (P4), before the advisory exists                                                                     | Folded into P5 with the migrations                                                | It proves the repair's **generality** against `v3.0.0`, `v5.0.0` and `v6.0.0`'s third, which is what the ADR says the repair is for; folding it in couples two proofs and hides which one failed                           | `ADR-US008-MITIGATION-OWNS-ITS-CHANNEL` · grilling Q1  |
| Who writes the migration key                  | The story, in P5, derived against `git tag` at that moment; the release re-asserts it against the tag actually cut | A placeholder the release substitutes; the release writing the keyed entry itself | A placeholder is the unverified claim the ADR bans; splitting the two entries across a workflow boundary leaves `copier.yml` half-built with nothing owning the other half                                                 | `ADR-US008-MIGRATION-KEY-DUAL-GATED` · grilling Q2     |
| How the untagged `v7.6.0` slip is handled     | Named once here with its measurement; the story and the ADR left unedited                                          | Correcting both in this change; saying nothing                                    | A story plan has no licence over an `Accepted` ADR or a story, and silence leaves a false premise in two binding records                                                                                                   | Grilling Q3, 18/09/2026                                |
| Where `CSRF_COOKIE_HTTPONLY` lives            | `base.py`, once, with no environment module re-assigning it                                                        | Per-environment assignment in `staging.py` and `production.py`                    | `code/src/django/config/settings/CLAUDE.md:39-41`: a shared value goes in `base.py`, and "an override that happens to match the base value is a future divergence nobody will notice"                                      | Q2 of the story's grilling, 08/09/2026                 |
| Where the `__Host-` names live                | `staging.py` and `production.py`, pasted twice on purpose                                                          | A shared constant; collapsing the duplicated block                                | They are per-environment values; the collapse is held by the `GAPS.md` row of 09/09/2026 (Q9), and the fourteen-to-sixteen-line growth is named by this story and claimed by no row                                        | Q9 · `../02-STORIES/US008.md` -> _Acceptance Criteria_ |
| Whether a pytest test asserts the five values | **No test.** The gate clause is the invariant's one named enforcement point                                        | A pytest assertion over the five settings                                         | `code/docs/NEGATIVE-SPACE.md` forbids a second enforcer of the same rule; `tests/all.sh` runs as a **regression check** that the test settings module still imports, and is reported as what it measured                   | `code/docs/NEGATIVE-SPACE.md` · assessment 7.1         |
| Where the gate clauses live                   | `code/src/scripts/audits/negative-space.sh`, three clauses                                                         | A new `audits/` script; a clause in an existing narrower gate                     | A new audit costs counted lines in `code/src/scripts/audits/CONTEXT.md`, which sits at **299 of 300** and which Q3 forbids this story to touch; the three clauses join a gate whose CI path filters already cover them     | Q3, Q7 · P0's length reading                           |
| The clause names                              | Three names, not one                                                                                               | One `cookie-doctrine-broken` clause                                               | The three ways to break the doctrine are three different repairs, on the `key-unraised` / `key-unregistered` / `key-duplicated` precedent                                                                                  | `../02-STORIES/US008.md` -> Scenario 3                 |
| The absence clause's scope                    | `*.py` under the directory, stated                                                                                 | "Every module under the directory"                                                | The directory holds `CONTEXT.md` and `CLAUDE.md` too; they are protected by the anchoring, and an implementation detail is not a boundary                                                                                  | AC-GAP-4 · EC-03, EC-05                                |
| Whether a gate clause covers the edge header  | **No clause.** The requirement goes to the deployment contract                                                     | A `negative-space.sh` clause asserting `SECURE_PROXY_SSL_HEADER` is assigned      | The setting is already present in both modules; the risk is entirely the other side of the seam, so a green clause would measure nothing in doubt — the false green `code/docs/GATE-REPORTING.md` names                    | `ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION` Option D |
| The advisory's gating                         | Two entries — one state-gated and unversioned, one version-keyed                                                   | One version-keyed entry; one unversioned entry; holding for the next MAJOR        | The two halves are true for different reasons and a single gate can only be correct about one; both precedents are already in `copier.yml` at `:827-829` and `:889`/`:903`                                                 | `ADR-US008-MIGRATION-KEY-DUAL-GATED` Option C          |
| The unversioned entry's silence               | Silent when it finds nothing                                                                                       | Bannering unconditionally, as the two shipped advisories do                       | It runs on every update for the life of the template; an entry that always runs must cost nothing on the updates where it has nothing to say                                                                               | Same ADR                                               |
| How this plan names what does not exist yet   | Double quotes                                                                                                      | Backticks; a `template-only` marker                                               | The citation gate reads backticked tokens; the marker is for a citation that is right and unprovable downstream, not for a dangling one                                                                                    | `code/docs/FORWARD-VOICE.md` · US006's precedent       |
| Who writes the records and register entries   | `22-implementation-documentation`                                                                                  | This story                                                                        | `REFERENCES.md`'s ownership table gives them to `22`; a story that writes its own register entry produces two owners for one file                                                                                          | `REFERENCES.md` -> _Ownership boundaries_              |

---

## Dependencies

| Story | Deliverable it owns                              | Required for                                                                                                                                                                              | Current state |
| ----- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| US009 | `install.sh` as the sole hook-arming path        | Nothing here. The other SPRINT-05 member, built **second** and the stretch tier; **shares no file** — verified 17/09/2026 across US001 to US008                                           | `Open`        |
| US004 | The citation gate's git-index repair             | Nothing here **blocks**. It would retire the baseline-diff regime, but it has not landed, so this story is on that branch unconditionally — unlike US006, which had to name both branches | `Open`        |
| US002 | `code/src/scripts/audits/CONTEXT.md` headroom    | Nothing here — this story leaves that file unchanged, which is **why** the three clauses join an existing gate rather than a new one (Q3)                                                 | `Open`        |
| US003 | "code/docs/ABSENCE.md"                           | Nothing here — non-collision recorded; this story writes into none of it                                                                                                                  | `Open`        |
| US001 | "code/docs/reliability/", the family             | Nothing here — non-collision recorded. It is the one legitimate `[dangling path]` several records in this tree carry, and it is US001's to clear                                          | `Open`        |
| US005 | Retry doctrine into "code/docs/reliability/"     | Nothing here — shares no file                                                                                                                                                             | `Open`        |
| US006 | The posture guard across six scripts             | Nothing here. **Adjacent, not blocking:** it edits `code/src/scripts/` as this story does, but not `negative-space.sh` and not `template-update.sh`                                       | `Open`        |
| US007 | One owner for the story `**Status:**` vocabulary | Nothing here blocks. It settles the vocabulary this plan's `Status` cell uses; `Open` is a value in every set in circulation                                                              | `Open`        |

**The `Current state` column is the one the parallel-worktree DAG reads**, and every row is `Open`
today — and none is a blocker, which is why this plan's own status is `Open` rather than a
judgement call.

- **Blocked by:** **none.** `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md` records
  `Frontier open: 0 · Blocking open: 0 · Resolved: 26` and slice `S-02`'s Nodes cell reads
  `— (all settled)`. No story in the backlog edits
  `code/src/django/config/settings/`, `code/src/scripts/audits/negative-space.sh`,
  `code/src/scripts/development/template-update.sh`, `copier.yml` or any of the five guides. US004
  edits `code/src/scripts/audits/doc-references.sh`, which this story only **runs**.
- **Blocks:** **`S-01` on the same map.** Its rule section "defers cookie scope to
  CRYPTO-AND-DATA.md", and the deferral is only true once this story makes it true — which is why
  the map's own build order puts `S-02` first. It does not pre-empt `S-01`'s rule-section filename
  or content. Nothing else in the backlog waits on it.
- **Shares one file with `S-04`, named at cutting.** `S-04` re-casts
  `code/docs/URL-STRATEGY.md`'s Phase 2 table (`:72-86`); this story rewrites the same file's
  `## CORS and session scope` bullet at `:149-153`. Different sections, one file: **whichever lands
  second re-reads the other's text before editing.** `S-04` is not cut into a story and
  `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Won't (this sprint)_ closes this record to it.
- **Runs beside, blocks neither:** US009 — the other member of this record, on a different map,
  sharing no file. Both sessions stage path-scoped; the sprint record and this sprint plan are the
  artefacts they share.
- **One sprint-level prerequisite that is no story's:** `v7.6.0` tagged at `16aac54`. It gates
  **P5 only** — every other phase is reachable without it — and it belongs to the `release` and
  `version` skills. Stated here because a plan whose `Status` reads `Open` must say what the one
  thing ahead of it is.
- **Can be done now:** **P0 to P4, once the branch exists** — the baselines, the gate, the
  settings, the guides and the contract clause, and the preview repair, with nothing inside them
  waiting on another story. **P5 waits on the tag**, and on P2 and P4 for its proofs. If the tag
  slips, P0 to P4 still land and P5 is the only outstanding phase — which is also the shape that
  makes US009 droppable without failing the sprint.

---

## GDPR

**Not applicable.** The `GDPR` flag reads `N/A`. Two strictly-necessary cookies are hardened: no
personal data is collected, no new store is introduced, no consent surface changes and no retention
window moves. Section dropped rather than filled with "none" per row.

**One adjacent thing is not GDPR and should not be filed as it.** A session cookie **is** an
identifier, and this story narrows which hosts may read it. Narrowing who can read an existing
identifier is a security change, not a data-protection one — `../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md`
Section 5 and the sprint plan's GDPR row both say so, and it is discharged under _Security_ below.

---

## Security

**Live, and it is the whole subject of the story.** Fifteen threats across **all six** STRIDE
categories over seven trust boundaries — **0 CRITICAL, 0 HIGH, 9 MEDIUM, 4 LOW, 2 INFO** — so
nothing gated sprint planning and nothing escalated to
`../10-SECURITY/VULNERABILITIES/PLANNING/`.

> **That zero is a measured outcome with its reason, never "the security gate passed."** Every
> threat resolves to `MEDIUM` or below **because this repository deploys nothing and no generated
> project is known to be live**. Section 3a of
> `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` names the
> event that promotes each, and **five promote to `HIGH`**, four of them the moment a generated
> project deploys or updates. Seven of the fifteen rows have **no attacker at all** — they are the
> doctrine mis-delivered, the gate mis-scoped, or a deploy consequence nobody is told about — so a
> `MEDIUM` here does not mean "an adversary would find this hard".

**No endpoint, no mutation, no protected action in the web sense** — so the template's
permission-check and IDOR rows have no subject and are recorded as such rather than left blank.
**The authorisation boundary is the browser's cookie jar**, and the subject is which host may write
a credential the apex will honour. `../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` Section 4
puts it exactly: the story has more access-control content than any story in this backlog so far,
and none of it is expressible as a `PA-nn` row.

| Check                            | Requirement for this story                                                                                                                                                   |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AuthN / AuthZ                    | Unchanged. No credential, session-issuance or MFA path moves. What moves is the **scope** of the two cookies an existing session already uses                                |
| Endpoint permission checks (A01) | **No subject** — no endpoint is added or changed. A01:2025 is nonetheless the dominant category, at the cookie-jar boundary rather than the view layer (TM-01, TM-02, TM-03) |
| IDOR                             | **No subject** — no user-supplied identifier is accepted anywhere in this story                                                                                              |
| Input validation                 | **No subject** in the request sense. The advisory's input is the project's own settings tree, and it **reads and reports**, never parses a value                             |
| Secrets                          | The two `__Host-` names are literals by design and are not secrets. `DEBUG` is untouched in every module. No `.env` content moves                                            |
| Rate limiting                    | **No subject**                                                                                                                                                               |
| Dependencies                     | **None added.** Django's own middleware source is read at three lines to verify a mechanism; no version moves                                                                |

### The thirteen constraints, carried in and not re-derived

`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` Section 7 numbers
thirteen; `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md`
Section 4b carries eleven, and **the two sets are not congruent**: 4b splits 7.3 and 7.4 into two
items each, and carries **no** counterpart to 7.2, 7.5, 7.8 or 7.11 — 7.5 and 7.11 sit in the
model's Section 4a as open questions Q2 and Q1, settled at `15-decisions` by two of the ADRs of
17/09/2026. The assessment's thirteen are the superset and are what this plan discharges. Its own
Section 7 opens "Eleven constraints" and closes "None of the thirteen"; the item count is thirteen,
and correcting that opening line belongs to `10-security-checks`. Each is discharged
in a named phase.

| #    | Constraint                                                                                       | Phase             | Discharged by                                                                                                                                                                                                  |
| ---- | ------------------------------------------------------------------------------------------------ | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1  | The prefix's three preconditions satisfied **in the same module**                                | P1/P2             | `cookie-host-prefix-absent` — presence and absence, never a read                                                                                                                                               |
| 7.2  | The doctrine binds **every TLS-serving module**; each clause names what it read in its skip note | P1/P3             | The skip-note rule, plus the owner guide's statement of the rule                                                                                                                                               |
| 7.3  | No `*_COOKIE_DOMAIN`, no non-`/` `*_COOKIE_PATH`; every match assignment-anchored                | P1                | `cookie-scope-widened`, scoped to `*.py` and anchored at line start                                                                                                                                            |
| 7.4  | `:92` and `:481` move together; each clause skips with a note                                    | P1                | One change; the `:407` idiom on all three clauses                                                                                                                                                              |
| 7.5  | `SECURE_PROXY_SSL_HEADER` stated as a **precondition** of the doctrine                           | P3                | The owner guide with the corrected mechanism, **plus the `EDGE-REQUIREMENTS.md` Section 6 strip-the-header clause and its verification entry** — Option C, both halves; Option B, the guide alone, was refused |
| 7.6  | The owner carries **three** limits, not two                                                      | P3                | Per cookie name · pre-prefix browsers · `HttpOnly` is not anti-XSS                                                                                                                                             |
| 7.7  | The owner states what the gate **can and cannot** see                                            | P3                | The three invisible assignment sites, named                                                                                                                                                                    |
| 7.8  | The dev/TLS name divergence stated in the **owner guide**, not only the advisory                 | P3                | Every project reads the guide; only an updating one runs the advisory                                                                                                                                          |
| 7.9  | The advisory names both directions of the invalidation and the cutover shape                     | P5                | The keyed entry's notice — rollback, and rolling is unsafe                                                                                                                                                     |
| 7.10 | No silencing annotation on the three clauses                                                     | P1                | `code/src/scripts/audits/CONTEXT.md:174`'s standing rule                                                                                                                                                       |
| 7.11 | **The advisory reaches its operator**                                                            | P4 + P5           | The preview repair, proved generally at P4 and re-proved carrying the cookie advisory at P5                                                                                                                    |
| 7.12 | The advisory prints paths, lines and setting names — **never a value**                           | P5                | Both scripts, on the US006 7.11 shape                                                                                                                                                                          |
| 7.13 | The key names the release the doctrine ships in, and that release is tagged                      | P5 + `24-release` | The entry and its derived-at-release comment in P5; the key and the tag at `24-release`, in one act                                                                                                            |

**7.11 and 7.13 are the two to read first**, on the assessment's own instruction: 7.11 changed the
story's scope rather than its text, and 7.13 invalidated a record the story already rested on.

### The register under-count, recorded as a cost rather than an oversight

`code/src/scripts/audits/CONTEXT.md:174` enumerates the clauses and says "Twelve `[gate: fail]`".
After this story there are **fifteen** and the cell under-counts by three. That is a **named cost
of Q3**, not an oversight: the file's docs-length allowance at `:8` expires 01/12/2026, US002 owns
its headroom, and the file sits at **299 of 300** as the gate measures it. The repair — extending
the existing cell in place, which costs no counted line however much prose it gains — belongs to
whoever next edits that file, with the register at `:170` the first thing they touch. TM-09 records
it as a quiet false negative, because the register is what a reader consults to learn what the gate
checks.

---

## Logging & Observability

**Not applicable as a flag** — `Logging: N/A`. The story adds no log line and wires no sink. The
advisory prints to a terminal, which is a report and not a log.

**One residual is named rather than left to be discovered at 3am** (TM-13). A browser silently
discards a malformed `__Host-` cookie: no error, no header, no log — the user is simply not logged
in and the server sees an anonymous request. **There is no detection anywhere for the failure this
story can cause**, and `code/docs/security/AUDIT-TRAIL.md` covers application events rather than a
browser's storage decision. Accepted residual, and the reason the advisory's wording is the whole
of the user-facing experience of a botched delivery.

---

## Performance, Rendering, Responsive & Accessibility

**Not applicable** — no rendered surface, no route, no upload, no user-owned table, so the
scale-readiness row has no subject either. The story adds no infrastructure dependency, so
`how-to/src/PLATFORM-PROVIDERS.md` gains no row.

**One edge requirement is added and it is a contract term, not a provisioning change.** The
`X-Forwarded-Proto` clause in `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 joins
the sibling headers that section already governs. It must be **reported as a contract term and
never as "the header is handled"** — this project's posture is `<%DEPLOYMENT_POSTURE%>` and that
section's own status reads "TBD — set per deployment".

**Accessibility is `N/A` and one thing sits beside it.** The story renders nothing; its outputs are
a gate finding in a terminal, an advisory in a terminal and Markdown in an editor. But the failure
mode it can cause is **invisible by design** — a rejected cookie gives the user no message at all —
which is why the manual walk reads the advisory as an operator would rather than only checking it
ran.

---

## Implementation Workflows & Standards

### PM workflow chain

`02-story-creation` ✅ (09/09/2026) → `10-security-checks` ✅ (`Draft`, 17/09/2026, grilling
deferred by direction) → `11-qa-checks` ✅ (`Reviewed`, 17/09/2026, ten gaps all `[RESOLVED]`) →
`15-decisions` ✅ (three ADRs `Accepted`, one superseded, 17/09/2026) → `03-sprint-planning` ✅
(record opened 09/09/2026, US009 admitted 17/09/2026) → `16-sprint-plans` ✅ (17/09/2026) →
**`17-story-plans` (this document)** → the lane below → `22-implementation-documentation` →
`23-pr-and-review` → `24-release`.

**A partial code lane, and this sprint's first.** `19-backend-code` applies — the story's `Backend`
flag reads `Yes` and it ships Python under `code/src/django/`. `20-api-code` and `21-frontend-code`
read `N/A`; the story's `API` and `Frontend` flags say so, and
`../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Phase Breakdown_ records both phases as `N/A` with
their reasons. The lane the story actually runs in is the six-phase plan above, entered at `19`.

**The gates were taken in an order the sprint plan records and this plan does not re-argue.** `10`
and `11` were written for both SPRINT-05 members on 17/09/2026 **before** the decisions, at
<%DEVELOPER_NAME%>'s direction; the interview ran later the same day at `15-decisions`, which is
where all nineteen gaps across the two members were settled and fed back. Each artefact records the
deviation in its own header, and neither gate's status word is upgraded here.

### Code workflows invoked

| Workflow                                | When                                                                                                                                                                                                                                                                       |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/workflows/01-implement-story/`    | The build spine, entered at P1. Its models-and-migration, service and endpoint steps have **no subject** here and are recorded as skipped with that reason                                                                                                                 |
| `code/workflows/02-tdd-cycle/`          | ✓ — P1's fixtures are the red state and the clauses green them; P4's preview proof is red before the report block exists                                                                                                                                                   |
| `code/workflows/08-security-hardening/` | ✓ — the story ships a security control; the pre-PR pass re-reads 7.1 to 7.13 against the shipped settings, gate, guides and advisories                                                                                                                                     |
| `code/workflows/07-review/`             | ✓ always — the code-content review before the PR                                                                                                                                                                                                                           |
| `code/workflows/11-refactor/`           | Only if the three clauses surface duplication worth lifting into a shared helper — a separate commit, behaviour unchanged                                                                                                                                                  |
| `code/workflows/10-debug/`              | A reproducible defect found by a walk-through — failing case first                                                                                                                                                                                                         |
| `code/workflows/03-database-migration/` | **N/A** — the word "migration" here means a copier `_migrations:` entry. `project-management/docs/git/MIGRATION-GATES.md` is **not** cited anywhere in this change: it sounds governing, covers database migration review gates, and contains zero occurrences of "copier" |

### Standards gates

Every command through `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`, `pytest`,
`pnpm`, `uv` or `docker` call. British English, DD/MM/YYYY, the U+00A7 ban and plain-ASCII
punctuation per `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2. Cross-artefact
citations by full repo-relative path.

- **Python** (`code/docs/BACKEND-CODING-PRINCIPLES.md`): module-level assignments only; ruff and
  basedpyright both run, and **`check.sh` is not `N/A` for the first time in this backlog**.
- **Shell** (`code/src/scripts/_lib/CLAUDE.md`, and the six advisories' own convention):
  `set -euo pipefail`; both migration scripts `exit 0` always; the `template-update.sh` block
  additive and changing no exit code.
- **Documentation**: nothing born at or above 270 code lines and nothing edited crossing it without
  a dated allowance (`code/docs/DOCUMENTATION-LENGTH.md`); the `config/settings/` pair edited on one
  half and kept whole (`code/docs/DOCUMENTATION-PAIRING.md`);
  `code/src/scripts/audits/CONTEXT.md` **not grown** from 299.
- **Delimiters**: the `copier.yml` entries are written without spelling the Jinja delimiter pair in
  any PM artefact, because `.github/scripts/check-template-tokens.sh` scans this folder.

---

## Execution & Verification via Claude Dynamic Workflows

Every session runs with ultracode on, and **the internal procedure comes first**
(`.claude/CLAUDE.md` Section 2.7): the dynamic workflow supplies the fan-out and the adversarial
verification, and the steps come from the folders named here.

- **Stage 0 — plan verification.** `17-story-plans` Step 9: two or three independent adversarial
  reviewers over this plan before it is treated as codeable — missing constraints, wrong doc
  references, a proof mapped to the wrong phase, a dependency-order error, an unscoped deferral.
  Findings resolved in this file. **If the reviewers cannot be dispatched, the review is recorded
  as not run** (`code/docs/GATE-REPORTING.md`), never written up as passed.
- **Stage 1 — build.** P0 first and alone. Then P1 as one TDD loop, the fixtures red before the
  clauses green them, closing with the pre-change capture. Then P2, then P3. **P4 fans out in
  parallel with P1 to P3** — it waits only on P0 — and P5 serialises behind P2 and P4.
- **Stage 2 — continuous verification.** After every meaningful change:
  `bash code/src/scripts/audits/negative-space.sh --self-test`, then the unscoped run;
  `bash code/src/scripts/syntax/lint.sh`; `bash code/src/scripts/syntax/check.sh` over the three
  modules; `bash code/src/scripts/audits/docs-length.sh`;
  `bash code/src/scripts/audits/docs-pairing.sh`;
  `bash code/src/scripts/audits/doc-references.sh --path code/docs`; ShellCheck by hand over
  `negative-space.sh`, both migration scripts and `template-update.sh`, recorded as run or not run.
- **Stage 3 — review.** `code/workflows/07-review/` driven by the `review` and `security` skills,
  each finding adversarially verified before it is acted on. **The one review question that matters
  here** is whether the owner guide's three limits and its statement of the gate's reach survived
  the edit intact — those are the sentences the whole doctrine's honesty rests on.
- **Stage 4 — behavioural verification.** The five manual walks under _Testing_. A tester other
  than the author signs.
- **Stage 5 — PR and release.** `07-review` clean → `22-implementation-documentation` writes the
  records → `23-pr-and-review` → `24-release`, where the key is re-asserted against the tag.

---

## Quality Gates, Scripts & Local↔Docker Alignment

**Governing rule.** All developer operations use the wrapper scripts in `code/src/scripts/**/*.sh`.
This story is unusual in that one of its deliverables **is** one of those wrappers
(`template-update.sh`) and another is one of the audits (`negative-space.sh`).

| Need                       | Command                                                                                          | Runs                            |
| -------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------- |
| The gate's own proof       | `bash code/src/scripts/audits/negative-space.sh --self-test`                                     | Local — `--path` is refused     |
| The gate over this tree    | `bash code/src/scripts/audits/negative-space.sh`                                                 | Local, unscoped                 |
| Python lint                | `bash code/src/scripts/syntax/lint.sh --file-type python --path code/src/django/config/settings` | Both                            |
| Python typecheck           | `bash code/src/scripts/syntax/check.sh`                                                          | Docker                          |
| Markdown lint / format     | `bash code/src/scripts/syntax/lint.sh --file-type markdown` · `format.sh`                        | Both                            |
| Citation gate — criterion  | `bash code/src/scripts/audits/doc-references.sh --path code/docs`                                | Local                           |
| Citation gate — whole tree | `bash code/src/scripts/audits/doc-references.sh`                                                 | Local — recorded, never claimed |
| Length gate                | `bash code/src/scripts/audits/docs-length.sh`                                                    | Local                           |
| Pairing gate               | `bash code/src/scripts/audits/docs-pairing.sh`                                                   | Local                           |
| Doctrine regression guard  | `bash code/src/scripts/audits/doctrine-drift.sh`                                                 | Local                           |
| Tests (regression)         | `bash code/src/scripts/tests/all.sh [--coverage]`                                                | Docker                          |
| The dev-stack cookie walk  | `bash code/src/scripts/development/server.sh up`                                                 | Docker                          |
| The preview proofs         | `bash code/src/scripts/development/template-update.sh` against a scratch copy                    | Local                           |
| Worktree `/etc/hosts`      | `bash code/src/scripts/development/hosts-story-add.sh us008`                                     | Local                           |

**Three things are not wrappers and are recorded as such.** **ShellCheck** has no project script —
run by hand, or recorded as not run, never as a `lint.sh` pass. **`migrate.sh check`** is `N/A`:
this story writes no Django migration. **`doctrine-drift.sh`** runs as a regression only — it reads
fenced code and no claim row in its table covers a settings line, so it **cannot see** the two guide
blocks this story edits and is never reported as though it had looked.

**The template's two raw-command exceptions** (`pnpm exec`, `uv run`) are not exercised by this
story.

---

## Testing

**One coverage floor does not apply, and the reason is a doctrine rather than an exemption.**
`code/docs/TESTING.md` sets 75% line and branch (90% auth), and **no new Python test is written for
the five settings values, deliberately**: the gate clause is the invariant's one named enforcement
point (`code/docs/NEGATIVE-SPACE.md`), and a pytest assertion over the same five values would be a
second enforcer of the same rule, which is the shape that guide forbids.
`bash code/src/scripts/tests/all.sh --coverage` runs as a **regression check** — the test settings
module still imports and every existing test passes — and is reported as what it measured. No floor
claim is made over the three edited modules; they are configuration with no branch to cover.

### The executable surface — `negative-space.sh --self-test`

| Test                  | Assertion                                                                                                            |
| --------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `--self-test` exit    | Exits 0; `EXPECTED` holds **fourteen** names                                                                         |
| `broken/settings/`    | Trips **all three** new clauses                                                                                      |
| `clean/settings/`     | Trips **none**                                                                                                       |
| Fixture inertness     | The **eleven pre-existing** clause names behave exactly as before — asserted, not assumed (AC-GAP-9, EC-07)          |
| Missing fixture       | Still `exit 2` with its message — never a silent pass (`:492-493`, unchanged)                                        |
| Anchoring             | A commented `# SESSION_COOKIE_DOMAIN = ...` is **neither a finding nor a pass**; so is the widened `base.py` comment |
| `CONTEXT.md` in scope | Not read as a module — the clause's scope is `*.py`, stated rather than inferred                                     |
| Empty `__init__.py`   | No finding and no crash                                                                                              |
| Absent module         | **Skips with a note** naming what it read — never reported as clean                                                  |

### The discriminating comparison — recorded, and one-directional

- The **new** script over the settings modules **before** P2 reports all three clauses (captured at
  P1's close).
- The **new** script over the modules **after** P2 reports none.
- **There is no comparison the other way round**, and the plan says so explicitly so it is never
  claimed: the old script has no clause for a fixture to fail against.

### The unscoped run

`bash code/src/scripts/audits/negative-space.sh` exits 0 on this tree after P2, **with none of the
three clauses in its skip notes** — they ran, they did not skip. A clause that skipped and a clause
that passed print differently and must never be read as the same thing (assessment 7.4).

### API / contract · browser e2e · component tests

**N/A, each with its reason.** No `/api/*` endpoint, so no Bruno `.bru` flow. No template,
component or partial, so no rendering test. No screen, so no `e2e-py.sh` journey and no axe scan.
The HTMX CSRF path **is** exercised — by hand, in the dev-stack walk below, because it is a browser
behaviour and this repository's e2e suite has no cookie assertions.

### Manual testing — five walks, all load-bearing

Captured in "project-management/src/18-TESTS/US008-MANUAL-TESTING.md", written by
`22-implementation-documentation`.

1. **The baseline capture and its close** — the whole-tree citation figure by identity with the
   detector's `git hash-object` beside it, taken before the first edit and re-asserted at close;
   every `>` line at close classified by whether its file is in this story's edit set. **A count is
   never the test.** A differing hash is reported as detector-confounded, never as this story's.
2. **The five-document read-across** — each of the five states the rule or defers to the owner; the
   `CORS_ALLOWED_ORIGINS` sentence confirmed **verbatim**; the seven cookie-mentioning bystanders
   re-read and recorded harmless; `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md:47-50` recorded as
   noted and left.
3. **The advisory dry run, three states** — against a scratch copy with `SESSION_COOKIE_DOMAIN`
   planted in `staging.py`, it names that file and line and its setting, prints its operator notes,
   **prints no value from the file**, and exits 0; against the clean tree it prints nothing and
   exits 0; with the settings directory removed it exits 0 early and prints nothing.
4. **The preview proof, inverted from what the story first specified** (AC-GAP-2). A **successful**
   `template-update.sh` preview shows the migration report in its own output, **before** the
   "Preview only — your project is unchanged" line at `:275`. Run twice: at P4 against the three
   advisories already shipped blind, and at P5 with the cookie advisory in place.
5. **The dev-stack cookie walk** — `server.sh up`, log in at `/control/`, submit a form, fire an
   HTMX write; all three succeed; the browser shows plain names in dev and `HttpOnly` on the
   `csrftoken` cookie; no console error.

**Two scenarios cannot be run here and are recorded rather than omitted.** `PA-01` and `PA-02` in
the QA plan — a sub host attempting to overwrite the apex's cookie, against the post-change and
pre-change apex — **need two hosts and a real browser, which this repository has neither of**. They
are the doctrine's defining test, and the settings assertions are a proxy for them. **A proxy is
not the thing**, and no record may report them as run.

**A tester other than the author signs the walk-through off.**

---

## Documentation Write-Ups (Implementation Records)

| Record                                     | Destination                                                                         | Produced by                           | This story                                                                                                                                                                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------- | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **This plan**                              | `../17-STORY-PLANS/`                                                                | `17-story-plans`                      | **Always** — this file                                                                                                                                                        |
| User story                                 | `../02-STORIES/US008.md`                                                            | `02-story-creation`                   | **Always** — exists                                                                                                                                                           |
| Sprint plan                                | `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`                                           | `16-sprint-plans`                     | **Always** — exists; this plan repoints two tables                                                                                                                            |
| ADRs                                       | `../15-DECISIONS/`                                                                  | `15-decisions`                        | **Always** — **five** bind this story, one superseded; the sprint's set of six includes US009's. **No new ADR is raised by this plan**; **no new ADR is raised by this plan** |
| Threat model (planning)                    | `../10-SECURITY/THREAT-MODEL/PLANNING/`                                             | `10-security-checks`                  | **Always** — exists, `Draft`                                                                                                                                                  |
| Assessment (planning)                      | `../10-SECURITY/ASSESSMENTS/PLANNING/`                                              | `10-security-checks`                  | **Always** — exists, thirteen constraints                                                                                                                                     |
| Threat model / assessment (implementation) | `../10-SECURITY/**/IMPLEMENTATION/`                                                 | `22-implementation-documentation`     | **Always** — re-assesses the fifteen threats                                                                                                                                  |
| QA plan (pre-dev)                          | `../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md`                              | `11-qa-checks`                        | **Always** — exists, `Reviewed`                                                                                                                                               |
| QA implementation review                   | `../11-QA/IMPLEMENTATION/`                                                          | `23-pr-and-review`                    | **Always**                                                                                                                                                                    |
| Test status / manual testing               | "project-management/src/18-TESTS/US008-TEST-STATUS.md" · "…US008-MANUAL-TESTING.md" | `22-implementation-documentation`     | **Always** — `22`'s, not this story's                                                                                                                                         |
| Code review record                         | `../19-REVIEWS/`                                                                    | `23-pr-and-review` / code `07-review` | **Always**                                                                                                                                                                    |
| Release (version bump)                     | root `VERSION`, `CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md`                 | `24-release`                          | **Conditional** — a MINOR bump carries this doctrine                                                                                                                          |
| GDPR · SEO · API design · Logging · Schema | —                                                                                   | —                                     | **Not required** — each flag reads `N/A`                                                                                                                                      |
| Bug / refactoring record                   | `../21-BUGS/` · `../22-REFACTORING/`                                                | code `10-debug` · `11-refactor`       | **Conditional** — only if a walk surfaces one                                                                                                                                 |

**`22-implementation-documentation` owns every `GAPS.md` write**, and this sprint has three:
the **closure** of the 09/09/2026 preview-blindness row that P4 repairs, and the two **openings** of
17/09/2026 — `shared-ai-symlinks.sh`'s missing register row, and the eleven unsuppressed
`pnpm install` invocations US009 declines. The 09/09/2026 rows and the corrected `:454` figure were
written **in the same change as the story**, a disclosed departure from `22`'s ownership, and are
not rewritten here.

---

## CONTEXT.md & Index Updates

| File                                                   | Change required                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`              | Point US008's row in _Story Plans — the code master_ at this file, replacing `_none yet — 08- reserved_`; fill the Stories table's `Story plan` and `Git branch` cells; fill the _Branch Naming Reference_ row with `us008/host-only-cookies`                                                                                                                                                                                                                          |
| `../02-STORIES/US008.md`                               | Add the story-plan citation, in the form US006 and US007 use — its _Decisions_ section currently reads "**No story plan is cited yet**"                                                                                                                                                                                                                                                                                                                                |
| `code/src/django/config/settings/CONTEXT.md`           | Six rows in the Critical Settings table; the Module Map's `staging.py` cell naming the `__Host-` divergence; **Last Updated** refreshed. `code/src/django/config/settings/CLAUDE.md:23-24` makes the table update compulsory                                                                                                                                                                                                                                           |
| `code/src/scripts/audits/CONTEXT.md`                   | **Not edited** (Q3). The `:170` under-count is a named cost, recorded in the test record                                                                                                                                                                                                                                                                                                                                                                               |
| `project-management/workflows/24-release/CHECKLIST.md` | **One checklist line**: re-derive every version-keyed `copier.yml` `_migrations:` key against the tag about to be cut, with `git tag --sort=-v:refname \| head -1`, and write it in the same act as the tag. Measured 18/09/2026, that workflow's `STEPS.md` and `CHECKLIST.md` contain zero occurrences of `migration`, `copier` or `key` — **this is the channel this story's own key is delivered through** (`ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`) |
| `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`           | One register row per migration entry                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`  | The Section 6 clause plus a post-deploy verification entry                                                                                                                                                                                                                                                                                                                                                                                                             |
| `../17-STORY-PLANS/CONTEXT.md`                         | **Nothing added.** It ships, and its _The plans index_ section records that it holds no index by decision                                                                                                                                                                                                                                                                                                                                                              |
| `GAPS.md` / `DEFERRED.md`                              | `22-implementation-documentation`'s — one closure, two openings. **Not this story's to write**                                                                                                                                                                                                                                                                                                                                                                         |

**No new directory is created outside the fixtures tree**, so no new `CONTEXT.md` / `CLAUDE.md`
pair is owed. `broken/settings/` and `clean/settings/` are exempt from `docs-pairing.sh`'s Check 10
by rule — `is_exempt_from_enumeration()` at `code/src/scripts/audits/docs-pairing.sh:227-237`, the
reason at `:218-226`: "a pair added inside one becomes live input to the audit reading it". **The
pass is the exemption doing its job rather than an absence of new directories**, and must be
reported that way.

---

## Status Propagation & ClickUp Sync

On every transition, set the same canonical value everywhere, in this order:

| #   | Artefact                                | Where the status lives                                     |
| --- | --------------------------------------- | ---------------------------------------------------------- |
| 1   | **Story (source of truth)**             | `../02-STORIES/US008.md` -> `**Status:**`                  |
| 2   | **This plan**                           | The `Status` cell in the metadata table above              |
| 3   | **Sprint plan — story-plan row**        | `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` -> _Story Plans_ |
| 4   | **Sprint record**                       | `../03-SPRINTS/SPRINT-05.md` -> Story Summary              |
| 5   | **Sprint plan — Stories table and DoD** | `../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`                  |
| 6   | **ClickUp export (generated)**          | Regenerated, never hand-edited                             |

```bash
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US008
```

---

## Deferred Items

- **The six-target map re-cut** — `:116`, `:118`, `:119`, `:120`, `:211` and `:447` of
  `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md`, each placing the cookie build on the slice N-019
  gates. A separate `01-feature-map` correction on <%DEVELOPER_NAME%>'s 09/09/2026 ruling, filed
  with that list. **Nothing in this story depends on the re-cut having happened.** Target: a
  `01-feature-map` change.
- **Collapsing the two near-duplicate guide settings blocks** — `code/docs/security/AUTH-AND-AUTHZ.md:133-140`
  and `code/docs/security/OWASP-AND-CHECKLIST.md:44-52`, whose bodies differ by exactly one hunk.
  Held by the `GAPS.md` row of 09/09/2026 (Q9). Target: whoever takes that row.
- **The byte-identical `staging.py:9-22` / `production.py:9-22` block** behind them, growing to
  sixteen lines in this story. Named by the story and **claimed by no row** — a settings-module
  refactor is not this story's. Target: future.
- **`code/src/scripts/audits/CONTEXT.md:174`'s clause register**, under-counting by three after
  this story. Target: whoever next edits that file.
- **`shared-ai-symlinks.sh`'s missing `06-GENERATION.md` register row** — incomplete since
  14/09/2026. This story establishes the **form** a row with no version takes; it does not backfill.
  A `GAPS.md` row of 17/09/2026. Target: whoever takes that row.
- **A `SameSite` gate clause** — owned in prose at `code/docs/security/CRYPTO-AND-DATA.md:120-121`,
  satisfied by Django's `Lax` default, read by no script. Target: a later story.
- **Retiring the unversioned migration entry** — see below.

### Accepted residuals — not deferred, and nobody is coming back to these

**These are accepted, not scheduled.** No story owns them and none is expected to; the owner guide
states each so the next reader is not surprised by it.

- **The `messages` and language cookies** (TM-07) — unprefixed and subdomain-writable after this
  story. The doctrine names session and CSRF, and says so.
- **The three assignment sites outside the scanned directory** (TM-08) — a runtime
  `django.conf.settings` write, an environment-driven value, a settings module outside the
  directory. The owner guide states the gate's reach rather than closing them.
- **No detection for the failure this story can cause** (TM-13) — a browser discards a malformed
  `__Host-` cookie in silence. `code/docs/security/AUDIT-TRAIL.md` covers application events, not
  a browser's storage decision.
- **`SECURE_SSL_REDIRECT`'s wider dependence on `X-Forwarded-Proto`** — it governs every response
  the deployable serves, not only cookies. `ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md`
  scopes itself to the cookie doctrine and names the wider exposure. Target: a security-hardening
  pass over the deployed surface, when there is one.
- **The `EDGE-REQUIREMENTS.md` clause surviving regeneration** — `how-to/src/SERVER-ARCHITECTURE/`
  is a snapshot regenerated by `scale-planning`, so the clause must survive the next regeneration
  or be re-added, **an obligation nothing enforces today**. Target: future.
- **A ShellCheck leg in `lint.sh`** — no project script runs it, so this story runs it by hand. No
  story owns adding one. Target: future.
- **Retiring the unversioned migration entry** — it runs on every `copier update` for the life of
  the template and nothing retires it. A later record may judge the class closed once no supported
  project can carry the old mandate; **that is a decision with no evidence available today.**
  Target: future — a template-lifecycle review, when no supported project can still carry the old
  mandate.
- **The eleven unsuppressed `pnpm install` invocations** — US009's declined Option D, `GAPS.md`
  from 17/09/2026. Not this story's at all; named so the two members' deferrals are not merged.
  Target: US009, or whoever takes that `GAPS.md` row.

---

## Risks

| Risk                                                                                                                                                 | Likelihood | Impact | Mitigation                                                                                                                                                                                                                                  |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The settings land before the clauses exist, so the discriminating comparison can never be captured and the gate's discrimination is never proved     | Med        | High   | P1 precedes P2 by construction; the capture is P1's closing act; the Definition of Done names both halves and states that no reverse comparison exists                                                                                      |
| `:92` is widened without repointing `:481`, so the self-test proves a different shape than the real run                                              | Med        | High   | Named as one change in P1, in _Key Decisions_, in the DoD and in assessment 7.4; it is the defect the script's own header says it refuses at the parser                                                                                     |
| The new `settings/` fixtures trip the constraint or key-register clauses, and `EXPECTED` passes or fails for the wrong reason                        | Med        | Med    | `:252` excludes `*/tests/*` + `*/migrations/*` and `:278` excludes `*/tests/*` + `conftest.py`, and **neither** excludes `*/settings/*`; the fixtures contain cookie settings only, and the eleven names are asserted unaffected (AC-GAP-9) |
| The `CORS_ALLOWED_ORIGINS` sentence is lost to a rewrite aimed at the cookie clause three lines above it                                             | Med        | High   | A `.claude/CLAUDE.md` Section 6 non-negotiable; named verbatim in the story, in P3, in the read-across walk and in the DoD                                                                                                                  |
| An untagged number is written into `copier.yml` and the advisory never fires for the projects that need it — the defect that falsified the first ADR | Med        | High   | The key is derived against `git tag` at write time **and** re-asserted at release against the tag actually cut; the DoD carries both halves; `v7.6.0` being untagged is stated here                                                         |
| The `v7.6.0 is tagged` slip in two binding records is read as fact and built on                                                                      | Med        | Med    | Measured and named in _The migration key_ with `git tag --points-at 16aac54` returning nothing; the sprint plan's "must be tagged" form is used throughout this plan                                                                        |
| The preview repair is written cookie-specifically, so the three blind advisories stay blind                                                          | Low        | Med    | P4 runs **before** the cookie advisory exists and is proved against `v3.0.0`, `v5.0.0` and `v6.0.0`'s third; the ADR requires generality explicitly                                                                                         |
| The repair touches the failure tail or the `cleanup` trap and changes `template-update.sh`'s contract                                                | Low        | High   | The block is additive on the success path, a sibling of `:162`; `:151` is inside `if [[ $UPDATE_RC -ne 0 ]]` and `:122` fires at exit; no exit code changes and no section reorders                                                         |
| The owner guide gains the rule but loses a limit, and `HttpOnly` reads as anti-XSS                                                                   | Med        | Med    | Three limits, enumerated in P3, in assessment 7.6 and in the DoD; Stage 3 names this as the one review question that matters                                                                                                                |
| A green `negative-space.sh` run is reported as proof the rule holds everywhere                                                                       | Med        | Med    | The owner guide states the gate's reach; the three invisible assignment sites are named in P3; the sprint plan's _Gate honesty_ forbids it at sprint level                                                                                  |
| The present-state severities are read as a clean security result                                                                                     | Med        | Med    | The five Section 3a promotion rows — **seven threats between them** — and their triggers are cited beside every severity claim, per `code/docs/GATE-REPORTING.md`                                                                           |
| `code/src/scripts/audits/CONTEXT.md` is edited and breaches the 300-line limit US002 owns                                                            | Low        | High   | The clauses join an existing gate; P0 records the file at **299** and the close proves it unchanged with `docs-length.sh`, never `wc -l`                                                                                                    |
| `S-04` lands in `code/docs/URL-STRATEGY.md` concurrently and one rewrite clobbers the other                                                          | Low        | Med    | `S-04` is not cut and the record is closed to it; the re-read rule is stated in _Dependencies_ for whichever lands second                                                                                                                   |
| The whole-tree citation figure is netted against the baseline and reported as a pass                                                                 | Med        | Low    | ADR-US003's diff regime; the baseline is captured by **identity** with its detector hash and index state; every survivor is attributed by citer                                                                                             |
| ShellCheck is recorded as a `lint.sh` pass                                                                                                           | Low        | Med    | P0 probes it; the result is recorded as run or as not run in the test record, never as a gate pass                                                                                                                                          |

---

## Docker & Nginx Infrastructure

**N = 8.** `how-to/docs/GIT-WORKTREES.md` fixes the loopback rule — the final octet equals the
story number, `127.0.0.1` being the main stack — so the IP is `127.0.0.8`. **Verified free
18/09/2026**: `git grep -E '127\.0\.0\.8([^0-9]|$)'` returns **no tracked hit outside this plan**,
and no sibling plan in this folder names it. Subnets
follow `code/src/docker/CONTEXT.md`: second octet the story number, third octet 1 for dev and 0 for
test.

| File                                            | Purpose                                                                                                                                                                                     |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "code/src/docker/docker-compose.us008.dev.yml"  | Dev stack override — copied from `code/src/docker/docker-compose.usXXX.dev.yml.example`; `name:` `<%PROJECT_SLUG%>-dev-us008`; nginx published on `127.0.0.8:3080:80`; subnet `10.8.1.0/24` |
| "code/src/docker/docker-compose.us008.test.yml" | Test stack override — from `code/src/docker/docker-compose.usXXX.test.yml.example`; `name:` `<%PROJECT_SLUG%>-test-us008`; `127.0.0.8:3081:80`; subnet `10.8.0.0/24`                        |
| "code/src/docker/nginx/dev-us008.conf"          | Named per `./CLAUDE.md`'s four-file rule — **and not generated**: see below                                                                                                                 |
| "code/src/docker/nginx/test-us008.conf"         | Same                                                                                                                                                                                        |

**The two Nginx files are named because the folder's rule names them, and the docker layer says
they do not exist.** `code/src/docker/nginx/CONTEXT.md` states that `dev.conf` and `test.conf` are
`server_name _` catch-alls a worktree stack reuses unchanged, and that "there are no per-story Nginx
variants to generate". The two compose overrides are the files a worktree actually creates; the two
Nginx names are recorded so the four-file convention is satisfied on paper and the reader is told
which half is real. **That disagreement between `./CLAUDE.md` and the docker layer's own
orientation is not this story's to settle** — `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`
set this treatment on 08/09/2026 and `../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`
carried it.

**A second contradiction to know rather than resolve:** the plan template names three dev ports
(`3080`/`3082`/`3180`) where `code/src/docker/docker-compose.usXXX.dev.yml.example` binds only
`127.0.0.NNN:3080:80`. **The example is the file that gets copied.**

Every path in the table is in quotes because none exists until the worktree does; the two example
files they are copied from do exist and are backticked.

```text
127.0.0.8 dev-us008.<%PROJECT_SLUG%>.localhost test-us008.<%PROJECT_SLUG%>.localhost
```

`bash code/src/scripts/development/hosts-story-add.sh us008`, reversed by `hosts-story-remove.sh`.
The worktree-aware scripts auto-detect the `us008/` branch through `_lib/worktree-detect.sh` and
layer the two overrides in.

**This story needs a running stack where US006 did not**, and it is worth saying why: the cookie
walk is a browser observation — `HttpOnly` on the `csrftoken` cookie, plain names in dev, an HTMX
write succeeding — and no gate in this repository can make it. This project keeps no cross-cutting
parallel-worktree programme plan; the DAG is the _Dependencies_ sections of the plans in this
folder.

---

## Sprint Verification Checklist

```bash
# The gate, both ways
bash code/src/scripts/audits/negative-space.sh --self-test
bash code/src/scripts/audits/negative-space.sh

# The Python this backlog has not had before
bash code/src/scripts/syntax/lint.sh --file-type python --path code/src/django/config/settings
bash code/src/scripts/syntax/check.sh
bash code/src/scripts/tests/all.sh --coverage

# The documentation gates
bash code/src/scripts/syntax/format.sh --file-type markdown
bash code/src/scripts/syntax/lint.sh --file-type markdown
bash code/src/scripts/audits/doc-references.sh --path code/docs
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/doctrine-drift.sh

# Status propagation
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US008
```

- [ ] `negative-space.sh --self-test` exits 0; `EXPECTED` holds fourteen names;
      `broken/settings/` trips all three and `clean/settings/` trips none; a removed fixture still
      exits 2; **the eleven pre-existing names are asserted unaffected**
- [ ] The unscoped run exits 0 after P2 with **none of the three clauses in its skip notes**
- [ ] The discriminating comparison recorded **both ways round that exist** — three findings over
      the pre-change modules, none after — and the absence of a reverse comparison stated
- [ ] `check.sh` passes — **the first sprint for which this is not `N/A`**
- [ ] `lint.sh` passes — the Python leg over three modules, the Markdown leg over every document
      edited
- [ ] `tests/all.sh --coverage` green, **read as a regression check**; no floor claim over the
      three edited modules, and the reason stated
- [ ] `doc-references.sh --path code/docs` exits 0 with "Clean — every citation resolves." — **the
      criterion**, quoted rather than summarised
- [ ] `doc-references.sh --path <file>` exits 0 for each of the **five** shipped scanned files
      edited outside that scope, not the three the ADR first enumerated
- [ ] `doc-references.sh` whole tree — executed before the first edit and at close, recorded with
      `HEAD`, detector hash, count and class, and **never reported as passing while the baseline
      stands**; every close-time survivor attributed by citer and by class
- [ ] `docs-length.sh` — the five guides clear of 270; **`code/src/scripts/audits/CONTEXT.md`
      unchanged at 299 of 300** as the gate measures it, not the 298 the story asserts.
      `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` is outside the gate's scope and no figure for it
      is claimed as the gate's
- [ ] `docs-pairing.sh` passes — the `config/settings/` pair edited on one half and whole; the two
      fixture directories exempt by rule, **and the pass reported as the exemption doing its job**
- [ ] `doctrine-drift.sh` — regression only; no claim row covers a settings line, so it **cannot
      see** the two guide blocks and is never reported as having looked
- [ ] ShellCheck over `negative-space.sh`, both migration scripts and `template-update.sh` —
      **recorded as run or as not run**, never as a `lint.sh` pass
- [ ] `migrate.sh check` · Bruno API tests · template/component/HTMX tests · `e2e-py.sh` ·
      accessibility walk-throughs — **N/A**, each with its reason above
- [ ] All five manual walks completed and **signed off by a tester other than the author**;
      `PA-01` and `PA-02` recorded as **unrunnable here**, never as run
- [ ] No secrets, debug flags or hardcoded IDs — the two `__Host-` names are literals by design;
      both advisories print paths, line numbers and setting names and **never a value**
- [ ] All thirteen security constraints signed off; each design-state promotion trigger in
      Section 3a re-read against the model as it then stands
- [ ] GDPR, Logging, SEO and accessibility criteria — **N/A**, each flag reads `N/A`
- [ ] Status propagated to the story, this plan, the sprint plan's two tables and the sprint
      record; the ClickUp export regenerated

---

## Definition of Done

- [ ] P0's four baselines captured **before any edit**, each with its index state, its detector
      hash or its tool named beside it
- [ ] `code/src/django/config/settings/base.py` assigns `CSRF_COOKIE_HTTPONLY = True` exactly once
      beside `:159-160`, no environment module re-assigns it, and the `:161-162` comment is widened
      to name `CSRF_COOKIE_SECURE` alongside `SESSION_COOKIE_SECURE`
- [ ] `staging.py` and `production.py` each assign `SESSION_COOKIE_NAME = "__Host-sessionid"` and
      `CSRF_COOKIE_NAME = "__Host-csrftoken"` beside their `SECURE = True` lines at `:21-22`, and no
      other module assigns either name
- [ ] No module under `code/src/django/config/settings/` assigns `SESSION_COOKIE_DOMAIN`,
      `CSRF_COOKIE_DOMAIN`, `SESSION_COOKIE_PATH` or `CSRF_COOKIE_PATH` — **and the claim is scoped
      to that directory, with the owner guide saying so**
- [ ] `dev.py` and `test.py` are **unchanged by this story** — the property, asserted on the diff, with
      `ff24084` (HEAD when the criterion was written) and `c09a189` (the settings directory's last
      touch, 23/08/2026) kept as **evidence** rather than as the assertion (AC-GAP-10)
- [ ] `code/src/django/config/settings/CONTEXT.md` carries the six rows and the Module Map's
      `staging.py` cell names the `__Host-` divergence; `docs-pairing.sh` passes over the pair
- [ ] Three `[gate: fail]` clauses exist, named apart, presence asserted per named module and
      absence over every `*.py` in the directory, every match assignment-anchored at line start,
      each skipping with a note that **names the modules it read**, and **none carrying a silencing
      annotation**
- [ ] `negative-space.sh:92` and `:481` moved **in the same change**; `SETTINGS_FILE` and
      `run_middleware_clause` unchanged; `EXPECTED` at fourteen; both fixture subtrees added and
      asserted inert for the eleven pre-existing clauses
- [ ] `.github/workflows/audit-negative-space.yml` unedited — its path filters already cover the
      surface, verified rather than assumed
- [ ] `code/docs/security/CRYPTO-AND-DATA.md:122-123` is the **sole owner**: host-only, `__Host-`,
      the three preconditions, **three** limits, the gate marker inline, the
      `SECURE_PROXY_SSL_HEADER` precondition, the gate's reach, the doctrine's scope, and the
      dev/TLS name divergence — and it does not restate `:120-121` or `:124-125`, neither of which
      moves
- [ ] The four other statements defer or take the new line, per the story's five-statement table;
      **the `CORS_ALLOWED_ORIGINS` sentence survives verbatim**; `:147-148` and `:154-156` are left
      alone; `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md:47-50` is noted and not edited
- [ ] `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6 requires the edge to **strip**
      any client-supplied `X-Forwarded-Proto` and set it itself, with an entry in that file's
      post-deploy verification section — **and it is reported as a contract term, never as "the
      header is handled"**
- [ ] **No gate clause was added for the edge header**, and the reason is recorded
- [ ] `code/src/scripts/development/template-update.sh` carries an additive report block on the
      success path, a sibling of `:162`, touching neither `:151` nor `:122`, reordering no section
      and changing no exit code — **and the three advisories already shipped blind are proved
      visible in a preview**
- [ ] Two `_migrations:` entries exist before the trailing unversioned entry at `:945`, which stays
      last: the **unversioned, state-gated** `cookie-domain-conflict.sh`, silent when it finds
      nothing and exiting 0 always; and the **version-keyed** cutover advisory, carrying the
      invalidation in both directions, the rolling-deploy hazard and the name-matching warning, and
      ending in the `negative-space.sh` proof step
- [ ] **P5 wrote the keyed entry with its derived-at-release comment and no key**, and the key was
      written at `24-release` with `git tag --sort=-v:refname | head -1`, in the same act as the
      tag. **No untagged number ever entered `copier.yml`** — the act all three binding records
      name as the unverified claim. **Not `7.6.0`**, which the 14/09/2026 shared-AI release claims;
      `v7.7.0` is the expectation and a prediction
- [ ] **`v7.6.0` is tagged at `16aac54` before the release that carries this doctrine.** A sprint
      prerequisite owned by the `release` and `version` skills, not by this story
- [ ] `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` carries a row for **each** entry, the unversioned
      one establishing the form for a row with no version
- [ ] `project-management/workflows/24-release/CHECKLIST.md` carries the key-derivation line, so the
      obligation reaches the workflow that executes it rather than living only in this plan —
      **or, if the implementer declines the scope addition (<%DEVELOPER_NAME%> left the call to
      them, 18/09/2026), a `GAPS.md` row stands in its place.** One of the two, never neither
- [ ] `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is **cited and
      unchanged** — both its supersession fields still read `—` (Q13, <%DEVELOPER_NAME%> explicit)
- [ ] Every gate above run and recorded per `code/docs/GATE-REPORTING.md`; nothing skipped silently
      and nothing not-run reported as clean
- [ ] Both test records written by `22`, the manual one signed off by a second tester
- [ ] Code reviewed and approved (minimum 1 reviewer); the security pass re-read 7.1 to 7.13
      against the shipped text
- [ ] No TODO or FIXME introduced; no secret, debug flag or hardcoded ID
- [ ] `../01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md:323` carries US008 in its Story column, and
      `:116`, `:118`, `:119`, `:120`, `:211` and `:447` are byte-identical to `82ec176` — **the
      re-cut is filed separately, not smuggled**. That pin is carried from the story's own DoD;
      unlike the settings pair it names a file no story here edits, so the commit stays the
      cheapest available evidence
- [ ] Status propagated to every artefact that carries it, and the ClickUp export regenerated
- [ ] PR raised and promoted via `23-pr-and-review`; merged to `main` or the active release branch
