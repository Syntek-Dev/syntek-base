# Changelog

**Last Updated**: <%DATE%> **Version**: 2.20.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.20.0] - 11/08/2026

### Added

- **`how-to/docs/skill-authoring/` — four sub-documents plus their pairing**, with `how-to/docs/SKILL-AUTHORING.md` reduced to a thin index over them. `FRONTMATTER.md` owns the field set, `FORK-DECISION.md` the reference/task split and the fork rubric, `CRAFT.md` invocation and information hierarchy, `SHIPPING.md` the pre-ship checklist. The precedent was already in the tree twice — `tooling-guide/` with three sub-documents and `ai-dictionary/` with seven — and the incoming doctrine exceeded the 58 lines the index had spare.
- **Four runtime keys admitted by `code/src/scripts/audits/skill-conformance.sh`** — `context`, `agent`, `background`, `model` — beside the two specification fields this project authors. `disable-model-invocation` is **not** adopted and a skill carrying it fails. The gate had been asserting that anything outside the six specification fields fails validation, which was never true: Claude Code accepts documented extensions of its own, and declining the rest is this project's choice rather than the format's rule.
- **Two fork assertions in the same gate.** Every skill carrying `context: fork` must carry an explicit `agent:`, and no `agent:` value may name anything outside `Explore`, `Plan` and `general-purpose`. The documented default is `general-purpose`, but `context: fork` changed behaviour at 2.1.218, so an explicit value is version-proof — and the second assertion is what keeps the custom-agent door shut in code while the doctrine records the test for reopening it.
- **Three authoring rules earned from measurement, not from taste.** One remit, one skill — a declared skill/agent pair is two roster entries for a single job. A description is a claim that it discriminates against its near neighbours, and the claim is checkable. And a `skills:` list is load-bearing rather than documentary: a reference skill shadowed by its task counterpart places second every time, so it is reached only by being named, and a task skill that omits it stops receiving the conventions with nothing failing loudly.

### Changed

- **`README.md` and `THIRD-PARTY-NOTICES.md` credit the two upstream sources in the same change as the rules they inform**, per the standing attribution rule. The Agent Skills specification is Apache-2.0 and derivable with attribution; Claude Code's documentation carries no `LICENSE`, so its facts are usable and its wording is not. Both entries carry a measured five-gram overlap, and the measurement is recorded as a step rather than a claim — the first draft of `FORK-DECISION.md` failed it.
- **`.github/workflows/audit-skill-conformance.yml` stops advertising the retired narrowing.** Its header still described a two-field gate, and the file is not copier-excluded, so every generated project would have started from a CI comment contradicting the audit beside it.
- **The registries that describe the gate were brought with it** — `code/src/scripts/audits/CONTEXT.md`, `.copier/README.md`, `.claude/skills/CONTEXT.md` and `CLAUDE.md`, the root and `how-to/` `REFERENCES.md`, and `how-to/docs/CONTEXT.md` and `CLAUDE.md`. A gate whose own inventory describes the previous version is how the next reader learns the wrong rule.

### Fixed

- **A declined frontmatter key could be smuggled past the gate by quoting it.** The key check matched unquoted keys only, so `"allowed-tools":` reported fully clean on a first-party skill. Verified by probe before and after.
- **A nine-word clause taken verbatim from documentation carrying no licence.** It reached a shipped guide by way of a research note, where it had been correctly marked as a quotation, and lost its quotation marks in transit. Re-authored, and the file now measures zero shared five-grams against both upstream sources.

## [2.19.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/doc-references.sh` — the citation guard**, run on every push and pull request by `.github/workflows/audit-doc-references.yml`. Two fail clauses over tracked **and** untracked-but-not-ignored `.md`/`.sh` files: every backticked path the template owns must resolve, and no per-project instance — the `ADR-###`, `US###`, `SPRINT-##`, `MAP-*`, `PLAN-*`, `BUG-*` and `QA-*` families — may be cited as real, because a generated project has different ones at those numbers or none at all. The class kept coming back: three ADR numbers were cited as real across six files for a week before anyone noticed there was no ADR register behind them, and a manual sweep that found nine phantoms missed thirty more.
- **The exemptions and resolutions that keep it from being permanently red.** History files record what was true then; `how-to/src/TEMPLATE-GUIDE/` is copier-excluded and must be able to name a broken citation in order to log it; `handoffs/` and `.copier/` are staging; vendored docs are not this repository's to fix. `copier.yml` is parsed for the paths Copier seeds at generation, so a new seed needs no edit here. Relative citations resolve against the **citing** file rather than the repo root, and the house shorthand against `code/src/scripts/`. A naming pattern, and a row marked `e.g.` or `[EXAMPLE]`, demonstrates a convention rather than citing a document. `doc-references: ignore` on the line or the one above suppresses the case neither rule reaches — a path quoted in order to ban it, or one belonging to another repository.
- **It assembles the two Jinja delimiter pairs at runtime.** Copier renders this script into every generated project, so a literal pair anywhere in it would end generation with a `TemplateSyntaxError`. That is also why its patterns are variables rather than inline globs.
- **Three index rows in the root `REFERENCES.md`** — `code/docs/MANAGEMENT-COMMANDS.md`, `code/docs/MOBILE-CODING-PRINCIPLES.md` and `how-to/src/STORE-LISTING.md`, the guides added earlier in this cycle. All three exist on disk before the row claims them.
- **A Round 3 section in `research/SKILLS-VS-SUBAGENTS.md`**, plus the licence verdict its epic's gate needs. Inline is the documented default for a skill body; an invoked body stays in the conversation for the **session**, not the turn, and this project disables auto-compaction, so the re-attach budget never fires and bodies accumulate until `/handoff`; Anthropic publishes its own rubric for when `context: fork` is worth it; `agent:` defaults to `general-purpose`; a backgrounded fork runs on a narrower tool set and outside the session's checkpoints. On licences: the Agent Skills specification is Apache-2.0 and derivable with attribution, Claude Code's documentation carries no LICENSE file — its facts are usable, its wording must be re-authored — and nothing share-alike is involved, so nothing propagates into a generated project.

### Changed

- **The root `CONTEXT.md` describes the repository it has become.** "There is no separate frontend or mobile application" was true the day the stack became Django-only and false the day the mobile surface shipped. It now states the Django-monolith rule for the web and names the three optional surfaces — `code/src/mobile/`, `code/src/rust/`, and the Slint desktop app inside it — as separate deployables consuming the same API. The Layer Map gains the mobile row and stops calling the Django project "the single deployable".
- **The directory tree gains five rows it had drifted past** — `.copier/`, `code/src/improvement-architecture/`, `LICENSE`, `SECURITY.md` and `CONTRIBUTING.md` — and `.mcp.json` is described as the three servers it configures rather than one.
- **`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` records seven findings from this cycle and closes two.** The seven: the routing half deferred because the agent tier is being retired; merge-conflict markers that passed every gate for two releases after Prettier reformatted them into valid Markdown; the `/mcp/` surface having no error-taxonomy row; the ruff CI jobs below; the two research notes that cannot be deleted with their epic because `README.md` cites them as licence evidence; retiring the ADR machinery template-wide, measured at 74 actionable files; and the mobile tree's sub-directories carrying no `CONTEXT.md`/`CLAUDE.md` pair, which `docs-pairing.sh` structurally cannot see. The two closed are both citation gaps, closed by the rule the new audit now enforces.

### Fixed

- **`.github/workflows/syntax-python.yml` claimed to be the only Python gate this repository enforces on itself.** The lockfile half of that reasoning is correct — the three jobs run `uv sync` without `--frozen`, so no committed lock file is needed. The conclusion was not: in the base template the root `pyproject.toml` still carries the unrendered project-slug token as its `name`, and uv rejects that while parsing the manifest, before dependency resolution begins. All three jobs fail at the sync step and every step after it is skipped. The header now says so, notes that a generated project is unaffected, and records the contrast that makes the cause legible — pnpm skips name validation on a private package, so the identical token is harmless in `package.json` and fatal in `pyproject.toml`.
- **A dangling ADR citation in the root `REFERENCES.md`** — the `code/docs/architecture/CORE-AND-SCALING.md` row named two ADR numbers as its source, which is precisely what the new audit's second clause forbids. Dropped; the row keeps its pointer to the sizing snapshot.

## [2.18.0] - 11/08/2026

### Added

- **`code/src/django/apps/core/management/base.py` — `ManagementCommand`, the error taxonomy expressed on a command line.** A command has no HTTP status to carry the three classes, so the distinction is made in what the operator reads and what a scheduler can act on: a `ServiceError` becomes a one-line `CommandError` at exit 1, `DependencyUnavailable` exits **75** — `EX_TEMPFAIL`, from BSD `sysexits.h` — because a scheduler retries on it and must not retry on the other two, and `InvariantViolation` is deliberately not caught, so a programmer error reaches the operator as a traceback and the tracker as an event.
- **`execute()` calls `close_old_connections()` on entry and exit.** Django closes connections in `run_from_argv`, which `call_command()` never reaches, so a command invoked from a task, a test, or another command inherited whatever connection state its caller left.
- **A ruff `TID251` ban on both `BaseCommand` import paths**, `django.core.management.base.BaseCommand` and the `django.core.management.BaseCommand` re-export, because banning one would leave a one-word bypass. `pyproject.toml` exempts exactly one file — the base class itself. The ban is what makes subclassing compulsory rather than advisory: the direct base still works, and the only difference is that a broken invariant stops being distinguishable from a transient outage.
- **`code/docs/MANAGEMENT-COMMANDS.md`** — the rule the module implements. When work belongs to a person choosing the moment rather than to a queue; why argparse parses and parsing is not validation; why an identifier off the command line is as unverified as one off a URL and identity is an argument that must be verified rather than inferred; blast radius as the argument nobody passes, with `--dry-run`, declared bounds, and why the confirmation prompt is not the safety; and the four things worth asserting in a test, including the exit-75 one everybody skips.
- **`code/src/django/apps/core/management/` with its own `CONTEXT.md`/`CLAUDE.md` pair**, and no `commands/` package in it deliberately — Django discovers commands inside the app that owns their data, and `core` owns no domain.

### Changed

- **`code/docs/PROCESS-MODEL.md` records that one of its three no-request surfaces now satisfies the ORM connection rule structurally.** A command satisfies it by subclassing the base; a task and an MCP tool still carry it themselves.
- **`code/docs/TASK-AUTHORING.md` gains the taxonomy on its own surface, and its user-error class is empty on purpose.** A task has nobody to tell, so an argument it cannot act on was put there by code — a programmer error, even where the identical value arriving on an endpoint would be a 422. The two surfaces now name each other: the queue spends retry classification where the shell spends exit codes.
- **`code/src/django/apps/CONTEXT.md`, `code/src/django/apps/core/CONTEXT.md` and `code/src/django/apps/core/CLAUDE.md`** list the two sub-packages `core` now ships, `management/` and `templatetags/`, and carry the rule that `management/base.py` is the only module permitted to import Django's `BaseCommand`.
- **The `Decided by` column in `code/src/django/apps/core/CONTEXT.md` cites shipped guides.** It pointed at node IDs from a planning map that no generated project receives; it now names `code/docs/NEGATIVE-SPACE.md` and `code/docs/MANAGEMENT-COMMANDS.md`, which exist everywhere.
- **`code/REFERENCES.md`, `code/docs/CONTEXT.md` and `code/CONTEXT.md` index the guide**, together with `code/docs/discoverability/APP-STORE.md` and `code/docs/MOBILE-CODING-PRINCIPLES.md`. `code/REFERENCES.md` also adds the two external sources the base class is built on: Django's custom-management-commands howto — noting that `run_from_argv` catches `CommandError` and closes connections while `call_command()` does neither — and BSD `sysexits.h` for `EX_TEMPFAIL`.

## [2.17.0] - 11/08/2026

### Added

- **`code/src/django/templates/500.html` — the one template with a live consumer before any page exists.** Django resolves it by name with no view and no URL entry, so it works on a project that has not written a route yet. It deliberately extends no base, loads no CSS and names no internals, because Django renders it with an empty `Context` and no request — a base template that reads `request` would render blanks on the one page a user only ever reaches after something has already broken. The copy is a placeholder until first-time setup, exactly like the worked row in `how-to/src/INVARIANTS.md`.
- **`{% request_id %}`, in the new `code/src/django/apps/core/templatetags/core.py`.** The tag reads the correlation identifier from the `ContextVar` in `code/src/django/apps/core/middleware.py` rather than from the template context, which is the only mechanism that reaches the 500 page as well as HTMX error partials and ordinary views. A context processor cannot: those run only for a `RequestContext`, and there is no request. An empty string outside a request — a management command, a task, an exception raised above the middleware — is a correct answer rather than a gap, because a stale identifier resolves to the wrong tracker event.
- **`code/src/django/static/js/observability.js` — the global HTMX error handler.** One `htmx:beforeSwap` / `htmx:sendError` listener pair on `document.body`, never per element, closing the defect where a 5xx swaps nothing at all: the indicator stops, the page is unchanged, and the user re-clicks. It creates its own `role="alert"` region instead of targeting a possibly-null element, refuses to swap a complete edge-served HTML document into a `div` by testing the doctype, and leaves htmx's own `isError` alone — a handler that quietens the console while claiming to make failure visible is worse than none.
- **`CONTEXT.md` / `CLAUDE.md` pairs for `code/src/django/static/` and `code/src/django/templates/`**, retiring the two `.gitkeep` placeholders that kept both trees tracked. The static pair records that there is no client-side build, that the `htmx-handler-absent` clause in `code/src/scripts/audits/negative-space.sh` keys on the listener rather than on this file's path, and that no `css/` token layer or vendored HTMX/Alpine exists yet because no page loads them. The template pair records that `500.html` names no internals, that the identifier arrives through the tag rather than a context processor, and that `503.html` is never added there.
- **`code/src/django/apps/core/templatetags/CONTEXT.md` / `CLAUDE.md`** — the table of rendering paths showing which have a request context and which do not, plus the rules that keep the library honest: a tag here must work without a request context or it belongs in a context processor, `{% request_id %}` must never grow into a general correlation API, and the module name is load-bearing because templates carry `{% load core %}`.
- **`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 14 — the 503 page.** Django defines a handler and a template name for 400, 403, 404 and 500, and none for 503, so there is nothing to override. More decisively, the 503 that matters is returned precisely when the Django process is not answering, and a template cannot be rendered by a process that is down. The deploy repository owes a static document served from disk for `error_page 502 503 504`, carrying `Retry-After` where the window is known and `X-Request-ID` where the edge minted one, never cached, and with no asset references — the static tree is served by the same upstream that is failing.
- **`code/docs/FRONTEND-CODING-PRINCIPLES.md` § _What is not built yet_** — the web peer of `code/docs/MOBILE-CODING-PRINCIPLES.md` § 5, naming the base template, the `#error-region` div, the HTMX error partial, the `<script>` tag that would load the handler, and the token stylesheet, each with the reason it waits. It also states the consequence: the `htmx-handler-absent` clause is a no-op until the first template uses `hx-`, so the handler ships proven by ruff, ESLint and Prettier rather than by that gate.

### Changed

- **`code/docs/rendering/PITFALLS-AND-EXAMPLES.md` now documents the shipped handler rather than an illustrative sketch**, and gains § _The identifier a full-page error cannot be given_: Django's own documentation on the empty `Context`, the two consequences that follow from it, and the `{% extends %}` trap on an error page. The section closes by stating there is no `503.html` and routing to the edge contract.
- **`.claude/skills/stack-htmx-templates/SKILL.md` gains § _When a swap would show nothing_.** The per-view 200-re-render pattern it already carried is the user-error half and is complete; the other two taxonomy classes need the global listener, and the skill documents the shipped handler because that is what a frontend agent is about to edit.
- **`code/src/CONTEXT.md` and `code/src/django/CONTEXT.md` stop describing `static/` and `templates/` as empty.** Each tree now names the one file it holds, with a paragraph explaining the narrow exception — each carries a correctness rule rather than a design decision, which is why it ships before the design work exists. `code/src/CONTEXT.md` also adds `mobile/lib/` as the mobile surface's home for non-route modules, and the `core` app's one-liner widens to include the middleware and the command base.

