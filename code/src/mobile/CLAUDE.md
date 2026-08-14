@./CONTEXT.md

# CLAUDE.md — code/src/mobile/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/CONTEXT.md` (the surfaces
model) → this folder's `CONTEXT.md` (tree, scripts table, versioning — imported above) → this
file.

## Purpose (one line)

The optional Expo / React Native mobile surface — a separate deployable that consumes the Django
Ninja API, never a client-side build for the Django-served pages.

## How to work here

- **Routing:** React Native work loads the `stack-react-native` skill. The `frontend` skill stays
  Django-templates-only and does **not** own this tree; `test-writer`, `qa-tester` and
  `code-reviewer` may load `stack-react-native` without owning React Native conventions. Start
  substantive work from `project-management/workflows/20-frontend-code/`, whose mobile steps are
  flagged mobile-only.
- **Model:** Opus for code, tests and review; Fable only where a design or schema decision is
  being made upstream of the code.
- **Every operation runs through `code/src/scripts/mobile/*.sh`** — never raw `pnpm`, `expo`,
  `tsc` or `jest`. The scripts table is in `CONTEXT.md`.
- **Concrete steps:** read `CONTEXT.md` → implement under `app/` → `lint.sh` → `typecheck.sh` →
  `test.sh --coverage` → `bundle.sh` before raising a PR → update this pair if the structure
  changed → refresh the code-review-graph.
- **Definition of done:** lint, typecheck, tests and the bundle export all exit `0`; coverage at
  or above 75% lines and branches (90% on auth-adjacent code); WCAG 2.2 AA satisfied by the
  React Native techniques in `code/docs/accessibility/MOBILE.md`; British English throughout.

## Guardrails

- **Never commit `ios/` or `android/`.** They are Expo-generated artefacts. Committing them puts
  a Gradle wrapper JAR, launcher PNGs and iOS asset catalogues in a tree that Copier renders
  through Jinja and **cannot render binaries** — it would break generation outright. Running
  `expo prebuild` and keeping the output is an ADR-level decision, not an incidental one.
- **No binary assets anywhere in this tree**, for the same reason. Icons and splash images are a
  per-project addition with a matching exclusion entry.
- **The Expo SDK is pinned.** Bumping it is a versioned template release that flows downstream
  through `copier update`, not a routine dependency bump — SDK majors have broken projects before.
- **Token-first applies here too.** Design values come from the generated token module, never a
  raw literal in a `StyleSheet`. Enforced by `code/src/scripts/audits/mobile-tokens.sh`; the
  "name resolves" half is free, because an unresolved token import does not compile.
- **A non-route module goes in `lib/`, and joins the coverage glob when it does.** `app/` is
  routes only — expo-router would publish a helper placed there as a navigable screen. `lib/` is
  named in `jest.config.js` → `collectCoverageFrom` for the reason a new directory usually is
  not: a module outside that list is not merely untested, it is **invisible to the floor**, so
  the run stays green having measured nothing. Add a directory there and add it here in the same
  change. Reachable as `@/lib/…` — the alias resolves in both `tsc` and Jest.
- **The compiler flags in `tsconfig.json` are a rule, not a preference.** The four beyond
  `strict` each ban a state (`code/docs/MOBILE-CODING-PRINCIPLES.md` § 1). Loosening one to make
  a build pass is a finding for `project-management/src/19-FINDINGS/`; the fix is a guard or a
  length check, never a `!` non-null assertion.
- **Stay self-contained.** TypeScript, eslint and their config live here and only here. Adding a
  TypeScript dependency to the repository root would breach the one-conditionalisation-mechanism
  rule that keeps a web-only generation byte-identical.
- **WCAG 2.2 AA is unchanged by the platform** — one standard, two technique sets. Automated a11y
  scanning has no React Native counterpart to `axe-core-python`, so verification here is more
  manual than on the web.
- Source files **≤ 750 lines (800 grace)**, as everywhere under `src/`.

## Output & naming

- **Hand-written:** everything tracked here — `app/`, the four config files, this pair.
- **Generated / gitignored:** `ios/`, `android/`, `.expo/`, `.expo-bundle/`, `coverage/`,
  `expo-env.d.ts`.
- Routes are expo-router files under `app/` in `kebab-case.tsx`; components `kebab-case.tsx`;
  documentation `SCREAMING-SNAKE-CASE.md`.
- **Tests live in `__tests__/`, never beside their subject inside `app/`.** expo-router treats
  every file under `app/` as a route, so a co-located `*.test.tsx` pulls the testing library into
  the production bundle and `bundle.sh` fails. This is the one place the repo's
  test-beside-the-code habit does not apply.
