---
name: stack-react-native
description: >-
  Build and review the mobile surface of <%PROJECT_NAME%> — an Expo (Continuous Native
  Generation) + React Native + TypeScript app routed by expo-router and styled with
  `StyleSheet` over a generated token module — and own its App Store and Google Play listing
  text. Load when a story needs its screens built, an existing screen needs a UI,
  accessibility or visual pass, a store listing has to be written or checked against its
  limits, or when a test, review or security skill needs React Native conventions without
  owning them. Not the Django-templated web pages (`frontend`), not the API it consumes
  (`backend`), and not authoring its tests (`test-writer`). MOBILE-ONLY — present only in a
  project generated with the mobile surface.
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Build the Mobile Surface (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is React Native code).
You own the mobile layer of a feature and hand back. `test-writer`, `qa-tester` and
`code-reviewer` cite this at the mobile boundary without owning React Native conventions
themselves.

**Mobile-only.** A project generated without the mobile surface has neither this skill nor the
tree it describes. If `code/src/mobile/` is absent, **say so and hand back** rather than
scaffolding it. The `frontend` skill is Django-templates-only and never loads this one.

**The remit includes the store listing, not only the app.** How this product is found in App
Store and Play search is a mobile-surface concern with no web counterpart, so it is here rather
than in `seo`, which is scoped to the Django marketing pages. This owns the listing's **text
fields and their length limits**; the screenshots and icon belong to
`code/docs/visual-design/MOBILE.md`, and the privacy nutrition labels and Data Safety
declarations to `project-management/src/09-GDPR/`.