### Fixed

- **The handler snippet the rendering guide documented reproduced the defect it was there to close.** It assigned `document.getElementById("error-region")` straight to `event.detail.target`, which is `null` on any page that has not defined the region — and a swap into `null` fails silently, leaving the user with the unchanged page the handler exists to prevent. The shipped handler creates the region.

## [2.16.0] - 11/08/2026

### Added

- **`code/docs/discoverability/APP-STORE.md`** — the fifth member of the discoverability family, and the first that governs an artefact of a **different deployable**: the App Store and Google Play listing for `code/src/mobile/`. Store search matches listing metadata inside a length budget, not a crawled page, so none of the head, schema, root-surface or body rules reach it. Carries the field-by-field limits with a `Source:` and a `Verified:` date each, and four rules: `app.json` `expo.name` is the on-device name and **not** the listing name, keywords are never spent on the app or company name, the description is plain text with no HTML, and promotional text is the field that can change without a new version. **Mobile-only** — copier-gated on the same mechanism as `code/docs/visual-design/MOBILE.md`.
- **Apple's keyword budget is 100 _bytes_, not 100 characters**, quoted from App Store Connect Help. Almost every third-party ASO source states it as characters; the two coincide for an ASCII listing, which is why the error survives. In UTF-8 an accented Latin character costs two bytes and most CJK characters three, so a localised keyword set measured at 100 characters can be rejected at a third of its apparent length. Count with `len(text.encode("utf-8"))`.
- **`how-to/src/STORE-LISTING.md`** — the per-project register the guide governs: every text field, the value this project uses, and the budget it must fit. Same rule-elsewhere/answer-here split as `how-to/src/PLATFORM-PROVIDERS.md` and `how-to/src/INVARIANTS.md`. A blank cell is an unanswered question, not a default, and only the guide carries the verification dates — if the two disagree, the guide is right.
- **A conditional store-listing gate in `project-management/workflows/23-release/`.** New Step 2 in `STEPS.md` fires **only if the release moved `code/src/mobile/`** (`app.json` `expo.version`); a root-only bump reaches no store, and a web-only project never meets the condition. It delegates to `mobile`, writes the What's New copy into App Store Connect and the Play Console, and records the same text in the register — **overwriting, never appending**, because the history already lives on the mobile sub-package's own `CHANGELOG.md` and `RELEASES.md`. Matching row in `CHECKLIST.md`, routing in `CONTEXT.md`.
- **A `How much of this a machine can check` section across the discoverability family.** `code/docs/DISCOVERABILITY.md` states the gradient — from `discoverability/STRUCTURED-DATA.md`, where nearly everything is a test, to `discoverability/CONTENT-STRUCTURE.md` and `discoverability/APP-STORE.md`, where almost nothing is — and the two consequences: no audit in `code/src/scripts/audits/` covers this family and none is planned, and a clean pipeline says nothing about whether any of it was honoured.

### Changed

- **The `mobile` agent owns the store listing, not the `seo` agent.** How a product is found in store search has no web counterpart, and `seo` is scoped to the Django marketing pages. `mobile` owns the **text fields and their limits**; the screenshots and icon stay with `code/docs/visual-design/MOBILE.md`, and the privacy nutrition labels and Data Safety declarations with `project-management/src/09-GDPR/`. Roster row in `.claude/agents/CONTEXT.md` updated to match.
- **`how-to/src/BRAND-VOICE.md` gains store-listing text as a third thing that is not a fifth register** — a separate bullet from SEO metadata rather than a clause inside it, because the constraints are not the same shape: a byte budget runs out two to three times sooner than a character count predicts.
- **`project-management/docs/SEO-CHECKLIST.md` says plainly that a green pipeline is not evidence.** `12-seo-checks` runs inside the per-story loop **before any code exists**, so it reviews the plan for a page rather than the page. Every tick is a person's judgement.
- **`STRUCTURED-DATA.md`'s `Verification` section is now `What is mechanically checkable here`**, and states the half that is not: whether the type chosen suits the page, and whether the values describe the thing honestly. A `Product` block with valid syntax and invented review counts passes every check and is a manipulation.
- **`WEB-METADATA.md` names its checkable half as the half that fails silently.** One `<title>`, one description, one canonical per route; the canonical absolute and derived from `SITE_URL`. A `Host`-derived canonical renders correctly, looks correct in a browser, and hands a proxied copy of the site the right to call itself the original.
- **`code/docs/DISCOVERABILITY.md` no longer defers the third destination.** The row that said store-listing doctrine was "not covered here yet" now names its owner, and the sub-document table and `discoverability/CONTEXT.md` read four artefacts as five.
- **Release Step 5 stops instead of printing a command that does not work.** `code/src/scripts/deployment/` is a scaffold, so the workflow now says it has no deploy entry point to give you and hands the tagged, tested release to whoever owns the target environment — rather than naming `deploy.sh` with a footnote admitting it is unwritten.
- **`how-to/REFERENCES.md` and `how-to/src/CONTEXT.md`** carry the `STORE-LISTING.md` row, flagged mobile-only.

## [2.15.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/negative-space.sh`** — the CI half of `code/docs/NEGATIVE-SPACE.md`. It correlates `how-to/src/INVARIANTS.md` with the code, by name, in both directions and on both surfaces. Nine `[gate: fail]` clauses — `constraint-unregistered`, `constraint-absent`, `key-unraised`, `key-unregistered`, `key-duplicated`, `register-absent`, `htmx-handler-absent`, `request-id-middleware-absent`, `ts-flags-loosened` — and one `[gate: warn]`, `worked-row-stale`. There is **no silencing annotation**, deliberately: a comment suppressing a finding here is itself a finding, on the same reasoning that makes a `# noqa: S101` one.
- **`--self-test`, and the fixture pair under `code/src/scripts/audits/fixtures/negative-space/`.** `broken/` must trip every fail clause; `clean/` must trip none. Six known-positive files carry one violation each — `models.py` holds `constraint-unregistered` and `constraint-absent` together, `services.py` holds `key-unregistered` and `key-duplicated`, `page.html` an `hx-post` with no `htmx:responseError` handler, `settings.py` a `MIDDLEWARE` list omitting the request-ID middleware while naming it in the docstring, `tsconfig.json` a loosened compiler flag, and `INVARIANTS.md` one breach of each register clause. Missing fixtures exit 2 rather than passing having proved nothing.
- **`.github/workflows/audit-negative-space.yml`** — the self-test runs **first**, then the scan. Its path filter is deliberately broad across both `how-to/src/INVARIANTS.md` and the code the register names, because a clause landing in one half alone is the drift the audit exists to catch.
- **`code/docs/MOBILE-CODING-PRINCIPLES.md`** — the mobile peer of the backend and frontend principles guides. It owns how the mobile surface **expresses** the negative-space rules and restates none of them: the four compiler flags and what each makes un-writable, the flags deliberately declined, exhaustiveness across compile time and runtime, and the error taxonomy on a device.
- **`code/src/mobile/lib/invariant.ts`** — `InvariantViolation`, named to match the backend's exactly so one `On breach` column reads the same on both surfaces, plus `unreachable(value: never, key)`, which fails typecheck at every unhandled call site and throws a keyed error when an unseen union member arrives from the API.
- **`code/src/mobile/lib/error-classes.ts`** — `classify()` and its reporting table. `408`, `502`, `503` and `504` are carved out as **environment** errors despite three being 5xx, so a rolling deploy's restart window is not filed as a fleet of new defects; environment reports aggregate, because a phone losing connectivity is ordinary; an unrecognised failure defaults to **programmer error**, because defaulting to environment silences exactly the failures nobody has considered yet.
- **`code/src/mobile/__tests__/invariant.test.ts` and `code/src/mobile/__tests__/error-classes.test.ts`** — the classifier's table pinned status by status, the REPORTING policy and `isRetryable`, and proof that a thrown string, a `null` and a stringified status all land as programmer errors.

### Changed

- **`how-to/src/INVARIANTS.md` gains a `Key` column, and it is a column rather than a convention because a gate cannot read a convention.** The key in the register and the string in the `raise` are one string, checked by name. A pure `db-constraint` row carries `—`, because a constraint name is already its own identifier. The file also gains a **client-enforced** section, mobile-only, and a standing rule that a client guard never re-checks what the server enforces — that is the second call site the register forbids, only harder to notice because it sits on the other side of an API.
- **`code/docs/NEGATIVE-SPACE.md` gains a _What the gate decides_ section** naming every clause and its tier inline, so the script implements against the markers rather than re-deriving what is detectable. Two things are marked `[judgement]` and belong to the reviewer: whether a named enforcement point guards the **right** thing, and whether an invariant is missing altogether. The `Mechanism` vocabulary adds `client-guard`, `RequestIDMiddleware` staying in `MIDDLEWARE` becomes a gated clause, and the per-surface table extends to background tasks, management commands and the mobile app.
- **Scope is stated, because a gate that measures the wrong thing is worse than none.** Models only, never migrations — a migration history holds every constraint ever added, including ones since dropped, so scanning it would force the register to carry dead rows to stay green. Test code is exempt on both surfaces, exactly as ruff `S101` exempts it, and `code/src/scripts/audits/fixtures/negative-space/clean/guard.test.ts` and `clean/tests/test_guard.py` construct unregistered keys on purpose so the self-test fails the day that exemption is removed.
- **`code/src/mobile/tsconfig.json` enables the four flags beyond `strict`** that neither `strict` nor `expo/tsconfig.base` implies — `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitReturns`, `noFallthroughCasesInSwitch`. Each bans a state rather than a style, which is the test for adding a fifth. `noUnusedLocals` and `noUnusedParameters` are declined and the file says why: ESLint already owns that rule, and two enforcers of one rule drift.
- **`code/src/mobile/jest.config.js` adds `lib/**/\*.{ts,tsx}`to`collectCoverageFrom`.\*\* Without the entry the new non-route modules are invisible to the coverage floor, and the run stays green having measured nothing.
- **`code/src/mobile/CONTEXT.md` and `code/src/mobile/CLAUDE.md` document the `lib/` tree and two rules.** `lib/` exists because expo-router would publish any helper placed under `app/` as a navigable screen. A new non-route module joins the coverage glob in the same change, and loosening a compiler flag to clear a build is a finding for `project-management/src/19-FINDINGS/`, never a `!` non-null assertion.
- **The three stack skills teach the taxonomy the register encodes.** `stack-django` — the three error trees, `InvariantViolation` taking its register key first, and the guard whose only exit is the `raise`. `stack-react-native` — the four flags, `unreachable()` over `assertNever`, `classify()`, and one root `ErrorBoundary` because on a phone the environment error is the ordinary case. `stack-fastmcp` — a tool inherits the JSON API's row rather than holding one of its own, and the guard stays in the service.
- **`code/src/scripts/audits/CONTEXT.md` registers the audit and its fixtures**, widens exit code 2 to cover a self-test whose fixtures are missing, and states the new rule that a warn tier is **earned rather than assumed**.
- **`how-to/workflows/06-quality-gates/` carries both invocations** — the scan and `--self-test` — in `STEPS.md` and `CHECKLIST.md`, with the audit named in `CONTEXT.md`.
- **`README.md` and `THIRD-PARTY-NOTICES.md` credit TigerStyle where the doctrine sits.** Two rows measured at **0.0% five-gram overlap** against `code/docs/NEGATIVE-SPACE.md` and `how-to/src/INVARIANTS.md`, with the note that its assertion mechanism is deliberately not adopted: Python's `assert` is stripped by `-O` and cannot carry the register key.

## [2.14.0] - 11/08/2026

### Added

- **`context7` and `mcp-mermaid` are configured in `.mcp.json`.** The `.claude/CLAUDE.md` § 3 table listed five MCP servers as though the project supplied them; `.mcp.json` supplied one. Two more are now genuinely wired, and the table gains a **How you get it** column so the difference is visible rather than assumed: `code-review-graph`, `context7` and `mcp-mermaid` come from `.mcp.json`; `claude-in-chrome` needs the Chrome extension installed and paired, which nothing in this repository can do on your behalf. The `figma` row is gone — nothing here provides it either.
- **`.copier/MAP-SCALE-PLANNING.md`, seeded into `project-management/src/01-FEATURE/` at generation.** Six shipped files route a reader to that map, and it did not exist until `/scale-planning` wrote it — so on day one, every one of those six routes went nowhere. The seeded file is a stub: every row reads `TBD`, and the frontier is **named rather than answered**, which is the honest state before the pass has run. It rides the same seed-once `_tasks` mechanism as the root version files, on `copy` only, so `copier update` can never hand a project its blank stub back over a filled-in map.
- **Two nested `.gitignore` files, both `_exclude`d from the template.** `handoffs/.gitignore` ignores `HANDOFF-*.md`; `project-management/src/01-FEATURE/.gitignore` ignores the feature maps, bar the template they are written from. In **this** repository both are throwaway working state about the template itself and belong in no history. In a **generated** project both are real — handoffs are that project's session continuity and maps are the artefacts of `01-feature` — which is why the rule must not travel. Git honours a `.gitignore` in any directory, so a repo-local rule can live in a file copier drops at generation, leaving the root `.gitignore` shipped and therefore still updatable.

### Changed

- **A shipped file may cite only what every project is guaranteed to have.** That is the layering system — `CONTEXT.md`, `CLAUDE.md`, the `docs/` guides, the workflows, the scripts. A per-project instance is not guaranteed: a generated project has different ones at those numbers, or none at all. Naming a **pattern** stays fine — "take the next free number in `14-DECISIONS/`" describes a format, not a document. Citing a specific instance as real does not. Applied by hand across the tree in this release.
- **This project does not use ADRs, and `.claude/MEMORY.md` now records that as a project- and template-wide decision.** Decisions are recorded where the work already lives — the feature map, the story plan, the nearest `CONTEXT.md` glossary, a `research/` note. The trigger was `project-management/src/14-DECISIONS/` not being copier-excluded: an ADR about the template's own tooling would ship into every generated project as a decision that project never made. The machinery it retires is still standing and still instructs otherwise; the memory entry is read second in the § 2.1 order and wins until the removal ships.

### Fixed

