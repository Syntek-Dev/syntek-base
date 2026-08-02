# .claude/MEMORY.md — Project Memory

Read this at the start of every session. Write here instead of the global auto-memory system.

Sections: **Feedback** (<%DEVELOPER_NAME%>'s guidance on approach) · **Project Patterns** (conventions discovered
during work) · **Project State** (business/stack facts not derivable from the codebase)

To add an entry: append a subsection under the correct heading. Keep entries concise — one paragraph
max. Update or remove stale entries rather than appending contradictions.

**Do not write here:** active gaps, blockers, sprint dependencies → those go in `GAPS.md`.

---

## Feedback

_No entries yet._

---

## Project Patterns

### "Surface" is load-bearing vocabulary (02/08/2026)

A **surface** is one delivery target with its own runtime, toolchain and release cycle. The repo
has at most two: **web** (`code/src/django/`, always) and **mobile** (`code/src/mobile/`, only if
the project opted in). Every doctrine statement about builds, bundlers, TypeScript or rendering is
scoped to one of them — "no client-side build" means _for the web surface_. The narrowing is
scope, never force: a mobile app is a separate deployable, not a bundler for Django pages, so
`RENDERING.md`'s "there is no fourth row" survives verbatim. Defined in `code/src/CONTEXT.md` →
_Surfaces_. When writing any rule about the stack, say which surface it governs; silence means web.

### Optional template content is gated one way only (02/08/2026)

A templated `_exclude` entry in `copier.yml` — never templated file contents. Shared files take
**inert no-ops** instead (an ignore entry, a glob, an added extension), each costing an opted-out
project nothing. This keeps every shared file byte-identical on both render paths, and means a
Jinja error inside optional content cannot break a generation that excluded it. Rationale and the
rejected alternatives: `how-to/src/TEMPLATE-GUIDE/10-CUSTOMISING.md`.

### The mobile toolchain's pins are a matched set — verify, never assume (02/08/2026)

Every "obvious" latest-version choice was wrong, and each failed only at runtime: Expo 57 pins
TypeScript ~6 (7 is out); jest-expo 57 is on the **Jest 29** line (Jest 30 dies with
`clearMocksOnScope is not a function`); expo-router 57's testing library needs **RNTL 13**, not 14
(14 removed the `screen` singleton and changed the render-result shape); and `eslint-config-expo`
is not ESLint 10 compatible, so mobile pins ESLint **9** while the root stays on 10 — which is
precisely the isolation the self-contained-workspace decision bought. Take pins from Expo's own
published `expo-template-default`, then run install → typecheck → lint → test → bundle before
believing any of it.

### The repo's `glob: ">=11.0.0"` override breaks CJS dev tooling (02/08/2026)

glob 11 is ESM-only, so any `require('glob')` resolves to undefined. This silently broke mobile
coverage twice — `test-exclude@6` calls `promisify(glob)`, and Jest 29's coverage reporter calls
`glob.sync`. Fixed with two narrow overrides (`test-exclude: ">=7.0.1"` and
`"@jest/reporters>glob": "^7.1.6"`), keeping the repo-wide floor intact. Expect this class of
failure from any CJS dev dependency added in future; scope the exception, never drop the floor.

### expo-router treats every file under `app/` as a route (02/08/2026)

A co-located `app/**/*.test.tsx` therefore pulls the testing library into the **production
bundle** and fails `bundle.sh`. Mobile tests live in `code/src/mobile/__tests__/` — the one place
the repo's test-beside-the-code habit does not apply. Tests mount the real router via
`renderRouter`, which covers the root layout too; testing the route in isolation hides a layout
that renders nothing.

### `syntek-base` ships specifications, not implementations (02/08/2026)

The `code/docs/` guides are written in the **present tense as if built** — "the `design_tokens`
app owns two models", "Status: … in place" — but they describe what a **generated project**
implements. The template itself carries no application code: `code/src/django/apps/` holds only
`__init__.py`, there is no `static/css/tokens/`, and there are no migrations in the tree. So work
that would be a schema change _in a generated project_ is a **documentation change here** — extend
the guide, never write the model, the migration, or the `03-DATABASE/` spec. Before treating any
`code/docs/` guide as describing live code, check the path it names actually exists. This caught
the design-token bridge (N08) after the decision map had already recorded it as a schema change.

### Template-development reasoning lives in `TEMPLATE-GUIDE/`, not in ADRs (02/08/2026)

`how-to/src/TEMPLATE-GUIDE/` is in `copier.yml`'s `_exclude`, so it is durable in git yet never
ships. That makes it the right home for reasoning about how `syntek-base` itself is built — a
generated project needs to know _how_ to use a choice, not _why_ the template made it. ADRs under
`13-DECISIONS/` are for decisions a generated project inherits.

---

## Project State

_No entries yet._