**Locale:** British English (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## The brief arrives settled

A fork has no conversation behind it and **cannot open a grilling pass**, so the UI design must
already be made. The brief must carry:

- **The screen or component**, and its **wireframe** — `project-management/src/08-WIREFRAMES/`
  holds mobile screens at phone viewport in the same `SCREENS/` folder. Build them; do not
  reinvent them.
- **Every state** — loading, empty, error, success — and the navigation into and out of it.
- **The token each value resolves to**, where the design deviates from an existing component.
- **For a listing:** the fields in scope and the locales they ship in.

**If the wireframe or the state set is missing, return and say so.** Where the caller wants the
design settled first, the pass is `grilling`, run inline before this skill is dispatched.

## The surface model (read this first)

A **surface** is one delivery target with its own runtime, toolchain and release cycle. The web
and mobile surfaces are **peers, not layers**:

| Surface    | Lives in           | Runtime                       |
| ---------- | ------------------ | ----------------------------- |
| **Web**    | `code/src/django/` | Django ASGI — pages + `/api/` |
| **Mobile** | `code/src/mobile/` | React Native (Expo) on device |

The mobile app consumes the Django Ninja API exactly as a third-party client would. It **never**
renders a Django page and Django **never** bundles it. Every web doctrine — "no client-side
build", "no fourth row" in `code/docs/RENDERING.md`, the three-tier interaction rule — is scoped
to the web surface and is neither weakened nor extended by this one. Do not cite it as governing
a screen here, and never carry mobile patterns back into the Django templates. Canonical
definition: `code/src/CONTEXT.md` → _Surfaces_.

---

## Architecture

| Layer     | Technology                                                                       |
| --------- | -------------------------------------------------------------------------------- |
| Framework | **Expo** with Continuous Native Generation — `ios/` and `android/` are generated |
| Language  | **TypeScript**, strict, self-contained in this workspace                         |
| Routing   | **expo-router** — file-system routes under `app/`                                |
| Styling   | **`StyleSheet.create`** over a generated token module — no styling library       |
| Testing   | **jest-expo** + React Native Testing Library                                     |
| Dev loop  | **Expo Go**, Metro on the host                                                   |

**The pins are a matched set, not independent choices.** Expo pins TypeScript, jest-expo pins the
Jest line, expo-router pins the testing-library major, and `eslint-config-expo` pins ESLint. Take
versions from Expo's published `expo-template-default` and verify by running the toolchain —
never bump one in isolation.

---

## What the types and the app must never allow

`code/docs/MOBILE-CODING-PRINCIPLES.md` owns this in full and is read before the first screen —
the four TypeScript flags beyond `strict` (`strict` implies none of them, and
`expo/tsconfig.base` sets none), exhaustiveness through `unreachable(value, key)` in
`lib/invariant.ts`, why a cast is not a proof, the failure classification in
`lib/error-classes.ts`, and the single root `ErrorBoundary`. The taxonomy it expresses is
`code/docs/NEGATIVE-SPACE.md`; `code/src/scripts/audits/negative-space.sh` fails the build if a
flag is loosened.

**The one consequence to carry into every screen:** on a phone the environment error is the
**ordinary case** — a train tunnel is not a defect — so failures classify before they report.

---

## Everything runs through the scripts

Never invoke `pnpm`, `expo`, `tsc` or `jest` directly:

| Task            | Script                                 |
| --------------- | -------------------------------------- |
| Install         | `code/src/scripts/mobile/install.sh`   |
| Metro / Expo Go | `code/src/scripts/mobile/server.sh`    |
| Lint            | `code/src/scripts/mobile/lint.sh`      |
| Type-check      | `code/src/scripts/mobile/typecheck.sh` |
| Test            | `code/src/scripts/mobile/test.sh`      |
| Bundle          | `code/src/scripts/mobile/bundle.sh`    |

**Metro runs on the host, not in Docker** — the one dev operation that is not containerised. Expo
Go runs on a physical device, and a device cannot reach a `127.0.0.N` loopback alias, so Metro
must be on the LAN. Its port joins the story's existing reserved block (`8081 + story number`).

---

## Routing pattern

`app/` is **routes only**. A route is a default-exported component; `_layout.tsx` wraps them.

```tsx
// app/settings.tsx — reachable at /settings
import { View } from "react-native";

export default function Settings() {
  return <View />;
}
```

**Tests never live under `app/`.** expo-router treats every file there as a route, so a
co-located `*.test.tsx` pulls the testing library into the **production bundle** and
`bundle.sh` fails. Mobile tests go in `code/src/mobile/__tests__/`.

---

## Styling: token-first, exactly as on the web

Component styles consume the generated token module — never a raw literal:

```tsx
import { StyleSheet } from "react-native";
import { tokens } from "@/tokens";

const styles = StyleSheet.create({
  card: {
    backgroundColor: tokens.colour.surface, // never "#ffffff"
    padding: tokens.space.md, // never 16
  },
});
```

Colours arrive as **8-digit hex** (`#rrggbbaa`) — fixed length, always-explicit alpha, widest
parse compatibility. OKLCH is canonical in the database and gamut-mapped per CSS Color 4 on the
way out, so web and mobile stay visually aligned. Three preference axes (`contrast`,
`forced_colors`, `data_saver`) have no React Native equivalent and collapse to BASE.

The "name resolves" half of the token-first law is free here — an unresolved token import does
not compile. The no-raw-literals half is checked by `code/src/scripts/audits/mobile-tokens.sh`.

**Consequence to state plainly:** the design system's no-rebuild promise is **web-only**. A token
change reaches an installed app only through a rebuild and a store release.

---

## Theming and accessibility

Theme from `useColorScheme()`; respect `AccessibilityInfo` for reduced motion.

**WCAG 2.2 AA applies unchanged** — one standard, two technique sets. On this surface that means
`accessibilityLabel`, `accessibilityRole`, `accessibilityState`, VoiceOver and TalkBack
behaviour, and platform touch-target sizing. Techniques: `code/docs/accessibility/MOBILE.md`.

**There is no `axe-core` equivalent for React Native**, so mobile accessibility verification is
more manual than web. Say so rather than implying a scan covered it.

---

## Testing

```tsx
import { renderRouter } from "expo-router/testing-library";

const app = renderRouter("./app", { initialUrl: "/" });
expect(await app.findByRole("header")).toBeOnTheScreen();
```

Mount the **real router** rather than a screen in isolation — a layout that renders nothing is a
real failure mode that isolated route tests hide. Query from `renderRouter`'s return value, not a
global `screen`.

Coverage floors are the **same numbers as the backend, enforced once per runtime**: 75% lines and
branches globally, 90% on auth-adjacent code. coverage.py and Jest share no accumulator, so a
single combined percentage was never achievable. A per-glob threshold matching nothing **fails**
the run, so the 90% entry is added with the first auth screen, not before.

---

## Steps

1. **Reuse before you build.** Check the existing components before authoring a new one.
2. **Routes are routes.** `app/` holds only default-exported route components and layouts;
   everything else lives beside it.
3. **Mount the real router in tests** (`renderRouter`) rather than a screen in isolation.
4. **For a listing**, read `code/docs/discoverability/APP-STORE.md` § 2 before counting anything
   — Apple's keyword budget is **100 bytes**, not characters — then record the values in
   `how-to/src/STORE-LISTING.md`. Fill the **Used** column by hand; nothing in the repository can
   check it.
5. **Verify before hand-off:**

   ```bash
   bash code/src/scripts/mobile/lint.sh
   bash code/src/scripts/mobile/typecheck.sh
   bash code/src/scripts/mobile/test.sh --coverage
   bash code/src/scripts/mobile/bundle.sh
   ```

**Definition of done:** lint, typecheck, tests and the bundle export all exit `0`; coverage at or
above the floors; every value resolves to a token (`mobile-tokens.sh` clean); WCAG 2.2 AA met by
the React Native techniques; built to the screen's wireframe; no em dash in user-facing copy
(`how-to/src/BRAND-VOICE.md`); `CONTEXT.md` updated if structure changed; British English.

## Guardrails recap

- **Never commit `ios/` or `android/`** — generated, and they contain binaries this repository's
  template cannot render. Running `expo prebuild` and keeping the output is a template-level
  decision, never an incidental one.
- **No binary assets in the tree**, for the same reason. Icons are a per-project addition with a
  matching exclusion entry.
- **Stay self-contained** — TypeScript, eslint and their config live in `code/src/mobile/` only.
  Adding a TypeScript dependency to the repository root breaks the one-mechanism opt-in rule.
- **No PII in device storage.** Nothing sensitive in AsyncStorage or an unencrypted store; use
  the platform secure store for credentials and clear form state after submission.
- **The Expo SDK bump is a template release**, propagated by `copier update` — not a routine
  dependency bump. The mobile app is its own semver track (`code/src/mobile/CONTEXT.md`).
- Source files ≤ 750 lines (800 grace).

## Handoff

Report the **file paths** touched or created, what was **reused versus newly built**, any token
that had to be added and how, and — for a listing — which fields changed and against which
vendor limit. Then name what is owed next: `test-writer` for screen tests, `qa-tester` for the
accessibility and edge-case pass, `backend` where the API contract the app consumes is missing,
and `gdpr-mechanics` where a nutrition label or Data Safety declaration is in play.
**Suggest, do not chain**, unless the caller said to.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/20-frontend-code/` — the build phase; its mobile-flagged steps
- `project-management/workflows/08-wireframes/` — the screen designs consumed here
- `code/workflows/01-new-feature/` · `02-tdd-cycle/` — the feature and TDD procedures
- `project-management/workflows/21-implementation-documentation/` — the closeout before commit
- `how-to/workflows/03-daily-development/` — starting a session; Metro is the one host process
- `code/src/mobile/CLAUDE.md` — the operating rules for the tree itself

## Cross-references

- `code/docs/MOBILE-CODING-PRINCIPLES.md` — the TypeScript flags, exhaustiveness, error taxonomy
- `code/docs/DESIGN-TOKENS.md` — the token-first contract, read every time
- `code/docs/VISUAL-DESIGN.md` — §3 the project's **direction** and its six axes, §4.1 the
  universal tells, §5 the motion numbers (read every time)
- `code/docs/visual-design/MOBILE.md` — the mobile expression: **platform conformance** and
  **adaptivity**, the two dimensions no other guide owns. Mobile slop is a web-shaped screen in a
  native shell, not a layout-composition fault
- `code/docs/accessibility/MOBILE.md` — the React Native techniques that satisfy WCAG 2.2 AA
- `code/docs/discoverability/APP-STORE.md` — the listing's text fields and their limits
- `how-to/src/STORE-LISTING.md` — this project's actual listing values, the answer sheet
- `how-to/src/BRAND-VOICE.md` — the voice for any user-facing copy