- **The phantom decision-record numbers 2.13.1 logged and deliberately left open.** They are cleared from `DESIGN.md`, `.prettierignore`, `code/workflows/03-database-migration/CONTEXT.md`, `code/src/scripts/audits/css-tokens.sh` and `code/src/scripts/audits/css-gradients.sh`. Each one described something real, so each now names that thing directly — the shard-key co-location, the Django static token cascade, the co-located django-component CSS — instead of pointing at a decision record no project has ever held.
- **Story numbers used as worked examples in a template that ships no stories** — `project-management/src/07-COMPONENTS/CONTEXT.md`, its `CONSOLIDATED-IDEAS/CONTEXT.md`, `project-management/workflows/17-consolidate-design-work/CONTEXT.md`, and the naming table in `project-management/src/CONTEXT.md`. "One story's status badge and another story's tag chip" makes the identical point and is true in every project.
- **Map names and node numbers cited as evidence** in `.claude/MEMORY.md`, `.claude/skills/grilling/SKILL.md`, `.claude/skills/wayfinder/SKILL.md`, `.claude/agents/seo.md` and three `research/` notes. A map is deleted once its epic ships, so the citation dies while the lesson it was supporting stays true. Each lesson now stands on its own wording.
- **`.claude/agents/release.md` named two paths that do not exist.** The version-bump phase listed `code/src/django/pyproject.toml`; the Django package's manifest is the root `pyproject.toml`. Phase 4 ran `code/src/scripts/deployment/production.sh`; `deployment/` is a scaffold with no runner in it. That phase now stops and reports, and says never to improvise a deploy command.
- **`.claude/agents/completion.md` was instructed to keep a story index reconciled** — a file this template does not ship, in the remit, the read list and the procedure. All three removed.
- **The pytest and coverage configuration was cited at `code/src/django/pyproject.toml`** in `code/docs/testing/BACKEND-TESTING.md` and `code/docs/testing/COVERAGE.md`. `[tool.pytest.ini_options]` and `[tool.coverage.run]` both live in the repository-root `pyproject.toml`, and the snippet headers now say so.
- **A dependency-audit script cited three times and never written.** Dependency scanning is `.github/workflows/audit-deps.yml` — `pip-audit` plus `pnpm audit` — and it runs on a schedule, not the "every PR" cadence `code/docs/testing/TAXONOMY.md` claimed. Corrected there, in `code/docs/testing/ADVANCED-TESTING.md` (which also stops pointing future load tests at a directory that does not exist), and in the pre-deploy checklist in `code/docs/security/OWASP-AND-CHECKLIST.md`.
- **`code/workflows/09-debugging-with-logs/CHECKLIST.md` pointed at `lint.sh` and `check.sh` one directory too high** — both live under `code/src/scripts/syntax/`.
- **Deploy-repository paths that read as paths in this repository.** `how-to/src/NIXOS-SETUP.md`, `how-to/src/SERVER-ARCHITECTURE/CONTEXT.md` and `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md` cited the fork guide and the server-setup workflow bare, so each resolved here — to the wrong thing. Every one is now prefixed `<%DEPLOY_REPO%>`.
- **Counts stated in prose that had stopped being true.** `how-to/src/TEMPLATE-GUIDE/07-REPO-TOUR.md` said 11 code workflows in three families (there are four, the fourth being the opt-in surfaces) and five script groups, omitting `deployment/`, the surface-gated groups and `_lib/`. `code/workflows/13-desktop-app/CONTEXT.md` said "the two scripts".

## [2.13.1] - 11/08/2026

### Added

- **`.github/scripts/shipped-readme.sh`** — verifies that the documentation a generated project receives still describes the template that generated it. Two documents drift silently because nothing consuming them is ever run by this repository's CI: `.copier/README.md`, the README a new project actually gets, and `how-to/src/TEMPLATE-TOKENS.md`, the prose token contract `copier.yml` implements. Neither had a consumer that fails when it goes stale.
- **The four `REFERENCES.md` files index every guide added across 2.4.0–2.13.0** — `DOCUMENTATION-PAIRING`, `VISUAL-DESIGN`, `NEGATIVE-SPACE`, `DISCOVERABILITY`, `PROVIDER-NEUTRALITY`, `BUILD-OPERATE-SEAM`, `TASK-AUTHORING`, `PROCESS-MODEL`, `OBJECT-STORAGE`, `AUDIT-TRAIL`, and the sub-document folders under each.

### Fixed

- **`.copier/README.md` described a repository three surfaces out of date.** Its `code/src/` tree omitted `improvement-architecture/`, which ships everywhere; its `.github/workflows/` list named 11 of 28, only two of the omissions being surface-gated; and its `code/docs/` tree omitted eight ungated guides. The `src/` tree stopped at `21-REFACTORING` and the workflow count said 21. All corrected, plus the new attribution section and an honest _declared, not wired_ note against Celery.
- **`check-template-tokens.sh` reported green on files it had never looked at.** It scanned `git ls-files` only, so the file you had just written — the one most needing the check — was invisible. CI never noticed, because everything is tracked by the time CI runs; local runs are exactly where the blindness bit. It now scans tracked **and** untracked-but-not-ignored files.
- **`.prettierignore` pointed at directories that have not existed since the stack became Django-only** — `code/src/frontend/`, `code/src/backend/`, a Next.js build-output block and GraphQL codegen paths. Repointed at `code/src/django/`.
- **The root `CONTEXT.md` declared version 2.0.0**, three releases behind, and gave three wrong workflow ranges: code workflows as `02–14` (they are `01–13`), how-to as `01–04` (they are `01–09`), and PM as `01–22` (they are `01–23`).
- **The `README.md` footer declared v1.0.0**, and the stack table promised Celery and S3 storage as though both were wired.
- **Cross-references left dangling by the guide splits** — chiefly `CODING-PRINCIPLES.md` anchors that moved into `coding-principles/PRACTICAL-RULES.md`, and `project-management/docs/RESPONSIVE-DESIGN.md` cited as a source when it is a redirect stub.

### Known issues

- **The phantom ADR references are still open.** `ADR-016`, `ADR-019` and `ADR-023` are cited as real in `REFERENCES.md`, `DESIGN.md`, `code/workflows/03-database-migration/CONTEXT.md`, `.prettierignore` and two audit scripts, and no ADR register exists. Logged in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`; deciding whether to write the ADRs or drop the citations is its own change, not a sweep item.

## [2.13.0] - 11/08/2026

### Added

- **`.claude/hooks/context-threshold-handoff.sh`, registered as a `UserPromptSubmit` hook.** The model cannot read its own context usage, so a hook measures it and the rule in `.claude/CLAUDE.md` §2.6 reacts. **At 50%** — advise, once per session: finish the step in flight, start no new scoped work, name the stopping point and offer `/handoff`. **At 75%** — insist, on every prompt: write the handoff and stop the turn.
- **A deny-list covering every `.env` variant** — `.env`, `.env.dev`, `.env.test`, `.env.prod`, `.env.staging`, `.env.local`, `.env.probe`, `.env.backup`, `.env.bak*` and the long-form spellings — for both `Read` and `Bash`. The `.example` templates are explicitly allowed, because reading those is how an agent learns which variables exist without learning their values.

### Changed

- **The handoff trigger moved earlier, and the reason is the point.** `PreCompact` alone is too late: by the time compaction fires the window is already spent, and a handoff written under that pressure is the worst one of the session. The new hook keeps the same split as `pre-compact-handoff.sh` — a hook cannot invoke a skill or stop a turn, so the script measures and reminds while the rule carries the behaviour.
- **The window size is a constant with an environment override.** Nothing in the transcript reports it. The default is this project's observed 1M window; `CLAUDE_CONTEXT_WINDOW` overrides it for a 200k plan, and both thresholds are overridable too.
- **The hook always exits 0.** A miscounted token must never block a prompt — a warning system that can refuse input is worse than no warning system.
- **`how-to/docs/ai-dictionary/PATTERNS-OF-WORK.md`** describes the two-threshold pattern, so the vocabulary matches the behaviour.

## [2.12.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/static-analysis.sh`** — pattern and taint analysis over the Django surface using Opengrep against this project's own rule files. It closes two gaps that nothing else could, because both are structural rather than a matter of configuration.
- **Django template markup is now scanned at all.** Ruff cannot parse a `.html` file, so `{% autoescape off %}`, the `|safe` filter, and a template variable interpolated into an Alpine expression or an inline script were entirely unchecked. Three rules cover them: `django-autoescape-off.yml`, `django-safe-filter.yml`, `django-template-xss.yml`.
- **Cross-file taint tracking.** `pyproject.toml` already enables ruff's `S` ruleset, which runs per file — it flags a bare `eval()`, but it cannot see that the argument arrived from a request three modules away. `request-to-sink-taint.yml` follows request data to raw SQL, shell and eval sinks.
- **`secrets-in-source.yml`** — hardcoded credential assignments, complementing the `.env` read-denials rather than duplicating them.
- **`code/src/scripts/audits/rules/` with its own `CONTEXT.md`/`CLAUDE.md` pair**, because the rules are hand-authored source and need the same orientation as anything else in the tree.

### Changed

- **`stubs.sh` now covers Rust** — `// STUB`, `// TODO`, `// FIXME`, `// HACK`. It deliberately does **not** grep `todo!()`, `unimplemented!()` or `unreachable!()`: all three are denied at lint level in every crate's `[lints.clippy]`, and clippy parses Rust, so it cannot be fooled by a macro name inside a string or a doc example, and it offers a per-site `#[allow]` carrying a reason. A `// STUB` comment is precisely what clippy cannot see, which is the division of labour.
- **The Cargo `target/` tree is excluded from the stub scan** — thousands of generated `.rs` files carrying upstream crates' markers, none of them anyone's to fix here.
- **`code/docs/rust/PYO3-BOUNDARY.md`** documents the lint-level rule and its escape hatch, so the two halves of the stub policy are described in one place.

## [2.11.0] - 11/08/2026

### Added

- **`/incident`** — runs a live incident alongside you: timestamped notes, the clock, the seven-field handover when you have to stop, and the blameless postmortem at stand-down. It has **no paired agent** deliberately — running an incident is a session mechanic, not a remit. Doctrine: `how-to/docs/INCIDENT-PRACTICE.md`. Register: `project-management/src/22-INCIDENTS/`, which is **PII-free** and, unlike every other record folder, **not story-anchored**.
- **`/resolving-merge-conflicts`** — recovers the intent behind both sides of a conflict, resolves every hunk, and proves the result with the project gates. Knows the file classes that must **never** be hand-merged: migrations, lockfiles, version state, and frozen PM artefacts.
- **`/wizard`** and `code/src/scripts/_lib/wizard.sh` — authors a guided bash script for the parts of a procedure a person must do by hand: provisioning a third-party service, minting credentials or CI secrets, a one-off cutover. Explicitly never for work the agent can do itself.
- **`/to-questionnaire`** and the `questionnaires/` sandbox — turns a decision the session cannot settle into a questionnaire for the person who can: a client, a data controller, a vendor, a stakeholder. It is the honest exit from a grilling pass that has stalled on somebody who is not in the room, and is never invoked by the model on its own.
- **`/wait-what`** — re-pitches a reply that did not land, in plain language, with the context it wrongly assumed. Also never self-invoked.
- **`code/src/scripts/audits/skill-conformance.sh` and its CI job.** Eight fail-tier clauses, reported in two groups because a specification breach and a house-rule breach are different problems: six checks against the [Agent Skills specification](https://agentskills.io/specification), and two house rules — no spec-optional key on a first-party skill, and a `## Governing procedures` section present. Length is deliberately **not** checked here; `docs-length.sh` owns the 300-line cap across `.claude/**`, and one rule with two enforcers drifts.
- **`how-to/docs/SKILL-AUTHORING.md`** — the standard the audit enforces, including why this project authors only `name` and `description` and declines the other four spec fields: capability and model belong to the **agent** that loads a skill, never to the skill.
- **`research/AGENT-SKILL-ECOSYSTEM.md` and `research/SKILLS-VS-SUBAGENTS.md`** — the primary-source survey behind both the five skills and the authoring standard.

### Changed

- **Vendored skills are held to the specification half only.** The Cloudinary set is a symlinked folder refreshed from upstream via `skills-lock.json`; hand-editing one to satisfy a house rule is undone by the next refresh, so clauses 7 and 8 skip them.
- **`code/docs/security/MONITORING-AND-INCIDENT.md`** routes its response half to the new incident practice rather than describing a procedure in its own words.

## [2.10.0] - 11/08/2026

### Added

- **`code/docs/TASK-AUTHORING.md`** — the enqueue boundary, idempotency, retries, limits, queue routing, and broker-free testing. `celery[redis]>=5.3` has been a declared dependency with nothing consuming it: no `config/celery.py`, no task module, no `CELERY_*` setting, and no `worker` or `beat` service in any of the four Compose files. The guide is the design of record for the day a feature needs a task.
- **`code/docs/PROCESS-MODEL.md`** — worker class, event loop, and the ORM's synchronous boundary treated as **one topic rather than three**, because deciding any of them alone decides the other two badly. Also says where a task worker sits relative to the web process family. The web half is verified against `code/src/docker/`; the task half is not, and says so.
- **`code/docs/OBJECT-STORAGE.md`** — private-document storage over the S3 API: the adapter contract, presigned URLs, upload validation, and the private/public split against Cloudinary. `boto3` is declared and unconsumed, exactly as Celery is.
- **`code/docs/security/AUDIT-TRAIL.md`** — the owning guide for the audit record, and the **record** half of OWASP A09:2025. Table schema, the atomic write path, what goes in and what must never, the PII rule, retention, and tamper resistance. `MONITORING-AND-INCIDENT.md` keeps the alerting-and-response half; the A09 row in `OWASP-AND-CHECKLIST.md` now names both.

### Changed

- **Every one of these guides opens with an explicit status line.** _Declared, not wired_ — naming the dependency, where it is declared, and precisely what does not exist yet. A guide that reads as though the subsystem is running is worse than no guide: it sends someone looking for a module that was never written.
- **`code/docs/logging/OBSERVABILITY.md` is rewritten around four interfaces** — error tracking, log aggregation, metrics, traces — each leading with the interface the code is written against and naming the default as one implementation behind it. `sentry-sdk[django]` and `django-prometheus` are declared and unconfigured, and the guide now says so rather than implying otherwise.
- **The collector side is named as server infrastructure, not application concern.** Log shipper, metrics store and dashboards do not run in the local Compose stack; they are provisioned by the deploy repository. That boundary was previously implicit and routinely misread.
- **`how-to/docs/CELERY-FIRST-RUN.md`** is reconciled with the state of the tree — it described a first run of something the template does not stand up.

## [2.9.0] - 11/08/2026

### Added

- **`code/docs/architecture/PROVIDER-NEUTRALITY.md` — the rule for deciding what a dependency actually is.** Three kinds, and they are not interchangeable: a **protocol seam** (the code is written against a published wire format or API — S3, the Prometheus exposition format), an **adapter seam** (the code is written against an interface this project defines, with an implementation behind it), and **substrate** (the code is written against the product itself, and swapping it is a rewrite). Includes the evidence a neutrality claim owes before it is allowed to stand, and the standing rule that **one adapter is a hypothetical seam; two are real**.
- **`code/docs/architecture/BUILD-OPERATE-SEAM.md` — where a fact lives when three owners each hold part of it.** The code, the server contract, and the deploy repository routinely share one infrastructure fact between them. This names which part belongs to which, gives the two bridge shapes, and states the same-change rule that keeps the three from drifting.
- **`how-to/src/PLATFORM-PROVIDERS.md` — the per-project register.** Every infrastructure dependency, the interface it sits behind, its seam kind, and whether it may be swapped. The rule is the same in every generated project; this file is the answer sheet and it is yours.
- **Eight Copier questions recording platform choices** — `HOSTING_PROVIDER`, `OBJECT_STORE`, `ERROR_TRACKING`, `LOG_AGGREGATOR`, `OBSERVABILITY_STACK`, `TRACING_BACKEND`, `ANALYTICS_PROVIDER`, `INCIDENT_TRACKER`. Each records a **choice, not a dependency**: the guides name the interface and treat the product as one implementation behind it, so a project answering differently is still on-doctrine. All eight carry defaults, so `copier update --defaults` is unaffected.
- **`code/src/scripts/audits/seam-contract.sh` and its CI job.** `how-to/src/SERVER-ARCHITECTURE/` is the contract the deploy repository implements against, so every section stating a requirement must say where that requirement came from. Two mechanical checks: every repository path named in a `**Source:**` field resolves, and every numbered section carries one.

### Changed

- **`SERVER-ARCHITECTURE/` sections now carry `**Source:**` fields**, which is what makes the audit above possible — a requirement with no source is a requirement nobody can verify or update when the thing it came from changes.
- **`LOGGING.md`, `PERFORMANCE.md`, `ARCHITECTURE-PATTERNS.md` and `CORE-AND-SCALING.md` name interfaces where they previously named products.** Structured JSON on stdout rather than a named shipper; the Prometheus exposition format rather than Prometheus; the Sentry SDK wire protocol rather than Sentry.
- **The `backend` and `planner` agents** consult the neutrality rule before writing a dependency into a design, rather than after review finds it.
- **`how-to/src/TEMPLATE-TOKENS.md` and `TEMPLATE-GUIDE/05-ANSWERS.md`** document all eight new questions, keeping the token contract complete.

## [2.8.0] - 11/08/2026

### Added

- **`code/docs/DISCOVERABILITY.md` and its four sub-documents.** `WEB-METADATA.md` owns the `build_seo()` head pipeline; `STRUCTURED-DATA.md` owns the JSON-LD block; `ROOT-SURFACE.md` owns the root and `.well-known` register; `CONTENT-STRUCTURE.md` owns the page **body**, the fourth output surface and the one nothing previously governed.
- **A clean split with `project-management/docs/SEO-CHECKLIST.md`, stated in both files.** The checklist is **what must be true per page** before a story closes. The guide is **how this stack does it**. Neither restates the other, which is the same route-don't-restate rule the pairing standard applies to directories.
- **A `_(not a gate item)_` convention in the checklist**, marking roughly nine rows that describe good practice but cannot gate a story, so the gate stays honest about what it actually blocks on.
- **`research/DISCOVERABILITY-SKILL-ECOSYSTEM.md`** — the primary-source survey the corrections below came out of.

### Removed

- **Three answer-engine myths, deleted rather than left unticked.** Google states there are **no additional requirements and no special optimisations** for AI Overviews and AI Mode, and no new machine-readable files. Removed from `SEO-CHECKLIST.md`: **content chunking for RAG**, **fan-out query coverage**, and **per-engine optimisation** — the last of which also named five specific products as a requirement, against the provider-neutrality rule this template holds elsewhere. Cited to Google's _AI features and your website_.

### Changed

- **`llms.txt` is re-justified, not removed.** `ROOT-SURFACE.md` § 1 previously called it "the one leg of answer-engine discoverability", which is false — it is not a search or citation signal. It stays, justified honestly as **agent-facing**: for IDE agents and MCP clients that read rather than crawl, pointing at `code/docs/MCP-SERVER.md`.
- **`CONTENT-STRUCTURE.md` § 1 states there is no separate answer-engine discipline**, cited to the primary source, so the myth cannot quietly return as a new section.
- **`.claude/agents/seo.md`** — the `llms.txt`-as-GEO-lever claim is marked in place at both occurrences. The remaining techniques in that agent are ordinary SEO and are untouched.
- **`how-to/src/BRAND-VOICE.md` § 2 gains the reciprocal pointer** — shape is not voice. Content structure decides how a page is organised; the voice guide decides how it reads.

### Fixed

- **`WEB-METADATA.md` said content structure was "not settled doctrine here yet".** It now routes to the guide that settles it.

## [2.7.0] - 11/08/2026

### Added

- **`code/docs/NEGATIVE-SPACE.md` — the owning guide for what the code must never allow.** The governing principle, what counts as an invariant, the **enforcement-point register** in two halves, the invariant classes, the soft-delete trap, the one case where a constraint firing is not a bug, the three-class error taxonomy, and the guard clause. Every surface clause routes to the guide that already governs that surface rather than being restated here.
- **`how-to/src/INVARIANTS.md` — the per-project register.** Each invariant gets **exactly one named enforcement point**, database-enforced and service-enforced listed apart, with a worked row for shape and a section on what keeps the file true. The rule is portable; the register is yours.
- **`code/src/django/apps/core/` — the module the doctrine needs to exist.** `services/errors.py` carries `InvariantViolation` deliberately **outside** the `ServiceError` tree, because a broken invariant is a programmer error and must never be catchable as a user-facing failure. `schemas.py` provides three bases, one per API surface — `Schema` for request bodies, which is the one that carries `extra="forbid"`, plus `OutSchema` for responses and `QuerySchema` for query params, where forbidding extras would be wrong. `middleware.py` adds `RequestIDMiddleware` and `current_request_id()`.
- **`RequestIDMiddleware`, and the trust boundary it draws.** It reads the edge's `X-Request-ID` and mints a UUID4 only when one is absent or malformed. Inbound values are treated as untrusted — bounded alphabet, 200-character cap. The value lives in a `ContextVar`, not on the request object, so anything below the view can reach it without being handed a request.
- **A third invariant class enforced by the ORM's own errors.** `string_if_invalid` is set in dev and test only. Django's behaviour settles it: a non-empty value stops filters applying to invalid variables, and `{% if %}`, `{% for %}` and `{% regroup %}` read an invalid variable as `None` and never consult it. The production template surface therefore has **no loud failure by construction**, and that is recorded as an honest gap rather than papered over.

### Changed

- **`assert` is banned outside tests, and ruff now enforces it.** `S101` is no longer globally ignored; it is exempted per path for `*/tests/*` and `conftest.py` and nowhere else, and a `# noqa: S101` is a finding. Three reasons, all in the guide: an `assert` cannot carry the register key, it is indistinguishable from a failing test in the error tracker, and `python -O` strips it. Guard clauses `raise`.
- **`ninja.Schema` is banned by ruff `TID251`.** Django Ninja silently ignores unknown request-body fields by default; `extra="forbid"` fixes that and propagates by subclassing, so the only way to bypass it is to import `Schema` from `ninja` directly. `apps/core/schemas.py` is the one module allowed to.
- **`N818` yields to the taxonomy on two names.** `InvariantViolation` and `DependencyUnavailable` are not `*Error` on purpose: neither is a `ServiceError`, and the names carry that. `DependencyUnavailable` also avoids colliding with `EnvironmentError`, a built-in alias of `OSError`.
- **A breach surfaces as a 500 and a tracker event, never a friendly 4xx.** Added to `.claude/CLAUDE.md` § 6 as a non-negotiable, alongside the existing database-level-invariants rule it completes.
- **HTMX error handling is split by taxonomy class.** HTMX swaps on 2xx only, so a 500 replaced nothing at all. User errors keep the shipped 200-re-render; 500 and 503 go to **one global `htmx:beforeSwap` listener**, never a per-element handler.
- **The Rust surface denies the three panicking macros `panic = "deny"` does not cover.** `todo`, `unimplemented` and `unreachable` all live in clippy's `restriction` group, which `all` excludes, so each is denied by name in both crates. `unreachable!()` is included deliberately: a window that vanishes is no better for being unreachable in theory. `slint-build` emits `todo!()` into generated code, so the desktop crate's generated-code allow list is extended to match — the boundary the strict table draws stays exactly where it was.

### Fixed

- **`code/src/rust/Cargo.lock` is now committed.** A workspace with binaries needs its lock file in version control; without it the desktop and native builds resolved differently on every machine.

## [2.6.0] - 11/08/2026

### Added

- **`how-to/src/BRAND-VOICE.md` — how the project speaks, settled before the first feature.** Tone, the four registers, casing, punctuation, and the machine-authored tells that are banned outright. It ships as a template: § 1 and § 4 are the portable core, adopted unchanged; § 3 and § 5 carry placeholders for this project's own voice. Six agents and the `stack-htmx-templates` skill load it for every user-facing string.
- **`code/docs/VISUAL-DESIGN.md` — the same doctrine in composition rather than copy**, with per-surface sub-documents under `code/docs/visual-design/` (`WEB.md`, `MOBILE.md`, `DESKTOP.md`). § 3 pins a **named visual direction** on six axes, and it is what makes § 4.2's ban list decidable at all: without a direction there is no such thing as a deviation from it. § 4.1 bans the universal tells on every direction; § 5 is a numeric motion standard — frequency first, duration ceilings, easing as a hierarchy rather than a preference, and reduced-motion as fewer and gentler rather than none.
- **Four deterministic slop gates, split by input.** `copy-slop.sh` takes prose, `css-slop.sh` takes stylesheets, `template-slop.sh` takes Django markup, and `render-slop.sh` takes a viewport — the last because the repeated-device clauses in § 4.1 cannot be decided by any static scan. Each ships a CI workflow.
- **Two tiers in one run, following `cloc.sh`'s warn-at-750 / fail-at-800 precedent.** `[gate: fail]` is an unambiguous match and exits 1; `[gate: warn]` is a threshold, a ratio, or a word that is sometimes correct English, and is reported without failing. The tier scheme and its rationale live in `VISUAL-DESIGN.md` § 6, which is also the list of what a script can and cannot decide.
- **`code/src/scripts/desktop/style-check.sh` and its CI job** — the Slint surface picks a style whether or not you name one, so the build script now names it and the gate holds it. Copier-excluded on a project without the desktop surface, because a workflow shipped without its script is a permanently red job on every web-only project.
- **`README.md` § _Influences and attribution_ and `THIRD-PARTY-NOTICES.md`.** The design doctrine, the copy rules and the audit scripts derive from an open skill ecosystem; those sources are named with their licences. `THIRD-PARTY-NOTICES.md` is the separate, narrower obligation: the files that contain substantial portions of someone else's licensed work, carrying the notice that licence requires. It ships into every generated project, because the adapted files do and `LICENSE` is copier-excluded.
- **`research/ANTI-SLOP-RULE-SOURCES.md`** — the per-claim citations behind every derived rule, so the reasoning stays checkable.

### Changed

- **Two new non-negotiables in `.claude/CLAUDE.md` § 6, both about attribution.** Doctrine derived from an outside source is credited in the **same change** as the rule it credits — attribution written once decays, written alongside it stays true. And: use, adapt and redistribute are three different permissions. A share-alike source may be **read** as a checklist of concerns, but its text and rule wording may never be derived into anything this template redistributes, because every generated project would inherit the obligation. The licence column is consulted **before** deriving.
- **The first-time-setup ordering now has four prerequisite passes, not two** — project brief → brand voice → visual direction → `/scale-planning`, in that order, because each depends on the one before and the later documents are themselves written in the voice the earlier one settles. All four are cheap before the first feature and expensive after the tenth.
- **`DESIGN.md` and the four design workflows (`06`, `07`, `08`, `17`)** route to the two new guides rather than describing taste in their own words.
- **The desktop surface composes its own look.** `build.rs` names Fluent explicitly — from Slint 1.16 the fallback is Fluent on every platform, so saying nothing shipped a vendor look on macOS and Linux that nobody chose — and `app.slint` reads colour and rhythm from `Palette` and `StyleMetrics` so the built-in widgets stay structural scaffolding rather than the design itself.

### Fixed

- **`copy-emdash.sh` and `css-gradients.sh` cited a section that has since split.** Both predate the four new gates and pointed at `VISUAL-DESIGN.md` § 4, which now has two halves that mean different things. Each now names § 4.1 — a universal tell, banned on every direction and every surface — rather than the parent section that also contains the per-direction deviations.

## [2.5.0] - 11/08/2026

### Changed

- **Grilling asks in frontier rounds, not one question per message.** The **frontier** is every question whose prerequisites are already settled. All of it goes into a single numbered message; the agent then stops and waits. The answers settle decisions, which pushes the frontier outward and unblocks questions that were previously unanswerable, and the next round is recomputed from there. The old mechanic made a ten-decision design cost ten exchanges, each carrying the full re-orientation overhead, and it is now named as an explicit anti-pattern along with its opposite — front-loading questions whose answers would only be guesses.
- **`.claude/skills/grilling/SKILL.md` owns the interview's shape, and nothing else restates it.** The round mechanics, the exact question format, and the recommendation rule live in that one file. Every agent, workflow and skill that opens a grilling pass now names **what** must be settled and routes to the skill for **how**. This is the fix for a specific failure: the mechanic was restated across dozens of files, so changing the skill alone would have left every one of them contradicting it.
- **The question format is fixed and stated once.** Numbered, titled, brief options, and an explicit `➡️ Claude recommends N` with its reason in one line. Always recommend, always justify, and never soften the recommendation because the answer leaned the other way — sycophancy is called out in the skill as a failure mode, not a courtesy.
- **A lookup in flight never blocks a round.** The rule is now explicit: treat it exactly as an unanswerable question — hold it for the next round and ask the rest immediately.
- **`.claude/CLAUDE.md` §10 no longer describes the interview.** It states that substantial work in every layer opens with a grilling pass, that this supersedes every static _Clarify Before Planning_ / _Required Information_ / _Clarifying questions_ checklist project-wide, and routes to the skill. A restatement drifts the moment the skill changes.

### Added

- **`AskUserQuestion` is denied in `.claude/settings.json`.** Questions are asked in the chat as prose, so an answer can be a number, a counter-proposal, or a redirect in the reader's own words — none of which a multiple-choice widget accepts. The deny entry removes the widget only: the _take no action until confirmed_ gate comes from the grilling rule, not from the tool being absent.
- **Two project-memory entries recording both decisions** and, more importantly, the standing rule they produced: route for the mechanic, never restate it.

### Fixed

- **Agents and workflows that promised an interview the skill no longer runs.** Fourteen agents, five workflow `STEPS.md` files, seven skills and two template-guide pages each described the one-question-at-a-time mechanic in their own words; all now route to the skill instead.

## [2.4.0] - 11/08/2026

### Added

- **`code/docs/DOCUMENTATION-PAIRING.md` — the owning guide for a rule that had no home.** The split was stated in three places (root `CONTEXT.md`, `.claude/CLAUDE.md`, and by example in every folder) and owned by none, which is the condition under which a rule drifts. The guide states it in one sentence — _`CONTEXT.md` says what is here and why it is here; `CLAUDE.md` says how to work here_ — then gives the decision test for a sentence that could go in either, the headings that never belong in an orientation file, and the route-don't-restate rule that keeps a fact in exactly one place.
- **`code/src/scripts/audits/docs-pairing.sh` — the mechanical half, enforced.** Checks the pairing both directions, the four required `CLAUDE.md` H2s, the `@./CONTEXT.md` import, the `Read order:` line, and the banned orientation headings. Wired into CI as _Audit — Docs Pairing_ and into `lefthook.yml` at pre-commit. Deliberately **unscoped**: the checks are cross-file, so a per-file run cannot see a `CLAUDE.md` whose `CONTEXT.md` was just deleted.
- **`code/src/scripts/audits/docs-length.sh` — the 300-line instructional cap gets its own gate.** Measured in `cloc` code lines over `**/docs/**/*.md`, `**/workflows/**/*.md`, `.claude/**/*.md` and every `CONTEXT.md`/`CLAUDE.md`. Root-level `*.md` and `**/src/*.md` are exempt — a README and an operator guide are read by humans start to finish, and capping them optimises for the wrong reader. A `CONTEXT.md` or `CLAUDE.md` inside an exempt tree is still bound. CI job: _Audit — Docs Length_.
- **`code/src/scripts/development/sync-trees.sh` — Directory Tree blocks reconciled at commit time.** Scoped to `--staged`, so a one-file commit does not walk 195 trees. It **adds** a missing row and never deletes one: a row naming something absent is usually a gated surface or a naming pattern, not drift. An added row carries `← TODO: what this is and why it is here` and **fails the commit** — the description gets written while the author still knows the answer, which is the only moment anyone ever does.

### Changed

- **`cloc.sh` no longer measures Markdown, and the rule now says so.** It excludes Markdown by design, so pointing the instructional cap at it measured nothing. `.claude/CLAUDE.md` §8 now names `docs-length.sh` explicitly and states the exemptions, because the previous wording sent every reader to the one script that could not answer.
- **Every `CLAUDE.md` in the tree conforms to one shape** — `@./CONTEXT.md` (plus `@./REFERENCES.md` where the directory has one), a `Read order:` line, then exactly four H2s: _Purpose (one line)_ · _How to work here_ · _Guardrails_ · _Output & naming_, scaled to the folder.
- **Every workflow `CONTEXT.md` conforms too.** _Hard gates — read before executing Step 1_ / _Soft references — consult during execution_ became **Governing documents** / **Related reading**: the old names described when to read a file rather than what it is, which is an operating rule wearing an orientation file's clothes. `Prerequisites`, `Quality gates` and `Naming` headings are gone from orientation files for the same reason — each now lives once, in the paired `CLAUDE.md` or the workflow's `CHECKLIST.md`.
- **Each orientation file opens by saying why the thing it describes exists**, rather than starting cold with a tree. A directory listing tells you what is there; it does not tell you why you would go.
- **`.markdownlint-cli2.jsonc` and `.prettierignore` exclude `**/reports/**`and`code/src/rust/target/`.** An audit run with `--output md` was capable of failing the format gate it exists to complement.

### Fixed

- **Workflow headings left stale by the 2.0.0 renumber.** `## Workflow 13 — Decisions (ADRs)` in `workflows/14-decisions/`, and its siblings across the PM layer, named the number the folder had before that release.

## [2.3.1] - 03/08/2026

### Fixed

- **`.copier/` survived an update, leaving four stray staging files in the project.** 2.3.0 began shipping the root version files from a `.copier/` staging directory that a post-generation task moves into place and removes. Those tasks run on `copier copy` and never on `copier update` — which is what makes the seeds seed-once, and is therefore the point — but it also meant an updating project received `.copier/CHANGELOG.md`, `.copier/RELEASES.md`, `.copier/VERSION` and `.copier/VERSION-HISTORY.md` and simply kept them. Harmless to the build, actively confusing to read: four files that look like the project's version state, sitting next to the real ones.
- **Fixed with a `_migrations` entry that removes `.copier/` after any update.** Deliberately not version-scoped: it must hold for every future release that stages a file this way, not only the one that introduced the problem. `rm -rf` on a normally-absent directory is a no-op, so running it on every update costs nothing.

Caught by updating a real project rather than by review — the same lesson as 2.1.1, which is that a mechanism split across `copy` and `update` needs exercising on both paths before it ships.

---

## [2.3.0] - 03/08/2026

### Fixed

- **Every generated project inherited syntek-base's version and release history.** `VERSION`, `CHANGELOG.md`, `RELEASES.md` and `VERSION-HISTORY.md` shipped from the repo root unmodified, so a brand-new project declared itself version `2.1.1` and its changelog documented twenty releases of the template's own development. Verified against the four projects generated before this release: each carried twenty `CHANGELOG.md` entries, twenty `RELEASES.md` sections and twenty `VERSION-HISTORY.md` rows, none of which were theirs.

### Changed

- **Root version state is now seeded fresh from `.copier/`.** The four files are `_exclude`d from generation and shipped from a staging directory that a post-generation task moves into place, exactly as `README.md` already worked. A new project starts at `0.1.0` with one entry describing its own scaffold.
- **Seeded once, never updated.** `_tasks` run on `copier copy` and never on `copier update`, so a template update can no longer overwrite a project's release history with the template's. The corollary is deliberate and now documented: template improvements to those four files never reach an existing project either — they are the project's own from the moment it exists.

### Added

- **Two CI assertions in `Audit — Template Integrity`.** _A generated project starts fresh at 0.1.0_ checks `VERSION`, requires exactly one entry in each of the three history files, and confirms the `.copier/` staging directory was removed. _Sub-package version files are pinned at 0.1.0_ checks that `code/src/django/` and `code/src/mobile/` version documents remain single-entry seed content.
- **The rule, written down where it cannot leak downstream.** `CONTRIBUTING.md` § 1b: in this repository a version bump edits exactly six root files and never a versioning document elsewhere in the tree. The sub-package documents are seed content for generated projects and stay pinned at `0.1.0`; bumping them here would hand every new project a sub-package history describing the template's development. Scoped to syntek-base — a generated project has real sub-packages that legitimately release on their own tracks.
- **`VERSIONING-GUIDE.md` → _Your version history is yours_**, explaining the seed-once mechanism and its trade-off to the people who inherit it.

---

## [2.2.0] - 03/08/2026

### Added

- **`code/src/scripts/audits/template-orphans.sh` — detects artefacts a template update stranded.** When a release renumbers or moves a directory, Copier relocates the scaffolding it owns and deletes the old path, but developer-authored files were never template files, so they stay behind. No conflict is raised, nothing fails, and the update reports success. Every template-owned directory under `project-management/src/` ships a `CONTEXT.md`, which makes the signature exact: **content present, `CONTEXT.md` absent**. Wired into CI as `Audit — Template Orphans`.
- **`code/src/scripts/development/template-update.sh` — preview an update before it touches anything.** Clones the project to a scratch directory, runs the update against the copy, and reports what changes, what is deleted, what conflicts, and what would be orphaned. Refuses to `--apply` when orphans are predicted unless `--force-orphans` is given. This is `14-UPDATING.md`'s "diff in a scratch directory first" advice turned into one command, because prose nobody executes prevents nothing.
- **`copier.yml` → `_migrations`, with a v2.0.0 entry.** Copier has supported migrations since 9.0.0 and this template required 9.0.0 without using them. The new `.copier/migrations/v2.0.0-renumber-src.sh` moves developer artefacts out of the twenty folders that 2.0.0 renumbered and into their replacements, preserving sub-paths, never overwriting on a name collision, and idempotent on re-run. Anyone still on 1.x now gets their stories and ADRs carried across instead of silently stranded.

### Changed

- **`project-management/src/` folder numbers are frozen — append only.** The distinction that was missing: a `workflows/` folder is a **procedure**, wholly owned by the template, so renumbering it is a reference sweep whose worst case is a broken link. A `src/` folder is a **data store** holding work the template has never seen, so renumbering it is a schema migration Copier cannot perform. A new artefact folder now takes the next free number at the end even where that breaks the workflow↔`src` mirroring — the mirroring is a convenience, the developer's work is not. Recorded in `project-management/src/CONTEXT.md`, `src/CLAUDE.md`, `workflows/CONTEXT.md` and `workflows/CLAUDE.md`.
- **Any release that must move a directory holding developer artefacts ships a migration in the same commit.** Stated in `copier.yml` beside `_migrations` and in `12-EXTENDING.md`.

### Fixed

- **`12-EXTENDING.md` told you PM workflow numbers were not a sequence.** They are — that layer's numbers are a running order, unlike `code/workflows/` and `how-to/workflows/`, whose numbers are stable identifiers. The guide now distinguishes all four trees, including the frozen `src/` rule.
- **`14-UPDATING.md` and `15-TROUBLESHOOTING.md` documented conflicts but not the silent failure.** Both now lead with it, including a "my stories vanished after an update" entry that names the audit and the recovery.

---

## [2.1.1] - 03/08/2026

### Fixed

- **The template-integrity CI probe could not generate a project.** `PROJECT_DESCRIPTION`, added in 2.1.0, has no default, so the `Audit — Template Integrity` job's `copier copy --defaults` invocation failed with `Question "PROJECT_DESCRIPTION" is required` before any of its assertions ran. Both render paths now pass the new question, and so does the equivalent snippet in `.github/PULL_REQUEST_TEMPLATE.md`, which had the same gap and would have sent every contributor down the same dead end.
- **No effect on generated projects.** Both files are in `copier.yml` → `_exclude`, so nothing a generated project holds changes in this release; `copier update` from 2.1.0 to 2.1.1 is a no-op beyond the version metadata.

---

## [2.1.0] - 03/08/2026

### Added

- **`PROJECT_DESCRIPTION` — a Copier question for the project brief.** One or two sentences on what the project does, who it is for, and what it replaces. It opens the root `CONTEXT.md` under a new _What this project is_ heading, and because `.claude/CLAUDE.md` imports that file it becomes the first thing every agent reads in every session. It also fills the `description` field of `pyproject.toml` and `package.json` (neither had one) and the blurb in the generated `README.md`. Two validators: a 40-character floor, because a tagline is not a brief, and a rejection of double quotes, because the value lands in two manifests.
- **Describe-then-size runs before the first feature.** `how-to/workflows/01-first-time-setup/` gains Steps 7 and 8, which run once per project after the stack is up and before anything is charted: sharpen the generated brief into a real one (what it does, who for, what it replaces, what it deliberately is **not**), then run `/scale-planning`. The value of the second is not the server tier — it is forcing the sizing questions while they are still cheap, and producing the explicit **not required** list that stops the first feature carrying machinery it will never use. `01-feature` lists both as prerequisites and reads `SCALE-ARCHITECTURE/` as ground truth; neither is a hard gate, because charting without them is possible — it just surfaces every sizing question as a decision node, one feature at a time.
- **`GAPS.md` and `DEFERRED.md` are read at the discovery gate, not only written.** A new `/wayfinder suggest` mode mines the standing register for candidate features, clustering entries by shared cause, surface, or dependency — five deferrals waiting on the same missing table are one feature, not five — and puts them to the developer ranked. Charting then triages **every** open entry against the feature being planned: **closes** (recorded under a new _Register claimed_ section on the map, and part of what "done" means), **blocks** (a frontier node, not an assumption), or **unrelated** (counted, so the triage is provably exhaustive).
- **The claim/close boundary.** `01-feature` claims a register entry; `21-implementation-documentation` closes it against shipped code, and is now the only place that marks `✅ CLOSED` or removes a `DEFERRED.md` row. A claim the story did not in fact retire stays open, and the reason becomes a finding. A claim is a promise; a close is evidence.

### Changed

- **Code comments and docstrings carry the _why_ only.** The canonical standard (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` §4, mirrored in `code/docs/coding-principles/STYLE-AND-PROCESS.md`) previously mandated the opposite in three places — "what it does (not how)" for docstrings, and inline comments explaining "**what** and **why**". The code states the what; a comment restating a name or a type is a duplicate fact that drifts. Docstrings are now one line on why the thing exists, with no `Args:`/`Returns:`/`Raises:` block, because the typed signature already carries them.
- **A comment never points outside its own file.** No story (`US###`), sprint, ADR, plan, bug record, ticket, PR, commit, `code/docs/*` path, URL, person, or date — the reason must travel in the comment, because a reader who cannot open the reference still has to understand why. Scope is application source that ships in a deployable; declarative configuration and `code/src/scripts/**/*.sh` are exempt, because there the reference **is** the content. The one exception is published interface text: Django Ninja endpoint docstrings and `summary` render on the OpenAPI page, and a FastMCP tool docstring is the prompt a model reads, so both state the full what.
- **`TODO`/`FIXME` are no longer permitted in committed code.** The old rule required a ticket reference, which is exactly the outward pointer now banned. Deferred work goes to `DEFERRED.md` or `GAPS.md`, which are read and triaged.

### Fixed

- **Broken token substitutions across sixteen files.** The de-tokenisation pass left three distinct defects: paths concatenated with their filename (`` `the project's plans folderPLAN-US000-TEMPLATE.md` ``), placeholder prose where a number belongs ("next free number is `` `a decision record` ``", and in `wayfinder` the doubly-garbled "a new ADR — the project's decision register (next free number is the project's decision register)"), and prose standing in for a path. All now resolve to `project-management/src/14-DECISIONS/` and `.../16-STORY-PLANS/`, verified to exist on disk.
- **Origin-project references leaking into the template.** `wayfinder` cited "the Design Studio epic … US208–US214" and `prototype` cited `PLAN-US207-DESIGN-STUDIO.md` as live worked examples; the template ships no stories, so both were dangling. `MAP-SCALE-PLANNING.md` was placed in the plans folder in four files — it is a map, so it belongs in `src/01-FEATURE/`.
- **`PLAN-US###` normalised to `STORY-PLAN-US###`** in six files, matching the naming convention the PM layer has always used.
- **Five comments in the shipped Django, mobile, Rust and Slint skeletons** pointed at `code/docs/*` paths, in breach of the standard added above. Each reworded so the reason travels in the comment.
- **Copier question counts were stale in three guides** — `TEMPLATE-TOKENS.md` claimed twenty-four tokens and `05-ANSWERS.md` twenty-four questions when the real figure was twenty-nine; `06-GENERATION.md`'s pipeline diagram still said twenty-one. All corrected to thirty (twenty-six always asked, four conditional on the optional surfaces).

---

## [2.0.0] - 03/08/2026

### Added

- **The planning cadence is now explicit: plan one story at a time, all the way through.** A story runs `02-story-creation` → `14-decisions` before the next one starts, so each story is planned against everything the previous ones settled. The rationale is recorded where the loop lives (`project-management/workflows/CONTEXT.md`): a human thinks the work through at plan time so implementation is mechanical. It assumes real PM and development knowledge — and the gate sequence is what carries someone who does not yet have it.
- **A sprint is planned when it fills, not at the end of a backlog-wide checks phase.** Each story clearing `13` is slotted into the open `SPRINT-##.md` with its points; at `SPRINT_CAPACITY_SP` (grace `SPRINT_GRACE_SP`) planning pauses while `15-sprint-plans` and `16-story-plans` run for that sprint, then resumes. Canonical rules and the ceiling: `project-management/docs/PLANNING-GUIDE.md` → _Sprint Capacity_.
- **Two Copier questions — `SPRINT_CAPACITY_SP` (11) and `SPRINT_GRACE_SP` (13)**, with a validator forcing grace above capacity. These close a real hole: `.claude/agents/sprint.md` already claimed the guide defined a point ceiling, and it never did.
- **`project-management/workflows/01-feature/` and `src/01-FEATURE/` — discovery, once per feature.** Wayfinder charts the feature's decision frontier, then each node is settled one at a time and graduated to an ADR, plan, or story. The resolved `MAP-<FEATURE>.md` is what stories are cut from, and what stops every later grilling pass re-asking the same cross-cutting questions. Its reading order is deliberate: `CONTEXT.md` → `CLAUDE.md` → the relevant `docs/` guides → **the whole of `project-management/src/`** → the codebase. Because every story closes with `IMPLEMENTATION/` records stating where the build diverged from the plan, reading `src/` shows what was actually built rather than what was once intended.
- **`how-to/src/TEMPLATE-GUIDE/09-PROJECT-MANAGEMENT.md`** — how to use `project-management/src/`: the five tiers, the workflow↔`src` mirroring, the three-stage vs two-stage folder patterns, a which-folder-when table, and the four ways people get it wrong. `09-FIRST-STORY.md` became `10-FIRST-FEATURE.md` and now opens by charting the feature, because work no longer starts with a story.
- **`project-management/docs/planning/`** — `CADENCE.md`, `STORIES.md`, `SPRINTS.md`, behind the thin `PLANNING-GUIDE.md` index, on the `GDPR-GUIDE.md` → `gdpr/` precedent. The capacity figure is stated once, in `CADENCE.md`.
- **`project-management/workflows/17-consolidate-design-work/`** — the second half of the per-story bargain. Planning per story means design arrives per story and drifts by construction; once every story is through `15`, this workflow reconciles it into one coherent design before any code. It resolves `04-DATABASE` first, because schema fragmentation is the expensive kind, and its Step 7 corrects any story plan the consolidation invalidated — otherwise the developer codes from a plan asserting a superseded design.

### Changed

- **PM workflows renumbered again, +1 across the board** (`01`–`22` → `02`–`23`) to open `01` for the feature-discovery gate, and `src/` `01`–`20` → `02`–`21` alongside it so the `01`–`16` workflow↔`src` mirroring survives. ~2,455 references across every layer. `code/workflows/` and `how-to/workflows/` numbering is untouched — those are catalogues, where numbers are stable identifiers.
- **`SPRINT-PLANNING-GUIDE.md` → `PLANNING-GUIDE.md` + `planning/`.** The old name had stopped describing its contents once the cadence — which governs `01`–`17`, not sprint planning — moved into it.
- **`12-seo-checks` is now a planning gate, not a verification one.** It sat in the specify tier but required a deployed page, which made it impossible to run in its own slot. It now sets per-dimension SEO targets before the page exists; auditing the built page, Lighthouse, and the `IMPLEMENTATION/` record moved to `21-implementation-documentation`, which already owned every other implementation record. Its model moves Opus → Fable, because choosing a schema type and an indexing posture is judgement, not measurement.

- **`src/04-DATABASE` … `src/08-WIREFRAMES` are now three-stage:** `USER-STORY-IDEAS/` → `CONSOLIDATED-IDEAS/` → `IMPLEMENTATION/`. Stage 1 is **frozen** once workflow `16` runs — it is the audit trail of what each story asked for. Stage 2 is **what gets built**. Each folder keeps one cumulative asset outside the stages (`ERD-DIAGRAMS/`, `DIAGRAMS/`, `guide-build/`, `component-build/`, `SHARED/wireframe.css`); the brand and component PDFs are regenerated once, at consolidation, not per story. `08-WIREFRAMES/SCREENS/` is absorbed into the stage folders.
- **Folders `09-GDPR` … `13-API-DESIGN` keep their two-stage `PLANNING/` + `IMPLEMENTATION/` split.** A lawful basis or an API contract is genuinely per story and does not fragment a shared system, so it needs no consolidation pass.
- **PM workflows `16`–`21` renumbered to `17`–`22`** to make room at `16`. Unlike `code/workflows/` and `how-to/workflows/` — catalogues where numbers are stable identifiers and are never reused — PM workflow numbers are a **running order**, so inserting mid-sequence is legitimate here. 413 references updated across 161 files. Historical entries in this file and `RELEASES.md` are left as written: they record what those releases actually shipped.

### Removed

- **`project-management/docs/SPRINT-PLANNING-GUIDE.md`** — replaced by `PLANNING-GUIDE.md` and `planning/{CADENCE,STORIES,SPRINTS}.md`.
- **`project-management/src/08-WIREFRAMES/SCREENS/`** — absorbed into the three-stage folders: per-story screens to `USER-STORY-IDEAS/`, the built set to `CONSOLIDATED-IDEAS/`.

### Fixed

- **Twenty `IMPLEMENTATION/` folders credited `pr-and-review` for writing their records.** Workflow `21-implementation-documentation` explicitly absorbed that duty — its own `CONTEXT.md` says the PR workflow "now only **verifies** these records". Every one now routes correctly.
- **Three workflows had no grilling pass at all** — brand guides, wireframes, and sprint plans — despite `.claude/CLAUDE.md` §10 making it the default for substantial work. Each now opens with one.
- `.claude/skills/wayfinder/SKILL.md` referenced the map as `` `the project's plans folderMAP-<EPIC>.md` `` — a token substitution that had lost its separator. Maps now resolve to `src/01-FEATURE/`.
- `21-implementation-documentation/CONTEXT.md` was still titled "Workflow 19".

- `PLANNING-GUIDE.md` documented sprint plans as `SPRINT-PLAN-##.md`; `src/15-SPRINT-PLANS/` has always used `{exec-order}-SPRINT-PLAN-{sprint-number}.md`. The guide now matches, and explains why the two segments diverge.
- `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` claimed twenty-one Copier questions; there were twenty-seven before this change and are now twenty-nine.

---

## [1.2.0] - 02/08/2026

### Added

- **An optional native desktop surface, gated by the new `INCLUDE_DESKTOP` question.** A **Slint** application at `code/src/rust/crates/desktop/` — a real native binary, not a webview or an Electron shell. The question is only asked when `INCLUDE_RUST` is true, because Slint is Rust, and both default to `false`.
- **It is a member of the existing Rust workspace, not a second one.** `members = ["crates/*"]` is a glob, so the workspace adapts with no edit and there stays exactly one `rust-toolchain.toml`, one `deny.toml` and one `clippy.toml`. `slint` is pinned in the crate rather than `[workspace.dependencies]`, since one member uses it. Lint, test, audit and build therefore come from the existing Rust script group — `code/src/scripts/desktop/` carries only the two genuinely desktop-specific operations, `run.sh` and `package.sh`.
- **`desktop` agent, `stack-slint` skill, `code/docs/DESKTOP.md` + two sub-docs, and `code/workflows/13-desktop-app/`** — all excluded together with the crate.

### Changed

- **`deny.toml` now carries Slint's licence exceptions and two accepted advisories.** These are unconditional, because no file in this template has conditional contents; on a project without the desktop surface they match nothing and cargo-deny reports an informational note rather than an error.
- **`code/src/` describes four surfaces.** Desktop is a distinct _surface_ (its own delivery target and release cycle) inside a shared _workspace_ — the first time those two ideas come apart in this repository, and worth reading `code/src/CONTEXT.md` for.

### Security

- **Two `quick-xml` advisories (RUSTSEC-2026-0194, -0195) are accepted, with justification and a re-check date.** Both are denial-of-service issues reached **only** through Slint's accessibility stack (`accesskit_unix` → `atspi` → `zbus_xml` → `quick-xml`), and every version pin up that chain to Slint's own `=1.17.1` blocks the patched 0.41.0. The parser handles D-Bus introspection XML from the **local** AT-SPI session bus, not network or user input; an attacker able to publish malicious XML there already owns the session. **Removing AccessKit is not the mitigation** — it is what makes the app usable with a screen reader. Re-check 02/11/2026.
- **`unmaintained` is now scoped to `workspace`.** You can act on your own direct dependency choices; you cannot act on one buried three levels inside a GUI toolkit, and a permanent ignore list of other people's transitive crates rots silently.

### Licensing — read before enabling

- **The app ships under Slint's Royalty-free tier**, which permits proprietary **and commercially sold** desktop applications at no cost, in exchange for **disclosing that you use Slint**. The `AboutSlint` widget is that disclosure and `code/src/scripts/desktop/package.sh` refuses a release build without it — a licence gate, not a lint.
- **The tier does not cover embedded systems** (an appliance screen, a POS terminal, a car dashboard), **nor redistributing anything that exposes Slint's own APIs.** The second is why desktop UI is never moved into a shared package layer, and why desktop panels are duplicated across applications rather than shared. That duplication is a deliberate, priced decision.
- This is a reading of the licence text, not legal advice.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.1.0] - 02/08/2026

### Added

- **An optional Rust surface, gated by the new `INCLUDE_RUST` question.** A Cargo workspace at `code/src/rust/` for PyO3 extension modules, standalone binaries, CLI tools and services — with `nativecore`, a baseline PyO3 crate, as its first member. It follows the `INCLUDE_MOBILE` precedent exactly: templated `_exclude` entries are the single conditionalisation mechanism, no file gains templated contents, and the indexes list the new rows unconditionally with a **rust-only** flag. A project generated with `INCLUDE_RUST: false` gets **no new or removed files** — verified by diffing a `1.1.0` web-only generation against a `1.0.0` one. Sixteen files differ in content: the documentation indexes gaining flagged rows, the version metadata, and one comment in `pyproject.toml`. The tree is unchanged; it is not byte-identical, and that distinction matters when reviewing a `copier update` diff.
- **The flag gates authoring, not consuming.** A project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and needs no toolchain — it answers `false`. `true` means _this repository compiles Rust_, which makes `rustup` a prerequisite for `uv sync` and adds a Rust stage to the backend image. That cost is why the default is `false`, and why the distinction is stated in `TEMPLATE-TOKENS.md`, `05-ANSWERS.md`, the guide, the skill and the agent.
- **`rust` agent and `stack-rust` skill**, excluded together with the tree — a Rust agent with no Rust to work on is worse than no agent at all. Both carry the gate question as their opening move: Rust earns its place only on a guarantee Python cannot make, or a **measured** hot path.
- **`code/docs/RUST.md` and three sub-documents** — `rust/PYO3-BOUNDARY.md` (never panic across FFI, thin-boundary shape, error mapping, the GIL, `abi3`), `rust/MEMORY-HYGIENE.md` (why Python cannot erase a secret, zeroize-on-drop, constant-time comparison, and the limits it does _not_ cover — copies, swap, core dumps), and `rust/SUPPLY-CHAIN.md` (why a crate is more dangerous than a Python package, and what `deny.toml` enforces).
- **`code/workflows/12-rust-extension/`** — appended, never renumbered, per the stable-identifier rule. Entered from PM `18-backend-code`; Step 1 is a grilling pass whose first question is the gate.
- **`code/src/scripts/rust/`** — `build.sh`, `test.sh`, `lint.sh`, `audit.sh` plus `_common.sh`. The second script group keyed by stack rather than operation, and the second to run on the host rather than in Docker; the toolchain pin is what keeps a host run and the image's build stage identical.
- **`syntax-rust.yml`** — clippy at `-D warnings`, the Rust test suite, and `cargo-deny`. The workflow file is itself rust-only, so there is no job to guard on a project without the surface.
- **`code/docs/encryption/RUST-CRYPTO.md`** — the dual-path branch of the encryption guide.

### Changed

- **`code/src/` now describes three surfaces rather than two.** The native surface is the odd one: it has no separate runtime, because a PyO3 extension is loaded **into** the web surface's process and shares its address space. That is precisely why its supply chain is gated harder than any Python dependency.
- **Fernet remains canonical for field encryption.** Native crypto is a branch for what Fernet structurally cannot do — constant-time comparison, and wiping key material Python cannot erase — never a replacement. Keeping the two paths separate is deliberate: two implementations of the _same_ concern is a parity burden that drifts, whereas two covering _different_ concerns is a boundary. It also keeps `syntek-base` usable by anyone outside <%ORG_NAME%>, which a hard dependency on a private wheel would not.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.0.0] - 02/08/2026

### Changed

- **The template is now stable.** The root version track leaves `0.x` and enters `1.0.0`. Nothing in the generated project changes as a consequence — this release is a **statement about support, not a code change**. The surface a generated project inherits is exactly the one 0.14.0 produced, and the two are functionally identical.
- **What `1.0.0` commits to.** From here the Copier answer file (`copier.yml`'s twenty-two questions, or twenty-four with the mobile surface), the three-layer directory contract (`code/` · `how-to/` · `project-management/`), the `CONTEXT.md` + `CLAUDE.md` pairing rule, and the numbered workflow identifiers are treated as the template's public interface. A breaking change to any of them now requires `2.0.0`, which is the guarantee the `0.x` track could not offer — under semver, `0.x` permits a breaking change in any minor bump, and this template used that latitude repeatedly (the workflow renumbers in 0.14.0 and the PM renumber in 0.8.0 would each have been a major bump under this policy).
- **The `0.1.0`–`0.14.0` track is reclassified as pre-release history.** Those fourteen versions are published as GitHub pre-releases; `1.0.0` is the first entry marked latest. The reclassification is presentational — the commits, the changelog entries and the release notes are unchanged.

### Removed

- **`.claude/MEMORY.md` emptied of its template-development entries.** It carried five notes accumulated while `syntek-base` itself was built — the "surface" vocabulary, the one-way optional-content gate, the Expo pin matrix, the `glob` override, and the expo-router route-collision rule. Every one is reasoning about **how the template was constructed**, which a generated project inherits as noise: it describes decisions already made, in a repository the reader is not working in. The file ships with its three headings (`Feedback`, `Project Patterns`, `Project State`) and its write-policy preamble intact, so a generated project starts recording against an empty store rather than deleting someone else's notes first. Where that reasoning is durable it already lives in the right place — `code/src/CONTEXT.md` defines _surface_, and `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md` holds the gating rationale.

### Fixed

- Nothing. No defect is addressed in this release; `0.14.0` is the last release carrying fixes.

---

## [0.14.0] - 02/08/2026

### Added

- **`code/docs/MCP-SERVER.md` and its `mcp-server/` sub-tree** — the design of record for a FastMCP tool surface at `/mcp/`, serving LLM agent clients beside Django Ninja's `/api/`. Four sub-documents: `MOUNTING.md` (the `config/asgi.py` Starlette composition), `TOOL-DESIGN.md` (tools over the service layer), `AUTH-AND-THREATS.md` (`TokenVerifier` and the MCP threat model), `TESTING-AND-OPS.md` (in-memory `Client` tests, observability, rollout). **Nothing is mounted and `fastmcp` is not a declared dependency** — the same available-but-unwired status Django Ninja itself holds.
- **The two-adapter rule, stated once.** MCP tools and Ninja endpoints are peers over one service layer; neither calls the other and neither holds logic. Ninja alone made that seam hypothetical — a second adapter makes it real.
- **`.claude/skills/stack-fastmcp/`** — the MCP idioms, loaded on demand by `backend` (tools), `security` (the threat surface) and `test-writer` (in-memory client tests). No new agent: MCP tools are backend service-layer work, and the roster stays non-overlapping.
- **Five new `how-to/` workflows**, each mapping onto scripts that already exist: `04-database-operations` (backup, restore, reset, seed, users — 8 scripts that had no workflow), `05-testing-and-coverage` (8 runners), `06-quality-gates` (the 8 pre-PR gates + 7 audits), `07-dependency-updates`, and `09-write-operator-guide` — the meta-workflow for authoring operator documentation.
- **`.claude/agents/operator-docs.md`** — a specialist owning `how-to/docs/*` and `how-to/src/*`. Justified by three testable differences from `doc-writer`: different audience (running the system vs writing code), different length standard (`how-to/src/` is the sanctioned exemption from the 300-line cap), and different verification (a runbook is proven by executing it). Completes a three-way split with `support-articles`, which owns end-user help.
- **`.claude/skills/runbook/`** — the operator-doc craft: the fixed spine (purpose → prerequisites → steps with expected output → failure modes → rollback → verification), script-first command discipline, and the execute-to-verify rule.
- **`code/workflows/05-mcp-server/`** — the procedure, opening with a gate question (is an agent genuinely the caller, or would an HTTP client do?) and running through mount, verifier, tools, tests and hardening. Entered from PM `19-api-code`, never from a design gate.
- `/api/` and `/mcp/` documented as **machine prefixes** in `code/docs/URL-STRATEGY.md`, which previously named only the four human-facing surfaces. `/mcp/` is a sibling of `/api/`, never nested inside it.
- `fastmcp` added to the "deliberately NOT declared at baseline" register in `pyproject.toml`, with its trigger condition — an agent must carry out this project's domain operations, **not** "expose the API to AI".

### Changed

- `backend`'s remit widened from "Django Ninja endpoints" to "Django Ninja endpoints and the FastMCP tool adapter"; `security` and `test-writer` gained MCP routing lines. `code/workflows/CLAUDE.md` now describes eleven workflows, not ten.
- `config/CONTEXT.md` records that `asgi.py` is the one file an MCP surface changes, and that the mount sits outside Django's middleware chain.
- **The nine how-to workflows regrouped into four families** — set up (`01`–`02`), run (`03`–`07`), diagnose (`08`), author (`09`) — matching the shape the code layer now has. `02-daily-development` → `03`, `03-debugging` → `08`, `04-worktree-setup` → `02`; `01-first-time-setup` kept its number.
- **`doc-writer`'s remit now explicitly excludes `how-to/`**, and `how-to/src/CLAUDE.md` no longer routes there — it previously named `doc-writer` against that agent's own stated scope of `code/docs/*`, a contradiction that had gone unnoticed.
- `how-to/workflows/CLAUDE.md` corrected from "three-file shape" to four — every workflow here has carried a `CLAUDE.md` as well since the pairing rule landed.
- **The eleven code workflows renumbered into three families** — build (`01`–`06`), verify (`07`–`08`), diagnose & improve (`09`–`11`). Within build the layers now read bottom-up (`03` data → `04` `/api/` → `05` `/mcp/`); within diagnose they read in handoff order (`09` find → `10` fix → `11` improve). `01-new-feature`, `02-tdd-cycle` and `04-api-design` keep their numbers; the other eight moved. The mapping was circular (`03`→`08`, `08`→`11`, `09`→`03`), so the rename went through a temporary namespace.
- The renumber touched **282 path tokens across 117 files** plus 12 bare-number references that carry no slug (`.claude/CLAUDE.md` §2.4, `code/docs/CODE-REVIEW-GRAPH.md`, and two workflow `CLAUDE.md` files). Historical `CHANGELOG.md` / `RELEASES.md` entries were deliberately **not** rewritten — they record the paths as they stood at that release.
- **`09-debugging-with-logs` and `10-debug` are now adjacent**, which is the defect that motivated the change: they are two halves of one activity (`09` locates a fault, `10` fixes it and proves the fix), they reference each other five times, and `09/STEPS.md` ends by handing over to `10` — yet they previously sat three positions apart with unrelated workflows between them.
- `code/workflows/CONTEXT.md` regrouped into the three families, and now states outright that **these numbers are stable identifiers, not a sequence** — append a workflow, never renumber one. Roughly 110 files cite these paths, and a stale number in an agent definition is a silent routing failure.

### Fixed

- **`.copier/README.md` shipped a workflow table whose `#` column had decoupled from the workflow names** — row `03` pointed at `08-security-hardening/`, row `09` at `03-database-migration/`. The renumber sweep corrected every slug but had no way to know a separate hand-maintained column encoded the same number. Every generated project would have carried it. Rebuilt as a family-grouped table, along with both directory trees (`10 coding workflows` → 11, `4 operational` → 9) and the "three files" claim (workflows carry four).
- **Stale hard counts removed from `README.md`, `01-OVERVIEW.md` and `07-REPO-TOUR.md`** — "50 agents" (52), "16 skills" (23), "15 GitHub Actions workflows" (17). The 0.13.0 release deliberately removed such counts because one differs between two correct projects once the roster is conditional; that removal reached `08-CLAUDE-CODE.md` and missed these three, which had gone stale exactly as predicted. The Copier question count is now stated accurately as twenty-two, or twenty-four with the mobile surface, rather than the stale "twenty-one".
- `07-REPO-TOUR.md` described the code workflows as a **range** ending at `10-debugging-with-logs`; the sweep renumbered that token to `09`, leaving a semantically wrong but syntactically valid endpoint. A path check cannot catch this class of error.
- `12-EXTENDING.md`'s "An MCP server" section was about servers the project **consumes** via `.mcp.json`, and would now be read as covering the FastMCP surface the project **serves**. Split into two sections.

- **Six of the eight `claude.yml` quality gates failed on every push and pull request** raised against this template — `uv sync --frozen` cannot resolve without a `uv.lock`, which is absent by design here because it would pin the root project under the literal project-slug token. Each now carries the same `Detect the backend lockfile` step `test.yml` already used, guarded at **step** level so the JS half (Prettier, ESLint, `pnpm audit`) keeps gating this repository rather than being thrown away with the Python half.
- `audit-deps.yml` failed on its nightly schedule for the same reason, opening a tracking issue about a Python dependency tree that does not exist yet. The JS half is unguarded and keeps its nightly CVE scan.
- `clickup-sync.yml` failed whenever triggered: the template ships `US000-TEMPLATE.md` and no real stories, so `export/clickup/` holds no `US###-CLIENT.md` files and `sync-clickup.sh` exits 2 on preflight. Now guarded on the exports existing. This is **not** the missing-credentials case — the script already degrades to a dry run for that by itself.
- All three `syntax-python.yml` jobs failed at `astral-sh/setup-uv@v4`, a stale action pin with no explicit version while every other workflow here uses `@v5` with `UV_VERSION`. Fixed rather than skipped: these jobs run `uv sync` **without** `--frozen`, so they need no lockfile and are the one Python gate this repository genuinely enforces on itself.

---

## [0.13.0] - 02/08/2026

### Added

- **The opt-in React Native mobile surface.** `INCLUDE_MOBILE` (default `false`) gates a bootable Expo application at `code/src/mobile/` — Expo SDK 57 with Continuous Native Generation, expo-router, TypeScript, one placeholder route, and no binary assets. Answering no produces a repository functionally identical to 0.12.0's output.
- `MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` Copier questions, asked only when the mobile surface is included; the bundle ID defaults to the primary domain, label-reversed.
- `code/src/scripts/mobile/` — `install.sh`, `server.sh`, `lint.sh`, `typecheck.sh`, `test.sh` and `bundle.sh`, plus a shared `_common.sh`. Metro runs on the **host**, the one dev operation that is not containerised, because Expo Go on a physical device cannot reach a loopback alias.
- Four mobile CI jobs — `jest-expo + coverage` and `Bundle export` in `test.yml`, `ESLint (mobile surface)` and `TypeScript (mobile surface)` in `syntax-js-ts.yml` — each guarded at **step** level so a web-only project reports green rather than skipped.
- `.claude/agents/mobile.md` and `.claude/skills/stack-react-native/` — the mobile governance pair, excluded with the tree.
- `code/docs/design-tokens/MOBILE.md` — the design-token bridge: six colour forms with OKLCH canonical and five derived on write, CSS Color 4 gamut mapping, 8-digit hex for mobile, the `render_tokens_ts()` emitter, and which three preference axes collapse to BASE.
- `code/docs/accessibility/MOBILE.md` — the React Native technique set for the unchanged WCAG 2.2 AA standard, including why verification here is manual.
- `code/src/scripts/audits/mobile-tokens.sh` and `.github/workflows/audit-mobile-tokens.yml` — the mobile half of the token-first law. Self-guarding: exits 0 with a note when there is no mobile surface.
- `code/src/mobile/CHANGELOG.md`, `VERSION-HISTORY.md` and `RELEASES.md` — the mobile application is a third independent semver track, starting at 0.1.0.
- Mobile-flagged steps in `project-management/workflows/20-frontend-code/` (Step 4M), `code/workflows/01-new-feature/` (Step 7M) and `code/workflows/02-tdd-cycle/`, plus the mobile wireframe convention in `project-management/src/08-WIREFRAMES/`.

### Changed

- **Five documented invariants narrowed in scope, not in force**, to "the web surface" — `code/src/CLAUDE.md`, `code/src/CONTEXT.md`, `eslint.config.mjs`, `project-management/src/CONTEXT.md` and `code/docs/RENDERING.md`. A mobile app is a separate deployable, not a bundler for Django pages, so `RENDERING.md`'s "there is no fourth row" survives verbatim.
- **"Surface" became load-bearing vocabulary**, defined once in `code/src/CONTEXT.md` → _Surfaces_. Silence still means the web surface.
- `test-backend.yml` renamed **`test.yml`** to hold both surfaces' test jobs, and its path filters dropped — a path-filtered required check never reports and would silently stop gating mobile.
- `audit-template.yml` now runs **both** `INCLUDE_MOBILE` values through every assertion, plus two new ones: the opt-in is obeyed in both directions, and every shared file is byte-identical across the render paths.
- Jinja comment delimiters moved from the vertical-bar pair to a tilde pair, because the old opening sequence collided with TypeScript union types and would have swallowed a generated declaration. No committed file used it as a real comment, so nothing behavioural changed. The sequences themselves are quoted in `how-to/src/TEMPLATE-GUIDE/`, which is excluded from rendering and is the only place they can appear literally.
- `VERSIONING-GUIDE.md` documents the mobile track and its **two-files-one-number** rule (`package.json` and `app.json`); the `version` agent learned it, and its stale `backend`/`frontend`/`shared` sub-package list was corrected.
- `code/docs/testing/COVERAGE.md` reworded from "one floor, not one per layer" to **one standard, enforced once per runtime** — `coverage.py` and Jest share no accumulator.
- **Hard agent counts removed rather than incremented** across `.claude/CLAUDE.md`, `CONTEXT.md`, `.claude/CONTEXT.md`, `how-to/docs/TOOLING-GUIDE.md` and `TEMPLATE-GUIDE/08-CLAUDE-CODE.md` — a count differs between two correct projects once the roster is conditional, and one was already stale.
- `project-management/workflows/08-wireframes/` corrected to match the artefact folder it drives: self-contained HTML screens named `WF-###-<Screen-Name>.html`, not `WF-US###-<DESCRIPTOR>.md`, and Figma/Excalidraw are no longer offered as alternative media.

### Fixed

- `@jest/reporters>glob` repinned from `^7.1.6` to `^9.3.5`, removing `inflight@1.0.6` from the tree. The constraint is an interop shape, not a version floor: glob 10 and 11 set `__esModule` with no `default` export, so `.default.sync` is undefined and the Jest 29 coverage reporter dies. glob 9 is the newest version that still works.

### Security

- `inflight@1.0.6` — an unbounded-memory-leak package — no longer appears anywhere in the dependency tree.

---

## [0.12.0] - 02/08/2026

### Added

- `copier.yml` — the executable template contract: twenty-one questions with derived defaults and validators, custom Jinja delimiters, exclusion rules, and four post-generation tasks. Replaces `setup.sh`.
- `.copier-answers.yml` — rendered into every generated project so `copier update` can three-way-merge later template improvements into live projects.
- `.copier/README.md` — the generated project's README, moved out of the repository root so the root README can describe the template itself.
- `LICENSE` — MIT. The template no longer withholds a licence; `<%LICENCE%>` remains a token so a generated project still chooses its own.
- `SECURITY.md` — private vulnerability disclosure policy, scoped to the realistic risk of an insecure default propagating into every generated project.
- `CONTRIBUTING.md` at the root — the external contributor front door, distinct from `how-to/src/CONTRIBUTING.md` which holds the standards applying inside a generated project.
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, and `.github/ISSUE_TEMPLATE/` (bug report, template improvement, config).
- `.github/workflows/audit-template.yml` and `.github/scripts/check-template-tokens.sh` — two unconditional CI gates: token-syntax integrity, and a full generation smoke test asserting zero surviving tokens, no template-only leakage, and intact `${{ }}` / `[[ ]]` syntax.
- `how-to/src/TEMPLATE-GUIDE/` — fourteen numbered guides plus a `CONTEXT.md`/`CLAUDE.md` pair, covering overview, stack, prerequisites, quickstart, answers, generation, repository tour, Claude Code, first story, customising, extending, deployment, updating, and troubleshooting.
- `how-to/src/CONTRIBUTING.md` — the contributing and code-quality standard, lifted out of `how-to/src/CONTEXT.md`.
- Host platform and container-runtime detection in `install.sh` — distinguishes Linux, macOS, WSL and native Windows, accepts Docker Desktop or Colima on macOS, rejects non-WSL Windows shells, and warns on WSL 1 and on repositories living under `/mnt/c`.

### Changed

- **Token delimiters replaced** — swept across 433 files. Jinja's default double-brace delimiters collide with GitHub Actions expressions (`${{ }}`), Django template syntax, and Bruno variables; double-square-bracket was rejected in turn because it is bash test syntax. The replacement variable, block and comment delimiters were each verified absent from the tree before adoption — see `how-to/src/TEMPLATE-TOKENS.md` for the set and the reasoning.
- `README.md` rewritten template-facing and literal — 1160 lines to 140 — describing syntek-base rather than impersonating a shipped product, and indexing the guide set.
- `how-to/src/CONTEXT.md` is now a genuine orientation index rather than a 239-line guide.
- `how-to/src/TEMPLATE-TOKENS.md` rewritten as the contract `copier.yml` implements, including the delimiter rationale.
- Licence language in `how-to/src/CONTEXT.md`, `how-to/src/CLAUDE.md` and the project README now keys off `<%LICENCE%>` instead of asserting proprietary.
- `how-to/CONTEXT.md` and `how-to/REFERENCES.md` corrected — the tree had drifted, omitting every `CLAUDE.md`, `CELERY-FIRST-RUN.md`, `FEATURE-DEPLOY.md`, and `TEMPLATE-TOKENS.md`.
- Deployment documentation made provider-neutral: any Linux host with Docker will serve the application; Hetzner, NixOS and Cloudflare are named as the target the runbooks are written against, not a requirement.
- The Claude Code guide now distinguishes grilling from wayfinder, and the plan requirement (Fable tier) is stated in the README, prerequisites and Claude Code guides.

### Removed

- `setup.sh` — superseded by Copier. Its literal string substitution had no update path, which is the capability the migration exists to gain.

### Fixed

- Two tokens corrupted by Prettier's Markdown formatter, which pairs the underscore inside a token name with nearby `_emphasis_` and rewrites both. A corrupted token renders as an undefined variable and vanishes silently from every generated project.
- Literal token delimiters written in prose inside `how-to/src/CLAUDE.md`, a rendered file — Jinja parsed them and generation failed outright with `TemplateSyntaxError`.
- `_exclude` patterns anchored to the repository root. They use gitignore semantics, so an unanchored `README.md` also matched `.copier/README.md`, and `CONTRIBUTING.md` would have swallowed `how-to/src/CONTRIBUTING.md`.

### Security

- Branch protection on `main` via a repository ruleset — pull request required, conversation resolution required, force-push and deletion blocked, and eleven required status checks. Administrators may bypass, so solo merges still work.
- Private vulnerability reporting enabled on the repository, matching the disclosure route `SECURITY.md` documents.

---

## [0.11.0] - 01/08/2026

### Added

- Root `CONTEXT.md` — the project overview: directory tree, layer map, starting points, conventions, and repository state. Reinstates the orientation file retired in 0.10.0.

### Fixed

- `.claude/CLAUDE.md` line 6 imports `@../CONTEXT.md`, which resolved to nothing after 0.10.0 removed the file. The import now loads on every session as intended.

---

## [0.10.0] - 01/08/2026

### Added

- `REFERENCES.md` — the root reference index covering every layer entry point, guide, workflow, and external standard.
- `DEFERRED.md` — the register of work deliberately deferred, alongside `GAPS.md` for active blockers.
- `setup.sh` and a rewritten `install.sh` — resolve the template placeholders and prepare a scaffolded project.
- `skills-lock.json` — installed Claude Code skills with their versions and hashes.
- `.github/workflows/audit-css-tokens.yml`, `audit-css-gradients.yml`, `audit-copy-emdash.yml`, `audit-secrets.yml`, and `audit-deps.yml` — CI wiring for the audit scripts added in 0.4.0.
- `.github/workflows/claude.yml` and `clickup-sync.yml` — the Claude Code review pipeline and the ClickUp story export sync.
- `.zed/settings.json` — editor configuration shipped as part of the template's tooling surface.
- `handoffs/`, `learning/`, and `research/` — session sandboxes for the handoff, teach, and research skills, each with `CONTEXT.md` and `CLAUDE.md`.

### Changed

- Hardcoded project identifiers replaced with substitution placeholders throughout the root files — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`, `<%ORG_SLUG%>`, `<%DEVELOPER_NAME%>`, `<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>`, and `<%DATE%>`.
- `README.md` rewritten for the Django-only monolith; the version badge and footer set to `0.10.0`.
- `DESIGN.md` and `GAPS.md` rewritten around the token-first design system and the template's open items.
- `package.json`, `pnpm-workspace.yaml`, and `pnpm-lock.yaml` reduced to the tooling dependencies that survive without a JavaScript application.
- `eslint.config.mjs`, `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, and `.npmrc` re-scoped to the remaining file types.
- `lefthook.yml` — pre-commit hooks re-pointed at the Django tree, with a self-gating ClickUp export step and an advisory code-review-graph pass.
- The six surviving CI workflows re-pointed at `code/src/django/` and the rewritten script surface.

### Removed

- Root `CONTEXT.md` — superseded by `REFERENCES.md` as the root index.
- `LICENCE` — a base template does not choose a licence on behalf of the project scaffolded from it; the placeholder `<%LICENCE%>` is resolved at setup.
- `CONTRIBUTING.md` — superseded by the PM layer's git, PR, and review workflows.

---

## [0.9.0] - 01/08/2026

### Added

- `how-to/docs/AI-DICTIONARY.md` with `ai-dictionary/` — plain-English definitions across `THE-MODEL.md`, `SESSIONS-CONTEXT-AND-TURNS.md`, `TOOLS-AND-ENVIRONMENT.md`, `MEMORY-AND-STEERING.md`, `PATTERNS-OF-WORK.md`, `HANDOFFS.md`, and `FAILURE-MODES.md`.
- `how-to/docs/TOOLING-GUIDE.md` with `tooling-guide/` — `COMMANDS.md`, `CONFIGURATION.md`, and `WORKFLOW.md` covering the internal agents and skills.
- `how-to/docs/GIT-WORKTREES.md`, `SKILL-AUTHORING.md`, `CELERY-FIRST-RUN.md`, and `FEATURE-DEPLOY.md`.
- `how-to/workflows/04-worktree-setup/` — a complete workflow (`CONTEXT.md`, `STEPS.md`, `CHECKLIST.md`, `CLAUDE.md`) for running parallel stories in isolated worktrees and Docker stacks.
- `how-to/src/SCALE-ARCHITECTURE/` — `OVERVIEW.md`, `LOAD-PROFILES.md`, `SIZING-ENVELOPE.md`, `READINESS.md`, and `TOPOLOGY.md` for sizing a deployment against a target user count.
- `how-to/src/SERVER-ARCHITECTURE/` — `OVERVIEW.md`, `COMPUTE-ALLOCATION.md`, `EDGE-REQUIREMENTS.md`, and `NIXOS-HANDOFF.md`, the interface to the NixOS deployment repository.
- `how-to/src/NIXOS-SETUP.md`, `how-to/src/TEMPLATE-TOKENS.md`, `how-to/REFERENCES.md`, and `CLAUDE.md` operating-rules files throughout the layer.

### Changed

- `how-to/docs/DEVELOPMENT.md`, `CLI-TOOLING.md`, and the three existing workflows rewritten for the Django-only stack and the rewritten script surface.
- `how-to/CONTEXT.md` updated for the new document set and workflow `04`.

### Removed

- `how-to/docs/SYNTEK-GUIDE.md` and `how-to/docs/API-TESTING.md` — project-specific or superseded by the code-layer testing guides.
- Nine narrow contributor guides under `how-to/src/` — `BRANCH-GUIDE.md`, `COMMIT-GUIDE.md`, `PR-GUIDE.md`, `CODE-REVIEW.md`, `ISSUE-REPORTING.md`, `ENV-SETUP.md`, `GETTING-STARTED.md`, `CLAUDE-MULTILAYER.md`, and `API-TESTING.md` — each duplicated an authoritative guide in the code or PM layer.

---

## [0.8.0] - 01/08/2026

### Added

- `project-management/src/` renumbered to `00`–`20` across three tiers — specify (`02-STORIES` … `13-API-DESIGN`), decide and plan (`14-DECISIONS`, `15-SPRINT-PLANS`, `16-STORY-PLANS`), and record (`17-TESTS` … `21-REFACTORING`).
- `project-management/workflows/` extended to `01`–`21`, adding `13-api-design`, `14-decisions`, `15-sprint-plans`, `16-story-plans`, the `16`–`18` implementation phases, `21-implementation-documentation`, `22-pr-and-review`, and `23-release`.
- `project-management/docs/gdpr/` — `COMPLIANCE.md` and `DATA-RIGHTS.md`, with `GDPR-GUIDE.md` reduced to a thin index over them.
- `project-management/export/clickup/` and `clickup-task-map.json` — the read-only client export surface regenerated from source stories by the pre-commit hook.
- `project-management/src/00-ASSETS/scripts/` — the export and sync family: `export-clickup-stories.sh`, `export-design-docs.sh`, `export-pm-files.sh`, `export-wireframes.sh`, `sync-clickup.sh`, and the self-gating `precommit-clickup.sh`.
- `CLAUDE.md` operating-rules files for the layer root, `docs/`, every `src/` artefact folder, and every numbered workflow.

### Changed

- All eight PM guides rewritten for the Django-only stack — `GIT-GUIDE.md`, `VERSIONING-GUIDE.md` (now a two-tier scheme with the django sub-package), `SEO-CHECKLIST.md`, `SECURITY-GUIDE.md`, `QA-GUIDE.md`, `PLANNING-GUIDE.md`, `GDPR-GUIDE.md`, and the `RESPONSIVE-DESIGN.md` redirect stub.
- `project-management/CONTEXT.md` and `REFERENCES.md` rewritten around the three-tier structure and the cross-layer workflow pairing map.
- Story, sprint, and plan templates re-expressed with template placeholders in place of project-specific content.

### Removed

- The pre-renumbering artefact folders `00-DECISIONS/`, `00-PLANS/`, `13-SPRINT-PLANS/`, `14-TESTS/`, `15-REVIEWS/`, `16-BUGS/`, and `17-REFACTORING/` — superseded by their renumbered equivalents.
- The organisation's logo exports (`00-ASSETS/LOGOS/` at 8k, HD, and SVG) and the project's twelve ERD diagrams (`00-ASSETS/ERD-DIAGRAMS/`) — a template ships the asset pipeline, not one organisation's brand or one project's schema.

---

## [0.7.0] - 01/08/2026

### Added

- `code/docs/DATABASE.md` — scope columns, database-level invariants, lock-safe migration patterns, search, and the deferred-infrastructure register.
- `code/docs/DESIGN-TOKENS.md` with `design-tokens/` (`MODEL.md`, `CASCADE.md`, `EDITOR.md`) — the database-canonical token system that component CSS may only consume through `var(--token)`.
- `code/docs/RENDERING.md` with `rendering/` — where each interaction runs: server template, HTMX, or Alpine.
- `code/docs/VISUAL-DESIGN.md`, `BACKEND-CODING-PRINCIPLES.md`, and `FRONTEND-CODING-PRINCIPLES.md`.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore, debug, review, and refactor playbooks for the code-review-graph MCP server.
- Sub-folders splitting every oversized guide: `accessibility/`, `api-design/`, `architecture/`, `coding-principles/`, `data-structures/`, `encryption/`, `logging/`, `performance/`, `responsive/`, `rls/`, `security/`, and `testing/`.
- `code/docs/cloudinary/` — the Cloudinary Python SDK and cross-SDK reference index.
- `code/REFERENCES.md` and `CLAUDE.md` operating-rules files for the code layer root, `code/workflows/`, and all ten numbered workflows.

### Changed

- All fourteen existing `code/docs/*.md` guides rewritten for the Django-only stack and reduced to thin indexes over their sub-folders where they exceeded the 300-code-line instructional limit.
- All ten `code/workflows/` procedures re-pointed at the Django tree, the rewritten script surface, and the paired project-management workflows.
- `code/CONTEXT.md` — directory tree and layer map updated for the single-stack monolith and the 750-line source file limit.

---

## [0.6.0] - 01/08/2026

### Added

- `.claude/agents/` — 50 agent definitions in two tiers: 8 orchestrators (`bugfix`, `feature`, `pr`, `refactor`, `release`, `review`, `security`, `story`) plus the specialists and document writers they delegate to.
- `.claude/skills/` — the internalised skill library: `stack-django`, `stack-htmx-templates`, `global-workflow`, the `grilling` engine with its `grill-me` and `grill-with-docs` wrappers, `codebase-design`, `domain-modelling`, `improve-codebase-architecture`, `scale-planning`, `teach`, `wayfinder`, `handoff`, `prototype`, `research`, `legal-documents`, and `msp-scp-documents`.
- `.claude/MEMORY.md` — the project memory store that replaces the global auto-memory system.
- `.claude/CONTEXT.md` — orientation for the configuration directory.
- `.claude/hooks/pre-pr-check.sh` — the eight-gate quality check run before a pull request is marked ready; `post-pr-comment.sh` posts the structured result summary.
- `.claude/hooks/pre-compact-handoff.sh` — intercepts auto-compaction so a session writes an explicit handoff document instead of silently compacting.
- `.agents/skills/cloudinary-docs`, `cloudinary-react`, and `cloudinary-transformations` — Cloudinary SDK skill references.
- `CONTEXT.md` and `CLAUDE.md` pairs for the hooks and plugins directories.

### Changed

- `.claude/CLAUDE.md` — rewritten around the Django-only stack, the two-tier agent model, the Fable/Opus model allocation, the templatised project placeholders, and the non-negotiable rules (token-first CSS, database-enforced invariants, lock-safe migrations, and the docs hard gate).
- `.claude/settings.json` — auto-compaction disabled, dynamic workflows enabled, the Opus model and extra-high effort level pinned, and both marketplace plugins disabled.
- `.claude/hooks/lib/check-*.sh` — the eight shared check scripts re-pointed at the Django tree and the rewritten script surface.

### Removed

- `.claude/commands/` — seven slash commands (`codegen`, `dev`, `migrate`, `production`, `schema`, `staging`, `test`) superseded by the runners under `code/src/scripts/`.
- `.claude/hooks/pr-gate.sh` and `pr-comment.sh` — replaced by `pre-pr-check.sh` and `post-pr-comment.sh`.
- `.claude/plugins/chrome-tool.py`, `ddev-tool.py`, `docker-tool.py`, and `quality-tool.py` — plugins that ran dev operations; those now belong exclusively to the shell scripts.

---

## [0.5.0] - 01/08/2026

### Added

- `code/src/tests/api/environments/*.bru` — native Bruno environment files for `local`, `host`, `docker`, `staging`, and `production`, alongside the retained JSON definitions.
- `code/src/tests/api/environments/host.json` — the host-machine environment, for running the suite outside the Docker network.
- `code/src/tests/template-test.bru` — a single annotated request template that every new Bruno suite is copied from, relocated from `api/template-test.bru`.
- `code/src/improvement-architecture/` — scratch area for architecture improvement reports; contents are git-ignored, orientation files are tracked.
- `CLAUDE.md` operating-rules files for `code/src/tests/`, `code/src/tests/api/`, `code/src/tests/api/environments/`, and `code/src/logs/`.

### Changed

- `code/src/tests/api/bruno.json` and the `docker`, `staging`, `production`, and `variables` JSON environments re-pointed at the Django service and its `/api/` prefix.
- `code/src/tests/CONTEXT.md`, `api/CONTEXT.md`, and `logs/CONTEXT.md` rewritten for the template layout.

### Removed

- The illustrative Bruno collections — `api/auth/`, `api/orders/`, `api/users/`, and `api/performance/` — a template ships no domain fixtures.
- `code/src/tests/api/template-test.bru` — relocated up one level to `code/src/tests/template-test.bru`.

---

## [0.4.0] - 01/08/2026

### Added

- `code/src/scripts/_lib/` — shared shell helpers, including `worktree-detect.sh` for resolving the active worktree and its Docker project name.
- `code/src/scripts/audits/` — `css-tokens.sh` (enforces that component CSS only consumes resolvable `var(--token)` values), `css-gradients.sh`, `copy-emdash.sh`, and `security.sh`.
- `code/src/scripts/development/new-django-view.sh` — scaffolds a public page as a Django view, template, and URL entry; the only supported way to add a page route.
- `code/src/scripts/development/hosts-story-add.sh` and `hosts-story-remove.sh` — manage per-story loopback host entries for parallel worktrees.
- `code/src/scripts/development/install.sh`, `install-backend.sh`, `install-frontend.sh`, and `pnpm-update.sh` — dependency installation and update runners.
- `code/src/scripts/database/seed-dev.sh` and `verify-db-security.sh` — development seeding and a row-level-security and grant verification pass.
- `code/src/scripts/tests/e2e-py.sh` (Playwright driven from the Django tree), `server.sh`, and `mutmut.sh` for mutation testing.
- `CLAUDE.md` operating-rules files for the script root and every script sub-directory.

### Changed

- Every runner under `database/`, `deployment/`, `development/`, `syntax/`, and `tests/` re-pointed from `code/src/backend/` to `code/src/django/`.
- `code/src/scripts/CONTEXT.md` rewritten around the Django-only script inventory.

### Removed

- `code/src/scripts/tests/frontend.sh`, `frontend-coverage.sh`, `mobile.sh`, `mobile-coverage.sh`, and `e2e.sh` — superseded by `e2e-py.sh` or removed with their layer.
- `code/src/scripts/development/codegen.sh`, `new-next-route.sh`, and `new-expo-screen.sh` — scaffolding for the removed JavaScript layers.
- `code/src/scripts/tests/reports/**` — generated report directories are no longer tracked; `.gitignore` now excludes them and a single `reports/.gitignore` keeps the directory self-managing.

---

## [0.3.0] - 01/08/2026

### Added

- `code/src/django/` — the Django project bundle: `config/` (ASGI and WSGI entry points, root URL conf, and the four-environment settings split), `apps/`, `templates/`, `static/`, `tests/e2e/` with accessibility and marketing-overflow suites, plus `conftest.py`, `manage.py`, and `pyrightconfig.json`.
- `code/src/django/CHANGELOG.md`, `code/src/django/VERSION-HISTORY.md`, and `code/src/django/RELEASES.md` — sub-package version files at the `0.1.0` baseline, as required for every package manifest by `project-management/docs/VERSIONING-GUIDE.md`.
- `code/src/docker/django/` — the Django container images and entrypoints for dev, test, staging, and production.
- `code/src/docker/postgres/` — PostgreSQL container configuration, including `postgresql.dev.conf`.
- `code/src/docker/docker-compose.usXXX.dev.yml.example` and `docker-compose.usXXX.test.yml.example` — per-worktree Compose overlays for parallel story development.
- `CLAUDE.md` operating-rules files alongside every `CONTEXT.md` in the `code/src`, `docker`, and `django` trees, per the directory pairing rule.

### Changed

- `code/src/backend/` → `code/src/django/` — the Python package root is renamed to reflect that Django now serves the entire application, not just an API.
- `code/src/docker/backend/` → `code/src/docker/django/` — image names, build contexts, and entrypoints follow the rename.
- Compose files, the Nginx dev and test configurations, and the four `.env.*.example` templates re-pointed at the `django` service.
- `pyproject.toml` — project name templatised to `<%PROJECT_SLUG%>`, version set to the django sub-package `0.1.0` baseline, and the dependency set narrowed to the Django-only stack.

### Removed

- `code/src/backend/**` — superseded in full by `code/src/django/**`.
- `code/src/shared/**` — the TypeScript package shared between the web and mobile clients, obsolete now that neither client exists.

---

## [0.2.0] - 01/08/2026

### Removed

- `code/src/frontend/**` — the Next.js/React web application (34 files), including its App Router pages, components, hooks, and TypeScript configuration.
- `code/src/mobile/**` — the Expo React Native application (45 files), including its screens, navigation, native configuration, and Expo tooling.
- `code/src/docker/frontend/**` — the frontend container images and configuration for dev, test, staging, and production (5 files).
- `code/src/docker/mobile/Dockerfile.test` — the React Native test image.
- `.github/workflows/test-frontend.yml` and `.github/workflows/test-mobile.yml` — the CI pipelines for the two removed layers.

---

## [0.1.0] - 01/08/2026

### Added

- Initial scaffold from the base template — Django · Django Ninja · django-components · HTMX · Alpine · vanilla token CSS · Celery · PostgreSQL · Valkey · Nginx · Docker.
- `.gitignore` rules for the template surface — generated test reports under `code/src/scripts/tests/reports/`, the resolved Python lockfile, git worktree checkouts under `.claude/worktrees/`, and local Claude Code overrides.

### Changed

- Root version track reset from `1.11.0` to `0.1.0` — this repository is now the reusable base template rather than a single delivered project.
- `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` truncated to the template baseline; the pre-template 1.x history is retained in git history only and is not back-filled.

### Removed

- `uv.lock` — the resolved Python lockfile is no longer tracked. The template's `pyproject.toml` carries unsubstituted placeholders, so the lockfile is resolved per scaffolded project rather than shipped.
